# OR-01 — RFI Lifecycle Decision Decomposition and Review Worksheet

**Document type:** Atomic decision decomposition and controlled review worksheet  
**Date:** 2026-11-12  
**Status:** WORKING — DISP-OR01-001 AND DISP-OR01-003 THROUGH DISP-OR01-008 CONDITIONALLY APPROVED BY OWNER FOR RECORDED SCOPES; OTHER OR-01 DISPOSITIONS AND SPECIALIST SIGN-OFFS PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent review:** OR-01 / CR-01 / RFI-DD-01  
**Source specification:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`, §§3.1–3.5  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`, OR-01  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Controlling governance:** DEC-104, DEC-105, DEC-106, DEC-107, DEC-108, DEC-109, DEC-110; related DEC-022-A/B where revision classification is implicated

> This worksheet decomposes the candidate lifecycle model into individually reviewable questions. It does not choose candidate states, approve transition rules, assign named authorities, amend governance, or authorize workflow implementation or test execution. All dispositions remain blank.

## 1. Review method and scope

OR-01 concerns the **parent RFI lifecycle**: the official RFI identity's current technical/administrative stage, transition guards, terminal outcomes, cycle behavior and relationship to subordinate records.

The source draft contains 13 candidate state/record labels, a transition matrix, consistency rules and subordinate record models. Those are proposals, not approved vocabulary. The review must consider meaning, entry/exit guards, actor authority, evidence, failure behavior and history together; approving a label alone is insufficient.

Use one disposition record per item below in docs/87. The IDs in this worksheet are proposed stable identifiers for this review decomposition; they do not imply approval.

### 1.1 Candidate state/record inventory from docs/72 §3.2

| Candidate label | Source classification | Review treatment |
|---|---|---|
| Draft | Draft record outside official lifecycle | Preserve DEC-107 boundary; review only draft lifecycle details not already fixed |
| Abandoned Draft | Draft disposition, not official withdrawal | Review only if this behavior is in scope; preserve no-number-consumed rule |
| Submitted | Candidate official lifecycle state | Review formal submission success boundary and transition guard against DEC-107 |
| Under Coordination | Candidate official lifecycle state | Review administrative intake/routing boundary under DEC-105 |
| Returned for Completion | Candidate official lifecycle state | Open: eligibility, reasons, re-submission and revision effect |
| In Technical Assessment | Candidate official lifecycle state | Review assignment readiness and technical authority boundary |
| Awaiting Originator Clarification | Candidate official lifecycle state | Review blocking semantics, multiple requests and resume rule |
| Under Consolidation | Candidate official lifecycle state | Open: strictly sequential parent stage or parallel subordinate preparation |
| Under Independent Review | Candidate official lifecycle state | Review trigger dependency, reviewer authority/independence and exact-version binding |
| Ready for Issue | Candidate official lifecycle state | Review readiness evidence and final issue gate |
| Closed | Candidate terminal technical state | Preserve DEC-106/108 separation; review exact closure event/record semantics |
| Withdrawn | Candidate terminal administrative outcome | Preserve DEC-106 boundaries; detailed eligibility/cutoff/authority require review |
| Cancelled | Candidate terminal administrative outcome | Preserve administrative-only meaning; exact eligible states/grounds require review |

The candidate labels above are not a final state machine. The source also explicitly excludes delivery, acknowledgement, access, notification, archive and workload indicators from parent lifecycle vocabulary; see protected invariants in §4.

## 2. Atomic OR-01 disposition catalogue

### OR01-D01 — Final parent lifecycle vocabulary and state meanings

**Source:** docs/72 §3.2  
**Question:** Which candidate labels should form the final parent RFI lifecycle, and what exact meaning distinguishes each adjacent state?  
**Owner decision:** Confirm, amend or defer each label and its meaning; explicitly identify whether any candidate should be removed, renamed, split or merged.  
**Required validation:** Process owner, Document Control, technical architecture, security and QA; validate usability, auditability, invalid-state denial and separation from subordinate records.  
**Blocking dependency:** No final state machine or UI/workflow mapping until vocabulary and semantics are resolved.  
**Disposition:** Conditionally approved by the project owner on 2026-11-12 for the scope recorded in docs/89 §12 and docs/87 §4.3. Specialist validation and downstream reconciliation remain pending; this is not final state-machine approval or implementation authorization.  
**Register ID:** DISP-OR01-001.

