# PROJECT DOC CONTROL — Decision-to-Implementation Traceability Matrix

**Document ID:** TRACE-DEC-001  
**Version:** 1.0  
**Date:** 2026-11-11  
**Status:** INITIAL / READ-ONLY TRACEABILITY BASELINE  
**Controlling directive:** [POL-GOV-001](00_CURRENT_APPROVED_GOVERNANCE_DIRECTIVE.md)  
**Decision register:** [REG-DEC-001](01_MASTER_DECISION_REGISTER.md)  
**Branch:** `governance/current-approved-baseline-2026-11-11`

> This matrix connects approved decisions to likely implementation locations and required acceptance evidence. It is an initial map based on the decision register and static source-review findings available on 2026-11-11. It is not proof that implementation is complete, tests pass, or the live database matches the inspected migrations.

## 1. How to read status

| Status | Meaning |
|---|---|
| APPROVED REQUIREMENT | Required target behavior approved by the project owner; not an implementation claim. |
| STATIC FINDING | A source or migration condition was reported by static inspection; runtime behavior is not thereby proven. |
| NOT VERIFIED | The relevant implementation or acceptance test has not been demonstrated in this review. |
| BLOCKED — BACKUP / APPROVAL | Work touching database, schema, migrations, generated types, or production remains blocked by the approved safety gates. |
| UNRESOLVED | The business rule is not yet decided; do not invent it. |

Every decision is assessed in three separate dimensions:
1. **Current target behavior** — the approved requirement.
2. **Observed source state** — static findings only, tied to the reviewed snapshot/reports.
3. **Implementation and test state** — not verified unless explicit test evidence is later attached.

## 2. Decision traceability

