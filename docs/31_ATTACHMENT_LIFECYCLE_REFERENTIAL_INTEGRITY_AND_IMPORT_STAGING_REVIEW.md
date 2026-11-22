# 31 — Attachment Object Lifecycle, Referential Integrity, and Staging Mutability Review

**Branch:** `dev/review-fixes`  
**Review type:** Static migration review only  
**Scope:** Core foreign keys and grants/RLS in `0000_core_schema.sql`; scope triggers and audit triggers in `0001_triggers_and_rpcs.sql`; Storage policies in `0002_storage_policies.sql`.

## Executive summary

This review focuses on the lifecycle boundary between PostgreSQL rows and Supabase Storage objects, deletion semantics, and direct write permissions on import staging. The checked-in migrations define attachment metadata and Storage object policies separately; no visible trigger or RPC coordinates deletion of the underlying Storage object when an attachment row or parent document is deleted. The import staging tables also grant authenticated editors direct UPDATE access, while the visible scope trigger for import rows runs only on INSERT.

These are source-level findings. No Storage bucket, live row, database catalog, or actual deletion behavior was tested.

## Findings

### F-31-01 — Attachment row deletion is not visibly coupled to Storage object deletion (High)

The `attachments` table stores a unique `storage_path`; the document foreign key uses `ON DELETE CASCADE`. The visible migration set contains no trigger/RPC that deletes the corresponding object from `storage.objects` when an attachment row is deleted or cascaded with its parent document. PostgreSQL row deletion does not itself delete a Supabase Storage object.

**Risk:** orphaned files may remain in the bucket after metadata deletion, consume storage, and remain accessible under the broad project-member Storage SELECT policy identified in Reports 19 and 30.

**Required control:** implement a controlled object lifecycle (prefer an explicit server-side deletion workflow or durable cleanup queue). Verify authorization before deletion, record the operation, handle Storage failures/retries, and ensure metadata is not removed until the object lifecycle outcome is recorded. Do not rely on a database FK to delete a Storage object.

### F-31-02 — Parent document cascade can remove attachment metadata without preserving a cleanup work item (High)

The attachment `document_id` foreign key cascades on document deletion. The visible schema has no `storage_delete_jobs`/outbox record or cascade-aware cleanup trigger. If a document row is deleted, attachment metadata can disappear with it while the Storage object remains.

**Required control:** prevent ordinary hard deletion of documents with files, or use a transactionally recorded deletion/outbox workflow that preserves each storage path for asynchronous cleanup. Keep audit evidence and retry failures. Define retention/legal-hold rules before enabling hard deletion.

### F-31-03 — Attachment revision references can block revision deletion, but lifecycle policy is implicit (Medium)

`attachments.revision_id` references `document_revisions(id)` without an explicit `ON DELETE` action, so PostgreSQL's default NO ACTION behavior applies. By contrast, the parent document reference cascades. This can prevent deleting an individual revision while attachment rows refer to it, but does not define what should happen to those files when a revision is superseded, archived, or retained.

**Required control:** define revision retention and attachment ownership explicitly. Prefer immutable revision/file history; avoid deleting a revision merely to clean up a file. Test document cascade and revision deletion separately.

### F-31-04 — Import-row scope trigger runs on INSERT, not UPDATE (High)

`import_rows_scope()` derives `project_id` and `company_id` from the parent batch, but its trigger is declared only `BEFORE INSERT`. The table grants authenticated users UPDATE, and the RLS update policy checks `can_edit_documents(project_id)`. The visible schema does not show a matching UPDATE trigger to re-derive or lock `batch_id`, `project_id`, or `company_id` during later updates.

**Risk:** an editor can attempt to alter scope-bearing columns directly, subject to the current RLS row check and constraints. RLS is not a substitute for immutable parent-child scope constraints.

**Required control:** make scope columns immutable after insert or derive them on every relevant UPDATE; ensure batch reassignment is prohibited; add database constraints/triggers and negative tests for changing batch/project/company IDs.

### F-31-05 — Import staging table grants direct UPDATE over commit-control fields (High; overlaps Report 18)

Authenticated users receive table-level UPDATE on `import_rows`; the RLS policy allows updates to rows when `can_edit_documents(project_id)` is true. The visible policy is row-level, not column-level. The commit RPC uses fields such as `decision`, `validation_status`, `mapped`, and `commit_status` to decide which rows to process. The visible `save_import_validation()` restricts its own update to uncommitted rows, but that restriction does not automatically constrain direct table UPDATE statements.

**Risk:** an authorized editor may directly alter fields that control import eligibility or apparent commit state, bypassing the intended RPC pathway. This is an additional write-surface observation to the server-side revalidation gaps in Report 18, not a claim that an unauthorized user can write.

**Required control:** revoke broad table UPDATE and expose narrowly scoped RPCs or column-level grants. Make `commit_status`, committed document IDs/timestamps, and immutable scope fields server-managed only. Recompute validation at commit and reject forged decisions/statuses. Test direct SQL/API attempts against both pending and committed rows.

### F-31-06 — Import batch UPDATE also exposes lifecycle/configuration fields through broad table grant (Medium)

Authenticated users have table-level UPDATE on `import_batches`, with an RLS policy based on `can_edit_documents(project_id)`. The table includes workflow-control fields such as `status`, `document_type_id`, mappings, totals, and stats. No visible guard trigger restricts transitions such as staged → validated → committing → committed/cancelled or prevents edits after commit.

**Required control:** enforce batch state transitions and immutable post-commit fields server-side. Separate user-editable mapping fields from server-owned lifecycle/status/counters. Add concurrency and replay tests for committing/cancelled/completed batches.

### F-31-07 — OCR job records are readable to project editors but lack visible client-side write policy (Informational)

The schema grants authenticated SELECT on `ocr_jobs` and defines a project-editor SELECT policy; it does not grant authenticated INSERT/UPDATE in the visible migration. This is a useful restrictive default. Any future OCR worker or review UI should use a narrowly scoped server-owned path and must not expose extracted content or reviewer decisions to unauthorized parties.

**Required control:** retain server-owned writes, define party/document visibility for extracted data, and audit OCR review decisions before the feature is enabled.

## Required acceptance tests

1. Deleting an attachment metadata row cannot silently strand an accessible Storage object.
2. Deleting a document with attachments creates a durable cleanup record or is rejected by retention policy.
3. Storage deletion failure is retried and leaves auditable state.
4. Revision deletion is blocked or handled according to an explicit retention policy.
5. Direct UPDATE cannot change an import row's batch/project/company scope.
6. Direct UPDATE cannot forge `commit_status`, committed IDs, or committed timestamps.
7. Only approved RPC paths can alter import decision/validation fields.
8. A committed or cancelled import batch cannot be silently reopened or remapped.
9. Concurrent/replayed commit calls cannot duplicate or corrupt imported records.
10. OCR extracted content and decisions remain inaccessible to unauthorized project parties.

## Safe next sequence

1. Resolve the import staging write model and make server-owned fields immutable.
2. Define attachment and revision retention, hard-delete, archive, and legal-hold policy.
3. Design Storage object cleanup with an auditable outbox/retry mechanism.
4. Verify actual bucket configuration, Storage policies, and existing orphan objects only after identifying the correct Supabase project and securing a restorable backup.
5. Run acceptance tests in an isolated restored environment before any production changes.

**Conclusion:** The checked-in migrations expose additional lifecycle and direct-write risks that must be addressed before enabling document/file deletion or treating import staging as tamper-resistant. This is not a live Storage/database test or security certification.
