import type { Lifecycle } from "./domain";

export interface KpiRow {
  project_id: string;
  type_code: string;
  discipline_code: string;
  status: Lifecycle;
  response_code: string | null;
  docs: number;
  overdue: number;
  resubmitted: number;
  pending_days_sum: number;
  pending_n: number;
  max_pending: number | null;
  revisions_total: number;
  aging_0_7: number;
  aging_8_14: number;
  aging_15_30: number;
  aging_31p: number;
}

export interface KpiGroup {
  key: string;
  total: number;
  open: number;
  overdue: number;
  bc: number;
  resubmitted: number;
  avgPending: number | null;
  byStatus: Record<string, number>;
}

export interface KpiSummary {
  total: number;
  openReview: number;
  overdue: number;
  bc: number;
  codeB: number;
  codeC: number;
  resubmitted: number;
  revisionsTotal: number;
  avgPending: number | null;
  maxPending: number | null;
  byStatus: Record<string, number>;
  byCode: Record<string, number>;
  aging: { d0_7: number; d8_14: number; d15_30: number; d31p: number };
  byType: KpiGroup[];
  byDiscipline: KpiGroup[];
}

const OPEN = new Set<Lifecycle>(["submitted", "under_review"]);
const BC = new Set(["B", "C"]);

function round1(n: number) {
  return Math.round(n * 10) / 10;
}

function groupBy(rows: KpiRow[], key: (r: KpiRow) => string): KpiGroup[] {
  const map = new Map<string, KpiGroup & { _ps: number; _pn: number }>();
  for (const r of rows) {
    const k = key(r);
    let g = map.get(k);
    if (!g) {
      g = { key: k, total: 0, open: 0, overdue: 0, bc: 0, resubmitted: 0, avgPending: null, byStatus: {}, _ps: 0, _pn: 0 };
      map.set(k, g);
    }
    const n = Number(r.docs);
    g.total += n;
    if (OPEN.has(r.status)) g.open += n;
    g.overdue += Number(r.overdue);
    if (r.response_code && BC.has(r.response_code)) g.bc += n;
    g.resubmitted += Number(r.resubmitted);
    g.byStatus[r.status] = (g.byStatus[r.status] ?? 0) + n;
    g._ps += Number(r.pending_days_sum);
    g._pn += Number(r.pending_n);
  }
  return [...map.values()]
    .map(({ _ps, _pn, ...g }) => ({ ...g, avgPending: _pn ? round1(_ps / _pn) : null }))
    .sort((a, b) => b.total - a.total || a.key.localeCompare(b.key));
}

export function summarizeKpis(rows: KpiRow[]): KpiSummary {
  let total = 0, openReview = 0, overdue = 0, codeB = 0, codeC = 0, resubmitted = 0, revisionsTotal = 0;
  let ps = 0, pn = 0;
  let maxPending: number | null = null;
  const byStatus: Record<string, number> = {};
  const byCode: Record<string, number> = {};
  const aging = { d0_7: 0, d8_14: 0, d15_30: 0, d31p: 0 };
  for (const r of rows) {
    const n = Number(r.docs);
    total += n;
    if (OPEN.has(r.status)) openReview += n;
    overdue += Number(r.overdue);
    if (r.response_code === "B") codeB += n;
    if (r.response_code === "C") codeC += n;
    if (r.response_code) byCode[r.response_code] = (byCode[r.response_code] ?? 0) + n;
    resubmitted += Number(r.resubmitted);
    revisionsTotal += Number(r.revisions_total);
    byStatus[r.status] = (byStatus[r.status] ?? 0) + n;
    ps += Number(r.pending_days_sum);
    pn += Number(r.pending_n);
    if (r.max_pending != null) maxPending = Math.max(maxPending ?? 0, Number(r.max_pending));
    aging.d0_7 += Number(r.aging_0_7);
    aging.d8_14 += Number(r.aging_8_14);
    aging.d15_30 += Number(r.aging_15_30);
    aging.d31p += Number(r.aging_31p);
  }
  return {
    total,
    openReview,
    overdue,
    bc: codeB + codeC,
    codeB,
    codeC,
    resubmitted,
    revisionsTotal,
    avgPending: pn ? round1(ps / pn) : null,
    maxPending,
    byStatus,
    byCode,
    aging,
    byType: groupBy(rows, (r) => r.type_code),
    byDiscipline: groupBy(rows, (r) => r.discipline_code),
  };
}