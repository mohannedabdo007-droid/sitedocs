# RFI Lifecycle and Authority Specification — Working Draft

**Document type:** Non-authoritative detailed-design working draft  
**Date:** 2026-11-12  
**Status:** PROPOSED FOR REVIEW — NOT GOVERNANCE APPROVAL — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Controlling governance baseline:** `governance/scan-lifecycle-design-2026-11-11`  
**Primary decisions:** DEC-104, DEC-105, DEC-106, DEC-109, DEC-110  
**Backlog items:** RFI-DD-01 and RFI-DD-02  
**Related working draft:** `docs/69_RFI_WORKFLOW_DESIGN_WORKING_DRAFT.md`

> This document develops candidate lifecycle and authority specifications within the approved policy boundaries. Candidate state names, transition details and capability mappings below are not owner-approved merely because DEC-104–DEC-110 approve the policy direction. Unresolved details are explicitly marked. No permission grants, workflow behavior, API/UI/code, DB/schema/migration/generated types, Storage, authentication/authorization/RLS, production-data operation, live testing, merge or deployment is authorized.

## 1. Purpose and decision discipline

This specification addresses the two foundational workstreams:

- **RFI-DD-01:** candidate parent lifecycle states, transition guards, cycle behavior and event model.
- **RFI-DD-02:** action-level authority, capability/appointment boundaries, separation of duties and deny cases.

It does not finalize technical mechanisms or grant authority to real users. Every item is classified as:

- **Approved constraint:** directly required by DEC-104–DEC-110 or the controlling baseline.
- **Recommended design:** a proposed detailed rule for owner/authority review.
- **Open decision:** a value, authority, project policy or mechanism that must be explicitly resolved.

## 2. Approved constraints that the specification must preserve

1. RFI is an engineering Request for Information and remains separate from WIR in identity, numbering, permissions, lifecycle, reports and audit (DEC-002/104).
2. The authorized originator population is explicitly enabled by project, party and RFI scope; membership alone is insufficient (DEC-105).
3. The coordinator performs delegated administrative tasks only and does not acquire technical decision authority by coordination (DEC-105).
4. One RFI may contain independently attributable discipline contributions and one controlled consolidated answer; technical lead, reviewer and issuer boundaries remain distinct (DEC-104/105).
5. Required independent review must follow an approved risk/authority matrix and applicable separation-of-duties rules; exact triggers remain open (DEC-105).
6. Formal response is issued only by the authorized technical authority; Document Control distributes but does not gain issue, approval or closure authority (DEC-104/105/108).
7. Clarification, formal revision, linked new RFI, withdrawal request, authorized withdrawal, administrative cancellation, reopening and technical closure are distinct (DEC-106).
8. Preferred closure is part of the successful formal-issue transaction after required contributions, conflict resolution and reviews are complete. A separate closure event would require its own explicit authorized rule (DEC-106).
9. Requested dates are informational; target dates require an approved project rule. No default SLA, pause clock or contractual consequence is created (DEC-106/109).
10. Official number allocation, non-reuse, identity stability and immutable evidence principles follow DEC-107 and DEC-022-A/B. RFI number, revision, clarification round, contribution ID, response version and Transmittal ID remain distinct.
11. Delivery, access, acknowledgement, substantive response, notification, overdue, workload and archive are not technical lifecycle transitions (DEC-103/108/109).
12. DEC-110 requires traceable acceptance, negative authorization, concurrency/idempotency, evidence/history, recipient communication, reporting and recovery tests. No test pass is claimed here.

## 3. Candidate parent lifecycle model (RFI-DD-01)

### 3.1 Design principles

- Parent lifecycle describes the controlled technical/administrative stage of one official RFI identity.
- Unsubmitted drafts are separate draft records and are not official RFIs.
- A parent RFI has one current lifecycle stage; assignments, contributions, reviews, clarification requests and recipient events have their own subordinate states.
- Every consequential transition is server-authorized at action time against the exact RFI, cycle, version, party/project scope, assignment and capability.
- Every transition preserves prior state, actor, authority context, timestamp, reason, affected scope and linked evidence as attributable history.
- No communication, due-date, notification, archive or read event can substitute for a technical transition.
- Technical closure occurs only through successful authorized formal issue and its associated closure event, subject to DEC-106.

### 3.2 Candidate state dictionary

The following names are a proposed vocabulary for review, not approved final labels.

