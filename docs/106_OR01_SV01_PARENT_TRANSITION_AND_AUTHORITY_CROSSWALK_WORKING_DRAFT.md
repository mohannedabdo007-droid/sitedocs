# OR-01 SV-01 — Parent Transition and Authority Crosswalk

**Document type:** Consolidated conceptual transition/authority review aid  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — CANDIDATE TRANSITIONS MAPPED — AUTHORITY AND SPECIALIST VALIDATION PENDING — NOT A FINAL STATE MACHINE OR IMPLEMENTATION AUTHORIZATION  
**Branch:** implementation/ui-foundation-2026-11-11  
**Related review:** docs/105_OR01_SV01_LIFECYCLE_AND_AUTHORITY_FOUNDATION_REVIEW_WORKING_DRAFT.md  
**Primary specification:** docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md  
**Owner dispositions:** DISP-OR01-001, 003, 004, 005, 006, 007, 008, 009, 010, 011, 012, 013 and 014 as applicable  
**Coordination matrix:** docs/104_OR01_SPECIALIST_VALIDATION_AND_EVIDENCE_MATRIX_WORKING_DRAFT.md

> This crosswalk consolidates candidate parent transitions and approved owner constraints for review. It does not appoint people, define production capabilities, finalize the lifecycle vocabulary, or authorize workflow implementation. “Authority function” describes the function that must be evidenced by the project governance route; it is not a named role grant.

## 1. Purpose and reading rules

This document addresses SV-01 gaps G-01 through G-06 by putting parent transition candidates, authority boundaries, evidence gates and hold outcomes in one review surface.

Three classifications are used:

- **Owner-bound constraint:** a principle within the scope of a conditionally approved owner disposition. It remains subject to specialist validation and does not authorize implementation.
- **Candidate transition:** a transition proposed in docs/72 or a related detailed-design draft. Its final eligibility, vocabulary and mechanics remain subject to authority review.
- **Open route:** an issue for which the owner-approved principle requires separation or a guard, but exact transition/event/authority mechanics are not yet defined.

The candidate state labels below reproduce the working vocabulary only. They are not final approved enum values. Parent lifecycle, response-cycle outcome, subordinate record state, immutable event, pre-submission draft condition and monitoring indicator must remain distinct.

## 2. Authority-function dictionary

| Function | Decision/record boundary | Must not be inferred from |
|---|---|---|
| Originator / authorized party representative | Creates/submits the RFI within evidenced party/project scope; supplies requested clarification; may request pre-issue withdrawal within the applicable rule | Being a recipient, contributor or viewer |
| Appointing / project governance authority | Establishes the project-approved appointment/delegation route and its scope/effective period | Job title, project membership or roster presence |
| Appointed technical authority | Determines technical discipline scope, required lead/assignments where appointed, technical disposition within scope, reopening and technical issue authority only where separately appointed | Coordinator status, generic PM oversight or assignment acceptance |
| Appointed assignment authority | Establishes required discipline assignments only within an explicit appointment/delegation | Coordinator status unless separately delegated |
| Appointed technical lead | Coordinates/consolidates within exact appointment; evaluates technical gaps and returns bounded work within authority; cannot erase discipline positions or bypass mandatory review | Being the most senior contributor or a default discipline lead |
| Appointed independent reviewer | Reviews exact frozen candidate/package within risk-matrix trigger, competence and independence scope | Technical lead, author or issuer status |
| Appointed readiness authority/function | Records readiness only within an evidenced appointment and exact candidate scope | Review completion or coordinator checklist |
| Appointed technical issuer | Issues the exact response and commits the linked technical closure atomically, within exact appointment | Reviewer, technical lead, PM or Document Control title |
| Appointed records/workflow authority | Validates/authorizes administrative withdrawal/cancellation only within explicit scope; maintains controlled record outcome | Coordinator or Document Control membership alone |
| Coordinator | Administrative intake, checklist verification, routing execution and recordkeeping only within current delegated scope | Technical scope, assignment, review, readiness, issue or closure authority |
| Document Control / records administrator | Records, controls and distributes authorized records; does not make technical decisions or issue responses by default | Custody or distribution responsibility |
| System / authorization service | Enforces current authorization and transaction guards against exact record/version/scope; records attributable events | Product defaults or UI-only role checks |

