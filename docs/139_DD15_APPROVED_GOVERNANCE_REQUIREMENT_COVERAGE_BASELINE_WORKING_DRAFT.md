# DD-15 Approved Governance Requirement Coverage Baseline — Working Draft

**Document type:** Owner-approved governance requirement decomposition and scenario coverage baseline  
**Date:** 2026-11-12  
**Status:** GOVERNANCE-SOURCE DECOMPOSITION PREPARED — QA / OWNER VALIDATION PENDING — NO TEST EXECUTION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Authoritative source branch:** `governance/scan-lifecycle-design-2026-11-11`  
**Primary sources:** `docs/01_MASTER_DECISION_REGISTER.md` (DEC-103–DEC-110); `docs/02_DECISION_IMPLEMENTATION_TRACEABILITY.md` (Sections 109–115); `docs/68_DOCUMENT_LIFECYCLE_DESIGN_PROPOSAL.md` (§§14.64–14.71)  
**Scenario source/inventory:** `docs/69` §8 and §21.4; controlled import in `docs/137`  
**Candidate mapping:** `docs/138`

> This baseline decomposes the owner-approved governance direction into stable testable requirement references. These references are traceability keys only, not new governance decisions or implementation requirements. Scenario mappings are candidate coverage, not proof that a test asserts every listed rule. Detailed specifications remain working drafts and may contain unresolved implementation-level details. Where a scenario does not explicitly exercise a rule, coverage is marked partial or uncovered rather than assumed.

## 1. Authority and classification rules

- **Approved governance requirement:** directly supported by DEC-103–DEC-110 on the governance branch cited above.
- **Candidate detailed rule:** a proposed implementation-level detail in docs/72–docs/82; not promoted to approved governance by this file.
- **Direct candidate scenario:** a source scenario explicitly addresses the requirement's principal behavior, but still needs atomic assertions and an approved expected result.
- **Partial candidate coverage:** the scenario touches the subject but does not explicitly exercise all conditions, negative paths, authority checks or evidence.
- **No explicit scenario:** no one of AT-RFI-01–13 or E2E-01–28 explicitly verifies the requirement as written.
- **Blocked:** expected behavior or a necessary prerequisite is unresolved; no result may be inferred.
- All scenario IDs below refer to the original source-preserved descriptions in docs/137. The mapping does not expand their original scope.

## 2. Owner-approved RFI operating-model requirements — DEC-104 / ODM-01–ODM-22

