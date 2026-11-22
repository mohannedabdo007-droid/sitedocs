# RFI Test Governance and Acceptance Catalogue — Working Draft

**Document type:** Non-authoritative detailed test-design specification  
**Date:** 2026-11-12  
**Status:** WORKING — FOR QA / SECURITY / RECORDS / ARCHITECTURE REVIEW — NOT TEST EXECUTION EVIDENCE — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Controlling governance baseline:** `governance/scan-lifecycle-design-2026-11-11`  
**Controlling decisions:** DEC-103–DEC-110  
**Related specifications:** `docs/71_RFI_DETAILED_SPECIFICATION_BACKLOG.md` and `docs/72`–`docs/82` RFI working specifications.

> This document proposes test governance and acceptance coverage only. It does not state that tests have run or passed, approve unresolved behavior, authorize live workflow tests, or authorize implementation.

## 1. Purpose and governing hierarchy

This specification consolidates RFI-DD-01–DD-14 test requirements and develops DEC-110 into a reviewable acceptance catalogue. Apply this precedence: (1) approved governance decisions and project baselines; (2) separately approved detailed specifications and authority decisions; (3) separately approved implementation/test plan; (4) this and other DD working drafts as proposals only.

A test cannot amend a decision, create permission, resolve a policy gap or turn a candidate label/state into approved behavior. Where sources conflict, block the affected case and raise a traceable decision issue.

## 2. Objectives and acceptance principles

Any separately authorized implementation must demonstrate that it:
- enforces authority and scope at the point of every consequential action;
- preserves RFI/WIR and document-family separation;
- prevents unauthorized access, disclosure, mutation, issue, closure and distribution;
- preserves identity, version, evidence, transaction and event integrity;
- applies recipient-level delivery and acknowledgement without conflating communication with technical disposition;
- produces permission-safe, reproducible reporting and notifications;
- preserves records and recovery boundaries; and
- fails closed when authority, rule, evidence or prerequisite is unresolved.

A green UI, successful HTTP response, passing unit test or absence of observed defects is not sufficient by itself.

## 3. Requirement-to-acceptance traceability contract

Every requirement must follow this chain:

**Requirement → controlling decision → detailed specification → test case → expected result → execution record → evidence → defect / exception / waiver → retest → acceptance decision.**

Minimum traceability fields:

| Field | Required content |
|---|---|
| Requirement ID | Stable requirement identifier |
| Source | DEC / project baseline / specification and section |
| Status | Approved constraint, open decision, prerequisite or candidate proposal |
| Test ID and version | Stable controlled identifier |
| Test level | Unit, integration, service/API, UI, E2E, security, reliability or recovery |
| Preconditions | Environment, synthetic data, actor, capability and scope |
| Steps | Deterministic sequence including negative attempts |
| Expected / actual | Expected result grounded in approved rule; observed result |
| Evidence | Timestamped, attributable and protected references |
| Outcome | Pass, Fail, Blocked, Not Run or Not Applicable with reason |
| Defect / exception | Linked issue, severity, owner and disposition |
| Retest / acceptance | Build/configuration, retest result, regression scope and authorized decision |

No test may be Pass if its expected result is not grounded in an approved requirement. Unresolved behavior is **Blocked — Pending Design Decision/Prerequisite**.

## 4. Test governance, roles and separation of duties

A future plan must name:
- **Owner / acceptance authority:** approves scope, risk disposition, permissible waivers and final acceptance within authority.
- **QA / test lead:** strategy, traceability, execution control, evidence, defect triage and regression.
- **Requirement / process owner:** validates expected outcomes against approved workflow rules.
- **Technical / discipline authority:** validates technical scenarios and issue-authority boundaries.
- **Security / identity reviewer:** approves security cases, test identities, scopes and negative authorization.
- **Records / Document Control reviewer:** validates evidence custody, immutable history, retention and lineage.
- **Architecture / engineering reviewer:** validates transaction, concurrency, integration and failure assumptions.
- **Independent acceptance reviewer:** assesses evidence independently where the approved risk/authority matrix requires it.

No self-approval where separation of duties applies. Exact appointments, competence, thresholds and permitted role combinations remain open. A test role grants no production authority.

## 5. Test levels and scope boundaries

| Level | Candidate purpose | Boundary |
|---|---|---|
| Unit | Deterministic domain rules and pure calculations | Cannot alone prove server authorization or cross-service integrity |
| Component / integration | Service interactions, persistence contracts and event boundaries | Isolated non-production dependencies |
| Service / API | Authorization, validation, idempotency and direct-call behavior | Include direct API negative tests, not only UI paths |
| UI | Presentation, affordances and feedback | Hidden/disabled controls are not authorization |
| End-to-end | Complete authorized journeys and cross-domain invariants | Synthetic identities/data only |
| Security / privacy | Denial, isolation, revocation, leakage and evidence access | Security sign-off required |
| Reliability / performance | Candidate resilience, load and recovery | Workload models and numeric thresholds require approval |
| Backup / restore rehearsal | Recoverability and reconciliation | Separate approved plan, verified backups and isolated rehearsal; not authorized here |

Coverage should be risk-based, but no unapproved risk score, threshold, SLA or mandatory review trigger is created.

## 6. Environment, identity and test-data governance

Future execution must use a specifically approved non-production environment with synthetic or irreversibly anonymized data. Default for this draft: **no production data, live project workflow, external recipient delivery or real-user permission changes**.