| Candidate state / record condition | Meaning | Candidate entry guard | Classification |
|---|---|---|---|
| Draft | Unsubmitted originating-party working record; no official RFI number | Authorized draft creation; draft remains private to permitted originator/oversight scope | Draft record, outside official lifecycle |
| Abandoned Draft | Unsubmitted draft no longer pursued | Authorized draft owner action; no official number consumed | Draft record disposition, not official withdrawal |
| Submitted | Successful formal submission and official RFI identity allocation | Required submission fields, current originator capability, scope and snapshot checks succeed atomically | Candidate official lifecycle state |
| Under Coordination | Administrative intake, completeness, routing and assignment setup | Designated coordinator accepts within delegated administrative scope | Candidate official lifecycle state |
| Returned for Completion | Post-submission administrative or information deficiency requires originator action; not an engineering rejection | Authorized coordinator records precise deficiency and permitted return reason | Candidate official lifecycle state; eligibility and revision effect need confirmation |
| In Technical Assessment | Required discipline responders prepare scoped contributions; technical lead manages technical work | Valid technical lead and required assignments are established | Candidate official lifecycle state |
| Awaiting Originator Clarification | One or more clarification requests block the next technical action | Authorized technical participant records exact clarification request, scope and affected work | Candidate official lifecycle state; resume logic specified below |
| Under Consolidation | Technical lead prepares one consolidated answer and resolves or escalates material conflicts | Recommended entry only after all required contributions are complete or an authorized scope change has formally removed an assignment | Candidate official lifecycle state |
| Under Independent Review | Frozen consolidated response version is under a mandatory independent review | Approved risk/authority trigger applies; appointed reviewer is authorized and independent for exact version | Candidate official lifecycle state |
| Ready for Issue | All required contributions, conflict resolutions and mandatory reviews are complete; exact candidate response is frozen | Technical lead/authorized readiness function confirms all gates | Candidate official lifecycle state |
| Closed | Authorized technical response has been formally issued and technical closure recorded atomically | Successful issue transaction by appointed issuer; exact response version and closure evidence committed together | Candidate terminal technical state |
| Withdrawn | Eligible pre-issue RFI is withdrawn through authorized decision | Originator request; authorized validation; technical-lead concurrence after substantive work begins | Candidate terminal administrative outcome |
| Cancelled | RFI is administratively cancelled for evidenced duplicate/invalid-registration or other specifically approved administrative ground | Designated records/workflow authority; technical-lead concurrence if technical work began | Candidate terminal administrative outcome |

**Explicit exclusions from parent state vocabulary:** Overdue, Partially Delivered, Failed Delivery, Acknowledgement Pending, Viewed, Unread, Escalated, Awaiting Transmittal, Workload Queue and Archive are not parent RFI lifecycle states.

### 3.3 Candidate transition matrix

| From | To / event | Actor / authority boundary | Required guards and evidence |
|---|---|---|---|
| Draft | Submitted | Explicitly eligible originator | Validate required fields, party/project/RFI scope, current capability and submitted evidence manifest; allocate official number only on successful first submission; freeze submitted snapshot |
| Draft | Abandoned Draft | Authorized draft owner | No official number; preserve draft handling according to separately approved retention/privacy rules |
| Submitted | Under Coordination | Appointed coordinator | Active appointment and delegated project/party scope; record intake acceptance |
| Under Coordination | Returned for Completion | Coordinator only where explicitly delegated | Specific administrative/information deficiency; not an engineering disposition; preserve official number and prior snapshot |
| Returned for Completion | Under Coordination | Authorized originator resubmits | Preserve prior return and submitted versions; classify any controlled-content change under DEC-022-B before changing revision |
| Under Coordination | In Technical Assessment | Coordinator performs administrative routing; technical authority controls technical scope | Required disciplines and technical lead determined by authorized technical authority; named assignments valid |
| In Technical Assessment | Awaiting Originator Clarification | Assigned responder or technical lead within scope | Exact question, requester, affected discipline/contribution, reason and blocking dependency recorded |
| Awaiting Originator Clarification | Prior active stage resumes | Originator provides requested information; system records response | Resume only when all blocking clarification requests are satisfied; preserve each request/response and prior stage |
| In Technical Assessment | Under Consolidation | Technical lead within appointed scope | All required contributions submitted, or a formal authorized scope change removes an assignment; no unresolved blocking contribution |
| Under Consolidation | In Technical Assessment | Technical lead routes specific gap back to discipline work | Identify missing work, conflict, affected discipline and reason; preserve current candidate and prior contributions |
| Under Consolidation | Under Independent Review | Technical lead submits frozen candidate | Review trigger is active under approved matrix; reviewer appointed, qualified and independent; exact version frozen |
| Under Consolidation | Ready for Issue | Technical lead confirms no mandatory review applies | Record trigger assessment; all required contributions complete; conflicts explicitly resolved by authority; no blocking review remains |
| Under Independent Review | Ready for Issue | Authorized independent reviewer records passing outcome | Outcome applies only to exact frozen version; no blocking comment; version unchanged |
| Under Independent Review | Under Consolidation or In Technical Assessment | Reviewer requests changes or substantive rework | Preserve review and candidate; create new response candidate; re-review if trigger still applies |
| Ready for Issue | Closed | Specifically appointed technical issuer | All issue guards rechecked at action time; response version frozen; issue and closure commit atomically; failure leaves no partial issue/closure |
| Eligible pre-issue state | Withdrawal request / Withdrawn decision | Originator requests; designated records/workflow authority validates | Request is not itself transition; reason and scope recorded; technical-lead concurrence after substantive work begins; no number reuse |
| Eligible administrative state | Cancelled | Designated records/workflow authority | Evidenced administrative reason; technical-lead concurrence if technical work began; cannot represent engineering rejection |
| Closed | Reopened event and new active cycle | Designated technical authority | Recorded reason, scope and predecessor response; create new cycle; preserve old issue/closure; reassess assignments, conflicts and review |
| Any lifecycle state | Delivery/access/acknowledgement/notification/archive event | Recipient, provider or records authority as applicable | Record separately; no parent lifecycle change unless a separately authorized technical transition independently occurs |

