# RFI Workflow Design — Working Draft for Owner Review

**Document type:** Working design draft; non-authoritative  
**Date:** 2026-11-11  
**Status:** PROPOSED — NOT APPROVED — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Controlling baseline:** `governance/scan-lifecycle-design-2026-11-11`  
**Related approved decision:** DEC-002  
**Purpose:** Identify the RFI-specific decisions required before a detailed workflow and implementation plan can be approved.

> This file is a review aid only. It does not amend the governance branch, create an owner decision, or authorize UI/API/code, schema, database, migration, generated-type, Storage, authentication, authorization, RLS, production, merge, or deployment changes. Every item marked PROPOSED or OPEN remains unapproved until explicitly decided by the project owner.

## 1. Approved baseline — fixed constraints

The following are treated as approved requirements, not proposals:

1. RFI means **Request for Information**: an engineering inquiry or clarification.
2. RFI is fully separate from WIR in form, numbering, permissions, lifecycle, reporting, and audit trail.
3. RFI is not an inspection request. The superseded expansion “Request for Inspection” must not be used as current behavior.
4. An RFI is resolved through an authorized engineering response/resolution, not through a WIR inspection disposition.
5. Draft confidentiality, the Project Manager's read-only oversight exception, capability-based authorization, separation of duties, immutable submitted snapshots, and auditability remain subject to the current approved governance baseline.
6. The general lifecycle proposal is not an approved RFI state machine. Generic A/B/C/D/E/I response codes must not be assumed to govern RFI.

**Evidence:** DEC-002 in `docs/01_MASTER_DECISION_REGISTER.md`; POL-DOC-001 §§1, 2, 5, 6, 10; DEC-002 row in `docs/02_DECISION_IMPLEMENTATION_TRACEABILITY.md`.

## 2. Decisions still open

The current traceability matrix lists AT-RFI-01 through AT-RFI-04 as not verified. The following RFI-specific design decisions must be resolved before implementation:

- Initial RFI form fields and validation.
- Originator, recipient, responsible discipline, responder, reviewer, and records-control responsibilities.
- Whether one responsible responder or multiple discipline responders may be assigned.
- Whether responses are sequential, parallel, consolidated, or configurable.
- Response and clarification vocabulary, including when an answer is considered complete.
- Return-for-clarification, additional-question, cancellation, withdrawal, reopening, and closure authority.
- Revision/resubmission rules and preservation of prior question/answer history.
- Official number allocation and relationship to the already approved general numbering principles.
- Attachments, evidence, distribution, notifications, due dates, and reporting semantics.
- Mapping of existing RFI records without rewriting historical values or identifiers.

No default is inferred for any item above.

## 3. Proposed form structure — for review only

The table distinguishes candidate fields from confirmed requirements. It is not a final required-field specification.

| Candidate field | Purpose | Status / question |
|---|---|---|
| Project | Project context | Likely required; confirm whether inherited from project workspace |
| RFI subject/title | Short searchable engineering question | Proposed required field |
| Originating party and originator | Establish ownership and attribution | Required by authorization/audit principles; exact UI fields to confirm |
| Discipline | Route technical responsibility (ARC, CIVSTR, MEC, ELE, SUR as applicable) | Proposed; decide whether one or multiple disciplines are allowed |
| Location / zone / level | Locate the affected work or design area | Optionality and controlled vocabulary open |
| Drawing / specification / BOQ reference | Identify the source requiring clarification | Proposed repeatable reference list; requiredness open |
| Question / technical description | State the exact information or clarification requested | Proposed required field |
| Reason / impact | Explain why clarification is needed and potential effect | Requiredness and structured options open |
| Suggested resolution | Originator's suggested interpretation, if any | Optional proposal; must not be treated as an approved answer |
| Required response date | Requested target date | Whether supported, who sets it, and whether it has SLA effect are open |
| Attachments | Supporting drawings, marked-up extracts, photos, calculations | File rules, limits, visibility, and versioning require separate approval |
| Related documents | Link to WIR, drawing, submittal, NCR, or prior RFI where relevant | Link semantics and permitted types open; links must not merge workflows |
| Confidentiality / distribution | Restrict access to intended parties | Must follow approved document-level access rules; exact recipient model open |

### Form validation principles proposed

- A draft may be incomplete; validation errors must be visible to its authorized originator.
- Submission must require the final approved mandatory-field set and an authorized originator.
- Submission must freeze the exact question and attachment set for that submitted cycle.
- Editing submitted content must not silently alter the submitted snapshot; a controlled revision or separately approved clarification mechanism is required.
- Uploading an attachment alone must not submit, answer, approve, or close an RFI.
- Suggested resolution is not an engineering answer and must never appear as an authorized response.

## 3A. Recommended RFI form, numbering, attachments and distribution controls — proposed

This section recommends a lean, traceable RFI form and applies existing approved cross-document controls. It does not approve a final field catalogue, numbering pattern, file policy, distribution channel, or implementation.

### Recommended form structure

Separate the form into four groups so that the originator's question is not confused with internal routing or the eventual technical answer.

| Group | Candidate fields | Recommendation / requiredness |
|---|---|---|
| Identity and context | Project (workspace context), RFI subject, originating party, originator, submission date/time (server recorded), discipline(s), location/zone/level where relevant | Project, subject, originator/party and at least one responsible discipline should be required at successful submission. Location is conditional where relevant, not universally mandatory. |
| Technical inquiry | Question / description, reason for inquiry, affected work/design scope, requested response date | Question and reason should be required. Scope should be sufficiently clear to route. Requested date is optional tracking information only unless a separate approved rule says otherwise. |
| References and evidence | Drawing/specification/BOQ references, related document links, supporting attachments, originator's suggested interpretation | References and attachments are repeatable and conditional. Suggested interpretation is optional and visibly labelled as originator-provided, never as an approved answer. |
| Controlled workflow metadata | Assigned disciplines/responders, coordinator, technical lead, required reviewer(s), response issuer, response-required flag by recipient where applicable, event history | These are controlled workflow fields, not editable originator assertions. Values are assigned only by authorized actors and retained with their authority context. |

Avoid asking the originator to select an approver or assign themselves a response authority. The form should not expose internal reviewer-only notes or other parties' confidential draft contributions.

### Validation and submission boundary

1. Draft creation receives an internal draft identifier only. It does not reserve or consume an official RFI number.
2. Drafts may be incomplete and remain visible only to actors authorized to see that party's draft, subject to the approved PM read-only oversight exception.
3. At submission, validate required inquiry content, project/party membership, discipline routing eligibility, references, attachment integrity, duplicate/collision checks, and the submitter's current capability.
4. Allocate and fix the official RFI number only in the successful formal-submission transaction, applying DEC-022-A. Failed validation, abandoned drafts, uploads and saves consume no official number.
5. Freeze the exact submitted question, metadata that forms part of the controlled inquiry, reference list and attachment manifest. Subsequent corrections must be represented by a controlled version or separately linked clarification event; never silently mutate the submitted snapshot.
6. The official document number remains stable across applicable revisions. DEC-022-B's Rev.00 / sequential revision rules apply only where the RFI's approved family workflow creates a formal revision; clarification rounds must not be mislabeled as document revisions.
7. Exact mandatory fields, material-change classification and the boundary between a clarification round and a formal revision remain subject to owner approval.

### RFI numbering recommendation

- Keep an RFI-specific official numbering stream, distinct from WIR and every other document family, as required by DEC-002.
- Use the approved general allocation timing: internal draft ID at creation; official RFI number only on first successful formal submission (DEC-022-A).
- Preserve the official number across the same RFI's clarification/reopen cycles and formal revisions. Keep revision, clarification-round, internal draft, WIR attempt and Transmittal references as separate identifiers.
- Never recycle an issued RFI number, including for cancelled or withdrawn records. Abandoned pre-submission drafts have no official number to recycle.
- Do **not** invent or hard-code a prefix, project code, discipline token, year format, sequence width, reset period, or example number in this draft. The exact display pattern, uniqueness scope (project vs organization), concurrency allocation, legacy collision handling and any discipline component require an explicit numbering decision and inventory of existing records before implementation.

### Attachment and evidence controls

1. Bind every submitted attachment to the exact RFI identity, submitted cycle/version, uploader, originating party, upload timestamp, filename/media metadata, file identity and integrity hash (or equivalent verified integrity reference).
2. Preserve submitted attachment versions as immutable evidence. Replacing a file means adding a new version/event with an explicit relationship; never overwrite the bytes or silently substitute the latest file into an earlier submitted snapshot.
3. Keep draft attachments private to authorized draft participants. On submission, freeze the attachment manifest and enforce per-file authorization independently of access to the RFI summary.
4. A discipline contribution or consolidated response may include its own separately attributable supporting attachments. These must be linked to the exact contribution/response version and must not silently become originator attachments or source-document revisions.
5. Opening, downloading, uploading, or attaching a file does not constitute submission, technical review, approval, acknowledgement or closure.
6. Apply current server-side authorization at preview/download and every attachment action; a Transmittal or URL must not grant access by itself (DEC-021 and DEC-051).
7. File size/type limits, malware scanning, retention, quarantine, preview/conversion, version comparison and storage implementation are not specified here. They require a separately reviewed file-security and storage design; no Storage or upload implementation is authorized by this proposal.

### Routing versus formal distribution

1. **Internal workflow routing** sends the submitted inquiry and scoped contributions to currently assigned responders, coordinator and technical lead under RFI permissions. It is not a general project broadcast and does not itself constitute formal issue to external recipients.
2. **Formal response issue/distribution** occurs only after the RFI's authorized technical response gate. Recommend using the controlled Transmittal framework for formal distribution of the exact issued response package, subject to DEC-050/051 and the final RFI-specific distribution rule.
3. A Transmittal must identify the exact RFI and response/revision version, immutable manifest, sender/issuer authority, intended recipients and per-recipient response/acknowledgement requirement. Recipients are resolved individually; no project-wide broadcast by default.
4. Track dispatch, technical delivery, access, explicit acknowledgement and substantive response as separate recipient-level events. Partial delivery remains visible. None of these events is a technical answer, approval or RFI closure.
5. A response-required / optional / not-requested classification should be explicit per recipient where applicable. A target response date is tracking only unless separately governed. Formal substantive responses must route only to authorized relevant RFI participants, not automatically to every Transmittal recipient.
6. Exact package format, delivery channel, recipients, acknowledgement wording, retention, retry policy and whether every RFI response requires a Transmittal remain open. DEC-050's secure-channel and manifest rules continue to control; this draft does not approve email attachments, public links or a default external channel.

### Recommended acceptance scenarios

- Two concurrent first submissions for the same project/type cannot receive the same official RFI number.
- An abandoned draft and failed submission consume no official number.
- An RFI number is never confused with Rev.00, a clarification-round ID, WIR attempt or Transmittal reference.
- Submitted question and attachment manifest remain unchanged after later draft edits or file replacement.
- A response attachment is attributable to its author and exact contribution/response version.
- An unauthorized party cannot infer or retrieve another party's draft or attachment through search, counts, preview, direct URL or download.
- Internal routing reaches only assigned authorized participants; it does not silently broadcast the RFI.
- Formal response distribution binds the exact issued version and recipient manifest; delivery, access and acknowledgement remain distinct.
- A failed delivery to one recipient remains visible even if other recipients receive the package.

**Open approval points:** final mandatory field list; whether one or multiple disciplines are selected by the originator; official RFI number format and uniqueness scope; clarification-round versus formal-revision classification; file policy and limits; whether formal response distribution always uses a Transmittal; recipient and acknowledgement rules; and delivery-channel policy.

## 3B. Recommended RFI register, reporting, dashboard and notification controls — proposed

This section defines a proposed reporting and oversight model for RFI. It does not approve a final status catalogue, SLA, notification cadence, dashboard entitlement, export format, or implementation. RFI remains a separate document family under DEC-002; its reporting must not reuse WIR outcomes or generic A/B/C/D/E/I response codes.

### RFI register — authoritative record index

Recommend one searchable RFI register backed by the authoritative RFI records and append-only event history, with role- and party-scoped views rather than separate competing registers.

**Candidate register columns**
- Official RFI number and subject.
- Project and originating party.
- Originator and responsible discipline(s).
- Current assigned coordinator, discipline responder(s), technical lead and authorized issuer, where visible to the viewer.
- Current controlled cycle/version and latest formally issued response reference, if any.
- Family-specific current lifecycle state, shown separately from delivery/acknowledgement state.
- Created/submitted timestamps; requested response date and separately configured target date, if present.
- Outstanding contribution/clarification/review indicators.
- Latest authoritative workflow event and timestamp.
- Related RFI, WIR or other document references, subject to independent authorization.
- Delivery/acknowledgement summary for a formally distributed response, without implying technical acceptance.

**Candidate saved views**
- My assigned actions.
- My party's originated RFIs.
- RFIs awaiting discipline contribution.
- RFIs awaiting consolidation or conflict resolution.
- RFIs awaiting required independent review.
- RFIs ready for authorized issue.
- Issued responses with incomplete required delivery/acknowledgement.
- Clarification requested / response pending.
- Overdue against an explicitly configured target date.
- Closed, withdrawn or cancelled historical records.
- Reopened/current follow-up cycle.
- Cross-project oversight only for roles with an expressly approved scope.

These are view concepts, not approved statuses. A saved view must be derived from authoritative record/event facts and must not create or change workflow state.

### Search, filtering and navigation

Recommend filters for project, official RFI number, subject/keywords, originating party, discipline, assigned responder, technical lead, lifecycle state, outstanding action type, date range, requested/target date, related record and delivery/acknowledgement condition.

Search results, autocomplete, counts, facets, exports, linked-record previews and dashboard drill-downs must enforce the same current server-side authorization as opening the RFI itself. Do not reveal another party's existence of a confidential draft, subject, attachment name, participant, count or status through search or aggregate results.

A related-record link is navigational only. Permission to view an RFI does not automatically grant access to a linked WIR, drawing, submittal, Transmittal, response attachment or another RFI. Reauthorize every destination and exact version independently.

### Dashboard and management indicators

Recommend separating **workload/action indicators**, **technical lifecycle indicators**, and **distribution indicators**. Do not combine them into one ambiguous "RFI status" KPI.

| Indicator family | Candidate measures | Interpretation guardrail |
|---|---|---|
| Volume | Drafts visible to the viewer; submitted RFIs; RFIs created/issued/closed in a selected period | State the population, date window and as-of timestamp; do not count inaccessible records |
| Workload | Outstanding discipline contributions by discipline/assignee; items awaiting consolidation; required reviews pending; actions assigned to the viewer | Workload is not a judgement of technical quality or individual performance |
| Age and timeliness | Age since successful submission; time awaiting current action; requested/target date approaching or passed | Show the chosen clock start, pauses and date source; no contractual SLA is inferred |
| Resolution | Issued responses; clarification rounds; reopened RFIs; withdrawn/cancelled records | Distinguish first issue from later cycle activity; cancellation/withdrawal is not technical resolution |
| Distribution | Delivered / partially delivered / failed recipients; acknowledgement outstanding where explicitly required | Delivery and acknowledgement are recipient-level communication facts, not approval or closure |
| Quality and traceability | RFIs with unresolved cross-discipline conflicts; missing required references/evidence; records with incomplete mandatory audit data | These are completeness/control indicators, not engineering decisions |

Every metric definition must specify its exact source events/fields, inclusion/exclusion rules, grouping, timezone, time window, as-of cut-off, treatment of reopened cycles, duplicate prevention and permission scope. A chart must drill down only to records the viewer is authorized to see.

Do not publish rankings, response-time league tables or individual performance scores by default. Any such use requires explicit purpose, data-quality controls, role/party context, attribution rules and owner approval. Counts of drafts, submitted RFIs, responses, Transmittals and recipients must not be added together as though they were the same unit.

### Metric calculation contract — proposed definitions

To make dashboard totals reproducible, define each measure by its counting unit and source evidence before implementation. The following definitions are proposed calculation rules, not a final status catalogue:

| Measure | Counting unit and proposed calculation | Required separation |
|---|---|---|
| Current RFI inventory | Count distinct official RFI identities visible to the viewer at the stated as-of cut-off; classify each identity once by its current authoritative lifecycle state | Do not count revisions, clarification rounds, responses or recipients as additional RFIs |
| Submitted in period | Count distinct RFIs whose first successful formal-submission event falls inside the selected period | A resubmission, clarification, revision or reopening is not a new first submission |
| Issued responses in period | Count formally issued response events in the period, with cycle/version identified | This is an event count, not a count of unique RFIs; one RFI may have more than one issued response across approved cycles |
| Outstanding action queue | Count distinct currently open action assignments at the as-of cut-off, grouped by action type and current assignee | Reassignment closes or supersedes the prior assignment for current workload; preserve it in history |
| Discipline contribution pending | Count current required discipline assignments with no qualifying contribution recorded for that assignment/cycle | Optional or withdrawn assignments are excluded; a contribution in another discipline or cycle does not satisfy it |
| Awaiting consolidation | Count RFIs/cycles for which required contributions exist but the authorized consolidated response has not yet been completed | Do not infer readiness while a required contribution or conflict remains unresolved |
| Review pending | Count current mandatory review assignments without a recorded outcome for the exact response version under review | An outcome on an earlier version does not satisfy review of changed content |
| Overdue | Count currently outstanding actions whose explicitly configured target timestamp has passed at the report cut-off, using the approved timezone/calendar rule | Requested dates without an approved target meaning are not automatically overdue; expiry changes no workflow state |
| Delivery result | Count recipient-level delivery outcomes for the exact Transmittal/manifest, separately as delivered, failed or pending; derive package-level summaries from those recipient rows | Partial delivery must remain visible; never infer delivery from dispatch, access or acknowledgement |
| Acknowledgement outstanding | Count only recipients/manifest entries for which acknowledgement was explicitly required and remains unconfirmed | Recipients not asked to acknowledge are excluded; technical delivery/access does not satisfy acknowledgement |
| Cycle duration | Calculate separately for each preserved RFI cycle from its successful submission timestamp to the explicitly defined terminal event or report cut-off | Do not reset prior-cycle clocks on reopening or substitute a later cycle's duration |
| Clarification activity | Count clarification-round events, with both event totals and distinct affected RFI identities available as separately labelled measures | Do not treat each clarification as a new RFI or a formal revision unless the approved revision rule says so |

