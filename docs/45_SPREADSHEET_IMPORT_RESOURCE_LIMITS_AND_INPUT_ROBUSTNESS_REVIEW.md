# 45 — Spreadsheet Import Parser Resource Limits and Input Robustness Review

**Review type:** Static source review  
**Branch:** `dev/review-fixes`  
**Reviewed source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Status:** Findings documented; no source or runtime changes made.

## 1. Scope

This review is limited to the spreadsheet parsing and row-mapping helpers:

- `src/lib/import/excel.ts`
- `src/lib/import/mapping.ts`

The file-selection UI, upload endpoint, staging RPC, storage configuration, and server-side limits were not established from the files reviewed here. Related server-side import integrity findings are tracked separately in reports 18, 29, and 31.

## 2. Executive summary

The workbook parser imports the XLSX library and parses the supplied ArrayBuffer, then materializes every named sheet and its rows into JavaScript arrays. The reviewed helper does not itself enforce visible limits for input bytes, sheet count, rows, columns, total cells, or cell-string length.

This is a resource-exhaustion and robustness concern, not proof of a remotely exploitable vulnerability. Whether it is reachable depends on the file-picker/UI constraints and any upstream validation, which were not confirmed in this scoped review.

The row builder also computes a maximum width across all remaining rows and creates a property for each header/cell position. Large sparse worksheets can therefore amplify memory and CPU use during conversion.

## 3. Findings

### F45-01 — Workbook parsing has no visible resource bounds in the parser helper

**Severity:** High — potential client-side resource exhaustion; reachability requires UI review

**Evidence:**
- `parseWorkbook(buffer)` passes the entire ArrayBuffer to `XLSX.read`.
- It iterates every entry in `wb.SheetNames`.
- It converts each worksheet to a full two-dimensional array with `sheet_to_json`.
- It maps every returned cell through `toCell`.
- No limit is enforced in this helper for buffer byte length, worksheet count, row count, column count, total cells, or cell text length.

**Potential impact:**
- Very large or adversarial workbooks may cause excessive memory allocation, long main-thread tasks, browser tab unresponsiveness, or process termination.
- Materializing all sheets and cells at once increases peak memory compared with bounded or incremental processing.
- A client-side limit alone is not a security boundary; server-side staging and commit paths still need independent limits and validation.

**Required verification/remediation direction (not implemented):**
1. Trace every caller and file-selection path to determine whether a file-size limit exists before parsing.
2. Define documented maximum file bytes, sheets, rows per sheet, columns per sheet, total cells, and per-cell text length based on supported project workloads.
3. Reject over-limit files before full workbook materialization wherever feasible.
4. Enforce authoritative row/batch/cell limits again on the server before staging and at commit.
5. Consider parsing in a Web Worker and/or processing one selected sheet at a time to avoid blocking the UI and retaining unnecessary worksheets.
6. Add tests for boundary values, oversized sparse sheets, excessive sheet counts, malformed workbooks, and very long cell values.

### F45-02 — Record construction expands to the widest row in the entire remaining sheet

**Severity:** Medium — memory/CPU amplification on malformed or sparse workbooks

**Evidence:** `buildRecords()` computes `width` using the maximum of the header row length and every subsequent row length, then creates a header and a raw object entry for every column position for every non-empty row.

**Potential impact:**
- A single unusually wide row can cause all records to be expanded to that width, even when most rows contain few cells.
- The helper has no explicit cap on the number of generated columns or records.
- This compounds the resource exposure described in F45-01.

**Required verification/remediation direction (not implemented):**
- Apply an explicit maximum column count and maximum record count before constructing all row objects.
- Reject or quarantine rows that exceed the supported width rather than silently expanding the whole dataset.
- Test a workbook with one extreme-width row and many ordinary rows.

### F45-03 — Cell conversion and header normalization do not impose a maximum text length

**Severity:** Medium — resource and downstream validation robustness

**Evidence:**
- `toCell()` returns input strings without truncation or length validation (except whitespace-only strings, which become null).
- `buildRecords()` converts header values to strings and normalizes whitespace without a maximum header length.
- `mapping.ts` uses normalized cell values and retains unmapped values in each row's `extra` object.

**Potential impact:**
- Extremely long cell/header strings can increase memory use and produce large validation payloads or diagnostic messages.
- Downstream limits may exist, but were not established by these helpers.

**Required verification/remediation direction (not implemented):**
- Define per-cell and per-header length limits and reject oversized values with a row/column-specific validation message.
- Ensure server-side staging applies the same or stricter limits.
- Avoid copying unbounded raw values into user-visible errors or logs.

## 4. Positive controls observed

- The code uses a typed cell union for mapped values.
- Empty and whitespace-only string cells are normalized to null.
- Invalid JavaScript Date values are converted to null.
- Duplicate header labels are disambiguated with a numeric suffix.
- The parser comment states that workbook parsing occurs in the browser and the file is not sent away until rows are staged; actual network behavior still depends on the caller and staging implementation.

## 5. Required verification before closure

1. Inspect the complete file-selection and caller flow; confirm accepted extensions, MIME handling, and pre-parse byte limits.
2. Confirm the XLSX library version and review applicable security advisories and parser options.
3. Add deterministic resource-boundary tests for file size, sheets, rows, columns, cells, and string lengths.
4. Verify server-side staging and commit RPCs reject oversized and malformed payloads independently of client checks.
5. Test large sparse workbooks and malformed workbook structures in a controlled environment.
6. Measure browser responsiveness and peak memory for the documented maximum supported workbook.
7. Re-run tests after any approved remediation.

## 6. Boundaries and non-actions

- Static source inspection only, limited to the two files named above.
- The file-picker/caller path and server-side enforcement were not established in this report.
- No workbook was uploaded or parsed during this review.
- No source, SQL, migration, database, or storage configuration was changed.
- No tests, lint, typecheck, or build were executed.
- No deployment or pull-request merge was performed.
- This report does not authorize a remediation implementation.

## 7. Conclusion

The parser currently materializes workbook content without visible resource bounds in the reviewed helper. Before enabling broad spreadsheet imports, the project should establish explicit client-side usability limits and independent server-side payload limits, then verify them with oversized and malformed workbook tests. The finding remains open until the caller path and server enforcement are inspected and tested.
