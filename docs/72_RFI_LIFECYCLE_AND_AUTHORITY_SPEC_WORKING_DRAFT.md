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
3. Resolve DD-03 and DD-04 using the approved responsibility boundaries in DEC-105.
4. Only after those specifications stabilize, proceed to materiality, numbering/legacy, concurrency and evidence details.

**Boundary:** This document is a working design proposal only. It does not amend DEC-104–DEC-110, activate any capability, appoint project personnel, implement a state machine, change UI/API/code, DB/Storage/auth/RLS/grants, run live tests, operate on production data, merge or deploy. A separate detailed review, security/records impact assessment, implementation/test plan and explicit owner authorization remain mandatory.
