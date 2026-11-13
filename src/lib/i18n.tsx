import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from "react";

import { en, ar, type DictKey } from "./i18n-dict";

export type Locale = "ar" | "en";
const STORAGE_KEY = "pdc-locale";

interface I18nValue {
  locale: Locale;
  dir: "rtl" | "ltr";
  setLocale: (l: Locale) => void;
  t: (key: DictKey, vars?: Record<string, string | number>) => string;
  /** Pick the localized field from a row with *_en / *_ar or name / name_ar columns. */
  pick: (en: string | null | undefined, ar: string | null | undefined) => string;
  fmtDate: (iso: string | null | undefined, withTime?: boolean) => string;
  fmtNumber: (n: number | null | undefined) => string;
}

const I18nContext = createContext<I18nValue | null>(null);

export function I18nProvider({ children }: { children: ReactNode }) {
  const [locale, setLocaleState] = useState<Locale>("ar");

  useEffect(() => {
    const saved = window.localStorage.getItem(STORAGE_KEY);
    if (saved === "en" || saved === "ar") setLocaleState(saved);
  }, []);

  useEffect(() => {
    document.documentElement.lang = locale;
    document.documentElement.dir = locale === "ar" ? "rtl" : "ltr";
  }, [locale]);

  const setLocale = useCallback((l: Locale) => {
    window.localStorage.setItem(STORAGE_KEY, l);
    setLocaleState(l);
  }, []);

  const value = useMemo<I18nValue>(() => {
    const dict = locale === "ar" ? ar : en;
    const t = (key: DictKey, vars?: Record<string, string | number>) => {
      let s: string = dict[key] ?? en[key] ?? key;
      if (vars) for (const [k, v] of Object.entries(vars)) s = s.split(`{${k}}`).join(String(v));
      return s;
    };
    const loc = locale === "ar" ? "ar-EG" : "en-GB";
    return {
      locale,
      dir: locale === "ar" ? "rtl" : "ltr",
      setLocale,
      t,
      pick: (e, a) => (locale === "ar" ? a || e || "" : e || a || ""),
      fmtDate: (iso, withTime) => {
        if (!iso) return "—";
        const d = new Date(iso.length === 10 ? `${iso}T00:00:00Z` : iso);
        if (Number.isNaN(d.getTime())) return iso;
        return new Intl.DateTimeFormat(loc, {
          year: "numeric",
          month: "short",
          day: "2-digit",
          ...(withTime ? { hour: "2-digit", minute: "2-digit" } : {}),
          numberingSystem: "latn",
          timeZone: withTime ? undefined : "UTC",
        }).format(d);
      },
      fmtNumber: (n) => (n == null ? "—" : new Intl.NumberFormat(loc, { numberingSystem: "latn" }).format(n)),
    };
  }, [locale, setLocale]);

  return <I18nContext.Provider value={value}>{children}</I18nContext.Provider>;
}

export function useI18n() {
  const ctx = useContext(I18nContext);
  if (!ctx) throw new Error("useI18n must be used inside I18nProvider");
  return ctx;
}

/** Translate import/validation message codes like "imp.unmapped_status|UR". */
export function useMessageText() {
  const { t } = useI18n();
  return (msg: string) => {
    const [key, ...args] = msg.split("|");
    if (!key) return msg;
    const known = (en as Record<string, string>)[key];
    if (!known) return msg;
    const vars: Record<string, string> = {};
    args.forEach((a, i) => (vars[String(i)] = a));
    return t(key as DictKey, vars);
  };
}