### OR01-D02 — Draft boundary, formal submission and official identity

**Source:** docs/72 §§3.1–3.4; DEC-107  
**Question:** What lifecycle details apply to draft creation, abandonment and successful submission, without changing the approved official-number boundary?  
**Owner decision:** Decide only unresolved draft lifecycle behavior and the business meaning of successful submission.  
**Protected constraint:** Drafts and failed attempts do not consume official numbers; number allocation occurs only on first successful formal submission, with the required integrity controls under DEC-107. This constraint is not reopened here.  
**Required validation:** Document Control, architecture, security and records.  
**Blocking dependency:** No allocator, sequence reservation or migration.  
**Disposition:** No new policy disposition; consistency validation pending.  
**Register ID:** DISP-OR01-002 (consistency review only; not authority to reopen DEC-107).  
**Technical consistency memorandum:** [docs/90 — Draft, Formal Submission and Official Identity Consistency Review](90_OR01_D02_SUBMISSION_BOUNDARY_CONSISTENCY_REVIEW_WORKING_DRAFT.md). It records no conflict in the reviewed source wording subject to explicit clarifications; DEC-107 remains unchanged. The Submitted persistent-state versus event-only representation remains a design choice for owner review.

### OR01-D03 — Under Coordination and administrative return for completion

**Source:** docs/72 §3.3 rows Submitted→Under Coordination, Under Coordination→Returned for Completion, Returned for Completion→Under Coordination; §3.4 item 1  
**Question:** Which post-submission deficiencies permit a return, who may issue it, and what evidence and resubmission rules apply?  
**Owner decision:** Decide eligibility categories and whether any return reason affects revision/version treatment, subject to DEC-022-A/B and technical validation.  
**Required validation:** Document Control, process owner, technical authority, architecture and QA.  
**Open issues:** exact eligible states; whether return is permitted after technical work begins; mandatory reason taxonomy; handling of prior submissions and controlled-content changes.  
**Blocking dependency:** No generic return action or revision side effect by assumption.  
**Disposition:** **Conditionally approved — Option C (hybrid stage gate), 2026-11-12.** Normal administrative return is limited to the pre-technical-assessment stage. A genuine administrative defect discovered after technical assessment begins is recorded and referred through a separately authorized correction/exception path; no generic parent-state return or silent lifecycle reset is permitted. The parent lifecycle remains unchanged unless a distinct, explicit owner-approved transition rule governs the case. Specialist validation and detailed prerequisites remain pending.  
**Register ID:** DISP-OR01-003.

**Detailed review and owner disposition memorandum:** [docs/91 — Coordination and Return for Completion](91_OR01_D03_COORDINATION_AND_RETURN_FOR_COMPLETION_WORKING_DRAFT.md), §16. Option C is conditionally approved within the recorded scope; it does not appoint operational actors or authorize implementation.

### OR01-D04 — Administrative routing into technical assessment

