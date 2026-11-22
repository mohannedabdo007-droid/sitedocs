// Mirror of public.format_doc_number — keep both in sync.
export const NUMBER_TOKENS = ["{PROJECT}", "{TYPE}", "{DISC}", "{SEQ:4}", "{YYYY}", "{YY}"] as const;
export const DEFAULT_PATTERN = "{PROJECT}-{TYPE}-{DISC}-{SEQ:4}";

export interface NumberParts {
  project: string;
  type: string;
  disc?: string | null;
  seq: number;
  date?: Date;
}

export function formatDocNumber(pattern: string, parts: NumberParts): string {
  const date = parts.date ?? new Date();
  const s = String(parts.seq);
  let res = pattern
    .split("{PROJECT}").join(parts.project ?? "")
    .split("{TYPE}").join(parts.type ?? "")
    .split("{DISC}").join(parts.disc ? parts.disc : "GEN")
    .split("{YYYY}").join(String(date.getUTCFullYear()))
    .split("{YY}").join(String(date.getUTCFullYear()).slice(-2));
  res = res.replace(/\{SEQ:(\d+)\}/g, (_m, w: string) => {
    const width = Math.min(Number(w), 10);
    return s.length >= width ? s : s.padStart(width, "0");
  });
  return res.split("{SEQ}").join(s);
}

export function isValidPattern(pattern: string): boolean {
  return pattern.includes("{SEQ") && pattern.length <= 120;
}