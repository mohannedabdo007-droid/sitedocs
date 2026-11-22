# 05 — RPC & Workflow Source Audit

**Review date:** 2026-11-10  
**Target branch:** `dev/review-fixes`  
**Source:** static inspection of `drizzle/migrations/0001_triggers_and_rpcs.sql`, `0000_core_schema.sql`, and `0002_storage_policies.sql`.  
**Status:** findings and remediation requirements only. No database was queried and no tests were executed.

## 1. Scope and limitations

This audit inspects the checked-in migration source. It does not prove which migrations are installed in any Supabase environment, the effective grants after deployment, or the live behavior of PostgreSQL policies. No live SQL, exploit attempt, test, backup, restore, migration, or deployment was performed.

## 2. Findings

### RPC-01 — Admin bypasses current workflow-party authorization

**Source:** `public.transition_document`, branches `start_review` and `respond/return`.

The function accepts the action when `r = 'admin'` without requiring `p = cur`. This makes project-admin status an implicit reviewer override, even when the admin is not the party assigned to the current workflow step.

**Risk:** cross-party review, response, return, and approval; undermines contractual party separation.

**Required change:** remove the implicit admin exception. Require explicit current-step authorization for all reviewer actions. If an exceptional override is ever required, define a separate capability, require separation-of-duties checks, capture a mandatory reason, and audit it distinctly.

**Tests:** SEC-01 and SEC-08 in `04_SECURITY_REMEDIATION_SPEC.md`.

### RPC-02 — Submit action allows project admin to bypass originator-party restriction

**Source:** `public.transition_document`, `_action = 'submit'`.

The function checks that the actor role is admin or controller, but the originator-party comparison is conditional on `r <> 'admin'`. An admin can therefore submit a document even when their party differs from the document's configured originator party.

**Risk:** a project administrator can act for a contractual party without being a member of that party.

**Required change:** require originator-party membership for every submitter, including admins, unless a separately authorized and audited submission-on-behalf capability is explicitly approved.

**Tests:** add a positive/negative pair for an admin outside the originator party attempting submit.

### RPC-03 — Submitter/approver separation is not enforced in transition RPC

**Source:** `public.transition_document`.

The inspected function does not compare `auth.uid()` with the persisted document creator/originator identity before accepting a reviewer response. The review insert records the actor but this is not a substitute for an authorization check.

**Risk:** the document creator may participate in approving their own document if they also hold a role/party accepted by the current function.

**Required change:** enforce separation of duties on the server using trusted persisted identity. Define whether the protected identity is creator, formal submitter, originating organization, or a combination. Do not rely on client-provided actor IDs.

**Tests:** SEC-02 plus a case where the creator's role changes after submission.

### RPC-04 — Default response-code seed conflicts with approved business rules

**Source:** `public.create_project`.

The default project response codes currently include:
- `E`: “Reviewed – no further action” with outcome `proceed`.
- `I`: “For information only” with outcome `proceed`.

The approved project rules instead define E as cancellation by the contractor/originating party (not a reviewer decision), and I as For Information Only that closes the review cycle while retaining the document in the archive.

**Risk:** E may be used as a reviewer response, while I may progress to another workflow step or result in Approved rather than close, depending on the workflow position. This conflicts with the accepted process.

**Required change:** do not simply relabel E. Remove E from reviewer response choices and model cancellation as a separately authorized originator-side action with a reason and audit event. Map I to an explicit close outcome and verify archival retention. Confirm behavior for both single-step and multi-step workflows.

**Tests:** add E cancellation authorization tests and I closure/archive tests; update SEC-09 and SEC-10.

### RPC-05 — MQR does not receive a separate default response-code policy

**Source:** `public.create_project`.

The function seeds A/B/C/D/E/I as project-wide default response codes without an evident MQR-specific exclusion or separate workflow configuration in this function.

**Risk:** MQR may inherit response-code behavior that was explicitly rejected for Monthly Quality Reports.

**Required change:** configure MQR independently by document type. Do not attach A/B/C/D/E/I by default to MQR. Ensure MQR can complete its own review lifecycle without relying on those response codes.

**Tests:** MQR submission, reviewer actions, completion, and KPI exclusion/aggregation tests.

### RPC-06 — Project-member management requires stronger self-escalation safeguards

**Source:** `public.add_project_member` and `project_members` RLS policies in `0000_core_schema.sql`.

The RPC checks `can_manage_project`, looks up a user by email, and upserts the supplied party and role. The source does not visibly prohibit an administrator from targeting their own email or escalating/reassigning their own membership. The direct project-members update policy also relies on project-admin status without visible immutable self-change protections.

**Risk:** a project administrator may change their own party/role through the member-management route; broad direct table access may create alternate mutation paths.

**Required change:** prevent self-targeting for privileged role/party changes, restrict assignable roles, validate company/project scope, and route membership changes through a single controlled operation. Revoke or narrow direct table writes as appropriate. Define a separate owner-transfer process if needed.

**Tests:** self role escalation, self party reassignment, cross-company target, unauthorized role assignment, and authorized admin changing another user.

### RPC-07 — Storage policies authorize by project membership, not parent-document visibility

