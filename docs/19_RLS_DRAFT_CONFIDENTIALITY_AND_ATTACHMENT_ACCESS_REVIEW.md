# 19 — RLS, Draft Confidentiality, and Attachment Access Review

**Review type:** Static source review only  
**Source branch:** `dev/review-fixes`  
**Reviewed files:** `drizzle/migrations/0000_core_schema.sql`, `0001_triggers_and_rpcs.sql`, `0002_storage_policies.sql`, `src/lib/domain.ts`  
**Runtime status:** No live database/catalog inspection, authenticated-session testing, storage test, or deployment verification was performed.

## Executive summary

The migration enables RLS on the application tables and defines table-specific policies. However, the visible policy predicates do not implement the approved draft-confidentiality rule: document, revision, review-history, and attachment reads are granted to every project member without a lifecycle/party visibility condition. The Storage object read policy uses the same broad project-membership predicate. This is a **high-priority source-level policy mismatch** against the approved requirement that drafts remain invisible to other parties before formal submission.

The Project Manager read-only role is also not represented in the current project-role enum. The current role helper falls back to project `admin` for company owners/admins who are not explicit project members. That behavior is incompatible with a distinct PM role and risks granting broader powers than read-only access.

These are findings in the checked-in migration source, not proof that the live database has identical policies. Verify the deployed catalog before planning any migration.

## 1. Approved access rules used as review criteria

- Drafts are visible only to their originating party and authorized project oversight.
- Project Manager can read all project documents, including drafts, but cannot create/edit, submit, review, respond, return, approve, or close.
- A company/project administrator is not automatically a Project Manager.
- X1 sees only P2 documents for their company.
- File access must follow the same document/revision visibility boundary as the parent record.
- No DB policy or role migration before an independent backup, successful restore rehearsal, and explicit approval of the exact migration.

## 2. Table policy coverage observed in source

| Data area | Current SELECT predicate | Static concern |
|---|---|---|
| `documents` | `is_project_member(project_id)` | All project members can read drafts; no party/lifecycle filter |
| `document_revisions` | `is_project_member(project_id)` | Same broad access, including revisions belonging to draft documents |
| `document_reviews` | `is_project_member(project_id)` | Review history has no draft/party visibility filter |
| `attachments` | `is_project_member(project_id)` | Attachment metadata is readable by every project member |
| `storage.objects` | `is_project_member(storage_project_id(name))` | Object read access is project-wide, not parent-document-aware |
| `comments` | project member AND (external OR same party) | Party-scoped internal comments, but not tied to draft visibility |
| `audit_log` | project member for project rows | Project-wide audit visibility; inspect whether draft metadata is acceptable |
| `import_batches`, `import_rows` | `can_edit_documents(project_id)` | Restricted to editors in the visible policy |
| `ocr_jobs` | `can_edit_documents(project_id)` | Read restricted to editors in the visible policy |
| `project_members` | project member read; admin writes | Membership roster visible to project members |
| Reference/config tables | project member read; admin writes | No draft confidentiality issue apparent from these predicates alone |

The schema grants authenticated users SELECT on the core records and relies on RLS for row filtering. The review therefore treats the policy predicates as security-critical.

## 3. Priority findings

### RLS-01 — Draft records are not party-confidential
**Priority:** High  
**Evidence:** Policies named `documents: members read`, `revisions: members read`, and `reviews: members read` use only `is_project_member(project_id)`.  
**Impact:** A member from another party can satisfy the visible predicate for a draft document and its revision/history. This conflicts with the approved draft-visibility rule.  
**Required design:** Define one canonical server-side visibility predicate based on project role, document originator/current lifecycle, and approved oversight role. Apply consistently to documents, revisions, reviews, comments, attachments, and any RPC/view that returns document data. PM read access must not imply write/workflow authority.  
**Tests:** Cross-party SELECT attempts for draft, returned, submitted, under-review, approved, and closed documents; PM read-all/draft tests; verify no indirect leaks through counts, search, KPI, history, and RPC results.

### RLS-02 — Storage reads are project-wide, not document-aware
**Priority:** High  
**Evidence:** `0002_storage_policies.sql` permits SELECT on bucket `document-files` when the first object-name segment resolves to a project UUID and `is_project_member(project_id)` is true.  
**Impact:** Any project member who knows or obtains an object path may satisfy the project-level read predicate even when the associated document is a draft hidden from their party. The policy does not join the object to an attachment/document row.  
**Required design:** Resolve the object to a registered attachment and parent document, then apply the same document visibility predicate. Define behavior for orphaned objects and malformed paths. Signed URL issuance and download flows must not bypass the same rule.  
**Tests:** Cross-party direct object read, signed URL generation/download, guessed path, orphan object, mismatched project path, and draft-to-submitted transition tests.

### RLS-03 — Attachment upload is not visibly bound to an authorized document
**Priority:** High  
**Evidence:** Storage INSERT checks bucket plus `can_comment(storage_project_id(name))`; attachment-row INSERT checks `can_comment(project_id)`. Neither visible policy verifies that the path/document/revision belongs to the same authorized parent record or that the document is in a writable lifecycle for the uploader.  
**Impact:** The policies are broader than a document-scoped attachment rule. The trigger derives attachment project/company from the document and checks revision/document consistency, which is useful, but it does not by itself prove that the Storage object and attachment row are atomically or uniquely bound.  
**Required design:** Enforce uploader permission against the exact parent document/revision and lifecycle; ensure object path, attachment row, project, document, and revision agree; define cleanup/rollback for failed metadata insertion.  
**Tests:** Upload to another party's draft, upload to submitted/closed documents, forged project prefix, mismatched revision, orphan object, duplicate path, and unauthorized attachment metadata insert.