**Separation note:** The two-key hand-off requires distinct technical authorization and administrative execution functions. It does not automatically require two different human beings if project governance expressly permits a combined appointment; any combination must be evidenced and must preserve required separation-of-duties controls.

## 3. Parent transition crosswalk

| ID | Candidate source → target / event | Decision authority and administrative execution | Required evidence / gate | Hold / prohibited shortcut | Basis and status |
|---|---|---|---|---|---|
| T-01 | Draft → Submitted | Authorized originator submits; system/records process commits official identity | Required fields; active party/project/RFI scope; authorization at action time; submitted evidence snapshot; atomic first-success number allocation | Failed validation consumes no official number; draft remains private within authorized scope; no coordinator submission by implication | Candidate in docs/72; DEC-107 constraint; pre-submission boundary conditionally approved in DISP-OR01-001 |
| T-02 | Draft → Abandoned Draft | Authorized draft owner records abandonment | Draft identity, actor, time and reason under draft-record policy; no official number | Never represent as official RFI withdrawal; no official number consumed | DISP-OR01-001 conditionally approved scope; detailed record/retention rules open |
| T-03 | Submitted → Under Coordination | Appointed coordinator accepts intake within delegated administrative scope | Successful official submission/ID; immutable submitted snapshot; valid coordinator appointment and project/party scope; intake event | Hold if submission identity, appointment or scope is missing/stale; no new number or reset | Candidate in docs/72; administrative boundary under DEC-105 |
| T-04 | Under Coordination → Returned for Completion | Coordinator only if explicitly delegated for this administrative return; technical authority not replaced | Specific correctable pre-technical administrative/information deficiency; reason, affected fields/evidence and return event; preserve official ID/snapshot | Not engineering rejection; not permitted as generic post-handoff reset; exact eligibility/ revision effects remain subject to specialist confirmation | Candidate docs/72; DISP-OR01-003 Option C boundary conditionally approved |
| T-05 | Returned for Completion → Under Coordination | Authorized originator resubmits; coordinator rechecks intake | Attributable resubmission/version; prior return and original submission preserved; classify controlled content change under applicable revision rule | No silent overwrite, new number or deletion of prior return; no automatic acceptance of technical content | Candidate docs/72; DEC-022 family reference; detailed revision handling remains governed separately |
| T-06 | Under Coordination → In Technical Assessment | **Technical key:** appointed technical authority / explicitly appointed assignment authority determines scope, required lead and complete required assignment set. **Administrative key:** coordinator verifies evidence and executes parent transition | Official RFI identity/current state; current appointment/delegation; explicit discipline scope; required technical lead where project model requires; every required assignment with assignee/scope/output; access/confidentiality authorization; routing decision and assignment-set version; action-time state/version recheck | Hold in Under Coordination if authority, discipline, lead, assignee, scope or evidence is absent/ambiguous/stale. Coordinator cannot infer discipline or assign by convenience. Parent cannot transition with incomplete required assignments | DISP-OR01-004 conditionally approved; docs/92; DISP-OR01-014 assignment gate |
| T-07 | In Technical Assessment → Awaiting Originator Clarification | Authorized technical actor within appointed scope records parent-progression blocker; originator responds; authorized technical actor assesses sufficiency | Exact clarification request/ID; reasoned dependency; affected parent progression scope; prior parent stage captured at first valid parent blocker; request/response version history | Mere request, receipt or partial response does not resolve; contribution-only blocker remains at child scope and must not change parent stage | DISP-OR01-005 and 014 conditionally approved; docs/72 row is narrower and G-02 remains open |
| T-08 | Awaiting Originator Clarification → exact prior parent stage resumes | Authorized technical actor confirms all valid parent-progression blockers resolved; system rechecks current authority/scope/assignment/version guards | Every parent blocker resolved by technically sufficient response or authorized disposition; each request/response retained; exact pre-blocker parent stage; current appointment, scope, evidence and concurrency checks | Do not resume on mere receipt, partial response or closure of one request while another parent blocker remains open; do not overwrite captured prior stage when further blockers arrive | DISP-OR01-005/014 conditionally approved; aggregation/source-stage mechanics remain open under G-02 |
| T-09 | In Technical Assessment → Under Consolidation | Appointed technical authority/lead confirms required contribution gate; authorized transition function records parent change | Every required contribution complete and technically confirmed, or valid authorized scope change removes it; no open parent-progression blocker; no unresolved blocker affecting required contribution; exact contribution versions and scope | No convenience reclassification of required work as optional; no provisional candidate presented as formal consolidation; limited provisional preparation remains subordinate while parent stays In Technical Assessment | DISP-OR01-006 conditionally approved; DISP-OR01-014; docs/102 |
| T-10 | Under Consolidation → In Technical Assessment (scoped return) | Appointed technical lead evaluates gap and authorizes bounded return within appointment; appointed technical authority resolves scope/delegation dispute; coordinator executes only if expressly delegated | Material technical gap/new dependency/invalidated contribution/material scope-evidence change/conflict beyond lead mandate; affected discipline scope; preserved unaffected contributions; successor versions/candidate for substantive change | No generic admin reset; no automatic reopening of every discipline; no silent overwrite; no automatic return loop | DISP-OR01-007 conditionally approved; exact materiality/return event details remain open |
| T-11 | Under Consolidation → Under Independent Review | Appointed technical lead submits frozen candidate; appointed independent reviewer performs review under approved risk/authority matrix | Mandatory trigger from approved versioned matrix; matrix owner/applicability authority evidenced; reviewer appointment, competence, independence and conflict status; exact frozen candidate/package and evidence manifest | If matrix/trigger/reviewer/version evidence missing, hold Pending Authority Decision; no self-review where prohibited; no inherited review clearance | DISP-OR01-008 conditionally approved; candidate in docs/72 |
| T-12 | Under Consolidation → Ready for Issue (only if mandatory independent review is not required) | Appointed technical/readiness authority records exact-version readiness; technical lead may perform only if appointment explicitly permits | Recorded matrix-based finding that independent review is Not Required; required contributions; conflicts/dissent disposition; blockers clear; exact response/evidence package; readiness confirmation record; current appointment and action-time checks | Do not treat missing matrix as Not Required; do not bypass mandatory review; readiness does not issue the response | DISP-OR01-009 conditionally approved; candidate docs/72; risk matrix remains prerequisite |
| T-13 | Under Independent Review → Ready for Issue | Appointed independent reviewer records outcome for exact frozen version; readiness function verifies all other gates | Passing outcome against exact version/package; no blocking comment; no material change; all other readiness criteria met | Conditional clearance only if approved matrix expressly allows and objective conditions are satisfied; silence is not approval; changed candidate requires impact assessment/re-review | DISP-OR01-008/009 conditionally approved |
| T-14 | Under Independent Review → rework path (candidate/version successor) | Reviewer records blocking outcome; appointed technical lead/authority determines affected rework path | Review finding and affected scope; preserve reviewed candidate and outcome; create attributable successor candidate/version for substantive changes; determine targeted/full re-review under matrix | Do not overwrite candidate or erase review history; exact parent target state and route remain subject to detailed-design validation | Candidate docs/72; DISP-OR01-008/007 constraints; exact target transition open |
| T-15 | Ready for Issue → Closed (formal issue + technical closure) | Specifically appointed technical issuer commits formal issue and technical closure as one indivisible business outcome | Exact active cycle; current issuer appointment/delegation; all issue/readiness/review/contribution/conflict/blocker/package gates revalidated at action time; frozen package; linked distinct issue and closure evidence; atomic commit/idempotency | Both succeed or neither is recorded successful; no partial issue/closure; no second discretionary closure step assumed; delivery/acknowledgement not part of issue commit | DISP-OR01-009/010/014 conditionally approved |
| T-16 | Eligible pre-issue parent → withdrawal decision | Originator/authorized same-party delegate requests; appointed records/workflow authority validates/authorizes; technical-lead concurrence after substantive technical work begins | Requester authority; pre-issue cutoff; evidence-based work-start determination; concurrence where required; reason; whole-parent scope by default; preserve all history | Request receipt alone does not change state; after successful issue, withdrawal unavailable; no delete/renumber; no partial discipline withdrawal by default | DISP-OR01-011 conditionally approved; exact state eligibility and authority evidence remain open |
| T-17 | Eligible pre-issue parent → Cancelled | Any participant may refer; appointed records/workflow authority validates/authorizes; technical-lead concurrence after substantive work begins | Narrow grounds: proven duplicate official registration or objectively invalid registration; objective evidence; canonical-link/history handling; external concurrence only where approved project/contract rule requires | Correctable admin defect uses correction route; no silent merge, deletion, number reuse or technical rejection disguised as cancellation; no post-issue cancellation | DISP-OR01-012 conditionally approved; exhaustive taxonomy and state eligibility remain open |
| T-18 | Closed prior cycle → authorized new response cycle and governed parent current stage | Currently appointed technical authority for exact scope authorizes reopening; system/records creates one logical new cycle; administrative recording under delegated scope | Approved reopening ground; authority/appointment; predecessor cycle/issued response; reason and scope; new cycle identity; starting-stage assessment based on current scope, assignments, blockers and evidence | Prior cycle stays closed/immutable; no universal automatic return to In Technical Assessment; no inherited review/readiness; independent question becomes linked new RFI; duplicate/concurrent cycle creation prevented | DISP-OR01-013/014 conditionally approved; G-01 remains open pending exact parent-stage projection |
| T-19 | Late administrative defect after technical hand-off → separate correction event/route | Specifically authorized correction/records function validates defect; appointed technical authority assesses technical impact; Document Control records/administers only within delegation | Material defect evidence; correction authority; impact assessment; affected records/assignments/contributions; versioned correction trail; explicit determination whether any technical work is affected | Must not silently reset parent to Returned for Completion or roll back technical lifecycle; technical disagreement is not an admin defect | DISP-OR01-003 Option C conditionally approved; G-03 open pending route definition |
| T-20 | Any parent stage → delivery/access/acknowledgement/notification/monitoring/archive event | Recipient/provider/records actor performs its own authorized subordinate event | Event-specific identity, recipient/record scope and evidence; separate child/event history | No parent lifecycle transition, issue/closure, approval or acceptance inferred | DEC-103/108/109 constraints; DISP-OR01-014 conditionally approved |

