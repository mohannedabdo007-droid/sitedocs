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

## 7. Core lifecycle questions requiring explicit decisions

| ID | Question | Options to consider | Why it matters |
|---|---|---|---|
| RFI-D01 | Who may originate an RFI? | Contractor only; consultant only; any authorized project party; type-specific | Defines party boundary and numbering ownership |
| RFI-D02 | Who performs administrative completeness checks? | Originator validation only; separate coordinator; both | Separates administrative screening from engineering judgment |
| RFI-D03 | Who assigns the responder? | Coordinator; discipline lead; configured routing; combination | Establishes accountable routing authority |
| RFI-D04 | How many responders? | One; multiple with consolidated answer; configurable | Affects data model, assignment, statuses, and reports |
| RFI-D05 | Is independent technical review required? | Never by default; always; only configured cases | Controls separation of duties and response authority |
| RFI-D06 | Can originator ask follow-up questions? | New linked RFI; clarification loop in same RFI; both under defined conditions | Prevents ambiguity in numbering and closure |
| RFI-D07 | What closes an RFI? | Issued response; originator acknowledgement; explicit authorized closure; configured rule | Avoids treating delivery/read/acknowledgement as technical acceptance |
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