| Decision | Current target behavior (approved) | Candidate source / evidence locations | Observed source state (static only) | Required acceptance evidence | Current status |
|---|---|---|---|---|---|
| DEC-001 — WIR | WIR is Work Inspection Request for inspection of executed work; it is not an engineering inquiry. | `src/lib/domain.ts`; document-type configuration; workflow RPCs in `drizzle/migrations/0001_triggers_and_rpcs.sql`; forms/UI routes. | Existing domain lifecycle and generic workflow primitives were inspected; no completed WIR-specific end-to-end verification is available. | **AT-WIR-01:** contractor submits a WIR for executed work; authorized inspection party records inspection outcome; **AT-WIR-02:** WIR cannot be closed merely by an engineering clarification; **AT-WIR-03:** WIR numbering, permissions, lifecycle, reports and audit trail are independent of RFI. | APPROVED REQUIREMENT; NOT VERIFIED |
| DEC-002 — RFI | RFI means Request for Information. It is a separate engineering inquiry in form, numbering, permissions, lifecycle, reporting and audit trail. | `src/lib/domain.ts`; `drizzle/migrations/0000_core_schema.sql`; `drizzle/migrations/0001_triggers_and_rpcs.sql`; document-type configuration and UI. | Historical reports/seeds contain the superseded “Request for Inspection” wording. Current static findings do not demonstrate a fully separate RFI workflow. | **AT-RFI-01:** RFI can be created/submitted as an engineering inquiry; **AT-RFI-02:** RFI and WIR have distinct identifiers/configuration and cannot be substituted; **AT-RFI-03:** RFI closes only through an authorized engineering response/resolution; **AT-RFI-04:** cross-type permissions, reports and audit records remain separate. | APPROVED-REVISED; STATIC FINDING; NOT VERIFIED |
| DEC-003 — MQR | MQR means Monthly Quality Report and uses an independent workflow. Generic A/B/C/D/E/I response codes are not applied by default. | `drizzle/migrations/0000_core_schema.sql`; `drizzle/migrations/0001_triggers_and_rpcs.sql`; `src/lib/domain.ts`; docs/64 and docs/05. | Reports 62/64 describe a seed/source definition using “Material Quality Report”, generic response codes and a generic contractor-to-consultant workflow. Exact MQR stages and actor sequence remain unresolved. | **AT-MQR-01:** MQR is labelled Monthly Quality Report; **AT-MQR-02:** MQR workflow is independent of the general response-code workflow; **AT-MQR-03:** no generic response code is available by default; **AT-MQR-04:** configured stages/actors match a separately approved MQR workflow specification. | APPROVED-REVISED; STATIC FINDING; UNR-001 / NOT VERIFIED |
| DEC-004 — canonical disciplines | Current selectable disciplines are ARC, CIVSTR, MEC, ELE and SUR. Civil & Structural is one discipline. | `drizzle/migrations/0000_core_schema.sql`; `src/lib/domain.ts`; reference-data selectors; import validation; reporting/KPI grouping. | Report 62 says the inspected seed contains ARC, STR, MEC, ELE and CIV, and omits CIVSTR/SUR. | **AT-DISC-01:** selectors expose exactly the five canonical codes; **AT-DISC-02:** unsupported codes are rejected or explicitly handled; **AT-DISC-03:** imports, filters and KPIs group by canonical code. | APPROVED-REVISED; STATIC FINDING; NOT VERIFIED; DB work blocked |
| DEC-005 — legacy discipline compatibility | Legacy CIV and STR remain traceable and map to canonical CIVSTR in current selectors/imports/filters/reports/KPIs using a controlled, non-destructive compatibility strategy. Preserve raw historical values and issued numbers. | `src/lib/domain.ts`; `src/lib/numbering.ts`; import parser/validation modules (exact paths require inventory); docs/06; historical records. | Report 29 identifies missing discipline-alias normalization and raw-code KPI grouping. Numbering module uses a configurable token pattern and GEN fallback; collision and historical-stream implications are not fully verified. | **AT-DISC-04:** CIV/STR inputs normalize to CIVSTR for current use while raw source is retained; **AT-DISC-05:** historical documents and numbers remain unchanged; **AT-DISC-06:** no numbering-stream merge occurs without inventory, collision analysis, recovery plan and explicit approval. | APPROVED REQUIREMENT; STATIC FINDING; NOT VERIFIED |
| DEC-006 — E cancellation | For applicable general workflows, E means Cancelled by Contractor and may be initiated only by the originating contractor under explicit authority checks. | `drizzle/migrations/0001_triggers_and_rpcs.sql`; `src/lib/domain.ts`; response-code configuration; docs/05 and docs/63. | Static SQL review reports E seeded as “Reviewed – no further action” with proceed outcome; transition path has no clearly demonstrated originator-only guard. | **AT-RESP-01:** originating contractor can cancel only its own eligible document; **AT-RESP-02:** consultant, PM, admin and unrelated members cannot invoke E on its behalf; **AT-RESP-03:** server-side RPC rejects forged party/actor values; **AT-RESP-04:** audit trail records actor and cancellation. | APPROVED-REVISED; STATIC FINDING; NOT VERIFIED |
| DEC-007 — I information-only | For applicable general workflows, I means For Information Only, closes the review cycle and preserves the document in the archive; it is not a B/C KPI result. | `drizzle/migrations/0001_triggers_and_rpcs.sql`; `src/lib/domain.ts`; KPI/report queries; docs/63. | Static review reports I seeded with a generic proceed outcome; guaranteed cycle closure/archive behavior has not been demonstrated. | **AT-RESP-05:** authorized I response closes the applicable review cycle; **AT-RESP-06:** document remains retrievable in archive with history intact; **AT-RESP-07:** I is excluded from B/C KPI counts; **AT-RESP-08:** unauthorized actors cannot issue I. | APPROVED-REVISED; STATIC FINDING; NOT VERIFIED |
| DEC-008 — draft confidentiality | Drafts remain confidential to their originating party before formal submission, subject to the explicit PM oversight exception in DEC-009. Attachments and storage objects follow the same visibility boundary. | `drizzle/migrations/0000_core_schema.sql`; `drizzle/migrations/0002_storage_policies.sql`; document/revision/review/comment/attachment queries; docs/51–54. | Static SQL findings report membership-based reads for documents and related records, and storage SELECT based on project membership rather than document-level draft visibility. | **AT-ACL-01:** other parties cannot read another party's draft through UI, API, direct query or RPC; **AT-ACL-02:** revisions, reviews, comments, metadata and audit exposure follow the approved visibility policy; **AT-ACL-03:** attachment listing, object download and signed URL issuance enforce document-level authorization; **AT-ACL-04:** submission changes visibility only at the authorized transition. | APPROVED REQUIREMENT; STATIC FINDING; NOT VERIFIED; DB work blocked |
| DEC-009 — PM read-only oversight | Project Manager can view all project documents including drafts for oversight, but cannot edit, submit, review, respond, approve, cancel or close on behalf of another party. | `src/lib/domain.ts`; role/party model in `drizzle/migrations/0000_core_schema.sql`; server RPCs in `0001_triggers_and_rpcs.sql`; UI action guards. | Inspected role enum lists admin/controller/reviewer/viewer and party enum contractor/consultant/owner/pmc; no explicit PM role/read-only policy was demonstrated in the reviewed source. | **AT-PM-01:** PM can read all project documents including drafts; **AT-PM-02:** PM cannot mutate any document or invoke workflow actions; **AT-PM-03:** PM cannot gain authority by being admin/company owner; **AT-PM-04:** negative tests cover direct API/RPC calls, not just hidden UI buttons. | APPROVED REQUIREMENT; STATIC FINDING; NOT VERIFIED |
| DEC-010 — no self-approval | An originator must not issue a review/approval decision on their own document wherever separation of duties applies. | `drizzle/migrations/0001_triggers_and_rpcs.sql`; `src/lib/domain.ts`; review RPCs; docs/05 and docs/59. | Static RPC review reports no clearly enforced separation-of-duties/self-approval check in the inspected transition path. | **AT-SOD-01:** originator cannot review/approve own document; **AT-SOD-02:** alternate account with same prohibited originator identity/party is rejected according to approved identity rules; **AT-SOD-03:** forged client actor values do not bypass server checks; **AT-SOD-04:** all rejected attempts are safely audited where applicable. | APPROVED REQUIREMENT; STATIC FINDING; NOT VERIFIED |
| DEC-011 — party/role separation | Project role and membership party are separate authorization dimensions. Admin cannot bypass workflow party boundaries or act as another party. | `src/lib/domain.ts`; `drizzle/migrations/0000_core_schema.sql`; `drizzle/migrations/0001_triggers_and_rpcs.sql`; docs/05, 57–59. | Static review reports admin bypass branches in client domain logic and transition RPC party checks. Effective database ACLs and all privileged call paths remain unverified. | **AT-AUTH-01:** test the full role × party × lifecycle-action matrix; **AT-AUTH-02:** admin cannot submit/review/respond as an unrelated party; **AT-AUTH-03:** membership changes cannot self-escalate; **AT-AUTH-04:** service-role calls validate authenticated actor, tenant/project, party, resource and action server-side; **AT-AUTH-05:** effective PUBLIC/anon/authenticated EXECUTE grants are inspected in an isolated DB. | APPROVED REQUIREMENT; STATIC FINDING; NOT VERIFIED; DB work blocked |
| DEC-012 — archive preservation | Superseded decisions/files are retained, not deleted or silently overwritten. Archive access/reuse requires a concrete need and explicit owner permission. | `docs/` governance and supersession index; repository history; archive/storage access controls. | Policy is recorded in current governance documents. Physical relocation of legacy files and enforcement of restricted archive access have not been verified. | **AT-ARCH-01:** original file hash/content remains recoverable; **AT-ARCH-02:** superseded items are visibly marked non-current; **AT-ARCH-03:** routine agents do not treat archive content as active instructions; **AT-ARCH-04:** archive retrieval/reuse requires recorded authorization. | APPROVED REQUIREMENT; DOCUMENTED; OPERATIONAL ENFORCEMENT NOT VERIFIED |
| DEC-013 — preserve diagnostics | Accurate diagnostic reports remain intact as evidence. Remediation status is recorded separately and only after verified source changes and tests. | `docs/05_RPC_WORKFLOW_SOURCE_AUDIT.md`; `docs/51`–`docs/64`; Git history and remediation records. | Diagnostic reports are referenced by the decision register; this matrix does not establish a complete repository-wide preservation audit. | **AT-EVID-01:** compare diagnostic file hashes before/after remediation; **AT-EVID-02:** add separate remediation record with commit, test evidence and reviewer; **AT-EVID-03:** never edit historical findings merely to make current implementation appear compliant. | APPROVED REQUIREMENT; PARTIAL INVENTORY; NOT VERIFIED |
| DEC-014 — database safety gates | No database/schema/migration/generated-type/production change until independent backup, successful isolated restore, reviewed exact plan, authorized ownership workflow and separate explicit user approval. | `AGENTS.md`; `docs/PHASE_0_BACKUP_RESTORE_CHECKLIST.md`; `drizzle/`; `supabase/migrations/`; generated types and backend inventory. | Available backup is source/metadata snapshot, not a verified physical DB backup or tested restore. Checklist says backup/restore steps remain uncompleted. Actual production DB identity is unresolved. | **AT-DB-01:** identify exact live backend/environment; **AT-DB-02:** create independent full backup including DB and storage; **AT-DB-03:** restore to isolated project; **AT-DB-04:** compare schema, policies, functions, records and objects; **AT-DB-05:** submit exact migration plan and obtain explicit approval before any write. | APPROVED REQUIREMENT; BLOCKED — BACKUP / APPROVAL; UNR-005 |
| DEC-015 — current baseline precedence | Current approved definitions govern current behavior over conflicting historical reports, seeds, prompts, comments and agent assumptions. | POL-GOV-001; REG-DEC-001; GitHub Issue #11; Issues #7–#10; PR #6 comments; agent instruction files. | Governance directive, decision register and central GitHub notice have been created. Full synchronization of every repository file and external agent is not complete. | **AT-GOV-01:** each agent/reviewer acknowledges current directive before work; **AT-GOV-02:** conflicting historical language is marked superseded without deleting evidence; **AT-GOV-03:** implementation PR links affected decisions and test evidence; **AT-GOV-04:** no merge/deploy without required explicit approval. | APPROVED REQUIREMENT; PARTIAL GOVERNANCE SYNC; NOT VERIFIED |