For every displayed figure, expose or retain its counting unit (RFI, cycle, response, action assignment, recipient or event), source population, selected period, timezone and as-of cut-off. Where a measure has no approved source event or authoritative field, mark it unavailable rather than estimating it from UI labels or free text.

A summary bucket such as "awaiting response" must not combine discipline contribution, consolidation, review, issue, delivery and acknowledgement into one number. If a combined executive view is later requested, show the component counts and their distinct meanings alongside it. Reopened, withdrawn and cancelled records remain in historical activity reporting while their current-state classification follows the separately approved lifecycle rules.

### Aging, overdue and cycle-time semantics

1. Preserve separate timestamps for draft creation, successful formal submission, assignment, each contribution, clarification request/answer, consolidation, review, formal issue, dispatch, delivery, acknowledgement, reopening and closure.
2. Recommend showing elapsed calendar time from successful submission and elapsed time in the current assigned action as distinct measures. A paused/working-time clock must not be introduced until its pause conditions, calendar and timezone are explicitly approved.
3. Requested response date and configured target date must remain distinguishable. Display their source and responsible setter; do not silently substitute one for the other.
4. Overdue is a monitoring flag only. It must not issue a technical answer, change review authority, escalate access, cancel, withdraw, reopen or close an RFI.
5. If a later cycle is opened, preserve prior-cycle durations and outcomes. Do not reset the historical submission date or rewrite the previous cycle's elapsed time.
6. No universal numeric SLA, contractual deadline, deemed response, pause rule or escalation threshold is created by this draft.

### Notifications and reminders

Apply the approved central notification framework in DEC-049 without merging RFI into WIR's specific reminder rules.

Candidate RFI notification events include successful formal submission; assignment/reassignment; request for a discipline contribution; clarification requested; contribution submitted; consolidation conflict or return for clarification; independent review assignment/outcome; authorized response issue; formal distribution and recipient-level delivery failure; required acknowledgement outstanding; authorized withdrawal/cancellation; reopening; and closure.

For every event:
- Resolve recipients individually from current project, party, discipline, assignment, workflow step, visibility and capability—not broad membership or historical assignment.
- Identify the RFI reference, event, authorized context, priority, timestamp, recipient and expected action where applicable, while limiting message content to what that recipient may see.
- Recheck authorization on notification list, counts, open, preview, download and linked action. A notification is not an access grant.
- Keep notification delivery/read/dismissal/acknowledgement state separate from the source RFI state. Reading a notice does not complete the action.
- Deduplicate technical retries without hiding distinct business events. Preserve recipient-level delivery attempts/outcomes and audit evidence.
- Do not assume every informational event requires action. Exact event-to-priority mapping, reminder cadence, escalation thresholds, quiet hours, retry limits and channels remain open for RFI-specific approval.

DEC-042's WIR-specific reminder policy must not be copied wholesale into RFI. Any RFI reminders/escalations need their own approved actionable-event definitions, responsible recipient rules, timing and escalation scope. Escalation may improve visibility/accountability only; it must never transfer authority, grant permissions or perform a workflow action.

### Exports and report integrity

Recommend authorized, reproducible register exports and period reports only after the reporting scope is approved. Each export/report should record its requester, authority context, filter criteria, timezone, generation timestamp, as-of cut-off, selected fields, source record/cycle/version references and integrity reference where appropriate.

Exports must apply the same row-, field-, party- and attachment-level access rules as the interactive register. Exclude hidden drafts, confidential contribution content, personal details and other-party recipient data unless the viewer has explicit authority. A report must not flatten or silently replace historical cycles with the latest one.

A report is a derived view, not a new technical decision or authoritative RFI response. Correcting a report does not change source records; correcting a source record requires its own authorized, attributable event. Retention, scheduled distribution, external BI integration, spreadsheet formula safety and export formats require separate review.

### Recommended acceptance scenarios

- Register counts, filters and exports return only records and fields the current actor may access.
- Search/autocomplete/facets do not disclose unauthorized draft existence, subjects, attachment names or participant identities.
- Dashboard totals reconcile to the defined source population and explicit as-of cut-off; inaccessible records are not leaked through aggregate counts.
- Reopened RFIs preserve prior-cycle dates, durations, issued responses and closure history.
- A recipient delivery failure remains visible independently of successful delivery to other recipients.
- An acknowledgement-pending indicator appears only for recipients explicitly required to acknowledge.
- Reading/dismissing a notification does not resolve the underlying RFI action.
- Due-date expiry changes only the monitoring indicator; it does not change workflow state or authority.
- A dashboard drill-down rechecks authorization and cannot be used to navigate into an inaccessible linked record.
- An export preserves the selected filter/timezone/cut-off context and does not silently substitute a newer response version.

**Open approval points:** final register columns and saved views; lifecycle status vocabulary and aggregation rules; KPI definitions and reporting population; date/time and pause semantics; role-specific dashboard visibility; reminder/escalation event map and cadence; export formats, retention and scheduled distribution; and whether any performance analytics are permitted.

## 4. Candidate role and capability matrix — not approved

Capabilities must be assigned explicitly and checked server-side at action time. Job titles or project membership alone must not imply workflow authority.

| Actor / party | Candidate responsibility | Decisions required |
|---|---|---|
| Originating contractor / consultant / authorized project party | Create and maintain own draft; submit; view permitted responses; provide clarification when requested | Which parties may originate each RFI category? Can originator withdraw after submission, and until which event? |
| RFI coordinator / document controller | Completeness check, routing, recipient coordination, register quality | Is this a distinct role? Can it return an incomplete RFI without making an engineering decision? |
| Responsible discipline engineer | Prepare technical response within assigned scope | Who assigns the responder? Can one RFI have multiple discipline owners? |
| Lead engineer / designated reviewer | Review or consolidate technical response | Is independent review mandatory? Which cases require it? |
| Project Manager | Oversight visibility, read-only under DEC-009 | No edit, submit, review, response, approval, cancellation, or closure authority is implied by visibility |
| System / company administrator | Technical administration only within approved boundaries | No automatic cross-party workflow authority or bypass |
| Records / document control | Issue, distribute, archive, and preserve the record if authorized | Exact capabilities and timing relative to technical resolution remain open |

**Mandatory negative controls:** no self-approval where separation of duties applies; no proxy/impersonation; no cross-party administrator bypass; no workflow action based only on hidden/disabled UI controls; no action without server-side capability and resource-scope checks.

## 4A. Recommended RFI responsibility and capability boundaries — proposed

This section translates the already approved governance constraints into an RFI-specific candidate responsibility model. It does **not** create new role grants, approve role bundles, or authorize implementation. Capabilities must be checked server-side for the exact project, party, RFI, revision, assignment and workflow step at the time of each action.

### Responsibility and authority separation

| Responsibility | Candidate permitted scope | Explicit boundary |
|---|---|---|
| Originator | Create/edit own party's draft; submit when authorized; answer a formal clarification request; view the RFI and responses permitted to that party | Cannot assign engineering responders, issue the authoritative answer, review/approve own submission, or alter a submitted snapshot |
| RFI coordinator / document controller | Check administrative completeness; route and assign within delegated scope; monitor outstanding contributions; manage permitted distribution and record completeness | Cannot decide technical meaning, rewrite discipline contributions, consolidate engineering judgement, approve a technical answer, or close by administrative convenience |
| Discipline responder | Prepare and submit a contribution limited to the assigned discipline/scope; attach supporting references and identify assumptions or conflicts | Cannot edit another discipline's contribution, issue the consolidated answer, or approve their own contribution where independent review applies |
| Technical lead / consolidator | Review contributions for consistency; resolve or escalate conflicts; prepare the consolidated response; return incomplete or conflicting contributions for resolution | Must have explicit technical authority for the relevant discipline/package; coordination title alone is insufficient; cannot bypass mandatory independent review |
| Independent technical reviewer | Review the defined response snapshot and record the authorized review outcome | Must be a distinct eligible person from the author where separation of duties applies; review scope does not automatically grant editing or issuing authority |
| Authorized response issuer | Formally issue the approved consolidated engineering response to permitted recipients | Issuing authority must be explicitly assigned and distinct from mere document-control/distribution capability; no issue while required contributions or reviews remain incomplete |
| Records / distribution controller | Perform the approved records registration, distribution, archival and retention actions after the relevant technical gate | Cannot change the technical answer, infer approval from delivery, or close an RFI unless separately and expressly authorized |
| Project Manager | Read-only oversight visibility, including drafts, under DEC-009 | Visibility grants no edit, submit, routing, response, review, approval, cancellation, signing or closure capability |
| Company / system administrator | Technical administration only within approved system boundaries | No automatic cross-party access, impersonation, workflow action, reviewer substitution, or administrator bypass |
| Project / party roster administrator | Manage only authorized roster and assignment administration | Roster administration does not itself grant access to an RFI or authority to respond, review, issue or close it |

### Action-level separation controls

1. **Draft authoring and submission:** the originator may submit only within their authorized party and document scope. A different authorized person may perform a permitted administrative completeness check, but this does not convert that check into technical review.
2. **Routing and assignment:** only a specifically authorized coordinator or technical routing authority may assign responders. Every assignment must identify the person, party, discipline, scope, effective period and relevant RFI cycle.
3. **Discipline contribution:** each contribution is attributable to the authenticated individual and active assignment. Shared accounts, typed names, proxy actions and impersonation are prohibited.
4. **Consolidation:** the consolidator may reconcile and assemble contributions but must preserve their source authorship and history. Material technical disagreement must be resolved by an authorized technical decision, not silently edited away.
5. **Independent review:** where required, the reviewer must be distinct from the response author and must review the exact consolidated-response version. A changed version invalidates any review that no longer covers the changed content, subject to the approved review policy.
6. **Formal issue:** only the explicitly assigned issuer may issue the consolidated response after all required discipline contributions, conflict resolutions and mandatory reviews are complete.
7. **Distribution and archive:** technical issue, delivery, acknowledgement and archival are distinct capabilities and events. A successful distribution event cannot create or substitute for an engineering decision.
8. **Cancellation, withdrawal, reopening and closure:** these remain separate high-impact capabilities. No actor receives them merely by being an originator, coordinator, responder, reviewer, records controller, PM or administrator. Each requires a separately approved rule, authorized scope, reason where applicable, and immutable event history.

### Mandatory deny-by-default checks

For every attempted RFI action, the server-side authorization decision must evaluate at least:

- authenticated individual identity and active account;
- active, accepted project/party assignment and effective role;
- the RFI's project, originating party, recipient scope and confidentiality;
- the exact capability required for the requested action;
- current RFI state, submitted revision and workflow step;
- current responder/reviewer/issuer assignment and its scope;
- separation-of-duties conflicts, including self-review/self-approval;
- whether the action would alter an immutable submitted or issued record;
- whether the actor is attempting to cross a party boundary or use an administrator/PM visibility exception as workflow authority.

A hidden or disabled UI control is not an authorization control. Unauthorized requests must be denied by the server even when manually invoked. Denials and authorized formal actions must be auditable without exposing confidential content to unauthorized readers.

### Combined responsibilities — unresolved

The same person may hold multiple project roles, but role combination must not collapse distinct capabilities. Before implementation, define whether the same individual may act as coordinator and consolidator, consolidator and issuer, or reviewer and issuer for each RFI class. At minimum, the author must not independently review/approve their own response where separation of duties applies. Any permitted combination must be explicit, scoped, and tested; no combination is inferred from job title or system administration.

### Evidence basis and status

This recommendation is constrained by the approved baseline: DEC-008 (draft confidentiality), DEC-009 (Project Manager read-only oversight), DEC-010 (no self-approval), DEC-011 (party boundary and no administrator bypass), DEC-020 (individual authenticated roster assignments), and DEC-021 (deny-by-default capability authorization). The general lifecycle proposal §§2–5 further requires action-time server checks, immutable submitted snapshots, attributable transitions and controlled revisions.

**Status:** PROPOSED RFI-specific design; not an approved capability catalogue, role grant, or implementation plan. Exact role names, grant owners, combinations, review triggers, issuer appointment and cancellation/reopening/closure authorities remain open.

## 5. Candidate workflow patterns — alternatives, not decisions

The following alternatives are presented for owner selection. They must not be combined by assumption.

### Option A — Single responsible responder

1. Originator prepares draft.
2. Originator submits the RFI.
3. An authorized coordinator checks administrative completeness and routes it to one responsible discipline/party.
4. Assigned responder prepares one consolidated engineering response.
5. A separately assigned reviewer reviews the response only if the approved project rules require it.
6. The authorized response is issued to the originator.
7. The RFI is closed only by an explicitly authorized resolution/closure action under an approved closure rule.

**Trade-off:** simpler responsibility and reporting; may require internal coordination outside the system for multidisciplinary questions.

### Option B — Multiple discipline responses with consolidation

1. Originator submits one RFI.
2. Coordinator assigns one or more discipline responders.
3. Each assigned responder contributes a scoped response.
4. A designated lead consolidates the responses.
5. The consolidated response is issued as the authoritative RFI answer.
6. Closure follows an approved completeness rule covering all required contributions.

**Trade-off:** better multidisciplinary traceability; requires rules for partial responses, conflicting advice, quorum, reassignment, and final consolidation authority.

### Option C — Configurable response model

A project/type configuration selects either one responder or multiple responders, with versioned configuration and no silent change to in-progress RFIs.

**Trade-off:** flexible but increases configuration, validation, reporting, and test complexity. Configuration owner and safe change-effective rules must be approved.

## 5A. Recommended direction for multidisciplinary RFI — proposed, not approved

Based on the project needs and the approved separation-of-duties and audit principles, the recommended target is **multiple discipline contributions with one controlled consolidated response**. This is the design recommendation selected for further owner review; it is not yet an approved decision or implementation authority.

### Recommended operating model

1. **One RFI record and one official RFI identity.** A multidisciplinary inquiry remains one RFI. It is not split into multiple independent RFIs merely because several disciplines must contribute.
2. **Scoped discipline assignments.** The authorized coordinator routes the submitted inquiry to one or more responsible disciplines (for example ARC, CIVSTR, MEC, ELE, SUR), with each assignment limited to a defined question/scope and an accountable responder.
3. **Independent contributions.** Each responder records a separately attributable contribution, including its author, timestamp, scope, response version, references and supporting evidence. One discipline cannot overwrite another discipline's contribution.
4. **Consolidation owner.** A designated lead engineer or other explicitly authorized technical role reconciles the contributions and prepares one consolidated response. The coordinator may manage routing and completeness but does not acquire engineering decision authority merely by coordinating.
5. **Conflict handling.** Conflicting, conditional, or mutually dependent discipline contributions must be returned for resolution by the designated technical lead or escalated to an explicitly authorized authority. The system must not silently choose one response or mark the RFI resolved while a material conflict remains.
6. **Review by risk/authority rule.** Independent review is required where the approved project rule, discipline authority matrix, or configured risk condition requires it. The author of a response must not approve their own response where separation of duties applies. The exact triggers and reviewer authority remain open.
7. **Issue as one authoritative answer.** Only the authorized consolidated response, after all required contributions and reviews are complete, is formally issued to the permitted recipients. Drafts and partial discipline contributions remain clearly distinguished from the issued answer.
8. **Clarification within the same RFI.** Follow-up questions that clarify the original inquiry should be recorded as a new, auditable clarification round within the same RFI, preserving prior questions, contributions, consolidated responses and issue history. A materially different or independent inquiry should be a new RFI linked to the earlier one. The boundary test and who classifies it remain to be approved.
9. **Closure after authorized issue.** The recommended closure condition is completion of all required discipline contributions, resolution of material conflicts, completion of mandatory review, and formal issue of the consolidated engineering response by an authorized actor. Delivery, opening, acknowledgement, silence, or originator acceptance must not be treated as engineering approval or silently substituted for the issued response. Whether closure is automatic on issue or requires a separate authorized closure action remains open.
10. **Preserve the record.** Reassignment, clarification, review, consolidation, issue, withdrawal/cancellation and any permitted reopening must retain immutable event history. No in-progress RFI may be silently reconfigured in a way that changes its required responders or approval path.

### Why this is preferred

- It preserves one traceable question and one authoritative answer while retaining discipline-level accountability.
- It avoids the fragmentation and duplicate numbering that would result from creating separate RFIs for each discipline by default.
- It makes incomplete contributions and conflicting technical positions visible.
- It separates administrative coordination from engineering judgement and formal response authority.
- It is more suitable for multidisciplinary construction projects than a single-responder-only model, while avoiding the broad configuration complexity of a fully configurable response engine.

### Decisions deliberately left open

The recommendation does **not** decide: which parties may originate RFIs; who appoints the coordinator and technical lead; mandatory review triggers; exact role/capability names; the formal clarification-versus-new-RFI test; cancellation/withdrawal/reopening authority; due-date or SLA effects; required form fields; recipient distribution/acknowledgement; or whether issue itself closes the record versus a separate closure action. These remain explicit design decisions and must be settled before implementation planning.

## 6. Response and clarification concepts — vocabulary unresolved

These are candidate concepts for discussion, not approved status labels:

- **Response in preparation:** responder is drafting; not yet an issued answer.
- **Response submitted for review:** only if a distinct review step is approved.
- **Clarification requested:** originator or authorized recipient asks a follow-up question; the effect on closure and response version must be decided.
- **Response issued:** an authorized technical answer has been formally released to the permitted recipients.
- **Resolved / Closed:** use only after the owner approves the exact closure meaning and authorized actor.
- **Cancelled / Withdrawn:** distinct from a technical answer; initiator, timing, and consequences are open.

