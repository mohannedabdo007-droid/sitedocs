/**
 * Current discipline vocabulary and explicit legacy aliases.
 * This is presentation/import normalization only; it never rewrites stored history.
 */
export const CURRENT_DISCIPLINES = ["ARC", "CIVSTR", "MEC", "ELE", "SUR"] as const;
export type CurrentDiscipline = (typeof CURRENT_DISCIPLINES)[number];

const DISCIPLINE_ALIASES: Record<string, CurrentDiscipline> = {
  ARC: "ARC",
  CIVSTR: "CIVSTR",
  STR: "CIVSTR",
  CIV: "CIVSTR",
  MEC: "MEC",
  ELE: "ELE",
  SUR: "SUR",
};

/** Returns a current discipline code, preserving unknown values for manual review. */
export function normalizeDisciplineCode(value: string | null | undefined): string | null {
  const key = value?.trim().toUpperCase();
  if (!key) return null;
  return DISCIPLINE_ALIASES[key] ?? null;
}
