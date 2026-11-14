# Independent review of open PRs 12-17 (static, 2026-11-14)

Scope: read the diffs only. Nothing was run (no install/tests/CI here), no DB contacted, no PR modified or commented.
Verdicts: BLOCK = fix before merge, CHANGE = merge after a small change, OK = fine, CONFIRM = needs an owner decision.

| PR | Verdict | Summary |
|---|---|---|
| 12 workflow party guard (client) | OK, incomplete | Removes the admin bypass in `availableActions` (UI only). Server RPC `transition_document` still lets admin bypass the party check, and admins can still change their own `party`. UI hiding is not a control. |
| 13 CIV/STR normalization | CONFIRM | Implements the repo baseline (docs/06, docs/21: CIV+STR -> CIVSTR). My recorded decision of 2026-11-10 said Structural and Civil are separate. Owner must confirm which is current. Also: until a CIVSTR row exists, `str`/`civ` no longer auto-map in the import (they map to `civstr`, not found), so users must map them by hand. |
| 14 invalid date blocks import | OK | Invalid mapped dates become errors; test covers it. |
| 15 Excel resource limits | BLOCK | (1) Regression: `.replace(/\s+/g, " ")` became `.replace(/\\s+/g, " ")` in `buildRecords`; header whitespace is no longer normalized (it now matches a literal backslash+s). No test covers it. (2) Limits run AFTER `XLSX.read` has fully parsed the workbook, so a small zip with huge decompressed XML (zip bomb) is not stopped; use `sheetRows` option, check uncompressed size from the zip directory, and parse in a Worker with a timeout. |
| 16 integration of 14+15 | BLOCK | Same regex regression (line 110 of its diff). Contains the changes of 14 and 15: merge 16 OR (14 + 15), never all, or they conflict/duplicate. |
| 17 restore verification (base: fix/cloudflare-workers-build) | OK | Better than my draft: checks exit codes, refuses same DB, requires empty target, `--single-transaction`, `--exit-on-error`. Retire `docs/claude-phase0/backup_and_restore_test.*` (my draft only warned on pg_restore errors and could report a false pass). Still not covered: auth users and Storage files. Note it is stacked on another branch, not dev/review-fixes. |

## Required follow-ups
- Server side: PR 12's rule must be enforced in `transition_document` and in `project_members` policies (party immutability, submitter != approver). Add DB tests (docs/02) before claiming it is fixed.
- Add a vitest for header normalization (e.g. "Doc  No" and "Ref\nNo" must become "Doc No" and "Ref No") to catch the regex regression.
- Decide discipline model (separate STR/CIV vs CIVSTR + SUR) in docs/DECISIONS.md with a date, then align PR 13, seeds and KPIs.