Do not reuse WIR outcomes (Accepted, Requires Correction, Not Ready for Inspection) or generic response codes as RFI outcomes.

## 6A. Recommended clarification, withdrawal, cancellation, reopening and closure controls — proposed

The following lifecycle controls are recommended for owner review. They preserve one RFI identity while distinguishing a technical answer from administrative termination and later follow-up. They are not approved status definitions or implementation authorization.

### Clarification rounds

1. **Before an authoritative response is issued:** an authorized participant may request clarification against the current RFI cycle. The request must identify the exact question or response contribution needing clarification, the requester, timestamp, reason/context and assigned recipient.
2. A clarification creates a new numbered round/event under the same RFI identity. It does not overwrite the original question, prior contributions, attachments, review comments or earlier clarification rounds.
3. The coordinator may route the clarification administratively. The responsible discipline responder supplies the technical clarification; the technical lead reconciles it where multiple disciplines are involved.
4. The system must show which contributions and consolidated response version answer each clarification round. A clarification that changes the technical scope materially must be assessed against the new-RFI test below.
5. **After a response has been issued:** a request that merely explains the issued answer may be recorded as a post-issue clarification event. If it requires a changed technical answer, the RFI should enter an authorized follow-up/reopen path or a new linked RFI according to the scope test; the issued response remains immutable.

### Same RFI versus new linked RFI

Keep the same RFI identity when the follow-up explains, completes, or resolves ambiguity in the original question without introducing a materially independent technical issue. Create a new RFI and link it to the original when the follow-up introduces a separate design decision, different physical scope/package, independent cause, or a question that could be answered and tracked independently without changing the original inquiry.

The classification must be recorded with a reason by an authorized technical lead or designated classification authority. A coordinator may flag a candidate but must not decide technical scope solely for administrative convenience. When uncertain, preserve the original and escalate for classification; do not silently append unrelated work.

### Originator withdrawal and administrative cancellation

1. **Originator withdrawal:** recommend allowing the authenticated originator (or an explicitly authorized delegate from the same originating party) to request withdrawal before an authoritative technical response is issued. The request must include a reason and be recorded as a request, not as an immediate deletion or silent state change.
2. An authorized coordinator validates the request's scope and whether material technical work or a formal response has already occurred. The exact approval/confirmation gate remains to be approved.
3. After an authoritative response is issued, the originator must not erase or withdraw that issued response. A later change of need is recorded as a post-issue request, and any technical correction follows a controlled clarification, reopening or new-linked-RFI path.
4. **Administrative cancellation** is distinct from originator withdrawal. Recommend reserving it for demonstrable administrative cases such as duplicate registration or invalid routing, by an explicitly authorized records/workflow authority, with a mandatory reason and, where technical work has started, technical-lead concurrence.
5. Neither cancellation nor withdrawal deletes the RFI, releases its number for reuse, erases assignments or evidence, nor rewrites prior events. The record remains searchable and auditable with its terminal reason and links.

### Reopening a closed RFI

1. Recommend permitting reopening only by an explicitly authorized technical authority, on a documented reason such as a material defect/ambiguity in the issued response or a formally accepted need for further technical clarification.
2. Reopening creates a new response/clarification cycle under the same RFI identity, with a new cycle/version reference. It does not revert or erase the prior issued response or closure event.
3. The new cycle must re-evaluate required discipline contributions, conflicts, review and issue authority. Prior approvals/reviews do not automatically carry forward to changed content.
4. A new independent technical question should be a new linked RFI, not a reopening used to expand scope.
5. Reopening must notify the appropriate assigned participants under the approved distribution rules. Exact notification recipients and deadlines remain open.

### Closure and terminal semantics

Recommend that an RFI becomes **Closed** automatically only after all required discipline contributions are complete, material conflicts are resolved, mandatory independent review is complete, and the authorized consolidated technical response is formally issued. The system records the closure event as part of the same controlled issue transaction or its confirmed completion event.

Do not require originator acceptance, acknowledgement, opening/read status, or silence as a condition of technical closure. Those are separate communication events and must not veto or imply engineering resolution. If an explicit administrative closure action is retained instead of automatic closure, it must be a separately authorized records action after the technical issue gate; it cannot change the technical content or substitute for missing engineering authority.

A later clarification or approved reopening creates a new active cycle while preserving the previous Closed cycle and issued response as historical. A due date expiring must never automatically close, cancel or withdraw an RFI.

### Due dates and overdue handling

Treat a requested response date as a recorded request unless an approved project/contract rule explicitly gives it a binding workflow meaning. Any assigned target date or SLA must identify its source, owner, applicable calendar/time zone, start/pause/resume rules, and escalation authority. Overdue status is a monitoring condition only: it must not generate an automatic technical answer, approval, rejection, cancellation or closure. No contractual consequence or default SLA is inferred by this draft.

### Required audit record

For each clarification, withdrawal request, cancellation, reopening and closure event, preserve at minimum: RFI identity and cycle/version; event type; authenticated actor and effective party/assignment; timestamp; reason and referenced scope; affected question/contribution/response; prior and resulting state; authority/capability basis; linked RFI/transmittal where applicable; and notification/delivery evidence where required. Corrections must be additive and attributable; never overwrite the original event.

### Recommended acceptance scenarios

- A clarification round preserves all earlier questions, responses, attachments and review events.
- A materially independent question creates a new linked RFI and does not alter the original.
- A withdrawal request after issue cannot erase or retract the issued response.
- A duplicate cancellation preserves the record, number and reason.
- Reopening creates a new cycle while the former closure and issued answer remain visible as history.
- Changed content is re-reviewed where required; old review cannot silently approve a changed response.
- Due-date expiry produces an overdue indicator only and never closes or cancels the RFI.
- No delivery, acknowledgement, read event or originator silence is treated as technical approval or closure.

**Open approval points:** exact originator withdrawal cutoff and validation authority; administrative cancellation authority; technical reopening authority; same-RFI/new-RFI classification authority and test; automatic versus explicit closure event; due-date/SLA configuration and pause rules; and notification obligations.

## 7. Core lifecycle questions requiring explicit decisions

| ID | Question | Options to consider | Why it matters |
|---|---|---|---|
| RFI-D01 | Who may originate an RFI? | Contractor only; consultant only; any authorized project party; type-specific | Defines party boundary and numbering ownership |
| RFI-D02 | Who performs administrative completeness checks? | Originator validation only; separate coordinator; both | Separates administrative screening from engineering judgment |
| RFI-D03 | Who assigns the responder? | Coordinator; discipline lead; configured routing; combination | Establishes accountable routing authority |
| RFI-D04 | How many responders? | One; multiple with consolidated answer; configurable | Affects data model, assignment, statuses, and reports |
| RFI-D05 | Is independent technical review required? | Never by default; always; only configured cases | Controls separation of duties and response authority |
| RFI-D06 | Can originator ask follow-up questions? | New linked RFI; clarification loop in same RFI; both under defined conditions | Prevents ambiguity in numbering and closure |
| RFI-D07 | What closes an RFI after the technical response gate is satisfied? | Automatic closure as part of authorized formal issue; or a separate, explicitly authorized closure event after formal issue | Delivery, access, acknowledgement, read state, silence or originator acceptance are not closure options and cannot substitute for an issued engineering response |
| RFI-D08 | Can a closed RFI reopen? | No; authorized reopen with reason; new linked RFI | Preserves prior response and closure history |
| RFI-D09 | Can an RFI be withdrawn/cancelled? | Before routing; before response; any time with authority; not allowed | Determines who can terminate an inquiry |
| RFI-D10 | How are due dates handled? | Requested date only; assigned target date; configured SLA | Avoids inventing contractual deadlines or escalation |
| RFI-D11 | How are attachments revised? | Append-only per response/revision; replace with history; both by controlled rule | Preserves evidence and exact response context |
| RFI-D12 | What is the official number rule? | Apply already approved general numbering principles; define RFI-specific stream/token separately | Prevents accidental WIR numbering reuse or retroactive renumbering |

## 8. Initial acceptance-test outline

These scenarios expand the four existing traceability requirements; they are proposed test definitions, not passed tests.

- **AT-RFI-01 — Engineering inquiry:** an authorized originator can create and formally submit an RFI containing the approved required fields; an inspection-only WIR action cannot create or resolve it.
- **AT-RFI-02 — Type isolation:** RFI and WIR use distinct document-type configuration, numbering stream, permission checks, workflow actions, reports, and audit events; no conversion or substitution occurs implicitly.
- **AT-RFI-03 — Authorized resolution:** only the actor and capability explicitly approved for the relevant response/closure step can issue the technical response or close the RFI; draft response, comment, delivery, read, and silence do not count as an issued engineering resolution.
- **AT-RFI-04 — Cross-type and cross-party security:** unauthorized parties cannot read drafts, attachments, responses, or audit data; no PM read-only, administrator, originator, responder, or WIR permission grants unrelated RFI authority.
- **AT-RFI-05 — Snapshot integrity:** submitted question, references, and attachments remain bound to the exact submitted version; later edits create a traceable new version or approved linked event.
- **AT-RFI-06 — Response history:** every response, clarification, review, issue, cancellation, withdrawal, and closure event retains actor, timestamp, scope, and prior history; no silent overwrite.
- **AT-RFI-07 — Multidisciplinary completeness:** if multiple responders are approved, no final consolidated response or closure occurs while a required contribution remains outstanding.
- **AT-RFI-08 — No false closure:** delivery, acknowledgement, read state, due-date expiry, or a draft answer does not silently close the RFI.
- **AT-RFI-09 — Reopen/linkage:** any approved reopening or follow-up creates the correct auditable link and does not rewrite the prior closed record.
- **AT-RFI-10 — Number integrity:** drafts and failed validation do not consume official numbers if the approved numbering rule says otherwise; RFI numbers never collide with or reuse WIR numbers.

- **AT-RFI-11 — Metric counting units:** dashboard tests distinguish unique RFI identities, cycles, response events, open action assignments, recipients and clarification events; no mixed-unit total is presented as an RFI count.
- **AT-RFI-12 — Metric cut-off and dates:** the same source dataset and explicit timezone/as-of cut-off produce reproducible period totals; requested dates without an approved target meaning do not become overdue actions.
- **AT-RFI-13 — Recipient aggregation:** package delivery and acknowledgement summaries reconcile to individual recipient/manifest-entry outcomes; partial delivery and acknowledgement-required scope remain visible without implying technical resolution.

## 9. Existing-record and terminology cleanup

- Current terminology must use **RFI — Request for Information**.
- Historical “Request for Inspection” labels are evidence of superseded wording; preserve the original diagnostic/history and record a controlled correction plan.
- Do not mass-update existing records, seeds, migrations, database values, or issued numbers as part of this design draft.
- Inventory all current RFI references and distinguish live code/configuration from historical reports, seeds, test fixtures, and archived diagnostics before proposing a correction.
- Any historical mapping must preserve raw values, identifiers, timestamps, actor history, and links.

## 10. Required review outcome

Before an RFI implementation plan is prepared, the owner must explicitly decide:

1. Originating parties and administrative coordinator.
2. Single responder vs multiple responders vs configurable model.
3. Technical review requirement and final response authority.
4. Follow-up/clarification model.
5. Exact closure condition and closure authority.
6. Cancellation/withdrawal and reopening rules.
7. Due-date semantics.
8. RFI-specific form fields and requiredness.
9. RFI numbering stream and interaction with approved numbering rules.
10. Attachments, distribution, acknowledgement, and reporting requirements.

After approval, update the authoritative design proposal, Master Decision Register, and Decision-to-Implementation Traceability Matrix sequentially on the governance branch, with a unique decision ID and acceptance evidence. Only then prepare a separately reviewed implementation plan.

## 11. Explicit non-authorization

This working draft does not authorize or perform:
- RFI lifecycle implementation, UI actions, API/server functions, or workflow engine changes;
- database/schema/enum/function/trigger changes or migrations;
- generated types or data migrations;
- Storage buckets, object access, upload/download, or retention changes;
- authentication, authorization, RLS, grants, or production configuration changes;
- live-data tests, PR merge, or deployment.

**Current conclusion:** DEC-002 is approved; the detailed RFI workflow is not. Keep RFI screens informational until the owner approves the required design decisions and the implementation plan passes its separate safety and ownership gates.


## 12. Consistency audit and owner decision package — working review

**Review status:** document-level consistency review completed against the current working draft and the referenced approved governance baseline on 2026-11-11. This is not an implementation test, formal design approval, or owner decision.

### Audit findings

1. **RFI/WIR separation:** the proposed form, numbering, lifecycle, reporting and audit model consistently treats RFI as Request for Information and does not import WIR inspection dispositions or generic A/B/C/D/E/I response codes.
2. **Authority and confidentiality:** the proposed responsibility model preserves draft confidentiality, the Project Manager's read-only oversight exception, individual attribution, no self-approval, party separation and deny-by-default server-side authorization. It does not grant authority from job title, roster administration or system administration.
3. **Technical answer versus communications:** the design consistently distinguishes technical response issue from Transmittal dispatch, recipient delivery, access receipt, acknowledgement and substantive recipient response. None of the communication events is a technical approval or closure.
4. **Revision and evidence integrity:** official number, revision, clarification round, response cycle, WIR attempt and Transmittal reference remain distinct. Submitted snapshots, attachments and prior issued responses are preserved rather than silently overwritten.
5. **Due dates and reporting:** overdue is a monitoring condition only. No universal SLA, contractual deadline, pause rule, deemed response or automatic escalation authority is inferred. Metrics identify their counting unit, source population, timezone and as-of cut-off.
6. **Notification boundaries:** the RFI proposal uses the central notification framework in DEC-049 while keeping WIR-specific reminder rules separate. Notifications do not grant access or complete source workflow actions.
7. **Correction made during this audit:** RFI-D07 previously listed originator acknowledgement among possible closure options, which conflicted with the acknowledgement/closure separation elsewhere in this draft and DEC-052. The row has been corrected to retain only automatic closure on authorized formal issue or a separate authorized closure event after issue.

### Dependencies that remain intentionally unresolved

- The final RFI lifecycle status vocabulary and exact transition/terminal-state rules.
- Which parties may originate each RFI class, and who appoints the coordinator, discipline responders, technical lead, reviewer and issuer.
- Whether independent review is mandatory and which separation-of-duties combinations are prohibited.
- Clarification-round versus formal-revision classification, and same-RFI versus new-linked-RFI authority.
- Withdrawal, administrative cancellation, reopening and closure authority.
- Mandatory form fields, numbering format/uniqueness scope, file policy and attachment limits.
- Whether formal response distribution always requires a Transmittal, plus recipient and acknowledgement requirements.
- Requested date versus assigned target date, timezone/calendar, pause rules, SLA and escalation policy.
- Final dashboard population, role visibility, status aggregation, export formats, retention and notification event/priority/cadence rules.

### Recommended owner decision package

For efficient review, group the open decisions into four approval packages:

1. **Operating model and authority:** originating parties; coordinator; one versus multiple discipline responders (recommended: multiple scoped contributions with one consolidated response); technical lead; review triggers; issuer; permitted role combinations.
2. **Lifecycle and technical resolution:** response/clarification vocabulary; same-RFI/new-RFI test; formal revision boundary; withdrawal/cancellation/reopening; closure on issue versus separate authorized closure.
3. **Document control and distribution:** mandatory fields; official numbering format and uniqueness scope; attachment/security policy; Transmittal requirement; recipient-level delivery, access and acknowledgement rules.
4. **Monitoring and records:** requested/target date semantics; SLA and timezone; register/status/KPI definitions; notification recipients/priorities/reminders; report/export formats and retention.

**Recommended sequence:** owner reviews and explicitly approves or rejects each proposed rule; only approved decisions are then transferred to the authoritative governance proposal, Master Decision Register and traceability matrix on the governance branch, sequentially and with unique decision IDs. A separate implementation plan and safety review must follow. No implementation is authorized by this audit.


## 13. Owner decision matrix — recommendations for explicit review

**Status:** The recommendations below are the technical recommendation for owner review. They are not approved policy, role grants, contractual rules, or implementation authorization. “Owner decision” means the project owner must explicitly accept, reject or amend the proposed rule. “Design detail” means it may be finalized in the subsequent detailed design only within the approved boundary.