**Source:** docs/72 §§3.2–3.4 and §§4.1–4.6; Under Coordination→In Technical Assessment; DEC-105; related DISP-OR01-003 / Option C  
**Question:** What evidence is required before administrative coordination can route the RFI into technical assessment, and which decisions remain exclusively with the appointed technical authority?  
**Owner decision:** Decide the hand-off gate and minimum routing evidence, without appointing specific people or granting capabilities.  
**Protected constraint:** Coordinator performs administrative routing only. Technical authority determines discipline scope and technical leadership; valid assignment authority establishes scoped discipline assignments. No appointment, discipline ownership or technical authority may be inferred from job title, membership or convenience.  
**Required validation:** Relevant discipline/technical authorities, project/process owner, Document Control, architecture, security and QA.  
**Open issues:** two-key hand-off; complete versus partial assignment gate; appointment evidence; ambiguous/missing discipline ownership; technical lead requirement; assignee acceptance; routing corrections/reassignment and partial preparation.  
**Detailed technical review:** [docs/92 — Administrative Routing into Technical Assessment](92_OR01_D04_ADMINISTRATIVE_ROUTING_TO_TECHNICAL_ASSESSMENT_WORKING_DRAFT.md). It recommends separate technical authorization and administrative execution, a complete routing package, and holding the parent in Under Coordination when authority, scope or required assignments are unresolved.  
**Disposition:** **Conditionally approved — two-key hand-off + complete required-assignment gate, 2026-11-12.** The appointed technical authority determines and records disciplines, scope, required lead and assignments; the coordinator verifies the complete routing package and performs only the administrative transition. The parent remains Under Coordination if required authority, assignments or access evidence are missing, expired, ambiguous or unauthorized. Specialist validation and detailed prerequisites remain pending.  
**Detailed owner disposition:** [docs/92 §15](92_OR01_D04_ADMINISTRATIVE_ROUTING_TO_TECHNICAL_ASSESSMENT_WORKING_DRAFT.md).  
**Register ID:** DISP-OR01-004.

### OR01-D05 — Clarification blocking and resume behavior

**Source:** docs/72 §§3.2–3.5, especially §3.3 transitions and §3.4 item 3  
**Question:** When does a clarification request block a contribution or the parent RFI, how are multiple concurrent requests and partial responses aggregated, who determines sufficiency, and what exact parent stage resumes?  
**Owner decision:** Decide explicit blocking criteria, contribution-only versus parent-progression effect, aggregation, response sufficiency and resume semantics.  
**Technical review:** [docs/93 — Clarification Blocking and Resume Behavior](93_OR01_D05_CLARIFICATION_BLOCKING_AND_RESUME_BEHAVIOR_WORKING_DRAFT.md) recommends explicit dependency-based blockers, separate request/response records, parent Awaiting only for a valid parent-progression blocker, and resume to the exact prior parent state only after all parent blockers are resolved and current guards pass.  
**Required validation:** Process owner, technical authority/lead, discipline specialists, architecture, security, Document Control, QA and records; include concurrent, partial, duplicate, stale and post-issue cases.  
**Open issues:** exact source states; authority for parent-level blocking; whether unaffected disciplines may continue; partial-response follow-up model; request correction/withdrawal/supersession; cross-discipline disputes; Under Consolidation and post-issue handling.  
**Blocking dependency:** No single-flag implementation that loses per-request scope/history; no automatic resume on response receipt; no parent progression past an open parent-level blocker.  
**Disposition:** **Conditionally approved** on 2026-11-12 for the five principles in docs/93 §16; specialist validation and detailed prerequisites remain pending.  
**Register ID:** DISP-OR01-005.

### OR01-D06 — Under Consolidation entry and sequencing

**Source:** docs/72 §§3.2–3.4, especially §3.3 and §3.4 item 2  
**Question:** Must the parent enter Under Consolidation only after all required contributions are complete or formally removed by authorized scope change, or may parallel consolidation occur while non-blocking work continues?  
**Owner decision:** Decide the parent-stage meaning and acceptable sequencing.  
**Required validation:** Technical lead/discipline authorities, architecture and QA.  
**Open issues:** distinction between subordinate provisional preparation and formal parent-state transition; explicit classification of required versus optional inputs; completeness authority; treatment of open clarification blockers; conflict/dissent handling; scope-removal evidence; version/concurrency safeguards.  
**Blocking dependency:** Do not weaken the required-contribution gate, enter Under Consolidation with an incomplete required contribution, or allow provisional preparation to appear as a formal consolidated response.  
**Technical recommendation memorandum:** [docs/94 — Under Consolidation Entry and Sequencing](94_OR01_D06_UNDER_CONSOLIDATION_ENTRY_AND_SEQUENCING_WORKING_DRAFT.md). It recommends a complete required-contribution gate for the parent transition while permitting limited, versioned subordinate preparation in parallel without changing the parent state.  
**Disposition:** **Conditionally approved, 2026-11-12** for the complete required-contribution parent-entry gate and limited provisional subordinate preparation in parallel while the parent remains In Technical Assessment. Specialist validation, detailed prerequisites and downstream reconciliation remain pending; no implementation authorization.  
**Detailed owner disposition:** [docs/94 §16](94_OR01_D06_UNDER_CONSOLIDATION_ENTRY_AND_SEQUENCING_WORKING_DRAFT.md).  
**Register ID:** DISP-OR01-006.