The plan must identify environment owner/isolation/build, synthetic project/party/discipline/document/recipient/attachment fixtures, test identities and exact capabilities, credentials and cleanup, simulated external integrations, clock/timezone assumptions, evidence storage/access/retention, and teardown/reconciliation.

No real external email, public link, notification, Transmittal, legal hold, deletion or disposition is to be triggered without separate explicit authorization.

## 7. Cross-cutting negative authorization and confidentiality catalogue

Mandatory proposed acceptance domains under DEC-110. Test both UI routes and direct service/API/object-reference routes where applicable.

| Domain | Negative scenario | Expected acceptance direction |
|---|---|---|
| Draft confidentiality | Unentitled party lists/searches/counts/previews another party's draft | Deny without content or metadata leakage |
| PM read-only | Project Manager edits, submits, assigns, reviews, issues, closes or decides | Preserve read-only oversight; deny mutation/decision |
| Party isolation | Party A guesses Party B IDs or filters | No cross-party record or metadata disclosure |
| Discipline scope | User accesses unrelated discipline contribution/restricted field | Deny outside explicit appointment/scope |
| Revocation | Old session, URL, token or API call reused after revocation | Re-evaluate current authority; deny stale entitlement |
| Direct API bypass | Hidden/disabled UI action invoked directly | Server-side denial; no side effect |
| Attachment isolation | RFI-visible user requests file without separate entitlement | Deny file operation independently |
| Search/facets | Unauthorized values appear in snippets, autocomplete, facets, counts or aggregates | No metadata leakage |
| Export | Broader rows/fields requested or old export link replayed | Enforce authorized scope and current policy |
| Recipient identity | Unverified/incorrect external identity acknowledges or responds | No false authorized attribution |
| Notification privacy | Ineligible recipient receives protected content | Suppress/minimize disclosure; safe audit |
| Historical access | Closed/archived record accessed without current authorization | Historical status does not bypass access controls |

Any unauthorized access, disclosure or action is a release blocker. Exact capabilities and recipient matrices depend on DD-02/DD-09 and explicit authority decisions.

## 8. Lifecycle, authority and document-family tests — DD-01 to DD-04

Candidate coverage:
- RFI and WIR remain separate families with independent identifiers, workflows, records and permissions.
- Draft, submission, coordination, completion return, assessment, clarification, multidisciplinary contribution, consolidation, independent review, issue and closure are tested only against the finally approved transition model.
- Invalid/unresolved transitions are denied without partial mutation.
- Originator, coordinator, discipline responder, technical lead, reviewer, issuer and Document Control boundaries are tested independently.
- Document Control distribution grants no technical issue, approval or closure authority; PM oversight remains read-only.
- Discipline contributions retain attribution, scope, evidence and version; one discipline cannot silently overwrite another.
- Technical lead preserves material dissent and cannot manufacture concurrence from silence or majority vote.
- Unresolved material conflict blocks issue where approved rules require it.
- Independent-review triggers, reviewer competence, independence, substitution and self-review denial follow the approved matrix; unresolved entries remain blocked.
- Assignment changes, expiry and revocation are checked at action time.

Candidate lifecycle names and guards in DD-01 are not approved merely by appearing in that draft. Dependent tests remain blocked until the vocabulary and rules are approved.

## 9. Clarification, revision, identity and numbering tests — DD-05/DD-06

Candidate scenarios:
1. Same-scope clarification preserves RFI identity and records a distinct clarification round.
2. Material controlled-content change follows approved revision rules and preserves prior versions.
3. Independently trackable engineering question becomes a separate linked RFI only after authorized classification.
4. Ambiguous classification is blocked; no silent scope expansion or overwrite.
5. Draft ID, clarification ID, contribution ID, response version, formal revision, RFI number and Transmittal ID remain distinct.
6. Only first successful formal submission allocates the official number; failed validation, abandoned draft and preview consume none.
7. Concurrent first submissions cannot create duplicate identity/number.
8. Withdrawn/cancelled numbers are never reused.
9. Legacy collisions/incomplete inventory remain blocked pending approved reconciliation; no guessed winner or renumbering.
10. Number format and uniqueness scope are tested only after explicit approval.

No number allocator or legacy migration is authorized.

## 10. Concurrency, idempotency and transaction integrity — DD-07

Candidate scenarios include duplicate command/replay; timeout-after-success retry; same idempotency key with different payload; concurrent number allocation; stale aggregate version during review/issue/closure/reopening; competing withdrawal/cancellation/issue; disjoint subordinate changes; partial failure; event/outbox publication failure; duplicate/out-of-order event delivery; authorization revoked between page load and action; and interrupted processing recovery without duplicate identities, events, notifications or external delivery.

Expected outcomes must come from the approved command/state contract. Transaction, lock, isolation, key scope/retention and event architecture remain open. No technology-specific result is implied.

## 11. Attachment, evidence and history tests — DD-08

Candidate scenarios:
- stable evidence and version IDs remain distinct;
- submitted/issued manifests pin exact versions;
- replacement creates a new version and never silently overwrites a snapshot;
- uploader, timestamp, classification, context and custody remain attributable;
- MIME spoofing, malformed files, oversized files, archive bombs and active content are rejected/quarantined under approved policy;
- unscanned, failed or indeterminate files cannot be promoted where fail-closed policy applies;
- integrity mismatch is visible; no silent substitution/repair;
- preview, download, export, linked-record and derivative/cache operations enforce current authorization;
- revoked users cannot reuse old object references;
- audit is append-only; corrections are linked, not destructive; and
- interrupted upload/scan/storage/recovery cannot leave a falsely complete manifest.

