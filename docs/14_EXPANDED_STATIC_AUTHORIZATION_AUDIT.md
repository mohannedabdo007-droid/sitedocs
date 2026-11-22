# 14 — Expanded Static Audit: Tests, Authorization, and Visibility

**Date:** 2026-11-10  
**Project:** Project Doc Control  
**Inspected Lovable source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Related plan:** `docs/13_APPLICATION_REMEDIATION_EXECUTION_PLAN.md`  
**Scope:** Read-only source inspection. No tests, lint, build, database connection, SQL execution, migration, code edit, or deployment was performed.

## 1. Test inventory

The complete Lovable file listing at the inspected commit contains two test files:

- `src/test/app-routing.test.tsx`: one route-matching test for `/`.
- `src/test/domain-rules.test.ts`: unit tests for document-number formatting, UI workflow action availability, revision eligibility, pending/overdue calculations, KPI aggregation, import value mapping, duplicate/conflict detection, revision parsing, and date parsing.

The existing tests are useful but are not security tests. They exercise client-side TypeScript functions and do not call the database RPCs, exercise RLS as different authenticated users, or test Storage policies. No dedicated tests were found for server authorization or the approved business rules listed below.

## 2. Static authorization findings

These are source-level observations only. They identify high-priority cases for adversarial tests; they do not establish that a live deployed database has these exact definitions or that an exploit has been demonstrated.

### A. Workflow RPC permits an admin bypass of party checks

In `drizzle/migrations/0001_triggers_and_rpcs.sql`, `public.transition_document` checks the current party only when `r <> 'admin'` for `start_review`, `respond`, and `return`. Its `submit` branch similarly enforces the originating party only when the role is not admin.

Consequences to test:
- An admin from a non-current party may be able to start/respond/return on behalf of the reviewing party.
- An admin may submit a document even when not acting as the originating party.
- There is no explicit comparison of the responding actor's party with the document creator/originator to prevent self-review or self-approval.

This conflicts with the approved rule that authority follows the designated workflow party and that the originator must not approve its own document. Confirm intended admin exception policy before changing it; the approved project rules do not grant a general admin override.

### B. Project Manager role is absent from the current role vocabulary

The inspected schema enum and `src/lib/domain.ts` define project roles as `admin`, `controller`, `reviewer`, and `viewer`. There is no distinct Project Manager role in these definitions. The current role helper `project_role_of` also promotes a company owner/admin to project admin when no project-membership row exists.

This cannot implement the approved PM model as written: PM must be a distinct read-only role with visibility of all project documents, including drafts, and no document action permissions. A separate role and explicit read-only permission model need design review. Do not simply map PM to admin or viewer.

### C. Draft visibility is broader than the approved cross-party rule

The inspected RLS policy for `documents` grants SELECT to every project member through `is_project_member(project_id)`, without a draft-specific party/creator condition. The Storage read policy similarly permits every project member to read files in the project bucket. Attachments also have a project-member read policy.

This appears inconsistent with the approved rule that drafts remain invisible to other parties before formal submission. PM visibility is a specific exception and must not be generalized to all members. Design and test the document, revision, attachment, and Storage visibility rules together, including signed/download URL behavior.

### D. Membership administration needs adversarial tests

`add_project_member` checks `can_manage_project` and then inserts or updates the requested user's party and role. The inspected function does not visibly prevent assigning an elevated role to oneself or explicitly restrict which target roles can be assigned. Separately, `project_role_of` has the company-admin fallback described above.

Test self-promotion, cross-party role assignment, company-admin fallback, and updates to an existing member. The final policy should preserve legitimate company administration while preventing unauthorized privilege escalation.

### E. Storage upload/read scope is broad

`drizzle/migrations/0002_storage_policies.sql` permits project members to read files and users with `can_comment` to insert files based on the project UUID parsed from the object path. The policy does not visibly bind an uploaded object to a specific document, attachment record, or draft visibility state.

Test forged project paths, uploads unrelated to a permitted document, cross-party reads of draft attachments, and whether orphaned objects can be accessed. No live Storage policy test was performed.

