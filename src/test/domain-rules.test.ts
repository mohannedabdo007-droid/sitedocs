import { describe, expect, it } from "vitest";

import { availableActions, canAddRevision, isOverdue, pendingDays, type WorkflowDoc } from "@/lib/domain";
import { formatDocNumber } from "@/lib/numbering";
import { summarizeKpis, type KpiRow } from "@/lib/kpi";
import { normalizeDisciplineCode } from "@/lib/discipline";
import {
  NONE,
  parseDate,
  parseRevision,
  suggestValueMapping,
  validateRows,
  type ValidationContext,
} from "@/lib/import/mapping";

const base: WorkflowDoc = {
  status: "draft",
  workflow_steps: ["contractor", "consultant"],
  current_step: 1,
  requires_review: true,
  uses_response_codes: true,
};

describe("document numbering", () => {
  it("formats project/type/discipline/sequence tokens", () => {
    expect(formatDocNumber("{PROJECT}-{TYPE}-{DISC}-{SEQ:4}", { project: "P2", type: "WIR", disc: "STR", seq: 7 })).toBe(
      "P2-WIR-STR-0007",
    );
  });
  it("uses GEN when no discipline and never truncates long sequences", () => {
    expect(formatDocNumber("{TYPE}-{DISC}-{SEQ:3}", { project: "P2", type: "MIR", seq: 12345 })).toBe("MIR-GEN-12345");
  });
});

describe("workflow rules", () => {
  it("only the originating party (contractor) can submit a draft", () => {
    expect(availableActions(base, "controller", "contractor")).toContain("submit");
    expect(availableActions(base, "controller", "consultant")).not.toContain("submit");
  });
  it("only the current reviewing party can respond", () => {
    const doc: WorkflowDoc = { ...base, status: "submitted", current_step: 2 };
    expect(availableActions(doc, "reviewer", "consultant")).toContain("respond");
    expect(availableActions(doc, "controller", "contractor")).not.toContain("respond");
  });
  it("does not let an admin bypass the current workflow party", () => {
    const doc: WorkflowDoc = { ...base, status: "submitted", current_step: 2 };
    expect(availableActions(doc, "admin", "contractor")).not.toContain("respond");
    expect(availableActions(doc, "admin", "contractor")).not.toContain("return");
    expect(availableActions(doc, "admin", "contractor")).not.toContain("start_review");
    expect(availableActions(doc, "admin", "consultant")).toContain("respond");
  });
  it("does not let an admin submit on behalf of a different originating party", () => {
    expect(availableActions(base, "admin", "consultant")).not.toContain("submit");
    expect(availableActions(base, "admin", "contractor")).toContain("submit");
  });
  it("viewers get no actions", () => {
    expect(availableActions({ ...base, status: "submitted", current_step: 2 }, "viewer", "consultant")).toEqual([]);
  });
  it("new revisions only after Returned or Approved", () => {
    expect(canAddRevision({ status: "returned" }, "controller")).toBe(true);
    expect(canAddRevision({ status: "under_review" }, "controller")).toBe(false);
    expect(canAddRevision({ status: "approved" }, "reviewer")).toBe(false);
  });
});

describe("discipline normalization", () => {
  it("normalizes only the approved legacy aliases to CIVSTR", () => {
    expect(normalizeDisciplineCode("STR")).toBe("CIVSTR");
    expect(normalizeDisciplineCode(" civ ")).toBe("CIVSTR");
    expect(normalizeDisciplineCode("SUR")).toBe("SUR");
    expect(normalizeDisciplineCode("UNKNOWN")).toBeNull();
  });

  it("suggests a legacy discipline only when the current CIVSTR target exists", () => {
    const disciplines = [
      { id: "d-civstr", code: "CIVSTR", name_en: "Civil & Structural", name_ar: "مدني وإنشائي" },
    ];
    expect(suggestValueMapping("discipline", ["STR", "CIV", "CIVSTR"], { disciplines, codes: [] })).toEqual({
      STR: "d-civstr",
      CIV: "d-civstr",
      CIVSTR: "d-civstr",
    });
    expect(suggestValueMapping("discipline", ["STR"], { disciplines: [], codes: [] })).toEqual({});
    expect(
      suggestValueMapping(
        "discipline",
        ["STR"],
        { disciplines: [
          { id: "legacy-str", code: "STR", name_en: "Structural", name_ar: "إنشائي" },
        ], codes: [] },
      ),
    ).toEqual({});
  });

  it("groups legacy STR and CIV KPI rows under CIVSTR without changing other groups", () => {
    const kpiRow = (discipline_code: string, docs: number): KpiRow => ({
      project_id: "p", type_code: "WIR", discipline_code, status: "submitted", response_code: null,
      docs, overdue: 0, resubmitted: 0, pending_days_sum: 0, pending_n: 0, max_pending: null, revisions_total: docs,
      aging_0_7: 0, aging_8_14: 0, aging_15_30: 0, aging_31p: 0,
    });
    const s = summarizeKpis([
      kpiRow("STR", 2),
      kpiRow("CIV", 3),
      kpiRow("SUR", 1),
    ]);
    expect(s.byDiscipline).toEqual(
      expect.arrayContaining([
        expect.objectContaining({ key: "CIVSTR", total: 5 }),
        expect.objectContaining({ key: "SUR", total: 1 }),
      ]),
    );
    expect(s.byDiscipline).toHaveLength(2);
  });
});

