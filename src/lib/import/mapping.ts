import type { Lifecycle } from "../domain";
import { LIFECYCLE } from "../domain";

export type Cell = string | number | boolean | null;
export type RawRecord = Record<string, Cell>;

export const TARGET_FIELDS = [
  "doc_number",
  "rev_label",
  "title",
  "discipline",
  "status",
  "response_code",
  "submitted_at",
  "responded_at",
  "due_date",
  "location",
  "remarks",
] as const;
export type TargetField = (typeof TARGET_FIELDS)[number];

export const VALUE_MAPPED_FIELDS = ["discipline", "status", "response_code"] as const;
export type ValueMappedField = (typeof VALUE_MAPPED_FIELDS)[number];

/** Explicit "no value" choice; distinct from "not mapped yet". */
export const NONE = "__none__";

export type ColumnMapping = Partial<Record<TargetField, string>>;
export interface ImportOptions {
  /** Used only when the user explicitly picks a fixed status instead of a column. */
  status_fixed?: Lifecycle | null;
  date_order: "DMY" | "MDY" | "YMD";
}
export type ValueMapping = Partial<Record<ValueMappedField, Record<string, string>>>;

export interface MappedRow {
  doc_number: string | null;
  rev_label: string;
  rev_index: number;
  title: string | null;
  discipline_id: string | null;
  status: Lifecycle | null;
  response_code: string | null;
  submitted_at: string | null;
  responded_at: string | null;
  due_date: string | null;
  location: string | null;
  remarks: string | null;
  extra: Record<string, Cell>;
}

export type ValidationStatus = "valid" | "warning" | "error" | "duplicate" | "conflict";

export interface ValidationResult {
  id: string;
  mapped: MappedRow;
  validation_status: ValidationStatus;
  messages: string[];
  decision: "import" | "pending";
}

export function normalizeKey(v: Cell): string {
  if (v === null || v === undefined) return "";
  return String(v).trim().replace(/\s+/g, " ");
}