## 3. Cross-cutting security and data-integrity acceptance suite

These tests supplement the decision-specific tests above. They are requirements for a future isolated test environment; **none is claimed as passed**.

| Test ID | Acceptance condition | Main evidence surface |
|---|---|---|
| AT-SEC-01 | Draft confidentiality is enforced by database RLS and storage authorization, not merely by hiding UI elements. | Migrations 0000/0002; document and storage access paths |
| AT-SEC-02 | Signed URLs/downloads are issued only after actor-to-document authorization and expire according to an approved policy. | Attachment/download services; docs/52–54 |
| AT-SEC-03 | All SECURITY DEFINER functions have reviewed effective ACLs, safe ownership, controlled search path and explicit grants/revokes. | Migration 0001; docs/57–58; isolated DB catalog inspection |
| AT-SEC-04 | Service-role usage is inventoried; every privileged call enforces verified actor, project/tenant, party, resource and action authorization. | `src/` service-role imports/call sites; auth reports 27–28 |
| AT-SEC-05 | Import commits re-parse and validate server-side; client-supplied mapped values/validation decisions are not trusted as authority. | Import RPCs in migration 0001; import modules; docs/29 and related reviews |
| AT-DATA-01 | Invalid dates block import or require explicit, recorded acknowledgement; raw source value is retained. | Import parser/validator; docs/29 and docs/46 |
| AT-DATA-02 | Chronology constraints are validated server-side; impossible date sequences cannot be imported as valid records. | Import validation and commit RPC |
| AT-DATA-03 | XLSX upload limits cover file size, sheets, rows, columns, cells and text length, with safe failure behavior. | XLSX import parser; docs/45 |
| AT-DATA-04 | Discipline aliases normalize consistently in imports, selectors and KPI grouping without destructive historical rewrites. | Import/reference-data/reporting paths; docs/29 |
| AT-DATA-05 | Audit history is append-only or otherwise protected against unauthorized mutation; rejected and successful workflow transitions are attributable. | Audit/revision schema, triggers and RPCs; docs/60 |

