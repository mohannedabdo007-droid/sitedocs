# POL-SCAN-001 — Scanned Document Attachment Design Proposal

**Status:** DESIGN PROPOSAL — not implementation authorization  
**Date:** 2026-11-11  
**Governing decision:** DEC-016 in `docs/01_MASTER_DECISION_REGISTER.md`  
**Scope:** One primary scanned file plus additional scanned files per transaction/document.

## 1. Executive decision

Reuse the existing `public.attachments` metadata concept and private `document-files` Storage bucket where a fresh environment check confirms they exist and are configured as expected. Do not create a parallel scan table or bucket by default. The existing implementation is not sufficient as-is: its visible policies authorize reads by project membership and uploads by the broad `can_comment(project_id)` predicate, rather than enforcing document/revision visibility and an explicit file-management permission.

The scan feature must be additive and must not affect document numbering, revision sequence, lifecycle, review decisions, workflow authority, response codes, or KPI calculations.

## 2. Read-only source findings

Reviewed on branch `dev/review-fixes`:

- `drizzle/migrations/0000_core_schema.sql` defines `public.attachments` with: id, document_id, nullable revision_id, project_id, company_id, storage_path, file_name, mime_type, size_bytes, uploaded_by, created_at.
- The table has authenticated SELECT and INSERT grants; no authenticated UPDATE/DELETE grant is visible in that migration excerpt.
- Its RLS policies allow attachment SELECT for any project member and INSERT for users satisfying `can_comment(project_id)`.
- `drizzle/migrations/0002_storage_policies.sql` defines a `document-files` bucket policy that permits SELECT to project members based on the first path segment being a project UUID, and INSERT to users satisfying `can_comment(project_id)`.
- The current storage path policy does not visibly bind an object to a specific attachment row, document, revision, party visibility, or draft confidentiality.
- The attachment row references document and revision separately; the reviewed table definition does not itself enforce that the revision belongs to the same document/project/company.
- The document FK uses `ON DELETE CASCADE`; this can remove metadata when a document is deleted and therefore needs a preservation/retention guard before production use.
- The reviewed excerpt does not establish bucket-level size/MIME configuration, malware scanning, object lifecycle, signed URL configuration, or live deployed policy state.
- `requireSupabaseAuth` exists as a function middleware and validates claims, but a future server function must explicitly apply it. The global token attacher alone is not authentication.
- These are source/migration observations only. No live Supabase project, Storage bucket, RLS policy, grant, or runtime behavior was inspected.

## 3. User-facing register behavior

Each document row shows:
- A primary scan indicator and the primary file's short display name (for example, `WIR-125.pdf`).
- A count/link for additional files when present.
- An empty state when no scan has been attached.

Selecting the primary name opens that file. Selecting the additional-files control opens a small list with file name, type, size, revision association (if any), and upload timestamp. The viewer should support PDF and common raster scans; it must not expose a public permanent URL.

The UI must show the scan file's own display name, not use the attachment as a substitute for the document's official title or transaction number. The register remains usable when the file is absent or inaccessible.

## 4. Proposed file constraints (owner review required)

Recommended initial defaults, subject to confirmation against actual project operating needs and infrastructure limits:

| Constraint | Proposed default | Notes |
|---|---:|---|
| Allowed formats | PDF, JPEG, PNG | Validate extension, declared MIME, and file signature; do not trust browser MIME alone. Reject SVG, HTML, scripts, executables, archives, and Office files in this scan feature. |
| Maximum individual file | 25 MiB | Enforce before upload and again at the trusted server/storage boundary. |
| Maximum files per transaction | 20 total | Exactly one may be designated primary; remaining files are additional. |
| Aggregate scan storage per transaction | 100 MiB | Count active and retained versions, not merely currently visible files. |
| Display name | 180 Unicode characters | Store original filename safely; render escaped text and derive a sanitized display name. |
| Preview access | Short-lived signed URL, 5 minutes | Generate only after authorization; never persist or log the signed URL. |
| Upload completion | Quarantine until checks pass | Do not expose a file in the register/viewer until type, size, ownership, and integrity checks pass. Malware scanning requires a real configured scanner; do not claim scanning if none exists. |

A failed or interrupted upload must not create a visible attachment row or consume the primary slot. Enforce limits on the server, not only in browser controls.

## 5. Metadata and storage design (conceptual only)

Reuse the existing attachment record if its actual deployed schema is compatible. The implementation proposal should add or represent, through a reviewed schema change only:
- attachment category = `scan` (so existing non-scan attachments retain their meaning);
- primary/additional designation, with a server-enforced single-primary invariant per document;
- upload/verification state (pending, quarantined, available, rejected);
- content hash (SHA-256) and verified MIME/size;
- immutable original filename plus sanitized display filename;
- revision association, nullable only for transaction-level scans not tied to a specific revision;
- audit metadata for designation, supersession, and authorized removal.