Hash algorithm, scanning service, quarantine, file limits, encryption, key management, region and retention remain unresolved. Recovery is governed by Section 15.

### 11.1 DD-08 exact-version traceability requirement

The candidate scenarios above are thematic coverage only. Before any test plan is approved, QA must import the actual AT-RFI-01–AT-RFI-13 and 28 E2E scenario definitions from their controlled source and map each applicable scenario to the exact DD-08 requirement, evidence identity/version/manifest rule, actor and capability scope, operation, expected result, negative/failure injection, retained evidence and defect/waiver/retest path. The mapping must explicitly cover the identity and lineage distinctions in docs/130 EVD-01; manifest/concurrency behavior (EVD-02); integrity and scan-version binding (EVD-03/EVD-04); file abuse and derivatives (EVD-05); per-operation authorization and revocation (EVD-06); recipient-specific Transmittal scope (EVD-07); custody/event integrity (EVD-08); records/hold/residual copies (EVD-09); recovery/orphan reconciliation (EVD-10). Preserve original scenario IDs and do not infer scenario content from counts. Any new test IDs require an approved naming/versioning convention. This is a coverage requirement only; no test is executed or passed by this addition.

### 11.2 DD-07 / DD-08 transaction and manifest race coverage

Use [docs/131 — DD-07 / DD-08 Evidence Transaction and Manifest Contract](131_DD07_DD08_EVIDENCE_TRANSACTION_AND_MANIFEST_CONTRACT_WORKING_DRAFT.md) as a candidate coverage crosswalk, not as approved expected outcomes. After importing the actual AT-RFI/E2E definitions, map applicable cases to TXE-01–TXE-10 and the contract's Sections 3–10. Explicitly account for same-key upload/finalize/register/freeze replay; changed-payload key conflict; partial transfer; object-without-metadata and metadata-without-object; stale scan worker; replacement-vs-freeze and link/unlink-vs-freeze races; concurrent freezes; permission revocation at promotion/freeze/retrieval; derivative lineage; custody/event partial failure; orphan recovery and hold-aware disposition. Each case must bind exact specification version, actor/capability scope, logical command/operation identity, injected race/failure, expected authoritative result and retained evidence. Preserve source scenario IDs; new IDs require an approved convention. Unresolved outcomes remain Blocked — Pending Design/Authority Decision. No tests are executed or passed.

## 12. Recipient delivery, acknowledgement and response — DD-09/DD-10

Verify independently:
- recipient identity, party representation, authorization, purpose and access scope;
- frozen Transmittal manifest and exact response/evidence versions;
- delivery, access/read, explicit acknowledgement and substantive response as separate events;
- opening/downloading is not acknowledgement;
- only explicitly Required recipients enter the acknowledgement denominator; Optional and Not Requested are excluded; zero Required means Not Required;
- DEC-103 exact aggregation: Delivered only if all intended recipients succeed; Partially Delivered if some succeed and some fail; Failed if all fail;
- failed delivery is not acknowledgement;
- unchanged-package retry retains Transmittal identity and appends attempt history;
- changed package or recipient scope creates a new linked Transmittal;
- recipient feedback does not automatically alter source RFI issue/closure/revision/reopening; and
- silence, read receipt or delivery never implies technical acceptance or contractual effect.

DD-10 substantive-response categories remain proposals until approved. Do not invent wording, due dates, SLA, deemed acceptance or legal consequence.

### 12.1 DD-09 / DD-10 recipient communication cross-specification coverage

Use [docs/132 — DD-09 / DD-10 Recipient Communication Cross-Specification Review](132_DD09_DD10_RECIPIENT_COMMUNICATION_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md) as a candidate coverage crosswalk for RCP-01–RCP-12 and DEP-RCP-01–DEP-RCP-12. After importing the actual controlled AT-RFI-01–13 and 28 E2E definitions, map applicable cases to recipient/Transmittal/manifest/request identities; delivery vs acknowledgement denominators; Unknown / Unconfirmed provider outcomes; person vs organization endpoint identity; per-recipient and per-entry authorization; revocation and forwarded-link denial; same-scope retries vs changed-scope Transmittals; callback deduplication; acknowledgement vs substantive-response dimensions; immutable corrections/supplements; and source-RFI non-interference. Do not multiply DEC-103's recipient denominator by manifest-entry count absent an explicit approved rule. Preserve original scenario IDs; no test is executed or passed by this mapping.

## 13. Reopening, withdrawal and cancellation — DD-11

Candidate tests preserve DEC-106:
- reasoned originator withdrawal request only before formal response issue;
- authorized validation and technical-lead concurrence where applicable after substantive work begins;
- administrative cancellation limited to evidenced, authorized administrative grounds;
- authorized, reasoned reopening creates a new cycle while preserving prior issue/closure history;
- issued response is not erased via pre-issue withdrawal;
- RFI identity/number retained and never reused;
- effects on contributions, reviews, evidence, Transmittals and recipient events are explicit;
- competing issue/withdrawal/cancellation/reopening commands resolve atomically under approved contract; and
- unclear eligibility, authority or scope is blocked, not inferred from UI/job title.

