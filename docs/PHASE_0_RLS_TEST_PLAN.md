# Phase 0 — Isolated RLS and Workflow Test Plan

**Status:** Test design only. Not executed.  
**Target:** A disposable Supabase test project with synthetic users and synthetic data.  
**Forbidden target:** Production or any database containing real project/customer records.

## 1. Test fixtures

Create only in the isolated test project:

- Two synthetic companies: Contractor Co and Consultant Co.
- One synthetic project with contractor, consultant, and owner parties.
- Three synthetic users (one per party), plus a Project Manager test user.
- One separate-company user with no membership in the test project.
- Documents in each relevant state: draft, submitted, under review, returned, approved, closed, and cancelled (only if the approved schema supports it).
- Revisions, reviews, comments, attachments, and audit records linked to those documents.
- Synthetic Storage objects following the proposed path convention.

Use test-only identities and files. Never copy production users, documents, attachments, or tokens.

## 1A. Discipline reference-data verification

The approved target catalogue contains exactly five options: Architectural, Civil & Structural (combined), Mechanical, Electrical, and Survey. The repository's current historical seed migration still contains separate Structural and Civil rows and no Survey row. In the isolated test project, verify the target catalogue only after a separately reviewed forward migration has been prepared and approved. Before mapping legacy records, inspect every foreign-key reference, numbering scheme/counter, import mapping, and historical document. Do not delete or merge live rows in Phase 0. This section is a verification requirement, not migration authorization.

## 2. Execution method

Run in a disposable project using authenticated test JWT claims and transaction-scoped role switching where supported. A typical SQL test harness may use `SET LOCAL ROLE authenticated` and transaction-local request claims, but the exact claim-setting syntax must match the Supabase test environment and must be verified before execution.

Do not run these tests in production. Do not assume a SQL editor session reproduces PostgREST JWT context without verifying the harness.

## 3. Visibility expectations

| Actor | Draft created by same party | Draft created by another party | Submitted / under review | Closed / archived |
|---|---:|---:|---:|---:|
| Originating party member | Read | No | Read | Read |
| Other project party | No | No | Read according to project workflow | Read according to project membership |
| Project Manager | Read | Read | Read | Read |
| Unrelated company user | No | No | No | No |
| Anonymous user | No | No | No | No |

PM read access is not edit/review/approval access. The test must separately verify that PM cannot create, update, submit, start review, respond, return, approve, or close unless a separate explicitly approved permission grants that operation.

## 4. Table/operation matrix

Test each table for SELECT, INSERT, UPDATE, and DELETE as applicable. Record expected result, actual result, SQLSTATE/error, actor, row identifier, and test run ID.

| Resource | SELECT | INSERT | UPDATE | DELETE |
|---|---|---|---|---|
| documents | visibility function | authorized originator only | authorized workflow/editor fields only | deny end-user deletion |
| document_revisions | parent document visibility | authorized revision creation | narrowly controlled mutable fields only | deny historical deletion |
| document_reviews | parent document visibility | transition RPC only | deny; append-only | deny |
| comments | parent document visibility + comment visibility | authorized commenter | narrowly controlled if supported | deny or audited moderation path |
| attachments | parent document visibility | authorized attachment workflow | deny | deny or audited server-only path |
| audit_log | parent document visibility for document-linked rows | audited server-side events only | deny | deny |
| document_kpi_matrix | RLS via security-invoker semantics | n/a | n/a | n/a |
| storage.objects | project + document + revision visibility | document-level edit permission and exact path binding | deny | deny for end users |

The table names above are logical names from the review plan; verify exact deployed names before writing executable tests.

## 5. Mandatory negative tests

- Contractor cannot read a consultant's draft document.
- Contractor cannot read that draft's revisions, reviews, comments, attachments, or audit records.
- Contractor cannot fetch the consultant draft's Storage objects even when the object path is known.
- Project Manager can read all project drafts but cannot edit, submit, review, respond, approve, or close them solely by virtue of PM status.
- An administrator cannot change their own party or role to impersonate another party.
- A project administrator cannot change another user's party unless an explicitly approved owner-controlled process permits it and creates an immutable audit event.
- A user from another company/project cannot read or mutate any test project resource.
- An anonymous user cannot execute any SECURITY DEFINER RPC intended only for authenticated users; test inherited `PUBLIC` grants, not just explicit `anon` grants.
- A reviewer cannot select response code E; only the originating party can invoke the approved cancel action.
- I closes the review cycle and remains accessible in the archive.
- MQR follows its separate workflow and does not require the default A/B/C/D/E/I response codes.
- Revisions and review history remain append-only.

## 6. Party integrity and workflow tests

- A user's `party` is immutable through ordinary self-service membership updates.
- `add_project_member` cannot silently reassign an existing user's party on conflict.
- No `admin` role bypasses the required workflow party.
- The actual submitting actor cannot approve the same document.
- The actor, party, action, response code, from-status, and to-status in each review record match the authorized transition.
- A cancel action is rejected after a final reviewer response and is accepted only from the originating party within the approved lifecycle window.

## 7. RPC privilege audit

Inventory every SECURITY DEFINER routine and inspect:
- function owner;
- SECURITY DEFINER flag;
- fixed `search_path`;
- EXECUTE privileges for `PUBLIC`, `anon`, `authenticated`, and service roles;
- whether the routine validates `auth.uid()`, project membership, party, role, and tenant boundaries;
- whether any privileged routine returns distinguishable user-existence errors.

Use `has_function_privilege` for effective privilege checks. Record each function's full signature to avoid overload ambiguity. Test anonymous invocation through the same API path used by clients.

## 8. Result recording template

For every test case record:

| Field | Value |
|---|---|
| Test ID | |
| Test project identifier (non-production) | |
| Actor / synthetic party / role | |
| Resource and operation | |
| Document lifecycle state | |
| Expected outcome | |
| Actual outcome | |
| SQLSTATE / API response | |
| Pass / fail | |
| Evidence reference | |

## 9. Exit criteria

- All mandatory negative tests pass.
- All expected positive visibility tests pass.
- PM read-only exception passes for every relevant resource.
- No anonymous execution of protected RPCs.
- No party mutation or administrator party bypass.
- Storage access is consistent with document visibility.
- Append-only review/audit history is preserved.
- Any failed test is explained and fixed in an isolated branch before a new review.
- The complete test report is presented for approval before any production migration is considered.

**No production changes are authorized by this test plan.**
