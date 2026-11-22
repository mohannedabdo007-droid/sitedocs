# OR-01 SV-01 — Lifecycle and Authority Foundation Review

**Document type:** Preliminary document-level consistency and gap assessment for specialist review  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — DESK REVIEW RECORDED — SPECIALIST VALIDATION NOT EVIDENCED — NOT DETAILED-DESIGN APPROVAL OR IMPLEMENTATION AUTHORIZATION  
**Branch:** implementation/ui-foundation-2026-11-11  
**Review package:** SV-01 — DISP-OR01-001, DISP-OR01-003, DISP-OR01-004 and DISP-OR01-014  
**Primary specification:** docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md  
**Owner dispositions:** docs/89, docs/91, docs/92 and docs/102  
**Coordination matrix:** docs/104_OR01_SPECIALIST_VALIDATION_AND_EVIDENCE_MATRIX_WORKING_DRAFT.md

> This is a document-level review by the project assistant of the current working drafts. It is not a review or sign-off by an appointed process owner, technical authority, Document Control, architect, security specialist, QA specialist or records authority. No external reviewer or appointment is inferred.

## 1. Executive result

The current documents establish a coherent direction for the SV-01 foundation:
- one authoritative parent RFI lifecycle stage, with subordinate records retaining separate identities and histories;
- Draft and Abandoned Draft separated from the official RFI lifecycle;
- coordinator administrative routing separated from technical scope and assignment decisions;
- parent transitions gated by current authority, valid scope and required assignment evidence;
- subordinate communication, delivery, monitoring and records events prevented from autonomously changing the parent technical lifecycle.

The DD-01 specification remains a candidate working draft. Six design clarifications should be reconciled before SV-01 can be presented for specialist validation. The most consequential are the parent/cycle meaning of Closed after reopening, the complete clarification-blocker transition model, and explicit representation of the late administrative correction route.

**SV-01 status:** Desk review performed; specialist validation remains Pending; no specialist evidence count is added; detailed design remains open.

## 2. Source versions reviewed

The following files were freshly fetched from the target branch:

| File | SHA at review |
|---|---|
| docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md | 4cb82360490ec283ddf334af1115d23869212ab9 |
| docs/91_OR01_D03_COORDINATION_AND_RETURN_FOR_COMPLETION_WORKING_DRAFT.md | 4bf4b9e5a38a7a386483718676da4d7072210292 |
| docs/92_OR01_D04_ADMINISTRATIVE_ROUTING_TO_TECHNICAL_ASSESSMENT_WORKING_DRAFT.md | 2457b30b69dc6148b21825dd2a55795cd371f976 |
| docs/102_OR01_D14_PARENT_LIFECYCLE_SUBORDINATE_RECORDS_AND_INDICATORS_WORKING_DRAFT.md | a62305fc2f51f4ad0c12b328ee21053e5a399227 |
| docs/104_OR01_SPECIALIST_VALIDATION_AND_EVIDENCE_MATRIX_WORKING_DRAFT.md | d102cc9061c78c74b6aa434bf24e4821510a74de |
| docs/85_RFI_OWNER_AND_SPECIALIST_REVIEW_MATRIX_WORKING_DRAFT.md | f8c40d280612f2debf6adfb098f815daed473a1a |
| docs/103_OR01_OWNER_DISPOSITION_RECONCILIATION_AND_REVIEW_CLOSEOUT_ASSESSMENT_WORKING_DRAFT.md | b4b9933e417684c65e5727e4c8c8c2cd8d78d90a |

Governance master register files were not treated as files on this implementation branch. This review does not amend DEC-103–DEC-110.

## 3. Alignment findings

### A-01 — Draft boundary and official parent identity

DISP-OR01-001 distinguishes Draft and Abandoned Draft as pre-submission draft-record conditions outside the official parent RFI lifecycle. Docs/72 §3.2 labels Draft as a draft record outside the official lifecycle and Abandoned Draft as a draft-record disposition, not an official withdrawal.

