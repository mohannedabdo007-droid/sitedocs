# OR-01 SV-01 — Canonical RFI Lifecycle and Record Dictionary

**Document type:** Controlled conceptual glossary and semantic ownership proposal  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — CANONICAL CANDIDATE VOCABULARY — OWNER-CONSTRAINT ALIGNED — SPECIALIST VALIDATION PENDING — NOT A FINAL STATE ENUM OR IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Primary source:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`  
**Transition crosswalk:** `docs/106_OR01_SV01_PARENT_TRANSITION_AND_AUTHORITY_CROSSWALK_WORKING_DRAFT.md`  
**Desk validation:** `docs/107_OR01_SV01_TRANSITION_CROSSWALK_DESK_VALIDATION_WORKING_DRAFT.md`  
**Specialist evidence matrix:** `docs/104_OR01_SPECIALIST_VALIDATION_AND_EVIDENCE_MATRIX_WORKING_DRAFT.md`  
**Relevant owner dispositions:** DISP-OR01-001 and DISP-OR01-003 through DISP-OR01-014, each only within its conditionally approved scope; DISP-OR01-002 remains consistency-only.

> This dictionary proposes canonical meanings and record ownership to prevent semantic collisions across design documents. It does not finalize lifecycle labels, create schema/API enums, approve a state machine, appoint authorities, or authorize implementation. “Canonical” in this document means the controlled candidate term to use during review unless a competent authority changes it; it does not mean finally approved.

## 1. Purpose and governing semantic rules

The dictionary establishes a single conceptual vocabulary for:
1. the official parent RFI lifecycle;
2. response cycles belonging to one official RFI;
3. subordinate records with their own state;
4. immutable events and decisions;
5. pre-submission draft-record conditions;
6. monitoring, communication and records indicators.

The following rules are mandatory for any downstream design that uses this dictionary:

- **One parent, one current parent stage:** one official RFI identity has one authoritative current parent lifecycle stage. A response cycle has its own identity and history; cycle state/outcome must not be casually substituted for parent stage.
- **No child-driven parent mutation:** a subordinate state or event may satisfy or block a parent transition only through an expressly defined, authorized gate. It cannot autonomously change the parent stage.
- **Events are not states:** an event records that something happened. It does not become a persistent lifecycle state unless an explicit state model says so.
- **Indicators are not states:** overdue, unread, delivery failure, acknowledgement pending, workload, archive and report values are projections/metrics, not parent lifecycle states.
- **Drafts are not official RFIs:** Draft and Abandoned Draft are pre-submission draft-record conditions outside the official parent lifecycle and consume no official number.
- **Technical closure is not communication completion:** successful formal issue and technical closure are an indivisible business outcome under DISP-OR01-010. Transmittal dispatch, delivery, access, acknowledgement and substantive response remain separate.
- **No inferred authority:** a term naming a function does not prove that a person is appointed, delegated or authorized.
- **No default operational semantics:** no SLA, due-date rule, timeout, notification cadence, escalation, retention period, legal effect or deemed acceptance is created here.

## 2. Semantic type taxonomy

| Type code | Semantic type | Meaning | Owns current status? | Can change parent stage? |
|---|---|---|---|---|
| PARENT_STAGE | Official parent lifecycle stage | Current controlled stage of the official RFI identity | Yes — parent RFI record | Only through authorized parent transition |
| DRAFT_CONDITION | Pre-submission draft condition | State/condition of an unsubmitted draft record | Draft record only | No |
| CYCLE_STAGE | Response-cycle stage | Stage of a distinct response cycle under one RFI | Response-cycle record | Only through explicit governed parent/cycle transition rules; mapping remains open |
| CYCLE_OUTCOME | Response-cycle terminal/business outcome | Outcome of a specific cycle, preserving its history | Response-cycle record | No autonomous parent mutation |
| CHILD_STATE | State of an independently identified subordinate record | Assignment, contribution, clarification, candidate, review or readiness record state | Its own child record | Only as an explicit gate input |
| DECISION | Attributable authorized decision | A decision with actor, authority, scope, reason and evidence | Decision record/history | Only where its governing rule authorizes a parent transition |
| EVENT | Immutable occurrence/history item | Submission, assignment, response, issue, dispatch, delivery, access, acknowledgement, notification or archive event | Event history | No, unless an explicit authorized transition is separately committed |
| INDICATOR | Derived monitoring/reporting value | Workload, aging, overdue, delivery/acknowledgement or archive/report projection | Reporting/monitoring projection | No |
| RECORDS_CONTROL | Records governance condition/action | Archive, retention review, legal hold, disposition review or controlled deletion process | Records-control record | No technical parent-stage mutation |

## 3. Official parent RFI lifecycle — candidate dictionary

The following candidate labels derive from docs/72 §3.2 and are reconciled with DISP-OR01-001, DISP-OR01-005, DISP-OR01-006, DISP-OR01-010, DISP-OR01-011, DISP-OR01-012 and DISP-OR01-014. They remain provisional pending specialist validation and owner approval of the exact detailed-design version.

| Canonical candidate term | Semantic type | Owning record | Controlled meaning | Entry/exit boundary | Governing source / status |
|---|---|---|---|---|---|
| Submitted | PARENT_STAGE | Official parent RFI | Formal submission succeeded and the official RFI identity/number was allocated | Enter only after required fields, authorization, scope, evidence snapshot and atomic first-success numbering succeed | DEC-107; docs/72; DISP-OR01-001 boundary — candidate label |
| Under Coordination | PARENT_STAGE | Official parent RFI | Administrative intake, completeness, routing and required-assignment setup are being coordinated | Technical hand-off only after the two-key and complete-required-assignment gate is satisfied | DEC-105; DISP-OR01-004 — candidate label |
| Returned for Completion | PARENT_STAGE | Official parent RFI | A permitted administrative/information deficiency after successful submission has been returned for originator completion; not a technical rejection | Ordinary route is pre-technical. Late material administrative defect after technical work starts follows a separate correction route, not a silent reset | DISP-OR01-003 Option C; docs/91 — candidate label and eligibility subject to specialist review |
| In Technical Assessment | PARENT_STAGE | Official parent RFI | Required discipline contributions and technical assessment are in progress | Parent enters after valid technical hand-off; remains until required-contribution and blocker gates allow consolidation or another authorized route applies | DISP-OR01-004/006/007 — candidate label |
| Awaiting Originator Clarification | PARENT_STAGE | Official parent RFI | At least one valid authorized parent-progression clarification blocker prevents the next parent technical action | Enter only where reasoned dependency and affected parent scope are recorded; remain while any valid parent blocker is open; resume exact prior stage only after all parent blockers resolve and current guards pass | DISP-OR01-005/014 — candidate label; exact source-stage eligibility remains open |
| Under Consolidation | PARENT_STAGE | Official parent RFI | Appointed technical lead is consolidating complete required technical contributions into a response candidate | Parent entry requires every required contribution complete and technically confirmed, or valid authorized scope change removes it; limited provisional preparation before this gate is subordinate only | DISP-OR01-006/007 — candidate label |
| Under Independent Review | PARENT_STAGE | Official parent RFI | Exact frozen response candidate/package is undergoing mandatory independent review | Only where approved/versioned risk-authority matrix requires review and valid reviewer/package/version evidence exists | DISP-OR01-008/009 — candidate label; risk matrix prerequisite unresolved |
| Ready for Issue | PARENT_STAGE | Official parent RFI | All required technical, blocker, conflict, review and exact-package readiness conditions are confirmed for one exact candidate | Readiness confirmation is distinct from formal issue; final issue-time revalidation remains mandatory | DISP-OR01-009/010 — candidate label |
| Closed | PARENT_STAGE | Official parent RFI | The authorized formal response was issued and technical closure committed as one indivisible successful business outcome for the active cycle | Enter only on successful authorized atomic issue/closure commit; failed or partial attempts cannot produce successful Closed status | DISP-OR01-010/014 — candidate label |
| Withdrawn | PARENT_STAGE | Official parent RFI | The whole eligible pre-issue parent RFI was withdrawn through the authorized route | Request alone does not change state; only before successful formal issue; preserve number and history | DISP-OR01-011 — candidate terminal outcome label |
| Cancelled | PARENT_STAGE | Official parent RFI | The eligible pre-issue parent RFI was administratively cancelled on the narrowly approved grounds | Current baseline grounds are proven duplicate official registration or objectively invalid registration; no post-issue cancellation | DISP-OR01-012 — candidate terminal outcome label |

### 3.1 Deliberate exclusions from parent-stage vocabulary

These terms must not be represented as parent RFI stages:

| Term / concept | Semantic type | Owning record/projection | Why excluded from parent lifecycle |
|---|---|---|---|
| Draft | DRAFT_CONDITION | Originating-party draft record | Not formally submitted; no official RFI identity |
| Abandoned Draft | DRAFT_CONDITION | Originating-party draft record | Pre-submission draft disposition, not official withdrawal |
| Issued / Formal Issue | EVENT + DECISION | Issue decision/event and exact response package | Issue is the authorized event/outcome that commits with technical closure; do not create an ambiguous parallel stage |
| Technical Closure | EVENT + CYCLE_OUTCOME | Closure record/event linked to issue and response cycle | Distinct evidence identity but same indivisible successful business outcome as formal issue |
| Reopened | EVENT / CYCLE_STAGE creation | Reopening decision and new response-cycle record | Reopening creates a distinct new response cycle; it is not a parent stage label by itself |
| Overdue / Aging | INDICATOR | Monitoring/report projection | Time-derived monitoring value, not lifecycle |
| Partially Delivered / Failed Delivery | EVENT / INDICATOR | Transmittal recipient delivery record | Communication outcome under DEC-103, not technical lifecycle |
| Acknowledgement Pending / Complete | EVENT / INDICATOR | Recipient acknowledgement record/aggregate | Communication evidence under DEC-103/108, not technical approval or closure |
| Viewed / Unread / Accessed | EVENT / INDICATOR | Access event and permission-safe projection | Access is not acceptance or technical disposition |
| Escalated | EVENT / INDICATOR | Escalation event/work item | Does not itself alter parent authority or stage |
| Awaiting Transmittal | CHILD_STATE / INDICATOR (if separately adopted) | Distribution work item | External distribution follows formal issue; not parent technical lifecycle |
| Workload Queue | INDICATOR | Workload projection | Operational workload classification only |
| Archived | RECORDS_CONTROL | Records/archive control record | Archive is separate from lifecycle and does not imply closure or deletion |
| Legal Hold | RECORDS_CONTROL | Hold record | Records restriction; no parent technical-stage mutation |

## 4. Response-cycle dictionary

A response cycle is a separately identified technical-response attempt/history for the same official RFI question. The exact parent-current-stage projection while a prior cycle remains closed and a new cycle is active is still open under G-01.

| Canonical candidate term | Semantic type | Owning record | Meaning | Boundary / unresolved point |
|---|---|---|---|---|
| Response Cycle | CYCLE_STAGE container | Response-cycle record | Distinct cycle identity linked to one official RFI identity and, after reopening, to its predecessor cycle | Cycle identity/sequence format and parent-stage projection require specialist validation |
| Active Cycle | CYCLE_STAGE descriptor | Parent-to-cycle relationship | Cycle currently subject to authorized technical work | Exact rules for one active cycle, transition overlap and concurrent reopening require architecture validation |
| Closed Prior Cycle | CYCLE_OUTCOME | Historical response-cycle record | Earlier cycle whose formal response and technical closure remain immutable | Reopening cannot edit or reverse it |
| Reopening Decision | DECISION + EVENT | Reopening decision record | Authorized post-issue decision that a new cycle is required for the same question | Referral alone is not reopening; exact grounds and authority evidence remain subject to specialist validation |
| New Response Cycle Created | EVENT | Cycle creation event | One logical new cycle created idempotently from an authorized reopening decision | Must preserve predecessor link; duplicate/concurrent creation prevented |
| Cycle Starting-Stage Assessment | DECISION | New cycle assessment record | Governed selection of the new cycle's starting stage based on current scope, authority, assignment, blocker and evidence prerequisites | No universal automatic return to In Technical Assessment; decision matrix remains open |
| Cycle Response Candidate | CHILD_STATE / CYCLE_STAGE | Response candidate record | Candidate technical response belonging to one exact cycle and version lineage | Must not inherit prior cycle's review/readiness clearance without explicit revalidation |

**G-01 remains open:** the dictionary intentionally does not decide whether the official parent stage is projected from the active cycle, whether a distinct parent-level “Reopened” stage is ever permissible, or how simultaneous cycle history appears in reporting. No new parent-stage label is approved by this document.

## 5. Subordinate-record dictionary

Each subordinate record has its own stable identity, status and event history. The candidate labels below are descriptive only and must be validated by the responsible domain specialists.

| Record family | Owning record | Candidate states / controlled concepts | Parent effect permitted only through |
|---|---|---|---|
| Discipline assignment | Assignment record | Assigned; Accepted; In Progress; Clarification Requested; Contribution Submitted; Changes Requested; Completed; Reassigned; Cancelled | Valid required-assignment gate for technical hand-off; authorized scope/assignment change |
| Discipline contribution | Contribution record | Draft; Submitted; Under Review/Assessment; Changes Requested; Complete/Technically Confirmed; Superseded; Withdrawn (if separately approved) | Required-contribution gate for consolidation/readiness; scoped blocker where expressly authorized |
| Clarification request | Clarification record | Open; Response Received; Under Sufficiency Assessment; Resolved; Withdrawn/Superseded (if authorized) | Explicit parent-progression blocker or contribution-only blocker; receipt alone never resolves |
| Clarification response | Response record/version | Submitted; Partially Responsive; Awaiting Technical Sufficiency Decision; Sufficient/Accepted for request purpose; Insufficient/Follow-up Required | Authorized technical sufficiency decision against exact request and affected scope |
| Response candidate | Candidate/version record | Drafting; Provisional Preparation; Submitted for Review; Changes Required; Review Passed; Readiness Confirmed; Issued; Superseded | Exact-version review/readiness/issue gates; child state alone does not advance parent |
| Independent review | Review record | Not Required (matrix-determined); Pending; In Progress; Blocking Findings; Conditionally Cleared (only if matrix permits); Cleared; Superseded/Invalidated | Approved/versioned risk matrix, reviewer appointment, exact package/version and outcome |
| Readiness confirmation | Readiness record | Pending; Confirmed; Invalidated/Superseded | Exact candidate/package readiness gate; never formal issue by itself |
| Transmittal | Transmittal record | Draft/Prepared; Frozen; Dispatching; Dispatched; Partially Delivered; Failed (candidate terms subject to DEC-103 and detailed design) | Communication workflow only; no parent technical-stage mutation |
| Transmittal recipient | Recipient delivery/ack record | Not Requested; Required; Optional; Pending; Delivered; Failed; Acknowledged; Substantive Response Received (distinct event classes) | Recipient-level aggregation under DEC-103/108; no technical approval or closure |
| Notification | Notification record | Queued; Sent; Failed; Retried; Suppressed (candidate terms) | Notification event only; never a lifecycle gate unless a separate approved rule expressly says so |
| Report/export | Report/export record | Requested; Generated; Failed; Expired/Revoked (candidate terms) | Permission-safe reporting/export authorization; no parent-stage mutation |
| Records control | Archive/retention/hold/disposition record | Candidate states to be separately specified by records authority | Records policy only; no technical parent-stage mutation |

**Important:** The candidate subordinate labels are not a complete child-state machine. In particular, this document does not approve a universal “Accepted”, “Completed”, “Resolved” or “Cleared” definition across different record families. Each term must be qualified by its owning record and decision purpose.

## 6. Event dictionary — immutable occurrence, not persistent stage

| Canonical event term | Event owner | Minimum semantic meaning | Parent lifecycle effect |
|---|---|---|---|
| Draft Created | Draft record | An authorized unsubmitted draft record was created | None |
| Draft Abandoned | Draft record | Draft owner recorded abandonment before formal submission | None |
| RFI Formally Submitted | Parent RFI | First successful formal submission and official identity allocation | Creates official parent in Submitted |
| Intake Accepted | Parent RFI / intake event | Authorized coordinator accepted administrative intake | May support Submitted → Under Coordination |
| Returned for Completion | Parent RFI decision/event | Permitted pre-technical administrative return with reason and affected scope | Changes parent only through authorized transition |
| Originator Resubmitted | Parent RFI submission/version event | Attributable response to return, preserving prior versions | May support return-to-coordination route |
| Technical Hand-off Authorized | Assignment/authority decision event | Technical scope, lead and required assignments established by authorized technical function | May support Under Coordination → In Technical Assessment after administrative key |
| Parent Clarification Blocker Opened | Clarification + parent event | Authorized reasoned dependency blocks parent progression for recorded scope | May place parent in Awaiting Originator Clarification |
| Contribution Clarification Blocker Opened | Clarification child event | Affected contribution is blocked without blocking parent progression | No parent-stage change by itself |
| Clarification Response Received | Clarification response event | Originator response/version received | No automatic blocker resolution |
| Clarification Sufficiency Confirmed | Technical decision event | Authorized technical actor confirms sufficiency for exact request/scope | May resolve that blocker; parent resumes only if all parent blockers resolve and guards pass |
| Required Contribution Confirmed | Contribution decision/event | Required contribution is technically complete for the specified scope/version | May satisfy a parent gate; does not autonomously move parent |
| Scope/Assignment Change Authorized | Decision + event | Authorized change to required scope/assignments with evidence | May alter future gate denominator only under approved rules |
| Provisional Candidate Prepared | Candidate event | Subordinate provisional response preparation exists | Parent remains In Technical Assessment |
| Consolidation Entered | Parent transition event | Parent entered Under Consolidation after required-contribution gate | Changes parent only via authorized transition |
| Scoped Return Authorized | Technical decision/event | Bounded technical work returned under appointed authority | May change parent/affected child states according to approved route |
| Independent Review Trigger Assessed | Review decision/event | Applicable approved risk/authority matrix evaluated for exact scope | No stage change unless review route is required and authorized |
| Review Started / Finding Recorded | Review event | Review activity or attributable outcome for exact candidate/version | Gate input only |
| Readiness Confirmed | Readiness decision/event | Authorized readiness function confirms exact candidate/package | May support Ready for Issue; not issue |
| Formal Issue Committed | Issue decision/event | Authorized issuer successfully commits exact response version | Atomic with technical closure; parent becomes Closed under approved model |
| Technical Closure Committed | Closure decision/event | Distinct closure evidence committed with formal issue in same indivisible outcome | Same atomic outcome; no separate partial success |
| Withdrawal Requested | Parent referral/request event | Authorized originator/delegate asks for pre-issue withdrawal | No parent change until authorized decision |
| Withdrawal Authorized | Parent decision/event | Appointed records/workflow authority authorizes eligible whole-parent withdrawal | Parent becomes Withdrawn through authorized commit |
| Cancellation Referred | Parent referral event | Participant refers a possible duplicate/invalid registration | No parent change |
| Cancellation Authorized | Parent decision/event | Appointed records/workflow authority authorizes cancellation on approved grounds | Parent becomes Cancelled through authorized commit |
| Reopening Authorized | Reopening decision/event | Appointed technical authority authorizes a new cycle for the same question | Creates a new cycle; parent projection remains G-01 open |
| Administrative Correction Recorded | Correction event | Separately authorized late administrative correction is recorded with technical-impact assessment | No silent parent reset; exact parent effect remains G-03 open |
| Transmittal Frozen / Dispatched | Transmittal event | Exact package/recipient set frozen or dispatched | None |
| Recipient Delivery Attempt / Delivered / Failed | Recipient event | Technical delivery outcome for one recipient/attempt | None |
| Recipient Accessed | Access event | Authorized recipient accessed an item/package | None |
| Acknowledgement Recorded | Recipient acknowledgement event | Explicit acknowledgement under Required/Optional/Not Requested rule | None |
| Substantive Response Recorded | Recipient response event | Recipient supplied substantive response category | None |
| Notification Sent / Failed | Notification event | Notification delivery attempt/result | None |
| Report Generated / Exported | Report/export event | Authorized report/export snapshot generated | None |
| Archive / Hold / Retention Review / Disposition Decision | Records-control event | Records governance action recorded under separate authority | None |

## 7. Indicator and reporting dictionary

| Indicator family | Example candidate measure | Counting unit must be | Must not be interpreted as |
|---|---|---|---|
| Lifecycle distribution | Count by current parent stage | Distinct official parent RFI identity, as-of timestamp | Number of child records or response cycles |
| Active response cycles | Count of active cycles | Distinct response-cycle identity, with explicit parent link | Number of official RFIs |
| Cycle history | Reopened/closed cycle count | Distinct cycle identity/event | Parent RFI count unless explicitly deduplicated |
| Assignment workload | Assigned/in-progress workload | Distinct assignment identity | Parent RFI count |
| Contribution completion | Required completed contributions | Distinct required contribution identity/version and scope | Count of submissions or attachments |
| Clarification aging | Open clarification age | Distinct clarification request identity | Parent RFI aging unless separately defined |
| Parent clarification hold | Parents held for clarification | Distinct parent RFI identity with at least one valid open parent blocker | Count of all open clarification requests |
| Review workload | Pending/in-progress reviews | Distinct review record and exact candidate version | Parent RFI count |
| Readiness workload | Pending/confirmed readiness records | Distinct readiness record/version | Formal issue count |
| Issue throughput | Successfully issued responses | Distinct successful issue decision/response cycle | Transmittal dispatch or recipient delivery count |
| Recipient delivery | Delivered/failed recipients | Distinct recipient × Transmittal × attempt/event as defined | Parent RFI count or technical acceptance |
| Acknowledgement completeness | Required acknowledgements received | Required recipient denominator for exact Transmittal | Optional/Not Requested recipients or technical approval |
| Notification performance | Sent/failed notification events | Distinct notification attempt/event | Parent lifecycle stage |
| Archive/retention | Records by archive/hold/review condition | Distinct records-control item and source record | Closed/accepted RFI count |

No metric formula, overdue threshold, aging clock, default SLA, escalation, ranking, dashboard audience, export permission or retention period is approved here. Exact metric keys, as-of/timezone behavior, deduplication and permission-safe aggregation remain subject to DD-13/DD-14 and specialist review.

## 8. Authority-function terms — function is not appointment

| Canonical function term | What the function may decide/perform within evidenced scope | Must not be inferred from |
|---|---|---|
| Originator / Authorized Party Representative | Submit RFI, provide clarification, request withdrawal within eligible route | Recipient status, contributor status or viewer access |
| Appointing / Project Governance Authority | Establish project-approved appointments/delegations and effective scope | Job title, membership or roster presence |
| Appointed Technical Authority | Determine technical scope/assignments, technical disposition, reopening and issue authority only where separately appointed | Project Manager oversight, coordinator title or assignment acceptance |
| Appointed Assignment Authority | Establish required discipline assignments within explicit delegation | Coordinator role unless separately delegated |
| Appointed Technical Lead | Coordinate/consolidate, evaluate scoped gaps and authorize bounded return within appointment | Seniority or being the most active contributor |
| Appointed Independent Reviewer | Review exact candidate/package within risk trigger, competence and independence scope | Authorship, technical lead or issuer status |
| Appointed Readiness Authority | Confirm readiness for exact candidate within appointment | Checklist completion or review outcome alone |
| Appointed Technical Issuer | Commit formal issue and linked technical closure within exact appointment | Job title, review, coordination or distribution |
| Appointed Records/Workflow Authority | Validate/authorize withdrawal or cancellation within evidenced scope | Document Control membership or coordinator role |
| Coordinator | Perform delegated administrative intake, verification, routing and records tasks | Technical scope, review, readiness, issue or closure authority |
| Document Control / Records Administrator | Control and distribute authorized records; maintain records evidence | Technical decision or issue authority |
| System / Authorization Service | Enforce current server-side authorization, transition, version and transaction guards | UI visibility or a client-side role flag |

## 9. Crosswalk to owner dispositions and open gaps

| Disposition / gap | Dictionary effect | Status |
|---|---|---|
| DISP-OR01-001 | Draft/Abandoned Draft separated from official parent lifecycle; preserve 11 official candidate labels; terminal outcomes distinguished from communication/indicator concepts | Owner conditionally approved; specialist validation pending |
| DISP-OR01-003 | Ordinary pre-technical return separated from late administrative correction route | Owner conditionally approved; G-03 details open |
| DISP-OR01-004 | Authority function and administrative execution are separate keys | Owner conditionally approved; appointment evidence open |
| DISP-OR01-005 | Parent clarification blocker distinguished from contribution-only blocker; exact prior-stage resume rule | Owner conditionally approved; G-02 source-stage mechanics open |
| DISP-OR01-006 | Parent consolidation gate depends on all required contributions; provisional preparation remains subordinate | Owner conditionally approved; completion criteria open |
| DISP-OR01-007 | Scoped technical return preserves unaffected work and version history | Owner conditionally approved; materiality/re-entry details open |
| DISP-OR01-008 | Review is exact-version and matrix-triggered | Owner conditionally approved; approved risk matrix and reviewer evidence open |
| DISP-OR01-009 | Readiness distinct from issue | Owner conditionally approved; readiness authority/package schema open |
| DISP-OR01-010 | Formal issue and technical closure are one indivisible successful business outcome | Owner conditionally approved; architecture/recovery design open |
| DISP-OR01-011 | Withdrawal is pre-issue, whole-parent by default and separately authorized | Owner conditionally approved; eligibility and appointment evidence open |
| DISP-OR01-012 | Cancellation is distinct from withdrawal and limited to approved grounds | Owner conditionally approved; evidence taxonomy/authority open |
| DISP-OR01-013 | Reopening creates a new response cycle and preserves prior closed cycle | Owner conditionally approved; G-01 parent projection open |
| DISP-OR01-014 | Parent, cycle, child, event and indicator identities remain distinct | Owner conditionally approved; G-01/G-05/G-06 specialist validation open |
| G-01 | Parent current-stage projection during a new response cycle is unresolved | Open — do not invent a “Reopened” parent stage |
| G-02 | Exact parent-blocker eligible source stages and aggregation are unresolved | Open — do not infer from any clarification request |
| G-03 | Late administrative correction route details are unresolved | Open — no silent Returned for Completion reset |
| G-04 | Actual appointments/delegations and function-combination evidence are unresolved | Open — function labels do not grant authority |
| G-05 | This dictionary provides a proposed semantic map, not final approval | Open — requires process/technical/architecture/records review |
| G-06 | Complete transition guard/failure/recovery contract remains incomplete | Open — no implementation inference |

## 10. Required specialist review and evidence

Review this dictionary as a controlled exact-version artifact. Each reviewer must identify:
- organization/identity and review capacity (advisory or decision-making);
- competence and appointment/delegation evidence where applicable;
- exact file SHA, sections and terms reviewed;
- accepted terms, proposed amendments, rationale, conditions and dissent;
- affected record ownership and parent-stage impact;
- DEC-103–DEC-110 consistency;
- attributable evidence reference and review date.

Required domains include project/process owner, appointed technical authority/lead, affected discipline authorities, Document Control, architecture/data governance, security/privacy, QA/independent assurance and records/reporting governance as applicable. Their participation is not assumed and no sign-off is claimed.

### 10.1 Specific questions for review

1. Are the 11 official candidate parent labels semantically distinct and complete for the approved owner constraints, without adding a new label?
2. Should Closed remain the sole successful parent terminal stage while issue and closure are recorded as distinct linked evidence in one atomic business outcome?
3. What exact parent-stage projection is required while a reopened response cycle is active (G-01)?
4. Which source parent stages can enter Awaiting Originator Clarification, and how do concurrent blockers restore the prior stage (G-02)?
5. Does every child family have a distinct owning record and status dictionary, with no cross-family reuse of unqualified labels?
6. Which indicator counting units and deduplication keys are authoritative, and how are parent/cycle/child totals presented?
7. Are event names, actor/authority boundaries and immutable evidence requirements adequate for audit, security and records governance?
8. What additional state/event terms are needed, and which proposed terms should be rejected or renamed?

## 11. Change-control and usage rules

- Use these canonical candidate terms in subsequent working drafts only with their semantic type and owning record clear.
- If a term is used with a different meaning, qualify it (for example, “recipient acknowledgement status” rather than “RFI acknowledgement status”).
- Never use “Issued”, “Closed”, “Delivered”, “Acknowledged”, “Resolved”, “Completed” or “Archived” without naming the owning record and event/state type.
- Do not introduce a new parent-stage label in a downstream file without recording its owner, definition, source, entry/exit guards and impact on DISP-OR01-001/014.
- Any proposed semantic change must include a crosswalk to docs/72, docs/106, docs/104 and affected owner-disposition memoranda.
- Material source changes require exact-version impact assessment and possible specialist re-review.
- This dictionary cannot amend DEC-103–DEC-110 or the conditional owner dispositions.

## 12. SV-01 status and exit criteria

- [x] Parent, cycle, child, event, decision, indicator and records-control semantic types separated.
- [x] Eleven official parent candidate labels represented without adding a new “Reopened” stage.
- [x] Draft and Abandoned Draft separated from official parent lifecycle.
- [x] Issue/technical closure distinguished from recipient communication events.
- [x] Subordinate record families and event/indicator examples catalogued.
- [x] G-01–G-06 explicitly retained as open rather than guessed.
- [ ] Process owner and appointed technical authority validate parent/cycle semantics.
- [ ] Discipline authorities validate assignment/contribution/clarification semantics.
- [ ] Architecture/data governance validates identities, projections, counting units and event lineage.
- [ ] Security/privacy validates permission-safe access and reporting boundaries.
- [ ] Document Control/records validates official record ownership, archive/retention and audit semantics.
- [ ] Exact-version specialist findings are recorded in docs/104 and independently verified.
- [ ] Owner approval is obtained for the exact reconciled detailed-design version before any separate implementation plan.

## 13. Explicit exclusions

This document does not approve final state labels/enums, create state machines or schemas, appoint reviewers/authorities, grant capabilities, set SLA/notification/retention/legal defaults, select technologies/providers, execute tests, modify UI/API/code, DB/schema/migrations/generated types, Storage, authentication, authorization/RLS/grants or production data. No backup/restore, merge, deployment or release is performed or authorized.

---

**End of working dictionary — candidate vocabulary consolidated for review; G-01–G-06 remain open; specialist validation and detailed-design approval remain pending.**