## 4. Subordinate-record guard matrix

| Subordinate record/event | May satisfy or block | Must never do autonomously |
|---|---|---|
| Required discipline assignment | May satisfy T-06 hand-off gate; later assignment changes may affect contribution gates through an authorized scope change | Create parent technical authority or move parent stage by itself |
| Discipline contribution | May satisfy T-09 required contribution gate; an explicitly authorized dependency may create a scoped or parent blocker | Make parent Under Consolidation or Ready for Issue merely by submission |
| Clarification request/response | May block only its recorded affected scope; valid parent-progression blocker may hold parent under T-07/T-08 | Treat receipt/partial response as technical resolution; force parent wait for a contribution-only blocker |
| Provisional response candidate | May support subordinate preparation while parent remains In Technical Assessment under DISP-OR01-006 | Represent parent as Under Consolidation, review passed, ready or issued |
| Independent review | May satisfy/block exact-version review gate | Issue/close parent or transfer clearance to changed version |
| Readiness confirmation | May satisfy exact candidate readiness prerequisite for issue | Issue or close RFI |
| Formal issue/closure transaction | Changes parent outcome only on atomic successful authorized commit | Split successful issue from technical closure |
| Transmittal/recipient event | Supports communication/receipt reporting | Create, reverse, pause or close technical lifecycle |
| Notification/workload/report/export/archive/hold event | Supports its own operational/records metric | Mutate parent stage or confer authorization |