**Result:** Directionally consistent. The final lifecycle diagram and identity/numbering narrative should show these as pre-parent record conditions, not official parent states. Final labels remain subject to specialist validation.

### A-02 — Administrative coordination versus technical routing

DISP-OR01-004 establishes the two-key hand-off: technical authority determines discipline scope, required lead and assignments; the coordinator checks administrative readiness and executes the parent transition. Docs/92 §4–§7 describes the technical routing decision, complete assignment set, coordinator verification and action-time parent transition. Docs/72 §3.3 describes coordinator administrative routing while the technical authority controls technical scope. Docs/72 §4.2–§4.3 does not grant coordinator technical scope authority and makes assignment authority dependent on explicit delegation.

**Result:** No substantive contradiction identified in the reviewed passages. Any coordinator assignment function must require a separate explicit appointment/delegation as assignment authority, not arise from coordinator status.

### A-03 — Parent/subordinate separation

DISP-OR01-014 establishes one authoritative current parent stage and independent subordinate identities/state/event histories. Docs/72 §3.1 and §3.5 state that the parent has one current stage while assignments, contributions, reviews, clarifications and recipient events have separate states. Docs/102 elaborates the parent/cycle/child hierarchy and states that child events only satisfy or block explicit authorized gates; they do not autonomously mutate the parent.

**Result:** Directionally aligned. The unresolved issue is the exact parent-stage projection when a previously closed response cycle is reopened (G-01).

## 4. Design gaps requiring reconciliation

### G-01 — Parent Closed state versus reopened response cycle

**Source:** Docs/72 §3.2 classifies Closed as a candidate terminal technical state; §3.3 describes a Closed-to-reopened-event/new-active-cycle path. DISP-OR01-013 requires the prior cycle to remain closed and immutable while a distinct new response cycle is created for the same question. DISP-OR01-014 requires one authoritative current parent stage per official RFI identity, with response-cycle identities/history separate. Docs/102 §3–§4 describes the parent and response-cycle hierarchy.

**Gap:** The documents do not yet state unambiguously whether Closed is a parent-level state superseded when a new cycle starts, a terminal outcome of the prior cycle while the parent adopts a new active stage, or a parent outcome/history marker with a separate current-stage projection. The approved principles imply that the prior cycle remains closed while the parent can have a new active cycle, but exact state representation and event semantics need to be written.

**Required reconciliation:**
1. Distinguish parent current stage from response-cycle outcome/current-cycle stage at the conceptual model level.
2. Specify how the parent moves from a closed prior cycle to the authorized starting stage of the new cycle without reopening or mutating the old cycle.
3. Define what dashboards and reports show when the prior cycle is closed and a new cycle is active.
4. Confirm that only the authorized reopening decision creates the new cycle and one active-cycle outcome; duplicate/concurrent decisions remain governed by the separate idempotency design.

**Review domains:** project/process owner, appointed technical authority, architecture/data governance, Document Control and records.

**Interim control:** Do not infer a parent stage from the existence of a reopened-cycle record; hold any lifecycle projection whose source cycle and authority are ambiguous.

### G-02 — Clarification blocker transitions are narrower than the approved parent-blocker rule

**Source:** Docs/72 §3.2 describes Awaiting Originator Clarification as one or more requests blocking the next technical action. §3.3 explicitly lists In Technical Assessment → Awaiting Originator Clarification and resumption of the prior active stage. DISP-OR01-005 and DISP-OR01-014 establish that a valid parent-progression blocker may hold the parent while open; contribution-only blockers remain scoped; when all parent blockers resolve the exact prior parent stage is resumed, subject to current guards. Docs/102 §4 and §6 elaborate the any-open-parent-blocker rule.

**Gap:** The transition matrix does not clearly enumerate whether a parent-level clarification blocker can be raised while the parent is Under Consolidation or another active technical stage, nor how a new parent blocker interacts with an already active clarification-wait state and the stored prior stage. The approved rule is broader than the single explicit transition row in docs/72.

