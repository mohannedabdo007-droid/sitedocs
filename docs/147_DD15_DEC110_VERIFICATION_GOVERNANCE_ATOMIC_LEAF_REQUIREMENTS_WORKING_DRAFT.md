# DD-15 DEC-110 Verification Governance — Atomic Leaf Requirements

**Document type:** Atomic decomposition of owner-approved verification governance  
**Date:** 2026-11-12  
**Status:** GOVERNANCE-SOURCE DECOMPOSITION PREPARED — QA / OWNER VALIDATION PENDING — NO TEST EXECUTION — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Authoritative source:** `governance/scan-lifecycle-design-2026-11-11/docs/01_MASTER_DECISION_REGISTER.md`, DEC-110  
**Supporting acceptance framework:** `docs/83` §§3–7, 16–21  
**DD-15 baseline:** `docs/139`; scenario inventory `docs/137`; candidate mapping `docs/138`

> The leaves below decompose only the approved DEC-110 direction. They are traceability references, not new DEC decisions, QA procedures, release rules or implementation requirements. Where DEC-110 does not define a value or authority, the matter remains open and must not be inferred.

## 1. Decomposition and coverage rules

- **Approved governance constraint:** directly supported by DEC-110.
- **Process-control leaf:** governs test design, execution records, evidence or disposition; it is not necessarily a product AT-RFI/E2E scenario.
- **Partial:** an existing scenario or supporting process document touches the subject but does not prove the entire leaf.
- **Uncovered:** no direct scenario or approved process evidence has been identified.
- **Blocked:** a required authority, prerequisite, environment, evidence control or acceptance value remains unresolved.
- The 13 AT-RFI and 28 E2E definitions remain the source-preserved initial scenario inventory in docs/137. No new scenario IDs are created here.

## 2. DEC-110 atomic verification-governance requirements

