import type { Cell, RawRecord } from "./mapping";

export interface ParsedSheet {
  name: string;
  rows: Cell[][];
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
  if (typeof v === "string") return v.trim() === "" ? null : v;
  if (typeof v === "number" || typeof v === "boolean") return v;
  return String(v);
}

/** Parses in the browser; the file never leaves the device until rows are staged. */
export async function parseWorkbook(buffer: ArrayBuffer): Promise<ParsedSheet[]> {
  const XLSX = await import("xlsx");
  const wb = XLSX.read(buffer, { type: "array", cellDates: true });
  return wb.SheetNames.map((name) => {
    const ws = wb.Sheets[name];
    const rows = XLSX.utils.sheet_to_json<unknown[]>(ws, { header: 1, raw: true, defval: null, blankrows: false });
    return { name, rows: rows.map((r) => (r as unknown[]).map(toCell)) };
  });
}

/** Picks the row (within the first 20) with the most non-empty text cells. */
export function detectHeaderRow(rows: Cell[][]): number {
  let best = 0;
  let bestScore = -1;
  for (let i = 0; i < Math.min(rows.length, 20); i++) {
    const score = rows[i].filter((c) => typeof c === "string" && c.trim() !== "").length;
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
    let h = headerRow[c] == null ? "" : String(headerRow[c]).replace(/\s+/g, " ").trim();
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