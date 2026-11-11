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


## 9. Authorization, RLS and test-coverage cross-check — 2026-11-11

This section records a further read-only cross-check of the auth helpers, migrations 0000/0002/0003 and existing domain tests at `dev/review-fixes` commit `1aae68808318dbe0cbaa0bd55d19f9238b587453`.

### 9.1 Verified identity versus business authorization

- `auth-middleware.ts` exports `requireSupabaseAuth` as a function middleware and validates the bearer token through Supabase `getClaims` before supplying a user-scoped client/context.
- `auth-attacher.ts` is a client middleware that forwards the current access token; `start.ts` registers this attacher globally for server functions.
- The tracked route inventory and diagnostic docs 27/28 describe only the root UI route and no product-specific business server-function modules/API handlers demonstrating the full chain. The helper's existence therefore cannot be counted as proof of endpoint protection.
- `client.server.ts` exposes a server-only service-role proxy documented as bypassing RLS. The tracked application snapshot does not demonstrate a business-operation call path using it. Keep the status as **sensitive capability present; call graph and runtime use not established**, rather than asserting either active misuse or a complete absence of external consumers.

### 9.2 Draft confidentiality and storage authorization

- Migration 0000 enables RLS and defines `documents: members read` using only `is_project_member(project_id)`; revisions, reviews and attachments similarly use project membership for read access. These predicates do not visibly filter draft status or originator/party visibility.
- Migration 0002 grants storage object SELECT to project members using a project identifier parsed from the object path. The policy does not visibly join the object to an attachment/document record or apply that document's draft visibility rule.
- Therefore the checked-in migration source does not demonstrate the approved rule that drafts remain hidden from other parties before formal submission. This is a **migration-source gap**, not a live database observation. The project-manager read-only exception also needs explicit tests that distinguish visibility from mutation/review authority.

### 9.3 Existing test coverage and a key discrepancy

- `src/test/domain-rules.test.ts` has unit cases for numbering, generic workflow helpers, KPI and import parsing/validation. It includes a helper-level expectation that only the originating party can submit a draft.
- The SQL `transition_document` function nevertheless has an explicit admin exception to the originating-party submit check and current-review-party checks. Thus a passing unit test of the client helper would not prove that direct RPC calls enforce the same rule. This client/server policy divergence must be covered with direct database/RPC negative tests.
- Existing tests include a warning-only import row whose decision is expected to be `import`; this matches the source validator/commit path and should be changed only after the approved invalid-date/acknowledgement policy is made explicit.
- No tests were run during this inspection; test names and assertions were read statically.

### 9.4 Additional acceptance tests

| Test ID | Required condition | Evidence target |
|---|---|---|
| AT-ACL-05 | Draft documents, revisions, reviews, comments and attachments are hidden from unauthorized project parties until formal submission. | RLS policy tests with two parties and draft/submitted fixtures |
| AT-ACL-06 | Storage object access follows the linked document's visibility and cannot be obtained by guessing another object path. | Storage policy tests with cross-party and draft fixtures |
| AT-PM-05 | PM may read drafts for oversight but cannot edit, submit, respond, review, approve or close them unless separately granted an authorized operational role. | RLS/RPC/API tests separating read from action permission |
| AT-SOD-05 | Direct RPC calls enforce originator/current-party rules even if client-side action helpers are bypassed. | SQL/RPC negative tests for admin and non-admin identities |
| AT-GOV-05 | Every test report distinguishes helper/unit coverage from database policy and direct endpoint coverage. | CI artifact/report review |

### 9.5 Status

All findings above are static source observations. Effective database ACLs, deployed RLS policies, Storage configuration, live endpoint exposure, runtime authorization, and restore-backed isolated database tests remain unverified. No tests were executed and no application, migration, database, generated type or deployment changes were made.


## 10. First controlled client-side remediation — 2026-11-11