| Leaf ID | Atomic requirement / invariant | DEC-110 basis | Candidate scenario / process mapping | Coverage | Unresolved evidence or approval |
|---|---|---|---|---|---|
| RFI-TST-L001 | Every approved requirement included in acceptance scope has a traceable reference to one or more expected outcomes. | Trace every approved requirement to expected outcomes | docs/139; docs/138; docs/83 §3 | Partial | QA must validate completeness against exact approved source versions. |
| RFI-TST-L002 | Each accepted expected outcome has identifiable retained evidence sufficient to support its recorded result. | Trace requirements to retained evidence | docs/83 §§3,6,16 | Partial | Evidence repository, format, custody, retention and access controls remain open. |
| RFI-TST-L003 | Test design is recorded distinctly from test execution. | Separate test design from execution | docs/137–139; docs/83 §§5,16 | Partial | Controlled test-case and execution-record lifecycle requires QA procedure approval. |
| RFI-TST-L004 | An unexecuted test design is never represented as an executed result or Passed outcome. | Separate execution and passed results | docs/141; docs/83 §§16,21 | Partial | QA ledger state model and independent verification remain to be approved. |
| RFI-TST-L005 | A Passed result is recorded only after execution against its approved expected outcome and review of required evidence. | Separate execution and passed results; retained evidence | docs/83 §§3,16–17 | Uncovered | Result acceptance authority and evidence sufficiency criteria require QA/owner approval. |
| RFI-TST-L006 | The verification scope includes functional and lifecycle gates. | DEC-110 required test domains | AT-RFI-01–13; E2E-01–28 | Partial | Exact leaf-to-scenario assertions and lifecycle authority remain pending. |
| RFI-TST-L007 | The verification scope includes negative authorization and confidentiality tests. | DEC-110 required test domains | AT-RFI-04; E2E-07, E2E-15, E2E-27, E2E-28; docs/83 §7 | Partial | Capability/entitlement matrix and negative-case completeness require security/owner validation. |
| RFI-TST-L008 | The verification scope includes concurrency, idempotency and transaction-integrity tests. | DEC-110 required test domains | E2E-01–02, E2E-03–04, E2E-10–11, E2E-18–19; docs/131 | Partial | Approved transaction/idempotency contract and exact race outcomes remain open. |
| RFI-TST-L009 | The verification scope includes immutable evidence and append-only history tests. | DEC-110 required test domains | AT-RFI-06; E2E-04, E2E-15, E2E-20, E2E-24–26; docs/130–131 | Partial | Evidence identity, custody and records contract require specialist validation. |
| RFI-TST-L010 | The verification scope includes recipient-level delivery and acknowledgement tests. | DEC-110 required test domains | AT-RFI-13; E2E-14–19, E2E-22, E2E-24; docs/140 | Partial | Exact provider Unknown handling and complete DEC-103 edge-case assertions remain open. |
| RFI-TST-L011 | The verification scope includes notification tests. | DEC-110 required test domains | E2E-28; docs/144 | Partial | Event/recipient/action authority and delivery/reconciliation prerequisites remain open. |
| RFI-TST-L012 | The verification scope includes reporting/export reconciliation and metadata-leakage tests. | DEC-110 required test domains | AT-RFI-11–12; E2E-27; docs/145 | Partial | Metric formulas, audience entitlements, suppression and cache/index bounds remain open. |
| RFI-TST-L013 | Failure/recovery rehearsal is controlled and performed in a non-production context. | DEC-110 controlled non-production failure/recovery rehearsal | E2E-11, E2E-18, E2E-26; docs/83 §6 | Partial | Approved isolated environment, synthetic data, backup/restore plan and owner authorization are absent. |
| RFI-TST-L014 | Each execution result identifies the tested build and configuration. | DEC-110 execution-result record fields | docs/83 §§16–17 | Uncovered | QA execution record template and build provenance process require approval. |
| RFI-TST-L015 | Each execution result identifies the requirement and decision versions used as its acceptance basis. | DEC-110 execution-result record fields | docs/138–140, docs/145–146 | Partial | Exact version-pinning and change-impact/retest rules require QA/owner validation. |
| RFI-TST-L016 | Each execution result identifies its environment and test data. | DEC-110 execution-result record fields | docs/83 §6 | Partial | Environment qualification, synthetic-data catalogue and fixture ownership are not approved. |
| RFI-TST-L017 | Each execution result identifies the actor and capability context used. | DEC-110 execution-result record fields | docs/83 §§6–7 | Partial | Approved identity/appointment model and test-identity controls remain open. |
| RFI-TST-L018 | Each execution result records its timestamp and the expected and actual outcomes. | DEC-110 execution-result record fields | docs/83 §§16–17 | Partial | Timestamp/timezone policy and controlled result schema require QA approval. |
| RFI-TST-L019 | Each execution result links the evidence, defect or exception, and any retest record. | DEC-110 execution-result record fields | docs/83 §§16–17 | Partial | Evidence contract, defect taxonomy and immutable retest lineage require approval. |
| RFI-TST-L020 | A test dependent on an unresolved prerequisite is blocked; expected behavior is not inferred to make the test executable. | DEC-110 unresolved-prerequisite rule | docs/137 §6; docs/138 §5; docs/83 §§3,18 | Partial | A controlled blocked-state owner, review cadence and prerequisite-clearance record remain to be defined. |
| RFI-TST-L021 | Unauthorized access or unauthorized action is an acceptance blocker. | DEC-110 blocker categories | AT-RFI-04; E2E-07, E2E-15, E2E-27–28 | Partial | Exact release-blocker evidence and authorized disposition process require approval. |
| RFI-TST-L022 | Duplicate official RFI identity or number is an acceptance blocker. | DEC-110 blocker categories | AT-RFI-10; E2E-01–02 | Partial | Legacy reconciliation and allocator acceptance outcomes remain open. |
| RFI-TST-L023 | Evidence corruption is an acceptance blocker. | DEC-110 blocker categories | AT-RFI-05; E2E-04, E2E-15, E2E-19, E2E-26 | Partial | Integrity profiles, corruption fixtures and verification evidence require security/records approval. |
| RFI-TST-L024 | Unauthorized technical issue or unauthorized technical closure is an acceptance blocker. | DEC-110 blocker categories | AT-RFI-03; E2E-10, E2E-12–13 | Partial | Exact authority/appointment negative assertions and approved lifecycle guards remain pending. |
| RFI-TST-L025 | Incorrect recipient delivery or acknowledgement aggregation is an acceptance blocker. | DEC-110 blocker categories | AT-RFI-13; E2E-16–17; docs/140 | Partial | All-success, mixed, all-fail, zero-Required and Unknown outcomes need validated assertions. |
| RFI-TST-L026 | Unreconciled data loss is an acceptance blocker. | DEC-110 blocker categories | E2E-11, E2E-18, E2E-26; docs/131, docs/146 | Partial | Recovery reconciliation criteria, evidence and isolated rehearsal remain unapproved. |
| RFI-TST-L027 | A waiver requires explicit scoped authority. | DEC-110 waiver rule | docs/83 §17 | Uncovered | Named waiver authority and non-waivable categories remain open. |
| RFI-TST-L028 | A waiver records its risk and rationale. | DEC-110 waiver rule | docs/83 §17 | Uncovered | Risk assessment format and approver remain open. |
| RFI-TST-L029 | A waiver records compensating controls. | DEC-110 waiver rule | docs/83 §17 | Uncovered | Control adequacy reviewer and evidence requirements remain open. |
| RFI-TST-L030 | A waiver has a review or expiry control and retained evidence. | DEC-110 waiver rule | docs/83 §17 | Uncovered | Review authority, expiry handling and waiver register remain open. |
| RFI-TST-L031 | A waiver cannot override governance requirements. | DEC-110 waiver rule | docs/83 §§17–20 | Partial | QA/owner must validate the non-waivable classification and escalation path. |