**Required reconciliation:**
1. Identify eligible source stages for a parent-progression blocker, based on actual dependency and authority—not a blanket automatic transition from every stage.
2. Define the first-blocker event that captures the exact prior parent stage.
3. Define how additional parent blockers aggregate without overwriting that prior stage.
4. Define resolution, withdrawal, supersession and partial-response handling for each blocker.
5. Ensure contribution-only blockers never force the parent into Awaiting Originator Clarification.

**Review domains:** appointed technical authority/lead, relevant discipline authorities, process owner, architecture and QA.

**Interim control:** No parent clarification transition or resume where blocker class, affected scope, prior stage or technical sufficiency evidence is missing or ambiguous.

### G-03 — Option C late administrative correction is not explicit in the candidate transition model

**Source:** DISP-OR01-003 conditionally approves Option C: normal administrative return before technical assessment; a late-discovered material administrative defect uses a separate authorized correction route without silently resetting technical lifecycle. Docs/91 §6–§8 describes the hybrid approach and evidence requirements. Docs/72 §3.2–§3.3 includes Returned for Completion and an Under Coordination → Returned for Completion transition, but does not show a separate late correction event/route for defects found after technical work begins.

**Gap:** The candidate model may be read as if all administrative defects use the same Returned for Completion parent state, or as if the late correction route is omitted. That would blur the owner-approved distinction.

**Required reconciliation:**
1. Define the normal pre-assessment Returned for Completion path and its resubmission/version behavior.
2. Define a separate late administrative correction record/event/route for post-handoff defects, preserving the active technical parent stage unless an explicitly approved transition rule applies.
3. Specify who validates the defect, who assesses technical impact, who authorizes correction and who records the administrative event.
4. Ensure correction does not silently reset, erase or invalidate technical work; any impact on assignments/contributions must be explicitly assessed and evidenced.

**Review domains:** process owner, Document Control/records, technical authority/lead, architecture, security and QA.

**Interim control:** Do not use Returned for Completion as a generic post-handoff reset or as a route for technical disagreement.

### G-04 — Two-key hand-off needs a single cross-document authority/assignment crosswalk

**Source:** DISP-OR01-004 and docs/92 §4–§9 specify the technical determination, assignment authority, coordinator verification and administrative transition. Docs/72 §4.2–§4.3 contains role and action-capability candidates, including coordinator assignment only under separate delegation and technical lead/authority assignment conditions. Docs/102 §4 describes the parent transition gate.

**Gap:** The core principle is aligned, but authority terms are not yet normalized across the documents: technical authority, assignment authority, technical lead, coordinator and designated authority appear in related contexts. A reader needs one action-level crosswalk identifying who decides, who records, who verifies and who executes each step. This is a design requirement, not permission to appoint anyone.

**Required reconciliation:**
1. Create an action-level matrix for discipline scope determination, technical lead appointment, required assignment determination, assignment creation/recording, access verification, administrative completeness verification and parent transition.
2. For each action, identify whether it is a decision, administrative execution or verification.
3. State which functions may be combined only if valid project governance explicitly permits it; do not infer that the two-key model necessarily means two different people.
4. Record required appointment/delegation evidence and effective scope for each action.

**Review domains:** project appointing authority, technical authority, discipline authorities, process owner, Document Control, architecture and security.

**Interim control:** No missing appointment, discipline, lead or assignee may be filled by coordinator discretion, job title, group membership, keyword matching or convenience.

### G-05 — Candidate state labels and state/event/record-condition distinctions need one controlled dictionary

**Source:** Docs/72 §3.2 labels Draft and Abandoned Draft as record conditions outside official lifecycle, while other rows are candidate parent states. Docs/72 §3.5 contains subordinate state labels. Docs/102 §3–§4 separates parent, cycle, assignment, contribution, clarification, candidate, review, readiness, Transmittal, recipient and records objects.

**Gap:** The candidate dictionary is distributed across several tables and mixes parent stages, terminal outcomes, draft-record conditions and events. The principles are sound, but a final controlled dictionary must explicitly label each term by record owner and semantic type. Otherwise the same word (for example Closed, Issued, Completed or Withdrawn) may be incorrectly reused across parent and child records.