### OR01-D07 — Return from consolidation to technical assessment

**Source:** docs/72 §3.3 row Under Consolidation→In Technical Assessment  
**Question:** Which gaps or conflicts require return to discipline work, who may initiate the return, and what candidate response/contribution history must be preserved?  
**Owner decision:** Decide business-level return conditions and required reason/evidence.  
**Required validation:** Technical lead and relevant discipline authorities, Document Control, architecture and QA.  
**Open issues:** materiality threshold separating consolidation judgement from new discipline work; return initiation versus authorization; narrow versus broad affected scope; authority for assignment/scope changes; immutable contribution and candidate version lineage; clarification and independent-review interactions; re-entry gate and stale-state controls.  
**Technical recommendation memorandum:** [docs/95 — Return from Consolidation to Technical Assessment](95_OR01_D07_RETURN_FROM_CONSOLIDATION_TO_TECHNICAL_ASSESSMENT_WORKING_DRAFT.md). It recommends a materiality/authority test, selective return of affected discipline work, immutable preservation of prior contributions and consolidated candidates, and re-entry only after the DISP-OR01-006 gate is re-satisfied.  
**Disposition:** **Conditionally approved, 2026-11-12**, for the seven business principles recorded in docs/95 §19; specialist validation and detailed prerequisites remain pending. No implementation authorization.  
**Register ID:** DISP-OR01-007.

### OR01-D08 — Independent review trigger and exact-version gate

**Source:** docs/72 §§3.2–3.4, rows Under Consolidation→Under Independent Review and reviewer outcomes  
**Question:** Which approved risk/authority triggers require independent review, what constitutes a valid reviewer outcome, and when must re-review occur?  
**Owner decision:** Confirm the governance route for adopting a risk/authority matrix; do not invent risk thresholds or appoint reviewers through this worksheet.  
**Required validation:** Technical/risk authority, QA, security and relevant discipline authorities.  
**Open issues:** actual approved risk matrix; reviewer competence/independence evidence; substitution; blocking versus advisory comments; version change materiality and re-review triggers.  
**Protected constraint:** Review applies to an exact frozen response version; a material change cannot inherit approval of a prior version.  
**Blocking dependency:** No review trigger defaults or review-clearance implementation while the matrix/authority remains unresolved.  
**Technical recommendation memorandum:** [docs/96 — Independent Review Trigger and Exact-Version Gate](96_OR01_D08_INDEPENDENT_REVIEW_TRIGGER_AND_EXACT_VERSION_GATE_WORKING_DRAFT.md).  
**Owner disposition:** **Conditionally approved on 2026-11-12** for the seven principles recorded in docs/96 §17.  
**Conditions:** Approved/versioned risk-authority matrix and its authority remain to be evidenced; reviewer competence/appointment/independence, final outcome/comment rules, exact package integrity, change materiality and targeted/full re-review criteria require specialist validation. No implementation or test authorization.  
**Register ID:** DISP-OR01-008.

### OR01-D09 — Ready for Issue entry criteria