### RLS-04 — Project Manager role is absent; company-admin fallback grants project admin
**Priority:** High  
**Evidence:** `project_role` enum contains only `admin`, `controller`, `reviewer`, `viewer`. `project_role_of()` returns `admin` when the user is a company owner/admin and has no explicit `project_members` row. `can_manage_project()` and `can_edit_documents()` derive privileges from that result.  
**Impact:** The source cannot represent the approved distinct read-only PM role. A company admin without an explicit project membership can inherit project-admin powers, including management/edit/workflow privileges where those helpers are used.  
**Required design:** Introduce a distinct PM permission model with read-all (including drafts) and no mutation/workflow authority. Revisit company-admin fallback and require explicit project assignment/role mapping; do not silently map PM or all company admins to project admin.  
**Tests:** Company owner/admin with and without explicit project membership; PM read-all plus denied writes and every workflow RPC; role changes and removal; cross-company isolation.

### RLS-05 — X1-to-P2 visibility rule is not represented in the visible document SELECT policy
**Priority:** High  
**Evidence:** The documents SELECT policy checks project membership only; no company/P2 predicate is visible in that policy.  
**Impact:** The source policy does not demonstrate the approved X1 restriction to P2 documents for their company. Other helpers or application filters cannot replace database enforcement.  
**Required design:** Encode the X1/P2/company constraint in the authoritative server-side row predicate and reuse it for all dependent data and storage. Confirm exact business meaning of X1/P2 before implementing.  
**Tests:** X1 user reads own-company P2; attempts other document categories, other companies, other parties, and direct RPC/storage paths.

### RLS-06 — Function EXECUTE grants need PUBLIC-safe hardening and live catalog verification
**Priority:** High  
**Evidence:** The migration revokes selected RPC EXECUTE privileges from `anon` only, while PostgreSQL functions normally receive EXECUTE for `PUBLIC` by default unless revoked. `resolve_numbering_scheme` is explicitly revoked from `public, anon, authenticated`, showing a stricter pattern is already used for one helper.  
**Impact:** The migration text alone does not establish that selected functions are inaccessible through inherited PUBLIC privileges. Function bodies perform checks, but exposure should be explicit and least-privilege.  
**Required design:** For every function, inventory owner, SECURITY DEFINER/INVOKER, search_path, EXECUTE grants to PUBLIC/anon/authenticated/service_role, then revoke PUBLIC/anon as appropriate and grant only intended roles. Do not assume migration source equals live grants.  
**Tests:** Query `pg_proc`, `pg_namespace`, `pg_roles`, and `aclexplode(proacl)` in the deployed database; test RPC invocation as anon and authenticated users with/without project membership.

## 4. Additional observations

- The attachment scope trigger derives project/company from the parent document and rejects a revision that belongs to a different document. Preserve this defense, but extend authorization to the exact parent and lifecycle.
- The comments SELECT rule distinguishes external comments from same-party internal comments. It still needs a separate parent-document visibility condition so comments cannot reveal a hidden draft.
- `profiles: read in shared scope` exposes profiles to users sharing a company or project; verify that only intended profile fields are exposed through the API.
- `project_members: admins delete` prevents an admin from deleting their own membership but otherwise permits deletion of another member; test protection against removing the last administrator and against unauthorized party/role reassignment.
- `integration_connections` and `sync_jobs` show read policies for company admins but no authenticated write policies in this migration. Do not infer that integration features are operational.
- `audit_log` is project-readable. Review whether audit entries contain sensitive draft metadata or changes that would reveal hidden document existence/content.

## 5. Required verification matrix before any policy change

| Test family | Minimum cases | Expected result |
|---|---|---|
| Draft confidentiality | Same-party vs other-party draft | Only originator and explicitly authorized oversight can read |
| PM | All lifecycle states; all write/workflow RPCs | Read all; every mutation and workflow action denied |
| X1/P2 | Same company vs other company; P2 vs non-P2 | Only approved company/P2 scope readable |
| Related records | revisions, reviews, comments, attachments, audit | No side-channel disclosure of hidden drafts |
| Storage | object read, upload, signed URL, guessed/orphan path | Same parent-document authorization as metadata |
| Company admin fallback | explicit and implicit project membership | No unintended project-admin inheritance |
| RPC grants | anon, authenticated, service_role | Only explicitly intended EXECUTE access |
| Tenant isolation | cross-company IDs in every table/RPC/storage path | Denied without information leakage |

## 6. Safe execution sequence

1. Confirm the deployed Supabase project/ref independently; do not infer it from a backup branch or unrelated project identifier.
2. Take an independent database backup and perform a successful restore rehearsal in an isolated environment.
3. Capture live catalog snapshots for RLS policies, table grants, function definitions, function ACLs, storage policies, and bucket configuration.
4. Build and review a migration proposal against the live catalog and this static inventory.
5. Obtain explicit approval for the exact migration and test plan.
6. Apply first to an isolated restored environment; run the complete authorization matrix using real authenticated roles.
7. Only after evidence is reviewed, plan production deployment separately.

## 7. Change and test status

- No source code or SQL was changed.
- No migration was created or applied.
- No live database was queried.
- No Storage object, signed URL, or authenticated policy test was run.
- No build, lint, or automated test suite was run.
- This report is documentation only and must not be treated as a security certification.
