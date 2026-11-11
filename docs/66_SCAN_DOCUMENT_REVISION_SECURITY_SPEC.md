# POL-SCAN-002 — Document- and Revision-Level Security Remediation

**Status:** Security implementation specification; no database change authorized or performed  
**Date:** 2026-11-11  
**Depends on:** DEC-016, POL-SCAN-001  
**Target reuse:** existing `public.attachments` and private `document-files` bucket

## 1. Security objective

Reuse the existing attachment metadata and Storage bucket rather than introducing a parallel file system. Close the authorization gap so every list, preview, download, upload, primary designation, supersession, and withdrawal is authorized against the exact parent document and, when present, its exact revision.

Project membership alone is not sufficient for file access. Comment permission alone is not sufficient for upload. The Project Manager's approved read-only visibility does not grant mutation authority. No administrator bypass may override document party boundaries, draft confidentiality, or separation of duties.

## 2. Existing structures to retain

The source migration currently defines `public.attachments` with:
`id, document_id, revision_id, project_id, company_id, storage_path, file_name, mime_type, size_bytes, uploaded_by, created_at`.

The `document-files` Storage bucket is referenced by current policies. Keep existing IDs and object references stable. Do not rename/drop the table, bucket, columns, or historical objects as part of the scan feature.

A scan-specific classification and primary designation may be added only after the live schema and all attachment consumers have been inventoried. Existing non-scan attachments must preserve their current semantics.

## 3. Required relational invariants

The trusted write path must reject an attachment unless all of the following are true:

1. The document exists and its `id`, `project_id`, and `company_id` match the supplied attachment metadata.
2. If `revision_id` is non-null, that revision exists and belongs to the same `document_id`, `project_id`, and `company_id`.
3. The Storage object key is generated server-side and is unique; it is not derived directly from an untrusted filename.
4. The object is in the expected private bucket and the attachment row references that exact object key.
5. The uploader is the authenticated actor recorded by the trusted path; clients cannot impersonate another uploader.
6. The file has passed server-side type, size, integrity, and quarantine checks before becoming visible as available.
7. A transaction/document can have no more than one active primary scan. Enforce this atomically in the database or trusted transaction, not with a client-side pre-check.
8. A revision-specific attachment remains bound to that revision. A document-level attachment has a null revision and must not be silently copied or reassigned.

The present table definition does not visibly enforce all these invariants. Exact constraint/index/RPC design must be based on the fresh deployed schema and all migration history, not this source excerpt alone.

## 4. Read authorization contract

Define one reusable, server-authoritative predicate for attachment visibility, conceptually:

`can_view_attachment(actor, attachment)` is true only when:
- actor is authenticated;
- attachment row and Storage object resolve to the same document/project/company;
- actor can view the parent document under the current party, draft, and project rules;
- if revision-specific, actor can view that revision under the parent document's visibility rules;
- no confidentiality or lifecycle restriction denies access.

Do not implement this as `is_project_member(project_id)` alone.

The predicate must be used consistently for:
- attachment metadata SELECT;
- Storage object SELECT/download;
- signed URL issuance or server streaming;
- preview route/server function;
- additional-files list and primary-file display.

A signed URL is a temporary bearer capability. Issue it only after checking the exact attachment and parent document; use a short expiry, do not persist it, and do not expose it in logs. If Storage RLS cannot enforce the necessary row/document/revision relationship directly, route reads through a server-authorized function or redesign the object path and policy so the relationship can be verified securely. Do not leave a broad direct-object policy as a bypass.

## 5. Mutation authorization contract

Use separate server-authoritative capabilities:
- `can_upload_scan(actor, document, revision?)`
- `can_designate_primary_scan(actor, document, attachment)`
- `can_withdraw_scan(actor, document, attachment)`

These must resolve against the authorized party and project role for the parent document. They must not be aliases for `can_comment`, project membership, or a blanket admin check.

The exact party/role mapping is deliberately not invented here. Confirm it against the approved project roles and contractual party responsibilities before coding. PM visibility remains read-only. A user who can view a file is not thereby allowed to upload, replace, designate, or withdraw it.

## 6. Storage object path and request flow

Use opaque server-generated keys, conceptually:
`<project_uuid>/<document_uuid>/<revision_uuid-or-document>/<attachment_uuid>`.

