# DD-15 AT-RFI / E2E Candidate Requirement Traceability Matrix — Working Draft

**Document type:** Scenario-to-specification candidate traceability matrix  
**Date:** 2026-11-12  
**Status:** INITIAL SCENARIO MAPPING PREPARED — ATOMIC REQUIREMENT DECOMPOSITION AND QA / OWNER VALIDATION PENDING — NO EXECUTION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Source inventory:** `docs/137_DD15_CONTROLLED_AT_RFI_AND_E2E_TEST_INVENTORY_WORKING_DRAFT.md`  
**Scenario source:** `docs/69_RFI_WORKFLOW_DESIGN_WORKING_DRAFT.md` §8 and §21.4  
**Governing acceptance framework:** DEC-110

> This matrix links each imported scenario to candidate detailed-specification sections for review. It is not yet an atomic requirement-to-test matrix: source specifications contain candidate rules and open decisions, and no final approved requirement IDs, expected results, fixtures or execution evidence are established by this mapping.

## 1. Mapping rules

1. Preserve the original scenario IDs and source text in docs/137.
2. Candidate DD references identify where the relevant rule is currently described; they do not prove that the requirement is approved, complete or testable.
3. QA must decompose each referenced section into atomic requirement IDs and mark its authority status: owner-confirmed governance, approved detailed requirement, candidate working-draft rule, or blocked prerequisite.
4. Expected results may be approved only when supported by the controlling DEC and resolved detailed-design authority. Where a dependency is open, status remains **Blocked — Pending Design Decision/Prerequisite**.
5. Multiple scenarios may cover one requirement, and one scenario may cover several requirements. Coverage must be counted by atomic requirement, not by document or scenario count.
6. This matrix does not create new test IDs, execution plans, fixtures, permission grants or implementation authorization.

## 2. AT-RFI scenario-to-specification mapping

| Scenario | Candidate specification sections | Coverage intent | Mapping status |
|---|---|---|---|
| AT-RFI-01 | docs/72 §§3–4; docs/73 §§3–6; docs/69 §8 | Authorized RFI origination/submission, mandatory form content, separation from inspection-only WIR actions | Candidate section mapping; authority/required-field validation pending |
| AT-RFI-02 | docs/72 §§3–4; docs/74 §§1–5; docs/81 §§3–4,12 | RFI/WIR type, numbering, permissions, actions, reports and audit isolation | Candidate mapping; numbering and legacy prerequisites open |
| AT-RFI-03 | docs/72 §§3–4; docs/78 §§6–9; docs/79 §§4–6 | Action-specific technical response and closure authority; non-equivalence of drafts, comments, delivery, read and silence | Candidate mapping; final lifecycle and capability matrix open |
| AT-RFI-04 | docs/72 §§4.1–4.6; docs/76 §§8–9; docs/77 §§6–7,14; docs/81 §15 | Cross-party and cross-type authorization, draft confidentiality, attachment/audit isolation, least privilege | Candidate mapping; identity and entitlement matrices open |
| AT-RFI-05 | docs/75 §§4–5,8; docs/76 §§4,7,12; docs/131 §§2,5 | Immutable submitted question/reference/attachment snapshot and exact-version lineage | Candidate mapping; canonical evidence and manifest contract open |
| AT-RFI-06 | docs/75 §8; docs/76 §12; docs/79 §17; docs/82 §§8,16 | Attributable, append-only event history across response, review, issue, cancellation, withdrawal and closure | Candidate mapping; event model and record-series mapping open |
| AT-RFI-07 | docs/72 §§9.2–9.5; docs/127 §§4–8; docs/128 DM-01–DM-20 | Required discipline contributions, technical-lead consolidation, conflict and completeness gates | Candidate mapping; specialist validation and authority evidence pending |
| AT-RFI-08 | docs/72 §§3.4–3.5; docs/77 §11; docs/78 §§3,11–12; docs/80 §§3–5,12 | Prevent communication, read state, date expiry or draft answer from becoming technical closure | Candidate mapping; exact transition and notification behavior open |
| AT-RFI-09 | docs/73 §§5–7; docs/79 §§9–12,17; docs/82 §4 | Reopening/follow-up linkage and preservation of prior closed record | Candidate mapping; reopening authority and cycle model open |
| AT-RFI-10 | docs/74 §§3,5,8–13; docs/75 §§4,7 | Number allocation, no draft/failure consumption, uniqueness, no RFI/WIR collision or reuse | Candidate mapping; display format, uniqueness and legacy reconciliation open |
| AT-RFI-11 | docs/81 §§4–5,8,10,13; docs/83 §14 | Separate counting units for RFI identity, cycle, response, assignment, recipient and clarification | Candidate mapping; metric formulas and lifecycle vocabulary open |
| AT-RFI-12 | docs/81 §9; docs/80 §14 | Reproducible timezone/as-of metrics and requested-date vs authorized target-date distinction | Candidate mapping; project calendar/date policy and report formulas open |
| AT-RFI-13 | docs/77 §§9–12; docs/78 §§3,6,12; docs/81 §13 | Recipient-level delivery/acknowledgement reconciliation and no false technical resolution | Candidate mapping; provider outcome and request granularity open |