## 5. Consolidated action-level hand-off matrix (G-04)

| Action | Required authority function | Administrative / recording function | Evidence needed | Current status |
|---|---|---|---|---|
| Determine discipline scope | Appointed technical authority | Coordinator records decision reference only | Appointment, scope rationale, discipline boundaries | Owner principle conditionally approved; exact authority instrument pending |
| Determine required lead | Appointed technical authority / appointing authority under project model | Coordinator records | Lead appointment, competence, scope, effective period | Exact project model pending |
| Determine required assignments | Appointed technical or assignment authority | Coordinator may prepare/record only if delegated | Assignment authority, required/optional basis, scope/output | Owner principle conditionally approved; detailed criteria pending |
| Appoint/assign responders | Explicitly appointed assignment authority | Coordinator only if separately delegated | Assignee identity, assignment scope, effective period, acceptance if required by project rule | Appointment and acceptance rules pending |
| Verify linked-resource access | Authorized security/access function under approved policy | Coordinator may identify missing evidence but cannot grant access by routing | Current project/party/discipline/assignment authorization | Security/architecture validation pending |
| Verify administrative completeness | Appointed coordinator within administrative scope | Coordinator | Checklist, source decision, version and required evidence presence | Two-key principle conditionally approved |
| Execute parent hand-off | Authorized transition executor under approved workflow delegation; coordinator only within evidenced scope | System records transition and linked decision IDs | Current state/version, both keys, action-time authorization, atomic history | Detailed executor and transaction design pending |
| Correct late admin defect | Appointed correction/records authority; technical authority assesses impact | Document Control/records records and communicates | Defect, authority, impact and correction evidence | Option C principle conditionally approved; route open |

