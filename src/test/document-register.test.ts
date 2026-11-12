import { describe, expect, it } from "vitest";
import { filterDocumentRecords, type RegisterRecord } from "@/lib/document-register";

const records: RegisterRecord[] = [
  { id: "WIR-ARC-01", title: "فحص العزل", type: "WIR", discipline: "معماري", submittedBy: "المقاول أ", date: "2026-11-11", status: "قيد المراجعة", age: "اليوم" },
  { id: "RFI-CIV-02", title: "تفصيلة قاعدة", type: "RFI", discipline: "مدني وإنشائي", submittedBy: "المقاول ب", date: "2026-11-10", status: "معتمد", age: "أمس" },
  { id: "WIR-ELE-03", title: "تمديدات كهربائية", type: "WIR", discipline: "كهرباء", submittedBy: "المقاول أ", date: "2026-11-09", status: "معاد للتعديل", age: "قبل يومين" },
];

describe("document register filtering", () => {
  it("returns all records when no filters are selected", () => {
    expect(filterDocumentRecords(records, "", "الكل", "الكل")).toHaveLength(3);
  });
  it("treats a whitespace-only query as no query", () => {
    expect(filterDocumentRecords(records, " \t\n ", "الكل", "الكل")).toEqual(records);
  });
  it("returns no records when the input list is empty", () => {
    expect(filterDocumentRecords([], "", "الكل", "الكل")).toEqual([]);
  });
  it("filters by document type and status together", () => {
    expect(filterDocumentRecords(records, "", "WIR", "معاد للتعديل").map((item) => item.id)).toEqual(["WIR-ELE-03"]);
  });
  it("combines a text query with document type and status filters", () => {
    expect(filterDocumentRecords(records, "العزل", "WIR", "قيد المراجعة").map((item) => item.id)).toEqual(["WIR-ARC-01"]);
  });
  it("searches identifiers, titles, submitters and disciplines without case sensitivity", () => {
    expect(filterDocumentRecords(records, "rfi-civ", "الكل", "الكل").map((item) => item.id)).toEqual(["RFI-CIV-02"]);
    expect(filterDocumentRecords(records, "كهرباء", "الكل", "الكل").map((item) => item.id)).toEqual(["WIR-ELE-03"]);
  });
  it("matches identifiers when the query uses mixed letter casing", () => {
    expect(filterDocumentRecords(records, "rFi-CiV", "الكل", "الكل").map((item) => item.id)).toEqual(["RFI-CIV-02"]);
  });
  it("searches Arabic text in document titles", () => {
    expect(filterDocumentRecords(records, "تفصيلة", "الكل", "الكل").map((item) => item.id)).toEqual(["RFI-CIV-02"]);
  });
  it("trims query whitespace and returns an empty result for no matches", () => {
    expect(filterDocumentRecords(records, "  العزل  ", "الكل", "الكل")).toHaveLength(1);
    expect(filterDocumentRecords(records, "غير موجود", "الكل", "الكل")).toEqual([]);
  });
});