**Open transition questions:** exact eligibility of Returned for Completion; whether Under Consolidation is strictly sequential or may begin as a parallel preparation activity while some non-blocking work continues; exact cancellation-eligible states; detailed withdrawal cutoff and authority; and whether reopening returns to Technical Assessment in all cases or to a state selected by a governed cycle-resumption rule.

### 3.4 Important state-model consistency rules

1. **Draft validation versus post-submission return:** missing mandatory submission fields must fail before official submission and must not consume a number. Returned for Completion can only apply after a successful formal submission and must have a separately defined reason; it must not become a workaround for failed pre-submission validation.
2. **Consolidation gate:** do not conflate starting internal drafting with the parent state Under Consolidation. Recommended parent transition is after all required discipline contributions are complete or an authorized scope change removes an assignment. If partial parallel consolidation is desired, model it as a subordinate task without weakening the parent readiness gate.
3. **Clarification concurrency:** multiple clarification requests may coexist at contribution/assignment level. The parent may show Awaiting Originator Clarification while at least one formally blocking request remains open. Resume the recorded stage only when all blocking requests are satisfied.
4. **Review version binding:** review binds to an exact frozen candidate and evidence set. A material change creates a new candidate and invalidates prior review as approval of that changed content.
5. **Atomic issue/closure:** no state may imply that the response was issued if the issue transaction failed. Delivery/acknowledgement happens independently and cannot roll back closure.
6. **Reopening:** reopening is an event creating a new response cycle, not an edit or deletion of the prior closure. Prior recipient acknowledgements remain attached to the prior Transmittal/version.
7. **Withdrawal/cancellation:** preserve the official number and complete history. Do not allow either outcome to erase or transfer contributions, reviews, response versions or Transmittal events.
8. **No inferred authority:** a title, membership, read permission, roster administration, notification, assignment acceptance or Transmittal access does not grant a workflow capability.

### 3.5 Subordinate records and independent indicators

Keep separate state models for:

- Discipline assignments: Assigned, Accepted, In Progress, Clarification Requested, Contribution Submitted, Changes Requested, Completed, Reassigned or Cancelled — candidate labels only.
- Clarification requests: Open, Responded, Resolved/Closed — candidate labels only; each request has a unique ID and scope.
- Response candidates: Drafting, Submitted for Review, Changes Required, Review Passed, Ready for Issue, Issued — candidate labels only and bound to exact versions.
- Transmittal recipients: individual delivery, access, acknowledgement and substantive-response events under DEC-103/108.
- Monitoring indicators: overdue, workload, notification, report cut-off and archive metadata under DEC-109.

No subordinate state or indicator automatically advances or closes the parent RFI.

## 4. Candidate capability and appointment model (RFI-DD-02)

### 4.1 Authorization contract

Every consequential action must be checked server-side at action time against:

1. authenticated actor and active account;
2. project and effective party scope;
3. RFI visibility/confidentiality and exact resource;
4. exact RFI identity, cycle, revision, assignment and version;
5. explicit action capability;
6. current state and permitted transition;
7. active appointment, discipline/scope and delegation;
8. separation-of-duties and conflict rules;
9. evidence, recipient and records restrictions.

Deny by default if any required fact is missing, expired, ambiguous or out of scope. A hidden UI control is not a security boundary. Direct API, export, preview, download and notification paths must apply the same authorization contract.

### 4.2 Responsibility boundaries

| Responsibility | Permitted scope under approved policy direction | Prohibited inference |
|---|---|---|
| Originator | Create/submit own-party RFI where party, project, class and scope are explicitly enabled; provide requested clarification; request withdrawal where permitted | Membership alone does not authorize origination; originator does not appoint responders, resolve technical conflicts, review own response where independence applies, issue or close |
| RFI coordinator | Administrative completeness, routing, records and coordination actions only within explicit delegation | Coordinator title does not confer engineering scope decisions, conflict resolution, review, issue or closure |
| Discipline responder | Provide attributable contribution within active assignment and discipline scope; request clarification within that scope | Assignment does not authorize another discipline's work, consolidated issue or parent closure |
| Technical lead | Consolidate contributions, preserve conflicts, request rework, and resolve only within expressly delegated technical authority | Lead appointment alone does not confer independent-review or issue authority; cannot silently discard another discipline's position |
| Independent reviewer | Review exact frozen candidate/evidence version within active appointment and approved trigger | Review does not confer issue authority; author cannot review own response where separation applies |
| Authorized technical issuer | Formally issue the exact approved response version within assigned technical scope | Job title, coordinator role, reviewer status or dispatch activity alone does not confer issue authority |
| Records / Document Control / distribution controller | Controlled records administration and dispatch of an already authorized issued response; maintain distribution evidence | Cannot create engineering approval, issue technical response, close RFI or change technical content |
| Project Manager oversight | Read-only visibility within approved oversight scope, including permitted drafts | Read access does not grant edit, assignment, contribution, review, issue, approval, cancellation, withdrawal approval, reopening or closure |
| System / roster administrator | Technical roster administration only within separately governed admin scope | No implicit RFI visibility, cross-party access, impersonation, capability grant, workflow bypass or engineering authority |