Do not place a raw filename or user-supplied path segment in the object key. At every upload request:
1. Verify bearer token claims using the existing `requireSupabaseAuth` function middleware.
2. Use the resulting user-scoped Supabase client for normal access; do not default to the service-role client.
3. Resolve document and optional revision from trusted DB rows.
4. Verify the exact mutation capability.
5. Validate declared and actual file type/size, enforce quotas, and create a pending/quarantined upload record using a generated key.
6. Upload to the private bucket.
7. Verify object metadata/content hash and complete required content checks.
8. Mark the attachment available only after successful validation.
9. Audit the result without storing file contents or signed URLs.

For reads:
1. Verify user claims.
2. Fetch the attachment by ID through a user-scoped path.
3. Re-check parent document and revision visibility.
4. Confirm object bucket/key match the row.
5. Issue a short-lived signed URL or stream the object.
6. Audit the authorized access event without logging the signed URL.

Do not expose service-role credentials to browser code. Any privileged server operation must be narrowly scoped, authenticate and authorize the actor first, and document why RLS bypass is necessary.

## 7. Primary file and historical preservation

- Store primary designation as a trusted, atomic property. A unique partial index or transaction-safe operation may be appropriate, but exact SQL is not prescribed until the live schema is confirmed.
- A primary replacement is a new immutable attachment. Validate it first, then atomically switch the designation and mark the former file superseded.
- Never overwrite an existing object key.
- No normal hard-delete path. Withdrawal/supersession retains metadata and object according to an owner-approved retention rule.
- The current `document_id ON DELETE CASCADE` is a preservation risk. Before production, decide and implement an explicit document deletion/retention guard so scan evidence cannot silently disappear. Do not change FK behavior without a reviewed backup/restore and migration approval.

## 8. Negative security test matrix

| Test | Expected result |
|---|---|
| Authenticated project member cannot view parent draft | Cannot list, preview, sign, or download its scan |
| User from another project guesses attachment UUID | Denied; no metadata or object disclosure |
| User guesses Storage object path | Denied unless exact parent-document visibility is satisfied |
| User has comment-only capability | Upload denied absent separate scan-upload authority |
| PM can view parent document | Scan view allowed only to same visibility scope; all mutation denied |
| PM attempts upload/primary switch/withdraw | Denied |
| Attachment document ID does not match project/company | Write rejected |
| Revision belongs to another document/project | Write rejected |
| Client supplies another uploader ID | Ignored/rejected; actor derived from verified claims |
| Two concurrent primary designation requests | Exactly one active primary |
| Expired signed URL reused | Access denied |
| Pending/quarantined/rejected object requested | Not available to ordinary viewer |
| Attachment row points to a different object key/bucket | Access denied |
| Historical primary superseded | Old file remains retrievable by authorized history view |
| Document deletion attempted with retained scans | Blocked or handled by explicit approved archival process; no silent cascade |
| Scan operation executed | Numbering, revision sequence, lifecycle, review status, response code and KPI outputs unchanged |

## 9. Implementation gates

**Gate 1 — source inventory:** complete all attachment references, Storage bucket configuration references, relevant helper definitions, and every policy affecting documents, revisions, attachments, and Storage. Re-check the exact target branch and current live schema separately.

**Gate 2 — authorization mapping:** approve exact uploader, primary-designator, and withdrawal roles/parties; confirm PM read-only behavior and draft visibility.

**Gate 3 — owner-approved limits:** approve or revise the proposed formats and limits in POL-SCAN-001, quarantine/scanner capability, signed URL expiry, retention, and withdrawal.

**Gate 4 — isolated database safety:** identify DB owner/environment; create independent backup; restore into a separate project; verify restore; inspect deployed policies/grants/schema; prepare exact migration and rollback. No production DB change before explicit approval of the exact migration.

**Gate 5 — isolated implementation:** dedicated feature branch; minimal migration; user-scoped server functions with explicit auth middleware; document/revision-bound RLS and Storage; register UI; regression tests. No merge/deploy until separately approved.

## 10. Current status and limits

This document is a security specification, not implemented security. No source code, UI, server function, migration, generated type, DB, Storage bucket, policy, stored record, or deployment was changed. No live database or Storage state was inspected and no tests were run. Existing policies remain as found in source. The feature must not be described as secure or production-ready until the negative test matrix is executed against an isolated restored environment and reviewed.