**Source:** `0002_storage_policies.sql`.

The object path parser extracts a project UUID from the first path segment. Read access is granted to project members; upload access is granted to users accepted by `can_comment`. The policy does not resolve the parent document or attachment metadata and does not apply draft visibility rules.

**Risk:** another project party may read a draft file if they can guess or obtain its storage path; PM read-only semantics are not represented at file level; upload permission may be broader than document-specific action permission.

**Required change:** bind each object to an attachment/document record and authorize using the canonical document visibility and action predicates. Treat PM as read-only. Verify download, list, upload, replace, move, and delete operations separately.

**Tests:** SEC-06, SEC-07, and SEC-11.

### RPC-08 — Function execute grants need an explicit effective-privilege audit

**Source:** end-of-file revoke statements in `0001_triggers_and_rpcs.sql`.

The migration contains explicit revokes from `anon` for selected functions, but this source excerpt alone does not establish the effective grants for `PUBLIC`, `authenticated`, or service roles, nor whether project-level default privileges modify them.

**Risk:** an exposed function may have broader execute availability than intended. Authorization checks inside a function remain necessary even when execute is granted only to authenticated users.

**Required change:** inventory every exposed function, inspect effective grants in the restored database, explicitly revoke from `PUBLIC` where appropriate, and grant execute only to intended roles. Review SECURITY DEFINER functions for fixed safe search_path, qualified object references, and authorization checks.

**Tests:** direct RPC invocation as anon, authenticated unauthorized user, authorized user, and service role where relevant.

### RPC-09 — Import path uses privileged transaction-local flags and needs adversarial testing

**Source:** `public.commit_import_rows`, `documents_before_insert`, `documents_guard_update`, and revision triggers.

The import RPC sets custom transaction-local flags `app.doc_import` and `app.doc_transition` to bypass normal document lifecycle guards for the import transaction. This is an intentional privileged import path, but its security depends on who can execute the function and whether any untrusted entry point can set or reuse those flags.

**Risk:** if an untrusted caller can reach a code path that sets these flags or influence privileged import data, lifecycle constraints may be bypassed.

**Required change:** verify effective execute grants and PostgREST exposure; validate imported statuses, response codes, revision state, originator identity, and document-type workflow semantics; ensure the flags are set only within the controlled function transaction and always reset on exceptions (transaction rollback should also be tested). Consider a narrower import-specific guard rather than a generic lifecycle bypass.

**Tests:** unauthorized import call, malicious import payload, invalid lifecycle values, cross-project batch/document references, exception rollback, and post-import guard behavior.

### RPC-10 — Admin role derivation needs a deliberate policy decision

**Source:** `public.project_role_of`.

Company owners/admins without a project_members row are implicitly treated as project role `admin`. This can be appropriate for project administration, but it currently feeds into document edit/comment capabilities and the transition bypass noted above.

**Risk:** tenant-level administration implicitly expands into project-level operational and workflow authority.

**Required change:** separate project administration, document editing, review authority, and PM oversight into distinct capabilities. Preserve any approved company-admin project management needs without granting reviewer-party authority or automatic document lifecycle privileges.

**Tests:** company admin with no project membership; company admin with explicit non-admin project membership; company admin attempting cross-party review; company admin read access to drafts versus PM.

## 3. Priority order

| Priority | Findings | Reason |
|---|---|---|
| P0 — workflow integrity | RPC-01, RPC-02, RPC-03, RPC-04, RPC-05 | Incorrect actor authority and business workflow semantics |
| P0 — confidentiality | RPC-07 | Draft attachments may not follow document visibility |
| P1 — privilege management | RPC-06, RPC-08, RPC-10 | Membership escalation and overbroad role/function authority |
| P1 — import boundary | RPC-09 | Privileged bypass path requires strict adversarial validation |

## 4. Required acceptance tests before implementation is accepted

- Admin outside the current workflow party cannot start review, respond, return, or approve.
- Admin outside the originator party cannot submit on behalf of that party.
- Creator/submitter cannot approve the same document, including when they are also an admin.
- E is not selectable as a reviewer response and cancellation is restricted to the originating side.
- I closes the cycle and preserves the archived record; it does not advance to another party.
- MQR uses an independent workflow and has no default A/B/C/D/E/I response-code dependency.
- PM can read drafts and their files but cannot write, submit, review, approve, or close.
- Other parties cannot read draft document data or its attachment through Storage API, guessed object paths, or metadata.
- A user cannot self-promote or change their own party through RPC or direct table access.
- Effective function grants are verified from the isolated restored database.
- Import-specific bypass behavior is tested under authorized and malicious payloads.

## 5. Change control

This file is documentation only. It does not authorize editing migration files, changing application code, applying SQL, or deploying. Follow `AGENTS.md`: Lovable-managed migrations must not be manually edited. Any remediation must be implemented through the approved workflow after correct Supabase project identity, independent backup, successful isolated restore, exact migration review, and explicit user approval.

## 6. Status

- Source files inspected: yes.
- Findings recorded: yes.
- Live database inspection: no.
- Effective grants verified: no.
- Tests executed: no.
- Fixes implemented: no.
- Migration created/applied: no.
