# 30 — Database Transition, Audit Trail, and Bootstrap Defaults Review

**Branch:** `dev/review-fixes`  
**Review type:** Static migration review only  
**Scope:** `drizzle/migrations/0000_core_schema.sql`, `0001_triggers_and_rpcs.sql`, `0002_storage_policies.sql`, `0003_import_validation_and_kpi_buckets.sql`.  
**No live database was queried.**

## Executive summary

This review identifies concrete migration-level mismatches against approved project decisions and several database controls that require explicit verification before implementation. The most important confirmed source-level defects are: broad administrator bypass in the workflow RPC; obsolete E defaults; SOR/NCR/SNAG workflow defaults that are not yet approved; and the generic close action's role-based authority. The audit trigger avoids copying comment bodies, which is positive, but it copies most other row data into a shared JSON audit table and requires a sensitive-data review.

No SQL, migration, database, source, secret, setting, or deployment was changed. These findings describe checked-in migration text only; they do not establish the live database's state.

## Findings

### F-30-01 — Workflow RPC grants administrator party bypass (Critical)

`transition_document()` allows project role `admin` to bypass the originating-party check on submit and the current-party check on start_review/respond/return. This is an explicit source-level conflict with the approved rule that administrative role alone does not grant workflow authority or party override.

**Required control:** Remove broad admin bypass in the owning implementation workflow. Derive authority from the authenticated actor's project membership, party, document originator, current step, and action-specific policy. Add negative integration tests for each action. Do not rely on frontend `availableActions()`.

### F-30-02 — Project bootstrap seeds obsolete E meaning and generic response codes (Critical)

`create_project()` seeds A/B/C/D/E/I for every project. E is seeded as “Reviewed – no further action” with outcome `proceed`, conflicting with the approved meaning “Cancelled by Contractor” initiated by the originating contractor. I is seeded as “For information only” with outcome `proceed`; the approved rule requires it to close the review cycle and archive the document while excluding it from B/C KPI. The generic seed also conflicts with MQR's independent workflow and no default A/B/C/D/E/I responses.

**Required control:** Replace bootstrap defaults only through an approved, tested migration after backup/restore. Encode E as an originator cancellation action rather than a reviewer response code; encode I's close/archive semantics explicitly; configure MQR independently with no default response-code set. Preserve historic response records and mark obsolete configuration superseded rather than deleting history.

### F-30-03 — SOR/NCR/SNAG workflow overrides are hard-coded without approved policy confirmation (High)

`create_project()` inserts a consultant-to-contractor workflow for SOR, NCR, and SNAG document types. The open decisions register records these document-type workflow exceptions as requiring confirmation. The migration's default is therefore not an approved operational rule.

**Required control:** Do not treat these defaults as authoritative until parties, order, decision outcomes, and any exceptions are explicitly approved. Avoid silently propagating them to new projects.

### F-30-04 — Generic close action is role-based, not party/decision-based (High)

The `close` branch permits any `admin` or `controller` project role to close an eligible document. It does not visibly constrain the action to a particular workflow party or an authorized document-type-specific close policy. This is inconsistent with the open policy decision on generic close authority.

**Required control:** Define close authority by document type and workflow outcome; avoid broad administrator/controller shortcuts. Enforce the same policy in RPC and UI, with integration tests for wrong party and wrong role.

### F-30-05 — Audit trigger copies most row fields into shared audit JSON (High; data minimization)

`audit_row()` records full inserted/deleted row JSON and changed field values for updates, excluding only `updated_at`; it specifically removes `body` for comments. That protects comment text but does not generally redact other potentially sensitive fields, including document metadata, import metadata/extra columns, names/emails, or attachment metadata. Audit-log read policy and project/draft scoping have been separately flagged in prior reviews.

**Required control:** Define an allowlist of audit fields per entity, redact sensitive values, avoid storing full import payloads/document metadata by default, and enforce authorized audit visibility. Retain enough before/after information for accountability without duplicating confidential document contents.

### F-30-06 — Audit coverage does not include every relevant table in the visible trigger list (Medium)

