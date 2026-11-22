# 49 — Import Row Auditability and Change-History Coverage Review

**Review type:** Static SQL migration review  
**Branch:** `dev/review-fixes`  
**Reviewed source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Status:** Finding documented; no source, SQL, or database changes made.

## 1. Scope

Reviewed:
- `public.audit_log` and `public.import_rows` definitions in `drizzle/migrations/0000_core_schema.sql`.
- The generic `public.audit_row()` trigger function and audit trigger registrations in `drizzle/migrations/0001_triggers_and_rpcs.sql`.
- The import commit RPC's row status updates in the same migration.

This review is limited to the checked-in migration source. It does not establish the live database trigger inventory or any application-level audit mechanism.

## 2. Executive summary

The migrations define a shared append-only audit log and register row-level audit triggers for `import_batches`, but do not register an equivalent audit trigger for `import_rows`. The import RPC updates row-level fields including `commit_status`, `committed_document_id`, `committed_at`, and `messages`; the validation RPC also updates validation/decision-related row data.

As a result, the checked-in generic audit trail captures changes to the batch record but does not visibly capture the individual import-row state transitions. Batch-level audit events alone may not explain which row changed, what its previous and new state were, or why a particular row failed.

## 3. Finding

### F49-01 — Import-row state transitions are not covered by the registered generic audit triggers

**Severity:** Medium — auditability and operational investigation gap

**Evidence:**
1. `public.audit_log` is defined as the shared audit table, with entity type/id, actor, action, JSON changes, and timestamp.
2. `public.audit_row()` computes a row-level diff for updates and writes an audit record for the table on which its trigger fires.
3. The migration registers `audit_import_batches` on `public.import_batches`.
4. The migration does not register an `audit_import_rows` trigger on `public.import_rows`.
5. The import commit RPC updates `import_rows.commit_status`, `committed_document_id`, `committed_at`, and `messages` for successful, skipped, and failed outcomes.
6. The import validation function in migration 0003 updates row validation/decision information. No corresponding row-level audit trigger is registered in the reviewed migration set.

**Potential impact:**
- The shared audit log may show that a batch was updated without showing the individual row transitions that produced the final outcome.
- Investigations into failed imports may lack a reliable actor/time/change record for the row's validation and commit-state changes.
- A batch-level event cannot reliably substitute for a row-level history when a batch contains many rows and multiple chunks.
- Operational reporting may be unable to reconstruct how a specific row moved from staged to validated to committed/failed using the generic audit log alone.

## 4. Recommended remediation direction (not implemented)

1. Decide which import-row events require durable audit history: creation/staging, mapping changes, validation result changes, decision changes, commit outcome, retry attempts, and cancellation.
2. Add a dedicated, append-only import-row event history or a carefully scoped audit trigger. Prefer a purpose-built event schema if the generic `audit_log.changes` would retain excessive raw spreadsheet data.
3. Record stable identifiers: batch ID, row ID/number, project/company, actor, timestamp, event type, previous/new status, and a safe reason/error classification.
4. Avoid copying full raw spreadsheet values, credentials, personal data, or unrestricted SQL error details into shared audit records. Apply explicit field allowlists and redaction.
5. Ensure service-role/background operations record a meaningful initiating actor or execution identity rather than silently attributing them to a null user.
6. Preserve append-only behavior for the event history; ordinary users should not be able to rewrite or delete audit events.
7. Verify RLS so users can read only event records within their authorized project/company scope. Audit visibility must not grant edit or workflow authority.
8. Add tests for row insert, validation changes, decision changes, successful commit, skipped row, failed row, retry, and unauthorized cross-project reads.

## 5. Important design caution

A generic trigger that copies the entire `raw` or `mapped` JSON payload into `audit_log.changes` could duplicate sensitive spreadsheet content and substantially increase storage. Any remediation must log only the minimum necessary state and must not copy untrusted raw row payloads or unrestricted exception text by default.

The existing generic audit function already excludes comment bodies. Import-row auditing should apply at least the same data-minimization discipline.

## 6. Required verification before closure

1. Inspect application code for a separate import-row history/event mechanism.
2. Inspect the live database trigger inventory only after the approved backup/restore gate and authorization process.
3. Confirm how validation and commit RPCs execute and which actor identity is available in each path.
4. Confirm audit records are retained and readable by authorized project roles without exposing other projects' import data.
5. Test that a row's state history remains available after the batch is reopened and after subsequent chunks finish.
6. Confirm that audit history does not store full spreadsheet payloads or sensitive error details.

## 7. Boundaries and non-actions

- Static review of checked-in migrations only.
- No live database catalog, import batch, or row was accessed.
- No source, SQL, migration, database, or storage configuration was changed.
- No tests, lint, typecheck, or build were executed.
- No deployment or pull-request merge was performed.
- No new audit schema or trigger was approved by this report.

## 8. Conclusion

The reviewed migrations audit import-batch changes but do not register the generic audit trigger on import rows. Because validation and commit outcomes are stored at row level, this leaves a gap in the shared audit trail unless a separate verified history mechanism exists. Define a minimal, privacy-conscious, append-only row-event history and verify its access controls before closing the finding.