| ID | Decision area | Recommended position | Approval level | Reason / guardrail |
|---|---|---|---|---|
| ODM-01 | Parties allowed to originate | Permit only project parties explicitly enabled for the relevant RFI class and project; do not grant originator capability from project membership alone | Owner decision | Preserves party boundaries and avoids assuming every participant may raise every inquiry |
| ODM-02 | Administrative coordinator | Assign a designated RFI coordinator/document controller per project or controlled project scope; coordinator performs completeness/routing/records tasks only | Owner decision on role and appointment authority; detailed assignment fields are design detail | Keeps administration separate from engineering judgement |
| ODM-03 | Response model | Adopt multiple scoped discipline contributions under one RFI identity, followed by one controlled consolidated response; do not create one RFI per discipline by default | Owner decision | Best traceability for multidisciplinary construction questions without fragmenting the inquiry |
| ODM-04 | Assignment authority | Coordinator may route only within an explicitly delegated routing scope; technical lead/discipline authority resolves technical ownership disputes | Owner decision on delegation boundary; assignment data structure is design detail | Prevents administrative assignment from silently becoming technical authority |
| ODM-05 | Technical lead and consolidation | Require a named technical lead for multi-discipline RFIs; lead consolidates, records conflicts and obtains authorized resolution; cannot silently discard conflicting contributions | Owner decision | Establishes one accountable consolidated answer while preserving each discipline's authorship |
| ODM-06 | Independent review | Require independent review when a project-approved risk/authority matrix says so; author cannot review/approve own response where separation applies | Owner decision on trigger authority and mandatory cases; exact risk criteria may be a controlled project design detail | Avoids both blanket over-review and unreviewed high-risk answers |
| ODM-07 | Final response issuer | Formal issue by a specifically assigned technical authority for the relevant discipline/package; document control may distribute but does not acquire technical issue authority | Owner decision | Separates technical authorization from records distribution |
| ODM-08 | Clarification versus new RFI | Same RFI for explanation/completion of the original question; new linked RFI for a materially independent technical decision or independently trackable scope; classification by technical lead or delegated technical authority with recorded reason | Owner decision on authority and principle; examples/test cases are design detail | Preserves traceability without allowing scope creep |
| ODM-09 | Clarification versus formal revision | Use a clarification-round identifier for follow-up that does not materially change the controlled inquiry; use a formal revision only when the approved document-control rule classifies a material change to the formal RFI content | Owner decision on material-change principle; detailed change examples are design detail | Prevents clarification rounds from being confused with Rev.00/Rev.01 |
| ODM-10 | Originator withdrawal | Permit a withdrawal request before formal response issue; require an authorized coordinator/records authority to validate it, with technical-lead concurrence once substantive work has begun; never delete or reuse the number | Owner decision | Prevents unilateral erasure of work already relied upon by technical participants |
| ODM-11 | Administrative cancellation | Limit to evidenced administrative cases such as duplicate/invalid registration; require designated records/workflow authority and technical-lead concurrence if technical work has started | Owner decision | Cancellation is not a technical disposition and must preserve the record |
| ODM-12 | Reopening | Permit only through an explicitly designated technical authority, with reason and a new cycle; preserve the prior issued response and closure unchanged | Owner decision | Supports correction without rewriting history |
| ODM-13 | Closure event | Prefer automatic closure in the same controlled transaction as authorized formal issue, after all required contributions/conflicts/reviews pass; do not require originator acceptance or acknowledgement | Owner decision | One unambiguous technical terminal event; if a separate closure action is retained, it must be explicitly authorized and cannot precede issue |
| ODM-14 | Requested date, target date and SLA | Keep originator-requested date informational; permit a separate assigned target date only under an approved project rule; introduce no default SLA, pause clock or contractual consequence | Owner decision on whether project SLAs are enabled; calendar/timezone calculation is design detail | Avoids inventing contractual commitments |
| ODM-15 | Form requiredness | Require project, subject, originator/party, at least one responsible discipline, clear question and reason at formal submission; make location and references conditional where relevant; keep suggested resolution optional and clearly non-authoritative | Owner decision on required-field set; validation messages/layout are design detail | Captures enough to route and answer without overloading the form |
| ODM-16 | Official number | Use a dedicated RFI numbering stream; allocate only on successful first formal submission; never reuse an issued number. Recommend project-scoped uniqueness unless the existing approved numbering baseline and legacy inventory require a wider scope | Owner decision on uniqueness scope and display pattern | Exact prefix/year/sequence format must follow baseline and collision inventory; do not invent it in implementation |
| ODM-17 | Attachments and evidence | Preserve immutable submitted manifests and attributable versions; enforce per-file server-side authorization; require a separate security/storage design for size/type/scanning/retention before any upload implementation | Owner decision on evidence policy; security/storage specifications require separate technical approval | Protects evidence integrity and prevents a URL or Transmittal from becoming an access grant |
| ODM-18 | Formal distribution | Use controlled Transmittal for formal external response distribution; any permitted internal issue-only route must still preserve exact response version and recipient authorization | Owner decision | Applies DEC-050/051 without assuming every internal workflow event is a formal distribution |
| ODM-19 | Recipient acknowledgement | Require acknowledgement only for recipients explicitly designated as requiring it; track delivery, access, acknowledgement and substantive response separately per recipient | Owner decision on recipient classes and wording; event aggregation is design detail | Prevents silence or acknowledgement from being treated as technical acceptance |
| ODM-20 | Status vocabulary and aggregation | Approve a small RFI-specific lifecycle vocabulary only after the transition model is settled; keep workflow state separate from workload, overdue, delivery and acknowledgement indicators | Owner decision on lifecycle states; labels, filters and aggregation logic are design detail | Prevents dashboard indicators from becoming unintended workflow states |
| ODM-21 | Notifications and escalation | Notify only currently authorized, relevant recipients for defined events; no default reminder cadence or escalation threshold until approved; escalation never transfers authority | Owner decision on actionable events/cadence/escalation; templates and deduplication logic are design detail | Applies DEC-049 while keeping RFI rules independent of WIR reminder policy |
| ODM-22 | Reports, exports and retention | Provide permission-filtered, reproducible register/report exports with requester, filters, timezone and as-of cut-off; retention and scheduled external distribution require separate approval | Owner decision on retention and scheduled distribution; report layout is design detail | Preserves confidentiality and reproducibility; reports do not alter source records |

### Decisions that should be confirmed first

To avoid approving dependent details prematurely, confirm the following in order:

1. **Operating authority:** ODM-01 through ODM-07.
2. **Lifecycle and closure:** ODM-08 through ODM-14.
3. **Document control and distribution:** ODM-15 through ODM-19.
4. **Monitoring and records:** ODM-20 through ODM-22.

### Matters that should remain outside this approval

Even if the owner approves the design recommendations above, that approval alone must not authorize database/schema changes, migrations, generated types, Storage/upload implementation, authentication/authorization/RLS changes, production-data operations, deployment, or merge. Those require a separate implementation plan, impact review, backup/rehearsal controls where applicable, and explicit authorization.

## 14. Proposed RFI lifecycle state machine — detailed design recommendation

**Status:** Proposed detailed design under approved DEC-104; the vocabulary and transition table below are not yet separately owner-confirmed. This section defines a recommended RFI-specific workflow model for review. It does not authorize implementation.

### 14.1 Design principles

1. The RFI lifecycle status describes the current controlled workflow stage of the RFI, not every task, recipient event, deadline, or dashboard condition.
2. One RFI has one current lifecycle status and one official identity. Multidisciplinary contributions and individual assignments have their own subordinate states and do not create multiple parent RFIs.
3. Every transition is an attributable, authorized event with a trusted server timestamp, actor, effective party/assignment, reason where required, prior state, new state, cycle/version reference and immutable audit record.
4. A formal response is not issued until all required contributions, conflict resolutions and mandatory reviews are complete and an authorized issuer performs the issue action.
5. The preferred terminal transition is formal issue and closure in one controlled transaction. The issued response, closure event and exact response version must be preserved together.
6. Exceptional withdrawal and administrative cancellation are separate from technical resolution. Neither is an engineering answer, and neither deletes the record or releases its official number for reuse.
7. Reopening creates a new response cycle. It does not rewrite the previously issued response, prior cycle or closure event.
8. Delivery, access, acknowledgement, substantive recipient response, overdue, workload, and notification conditions are separate indicators/events, never parent lifecycle statuses.

### 14.2 Recommended parent RFI status vocabulary

| Status | Meaning | Entry condition / responsible authority | Exit condition |
|---|---|---|---|
| **Draft** | Unsubmitted working content visible only to the originating party and authorized oversight exception | Originator creates an internal draft; no official RFI number exists | Successful formal submission, or draft abandonment under draft-retention policy |
| **Abandoned (draft record state)** | Originator has abandoned an unsubmitted draft; this is not a status of an officially numbered RFI | Originator abandons before successful formal submission; no official number exists or is consumed | Terminal for that draft record; exclude it from the official RFI register and lifecycle counts unless a separately approved draft metric includes it |
| **Submitted** | Formal submission has succeeded and the official RFI identity has been allocated | Server validates required fields, originator authority and submission snapshot; allocate the official number only on successful first submission under DEC-022-A | Coordinator takes ownership for completeness/routing |
| **Under Coordination** | Administrative completeness, classification, discipline routing and assignment setup are in progress | Designated RFI coordinator accepts the submitted item | Complete and routed to technical assessment; or returned for administrative completion |
| **Returned for Completion** | The submission requires missing or invalid administrative/form information before technical assessment can proceed | Coordinator records specific deficiencies and returns it to the originator; this is not an engineering response | Originator resubmits the required completion; return to Under Coordination |
| **In Technical Assessment** | Assigned discipline responders are preparing scoped technical contributions and the technical lead is managing technical work | Coordinator completes routing; designated technical lead/discipline assignments are active | Required contributions are complete and ready for consolidation/review; or a technical clarification is requested |
| **Awaiting Originator Clarification** | Technical participants need a specific clarification from the originator to continue the current assessment | Assigned technical responder or technical lead requests clarification with a recorded question and scope | Originator supplies clarification; resume the recorded prior active stage without erasing prior work |
| **Under Consolidation** | The technical lead is assembling the scoped discipline contributions into one authoritative response and resolving or escalating conflicts | Required contributions are received, or the technical lead has sufficient contributions to begin controlled consolidation under the approved routing plan | Consolidated response is ready for any mandatory independent review; or returned to technical assessment for additional work |
| **Under Independent Review** | A frozen response version is undergoing an independent review required by the approved risk/authority matrix | Authorized reviewer, different from the author where separation applies, accepts the exact review version | Review passes to Ready for Issue; or review requires changes and returns to the appropriate technical preparation stage |
| **Ready for Issue** | All required contributions, conflict resolution and mandatory reviews have passed; the controlled response package is frozen for issue | Technical lead confirms readiness and the required review gate is satisfied | Authorized technical issuer formally issues the response; issue and closure occur atomically |
| **Closed** | The authorized formal engineering response has been issued and the RFI's current response cycle is technically closed | Successful authorized issue transaction; exact issued response version and closure event are recorded together | May remain closed, or be reopened by designated technical authority into a new response cycle |
| **Withdrawn** | The originator's pre-issue withdrawal request has been validated and accepted by the authorized records/workflow authority | Reason recorded; technical-lead concurrence obtained if substantive technical work had begun | Terminal for that RFI identity; any later inquiry is a new linked RFI |
| **Cancelled** | The RFI identity is administratively cancelled for an evidenced administrative reason such as duplicate or invalid registration | Designated records/workflow authority approves; technical-lead concurrence obtained if technical work had begun | Terminal for that RFI identity; retain number and full history |

**Vocabulary exclusions:** Do not add generic WIR outcomes such as Accepted, Rejected, Approved with Comments, Not Ready, or A/B/C/D/E/I as RFI lifecycle states. Do not add Overdue, Partially Delivered, Acknowledgement Pending, Viewed, Unread, Escalated, or Awaiting Transmittal as parent RFI lifecycle statuses.

### 14.3 Transition table and guards

| From | To | Authorized trigger | Mandatory guard |
|---|---|---|---|
| Draft | Submitted | Originator submits | Server-side originator capability check; required fields and attachment manifest validated; immutable submission snapshot created; official number allocated only after successful submission |
| Submitted | Under Coordination | Designated coordinator accepts/routs | Coordinator assignment is valid and within project/party scope |
| Under Coordination | Returned for Completion | Coordinator returns administrative deficiencies | Specific missing/invalid items and reason recorded; no technical disposition implied |
| Returned for Completion | Under Coordination | Originator resubmits completion | Resubmission is attributable; preserve prior submission and return events |
| Under Coordination | In Technical Assessment | Coordinator completes routing | Required disciplines and named technical lead are assigned within authorized scope |
| In Technical Assessment | Awaiting Originator Clarification | Assigned technical responder/technical lead requests clarification | Exact question, scope, requester and affected contribution recorded; prior work retained |
| Awaiting Originator Clarification | In Technical Assessment | Originator provides clarification | Clarification is linked to the open request; resume the recorded stage; no silent replacement of original question |
| In Technical Assessment | Under Consolidation | Technical lead confirms all required contributions are complete, or an individual assignment has been formally removed/waived by an authorized actor | Every required discipline contribution is attributable; every removed/waived assignment has a recorded authority, scope and reason; no required contribution remains outstanding; all technical conflicts have a named resolution path |
| Under Consolidation | In Technical Assessment | Technical lead returns for further technical work | Specific gap/conflict and required discipline action recorded |
| Under Consolidation | Under Independent Review | Technical lead submits frozen response version for required review | Independent review is required by approved matrix; reviewer is authorized and satisfies separation-of-duties |
| Under Consolidation | Ready for Issue | Technical lead confirms no independent review is required | All required contributions complete; every technical conflict is resolved by an authorized technical authority (escalation alone is insufficient); no mandatory review outstanding |
| Under Independent Review | Ready for Issue | Authorized reviewer passes the exact frozen response version | Review outcome and reviewed version recorded; no unresolved blocking comments; the response content remains unchanged after review |
| Under Independent Review | Under Consolidation | Reviewer requires consolidation/rewording or any response-content change | Review comments and reviewed version preserved; create a new candidate version; the prior review does not approve the changed version and a new review is required whenever the approved review trigger still applies |
| Under Independent Review | In Technical Assessment | Reviewer requires substantive discipline rework | Required discipline and technical reason recorded; previous contributions/review retained |
| Ready for Issue | Closed | Authorized technical issuer issues formal response | Issuer capability and assignment valid; exact response version frozen; issue event and closure event commit atomically; subsequent delivery/access/acknowledgement are independent recipient events under DEC-050/051/052/103 and cannot roll back technical closure |
| Draft record | Abandoned draft record | Originator abandons an unsubmitted draft | No official number is allocated or consumed; apply the approved draft-retention policy; do not record this as formal RFI withdrawal or as a transition of an official RFI |
| Submitted / Under Coordination / Returned for Completion / In Technical Assessment / Awaiting Originator Clarification / Under Consolidation / Under Independent Review / Ready for Issue | Withdrawn | Originator requests withdrawal; authorized records/workflow authority validates | Must occur before formal response issue; reason recorded; technical-lead concurrence required after substantive work begins; preserve all work and official number |
| Submitted / Under Coordination / Returned for Completion / In Technical Assessment / Awaiting Originator Clarification / Under Consolidation / Under Independent Review / Ready for Issue | Cancelled | Authorized records/workflow authority approves administrative cancellation | Evidenced duplicate/invalid-registration reason; technical-lead concurrence if technical work began; never use cancellation to express an engineering answer |
| Closed | In Technical Assessment | Designated technical authority reopens | Recorded reason, authority and new response-cycle identifier; prior issued response/closure remain immutable; new work/review required as applicable |

### 14.4 Reopening and response-cycle behavior

- Reopened is an immutable event and cycle relationship, not a separate long-lived parent status. The active parent status becomes **In Technical Assessment** for the new cycle.
- Each response cycle has a unique cycle identifier, opening actor/time/reason, scope of reopened issue, linked prior issued response, assignments, contributions, reviews and eventual issue/closure.
- The prior response remains issued and historically closed. A new cycle must never overwrite, revoke silently, or relabel the prior response.
- If the follow-up is only explanation of the already issued answer and does not require changing the controlled engineering answer, record it as a clarification event under the approved clarification rule. If the engineering answer must change, use the authorized reopening/new-cycle route. If the new inquiry is materially independent, create a new linked RFI instead.
- Withdrawal and cancellation are not permitted after formal response issue. A closed RFI may be reopened only by the designated technical authority; it cannot be converted to Withdrawn or Cancelled to erase the issued history.

### 14.5 Parent status versus subordinate assignment states

The parent RFI status must not attempt to encode every discipline's progress. Each discipline assignment should independently track at least:

- Assigned — authorized responder and scope appointed.
- Accepted — responder acknowledges the assignment.
- In Progress — substantive work started.
- Clarification Requested — responder is waiting for a defined input, if applicable to that assignment.
- Contribution Submitted — attributable contribution/version submitted.
- Changes Requested — lead/reviewer requires a specific update.
- Completed — contribution accepted into the consolidated response scope by the authorized technical lead.
- Reassigned/Cancelled — only by an authorized assignment controller, with reason and immutable prior assignment history.

The parent status is derived from controlled workflow gates and the technical lead's authorized stage transition; it is not a naive majority or average of assignment states. One completed discipline cannot make the RFI ready for issue while another required contribution remains outstanding.

### 14.6 Independent indicators, clocks and recipient events

Keep the following outside the parent lifecycle state:

- **Overdue:** derived by comparing an approved assigned target date against the applicable project calendar/timezone and current time. Requested date alone does not make an RFI overdue. Due-date expiry never closes, cancels, withdraws or automatically escalates an RFI.
- **Workload queues:** counts of outstanding assignments, contributions, clarification requests, consolidation tasks and reviews. Each metric declares its count unit, population, timezone and as-of cut-off as already proposed in §3B.
- **Transmittal delivery:** recipient-level delivery and aggregate result under DEC-050 and DEC-103; never a parent RFI state.
- **Access and acknowledgement:** recipient-specific events under DEC-051/052; never technical approval or closure.
- **Substantive recipient response:** a separately recorded communication event; it does not silently modify the issued engineering response or reopen the RFI.
- **Notifications/escalations:** event-driven records under DEC-049; a notification does not grant access, change authority, complete an assignment or advance lifecycle state.

### 14.7 Required audit/event record

For each parent transition and material subordinate action, preserve at minimum:

- RFI identity, project/party scope, current cycle and formal revision where relevant;
- prior and new parent status, or prior/new assignment state;
- action/event type, actor, effective party, active assignment and authority/capability basis;
- trusted server timestamp and timezone representation;
- reason, scope, affected question/contribution/response version and linked clarification/review;
- exact attachment/evidence manifest references where applicable;
- notification and recipient event references without conflating delivery/access/acknowledgement;
- issue/closure transaction reference or reopening/withdrawal/cancellation approval reference.

Events are append-only from the business user's perspective. Corrections are made through attributable compensating events, never by editing historical transitions.

### 14.8 Acceptance scenarios for the state model