The visible audit trigger list covers companies, company_members, projects, project_members, response codes, workflows, numbering schemes, documents, revisions, attachments, comments, and import_batches. It does not show audit triggers for import_rows, profiles, or document_reviews. Workflow history is itself append-only by design, but its access and retention still need verification; import-row decision/validation changes may otherwise lack a corresponding generic audit event.

**Required control:** Define the audit event catalogue by business significance. Ensure changes to import decisions/validation and security-sensitive membership changes are attributable and retained, without duplicating sensitive payloads.

### F-30-07 — SECURITY DEFINER function execution grants need PUBLIC-level hardening and live catalog verification (High)

The migration explicitly revokes EXECUTE from `anon` for selected functions, while other functions revoke from `public, anon, authenticated`. PostgreSQL grants to `PUBLIC` are distinct from grants to the `anon` role. Therefore, revoking only from `anon` does not itself prove that PUBLIC cannot execute a SECURITY DEFINER function. The migration text alone cannot establish effective privileges after all migrations, platform defaults, and subsequent changes.

**Required control:** Inventory every SECURITY DEFINER function in the live database using `pg_proc`/ACL catalog queries; revoke from PUBLIC/anon/authenticated by default and grant only to required roles. Verify function owners, fixed search_path, and every call site's independent authorization. This requires a controlled live environment and explicit approval; no catalog query was run here.

### F-30-08 — Storage policy remains project-member-wide, not document-aware (High)

`0002_storage_policies.sql` permits authenticated project members to read objects when the first storage path segment resolves to a project ID; upload uses `can_comment(project_id)`. These policies do not visibly bind object read/upload to the exact document, revision, draft visibility, or document lifecycle. This corroborates Report 19 and is not a new live exploit confirmation.

**Required control:** Use an opaque, validated object path linked to an authorized attachment/document/revision record. Enforce party and lifecycle visibility on both upload and download; test cross-document and cross-party access, including drafts and archived/cancelled documents.

### F-30-09 — Audit and bootstrap source must not be mistaken for live configuration (High; verification boundary)

All conclusions above come from checked-in migration definitions. There is no evidence here that these migrations are currently applied, unapplied, partially applied, or superseded in the connected Supabase project. The repository's backup branch/manifest is not a verified physical database backup or restore test.

**Required control:** Before any DB changes, identify the actual Supabase project/ref through the authorized project connection, take an independent backup, restore it into an isolated environment, compare live schema/function ACLs/policies/reference rows to migrations, and obtain approval for each migration. No live project was queried in this review.

## Required acceptance tests

1. Admin from a non-authorized party cannot submit/start/respond/return/close.
2. E cannot be issued as a reviewer outcome; only the originating contractor can invoke the approved cancellation path.
3. I closes the review cycle and archives per approved rules; it is excluded from B/C KPI.
4. MQR is independently configured and has no default A/B/C/D/E/I response codes.
5. SOR/NCR/SNAG workflow defaults match explicit approved party/order rules.
6. Generic close rejects unauthorized party/role and respects document-type policy.
7. Audit records redact sensitive fields and are visible only to authorized users.
8. Import-row decisions and validation changes are auditable without persisting unnecessary raw content.
9. SECURITY DEFINER ACLs deny PUBLIC/anon unless expressly required and approved.
10. Storage read/upload is denied across document, revision, party, draft, and lifecycle boundaries.

## Safe next sequence

1. Resolve open policy decisions in Report 24, particularly cancellation timing, close authority, MQR, post-draft visibility, and SOR/NCR/SNAG workflows.
2. Confirm the actual Supabase project and obtain an independently restorable backup.
3. Compare live catalog state with migrations, including policies, function definitions, owners, and ACLs.
4. Implement P0 server-side workflow, draft, attachment, and import integrity fixes through the owning workflow.
5. Re-run the acceptance catalogue in an isolated restored environment before any production migration.

**Conclusion:** This static review confirms important defects in the checked-in migration source, but it is not a live database audit, penetration test, backup verification, or security certification.