## 3. Coverage interpretation

1. The 31 leaves are derived from the approved DEC-110 text. The mapping column is not proof that the cited scenario fully asserts the leaf.
2. Process-control leaves (test design/execution separation, evidence recording, prerequisite blocking, waiver governance) require QA process records and review evidence; they cannot be satisfied merely by product E2E scenarios.
3. The source inventory contains 41 AT-RFI/E2E scenarios, but source count is not coverage completeness. A cited scenario may only partially touch a leaf.
4. Release-blocker categories are stated by DEC-110. Numeric severity, response targets, waiver authority, release sign-off roles and evidence sufficiency are not invented here.
5. Recovery-related scenario mapping does not authorize backup/restore execution. DEC-110 requires controlled non-production rehearsal; separate approval and verified safeguards remain necessary.

## 4. Required QA completion fields

For every leaf, QA must record: exact DEC-110 source version; leaf ID; owner; independent verifier; applicable source scenario ID and exact wording or process-control artifact; actor/capability; approved expected-result authority; positive/negative/boundary/concurrency/failure assertions as applicable; synthetic fixture; build/configuration; environment/data; timestamp; evidence location and custody; actual result; defect/exception; retest link; blocker/waiver disposition and approver.

A missing authority, prerequisite, fixture, environment, evidence or required reviewer means **Blocked**, not Passed.

## 5. Required next actions

- QA validates each leaf against the exact DEC-110 source and docs/83.
- QA reconciles every candidate scenario reference against docs/137 without altering source wording or inventing test IDs.
- Owner and QA identify the competent independent verifier and evidence custodian; no self-appointed sign-off.
- Security and records authorities validate their respective negative-access, confidentiality, evidence custody and recovery leaves.
- Owner/QA resolve waiver authority, non-waivable categories, severity and release sign-off before any release-readiness assessment.
- Only after validation may the leaves be promoted into a controlled requirement-to-test baseline. Execution remains a separate authorization.

## 6. Relationship to existing DD-15 artifacts

This document supplements docs/137 (source-preserved AT-RFI/E2E inventory), docs/138 (candidate scenario-to-specification mapping), docs/139 (approved governance coverage baseline), docs/140 (DEC-103/108 communication leaves), docs/144 (DD-12 notification leaves), docs/145 (DD-13 leaves), docs/146 (DD-14 leaves) and docs/83 (acceptance catalogue). It does not replace any of them.

## 7. Explicit non-authorization

No test execution, live workflow, production-data access, real notification/Transmittal, permission/account change, backup/restore, archive, legal hold, deletion/disposition, DB/schema/migration/generated types, Storage, authentication, authorization/RLS/grants, API/UI/code, merge, deployment or release is authorized. No test is claimed passed. Any execution requires a separate owner-approved plan, approved synthetic non-production environment and identities, evidence controls, required specialist reviews and explicit authorization. DB/Storage work additionally requires verified backups, isolated restore/rehearsal and reconciliation.
