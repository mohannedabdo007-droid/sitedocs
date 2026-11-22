# 46 — Import Date Parsing, Warning Semantics, and Data Loss Review

**Review type:** Static source review  
**Branch:** `dev/review-fixes`  
**Reviewed source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Status:** Finding documented; no source or runtime changes made.

## 1. Scope

Reviewed `src/lib/import/mapping.ts`, focusing on:
- `parseDate()`
- Date-field conversion inside `validateRows()`
- The resulting validation status and import decision

This report concerns the client-side row-mapping/validation helper. Server-side import commit integrity is covered separately in reports 18, 29, and 31 and must independently validate the submitted data.

## 2. Executive summary

When a mapped date value cannot be parsed, `dateOf()` adds a warning and returns `null`. The row is then assigned `validation_status: "warning"` when it has no other errors. The final decision explicitly treats both `valid` and `warning` rows as `"import"`.

As a result, a row containing an invalid submitted date, response date, or due date can remain importable while the invalid date is silently represented as an empty value in the mapped record. The warning message retains the raw value for the UI, but the mapped date field itself is null.

This is a data-integrity and user-confirmation concern. It does not establish that server-side storage accepts the row unchanged; that requires inspection and tests of the staging/commit path.

## 3. Finding

### F46-01 — Invalid mapped dates are downgraded to warnings and remain importable

**Severity:** High — potential silent loss or corruption of imported date information

**Evidence:**
1. `parseDate()` returns the sentinel string `"invalid"` when a non-empty value cannot be parsed using the selected date order or is not a valid calendar date.
2. In `validateRows()`, `dateOf()` converts that sentinel into a warning and returns `null`.
3. The three mapped fields affected are `submitted_at`, `responded_at`, and `due_date`.
4. When there are warnings but no errors, the row receives `validation_status = "warning"`.
5. The final decision is `"import"` for both `"valid"` and `"warning"` rows.

**Potential impact:**
- A user may import a record believing its date was retained when the mapped value is actually null.
- KPI, overdue, turnaround, chronology, and audit interpretation may be affected where these dates are used.
- The UI may display a warning, but the helper does not require an explicit per-row acknowledgement or correction before marking the row importable.

**Required verification/remediation direction (not implemented):**
- Decide and document which date fields are mandatory, optional, or conditionally mandatory for each document type and lifecycle.
- Treat invalid non-empty dates as blocking errors by default, unless an explicitly approved business rule permits omission.
- If warnings remain importable, require explicit user acknowledgement and make the affected field/value visible in the final import confirmation.
- Preserve the original invalid value in a controlled staging/error field for correction and audit; do not silently discard it.
- Ensure the server re-parses and validates date values at commit, rather than trusting client-supplied validation status or mapped fields.
- Add tests for impossible dates, ambiguous day/month values, unsupported formats, numeric serial boundaries, empty optional dates, and each of the three date fields.
- Add end-to-end tests proving invalid dates cannot silently become null in committed records.

## 4. Positive controls observed

- Date parsing uses the user-selected DMY/MDY/YMD order rather than guessing.
- Calendar validity is checked by round-tripping through UTC date components.
- Empty values are distinguished from invalid non-empty values by the parser.
- The warning message identifies the field and includes the original normalized value for review.
- Excel serial dates are handled through a defined conversion path.

## 5. Required verification before closure

1. Inspect the UI to confirm exactly how warning rows and raw invalid values are presented.
2. Verify whether the user can correct a date after preview and whether acknowledgement is recorded.
3. Trace staging and commit RPCs to confirm server-side parsing and rejection behavior.
4. Test that an invalid date cannot be committed as null without an explicit approved decision.
5. Confirm downstream KPI and overdue calculations handle legitimately absent dates consistently.
6. Re-run relevant tests after any approved implementation change.

## 6. Boundaries and non-actions

- Static source inspection only.
- No live import batch, database, or production record was accessed.
- No source, SQL, migration, database, or storage configuration was changed.
- No tests, lint, typecheck, or build were executed.
- No deployment or pull-request merge was performed.
- No new business rule was approved by this report.
- This report does not authorize a remediation implementation.

## 7. Conclusion

The current helper makes an invalid non-empty date non-blocking by converting it to null and marking the row importable with a warning. This should be resolved as an explicit import policy and enforced again on the server. Until then, date-bearing imports carry a documented risk of silent information loss.
