# 15 — Workflow RPC and Import Path Review

**Date:** 2026-11-10  
**Project:** Project Doc Control  
**Inspected source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Scope:** Read-only static review of workflow, project/member, import, trigger, and KPI SQL. No SQL was executed and no database was contacted.

## 1. Workflow transition findings

### 1.1 Admin override applies to multiple workflow actions
In `drizzle/migrations/0001_triggers_and_rpcs.sql`, `transition_document` allows `admin` to bypass the current-party equality check for `submit`, `start_review`, `respond`, and `return`. The `close` action also allows either admin or controller without checking that the actor belongs to the current workflow party.

**Required tests:** admin from a non-current party attempts each action; controller from a non-current party attempts close; current-party reviewer attempts allowed actions; wrong-party reviewer attempts denied actions. Confirm whether any narrowly defined emergency override is intended; no blanket override is approved by the current business rules.

### 1.2 Originator self-review is not explicitly prevented
The transition function obtains the actor's project party and current workflow party, but the inspected logic does not compare the actor with `documents.created_by` or otherwise ensure that the originating organization/user cannot review and approve its own submission.

**Required tests:** same user creates/submits and attempts to start review/respond; another user from the same originating party attempts to review if the business rule is party-level; a separate authorized reviewer from the opposite party succeeds. Clarify whether the prohibition is user-level, company-level, or originating-party-level; the approved rule at minimum forbids self-approval by the originating party.

### 1.3 I and E cannot currently achieve the approved semantics through defaults
The transition logic uses `project_response_codes.outcome` to decide whether a response returns, closes, proceeds to another step, or approves. The default E outcome is `proceed`; I is also `proceed`. The default configuration therefore does not make E an originating-contractor cancellation or I an information-only close/archive outcome.

The approved response contract must be encoded as a validated configuration and transition policy:
- A Approved
- B Approved as Noted
- C Revise and Resubmit
- D Rejected
- E Cancelled by Contractor (originating party cancellation, not a reviewer outcome)
- I For Information Only (ends the review cycle and archives/closes the document; excluded from B/C KPI)

Do not merely change display labels. Define which party may issue E and the resulting lifecycle/audit record.

### 1.4 Close action needs party/authority characterization
The `close` branch checks role membership in `admin` or `controller` and lifecycle state, but does not check current workflow party or originator. Determine whether close is a workflow action for a designated party or an administrative lifecycle action. Encode that decision in tests before changing behavior.

## 2. Project and membership functions

- `project_role_of` returns explicit project membership role, otherwise treats a company owner/admin as project admin. This implicit elevation must be tested against the approved PM separation and project-party authority model.
- `add_project_member` permits a project manager (as represented by current project admin) to assign the supplied party and role to a user; no explicit self-target restriction or role-assignment matrix appears in the function body.
- `add_company_member` rejects assigning the owner role, but allows company admins to add/update non-owner roles. Confirm intended limits and ensure this cannot create project-level privilege escalation through the company-admin fallback.
- `create_project` assigns the creator project role admin and inserts generic default response codes/workflow. It does not configure the approved PM role or MQR-specific workflow.

**Required tests:** company owner/admin with and without project_members row; explicit project roles; self-promotion; assignment of admin to another user; changing a user's party; attempts to remove/downgrade owner; PM read-only behavior.

## 3. Import path and protected-field trigger

### 3.1 Import commit is a privileged workflow bypass by design
`commit_import_rows` is `SECURITY DEFINER`, checks `can_edit_documents`, sets transaction-local `app.doc_import` and `app.doc_transition` flags, then inserts documents/revisions and can update lifecycle/status/response fields directly. It catches per-row exceptions and records failed rows.

This may be appropriate for controlled historical migration/import, but it is a privileged alternate path around normal transition actions. It needs explicit tests for:
- only permitted project editors can commit;
- only rows in the selected validated batch/project can be committed;
- forged mapped JSON cannot set arbitrary document type/project/company/discipline or unsupported status/response values;
- imported current revision and historical audit fields remain consistent;
- failed rows do not partially corrupt a document;
- repeated commits are idempotent and do not overwrite existing data;
- batch ownership and cross-project row IDs cannot be mixed.

The report does not assert an exploit; these are necessary security and integrity test cases for a SECURITY DEFINER import RPC.

### 3.2 Trigger trusts transaction-local flags
`documents_guard_update` bypasses protected-field checks when `current_setting('app.doc_transition', true) = 'on'`. The import and workflow RPCs set this flag. Verify that untrusted authenticated callers cannot set or retain this flag through any exposed SQL/RPC route, and that flags are transaction-local and cleared on every successful path. Test exception rollback behavior too.

### 3.3 Import validation is client-computed
`save_import_validation` is `SECURITY INVOKER` and writes client-provided mapped values/validation status/decision for uncommitted rows after checking project edit permission. Since validation is client-computed, the commit RPC must independently validate all security-critical fields and constraints; it must not treat a client-supplied `valid` or `warning` status as proof that the data is safe.

## 4. KPI and lifecycle observations

- The SQL KPI matrix groups by the raw reference discipline code and the TypeScript KPI layer also groups raw discipline strings. Legacy STR/CIV aliases therefore need canonical normalization to CIVSTR across SQL, import mapping, and client aggregation.
- The TypeScript summary counts only B/C response codes for the B/C metric; the SQL matrix returns response codes and lifecycle rows without applying a special I exclusion. Confirm the exact KPI denominator/metric contract and explicitly exclude I from B/C metrics as approved.
- The current transition RPC records a response in `document_reviews` and `document_revisions`; tests should verify actor, party, step, from/to status, response code, and closure timestamps are consistent.

## 5. Prioritized test matrix

| Priority | Area | Negative case | Expected result |
|---|---|---|---|
| P0 | transition RPC | wrong-party admin responds | denied |
| P0 | transition RPC | originating party/user approves own submission | denied |
| P0 | transition RPC | wrong-party controller closes review | denied unless separately approved rule |
| P0 | draft visibility | other party reads draft or attachment | denied |
| P0 | PM | PM attempts edit/submit/review/close | denied |
| P0 | import RPC | client forges status/response or cross-project row | denied/row rejected |
| P1 | response codes | E issued by reviewer | denied |
| P1 | response codes | I issued | closes/archives; excluded from B/C KPI |
| P1 | MQR | default A/B/C/D/E/I response flow attached | not applied |
| P1 | membership | self-promotion / unauthorized admin assignment | denied |
| P1 | discipline | STR/CIV historical values | normalized to CIVSTR |

## 6. Status and next safe action

This report is a static source assessment only. No tests, lint, build, SQL, database connection, migration, source edit, merge, or deployment was performed. Lovable agent planning remains blocked by the workspace credit limit.

Next safe action: obtain an isolated, verified test environment and write characterization tests before implementing any changes. All schema, RPC, RLS, Storage, and reference-data changes must be delivered through the project’s Lovable-managed migration workflow after backup/restore evidence and explicit approval.
