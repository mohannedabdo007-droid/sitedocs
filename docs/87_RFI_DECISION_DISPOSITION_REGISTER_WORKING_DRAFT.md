# RFI Decision Disposition Register — Working Draft

**Document type:** Controlled index and status register for owner decisions and specialist reviews  
**Date:** 2026-11-12  
**Status:** WORKING — SIX OWNER DISPOSITIONS CONDITIONALLY APPROVED (DISP-OR01-001, 003, 004, 005, 006 and 007); REMAINING DISPOSITIONS AND SPECIALIST REVIEWS PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Companion records:** `docs/85_RFI_OWNER_AND_SPECIALIST_REVIEW_MATRIX_WORKING_DRAFT.md`, `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Detailed specifications:** `docs/72`–`docs/83`  
**Backlog:** `docs/71_RFI_DETAILED_SPECIFICATION_BACKLOG.md`  
**Governance baseline:** DEC-103–DEC-110

> This register is an index and control record. It does not appoint any person, create authority, amend a governance decision, or authorize implementation, testing, data operations or deployment. Six owner dispositions (DISP-OR01-001, 003, 004, 005, 006 and 007) are recorded as Conditionally approved for their exact scopes; all other disposition and specialist-review fields remain pending unless expressly recorded below.

## 1. Purpose and relationship to companion documents

This register consolidates the status and evidence for owner decisions and specialist reviews arising from CR-01–CR-12.

1. **docs/87:** working index of disposition status, authority, evidence, dependencies and downstream impact.
2. **docs/86:** detailed decision questions and blank decision sheets OR-01–OR-12; captures deliberation.
3. **docs/85:** review domains, specialist validation and operational authority evidence; it does not appoint reviewers.

The detailed specifications (docs/72–83) remain working drafts. A register entry does not approve a specification. Update a specification and backlog only after a disposition is validly evidenced and reconciled.

## 2. Non-negotiable recording rules

1. Record one disposition per discrete consequential rule, not a blanket approval of an OR group or DD file.
2. Assign a stable unique Disposition ID. Never reuse an ID; later decisions create a linked revision/event.
3. Identify the actual decision authority and source/scope of authority. The project owner cannot substitute for a separately required technical, contractual, legal, records, security or statutory authority.
4. Specialist review is validation/advice unless a documented appointment explicitly grants decision authority for that subject and scope.
5. Record approval only when the authorized decision-maker's attributable decision and supporting evidence are available. Silence, attendance, delivery, acknowledgement or an unappointed review is not approval.
6. Record conditions, dissent, rationale, scope, effective date and dependencies. Preserve objections.
7. Conditional approval is not an implementation release. Conditions and independent prerequisites must close before dependent gates pass.
8. A conflict with DEC-103–DEC-110 stops the affected item and triggers formal governance amendment/reconciliation. This register cannot override governance.
9. If authority, evidence, scope or prerequisite is unclear, mark **Blocked — Pending Decision/Prerequisite**; do not infer a default.
10. This is a design register only. Implementation, test execution, DB/schema/migration, Storage, auth/RLS/grants, production-data operations, backup/restore, merge and deployment require separate reviewed plans and explicit approval.

## 3. Controlled status vocabulary

| Status | Entry rule | Interpretation |
|---|---|---|
| Open | Decision identified; review package not ready | No disposition |
| Pending review | Required owner/specialist review outstanding | Review outstanding |
| Blocked — Pending Decision/Prerequisite | Authority decision, evidence or prerequisite missing | Dependent activity must not proceed |
| Amend and return | Reviewer/authority requires revision | Not approved |
| Conditionally approved | Authorized decision-maker approves exact scope subject to explicit conditions | Conditions remain blocking; no dependent gate passes |
| Approved | Authority approved exact scope/version; evidence retained; required prerequisites satisfied | Approved only for recorded scope; not implementation authorization |
| Rejected | Authorized rejection with evidence | Do not proceed on proposal |
| Deferred | Explicitly deferred by authority or prerequisite | No implied approval |
| Superseded | Replaced by linked valid successor | Preserve history |

**Status integrity:** “Approved” never means draft complete, discussion held or comments received. Without attributable evidence, the status cannot be Approved.

## 4. Master disposition index

These twelve rows are workstream indexes, not twelve blanket decisions. Each OR sheet must be decomposed into atomic Disposition IDs before consequential approval.

| Review | Risk / detailed work | Source | Required decision domains (not appointments) | Initial status | Interim control |
|---|---|---|---|---|---|
| OR-01 | CR-01 lifecycle/transitions; DD-01 | docs/72; docs/86 §OR-01; [docs/88 OR-01 decomposition](88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md); [docs/89 DISP-OR01-001 vocabulary review](89_OR01_D01_STATE_VOCABULARY_REVIEW_WORKING_DRAFT.md) | Owner/process authority; architecture; Document Control; security; QA | Pending review | DISP-OR01-001, DISP-OR01-003 and DISP-OR01-004 conditionally approved within recorded scopes; 11 other atomic items and specialist validation pending; no workflow implementation |
| OR-02 | CR-02 capabilities/appointments/delegation; DD-02 | docs/72; docs/86 §OR-02 | Owner; project/party governance; identity/security; privacy; architecture | Pending review | No inferred grants or appointments |
| OR-03 | CR-03 discipline/conflict/independent review; DD-03/04 | docs/72; docs/86 §OR-03 | Owner; discipline and technical/risk authorities; QA; security | Pending review | No coordinator tie-break, assumed concurrence or self-review |
| OR-04 | CR-04 classification/numbering/legacy identity; DD-05/06 | docs/73–74; docs/86 §OR-04 | Owner; technical authority; Document Control; records/data; architecture/security | Pending review | No allocator, guessed format, renumbering or migration |
| OR-05 | CR-05 concurrency/idempotency/transaction/recovery; DD-07 | docs/75; docs/86 §OR-05 | Owner for business outcomes; architecture; data integrity; security; records | Pending review | No state-changing implementation or live recovery |
| OR-06 | CR-06 attachment/evidence security; DD-08 | docs/76; docs/86 §OR-06 | Owner; security; privacy; records; architecture; operations | Pending review | No real file/storage operations |
| OR-07 | CR-07 recipient identity/external access/distribution; DD-09 | docs/77; docs/86 §OR-07 | Owner; communication authority; identity/security; Document Control | Pending review | No provider/channel/access pattern selected |
| OR-08 | CR-08 acknowledgement/substantive response; DD-10 | docs/78; docs/86 §OR-08 | Owner; Document Control; technical authority; contract/records/security as applicable | Pending review | Candidate catalogue only; no deemed acceptance/SLA |
| OR-09 | CR-09 reopening/withdrawal/cancellation; DD-11 | docs/79; docs/86 §OR-09 | Owner; technical authority; records/Document Control; contract/security/QA | Pending review | No unresolved exception action |
| OR-10 | CR-10 notifications/reporting/search/export; DD-12/13 | docs/80–81; docs/86 §OR-10 | Owner; operations; reporting authority; security/privacy; architecture; records; QA | Pending review | No defaults/provider/implementation |
| OR-11 | CR-11 retention/archive/legal hold/disposition; DD-14 | docs/82; docs/86 §OR-11 | Owner; records; legal/contract authority as applicable; security; architecture; operations; QA | Pending review | No archive/hold/deletion/backup/restore |
| OR-12 | CR-12 verification/acceptance; DD-15 | docs/83; docs/86 §OR-12 | Owner; QA/test authority; security; records; architecture | Pending review | No test execution/pass/release claim |

**Current roll-up:** 12 review workstream indexes; 7 owner dispositions recorded as Conditionally approved (DISP-OR01-001 and DISP-OR01-003 through DISP-OR01-008); the remaining workstream indexes and OR-01 atomic items remain pending review/disposition, with specialist validation still outstanding. This is a controlled owner direction, not evidence that specialist reviews occurred or that implementation is authorized.

### 4.1 OR-01 atomic decomposition

The OR-01 worksheet in [docs/88](88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md) decomposes the candidate lifecycle specification into **14 individually traceable review items**:

- DISP-OR01-001 — final parent lifecycle vocabulary and meanings.
- DISP-OR01-002 — draft/formal-submission boundary; consistency check only, not reopening DEC-107. [Technical consistency memorandum: docs/90](90_OR01_D02_SUBMISSION_BOUNDARY_CONSISTENCY_REVIEW_WORKING_DRAFT.md) — no conflict identified in reviewed wording subject to clarifications; DEC-107 unchanged.
- DISP-OR01-003 — administrative return for completion. [Technical review and owner disposition: docs/91](91_OR01_D03_COORDINATION_AND_RETURN_FOR_COMPLETION_WORKING_DRAFT.md) — Option C conditionally approved by owner; specialist validation and detailed prerequisites pending.
- DISP-OR01-004 — administrative routing into technical assessment. [Technical review and owner disposition: docs/92](92_OR01_D04_ADMINISTRATIVE_ROUTING_TO_TECHNICAL_ASSESSMENT_WORKING_DRAFT.md) — two-key hand-off and complete required-assignment gate conditionally approved by owner; specialist validation and detailed prerequisites pending.
- DISP-OR01-005 — clarification blocking and resume behavior. [Technical review and owner disposition: docs/93](93_OR01_D05_CLARIFICATION_BLOCKING_AND_RESUME_BEHAVIOR_WORKING_DRAFT.md) — five principles conditionally approved by owner; specialist validation and detailed prerequisites pending.
- DISP-OR01-006 — consolidation entry and sequencing. [Technical review memorandum: docs/94](94_OR01_D06_UNDER_CONSOLIDATION_ENTRY_AND_SEQUENCING_WORKING_DRAFT.md) — complete required-contribution gate for parent transition; limited provisional subordinate preparation may proceed in parallel without changing parent state; owner disposition conditionally approved; specialist validation pending.
- DISP-OR01-007 — return from consolidation to discipline work. [Technical review and owner disposition: docs/95] — seven business principles conditionally approved by owner; specialist validation and detailed prerequisites pending.
- DISP-OR01-008 — independent-review trigger and exact-version gate. [Technical recommendation and owner disposition: docs/96] — seven principles conditionally approved by owner; matrix/authority, reviewer-independence, exact-package, outcome and re-review details remain subject to specialist validation.
- DISP-OR01-009 — Ready for Issue entry criteria.
- DISP-OR01-010 — formal issue and technical closure.
- DISP-OR01-011 — withdrawal eligibility, cutoff and authority.
- DISP-OR01-012 — cancellation eligibility, grounds and authority.
- DISP-OR01-013 — reopening and new response cycle.
- DISP-OR01-014 — parent lifecycle versus subordinate records and indicators.

These are **13 substantive review/disposition items plus one governance-consistency check**. DISP-OR01-001 and DISP-OR01-003 through DISP-OR01-008 are conditionally approved within their recorded scopes; all other items remain pending. No specialist sign-off or implementation authorization is implied. The worksheet identifies protected DEC-103–DEC-110 constraints separately so that a detailed lifecycle discussion cannot silently reopen or override them.

#### 4.2 DISP-OR01-001 — vocabulary review memorandum

[docs/89 — OR-01 / DISP-OR01-001 State Vocabulary Review](89_OR01_D01_STATE_VOCABULARY_REVIEW_WORKING_DRAFT.md) provides the candidate-by-candidate technical assessment and the recorded owner disposition.

#### 4.3 DISP-OR01-003 — coordination and return-for-completion review

[docs/91 — OR-01 / DISP-OR01-003 Coordination and Return for Completion](91_OR01_D03_COORDINATION_AND_RETURN_FOR_COMPLETION_WORKING_DRAFT.md) provides the technical review and recorded owner disposition. **Option C (hybrid stage gate) is conditionally approved for the bounded scope in docs/91 §16; specialist validation and detailed prerequisites remain pending.**

#### 4.3 DISP-OR01-001 — owner disposition record (Revision 1)

| Field | Recorded disposition |
|---|---|
| Disposition ID / revision | DISP-OR01-001 / Rev 1 |
| Review group / source | OR-01 / CR-01; docs/72 §§3.1–3.5; technical memorandum docs/89 |
| Decision authority / evidence | Project owner, evidenced by the explicit instruction “أعتمد التوصية” in the project decision conversation dated 2026-11-12; no separate signed instrument is attached |
| Disposition status | **Conditionally approved** |
| Accepted scope | Draft and Abandoned Draft are separate pre-submission draft-record conditions outside the official parent lifecycle; retain the 11 official candidate labels as the baseline for controlled refinement; Closed, Withdrawn and Cancelled remain distinct terminal outcomes; delivery/access/acknowledgement/notification/archive/workload indicators remain outside the parent lifecycle |
| Limits | This does not approve every transition guard, detailed state definition, authority appointment, final enum/UI mapping or the complete RFI state machine; it does not authorize implementation or test execution |
| Conditions | Required process-owner, Document Control, technical architecture, security, QA and records validation as applicable; reconciliation with remaining OR-01 dispositions and downstream specifications |
| Specialist review / dissent | Pending; no specialist sign-off or dissent is claimed |
| Effective date | 2026-11-12 |
| Evidence references | Owner instruction in the project conversation; docs/89 §12; docs/88 OR01-D01 |
| Independent verification | Completed by re-fetching docs/86–89 and checking recorded scope, conditions and implementation boundary on 2026-11-12 |

This conditional approval records the owner's acceptance of the recommendation as a controlled refinement baseline only. It does not promote docs/72 to an authoritative final specification or pass any implementation gate.



#### 4.4 DISP-OR01-003 — owner disposition record (Revision 1)

| Field | Recorded disposition |
|---|---|
| Disposition ID / revision | DISP-OR01-003 / Rev 1 |
| Review group / source | OR-01 / CR-01; docs/72 §§3.2–3.5; technical review memorandum docs/91 |
| Decision authority / evidence | Project owner, evidenced by the explicit instruction “أعتمد C ..اوافق” in the project decision conversation dated 2026-11-12; no separate signed instrument is attached |
| Disposition status | **Conditionally approved — Option C (hybrid stage gate)** |
| Accepted scope | Normal administrative return-for-completion is limited to the pre-technical-assessment stage. A genuine administrative defect discovered after technical assessment begins must be recorded and referred through a separately authorized correction/exception path; it must not trigger a generic Returned for Completion transition or silently reset the parent lifecycle. The parent lifecycle remains unchanged unless a distinct, explicit owner-approved transition rule governs the case. |
| Preserved constraints | DEC-105 administrative/technical separation; DEC-107 official RFI identity and number; immutable original submission/evidence history; DEC-022-A/B classification for material controlled-content changes; DEC-109 separation of lifecycle and workload/communication indicators. |
| Conditions | Specialist validation pending. Defect taxonomy/checklist, designated correction authority and appointment evidence, independent verification, impact on active technical work, completion criteria, repeat-round controls and detailed transition mechanics remain open. No default SLA, timeout, contractual effect or automatic pause. |
| Specialist review / dissent | Pending; no specialist sign-off or dissent is claimed |
| Limits | Does not approve Option B, finalize the full state machine, appoint actors, grant capabilities, or authorize implementation, test execution, DB/Storage/auth/RLS changes, merge or deployment |
| Effective date | 2026-11-12 |
| Evidence references | Owner instruction in the project decision conversation; docs/91 §16; OR01-D03 in docs/88 |
| Independent verification | Completed by re-fetching docs/86–88 and docs/91 and checking recorded scope, conditions and implementation boundary on 2026-11-12 |


#### 4.5 DISP-OR01-004 — administrative routing into technical assessment review

[docs/92 — OR-01 / DISP-OR01-004 Administrative Routing into Technical Assessment](92_OR01_D04_ADMINISTRATIVE_ROUTING_TO_TECHNICAL_ASSESSMENT_WORKING_DRAFT.md) provides a technical recommendation for a two-key hand-off: the appointed technical authority determines and records discipline scope, required technical leadership and assignments; the appointed coordinator performs only the administrative transition after verifying the complete routing package. It recommends holding the parent RFI in Under Coordination when technical authority, discipline ownership, required assignments or access evidence are missing or ambiguous. **Owner disposition:** **Conditionally approved — two-key hand-off + complete required-assignment gate**, 2026-11-12. Specialist validation and detailed prerequisites remain pending. See [docs/92 §15](92_OR01_D04_ADMINISTRATIVE_ROUTING_TO_TECHNICAL_ASSESSMENT_WORKING_DRAFT.md).


#### 4.6 DISP-OR01-004 — owner disposition record (Revision 1)

| Field | Recorded disposition |
|---|---|
| Disposition ID / revision | DISP-OR01-004 / Rev 1 |
| Review group / source | OR-01 / CR-01; docs/72 §§3.2–3.4 and §§4.1–4.6; technical review memorandum docs/92 |
| Decision authority / evidence | Project owner; explicit instruction in the project decision conversation dated 2026-11-12 approving the two-key hand-off and complete-assignment gate as a conditional approval |
| Disposition status | **Conditionally approved — two-key hand-off + complete required-assignment gate** |
| Accepted scope | Appointed technical authority (or explicitly delegated assignment authority) determines and records disciplines, scope, required technical lead and assignments. The appointed coordinator verifies administrative prerequisites and the complete valid routing package, then performs only the administrative parent transition. The parent must not enter In Technical Assessment until all required discipline assignments, any required lead and applicable scope/access evidence are validly established. Missing, expired, ambiguous or unauthorized authority/assignment/access evidence keeps the parent in Under Coordination pending resolution by the designated authority. |
| Preserved constraints | DEC-105 separation of technical authority and administrative coordination; DEC-107 official identity and submitted snapshot; DEC-103/109 separation of delivery/access/acknowledgement/workload indicators; DEC-110 verification principles. No appointment or authority is inferred from title, membership, group presence, keywords or convenience. |
| Conditions | Specialist validation pending. Appointing authority/evidence, assignment fields, mandatory-lead criteria, assignee acceptance, unavailable-discipline escalation, pre-transition subordinate preparation, reassignment/change controls, transaction/concurrency and correction/exception mechanics remain open. No default SLA, deadline, contractual effect or notification rule. |
| Specialist review / dissent | Pending; no specialist sign-off or dissent is claimed |
| Limits | Does not appoint actors, grant capabilities, approve final discipline matrix/state machine, or authorize implementation, test execution, DB/Storage/auth/RLS changes, merge or deployment |
| Effective date | 2026-11-12 |
| Evidence references | Owner instruction in the project decision conversation; docs/92 §15; OR01-D04 in docs/88 |
| Independent verification | Completed by re-fetching docs/86–88 and docs/92 and checking the recorded scope, conditions, cross-links and implementation boundary on 2026-11-12 |


#### 4.7 DISP-OR01-005 — clarification blocking and resume behavior review

[docs/93 — OR-01 / DISP-OR01-005 Clarification Blocking and Resume Behavior](93_OR01_D05_CLARIFICATION_BLOCKING_AND_RESUME_BEHAVIOR_WORKING_DRAFT.md) provides the technical recommendation and records the owner's **conditional approval** dated 2026-11-12 for the five principles in §16: explicit dependency-based blockers; contribution-only versus parent-progression scope; parent Awaiting while any valid parent blocker remains open; separate request/response evidence with technical sufficiency review; and guarded exact-prior-state resumption. Specialist validation and detailed prerequisites remain pending.

#### 4.8 DISP-OR01-005 — disposition status

| Field | Current status |
|---|---|
| Disposition ID | DISP-OR01-005 |
| Status | **Conditionally approved** — five principles only |
| Technical review | [docs/93 §15](93_OR01_D05_CLARIFICATION_BLOCKING_AND_RESUME_BEHAVIOR_WORKING_DRAFT.md) |
| Specialist validation | Pending; no specialist sign-off claimed |
| Owner decision | Explicit “اعتمد” dated 2026-11-12; recorded in docs/93 §16 |
| Accepted scope | Explicit dependency-based blocking; contribution-only versus parent-progression effects; parent Awaiting while any valid parent blocker remains open; per-request/response preservation and technical sufficiency review; guarded resume to exact prior parent state |
| Conditions | Exact source states, cross-discipline authority, partial-response follow-up, correction/withdrawal/supersession, Under Consolidation and post-issue handling remain open |
| Interim control | No single clarification-pending flag; no automatic resume on receipt; preserve per-request scope/history; no progression past an open parent-level blocker |
| Implementation boundary | No workflow implementation, tests, DB/Storage/auth/RLS changes or release authorization |


#### 4.10 DISP-OR01-006 — consolidation entry and sequencing review

| Field | Recorded review position |
|---|---|
| Technical review | [docs/94 — Under Consolidation Entry and Sequencing](94_OR01_D06_UNDER_CONSOLIDATION_ENTRY_AND_SEQUENCING_WORKING_DRAFT.md) |
| Recommendation | Parent enters Under Consolidation only after every required contribution is complete and technically confirmed, or formally removed by an authorized evidenced scope change. Limited provisional subordinate preparation may proceed in parallel while the parent remains In Technical Assessment. |
| Protected constraints | DISP-OR01-004 complete required-assignment gate; DISP-OR01-005 parent-progression and contribution-only blocker semantics; DEC-105 authority boundaries; DEC-109 no default SLA; DEC-110 verification principles. |
| Owner decision | **Conditionally approved — 2026-11-12**; see owner disposition record Rev 1 in docs/94 §16 |
| Specialist validation | Pending — technical lead/authority, discipline specialists, process owner, Document Control, architecture, security, QA and records as applicable |
| Interim control | No parent transition with an incomplete required contribution; no coordinator waiver/removal; provisional artifacts remain subordinate, versioned and not for issue |
| Implementation boundary | No workflow implementation, tests, DB/Storage/auth/RLS changes, production-data operation, merge or deployment authorization |

#### 4.11 DISP-OR01-006 — owner disposition record (Revision 1)

| Field | Recorded disposition |
|---|---|
| Disposition ID / revision | DISP-OR01-006 / Rev 1 |
| Review group / source | OR-01 / CR-01; technical memorandum docs/94 |
| Decision authority / evidence | Project owner; explicit instruction “اعتمد” in the project decision conversation dated 2026-11-12 |
| Disposition | **Conditionally approved** |
| Approved scope | (1) Parent remains In Technical Assessment until all required contributions are complete and technically confirmed, or formally removed through an authorized, evidenced scope change; (2) limited provisional subordinate preparation may proceed in parallel while the parent remains In Technical Assessment, without representing it as formal consolidation or readiness for issue |
| Conditions | Specialist validation and downstream reconciliation remain pending; required/optional classification, discipline-specific completion criteria, appointment/delegation evidence, conflict materiality/escalation, provisional record structure and concurrency controls require validation |
| Interim control | No parent entry with incomplete required contribution, open applicable parent blocker, or stale/ambiguous authority/scope/version evidence; provisional work remains subordinate, attributable, versioned and not for issue |
| Specialist validation | Pending — no specialist sign-off claimed |
| Implementation boundary | No workflow implementation, test execution, DB/Storage/auth/RLS changes, production-data operation, backup/restore, merge, deployment or release authorization |

#### 4.9 DISP-OR01-005 — owner disposition record (Revision 1)

| Field | Recorded disposition |
|---|---|
| Disposition ID / revision | DISP-OR01-005 / Rev 1 |
| Review group / source | OR-01 / CR-01; docs/72 §§3.2–3.5; technical memorandum docs/93 |
| Decision authority / evidence | Project owner; explicit instruction “اعتمد” in the project decision conversation dated 2026-11-12 |
| Disposition status | **Conditionally approved** |
| Accepted scope | (1) Blocking requires an authorized technical actor to record a reasoned dependency and affected scope. (2) Contribution-only blockers stop only affected work; independent authorized work may continue without bypassing a dependent gate. (3) Parent enters Awaiting Originator Clarification while any valid parent-progression blocker remains open. (4) Each request/response is separately preserved; partial response or receipt alone does not resolve it; technical sufficiency review is required. (5) After all parent blockers resolve, resume the exact prior parent state, subject to current guards. |
| Conditions | Specialist validation remains pending. Exact source states, cross-discipline authority, partial-response follow-up, request correction/withdrawal/supersession, Under Consolidation and post-issue handling remain open. |
| Specialist review / dissent | Pending; no specialist sign-off or dissent is claimed |
| Effective date | 2026-11-12 |
| Evidence references | Owner instruction in project conversation; docs/93 §16; OR01-D05 in docs/88 |
| Limits | No final state machine, appointments, capabilities, implementation, test execution, DB/Storage/auth/RLS changes, merge or deployment authorization |
| Independent verification | Pending post-write re-fetch of docs/86–88 and docs/93 on 2026-11-12 |


## 5. Atomic disposition record template

Create one record per discrete rule/value/authority question. Copy this template for each Disposition ID; retain completed records and revisions.

### DISPOSITION RECORD — [DISP-ORxx-NNN]

| Field | Required entry |
|---|---|
| Disposition ID / revision | Stable ID and revision |
| Review group / risk | OR-xx / CR-xx |
| Detailed work item | DD-xx and exact document/section/version |
| Decision statement | One precise, answerable question; no bundling |
| Proposed disposition | Exact proposed text/value and alternatives |
| Controlling governance | Applicable DEC references and consistency finding |
| Decision authority | Verified role/person, authority instrument and scope |
| Owner/authority disposition | Exact decision: approve / conditional / amend / reject / defer |
| Specialist validation | Domain, reviewer/appointment where applicable, finding, date, evidence |
| Operational authority prerequisite | Appointment/delegation/competence evidence required before action |
| Conditions/dependencies | Numbered condition, responsible authority, closure evidence, dependent gate |
| Dissent/objection | Author/domain, rationale, resolution or unresolved status |
| Rationale and impact | Lifecycle, roles, records, communication, reporting and test impact |
| Effective scope | Project, party, discipline, document family, workflow and exclusions |
| Version/effective date | Exact text version and date, if validly determined |
| Evidence references | Decision instrument/minutes, specialist review, attachments and repository paths |
| Status | Controlled status from §3 |
| Recorded by / timestamp | Attributable recorder; recorder is not thereby approver |
| Supersedes / superseded by | Linked prior/successor Disposition ID |
| Downstream updates | Specification, backlog, traceability, tests and documents |
| Independent verification | Check of status, authority, evidence, scope and linked documents |

Blank values are intentional. Never fill missing values by inference.

## 6. Review and approval workflow

1. **Prepare:** identify the exact rule in docs/72–83 and create a unique Disposition ID.
2. **Authority check:** verify decision-maker and authority instrument/scope; if unknown, mark Blocked.
3. **Specialist validation:** obtain reviews identified in docs/85 and record each finding separately.
4. **Disposition:** capture exact decision, conditions, rationale, dissent and evidence in the matching OR sheet and register.
5. **Consistency:** check DEC-103–DEC-110; any conflict triggers governance amendment/reconciliation before promotion.
6. **Reconcile:** update affected specification, backlog and traceability only after the disposition is evidenced.
7. **Independently verify:** confirm approved scope/version, authority, evidence, conditions and downstream links.
8. **Evaluate gate:** only then may the relevant design dependency be considered satisfied. Implementation/test authorization remains separate.

## 7. Conditions, dissent and change history

- Conditions are individually numbered and have a responsible authority, closure evidence and dependent gate.
- Conditional approval remains conditional until every condition is verified; no automatic conversion to Approved.
- Material dissent remains visible; no silence, majority-vote shortcut or deletion.
- A changed proposal receives a new revision and renewed review where meaning, risk, authority, scope or evidence changes.
- Superseding decisions link to prior IDs and explain the change. Preserve historical records.
- Clerical corrections log who/when/why and must not silently rewrite decision substance.
- If an approval authority is invalid or out of scope, flag the disposition, block dependent activity and obtain a valid decision; preserve the earlier record.

## 8. Governance invariants to preserve

- **DEC-103:** recipient-level delivery and acknowledgement aggregation remain distinct.
- **DEC-104:** confirmed RFI operating-model recommendations remain governing policy.
- **DEC-105:** administrative coordination, discipline contribution, technical leadership, independent review and formal issue authority remain distinct.
- **DEC-106:** clarification, revision, withdrawal, cancellation, reopening and closure retain approved boundaries.
- **DEC-107:** official numbering and immutable evidence requirements remain; unresolved display/legacy details are not guessed.
- **DEC-108:** formal external distribution, Transmittal identity, recipient acknowledgement and technical RFI closure remain separate.
- **DEC-109:** monitoring, notification, reporting, archive and retention do not create unapproved defaults or authority.
- **DEC-110:** verification criteria remain a design framework; proposed test counts are not executed/passed tests.

If a detailed disposition appears to alter a confirmed constraint, pause it and use the formal governance process. docs/87 cannot amend the governance baseline.

## 9. Promotion and implementation gates

A disposition may be considered **design-approved for its recorded scope** only when all applicable checks are true:

- [ ] Exact decision and affected specification version identified.
- [ ] Decision authority and scope evidenced.
- [ ] Required specialist validations recorded, including dissent.
- [ ] Exact disposition, rationale, conditions and scope attributable.
- [ ] Evidence references accessible and retained.
- [ ] DEC-103–DEC-110 consistency verified or formal governance amendment completed.
- [ ] Conditions/prerequisites closed or explicitly remain blocking.
- [ ] Downstream specification/backlog/traceability reconciled.
- [ ] Independent verification recorded.

Passing this checklist does **not** authorize implementation, test execution, production-data access/change, DB/schema/migration, Storage, auth/RLS/grants, backup/restore, merge or deployment. Those require separate scoped plans, safeguards and explicit approval.

## 10. Current open register actions

| Action | Work | Responsible domain (not named person) | Completion evidence | Status |
|---|---|---|---|---|
| REG-01 | Review OR-01 and decompose lifecycle proposal into atomic dispositions | Owner + process/technical authority + Document Control + security/QA | Completed OR-01 sheet and individual records | Open |
| REG-02 | Verify authority instruments and specialist assignments for each OR group | Project governance / relevant domain authorities | Verified authority and reviewer evidence | Open |
| REG-03 | Populate dispositions only after actual reviews and decisions | Authorized decision authority; register custodian records | Attributable decision evidence | Open |
| REG-04 | Reconcile valid dispositions into DD files, backlog and traceability | Document owner / Document Control | Verified cross-document links and version history | Blocked — Pending Decision/Prerequisite |
| REG-05 | Reassess readiness after conditions and prerequisites close | Owner + relevant technical/security/QA/records authorities | Gate review record | Blocked — Pending Decision/Prerequisite |

## 11. Explicit exclusions

This register does not create named reviewers, appoint authorities, grant permissions, approve the complete RFI specification, choose technology/providers, set SLA/cadence/retention defaults, execute tests, modify application code/data, alter DB/Storage/auth/RLS, perform backup/restore, or authorize merge/deployment.

---
**End of working draft — six owner dispositions (DISP-OR01-001, DISP-OR01-003, DISP-OR01-004, DISP-OR01-005, DISP-OR01-006 and DISP-OR01-007) are conditionally approved for their recorded scopes; remaining dispositions and all specialist sign-offs remain pending. No implementation is authorized.**


### 4.12 DISP-OR01-007 — return from consolidation to technical assessment review

[docs/95 — OR-01 / DISP-OR01-007 Return from Consolidation to Technical Assessment](95_OR01_D07_RETURN_FROM_CONSOLIDATION_TO_TECHNICAL_ASSESSMENT_WORKING_DRAFT.md) provides the technical recommendation and decision questions.

| Field | Recorded review position |
|---|---|
| Technical review | [docs/95 — Return from Consolidation to Technical Assessment](95_OR01_D07_RETURN_FROM_CONSOLIDATION_TO_TECHNICAL_ASSESSMENT_WORKING_DRAFT.md) |
| Recommendation | Return only for material technical gaps, new dependencies, invalidated contributions, material scope/evidence changes or conflicts requiring discipline reassessment beyond the consolidation mandate. Editorial corrections and matters resolvable within appointment remain in Under Consolidation. |
| Authority model | Assigned contributors may identify gaps; appointed technical lead evaluates and initiates/authorizes within appointment; appointed technical authority resolves scope/delegation disputes; coordinator executes only an expressly delegated administrative transition after the technical decision. |
| Scope and records | Return affected work only where dependencies are bounded; preserve unaffected contributions, prior contribution versions and exact consolidated candidate; substantive technical changes require attributable successor versions. |
| Re-entry | Re-satisfy DISP-OR01-006 required-contribution, blocker, scope, assignment, authority and version gates before Under Consolidation resumes. |
| Owner decision | **Conditionally approved** on 2026-11-12; explicit owner instruction “اعتمد” after presentation of the seven principles in docs/95 §18 |
| Accepted scope | Seven principles in docs/95 §19: materiality-based return triggers; no automatic return for editorial/in-scope consolidation matters; appointment-bound technical authority with administrative-only delegated execution; selective affected-scope return; immutable contribution/candidate lineage; separate clarification/review/revision/new-RFI/post-issue routes; and re-entry only after DISP-OR01-006 gates pass |
| Conditions | Specialist validation remains pending; materiality examples, appointment evidence, detailed version/candidate mechanics, clarification/review interactions, concurrency and recovery remain open |
| Specialist validation | Pending — technical lead/authority, discipline specialists, project/process owner, Document Control, architecture, security, QA and records as applicable |
| Interim control | No generic administrative reset, silent overwrite, inferred authority, automatic return loop or re-entry on stale evidence |
| Implementation boundary | No workflow implementation, test execution, DB/Storage/auth/RLS changes, production-data operation, backup/restore, merge or deployment authorization |



### 4.13 DISP-OR01-008 — independent review trigger and exact-version gate

[docs/96 — OR-01 / DISP-OR01-008 Independent Review Trigger and Exact-Version Gate](96_OR01_D08_INDEPENDENT_REVIEW_TRIGGER_AND_EXACT_VERSION_GATE_WORKING_DRAFT.md) provides the technical recommendation and decision questions.

| Field | Recorded review position |
|---|---|
| Technical review | [docs/96 — Independent Review Trigger and Exact-Version Gate](96_OR01_D08_INDEPENDENT_REVIEW_TRIGGER_AND_EXACT_VERSION_GATE_WORKING_DRAFT.md) |
| Recommendation | Mandatory review triggers must come from an approved, versioned risk/authority matrix; no invented defaults or thresholds. |
| Reviewer governance | Appointment, competence, scope, independence, conflict declaration and recusal/substitution must be evidenced for the specific RFI and review. No prohibited self-review. |
| Exact-version gate | Freeze an immutable package manifest tied to exact response, contribution and evidence versions; clearance applies only to that exact package/version. |
| Outcomes and comments | Explicit attributable outcomes; blocking comments prevent Ready for Issue. Conditional clearance only if expressly authorized with objective pre-issue closure controls. Silence is never clearance. |
| Change/re-review | Changed candidate requires impact assessment; substantive changes and applicable matrix triggers require targeted/full re-review. Prior clearance does not transfer automatically. |
| Owner decision | **Conditionally approved on 2026-11-12** — seven principles recorded in docs/96 §17 |
| Approved scope | Matrix-controlled triggers; evidenced reviewer competence/appointment/independence; immutable exact-version package; version-bound clearance; blocking comments; conditional clearance only if expressly authorized; stale-state and separation safeguards |
| Conditions | Approved matrix/authority, reviewer criteria and appointment evidence, final outcomes/comment rules, package integrity, change materiality and targeted/full re-review criteria remain subject to specialist validation |
| Specialist validation | Pending — project/process owner and risk authority, technical/discipline authorities, QA/independent assurance, architecture, security, Document Control and records as applicable |
| Interim control | No invented matrix or reviewer appointment; no stale/changed candidate clearance; hold uncertain trigger, authority, package or version |
| Implementation boundary | No workflow implementation, test execution, DB/Storage/auth/RLS changes, production-data operation, backup/restore, merge or deployment authorization |