### F. Default response-code semantics conflict with approved rules

The inspected `create_project` RPC seeds:
- E as “Reviewed – no further action” with outcome `proceed`, rather than cancellation by the originating contractor.
- I as “For information only” with outcome `proceed`, which does not itself close/archive the review cycle.
- A/B/C/D defaults, with B labelled “Approved with comments”.

The approved semantics are: A Approved; B Approved as Noted; C Revise and Resubmit; D Rejected; E Cancelled by Contractor; I For Information Only, closing the review cycle and archiving the document while excluding I from B/C KPI metrics. This needs a controlled workflow/configuration design, not just label changes.

### G. MQR and RFI/WIR distinctions need explicit tests

The inspected default project creation logic inserts generic response codes and workflow defaults, with special workflow direction only for SOR/NCR/SNAG. No explicit MQR-specific workflow branch was found in that function. The current static review does not establish how every document type is configured elsewhere.

Add tests proving MQR means Monthly Quality Report and uses an independent workflow without default A/B/C/D/E/I codes; RFI means Request for Inspection and remains a distinct document type from WIR.

## 3. Discipline and KPI normalization

- `src/lib/import/mapping.ts` maps discipline values only by exact code/name matches. It does not normalize historical STR/CIV aliases to CIVSTR.
- `src/lib/kpi.ts` groups by raw `discipline_code`; it does not merge legacy STR/CIV into CIVSTR.
- `document_kpi_matrix` returns the raw discipline code from the reference table.

The approved current set is ARC, CIVSTR, MEC, ELE, SUR. Civil and Structural are one discipline; SUR is Survey. Implement a single normalization contract across seed/reference data, imports, numbering, and KPI aggregation. Preserve historical identifiers and audit traceability during any data migration.

## 4. Recommended test-first sequence

1. **Authorization characterization tests:** exercise RPCs under each role and party, including admin wrong-party actions, creator attempting to review/approve, PM read-only, company-admin fallback, self-promotion, and invalid role assignment.
2. **Visibility/RLS/Storage tests:** drafts visible to creator/originating party and explicitly authorized PM only; other parties cannot list/read documents, revisions, attachments, or storage objects before submission; verify post-submission visibility.
3. **Workflow semantics tests:** exact A/B/C/D/E/I transitions, E cancellation attribution, I close/archive behavior, MQR independent workflow, and RFI distinct from WIR.
4. **Discipline normalization tests:** ARC/CIVSTR/MEC/ELE/SUR selectable; STR/CIV legacy inputs normalize to CIVSTR; KPI groups legacy rows into CIVSTR without double counting.
5. **UI parity tests:** only after server contracts are defined, align `domain.ts` action availability and UI visibility with server rules.
6. **Regression/release gates:** full test suite, lint, build, migration review, backup/restore evidence, and explicit release approval.

## 5. Required environment and safeguards

- The Lovable project is readable and reports status `ready`; its latest inspected source commit remains `963a4af6226e1451b0b155913abb2a4f6770485f`.
- The workspace currently reports insufficient Lovable credits to send an agent message. No agent planning response has been obtained.
- `package.json` defines `test`, `lint`, and `build` scripts, but none was run in this audit.
- Server authorization and RLS/Storage behavior cannot be proven from frontend tests alone. Database-backed tests require a verified isolated test environment and known project backend.
- Any role/schema/policy/workflow/reference-data change may require a Lovable-managed migration. Do not hand-edit migrations or generated schema/types. No database connection or migration is authorized by this report.
- No changes were made to source code, database, branch protection, secrets, PRs, or deployment.

## 6. Status

**Completed:** expanded static inspection of both test files, domain logic, migration-defined workflow RPCs, role helpers, RLS policies, Storage policies, import mapping, KPI grouping, and project defaults.

**Not completed:** runtime validation, live database verification, Lovable agent plan, code changes, test execution, lint/build, backup/restore, migration, merge, or deployment.

**Next safe action:** obtain Lovable workspace credits or have a workspace owner enable them, then request the previously prepared plan-only analysis. Meanwhile, this report provides the additional source-backed test cases and authorization review for the remediation plan.