**Required reconciliation:**
1. Create a glossary of parent-stage labels, cycle outcomes, child-record states, immutable events, indicators and pre-submission record conditions.
2. Identify the authoritative record that owns each label and whether it is a state, outcome, event or derived indicator.
3. Reconcile candidate names against DISP-OR01-001 and DISP-OR01-014 without treating the candidate vocabulary as final approval.
4. Preserve the exclusion of delivery, acknowledgement, notification, workload, overdue, archive and read/access indicators from the technical parent lifecycle.

**Review domains:** process owner, technical authority, Document Control, architecture, records and QA.

**Interim control:** Candidate labels remain working vocabulary; no UI/API/database enum or workflow transition may be inferred from draft tables.

### G-06 — Parent transition guards need a consolidated source-of-truth table

**Source:** Docs/72 §3.3 contains the candidate transition matrix. Docs/92 specifies the technical hand-off sequence and complete-assignment gate. Docs/102 §4 specifies parent transition gates using subordinate evidence.

**Gap:** The same gate is described at different levels in different documents. There is not yet one consolidated matrix linking each parent transition to its exact authority, required subordinate evidence, blocker behavior, action-time checks and resulting event. This increases the risk of one document allowing a transition that another blocks.

**Required reconciliation:** Create one controlled transition crosswalk with source parent stage and target stage/event; cycle context; authorized decision-maker and administrative executor; appointment/delegation evidence; required assignment/contribution/clarification/review/package evidence; parent-blocking versus child-only failure; exact version/scope and action-time authorization checks; history/event record and failure/hold result; linked owner disposition and governance decision.

**Review domains:** technical authority, process owner, architecture, security, QA, Document Control and records.

## 5. SV-01 disposition crosswalk

| Disposition | Review result | Required action before specialist validation |
|---|---|---|
| DISP-OR01-001 | Direction aligned; state/record-condition vocabulary needs normalization | Close G-05; preserve Draft/Abandoned Draft outside official parent lifecycle |
| DISP-OR01-003 | Option C direction exists in docs/91; late correction route absent from parent transition crosswalk | Close G-03 and verify no generic post-handoff Returned for Completion path |
| DISP-OR01-004 | Two-key hand-off direction is consistent across docs/72 and docs/92 | Close G-04 and reconcile exact actor/action/delegation matrix |
| DISP-OR01-014 | Parent/subordinate separation is consistent; cycle-to-parent projection and complete transition gates need elaboration | Close G-01, G-02, G-05 and G-06; preserve independent child histories and metrics |

## 6. Consolidated review aid and recommended document updates — not yet applied

The candidate transitions and authority functions have now been consolidated for review in [docs/106 — SV-01 Parent Transition and Authority Crosswalk](106_OR01_SV01_PARENT_TRANSITION_AND_AUTHORITY_CROSSWALK_WORKING_DRAFT.md). The crosswalk maps the six gaps and identifies owner-bound constraints versus candidate transitions; it does **not** resolve G-01–G-06 or close specialist validation.

1. Docs/72 §3.2–§3.5: revise lifecycle vocabulary and transition table to distinguish parent stage, response-cycle outcome, child state, record condition and event.
2. Docs/72 §3.3–§3.4: add the governed new-cycle projection and parent clarification blocker transitions, with precise guards.
3. Docs/72 §3.2–§3.3 and docs/91: represent the Option C late administrative correction route separately from Returned for Completion.
4. Docs/72 §4.2–§4.3 and docs/92: add a single action-level authority/assignment crosswalk.
5. Docs/102: add explicit parent-current-stage versus prior-cycle-closed/new-cycle-active semantics and link to the consolidated transition crosswalk.
6. Update docs/104 only after actual specialist reviewers, exact reviewed versions, findings, conditions and evidence references are received.

No changes to docs/72, docs/91, docs/92 or docs/102 are made by this review. This assessment records gaps; it does not silently decide them.

## 7. Specialist review questions for SV-01