Eligible states, substantive-work threshold and delegation remain open. Dependent tests cannot pass until approved.

### 13.1 DD-11 lifecycle cross-specification coverage

Use [docs/142 — DD-11 Reopening, Withdrawal and Cancellation Cross-Specification Review](142_DD11_REOPENING_WITHDRAWAL_CANCELLATION_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md) as a candidate coverage crosswalk for RCL-01–RCL-15 and DEP-RCL-01–DEP-RCL-15. After importing the actual controlled AT-RFI and E2E definitions, map applicable cases to withdrawal request versus authorized outcome; shared substantive-work evidence and concurrence; pre-issue cutoff including Ready for Issue; issue/withdrawal/cancellation race; narrow cancellation grounds and canonical duplicate lineage; post-issue reopening authority/materiality; one parent projection with immutable predecessor/new cycle identities; cycle starting-stage and assignment/review gates; contribution revalidation; correction/revision/clarification/linked-new-RFI classification; new Transmittal and prior recipient-history preservation; retention/hold/recovery; and idempotent timeout/duplicate action handling. Preserve original scenario IDs and do not infer expected outcomes from counts. This is coverage planning only; no tests are executed or passed.

## 14. Notifications, reporting, search and export — DD-12/DD-13

### Notifications
- Candidate event derives only from authoritative source event.
- Recipient resolution is current, individually authorized and purpose-limited.
- Deduplication/retry creates no duplicate actionable event.
- Read/dismiss does not change source workflow or grant access.
- Reminder/escalation transfers no authority and creates no permission.
- Channel failure/provider uncertainty remains distinct from source workflow outcome.
- Content discloses no unauthorized fields, attachments or cross-party metadata.

No default cadence, channel, priority, retry count or escalation threshold is approved.

### Reporting, search and export
- Every metric declares source, counting unit, inclusion/exclusion, period, timezone and as-of cut-off.
- RFI, cycle, response, assignment, recipient and event counts are not conflated.
- Unauthorized rows, fields, snippets, facets, counts and aggregates are excluded server-side.
- Filters/drill-down cannot reveal hidden records through aggregate differences.
- Reports preserve historical cycles and exact response versions.
- Recipient delivery/acknowledgement reconciles to DEC-103.
- Export matches authorized query snapshot and records requester, authority, filters, fields, timezone, generated time and source/version references.
- Revoked access applies to subsequent export retrieval under approved policy.
- Stale index, delayed event and source/report reconciliation behavior is explicit.

Metric formulas, audiences, small-count suppression, index freshness, date rules, export formats and retention remain open.

## 15. Records, archive, legal hold, disposition and recovery — DD-14

Tests distinguish technical closure, withdrawal, cancellation, supersession, archival, retention expiry, legal hold and disposition.

Candidate non-production scenarios:
- archive eligibility requires approved completeness/manifest checks;
- archived records remain attributable and subject to current authorization;
- archival does not close, cancel, delete or broaden access;
- overlapping holds remain independent; releasing one does not release another;
- hold blocks disposition only within authorized scope;
- retention expiry triggers controlled review, not automatic deletion;
- disposition requires approved schedule, authority, hold clearance and scope evidence;
- backup, replica, cache and export copies have separate lifecycle treatment; and
- recovery reconciliation accounts for source records, evidence, events and linked records.

No retention period, schedule, legal authority, archive tier, hold-release rule, destruction method or deletion proof is selected. No archive, hold, deletion or disposition operation is authorized. DB/Storage backup and restore require a separate plan, verified backups, isolated rehearsal, reconciliation and explicit approval.

## 16. Test inventory, baseline mapping and coverage accounting

Initial baseline source discovery and controlled import:

- **AT-RFI-01–AT-RFI-13:** all 13 source definitions have been located in `docs/69_RFI_WORKFLOW_DESIGN_WORKING_DRAFT.md`, §8, lines 507–522, and imported without changing their identifiers into `docs/137_DD15_CONTROLLED_AT_RFI_AND_E2E_TEST_INVENTORY_WORKING_DRAFT.md`.
- **E2E-01–E2E-28:** all 28 source definitions have been located in `docs/69_RFI_WORKFLOW_DESIGN_WORKING_DRAFT.md`, §21.4, lines 1540–1567, and imported without changing their identifiers into the same controlled inventory file.
- The source file blob SHA at import was `23e892245c4120ce361e5673585539136707b70e`.

This closes source discovery/import only. The source definitions and safe outcomes remain proposed working-draft material, not final approved expected behavior or executed evidence. QA must validate the candidate DD/DEC mappings in docs/137, build the atomic requirement-to-test matrix, identify uncovered/duplicate/superseded cases, assign owners, approve synthetic fixtures/environment and evidence controls, and obtain authority decisions for every dependent expected outcome. Do not mark a case Passed without execution evidence. New IDs require an approved naming/versioning convention. Track requirement coverage, test coverage and execution status separately.

**Controlled source inventory:** `docs/137_DD15_CONTROLLED_AT_RFI_AND_E2E_TEST_INVENTORY_WORKING_DRAFT.md` preserves AT-RFI-01–13 and E2E-01–28 from the exact source locations. Its candidate DD/DEC mappings are not yet approved. Source import is complete; atomic requirement traceability, owner validation, fixtures, evidence, execution and acceptance remain open.