describe("pending days and overdue", () => {
  const today = new Date("2026-11-10T12:00:00Z");
  it("counts days only while in open review", () => {
    expect(pendingDays("under_review", "2026-11-01T08:00:00Z", today)).toBe(9);
    expect(pendingDays("approved", "2026-11-01T08:00:00Z", today)).toBeNull();
  });
  it("is overdue only when open and past due date", () => {
    expect(isOverdue("submitted", "2026-11-09", today)).toBe(true);
    expect(isOverdue("submitted", "2026-11-10", today)).toBe(false);
    expect(isOverdue("returned", "2026-11-01", today)).toBe(false);
  });
});

describe("KPI summary", () => {
  const row = (p: Partial<KpiRow>): KpiRow => ({
    project_id: "p", type_code: "WIR", discipline_code: "STR", status: "submitted", response_code: null,
    docs: 1, overdue: 0, resubmitted: 0, pending_days_sum: 0, pending_n: 0, max_pending: null, revisions_total: 1,
    aging_0_7: 0, aging_8_14: 0, aging_15_30: 0, aging_31p: 0, ...p,
  });
  it("counts B/C codes and averages pending days", () => {
    const s = summarizeKpis([
      row({ status: "approved", response_code: "B", docs: 3 }),
      row({ status: "returned", response_code: "C", docs: 2, resubmitted: 2 }),
      row({ status: "under_review", docs: 2, pending_days_sum: 10, pending_n: 2, overdue: 1 }),
    ]);
    expect(s.bc).toBe(5);
    expect(s.openReview).toBe(2);
    expect(s.avgPending).toBe(5);
    expect(s.resubmitted).toBe(2);
    expect(s.overdue).toBe(1);
  });
});

describe("Excel import validation", () => {
  const ctx: ValidationContext = {
    typeCode: "WIR",
    usesResponseCodes: true,
    activeCodes: ["A", "B", "C", "D", "E", "I"],
    disciplineIds: ["d-str"],
    existing: new Map([["P2-WIR-001", { typeCode: "WIR", revIndexes: new Set([0]), revLabels: new Set(["00"]) }]]),
  };
  const mapping = { doc_number: "Ref", rev_label: "Rev", status: "Status", response_code: "Code", discipline: "Disc" };
  const opts = { date_order: "DMY" as const };

  it("never auto-maps UR", () => {
    const s = suggestValueMapping("status", ["UR", "approved"], { disciplines: [], codes: [] });
    expect(s["UR"]).toBeUndefined();
    expect(s["approved"]).toBe("approved");
    const c = suggestValueMapping("response_code", ["UR", "a"], { disciplines: [], codes: ["A"] });
    expect(c).toEqual({ a: "A" });
  });

  it("flags unmapped values as errors instead of guessing", () => {
    const [r] = validateRows(
      [{ id: "1", row_number: 2, raw: { Ref: "X-1", Rev: "0", Status: "UR", Code: "UR", Disc: "STR" } }],
      mapping,
      { status: {}, response_code: {}, discipline: { STR: "d-str" } },
      opts,
      ctx,
    );
    expect(r.validation_status).toBe("error");
    expect(r.messages).toContain("imp.unmapped_status|UR");
    expect(r.messages).toContain("imp.unmapped_response_code|UR");
    expect(r.decision).toBe("pending");
  });

  it("keeps duplicates and existing revisions flagged, never dropped", () => {
    const rows = [
      { id: "1", row_number: 2, raw: { Ref: "A-1", Rev: "0", Status: "UR", Code: "UR", Disc: null } },
      { id: "2", row_number: 3, raw: { Ref: "A-1", Rev: "00", Status: "UR", Code: "UR", Disc: null } },
      { id: "3", row_number: 4, raw: { Ref: "P2-WIR-001", Rev: "0", Status: "UR", Code: "UR", Disc: null } },
    ];
    const res = validateRows(
      rows,
      mapping,
      { status: { UR: "under_review" }, response_code: { UR: NONE } },
      opts,
      ctx,
    );
    expect(res).toHaveLength(3);
    // first row is importable (warning only: no title column mapped)
    expect(res.map((r) => r.validation_status)).toEqual(["warning", "duplicate", "conflict"]);
    expect(res[0].decision).toBe("import");
    expect(res[1].messages[0]).toBe("imp.duplicate_in_file|2");
  });

  it("parses revisions and dates with the chosen order", () => {
    expect(parseRevision("Rev.02")).toEqual({ index: 2, label: "Rev.02" });
    expect(parseRevision("B")).toEqual({ index: 1, label: "B" });
    expect(parseDate("03/04/2025", "DMY")).toBe("2025-04-03");
    expect(parseDate("03/04/2025", "MDY")).toBe("2025-03-04");
    expect(parseDate("31/02/2025", "DMY")).toBe("invalid");
  });
});