1. A draft has no official RFI number and is invisible to other parties except the approved oversight exception.
2. A successful formal submission allocates exactly one official RFI number; a failed submission allocates none.
3. Administrative incompleteness enters Returned for Completion and does not masquerade as technical rejection.
4. A multidisciplinary RFI remains In Technical Assessment while any required discipline contribution is outstanding.
5. A technical clarification request pauses the relevant work stage visibly, preserves all prior contributions, and resumes the recorded stage when answered; no SLA pause is inferred without project approval.
6. The technical lead cannot advance to Ready for Issue while required contributions or unresolved conflicts remain.
7. Independent review is required only when the approved project matrix triggers it; the response version reviewed is exactly the version presented for issue unless a new review is completed.
8. A review change request returns the RFI to the appropriate preparation stage and preserves the rejected review version and comments.
9. Only the assigned technical issuer can issue; unauthorized attempts are denied server-side even if a UI control is exposed.
10. Formal issue and closure are atomic; a failed issue transaction leaves the RFI unclosed and does not expose a partially issued response.
11. Delivery failure, access, acknowledgement, recipient silence or originator acceptance cannot close or approve the RFI.
12. Withdrawal after substantive technical work requires recorded technical-lead concurrence; the RFI number and all work remain preserved.
13. Cancellation requires an evidenced administrative reason and cannot be used as an engineering disposition.
14. Reopening creates a new response cycle and leaves the prior issued response and closure unchanged.
15. Due-date expiry changes only the overdue indicator; it does not change the parent lifecycle state or automatically escalate.
16. A materially independent follow-up becomes a new linked RFI rather than silently expanding the closed RFI's scope.

### 14.9 Open detailed-design checks

Before this model is transferred into the authoritative governance proposal, confirm the exact role/capability names and assignment authority, whether the coordinator may return incomplete submissions, the precise review-trigger matrix, the response-version/revision relationship, the permitted withdrawal window once issue preparation has begun, and the exact project calendar/timezone rules. These details must conform to DEC-104 and the existing approved governance baseline.

**Implementation boundary:** This is a proposed detailed state model only. No RFI status/API/UI/code, workflow engine, database/schema/enum/function/trigger, migration, generated type, Storage, authentication/authorization/RLS/grant, production data, live workflow test, merge or deployment change is authorized. A separately reviewed implementation plan and explicit owner authorization remain mandatory.


## 15. State-model consistency audit and refined transition guards

**Status:** Detailed-design refinement under approved DEC-104. This section resolves internal consistency issues found during review of §14. It remains design documentation only and does not authorize implementation or amend the authoritative governance branch.

### 15.1 Draft record versus official RFI lifecycle

- **Draft** and **Abandoned** describe the originating party's unsubmitted draft record. A draft has no official RFI identity and is not part of the official RFI lifecycle register.
- Successful first formal submission creates the official RFI identity and enters the official lifecycle at **Submitted**. The official number is allocated only on that successful transaction under DEC-022-A.
- Abandoning a draft is not withdrawal of a submitted RFI. Draft retention, deletion/archival timing and draft metrics remain subject to the applicable records/privacy policy; no retention period is invented here.

### 15.2 Returned-for-completion and revision integrity

- **Returned for Completion** is an administrative return after an official RFI identity has been allocated. The return event must identify each missing or invalid administrative/form item and must not be presented as an engineering rejection or technical response.
- The official RFI number is retained. A return does not itself increment the formal revision.
- On resubmission, unchanged controlled content retains the same formal revision; a material change to controlled submitted content follows the sequential revision rules in DEC-022-B. Every submitted snapshot and return/resubmission event remains attributable and immutable.
- The detailed implementation design must distinguish administrative metadata completion from a material change to the controlled inquiry, and must not permit silent overwrite of a submitted snapshot.

### 15.3 Consolidation gate and discipline assignment changes

- The parent RFI may enter **Under Consolidation** only when all required discipline contributions have been submitted, or when a specific assignment has been formally removed/waived by an actor authorized to change the technical scope.
- Removing or waiving an assignment requires a recorded reason, affected discipline/scope, actor and authority. It must not be used to bypass a known unresolved technical conflict.
- A conflict is not resolved merely because it has been escalated. **Ready for Issue** requires an explicit resolution by the authorized technical authority and a preserved decision/reference. If the conflict remains pending, the RFI remains in the appropriate technical/consolidation stage.

### 15.4 Independent review and response-version freeze

- Independent review applies to one exact, frozen response version. The review record identifies that version and the reviewer.
- Any subsequent change to the reviewed response content creates a new candidate version. The prior review remains historical evidence but does not approve the changed version.
- Where the approved risk/authority matrix still requires independent review, the changed candidate must pass a new review before it can become **Ready for Issue**.
- Non-content packaging changes may be handled under a controlled rule, but must not alter the technical meaning or bypass required review.

### 15.5 Clarification concurrency and resumption

- Multiple clarification requests may exist concurrently at assignment/contribution level. Each request has its own scope, requester, target recipient, request/response events and completion state.
- The parent **Awaiting Originator Clarification** status applies while at least one clarification is formally blocking the next technical action. Answering one request does not resume the parent stage while another blocking clarification remains open.
- The workflow records the exact prior active stage and resumes only when all blocking clarification gates are satisfied. No SLA clock pause is implied by this status.

### 15.6 Issue, closure and distribution separation

- Authorized formal issue and technical closure are one atomic workflow outcome as recommended in §14. Delivery, access, acknowledgement and recipient response continue independently under DEC-050/051/052/103.
- A delivery failure or missing acknowledgement does not undo issue or reopen the RFI. A corrected distribution attempt is a recipient/distribution event, not a new technical response cycle.
- If the issue transaction fails, neither the formal issue nor closure is recorded as successful; the RFI remains **Ready for Issue** or returns to a controlled retry state without exposing a partially issued answer.

### 15.7 Refined acceptance tests

1. An abandoned draft has no official number and is excluded from the official RFI lifecycle register.
2. Administrative return preserves the official number and current revision unless controlled content is materially changed under DEC-022-B.
3. A resubmitted materially changed inquiry receives the next sequential revision; the prior snapshot remains retrievable and immutable.
4. Consolidation is blocked while any required discipline contribution remains outstanding, unless the assignment is formally removed by an authorized actor with a recorded reason.
5. Escalating a technical conflict without an authorized resolution cannot advance the RFI to **Ready for Issue**.
6. Any change to a reviewed response version invalidates the prior review as approval of that changed version.
7. One answered clarification does not resume the parent RFI while another blocking clarification remains outstanding.
8. Delivery failure or acknowledgement delay after formal issue does not reverse technical closure.

### 15.8 Remaining detailed-design dependencies

The following still require specification before transfer to the authoritative governance proposal: exact capability identifiers and appointment authorities; approved risk/authority review triggers; controlled-content classification for DEC-022-B revision decisions; project-specific calendar/timezone and target-date configuration; exact draft-record retention treatment; and the detailed event/metric mapping for concurrent assignments and clarification rounds.

**Implementation boundary:** No lifecycle code, API, UI action, workflow engine, database/schema/enum/function/trigger, migration, generated type, Storage, authentication/authorization/RLS/grant, production-data operation, live workflow test, merge or deployment is authorized. A separate implementation plan, security/impact review, test plan and explicit owner authorization remain required.


## 16. RFI action-level capability matrix

**Status:** Proposed detailed capability mapping under approved DEC-021 and DEC-104. This matrix separates responsibilities from permissions. It does not create role grants, activate role templates, settle all appointment authorities, or authorize implementation.

### 16.1 Authorization contract

Every RFI action must be evaluated server-side at action time against all applicable dimensions:

1. Authenticated actor and active account status.
2. Project membership and exact project scope.
3. Effective party and permitted cross-party relationship.
4. RFI visibility and confidentiality classification, including draft-originating-party restrictions.
5. Exact RFI identity, response cycle, revision, assignment and resource being acted upon.
6. Explicit capability for the requested action.
7. Current workflow state and permitted transition.
8. Assignment validity, discipline scope and delegated authority.
9. Separation-of-duties and conflict-of-interest rules.
10. Relevant evidence/version, recipient and records-control constraints.

A denial must be the default whenever any required condition is absent, expired, ambiguous or outside scope. A UI-hidden control is not an authorization control. Direct API/manual requests must receive the same server-side decision. A notification, Transmittal, roster entry, project title or read permission never grants an action capability.

### 16.2 Candidate responsibility-to-action matrix

Legend: **P** = may perform only when the corresponding explicit capability and scope are granted; **R** = read only within authorized visibility; **N** = no authority by this responsibility; **C** = conditional on a separate explicit delegation/approval. The legend describes candidate boundaries, not live grants.

| Action / capability | Originator | RFI coordinator | Discipline responder | Technical lead | Independent reviewer | Authorized issuer | Records / distribution controller | Project Manager oversight | System / roster administrator |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Create an RFI draft | P | N | N | N | N | N | N | N | N |
| View/edit own originating-party draft | P | N | N | N | N | N | N | R | N |
| Submit an RFI formally | P | N | N | N | N | N | N | N | N |
| View submitted RFI | P | P | P | P | P | P | P | R | N |
| Return for administrative completion | N | P | N | N | N | N | C | N | N |
| Assign coordinator / route administratively | N | C | N | C | N | N | C | N | N |
| Appoint discipline responders | N | C | N | C | N | N | N | N | N |
| Submit scoped discipline contribution | N | N | P | P only within own assigned technical scope | N | N | N | N | N |
| Request originator clarification | N | N | P within assigned scope | P | N | N | N | N | N |
| Respond to clarification | P | N | N | N | N | N | N | N | N |
| Consolidate technical contributions | N | N | N | P | N | N | N | N | N |
| Resolve technical conflict | N | N | N | C; only within delegated technical authority | N | C; within assigned authority | N | N | N |
| Perform mandatory independent review | N | N | N | N | P | N | N | N | N |
| Issue formal engineering response | N | N | N | N unless separately appointed as issuer | N | P | N | N | N |
| Request withdrawal | P | N | N | N | N | N | N | N | N |
| Validate/approve withdrawal | N | C | N | C when substantive work has begun | N | N | C only if formally delegated records authority | N | N |
| Approve administrative cancellation | N | C | N | C when technical work has begun | N | N | C only if designated authority | N | N |
| Reopen a closed RFI | N | N | N | C only if designated technical authority | N | C only if designated technical authority | N | N | N |
| Prepare / dispatch controlled Transmittal | N | C | N | N | N | N | P | N | N |
| Archive / classify records | N | N | N | N | N | N | P | N | N |
| Read audit history | P within own RFI scope | P within delegated scope | P within assigned scope | P within assigned scope | P for reviewed scope | P for issued scope | P within records scope | R within oversight scope | N by default |
| Change project roster | N | N | N | N | N | N | N | N | P only for roster administration |
| Change capability grants / workflow configuration | N | N | N | N | N | N | N | N | N by default; separate governed authority required |

**Interpretation notes:**

- The table does not mean every person in a named responsibility automatically receives the listed capability. Each **P** or **C** requires an explicit, scoped grant and, where applicable, an active appointment.
- The originator may submit and clarify their own inquiry but cannot appoint technical responders, edit another party's contribution, consolidate the authoritative answer, review their own response where independence applies, issue the engineering answer, or close the RFI.
- The coordinator's administrative routing/records scope does not confer technical decision authority. Any assignment or return capability must be explicitly delegated and must not be inferred from document-control job title.
- A discipline responder contributes only within the assigned discipline and scope. A responder does not alter another discipline's contribution or issue the consolidated answer merely because they are the most senior contributor.
- The technical lead consolidates and manages technical conflicts but cannot waive mandatory independent review or issue the response unless separately and validly appointed to that capability, and only where separation-of-duties permits.
- The independent reviewer reviews the exact frozen response version. Review authority is not issue authority.
- The authorized issuer must be explicitly assigned for the relevant technical scope. Distribution staff cannot issue or change technical content.
- Project Manager oversight remains read-only. It does not grant draft editing, submission, assignment, contribution, review, issue, withdrawal approval, cancellation, reopening or closure authority.
- System administrators and roster administrators receive no implicit document visibility, cross-party access, impersonation, capability-grant, workflow-bypass or engineering authority. Any exceptional administrative access requires a separate approved, auditable and narrowly scoped policy; none is assumed here.

### 16.3 Capability catalogue — separate grants, not bundled titles

The following capability families should be represented and governed independently. Exact machine identifiers and grant templates remain pending:

| Capability family | Candidate atomic actions | Scope that must be bound |
|---|---|---|
| Draft management | Create draft; view own-party draft; edit draft; abandon draft | Project, originating party, draft owner, draft identity |
| Formal submission | Validate and submit; resubmit returned completion | Project, originating party, RFI class, current draft/RFI, controlled snapshot |
| Visibility | View submitted RFI; view contribution; view response; view attachment; read audit | Party, project, RFI, cycle, revision, field/resource sensitivity |
| Administrative coordination | Accept coordination; return for completion; classify; route; appoint or change assignment where delegated | Project, party, discipline, RFI, assignment scope |
| Technical contribution | Accept assignment; request clarification; submit/update contribution; respond to assigned technical action | RFI, cycle, discipline, assigned scope, contribution version |
| Technical leadership | Appoint lead where delegated; consolidate; request rework; record conflict; resolve within authority; escalate | Project, RFI, technical domain, delegated authority |
| Independent review | Accept review; comment; pass; request changes; record review outcome | Exact frozen response version, review trigger, reviewer identity |
| Formal issue | Confirm readiness; issue response; create official issued response record | RFI, response version, discipline/package, issuer appointment |
| Exceptional lifecycle control | Validate withdrawal; approve cancellation; reopen closed cycle | RFI, exact lifecycle state, reason, designated authority |
| Distribution and records | Prepare Transmittal; dispatch; record recipient events; archive; retrieve; correct records through compensating event | Exact issued version, recipients, party scope, records classification |
| Oversight and audit | Read permitted register/dashboard; inspect authorized history; export authorized records | Project, permitted party/document scope, fields, purpose where required |
| Administration | Manage roster; propose capability grant; approve/revoke capability grant; change workflow configuration | Separate administrative scope and approval chain; never inferred from system/roster administration |

### 16.4 Separation-of-duties and combination controls

1. The same person may hold more than one responsibility only where the project capability policy explicitly permits the combination and the exact transaction passes all separation-of-duties checks.
2. Where independent review is required, the response author/consolidator cannot act as its independent reviewer. A reviewer cannot approve their own authored response by switching role labels.
3. A person who prepares a response cannot issue it where the applicable authority matrix requires distinct preparation and issue actors.
4. Combining coordinator and technical-lead responsibilities does not allow administrative completeness checks to become engineering decisions; the actor must act under the correct explicit capability and recorded capacity.
5. A technical lead who also holds issuer authority may issue only if the project-specific authority policy explicitly permits the combination and no mandatory independent review or other separation rule is breached.
6. Project Manager oversight cannot be combined with an implied workflow action. Any additional PM capability requires a separate explicit owner-approved rule and must not be inferred from the oversight exception.
7. No proxy signing, impersonation, shared account, hidden administrator bypass or retrospective reassignment may be used to make an otherwise unauthorized action appear valid.
8. Emergency access, break-glass procedure, delegation expiry, temporary acting appointments and conflict-of-interest substitution remain separate approval topics; no emergency bypass is proposed by this matrix.

### 16.5 Assignment and appointment invariants

- Every technical assignment identifies one RFI, cycle, discipline, contribution scope, assignee, assigning actor, effective time and any applicable target date.
- The assignment controller must have explicit authority for that project/party/discipline scope. Coordinator status alone is not sufficient unless that assignment capability is explicitly delegated.
- Assignment acceptance is an assignment event, not recipient acknowledgement under DEC-052 and not technical approval.
- Reassignment or cancellation preserves the previous assignee, assignment state, contributions, comments, evidence, timestamps and reason/authority where required. It does not transfer unrelated capabilities.
- The technical lead is explicitly named for every multidisciplinary RFI. A technical lead may not silently delete, rewrite or suppress a discipline contribution; correction is attributable and versioned.
- Removing a required discipline from scope requires a reasoned decision by the authorized technical authority and updates the required-contribution gate. It cannot be performed solely to make the RFI appear ready for issue.
- A reviewer and issuer must be appointed for the exact response scope/version where the applicable project authority matrix requires those appointments.

### 16.6 Denial and audit requirements

For every allow or deny decision, the system should retain enough evidence to reconstruct the decision, including actor, effective party, capability, resource, project/RFI/cycle/revision, assignment, workflow state, separation rule, policy/configuration version, decision timestamp and correlation reference. Denials should not reveal the existence or content of an RFI to an unauthorized party.

A denial must not be bypassed by direct URL, guessed identifier, export, attachment URL, notification preview, alternate endpoint, stale session, changed UI state or administrator role. Access to an attachment is checked against the exact file/version and parent RFI scope at each preview/download action.

### 16.7 Capability acceptance scenarios

1. Project membership without an explicit RFI capability does not permit draft creation, viewing or submission.
2. A contractor-originating party cannot view another party's draft or infer its existence through search, counts, notifications or exports.
3. A coordinator can return an administratively incomplete submission only when explicitly delegated; cannot issue or alter an engineering response.
4. A discipline responder cannot edit another discipline's contribution or issue the consolidated answer.
5. A technical lead cannot bypass a required discipline contribution or independent review.
6. An author/consolidator cannot perform a mandatory independent review of the same response version.
7. A reviewer cannot issue the response solely by virtue of review capability.
8. A records/distribution controller can dispatch an authorized issued version but cannot alter its technical content or infer approval from delivery.
9. A Project Manager can read only the oversight scope and cannot perform workflow actions through direct API requests.
10. A system/roster administrator cannot gain cross-party document access, impersonate a participant or bypass workflow authorization.
11. A reassigned responder loses future action authority for the old assignment while historical contributions and events remain attributable.
12. A capability revoked or assignment expired before an action is evaluated as inactive at action time; historical actions remain preserved.
13. A direct API call, export, attachment URL or notification preview is denied when the same actor lacks the underlying resource/action authorization.
14. Any permitted combination of roles is rejected when it violates the active separation-of-duties rule for the exact transaction.