### 4.3 Candidate action-capability matrix

Legend: **P** = may perform only with explicit scoped capability and active appointment where required; **C** = only under a separately approved delegation/appointment; **R** = read-only within authorized visibility; **N** = no authority by this responsibility. This is not a live grant matrix.

| Action | Originator | Coordinator | Discipline responder | Technical lead | Reviewer | Issuer | Records / DC | PM oversight | System / roster admin |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Create own-party draft | P | N | N | N | N | N | N | N | N |
| Submit own-party RFI | P | N | N | N | N | N | N | N | N |
| Read permitted submitted RFI | P | P | P | P | P | P | P | R | N |
| Return for administrative completion | N | C | N | N | N | N | C only if designated | N | N |
| Appoint coordinator / route | N | C | N | C only if designated technical authority | N | N | C only if delegated | N | N |
| Appoint technical lead / required disciplines | N | N | N | C only if delegated appointment authority | N | N | N | N | N |
| Assign discipline responder | N | C only if delegated | N | C only if designated assignment authority | N | N | N | N | N |
| Submit scoped contribution | N | N | P | P only for own assigned scope | N | N | N | N | N |
| Consolidate technical response | N | N | N | P | N | N | N | N | N |
| Resolve technical conflict | N | N | N | C within delegated authority | N | C within own appointed authority | N | N | N |
| Perform mandatory independent review | N | N | N | N | P | N | N | N | N |
| Formally issue response | N | N | N | C only if separately appointed issuer | N | P | N | N | N |
| Request withdrawal | P where permitted | N | N | N | N | N | N | N | N |
| Validate/approve withdrawal | N | C if designated records/workflow authority | N | C concurrence after substantive work begins | N | N | C if designated authority | N | N |
| Approve administrative cancellation | N | C if designated authority | N | C concurrence if technical work began | N | N | C if designated authority | N | N |
| Reopen closed RFI | N | N | N | C if designated technical authority | N | C only if separately designated | N | N | N |
| Prepare/dispatch Transmittal | N | C only if delegated | N | N | N | N | P after formal issue authority gate | N | N |
| Archive/classify records | N | N | N | N | N | N | P within records appointment | R only if permitted | N |
| Read audit history | P within own-party scope | P within delegated scope | P within assignment scope | P within technical scope | P for reviewed scope | P for issued scope | P within records scope | R within oversight scope | N by default |
| Manage roster | N | N | N | N | N | N | N | N | P within roster-admin scope |
| Grant/revoke RFI capabilities | N | N | N | N | N | N | N | N | N by default; separate governed grant authority required |

**Critical note:** The table expresses responsibility boundaries only. It does not select machine-readable capability IDs, create role bundles, appoint actual people or activate any grant.

### 4.4 Capability families to define separately

Exact identifiers and grant owners remain open. The detailed catalogue should separate:

- draft create/view/edit/abandon;
- formal submit/resubmit;
- record/field/attachment visibility;
- administrative coordination/return/routing;
- technical lead appointment and technical-scope classification;
- discipline assignment and scoped contribution;
- consolidation and conflict disposition;
- independent review and review outcome;
- formal issue;
- withdrawal request/validation, cancellation, reopening;
- Transmittal preparation/dispatch and recipient-event recording;
- archive/retrieval/disposition;
- roster administration;
- capability grant/revoke and workflow configuration.

Each capability must bind project, party, RFI class, RFI identity, cycle, discipline, assignment, exact resource/version and effective period where relevant.

### 4.5 Separation-of-duties controls

1. A response author/consolidator cannot perform a mandatory independent review of the same response version.
2. Reviewer capability does not imply issuer capability.
3. Document Control/distribution cannot issue or alter technical content.
4. Coordinator administrative authority cannot become technical scope authority.
5. Technical lead authority is bounded by explicit appointment and delegation; it cannot waive mandatory review or another discipline's professional conclusion without the required authority.
6. Project Manager read-only oversight remains read-only.
7. System/roster administration does not confer RFI visibility or workflow authority.
8. Permitted combinations must be explicit and checked on the exact consequential transaction; role switching, shared accounts, proxy signing or retrospective reassignment cannot bypass controls.

### 4.6 Denial and audit requirements

For each allow/deny decision, preserve actor, effective party, capability, resource, project/RFI/cycle/revision, assignment, workflow state, separation rule, policy/configuration version, timestamp and correlation reference. Denials must not leak restricted record existence or content. Check authorization independently for linked records, attachments, exports, search/facets/counts, previews and old links after revocation.

## 9. Discipline responsibility, technical leadership and conflict disposition (RFI-DD-03)

### 9.1 Governing principles

1. Each discipline contribution is separately attributable to its author, discipline, assignment, scope, evidence and version.
2. The technical lead coordinates and consolidates the response; the appointment does not make the lead the owner of every discipline's professional judgment.
3. A discipline opinion must not be deleted, silently rewritten, hidden or represented as concurrence by the technical lead or coordinator.
4. A conflict is a recorded technical condition requiring an authorized disposition, not a formatting inconvenience and not something resolved by majority vote or by the coordinator.
5. The authority that may resolve a conflict must be expressly appointed and delegated for the relevant technical subject, project, party and RFI scope.
6. If the technical lead lacks authority or competence for the subject, the conflict is escalated to the designated technical authority. Until disposition, the affected response content remains blocked from issue.
7. Consolidation must distinguish consensus, compatible discipline inputs, qualified/conditional positions, unresolved conflict and an authorized decision that selects a direction while preserving dissent.

