# 04 — Security Remediation Specification & Regression Test Matrix

**Review date:** 2026-11-10  
**Repository:** `mohannedabdo007-droid/sitedocs`  
**Target branch:** `dev/review-fixes`  
**Specification status:** Proposed requirements based on static source inspection; not implemented and not executed.  
**Scope:** Authorization boundaries, workflow transitions, document visibility, Storage, RPC access, and workflow/KPI regression requirements.

## 1. Evidence boundary and current source observations

This specification was prepared from the repository source at the observed `dev/review-fixes` head. It is not a live Supabase audit. No database connection, production data inspection, backup, restore, migration, test run, or deployment was performed.

Files inspected:
- `drizzle/migrations/0000_core_schema.sql`
- `drizzle/migrations/0001_triggers_and_rpcs.sql`
- `drizzle/migrations/0002_storage_policies.sql`
- `drizzle/migrations/0003_import_validation_and_kpi_buckets.sql`
- `AGENTS.md`
- `docs/03_IMPLEMENTATION_READINESS_REVIEW.md`

### 1.1 Confirmed source-level risks requiring remediation

1. **Workflow admin bypass:** `public.transition_document` permits an `admin` to bypass the current workflow-party check for `start_review`, `respond`, and `return`. The same RPC does not visibly enforce that the document creator is different from the approving actor. The client helper also treats `isAdmin` as an unconditional reviewer.
2. **Draft confidentiality:** the current `documents: members read` policy allows every project member to read every document row. The revisions and attachments read policies similarly allow every project member. This does not enforce the approved rule that drafts remain hidden from other parties while the Project Manager may read all drafts for oversight.
3. **Storage authorization is project-scoped, not document-scoped:** `0002_storage_policies.sql` derives a project ID from the first storage-path segment. Read access is granted to any project member and upload access to any role accepted by `can_comment`. The policy does not establish visibility of the specific parent document or distinguish draft visibility from submitted-document visibility.
4. **Membership mutation surface:** project membership insert/update/delete policies rely on `can_manage_project`. The update policy does not visibly prohibit an administrator from changing their own membership row or changing sensitive membership attributes through direct table access. Membership changes need a constrained server-side operation and explicit self-escalation tests.
5. **Direct RPC calls:** UI restrictions are not a security boundary. Security-definer RPCs must independently enforce actor, project, party, document state, separation of duties, and authorization. Function execute grants must be reviewed individually.
6. **KPI semantics:** the current KPI matrix groups by current response code; the source does not establish a dedicated B/C-only denominator that explicitly excludes I. A metric-specific aggregation and regression proof are required.
7. **RLS is not a substitute for lifecycle rules:** document editor policies permit document updates for `admin` and `controller`, while protected-field triggers and RPCs govern selected lifecycle fields. Every write path must be checked for unintended bypasses, including direct table updates and privileged RPCs.

These are static-source findings and risk statements. They are not claims that an exploit has been executed against a live database.

## 2. Security invariants — required end state

- **Server is authoritative:** hiding a button or disabling a route must never be the only authorization control.
- **Party separation:** an admin's administrative authority does not automatically make them the current workflow reviewer. A review response is permitted only when the actor is authorized for the current workflow step and party.
- **Separation of duties:** the document originator/submitter cannot approve or issue a reviewer decision on the same document. If an exceptional emergency override is ever required, it must be a separately specified, explicitly permissioned, audited process—not an implicit admin bypass.
- **Project Manager is a distinct oversight role:** PM may read all documents in the project, including drafts, but receives no edit, submit, review, respond, approve, return, or close permission merely by being PM.
- **Draft confidentiality:** before formal submission, a draft is visible only to its originator-side authorized users and the PM oversight role. Other parties cannot discover the draft through tables, views, RPCs, search, counts, revisions, comments, attachments, Storage URLs, or exports.
- **Tenant isolation:** X1 can access only records belonging to projects/company P2 for which X1 is an authorized member; membership in one tenant never grants access to another tenant.
- **Membership integrity:** users cannot add themselves, change their own party/role, or self-promote through direct table writes or RPC parameter manipulation. Only a separately authorized administrator operation may change membership, with immutable actor identity and audit history.
- **Document-level file authorization:** Storage read/write follows the parent document's visibility and the specific action permission, not merely project membership.
- **RPC parity:** direct authenticated RPC invocation must produce the same authorization result as the UI action.
- **Auditability:** every successful membership change and workflow transition records actor, document/project, prior and resulting state, action, timestamp, and decision metadata. Denied actions must not create a false successful review event; security logging may record denials without leaking protected document content.
- **Approved workflow semantics:** RFI remains Request for Inspection and separate from WIR. MQR remains Monthly Quality Report with an independent review flow and no default A/B/C/D/E/I response scheme. I closes the review cycle while retaining the document in the archive and is excluded from B/C KPI statistics. E remains an originating-party cancellation action, not a reviewer response.