### 16.8 Open approval and detailed-design dependencies

Before this matrix is transferred to the authoritative governance proposal or implementation plan, specify and approve: exact capability identifiers; who may grant/revoke each capability; coordinator appointment and assignment delegation authority; technical lead and issuer appointment authority; project-specific independent-review triggers; permitted role combinations; conflict-of-interest substitution; emergency access/break-glass controls; delegation expiry; denial logging and audit retention; and the exact PM oversight scope.

**Implementation boundary:** This is a proposed action-level capability design only. It does not activate grants, role templates or access policies. No authentication/authorization/RLS/grant, API, UI, database/schema, migration, generated type, Storage, production-data, live workflow test, merge or deployment change is authorized. A separate security/impact review, implementation plan, test plan and explicit owner authorization remain mandatory.


## 17. RFI discipline assignment, technical leadership and independent review matrix

**Status:** Proposed detailed-design recommendation under DEC-021 and DEC-104. This section defines how the required technical scope is identified, assigned, contributed, consolidated and independently reviewed. It does not appoint real project personnel, activate discipline grants, or authorize implementation.

### 17.1 Discipline taxonomy and project applicability

Use a controlled project discipline catalogue. The initial candidate catalogue for SiteDocs is:

| Code | Discipline | Scope note |
|---|---|---|
| ARC | Architectural | Architectural design, finishes, envelope/interfaces where assigned |
| CIV | Civil / Structural | Civil and structural engineering grouped as one controlled discipline for the current SiteDocs taxonomy |
| MEC | Mechanical | HVAC, plumbing, firefighting and other mechanical systems as configured in the project discipline scope |
| ELE | Electrical | Power, lighting, ELV and other electrical systems as configured in the project discipline scope |
| SURVE | Survey | Setting-out, coordinates, levels, as-built and survey-control matters |

The catalogue is a controlled project configuration, not a claim that every project uses every discipline or that every RFI requires multiple disciplines. Project-specific sub-disciplines may be recorded as scoped specialties under a parent discipline where approved; they must not create duplicate or conflicting parent identities. Civil and structural remain one combined CIV discipline in this initial catalogue; a project cannot silently create separate CIV/STR identities in the RFI register.

### 17.2 Identifying required disciplines

1. The originator selects one primary discipline and may propose related disciplines at draft stage. These selections are proposals, not assignments and do not determine technical ownership.
2. During triage, the authorized RFI coordinator checks completeness and routes the inquiry to the designated technical lead or authorized technical-scope decision maker. The coordinator may not decide technical applicability solely by administrative judgment.
3. The technical lead or delegated technical authority records the required discipline set, the reason for each inclusion, and any explicitly excluded discipline where the inquiry presents a credible interface.
4. The required set is based on the actual question, affected design/system/location, referenced documents, interfaces and potential technical consequences—not merely the originator's selected label.
5. A single-discipline RFI remains valid where one discipline fully owns the technical question. Multidisciplinary handling is required where a material interface or dependency requires input from more than one discipline.
6. Where scope is disputed, the issue is referred to the designated technical authority. It cannot be resolved by hiding a discipline, removing its assignment or advancing the RFI to consolidation.
7. Any later change to the required discipline set is a controlled, attributable scope decision. Preserve the prior set, actor, time, reason, affected assignments and downstream effect on due dates/review gates. Do not silently rewrite the original routing history.

### 17.3 Appointment and assignment sequence

| Step | Responsible function | Required record / control | Prohibited shortcut |
|---|---|---|---|
| 1. Originator proposes scope | Originator | Primary discipline, proposed related disciplines, question and affected location/system where known | Treating the originator's selection as final technical routing |
| 2. Administrative intake | RFI coordinator | Completeness, project/party eligibility, missing information and routing event | Making engineering scope decisions under an administrative title |
| 3. Technical ownership and lead appointment | Designated project technical authority | Named technical lead, discipline scope, appointment authority and effective time | Self-appointment or appointment by an unauthorized coordinator |
| 4. Required discipline determination | Technical lead / delegated authority | Required discipline set, inclusion rationale, exclusions and interface notes | Removing a relevant discipline merely to meet a target date |
| 5. Discipline responder assignment | Explicitly authorized assignment controller | One or more named responders per required discipline, scope, assignment version and target date if configured | Assigning an entire party/team without an accountable assignee |
| 6. Contribution | Assigned discipline responder | Attributable contribution, references, assumptions, constraints, conflicts and response version | Editing another discipline's contribution |
| 7. Consolidation | Technical lead | Consolidated response, contribution-to-answer traceability and conflict disposition | Silently rewriting, dropping or misattributing a contribution |
| 8. Independent review, if triggered | Separately appointed reviewer | Trigger, reviewer independence, exact frozen response version and outcome | Self-review or review of a different version |
| 9. Formal issue | Authorized issuer | Issuer authority, exact response version and formal issue event | Treating coordinator, reviewer or distribution controller as issuer by default |

### 17.4 Assignment granularity and multiple responders

- The minimum technical assignment unit is **RFI × response cycle × discipline × defined contribution scope**. A discipline may have more than one responder only where the technical lead records distinct scopes or an explicit co-contribution arrangement.
- Each assignment has one accountable lead responder. Additional contributors may be associated with that assignment, but the system must distinguish accountable responder from supporting contributor.
- Assignment scope must be concrete enough to identify the expected input (for example, a drawing/package/interface/location or a specific technical question). Broad labels such as "review all" should not replace a defined scope.
- A responder may submit a contribution, request clarification within their assigned scope, or record that the question is outside their scope with a reason. They may not close the parent RFI or waive another discipline's input.
- A contribution may be returned for clarification/rework by the technical lead within the documented scope. The prior contribution and comments remain preserved; a replacement contribution is a new attributable version/event.
- If an assignee is unavailable, conflicted or incorrectly assigned, reassignment follows §16.5. A replacement assignee receives authority prospectively for the active assignment; previous contributions remain attributed to their original author.
- An assignment being accepted, opened or acknowledged does not count as a technical contribution or a completed response.

### 17.5 Technical lead selection and conflict resolution

- Every multidisciplinary RFI must have one named accountable technical lead for consolidation. The lead is selected by the designated project technical authority based on the dominant technical subject, interface ownership and delegated authority—not automatically by the originator, coordinator, most senior person or first responder.
- Where no discipline clearly owns the interface, the designated project technical authority appoints a lead and records the rationale. The lead coordinates, but does not acquire authority over another discipline's professional conclusion.
- Each discipline contribution remains separately attributable and visible to authorized participants. The consolidated answer must identify material assumptions, constraints, interfaces and unresolved matters.
- A conflict is classified as: (a) wording/interpretation inconsistency that can be reconciled by the lead within delegated authority; (b) cross-discipline technical conflict requiring the designated technical authority; or (c) scope/design decision beyond the lead's authority requiring escalation to the appropriate project design authority.
- The lead records the conflicting positions, affected disciplines, evidence/references, decision-maker and resolution. A conflict is not closed by majority vote, silence, administrative deadline expiry or omission from the consolidated answer.
- If the conflict remains unresolved, the RFI remains in the technical assessment/consolidation stage or another explicitly configured blocked state. It cannot become Ready for Issue.
- A technical decision that changes the original inquiry materially may require a clarification/new linked RFI decision under §6A; the lead must not expand the scope invisibly.

### 17.6 Independent review trigger model

Independent review is required only when a pre-approved project risk/authority matrix or governing project requirement says it is required. The following are **candidate trigger categories for owner/project approval**, not automatically active rules:

| Candidate trigger | Why independent review may be required | Candidate review scope |
|---|---|---|
| Life-safety, fire/life-safety or statutory compliance impact | High consequence if the answer is wrong | Affected discipline and interfaces |
| Structural integrity, stability or significant loading/interface impact | Potential safety and asset-integrity consequence | CIV and affected interfacing disciplines |
| Material departure from approved design basis, specification or contractual technical requirement | May change a controlled design premise | Affected design authority and relevant discipline |
| Multi-discipline conflict or unresolved interface with significant technical consequence | Risk of contradictory instructions | All affected discipline contributions and consolidated answer |
| High-risk temporary works, construction methodology or sequence where the RFI answer directs execution | Potential construction-stage safety/quality impact | Responsible technical discipline and relevant temporary-works authority |
| Repeated or reopened RFI after a material technical answer change | Prior answer/review may no longer be valid | Changed response version and affected interfaces |
| Explicit contract, client, authority or project quality-plan requirement | External/project governance requires review | Exact required reviewer and technical scope |

Review trigger logic must be explicit and reproducible: trigger code, source policy/version, affected scope, required reviewer qualification/appointment, independence test, and whether review is mandatory or advisory. The system must not infer triggers from free-text keywords alone as the final authority; automated suggestions may flag a candidate for authorized confirmation.

### 17.7 Reviewer appointment, outcome and re-review

1. The reviewer is appointed by the authority designated in the project risk/authority matrix. The technical lead may propose a reviewer but cannot self-approve the appointment unless separately delegated.
2. The reviewer must have the required discipline/technical competence and active project appointment for the exact scope.
3. Where independent review is mandatory, the reviewer must be different from the response author and any person whose participation would breach the applicable separation rule. A role switch or alternate account does not establish independence.
4. Review applies to one frozen consolidated response version and its identified supporting evidence. The review record includes trigger, scope, version/hash or equivalent immutable version reference, reviewer, outcome, comments, timestamp and policy version.
5. Candidate review outcomes are **Reviewed — No Blocking Comment**, **Changes Required**, and **Unable to Review / Out of Scope**. These are review outcomes, not engineering response codes and not final RFI lifecycle states.
6. **Changes Required** returns the response to consolidation with comments and affected scope. The changed response becomes a new candidate version; prior review remains historical and cannot approve the changed content.
7. **Unable to Review / Out of Scope** requires reassignment or a revised scope decision; it does not count as a passed review.
8. A reviewer may identify a technical concern, but does not replace the authorized technical lead or issuer. Any technical decision arising from the review must be attributed to the actor with the relevant authority.
9. If no mandatory review trigger applies, the workflow may proceed without independent review only after the trigger evaluation is recorded. Absence of a reviewer assignment is not evidence that review was unnecessary.

### 17.8 Re-review and scope-change rules

- A change to technical meaning, assumptions, design direction, discipline conclusion, response recommendation or material supporting evidence after review creates a new response candidate and requires re-review whenever the original trigger still applies.
- Pure formatting or non-substantive packaging changes may retain the prior review only under an approved, explicit classification rule, with a recorded comparison and confirmation that technical meaning and evidence are unchanged.
- Adding/removing a required discipline, changing the technical lead, resolving a previously open conflict or changing the answer after review requires impact assessment and re-review of affected scope; the authority matrix determines whether the entire consolidated answer or only affected portions must be reviewed.
- A new clarification after formal issue does not silently alter the issued answer. If it changes technical direction, use the approved reopen/new-linked-RFI path and repeat applicable review/issue gates.

### 17.9 Acceptance scenarios

1. An originator selecting ARC does not prevent the technical authority from adding CIV and ELE where the question materially affects those disciplines.
2. A coordinator cannot add or remove a discipline as a technical decision without delegated authority.
3. A multidisciplinary RFI cannot enter consolidation while a required discipline contribution is outstanding, unless that assignment is formally removed by the authorized technical authority with a recorded reason.
4. A single-discipline RFI does not receive artificial assignments merely to satisfy a fixed multi-discipline template.
5. A discipline responder cannot modify another discipline's contribution or claim completion for its scope.
6. A technical lead is named and attributable; a multidisciplinary RFI cannot progress to consolidation without one.
7. An unresolved conflict cannot be bypassed by escalation alone, majority preference, silence or omission.
8. A reviewer who authored or consolidated the same response is rejected where independent review is mandatory.
9. A review outcome applies only to the exact frozen response version identified in the review record.
10. A material post-review change invalidates the prior review as approval of the changed response.
11. A reviewer marked Out of Scope does not satisfy the mandatory review gate.
12. A project requirement triggers independent review even if the RFI is otherwise low-volume or administratively complete.
13. An untriggered review is skipped only after an attributable trigger assessment is recorded.
14. Reassignment preserves previous contributions and actor history and does not transfer the previous assignee's identity or actions to the replacement.
15. Removing a discipline requires authority and rationale and cannot be used solely to bypass a blocking contribution or review.

### 17.10 Remaining approval points

Before promotion to the authoritative governance proposal, the owner/project must confirm: exact discipline catalogue and sub-discipline policy; technical authority responsible for lead appointment; assignment-controller delegation; criteria for single versus multidisciplinary classification; required responder cardinality and accountable lead rules; conflict decision authority and escalation destination; approved review trigger matrix and reviewer qualification; reviewer appointment authority; review outcomes and scope of re-review; and project-specific handling of temporary works, statutory/client requirements and exceptional urgent responses.

**Implementation boundary:** This section is proposed design only. It does not appoint actual personnel, create assignment records, activate reviewer rules, grant capabilities, or authorize RFI lifecycle implementation. No API, UI, workflow engine, database/schema, migration, generated type, Storage, authentication/authorization/RLS/grant, production-data operation, live workflow test, merge or deployment is authorized.


## 18. RFI identity, numbering, revisions and evidence integrity

**Status:** Proposed RFI-specific control design. It applies the approved common numbering and revision components DEC-022-A and DEC-022-B without treating the wider DEC-022 lifecycle proposal as approved. The exact RFI numbering pattern, clarification/revision boundary, attachment policy and retention rules remain subject to owner/project approval. No implementation is authorized.

### 18.1 Separate identity layers

The design must keep the following identifiers distinct and explicitly related:

| Identity | Purpose | Allocation / stability rule |
|---|---|---|
| Internal draft ID | Private system tracking before formal submission | Created at draft creation; never presented as an official RFI number |
| Official RFI number | Stable identity of the formal engineering inquiry | Allocated once, on first successful formal submission; remains stable across the same RFI's controlled history |
| Response/document revision | Identifies a controlled content version where the RFI profile requires formal revision | First formal issue is Rev.00; controlled-content correction after return increments sequentially under DEC-022-B |
| Clarification round ID | Distinguishes a request/response exchange seeking clarification without silently changing the controlled RFI identity | Separate sequence/reference; does not itself consume a document revision |
| Contribution ID/version | Identifies one discipline's attributable technical input and its successive versions | Scoped to RFI, response cycle, discipline and assignment |
| Response candidate/version | Identifies a consolidated technical answer before formal issue | Frozen version reference for review; a material change creates a new candidate |
| Attachment/evidence ID and version | Identifies an uploaded evidence object and each preserved replacement/version | Stable object identity plus immutable version identity; never overwrite prior submitted evidence |
| Transmittal ID | Identifies a controlled distribution package/event | Separate from RFI number, revision and clarification round |

No identifier may be reused as a substitute for another. In particular, a clarification-round number is not a revision, a response candidate is not an issued response, and a Transmittal is not an RFI.

### 18.2 Official RFI numbering

1. Maintain an RFI-specific numbering stream distinct from WIR and all other document families, consistent with DEC-002.
2. At draft creation, issue only an internal draft ID. Allocate the official RFI number only inside the successful first formal-submission transaction, after validation and authorization pass, consistent with DEC-022-A.
3. A failed validation, abandoned draft, saved draft, draft attachment upload or unsuccessful submission attempt consumes no official RFI number.
4. Once allocated, the official RFI number is permanent and must not be recycled, including where the RFI is later withdrawn, cancelled or closed.
5. Concurrent submissions must be allocated atomically so two successful first submissions cannot receive the same official number within the approved uniqueness scope. A uniqueness check performed only in the client or before the committing transaction is insufficient.
6. The number must not encode mutable attributes such as current assignee, technical lead, current status, response outcome or current discipline scope. Reassignment or a justified discipline-scope change must not change the RFI identity.
7. Do not infer the display pattern. Prefix, project identifier, year element, sequence width, reset cadence, organization-wide versus project-level uniqueness, legacy collision handling and any permitted human-readable suffix remain owner decisions.
8. A legacy RFI imported or registered after the system's launch must preserve its source reference and be mapped without colliding with newly allocated official numbers. The migration/mapping policy is not specified here and requires separate approval.

### 18.3 Clarification round versus formal revision versus linked new RFI

The classification must be based on controlled meaning and the approved RFI profile, not on a user's choice of label:

| Situation | Candidate treatment | Identity consequence |
|---|---|---|
| Originator supplies information specifically requested to explain or complete the existing inquiry, without changing its controlled question or scope | Clarification response event | Same official RFI number; separate clarification-round/event reference |
| Technical team asks a focused question to resolve ambiguity in the submitted inquiry | Clarification request and response round | Same official RFI number; clarification history remains attributable |
| Administrative correction that does not alter controlled technical content | Administrative correction event | Same RFI number and revision, subject to the approved correction rule |
| Controlled response content is returned for correction and then materially changed | Formal response revision under DEC-022-B | Same RFI number; next sequential revision; previous version remains immutable |
| Controlled content is resubmitted after return with no controlled-content change | Resubmission of the same revision under DEC-022-B | Same RFI number and same revision |
| Originator changes the technical question, affected design/location/system or requested decision so materially that it is no longer the same inquiry | Candidate new linked RFI, or another expressly approved RFI-specific revision path | Must not silently rewrite the submitted inquiry; exact classification rule remains open |
| A post-issue follow-up asks a genuinely new technical question | New linked RFI candidate | New official RFI identity on its successful first formal submission, with explicit relationship to the prior RFI |