### 9.2 Candidate responsibility model

| Function | Candidate responsibility | Guardrail / limit |
|---|---|---|
| Discipline responder | Produce a complete, evidence-based contribution within assigned discipline and scope; identify assumptions, limitations, interfaces and impacts | Cannot issue the consolidated response or decide another discipline's scope |
| Discipline lead / discipline authority | Validate discipline position where project governance requires it; appoint/confirm responder if separately authorized | Appointment and authority are project-specific; not inferred from job title |
| Technical lead | Maintain response plan, identify interfaces, request missing contributions, compare discipline inputs, document conflict, coordinate resolution within delegated authority and prepare consolidated candidate | Cannot erase dissent, exceed appointment scope, waive mandatory review or issue unless separately appointed |
| Conflict-resolution authority | Decide cross-discipline or technical conflict within an explicit delegated scope and competence | Must record basis, authority, affected disciplines, alternatives, impact and dissent; cannot decide beyond delegation |
| Independent reviewer | Assess the exact consolidated response against applicable requirements and risk triggers | Must be independent of authorship/decision roles as required; review is not issue authority |
| Technical issuer | Issue only after required contributions, conflict disposition and review gates are satisfied | Cannot use issue authority to bypass missing technical evidence or mandatory review |

### 9.3 Contribution completeness and interface checks

A contribution should be considered complete for consolidation only when it records, as applicable:

- discipline and assigned scope;
- named contributor and effective assignment;
- response to the specific engineering question;
- assumptions, limitations and exclusions;
- relevant drawing/specification/standard/document references and evidence;
- impacts on other disciplines, interfaces, constructability, sequence, safety, quality, cost or schedule where relevant;
- explicit statement of agreement, qualified agreement, disagreement or no position;
- unresolved dependencies and clarification requests.

The required fields and discipline-specific checklists remain project-baseline decisions. A blank or ambiguous position must not be interpreted as concurrence.

### 9.4 Conflict classification and disposition path

The following is a recommended minimum classification; labels and materiality thresholds require authority review.

| Conflict class | Example pattern | Candidate handling |
|---|---|---|
| C0 — No conflict | Contributions are compatible and answer different parts of the question | Technical lead records synthesis and source attribution |
| C1 — Interface clarification | Apparent mismatch caused by differing assumptions, boundaries or reference versions | Return targeted clarification to the affected contributors; preserve both inputs |
| C2 — Material technical disagreement | Disciplines recommend incompatible design, specification or execution outcomes | Record each position and evidence; block affected consolidated answer pending authorized technical decision |
| C3 — Authority / scope conflict | Proposed resolution exceeds technical lead's delegated authority or crosses project/contract authority | Escalate to designated technical authority; no coordinator or lead assumption |
| C4 — Unresolved / external dependency | Resolution requires owner/client/designer/authority response or unavailable project information | Keep affected response content blocked; use clarification or linked RFI only under DEC-106 classification rules |

**Candidate disposition sequence**

1. Detect and register the conflict with unique conflict reference, affected disciplines, contribution/version references and date.
2. Preserve each original contribution as immutable evidence.
3. Classify whether it is an assumption/interface clarification, material technical disagreement, authority issue or external dependency.
4. Give affected disciplines an opportunity to explain or correct factual misunderstandings without overwriting their original positions.
5. Technical lead may resolve only a matter expressly within the lead's delegated scope and competence.
6. Matters outside that scope go to the designated conflict-resolution authority.
7. Record the decision, rationale, governing references, alternatives considered, impact, authority basis, effective scope and any dissenting opinion.
8. Update the consolidated response as a new candidate version, retaining traceability to the underlying inputs and disposition.
9. Determine whether the change triggers independent review or re-review under DD-04.
10. Do not mark Ready for Issue while a material conflict or required disposition remains open.

### 9.5 Dissent, override and escalation safeguards

- No silent overwrite: a consolidated response may summarize a discipline contribution but must retain a traceable link to the source and any material qualification.
- No implied concurrence: non-response, missed target date, read receipt or assignment completion is not agreement.
- No majority rule: the number of disciplines supporting a position does not itself establish technical authority.
- No unilateral override outside delegation: the technical lead may not replace another discipline's conclusion unless expressly authorized to decide that subject.
- Preserve dissent: if an authorized authority selects a direction despite a recorded contrary position, preserve the dissent and the decision rationale in the official record.
- Escalation is not a grant: escalating a conflict does not automatically give the recipient decision authority; the recipient must have a valid appointment/delegation.
- Reopening the same issue or receiving new evidence must create a traceable follow-up/disposition event; do not rewrite the historical decision.

### 9.6 Open DD-03 decisions