| Requirement ID | Approved atomic requirement | Authority source | Candidate scenario coverage | Coverage assessment and known gap |
|---|---|---|---|---|
| RFI-GOV-001 | Only a project party explicitly enabled for the relevant RFI class and scope may originate that RFI; membership alone is insufficient. | DEC-104 ODM-01; DEC-105 | AT-RFI-01, AT-RFI-04 | **Partial** — AT-RFI-01 addresses authorized origination; explicit class/party/scope matrix and membership-only denial need separate assertions. |
| RFI-GOV-002 | Coordinator actions are limited to expressly delegated administrative completeness, routing, assignment administration, follow-up and records tasks; coordinator status grants no engineering decision authority. | DEC-104 ODM-02; DEC-105 | AT-RFI-03, AT-RFI-04; E2E-03, E2E-05, E2E-07 | **Partial** — scenarios touch authority boundaries but do not enumerate each forbidden coordinator action or direct-service denial. |
| RFI-GOV-003 | One official RFI identity supports multiple independently attributable, discipline-scoped contributions and one controlled consolidated response. | DEC-104 ODM-03; DEC-105 | AT-RFI-07; E2E-03, E2E-04 | **Direct candidate** — needs assertions for identity stability, authorship and contribution-to-response lineage. |
| RFI-GOV-004 | Technical ownership disputes are referred to the appointed technical lead or other authorized technical authority, not resolved by administrative routing. | DEC-104 ODM-04; DEC-105 | AT-RFI-07; E2E-05 | **Direct candidate** — exact dispute classes and authority hierarchy remain detailed-design prerequisites. |
| RFI-GOV-005 | A named technical lead preserves contribution authorship, records conflicts and obtains authorized disposition; no discipline position or dissent may be silently discarded. | DEC-104 ODM-05; DEC-105 | AT-RFI-06, AT-RFI-07; E2E-04, E2E-05, E2E-25 | **Direct candidate** — needs explicit before/after provenance, dissent-preservation and unauthorized-overwrite assertions. |
| RFI-GOV-006 | Independent review applies when the approved risk/authority matrix or controlled rule requires it; self-review is prohibited where separation of duties applies. | DEC-104 ODM-06; DEC-105 | AT-RFI-03, AT-RFI-07; E2E-06, E2E-07, E2E-12 | **Partial** — review-version race is present, but trigger matrix, competence, appointment, conflict and self-review negative cases are not comprehensively covered. |
| RFI-GOV-007 | Only an assigned, authorized technical authority may issue the formal engineering response; Document Control distribution does not grant issue authority. | DEC-104 ODM-07; DEC-105; DEC-108 | AT-RFI-03; E2E-10, E2E-12 | **Direct candidate** — requires role/appointment negative tests and proof that dispatch cannot issue/approve. |
| RFI-GOV-008 | Clarification that explains or completes the original inquiry remains under the same RFI identity; materially independent or independently trackable scope becomes a linked new RFI with a recorded technical classification reason. | DEC-104 ODM-08; DEC-106 | AT-RFI-09; E2E-08, E2E-21 | **Partial** — classification boundary examples and authorized classifier are unresolved; candidate scenario coverage is not an exhaustive decision table. |
| RFI-GOV-009 | Clarification rounds remain distinct from formal material revisions; material changes to controlled formal RFI content follow DEC-022-A/B. | DEC-104 ODM-09; DEC-106; DEC-107 | AT-RFI-09; E2E-08, E2E-09, E2E-20 | **Partial** — exact materiality criteria, revision examples and version/identity effects remain open. |
| RFI-GOV-010 | Before formal response issue, an originator or expressly authorized same-party delegate may request withdrawal with a reason; authorized records/coordinator authority validates; technical-lead concurrence is required after substantive technical work begins; issued response cannot be withdrawn or erased. | DEC-104 ODM-10; DEC-106 | AT-RFI-06; E2E-23, E2E-24 | **Partial** — E2E-23 addresses issue/distribution race; no explicit scenario fully covers request eligibility, reason, validator, concurrence cutoff and post-issue prohibition together. |
| RFI-GOV-011 | Administrative cancellation is limited to evidenced administrative cases such as duplicate/invalid registration, uses authorized records/workflow authority, preserves the record, and requires technical-lead concurrence if technical work began. | DEC-104 ODM-11; DEC-106 | AT-RFI-06; E2E-25 | **Partial** — duplicate cancellation after work is covered; invalid-registration and authority/record-preservation cases need explicit assertions. |
| RFI-GOV-012 | Reopening requires an expressly authorized technical authority and recorded reason, creates a new response cycle, and preserves prior issue/closure history. | DEC-104 ODM-12; DEC-106 | AT-RFI-09; E2E-21, E2E-22 | **Direct candidate** — requires explicit immutable prior-cycle assertions and authority denial tests. |
| RFI-GOV-013 | Technical closure follows authorized formal issue only after required contributions, material conflict resolution and mandatory reviews are complete; it must not depend on delivery, access, acknowledgement, reading, silence or originator acceptance. | DEC-104 ODM-13; DEC-106 | AT-RFI-03, AT-RFI-08; E2E-05, E2E-10, E2E-12, E2E-13, E2E-14 | **Direct candidate** — several scenarios touch gates and communication separation; atomic issue/closure and each prohibited communication dependency need explicit assertions. |
| RFI-GOV-014 | Originator-requested dates are informational; target dates require an approved project rule; no default SLA, pause-clock or contractual consequence is created; overdue monitoring cannot automatically close/cancel/resolve. | DEC-104 ODM-14; DEC-106; DEC-109 | AT-RFI-12 | **Partial / coverage gap** — AT-RFI-12 addresses requested-vs-target date metrics but does not explicitly test all workflow non-effects, clock semantics or unauthorized target configuration. |
| RFI-GOV-015 | Formal submission requires project, subject, originating party and originator, at least one discipline, a clear engineering question and reason/context; location/references are conditional, related records optional, suggested resolution optional and non-authoritative. | DEC-104 ODM-15; DEC-107 | AT-RFI-01 | **Partial** — one submission scenario exists; each required/conditional/optional field and invalid/unauthorized submission branch needs atomic coverage. |
| RFI-GOV-016 | A dedicated official RFI number is allocated only on first successful formal submission; drafts/failed attempts consume none; numbers are never reused; identity remains stable; allocation is concurrency-safe; project-scoped uniqueness is default subject to baseline/legacy reconciliation. | DEC-104 ODM-16; DEC-107; DEC-022-A/B | AT-RFI-10; E2E-01, E2E-02, E2E-11 | **Partial** — concurrency/duplicate scenarios exist; no complete explicit coverage for abandoned draft, failed validation, non-reuse after cancellation/withdrawal, stable identity across reassignment, and legacy collision reconciliation. |
| RFI-GOV-017 | Submitted attachment manifests and file versions are immutable snapshots; file access is independently server-authorized; detailed security/storage/limits/retention require separate design. | DEC-104 ODM-17; DEC-107 | AT-RFI-05; E2E-04, E2E-06, E2E-15, E2E-19, E2E-20, E2E-26 | **Partial** — snapshot/version and access themes exist; uploader/time/classification/context, integrity mismatch, every file operation, quarantine and recovery require separate atomic cases. |
| RFI-GOV-018 | Formal external distribution of an issued RFI response uses a controlled Transmittal under DEC-050/051; any separately authorized internal route remains distinct. | DEC-104 ODM-18; DEC-108 | AT-RFI-13; E2E-14–E2E-20, E2E-22, E2E-24 | **Partial** — distribution races are represented; external-vs-internal route controls, authority and exact issued package binding need dedicated cases. |
| RFI-GOV-019 | Acknowledgement is required only for recipients explicitly designated Required and remains separate from delivery, access and substantive response. | DEC-104 ODM-19; DEC-103; DEC-108 | AT-RFI-13; E2E-16, E2E-17, E2E-22 | **Partial** — denominator and access distinction are present; zero Required, optional/not-requested, failed-delivery and substantive-response independence need explicit assertion coverage. |
| RFI-GOV-020 | RFI technical lifecycle states remain separate from workload, overdue, delivery, access and acknowledgement indicators. | DEC-104 ODM-20; DEC-109 | AT-RFI-08, AT-RFI-11; E2E-14, E2E-22, E2E-28 | **Partial** — communication-vs-closure and metric units are touched; each indicator's non-transition behavior and parent/subordinate aggregation require explicit coverage. |
| RFI-GOV-021 | Notifications target only individually authorized relevant recipients; no default cadence/escalation is created; escalation does not transfer authority or grant permissions. | DEC-104 ODM-21; DEC-109 | E2E-28; AT-RFI-04, AT-RFI-08 | **Partial / coverage gap** — E2E-28 covers delayed notification and current authorization; no explicit source scenario fully covers unauthorized recipient resolution, cadence defaults and escalation non-authority. |
| RFI-GOV-022 | Reports/exports are permission-filtered and reproducible; retention and scheduled external distribution require separate approval. | DEC-104 ODM-22; DEC-109 | AT-RFI-11, AT-RFI-12; E2E-27 | **Partial** — export authorization race and metric reproducibility are touched; field-level privacy, count/facet leakage, as-of consistency and external distribution restrictions need separate cases. |

