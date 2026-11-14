import type { Cell, RawRecord } from "./mapping";

export interface ParsedSheet {
  name: string;
  rows: Cell[][];
}

export const WORKBOOK_LIMITS = {
  maxFileBytes: 10 * 1024 * 1024,
  maxSheets: 20,
  maxRowsPerSheet: 10_000,
  maxColumnsPerSheet: 100,
  maxTotalCells: 500_000,
  maxCellTextLength: 10_000,
} as const;

export type WorkbookLimitCode = "file_size" | "sheet_count" | "row_count" | "column_count" | "cell_count" | "cell_text_length";

export class WorkbookLimitError extends Error {
  constructor(
    public readonly code: WorkbookLimitCode,
    message: string,
  ) {
    super(message);
    this.name = "WorkbookLimitError";
  }
}

function toCell(v: unknown): Cell {
  if (v === null || v === undefined) return null;
  if (v instanceof Date) {
    if (Number.isNaN(v.getTime())) return null;
    const y = v.getFullYear();
    const m = String(v.getMonth() + 1).padStart(2, "0");
    const d = String(v.getDate()).padStart(2, "0");
    return `${y}-${m}-${d}`;
  }
  if (typeof v === "number" || typeof v === "boolean") return v;
  const text = String(v);
  if (text.length > WORKBOOK_LIMITS.maxCellTextLength) {
    throw new WorkbookLimitError("cell_text_length", `Cell text exceeds the ${WORKBOOK_LIMITS.maxCellTextLength.toLocaleString()} character limit.`);
  }
  return text.trim() === "" ? null : text;
}

/** Parses in the browser; rejects oversized workbooks before converting sheets to row arrays. */
export async function parseWorkbook(buffer: ArrayBuffer): Promise<ParsedSheet[]> {
  if (buffer.byteLength > WORKBOOK_LIMITS.maxFileBytes) {
    throw new WorkbookLimitError("file_size", `Workbook exceeds the ${WORKBOOK_LIMITS.maxFileBytes / (1024 * 1024)} MB limit.`);
  }

  const XLSX = await import("xlsx");
  const wb = XLSX.read(buffer, { type: "array", cellDates: true });

  if (wb.SheetNames.length > WORKBOOK_LIMITS.maxSheets) {
    throw new WorkbookLimitError("sheet_count", `Workbook has more than ${WORKBOOK_LIMITS.maxSheets} worksheets.`);
  }

  let totalCells = 0;
  const parsed: ParsedSheet[] = [];

  for (const name of wb.SheetNames) {
    const ws = wb.Sheets[name];
    if (!ws?.["!ref"]) {
      parsed.push({ name, rows: [] });
      continue;
    }

    const range = XLSX.utils.decode_range(ws["!ref"]);
    const rowCount = range.e.r - range.s.r + 1;
    const columnCount = range.e.c - range.s.c + 1;

    if (rowCount > WORKBOOK_LIMITS.maxRowsPerSheet) {
      throw new WorkbookLimitError("row_count", `Worksheet "${name}" exceeds ${WORKBOOK_LIMITS.maxRowsPerSheet} rows.`);
    }
    if (columnCount > WORKBOOK_LIMITS.maxColumnsPerSheet) {
      throw new WorkbookLimitError("column_count", `Worksheet "${name}" exceeds ${WORKBOOK_LIMITS.maxColumnsPerSheet} columns.`);
    }

    totalCells += rowCount * columnCount;
    if (totalCells > WORKBOOK_LIMITS.maxTotalCells) {
      throw new WorkbookLimitError("cell_count", `Workbook exceeds the ${WORKBOOK_LIMITS.maxTotalCells.toLocaleString()} cell processing limit.`);
    }

    const rows = XLSX.utils.sheet_to_json<unknown[]>(ws, {
      header: 1,
      raw: true,
      defval: null,
      blankrows: false,
    });
    parsed.push({ name, rows: rows.map((r) => (r as unknown[]).map(toCell)) });
  }

  return parsed;
}

/** Picks the row (within the first 20) with the most non-empty text cells. */
export function detectHeaderRow(rows: Cell[][]): number {
  let best = 0;
  let bestScore = -1;
  for (let i = 0; i < Math.min(rows.length, 20); i++) {
    const row = rows[i] ?? [];
    const score = row.filter((c) => typeof c === "string" && c.trim() !== "").length;
    if (score > bestScore) {
      best = i;
      bestScore = score;
    }
  }
  return best;
}

export function buildRecords(rows: Cell[][], headerIndex: number): { headers: string[]; records: { row_number: number; raw: RawRecord }[] } {
  const headerRow = rows[headerIndex] ?? [];
  const width = Math.max(headerRow.length, ...rows.slice(headerIndex + 1).map((r) => r.length), 0);
  const used = new Map<string, number>();
  const headers: string[] = [];
  for (let c = 0; c < width; c++) {
    let h = headerRow[c] == null ? "" : String(headerRow[c]).replace(/\\s+/g, " ").trim();
    if (!h) h = `Column ${c + 1}`;
    const n = (used.get(h) ?? 0) + 1;
    used.set(h, n);
    headers.push(n > 1 ? `${h} (${n})` : h);
  }
  const records: { row_number: number; raw: RawRecord }[] = [];
  for (let i = headerIndex + 1; i < rows.length; i++) {
    const r = rows[i];
    if (!r || r.every((c) => c === null || c === "")) continue;
    const raw: RawRecord = {};
    headers.forEach((h, c) => {
      raw[h] = r[c] ?? null;
    });
    records.push({ row_number: i + 1, raw }); // Excel row number (1-based)
  }
  return { headers, records };
}