Use opaque, non-user-controlled object paths, for example:
`<project-id>/<document-id>/<revision-id-or-document>/<random-attachment-id>`.
Never use a user-supplied filename as the object key. The server must verify that project, document, revision, company, and attachment identifiers all belong together.

A database constraint/transaction or a server-authoritative operation must prevent two primary files for the same document under concurrent uploads. Changing the primary pointer must be atomic and audited.

## 6. Authorization model

All operations require a verified authenticated user and server-side authorization against the document, not merely project membership.

| Operation | Proposed authorization |
|---|---|
| List scan metadata | Same document visibility rules as the parent document, including draft confidentiality and the approved PM read-only visibility exception. |
| Preview/download | Re-check document visibility and attachment-to-document/revision association for every request; issue a short-lived signed URL only after authorization. |
| Upload additional scan | Explicit document attachment-management permission for the user's originating/authorized party; project membership or `can_comment` alone is insufficient. |
| Set/replace primary designation | Explicit attachment-management permission; atomic update and audit. |
| Remove/withdraw | No hard delete by default. Use an authorized, audited withdrawal/supersession flow, retaining the historical record/object under the approved retention policy. |
| Project Manager | Read-only viewing remains as approved; no upload, primary designation, replacement, or removal authority is implied. |
| Admin | No blanket bypass of party boundaries, draft confidentiality, or separation of duties. |

The exact party/role mapping for attachment management must be confirmed against the approved project roles and contractual workflow before implementation. Do not invent a new role or equate comment permission with upload permission.

## 7. Preservation, replacement, and audit

- Never overwrite an existing Storage object key.
- Replacing a primary scan means uploading a new attachment, validating it, then atomically designating it primary; retain the former primary as a historical/superseded attachment.
- A revision-specific scan remains linked to that revision and must not silently move to a later revision.
- A document-level scan remains linked to the document, not automatically copied to every revision.
- Do not hard-delete metadata or objects as part of normal UI flows.
- Record uploader, timestamp, verified content hash, file size/type, document/revision link, primary designation changes, supersession/withdrawal actor and reason, and authorized access events where feasible.
- Retention duration and archive custodian remain unresolved under UNR-004; do not invent a statutory period.

## 8. Security and acceptance tests

Required tests before production approval:

1. A project member who cannot see a confidential draft cannot list, preview, or download its scan.
2. A Project Manager can view scans only where the parent document is visible, and cannot upload or alter them.
3. A user from another project cannot enumerate metadata or fetch an object by guessing IDs or paths.
4. A user with comment-only permission cannot upload a scan unless separately authorized.
5. A document/revision/project/company mismatch is rejected server-side.
6. Two concurrent primary designation attempts cannot leave two primary files.
7. An invalid extension, MIME mismatch, oversized file, too many files, or aggregate-limit breach is rejected.
8. Quarantined/rejected/incomplete uploads are never visible as available scans.
9. Expired signed URLs stop working; signed URLs are not stored in metadata or audit logs.
10. Replacing a primary scan preserves the prior file and its revision association.
11. Scan upload/open/primary changes do not alter document number, revision sequence, lifecycle, review state, response code, or KPI results.
12. A document deletion cannot silently cascade away retained scan evidence; deletion/retention behavior is explicitly guarded.
13. Attachment access and mutations are audited without logging file contents or signed URLs.
14. Filename rendering is safe against HTML/script injection and path traversal.

## 9. Implementation sequence and gates

**Phase A — read-only confirmation:** identify the live project/environment, inspect actual bucket configuration and deployed schema/policies, inventory every attachment caller, and verify current document visibility helpers. No writes.

**Phase B — owner review:** approve file constraints, authorized uploader/remover party mapping, retention/withdrawal rules, malware-scanning capability, and exact primary/revision semantics.

**Phase C — isolated implementation proposal:** prepare the exact schema/policy/server-function/UI diff on a dedicated branch. Use verified-user middleware and user-scoped authorization; do not default to service-role access.

**Phase D — isolated validation:** backup, restore into a separate project, review exact migration, run RLS/Storage negative tests and regression suite. Production DB work remains blocked until the required backup/restore, ownership, and explicit-approval gates are satisfied.

**Phase E — release:** only after explicit approval of the exact reviewed change. No merge or deployment is authorized by this proposal.

## 10. Explicit non-claims

No source code, UI, upload handler, server function, database schema, migration, generated type, Storage bucket, policy, stored record, or deployment has been changed by this proposal. No live database/Storage state was inspected. No tests were run. This document is a design proposal, not proof of implementation or security compliance.
