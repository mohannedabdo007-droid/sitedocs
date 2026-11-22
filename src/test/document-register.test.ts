import { describe, expect, it } from "vitest";
import { capDocumentRecords, filterDocumentRecords, type RegisterRecord } from "@/lib/document-register";

const records: RegisterRecord[] = [
  { id: "WIR-ARC-01", title: "فحص العزل", type: "WIR", discipline: "معماري", submittedBy: "المقاول أ", date: "2026-11-11", status: "قيد المراجعة", age: "اليوم" },
  { id: "RFI-CIV-02", title: "تفصيلة قاعدة", type: "RFI", discipline: "مدني وإنشائي", submittedBy: "المقاول ب", date: "2026-11-10", status: "معتمد", age: "أمس" },
  { id: "WIR-ELE-03", title: "تمديدات كهربائية", type: "WIR", discipline: "كهرباء", submittedBy: "المقاول أ", date: "2026-11-09", status: "معاد للتعديل", age: "قبل يومين" },
];

describe("document register filtering", () => {
  it("returns all records when no filters are selected", () => {
    expect(filterDocumentRecords(records, "", "الكل", "الكل")).toHaveLength(3);
  });
  it("filters by document type and status together", () => {
    expect(filterDocumentRecords(records, "", "WIR", "معاد للتعديل").map((item) => item.id)).toEqual(["WIR-ELE-03"]);
  });
  it("searches identifiers, titles, submitters and disciplines without case sensitivity", () => {
    expect(filterDocumentRecords(records, "rfi-civ", "الكل", "الكل").map((item) => item.id)).toEqual(["RFI-CIV-02"]);
    expect(filterDocumentRecords(records, "كهرباء", "الكل", "الكل").map((item) => item.id)).toEqual(["WIR-ELE-03"]);
  });
  it("trims query whitespace and returns an empty result for no matches", () => {
    expect(filterDocumentRecords(records, "  العزل  ", "الكل", "الكل")).toHaveLength(1);
    expect(filterDocumentRecords(records, "غير موجود", "الكل", "الكل")).toEqual([]);
  });
});


describe("document register result cap", () => {
  it("keeps all records when the result count is within the limit", () => {
    expect(capDocumentRecords(records, 3)).toEqual({ records, hasMore: false });
  });

  it("keeps the first records and flags overflow beyond the limit", () => {
    const extended = [...records, { ...records[0]!, id: "WIR-ARC-04" }];
    expect(capDocumentRecords(extended, 3)).toEqual({
      records,
      hasMore: true,
    });
  });

  it("rejects a non-positive or non-integer limit", () => {
    expect(() => capDocumentRecords(records, 0)).toThrow(RangeError);
    expect(() => capDocumentRecords(records, 1.5)).toThrow(RangeError);
  });
});