## 3. Recipient-level communication requirements — DEC-103 / DEC-108

| Requirement ID | Approved atomic requirement | Authority source | Candidate scenario coverage | Coverage assessment and known gap |
|---|---|---|---|---|
| RFI-COM-001 | Delivery is evaluated independently for every intended recipient in the frozen manifest. | DEC-103; DEC-108 | AT-RFI-13; E2E-17 | **Direct candidate** — verify per-recipient records, not only aggregate label. |
| RFI-COM-002 | Aggregate Delivered only when all intended recipients confirm technical delivery. | DEC-103; DEC-108 | AT-RFI-13; E2E-17 | **Partial** — E2E-17 focuses mixed outcomes; all-success branch needs explicit assertion. |
| RFI-COM-003 | Aggregate Partially Delivered when at least one recipient succeeds and at least one fails. | DEC-103; DEC-108 | AT-RFI-13; E2E-17 | **Direct candidate** — exact recipient denominator and mixed result must be asserted. |
| RFI-COM-004 | Aggregate Failed when all intended recipients fail delivery. | DEC-103; DEC-108 | AT-RFI-13 | **No explicit E2E scenario** — add controlled negative/failure assertion under an approved new test-ID convention or expand an existing case only with QA approval. |
| RFI-COM-005 | Acknowledgement is complete only when every recipient marked Required has explicitly acknowledged; Optional and Not Requested do not enter the denominator. | DEC-103; DEC-108 | AT-RFI-13; E2E-16, E2E-17 | **Partial** — exact zero-required and mixed Required/Optional denominator cases are not separately explicit. |
| RFI-COM-006 | If no recipient is marked Required, acknowledgement aggregate is Not Required. | DEC-103; DEC-108 | AT-RFI-13 | **No explicit scenario** — requires a dedicated assertion. |
| RFI-COM-007 | Failed technical delivery is not acknowledgement; delivery, access/read, acknowledgement, substantive response and approval remain distinct events. | DEC-103; DEC-108 | AT-RFI-13; E2E-16, E2E-17 | **Partial** — access-vs-acknowledgement is represented; failure-vs-acknowledgement and substantive response-vs-approval need explicit assertions. |
| RFI-COM-008 | Retry of an unchanged package preserves Transmittal identity and manifest; changed package or recipient scope creates a new linked Transmittal. | DEC-103; DEC-108 | E2E-18, E2E-19 | **Direct candidate** — verify unchanged retry and changed-manifest identity separately. |
| RFI-COM-009 | Technical issue and closure are independent of dispatch, delivery, access, acknowledgement, substantive response and silence; no default SLA/deemed receipt/contractual notice is created. | DEC-104/106/108 | AT-RFI-08; E2E-14, E2E-16, E2E-22, E2E-24 | **Partial** — issue/closure independence is represented; all communication events and prohibited legal/deadline inference need separate assertions. |