**Classification safeguards:**

- Every classification records the actor, time, reason, prior and proposed scope/content references, and applicable policy version.
- The technical lead may recommend technical materiality within delegated authority; the designated authority under the RFI profile confirms disputed or consequential classifications.
- The coordinator may record an administrative correction but cannot label a technical change "non-material" merely to avoid a revision or review gate.
- Clarification must not be used to bypass a formal revision, required review, issuer authority or a new linked inquiry where the controlled meaning has changed.
- No rule in this draft decides whether every RFI-originator clarification changes the inquiry revision. That boundary, including question-side materiality and post-issue follow-up, remains an explicit owner approval point.

### 18.4 Revision and immutable snapshot rules

1. Apply DEC-022-B only within the approved RFI revision profile: first formal issue is Rev.00; a controlled-content change after return/correction creates the next sequential revision; resubmission without controlled-content change retains the same revision.
2. The official RFI number remains stable across revisions. Revision is a version of controlled content, not a new document identity.
3. Each formally submitted or issued revision preserves its own immutable snapshot of the controlled question/response content, metadata included in that revision, references, attachment manifest and relevant approval/review/issue events.
4. A new revision must not overwrite, delete, or relabel a prior revision. Prior review, approval, signature, issue and delivery events remain attached to the exact version on which they occurred.
5. No review, approval, signature or issue authority carries forward automatically to a changed revision. The new revision must pass the applicable gates again.
6. A resubmission with no controlled-content change may retain the same revision only when a comparison/attestation establishes that controlled content is unchanged. Any metadata-only or packaging-only exception must follow a separately approved classification rule; it is not assumed here.
7. The system should preserve both a human-readable revision summary and a machine-verifiable comparison/reference where available. The summary must identify changed sections/attachments and the reason without replacing the underlying snapshots.
8. Clarification events, discipline contribution versions, response candidate versions and formal document revisions remain separately represented and linked. A clarification round does not automatically increment Rev.; a formal revision does not erase clarification history.

### 18.5 Attachment and evidence classification

Candidate evidence classes should be explicit so access and version rules can be applied consistently:

| Evidence class | Examples | Required linkage |
|---|---|---|
| Originator inquiry evidence | Markups, photographs, sketches, referenced drawings, calculations supplied with the question | RFI, originating party, draft/submission snapshot, uploader and attachment version |
| Discipline contribution evidence | Discipline calculations, marked-up extracts, technical notes, interface details | Exact discipline assignment, contribution version, author and RFI response cycle |
| Consolidation evidence | Interface matrix, technical comparison, consolidated sketch or supporting calculation | Exact response candidate/version and technical lead |
| Review evidence | Reviewer comments, checklists, review notes and recorded outcome | Exact frozen response version, reviewer, trigger and review event |
| Issued response evidence | Signed/authorized response package and its controlled enclosures | Exact issued RFI revision/response version and issuer event |
| Distribution evidence | Transmittal manifest, recipient delivery events and acknowledgements | Exact Transmittal, recipient and issued package version |

An attachment's filename or folder location is not its identity. The controlled record must retain a stable attachment/evidence ID and a distinct immutable version reference.

### 18.6 Upload, replacement, integrity and access safeguards

- On upload, record uploader identity, party/project scope, timestamp, original filename, media type, byte size, storage/object reference, attachment class, parent record/version and a verified integrity digest or equivalent mechanism.
- Preserve the original bytes of every submitted or relied-upon evidence version. A replacement creates a new immutable version and an explicit supersedes/replaces relationship; it never overwrites evidence referenced by a submitted snapshot.
- Freeze the attachment manifest for each formal submission and each formal response issue. The manifest identifies exact attachment versions, not merely the latest file associated with the RFI.
- A file uploaded to a draft remains subject to originating-party draft visibility. Formal submission does not make every attachment public to every project member; each file and version is independently authorized.
- Discipline and review attachments inherit the scope of their exact contribution/review record and must not silently become originator evidence or an issued enclosure.
- Preview, download, export, direct-object retrieval and link access must re-evaluate current server-side authorization for the exact file version. A guessed URL, Transmittal reference or permission to view the RFI summary is not sufficient.
- Integrity verification must detect whether retrieved bytes match the recorded version reference. A mismatch is a records/security exception, not an ordinary replacement.
- Opening, previewing, downloading or uploading evidence does not constitute technical acceptance, review completion, acknowledgement, issue or closure.
- Malware scanning, quarantine, file type/size limits, preview/conversion, retention, legal hold, encryption/key management, storage region and deletion authority remain subject to a separate security/records design. This section does not authorize Storage implementation or deletion of evidence.

### 18.7 Controlled references and package manifests

1. A reference to a drawing, specification, submittal, WIR, RFI, Transmittal or external document must identify the exact source record and, where versioned, the exact revision/version relied upon.
2. A link to a changing "latest" document is insufficient as the sole evidence reference for a frozen RFI submission or issued answer. Preserve the version actually consulted or an immutable reference to it.
3. Related-record access is independently authorized. An RFI link does not confer access to a related WIR, drawing, submittal or another party's attachment.
4. The formal response package manifest identifies the exact RFI number, revision, issued response version, included evidence versions, issuer and intended recipients.
5. Recipient-level delivery and acknowledgement events follow DEC-103. Successful delivery, access or acknowledgement does not change the technical revision, constitute acceptance, or close the RFI.
6. If a package must be corrected after issue, preserve the original package and distribution events. Use an authorized correction/reissue or superseding-package event under the approved Transmittal policy; never silently replace the already distributed package.

### 18.8 Acceptance scenarios

1. Saving or uploading to an unsubmitted draft does not consume an official RFI number.
2. Two concurrent successful first submissions cannot receive the same number within the approved numbering scope.
3. An abandoned draft, failed validation or failed submission consumes no official number.
4. Withdrawal or cancellation does not make an allocated RFI number available for reuse.
5. Changing assignee, technical lead or discipline scope does not mutate the official RFI number.
6. A clarification round remains distinguishable from Rev.00/Rev.01 and from a Transmittal.
7. A controlled-content change after return increments the revision; unchanged resubmission retains the same revision, consistent with DEC-022-B.
8. A reviewer/approver event remains bound to the exact revision and cannot approve a later changed revision.
9. Replacing an attachment creates a new version and leaves the submitted/issued snapshot pointing to the earlier version.
10. A response attachment is linked to its contribution/response version and is not misrepresented as originator evidence.
11. A user with RFI summary visibility but no file permission cannot preview/download its restricted attachment.
12. A related-record URL does not bypass authorization for the referenced document or version.
13. An integrity mismatch is surfaced as an exception and does not silently substitute a file.
14. A corrected post-issue package preserves the originally issued package, its recipients and its delivery history.
15. Recipient delivery/acknowledgement does not alter technical response status or revision.

### 18.9 Remaining approval points

Before this section is promoted to authoritative governance, confirm: official RFI number format and uniqueness scope; legacy number collision/mapping policy; exact materiality test separating clarification, formal revision and new linked RFI; whether/how question-side changes are revised; metadata-only and packaging-only change treatment; exact revision snapshot boundary; attachment classes and mandatory metadata; integrity digest and malware-scanning requirements; file size/type/retention/legal-hold/deletion rules; exact referenced-document version policy; correction/reissue handling after formal distribution; and whether every formal RFI response must use a Transmittal.

**Implementation boundary:** Proposed design only. This section does not allocate live numbers, create revisions, store or replace files, change Storage policies, activate authorization, implement comparison/hash/scanning services, modify APIs/UI/workflow/database/schema/migrations/generated types/RLS/auth/grants, or operate on production data. A separate implementation plan and explicit owner approval remain mandatory.


## 19. RFI formal issue, recipient resolution and post-issue response controls

**Status:** Proposed RFI-specific distribution and post-issue control design applying owner-approved cross-document directions DEC-049, DEC-050, DEC-051, DEC-052 and DEC-103. It does not approve every RFI response as requiring a Transmittal, define contractual notice, or authorize a delivery channel or implementation.

### 19.1 Separate technical issue from distribution

1. Formal technical issue is an RFI source-workflow event performed only by the authorized issuer against the exact response version that has passed all applicable technical, conflict and independent-review gates.
2. A Transmittal is a separate controlled distribution record. It does not create, revise, approve or sign the RFI response, and it does not complete the RFI's technical workflow (DEC-050).
3. Recommend that the issued response package be distributed through a controlled Transmittal where formal cross-party distribution is required. Whether every RFI issue must always use a Transmittal remains an owner approval point; no informal channel is presumed approved by this draft.
4. Keep at least four separate facts: (a) technical response issued, (b) Transmittal dispatched, (c) technical delivery/access evidence, and (d) explicit acknowledgement or substantive response. None substitutes for another.
5. The issued response and its frozen evidence remain authoritative for the issue event even if distribution is delayed, partially delivered or fails. A delivery failure does not silently reverse the technical issue or authorize content edits.
6. A response may be technically issued while distribution remains pending or incomplete. Register/dashboard presentation must show these as separate dimensions and must not label the technical answer "unissued" solely because one recipient's delivery failed.

### 19.2 Formal response package and manifest

Before dispatch, prepare a controlled package manifest containing, at minimum:

- Official RFI identity and exact controlled revision/cycle, where applicable.
- Exact formally issued response version and issue event reference.
- Issuer identity, authority, party and issue timestamp/timezone.
- Exact included response files and evidence versions, with stable identifiers and integrity references.
- Referenced source documents and the exact versions relied upon, where included or required for traceability.
- Intended recipients resolved individually, their parties and authorized distribution scope.
- Per-recipient and, where necessary, per-manifest-entry response requirement: **Required**, **Optional**, or **Not Requested**.
- Stated purpose and delivery channel selected from separately approved project configuration.
- Any target response date clearly identified as tracking-only unless a separate approved contractual/SLA rule applies.

The manifest is frozen for the issued Transmittal. A change to recipients, included records, versions or other controlled manifest content that changes the issued package requires a new controlled Transmittal linked to the prior one; it must not mutate the prior manifest.

### 19.3 Recipient determination and authorization

1. Recipients are derived from the approved project/contract communication matrix, source-document visibility, RFI subject and affected scope, the specific distribution purpose, and the issuer's authority. The originator's project membership or historical involvement alone does not make every person a recipient.
2. The issuer or separately authorized distribution controller confirms the proposed recipient set. Records staff may prepare/dispatch only within the explicit capability and approved recipient scope; they cannot independently expand the technical audience or decide technical authority.
3. Resolve each recipient as an individually identifiable user or authorized external party under DEC-021 and DEC-050/051. Record the recipient party, identity assurance basis where applicable, intended manifest entries and current authorization context.
4. Include only parties that need the exact issued response for the approved purpose. Do not broadcast to all project members, every RFI participant, every Transmittal recipient from a prior issue, or all members of a discipline by default.
5. A required discipline contributor is not automatically a formal external recipient; a formal recipient is not automatically a technical reviewer or responder. These roles remain distinct.
6. Where the recipient list is disputed, incomplete or outside the issuer's authority, block dispatch for the affected package until an authorized decision is recorded. Do not infer consent from a pre-existing mailing list or project roster.
7. Each recipient sees only the manifest entries and recipient state they are authorized to see. Sender-side recipient-level reporting is available only within the sender's distribution authority. Do not reveal hidden recipients, their identities, their access state or failure reason to other recipients.
8. Recheck authorization at issue/dispatch and again for every subsequent preview, open, download, acknowledgement and response action. A Transmittal ID, deep link or previously valid session does not itself grant access.

### 19.4 Delivery, access and acknowledgement are separate recipient facts

For each intended recipient, preserve distinct event histories:

| Dimension | Candidate recipient facts | What it does not prove |
|---|---|---|
| Dispatch | Queued, attempted, retry attempted, dispatch failed | Technical receipt or human access |
| Technical delivery | Delivered, delivery failed, delivery pending/unknown | Reading, review, acceptance or approval |
| Access receipt | Not accessed, authentication/authorization denied, preview/open recorded, download initiated, download completed where measurable | Comprehension, acceptance, contractual notice or source-workflow action |
| Explicit acknowledgement | Not requested, pending, acknowledged, acknowledgement correction/supplement linked | Technical approval, acceptance of the answer or closure |
| Substantive response | Not requested, pending, draft, formally submitted, withdrawn/superseded by linked record | Automatic change to the source RFI answer or its technical disposition |

Use observable and accurately named events only. If the channel cannot reliably establish completed delivery or completed download, record the narrower observable result (for example, dispatch accepted by provider or download initiated); do not upgrade it to Delivered or Download Completed without evidence.

Recipient-level delivery aggregation must follow DEC-103:

- **Delivered:** every intended recipient in the issued manifest has confirmed technical delivery.
- **Partially Delivered:** at least one intended recipient has confirmed delivery and at least one has a confirmed failure.
- **Failed:** all intended recipients have confirmed failure.
- **Pending/Unknown:** the available evidence does not yet establish one of the above outcomes; do not misclassify lack of evidence as success or failure.

Acknowledgement aggregation is calculated separately and only across recipients explicitly marked as requiring acknowledgement. Recipients marked Optional or Not Requested do not block the required-acknowledgement aggregate. A recipient whose delivery failed cannot be treated as having acknowledged merely because another recipient did. Access receipts and delivery receipts are not acknowledgements (DEC-051/052).

### 19.5 Acknowledgement and substantive response requests

1. State the request separately for each recipient: Required, Optional or Not Requested. Where a manifest contains different entries with different obligations, preserve the requirement at the relevant entry/recipient scope.
2. Define the requested acknowledgement type and wording before dispatch. A receipt acknowledgement confirms only the expressly stated receipt fact. An awareness/review acknowledgement, if approved, remains distinct and must not be labelled Approved or Accepted without a separately governed authority and workflow.
3. Acknowledgement must be an explicit, authenticated action by the identified recipient and bind to the exact Transmittal/manifest version and source version. Email delivery, link opening, download, silence or a typed name without the approved identity assurance do not satisfy it.
4. A substantive technical response is a separate record/action from acknowledgement. It must identify the responding party/actor, authority, exact source/manifest references, response type/content, timestamp and supporting evidence.
5. Route a substantive response only to authorized relevant RFI originators and participants. Do not automatically broadcast it to every Transmittal recipient.
6. A substantive response received after the source RFI has closed or been superseded must be routed for authorized assessment under the approved reopen/new-linked-RFI rule. It must not silently mutate a closed or issued source record.
7. Corrections or supplements to a submitted acknowledgement or substantive response create linked subsequent records; preserve the original submission and its audit history (DEC-052).
8. Requested response dates are tracking information only unless a separate approved policy establishes a contractual or SLA effect. No deemed receipt, acceptance, waiver, consent or deadline consequence is inferred.

### 19.6 Failed delivery, retries and recipient changes

- Preserve each recipient's individual attempt, timestamp/timezone, channel, provider/technical result, failure classification and retry relationship.
- Retry only under a bounded, deduplicated policy. A retry of the exact same package to the same intended recipient preserves the Transmittal identity and immutable manifest while adding a new attempt event.
- A failure for one recipient does not erase successful delivery to others. Do not restart or overwrite successful recipient histories when retrying only failed recipients.
- If an address/identity is invalid, recipient is no longer authorized, or distribution scope is disputed, suspend further attempts for that recipient and route the exception to the authorized distribution/identity owner.
- Replacing a recipient after issue is not a silent edit to the original manifest. Preserve the original recipient and outcome history; an authorized correction/reissue creates a new Transmittal or controlled superseding distribution event with explicit relationship and reason.
- Changing the package content, source revision, included evidence or intended distribution scope requires a new controlled Transmittal. A resend of the exact same package does not create a new RFI revision.
- No delivery channel, retry interval, provider, public link, email attachment or external sharing mechanism is approved as a default here. Apply only a separately approved secure-channel policy.

### 19.7 Correction, supersession and withdrawal after issue

1. A technical correction to an already issued RFI response must follow the approved source revision/reopen or linked-new-RFI policy. The original issued response remains preserved and must not be edited in place.
2. A distribution-only correction (for example, correcting an authorized recipient list or replacing a damaged package copy without changing source content) is handled as a controlled Transmittal correction/reissue under DEC-050, preserving the original Transmittal and its recipient/access/delivery history.
3. A changed source response or changed evidence manifest that affects the package content requires a new exact package and a new Transmittal with an explicit supersedes/corrects relationship. It does not silently replace the earlier package.
4. Withdrawal or cancellation of a Transmittal requires the designated authority and a recorded reason, time, scope and affected recipients. It preserves all prior dispatch, delivery, access and acknowledgement evidence.
5. A withdrawal/cancellation notice is itself a controlled communication to affected authorized recipients under the approved notification and distribution rules. It cannot guarantee recall or deletion of copies already downloaded, printed or retained externally.
6. Supersession of a Transmittal does not automatically supersede or close the source RFI. Source technical status and distribution status remain separate.
7. If a recipient has already accessed or acknowledged the earlier package, retain that fact against the earlier manifest and version. Do not transfer the receipt/acknowledgement to a replacement package.

### 19.8 Reporting and notification boundaries

- Show technical issue state, Transmittal state, per-recipient delivery, access, required acknowledgement and substantive response as distinct fields/dimensions.
- Aggregate only from authorized populations. A sender may see the authorized distribution results; a recipient sees only their own permitted entries and states.
- Notify only current authorized recipients and responsible actors for the specific event under DEC-049. Notifications identify the event and required action without exposing hidden recipient lists or restricted technical content.
- Notification read/open/dismissal never counts as delivery, acknowledgement, substantive response or technical closure.
- Delivery failure may create an Action Required event for the authorized distribution owner. It does not transfer technical responsibility, grant new capabilities or create an SLA.
- Reports and exports must retain the measurement unit, recipient population, exact Transmittal/manifest version, time window, timezone and as-of cut-off. Do not present recipient-level percentages without showing the denominator and whether acknowledgement was required.

