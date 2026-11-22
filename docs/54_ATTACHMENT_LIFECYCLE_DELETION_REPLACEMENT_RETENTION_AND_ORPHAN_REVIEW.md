# 54 — Attachment lifecycle: deletion, replacement, retention, and orphan review

**Branch:** `dev/review-fixes`  
**Review type:** Static source and migration review only  
**Scope:** Attachment metadata, database permissions/RLS, audit trigger, storage-object policies, and the checked application source tree  
**Outcome:** Lifecycle controls are not fully established by the inspected snapshot. The clearest gap is that relational attachment deletion and Storage-object deletion are separate operations, while no coordinated cleanup/retention mechanism was identified in the checked migrations or application source.

## Executive summary

The schema records attachment metadata in `public.attachments` and stores a `storage_path` string. The checked migration grants authenticated users SELECT and INSERT on attachment rows, with matching read/insert RLS policies, but does not grant ordinary authenticated UPDATE or DELETE on those rows. The checked Storage migration defines SELECT and INSERT policies for the `document-files` bucket only; it does not define UPDATE or DELETE policies.

The attachment row references its parent document with `ON DELETE CASCADE`. That cascade removes relational metadata when a document is deleted, but it does not, by itself, delete a binary object held in Supabase Storage. The checked schema contains no foreign key from the attachment row to `storage.objects`, and the checked Storage migration contains no database-side object cleanup trigger or RPC. Consequently, a document cascade can leave a Storage object without a corresponding attachment row unless a separate, verified cleanup process exists outside this reviewed snapshot.

The attachment audit trigger records INSERT, UPDATE, and DELETE operations on attachment metadata. It does not establish that the corresponding Storage object was deleted, replaced, retained, or recoverable.

## Evidence

### 1. Attachment metadata schema

In `drizzle/migrations/0000_core_schema.sql`, `public.attachments` contains:
- `id` primary key;
- `document_id` referencing `public.documents(id) ON DELETE CASCADE`;
- nullable `revision_id` referencing `public.document_revisions(id)` without an explicit delete action;
- `project_id` and `company_id`;
- unique, non-null `storage_path`;
- `file_name`, `mime_type`, `size_bytes`, `uploaded_by`, and `created_at`.

The table has an index on `document_id`. The schema does not declare a foreign key from `storage_path` to a Storage object, nor does it define fields for a replacement chain, deletion state, retention deadline, legal hold, checksum, or object lifecycle status.

### 2. Authenticated row permissions

The same migration grants:
```sql
grant select, insert on public.attachments to authenticated;
grant all on public.attachments to service_role;
```

It defines these attachment RLS policies:
```sql
create policy "attachments: members read"
on public.attachments for select to authenticated
using (public.is_project_member(project_id));

create policy "attachments: contributors insert"
on public.attachments for insert to authenticated
with check (public.can_comment(project_id));
```

No authenticated UPDATE or DELETE grant/policy for `public.attachments` appears in the checked core migration. This is consistent with an append-oriented metadata pattern, but it also means the checked schema does not provide an ordinary authenticated row-level path for correcting or removing attachment metadata. Service-role capability exists at the SQL grant level; its actual use and safeguards were not established here.

### 3. Storage object permissions

`drizzle/migrations/0002_storage_policies.sql` defines:
- a SELECT policy for `storage.objects` in bucket `document-files`, based on project membership derived from the first path segment;
- an INSERT policy for that bucket, based on `public.can_comment(project_id)`.

No UPDATE or DELETE policy for this bucket appears in the checked migration. The policy predicates do not consult `public.attachments` to establish that an object is currently referenced by a live attachment row.

This report does not assert that no other Storage policy exists in a live Supabase project. The live database and any dashboard-managed policies were not inspected.

### 4. Cascades and orphan risk

The attachment's `document_id` foreign key uses `ON DELETE CASCADE`. A parent-document deletion therefore cascades to the relational attachment row. A PostgreSQL foreign-key cascade does not issue a delete against the separate Supabase Storage object store. Since no attachment-to-Storage foreign key exists, the migration itself provides no cross-system cascade.

This creates a concrete orphan risk if a document is deleted while its Storage objects remain: the database attachment metadata may disappear while the object remains stored. Such an object may no longer be discoverable through the attachment table, and the project-path Storage read policy may still authorize project members to read it if they know its path. Whether that path remains discoverable elsewhere is outside this static review.

The `revision_id` foreign key has no explicit `ON DELETE` action, so PostgreSQL's default NO ACTION behavior applies. The snapshot does not document a supported revision deletion/replacement lifecycle.

### 5. Audit evidence and its limit

`drizzle/migrations/0001_triggers_and_rpcs.sql` defines `public.audit_row()` and an `audit_attachments` trigger for AFTER INSERT/UPDATE/DELETE. The audit function records attachment row values/diffs in `public.audit_log`, including the `storage_path` value for attachment INSERT/DELETE events.