## 4. Known implementation surfaces and limits of this map

- `src/lib/domain.ts`: client/domain lifecycle, party/role constants and available-action logic. Client checks must never substitute for server authorization.
- `src/lib/numbering.ts`: numbering token resolution. Project-specific configuration, legacy compatibility and historical non-retroactivity require further verification.
- `drizzle/migrations/0000_core_schema.sql`: inspected schema/enums and initial RLS policies.
- `drizzle/migrations/0001_triggers_and_rpcs.sql`: inspected workflow, numbering, import and SECURITY DEFINER functions.
- `drizzle/migrations/0002_storage_policies.sql`: inspected storage policy definitions.
- `src/routes/index.tsx`: previously inspected as a placeholder route; do not infer a complete operational UI from the prototype.
- Import source paths: reports identify import behavior, but exact current module paths must be confirmed from a fresh repository tree/search before assigning code changes. No guessed import file path is treated as verified.
- `docs/05`, `docs/29), `docs/45), `docs/46), `docs/51`–`docs/64`: static diagnostic evidence, not runtime proof.
- `docs/06_DISCIPLINE_AND_NUMBERING_AUDIT.md`: compatible reference material for legacy discipline/numbering risks.

This initial map may be incomplete because the available ZIP extraction and report excerpts do not guarantee that every source file was fully represented. Before implementation planning, perform a fresh read-only path inventory and fetch the exact relevant source ranges. Do not modify source, migrations, database, generated types or production during that inventory.

## 5. Required next sequence

1. Read-only inventory of exact source paths and current branch/commit.
2. Expand each row with exact function/table/policy names and source line references.
3. Draft a test catalogue and identify the appropriate isolated test harness.
4. Resolve UNR-001 (MQR workflow), UNR-002 (project-specific configuration), UNR-003 (B/C/D semantics), UNR-004 (retention/custodians), and UNR-005 (backend/backup/restore) with the project owner.
5. Implement only after the relevant ownership, backup, restore and explicit approval gates are met.
6. Update statuses only with reproducible evidence: commit SHA, test command/environment, result, and reviewer. Never change a status to “passed” based on documentation alone.

## 6. Change log

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-11-11 | Initial decision-to-source-to-acceptance traceability matrix; read-only baseline, no source or database changes. |

**End of matrix.**


## 7. Read-only source inventory addendum — 2026-11-11

**Inspected branch:** `dev/review-fixes`  
**Inspected commit:** `1aae68808318dbe0cbaa0bd55d19f9238b587453`  
**Git tree:** `92e3d798d0b80aa2d70697bff8a7b96c13679e20`  
**Tree result:** 178 tracked blobs; recursive tree response was not truncated.  
**Scope:** read-only GitHub tree and source fetches. No source, migration, database, generated file or deployment change was made.

### 7.1 Exact source paths confirmed

| Area | Exact paths confirmed in inspected tree |
|---|---|
| Domain and workflow UI rules | `src/lib/domain.ts` |
| Numbering | `src/lib/numbering.ts` |
| Excel parsing | `src/lib/import/excel.ts` |
| Import mapping and validation | `src/lib/import/mapping.ts` |
| KPI aggregation | `src/lib/kpi.ts` |
| Auth token attachment | `src/integrations/supabase/auth-attacher.ts`; registration in `src/start.ts` |
| Verified-user middleware implementation | `src/integrations/supabase/auth-middleware.ts` |
| Privileged service-role client | `src/integrations/supabase/client.server.ts` |
| Current root route | `src/routes/index.tsx` |
| Schema and RLS | `drizzle/migrations/0000_core_schema.sql` |
| Workflow, numbering and import RPCs | `drizzle/migrations/0001_triggers_and_rpcs.sql` |
| Storage policies | `drizzle/migrations/0002_storage_policies.sql` |
| Import validation persistence and KPI buckets | `drizzle/migrations/0003_import_validation_and_kpi_buckets.sql` |
| Existing test files | `src/test/domain-rules.test.ts`; `src/test/app-routing.test.tsx` |
| Project scripts and dependencies | `package.json` |
| Repository ownership constraints | `AGENTS.md` |

### 7.2 Concrete source observations from fetched files

1. **Domain actions:** `src/lib/domain.ts` defines lifecycle values `draft/submitted/under_review/returned/approved/closed`, parties `contractor/consultant/owner/pmc`, roles `admin/controller/reviewer/viewer`, and generic response outcomes `proceed/return/close`. Its client-side `availableActions` currently treats admin as reviewer regardless of current party (`const reviewer = isAdmin || party === currentParty(doc)`) and permits admin submission through an originator-party bypass. This is a source observation, not proof of server exploitability.
2. **Numbering:** `src/lib/numbering.ts` supports `{PROJECT}`, `{TYPE}`, `{DISC}`, `{SEQ:n}`, `{YYYY}`, `{YY}`; missing discipline becomes `GEN`. `isValidPattern` currently checks only for a sequence token and maximum length. Project-specific uniqueness, collision handling and historical non-retroactivity are not proven by this helper.
3. **Excel parser:** `src/lib/import/excel.ts` reads the workbook with SheetJS and maps all returned sheets/rows/cells; no explicit size/sheet/row/column/cell/text limits are visible in this file. This observation aligns with the static concern in report 45; it does not establish behavior of any upstream upload limit.
4. **Import dates:** `src/lib/import/mapping.ts` has strict calendar-date parsing and returns `"invalid"` for invalid values, but the row validator converts invalid submitted/responded/due dates into warnings (`imp.invalid_date`). The fetched code therefore confirms the client-side warning path; whether the server independently rejects such values must be checked in the RPC and isolated DB.
5. **Import decision:** the same validator sets `validation_status` to `error` only when its errors array is non-empty; warning-only rows remain warning status. The existing test explicitly expects one warning-only row to have `decision: "import"`. This is a confirmed client-side test expectation, not proof that server-side commit revalidates safely.
6. **KPI:** `src/lib/kpi.ts` groups by the supplied raw `discipline_code` and counts B/C response codes. It contains no visible CIV/STR-to-CIVSTR alias normalization and no document-type-specific exclusion of response-code metrics for MQR.
7. **Auth attachment vs authentication:** `src/start.ts` registers `attachSupabaseAuth` in global `functionMiddleware`, which attaches the browser bearer token. A separate `requireSupabaseAuth` server middleware exists in `auth-middleware.ts` and validates claims, but this inventory has not established that it is applied to every server function/route. Do not describe token attachment as universal verified-user enforcement.
8. **Service role:** `client.server.ts` constructs a service-role client explicitly documented as bypassing RLS. Its call-site inventory and per-operation actor/resource authorization remain open.
9. **Root route:** `src/routes/index.tsx` still renders the blank-app placeholder. The presence of UI component primitives is not evidence of a finished SiteDocs application.
10. **Tests available:** `package.json` exposes `test`, `lint`, and build scripts. Existing `domain-rules.test.ts` covers basic numbering, generic workflow action helpers, KPI aggregation, and some import parsing/validation. It does not currently demonstrate the full approved WIR/RFI/MQR separation, PM read-only exception, RLS/storage isolation, server RPC authorization, E/I semantics, or import adversarial/server-revalidation suite. No test command was run in this read-only GitHub inspection.
11. **Ownership gate:** `AGENTS.md` explicitly reserves `drizzle/` and `supabase/migrations/` changes for Lovable and prohibits manual edits. This repository ownership rule remains binding; the current Lovable credit limitation is not permission to bypass it.

### 7.3 Refined acceptance-test priorities

| Priority | Test IDs to implement first | Reason |
|---|---|---|
| P0 — authorization | AT-AUTH-01–05, AT-SOD-01–04, AT-ACL-01–04, AT-PM-01–04 | Client domain helper currently includes admin party bypass; SQL policies use project membership for several document reads; privileged client bypasses RLS. Server-side authorization is the highest-risk verification gap. |
| P0 — workflow semantics | AT-WIR-01–03, AT-RFI-01–04, AT-MQR-01–04, AT-RESP-01–08 | Generic domain model and seeded workflows do not yet demonstrate the approved independent document workflows and response semantics. |
| P1 — import integrity | AT-DATA-01–05, AT-SEC-05 | Invalid dates are warnings in client validation; XLSX resource bounds are not visible in parser; server revalidation and import auditability need independent verification. |
| P1 — reference data and numbering | AT-DISC-01–06 | Canonical discipline alignment, legacy alias handling and preservation of issued numbers need tests across import, KPI and numbering paths. |
| P2 — governance evidence | AT-ARCH-01–04, AT-EVID-01–03, AT-GOV-01–04 | Preserve historical evidence and ensure agent/PR workflows consistently cite the approved baseline. |

### 7.4 Immediate next read-only tasks

- Inspect the complete function/RPC call sites for `requireSupabaseAuth` and `supabaseAdmin`; classify every server function by authenticated actor and authorization checks.
- Inspect the full bodies of `transition_document`, `commit_import_rows`, `save_import_validation`, and the exact RLS/storage policies with line-level references.
- Inspect the complete `validateRows` path and test coverage for chronology, invalid dates, discipline aliases and MQR/KPI behavior.
- Build a server-side test plan for RLS, SECURITY DEFINER ACLs and storage object authorization in an isolated restored environment only.

**Status remains unchanged:** this addendum records read-only observations. No test suite was executed; no test is marked passed; no source or database remediation is claimed.


## 8. Authorization and import deep-dive — read-only confirmation

Additional source ranges were fetched from the same inspected `dev/review-fixes` commit (`1aae68808318dbe0cbaa0bd55d19f9238b587453`). These observations refine, but do not replace, the earlier diagnostic reports.

### 8.1 Server entry-point and privileged-client boundary

- `src/start.ts` registers `attachSupabaseAuth` as global `functionMiddleware` and CSRF/error middleware as request middleware. The token attacher forwards the browser session token; it does not itself verify identity or authorize a project/document action.
- `src/integrations/supabase/auth-middleware.ts` defines `requireSupabaseAuth`, which validates a bearer token using `supabase.auth.getClaims(token)` and places the verified subject/claims and user-scoped Supabase client into context.
- `src/integrations/supabase/client.server.ts` exports a lazy service-role client whose comments explicitly state that it bypasses RLS.
- The inspected tree has no product server-function modules or API route handlers demonstrating protected business operations. `src/server.ts` is the TanStack server-entry/error wrapper, not a document API. Consequently, the current tracked snapshot does not demonstrate a complete authenticated business-operation call chain. This is a readiness gap, not evidence of a runtime bypass.
- `docs/27` and `docs/28` are retained as diagnostic context. Their wording must be read carefully: token attachment is registered; per-operation verified authentication and authorization are not demonstrated.

### 8.2 Exact workflow RPC observations

- In `drizzle/migrations/0001_triggers_and_rpcs.sql`, `transition_document` checks `r <> 'admin' and p is distinct from cur` for start-review/respond paths. Thus admin bypass of the current workflow party is explicit in the inspected SQL source. Submit also permits admin to bypass the originating-party check.
- The same function does not visibly compare the authenticated actor to the document originator/reviewer identity to enforce a general no-self-approval rule.
- `create_project` seeds E as “Reviewed – no further action” with outcome `proceed`, and I as “For information only” with outcome `proceed`; it seeds a generic contractor-to-consultant workflow. This conflicts with the approved E semantics and does not implement the approved MQR independence by itself.
- `add_project_member` authorizes project management, then upserts the supplied target user, party and role. The inspected function does not visibly prevent self-targeting or all forms of prohibited role/party escalation; effective policy needs isolated adversarial tests.
- The migration revokes several RPC execute privileges from `anon`, but the effective ACL for PUBLIC/authenticated must be checked in an isolated database catalog. Do not infer effective permissions from those revoke statements alone.

### 8.3 Exact import observations

- `src/lib/import/mapping.ts` returns `"invalid"` for impossible calendar dates, but `validateRows` converts invalid dates to warnings and maps the invalid value to null.
- Existing test `src/test/domain-rules.test.ts` explicitly expects a warning-only row to have `decision: "import"`.
- `drizzle/migrations/0001_triggers_and_rpcs.sql` function `commit_import_rows` consumes persisted `mapped` JSON, casts selected values, and accepts rows whose validation status is `valid` or `warning`. The fetched body does not visibly re-run the complete business validation (date chronology, canonical discipline mapping, response semantics, and all cross-field constraints) before insert/update.
- `drizzle/migrations/0003_import_validation_and_kpi_buckets.sql` function `save_import_validation` stores client-supplied `mapped`, `validation_status`, `messages` and `decision` fields after a permission check. This makes server-side recomputation/revalidation a critical acceptance requirement before any import commit is trusted.
- `src/lib/import/excel.ts` does not visibly enforce workbook resource limits at parse time. Upload-layer limits, if any, were not verified here.

### 8.4 Added acceptance tests

| Test ID | Required condition | Evidence target |
|---|---|---|
| AT-AUTH-06 | Every business server function explicitly uses verified-user middleware or a reviewed equivalent before accessing project/document data. | Full server-function and route inventory; middleware context |
| AT-AUTH-07 | Service-role client has no browser-reachable import and every use has explicit actor/resource authorization. | Full import/call-site graph and production build bundle inspection |
| AT-AUTH-08 | Effective EXECUTE ACLs for all SECURITY DEFINER functions are enumerated for PUBLIC, anon, authenticated and service_role in isolated DB. | pg_proc/proacl/aclexplode/default privileges |
| AT-AUTH-09 | Admin cannot submit/respond as another party through direct RPC invocation. | `transition_document` server-side negative tests |
| AT-AUTH-10 | Originator cannot self-review or self-approve, including direct RPC attempts. | `transition_document` and identity/party fixtures |
| AT-AUTH-11 | Project member management rejects unauthorized self-escalation and party reassignment. | `add_project_member` adversarial tests |
| AT-IMPORT-06 | Server recomputes mapped values and validation outcomes from retained raw input; client decision/status fields are not trusted. | `save_import_validation` and `commit_import_rows` |
| AT-IMPORT-07 | Invalid dates cannot silently become null-and-import; raw invalid input is preserved and rejected or explicitly acknowledged under an approved rule. | Import validation and commit RPC |
| AT-IMPORT-08 | Chronology and cross-field rules are revalidated server-side before any document/revision write. | Import commit RPC and isolated DB tests |

**No tests were executed.** These are source observations and test requirements only. No SQL, source, database, generated types, or production settings were modified.