## 3. E2E scenario-to-specification mapping

| Scenario | Candidate specification sections | Coverage intent | Mapping status |
|---|---|---|---|
| E2E-01 | docs/74 §§3,5,10; docs/75 §§4,6–7 | Competing first submissions, duplicate inquiry handling and official number allocation | Candidate mapping; duplicate classification and allocator design open |
| E2E-02 | docs/74 §§3,5,8,10; docs/75 §§4,6–7 | Concurrent number allocation and failed/abandoned submission behavior | Candidate mapping; atomic uniqueness implementation design open |
| E2E-03 | docs/72 §§4,9; docs/75 §§5–6 | Assignment change vs contribution submission; authorship and authoritative assignment context | Candidate mapping; assignment authority and transaction outcome open |
| E2E-04 | docs/72 §§9.2–9.5; docs/75 §§5–6,8; docs/76 §4 | Contribution arrival during consolidation; version and provenance preservation | Candidate mapping; consolidation compare/reconcile rules open |
| E2E-05 | docs/72 §§9–10; docs/127 §§4–8; docs/128 DM-01–DM-20 | Conflict escalation vs Ready for Issue; authorized conflict disposition | Candidate mapping; conflict taxonomy and risk authority open |
| E2E-06 | docs/72 §10; docs/75 §§5–6; docs/127 §§5–8; docs/128 DM-07–DM-16 | Review of candidate V1 while V2 is submitted; exact-version review binding | Candidate mapping; independent-review trigger and change-impact matrix open |
| E2E-07 | docs/72 §§4.1–4.6,10.4–10.6; docs/75 §12 | Appointment/capability revocation between assignment and consequential review | Candidate mapping; capability IDs and appointment evidence open |
| E2E-08 | docs/73 §§3,5,7–8; docs/75 §§5–6 | Clarification request competing with response issue preparation | Candidate mapping; clarification blocking and materiality rules open |
| E2E-09 | docs/73 §§3–8; docs/74 §2.3; docs/75 §§5–6 | Formal revision during review; exact revision/candidate binding and supersession | Candidate mapping; materiality and active-cycle semantics open |
| E2E-10 | docs/72 §§3–4; docs/75 §§4–7,12 | Competing formal issue attempts and stale/losing command handling | Candidate mapping; final issue transaction and authority contract open |
| E2E-11 | docs/75 §§2–4,7,9–10 | Timeout after successful issue and safe idempotent retry | Candidate mapping; key scope, replay and transaction outcome open |
| E2E-12 | docs/72 §§3.3,9–10; docs/127–128 | Issue attempt while mandatory review/conflict remains open | Candidate mapping; risk matrix and issue gate open |
| E2E-13 | docs/72 §3.3; docs/79 §§4–6 | Reject separate closure before formal issue | Candidate mapping; final parent lifecycle transition contract open |
| E2E-14 | docs/77 §§9–10; docs/78 §§12–14; docs/79 §13 | Delivery failure after technical issue/closure; keep communication outcome separate | Candidate mapping; provider delivery semantics open |
| E2E-15 | docs/72 §4; docs/76 §§8–9,11; docs/77 §§6–7,13–14; docs/130 EVD-06/EVD-07 | Revoked recipient access before opening exact manifest entry | Candidate mapping; authentication, revocation and external-copy boundary open |
| E2E-16 | docs/77 §§9–11; docs/78 §§3–4,6–9 | Access/download distinct from explicit acknowledgement | Candidate mapping; acknowledgement authority and evidence open |
| E2E-17 | docs/77 §§9–10; docs/78 §§12.1–12.3; docs/132 RCP-02–RCP-04 | Mixed recipient delivery and acknowledgement aggregation | Candidate mapping; DEC-103 governs aggregate, provider Unknown treatment open |
| E2E-18 | docs/75 §§2–4,7,9; docs/77 §12; docs/131 §6 | Same-package retry preserves Transmittal identity and deduplicates commands | Candidate mapping; idempotency contract and retry event model open |
| E2E-19 | docs/76 §§4,8–9; docs/77 §§9,12; docs/78 §6; docs/131 §5 | Changed recipient/package scope creates linked Transmittal; frozen manifest remains immutable | Candidate mapping; manifest and recipient snapshot contract open |
| E2E-20 | docs/73 §§5–7; docs/76 §§4,12; docs/77 §§9,12; docs/78 §§8–10; docs/79 §§13–14 | Correction after issue and recipient access; preserve original response and access history | Candidate mapping; correction/supplement and external notice authority open |
| E2E-21 | docs/73 §§3,5–7; docs/79 §§9–12 | Reopening vs new linked RFI for materially independent scope | Candidate mapping; classification authority and duplicate-active handling open |
| E2E-22 | docs/77 §§9–12; docs/78 §§6,11–12; docs/79 §§9–14 | Reopened cycle while historical acknowledgement pending | Candidate mapping; cycle-specific request/recipient obligation rules open |
| E2E-23 | docs/75 §§4–10; docs/79 §§3,5–6,16 | Withdrawal request competing with issue/distribution | Candidate mapping; transaction order and withdrawal authority open |
| E2E-24 | docs/77 §§12–15; docs/78 §§8–10; docs/79 §§6,13–17; docs/82 §§8–14 | Source response withdrawal after Transmittal; preserve recipient receipts and separate scopes | Candidate mapping; post-issue correction/notice and records scope open |
| E2E-25 | docs/72 §§3.4,9; docs/79 §§7–8,16–17; docs/82 §§3–4 | Duplicate cancellation after contributions/reviews; preserve both histories and authorized relationship | Candidate mapping; cancellation authority and record linkage open |
| E2E-26 | docs/76 §§13–14; docs/82 §§7–14,17; docs/130 EVD-09/EVD-10 | Archive request while legal hold or linked evidence dependency exists | Candidate mapping; record-series, hold scope, recovery and disposition authority open |
| E2E-27 | docs/72 §4; docs/81 §§6–7,9,11,15–17; docs/134 CR-134-04/05/06 | Export while party scope/assignment changes; action-time authorization and reproducible as-of snapshot | Candidate mapping; authorization freshness, index/cache and export semantics open |
| E2E-28 | docs/72 §4; docs/80 §§3–7,10–13,16; docs/133 CR-133-01/02/05/07/09 | Delayed notification after underlying action completion/revocation; source state and current access govern | Candidate mapping; notification commit/retry and recipient privacy rules open |

