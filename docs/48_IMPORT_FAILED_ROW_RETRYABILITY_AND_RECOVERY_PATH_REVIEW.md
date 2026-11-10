# 48 — Import Failed-Row Retryability and Recovery Path Review

**Review type:** Static SQL migration review  
**Branch:** `dev/review-fixes`  
**Reviewed source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Status:** Finding documented; no source, SQL, or database changes made.

## 1. Scope

Reviewed the import row state constraints in `drizzle/migrations/0000_core_schema.sql` and the chunked `commit_import_rows()` RPC in `drizzle/migrations/0001_triggers_and_rpcs.sql`. The migration directory on the reviewed branch contains migrations 0000 through 0003; the other checked migration files were considered when looking for a failed-row reset/retry path.

This is a static review of checked-in migration source, not a live database inspection. It does not prove that no external operator or application-level recovery mechanism exists.

## 2. Executive summary

The commit RPC selects rows for processing only when `commit_status is null`. Its per-row exception handler writes `commit_status = 'failed'`. A subsequent call to the same RPC therefore excludes those failed rows from its processing query. In the checked migrations, no dedicated reset/retry RPC or state transition that clears a failed row's commit status was identified.

Consequently, the built-in chunk continuation mechanism does not itself retry failed rows. Unless another verified recovery mechanism exists outside the checked migration set, failed rows can remain terminal and require a deliberate recovery procedure.

## 3. Finding

### F48-01 — Failed import rows are excluded from subsequent commit attempts

**Severity:** Medium — recovery gap and risk of stranded import rows

**Evidence:**
1. The `import_rows.commit_status` column allows `created`, `revision_added`, `skipped_existing`, and `failed`; it is nullable before processing.
2. The processing query in `commit_import_rows()` filters on `decision = 'import'`, `commit_status is null`, and `validation_status in ('valid','warning')`.
3. The row-level exception handler updates the failed row to `commit_status = 'failed'` and appends the SQL error message.
4. Because `failed` is non-null, that row no longer matches the processing query on a later call.
5. The reviewed migration directory contains no explicit retry RPC or failed-row reset procedure. This observation is limited to the checked-in migrations; UI, external jobs, manual operational procedures, and live database objects were not verified.

**Potential impact:**
- Retrying the batch RPC may process remaining untouched rows but will not retry rows already marked failed.
- Operators may see a batch with failed rows but have no clearly defined in-product recovery action.
- A transient database or constraint error may leave a row stranded even after the underlying cause is corrected.
- A naive manual reset could create duplicate documents/revisions if it is not reconciled against the successful rows already committed in earlier chunks.

## 4. Recommended recovery design (not implemented)

1. Define an explicit retry policy and eligible failure classes. Do not automatically retry permanent validation, authorization, or data-integrity errors.
2. Provide a controlled retry operation that targets selected failed rows only, checks the parent batch and project authorization, records the retry actor/time/reason, and preserves the original failure history.
3. Before retrying, reconcile each row against persisted documents and revisions using stable document/revision keys; never assume a failed client response means no database write occurred.
4. Keep successful rows immutable to the retry path. Do not clear or reset `created`, `revision_added`, or `skipped_existing` outcomes.
5. Record retry attempts and their outcomes in an auditable history rather than overwriting the only evidence of the first failure.
6. Make chunk continuation and failed-row retry separate operations with explicit UI labels and counters.
7. Test: transient failure then successful retry; permanent failure remains failed; duplicate document/revision protection; retry after earlier chunks succeeded; concurrent retry attempts; authorization boundaries; and refresh/reopen after retry.
8. Coordinate the retry state model with the batch terminal-state semantics in Report 47. A batch should not appear fully successful while failed rows remain unresolved.

## 5. Safety constraints

- Do not implement a generic client-side update that sets arbitrary `commit_status` values.
- Do not reset the entire batch or all row statuses to make a retry possible.
- Do not replay successful rows.
- Any schema/RPC migration proposal requires independent backup, a verified restore, review, and explicit approval before application.
- Any retry must be idempotent with respect to document number and revision identity and must preserve audit evidence.

## 6. Required verification before closure

1. Inspect all application callers and UI actions for a retry/reset mechanism.
2. Inspect the live database catalog only after the approved backup/restore gate and authorization process.
3. Confirm whether external operational tooling can reset or retry failed rows.
4. Reproduce a mixed chunk where one row fails and another succeeds, then invoke the RPC again and verify which rows are selected.
5. Verify that any approved retry path cannot duplicate already-created documents or revisions.
6. Confirm retry authorization is scoped to the same project/company permissions as import commit.

## 7. Boundaries and non-actions

- Static review of checked-in migrations only.
- No live database, production batch, or import row was accessed.
- No source, SQL, migration, database, or storage configuration was changed.
- No tests, lint, typecheck, or build were executed.
- No deployment or pull-request merge was performed.
- No retry policy or recovery implementation was approved by this report.

## 8. Conclusion

The checked-in commit RPC marks a failed row with a non-null terminal status, while later commit attempts select only rows whose commit status remains null. The same RPC therefore does not retry previously failed rows. Define and verify a controlled, auditable, idempotent recovery path before treating chunk continuation as a complete retry strategy.