// ---------- Column suggestions (header name heuristics only) ----------
const HEADER_HINTS: Record<TargetField, RegExp> = {
  doc_number: /(ref(erence)?\s*(no|number|#)?|^no\.?$|serial|doc(ument)?\s*(no|number)|wir\s*no|mir\s*no|rfi\s*no|letter\s*no|رقم|المرجع)/i,
  rev_label: /^(rev(ision)?\.?(\s*no)?|r\.?)$|revision|مراجعة|إصدار/i,
  title: /(title|subject|description|desc|activity|item|العنوان|الموضوع|الوصف)/i,
  discipline: /(discipline|trade|dept|التخصص)/i,
  status: /(status|الحالة)/i,
  response_code: /(code|result|response|action|الكود|النتيجة)/i,
  submitted_at: /(submi|sent|issue(d)?\s*date|date\s*of\s*sub|تاريخ\s*التقديم|تاريخ\s*الإرسال)/i,
  responded_at: /(repl(y|ied)|response\s*date|return(ed)?\s*date|received\s*back|تاريخ\s*الرد)/i,
  due_date: /(due|target|deadline|تاريخ\s*الاستحقاق)/i,
  location: /(location|area|zone|level|floor|building|الموقع|المنطقة)/i,
  remarks: /(remark|comment|note|ملاحظ)/i,
};

export function suggestColumnMapping(headers: string[]): ColumnMapping {
  const used = new Set<string>();
  const out: ColumnMapping = {};
  for (const field of TARGET_FIELDS) {
    const match = headers.find((h) => !used.has(h) && HEADER_HINTS[field].test(h.trim()));
    if (match) {
      out[field] = match;
      used.add(match);
    }
  }
  return out;
}

export function distinctValues(records: RawRecord[], column: string | undefined): { value: string; count: number }[] {
  if (!column) return [];
  const counts = new Map<string, number>();
  for (const r of records) {
    const k = normalizeKey(r[column] ?? null);
    if (!k) continue;
    counts.set(k, (counts.get(k) ?? 0) + 1);
  }
  return [...counts.entries()].map(([value, count]) => ({ value, count })).sort((a, b) => b.count - a.count);
}

/**
 * Suggest only exact, unambiguous matches. Anything else (e.g. "UR") stays
 * unmapped until the user decides what it means.
 */
export function suggestValueMapping(
  field: ValueMappedField,
  values: string[],
  ctx: { disciplines: { id: string; code: string; name_en: string; name_ar: string }[]; codes: string[] },
): Record<string, string> {
  const out: Record<string, string> = {};
  for (const v of values) {
    const lower = v.toLowerCase();
    if (field === "discipline") {
      const normalizedCode = lower === "civ" || lower === "str" ? "civstr" : lower;
      const d = ctx.disciplines.find(
        (x) => x.code.toLowerCase() === normalizedCode || x.name_en.toLowerCase() === lower || x.name_ar === v,
      );
      if (d) out[v] = d.id;
    } else if (field === "response_code") {
      const c = ctx.codes.find((x) => x.toLowerCase() === lower);
      if (c) out[v] = c;
    } else if (field === "status") {
      const s = LIFECYCLE.find((x) => x === lower.replace(/\s+/g, "_"));
      if (s) out[v] = s;
    }
  }
  return out;
}

// ---------- Parsing helpers ----------
export function parseRevision(value: Cell): { index: number; label: string } | null {
  const raw = normalizeKey(value);
  if (!raw) return null;
  if (typeof value === "number" && Number.isInteger(value) && value >= 0) {
    return { index: value, label: String(value).padStart(2, "0") };
  }
  const digits = raw.match(/(\d+)\s*$/);
  if (digits) {
    const index = Number(digits[1]);
    return { index, label: /^\d+$/.test(raw) ? raw : raw };
  }
  if (/^[A-Za-z]$/.test(raw)) {
    return { index: raw.toUpperCase().charCodeAt(0) - 65, label: raw.toUpperCase() };
  }
  return null;
}

function iso(y: number, m: number, d: number): string | null {
  if (!y || m < 1 || m > 12 || d < 1 || d > 31) return null;
  const dt = new Date(Date.UTC(y, m - 1, d));
  if (dt.getUTCFullYear() !== y || dt.getUTCMonth() !== m - 1 || dt.getUTCDate() !== d) return null;
  return dt.toISOString().slice(0, 10);
}

/** Returns ISO date, null for empty, or "invalid". Never guesses day/month order — uses the chosen order. */
export function parseDate(value: Cell, order: ImportOptions["date_order"]): string | null | "invalid" {
  if (value === null || value === undefined || value === "") return null;
  if (typeof value === "number") {
    // Excel serial date (1900 system)
    if (value > 20000 && value < 80000) {
      const ms = Math.round((value - 25569) * 86_400_000);
      return new Date(ms).toISOString().slice(0, 10);
    }
    return "invalid";
  }
  const s = String(value).trim();
  if (!s) return null;
  let m = s.match(/^(\d{4})-(\d{1,2})-(\d{1,2})(?:[T\s].*)?$/);
  if (m) return iso(Number(m[1]), Number(m[2]), Number(m[3])) ?? "invalid";
  m = s.match(/^(\d{1,4})[/.-](\d{1,2})[/.-](\d{1,4})$/);
  if (m) {
    const [a, b, c] = [Number(m[1]), Number(m[2]), Number(m[3])];
    let y: number, mo: number, d: number;
    if (order === "YMD") [y, mo, d] = [a, b, c];
    else if (order === "MDY") [mo, d, y] = [a, b, c];
    else [d, mo, y] = [a, b, c];
    if (y < 100) y += 2000;
    return iso(y, mo, d) ?? "invalid";
  }
  return "invalid";
}

// ---------- Validation ----------
export interface ValidationContext {
  typeCode: string;
  usesResponseCodes: boolean;
  activeCodes: string[];
  disciplineIds: string[];
  /** Existing project numbers: doc_number -> { typeCode, revIndexes, revLabels } */
  existing: Map<string, { typeCode: string; revIndexes: Set<number>; revLabels: Set<string> }>;
}

export function mappingProblems(mapping: ColumnMapping, options: ImportOptions): string[] {
  const p: string[] = [];
  if (!mapping.doc_number) p.push("imp.need_doc_number_column");
  if (!mapping.status && !options.status_fixed) p.push("imp.need_status_source");
  return p;
}

export function validateRows(
  rows: { id: string; row_number: number; raw: RawRecord }[],
  mapping: ColumnMapping,
  values: ValueMapping,
  options: ImportOptions,
  ctx: ValidationContext,
): ValidationResult[] {
  const mappedColumns = new Set(Object.values(mapping).filter(Boolean) as string[]);
  const seen = new Map<string, number>();
  const results: ValidationResult[] = [];

  for (const row of rows) {
    const errors: string[] = [];
    const warnings: string[] = [];
    const get = (f: TargetField): Cell => (mapping[f] ? (row.raw[mapping[f]!] ?? null) : null);
    const text = (f: TargetField) => normalizeKey(get(f)) || null;

    const doc_number = text("doc_number");
    if (!doc_number) errors.push("imp.missing_doc_number");

    // Revision
    let rev = { index: 0, label: "00" };
    if (mapping.rev_label) {
      const raw = get("rev_label");
      if (normalizeKey(raw) === "") warnings.push("imp.rev_blank_assumed_00");
      else {
        const parsed = parseRevision(raw);
        if (!parsed) errors.push(`imp.invalid_revision|${normalizeKey(raw)}`);
        else rev = parsed;
      }
    }

    // Status — explicit column mapping or explicit fixed value; never inferred.
    let status: Lifecycle | null = null;
    if (mapping.status) {
      const k = text("status");
      if (!k) {
        if (options.status_fixed) status = options.status_fixed;
        else errors.push("imp.missing_status");
      } else {
        const v = values.status?.[k];
        if (v && (LIFECYCLE as readonly string[]).includes(v)) status = v as Lifecycle;
        else errors.push(`imp.unmapped_status|${k}`);
      }
    } else if (options.status_fixed) {
      status = options.status_fixed;
    } else {
      errors.push("imp.need_status_source");
    }

    // Discipline
    let discipline_id: string | null = null;
    const dk = text("discipline");
    if (dk) {
      const v = values.discipline?.[dk];
      if (v === NONE) discipline_id = null;
      else if (v && ctx.disciplineIds.includes(v)) discipline_id = v;
      else errors.push(`imp.unmapped_discipline|${dk}`);
    }

    // Response code
    let response_code: string | null = null;
    const ck = text("response_code");
    if (ck) {
      const v = values.response_code?.[ck];
      if (v === NONE) response_code = null;
      else if (v && ctx.activeCodes.includes(v)) {
        if (ctx.usesResponseCodes) response_code = v;
        else warnings.push("imp.codes_not_used");
      } else errors.push(`imp.unmapped_response_code|${ck}`);
    }

    // Dates
    const dateOf = (f: "submitted_at" | "responded_at" | "due_date") => {
      const r = parseDate(get(f), options.date_order);
      if (r === "invalid") {
        warnings.push(`imp.invalid_date|${f}|${normalizeKey(get(f))}`);
        return null;
      }
      return r;
    };
    const submitted_at = dateOf("submitted_at");
    const responded_at = dateOf("responded_at");
    const due_date = dateOf("due_date");

    const title = text("title");
    if (!title) warnings.push("imp.title_missing");

    const extra: Record<string, Cell> = {};
    for (const [k, v] of Object.entries(row.raw)) if (!mappedColumns.has(k) && v !== null && v !== "") extra[k] = v;

    const mapped: MappedRow = {
      doc_number,
      rev_label: rev.label,
      rev_index: rev.index,
      title,
      discipline_id,
      status,
      response_code,
      submitted_at,
      responded_at,
      due_date,
      location: text("location"),
      remarks: text("remarks"),
      extra,
    };

    let validation_status: ValidationStatus = errors.length ? "error" : warnings.length ? "warning" : "valid";
    const messages = [...errors, ...warnings];

    if (doc_number && validation_status !== "error") {
      const key = `${doc_number}\u0000${rev.index}`;
      const first = seen.get(key);
      const existing = ctx.existing.get(doc_number);
      if (first !== undefined) {
        validation_status = "duplicate";
        messages.unshift(`imp.duplicate_in_file|${first}`);
      } else if (existing && existing.typeCode !== ctx.typeCode) {
        validation_status = "error";
        messages.unshift(`imp.exists_other_type|${existing.typeCode}`);
      } else if (existing && (existing.revIndexes.has(rev.index) || existing.revLabels.has(rev.label))) {
        validation_status = "conflict";
        messages.unshift("imp.exists_in_project_kept");
      }
      if (first === undefined) seen.set(key, row.row_number);
    }

    results.push({
      id: row.id,
      mapped,
      validation_status,
      messages,
      decision: validation_status === "valid" || validation_status === "warning" ? "import" : "pending",
    });
  }
  return results;
}

export function summarizeValidation(results: Pick<ValidationResult, "validation_status">[]) {
  const s = { valid: 0, warning: 0, error: 0, duplicate: 0, conflict: 0 };
  for (const r of results) s[r.validation_status]++;
  return s;
}