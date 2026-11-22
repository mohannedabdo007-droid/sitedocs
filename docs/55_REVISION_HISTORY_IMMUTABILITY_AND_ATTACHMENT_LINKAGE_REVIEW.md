# 55 — Revision history integrity, immutability, and attachment linkage review

**Branch:** `dev/review-fixes`  
**Review type:** Static migration/source review only  
**Scope:** `documents`, `document_revisions`, `document_reviews`, attachment-to-revision linkage, revision lifecycle triggers, grants/RLS, and audit behavior  
**Outcome:** The schema has useful append-oriented controls for authenticated users and validates revision ownership when attachments are inserted. However, immutability is not enforced by a dedicated database guard, and the checked foreign keys do not independently enforce that every revision reference belongs to the same parent document.

## Executive summary

The checked migrations establish a revision sequence per document, create initial revision 00, and require a document to be Returned or Approved before an ordinary user can create a subsequent revision. New revisions become the document's current revision and reset the document to Draft. Authenticated users receive SELECT and INSERT, but not UPDATE or DELETE, on `document_revisions`.

These are meaningful controls, but they are not equivalent to database-enforced immutability. No BEFORE UPDATE/DELETE rejection trigger for `document_revisions` was found in the checked trigger migration, and `service_role` receives ALL privileges. The audit trigger records revision changes, but audit logging detects and records changes; it does not prevent them.

The attachment insert trigger verifies that a supplied `revision_id` belongs to the same `document_id`. The database foreign key on `attachments.revision_id` only checks that the referenced revision exists; it does not express the same-document relationship as a composite constraint. The ownership check is implemented in a BEFORE INSERT trigger, not as a declarative composite foreign key or an UPDATE trigger. This leaves the integrity guarantee dependent on the insertion path and the privileges of any privileged writer.

## Evidence

### 1. Revision table and privileges

In `drizzle/migrations/0000_core_schema.sql`, `public.document_revisions` includes:
- `document_id` referencing `public.documents(id) ON DELETE CASCADE`;
- `project_id` and `company_id`;
- `rev_index` and `rev_label`;
- submission/response metadata, source, creator, and creation timestamp;
- unique constraints on `(document_id, rev_index)` and `(document_id, rev_label)`.

The migration grants:
```sql
grant select, insert on public.document_revisions to authenticated;
grant all on public.document_revisions to service_role;
```

The authenticated grant does not include UPDATE or DELETE. This prevents ordinary authenticated clients from directly updating or deleting revision rows through those table privileges. However, the schema does not define a revision-specific trigger that rejects UPDATE or DELETE regardless of caller, and the service role has broad table privileges.

### 2. Revision creation and sequence rules

`drizzle/migrations/0001_triggers_and_rpcs.sql` defines `revisions_before_insert()`:
- locks the parent document row;
- derives `project_id` and `company_id` from the parent document;
- for non-import inserts, derives the creator and source;
- clears imported workflow-response fields for manual revisions;
- if revisions already exist, permits a new manual revision only when the document status is `returned` or `approved`;
- assigns the next `rev_index` using the current maximum plus one;
- supplies a padded revision label when one is not provided.

The `revisions_after_insert()` trigger updates the document's current revision pointer when the new revision is current/latest. For a non-import revision above index zero, it resets the document lifecycle to Draft and clears current response/submission/closure fields.

The initial document trigger creates revision `00` for ordinary manual document creation. The import path uses a transaction-local import flag and has separate revision handling.

### 3. Current revision pointer constraint

The migration adds a foreign key from `documents.current_revision_id` to `document_revisions(id)`, deferrable and initially deferred.

That foreign key proves that the referenced revision row exists. It does not, by itself, prove that the referenced revision's `document_id` equals the owning `documents.id`. The normal revision trigger updates the pointer using the revision's own parent document, which is a sound normal path; however, the database constraint is not composite and does not independently encode this parent-child identity invariant.

A composite relationship or equivalent database guard should be considered if privileged maintenance paths, imports, or future RPCs can set the pointer outside the normal trigger path.

### 4. Attachment-to-revision ownership

The attachment schema declares:
```sql
document_id uuid not null references public.documents(id) on delete cascade,
revision_id uuid references public.document_revisions(id)
```

The `set_scope_from_document()` trigger in `0001_triggers_and_rpcs.sql` derives project/company scope from the parent document and, when `revision_id` is supplied, checks that a revision exists with both the supplied revision ID and the same document ID. It raises `REVISION_MISMATCH` if that check fails.