**Candidate scenario-to-specification matrix:** `docs/138_DD15_AT_RFI_E2E_CANDIDATE_REQUIREMENT_TRACEABILITY_MATRIX_WORKING_DRAFT.md` maps all 41 scenarios to candidate DD sections. This is not yet atomic requirement coverage and requires QA/domain-owner validation.

**Approved-governance coverage baseline:** `docs/139_DD15_APPROVED_GOVERNANCE_REQUIREMENT_COVERAGE_BASELINE_WORKING_DRAFT.md` decomposes DEC-104 ODM-01–ODM-22, DEC-103/108 recipient communication and DEC-110 test-governance controls into 39 traceability rows. Coverage is classified as direct candidate, partial, or uncovered; leaf-level decomposition and owner/QA validation remain open.

**Recipient communication leaf requirements:** `docs/140_DD15_DEC103_DEC108_RECIPIENT_COMMUNICATION_LEAF_REQUIREMENTS_WORKING_DRAFT.md` expands the DEC-103/DEC-108 subset into 25 leaf requirements, including delivery aggregates, Required-only acknowledgement, retry identity, immutable manifest, recipient scope and issue/closure separation. Several leaf requirements remain uncovered by the original 41 scenarios.

**Complete tracked repository test inventory:** `docs/141_DD15_REPOSITORY_TEST_INVENTORY_WORKING_DRAFT.md` records four tracked test files and 20 existing test cases on the inspected implementation branch. None is an RFI-specific acceptance test; this inventory is static and no test execution is claimed.

## 17. Defects, severity, retest, waivers and release gates

### Defects
Record reproducible steps, build/configuration, environment, synthetic fixture, actor/capability, timestamp, expected/actual result, logs/evidence, impact, owner and linked requirement.

Severity dimensions may include confidentiality, integrity, authorization, technical authority, records preservation, transaction correctness, recipient communication, availability and usability. Exact levels, scoring and response targets require QA/security/owner approval; no numeric threshold or SLA is created here.

### Mandatory release blockers under DEC-110
- unauthorized access, disclosure or action;
- duplicate/corrupt RFI identity or number;
- evidence corruption, silent substitution or manifest mismatch;
- unauthorized technical issue or closure;
- incorrect recipient delivery or acknowledgement aggregation;
- cross-party metadata leakage;
- failure to preserve required immutable history; and
- unreconciled data loss or inconsistent recovery.

### Retest and regression
A code change alone does not close a defect. Require linked retest evidence against the original failure, relevant negative/boundary variants and regression scope. Preserve the failure record; never overwrite it with a later pass.

### Waivers
A waiver cannot override DEC-103–DEC-110, grant authority, waive mandatory security/records controls or approve unresolved policy. Any permissible waiver requires a named authorized approver, exact scope, rationale, risk assessment, compensating controls, expiry/review date and retained evidence. Waiver authority and non-waivable categories remain open.

### Release readiness
A future gate should require approved requirements/specifications; complete traceability; approved environment/data; executed tests with evidence; zero open blockers; authorized dispositions for non-blocking defects; security and records sign-off; reconciled reports/recipient tests; recovery evidence where separately required; and explicit release approval by the authorized owner.

No readiness or release conclusion can be drawn from this draft or proposed cases.

## 18. Open decisions and required approvals

| Open item | Required authority / reviewer | Interim handling |
|---|---|---|
| State vocabulary and transition guards | Owner; process/technical authority; Document Control | Block lifecycle cases |
| Capability IDs, appointment/delegation | Owner; identity/security; project/party authority | No inferred grants |
| Conflict and independent-review triggers | Technical/risk authority; QA/security | Block unresolved review gates |
| Number format and legacy reconciliation | Owner; Document Control; records/data authority | No guessed number |
| Transaction/idempotency/recovery mechanics | Architecture; security; records | Architecture-neutral only |
| Attachment classes and scan/integrity/encryption | Security; records; architecture | No real file-service operation |
| Recipient identity and channel/provider | Owner; contract/communications; identity/security | Synthetic recipients/simulators |
| Acknowledgement/response wording | Owner; Document Control; technical/contract/records | Candidate catalogue only |
| Notification triggers/priority/cadence/channels | Owner; security/privacy; operations | No default schedule |
| Metric formulas/audiences/dates/export | Owner; reporting; security/records | Undefined metrics blocked/unavailable |
| Retention/legal hold/archive/disposition | Owner; records/legal/contract/security | No real records operation |
| Test ownership/competence/independent approval | Owner; QA; security/records | No self-appointed sign-off |
| Severity, thresholds and waiver authority | Owner; QA; security; records | No invented numeric gate |
| Evidence retention and release sign-off | Owner; records; QA | Remains open |
| Backup/restore rehearsal | Owner; data/Storage/security/records | Separate approval and isolated rehearsal |

## 19. Governance crosswalk and coverage map

