# OR-01 / DISP-OR01-001 — Parent RFI State Vocabulary Review

**Document type:** Technical review memorandum and owner decision support  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — OWNER DISPOSITION CONDITIONALLY APPROVED FOR THE RECORDED SCOPE — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Source candidate dictionary:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`, §§3.2–3.5  
**Protected governance:** DEC-104–DEC-110; DEC-022-A/B where revision classification applies

> This memorandum evaluates the 13 labels in the source draft. It is not an owner decision, final state-machine specification, amendment to governance, approval of transition rules, or authorization to implement or test.

## 1. Purpose and decision boundary

DISP-OR01-001 asks which labels form the final **parent RFI lifecycle** and what precise meaning distinguishes each state. This memorandum supplied the technical assessment accepted by the project owner as a controlled direction for further refinement. The owner disposition is recorded below as **Conditionally approved** for the defined scope; required specialist validation and downstream reconciliation remain pending.

The review covers semantic clarity, separation of concerns, observable entry/exit evidence, auditability, terminality, and risk of conflation with subordinate records or communication/records indicators. It does not settle actor appointments, capabilities, transition eligibility, concurrency implementation, or detailed operational procedures.

## 2. Executive technical recommendation

1. **Separate draft handling from the official RFI lifecycle.** Keep Draft and Abandoned Draft as pre-submission draft-record conditions, outside the official parent lifecycle. They have no official RFI number and must not be represented as Withdrawn or Cancelled.
2. **Retain the 11 candidate official lifecycle labels provisionally** for owner review: Submitted; Under Coordination; Returned for Completion; In Technical Assessment; Awaiting Originator Clarification; Under Consolidation; Under Independent Review; Ready for Issue; Closed; Withdrawn; Cancelled.
3. **Treat Closed, Withdrawn and Cancelled as distinct terminal outcomes**, not interchangeable generic closure statuses.
4. **Do not model communication, recipient acknowledgement, access, notifications, archive, workload or aging as parent lifecycle states.** These remain independent records/indicators under DEC-103, DEC-108 and DEC-109.
5. **Do not infer approval from this recommendation.** Every label and its definition remains subject to owner disposition and relevant specialist validation.

This is a recommendation to preserve the current 11-state official candidate vocabulary as a workable review baseline, not a finding that the vocabulary is already approved or complete.

## 3. Assessment criteria

A parent lifecycle state should:
- describe one intelligible current stage or terminal outcome for the official RFI identity;
- have a defined and evidenced entry condition and an identifiable exit event or terminal rule;
- be distinguishable from adjacent states without relying only on who last clicked a button;
- be auditable from authoritative records and event history;
- avoid collapsing independent discipline, clarification, review, Transmittal, recipient or records events;
- not imply authority, technical acceptance, delivery, receipt or contractual effect that has not been separately established.

A state may aggregate subordinate work only through an explicit, deterministic rule. A dashboard projection is not itself an authoritative lifecycle event.

## 4. Candidate-by-candidate assessment

| Candidate label | Technical assessment | Recommended treatment for owner discussion |
|---|---|---|
| Draft | Clearly pre-submission; no official identity or number. Including it in the official lifecycle would blur the DEC-107 numbering boundary. | Keep as a separate draft-record condition outside the official RFI lifecycle. |
| Abandoned Draft | A disposition of an unsubmitted draft, not a withdrawal of an official RFI. It has no official lifecycle identity to withdraw. | Keep as a separate terminal draft-record condition; preserve the draft and its history under separately approved records/privacy rules. |
| Submitted | Useful formal boundary, but can be mistaken for a transient technical stage. It should mean successful formal submission, not merely clicking Submit or saving a draft. | Retain provisionally as the first official lifecycle state, entered only after successful atomic validation and official identity allocation under DEC-107. |
| Under Coordination | Distinct administrative intake/routing stage. Risk: it may be interpreted as technical review or approval if its scope is not explicit. | Retain; define as administrative completeness, routing and assignment setup only. Coordinator authority remains administrative under DEC-105. |
| Returned for Completion | Understandable but potentially ambiguous: may be mistaken for rejection, a revision, or a failed pre-submission attempt. | Retain provisionally only for a successfully submitted RFI returned for a defined post-submission deficiency. Define reason codes and revision classification; never use for failed initial validation. |
| In Technical Assessment | Distinct technical work stage, but could hide incomplete discipline assignments or imply that all contributions are complete. | Retain; define as active preparation of scoped discipline contributions and technical assessment, with completeness tracked at subordinate assignment level. |
| Awaiting Originator Clarification | Meaning is understandable, but multiple clarification requests may exist concurrently and not all necessarily block the whole parent. | Retain provisionally as a parent projection only while at least one explicitly blocking clarification request remains unresolved. Preserve each request and response separately. |
| Under Consolidation | Distinct from discipline assessment if it means assembling contributions and resolving/escalating conflicts. Risk: parent stage could imply consolidation began before required contributions are complete. | Retain as a parent stage after all required contributions are complete or an authorized scope change removes an assignment. Any earlier parallel drafting should be subordinate activity, not a parent-state change. |
| Under Independent Review | Distinct assurance stage, but only meaningful where a valid approved trigger applies and a qualified independent reviewer is appointed for an exact version. | Retain conditionally; enter only for a mandatory review under an approved risk/authority matrix and bind review to a frozen response version. If the trigger matrix is missing or ambiguous, remain blocked/pending authority decision rather than defaulting to no review. |
| Ready for Issue | Useful readiness gate, not an issued or approved response. Risk: users may treat it as issuance or external release. | Retain; define as all required contributions, conflicts and mandatory reviews complete, with exact candidate response frozen and issue authority still to act. |
| Closed | Clear terminal technical outcome only if formal issue and technical closure are evidenced. It must not imply recipient delivery or acknowledgement. | Retain as terminal technical outcome following authorized formal issue and recorded technical closure; preserve atomic issue/closure rule and exact response version. |
| Withdrawn | Distinct terminal administrative outcome after a valid request and authorized validation; not a technical rejection and not a draft abandonment. | Retain as terminal administrative outcome only within DEC-106 eligibility, authority, cutoff and concurrence controls. |
| Cancelled | Distinct administrative cancellation for an evidenced permitted ground; risk of misuse to erase an unfavorable technical history. | Retain as terminal administrative outcome with enumerated permitted grounds and authorized decision; never treat as technical rejection or erase identity/history. |

## 5. Proposed semantic definitions for owner review

The following definitions are candidate wording for discussion, not approved system labels or enums.

### 5.1 Draft-record conditions — outside the official lifecycle

- **Draft:** An unsubmitted working record created by an authorized originator and visible only within its permitted draft/oversight scope. It has no official RFI number and is not yet an official RFI.
- **Abandoned Draft:** A draft record whose authorized owner has ended further pursuit before formal submission. It remains a draft-record disposition, not an official withdrawal or cancellation. Its retention/disposition follows a separately approved records/privacy rule.

The owner may decide whether these should be called statuses, dispositions, or a separate draft workflow. The technical requirement is that they remain outside the official numbered RFI lifecycle.

### 5.2 Official non-terminal candidate states

- **Submitted:** The official RFI has passed required formal-submission validation, acquired its official identity/number under DEC-107, and has a preserved submission snapshot. This is not technical acceptance.
- **Under Coordination:** The official RFI is undergoing permitted administrative intake, completeness checks, routing and assignment setup. No technical decision authority is implied.
- **Returned for Completion:** The official RFI has been returned to its originator for a recorded, permitted post-submission deficiency. The prior official identity and submission history remain intact. It is not an engineering rejection; any content change is classified under DEC-022-A/B where applicable.
- **In Technical Assessment:** Authorized technical participants are preparing scoped discipline contributions and assessing the question. Completion of every required contribution must be visible from subordinate records, not inferred from the parent label alone.
- **Awaiting Originator Clarification:** At least one clarification request formally designated as blocking remains unresolved and prevents the affected next technical action. Each request, affected scope, response and resolution remains separately traceable.
- **Under Consolidation:** Required discipline contributions are complete, or an authorized scope change has formally removed an assignment, and the appointed technical lead is assembling the response and resolving/escalating material conflicts. No unresolved blocking contribution is represented as complete.
- **Under Independent Review:** A frozen consolidated response version is undergoing an independent review required by an approved risk/authority rule. The review record is bound to that exact version and evidence set.
- **Ready for Issue:** All required contributions, authorized conflict dispositions and mandatory review gates are complete for a frozen response candidate. Formal issue has not yet occurred; only the appointed issuer may perform that action.

### 5.3 Official terminal candidate outcomes

- **Closed:** The authorized technical issuer has formally issued the exact response version and technical closure has been recorded under the approved issue/closure control. Delivery, access, acknowledgement and recipient substantive response remain separate.
- **Withdrawn:** An eligible official RFI has reached an authorized withdrawal outcome following a valid request and required validation/concurrence. Official identity and history are preserved.
- **Cancelled:** An official RFI has reached an authorized administrative cancellation outcome for a specifically permitted and evidenced administrative ground. It is not a technical rejection; official identity and history are preserved.

## 6. State boundaries and audit evidence

| Boundary | Minimum evidence that should be independently traceable | Must not be inferred from |
|---|---|---|
| Draft → Submitted | Successful formal validation, eligible originator authority, submission snapshot, official identity/number allocation event | Draft save, preview, failed attempt, button click alone |
| Submitted → Under Coordination | Intake acceptance by an appointed coordinator within administrative scope | Technical approval or assignment title |
| Under Coordination → Returned for Completion | Specific permitted deficiency, authorized return action, reason and preserved prior submission | Informal comment or failed initial validation |
| Returned for Completion → Under Coordination | Originator's controlled resubmission, preserved versions, revision classification where applicable | Silent overwrite of prior submission |
| Under Coordination → In Technical Assessment | Valid technical scope and assignments established by authorized technical authority | Coordinator's administrative role alone |
| In Technical Assessment → Awaiting Originator Clarification | Exact clarification request, scope, blocking designation and affected work | Generic email, notification or non-blocking query |
| Awaiting Originator Clarification → prior active stage | All blocking clarification requests satisfied, with responses recorded | One response where other blocking requests remain open |
| In Technical Assessment → Under Consolidation | Required contributions complete or formally removed by authorized scope change | Partial draft/contribution or elapsed time |
| Under Consolidation → In Technical Assessment | Identified gap/conflict, affected discipline, reason and preserved candidate/contributions | Unrecorded disagreement or coordinator instruction |
| Under Consolidation → Under Independent Review | Approved mandatory trigger, reviewer appointment/independence, frozen version/evidence | A generic second signature or unapproved risk score |
| Review → Ready for Issue | Passing outcome for exact unchanged version, no blocking comments, all other readiness gates satisfied | Review of a prior or materially changed version |
| Ready for Issue → Closed | Action-time revalidation, authorized issuer, exact version, successful formal issue and technical closure evidence | Ready status, dispatch attempt, recipient access or acknowledgement |
| Any eligible state → Withdrawn/Cancelled | Valid ground/request as applicable, actual authorized decision, required concurrence, preserved history | Originator request alone, generic admin convenience, desire to erase a record |

These are evidence categories for design review. They do not prescribe database fields, API contracts, event schemas, or implementation.

## 7. Terminality and non-lifecycle indicators

### 7.1 Terminality proposal

- **Draft** is non-official and can remain active until submitted or abandoned under a separate draft policy.
- **Abandoned Draft** is terminal only for that draft record.
- **Closed, Withdrawn and Cancelled** are terminal outcomes for the applicable official RFI cycle/identity under their distinct approved meanings. Any reopening must follow DEC-106 and create a new traceable response cycle; it must not overwrite prior closure.
- The other official candidate states are non-terminal. A parent lifecycle transition must be supported by an authorized event and evidence.

Whether terminality is defined at the official RFI identity level or at the response-cycle level must be aligned with the owner decision on reopening. This memorandum does not settle that separate OR-01 item.

### 7.2 Explicitly excluded from parent lifecycle

Do not add the following as parent RFI states: Overdue, Partially Delivered, Failed Delivery, Acknowledgement Pending, Viewed, Unread, Escalated, Awaiting Transmittal, Workload Queue, Archived, On Hold (unless a separately authorized lifecycle policy is later approved), or notification/retry conditions.

- Recipient delivery and acknowledgement remain recipient-level communication records under DEC-103 and DEC-108.
- Access/view events remain separate from acknowledgement and technical response.
- Notification, workload and aging remain monitoring/reporting dimensions under DEC-109.
- Archive, retention, legal hold and disposition remain records controls, not technical lifecycle stages.
- A Transmittal is a distinct communication identity and must not be collapsed into the RFI state.

## 8. Naming and vocabulary observations

1. **Submitted** is concise and familiar, but the definition must say “successfully formally submitted”; it must not mean a pending submission attempt.
2. **Under Coordination** is acceptable if the administrative-only boundary appears in the user-facing help text and permissions.
3. **Returned for Completion** is preferable to “Rejected” because it is not a technical disposition. The precise post-submission eligibility still needs owner decision.
4. **In Technical Assessment** is grammatically clear and distinguishes technical work from coordination.
5. **Awaiting Originator Clarification** is explicit but long. A shorter label such as “Awaiting Clarification” could be considered only if the UI makes the responsible party and blocking scope unmistakable. Do not rename in code before owner disposition.
6. **Under Consolidation** is acceptable if its entry gate is strict and subordinate drafting is distinguished.
7. **Under Independent Review** is explicit and should remain conditional on an approved review trigger.
8. **Ready for Issue** must not be shortened to “Approved” because readiness is not formal issuance and may not be equivalent to approval by every external party.
9. **Closed** is concise but requires a help-text definition that it means formal technical issue/closure, not recipient acknowledgement or archive completion.
10. **Withdrawn** and **Cancelled** should remain distinct and carry different reason/authority controls.
11. Do not use one generic **Completed** state for the three terminal outcomes.

No final label change is recommended without owner decision and review of downstream reports, user language, translations and transition references.

## 9. Open owner choices for DISP-OR01-001

The owner should record an explicit disposition on each point:

1. Confirm that Draft and Abandoned Draft are outside the official RFI lifecycle and handled as separate draft-record conditions.
2. Confirm, amend, split or remove each of the 11 official candidate labels.
3. Confirm whether Submitted is a persistent parent state or a formal submission event followed immediately by Under Coordination. If event-only, define the auditable event and first persistent state.
4. Confirm whether Returned for Completion is limited to administrative/information deficiencies and which authority can invoke it.
5. Confirm whether Awaiting Originator Clarification is a parent state only when at least one blocking request exists, with multiple requests tracked independently.
6. Confirm the strict parent entry gate for Under Consolidation and whether earlier parallel preparation is represented only as subordinate activity.
7. Confirm the conditions under which Under Independent Review is mandatory and how unresolved risk-matrix cases are blocked.
8. Confirm that Ready for Issue is not an issued/approved/closed state.
9. Confirm that Closed, Withdrawn and Cancelled are three distinct terminal outcomes and define their applicable scope relative to response cycles.
10. Confirm the explicit exclusion of delivery, access, acknowledgement, notifications, workload and archive indicators from parent lifecycle vocabulary.
11. Confirm the exact user-facing labels/translations only after semantic definitions are approved.

## 10. Required specialist validation

| Domain | Validation requested | Evidence expected before promotion |
|---|---|---|
| Process owner / project governance | Business meaning, state boundaries, terminality, permitted outcomes | Attributable owner disposition with scope and rationale |
| Document Control | Intake/return/issue record handling and non-conflation with Transmittal | Reviewed process mapping and records evidence requirements |
| Technical authority / discipline leads | Technical assessment, contribution completion, consolidation and conflict gates | Approved authority and contribution rules; no assumed appointments |
| Security / architecture | State-changing authority, scope enforcement, server-side controls, separation of parent and subordinate records | Reviewed threat/authorization model and negative test requirements |
| QA / test governance | Measurability, valid/invalid transitions, stale version and concurrency testability | Requirement-to-test traceability and acceptance evidence under DEC-110 |
| Records / information governance | Draft abandonment, terminal record preservation, archive separation | Applicable approved records policy; no retention period inferred |

A reviewer's title alone is not evidence of appointment or authority. No person or role is appointed by this memorandum.

## 11. Protected governance and consistency checks

This review must preserve, not reopen:
- **DEC-104/105:** enabled originators, administrative-only coordinator, multidisciplinary contributions, distinct technical leadership, independent review principle and authorized technical issuer.
- **DEC-106:** clarification/revision classification, withdrawal, cancellation, reopening and closure boundaries.
- **DEC-107:** no official number for drafts or failed attempts; official number allocation only on first successful formal submission; identity and evidence integrity preserved.
- **DEC-108:** formal external response distribution via controlled Transmittal; RFI, response version and Transmittal identities remain separate; acknowledgement is independent.
- **DEC-109:** lifecycle, workload, aging and communication indicators remain distinct; archival controls remain separate.
- **DEC-110:** eventual verification requires positive and negative authorization, lifecycle, concurrency, evidence, communication, monitoring and records tests; no test is claimed executed here.
- **DEC-022-A/B:** material response changes are classified through the existing formal revision policy, not by relabeling a state.

If any candidate definition conflicts with these controls, stop and use the formal governance amendment route; do not resolve the conflict through UI wording or implementation.

## 12. Owner disposition record — conditionally approved scope

| Field | Owner / authorized custodian entry |
|---|---|
| Disposition ID | DISP-OR01-001 |
| Decision authority and instrument | Project owner — explicit approval instruction in the project decision conversation; no separate signed authority instrument attached to this record |
| Decision date and effective scope | 2026-11-12; DISP-OR01-001 only, limited to the vocabulary direction and controlled refinement baseline recorded below |
| Disposition | **Conditionally approved** |
| Accepted labels and definitions | Draft and Abandoned Draft remain separate pre-submission draft-record conditions outside the official parent RFI lifecycle; retain the 11 official candidate labels as the baseline for controlled refinement; Closed, Withdrawn and Cancelled remain distinct terminal outcomes; delivery/access/acknowledgement/notification/archive/workload indicators remain outside the parent lifecycle |
| Amended / removed / split / merged labels | None approved by this disposition; individual wording and detailed semantics remain subject to specialist validation and reconciliation |
| Rationale and alternatives considered | The owner explicitly accepted the technical recommendation. The direction preserves official identity boundaries, distinguishes technical closure from administrative outcomes, and separates lifecycle from communication/records indicators |
| Conditions / unresolved items | Complete required process-owner, Document Control, technical architecture, security, QA and records validation as applicable; reconcile with remaining OR-01 dispositions and downstream specifications before promotion. No implementation or test execution is authorized |
| Specialist reviews and dissent | Pending; no specialist sign-off or dissent record is claimed |
| Evidence references | Owner instruction in the project conversation dated 2026-11-12; this memorandum; linked disposition record in docs/87 |
| Register update and independent verification | docs/87 register updated; docs/86 and docs/88 cross-references updated; post-write fetch verification completed on 2026-11-12 |

No status such as Conditionally Approved or Approved may be entered without the actual attributable decision and supporting evidence required by docs/87.

## 13. Promotion gate and exclusions

Before any promotion into authoritative specification:
- owner dispositions are recorded for all vocabulary choices;
- required specialist reviews and dissent are captured;
- definitions are reconciled with transition guards, cycle semantics and subordinate records;
- docs/72, docs/88, docs/87, docs/86, docs/71 and traceability are updated consistently;
- security, records and QA impacts are reviewed;
- DEC-110 test cases are traced, but execution occurs only under a separately approved plan and environment.

This memorandum does **not** authorize workflow/state-machine implementation, UI/API/code changes, DB/schema/migrations/generated types, Storage, authentication, authorization/RLS/grants, production-data operation, live tests, backup/restore, merge, deployment or release.

---
**End of technical review memorandum — owner disposition conditionally approved for the exact scope recorded in §12; specialist validation and promotion gates remain open.**
