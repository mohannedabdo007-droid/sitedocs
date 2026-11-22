# 47 — Import Batch Partial-Failure Completion Semantics Review

**Review type:** Static migration and RPC review  
**Branch:** `dev/review-fixes`  
**Reviewed source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Status:** Finding documented; no source, SQL, or database changes made.

## 1. Scope

Reviewed the import batch and row status definitions in `drizzle/migrations/0000_core_schema.sql` and the `commit_import_rows()` RPC in `drizzle/migrations/0001_triggers_and_rpcs.sql`.

This is a static review of the checked-in migration source. It does not establish the live database definition or current production behavior.

## 2. Executive summary

The import RPC processes eligible rows individually. A row-level exception is caught, the row is marked `commit_status = 'failed'`, and the loop continues. After the loop, the RPC counts only rows still eligible for import whose `commit_status` is null. When that count reaches zero, it sets the batch status to `committed`.

The batch schema has no distinct terminal status for partial completion or completion with failures. Therefore, a batch can be labelled `committed` even when one or more rows have `commit_status = 'failed'`. The RPC does return a `failed` count, so the failure is not necessarily hidden from a caller that checks and displays the full result. The ambiguity is in the persisted batch-level status and any UI/reporting that treats `committed` as full success.

## 3. Finding

### F47-01 — Batch is marked committed when all eligible rows are terminal, even if some rows failed

**Severity:** Medium — operational status ambiguity and incomplete-import risk

**Evidence:**
1. `import_batches.status` permits `staged`, `validated`, `committing`, `committed`, and `cancelled`; there is no `partially_committed` or `completed_with_errors` state.
2. `import_rows.commit_status` separately permits `created`, `revision_added`, `skipped_existing`, and `failed`.
3. Inside `commit_import_rows()`, each row is processed in a nested exception block. On any row error, the exception handler marks that row `failed` and increments `v_fail`, then continues processing.
4. The final `v_remaining` query counts only rows with `decision = 'import'`, `commit_status is null`, and validation status in `('valid','warning')`.
5. Failed rows have a non-null `commit_status`, so they are excluded from `v_remaining`. When no eligible unprocessed rows remain, the batch is updated to `status = 'committed'`.
6. The returned JSON includes created, revisions_added, skipped_existing, failed, and remaining counts.

**Potential impact:**
- A consumer that reads only the batch status may interpret a partially failed import as a fully successful import.
- Users may not revisit failed rows if the UI treats `committed` as a success-only terminal state.
- Operational dashboards and audit reports may overstate successful completion unless they aggregate row-level outcomes.
- The current RPC result can communicate failures, but that protection depends on every caller correctly consuming and presenting the response.

**Required verification/remediation direction (not implemented):**
- Define the intended meaning of batch-level `committed`: all rows attempted, or all rows successfully imported.
- Prefer an explicit terminal state such as `completed_with_errors` / `partially_committed` if partial completion is an accepted outcome, or preserve a distinct `failed` terminal state when policy requires it.
- If schema enum/status changes are proposed, treat them as a migration requiring backup, verified restore, review, and explicit approval; this report does not authorize such a change.
- Ensure the UI shows per-row created, revision-added, skipped, and failed counts and provides a direct path to inspect failed rows.
- Persist a stable batch summary so the final outcome remains understandable after the RPC response is no longer in client memory.
- Add tests for all-success, all-skipped, mixed success/failure, all-failure, and multi-chunk imports where failures occur in earlier chunks.
- Verify retry behavior: failed rows should be retryable only under a deliberate rule, without duplicating successful rows or silently resetting their commit status.

## 4. Positive controls observed

- A row-level failure is caught and recorded instead of aborting the entire chunk.
- Successful rows are marked with explicit outcomes (`created`, `revision_added`, or `skipped_existing`).
- The RPC returns separate counters for created documents, added revisions, skipped existing revisions, failures, and remaining work.
- The batch row is locked with `FOR UPDATE` while the RPC processes it, reducing concurrent processing of the same batch.
- The chunk limit is bounded to a maximum of 1000 rows.

## 5. Required verification before closure

1. Inspect every caller of `commit_import_rows()` and verify it consumes and displays all returned counters.
2. Inspect the import UI's batch status labels, completion notifications, and navigation behavior.
3. Verify how failed rows are displayed and whether users can safely retry or export them.
4. Test mixed outcomes across multiple chunks and refresh/reopen the batch after completion.
5. Confirm reporting distinguishes attempted rows from successfully created documents/revisions and skipped rows.
6. Reconcile the intended terminal-state semantics with the approved business workflow before proposing a migration.

## 6. Boundaries and non-actions

- Static review of checked-in migration definitions only.
- No live database catalog or import batch was accessed.
- No SQL, migration, source, database, or storage configuration was changed.
- No tests, lint, typecheck, or build were executed.
- No deployment or pull-request merge was performed.
- No batch-status policy or new status value was approved by this report.
- This report does not authorize a remediation implementation.

## 7. Conclusion

The RPC can finish processing a batch with row-level failures while persisting the batch status as `committed`. The returned counters provide useful detail, but the stored terminal status is ambiguous unless all callers consistently present row-level outcomes. Clarify the business meaning of completion and test mixed-result imports before closing this finding.