1. Which project role/authority appoints the technical lead and discipline responders, and how are acting appointments/revocation handled?
2. Which discipline combinations require named discipline leads or secondary validation?
3. What technical subjects and thresholds may be delegated to a technical lead?
4. Who is the designated higher-level conflict-resolution authority for each project/contract/discipline interface?
5. Which conflict classes are always blocking, and what constitutes a material conflict?
6. What is the escalation path and expected response mechanism where the project authority is external?
7. What mandatory interface checklist and contribution fields apply to each discipline?
8. Which decisions require owner/client/designer/engineer-of-record concurrence under the project's approved authority matrix?
9. How are dissenting opinions represented in the formal response and Transmittal package?
10. Which conflict disposition changes require a fresh independent review?

These questions are not answered by assigning generic labels such as Project Manager, Technical Manager or Lead Engineer. Actual authority must be established from the approved project appointment and delegation records.

## 10. Independent review, risk triggers and separation of duties (RFI-DD-04)

### 10.1 Purpose and boundary

Independent review is a controlled technical assurance gate applied where the approved project risk/authority matrix requires it. It is not a universal second signature by default, a substitute for discipline responsibility, or a transfer of issue authority. DEC-105 establishes the independent-review principle and DEC-110 requires negative authorization and separation-of-duties verification; the exact trigger matrix and quantitative thresholds remain open.

### 10.2 Candidate review trigger dimensions

The following dimensions are recommended for the project authority to assess. They are not automatic thresholds or a self-executing scoring formula.

| Risk dimension | Potential trigger evidence | Review consideration |
|---|---|---|
| Safety / life-safety | Potential impact on life safety, structural integrity, fire/life-safety systems, hazardous operations or public safety | Independent review likely mandatory under project risk matrix |
| Regulatory / authority compliance | Departure from approved code, permit, authority condition or statutory requirement | Review by appropriately qualified and appointed authority |
| Design basis / specification deviation | Proposed departure from approved design basis, specification, drawing or acceptance criterion | Independent technical review according to materiality and authority |
| Multi-discipline interface | Conflicting or interdependent structural, architectural, civil, mechanical, electrical or specialist-system decisions | Review by competent independent discipline/interface reviewer |
| Permanent works / structural consequence | Change to permanent works, load path, foundation, structural capacity, stability or durability | Review based on consequence and approved engineering authority |
| High uncertainty / novel solution | Unverified assumptions, first-of-kind solution, limited precedent or material uncertainty | Risk-based independent challenge |
| Significant cost / schedule / scope consequence | Material change to approved scope, cost baseline, construction sequence or critical path | Review by relevant technical/project authority; not necessarily technical independent review in every case |
| Quality / compliance concession | Proposed concession, nonconformance disposition or acceptance deviation linked to the RFI | Review under the governing quality/technical authority matrix |
| External interface / third-party dependency | Utility, authority, adjacent asset, specialist vendor or third-party design interface | Review by the appointed interface/discipline authority |
| Conflict or dissent | Material unresolved disagreement or an authorized decision contrary to a discipline recommendation | Independent review or higher-level technical disposition as defined by authority |
| Reopened / materially revised answer | New evidence, changed assumptions or material change after prior review/issue | Reassess whether previous review remains valid; changed candidate requires review if trigger applies |

### 10.3 Candidate trigger decision process

1. At intake/technical scoping, the appointed technical authority records the RFI's relevant risk dimensions and required discipline scope.
2. The risk/authority matrix determines whether independent review is Mandatory, Not Required, or Pending Authority Decision. Do not use an unapproved numeric score or developer default.
3. The review requirement is attached to the exact response scope and candidate version. A scope or content change triggers reassessment.
4. If the trigger matrix is missing, ambiguous or inapplicable, mark the review decision **Pending Authority Decision** and block Ready for Issue for the affected response; do not silently treat it as Not Required.
5. The designated reviewer must have an active appointment, relevant competence, permitted project/party/discipline scope and no disqualifying conflict.
6. Review outcome is recorded against the exact frozen candidate and evidence manifest.
7. A material change after review creates a new candidate version and requires reassessment; prior review remains historical evidence only.
8. Review completion is not formal issue, acceptance by the originator, delivery, acknowledgement or technical closure.

### 10.4 Independence and conflict checks

At minimum, assess these relationships for the exact response version:

- author of the response or discipline contribution;
- technical lead who consolidated or materially determined the response;
- person who resolved the material conflict;
- reviewer appointed for independent review;
- technical issuer;
- coordinator / Document Control participant;
- any prior review, design approval or related decision that could create a self-review or conflict.

**Recommended rule:** a person who authored the response, materially consolidated it, or made the substantive technical decision under review must not independently review that same response version where independent review is mandatory. A reviewer must not approve their own prior technical decision by changing role or appointment after the fact. Any permissible exception must be expressly defined by the owner-approved authority matrix with compensating controls; no exception is assumed here.

### 10.5 Review outcomes and change control

Candidate outcome vocabulary:

- **Reviewed — No Blocking Comment:** review gate passed for the exact frozen candidate.
- **Changes Required:** response is returned for revision; gate remains open.
- **Clarification Required:** reviewer needs defined information before reaching a conclusion; gate remains open.
- **Conflict Escalated:** reviewer identifies a material conflict outside current authority; gate remains open.
- **Not Applicable / Not Required:** may be recorded only when the approved trigger matrix supports it and the authorized assessor records the basis.
- **Pending Authority Decision:** trigger, reviewer competence or authority is unresolved; issue gate remains blocked.