**Implementation branch:** `fix/client-workflow-party-guard-2026-11-11`  
**Draft PR:** [#12 — enforce workflow party boundaries in client actions](https://github.com/mohannedabdo007-droid/sitedocs/pull/12)  
**Head commit:** `db7071031c8ab1795e3405f0483e462432cc0640`

### 10.1 Change implemented

- In `src/lib/domain.ts`, client `availableActions` no longer treats Admin as the current reviewing party by default.
- Admin no longer bypasses the originating-party condition for client-side draft submission.
- Added two unit test cases in `src/test/domain-rules.test.ts` to verify that Admin cannot submit/respond/return as a different party, while the correct party retains the action.

### 10.2 Scope and limitation

- The draft PR changes exactly two files: `src/lib/domain.ts` and `src/test/domain-rules.test.ts`.
- No SQL/Drizzle/Supabase migration, generated file, database, secret, or deployment was changed.
- This is a client-side consistency and defense-in-depth remediation only. The SQL RPC `transition_document` still has Admin bypass branches. The backend authorization gap remains open and this PR must not be treated as a complete authorization fix.
- Repository instructions in `AGENTS.md` reserve database/migration edits for Lovable; that rule was respected.

### 10.3 Verification status

- GitHub read-back confirmed the updated domain guard and both new test cases on the PR branch.
- **Vitest was not run. Lint was not run. Build was not run.** The repository has no `.github/workflows/` CI workflow in the inspected tree, and no connected execution environment was available to run the package scripts. Therefore no runtime test is marked passed.
- PR #12 remains draft and unmerged; it is not deployed.

### 10.4 Next required work

1. Run `npm test`, `npm run lint`, and `npm run build` in a project execution environment and attach their raw logs.
2. Obtain the Lovable/database-owner path for the server-side RPC remediation; do not hand-edit migrations.
3. Add direct RPC negative tests proving Admin cannot act as another party and originator cannot self-review/approve.
4. Only then reassess the PR from draft to ready; do not merge to `main` without the user's explicit approval.

**Status:** client source patch committed and read-back verified; runtime verification pending; backend authorization remediation pending.


## 11. Isolated database security audit plan — 2026-11-11

Created [POL-DB-SEC-001 — Isolated Database Security Audit Plan](03_ISOLATED_DATABASE_SECURITY_AUDIT_PLAN.md) in commit `9942265fecae8e0f2fec2703effd60518e8be77b`.

- Static migration-source inventory identifies 27 SECURITY DEFINER definitions across migrations 0000, 0001 and 0003, with exact names/signatures and source hashes recorded in the plan.
- The plan distinguishes source-level `REVOKE` statements from effective deployed ACLs, inherited role privileges, default privileges, schema CREATE rights, ownership, and live function definitions.
- It supplies read-only catalog queries for `pg_proc`, expanded ACLs, effective EXECUTE checks, default privileges, schema privileges, role membership, and function settings.
- It defines isolated negative tests for workflow-party boundaries, self-review, membership escalation, import tampering, tenant-scope triggers, RLS/draft visibility, Storage, audit trail, and numbering.
- **Execution status:** no live database was accessed; no backup or restore was performed; no catalog query or database test was run; no SQL, migration, schema, or data was changed. All DB execution remains blocked until the plan's backup/isolated-restore/ownership/explicit-approval gates are met.

The 27-function inventory is static source evidence only, not proof of deployed functions or effective ACLs.


## 12. Legacy discipline KPI normalization — PR #13 (draft)

**PR:** https://github.com/mohannedabdo007-droid/sitedocs/pull/13  
**Branch:** `fix/discipline-kpi-normalization-2026-11-11`  
**Head:** `b63f906165c00a5b03142cf99d3da48abdf6ea96`

- Added `normalizeDisciplineCode` in `src/lib/domain.ts`: legacy `CIV` and `STR` aliases map to `CIVSTR`; unrelated codes remain unchanged; null becomes an empty comparison key.
- Applied this normalizer only to KPI discipline grouping in `src/lib/kpi.ts`.
- Added unit cases for alias mapping and KPI aggregation. No historical stored identifiers or database rows are rewritten.
- PR changes only `src/lib/domain.ts`, `src/lib/kpi.ts`, and `src/test/domain-rules.test.ts`.
- Vitest/lint/build have not been executed. PR remains draft/unmerged; no runtime result is claimed.

**Status:** code and tests committed/read-back pending; execution verification pending.


## 13. Excel invalid-date import guard — PR #14 (draft)

**PR:** https://github.com/mohannedabdo007-droid/sitedocs/pull/14  
**Branch:** `fix/import-invalid-date-blocking-2026-11-11`  
**Head:** `eece6393b4f146b0dacd29dd382678cc98273599`

- Static review confirmed `parseDate` returns `"invalid"` for malformed/nonexistent dates, but `validateRows` previously downgraded that condition to a warning and set the mapped date to null. Warning rows are eligible for import, so a non-empty invalid date could be silently lost.
- Changed the validator so a non-empty invalid mapped date is an error; the row remains pending and cannot be selected as importable through the normal validation decision.
- Added a regression test for an impossible due date (`31/02/2025`) asserting error status, an explicit validation message, null mapped date, and pending decision.
- Read-back verified both changed files on the PR branch. This is a client/domain validator change only; server-side import revalidation in the database RPC remains a separate unresolved requirement (AT-SEC-05 / AT-IMPORT-06–08).
- No chronology rules between submitted/responded/due dates were introduced because those business constraints are not yet approved. No DB, migration, generated file, stored record, or deployment was changed.
- Vitest, lint and build have not been run; this is not a passed test result.

**Status:** source patch and regression test committed/read-back verified; runtime verification pending; server-side enforcement still unverified.


## 14. Excel workbook resource limits — PR #15 (draft)

**PR:** https://github.com/mohannedabdo007-droid/sitedocs/pull/15  
**Branch:** `fix/excel-import-resource-limits-2026-11-11`  
**Head:** `90e9f0c8c72a1c4b82c41dbfbd9c54782a3df3b6`

- Added a pre-parse file-size ceiling of 10 MiB.
- Added worksheet count ceiling of 20, per-sheet dimensions of 10,000 rows and 100 columns, an aggregate declared-range ceiling of 500,000 cells, and a 10,000-character per-cell/header string ceiling.
- Dimension checks use worksheet `!ref` and run before `sheet_to_json` materializes row arrays. Empty sheets remain accepted.
- Added regression tests for file size, sheet count, row count, column count, aggregate cells, and a valid small workbook. Files were read back from the PR branch.
- This is a client-side resource guard, not a streaming XLSX parser. The XLSX library still parses the compressed workbook after the file-size gate. The inspected `src/routes/index.tsx` remains a blank-page placeholder, and no active caller/UI path for `parseWorkbook` was established; user-facing error integration remains pending.
- Caller/UI integration has not been verified; callers should surface `WorkbookLimitError.message`. Vitest, lint, and build have not been run.
- No database, migrations, generated files, stored records, or deployments changed.

**Status:** source and test committed/read-back verified; runtime verification and user-facing error integration pending.


## 15. End-to-end import pipeline current-state audit (2026-11-11)

**Companion plan:** `docs/04_IMPORT_PIPELINE_END_TO_END_REMEDIATION_PLAN.md`  
**Evidence baseline:** supplied `sitedocs-dev-review-fixes.zip`, checked-in migrations 0000–0003, and PR #15 head. Static review only.

| Area | Current evidence | Status |
|---|---|---|
| Workbook parser | `src/lib/import/excel.ts`; PR #15 resource ceilings including 10 MiB, 20 sheets, 10,000 rows/sheet, 100 columns/sheet, 500,000 declared-range cells, 10,000 chars/cell | Implemented in PR branch; tests added but not executed |
| Mapping and client validation | `src/lib/import/mapping.ts` pure helpers; caller-supplied validation context | Static finding; not authoritative |
| Import route/UI | Route inventory shows only root/index; index is explicit blank-page placeholder; no import route/component or `parseWorkbook` caller found in supplied source inventory | Missing from reviewed snapshot; fresh repository inventory required |
| Workbook error UI | No verified parser caller to catch/display `WorkbookLimitError` | Not implemented / not verified |
| Staging validation RPC | `save_import_validation` in migration 0003 stores client-supplied mapped/status/messages/decision after project edit check | Server-side recomputation absent in reviewed source |
| Commit boundary | `commit_import_rows` in migration 0001 checks project edit permission and batch state, but selects using client-writable decision/status and does not visibly recompute all canonical rules | Source-level data-integrity gap; no live exploit claim |
| Batch terminal state | RPC may set batch `committed` with failed rows once no unprocessed eligible rows remain | Ambiguous completion semantics |
| Failed-row retry | Failed rows receive non-null `commit_status`; same RPC selects only null commit_status; no retry RPC identified in checked migration set | Recovery gap in checked migrations |
| Row audit | Batch audit trigger present; no import-row generic audit trigger identified in checked migration set | Row-level audit coverage gap unless external mechanism exists |
| Live DB/runtime | No live catalog, deployed function, grants, RLS runtime, or data inspected | Not verified |

**Scope and gates:** This section records source findings and a remediation sequence only. No route/UI, server function, SQL, migration, generated types, live database, stored data, or deployment was changed. No test/build/lint execution is claimed. Database remediation remains blocked pending identified owner, independent backup, verified restore, exact migration review, and explicit user approval. PR #15 remains draft/unmerged/not deployed.


**Authentication/staging follow-up:** `src/start.ts` globally attaches the session bearer token to server functions, but a future import server function must explicitly apply `requireSupabaseAuth` to verify claims and obtain a user-scoped client. No import server-function module was found. The service-role client bypasses RLS and is not an acceptable default import path. Report 31 additionally identifies broad direct UPDATE grants on import staging rows and INSERT-only scope derivation; a UI/server-function change alone cannot close these database write-surface gaps. See the updated Section 10 of the companion plan. No runtime auth/RLS/grant test was performed.

**Cross-PR dependency:** PR #15 does not include the separate PR #14 invalid-date client fix. The reviewed mapping source still downgrades invalid non-empty dates to warnings/null. Reconcile both branches before UI integration, then enforce strict server-side date parsing independently; do not infer chronology policy.


## 16. Scanned-document attachments — DEC-016 (approved requirement; implementation not started)

**Owner decision:** one designated primary scanned file per transaction/document, with zero or more additional scan files. The short file name is shown in the same document-register row and opens the selected file in an authorized viewer.

| Requirement | Target behavior | Candidate implementation area | Verification required | Current status |
|---|---|---|---|---|
| SCAN-01 | Each file references the stable document/transaction ID; revision-specific files also reference the exact revision ID. | New attachment metadata relation and document/revision association; exact schema not yet designed. | Cross-document and cross-revision isolation tests. | Approved requirement; not implemented |
| SCAN-02 | Exactly one primary designation per transaction; any number of additional files subject to approved limits. | Server-authoritative primary designation and attachment metadata operations. | Concurrent primary-selection, duplicate designation, and additional-file tests. | Approved requirement; implementation design pending |
| SCAN-03 | Register row displays the primary short file name and provides access to additional files. | Document register UI; no current scan UI path verified. | Empty state, one primary, multiple additional files, long names, and mobile layout tests. | Approved requirement; UI not implemented |
| SCAN-04 | Selecting a file opens it in a viewer only after current-user authorization. Storage remains private; do not expose permanent public URLs. | Private Storage object path plus server-authorized signed/streamed access; exact existing attachment mechanisms must be inspected before reuse. | Unauthorized user, cross-project, draft visibility, PM read-only, expired URL, and direct-object URL tests. | Approved security boundary; implementation not verified |
| SCAN-05 | Adding/opening a scan never changes numbering, revision sequence, lifecycle, response code, review authority, or KPI values. | Keep scan metadata outside numbering/workflow/KPI domain logic. | Regression tests for all unaffected domain outputs. | Approved requirement |
| SCAN-06 | Historical scan/revision associations are not silently overwritten or deleted. | Append-only/versioned association and audited replacement/removal workflow; policy details pending. | Historical retrieval, replacement trace, and audit tests. | Preservation requirement approved; exact lifecycle policy pending |

**Non-authorizations and unresolved design gates**
- This decision does not authorize database schema, migration, Storage policy, generated type, production, or deployment changes.
- File MIME/type allowlist, per-file and per-transaction size/count limits, malware/content scanning, retention period, authorized uploader/remover roles, replacement/withdrawal policy, and preview/download audit details require a technical proposal and owner review.
- Reuse of existing attachment tables or Storage paths must be established by a fresh source and migration inventory; do not assume the current attachment model is sufficient.
- Preserve document confidentiality: a Project Manager's approved visibility remains read-only and does not imply upload, replacement, deletion, or workflow authority.
- The scan feature is independent from the Excel import pipeline. Do not combine the implementation branches or change import scope because of this feature.

**Current evidence:** This section records the approved requirement and acceptance targets only. No scan UI, upload handler, storage object, schema, migration, database, generated type, test, or deployment has been changed.


## 17. Scan attachment technical design proposal — POL-SCAN-001

**Proposal:** [docs/65_SCAN_ATTACHMENT_DESIGN_PROPOSAL.md](65_SCAN_ATTACHMENT_DESIGN_PROPOSAL.md)

Read-only inspection of `dev/review-fixes` found an existing `public.attachments` table and `document-files` Storage bucket policy. The visible metadata includes document/revision/project/company IDs, storage path, file name, MIME, size, uploader and timestamp. However, current source policies allow attachment/object reads by project membership and uploads by the broad `can_comment(project_id)` predicate. The reviewed storage path check scopes only by project UUID; it does not visibly bind the object to an attachment row/document/revision or enforce draft-level visibility. The attachment FK also uses document `ON DELETE CASCADE`, requiring a preservation guard.

The proposal recommends reusing the existing attachment concept rather than creating a parallel scan system, subject to fresh deployed-schema verification. It defines a register-row primary file link plus additional-file list, revision-aware association, private storage, per-request authorization, atomic single-primary designation, quarantine, immutable replacement/supersession, audit, and a 14-case acceptance suite.

**Proposed initial limits for owner review (not yet approved as policy):** PDF/JPEG/PNG only; 25 MiB per file; 20 files per transaction; 100 MiB aggregate per transaction; 180-character display name; five-minute signed URL. Malware scanning is required before availability only if an actual scanner is configured; no scanner capability is claimed.

**Authorization proposal:** verified user-scoped server path; attachment-management permission distinct from comment permission; parent-document visibility governs list/preview/download; PM remains read-only; no admin/party bypass. Exact uploader/remover role mapping, retention, deletion/withdrawal, and malware-scanner availability remain approval items.

**Status:** design documented; implementation not started. No UI, source, server function, schema, migration, generated type, bucket, Storage policy, DB, stored record, test, or deployment was changed. No live DB/Storage state was inspected. No tests were run.


## 18. Document/revision-level scan security specification — POL-SCAN-002

**Specification:** [docs/66_SCAN_DOCUMENT_REVISION_SECURITY_SPEC.md](66_SCAN_DOCUMENT_REVISION_SECURITY_SPEC.md)

The specification defines:
- Reuse of the existing `attachments` metadata and `document-files` bucket without parallel storage, preserving existing IDs and non-scan attachment semantics.
- Relational integrity between attachment, document, revision, project, company, bucket, and object key.
- Document- and revision-level read authorization for metadata, Storage reads, preview, download, and signed URL issuance.
- Separate upload, primary-designation, and withdrawal capabilities; comment permission and project membership alone are insufficient.
- Explicit PM read-only behavior, verified-user middleware, user-scoped access, quarantine, atomic primary designation, immutable replacement, audit, and retention safeguards.
- Sixteen negative security tests covering cross-project access, draft confidentiality, PM mutation, forged uploader, mismatched revision, primary races, expired URLs, quarantine, historical retention, and workflow/KPI non-interference.

**Implementation status:** design/specification only. No code or DB/security policy changed. Existing source policies remain as found and must not be represented as remediated. Exact role mapping, live schema/policy inspection, backup/restore, and owner approval of the exact migration remain gates.


## 19. Live deployed database and Storage policy inspection — 2026-11-11

**Environment identified:** Lovable project **Project Doc Control**, project ID `8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`, database enabled with Supabase. This is distinct from the disabled Lovable **SiteDocs Interactive Preview** project (ID `56ce90aa-5a8f-430c-9a27-a3981f4072bb`). The live catalog queries in this section were executed against Project Doc Control, not inferred from repository migrations.

**Read-only live findings:**
- `pg_policies`: `attachments` SELECT is `is_project_member(project_id)`; INSERT is `can_comment(project_id)`. `documents` and `document_revisions` SELECT are also project-membership based. Storage `document-files` SELECT is based on `is_project_member(storage_project_id(name))`; INSERT uses `can_comment(storage_project_id(name))`.
- RLS is enabled on `public.attachments`, `public.documents`, `public.document_revisions`, and `storage.objects`; `relforcerowsecurity=false` on all four.
- Live `document-files` bucket is private, `file_size_limit=52428800` (50 MiB), `allowed_mime_types=NULL`.
- Live attachment columns include `document_id` NOT NULL, `revision_id` nullable, `project_id` NOT NULL, `company_id` NOT NULL, `storage_path` NOT NULL unique, `file_name` NOT NULL, nullable MIME/size, `uploaded_by` default `auth.uid()`, and `created_at`.
- Live `set_scope_from_document()` trigger function fills project/company from the parent document and rejects a revision whose `document_id` does not match. This is an INSERT trigger; it does not itself prove complete update-time integrity or object-to-row binding.
- Live triggers include audit triggers for attachment INSERT/UPDATE/DELETE and revision INSERT/UPDATE/DELETE.
- Live `can_comment`, `is_project_member`, and `project_role_of` are SECURITY DEFINER with `search_path=public`; `storage_project_id` is not SECURITY DEFINER and parses the first path segment as a project UUID.
- Effective privilege inspection via `has_table_privilege` and relation ACLs showed `anon` and `authenticated` have SELECT/INSERT/UPDATE/DELETE/TRUNCATE on each of `public.attachments`, `public.documents`, and `public.document_revisions`. They also have SELECT/INSERT/UPDATE/DELETE on `storage.objects` (no TRUNCATE there). This is a significant grant-surface finding. RLS still filters row operations where applicable; TRUNCATE is not governed by row-level policies. Do not infer that an unauthenticated caller can issue arbitrary SQL through the public API: exposure depends on available connection/API paths. The grants nevertheless require least-privilege remediation and investigation of their origin.
- The live ACLs differ from the grants visible in checked-in migration 0000, which explicitly grants narrower privileges on these tables. The source/deployed drift is not yet explained.
- The bucket query returned no object rows for `document-files`; this only establishes no rows were returned by that catalog query, not a complete independent backup or inventory of stored file bytes.

**Operational constraints and implementation gate:**
- Lovable project file `AGENTS.md` explicitly says not to add/edit `supabase/migrations/` or `drizzle/` directly; database changes must be requested through Lovable's schema workflow. `drizzle/schema.ts` is marked auto-generated and intentionally blank.
- Available Lovable MCP exposes read-only catalog querying and project file inspection, but no backup/export/restore operation was identified in the available tool inventory. A query action limit was reached during the inspection, so additional catalog queries could not be completed in this session.
- No backup was created, no restore was attempted, no data or Storage object was modified, no grant/policy/schema/migration was changed, and no test was run.
- Before remediation: identify the database owner and supported backup/export method for both PostgreSQL data and Storage object bytes; obtain an independent backup; restore it into a separate isolated project; verify row counts, schema, policies, grants, and object checksums/access; then prepare an exact reviewed remediation plan and obtain separate explicit user approval. Follow the Lovable project ownership workflow rather than editing managed migration directories directly.

**Status:** live policy/grant findings verified read-only; remediation blocked. The earlier Sections 16–18 remain historical design/source findings and should not be read as evidence that live policies were inspected at the time those sections were written.


### Backup/restore requirements cross-check — official Supabase documentation

The backup gate must cover both database state and Storage object bytes:
- Supabase documents automatic daily database backups for Pro, Team and Enterprise; Free projects should regularly export data using `supabase db dump`. The current Supabase plan for the identified project has not been verified.
- Supabase explicitly states database backups do **not** include Storage API objects. A database-only restore/clone can restore object metadata and bucket records without the actual file bytes; Storage objects and settings require a separate transfer/recovery step.
- Supabase documents restore-to-new-project as the safer route for testing because restoring over the original project replaces its database state. The clone/restore workflow requires manual reconfiguration and does not copy Storage objects.
- Therefore the acceptance gate is: database backup/export + separate complete export of all Storage buckets/objects + restore into an isolated project + verify object counts and per-object checksums (or byte-for-byte hashes), metadata-to-object links, policies, and access behavior. A successful database-only restore is not sufficient.

Official references:
- https://supabase.com/docs/guides/platform/backups
- https://supabase.com/docs/guides/platform/clone-project
- https://supabase.com/docs/guides/platform/migrating-within-supabase/dashboard-restore

No backup/export/restore was initiated in this work. These are documented requirements, not completed operations.


## Section 20 — Paper scanning and in-SiteDocs electronic signature lifecycle (DEC-017)

**Controlling design:** [POL-SCAN-003 — Paper Scanning and In-SiteDocs Electronic Signature Lifecycle Design](67_SCAN_AND_ELECTRONIC_SIGNATURE_LIFECYCLE_DESIGN.md).

**Owner-approved route selections (2026-11-11):**
- Paper: final scanning starts only after all required handwritten signatures and paper approvals are complete. A pre-scan completeness gate is required, followed by scan quality control, primary PDF registration, revision linkage, and archival handling.
- Electronic: each authorized person signs/approves inside SiteDocs using their own authenticated account and assigned role/party/workflow permission. Each action is bound to the exact document/revision/content snapshot and recorded in an append-only audit history.
- For the selected in-SiteDocs signing route, freeze the reviewable content snapshot before signing; generate and validate the final archival PDF only after the last required signature and final approval. PDF generation failure must not falsely mark the revision final/archived.

**Lifecycle separation:** review/approval state and records-processing/PDF/archive state are distinct. Paper and electronic routes have distinct stage labels. Neither scan nor PDF generation changes document numbering, revision sequencing, approval authority, workflow outcomes, response codes, or KPIs. WIR/RFI separation and MQR's independent workflow remain unchanged.

**Security/immutability requirements:** server-side action-time authorization; no proxy signing or self-approval; PM oversight remains read-only; draft and attachment visibility follow document-level confidentiality; preserve earlier signature events and final PDFs; changes after signing require a controlled new revision/reapproval; no silent overwrite.

**Open design items:** exact records-control role mapping, signer sequence/parallelism, delegation/revocation, MFA/re-authentication, visual signature treatment, legal/contractual e-signature assurance, PDF engine/hash/retention/backup, and paper-original custody/retention. See POL-SCAN-003 §10. These are not silently decided here.

**Implementation boundary:** design documentation only. No schema/DB/migration/generated type, Storage object/policy, authentication/authorization, production configuration, code, test, merge, or deployment change was made. Implementation requires a separate exact plan, DB and Storage backup, successful isolated restore, security/acceptance review, and explicit owner approval.


## Section 21 — Reusable and per-transaction personal signature assets (DEC-018)

**Owner-approved requirement (2026-11-11):** support both a saved personal signature asset in the user's account and a separate one-off signature upload for an individual transaction. Both PDF and JPEG formats are accepted. Every asset and applied signature is attributable to its owner and linked to the exact approval record and document revision.

**Target flow:** authenticated user manages a private personal signature library; at an assigned signing step, the signer chooses their saved asset or uploads a different transaction-only asset; previews and explicitly confirms placement; the signature is applied only as part of that user's authorized sign/approve action. Upload alone is not approval. A one-off upload does not replace the saved default. Replacing a saved asset does not alter previously signed records.

**PDF handling:** PDF is an accepted signature source file, but it requires a reviewed page and signature-region selection or equivalent placement process. No blind stamping of every page. JPEG is treated as a raster signature image. Actual file content validation, safe rendering, private storage, and approved size/security limits are required.

**Audit/integrity:** record account owner, actor/role/party, workflow step, document/revision/content snapshot, asset identifier/version, source (saved or one-off), action, and server timestamp. The visual mark must be bound to the same immutable content snapshot as the approval event. A visual image alone is not cryptographic identity proof or legal enforceability. Preserve prior signature assets/events and final PDFs.

**Implementation boundary:** design only. No signature asset storage, schema/DB/migration/generated types, Storage/upload policy, authentication/authorization, PDF stamping service, code, tests, merge, or deployment changes were made. See POL-SCAN-003 §12 for detailed stages and acceptance scenarios.


## Section 22 — Multi-party signature rosters and role-specific slots (DEC-019)

**Owner direction:** support up to 10 contractor signatory slots, up to 10 consultant slots, and up to 5 developer/owner slots. Each slot is distinct and independently attributable to a party, role, assigned authenticated account, signature asset/version, and approval event.

**Contractor role categories named:** ARC, CIVSTR, MEC, ELE, SUR, Quality, HSE, Procurement, and Document Controller. These are nine role categories against ten requested contractor roster slots; slot 10 remains configurable/optional until its role is specified. **A category is repeatable, not limited to one person:** for example, three contractor ELE engineers require three separate person-level slots and approval records. The same multiple-people-per-specialty model applies to consultant and developer/owner rosters.

**Consultant:** maximum 10 configurable person-level slots. **Developer/Owner:** maximum 5 configurable person-level slots. The 10/10/5 figures are party roster capacities, not fixed counts per specialty and not mandatory signer counts for every document. Multiple people assigned to one specialty consume separate slots within the party capacity. Any capacity increase, quorum, or representative-signature rule requires explicit configuration approval.

**Per-document selection:** the workflow selects the actual required people/slots by document type, discipline, party, project, contract, and approved workflow. A specialty may have zero, one, or multiple assigned signers. Optional/unselected slots do not block completion. If several named people are required, each must complete their own assigned action unless an explicitly approved quorum/representative rule says otherwise.

**Acceptance controls:** one person's signature cannot satisfy another person's slot; assigned authenticated account only; each repeated specialty assignment has a distinct slot/assignment ID, asset/version reference, and immutable approval event; optional/unpopulated slots do not block completion; all required individual slots must complete before finalization; returned/rejected states and authorized waivers are auditable. No proxy signing. Preserve per-person role, party, account, revision/content hash, asset/version, action, and server timestamp.

**Boundary:** design only. No DB/schema, provisioning, UI, authorization, workflow engine, code, merge, or deployment changes.


## Section 23 — Project Team Roster and authenticated individual registration (DEC-020)

**Controlling design:** [POL-SCAN-003 §14 — Project Team Roster and individual account registration](67_SCAN_AND_ELECTRONIC_SIGNATURE_LIFECYCLE_DESIGN.md#14-project-team-roster-and-individual-account-registration--dec-020).

**Owner-approved requirement (2026-11-11):** provide a central, party-scoped Project Team Roster for registering named personnel and linking each person to their own authenticated SiteDocs account and active project/party/role assignment. The roster supports the DEC-019 party capacities (Contractor 10, Consultant 10, Developer/Owner 5), with repeatable specialties and distinct person-level assignments.

**Target workflow:** an authorized party roster manager invites/registers a person; the person authenticates and accepts the project assignment; only an active, accepted, account-linked assignment may be selected as a signer candidate. A name-only record, shared account, or administrator impersonation is insufficient. Suspension or assignment end blocks future actions while preserving historical account, assignment, signature, and audit attribution.

**Permission separation:** roster administration does not grant blanket document visibility, draft access, document authoring, review, approval, or signature authority. Each document workflow selects the required person-level slots, and server-side authorization is rechecked at action time. Personal signature assets remain private to their account owner under DEC-018.

**Acceptance coverage:** invitation and account acceptance; duplicate/role assignment handling; multiple people per specialty; distinct identities for multiple roles; document-level visibility and action authorization; suspension/termination; historical attribution; and prevention of roster-manager impersonation or approval.

**Implementation boundary:** design only. No member-management UI, invitation/account-linking flow, user provisioning, database/schema/membership record, role grant, authentication/authorization policy, workflow engine, code, test, merge, or deployment change was made.

 
## Section 24 — Capability-based permission matrix (DEC-021 — approved design direction)

**Status:** approved design direction (owner approval: 2026-11-11); not a live implementation or permission grant.

**Proposed requirement:** separate roster management, account invitation/linking, document visibility, draft visibility, document authoring/editing, submission, review, approval, individual signing, attachment upload/primary/withdrawal, records archiving, and audit reading into distinct capabilities.

**Authorization model:** deny by default; explicitly scope each grant to authenticated account, active accepted assignment, project, party, document/revision, workflow step, and action. Re-check server-side at action time. Role title, specialty, party membership, roster presence, and project membership do not grant blanket access. Enforce separation of duties, no self-approval, no proxy signing, and no roster-manager impersonation. PM oversight remains read-only and does not grant edit/review/approval/signing authority.

**Required acceptance coverage:** roster manager cannot gain document permissions by managing the roster; PM oversight remains read-only; document viewer cannot write; reviewers/approvers/signers act only on assigned steps; signer is bound to exact frozen revision/content; suspended/ended assignments cannot act; direct API/Storage calls enforce the same rules; permission changes are independently auditable.

**Owner approval:** the capability separation, deny-by-default model, scope checks, action-time server authorization, and acceptance principles above are approved. Detailed grant/revocation authorities, party-specific role templates, permitted combinations, emergency-access controls, and final denial/audit settings remain to be specified before implementation.

**Implementation boundary:** design proposal only. No role mapping, grants, RLS/Storage policy, auth claims, DB/schema/migration, API, UI, code, tests, merge, or deployment changes.


## Section 25 — Common controlled document lifecycle framework (DEC-022 — proposed; DEC-022-A and DEC-022-B approved components)

**Controlling proposal:** [POL-DOC-001 — Controlled Document Lifecycle Design Proposal](68_DOCUMENT_LIFECYCLE_DESIGN_PROPOSAL.md).

**Status:** DEC-022 remains proposed for owner review. Its numbering component DEC-022-A and revision component DEC-022-B are approved only as recorded in Sections 26 and 27 below.

**Proposed coverage:** document-type/workflow configuration; confidential draft initiation; pre-submission validation; formal submission and immutable content snapshot; assigned review; return/correction/resubmission; approval; final records processing; controlled issue/transmittal; archive; revision and supersession.

**Required alignment:** DEC-008 draft confidentiality; DEC-009 PM read-only oversight; DEC-010 separation of duties; DEC-011 party/role boundaries; DEC-012 archive preservation; DEC-014 database safety gates; DEC-017 paper/electronic signature lifecycle; DEC-019 individual signature slots; DEC-020 authenticated Project Team Roster; DEC-021 capability-based authorization.

**Document-family isolation:** WIR remains Work Inspection Request; RFI remains Request for Information and fully separate from WIR; MQR remains Monthly Quality Report with its independent workflow and no default generic response-code behavior. POL-DOC-001 does not define final WIR/RFI/MQR state machines.

**Open decisions:** initial document-type scope and required fields; per-type action/outcome vocabulary; sequential/parallel review and quorum; return/reject/withdraw/cancel authority; resubmission revision rules; issue/transmittal model; records-control roles; retention/legal hold/paper custody; closure/reopening; and mapping of existing records.

**Acceptance coverage:** draft confidentiality; server-side capability checks; immutable submission snapshots; assigned-step actions; no self-approval/proxy/impersonation; correction history; approval vs PDF/archive separation; exact-revision transmittal; immutable superseded records; WIR/RFI/MQR isolation.

**Implementation boundary:** design proposal only except for the owner-approved numbering and revision design components DEC-022-A and DEC-022-B. No workflow engine, numbering logic, schema/DB/migration/generated type, Storage, auth/RLS/grants, UI/API/code, live-data test, merge, or deployment changes. No acceptance test is claimed as passed.


## Section 26 — Official document-number allocation (DEC-022-A — approved component)

**Status:** owner-approved design component — 2026-11-11. This does not approve the remainder of DEC-022 or POL-DOC-001.

**Approved rule:**
- Assign an internal, non-issued tracking identifier when a draft is created.
- Allocate and fix the official document number only when the first formal submission successfully passes validation and is committed.
- Abandoned drafts consume no official document number.
- The official number remains with the document through return/correction; revision numbering and increment rules remain a separate open decision.
- Upload, edit, save, comment, and validation alone do not allocate an official number.

**Authority:** explicit owner approval in conversation, 2026-11-11.

**Implementation boundary:** design approval only. No numbering logic, database/schema/migration/generated type, UI/API/code, test, merge, or deployment changes.


## Section 27 — Revision numbering and resubmission after return (DEC-022-B — approved component)

**Status:** owner-approved design component — 2026-11-11. This does not approve the remainder of DEC-022 or POL-DOC-001.

**Approved rule:**
- First formal issue is Rev.00.
- A change to controlled content after return/correction creates the next sequential revision (Rev.01, Rev.02, ...).
- Resubmission with no controlled-content change retains the same revision number.
- Each revision has its own immutable content snapshot and linked review, approval, signature, and audit history. Prior revisions remain preserved and are never overwritten/deleted.
- Signatures and approvals do not carry across revisions; changed content must complete the applicable approval/signature steps again.
- The official document number remains stable across revisions.

**Remaining detail:** minor/major revision labels and metadata-only change treatment may be specified by document-type profile without weakening the approved rules.

**Authority:** explicit owner approval in conversation, 2026-11-11.

**Implementation boundary:** design approval only. No revision engine, database/schema/migration/generated type, UI/API/code, test, merge, or deployment changes.


## Section 29 — Flexible WIR scope and item-level inspection outcomes (DEC-024 — approved requirements)

**Status:** owner-approved WIR requirements — 2026-11-11. This approves only the requirements below, not the complete WIR workflow or implementation.

**Approved scope requirements:**
- One WIR may cover one or multiple work activities and/or locations.
- Companies may consolidate several locations/activities into one WIR or create separate WIRs per location/activity.
- Location/activity selection is optional; open/general scope is supported where a precise location/activity is not known or applicable.
- No fixed one-location/one-activity-per-WIR constraint is imposed.
- Each included scope item remains individually identifiable for inspection, findings, evidence, and follow-up.

**Approved outcome requirements:**
- Inspection outcome is recorded independently per scope/inspection item.
- Some items may be accepted while other items in the same WIR require correction.
- Correction-required items remain open for corrective action and re-inspection; accepted items retain their outcomes and are not reopened or overwritten because another item needs correction.
- The WIR remains active while any item has outstanding correction, re-inspection, or other required action. Partial acceptance does not itself close the WIR.
- Findings, comments, evidence, corrective-action follow-up, and re-inspection history are linked to the relevant item; overall WIR status reflects outstanding items.
- Final closure occurs only when all applicable items have reached their required terminal disposition and no required follow-up remains, subject to detailed workflow design.

**Remaining design work:** form fields, scope-item data model, open/general scope handling, outcome vocabulary, partial acceptance, corrective-action ownership/due dates, repeated re-inspection cycles, overall status derivation, reviewer authority, evidence rules, cancellation/withdrawal, and final closure.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, live-data tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14 and DEC-024 in the Master Decision Register.


## Section 28 — Phase 1 document-type catalogue and control modules (DEC-023 — approved scope)

**Owner-approved Phase 1 controlled document types:**
- WIR — Work Inspection Request.
- MIR — Material Inspection Request.
- RFI — Request for Information / engineering clarification.
- NCR — Non-Conformance Report.
- SOR — Site Observation Report.
- DLR — Daily Labour Report.
- MQR — Monthly Quality Report.
- Snag List.
- WPR — Weekly Progress Report.
- Test Results.

**Owner-approved Phase 1 control modules (not additional document types):**
- Incoming / Outgoing Correspondence.
- Transmittals.
- Document Register.
- Archive.
- Reports & KPI.

**Required separation and traceability:**
- Each listed document type requires its own approved type profile and traceable requirements for fields, validation, permissions, numbering configuration, workflow, reporting, and retention as applicable.
- WIR and RFI remain separate in form, numbering, permissions, lifecycle, reporting, and audit. RFI is an engineering clarification, not an inspection request.
- MQR retains its independent review lifecycle and does not inherit generic A/B/C/D/E/I response codes by default.
- Correspondence and transmittals are controlled modules/records and must not silently reclassify or replace the underlying document type.
- Later document types may be added incrementally only after explicit approval.

**Acceptance criteria for future implementation:** all Phase 1 types are independently selectable and identifiable; type-specific rules are not cross-applied; module records link to the exact document/revision/party/project and audit trail; scope expansion does not rewrite historical records.

**Remaining design work:** detailed type-specific forms/fields, validation, workflow outcomes and sequence/quorum, return/reject/withdraw/cancel rules, issue/transmittal behavior, permissions, retention, closure, and legacy-record mapping.

**Implementation boundary:** DEC-023 approves requirements scope only. No schema/DB/migration/generated type, Storage, auth/RLS/grants, API/UI/code, live-data test, merge, or deployment changes are authorized or made. See POL-DOC-001 §13 and DEC-023 in the Master Decision Register.


## Section 30 — WIR item-level inspection outcome vocabulary (DEC-025 — approved requirements)

**Status:** owner-approved requirements — 2026-11-11. This approves the four outcome labels and item-level application only, not the complete WIR workflow or implementation.

**Approved outcomes for each WIR scope/inspection item:**
1. **Accepted** — the inspected item is accepted.
2. **Accepted with Comments** — the item is accepted with recorded comments that do not prevent acceptance.
3. **Requires Correction** — corrective action is required; the item remains open for correction and re-inspection.
4. **Not Ready for Inspection** — inspection could not proceed because the item/work was not ready or required prerequisites were incomplete.

**Additional rules:**
- Outcomes are recorded independently per item within a WIR.
- No separate generic **Rejected** outcome is added at this stage.
- An outcome for one item must not overwrite or force the outcome of another item.
- Overall WIR status must continue to reflect outstanding item-level correction, re-inspection, or other required follow-up, consistent with DEC-024.

**Remaining design work:** exact transition rules, whether and when Not Ready can be rescheduled, evidence/comments requirements, corrective-action ownership and due dates, repeat inspections, and overall status derivation.

**Implementation boundary:** design/requirements only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made.


## Section 31 — New WIR after Not Ready for Inspection (DEC-026 — approved requirements)

**Status:** owner-approved requirement — 2026-11-11. This approves the disposition of a Not Ready item only, not the complete WIR workflow or implementation.

**Approved rule:**
- When an inspection item is marked **Not Ready for Inspection**, the contractor must submit a new WIR for that item after the work is ready. The original item is not simply rescheduled and reused.
- Preserve the original WIR and its Not Ready result as an immutable historical record. Do not reuse the original official WIR number.
- Link the new WIR to the original WIR and specific item as a follow-up/successor reference.
- For a WIR containing multiple items, apply this rule only to the item marked Not Ready. Other items retain their outcomes and continue through their own workflow; they are not cancelled or reset by this result.
- The detailed relationship display, numbering configuration, and closure handling for the original WIR remain to be specified in the detailed WIR design.

**Implementation boundary:** design/requirements only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made.


## Section 32 — Formal WIR correction rejection and sequential re-inspection attempts (DEC-027 — approved requirements)

**Status:** owner-approved requirements — 2026-11-11.

**Approved outcome rule:**
- Keep exactly four outcomes: Accepted; Accepted with Comments; Requires Correction; Not Ready for Inspection.
- Do not add a fifth outcome or a separate selectable generic **Rejected** outcome.
- **Requires Correction** is the formal consultant rejection disposition. Preserve the rejection rationale/findings, comments, evidence, decision-maker, timestamp, and decision history while retaining the outcome label Requires Correction.

**Approved re-inspection sequence:**
- Initial request/attempt: **WIR-00**.
- First re-inspection after correction: **WIR-01**.
- Further re-inspection: **WIR-02**, continuing sequentially as needed.
- Each attempt is a new, distinct record in the same WIR series/base identity and links to its immediate predecessor.
- Preserve each attempt's outcome, findings, comments, evidence, attachments, decisions, and audit history. Never overwrite, delete, or reuse an earlier attempt.
- Apply the sequence to the affected correction-required item; accepted items in a multi-item WIR retain their own outcomes and are not reset or reopened.
- Attempt suffixes are distinct from both the official WIR document number and the content revision identifier (Rev.00/Rev.01).
- **Not Ready for Inspection** remains separate under DEC-026: after readiness, submit a new WIR with a new official number and link it to the original; do not reuse the original attempt series.

**Remaining design work:** numbering presentation/configuration, exact item-to-series relationships, and closure/status derivation in the WIR type profile.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.3 and DEC-027 in the Master Decision Register.


## Section 33 — WIR requested inspection date and optional time (DEC-028 — approved requirement)

**Status:** owner-approved WIR form requirement — 2026-11-11.

**Approved validation and capture rules:**
- Requested inspection date is mandatory for every WIR.
- Requested inspection time is optional.
- Accept both date + specific time and date-only submissions.
- A missing date blocks formal submission; a missing time does not.
- Do not infer or silently assign a time when the submitter provides date only.
- Preserve the requested date and optional time in the WIR record and audit history.

**Remaining design work:** scheduling windows, timezone display, and rescheduling rules in the WIR type profile.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.4 and DEC-028 in the Master Decision Register.


## Section 34 — Consultant-side WIR inspection engineer assignment (DEC-029 — approved requirement)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

**Approved workflow rules:**
- Contractor submission does not require selection or nomination of a consultant inspection engineer.
- After receiving the WIR, the consultant organization selects and assigns the appropriate eligible engineer or inspection team.
- Assignment considers the relevant discipline/scope, active project assignment, availability, and granted permissions.
- Record assignment and reassignment, the responsible assigner, assigned person(s), and timestamps in the WIR audit history.
- Assignment does not itself grant unrelated document access or approval capabilities.

**Remaining design work:** assignment roles, delegation, notifications, reassignment conditions, and service-level scheduling.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.5 and DEC-029 in the Master Decision Register.


## Section 35 — Flexible reassignment of the consultant inspection engineer (DEC-030 — approved requirement)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

**Approved workflow rules:**
- Consultant assignment managers may reassign an inspection to another eligible consultant engineer or team whenever operationally necessary; avoid unnecessary fixed-assignee restrictions.
- Replacement assignees must have an active project assignment and permissions relevant to the inspection scope.
- Reassignment reason is optional; absence of a reason must not block reassignment.
- Preserve immutable events containing the assigner, previous assignee(s), new assignee(s), timestamp, and any supplied reason. Keep current assignment distinguishable from assignment history.
- Do not rewrite or transfer prior findings, comments, evidence, decisions, signatures, or actor attribution.
- Assignment does not itself grant unrelated document access or approval authority.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.6 and DEC-030 in the Master Decision Register.


## Section 36 — Optional target date for WIR corrective action (DEC-031 — approved requirement)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

**Approved workflow rules:**
- For a **Requires Correction** inspection item, the consultant may specify a target completion date for the contractor's corrective action.
- The target date is optional; leaving it blank must not block the correction requirement or applicable workflow.
- If set or changed, preserve the responsible user, timestamp, and prior values in traceable history.
- The target date is for planning/control only. It does not change the inspection outcome, grant an extension, or close the corrective action.
- The contractor remains responsible for carrying out the correction.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.7 and DEC-031 in the Master Decision Register.


## Section 37 — Optional evidence of WIR corrective action (DEC-032 — approved requirement)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

**Approved workflow rules:**
- Contractor photographs/documents supporting completion of a correction are optional by default.
- Absence of an attachment must not block a correction/reinspection request.
- The consultant may request specific or additional evidence where justified by the finding or verification needs; record the request against the affected inspection item.
- Preserve evidence, uploader, timestamp, and links to the WIR series/attempt and inspection item. Do not overwrite earlier evidence.
- Evidence submission alone does not establish acceptance or close the corrective action; the applicable inspection/review decision remains necessary.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.8 and DEC-032 in the Master Decision Register.


## Section 38 — Separate correction completion from formal reinspection submission (DEC-033 — approved requirement)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

**Approved workflow rules:**
- Contractor records **Correction Completed** after carrying out the correction.
- This declaration alone does not formally submit a reinspection request or trigger consultant notification as a formal request.
- Contractor separately confirms and performs **Submit for Reinspection** to send the request formally.
- Do not automatically submit when correction is marked complete.
- Preserve the completion declaration and formal submission as separate timestamped audit events attributed to the authenticated user.
- DEC-032 evidence remains optional by default; a specifically recorded evidence requirement for the affected item may be enforced before submission.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.9 and DEC-033 in the Master Decision Register.


## Section 39 — Consultant completion request without a new inspection attempt (DEC-034 — approved requirement)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

**Approved workflow rules:**
- The consultant may request missing, unclear, or additional correction-completion information/evidence before proceeding with reinspection.
- The request must identify the affected item, specify what is needed, record the reason, author, and timestamp, and be preserved in history.
- Contractor response and evidence, followed by the separate **Submit for Reinspection** confirmation under DEC-033, remain within the current WIR correction/reinspection attempt.
- This administrative loop does not create a new attempt, increment attempt numbering, or add a fifth inspection outcome.
- Preserve requests, responses, evidence, and resubmissions as append-only history.
- The request itself is not an inspection disposition. The four DEC-025 outcomes remain unchanged.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.10 and DEC-034 in the Master Decision Register.


## Section 40 — Contractor pre-inspection withdrawal of reinspection request (DEC-035 — approved requirement)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

**Approved workflow rules:**
- The contractor who submitted the formal reinspection request may withdraw it with a reason only while the consultant has not started the inspection.
- Inspector assignment alone does not prohibit withdrawal; the decisive boundary is inspection start.
- Record the authenticated contractor actor, timestamp, affected WIR/item and attempt, withdrawal reason, and prior submission/assignment state.
- Preserve the original submission and all related activity as immutable history. Withdrawal is not deletion, an inspection outcome, or an attempt-number increment/reset.
- Once inspection has started, ordinary contractor withdrawal is unavailable. Any exceptional post-start handling requires a separately authorized process that preserves inspection activity and history.
- A later request must follow the applicable workflow and remain linked to the earlier withdrawn request.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.11 and DEC-035 in the Master Decision Register.


## Section 41 — Consultant inspection-assignment cancellation and reassignment (DEC-036 — approved requirement)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

**Approved workflow rules:**
- An authorized consultant assignment manager may cancel/revoke the current inspector assignment and reassign the inspection to another eligible engineer/team when operationally necessary.
- Replacement assignees must have an active project assignment and relevant discipline/scope permissions, consistent with DEC-029 and DEC-030.
- Assignment change does not cancel, withdraw, close, or alter the WIR; does not change the official WIR number, affected item, correction/reinspection attempt number, or recorded inspection outcome.
- Preserve actor, timestamp, previous/new assignees, assignment state changes, and any supplied reason as immutable audit history. Reason remains optional under DEC-030.
- Keep current assignment state distinct from full assignment history. Never erase prior findings, comments, evidence, decisions, signatures, or actor attribution.
- Assignment changes do not grant unrelated permissions or bypass inspection workflow/capability checks. Contractor users cannot change consultant assignments.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.12 and DEC-036 in the Master Decision Register.


## Section 42 — Separate WIR-level and inspection-item statuses (DEC-037 — approved requirement)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

**Approved overall WIR lifecycle statuses:**
- Draft
- Submitted
- Assigned
- In Progress
- Awaiting Contractor Action
- Awaiting Reinspection Submission
- Reinspection Submitted
- Closed
- Withdrawn

**Approved item-level workflow statuses:**
- Pending Inspection
- Inspection In Progress
- Awaiting Contractor Correction
- Awaiting Reinspection Submission
- Reinspection Submitted
- Completed

**Item-level inspection outcomes remain exactly the four DEC-025 outcomes:** Accepted, Accepted with Comments, Requires Correction, and Not Ready for Inspection. Item statuses describe workflow progress and do not add or replace outcomes.

**Integrity rules:**
- A multi-item WIR may have completed items alongside active items. Overall WIR status must reflect outstanding work and must not show Closed while any item still requires action.
- Not Ready remains governed by DEC-026: preserve the original item/outcome and create a new linked WIR when ready.
- Requires Correction remains active through correction/reinspection until resolved by the applicable inspection decision.
- Status transitions are controlled workflow events, not free-text edits; preserve actor, timestamp, source action, WIR/item/attempt linkage as immutable history.
- Maintain consistency with DEC-024 through DEC-036.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.13 and DEC-037 in the Master Decision Register.


## Section 43 — WIR notification channels and user preferences (DEC-038 — approved requirement)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

**Approved rules:**
- In-app notifications are the mandatory primary channel for authorized WIR workflow events.
- Email is optional per user and controlled through individual notification preferences.
- Disabling email must not suppress mandatory in-app notifications.
- Route notifications only to relevant authorized recipients, respecting project assignment, party, discipline, document visibility, and event relevance. Never disclose drafts or unauthorized information.
- Clearly distinguish action-required notifications from informational updates.
- Retain in-app notification history and read/unread state. Channel preferences do not change WIR workflow decisions or audit records.
- Detailed event-to-recipient mapping, urgency, batching/deduplication, delivery retry/failure handling, and other channels remain open for later design. DEC-038 does not approve SMS, push, or other channels.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.14 and DEC-038 in the Master Decision Register.


## Section 44 — WIR notification priority and acknowledgement (DEC-039 — approved requirement)

**Status:** owner-approved WIR notification requirement — 2026-11-11.

**Approved priority levels:**
- **Critical:** high-impact workflow decisions/events affecting the WIR lifecycle or requiring prompt awareness; prominently distinguished and promptly delivered to authorized relevant recipients.
- **Action Required:** identifies a task or response required from the recipient, such as correction, requested information/evidence, assignment acceptance, or another required workflow step.
- **Informational:** useful updates that do not require recipient action.

**Approved acknowledgement and retention rules:**
- Preserve priority, event reference, recipient, timestamps, and read/unread state.
- Reading a Critical notification does not delete it or remove it from history. It may be marked read/acknowledged and remain retrievable.
- Reading an Action Required notification does not complete the underlying WIR action. Keep it distinguishable until the action is completed or validly resolved.
- Preserve underlying WIR events and audit history independently from notification state.

**Noise control:**
- Non-urgent informational updates may be batched/deduplicated only when no material event is hidden.
- Critical and time-sensitive Action Required notifications must not be delayed or suppressed by informational batching.
- Detailed event-to-priority mapping, escalation, retries, and presentation remain open for later design.
- No SMS, push, or other additional channel is approved; DEC-038 remains controlling.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.15 and DEC-039 in the Master Decision Register.


## Section 45 — Central WIR Notification Matrix (DEC-040 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

The central WIR Notification Matrix maps each relevant workflow event to:
- intended recipient(s), resolved only among authorized and relevant users;
- priority: Critical, Action Required, or Informational;
- whether a recipient action is required;
- the underlying workflow action that resolves the notification.

**Baseline event mapping:**
- Formal WIR submission → authorized consultant intake/discipline team; Action Required; triage/assignment.
- Inspector assignment → newly assigned engineer/team; Action Required; perform assigned step.
- Assignment change → new assignee Action Required; previous assignee and assignment manager Informational, as relevant.
- Inspection start → relevant contractor contact/team; Informational.
- Requires Correction → responsible contractor users; Action Required; correction and subsequent inspection decision.
- Not Ready for Inspection → relevant contractor users; Action Required; readiness and a new linked WIR under DEC-026.
- Request for correction details/evidence → responsible contractor users; Action Required; provide response and separately submit for reinspection where applicable.
- Correction Completed without formal reinspection submission → consultant assignee/team; Informational only; does not constitute formal resubmission.
- Formal Submit for Reinspection → current consultant assignee/team; Action Required.
- Pre-start contractor withdrawal → relevant consultant assignee/team; Informational.
- Inspection result → relevant authorized contractor users; Critical for formal disposition, with Action Required follow-up where correction/readiness action is required; otherwise Informational as applicable.
- WIR closure → relevant authorized parties/users; Informational.

**Matrix-wide controls:**
- Resolve recipients using active project assignment, party, discipline, item responsibility, document visibility, and relevant capability at event time. Project membership alone is insufficient.
- Do not reveal drafts or unauthorized content in notification previews.
- Reading/opening a notification does not complete the underlying workflow action.
- Preserve event, recipient, priority, delivery, and read/action-resolution history.
- Critical events remain prompt and retained. Non-urgent informational events may be batched/deduplicated only when no material event is hidden.
- Exact role mapping, templates, escalation/SLA, retry and delivery-failure handling remain open design work. Email remains optional under DEC-038; SMS/push are not approved.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.16 and DEC-040 in the Master Decision Register.


## Section 46 — Central in-app WIR Notification Center (DEC-041 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Approved capabilities:**
- A centralized chronological in-app notification feed.
- Views: **All**, **Unread**, **Action Required**, and **Critical**.
- Filters by project, document type, and date, restricted to the user's authorized scope.
- Each notification shows what happened, its priority, relevant WIR/item context where permitted, and the exact expected action when action is required.
- Navigation to a related WIR/item is permitted only after current server-side access authorization is rechecked.
- Preserve notification history and read/unread state. Reading/opening does not complete the underlying WIR action; Action Required resolves only through the linked authorized workflow action or valid supersession.
- Notification presentation remains distinct from authoritative WIR/item status and audit history.

**Confidentiality controls:**
- No draft or unauthorized content in notification titles, previews, counts, filters, or navigation.
- Recheck access at navigation time; a notification must not become a route around revoked or changed permissions.
- Email remains optional under DEC-038; the in-app Notification Center remains mandatory.

**Open design details:** exact layout, pagination/retention policy, search, bulk read actions, accessibility, mobile presentation, and history-retention period.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.17 and DEC-041 in the Master Decision Register.


## Section 47 — WIR Action Reminders and Escalation Policy (DEC-042 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Approved policy:**
- Reminders apply only to unresolved **Action Required** WIR actions. Informational notifications do not trigger reminders.
- Critical notifications are delivered promptly; no reminder cadence, batching, or quiet-hour rule may delay their initial delivery.
- Remind only the currently responsible authorized recipient(s), with safe WIR/item context and a due/target date only where one actually exists.
- Escalate unresolved actions after a configurable threshold to designated authorized project/party/workflow roles only.
- Escalation is for visibility/accountability. It does not transfer responsibility, grant capabilities, reassign inspectors, or execute/approve/close any workflow action.
- Reading/opening/acknowledging a notification alone does not resolve the underlying action or reset its deadline.
- Stop reminders when the authoritative action is completed, validly superseded, withdrawn, or no longer required. Reassignment stops future notices to the former assignee and resolves the new authorized recipient; retain historical records.
- Preserve trigger, policy version, recipient, delivery attempts/results, reminder sequence, escalation event, timestamps, and stop/pause/resume reasons. Deduplicate processing and define bounded retry behavior.
- In-app notifications remain mandatory; email remains optional under DEC-038; SMS/push are not approved.

**Still open:** exact reminder intervals, escalation thresholds/roles, project calendars and time zones, quiet hours, retry limits, overdue behavior without a target date, recipient unavailability, holiday handling, and delivery-failure escalation. All timing/role rules require configurable, versioned, separately approved policy. **No fixed numeric SLA or contractual deadline is approved.**

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, scheduler/automation, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.18 and DEC-042 in the Master Decision Register.


## Section 48 — WIR Role-Based Dashboard and Performance Monitoring (DEC-043 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Approved dashboard direction:**
- **Contractor:** authorized WIRs/items, submissions, correction actions, correction evidence, reinspection submissions, target dates where recorded, and history.
- **Consultant:** authorized intake/triage, unassigned submissions, assigned inspections, in-progress work, pending decisions, reinspection submissions, and date/policy-grounded overdue or at-risk actions.
- **Project Manager:** supervisory project overview within authorized visibility, including permitted draft visibility, but read-only. No implied edit, assignment, inspection, review, approval, signature, or closure authority.
- Other roles receive only their explicitly authorized scope.

**Metrics and integrity:**
- Display WIR-level status and item-level status separately; distinguish statuses, the four DEC-025 outcomes, attempt sequence under DEC-027, and document revision.
- Aging/overdue indicators require a valid recorded date or separately approved SLA. A DEC-031 target completion date is not automatically a contractual due date or SLA.
- Derive metrics from authoritative workflow records/events, not notification read state or client assumptions.
- Separate contractor-controlled, consultant-controlled, and neutral/waiting durations. Define KPI numerator, denominator, exclusions, time basis, grouping, and reporting period before implementation.
- Do not misclassify Not Ready, count DEC-034 information/evidence completion as a new inspection attempt, or rank parties/individuals using uncontextualized raw counts.
- Filters, cards, drill-down, and future exports must enforce current server-side authorization and confidentiality; stale aggregates must be clearly identified.

**Still open:** exact layouts, charts, KPI formulas/thresholds, refresh cadence, time-zone/calendar rules, export formats, saved views, and aggregate snapshot retention. No SLA, contractual deadline, performance target, or KPI threshold is approved.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, analytics pipeline, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.19 and DEC-043 in the Master Decision Register.


## Section 49 — Reports & Analytics: WIR Reporting Foundation (DEC-044 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Initial WIR report catalogue:**
- WIR register/status.
- Inspection results using only the four approved DEC-025 outcomes.
- Correction and reinspection, including DEC-034 information/evidence follow-up without incorrectly counting a new attempt.
- Not Ready cases and linked new WIRs under DEC-026, kept distinct from Requires Correction.
- Workload, assignment, and reassignment.
- Stage aging/turnaround, with contractor, consultant, and neutral waiting time separated.
- Trends and recurrence by period/project/discipline where classification is sufficiently consistent.

**Governance requirements:**
- Each report defines source, row grain (WIR/item/attempt/event), filters, numerator/denominator, exclusions, date basis/timezone, and freshness.
- Keep WIR status, item status, inspection outcome, attempt sequence, and revision separate.
- Use authoritative workflow and audit data, not notification read state or cached assumptions.
- No overdue claim without a valid recorded date or separately approved SLA. DEC-031 target dates are not automatically contractual deadlines.
- No uncontextualized ranking or KPI threshold; no performance target, SLA, or contractual deadline is approved.
- Enforce current server-side authorization across queries, filters, aggregates, drill-downs, and exports. Prevent aggregate leakage and draft/party/project data exposure.
- PDF and spreadsheet exports are intended; exact templates, safe text/formula handling, export audit, and authorization controls remain open.
- Other Phase 1 modules need their own report definitions. Payment Certificates and financial reporting are explicitly deferred to a separately designed financial module.

**Still open:** exact layouts/columns, KPI formulas, charts, taxonomy, refresh cadence, retention, export templates, role mapping, and any scheduled distribution. No scheduled email distribution or new channel is approved.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, analytics/reporting pipeline, export service, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.20 and DEC-044 in the Master Decision Register.


## Section 50 — Official Report Templates and Controlled Report Outputs (DEC-045 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Approved template direction:**
- Standard report identity and structure: project/authorized branding, title/type/reference, reporting period, generation timestamp, scope/filters, date basis/timezone, data freshness, report-specific content, references/appendices, and report version/change history.
- Prepared/Reviewed/Approved attribution is shown only for actions actually completed by authenticated and authorized people. Report generation is not approval; approval of a report is distinct from approval of its source WIRs. No decorative signature images or assumed electronic signature.
- Clearly distinguish Draft/Preview from Official Generated Report. Preserve official outputs as immutable, reproducible snapshots or equivalent records tied to the report-definition version, exact scope, filters, timezone, and generation context. Regeneration/correction creates a traceable new output, never a silent overwrite.
- PDF is intended to be print-ready. Spreadsheet output must be structured, usable, and protected against formula injection from untrusted/formula-like values.
- Enforce current server-side authorization at preview, generation, download, and distribution. Audit actor, timestamp, report type/definition version, authorized scope, filters, format, output identity/hash where available, and delivery outcome.
- Reports are derivative records and must not change source WIR/document status, outcomes, attempts, revisions, approvals, or audit history.
- Apply initially to WIR reports under DEC-044. Other Phase 1 modules require their own report-specific templates and definitions. Payment Certificates and financial reporting remain excluded pending separate approval.

**Open design details:** report-specific templates/fields; branding asset governance; report numbering/versioning; snapshot storage/retention; formal report review/approval; electronic-signature requirements; distribution workflow and recipients; spreadsheet column schemas and safe-value handling; print layouts; multilingual and accessibility support.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, reporting pipeline, export service, scheduler, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.21 and DEC-045 in the Master Decision Register.


## Section 51 — Official Report Review, Approval, Issue, and Distribution Lifecycle (DEC-046 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Approved lifecycle direction:**
- Keep report states distinct: Draft/Preview, Submitted for Report Review, Under Review, Returned for Correction, Approved, Issued, Distributed, and Superseded/Withdrawn where applicable. These are report states, not WIR workflow states.
- Review and approval bind to one exact immutable report snapshot and report-definition version, including scope, filters, date basis/timezone, generation context, and output identity/hash where available.
- Material changes after submission require a new snapshot and applicable review cycle. Approval/signature from an earlier snapshot never transfers. Issued reports are not silently edited or deleted; correction creates a linked new issue or authorized withdrawal with preserved history.
- Preparation, review, approval, issue, and distribution are distinct capabilities. Apply DEC-021 deny-by-default, current server-side authorization, active assignment/scope, and separation-of-duties rules. No self-approval or proxy action is assumed. PM visibility remains read-only unless a separate explicit capability is approved.
- Issue only after required report approval and records checks. Distribute only to explicitly authorized recipients; no default broadcast to all project members.
- Record exact report version/snapshot, recipient/destination, actor or authorized process, authority, channel, timestamp, and delivery outcome. Recheck access at distribution and later preview/download. No public links, specific delivery channel, scheduled distribution, or email attachment route is approved by this decision.
- Preserve append-only submission, review, return, correction, approval, issue, distribution, withdrawal, and supersession events, including prior snapshots and recipient history.
- Report lifecycle actions never change WIR/source-document status, outcomes, attempts, revisions, approvals, or audit history.

**Open design details:** report-specific approval gates and role mapping; separation-of-duty combinations; reviewer assignment/reassignment; return/correction classifications; numbering and supersession conventions; recipient resolution; delivery channels and link security; acknowledgement semantics; retry/failure behavior; retention/legal hold; and report types that may be informational-only.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, reporting/export/distribution service, scheduler, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.22 and DEC-046 in the Master Decision Register.


## Section 52 — Controlled Document and Official Report Registers (DEC-047 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Approved register direction:**
- Maintain a controlled Document Register for source project documents and a distinct Official Report Register for generated report outputs. A shared navigation/search experience is acceptable only if record classes, identifiers, numbering, workflows, permissions, and histories remain distinct.
- Document entries show authorized authoritative metadata: project, document type/number, title, originating party, discipline where applicable, revision, status dimensions, key dates, and controlled related-record links.
- Report entries show authorized report type/reference/version, reporting period, generation timestamp/context, definition/snapshot version, report lifecycle state, issue date, and distribution summary.
- Search, filters, counts, suggestions, previews, drill-downs, downloads, and exports must enforce current server-side authorization and must not leak unauthorized record existence or aggregates.
- Register entries derive from authoritative source records/events. Stable identities and histories remain traceable through revisions, supersession, withdrawal, report regeneration, and reissue. Index/cache delays must be disclosed; stale summaries must not be represented as authoritative real-time status.
- Register visibility does not grant access to underlying files, drafts, revisions, comments, signatures, audit events, or workflow actions. PM supervisory access remains read-only under DEC-021.
- Reports remain derivative records and do not create source-document revisions or approvals. WIR, RFI, MQR, and other document families retain their distinct semantics. Financial registers remain excluded pending separate approval.

**Open design details:** exact columns and mandatory metadata by type; register ownership; numbering display/search rules; advanced search/saved filters; pagination/sorting; indexing/freshness; retention/legal-hold presentation; bulk actions; export formats/templates; and report-to-source scope link granularity.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, search/indexing service, reporting pipeline, export service, tests, merge, or deployment changes are authorized or made. See POL-DOC-001 §14.23 and DEC-047 in the Master Decision Register.


## Section 53 — Advanced Document Search and Retrieval (DEC-048)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-048 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.24.
- **Related baseline:** DEC-021 (authorization and capability boundaries), DEC-047 (controlled document and official report registers), DEC-022-B (revision identity), DEC-026/027 (WIR linkage and attempt identity), DEC-040/041 (notification confidentiality and navigation), DEC-044/045/046 (reports, outputs, and report lifecycle).
- **Required future evidence:** search acceptance tests must cover exact/partial matching, typed relationship navigation, historical retrieval, Arabic/English handling once specified, stale-index behavior, permission revocation, and non-disclosure through results, counts, facets, suggestions, snippets, previews, pagination, and exports. Tests must include direct-resource authorization rechecks and cross-party/project negative cases.
- **Implementation status:** not implemented. No search index, database/schema/migration/generated type, Storage, RLS/grant, API/UI/code, OCR, cache, export service, test suite, merge, or deployment change is authorized or recorded by this decision.

**Open traceability items:** detailed field matrix by document family; search language/normalization specification; relevance and matching rules; index freshness and invalidation guarantees; archive/OCR scope; saved-search and bulk-export controls; and role-specific UX. Each must be resolved in a separately reviewed design/implementation plan before engineering work.


## Section 54 — Document and Report Notifications (DEC-049)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-049 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.25.
- **Related baseline:** DEC-021 (authorization/capability boundaries), DEC-038–DEC-042 (WIR notification, center, reminders and escalation), DEC-045/046 (official report outputs and lifecycle), DEC-047 (registers), DEC-048 (search and retrieval).
- **Required future evidence:** per-family event/priority/recipient matrices; negative tests for cross-party/project and revoked access; no leakage through counts, previews, snippets, email or grouped summaries; read/acknowledge does not resolve workflow actions; delivery retry deduplication preserves distinct business events; Critical/urgent Action Required is not delayed by batching; report events bind to exact snapshot/version; and reminder/escalation behavior follows approved policy without invented SLA.
- **Implementation status:** not implemented. No notification infrastructure, schema, scheduler, API/UI, provider integration, auth policy, tests, merge, or deployment change is authorized or recorded by this decision.

**Open traceability items:** event catalogues, priority and recipient mapping per module; message templates/localization; preference model; aggregation and delivery guarantees; reminder/escalation configuration; email security; retention; and operational monitoring. Resolve through separately reviewed designs before implementation.


## Section 55 — Document Transmittals & Distribution Control (DEC-050)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-050 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.26.
- **Related baseline:** DEC-021 (authorization/capability boundaries), DEC-045/046 (official report outputs and lifecycle), DEC-047 (registers), DEC-048 (search and retrieval), DEC-049 (document/report notifications).
- **Required future evidence:** immutable manifest bound to exact source revisions/report snapshots; negative tests for unauthorized recipients and revoked access; proof that Transmittal does not grant source access; per-recipient delivery/partial-failure accounting; distinction between technical receipt and human acknowledgement; bounded deduplicated retries; exact-package re-send and supersession history; and audit evidence for sender authority, recipient resolution, dispatch, outcomes, and acknowledgements.
- **Implementation status:** not implemented. No database/schema/migration/generated types, storage changes, auth/RLS/grants, API/UI, delivery provider/channel integration, tests, merge, or deployment change is authorized or recorded by this decision.

**Open traceability items:** numbering and role mapping; record-family issue gates; recipient and external identity resolution; acknowledgement and legal effect; channels and secure-link controls; packaging; retry/failure and partial delivery; reissue/supersession/cancellation; retention/legal hold; localization; and operational monitoring. Resolve through separately reviewed designs before implementation.


## Section 56 — Controlled Document Distribution & Access Receipts (DEC-051)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-051 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.27.
- **Related baseline:** DEC-021 (authorization/capability boundaries), DEC-045/046 (official report outputs and lifecycle), DEC-047/048 (registers and search), DEC-049 (document/report notifications), DEC-050 (controlled Transmittals and distribution).
- **Required future evidence:** exact-version manifest binding; recipient-isolation and revoked-access negative tests; proof that Transmittal references do not grant access; distinct event evidence for open/preview/download initiation/completion/denial; acknowledgement not inferred from technical access; append-only access history; revocation behavior for active sessions/tokens; supersession without manifest mutation; and proof that already downloaded copies are not falsely represented as remotely recalled.
- **Implementation status:** not implemented. No identity/auth/session/token, signed URL, storage, schema/database, RLS/grants, API/UI, telemetry, notification provider, tests, merge, or deployment change is authorized or recorded by this decision.

**Open traceability items:** external identity proofing, authentication strength, secure viewer/download, token/session lifecycle, event taxonomy, telemetry minimization, acknowledgement semantics, visibility, supersession/revocation notifications, retention/legal hold, audit export, and any legal/contractual evidentiary effect. Resolve through separately reviewed security and operational designs before implementation.


## Section 57 — Document Acknowledgement & Response Management (DEC-052)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-052 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.28.
- **Related baseline:** DEC-021 (authorization/capability boundaries), DEC-038–042 (WIR notifications/reminders), DEC-045/046 (official report lifecycle), DEC-049 (document/report notifications), DEC-050 (Transmittals), DEC-051 (access receipts).
- **Required future evidence:** tests proving delivery/access/acknowledgement/formal response/source decision remain distinct; non-response never implies acceptance; per-recipient response requirement and exact manifest binding; authenticated actor/capability checks; immutable response history and linked corrections; draft confidentiality; authorized routing; and reporting that does not infer completion from access telemetry.
- **Implementation status:** not implemented. No schema/database/notification/auth/RLS/API/UI/storage/workflow automation, tests, merge, or deployment change is authorized or recorded by this decision.

**Open traceability items:** family-specific response taxonomy, acknowledgement requirements, recipient routing, response forms/evidence, clarification/review cycles, due-date semantics, reminder thresholds, external identity, correction/withdrawal rights, retention/legal hold, localization, metrics, and legal/contractual effect. Resolve through separately reviewed designs before implementation.


## Section 58 — Document Revision, Supersession & Withdrawal Control (DEC-053)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-053 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.29.
- **Related baseline:** DEC-021 (authorization/capability boundaries), DEC-022-A/B (official numbering and revision rules), DEC-045/046 (official report outputs and lifecycle), DEC-047/048 (registers and search), DEC-049 (notifications), DEC-050 (Transmittals), DEC-051 (access receipts), DEC-052 (acknowledgements/responses).
- **Required future evidence:** immutable revision snapshots and identity links; tests distinguishing latest-created from current-effective revision; no silent latest-version substitution; material-change classification evidence; authorized withdrawal gates and immutable history; preservation of prior approvals/signatures/transmittals/access/response records; recipient impact and notification traceability; revoked/stale link and cache negative tests; and accurate historical register/report states.
- **Implementation status:** not implemented. No schema/database/files/storage/auth/RLS/API/UI/numbering/workflow/notification/search/index changes, tests, merge, or deployment change is authorized or recorded by this decision.

**Open traceability items:** family-specific change taxonomy, numbering exceptions, effective issue gates, withdrawal authority, draft cancellation, temporary hold/suspension and reinstatement, linked workflow impact, recipient instructions, retention/legal hold, historical access, cache/link invalidation, and register/report semantics. Resolve through separately reviewed designs before implementation.


## Section 59 — Document Retention, Archiving & Legal Hold (DEC-054)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-054 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.30.
- **Related baseline:** DEC-021 (authorization/capability boundaries), DEC-045/046 (official report outputs and lifecycle), DEC-047/048 (registers and search), DEC-049 (notifications), DEC-050 (Transmittals), DEC-051 (access receipts), DEC-052 (acknowledgements/responses), DEC-053 (revision/supersession/withdrawal).
- **Required future evidence:** approved record-class schedule catalogue and source requirements; reproducible retention trigger calculations; preservation of linked records and provenance; archive integrity verification; legal-hold scope and multi-hold tests; blocked disposition evidence; authorized disposition approval and separation of duties; verified deletion limitations across replicas/indexes/backups; privacy/access controls for hold metadata; and append-only audit.
- **Implementation status:** not implemented. No schema/database/storage lifecycle/deletion/backup/restore/archive/hold tooling/auth/RLS/API/UI/retention jobs/disposition/destruction, tests, merge, or deployment change is authorized or recorded by this decision.

**Open traceability items:** record taxonomy/schedules and jurisdictional sources; trigger calculations; archive tiers and format preservation; integrity checks; backup lifecycle; hold authority/scope/review/release; multiple holds; disposition approvals; deletion limitations; retained audit metadata; privacy requests; reporting; and monitoring. Resolve through separately reviewed legal, contractual, security, and records-management designs before implementation.


## Section 60 — Document Audit Trail & Accountability (DEC-055)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-055 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.31.
- **Related baseline:** DEC-021 (capability authorization and actor accountability), DEC-022 (official numbering/revisions), DEC-045/046 (report snapshots and lifecycle), DEC-047/048 (register/search), DEC-049 (notifications), DEC-050/051/052 (Transmittals, access receipts, acknowledgements/responses), DEC-053 (revision/supersession/withdrawal), DEC-054 (retention/archive/legal hold).
- **Required future evidence:** approved event catalogue and schema; actor/authority attribution tests; exact record/revision linkage; before/after change evidence and sensitive-data redaction; failed/denied event coverage; causal ordering/correlation; tamper-evidence verification; critical action/audit atomicity and recovery tests; authorized audit review/export controls; retention/hold enforcement; and incident reconciliation.
- **Implementation status:** not implemented. No audit schema/table/triggers/pipeline/database/storage/cryptographic implementation/auth/RLS/API/UI/monitoring/backfill/tests/merge/deployment change is authorized or recorded by this decision.

**Open traceability items:** event taxonomy/mandatory coverage; change capture and redaction; actor/session/service attribution; timestamp/timezone/offline behavior; ordering/correlation; tamper-evidence architecture; transactional audit failure/recovery; security monitoring; audit access roles; retention/legal holds; export/evidence format; privacy; and incident reconciliation. Resolve through separately reviewed security, privacy, legal, architecture, and records-management designs before implementation.


## Section 61 — System Administration, Configuration & Governance Control (DEC-056)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-056 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.32.
- **Related baseline:** DEC-021 (capability authorization and separation of duties), DEC-022 (numbering/revision rules), DEC-045/046 (report definitions and lifecycle), DEC-047/048 (register/search), DEC-049 (notifications), DEC-053 (revision/supersession/withdrawal), DEC-054 (retention/archive/legal hold), DEC-055 (audit trail/accountability).
- **Required future evidence:** configuration taxonomy and risk classification; accountable owner/authority matrix; explicit inheritance and override rules; versioned proposal/review/approval/activation evidence; exact candidate version/hash binding; impact assessment; validation and negative authorization tests; in-flight transaction transition tests; historical non-retroactivity and identifier stability; rollback as a new audited activation; emergency-access review; secret-redaction checks; and baseline drift/health reporting.
- **Implementation status:** not implemented. No configuration schema/tables/migrations/generated types/settings UI/auth/RLS/workflow/numbering/feature flags/secret management/environment promotion/data migration/tests/merge/deployment change is authorized or recorded by this decision.

**Open traceability items:** configuration taxonomy/risk tiers, owner/authority matrix, inheritance/precedence, lifecycle gates, version/hash, effective-date/timezone, in-flight transition, validation/testing, activation/recovery, emergency process, environment promotion, secret management, drift detection, register/report, and communication. Resolve through separately reviewed security, architecture, operational, and governance designs before implementation.


## Section 62 — Integration, API & External System Governance (DEC-057)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-057 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.33.
- **Related baseline:** DEC-021 (authorization/separation of duties), DEC-022 (numbering/revision), DEC-049 (notifications), DEC-050/051/052 (Transmittals, access receipts, acknowledgements/responses), DEC-053 (revision/supersession/withdrawal), DEC-054 (retention/archive/legal hold), DEC-055 (audit), DEC-056 (configuration governance).
- **Required future evidence:** integration inventory and approval per connector; data-flow and ownership maps; API contract/version compatibility; service identity and scoped authorization tests; negative access and no-impersonation tests; import validation and provenance; export exact-version controls; idempotency/duplicate and concurrency tests; webhook authentication/replay/out-of-order handling; retry/dead-letter/reconciliation evidence; partial-failure reporting; secret redaction; retention/legal-hold controls; incident/revocation and decommissioning tests.
- **Implementation status:** not implemented. No API endpoints, integration credentials, service accounts, webhooks, external connections, imports/exports, synchronization jobs, schema/database/storage/auth/RLS/grants/UI, tests, merge, or deployment change is authorized or recorded by this decision.

**Open traceability items:** integration catalogue/risk tiers; API resources/contracts; authentication/authorization profiles; service identity lifecycle; quotas; idempotency/concurrency; webhook security; file exchange; data mapping/ownership/conflict; event ordering; retry/reconciliation; monitoring/service objectives; privacy/residency; external-copy obligations; incident response; decommissioning; and per-integration approvals. Resolve through separately reviewed architecture, security, privacy, legal, and operational designs before implementation.


## Section 63 — Data Import, Export & Migration Governance (DEC-058)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-058 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.34.
- **Related baseline:** DEC-021 (authorization/separation of duties), DEC-022 (numbering/revisions), DEC-038–042 (notifications and action handling), DEC-045/046 (official report snapshots and lifecycle), DEC-047/048 (register/search), DEC-049 (document/report notifications), DEC-050/051/052 (Transmittals, access receipts, acknowledgements/responses), DEC-053 (revision/supersession/withdrawal), DEC-054 (retention/archive/legal hold), DEC-055 (audit/accountability), DEC-056 (configuration governance), DEC-057 (integration/API governance), and the existing end-to-end import pipeline remediation plan.
- **Required future evidence:** approved data dictionary and source-to-target mappings; operation-specific business/data-owner authorization; immutable batch and item manifests; source provenance and stable identifiers; schema/reference/relationship validation; duplicate/conflict classification and human reconciliation; legacy status/approval mapping review; attachment byte/hash/binding verification; isolated staging and representative rehearsal; idempotent retry and partial-failure tests; source/target count and hash reconciliation; exact-version export authorization; formula-injection and destination-security tests; migration cutover and recovery rehearsal; rollback/forward-correction decision evidence; exception ownership; retention/legal-hold enforcement; and accountable data-owner acceptance.
- **Implementation status:** not implemented. No import/export job, migration, database/storage mutation, backup/restore, schema/mapping code, API/UI/auth/RLS/grant, file transfer, production data processing, tests, merge, or deployment change is authorized or recorded by this decision.

**Open traceability items:** canonical data dictionary and record-class mappings; supported formats; duplicate/conflict resolution; legacy status/approval mapping; source-of-truth ownership; staging/quarantine architecture; batch atomicity/idempotency; volume/rate limits; encryption/destination controls; migration cutover/change capture; rollback/reconciliation acceptance; export-package expiry; temporary-data disposal; and operation-specific approval matrix. Resolve through separately reviewed data, security, privacy, legal, architecture, and operational designs before implementation.


## Section 64 — System Backup, Disaster Recovery & Business Continuity (DEC-059)

**Status:** owner-approved design direction — 2026-11-11.

**Traceability:**
- **Source decision:** DEC-059 in the Master Decision Register.
- **Design specification:** POL-DOC-001 §14.35.
- **Related baseline:** DEC-021 (authorization/separation of duties), DEC-054 (retention/archive/legal hold), DEC-055 (audit/accountability), DEC-056 (configuration governance), DEC-057 (integration governance), DEC-058 (import/export/migration), and the isolated database security audit and end-to-end import pipeline remediation plans.
- **Required future evidence:** approved component/dependency inventory; business-impact analysis and owner-approved recovery objectives; database and object-storage backup coverage with consistency evidence; backup encryption/key custody and immutability controls; independent integrity verification; last-known-good tracking and failure alerts; isolated database-plus-storage restore rehearsals; schema/policy/count/referential-integrity checks; attachment byte/hash/link verification; signature/report/audit continuity checks; recovery-point gap and post-backup activity reconciliation; credential/identity/provider recovery evidence; DR/BC scenario exercises; manual continuity and post-recovery reconciliation tests; failover/failback and split-brain safeguards; restore authorization and separation-of-duties evidence; legal-hold/retention enforcement; and accountable business-owner acceptance.
- **Implementation status:** not implemented. No backup job, provider configuration, database export/restore, storage copy/replication, encryption-key operation, failover, production recovery, infrastructure change, schema/database/storage/auth/RLS/API/UI modification, test execution, merge, or deployment change is authorized or recorded by this decision.

**Open traceability items:** business-impact analysis and criticality tiers; component inventory and architecture; backup technology/provider; frequency and retention; RPO/RTO; geographic/residency requirements; immutability and key custody; database/object-storage consistency; restore order; reconciliation/replay; failover/failback; manual continuity; activation authority; test cadence/evidence; recovery acceptance; operational ownership/cost. Resolve through separately reviewed architecture, security, legal, privacy, provider, and business-continuity designs before implementation.

## Section 65 — DEC-060 Implementation Traceability: System Monitoring, Logging, Alerting & Operational Observability

**Decision reference:** DEC-060  
**Design source:** `docs/68_DOCUMENT_LIFECYCLE_DESIGN_PROPOSAL.md`, §14.36  
**Register source:** `docs/01_MASTER_DECISION_REGISTER.md`, DEC-060

| Traceability area | Required design evidence | Implementation status |
|---|---|---|
| Scope and component coverage | Inventory of application, API, DB, storage, auth, jobs/queues, notifications, integrations, reports/exports, backup/restore/DR, infrastructure and provider dependencies | Design requirement recorded; inventory open |
| Evidence classification | Separation of logs, metrics, traces, security events, workflow events, DEC-055 audit, alerts and dashboards | Design requirement recorded |
| Telemetry integrity and context | Structured events, correlation, UTC timestamps, clock-drift handling, safe actor/service identity, outcomes and durations | Design requirement recorded; schemas open |
| Privacy and access | Data minimization, redaction, secret exclusion, classification, least privilege, controlled exports | Design requirement recorded; detailed policy open |
| Monitoring catalogue | Availability, latency, errors, saturation, DB/storage, queues/jobs, auth, integrations, notifications, reports, backup/restore and integrity indicators | Candidate coverage recorded; definitions and owners open |
| Alerting | Operational severity distinct from DEC-039, thresholds, deduplication, suppression, escalation, recovery, authorized routing | Design requirement recorded; catalogue and thresholds open |
| Health and dashboards | Liveness/readiness/dependency checks, role-based dashboards, freshness disclosure, safe public responses, PM read-only | Design requirement recorded; layouts open |
| Tracing | Distributed correlation and sampling controls; traces not sole audit/security evidence | Design requirement recorded; architecture open |
| Security and incidents | Anomaly detection, evidence preservation, authorized incident response, no autonomous workflow/permission/numbering actions | Design requirement recorded; runbooks open |
| Pipeline resilience | Buffering, backpressure, loss detection, storage exhaustion, monitoring-of-monitoring, DEC-055 audit reliability | Design requirement recorded; architecture open |
| Governance dependencies | DEC-054 retention/legal hold; DEC-055 audit; DEC-056 configuration; DEC-057 integrations; DEC-059 backup/DR | Cross-references recorded |
| Operational targets | SLI/SLO/SLA, thresholds, on-call, response times, RPO/RTO | Explicitly not approved by DEC-060 |
| Implementation evidence | Tool/agent installation, provider configuration, telemetry schema, deployed dashboards/alerts, production tests | Not authorized; no implementation claimed |

**Verification boundary:** this section records design traceability only. It does not establish that monitoring exists, is configured, is active, or has been tested.

**Implementation boundary:** no monitoring agent/tool installation, infrastructure/provider configuration, code/API/database/storage/auth/RLS modification, telemetry schema, alert/dashboard deployment, integration credential, automated remediation, production test, merge, or deployment is authorized or recorded by DEC-060.

**Open traceability items:** component inventory and owners; monitoring architecture/provider; event and severity taxonomy; metric definitions and thresholds; SLI/SLO/SLA; alert routing/on-call and channels; escalation/maintenance windows; tracing/sampling; telemetry residency/encryption/retention; dashboards; security detection and incident runbooks; synthetic checks; pipeline resilience; operational ownership and cost.

## Section 66 — DEC-061 Implementation Traceability: Incident Management & Problem Management

**Decision reference:** DEC-061  
**Design source:** `docs/68_DOCUMENT_LIFECYCLE_DESIGN_PROPOSAL.md`, §14.37  
**Register source:** `docs/01_MASTER_DECISION_REGISTER.md`, DEC-061

| Traceability area | Required design evidence | Implementation status |
|---|---|---|
| Scope and definitions | Incident vs problem; operational, security/privacy, integrity, provider/integration, monitoring, backup/continuity scope | Design requirement recorded |
| Incident record | Stable ID, detection/occurrence, source, category, impact, severity, affected scope, owner, timeline, evidence, communications and related records | Design requirement recorded; schema open |
| Classification | Severity/impact matrix distinct from DEC-039 and workflow statuses; auditable reclassification | Design requirement recorded; matrix open |
| Lifecycle | Detect/report, register, triage, coordinate, contain, correct, recover/validate, close, review | Design lifecycle recorded |
| Roles and authority | Incident lead, least-privilege responders, emergency access boundaries, no DEC-021 bypass | Design requirement recorded; role mapping open |
| Security/privacy | Suspected compromise/exposure/tampering escalation, specialist review, evidence preservation, no unsupported legal conclusions | Design requirement recorded; criteria/runbooks open |
| Emergency change and recovery | Explicit authorization, risk, separation of duties, validation, rollback, DEC-056/059 alignment | Design requirement recorded; procedure open |
| Communications | Authorized audience/sender, verified content, channel, timestamp, outcome, no unsupported claims | Design requirement recorded; matrices/templates open |
| Problem management | Linked incidents, root/contributing causes, hypotheses, workaround, corrective actions, owners, effectiveness verification | Design requirement recorded; method/triggers open |
| Records and retention | Append-only material history, linked corrections, DEC-054 retention/legal hold, DEC-055 audit | Design requirement recorded |
| Metrics and improvement | Incident trends, recurrence, detection/containment/recovery timing where reliable, action effectiveness and limitations | Design requirement recorded; formulas open |
| Dependencies | DEC-060 monitoring; DEC-055 audit; DEC-056 configuration; DEC-057 integration; DEC-059 backup/DR | Cross-references recorded |
| Operational targets | Severity thresholds, SLA/SLO, response/recovery times, regulatory deadlines | Not approved by DEC-061 |
| Implementation evidence | Tooling, integrations, paging, emergency access, production containment/restoration, tests | Not authorized; no implementation claimed |

**Verification boundary:** this section records design traceability only. It does not establish that an incident-management process, tooling, on-call service, security response capability, or problem register exists or has been tested.

**Implementation boundary:** no incident tooling/ticketing integration, paging/on-call configuration, security operations tooling, emergency access, production containment, credential rotation, restoration, code/API/database/storage/auth/RLS/configuration modification, automated remediation, production exercise, merge, or deployment is authorized or recorded by DEC-061.

**Open traceability items:** incident/problem taxonomy; severity matrix; reporting channels; commander/responder roles and on-call; emergency access/change; privacy/legal escalation; communication matrices/channels; provider coordination; recovery objectives; evidence/chain-of-custody; root-cause method; problem triggers; corrective-action governance; metrics; retention mapping; exercises; ownership/staffing/cost.

## Section 67 — DEC-062 Implementation Traceability: Change Management & Release Governance

**Decision reference:** DEC-062  
**Design source:** `docs/68_DOCUMENT_LIFECYCLE_DESIGN_PROPOSAL.md`, §14.38  
**Register source:** `docs/01_MASTER_DECISION_REGISTER.md`, DEC-062

| Traceability area | Required design evidence | Implementation status |
|---|---|---|
| Scope and taxonomy | Controlled changes across code, UI, API, DB/data, storage, auth/RLS, integrations, infrastructure, procedures, templates and governance | Design requirement recorded; taxonomy open |
| Change request | Stable ID, requester/owner, reason, scope, dependencies, linked decisions/incidents/problems, execution and outcome history | Design requirement recorded; schema open |
| Risk assessment | Security, privacy, integrity, audit, continuity, compatibility, migration, external copies and user impact | Design requirement recorded; matrix open |
| Review and approval | Separate request/review/approval/implementation/validation/release capabilities; separation of duties | Design requirement recorded; role matrix open |
| Environments | Separated development/test/staging/production, least privilege, lower-environment data protection | Design requirement recorded; architecture open |
| Validation evidence | Acceptance criteria, peer review, automated/manual tests, negative authorization, regression, migration, recovery and business acceptance | Design requirement recorded; standards open |
| High-impact changes | DB/data, generated types, RLS/grants, storage, identity, secrets, signing, numbering; DB+storage backup and isolated restore | Design requirement recorded; change-specific gates open |
| Release identity | Immutable release ID, exact commits/artifacts/hash, approved changes, versions, dependencies, evidence and approvals | Design requirement recorded; tooling open |
| Deployment and verification | Exact approved package/scope, deployment log, health/security/data/integration/workflow checks | Design requirement recorded; procedure open |
| Rollback/forward-fix | Decision authority, compatibility, data/external side effects, recovery plan, audited rollback | Design requirement recorded; standards open |
| Emergency change | Narrow declaration/approval authority, minimum checks, evidence, validation and retrospective review | Design requirement recorded; policy open |
| Operational readiness | DEC-060 monitoring, DEC-061 incident response, DEC-059 recovery, support and communication | Cross-references recorded |
| Records and retention | Append-only history, DEC-054 retention/legal hold, DEC-055 audit, DEC-056 configuration governance | Design requirement recorded |
| Implementation evidence | Code changes, merges, pipeline, releases, production deployments, migrations, provider changes, production tests | Not authorized; no implementation claimed |

**Verification boundary:** this section records design traceability only. It does not establish that change-management tooling, CI/CD controls, release pipelines, environment separation, test suites, approvals, or deployment safeguards exist or have been tested.

**Implementation boundary:** no code change, merge, pipeline configuration, release/deployment, database migration/data mutation, storage/auth/RLS/grant/secret/key modification, infrastructure/provider or integration change, automated remediation, production test, or operational execution is authorized or recorded by DEC-062.

**Open traceability items:** taxonomy and class eligibility; risk matrix; pre-authorized catalogue; approval roles; emergency criteria/authority; environment architecture and masking; test evidence standards; CI/CD and branch protections; artifact provenance/signing; release identity/versioning; deployment strategy/windows; migration and storage recovery standards; rollback/forward-fix criteria; communication; operational readiness; post-implementation review; retention; metrics; ownership/cost.

## Section 68 — DEC-063 Implementation Traceability: Access Reviews & Periodic Permission Recertification

**Decision reference:** DEC-063  
**Design source:** `docs/68_DOCUMENT_LIFECYCLE_DESIGN_PROPOSAL.md`, §14.39  
**Register source:** `docs/01_MASTER_DECISION_REGISTER.md`, DEC-063

| Traceability area | Required design evidence | Implementation status |
|---|---|---|
| Scope and population | Human/non-human identities, project/party assignments, effective capabilities, privileged/temporary/emergency access and resource scope | Design requirement recorded; inventory open |
| Review evidence | Reproducible snapshot, as-of time, sources, scope, policy version, reviewer, approver, findings and evidence | Design requirement recorded; format open |
| Effective permissions | Direct/inherited grants, APIs, storage policies, service roles, sessions, tokens and caches | Design requirement recorded; calculation method open |
| Triggers and cadence | Periodic and event-driven reviews for joiner/mover/leaver, assignment/policy change, anomaly and incident | Design requirement recorded; schedule open |
| Independence | Separate preparation, business confirmation, technical review and approval; no self-certification as sole review | Design requirement recorded; role matrix open |
| Review outcomes | Retain, Modify, Revoke/End, Time-bound exception, Investigate, Not applicable | Design requirement recorded |
| Remediation | Governed grant/revoke process, verification, failed/partial remediation tracking | Design requirement recorded; timelines and mechanisms open |
| Historical integrity | Preserve prior signatures, approvals, decisions, comments, uploads and audit attribution after access ends | Design requirement recorded |
| Non-human/privileged | Named owner, purpose, scope, environment, credential custody, expiry/review, emergency access | Design requirement recorded; inventory and policy open |
| Verification and reporting | Positive/negative tests, non-response handling, coverage/overdue/discrepancy metrics | Design requirement recorded; methods/formulas open |
| Governance dependencies | DEC-020 roster; DEC-021 capabilities; DEC-054 retention/legal hold; DEC-055 audit; DEC-056 configuration; DEC-060 monitoring; DEC-061 incidents | Cross-references recorded |
| Operational targets | Review frequency, response deadlines, revocation time, exception duration | Not approved by DEC-063 |
| Implementation evidence | IdP changes, account/grant revocations, policy changes, token rotation, automated reviews, production tests | Not authorized; no implementation claimed |

**Verification boundary:** this section records design traceability only. It does not establish that access-review tooling, complete identity inventory, automated recertification, revocation controls, or periodic reviews exist or have been tested.

**Implementation boundary:** no identity-provider or account change, access grant/revocation, RLS/grant/policy modification, token/secret rotation, service-account creation, integration change, production access test, automated recertification/remediation, code/database/storage/auth/API/UI modification, merge, or deployment is authorized or recorded by DEC-063.

**Open traceability items:** review cadence/risk tiers; source-of-truth inventory; reviewer/approver matrix; snapshot format; effective-permission calculation; joiner/mover/leaver timing; session/token/cache handling; service-account lifecycle; privileged/emergency access; exception policy; verification methods; tooling/reminders; metrics; retention; ownership/cost.

## Section 69 — DEC-064 Implementation Traceability: Data Classification, Privacy & Information Protection

**Decision reference:** DEC-064  
**Design source:** `docs/68_DOCUMENT_LIFECYCLE_DESIGN_PROPOSAL.md`, §14.40  
**Register source:** `docs/01_MASTER_DECISION_REGISTER.md`, DEC-064

| Traceability area | Required design evidence | Implementation status |
|---|---|---|
| Scope and asset inventory | Records, drafts, revisions, attachments, signatures, user data, telemetry, exports, backups, metadata, third parties | Design requirement recorded; inventory open |
| Classification model | Public, Internal, Confidential, Restricted; catalogue, defaults, owner, overlays and exceptions | Proposed baseline recorded; detailed catalogue open |
| Classification lifecycle | Assignment, inheritance, review, mixed packages, downgrade/declassification approval and audit | Design requirement recorded |
| Privacy and purpose | Data categories, source, purpose, minimization, permitted uses/recipients, privacy review | Design requirement recorded; inventory/legal mapping open |
| Legal/privacy accountability | Jurisdiction, legal basis, controller/processor, notices, individual requests, transfer/notification duties | Explicitly requires qualified review; not determined by DEC-064 |
| Lifecycle handling | Creation, viewing, storage, transmission, print, export, support, lower environments, archive, backup and disposal | Design requirement recorded; detailed standards open |
| Drafts and derivatives | DEC-021 draft protection; attachment inheritance; scan/OCR/thumbnail/preview/PDF controls; metadata protection | Cross-references and design requirements recorded |
| Signature and evidence protection | Signing credentials, signature evidence, audit/security records; image not credential/proof | Design requirement recorded |
| External sharing and third parties | Recipient verification, minimum scope, approved channels, processor/provider safeguards, transfer and deletion terms | Design requirement recorded; contracts/channels open |
| Security and incidents | Encryption/key controls, redaction, integrity, malware/quarantine, DEC-060/061 response | Design requirement recorded; technical standards open |
| Governance dependencies | DEC-021/063 access; DEC-054 retention; DEC-055 audit; DEC-056 configuration; DEC-050–052 sharing; DEC-053 revisions; DEC-058 import/export; DEC-059 backup; DEC-060/061 monitoring/incidents | Cross-references recorded |
| Implementation evidence | Production classification, encryption/key changes, DLP, masking, provider/residency, sharing, disposal, production tests | Not authorized; no implementation claimed |

**Verification boundary:** this section records design traceability only. It does not establish that information is currently classified, that privacy controls or encryption are configured, or that the system meets any legal/regulatory requirement.

**Implementation boundary:** no production classification or data-collection change, encryption/key operation, DLP tooling, masking/migration, provider/residency change, external sharing, integration, legal notice, individual-request execution, retention/disposal operation, code/database/storage/auth/RLS/API/UI modification, production test, merge, or deployment is authorized or recorded by DEC-064.

**Open traceability items:** classification catalogue and defaults; asset/data inventory; privacy purpose/legal mapping; controller/processor roles; notices/individual requests; impact assessment; residency/transfers; encryption/key custody; sharing channels; third-party assurance; print/watermark; DLP/export; retention; masking; review cadence; incident notification; metrics; ownership/cost.

## Section 70 — DEC-065 Data Integrity, Validation & Consistency Governance

| Area | Traceability requirement | Status |
|---|---|---|
| Data ownership | Authoritative source, owner, permitted writers, correction route | Design requirement recorded |
| Validation | Server-side structural, semantic, business, workflow, file, import, integration, report, and recovery validation | Design requirement recorded; rule catalogues open |
| Referential integrity | Validate all typed project/document/revision/evidence/workflow/report/distribution/financial links | Design requirement recorded |
| Identity and numbering | Stable IDs, unique official numbering, no reuse, distinct numbering dimensions | Design requirement recorded; scopes open |
| Revision/snapshot binding | Exact immutable revision/snapshot for evidence, approvals, signatures, reports, and transmittals | Design requirement recorded |
| Workflow consistency | Authorized transitions; separate status dimensions; reject impossible combinations | Design requirement recorded |
| Atomicity and concurrency | Transaction boundaries, idempotency, race/lost-update/double-posting protection | Design requirement recorded; technical design open |
| Financial/quantity arithmetic | Explicit precision, rounding, currency, units, calculation lineage | Design requirement recorded; accounting/payroll/tax rules not approved |
| Temporal integrity | Preserve event/effective/target/due/posting dates and timezone context | Design requirement recorded |
| Corrections | Authorized append-only correction/amendment/reversal/supersession with full attribution | Design requirement recorded |
| Duplicates and anomalies | Detect, classify, route ambiguous cases to authorized human resolution | Design requirement recorded; thresholds open |
| File/evidence integrity | Validate bytes, metadata, quarantine, binding, hashes, storage availability | Design requirement recorded; technical standards open |
| Derived data and reports | Source lineage, version, freshness, exclusions, reconciliation | Design requirement recorded |
| Import/export/integration/recovery | Apply DEC-057/058/059 provenance, idempotency, reconciliation, coordinated restore | Cross-references recorded |
| Audit and privacy | DEC-055 audit, DEC-060 telemetry, DEC-021/063 access, DEC-064 classification/privacy | Cross-references recorded |
| Exceptions and testing | Owned, time-bounded exceptions; family-specific test evidence | Design requirement recorded; acceptance criteria open |
| Implementation evidence | Code/schema/storage/auth/API/UI/migration/production data/test/deployment changes | Not authorized; no implementation claimed |

**Verification boundary:** this section records design traceability only. It does not establish that existing data is clean, constraints are enforced, financial calculations are correct, attachments are intact, or any production test has passed.

**Implementation boundary:** no code, schema/constraint/trigger, storage, auth/RLS, API/UI, migration, data correction, production validation, integration, financial posting, payroll processing, backup/restore, test execution, merge, or deployment is authorized or recorded by DEC-065.

**Open traceability items:** field ownership; record-family validation catalogues; numbering scopes; currency/precision/rounding rules; correction authority; transaction/concurrency/idempotency design; duplicate thresholds; reconciliation owners/frequency; exception severity and blocking gates; file/hash/malware standards; legacy-data remediation; test plans and acceptance criteria; separate financial/payroll/tax/contractual rules.

## Section 71 — DEC-066 Business Continuity of Records & Controlled Operational Handover

| Area | Traceability requirement | Status |
|---|---|---|
| Continuity triggers | Personnel, assignment, party, project phase, provider, and service/recovery transitions | Design requirement recorded |
| Authority | Initiator/preparer/reviewer/recipient/acceptance/closure authority by scope and risk | Design requirement recorded; matrix open |
| Handover inventory | Open records/actions, exact states, pending reviews/signatures, evidence, dependencies, exceptions | Design requirement recorded |
| Exact record binding | Stable IDs and exact revisions, WIR items/attempts, report snapshots, transmittal manifests | Design requirement recorded |
| Identity and attribution | No credential/signature transfer; preserve original actor; successor uses own identity | Design requirement recorded |
| Successor authorization | Active assignment, scope, qualification where required, capability; package grants no access | Cross-reference DEC-020/021 recorded |
| Reassignment and temporary coverage | Family-specific reassignment; narrow, approved, time-bound coverage and expiry | Design requirement recorded |
| Reconciliation | Counts, open actions, versions, attachments/hashes, financial/custody balances where enabled | Design requirement recorded; tolerances open |
| Acceptance and exceptions | Authenticated acceptance/refusal/qualified acceptance; silence is not acceptance | Design requirement recorded |
| Project/provider transition | Approved scope, custody, manifest, secure transfer, acceptance, residual obligations | Cross-reference DEC-057/058/064 recorded |
| Financial/physical custody | Reconcile advances, petty cash, expenses, payroll status, payment evidence, custodians | Design requirement recorded; financial forms open |
| Access and revocation | Separate successor provisioning and verified revocation across access paths | Cross-reference DEC-063 recorded |
| Audit, retention, monitoring | Append-only handover evidence, retention/legal hold, monitoring and incident route | Cross-reference DEC-054/055/060/061 recorded |
| Reporting and privacy | Authorized status/exception reporting; no draft or cross-party leakage | Design requirement recorded |
| Implementation evidence | Production handover, access changes, reassignment, financial posting, migration, code or deployment | Not authorized; no implementation claimed |

**Verification boundary:** this section records design traceability only. It does not establish that handover workflows, access revocation, reconciliation, or continuity procedures currently exist or have been tested.

**Implementation boundary:** no production handover, account/role/access change, workflow reassignment, financial/payroll posting, export/migration/transfer, emergency access, code/database/storage/auth/RLS/API/UI change, test execution, merge, or deployment is authorized or recorded by DEC-066.

**Open traceability items:** handover templates and authority matrix; minimum inventory/lookback; acceptance/dispute workflow; qualification checks; temporary/emergency access limits; reconciliation tolerances; financial/physical custody evidence; retention; notification/escalation; provider transition controls; export/offline support; metrics and training.


## Section 72 — DEC-067 Project Closeout, Final Records Handover & Completion Governance

| Traceability area | Required design evidence | Status |
|---|---|---|
| Distinct completion concepts | Separate practical, taking-over/operational, contractual, administrative, financial, archive, and records-handover meanings | Recorded; project/contract definitions open |
| Workstream closeout gates | Technical/quality, inspections/tests, WIR, NCR/SOR/snags, commissioning, manuals, warranties, training, permits and correspondence | Recorded; checklists and owners open |
| Residual actions and exceptions | Owner, scope, risk, evidence, approved target date if applicable, authority, and continued tracking | Recorded; qualified-closeout criteria open |
| Final records index | Exact record IDs, revisions, report snapshots, approvals, evidence, transmittals, receipts, responses, audit, metadata and hashes | Recorded |
| Final handover package | Authorized recipient, purpose, classification, exact versions, manifest, integrity, custody and acceptance route | Recorded; formats/channels open |
| Delivery and acceptance | Separate preparation, validation, dispatch, delivery, access, receipt acknowledgement, review/acceptance and custody transfer | Recorded |
| Financial closeout | Separate final-account/payment/claims/retention/advance/deduction/liability reconciliation if Finance is enabled | Design requirement recorded; rules and formulas open |
| Cash, payroll and assets | Separate reconciliation of advances, petty cash, expenses, workforce/payroll and physical custody where enabled | Design requirement recorded; policies/forms open |
| Approval and separation of duties | Distinct preparation, verification, review, approval, issue and acceptance; DEC-021 controls | Recorded |
| Post-closeout obligations | Preserve defects, warranties, claims, disputes and other residual obligations; controlled reopening | Recorded; project-specific process open |
| Immutable closeout snapshot | Exact as-of scope, versions, manifest, exceptions, reconciliations, approvals and integrity evidence | Recorded |
| Security, retention and audit | Apply DEC-054/055/059/064/065/066; authorize every query, preview, export and download | Cross-references recorded |
| Implementation evidence | Actual closeout, financial posting, transfer, archiving, access change, code or deployment | Not authorized; no implementation claimed |

**Verification boundary:** this section records design traceability only. It does not establish that closeout gates, financial reconciliations, final handover packages, acceptance workflows, or archive procedures currently exist or have been tested.

**Implementation boundary:** no actual project closeout, contractual certification/taking-over, financial/payroll posting or payment, export/migration/transfer, archive/disposal, access changes, reassignment, code/database/storage/auth/RLS/API/UI change, test execution, merge, or deployment is authorized or recorded by DEC-067.

**Open traceability items:** project/contract phase definitions; closeout checklists and authority matrix; residual obligations; final records index and package formats; recipient/custody and acceptance; financial/payroll/asset controls; reconciliation tolerances; retention; reopening; report and certificate templates.


## Section 73 — DEC-068 Project Performance, Cost Control & Management Oversight Governance

| Traceability area | Required design evidence | Status |
|---|---|---|
| Performance dimensions | Separate progress, schedule, quality, safety/environment where scoped, resources, procurement, workflow, finance, risk and closeout | Recorded |
| Authoritative data | Source, owner, permitted updater, definition version, refresh, effective date and limitations per metric | Recorded |
| Baseline governance | Approved baseline/forecast/actual/target/scenario separation; authorized versioned re-baseline | Recorded; authority and rules open |
| Progress measurement | Work packages, quantities, weights, rules of credit, evidence, cut-off and verified versus reported values | Recorded; project measurement rules open |
| Schedule performance | Planned/forecast/actual dates, milestones, dependencies, slippage and recovery; no automatic contractual conclusion | Recorded |
| Quality and inspection | Indicators sourced from authoritative records; DEC-025 WIR outcomes preserved | Recorded |
| Cost and commitments | Separate budget, changes, commitments, actuals, accruals, forecasts, claims, retention, advances, deductions and payments | Design requirement recorded; financial rules open |
| Forecast and variance | Disclosed assumptions, uncertainty, baseline, threshold, owner, action, escalation and closure evidence | Recorded; thresholds open |
| Resource and productivity | Comparable units, scope, periods, trades, locations and source quality | Recorded |
| Metric dictionary | Formula, source, grain, units, filters, exclusions, time basis, aggregation, freshness, version and interpretation | Recorded |
| Role and portfolio views | DEC-021 authorization; comparability and confidentiality controls; PM read-only | Recorded |
| Drill-down, export and audit | Server-side authorization and immutable report/output lineage | Cross-references recorded |
| Implementation evidence | Actual budgets, baselines, ledgers, KPI thresholds, dashboards, financial actions, code or deployment | Not authorized; no implementation claimed |

**Verification boundary:** this section records design traceability only. It does not establish that project-control metrics, financial controls, dashboards, baselines, or reporting pipelines currently exist or have been tested.

**Implementation boundary:** no creation or alteration of budgets, baselines, schedules, ledgers, payment certificates, forecasts, accounting entries, payroll, financial approvals/payments, KPI thresholds, production dashboards, exports, access changes, code/database/storage/auth/RLS/API/UI changes, test execution, merge, or deployment is authorized or recorded by DEC-068.

**Open traceability items:** metric catalogue and formulas; project-specific progress rules and baselines; schedule/calendar rules; financial/accounting definitions; commitment/accrual/forecast rules; thresholds; portfolio normalization; dashboard roles; data freshness and reconciliation; export templates; retention and review cadence.


## Section 74 — DEC-069 Project Risk, Claims, Variations & Change Impact Governance

| Traceability area | Required design evidence | Status |
|---|---|---|
| Distinct record classes | Separate risks, issues, claims, variations/change requests, approved changes, incidents and problems | Recorded |
| Risk register and assessment | Stable identity, owner, cause/event/consequence, versioned method, inherent/residual exposure, response and history | Recorded; project scoring open |
| Issue management | Actual issue record, containment, corrective action, evidence and linked risk history | Recorded |
| Change initiation and assessment | Origin, source, scope, urgency, evidence, classification and multidimensional impact assessment | Recorded |
| Approval and baseline control | Authorized approval/instruction; pending changes do not alter baselines; DEC-068 versioning | Recorded; authority matrix open |
| Variation and claim separation | Distinct registers and explicit relationships; submission does not establish entitlement | Recorded |
| Notice governance | Contract-specific trigger, source rule, deadline, recipient, method, evidence and review | Recorded; clause mapping open |
| Time and cost substantiation | Separate submitted/assessed/recommended/agreed/determined/certified/paid values with evidence | Recorded; methodologies open |
| Schedule impact | Activity logic, calendars, data dates, critical path, float, mitigation and concurrency | Recorded; methodology open |
| Cost impact | Quantities, rates, currency, pricing basis, authorized treatments and calculation versions | Recorded; valuation rules open |
| Negotiation and dispute history | Immutable party positions, offers, responses, determinations and dispute events | Recorded |
| Cumulative effects | Linked impacts, overlaps, concurrency and double-counting controls | Recorded; project methodology open |
| Authority, confidentiality and audit | DEC-021 separation, party confidentiality, append-only evidence and exact version binding | Recorded |
| Closeout and retention | Preserve residual claims/disputes under DEC-054/055/067 and related controls | Cross-references recorded |
| Implementation evidence | Actual notice, claim decision, variation instruction, baseline/ledger update, payment, code or deployment | Not authorized; no implementation claimed |

**Verification boundary:** this section records design traceability only. It does not establish that risk, claim, variation, notice, or change-control workflows currently exist or have been tested.

**Implementation boundary:** no actual contractual notices, claim acceptance/rejection/determination, variation approval/instruction, scope execution, baseline/budget/schedule/ledger change, financial certification/payment, legal interpretation, access change, data export, code/database/storage/auth/RLS/API/UI change, test execution, merge, or deployment is authorized or recorded by DEC-069.

**Open traceability items:** risk scoring and taxonomy; authority and approval limits; change/emergency route; baseline process; contract notice rules; claim assessment; time/cost methodologies; concurrency; confidentiality; dispute stages; reporting and retention.