## 4. Coverage gaps and incomplete atomic traceability

This matrix currently provides **scenario-to-section mapping**, not complete requirement-to-test traceability. The following work remains:

1. Extract every atomic normative requirement from DD-01–DD-14 and controlling DEC-103–DEC-110, assigning stable requirement references without inventing governance DEC IDs.
2. For each requirement, record exact source section, authority status, owner, applicable scenario IDs, positive/negative/boundary/concurrency/failure dimensions and evidence expectation.
3. Identify requirements with no scenario, scenarios with no valid approved requirement, duplicate/overlapping coverage and tests blocked by unresolved decisions.
4. Resolve apparent mapping gaps through QA and domain-owner review; do not add new test IDs until a naming/versioning convention is approved.
5. Confirm that each expected result is supported by an approved rule, not merely a candidate specification.
6. Reconcile the full repository test inventory and separate current UI/helper tests from future RFI domain, service/API, integration, security, E2E and recovery tests.

## 5. Authority status and execution readiness

| Item | Current status |
|---|---|
| AT-RFI-01–13 source discovery/import | Complete in docs/137 |
| E2E-01–28 source discovery/import | Complete in docs/137 |
| Candidate scenario-to-DD section mapping | Drafted in this file; QA validation pending |
| Atomic requirement decomposition | Not complete |
| Requirement-to-test completeness | Not demonstrated |
| Expected-result authority for open dependencies | Blocked pending relevant decisions |
| Synthetic fixture catalogue and environment | Not approved |
| Test ownership / independent review | Not approved |
| Evidence repository/retention contract | Not approved |
| Severity / waiver / release authority | Not approved |
| Test execution | Not performed |
| Pass/fail or release readiness | No claim |

## 6. Next required action

QA and relevant domain owners should validate this matrix against the exact current versions of docs/72–docs/82, docs/127–docs/132, docs/134, docs/136–docs/137 and DEC-103–DEC-110. Record corrections, missing requirements, dissent, authority basis and source versions. Only after this reconciliation should the matrix be promoted to an atomic requirement-to-test baseline. Execution remains a separate, explicitly authorized activity.

## 6.1 Approved-governance coverage cross-reference

The companion `docs/139_DD15_APPROVED_GOVERNANCE_REQUIREMENT_COVERAGE_BASELINE_WORKING_DRAFT.md` decomposes the owner-approved DEC-104 ODM-01–ODM-22, DEC-103/108 recipient communication rules and DEC-110 test-governance controls into 39 initial requirement rows, and classifies candidate coverage as direct, partial or uncovered. Use both documents together: this file maps scenario IDs to candidate detailed-specification sections; docs/139 maps approved governance requirements to candidate scenario coverage. Neither is yet a leaf-level complete requirement-to-test baseline, and QA/domain-owner validation remains mandatory.

## 7. Explicit non-authorization

This matrix authorizes no test execution, production-data access, live workflow, real external notification/Transmittal, permission/account creation or change, backup/restore, archive, legal hold, deletion/disposition, DB/schema/migration/generated types, Storage, auth/RLS/grants, API/UI/code, merge, deployment or release. Any execution requires a separate owner-approved plan, exact test scope, approved synthetic non-production environment and identities, evidence controls, required specialist reviews and explicit authorization. DB/Storage operations additionally require verified backups, isolated restore/rehearsal and reconciliation.