### 19.9 Acceptance scenarios

1. A technically issued response remains distinguishable from a Transmittal that has not yet been dispatched.
2. An authorized issuer cannot dispatch a package that includes an unissued response version or an unauthorized recipient.
3. A required discipline responder is not automatically treated as a formal recipient.
4. A recipient cannot access a manifest entry intended for another recipient or outside their current authorization.
5. If A and B receive a package and C fails, the aggregate is Partially Delivered; A/B success does not erase C's failure.
6. If all intended recipients fail, the aggregate is Failed; it is not Delivered.
7. If a delivery result is unknown, the aggregate does not claim success.
8. If acknowledgement is required only from A and B, C marked Not Requested does not block required-acknowledgement completion.
9. Opening or downloading a package does not satisfy explicit acknowledgement.
10. An acknowledgement of receipt cannot be interpreted as technical acceptance or approval.
11. A substantive response is routed only to authorized relevant RFI participants and does not automatically close or revise the source RFI.
12. A retry to C preserves A/B's prior delivery events and the original manifest.
13. Changing a recipient after issue preserves the original manifest and requires a controlled correction/reissue relationship.
14. A changed response or evidence package receives a new Transmittal; the earlier manifest and access history remain intact.
15. Withdrawing a Transmittal preserves prior delivery/access/acknowledgement records and does not claim remote deletion.
16. Superseding a Transmittal does not automatically supersede or close the RFI.
17. A notification opened by a recipient does not count as acknowledgement or substantive response.
18. A recipient's revoked authorization blocks future system-controlled access even if the recipient retains an old Transmittal link.

### 19.10 Remaining approval points

Before promotion to authoritative governance, confirm: whether every formally issued RFI response requires a Transmittal; the authority matrix for approving recipients and external identities; allowed purpose values and manifest-entry granularity; which recipients require receipt acknowledgement and the exact wording; whether any review/awareness acknowledgement is needed; substantive response categories and routing; approved delivery channels and evidence standards; retry bounds and failure-owner assignment; recipient correction/reissue rules; Transmittal cancellation/withdrawal authority; notification event/priority mapping; and any contractual/legal notice effect (none is inferred here).

**Implementation boundary:** Proposed RFI-specific design only, applying existing approved cross-document principles. It does not issue or dispatch a live response, resolve real recipients, send notifications, collect acknowledgements, create or change Transmittals, modify source RFI state, implement providers/channels/retries, or change API/UI/workflow/database/schema/migrations/generated types/Storage/auth/RLS/grants or production data. Separate implementation planning and explicit approval remain mandatory.


## 20. RFI closure, reopening, withdrawal, cancellation and archival controls

**Status:** Proposed RFI-specific lifecycle and records-control design applying DEC-021, DEC-022-A/B, DEC-049, DEC-052, DEC-053 and DEC-054. This section remains a working recommendation, not an owner-approved final RFI state machine, authority matrix, retention schedule, or implementation instruction.

### 20.1 Separate lifecycle outcomes that must not be conflated

The RFI record should distinguish the following concepts and preserve their separate authority and evidence:

| Concept | Meaning in the proposed RFI model | Must not be treated as |
|---|---|---|
| Technical closure | The authorized RFI technical question/response cycle has reached its governed completion gate | Delivery, acknowledgement, silence, administrative filing or archive |
| Administrative cancellation | An authorized decision stops an eligible unissued or otherwise cancellable RFI process for a recorded administrative reason | Technical answer, rejection, withdrawal of an issued response or deletion |
| Originator withdrawal request | A request by the originator to stop or withdraw the inquiry, subject to the applicable authority and lifecycle gate | Effective withdrawal merely because it was requested |
| Authorized withdrawal | A controlled decision that an eligible RFI record/cycle or issued response is withdrawn from further use under a defined scope | Cancellation of a Transmittal, supersession, or erasure of history |
| Reopening | An authorized new active handling cycle on the same logical RFI identity, preserving the prior closure and its evidence | Editing the closed snapshot or silently undoing the historical closure |
| Supersession | A controlled relationship to a replacement revision or linked RFI where family rules require it | Deletion or rewriting of the predecessor |
| Archival | Moving a record into governed historical/records custody while preserving identity, provenance and access controls | Technical closure, withdrawal, deletion or automatic destruction |

A requested action is not an effective lifecycle transition until an authorized decision/event is recorded. A draft that has never been formally submitted is not an official RFI and must not be described as a withdrawn official RFI.

### 20.2 Technical closure gate

1. The working recommendation in §15.6 is that authorized formal issue of the final consolidated technical response and technical closure occur as one atomic source-workflow outcome. If the issue transaction fails, neither issue nor closure is recorded as successful.
2. The exact response candidate must have passed all required discipline contribution, conflict-resolution and independent-review gates applicable to that RFI. The issuer must hold the specific issue capability and must not rely on job title or administrative access alone.
3. The closure event binds the official RFI identity, exact revision/clarification cycle, frozen response version, required review evidence, issuer, authority context, timestamp/timezone and the applicable closure-rule version.
4. Closure means that the authorized technical response has been formally issued for the controlled inquiry. It does not mean the originator agrees with the answer, that construction has implemented it, or that every recipient has received, read, acknowledged or substantively responded to it.
5. If the project owner later chooses a separate closure event after formal issue rather than atomic issue-and-closure, that is a material owner decision. The alternative must define its authority, prerequisites, maximum permitted interval, interim status and failure behavior. It must not be silently inferred from the current draft.
6. A delivery failure, missing acknowledgement, access failure, recipient silence, notification read state or outstanding optional response does not undo technical issue or reopen the RFI.
7. A genuinely unresolved technical question, an unissued candidate response, an unresolved blocking conflict, or a required review not yet completed cannot be closed merely to clear a register or KPI.
8. A later question that is outside the scope of the issued response must be assessed under the clarification/materiality rules: a controlled same-RFI reopening/clarification or a separately linked new RFI. It must not be appended to the closed response snapshot.

### 20.3 Reopening a technically closed RFI

Recommend permitting reopening only as a controlled, exceptional action—not as an edit to the historical closed record.

1. A reopening request identifies the RFI, the exact closed revision/response, requester and party, reason, newly discovered fact or unresolved scope, affected discipline(s), supporting evidence and requested outcome.
2. A request alone does not reopen the RFI. An actor with a specifically approved reopening capability must assess whether the matter belongs to the same logical inquiry or requires a new linked RFI.
3. Candidate grounds for assessment include a demonstrable omission or ambiguity in the issued response, a material inconsistency discovered in relied-upon evidence, a response that did not address the controlled question, or a newly discovered technical interface that remains within the same inquiry scope. These are review grounds, not automatic reopening entitlements.
4. A materially new question, changed design basis or distinct work scope should normally be represented by a new linked RFI rather than rewriting the original inquiry. The same-RFI versus new-RFI boundary remains an owner approval point and must be aligned with §18's materiality rules.
5. If reopening is authorized, preserve the prior closure event and create a new linked active cycle/event set under the same logical RFI identity only where the approved family rule permits. Do not erase the earlier issue, closure, revision, Transmittal or recipient history.
6. Record the reopening decision, actor, authority, reason, scope, exact predecessor closure/response, affected parties, timestamp, new cycle identifier and any required review/notification.
7. Reopening does not automatically revoke the earlier issued answer or its Transmittal. If the earlier answer must no longer be relied upon, a separate authorized withdrawal/supersession action and controlled recipient communication are required under §19 and DEC-053.
8. The prior response remains historical and must be clearly distinguished from the current active cycle. A reopened record must not imply that previous recipients have received the new information.
9. If reopening is refused, preserve the request and reasoned decision. The requester may be directed to submit a new linked RFI where appropriate; refusal does not delete the original or bar a new question within authorized scope.

### 20.4 Withdrawal of a submitted RFI or issued response

1. Distinguish an originator's withdrawal request from an authorized withdrawal decision. The originator may request withdrawal only where the approved party/capability model permits; the request itself does not change the RFI's state.
2. Define eligible withdrawal gates separately: before formal technical issue, after issue but before/after distribution, and after a later revision or linked replacement. Do not assume one actor or one rule covers every gate.
3. A withdrawal decision must identify the precise scope: whole logical RFI, a specific submitted revision/cycle, an issued response version, or a specific distribution package. The decision must not silently affect linked RFIs, other revisions, discipline contributions or Transmittals beyond its stated scope.
4. Require an authorized actor, explicit capability, reason, decision timestamp/timezone, authority context, affected versions/evidence, related open assignments and recipient impact assessment.
5. Where the RFI has already been issued or distributed, assess whether a formal withdrawal notice or replacement communication is required for affected authorized recipients. Use a controlled Transmittal where required by the approved distribution policy; no default channel is inferred.
6. Withdrawal prevents future use/issue of the withdrawn item as defined by the approved family rule, but does not delete the original question, response, revisions, attachments, review records, signatures, Transmittals, delivery/access receipts, acknowledgements, substantive responses or audit events.
7. A replacement answer must be a new controlled response version/revision or linked new RFI under §18. The withdrawn snapshot remains immutable and visibly marked as withdrawn for authorized historical viewing.
8. Withdrawal of the source RFI/response is distinct from withdrawal or cancellation of a Transmittal. Each requires its own authority and event. One must not be inferred from the other.
9. Withdrawal cannot guarantee recall or deletion of material already downloaded, printed, copied or retained outside the system. Notices must not claim remote deletion.
10. If the withdrawal request is rejected, preserve the request, assessment, authority, reason and decision; the existing source lifecycle remains unchanged.

### 20.5 Administrative cancellation and draft abandonment

1. Abandonment of an unsubmitted draft is a draft-record event, not cancellation or withdrawal of an official RFI. It consumes no official number under DEC-022-A.
2. After successful formal submission, cancellation should be limited to explicitly defined eligible gates and a specifically authorized actor. It must not be a generic substitute for a technical answer, return, rejection, withdrawal or closure.
3. Candidate administrative grounds may include duplicate formal submission, creation in error, loss of the underlying request before technical work proceeds, or an administrative/contractual instruction from a competent authority. The allowed grounds and evidence requirements require owner approval; the list is not an automatic entitlement.
4. Before cancellation, assess whether technical contributions, reviews, issued responses, Transmittals, recipient actions or linked records already exist. The decision must specify what stops, what remains active, and which related records continue independently.
5. If a duplicate is cancelled, preserve a link to the surviving authoritative RFI and record why the records are duplicates. Do not merge histories or transfer approvals, contributions or acknowledgements silently.
6. Cancellation preserves the official RFI number and all historical events; an issued number is never recycled. It does not imply that the technical question was answered.
7. A cancellation request by an originator or administrator is not effective until an authorized decision is recorded. System administration, records administration or PM read-only visibility does not confer cancellation authority.
8. A cancellation after formal issue must be assessed under the source withdrawal/supersession policy rather than treated as a harmless draft cancellation.

### 20.6 Supersession and linked successor RFI

1. Where the inquiry is materially different, outside the original scope, or cannot safely be handled as a controlled reopening, create a new RFI with its own official identity under DEC-022-A and link it to the predecessor.
2. Record relationship type and direction explicitly (for example, follows, replaces, corrects, duplicates, or related inquiry) using a controlled vocabulary that remains subject to owner approval.
3. The new RFI does not inherit the predecessor's official number, revision, approvals, review evidence, signatures, response, Transmittal, acknowledgements or closure.
4. The predecessor remains independently viewable under current authorization with its own lifecycle and historical disposition. A link does not imply that the predecessor is withdrawn, cancelled or closed.
5. If the predecessor must no longer be relied upon, an authorized source withdrawal/supersession decision must explicitly identify the affected response/revision and any recipient notice required.
6. Preserve reciprocal links and the reason for the relationship, actor, authority, timestamp and exact versions involved. Prevent circular or misleading successor chains and do not silently redirect old links to the new RFI.

### 20.7 Archival, retention and legal hold

1. Treat archival as a records-management state/action separate from the RFI's operational lifecycle. A record may be technically closed yet remain operationally accessible for an approved period; archiving does not itself close, cancel or withdraw it.
2. Preserve the logical RFI identity, every official revision/cycle, submitted question snapshots, discipline contributions, consolidated and issued response versions, attachment/evidence identities and integrity references, review/decision records, reopening/withdrawal/cancellation events, linked RFIs, Transmittals/manifests, recipient delivery/access/acknowledgement/substantive-response events and audit provenance.
3. Preserve the exact relationships among source RFI, revision, response version, attachment, Transmittal and recipient events. Archiving one record must not make a retained linked item unintelligible or silently orphan evidence.
4. Historical access remains subject to current server-side authorization and least privilege. Archive status does not make restricted drafts, confidential contributions, external-party records or recipient lists visible to a wider audience.
5. Label archived and superseded material clearly as historical. Search, register, exports and dashboards must distinguish current active records, closed records and archived records; historical analytics must use the state at the selected time.
6. Apply a versioned, approved retention schedule by record class/project/contract/jurisdiction. No retention duration, archive tier, storage technology or automatic expiry is selected in this RFI draft.
7. Legal hold overrides ordinary disposition within its authorized scope. Record the hold authority, matter/reference, affected records/versions/evidence/copies, effective scope and release authority. Multiple holds remain independent; release of one does not release another.
8. Retention expiry makes a record eligible for controlled review only; it does not authorize automatic or manual destruction by itself. Uncertain classification, linked-record dependency or unresolved hold must fail closed and preserve the records pending competent review.
9. Any approved disposition requires a separate authorized decision, scope, schedule version, rationale, actor/authority, timestamp and auditable outcome. Preserve sufficient disposition evidence subject to applicable legal/privacy review.
10. Backups, replicas, exports, caches and external copies are not automatically the archive and require their own approved lifecycle. Do not claim immediate or complete erasure unless technically verified.
11. Archive retrieval, restoration, export and disposition actions require separate capabilities and append-only audit. PM visibility remains read-only unless an independent capability is approved.

### 20.8 Lifecycle and records reporting

Keep independent indicators for:

- Operational lifecycle: draft, submitted/active handling, technically closed, cancelled or withdrawn, using only the final approved RFI vocabulary.
- Current revision/cycle and whether it is latest-created, currently issued/effective, superseded or withdrawn.
- Reopening request/decision and current active cycle, if any.
- Linked successor/predecessor and relationship type.
- Distribution: Transmittal state and recipient-level delivery/access/acknowledgement under §19.
- Records state: retention class/schedule version, archive status, legal-hold status and disposition eligibility/review state.

Do not derive technical closure from an archived flag, delivery aggregate, acknowledgement aggregate, absence of outstanding notifications or an empty dashboard queue. Do not count a reopened RFI as a second official RFI identity; report cycle counts separately from unique RFI counts. Historical reports must retain the event time, timezone and as-of cut-off.

### 20.9 Acceptance scenarios

1. Abandoning an unsubmitted draft does not create an official RFI withdrawal or consume an official number.
2. A failed first submission creates no official RFI identity and cannot be shown as a formally cancelled RFI.
3. A technically closed RFI remains closed when one Transmittal recipient has failed delivery or has not acknowledged.
4. A response cannot be technically closed while a required discipline contribution, blocking conflict or mandatory independent review remains incomplete.
5. A failed formal issue transaction records neither successful issue nor technical closure.
6. A reopening request alone does not reopen the RFI; only a specifically authorized recorded decision can do so.
7. Reopening preserves the earlier closure, issued response, revision, review and distribution history.
8. A materially new question is assigned a new RFI identity and linked to the predecessor rather than silently appended to the closed response.
9. Withdrawal of an issued response preserves its exact content, attachments, approvals, Transmittals, access receipts and acknowledgements.
10. Cancellation of a submitted RFI preserves its official number and does not misrepresent the record as technically answered.
11. A duplicate RFI cancellation links to the surviving record without merging or transferring audit history.
12. Source withdrawal and Transmittal cancellation require distinct authorized events and do not imply one another.
13. A successor RFI does not inherit predecessor approvals, revision identity or acknowledgement records.
14. Archiving a closed RFI does not delete it, broaden access or automatically destroy linked evidence.
15. An active legal hold blocks disposition even when the ordinary retention period has expired.
16. Releasing one legal hold does not release another active hold covering the same RFI/evidence.
17. Historical reports distinguish a record that was closed at the selected time from one reopened later.
18. Archived, withdrawn and superseded records are never presented as current effective responses.

### 20.10 Remaining owner approval points and consistency items

Before promotion to authoritative governance, the owner must explicitly decide:

- Final RFI lifecycle vocabulary and whether technical issue/closure remains atomic as recommended in §15.6, or a separate authorized closure event is selected.
- Exact closure prerequisites and any family-specific exceptions.
- Who may request and who may approve reopening; permitted grounds; same-RFI versus new-RFI criteria; and treatment of a refused request.
- Which submitted/issued states are eligible for withdrawal, who may withdraw each scope, and the effect on active contributions, reviews, linked records and recipients.
- Whether administrative cancellation is permitted after formal submission, the allowed grounds, and the exact authority/segregation requirements.
- Relationship types and governance for duplicate, successor, correction, replacement and related RFIs.
- Archive trigger and records owner, retention schedules, jurisdiction/contract source, legal-hold authority, retrieval and disposition approvals.
- Historical visibility by party/role, export rights and treatment of sensitive/confidential evidence.
- Any contractual/legal notice or evidentiary effect; none is inferred by this draft.

**Implementation boundary:** Proposed RFI lifecycle and records-control design only. No live RFI is closed, reopened, withdrawn, cancelled, archived or deleted. No retention schedule, legal hold, disposition, notification or recipient action is applied. No API/UI/workflow/numbering/database/schema/migration/generated types/Storage/auth/RLS/grants/search/index or production-data changes are authorized. Promotion to governance and a separately reviewed implementation plan with explicit owner approval remain mandatory.
