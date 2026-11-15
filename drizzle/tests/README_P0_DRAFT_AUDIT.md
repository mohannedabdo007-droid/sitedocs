# P0 draft confidentiality and audit RLS acceptance tests

## Scope

`p0_draft_audit_rls.acceptance.sql` exercises the migration `0004_p0_draft_confidentiality_and_audit.sql` using authenticated JWT subjects against a restored, isolated SiteDocs database. It is not a production migration runner and must never be pointed at the live SiteDocs project.

## Required synthetic fixtures

Apply migration 0004 to the isolated database first, then create all fixtures in that database. The draft and submitted documents, their audit rows, and attachment object must be created after the migration so the audit-payload assertions evaluate the new trigger behavior. Use distinct synthetic Auth users and project memberships:

- `creator_user_id`: creator of `draft_document_id`, member of its originating party.
- `originator_peer_user_id`: another member of the same `originator_party`, with role `controller`, who created `other_party_import_batch_id`.
- `wrong_party_user_id`: explicit project member of a party that is neither the document originator nor the current workflow party (use `pmc` only as a party code, not as a PM flag).
- `current_reviewer_user_id`: explicit project member whose party equals `workflow_steps[current_step]`, with role `reviewer` and not the document creator.
- `project_manager_user_id`: explicit project member with `is_project_manager=true` and role `viewer`.
- `company_admin_user_id`: company owner/admin with no project_members row in the tested project.
- `other_tenant_user_id`: user belonging only to another tenant/project.
- `project_id`: UUID of the first synthetic project.
- `draft_document_id`: draft in the first project, with at least one revision, one audit event, and one registered `document-files` object.
- `submitted_document_id`: submitted document in the first project, with current workflow step set to a party different from `wrong_party_user_id`.
- `self_review_document_id`: submitted document created by `creator_user_id`, with that same user assigned to the current review party; use only in the isolated test DB.
- `attachment_path`: exact `attachments.storage_path` and `storage.objects.name` for the draft attachment.
- `other_party_import_batch_id`: an import batch created by `originator_peer_user_id`, containing at least one synthetic raw import row.
- `draft_ocr_job_id`: an OCR job linked to the protected draft attachment, with synthetic extracted content.

The project manager membership must have `is_project_manager=true`; do not infer PM status from `viewer`, `admin`, or `party='pmc'`.

## Run

Connect with a database owner/admin account to the isolated database. Apply the candidate migration there first:

```sh
psql "$ISOLATED_DATABASE_URL" -v ON_ERROR_STOP=1 \
  -f drizzle/migrations/0004_p0_draft_confidentiality_and_audit.sql
```

Then create the synthetic fixtures described above and execute the acceptance file. Supply fixture IDs as psql variables:

```sh
psql "$ISOLATED_DATABASE_URL" \
  -v creator_user_id="$CREATOR_ID" \
  -v originator_peer_user_id="$ORIGINATOR_PEER_ID" \
  -v wrong_party_user_id="$WRONG_PARTY_ID" \
  -v current_reviewer_user_id="$CURRENT_REVIEWER_ID" \
  -v project_manager_user_id="$PROJECT_MANAGER_ID" \
  -v company_admin_user_id="$COMPANY_ADMIN_ID" \
  -v other_tenant_user_id="$OTHER_TENANT_ID" \
  -v draft_document_id="$DRAFT_DOCUMENT_ID" \
  -v submitted_document_id="$SUBMITTED_DOCUMENT_ID" \
  -v self_review_document_id="$SELF_REVIEW_DOCUMENT_ID" \
  -v attachment_path="$ATTACHMENT_PATH" \
  -v project_id="$PROJECT_ID" \
  -v other_party_import_batch_id="$OTHER_PARTY_IMPORT_BATCH_ID" \
  -v draft_ocr_job_id="$DRAFT_OCR_JOB_ID" \
  -f drizzle/tests/p0_draft_audit_rls.acceptance.sql
```

The SQL file wraps all checks in a transaction and rolls back. A raised `P0_FAIL` exception is a failed assertion. A successful psql exit is required before any P0 database test can be marked passed.

## Required API-level checks not covered by this SQL file

Run these against the same isolated project using the corresponding synthetic authenticated sessions:

1. PostgREST direct GET by known draft UUID for creator, originator peer, other party, PM, company admin, and other tenant.
2. PostgREST direct GET for revisions, reviews, comments, and attachment rows by known IDs.
3. Storage download and signed-URL creation for the registered draft object. Other party, company admin without project membership, and other tenant must receive denial/no usable URL.
4. Storage metadata lookup by known object name and orphan object path must not disclose protected draft files.
5. Invoke `transition_document` directly as PM, wrong party, company admin without project membership, and creator-self-review fixture. All must be denied.
6. Confirm a valid current-party reviewer can transition a submitted document; confirm only the actual creator (not another member of the same party) can submit the draft.
7. Inspect `information_schema.routine_privileges` / `pg_proc.proacl` to verify no unintended PUBLIC/anon EXECUTE on privileged functions.

Record request/response status, JWT actor fixture, database migration version, branch SHA, and redacted evidence. Do not include JWTs, API keys, connection strings, or actual user data in the evidence.

## Current execution status

**NOT RUN — blocked by missing permission to inspect/create a Supabase development branch for SiteDocs.** The GitHub patch and SQL test harness are committed to the development branch only. No live database or Storage changes were made.