These are proposed labels, not final system enums. A reviewer comment is not itself an issued engineering response. The technical lead must address comments, preserve the review record and create a new candidate where content changes. The reviewer's acceptance must not be silently carried forward to a changed version.

### 10.6 Candidate reviewer appointment and substitution

- Reviewer appointment is specific to project, RFI class, discipline/risk scope, candidate version or review task, and effective period.
- Reviewer competence and independence must be evidenced through the approved appointment mechanism.
- Substitution requires a recorded reason, effective time and reassessment of independence; it does not erase prior review events.
- Expired, revoked, out-of-scope or conflicted reviewers must fail closed.
- The coordinator may arrange logistics only if delegated; they cannot select a reviewer based on convenience where selection authority belongs to a technical/quality authority.
- A reviewer cannot delegate the review outcome unless the appointment explicitly permits it and the substitute independently meets all conditions.

### 10.7 Open DD-04 decisions

1. Which risk dimensions are mandatory triggers for each project type and RFI class?
2. Which quantitative thresholds, if any, apply to cost, schedule, safety, technical consequence or design deviation?
3. Who owns and approves the project risk/authority matrix, and how is its version pinned to an RFI?
4. Who may classify a review as Mandatory, Not Required or Pending Authority Decision?
5. Which professional qualifications, discipline experience and project familiarity are required for each reviewer class?
6. Which relationships constitute a disqualifying conflict beyond authorship and technical decision-making?
7. Are there narrowly defined exceptions where reviewer/issuer or technical-lead/reviewer combinations may be permitted, and what compensating controls apply?
8. How many review stages or reviewers are required for each risk class, and who resolves reviewer disagreement?
9. What is the review SLA/target policy, if any, and which authority approves it? No default SLA is assumed.
10. Which changes to assumptions, evidence, scope, response text or linked documents require full re-review versus targeted review?
11. How are reviewer comments and outcomes preserved and distributed under confidentiality rules?
12. What evidence demonstrates reviewer competence, appointment validity and independence without exposing unnecessary personal information?

### 10.8 Required negative and boundary tests

Under DEC-110, the eventual test plan must include at least:

- technical lead attempts to remove or overwrite a discipline dissent without an authorized disposition;
- coordinator attempts to resolve a technical conflict or appoint a reviewer outside delegation;
- a discipline responder submits outside the assigned discipline/RFI scope;
- a non-appointed person attempts to resolve a material conflict;
- technical lead attempts to issue without a separate issuer appointment;
- response author attempts independent review of the same response version;
- reviewer attempts to issue or close the RFI;
- expired/revoked reviewer attempts review completion;
- reviewer appointment is changed after work begins;
- response content changes after review but the old review result is reused;
- review trigger is missing/ambiguous but the workflow attempts to proceed as if review were not required;
- a conflict remains unresolved while the RFI attempts to enter Ready for Issue;
- a conflict decision is recorded without preserving the original discipline contributions and dissent;
- notification/read/acknowledgement is misused as a substitute for review completion.

Unauthorized action, silent evidence alteration or bypass of a mandatory review gate is a release-blocking failure under the DEC-110 acceptance framework.

## 11. Consolidated open decision register for DD-03 and DD-04

| ID | Open decision | Required authority | Interim handling |
|---|---|---|---|
| DD03-01 | Technical lead/discipline appointment authority and effective period | Owner / project technical authority | No appointment inferred |
| DD03-02 | Technical lead delegation boundaries by subject and discipline | Owner / technical authority | Lead cannot decide beyond explicit scope |
| DD03-03 | Conflict classes and materiality thresholds | Owner / discipline authorities | Material unresolved conflict blocks issue |
| DD03-04 | Higher-level conflict-resolution authority and external escalation | Owner / project/contract authority | Escalate; do not assume coordinator authority |
| DD03-05 | Discipline contribution and interface completeness checklist | Discipline authorities / technical lead | Missing/ambiguous input is not concurrence |
| DD03-06 | Dissent representation in formal response | Owner / technical authority / records | Preserve source position and rationale |
| DD04-01 | Risk/authority matrix owner, approval and versioning | Owner / quality and technical authority | Missing matrix means review decision pending |
| DD04-02 | Mandatory trigger dimensions and thresholds | Owner / technical/quality authority | No numeric threshold inferred |
| DD04-03 | Reviewer competence and appointment requirements | Owner / discipline and quality authorities | No reviewer authority inferred from title |
| DD04-04 | Conflict-of-interest and prohibited role combinations | Owner / security/quality authority | Apply conservative deny where independence is required |
| DD04-05 | Reviewer stages, disagreement resolution and substitutions | Owner / technical/quality authority | No assumed multi-stage approval |
| DD04-06 | Re-review materiality criteria | Owner / technical/quality authority | Material changes require reassessment; uncertain cases remain blocked |

## 12. Acceptance and promotion checklist for DD-03/DD-04