## 4. Verification-governance requirements — DEC-110

| Requirement ID | Approved atomic requirement | Authority source | Candidate scenario coverage | Coverage assessment and known gap |
|---|---|---|---|---|
| RFI-TST-001 | Every approved requirement must trace to expected outcomes and retained evidence. | DEC-110 | Not a product scenario; process control | **Uncovered by AT/E2E product scenarios** — this is a test-governance control implemented by the traceability and evidence process itself. |
| RFI-TST-002 | Test design, test execution and passed result are distinct records/states; an unexecuted test is not Passed. | DEC-110 | Not a product scenario; process control | **Uncovered by AT/E2E product scenarios** — QA execution ledger and review control required. |
| RFI-TST-003 | Acceptance includes functional/lifecycle, negative authorization/confidentiality, concurrency/idempotency/transaction integrity, evidence/history, recipient communication/notification, reporting/export and recovery domains. | DEC-110 | All AT-RFI/E2E sets are baseline inputs | **Partial** — the 41 scenarios span many domains but do not establish complete coverage of every domain. |
| RFI-TST-004 | Each execution result records build/configuration, requirement/decision version, environment/data, actor/capability context, timestamp, expected/actual result, evidence, defect/exception and retest. | DEC-110 | Not a product scenario; process control | **Uncovered by AT/E2E product scenarios** — evidence record template and QA procedure required. |
| RFI-TST-005 | Unresolved prerequisites block dependent tests; expected behavior must not be inferred. | DEC-110 | Not a product scenario; process control | **Uncovered by AT/E2E product scenarios** — blocked-test workflow and authority source field required. |
| RFI-TST-006 | Unauthorized access/action, duplicate official identity/number, evidence corruption, unauthorized issue/closure, incorrect recipient aggregation and unreconciled data loss are acceptance blockers. | DEC-110 | AT-RFI-02–06, AT-RFI-10, AT-RFI-13; E2E-01–02, E2E-10–20, E2E-26 | **Partial** — blocker categories are represented, but exact release-gate assertions, evidence and owner sign-off are not. |
| RFI-TST-007 | Any waiver requires explicit scoped authority, recorded risk, compensating controls and review/expiry; it cannot override governance. | DEC-110 | Not a product scenario; process control | **Uncovered by AT/E2E product scenarios** — waiver authority and controlled register remain open. |
| RFI-TST-008 | Recovery tests are controlled non-production rehearsals; no destructive/production operation is inferred from test design. | DEC-110 | E2E-11, E2E-18, E2E-26 | **Partial** — retry/recovery situations are described; approved environment, fixture, backup/restore rehearsal and execution authorization remain absent. |