## 3. Regression test matrix

All tests below are **required test cases**, not completed tests. Run them against an isolated restored database with deterministic fixtures and authenticated users for each actor. Assert both the client-visible result and the server/database result.

| ID | Actor and preconditions | Action / attack path | Expected result | Server-side enforcement | Audit expectation |
|---|---|---|---|---|---|
| SEC-01 | Project admin; document is at another party's workflow step | Call `transition_document` directly with `start_review`, `respond`, and `return` | Denied for each action unless admin is explicitly assigned to the current step under an approved rule | RPC checks current party/step and an explicit reviewer capability; admin status alone is insufficient | No successful review row; denial may be security-logged |
| SEC-02 | Admin is also document creator/originator; document is awaiting review | Directly call `transition_document(..., 'respond', approval_code, ...)` | Denied; originator cannot approve own document | RPC compares immutable `created_by`/originator identity and actor identity, in addition to party authorization | No approval/review success event |
| SEC-03 | PM assigned to project; draft belongs to another party | Read draft, then attempt update, submit, review, respond, approve, return, and close | Read allowed; every write/workflow action denied | Dedicated PM read permission; PM excluded from write and transition capabilities; enforce in RLS and RPC | Read may be logged per policy; no workflow event for denied writes |
| SEC-04 | Ordinary user and project admin; membership fixtures exist | Attempt direct insert/update/delete of `project_members`, including changing own `party`, `role`, `user_id`, or project scope | Unauthorized changes denied; authorized admin changes only through constrained operation | Revoke broad direct write path or tightly constrain RLS; validate target role/party and prevent self-escalation; derive tenant scope server-side | Successful changes record before/after membership values and actor |
| SEC-05 | User X1 belongs to company/project P2; P1 belongs to another company | Query documents, revisions, comments, attachments, reviews, imports, KPIs, and RPCs using P1 identifiers | No P1 data returned; mutations denied; no cross-tenant existence leak beyond a generic not-found/forbidden response | RLS and every RPC derive access from authenticated membership; no client-supplied company scope trusted | Denied cross-tenant actions logged without exposing P1 data |
| SEC-06 | Draft belongs to Party A; Party B is also a project member; PM is assigned | Party B queries draft by list, guessed UUID, direct table, relation, search, export, and RPC; PM performs same read | Party B cannot discover/read draft through any path; PM can read it | Shared document-visibility predicate applied consistently to documents, revisions, comments, reviews, attachments, search/RPCs; PM exception read-only | No successful disclosure event to Party B; PM read audit according to policy |
| SEC-07 | Draft and submitted documents each have files; actors from originator, reviewer, PM, and unrelated tenant | Read/list/download/upload/replace/delete file using Storage API and guessed paths | Access mirrors parent-document visibility and per-action permission; hidden draft files remain hidden from other parties; unrelated tenant denied | Storage policies resolve the attachment/document relationship and call the same document-level authorization rules; validate object path and attachment row | File upload/delete metadata tied to actor and document; denied attempts do not reveal filenames |
| SEC-08 | Authenticated user lacks action permission; direct RPC execute permission exists or is attempted | Invoke workflow, membership, import, numbering, and other privileged RPCs directly, bypassing UI | Same denial as UI; unauthorized roles cannot call sensitive functions | Function body performs authorization; execute grants limited to intended roles; security-definer functions use fixed safe search_path and avoid trusting caller-supplied identity/scope | No state mutation or success audit on denied call |
| SEC-09 | KPI fixture includes response codes B, C, I and other codes; include archived/closed cases | Calculate B/C response metrics and dashboard aggregates | I is excluded from B/C numerator and denominator as defined by the approved KPI contract; I still closes the review cycle and remains archived | SQL aggregation explicitly filters the relevant response-code outcomes; UI uses the authoritative metric | KPI result reproducible from fixture; no mutation expected |
| SEC-10 | Project has RFI, WIR, and MQR document types/workflow configurations | Create/submit/review each type and inspect labels, response-code configuration, and transition behavior | RFI remains Request for Inspection and separate from WIR; MQR uses independent workflow and no default A/B/C/D/E/I codes | Document-type configuration and transition RPC enforce per-type workflow rules | Audit records correct type and workflow actions |
| SEC-11 | Originator-side user has a draft; another party has submitted-document access | Query comments, revision metadata, counts, notifications, and attachment metadata for the draft | No side channel reveals the draft or its contents to the other party | Apply the same visibility predicate to related tables, views, search, counts, and notifications | No unauthorized disclosure |
| SEC-12 | User has viewer role or no project membership | Attempt direct insert/update of documents, revisions, comments, attachments, and import rows | Denied according to role matrix; no forged author, party, project, or company fields accepted | RLS WITH CHECK plus triggers/RPC validation; author and tenant fields derived server-side | Successful permitted writes capture authenticated actor; denied writes create no business event |