- [ ] Technical lead and discipline appointments have named authorities, scope, effective period, delegation and revocation.
- [ ] Discipline contributions remain separately attributable and immutable.
- [ ] Conflict taxonomy, blocking criteria, escalation path and authorized disposition are complete.
- [ ] No majority vote, silence, coordinator action or role title substitutes for technical authority.
- [ ] Dissent and the rationale for any authorized override remain visible in the controlled record.
- [ ] Risk/authority matrix is approved, versioned and applicable to project/RFI classes.
- [ ] Review triggers and thresholds are explicit; unknown/ambiguous cases cannot default to no review.
- [ ] Reviewer competence, appointment, independence and conflict checks are defined.
- [ ] Review outcome is bound to the exact response version and evidence manifest.
- [ ] Changes after review trigger a documented materiality/re-review decision.
- [ ] Negative authorization and boundary tests are traced to DEC-110 with retained evidence.
- [ ] Crosswalk remains consistent with DEC-104–DEC-110 and applicable project decisions.

**No promotion is permitted while a blocking item remains unresolved.** Any proposed exception to approved policy returns for explicit owner decision.

## 5. Crosswalk to approved decisions

| Topic | Controlling decision | What is fixed | What remains open |
|---|---|---|---|
| Operating authority and multidisciplinary responsibility | DEC-104/105 | Enabled originators, admin-only coordinator, multidisciplinary contributions, technical lead, independent review principle, authorized issuer | Exact capability IDs, grant/revoke owners, appointments, combinations, technical tie-break and review triggers |
| Lifecycle controls | DEC-104/106 | Clarification vs new inquiry, withdrawal request/validation, administrative cancellation, reopening, atomic issue/closure preference, informational requested dates | Final state vocabulary, complete transition guards, eligible states, parent/subordinate aggregation and examples |
| Numbering and evidence | DEC-107 | Allocation on first successful formal submission, non-reuse, identity separation, immutable manifests/versions, per-file authorization | Display format, legacy reconciliation, file security mechanisms, retention |
| Monitoring/records | DEC-109 | Metric dimensions, source lineage, authorization, archive separation, no automatic deletion/retention assumptions | Exact report/event catalogues, retention schedule, legal-hold authority |
| Verification | DEC-110 | Required test domains, traceability, negative gates, concurrency/idempotency and non-production rehearsal principles | Test ownership, thresholds, severity taxonomy, waiver authority and detailed cases |

## 6. Open decisions and issues requiring explicit disposition

1. **Final state labels:** confirm the candidate vocabulary or replace it; labels must not be treated as approved simply because the transition principles are approved.
2. **Returned for Completion:** define exactly which post-submission deficiencies justify this state, who may return, and when resubmission is administrative completion versus a controlled revision under DEC-022-B.
3. **Consolidation timing:** confirm that the parent enters Under Consolidation only after all required contributions are complete or an authorized scope change removes an assignment; partial parallel drafting, if allowed, should be subordinate activity.
4. **Clarification resumption:** confirm parent-stage behavior where multiple blocking clarification requests exist.
5. **Cancellation eligibility:** specify which states permit administrative cancellation and the designated records/workflow authority.
6. **Withdrawal cutoff:** confirm the pre-issue cutoff and technical-lead concurrence requirement after substantive work begins.
7. **Reopening target:** define whether reopening always resumes in Technical Assessment or can return to another controlled stage based on affected scope.
8. **Capability IDs and grant authority:** define atomic capabilities, who approves/grants/revokes them and how project/party/discipline scope is represented.
9. **Appointments:** define who appoints coordinator, technical lead, discipline responders, reviewer and issuer, and the effective/revocation rules.
10. **Role combinations:** decide which combinations are permitted by project/RFI class while preserving mandatory separation of duties.
11. **Emergency/delegated authority:** define whether temporary acting appointments or break-glass access are permitted; none is assumed.
12. **Audit and denial retention:** define applicable records policy without inventing a retention duration.

## 7. Required review and acceptance evidence

Before this specification is promoted to authoritative governance:

- each candidate state has a precise definition, entry/exit guard, authorized actor/capability, event record and prohibited inference;
- every transition is tested for positive, negative, stale-version, concurrency and failure cases;
- each action has an explicit capability and scope; all unapproved role combinations fail closed;
- PM oversight, coordinator limits, issuer boundaries and cross-party confidentiality are tested through direct service/API paths;
- reopening, withdrawal and cancellation preserve prior response/closure/assignment/review/recipient history;
- every review is bound to the exact response candidate/version and material changes require re-review;
- the test catalogue traces every approved requirement to expected outcomes and evidence under DEC-110.

No tests are claimed to have been executed by this document.

## 8. Next work items

1. Owner/authority review of the candidate state vocabulary and transition questions in §6.
2. Complete the capability IDs, grant/revoke authority and appointment matrix with security review.
3. DD-03 and DD-04 candidate specifications are now drafted in §§9–12; review and resolve their open decision register before governance promotion.
4. Only after those specifications stabilize, proceed to materiality, numbering/legacy, concurrency and evidence details.

**Boundary:** This document is a working design proposal only. It does not amend DEC-104–DEC-110, activate any capability, appoint project personnel, implement a state machine, change UI/API/code, DB/Storage/auth/RLS/grants, run live tests, operate on production data, merge or deploy. A separate detailed review, security/records impact assessment, implementation/test plan and explicit owner authorization remain mandatory.
