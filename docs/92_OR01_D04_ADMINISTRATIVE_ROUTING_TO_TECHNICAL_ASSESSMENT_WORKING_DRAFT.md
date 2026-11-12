# OR-01 / DISP-OR01-004 — Administrative Routing into Technical Assessment

**Document type:** Detailed lifecycle decision review memorandum  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — TECHNICAL RECOMMENDATIONS ONLY — OWNER DISPOSITION NOT RECORDED — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Source detailed specification:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`, §§3.2–3.4 and §§4.1–4.6  
**Related review:** `docs/91_OR01_D03_COORDINATION_AND_RETURN_FOR_COMPLETION_WORKING_DRAFT.md`, §16 (DISP-OR01-003 / Option C)  
**Controlling governance:** DEC-104, DEC-105, DEC-107, DEC-109, DEC-110; DEC-022-A/B where controlled-content revision classification is implicated

> This memorandum recommends a controlled hand-off from administrative coordination to technical assessment. It does not appoint a technical authority, technical lead or discipline responder; grant a capability; approve a final transition matrix; or authorize workflow implementation or test execution.

## 1. Decision question and scope

DISP-OR01-004 asks what must be true before an official RFI may transition from **Under Coordination** to **In Technical Assessment**, what evidence establishes that the required technical responsibility has been assigned, and which actions remain exclusively with the appointed technical authority rather than the administrative coordinator.

The decision is about the parent lifecycle hand-off and its minimum evidence. It does not settle the detailed technical conflict model, discipline contribution lifecycle, clarification behavior, consolidation, independent review, or formal issue/closure rules; those remain separate OR-01 dispositions.

## 2. Protected constraints

1. **DEC-105 — administrative/technical separation:** the coordinator may perform administrative routing only within explicit delegation. The coordinator must not determine engineering discipline, technical scope, technical lead, adequacy of the engineering question, discipline conflict disposition, or the official answer merely by virtue of coordinating the RFI.
2. **DEC-105 — multidisciplinary responsibility:** each discipline contribution remains independently attributable. A technical lead coordinates and consolidates but does not erase a discipline position or acquire authority beyond an explicit appointment/delegation.
3. **DEC-107 — official identity:** routing does not allocate, replace or reset the official RFI number. The successful submission identity and submitted evidence snapshot remain preserved.
4. **DEC-109 — separate indicators:** routing, workload, aging, notification, delivery and access indicators must not be conflated with the parent lifecycle or create default SLA/clock rules.
5. **DEC-110 — verifiability:** the design must permit positive and negative authorization checks, invalid-transition denial, concurrency/idempotency, evidence/history preservation and recovery verification. No test is claimed executed.
6. **DISP-OR01-003 / Option C:** ordinary administrative return is limited to the pre-technical-assessment stage. A late administrative defect follows a separately authorized correction path and does not silently reset the parent lifecycle. This routing decision must not become a workaround for that boundary.

## 3. Technical recommendation — two-key hand-off

**Recommended direction for owner consideration:** treat the transition as a two-key hand-off with separate responsibilities:

- **Technical authorization key:** the currently appointed technical authority (or a separately appointed technical assignment authority acting under explicit delegation) determines and records the technical routing package: required discipline scope, accountable technical lead, required discipline assignments, assignment scope and any specialist/independent-review needs that must be known at intake.
- **Administrative execution key:** the currently appointed coordinator verifies that the administrative prerequisites and required routing evidence are present, then performs the administrative routing action within the coordinator's active project/party/RFI scope.

The coordinator's routing action records the hand-off; it does not create the technical decision or validate its engineering correctness. The technical authority's determination does not, by itself, give the coordinator any additional technical capability.

If the technical authority or its valid appointment/delegation cannot be established, the RFI remains in **Under Coordination** and is referred to the designated project/process authority. No default technical authority, discipline owner or lead may be inferred.

## 4. Candidate entry gate — minimum evidence before transition

The following is a proposed minimum gate for specialist validation, not an approved field schema:

| Gate | Required evidence | Decision owner / boundary |
|---|---|---|
| Official record eligibility | RFI has a successful formal submission, official identity, current parent state **Under Coordination**, and preserved submitted snapshot | System/records integrity; no new number or identity at routing |
| Administrative readiness | Required administrative intake checklist is complete; project, party, originator, subject, declared context and required references are internally consistent under approved project rules | Coordinator verifies presence/consistency only within delegated administrative scope |
| Technical authority basis | Named technical authority or assignment authority has a current, evidenced appointment/delegation for the project, party, technical subject and relevant RFI scope | Project governance / appointing authority; no inferred appointment |
| Technical scope determination | Required discipline(s) and boundaries of each discipline's work are explicitly determined, including treatment of genuinely cross-disciplinary questions | Appointed technical authority; coordinator must not infer disciplines from keywords or convenience |
| Technical leadership | A technical lead is explicitly appointed where the approved project model requires one, with subject, scope, effective period and delegated authority recorded | Appointing technical authority; lead appointment does not imply issuer or independent-review authority |
| Discipline assignment readiness | Every required discipline assignment has an identified authorized assignee, defined scope/output, relevant evidence/context and active assignment authority; assignment is not merely a distribution recipient | Authorized assignment authority; coordinator may record/route only where delegated |
| Access and confidentiality | Each assigned participant's access to the exact RFI and linked evidence is currently authorized and limited to the project/party/discipline/assignment scope | Security and server-side authorization; UI visibility is not a grant |
| Handoff record | Technical routing decision, assignment set/version, coordinator routing event, actor/appointment basis, timestamp and correlation/evidence references are attributable and traceable | Both functions record their own action; no silent substitution |

**Recommended parent transition guard:** do not move the parent RFI to **In Technical Assessment** until all required technical assignments and any required technical lead are validly established. Partial preparation may be tracked separately only if a separately approved subordinate-work model permits it; it must not be represented as completed parent hand-off.

The existence of a discipline label in the submitted form is not, by itself, an authorized technical determination or an assignment.

## 5. Discipline selection, ambiguity and multi-disciplinary cases

1. The originator may identify the discipline(s) believed relevant as intake information. That declaration is useful context, not the final technical scope decision.
2. The appointed technical authority confirms the required discipline set and may add, remove or split scopes only with an attributable rationale and within its appointment.
3. If discipline ownership is ambiguous, disputed, unavailable or outside the authority's competence, the RFI remains **Under Coordination** pending referral to the designated higher technical authority. The coordinator must not choose a discipline by default.
4. For a multi-disciplinary RFI, each required discipline receives a separately attributable assignment and scope. A single technical lead may coordinate a consolidated response only where explicitly appointed and competent for that coordination scope.
5. A discipline assignment must not imply that the assignee can decide another discipline's professional position, resolve a cross-discipline conflict, independently review their own response where prohibited, or issue the formal answer.
6. If a required discipline has no valid assignee, the parent transition is blocked under the recommended complete-handoff gate. No silent omission, inferred concurrence or empty placeholder assignment is permitted.
7. If a question is genuinely single-discipline, the technical authority records that determination; no artificial multi-discipline assignment is required.

## 6. Coordinator permissions and prohibited actions

| Coordinator may do, if explicitly delegated | Coordinator must not do by virtue of coordination |
|---|---|
| Verify the administrative intake checklist and current parent state | Decide technical discipline or engineering scope |
| Check that a valid technical routing decision and assignment evidence exist | Appoint a technical lead or discipline responder without a separate explicit appointment/delegation |
| Route the RFI and record the administrative hand-off | Choose technical assignees based on availability, title, group membership or convenience without delegated assignment authority |
| Correct administrative routing metadata through an approved auditable process | Rewrite technical scope, alter the submitted question or discard a discipline assignment |
| Refer ambiguity or missing authority to the designated project/process authority | Resolve technical conflicts, declare technical acceptance, issue or close the RFI |
| Monitor routing completion as a workload indicator | Treat delivery, notification, read/access or silence as technical acceptance |

A coordinator may hold or refer an incomplete routing package, but must not make the technical decision needed to cure the deficiency.

## 7. Recommended transition sequence

1. The official RFI is in **Under Coordination** after successful formal submission and intake acceptance.
2. The coordinator confirms administrative checklist completion and identifies any missing administrative evidence without judging engineering adequacy.
3. The coordinator requests the technical routing determination from the appointed technical authority through the separately governed internal process.
4. The technical authority records the required discipline set, scope boundaries, technical lead (if required), assignment authority and any mandatory specialist participation.
5. The authorized assignment function creates/records each required discipline assignment with assignee, scope, effective authority and exact RFI/cycle reference.
6. Current authorization and access are verified for every assigned participant and relevant evidence resource.
7. The coordinator checks that the complete routing package exists and is internally consistent as an administrative matter.
8. The coordinator performs the parent transition to **In Technical Assessment** only if the active state and all transition guards still hold at action time.
9. The transition event references the technical routing decision and assignment-set version. Each discipline contribution then proceeds as a separately attributable subordinate work item.
10. Any later assignment change is recorded as a new attributable event under the separately governed assignment process; it must not erase prior assignments or contributions.

The technical authority may need to revise the routing package before the hand-off is complete. Such revision is not an administrative return and does not change the official RFI identity.

## 8. Failure, exception and negative cases

| Scenario | Required design outcome | Prohibited outcome |
|---|---|---|
| No valid technical authority appointment | Keep parent in Under Coordination; refer to appointing/project authority | Coordinator assumes technical authority |
| Discipline ownership is ambiguous | Hold hand-off pending explicit technical determination | Default to the coordinator's discipline or infer from subject keywords |
| Required discipline has no authorized assignee | Block parent transition under the recommended complete-handoff gate | Move to technical assessment with a missing required assignment |
| Technical lead is required but not appointed | Hold transition; obtain valid appointment | Treat coordinator or senior responder as lead by title |
| Multi-disciplinary scope is disputed | Refer to designated technical authority; preserve each position | Coordinator chooses a winner or majority vote |
| Assignee has project membership but no exact scope authorization | Deny assignment/access; preserve routing record | Membership/group presence grants access or authority |
| Assignment package is stale or changed during routing | Recheck current version/state; retry only against current authoritative package | Commit a transition against stale assignments |
| Duplicate routing command | Idempotent/ordered outcome; one valid parent transition and traceable event history | Duplicate assignment sets or duplicate lifecycle transitions |
| Notification to an assignee fails | Keep routing/lifecycle result separate; record communication failure independently | Automatically roll back technical routing or treat notification as acceptance |
| Administrative checklist is incomplete | Remain Under Coordination; identify exact administrative gap | Route with known missing mandatory administrative evidence |
| Technical scope changes after hand-off | Use an authorized technical scope/assignment change event; preserve previous assignments and contributions | Silently rewrite the original routing decision or erase work |
| Late administrative defect after assessment begins | Apply DISP-OR01-003 Option C correction boundary; no generic parent rollback | Reopen Under Coordination as a coordinator convenience |
| Coordinator lacks active scoped routing capability | Deny transition and preserve state/history | UI button visibility or job title grants permission |

These are proposed design outcomes and test scenarios, not executed or passed tests.

## 9. Authorization, evidence and transaction integrity

The detailed specification's authorization contract should apply to the exact routing transaction:

- authenticated actor and active account;
- project and effective party scope;
- RFI visibility/confidentiality and exact official identity/cycle;
- current parent state and allowed transition;
- explicit routing capability and active coordinator appointment;
- technical routing decision reference and its current version;
- technical authority / assignment authority appointment and scope;
- each required assignment, assignee, discipline, effective period and evidence;
- access entitlement for the exact record and linked evidence;
- separation-of-duties and any conflict constraints;
- current policy/configuration version and event correlation.

Deny by default if any required fact is missing, expired, ambiguous, stale or outside scope. Authorization must be rechecked at action time, not only when the screen is opened.

The hand-off should behave as one logically consistent transition: either the parent state and its routing reference are committed together, or the parent remains in its prior state with no partial transition. Retries, stale-state submissions and concurrent changes must not create duplicate assignments or contradictory parent history. The specific locking, transaction, event and persistence mechanisms remain for architecture/security review and are not selected here.

The audit record should preserve who made the technical scope decision, who created/changed assignments, who executed administrative routing, which appointment/delegation justified each action, the exact assignment-set version, the prior/new parent state, timestamp and evidence references.

## 10. Reporting and communication boundaries

- Parent lifecycle state indicates the official RFI stage, not whether every assigned participant has opened a notification.
- Assignment status, contribution progress, workload and aging remain subordinate/workload indicators unless separately approved as parent-state gates.
- Delivery, access, acknowledgement and substantive response remain distinct recipient communication events under DEC-103/108.
- No default response SLA, assignment acceptance deadline, escalation cadence, notification channel or contractual effect is created.
- A routing event does not constitute technical acceptance, review completion, response approval or formal issue.

## 11. Owner decisions required

The owner should record a discrete disposition for each question; accepting the general memorandum must not silently answer every detailed policy choice:

1. **Two-key hand-off:** approve the separation between technical authorization of the routing package and coordinator execution of the administrative transition?
2. **Complete assignment gate:** must all required discipline assignments and any required technical lead be valid before the parent enters In Technical Assessment, or is a separately modeled partial hand-off permitted?
3. **Technical authority:** which project authority appoints the technical authority/assignment authority, and what evidence proves the appointment and scope?
4. **Discipline determination:** which technical authority confirms the required discipline set where the originator's declaration is incomplete, ambiguous or disputed?
5. **Technical lead:** when is a lead mandatory, who appoints the lead, and what delegation is required for assignment or conflict actions?
6. **Assignment minimums:** what exact information must each discipline assignment contain, and which fields are mandatory versus project-configurable?
7. **Assignee acceptance:** is an explicit acceptance event required before parent transition, or is a valid issued assignment sufficient? This must be decided without assuming a deadline or default SLA.
8. **Missing/unavailable discipline:** what escalation authority resolves unstaffed or unavailable required disciplines?
9. **Post-handoff changes:** which assignment/scope changes require technical-authority reapproval, and how are prior contributions preserved?
10. **Partial preparation:** may subordinate technical preparation begin before all assignments are ready while the parent remains Under Coordination, or must all work wait for the parent transition?

## 12. Specialist validation requested

| Domain | Validation question | Evidence expected |
|---|---|---|
| Technical / discipline authorities | Is the two-key hand-off clear, and can the designated technical authority reliably determine disciplines and scope? | Written boundary review and representative single-/multi-discipline examples |
| Project/process owner | Is the complete-assignment gate operationally workable across projects and parties? | Process disposition and approved exception/escalation route |
| Document Control | Are the administrative checklist and routing evidence sufficient without making DC the technical decision-maker? | Reviewed checklist and sample routing package |
| Architecture | Can the parent transition and assignment-set reference remain consistent under concurrency, retries and stale updates? | Architecture review; no implementation implied |
| Security | Are appointments, exact scope, resource visibility and assignment access checked server-side at action time? | Positive/negative authorization review |
| QA | Are missing authority, missing discipline, stale assignment, duplicate routing and invalid actor cases traceable? | Test-design review; no execution implied |
| Records | Are routing decisions, assignment changes and prior contributions retained as attributable history? | Records classification/reference; no retention duration invented |

These are review domains, not named appointments or completed sign-offs.

## 13. Cross-specification dependencies and implementation boundary

This review must reconcile with:
- **DISP-OR01-001:** the candidate official state vocabulary remains a controlled refinement baseline, not a final state machine.
- **DISP-OR01-002 / DEC-107:** successful formal submission and official identity remain fixed; routing does not allocate or change the number.
- **DISP-OR01-003 / Option C:** ordinary administrative return remains pre-assessment; late administrative defects use a separately authorized correction path without generic parent rollback.
- **DEC-105:** coordinator, technical authority, technical lead, discipline responder, reviewer, issuer and Document Control responsibilities remain distinct.
- **DEC-109:** workload/aging/communication indicators remain separate and no default SLA/cadence is introduced.
- **DEC-110:** verification must include both authorized and unauthorized routing, missing assignment/authority, stale state, concurrency and recovery.

This memorandum does not amend DEC-104–DEC-110 or DEC-022-A/B; approve a final discipline matrix or assignment catalogue; appoint any person; create or grant capabilities; define SLA or contractual effect; create UI/API/code/workflow/state-machine behavior; change DB/schema/migrations/generated types, Storage, authentication, authorization/RLS/grants or production data; execute tests; perform backup/restore; merge, deploy or release.

## 14. Technical recommendation summary

**Recommended baseline for owner consideration:**
1. Use a two-key hand-off: technical authority determines and evidences technical routing; coordinator performs only the administrative transition.
2. Require a complete, valid routing package before the parent enters In Technical Assessment: required disciplines, required lead, scoped assignments and access evidence.
3. Never infer technical authority, discipline ownership, lead appointment or assignment from job title, membership, keyword matching or convenience.
4. If scope or ownership is ambiguous or an appointment/assignee is missing, keep the RFI in Under Coordination and escalate to the designated technical/project authority.
5. Preserve official identity, submission snapshot, routing decisions, assignment versions and all subsequent contribution history.
6. Keep assignment progress and communication events separate from parent lifecycle state unless a separately approved rule explicitly defines a gate.

**No owner disposition is recorded by this memorandum.** All recommendations remain open for explicit owner decision and specialist validation.

---
**End of working draft — technical recommendation only; owner disposition and specialist validation pending.**