**Source:** docs/72 §§3.2–3.3  
**Question:** What evidence proves all contributions, conflicts and mandatory reviews are complete before the RFI can be marked Ready for Issue?  
**Owner decision:** Confirm the business readiness checklist and whether a separate readiness confirmation is required.  
**Required validation:** Technical authority, discipline leads, independent reviewer where required, Document Control and QA.  
**Open issues:** authoritative readiness confirmer and issuer appointment; required-contribution completion evidence; parent blocker and conflict closure; exact-version independent-review/no-review evidence; readiness confirmation record; issue-time revalidation and change invalidation.  
**Technical recommendation memorandum:** [docs/97 — Ready for Issue Entry Criteria](97_OR01_D09_READY_FOR_ISSUE_ENTRY_CRITERIA_WORKING_DRAFT.md). It proposes a pre-issue readiness checklist, distinct attributable readiness confirmation, exact-version package binding, current issue authority and action-time revalidation, while preserving formal issue/closure and Transmittal as separate events.  
**Blocking dependency:** No readiness status based solely on UI action, coordinator action, elapsed time, absence of comments or a stale approval.  
**Owner disposition:** **Conditionally approved on 2026-11-12** for the ten principles recorded in docs/97 §16.  
**Approved scope:** Ready for Issue is pre-issue only; readiness checklist covers current authority/scope/assignments, complete required contributions, blockers/clarifications/conflicts, applicable exact-version independent review or authorized no-review determination, frozen response/evidence package and attributable readiness confirmation; readiness confirmation does not confer issue authority; the technical issuer is separately appointed and revalidates at action time; material changes/stale evidence require reassessment; readiness, formal issue, technical closure, Transmittal and recipient events remain separate; exceptions require approved rules and cannot waive mandatory controls.  
**Conditions:** Specialist validation remains required. Actual readiness confirmer/issuer appointments and delegation, discipline completion and scope-removal criteria, conflict/clarification rules, approved review matrix and no-review evidence, package manifest/integrity, change materiality, stale-state/concurrency and formal issue/closure transaction design remain pending. No implementation, test or release authorization.  
**Register ID:** DISP-OR01-009.

### OR01-D10 — Formal issue and technical closure

**Source:** docs/72 §§3.2–3.4; DEC-106; DEC-108  
**Question:** What business-level evidence and authority must be present for formal issue and technical closure to be one controlled outcome?  
**Owner decision:** Confirm only the unresolved lifecycle semantics and evidence required for the authorized issue action.  
**Protected constraints:** Technical response authority remains separate from Document Control distribution; technical closure is not delivery, access, acknowledgement or substantive response. Preserve the exact response version and closure history.  
**Required validation:** Technical issuer authority, Document Control, architecture, security, QA and records.  
**Open issues:** issue-time authority and readiness revalidation; immutable issue identity and package evidence; atomic issue/closure business outcome; failure/retry/idempotency/concurrency behavior; any narrow separate-closure exception; post-issue correction and reopening boundaries.  
**Technical recommendation memorandum:** [docs/98 — Formal Issue and Technical Closure](98_OR01_D10_FORMAL_ISSUE_AND_TECHNICAL_CLOSURE_WORKING_DRAFT.md). It recommends formal issue by a separately appointed technical issuer after full action-time revalidation, with successful issue and technical closure as one atomic business outcome; failed attempts create neither successful issue nor Closed; Transmittal and recipient events remain independent.  
**Blocking dependency:** No partial issue/closure behavior, stale authorization, duplicate issue, or external delivery coupling.  
**Disposition:** **Conditionally approved by owner on 2026-11-12** for the ten principles recorded in docs/98 §17; specialist validation and implementation prerequisites remain pending.  
**Register ID:** DISP-OR01-010.

### OR01-D11 — Withdrawal eligibility, cutoff and authority

**Source:** docs/72 §3.3 withdrawal row; DEC-106; DISP-OR01-010.  
**Question:** Which pre-issue states are eligible for withdrawal, what constitutes substantive technical work having begun, and which authority validates the request?  
**Owner decision:** Confirm the originator request boundary, pre-issue cutoff, substantive-work evidence threshold, required technical-lead concurrence and designated withdrawal authorization route.  
**Protected constraints:** Withdrawal is not automatic on request; the originator's request is distinct from the authorized decision; technical-lead concurrence is required after substantive work begins; official identity and all work/communication history are preserved. After successful formal issue, use a separately governed post-issue route, not withdrawal.  
**Required validation:** Project/process owner, appointing and technical authorities, technical lead/discipline specialists, Document Control/records, architecture, security, QA and contract governance as applicable.  
**Open issues:** eligible pre-issue state set including Ready for Issue; objective substantive-work taxonomy/evidence; lead absence/substitution; designated administrative validator/approver; whole-RFI versus partial scope; issue/withdrawal concurrency and external communication.  
**Technical recommendation memorandum:** [docs/99 — Withdrawal Eligibility, Cutoff and Authority](99_OR01_D11_WITHDRAWAL_ELIGIBILITY_CUTOFF_AND_AUTHORITY_WORKING_DRAFT.md). It recommends originator/delegate request only, authorization strictly before successful issue, evidence-based substantive-work cutoff, technical-lead concurrence after that cutoff, a separately appointed administrative withdrawal authority, whole-parent withdrawal by default, preservation of all records, and deterministic issue/withdrawal concurrency.  
**Blocking dependency:** No automatic withdrawal on request, inferred concurrence, withdrawal after issue, partial-discipline removal through parent withdrawal, or deletion/reuse of identity/history.  
**Disposition:** Not recorded; owner decision and specialist validation pending.  
**Register ID:** DISP-OR01-011.