## 4. Required role/visibility truth table

This is the target behavior to encode in RLS, RPC authorization helpers, UI action guards, and tests. “Originator-side” means an authorized member of the document's originating party, not every project member.

| Capability | Originator-side editor/controller | Current reviewer party | Project Manager | Project admin not assigned to current review party | Other project party | Unrelated tenant |
|---|---:|---:|---:|---:|---:|---:|
| Read own-party draft | Allow | Deny | Allow | Deny unless also originator-side | Deny | Deny |
| Read submitted document visible to workflow parties | Allow | Allow | Allow | According to explicit project visibility, not admin bypass | According to workflow visibility | Deny |
| Edit draft | Allow if editor | Deny | Deny | Only if separately authorized originator-side editor | Deny | Deny |
| Submit | Allow if originating party and permitted role | Deny | Deny | No automatic bypass | Deny | Deny |
| Start review / respond | Deny unless current step is theirs | Allow if assigned and permitted reviewer | Deny | Deny | Deny | Deny |
| Approve own submitted document | Deny | Deny if same originator | Deny | Deny | Deny | Deny |
| Close | Only explicit close capability after eligible state | Only if workflow explicitly assigns it | Deny | No automatic bypass | Deny | Deny |
| Read all project drafts | No | No | Allow, read-only | No | No | No |

The exact submitted-document visibility rule must follow the approved workflow and contract-party model. It must not be broadened merely because a user has an administrative role.

## 5. Implementation requirements for the remediation

1. Define one canonical server-side authorization model for document visibility and workflow actions. Avoid separate, drifting interpretations in RLS, Storage, RPCs, and TypeScript helpers.
2. Remove the implicit admin-as-reviewer bypass. If project admins may perform any workflow action, define that as a separate explicit capability with party and separation-of-duties checks.
3. Enforce submitter/approver separation using trusted persisted identity and immutable originator information. Do not accept actor IDs from the client.
4. Introduce the PM oversight permission as read-only and apply it narrowly to the project documents and related data, including drafts.
5. Change draft visibility consistently across documents, revisions, comments, reviews, attachment metadata, Storage objects, search, counts, and exports.
6. Restrict membership mutations to a controlled server-side function or an equivalent narrow policy. Prevent self-promotion, self-party reassignment, tenant reassignment, and unauthorized role escalation.
7. Audit every exposed `SECURITY DEFINER` function and every function grant. Use fixed `search_path`, fully qualified object names, explicit authorization checks, and least-privilege execute grants.
8. Align Storage object path design with the attachment/document relation. Do not rely solely on a project UUID in the first path segment.
9. Add integration tests that exercise direct PostgREST table access, direct RPC calls, Storage API operations, and UI actions using multiple authenticated identities.
10. Implement B/C KPI filters explicitly and preserve I closure/archive semantics. Verify RFI/WIR and MQR behavior with document-type-specific fixtures.

## 6. Test execution and acceptance gates

Before accepting a fix:
- Run the test matrix against an isolated database restored from a verified backup.
- Demonstrate that each negative test fails before the fix and is denied after the fix.
- Demonstrate positive controls (authorized originator submission, assigned reviewer response, PM read-only access, and permitted file access) so the remediation does not over-block valid work.
- Run database policy/RPC tests, application unit/integration tests, lint, and production build; record exact command, environment, and result.
- Inspect effective grants and RLS policies from the restored database, not only migration text.
- Review audit rows for successful and denied actions.
- Record any accepted exception with its owner, reason, scope, expiry/review date, and test coverage.

### Stop conditions

Do not apply a database migration or production change until all of the following are true:
1. Correct Project Doc Control Supabase project identity is verified.
2. Independent backup is completed and a restore test succeeds in a separate environment.
3. The exact forward migration and recovery plan are reviewed.
4. Regression tests are prepared and the target environment is isolated.
5. The user explicitly approves the exact database change.

Per `AGENTS.md`, do not manually edit `drizzle/` or Lovable-managed migration files. This document is repository documentation only. It does not authorize application-code changes, schema changes, data updates, deployment, or merge to `main`.

## 7. Current status

| Work item | Status |
|---|---|
| Static inspection of migration source | Completed for listed files |
| Security risks documented | Completed at source-review level |
| Target authorization specification | Proposed in this document |
| Regression matrix | Specified; not executed |
| Live RLS/grant/Storage audit | Not performed |
| Backup and isolated restore | Not evidenced |
| Application/RPC remediation | Not implemented |
| Test suite / lint / build | Not run |
| Database migration | Not created or applied |
| Production deployment / merge to `main` | Not performed |