## 5. Explicit coverage gaps identified by this baseline

The following requirements have no explicit scenario or only partial scenario coverage and must not be called covered until QA decomposes and validates them:

1. **Recipient aggregate edge cases:** all-recipient failure (RFI-COM-004), zero Required acknowledgements (RFI-COM-006), failed delivery not acknowledgement, substantive response vs approval (RFI-COM-007).
2. **Date and monitoring non-effects:** requested/target date, overdue indicator and no automatic workflow/authority/access change (RFI-GOV-014).
3. **Notification authority:** recipient resolution, unauthorized recipient denial, no default cadence/escalation and escalation non-authority (RFI-GOV-021).
4. **Form field boundaries:** each mandatory, conditional and optional field plus unauthorized and failed submission branches (RFI-GOV-015).
5. **Numbering:** non-consumption on failed/abandoned submission, no reuse after withdrawal/cancellation, stable identity across reassignment, legacy collision reconciliation (RFI-GOV-016).
6. **Evidence security:** every file operation authorization, integrity mismatch, uploader/classification/context, quarantine/scanning and failure/recovery behavior (RFI-GOV-017).
7. **Report privacy:** row/field/party/attachment controls across search, facets, counts, drill-down and export; as-of reproducibility and small-count leakage (RFI-GOV-022).
8. **Test process governance:** execution ledger, evidence contract, blocked tests, waiver register and release authority (RFI-TST-001–008).
9. **Lifecycle and role matrix:** exact capability/appointment IDs, scope, grant/revoke authority, transition eligibility and direct API denial cases remain dependent on detailed design.

These are gap statements based on the 41 source scenarios and the cited approved decisions. They are not authority to create additional scenario IDs. QA must first confirm whether to expand an existing case or propose new IDs under a controlled naming/versioning convention.

## 5.1 Leaf-level refinement reference — DEC-103 / DEC-108

The recipient communication subset has been decomposed further into 25 independently verifiable leaf requirements in `docs/140_DD15_DEC103_DEC108_RECIPIENT_COMMUNICATION_LEAF_REQUIREMENTS_WORKING_DRAFT.md`. This refines RFI-COM-001–009 and related ODM-18/19 controls; it does not close the full baseline or authorize execution. Use docs/140 for leaf-level coverage and open communication prerequisites.

## 6. Required next refinement — atomic requirement decomposition

This baseline contains 39 governance traceability rows (22 operating-model requirements, 9 communication requirements and 8 test-governance requirements). It is an initial approved-governance layer, not the final atomic matrix. Next, QA and domain owners must:

1. Break each composite rule into its smallest independently verifiable conditions, including positive, negative, boundary, concurrency, failure and evidence assertions.
2. Link each leaf requirement to the exact detailed-specification section and mark that section's status (approved constraint, recommended design, open decision).
3. Assign a responsible requirement owner and independent verifier.
4. Decide whether existing scenarios sufficiently assert the leaf requirement or whether a separately approved test case is needed.
5. Record exact expected outcomes only where the owner-approved governance and resolved detailed design determine them.
6. Mark all open-authority-dependent leaf tests **Blocked — Pending Design Decision/Prerequisite**.
7. Reconcile the complete repository test inventory before claiming implementation test coverage.

## 7. Explicit non-authorization

This baseline authorizes no test execution, production-data access, live workflow, real external notification/Transmittal, permission/account creation or change, backup/restore, archive, legal hold, deletion/disposition, DB/schema/migration/generated types, Storage, auth/RLS/grants, API/UI/code, merge, deployment or release. Any execution requires a separate owner-approved plan, exact test scope, approved synthetic non-production environment and identities, evidence controls, required specialist reviews and explicit authorization. DB/Storage operations additionally require verified backups, isolated restore/rehearsal and reconciliation.