### OR01-D12 — Cancellation eligibility, grounds and authority

**Source:** docs/72 §3.3 cancellation row; DEC-106  
**Question:** Which administrative states and evidenced grounds permit cancellation, and when is technical-lead concurrence required?  
**Owner decision:** Confirm allowable administrative grounds and authority mapping, without treating cancellation as technical rejection.  
**Protected constraint:** Cancellation is administrative only, requires an evidenced permitted ground and preserves identity/history; technical-lead concurrence is required where technical work has begun under the approved policy boundary.  
**Required validation:** Document Control, technical authority, records, contract/legal authority as applicable, security and QA.  
**Open issues:** exhaustive eligible-state set; duplicate/invalid-registration evidence; handling of active contributions, review and external communication records.  
**Blocking dependency:** No cancellation for convenience or to erase an unfavorable technical outcome.  
**Disposition:** Not recorded.  
**Register ID:** DISP-OR01-012.

### OR01-D13 — Reopening and new response cycle

**Source:** docs/72 §3.3 Closed→Reopened event; §3.4 item 6; DEC-106  
**Question:** After an RFI is closed, how should the new cycle select its starting stage based on the reason and scope, and what prior records remain immutable?  
**Owner decision:** Decide the project-level resumption policy only within DEC-106's requirement for a new cycle and preserved prior closure.  
**Required validation:** Technical authority, records, Document Control, architecture, security and QA.  
**Open issues:** whether reopening always returns to Technical Assessment or uses a governed resumption rule; reappointment/reassignment; review and conflict reassessment; relationship to prior Transmittals and recipient responses.  
**Protected constraint:** Reopening does not edit or erase the prior issued response/closure; it creates a new cycle with traceable predecessor linkage.  
**Blocking dependency:** No in-place reopening or overwriting of prior issued content.  
**Disposition:** Not recorded.  
**Register ID:** DISP-OR01-013.

### OR01-D14 — Parent lifecycle versus subordinate records and indicators

**Source:** docs/72 §§3.1, 3.4, 3.5; DEC-103, DEC-108, DEC-109  
**Question:** Which subordinate events may influence parent stage, and which must remain independent records/indicators?  
**Owner decision:** Confirm aggregation semantics for each subordinate class without collapsing distinct event histories.  
**Required validation:** Architecture, Document Control, security, records, QA, technical authority.  
**Open issues:** exact parent aggregation for multiple discipline assignments, clarification requests, response candidates, reviews and cycles; reporting projections versus authoritative lifecycle.  
**Protected constraints:** delivery/access/acknowledgement/notification/archive/workload indicators are separate from parent technical lifecycle; subordinate state does not automatically advance or close the parent.  
**Blocking dependency:** No parent-state inference from read receipts, delivery events, notifications or archive status.  
**Disposition:** Not recorded.  
**Register ID:** DISP-OR01-014.

## 3. Cross-item dependencies and recommended review sequence

