# Claude Independent Review — PROJECT DOC CONTROL

**Date:** 2026-11-10  
**Working branch:** `dev/review-fixes`  
**Status:** Recommendations and static-review evidence only. This report does not authorize implementation.

## Evidence boundaries

The review is based on static inspection of the backup's SQL migrations 0000–0003, `src/`, `package.json`, and `AGENTS.md`. It did not access a live database, run tests/builds, or run `bun audit`. Findings below distinguish code-confirmed issues from live-database verification requirements.

## 1. Security findings

### 1.1 Project-party mutation and workflow bypass — confirmed from code

- The `project_members` UPDATE policy allows project managers to update rows, including `party` and `role`, without a self-row restriction.
- `add_project_member` updates `party`, `role`, and `organization` on conflict, including for an existing member.
- `transition_document` exempts `admin` from party checks.
- Combined, these behaviors may allow a user to change party context and bypass separation between contractor, consultant, and owner.

Recommended controls:
1. Prevent party changes after membership creation, or tightly restrict them to an authorized company owner with an audit record.
2. Prevent an administrator from changing their own membership party/role.
3. Remove administrator bypasses from workflow party checks.
4. Enforce submitter-versus-approver separation using the actual submitting actor, not merely the current role/party label.

### 1.2 SECURITY DEFINER RPC execution grants — requires live verification

Revoking EXECUTE from `anon` alone may not remove EXECUTE inherited from `PUBLIC`. Verify every SECURITY DEFINER routine on a disposable test project/database, including:
`has_function_privilege('anon', 'public.function_name(argument_types)', 'execute')`.

If exposure is confirmed, revoke from `PUBLIC`, then grant only to intended roles (normally `authenticated`), and set safe default privileges for future functions. Do not run grant changes against production without separate approval.

### 1.3 Storage draft visibility and upload scope — confirmed from code

- Current object-read policy checks project membership using the first path segment; it does not check whether the linked document is visible to the requesting party.
- Upload authorization uses `can_comment` at project level rather than document-level edit permission.
- Current policy does not bind the object path to a specific document/revision.
- Bucket-level size/MIME configuration was not visible in the inspected repository snapshot.

Recommended path:
`{project_id}/{document_id}/{revision}/{uuid}-{filename}`

Read policy should verify project membership and centralized document visibility. Upload policy should verify document-level edit permission and exact project/document/revision linkage. Enforce size and allowed MIME types at bucket level. Keep end-user UPDATE/DELETE disallowed; any server-side deletion must be explicitly authorized, audited, and narrowly scoped.

### 1.4 User enumeration — confirmed from code

Membership RPCs look up profile email and return `USER_NOT_FOUND`, which can reveal account existence. Use a non-enumerating response pattern and avoid exposing whether an email is registered.

### 1.5 Service-role client guardrail — confirmed from code structure

A server-side Supabase service-role client exists. No current usage was identified in the reviewed paths, but it bypasses RLS. Tenant-facing document routes should use authenticated user context and must not import the service-role client. Add an enforceable lint/import boundary before building those routes.

## 2. Centralized RLS and Storage visibility

Use one carefully reviewed `can_see_document(document_id)` decision rather than duplicating draft logic across policies.

Apply it to:
- `documents` SELECT;
- revisions, reviews, comments, and attachments through their parent document;
- audit records linked to a document;
- Storage objects linked through the document ID in the object path.

Visibility must preserve the approved Project Manager exception: PM may read all project documents, including drafts, but read access does not grant edit, submit, review, or approval rights. Originating parties may see their own drafts; other parties must not see drafts before formal submission.

Check that the function cannot trigger RLS recursion, uses a safe fixed `search_path` if SECURITY DEFINER is required, and has narrowly scoped EXECUTE grants. Confirm the KPI view/function remains security-invoker and follows RLS. If Realtime is enabled, test channel authorization separately.

## 3. Workflow and data-integrity recommendations

Use an expand → migrate → contract approach, with live data checks before any migration.

1. Add/verify project-scoped uniqueness for response codes and introduce composite foreign keys as `NOT VALID`, inspect orphan rows, then validate.
2. E — `Cancelled by Contractor`: treat as a `cancel` action by the originating party, not a reviewer response. A new enum value is operationally irreversible; rollback means leaving it unused, not removing it.
3. I — `For Information Only`: use `outcome = 'close'` so the review cycle closes and the record remains archived. Exclude I from B/C performance counts.
4. MQR — `Monthly Quality Report` only; use an independent workflow and no default response-code scheme.
5. Permit a response code on `return` where C/D is required and persist it in the review history.
6. Recompute import validation on the server in `commit_import_rows`; do not trust client-supplied validation decisions. Normalize document numbers and distinguish revision index from original revision label.
7. Preserve append-only review history; do not delete review rows or rewrite historical decisions.

Terminology remains: RFI = Request for Inspection, separate from WIR. Structural and Civil remain separate disciplines.

## 4. Dependency-management recommendations

- Treat Lovable config, Vite, Rolldown, Nitro, and TanStack as a coupled dependency graph; do not update individual members without compatibility review.
- Pin `drizzle-kit` and `drizzle-orm` to reviewed exact versions before any schema generation. Do not generate migrations until schema and snapshots are reconciled.
- Keep the official SheetJS tarball source currently in use; assess version/security separately and process untrusted spreadsheets with size limits and isolation.
- Any package update requires a separate PR, frozen-lockfile install, test suite, and production build. Dependency work follows database/security baseline work and is independently approved.

## 5. Recommended order

1. Independent backup and a proven restore test.
2. Read-only baseline of schema, Drizzle metadata/snapshots, lockfile, and branch commit.
3. RLS tests on a disposable test project/database that first demonstrate current failures.
4. Close party mutation/workflow bypass and verify RPC grants.
5. Reference data, response-code integrity, and E/I workflow semantics.
6. Draft visibility across database tables, Storage, audit, and Realtime, with regression tests.
7. Numbering, import, and KPI.
8. UI work.
9. Dependency updates in separate PRs.

## 6. Mandatory safety gates

- No production database changes or migrations without written approval for the exact reviewed change.
- No database changes until independent backup and restore have been verified.
- No tests against the live production database; use a disposable isolated test project.
- No source, dependency, deployment, or schema changes are authorized by this report.
- Do not merge to `main` without explicit approval.
- Report static findings separately from live-verified findings; do not claim tests or restores that were not run.