## 6. Parent/cycle/subordinate semantics (G-01 and G-05)

The working model must distinguish at least these conceptual objects:

| Conceptual object | Meaning | Status |
|---|---|---|
| Official RFI identity | Stable identity/number for the originating question | Owner-confirmed constraint; final data model not approved |
| Parent current lifecycle stage | One authoritative current stage for the official RFI identity | Owner-confirmed constraint; exact projection mechanics open |
| Response cycle | Distinct technical response attempt/cycle linked to same RFI identity | Owner-confirmed after reopening; exact identity mechanics open |
| Cycle outcome | Closed/withdrawn/cancelled or other governed outcome belonging to a specific cycle/parent context | Exact ownership and vocabulary require reconciliation |
| Subordinate record state | Assignment, contribution, clarification, candidate, review, readiness, Transmittal, recipient, notification or records state | Independent lifecycle/state owner |
| Immutable event | Attributable occurrence such as submission, return, correction, reopening, issue, dispatch or acknowledgement | Event catalogue and transaction rules pending |
| Draft record condition | Draft or Abandoned Draft before official submission | Outside official parent lifecycle |
| Derived indicator | Overdue, workload, delivery aggregate, acknowledgement aggregate, archive readiness or report metric | Never a parent technical stage |

**Unresolved G-01 question:** The prior response cycle remains closed and immutable when reopening occurs, but the precise representation of the parent’s current stage while a new cycle is active is not finalized. Until the process owner, technical authority, architecture and records domains validate the projection, do not infer the parent state from the last cycle outcome or the mere presence of a new cycle.

## 7. Clarification blocker rules (G-02)

The following are owner-bound constraints, not a complete transition implementation:

1. A clarification blocks the parent only when an authorized technical actor records a reasoned parent-progression dependency and affected scope.
2. A contribution-only blocker stops only that contribution/assignment; independent authorized work may continue if it does not bypass the affected gate.
3. While at least one valid parent-progression blocker remains open, the parent is held in Awaiting Originator Clarification.
4. The first parent-level blocker records the exact prior parent stage. Additional blockers do not overwrite it.
5. Partial response or mere receipt does not resolve a blocker. Technical sufficiency must be validated by the authorized technical actor.
6. When all parent blockers resolve, resume the exact prior parent stage only after current authority, assignment, scope, evidence, version and concurrency guards pass.