| Sequence | Disposition IDs | Why this order |
|---|---|---|
| 1 | DISP-OR01-001, 002 | Establish the state vocabulary and the fixed official-identity boundary |
| 2 | DISP-OR01-003, 004 | Define administrative intake/return and the hand-off into technical authority |
| 3 | DISP-OR01-005 | Resolve clarification blocking/resumption before finalizing stage aggregation |
| 4 | DISP-OR01-006, 007 | Resolve consolidation entry and return-to-discipline behavior |
| 5 | DISP-OR01-008, 009 | Resolve independent review and readiness gates |
| 6 | DISP-OR01-010 | Resolve issue/closure semantics after readiness gates |
| 7 | DISP-OR01-011, 012, 013 | Resolve terminal administrative outcomes and reopening cycle |
| 8 | DISP-OR01-014 | Finalize parent/subordinate aggregation after the individual record models are settled |

Dependencies are review sequencing recommendations, not approved workflow transitions. Where an earlier decision changes a later question, revise and re-review the affected item.

## 4. Protected governance constraints — consistency checks, not new approvals

The following are not reopened by OR-01. If a proposed lifecycle detail conflicts with them, stop and use the formal governance amendment route.

| Governance reference | Constraint to preserve in lifecycle design |
|---|---|
| DEC-104 | Confirmed RFI operating-model policy remains controlling; this worksheet does not reapprove or rewrite it |
| DEC-105 | Coordinator is administrative; discipline responsibility, technical leadership, independent review and formal response authority remain distinct |
| DEC-106 | Clarification, formal revision, withdrawal, cancellation, reopening and closure retain their approved boundaries |
| DEC-107 | Draft/failed submission does not consume official number; successful first formal submission is the numbering boundary; immutable evidence requirements remain |
| DEC-108 | Technical issue, controlled external Transmittal distribution, recipient acknowledgement and substantive response remain separate |
| DEC-109 | Notifications, monitoring, reporting, archive and retention do not create lifecycle transitions or unapproved defaults |
| DEC-110 | Test catalogue is a design framework only; no test execution or pass claim is made |

DEC-103 remains relevant to recipient-level delivery/acknowledgement aggregation and must not be collapsed into parent RFI lifecycle.

## 5. Specialist review evidence matrix

No named reviewer or appointment is presumed. Complete the following only when actual authority and evidence are available.

| Review domain | Required validation | Evidence to retain | Status |
|---|---|---|---|
| Process / RFI owner | Business meaning, transition necessity, scope and exception handling | Attributable review and exact decision authority reference | Pending |
| Technical / discipline authority | Technical assessment, consolidation, conflict, readiness, issue, withdrawal and reopening semantics | Scoped technical findings and authority/appointment evidence | Pending |
| Document Control | Administrative intake, official record identity, return, issue/distribution boundary and history | Controlled process review | Pending |
| Architecture / engineering | State integrity, concurrency, version binding, idempotency and failure behavior | Architecture review and failure-mode findings | Pending |
| Security / identity | Action-time authorization, least privilege, invalid-transition denial and record isolation | Security review and negative-case findings | Pending |
| QA / test authority | Testability, traceability, boundary and race-condition coverage | Review findings and proposed acceptance evidence | Pending |
| Records / legal / contract as applicable | Record preservation, withdrawal/cancellation evidence, closure/reopening history and applicable external constraints | Authority determination and records review | Pending |

## 6. Decision record capture

For every DISP-OR01-NNN, create/populate the corresponding atomic record in docs/87 §5. At minimum record:

- exact decision statement and source section/version;
- actual decision authority, instrument and scope;
- specialist findings and dissent;
- exact disposition, rationale, conditions and effective scope;
- evidence references and timestamp;
- DEC-103–DEC-110 consistency check;
- downstream docs/72, docs/71, docs/85, docs/86, docs/87 and test traceability updates;
- independent verification.

**No disposition is recorded by this worksheet.** All fourteen items remain pending review; items marked consistency-only must not be treated as an opportunity to reopen confirmed governance.

## 7. Explicit exclusions and gate

This worksheet does not authorize state-machine coding, UI changes, API/workflow implementation, capability grants, DB/schema/migration/generated types, Storage, auth/RLS, production-data operation, live testing, backup/restore, merge or deployment. Any such work requires a separate scoped plan, risk review, safeguards and explicit authorization.

---
**End of OR-01 decomposition worksheet — working draft only.**
