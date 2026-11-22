# 34 — Audit Trail Integrity, Visibility, and Retention Review

**Status:** Static migration review only  
**Branch:** `dev/review-fixes`  
**Scope:** `audit_log` table definition, grants, RLS read policy, `audit_row()` trigger function, and visible trigger coverage in `0000_core_schema.sql` and `0001_triggers_and_rpcs.sql`.  
**Not performed:** No live database/catalog query, runtime authorization test, retention job inspection outside tracked migrations, SQL execution, source change, or deployment.

## Executive summary

The tracked migrations describe the audit table as append-only and trigger-written, and authenticated users receive SELECT only. However, the visible policy grants project-wide audit visibility to project members, while audit records can contain full inserted/deleted row JSON and field-level before/after values for updates. This is especially important where other records are meant to remain party-confidential: the audit trail may expose their metadata or sensitive field values even when the underlying document row is later restricted.

The migrations also do not show an explicit retention/archival policy, an immutable audit administration boundary, or trigger coverage for every sensitive table. These are static observations only; deployed grants, additional triggers, external retention jobs, and actual runtime visibility remain unverified.

## Findings

### F34-01 — Project-wide audit read policy can bypass finer-grained record visibility
**Priority: High — confidentiality**

The visible `audit_log` SELECT policy permits any project member to read audit rows for that project. It does not apply document-party visibility, draft confidentiality, or the X1/P2 restrictions described elsewhere in the approved project baseline.

Audit rows can include document IDs, entity types, actor IDs, and JSON field changes. Therefore, even if a document's direct SELECT policy is later tightened, its audit history may remain visible to all project members unless the audit policy is independently scoped.

**Risk:** Audit history can become a side channel for discovering draft existence, document lifecycle, counterparties, attachment metadata, or other changes that the user is not authorized to see in the primary record.

### F34-02 — Audit payload captures broad row data and field values
**Priority: High — data minimization**

For INSERT and DELETE, `audit_row()` copies the complete row JSON into `changes`. For UPDATE, it stores changed field names and their before/after values. The only explicit field exclusion visible in this function is the comment body.

This broad capture can include personal data, storage object paths, import mappings, configuration values, or other sensitive attributes depending on the source table. The reviewed function does not show a per-table allowlist or general secret/token redaction policy.

**Risk:** The audit trail may retain and expose data beyond what is necessary to establish accountability.

### F34-03 — “Append-only” is descriptive, not fully demonstrated as an enforced invariant
**Priority: Medium — audit integrity**

Authenticated users receive SELECT on `audit_log`, and the reviewed migration does not grant them direct INSERT/UPDATE/DELETE. Trigger writes are performed by a SECURITY DEFINER function. This is a useful restrictive baseline.

However, the table definition itself contains no visible immutable-row trigger, no explicit privileged maintenance procedure, and no documented separation between ordinary service-role operations and controlled retention/administrative operations. The service role is granted ALL. Deployed role grants and policies must be inspected before concluding that records cannot be altered or deleted through privileged paths.

### F34-04 — Audit coverage is incomplete for sensitive operational entities
**Priority: Medium — accountability**

The visible trigger list includes companies, memberships, projects, response codes, workflows, numbering, documents, revisions, attachments, comments, and import batches. It does not show equivalent row-audit triggers for profiles, document_reviews, import_rows, OCR jobs, or sync jobs.

Some of these entities may be intentionally excluded or audited through another mechanism. The migrations do not document that alternative.

**Risk:** Important review decisions, staged import row changes, and identity/profile changes may not have a consistent application audit trail.

### F34-05 — No explicit retention, archival, or legal-hold policy is visible
**Priority: Medium — governance and operations**

The reviewed audit table has a creation timestamp and indexes for project/document timelines, but no retention metadata or policy is defined in these migrations. No scheduled purge/archive job is visible in the reviewed migration scope.

This does not prove no external retention process exists. It means the repository baseline does not yet establish retention duration, archival format, deletion authority, legal hold, or evidence export procedure.

## Recommended acceptance tests

1. A user outside the authorized document party attempts to read audit events for a draft; verify denial, including through direct table/API queries.
2. X1 attempts to read audit events for a non-P2 document; verify denial.
3. Authorized project manager can inspect the required audit history without gaining edit or review-decision authority.
4. Insert/update/delete events are checked for every audited table, with actor identity and correct project/company/document scope.
5. Review decisions, import row changes, and profile identity changes are either captured or explicitly covered by an alternative immutable event source.
6. Audit payloads are checked for secrets, tokens, private comment bodies, storage paths, personal data, and unnecessary before/after values.
7. Ordinary authenticated users and application service paths cannot update/delete audit rows.
8. Retention/archive/restore and legal-hold procedures are tested, including audit evidence export and integrity verification.

## Recommended remediation design (not approved or implemented)

- Make audit read authorization inherit the same record-level confidentiality rules as the underlying entity, with explicit handling for project managers and X1/P2.
- Replace unrestricted row JSON capture with table-specific allowlists and sensitive-field redaction; store only the minimum evidence needed.
- Establish a tightly controlled append-only write path and separately governed retention/archive process. Verify actual PostgreSQL grants, RLS, function ownership, and SECURITY DEFINER execution privileges.
- Add audit events or equivalent traceability for review decisions, import row state changes, and identity changes where required.
- Define retention periods, archival integrity, legal holds, export permissions, and deletion approvals.
- Keep audit access read-only for project managers; do not infer mutation or approval authority from audit visibility.

## Boundary and disposition

- This report reviews tracked migrations only.
- It does not establish live database behavior, deployed role privileges, external scheduled jobs, or a production confidentiality breach.
- No source, SQL, database, Storage, Auth settings, secrets, or deployment was changed.
- No tests were executed.
- Do not apply a migration or merge to `main` based on this report alone.
