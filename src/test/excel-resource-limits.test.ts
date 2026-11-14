import { describe, expect, it } from "vitest";
import * as XLSX from "xlsx";

import { buildRecords, parseWorkbook, WORKBOOK_LIMITS, WorkbookLimitError } from "@/lib/import/excel";

function toBuffer(workbook: XLSX.WorkBook): ArrayBuffer {
  return XLSX.write(workbook, { type: "array", bookType: "xlsx" }) as ArrayBuffer;
}

describe("Excel workbook resource limits", () => {
  it("rejects a file above the byte limit before parsing", async () => {
    await expect(parseWorkbook(new ArrayBuffer(WORKBOOK_LIMITS.maxFileBytes + 1))).rejects.toMatchObject({
      name: "WorkbookLimitError",
      code: "file_size",
    });
  });

  it("rejects workbooks with too many worksheets", async () => {
    const workbook = XLSX.utils.book_new();
    for (let i = 0; i <= WORKBOOK_LIMITS.maxSheets; i++) {
      XLSX.utils.book_append_sheet(workbook, XLSX.utils.aoa_to_sheet([["Ref"]]), `Sheet${i}`);
    }
    await expect(parseWorkbook(toBuffer(workbook))).rejects.toMatchObject({
      name: "WorkbookLimitError",
      code: "sheet_count",
    });
  });

  it("rejects a worksheet that exceeds the row limit", async () => {
    const workbook = XLSX.utils.book_new();
    const sheet = XLSX.utils.aoa_to_sheet([["Ref"], ...Array.from({ length: WORKBOOK_LIMITS.maxRowsPerSheet }, (_, i) => [`R-${i}`])]);
    XLSX.utils.book_append_sheet(workbook, sheet, "Rows");
    await expect(parseWorkbook(toBuffer(workbook))).rejects.toMatchObject({
      name: "WorkbookLimitError",
      code: "row_count",
    });
  });

  it("rejects a worksheet that exceeds the column limit", async () => {
    const workbook = XLSX.utils.book_new();
    const sheet = XLSX.utils.aoa_to_sheet([Array.from({ length: WORKBOOK_LIMITS.maxColumnsPerSheet + 1 }, (_, i) => `C${i}`)]);
    XLSX.utils.book_append_sheet(workbook, sheet, "Columns");
    await expect(parseWorkbook(toBuffer(workbook))).rejects.toMatchObject({
      name: "WorkbookLimitError",
      code: "column_count",
    });
  });

  it("rejects aggregate cell ranges above the workbook limit", async () => {
    const workbook = XLSX.utils.book_new();
    for (let i = 0; i < 6; i++) {
      const sheet = XLSX.utils.aoa_to_sheet([["x"]]);
      sheet["!ref"] = "A1:J10000";
      XLSX.utils.book_append_sheet(workbook, sheet, `Grid${i}`);
    }
    await expect(parseWorkbook(toBuffer(workbook))).rejects.toMatchObject({
      name: "WorkbookLimitError",
      code: "cell_count",
    });
  });

  it("rejects cell text above the configured length", async () => {
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(
      workbook,
      XLSX.utils.aoa_to_sheet([["Ref"], ["x".repeat(WORKBOOK_LIMITS.maxCellTextLength + 1)]]),
      "LongText",
    );
    await expect(parseWorkbook(toBuffer(workbook))).rejects.toMatchObject({
      name: "WorkbookLimitError",
      code: "cell_text_length",
    });
  });

  it("parses a workbook within the limits", async () => {
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, XLSX.utils.aoa_to_sheet([["Ref", "Status"], ["WIR-1", "submitted"]]), "WIR");
    await expect(parseWorkbook(toBuffer(workbook))).resolves.toEqual([
      { name: "WIR", rows: [["Ref", "Status"], ["WIR-1", "submitted"]] },
    ]);
  });
});


describe("Excel header normalization", () => {
  it("collapses internal whitespace before creating record keys", () => {
    const result = buildRecords(
      [
        ["  Document   No  ", "Title"],
        ["WIR-001", "Concrete inspection"],
      ],
      0,
    );

    expect(result.headers).toEqual(["Document No", "Title"]);
    expect(result.records).toEqual([
      { row_number: 2, raw: { "Document No": "WIR-001", Title: "Concrete inspection" } },
    ]);
  });

  it("disambiguates headers that normalize to the same value", () => {
    const result = buildRecords(
      [
        ["Ref   No", "Ref\\tNo"],
        ["WIR-001", "RFI-001"],
      ],
      0,
    );

    expect(result.headers).toEqual(["Ref No", "Ref No (2)"]);
    expect(result.records[0]?.raw).toEqual({ "Ref No": "WIR-001", "Ref No (2)": "RFI-001" });
  });
});