This is a useful insertion-time ownership check. The checked trigger is defined `BEFORE INSERT` on attachments. The schema's simple foreign key on `revision_id` does not itself enforce the same-document condition. Also, the authenticated table grant does not include UPDATE, but the service role has ALL privileges; the checked trigger does not cover privileged UPDATE operations.

### 5. Review-history linkage

`document_reviews.revision_id` references `document_revisions(id)`, while `document_reviews.document_id` separately references `documents(id)`. The checked migration does not define a composite foreign key tying the review's revision to the same document. The normal workflow RPC records the current revision ID when it inserts a review event, but the declarative constraint does not independently encode that relationship.

The review table is described as workflow history and authenticated users are granted SELECT only. The audit trigger covers INSERT/UPDATE/DELETE events, but no dedicated immutable-row trigger was identified in the checked migration.

### 6. Audit behavior

The `audit_row()` trigger function records INSERT payloads and UPDATE diffs, and captures the OLD row for DELETE events. Triggers are attached to documents, revisions, and attachments.

This provides a record of observed row changes. It is not an immutability control: an UPDATE or DELETE can still occur if the executing role has sufficient privileges. Audit retention, protection against privileged audit-log alteration, and live database trigger state were not validated in this static review.

## Findings and risk

| ID | Finding | Risk |
|---|---|---|
| REV-55-01 | Revision history has no dedicated database trigger rejecting UPDATE/DELETE; service_role has ALL privileges. | High — privileged paths can potentially rewrite or remove historical revision records unless protected by additional controls outside this snapshot. |
| REV-55-02 | Attachment revision ownership is checked on INSERT by a trigger, not encoded as a composite foreign key and not checked on UPDATE. | Medium — privileged updates or future write paths could create cross-document revision references. |
| REV-55-03 | `documents.current_revision_id` references a revision ID without a composite same-document constraint. | Medium — the FK alone does not enforce that the current revision belongs to its document. |
| REV-55-04 | `document_reviews.revision_id` and `document_id` are independently constrained, not constrained as a same-document pair. | Medium — workflow-history linkage relies on the normal RPC insertion path rather than a declarative invariant. |
| REV-55-05 | Audit triggers record changes but do not prevent revision/history mutation. | Medium — auditability should not be mistaken for immutability or tamper resistance. |

## Recommended controls before implementation

1. **Enforce append-only revision history at the database boundary.** Add a narrowly scoped guard rejecting UPDATE and DELETE for revision rows in ordinary operation. Define an explicit, separately authorized archival/repair process rather than relying solely on application conventions.
2. **Constrain privileged access.** Review every service-role caller and keep the service key server-side. Require explicit purpose, actor attribution, and audit correlation for any exceptional maintenance operation.
3. **Encode same-document relationships declaratively.** Consider unique keys and composite foreign keys for revision identity pairs, so attachments, review events, and the current-revision pointer cannot refer to a revision belonging to another document even if a trigger path is bypassed.
4. **Validate every write path.** If attachment or review rows can be updated in future, apply the same parent/revision ownership validation on UPDATE as on INSERT.
5. **Protect audit evidence.** Restrict direct audit-log mutation, monitor privileged changes, and define retention/backup controls for audit records. Keep audit evidence independent of the mutable entity being audited.
6. **Preserve historical attachment identity.** Ensure each file is bound to the exact revision it was issued with; do not silently reassign an old attachment to a newer revision. Use a new attachment record/path for a replacement.
7. **Test normal and privileged paths.** In an isolated restored environment, attempt cross-document revision references, revision UPDATE/DELETE, pointer mismatch, attachment reassignment, and review-event mismatch under authenticated and service-role contexts. Confirm both database rejection and audit behavior.

## Validation plan (not executed)

- Create a document and verify initial revision 00 and current pointer.
- Submit/respond/return or approve a document, create the next revision, and verify sequence/current pointer/status reset.
- Attempt direct authenticated UPDATE/DELETE of a revision and confirm permission denial.
- In an isolated environment, test privileged UPDATE/DELETE and determine whether an immutable guard exists in the actual deployed database.
- Attempt to attach a revision belonging to another document and verify `REVISION_MISMATCH`.
- Test mismatched current-revision and review-event references through every supported write path.
- Verify audit records for permitted and rejected operations, and confirm that audit data cannot be altered by ordinary project members.

## Scope limitations

- Static inspection of `dev/review-fixes`, principally `0000_core_schema.sql` and `0001_triggers_and_rpcs.sql`.
- No live database, deployed RLS/policy state, privileged service-role caller, or production record was queried.
- No runtime tests, migration execution, build, lint, or end-to-end test was run.
- No source code, SQL, migration, database record, or project setting was changed.
- This report documents findings and recommendations only; it does not authorize schema changes or privileged data repair.