**Process owner / RFI owner**
- Does the proposed parent/cycle model accurately represent the official RFI identity through reopening?
- Which parent-stage transitions are permitted for a parent-level clarification blocker, and what is the governing dependency test?
- What is the approved administrative correction route for a late defect under Option C?
- Who owns and approves the final parent-state dictionary?

**Appointed technical authority / technical lead / discipline authorities**
- What evidence proves the required discipline set, technical lead appointment and assignment decisions?
- Which contribution/clarification conditions may block the parent, and which remain child-only?
- How are cross-discipline authority boundaries and unresolved scope disputes escalated?
- What technical event starts, suspends or resumes a response cycle without altering prior cycle history?

**Document Control / records authority**
- How are official RFI identity, submitted snapshot, administrative return, late correction, cycle identity and historical closure retained and displayed?
- Which actions are recordkeeping/dispatch only, and which require a separate appointment?
- What audit evidence is mandatory for each administrative hand-off/correction?

**Architecture / security / identity**
- What conceptual identity and event relationships are required to represent parent, cycle and child records without conflation?
- How are actor, party/project scope, appointment, delegation, exact record/version and linked-resource access checked at action time?
- How are stale routing packages, concurrent blocker changes and reopening races held/reconciled?

**QA / independent assurance**
- What positive, negative, boundary and concurrency scenarios prove each transition gate?
- How will test cases trace to owner dispositions, approved detailed requirements, authority evidence and exact version?
- Which scenarios remain blocked until the risk/authority matrix and appointments are approved?

## 8. Exit criteria for SV-01

- [ ] G-01 through G-06 have a recorded resolution, accepted condition or explicit blocker owner.
- [ ] A consolidated parent/cycle/child glossary and transition crosswalk exists.
- [ ] Option C late correction is distinct from ordinary pre-assessment administrative return.
- [ ] The two-key hand-off has an action-level decision/verification/execution matrix.
- [ ] Parent-level clarification blocker entry/resume behavior is reconciled with DISP-OR01-005/014.
- [ ] Exact source document versions are frozen for each specialist review request.
- [ ] Actual reviewer appointments/competence/scope evidence are supplied by the authorized project route.
- [ ] Each specialist finding, limitation, condition and dissent is recorded with attributable evidence.
- [ ] No protected DEC-103–DEC-110 rule is contradicted or silently amended.

Even after these criteria, specialist validation is not owner acceptance of the final DD specification, and neither is implementation authorization.

## 9. Current blockers and next action

| Blocker | Status | Next action |
|---|---|---|
| Reviewer identity, appointment and competence evidence | Blocked — Pending Prerequisite | Obtain from actual authorized project appointing authority; do not infer names |
| Parent/cycle semantics after reopening | Open design gap G-01 | Process owner + technical authority + architecture/records review |
| Parent clarification blocker source-stage matrix | Open design gap G-02 | Technical authority + discipline + process owner review |
| Option C late correction route | Open design gap G-03 | Process owner + Document Control + technical authority review |
| Action-level hand-off authority crosswalk | Open design gap G-04 | Appointing authority + technical authority + Document Control review |
| Controlled lifecycle glossary | Open design gap G-05 | Process owner + technical authority + architecture/records review |
| Consolidated transition guard table | Open design gap G-06 | Technical authority + architecture + QA/security/records review |

**Next controlled step:** obtain actual authorized reviewer/appointing-authority evidence and present G-01–G-06 to the SV-01 review domains. Do not mark SV-01 specialist validation complete until attributable findings against exact versions are received and verified.

## 10. Explicit exclusions

No person is appointed; no capability or delegation is granted; no final lifecycle vocabulary/state machine or detailed specification is approved; no test is executed; no application code or UI is changed; no DB/schema/migration/generated type, Storage, authentication, authorization/RLS/grant or production data is changed; no backup/restore, merge, deployment or release is performed or authorized.

---
**End of working assessment — SV-01 desk review identifies six reconciliation gaps; specialist validation remains pending; OR-01 detailed-design closeout and implementation remain blocked.**