This is useful metadata-level traceability. It is not proof of object deletion or replacement: the trigger operates on the relational row and contains no Storage API operation. If a Storage object is removed independently, or an attachment row is cascaded away while the object remains, the attachment audit record alone cannot establish the actual object-store state.

### 6. Application-source coverage

The checked source tree on `dev/review-fixes` contains only the root and index routes in `src/routeTree.gen.ts`; `src/routes/README.md` is the route convention document. The checked `src/lib` and `src/integrations/supabase` listings did not identify an attachment lifecycle service or document-file upload/delete implementation. The Supabase integration includes client/auth infrastructure, not a verified attachment cleanup workflow.

This is a bounded finding: the reviewed snapshot does not establish a complete application workflow for upload, replacement, deletion, retention, or orphan cleanup. It is not a claim that no such workflow exists in any external service, deployed environment, unlisted branch, or dashboard configuration.

## Findings and risk

| ID | Finding | Risk |
|---|---|---|
| ATT-54-01 | Document deletion cascades attachment metadata, but the checked schema does not coordinate deletion of the corresponding Storage object. | High — potential orphaned objects and storage accumulation; access may remain possible under the project-member path policy. |
| ATT-54-02 | No authenticated UPDATE/DELETE grant or RLS policy for attachment metadata was found in the checked migration. | Medium — no demonstrated normal-user correction/removal lifecycle; privileged cleanup may be required. |
| ATT-54-03 | Storage object policies cover SELECT and INSERT only in the checked migration; object UPDATE/DELETE lifecycle is not established. | Medium — replacement and controlled deletion behavior are unverified. |
| ATT-54-04 | Audit records attachment-row changes but does not verify Storage object state. | Medium — metadata audit can be mistaken for proof of binary deletion/replacement. |
| ATT-54-05 | No retention, legal-hold, restore, checksum, or orphan-reconciliation mechanism was identified in the checked snapshot. | Medium — retention and recoverability requirements are not demonstrably enforced. |

## Required design controls before implementation

1. **Define one lifecycle owner.** A trusted server-side service or controlled RPC should coordinate attachment metadata and Storage operations. Do not rely on client-side best-effort cleanup for destructive operations.
2. **Use a safe replacement sequence.** Upload the new object to a new immutable path, validate size/type/checksum, create and verify its metadata, switch the document/revision reference through an authorized transaction, and only then queue the old object for deletion after the retention window. Never overwrite a live object in place without a recoverable version.
3. **Make deletion retryable and observable.** Record a pending-deletion state or durable cleanup job, perform Storage deletion idempotently, record the result, and retry failures. Do not delete the only metadata reference before a cleanup job is durably recorded.
4. **Reconcile orphans.** Periodically compare objects in the managed bucket against attachment `storage_path` references. Quarantine candidates first; exclude objects within an upload grace period and objects protected by legal hold/retention. Require a controlled approval path before permanent purge.
5. **Define retention and legal hold.** Specify retention periods by document class/project contract, preserve audit evidence, and prevent deletion while a hold applies. Define backup/restore expectations for both relational metadata and binary objects.
6. **Harden authorization consistently.** Storage reads, signed URL issuance, replacement, and deletion should resolve the attachment and parent document, enforce project/company scope and document visibility, and reject orphaned or inactive references. Keep direct Storage access aligned with the same rules.
7. **Separate metadata audit from object audit.** Record object operation, path, actor/service identity, timestamp, outcome, retry count, checksum/version where available, and correlation ID. Do not treat an attachment-row DELETE event as proof that the binary was deleted.
8. **Test failure boundaries.** Cover upload success + metadata failure, metadata success + upload failure, replacement interrupted between steps, object deletion failure, duplicate retries, document cascade, restore from backup, and orphan reconciliation. Verify both database and Storage state.

## Validation plan (not executed)

- In an isolated restored environment, create a document with multiple attachments and verify exact row/object mapping.
- Delete a test document and inspect both attachment rows and Storage objects; verify cleanup behavior and audit trail.
- Exercise replacement with failures injected at each stage; confirm the previous valid object remains recoverable until the new attachment is committed.
- Test unauthorized cross-project and non-member access to direct Storage reads, signed URLs, metadata updates, and deletion.
- Run an orphan reconciliation in report-only mode first; verify it does not flag recent uploads, held files, or valid references.
- Restore database metadata and Storage objects from backup and verify paths/checksums and document linkage.

## Scope limitations

- Static inspection of the repository branch `dev/review-fixes`, principally migrations `0000_core_schema.sql`, `0001_triggers_and_rpcs.sql`, `0002_storage_policies.sql`, and the checked `src` tree.
- No live Supabase database, Storage bucket, dashboard policy, deployed server, signed URL, or production object was queried.
- No runtime tests, migration execution, build, lint, or end-to-end test was run.
- No source code, SQL, migration, Storage object, database record, or project setting was changed.
- This report is documentation and a review finding only; it does not authorize a migration or destructive cleanup.
