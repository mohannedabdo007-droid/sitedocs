# 51 — Draft Confidentiality: Database RLS and Audit-Log Disclosure Review

**Repository:** `mohannedabdo007-droid/sitedocs`  
**Branch reviewed:** `dev/review-fixes`  
**Review type:** Static review of committed SQL migrations  
**Priority:** High — access-control policy mismatch requiring owner review  
**Status:** Findings documented only; no source, migration, database, or permission changes made.

## Executive summary

The approved product rule is that drafts must remain hidden from other project parties until formal submission, while the Project Manager may read drafts for supervision without receiving editing or review/approval authority.

The checked migration snapshot does not visibly enforce that confidentiality boundary at the database row level:

1. The `documents` SELECT policy allows every project member to read every document row, with no status-based restriction for `draft`.
2. The shared `audit_log` SELECT policy also allows every project member to read project-scoped audit entries.
3. The `audit_row()` trigger stores the full row JSON for document INSERT events in `changes`; a newly created draft can therefore be exposed through audit history even if a future UI hides it from ordinary document lists.

These are concrete policy/code-path observations in the checked migrations. Whether the deployed database has applied these exact migrations, and whether another server-side layer overrides access, has not been verified.

## Evidence

### E51-01 — Document SELECT policy has no draft visibility condition

In `drizzle/migrations/0000_core_schema.sql`, the policy is:

```sql
create policy "documents: members read" on public.documents
for select to authenticated
using (public.is_project_member(project_id));
```

The helper `is_project_member(_project)` returns whether `project_role_of(_project)` is non-null. The policy does not test `status`, `created_by`, party, or a dedicated supervisory permission.

The same migration defines project membership roles including `admin`, `controller`, `reviewer`, and `viewer`. Therefore, based on this policy alone, all those project members pass the SELECT predicate for draft rows.

### E51-02 — Audit-log SELECT policy is also project-member wide

The migration grants `SELECT` on `public.audit_log` to `authenticated` and defines:

```sql
create policy "audit: project members read" on public.audit_log
for select to authenticated
using (
  (project_id is not null and public.is_project_member(project_id))
  or
  (project_id is null and company_id is not null
   and public.is_company_admin(company_id))
);
```

For project-scoped entries, there is no filter on entity type, document status, creator, actor party, or whether the underlying document has been formally submitted.

### E51-03 — Document INSERT audit event contains the full row

In `drizzle/migrations/0001_triggers_and_rpcs.sql`, `audit_row()` sets `n := to_jsonb(new)`; for INSERT it assigns `diff := n`, then inserts that JSON into `audit_log.changes`.

The `documents` table has an `AFTER INSERT` audit trigger. The document creation trigger sets non-imported documents to `status = 'draft'`. Consequently, the initial audit event for a draft can include its title, description, metadata, creator, and other row fields, subject to the actual inserted row.

The audit function explicitly removes comment bodies, but the inspected implementation does not apply an equivalent minimization or draft-specific redaction to document rows.

## Impact and scope

- A project member who is not the draft creator or authorized Project Manager may be able to read draft document rows directly through the authenticated database API under the inspected RLS policy.
- The audit log provides a second read path for draft contents and other project-scoped entity changes.
- Hiding draft rows in the frontend alone would not enforce confidentiality against direct authenticated API queries.
- This finding is not evidence of cross-project access: the inspected project-scoped predicates still require membership in the same project.
- Company-level audit rows with no project ID remain restricted by the separate company-admin predicate in the inspected policy.

## Required design alignment

Before implementation, the owner should approve a database-enforced visibility model consistent with the existing decisions:

1. Draft creator can read their own draft.
2. Project Manager may read all drafts for supervision, but this read permission does not grant edit, submit, review, or approval authority.
3. Other project parties cannot read a draft until formal submission.
4. Audit history must apply the same underlying document visibility rule; it must not reveal hidden draft content or sensitive internal changes.
5. Audit payloads should use an explicit allowlist/minimized change representation rather than storing complete document rows by default.
6. Preserve project/company tenant isolation and ensure any privileged supervisory access is explicit, testable, and read-only.

Do not solve this by granting broad access to all project members or by treating project admin as an automatic substitute for the specifically approved Project Manager role.

## Recommended verification tests

- As a draft creator, select the draft and its audit events: expected allowed.
- As an ordinary member of another project party, query the draft by ID and query audit entries by project/document ID: expected no draft content before submission.
- As the authorized Project Manager, read the draft and its permitted audit metadata: expected allowed, while UPDATE and workflow-transition attempts remain denied unless separately authorized.
- After formal submission, verify the intended parties can read the document and permitted history.
- Attempt direct PostgREST/API queries, not only frontend navigation.
- Verify company-level audit rows remain company-admin-only and project-scoped events cannot cross project boundaries.

## Limitations

- Static review only; no live Supabase database or deployed RLS policies were queried.
- No authenticated-user matrix, API request, SQL test, or runtime test was executed.
- Frontend filtering and any external authorization layer were not established by this review.
- No SQL, migration, source code, generated types, database state, or permissions were changed.
- This report is a finding and proposed acceptance criteria, not authorization to implement a migration.

## Decision required

Treat draft confidentiality as a high-priority access-control gap in the checked migration snapshot. Obtain explicit approval of the intended role matrix and the exact proposed migration before changing RLS or audit payload behavior. Any database change remains blocked until an independent backup and successful restore rehearsal are evidenced and the specific migration is approved.