| Work item | Coverage | Controlling decisions |
|---|---|---|
| DD-01 Lifecycle | §§3–8, 13, 16–18 | DEC-104, 106, 109, 110 |
| DD-02 Capability/appointment | §§4, 6–8, 18 | DEC-104, 105, 110 |
| DD-03 Discipline/technical lead/conflict | §§4, 8, 18 | DEC-104, 105, 110 |
| DD-04 Independent review/separation | §§4, 5, 8, 17–18 | DEC-104, 105, 110 |
| DD-05 Clarification/revision/new RFI | §§9, 13, 16 | DEC-022-A/B, 104, 106, 107, 110 |
| DD-06 Numbering/legacy | §§9–10, 16–18 | DEC-002, 022-A/B, 104, 107, 110 |
| DD-07 Concurrency/idempotency | §§5, 10, 13, 16–18 | DEC-104, 106, 107, 110 |
| DD-08 Attachment/evidence | §§7, 11, 15, 17–18 | DEC-021, 051, 053, 104, 107, 109, 110 |
| DD-09 Recipient identity/distribution | §§7, 12, 14, 16–18 | DEC-050–052, 103, 104, 108, 110 |
| DD-10 Acknowledgement/response | §§12, 14, 16–18 | DEC-052, 103, 108, 110 |
| DD-11 Reopen/withdraw/cancel | §§8, 10, 13, 15–18 | DEC-104, 106, 108–110 |
| DD-12 Notifications | §§7, 14, 16–18 | DEC-049, 104, 105, 108–110 |
| DD-13 Reporting/search/export | §§7, 14, 16–18 | DEC-021, 049, 103, 104, 105, 108–110 |
| DD-14 Records/retention/archive/hold | §§11, 15, 17–18 | DEC-012, 021, 053, 054, 104, 107, 109, 110 |
| DD-15 Test governance | All sections | DEC-103–110 |

This is a proposed coverage map, not proof that requirements are fully specified or tested. DEC-110 remains controlling.

## 20. Explicit exclusions and implementation boundary

This document does not approve candidate lifecycle/transition rules, capability IDs, risk thresholds, numbering format, file mechanisms, provider/channel, report formulas, retention schedule or legal authority. It does not execute tests; create test accounts or real permission changes; send real notifications/Transmittals; operate workflow, allocator, evidence, notification, search/export, archive, hold or disposition services; modify API/UI/code, DB/schema/migrations/generated types, Storage, authentication, authorization, RLS or grants; access/change production data; perform DB/Storage backup/restore; merge, deploy or authorize release.

Any implementation or execution requires a separate scoped plan, resolved prerequisite decisions, security/records/architecture review, approved test environment/data and explicit owner authorization. DB/Storage work additionally requires verified backups, isolated restore/rehearsal and reconciliation before any change.

## 21. Review and promotion checklist

- [x] QA source discovery/import: all 13 AT-RFI and 28 E2E source definitions are preserved in `docs/137_DD15_CONTROLLED_AT_RFI_AND_E2E_TEST_INVENTORY_WORKING_DRAFT.md`; QA mapping/validation remains open.
- [ ] Every approved requirement traces to decision, detailed specification, test and evidence.
- [ ] Open decisions are blocked and assigned to named authorities.
- [ ] Security approves negative authorization, privacy and evidence-access coverage.
- [ ] Records authority approves custody, retention and recovery boundaries.
- [ ] Architecture approves transaction, concurrency, integration and failure assumptions.
- [ ] Synthetic data, environment isolation and test identities are approved.
- [ ] Severity, non-waivable blockers, waiver authority and release sign-off are approved.
- [ ] No test is reported passed without execution records and retained evidence.
- [ ] Separate implementation/test plan and explicit owner authorization exist before execution or implementation.

**Current disposition:** Initial DD-15 detailed working draft prepared. Review pending. No test execution, test pass, implementation authorization, release readiness, merge or deployment is claimed or granted.


## 22. DD-04 decision-matrix traceability — candidate mapping

The candidate decision matrix is maintained in `docs/128_RFI_DD04_DECISION_AND_REVIEW_CONTROL_MATRIX_WORKING_DRAFT.md`. Before any test execution, map actual approved DD-15 scenario definitions to DM-01–DM-20, including negative cases for instrument applicability, unauthorized trigger decision, unauthorized appointment, competence, self-review/conflict, exception, package integrity, per-operation access, findings, change impact, targeted/full re-review, substitution, records lifecycle and parent lifecycle separation. This mapping is a coverage prompt only; it does not create new passed tests or replace the actual AT-RFI/E2E scenario definitions. Any expected result lacking an approved authority/prerequisite remains Blocked — Pending Design Decision/Prerequisite.


## 23. DD-12 notification framework traceability

Use [docs/143 — DD-12 Notification Framework Cross-Specification Review](143_DD12_NOTIFICATION_FRAMEWORK_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md) as the exact-version desk-review input for DD-12. NTF-01–NTF-12 and DEP-NTF-01–DEP-NTF-12 identify open requirements for authoritative event/commit crosswalk, source-event/recipient-notification/channel-attempt identities, recipient/action authorization, privacy-safe fan-out, Action Required task identity, uncertain channel outcomes, durable publication/reconciliation, idempotency/grouping, DEC-049 priority/channel/reminder alignment, historical-version/revocation, DD-14 records/hold and atomic DD-15 traceability. Reconcile candidate mappings with the source-preserving inventory in docs/137 and governance leaf requirements in docs/139–140. E2E-28 is directly relevant to delayed notification and current authorization; retain its exact source wording. All mappings remain candidate pending QA/owner/specialist validation; no test execution or pass is claimed.

## 23.1 DD-12 notification leaf requirement traceability