**Open G-02:** exact eligible source stages, treatment of blockers raised during Under Consolidation/other active stages, simultaneous blocker aggregation, request correction/withdrawal/supersession, and stale prior-stage recovery require specialist validation.

## 8. Option C late administrative correction (G-03)

This crosswalk recognizes two different paths:

- **Ordinary pre-technical administrative return:** the candidate parent transition Under Coordination → Returned for Completion, followed by authorized originator resubmission and intake recheck.
- **Late-discovered material administrative defect after technical work starts:** a separately authorized correction event/route. It does not silently set the parent to Returned for Completion, reset technical work or invalidate contributions. Technical impact is assessed by the appointed technical authority; correction/records authority and Document Control functions remain separately evidenced.

Exact correction record identity, eligible defects, actor appointment, technical impact classification, affected child records, version behavior and concurrency/recovery remain open. Do not implement or operationalize this route from this conceptual statement alone.

## 9. Crosswalk gaps and required specialist questions

| Gap | Question requiring evidence-backed review | Required domains |
|---|---|---|
| G-01 | What is the authoritative parent current-stage projection while a prior cycle remains closed and a new cycle is active? | Process owner, technical authority, architecture/data, Document Control, records |
| G-02 | Which active source stages can enter parent clarification wait, and how are multiple blockers/prior-stage restoration governed? | Technical authority/lead, discipline authorities, process owner, architecture, QA |
| G-03 | What is the exact late administrative correction route, authority, evidence, impact handling and parent-stage behavior? | Process owner, correction/records authority, Document Control, technical authority, architecture, QA |
| G-04 | Which appointment/delegation instruments prove each action-level authority and when may functions be combined? | Appointing authority, technical authority, process owner, security, architecture, Document Control |
| G-05 | What controlled glossary identifies owner record and semantic type for every parent, cycle, child, event and indicator label? | Process owner, technical authority, architecture, records, QA |
| G-06 | What is the complete source-of-truth transition guard table, including failure/recovery and event identities? | Technical authority, process owner, architecture, security, QA, Document Control, records |

## 10. Required review and evidence record

For each specialist review, record in docs/104:
- reviewer identity/organization and whether advisory or decision-making;
- competence relevant to the review;
- appointment/delegation evidence and effective scope when applicable;
- exact reviewed file versions, SHAs, sections and exclusions;
- each transition ID/gap addressed;
- findings, rationale, conditions, unresolved items and dissent;
- attributable evidence reference and date;
- independent verification of status against evidence and exact source version.

Do not change SV-01 from Pending or add evidence counts merely because this crosswalk exists. A reviewer may validate only a stated portion while leaving other gaps blocked. Changed source versions require impact assessment and possible re-review.

## 11. SV-01 exit criteria

- [ ] G-01–G-06 have evidence-backed disposition, explicit condition or named blocker owner.
- [ ] Parent/cycle/child/event/indicator glossary is reconciled with owner-approved principles.
- [ ] All candidate transitions have authority, evidence, parent-vs-child blocking behavior and failure/hold outcome reviewed.
- [ ] Two-key hand-off action matrix is validated against actual appointment/delegation instruments.
- [ ] Clarification blocker aggregation and prior-stage restoration are validated.
- [ ] Option C late correction route is distinguished from ordinary pre-assessment return.
- [ ] Exact source versions and reviewer evidence are recorded in docs/104.
- [ ] No DEC-103–DEC-110 rule or owner disposition is contradicted or silently changed.

## 12. Explicit exclusions

This crosswalk does not create appointments, grants, capabilities, final state labels, a final state machine, field schemas, API contracts, database structures, migrations, generated types, UI behavior or operational workflows. No tests are executed. No DB, Storage, authentication, authorization/RLS/grants or production data are changed. No backup/restore, merge, deployment or release is performed or authorized.

---
**End of working crosswalk — candidate transitions and authority boundaries consolidated for SV-01 specialist review; G-01–G-06 remain open; specialist validation and detailed-design approval remain pending.**