Use [docs/144 — DD-12 Notification Governance Leaf Requirements](144_DD12_NOTIFICATION_GOVERNANCE_LEAF_REQUIREMENTS_WORKING_DRAFT.md) as the notification-specific leaf layer beneath the broader governance and scenario crosswalks in docs/137–140. It records RFI-NTF-L001–L018, candidate source-scenario mappings, explicit uncovered areas and required QA completion fields. It does not replace docs/138 or docs/139, does not convert candidate scenario mappings into coverage evidence, and does not claim tests executed. Reconcile every leaf against exact source scenario wording, approved expected-result authority, synthetic fixtures and QA/domain-owner validation before any test baseline promotion.


## 24. DD-13 reporting/search/export leaf traceability

Use [docs/145 — DD-13 Reporting, Search and Export Governance Leaf Requirements](145_DD13_REPORTING_SEARCH_EXPORT_GOVERNANCE_LEAF_REQUIREMENTS_WORKING_DRAFT.md) with docs/134, docs/137–139 and docs/81. It records RFI-RPT-L001–L016, candidate AT-RFI/E2E mappings, explicit uncovered/blocked areas and QA completion fields. The leaves do not approve report audiences, metric formulas, privacy thresholds, timezone rules, export formats, retention or implementation. Validate exact source wording, approved expected-result authority, synthetic fixtures and specialist review before test-baseline promotion.

## 25. DD-14 records lifecycle leaf traceability

Use [docs/146 — DD-14 Records Lifecycle Governance Leaf Requirements](146_DD14_RECORDS_LIFECYCLE_GOVERNANCE_LEAF_REQUIREMENTS_WORKING_DRAFT.md) with docs/135, docs/137–139 and docs/82. It records RFI-REC-L001–L018, candidate AT-RFI/E2E mappings, explicit uncovered/blocked areas and QA completion fields. It does not establish retention schedules, legal-hold authority, archive technology, destruction method, backup policy or implementation. Validate record-series authority, schedule/hold instruments, exact expected results, synthetic fixtures and specialist review before test-baseline promotion.


## 24. DEC-110 verification-governance atomic leaf traceability

Use [docs/147 — DD-15 DEC-110 Verification Governance Atomic Leaf Requirements](147_DD15_DEC110_VERIFICATION_GOVERNANCE_ATOMIC_LEAF_REQUIREMENTS_WORKING_DRAFT.md) to refine the composite DEC-110 controls into RFI-TST-L001–L031. Validate exact source authority, QA process records, independent verification, execution evidence, prerequisite blocking, acceptance blockers and waiver governance. Process-control leaves must not be falsely mapped to product scenarios; candidate AT-RFI/E2E mappings require exact source verification. No test execution or Passed status is claimed.


## 26. DD-01 lifecycle governance leaf traceability

Use [docs/148 — DD-01 Lifecycle Governance Atomic Leaf Requirements](148_DD01_LIFECYCLE_GOVERNANCE_LEAF_REQUIREMENTS_WORKING_DRAFT.md) as the lifecycle-specific leaf layer beneath the DD-01 candidate specification and the broader DD-15 scenario/governance maps. It records RFI-LFC-L001–L024 across draft/submission identity, parent/cycle/child semantic ownership, technical hand-off, return/clarification, consolidation, independent review/readiness, issue/closure, withdrawal/cancellation, reopening and communication/records separation. The leaf document preserves the distinction between DEC policy constraints, conditional owner dispositions and unresolved candidate mechanics. Map each leaf to exact source scenario wording and approved expected-result authority; mark uncovered where no genuine mapping exists. G-01–G-06 remain open; no test execution or pass is claimed.


## 27. DD-02 capability and appointment governance leaf traceability

Use [docs/149 — DD-02 Capability and Appointment Governance Atomic Leaf Requirements](149_DD02_CAPABILITY_APPOINTMENT_GOVERNANCE_LEAF_REQUIREMENTS_WORKING_DRAFT.md) as the capability/appointment-specific leaf layer beneath the candidate authority model in docs/72 and docs/110. It records RFI-AUT-L001–L030 across action-time server authorization, actor and resource scope, appointment/delegation provenance, competence, separation of duties, role boundaries, grant/revoke, revocation/stale evidence, protected resource paths, privacy-safe denial and audit reconstruction. These leaves do not approve machine-readable capability IDs, grant authorities, actual appointments, function combinations or emergency access. Map only to exact controlled scenario wording and approved expected-result authority; no test execution or pass is claimed.


## 28. DD-03 discipline responsibility and conflict-governance leaf traceability

Use [docs/150 — DD-03 Discipline Responsibility, Technical Leadership and Conflict Governance Atomic Leaf Requirements](150_DD03_DISCIPLINE_RESPONSIBILITY_CONFLICT_GOVERNANCE_ATOMIC_LEAF_REQUIREMENTS_WORKING_DRAFT.md) with docs/111–112, docs/125–126 and the DD-02 authority layer in docs/149. It decomposes candidate controls into RFI-DIS-L001–L040. The discipline taxonomy uses ARC, CIV, MEC, ELE and SURVE; CIV remains one combined discipline code. Candidate mappings must be checked against exact AT-RFI/E2E source text and approved expected-result authority. C0–C4 are descriptive conflict classes, not severity rankings. Appointment evidence, materiality criteria, project discipline checklists, dissent presentation, external instruments and specialist validation remain open. Mark uncovered where no scenario genuinely tests a leaf. No test execution or pass is claimed.

## 29. DD-04 independent-review and separation-of-duties leaf traceability

Use [docs/152 — DD-04 Independent Review Governance Atomic Leaf Requirements](152_DD04_INDEPENDENT_REVIEW_GOVERNANCE_ATOMIC_LEAF_REQUIREMENTS_WORKING_DRAFT.md) with docs/127–129 and docs/125–126. It decomposes review instrument/applicability, trigger authority, exact-version package/evidence, reviewer appointment/competence/independence, finding disposition, clearance, change impact and re-review into RFI-REV-L001–L028. Preserve docs/129 X-01/X-02 clarifications and DEP-01–09 as open. DM-01–DM-20 are decision-control references, not test IDs. No approved project risk matrix or reviewer appointment is evidenced. Process/appointment evidence must not be falsely represented as product test coverage; QA, security, records, architecture and domain-owner validation remains pending. No test execution or pass is claimed.


## 30. DD-05 clarification/revision/linked-new-RFI classification leaf traceability

Use [docs/153 — DD-05 Clarification, Formal Revision and Linked-New-RFI Classification Atomic Leaf Requirements](153_DD05_CLARIFICATION_REVISION_LINKED_RFI_ATOMIC_LEAF_REQUIREMENTS_WORKING_DRAFT.md) with docs/73, DD-01 docs/148, DD-02 docs/149, DD-03 docs/150 and the DD-07 transaction contract. It records RFI-CLS-L001–L035 across classifier authority, exact source snapshot, clarification-round identity, DEC-022-B revision constraints, linked-RFI isolation, post-issue reopening, concurrency/idempotency and evidence lineage. Candidate mappings must use exact AT-RFI/E2E source definitions and approved expected-result authority; uncovered leaves must remain uncovered rather than forcing a match. No new test IDs, test execution or pass is claimed.


## 31. DD-06 official numbering and legacy reconciliation leaf traceability

Use [docs/154 — DD-06 Official RFI Numbering and Legacy Reconciliation Atomic Leaf Requirements](154_DD06_OFFICIAL_RFI_NUMBERING_LEGACY_RECONCILIATION_ATOMIC_LEAF_REQUIREMENTS_WORKING_DRAFT.md) with docs/74, DD-05 docs/153 and DD-07 docs/75. It records RFI-NUM-L001–L032 across successful-first-submission allocation, non-reuse, identity separation, namespace decisions, raw legacy provenance, collision classification, sequence baseline, idempotency and migration safeguards. No display pattern, final uniqueness boundary, complete legacy inventory or sequence baseline is approved. Map only to exact AT-RFI/E2E definitions and approved expected-result authority; inventory/records evidence is not a software test pass. No allocator, migration, test execution or pass is claimed.


## 32. DD-07 concurrency/idempotency/transaction integrity leaf traceability

Use [docs/155 — DD-07 Concurrency, Idempotency and Transaction Integrity Atomic Leaf Requirements](155_DD07_CONCURRENCY_IDEMPOTENCY_TRANSACTION_INTEGRITY_ATOMIC_LEAF_REQUIREMENTS_WORKING_DRAFT.md) with docs/75 and the DD-07/DD-08 evidence transaction contract in docs/131. It records RFI-TXN-L001–L040 across logical command identity, action-time authorization, replay, stale-write prevention, race handling, atomic business outcomes, exact evidence/manifest binding, post-commit side effects and recovery. Architecture and owner approval remain pending. Map only to exact source AT-RFI/E2E definitions and approved expected results; do not convert architecture requirements into fictitious product test coverage. No test execution or pass is claimed.


## 33. DD-08 attachment/evidence security leaf traceability

Use [docs/156 — DD-08 Attachment and Evidence Security Atomic Leaf Requirements](156_DD08_ATTACHMENT_EVIDENCE_SECURITY_ATOMIC_LEAF_REQUIREMENTS_WORKING_DRAFT.md) with docs/76, docs/130–131, DD-02 docs/149, DD-07 docs/155 and DD-14 docs/146. It records RFI-EVD-L001–L038 across stable evidence/version/relationship identity, quarantine/scanning, integrity, immutable manifests, per-operation authorization, recipient scope, custody and recovery. EVD-01–EVD-11 and DEP-EVD-01–DEP-EVD-11 remain open. Map only to exact source scenarios and approved expected-result authority; no invented file limits, scan outcomes, test IDs or pass status. No test execution is claimed.


## 34. DD-09/DD-10 recipient communication atomic leaf traceability

Use [docs/157 — DD-09/DD-10 Recipient Identity, Controlled Distribution, Acknowledgement and Substantive Response Atomic Leaf Requirements](157_DD09_DD10_RECIPIENT_COMMUNICATION_ATOMIC_LEAF_REQUIREMENTS_WORKING_DRAFT.md) with docs/77–78 and cross-review docs/132. It records RFI-RCP-L001–L044 across recipient/Transmittal/manifest identity, party/endpoint authority, per-recipient access, DEC-103 delivery and Required-only acknowledgement denominators, Unknown/Unconfirmed outcomes, retry and changed-scope Transmittal boundaries, independent acknowledgement/substantive-response requests, immutable response correction and wrong-recipient incidents. RCP-01–RCP-12 and DEP-RCP-01–DEP-RCP-12 remain open. Map only to exact AT-RFI/E2E definitions and approved expected-result authority; no external dispatch, test execution or pass is claimed.
