# POL-DOC-001 — Controlled Document Lifecycle Design Proposal

**Document ID:** POL-DOC-001  
**Version:** 0.3 — OWNER REVIEW DRAFT (PARTIAL DECISIONS RECORDED)  
**Date:** 2026-11-11  
**Status:** PROPOSED — NOT APPROVED; NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `governance/scan-lifecycle-design-2026-11-11`  
**Related decisions:** DEC-001–DEC-021, especially DEC-008–DEC-015 and DEC-017–DEC-021  
**Related specifications:** POL-GOV-001, POL-SCAN-003, POL-SCAN-001, POL-SCAN-002

> This document proposes a common control framework for the lifecycle of controlled project documents. It is a design proposal only. It does not assert that these stages or controls exist in the current application, and it does not authorize code, schema, database, Storage, authentication, production, merge, or deployment changes.

## 1. Purpose and scope

Define a traceable lifecycle from document initiation through controlled issue, review, decision, finalization, distribution, supersession, and archive. The framework must support project-specific document types without forcing unlike workflows into one generic state machine.

The lifecycle framework applies to controlled project records, but each document family retains its own rules:
- **WIR** remains a Work Inspection Request for inspection of executed work.
- **RFI** remains a Request for Information / engineering clarification, fully separate from WIR in forms, numbering, permissions, lifecycle, reporting, and audit.
- **MQR** remains Monthly Quality Report with its independent review lifecycle and no default A/B/C/D/E/I response-code workflow.
- Other document types use their approved project/contract workflow configuration.

POL-SCAN-003 governs the paper-signature and in-SiteDocs electronic-signature routes. This proposal must be read consistently with it, not as a replacement.

## 2. Non-negotiable governing constraints

1. Drafts remain confidential to their originating party before formal submission, subject to the approved Project Manager read-only oversight exception.
2. Project Manager visibility does not confer edit, submit, review, response, approval, cancellation, signing, or closure authority.
3. Access and actions follow DEC-021: deny by default, distinct capabilities, scoped authorization, and server-side action-time checks.
4. No self-approval where separation of duties applies; no proxy signing, impersonation, or administrator bypass across party boundaries.
5. Every formal transition is attributable to an authenticated actor, effective assignment/party, resource, revision, action, and trusted server timestamp.
6. Submitted/reviewed content is an immutable snapshot for that cycle. Material change requires a controlled revision or a formally restarted cycle; prior events remain historical.
7. Issued/final records are not silently overwritten or deleted. Corrections create a new revision or superseding record, preserving prior versions and links.
8. Document numbering and revision identity are controlled independently from attachment upload, comments, review events, PDF rendering, and archive operations.
9. RFI, WIR, and MQR semantics must not leak into one another.
10. Historical decisions/files remain preserved under DEC-012; archived material is not current implementation authority without explicit owner permission.

## 3. Proposed lifecycle stages

The following is a common control sequence, not a requirement that every document type use every stage or the same labels.

### Stage 0 — Type and workflow configuration

Before a document can be created, an authorized configuration owner defines or selects the applicable project/contract document type, party ownership, discipline where relevant, numbering/revision rules, required metadata, route, required participants, review/approval steps, distribution rules, and retention classification.

Configuration must be versioned. A change to a workflow configuration must not silently reinterpret a document already in progress; each transaction should retain the configuration version under which it was created/submitted. Exact configuration-owner roles and change-effective rules remain open.

### Stage 1 — Initiation and draft

An authorized originator creates a draft and supplies the minimum metadata required for that document type, such as project, document type, originating party, discipline if applicable, title/subject, originator, and applicable contract/package/reference.

The draft:
- is visible only to authorized users of the originating party and explicitly authorized oversight readers;
- is editable only by users with the applicable draft-edit capability;
- is not distributed to other parties and does not appear as a formally submitted item in their work queues;
- may have working attachments, but upload alone does not submit, approve, or issue the document;
- receives no externally meaningful formal issue event until the authorized submission/registration gate succeeds.

A draft receives an internal, non-issued identifier only. It does not reserve or consume an official document number.

### Stage 2 — Pre-submission validation

Before submission, validate the document against its type-specific rules:
- required metadata and references;
- project, party, document type, and discipline compatibility;
- numbering/revision eligibility and duplicate/collision checks;
- required supporting files and file integrity checks;
- selected workflow route and required person-level assignments;
- active, accepted, account-linked assignments for any selected signer candidates;
- originator authority and separation-of-duties constraints.

A validation failure must identify actionable errors and leave the item in draft. No partial submission or accidental distribution should occur.

The exact required fields and validation rules are configured per document type; this proposal does not invent a universal field list.

### Stage 3 — Formal submission and controlled registration

On successful validation, an authorized originator performs a distinct **Submit** action. The server rechecks permission and records an immutable submission event and submitted content snapshot.

The submission event should capture:
- stable document identity and revision;
- document type, originating party, project, discipline where applicable;
- submitting account and effective assignment/role;
- timestamp and workflow-configuration version;
- content/manifest hash or equivalent integrity reference;
- selected review route and assigned workflow participants.

Only after the submission transaction succeeds does the document become visible to its authorized recipients and enter their assigned queues. The system must not expose another party's draft merely because a number was reserved or a file was uploaded.

The official document number is allocated and fixed only when the first formal submission succeeds. Draft creation, validation, and abandoned drafts do not consume an official number.

### Stage 4 — Review and technical evaluation

The system routes the exact submitted snapshot to the next configured authorized person or group. Each reviewer sees only the documents and actions permitted by their party, assignment, workflow step, and capabilities.

A review action must be explicit and attributable. Potential action categories for configuration are:
- record comments/observations without deciding the document;
- return for correction;
- recommend or record a technical review outcome;
- approve at an assigned approval step;
- reject/close only where the document-type procedure expressly allows it.

These are candidate action classes, not a universal response-code list. The exact actions, terminology, sequence, mandatory comments, deadlines, and whether parallel review is allowed remain open by document type and contract.

A comment alone must not be treated as approval or as completion of a workflow step.

### Stage 5 — Return, correction, and resubmission

A return for correction must identify the responsible recipient, the required action, and the affected document/revision. The document returns to an authorized correction state for the originating party.

Material changes create a new controlled revision or restart the relevant review cycle according to the approved revision policy. The new content must be validated and formally resubmitted. Prior comments, returns, review decisions, and signature events remain in the history and must remain associated with the snapshot on which they were made.

The precise distinction between "returned", "rejected", "withdrawn", and "cancelled" must be defined separately for each document family. Do not treat these labels as synonyms.

### Stage 6 — Approval and finalization

Where a document requires approval, only the assigned authorized approver(s) may complete their own step. Approval completeness is checked against the versioned workflow configuration and person-level assignments.

For the in-SiteDocs electronic-signature route, follow POL-SCAN-003: freeze the reviewable content before signing, collect each person's own authenticated action, and generate/validate the final archival PDF only after the last required signature and final approval.

For paper-signature documents, follow POL-SCAN-003: all required handwritten signatures and approvals must be complete before the pre-scan completeness gate and final scan.

Approval state and records-processing/PDF/archive state remain separate. A document must not be labelled final merely because its review decision is approved if required PDF generation, scan QC, or records checks remain incomplete.

### Stage 7 — Issue and controlled distribution

After the applicable approval/final-record gate succeeds, an authorized records/document-control function may issue or distribute the controlled record according to the configured recipients and contractual procedure.

The issue/transmittal record should capture:
- exact document and revision;
- final file identity/hash where applicable;
- issuer account and authority;
- recipients/party distribution list;
- issue channel/reference and server timestamp;
- purpose/status of issue and any response due date where configured.

A transmittal is a distribution record, not a new approval and not a new document revision. Re-sending an existing issue should be traceable without creating a false new revision. Whether issue and transmittal are one event or separate events remains open.

### Stage 8 — Archive and retrieval

A finalized record is archived with its document identity, revision, final content/file, approval or paper-scan evidence, issue/transmittal history, audit events, and retention classification.

Archive access remains permission-controlled. The Project Manager's oversight remains read-only. Retrieval, preview, and download must be authorized against the parent document and applicable confidentiality/retention rules.

Retention duration, legal hold, export format, archival storage tier, destruction authority, and physical paper-original custody remain separate policy decisions. No retention period or destruction rule is assumed here.

### Stage 9 — Revision, supersession, and closure

A finalized record is immutable. A subsequent change must be represented as a new controlled revision or formally linked superseding record, with its own review/approval/finalization cycle where required.

The prior revision remains retrievable as historical evidence and is clearly marked with its actual state (for example, superseded) without rewriting its original approval or issue history.

A document may be closed only through a document-type-specific authorized closure action. Closure must not mean deletion. The exact meaning of closed, archived, superseded, cancelled, and withdrawn must remain distinct in the data model and user interface.

## 4. Separate status dimensions

Avoid one overloaded status field. The following dimensions are proposed; exact labels and allowed combinations require validation against each document family.

| Dimension | Illustrative values only |
|---|---|
| Preparation | Draft; Validation Failed; Ready to Submit |
| Workflow/review | Submitted; Under Review; Returned; Awaiting Approval; Approved; Rejected/Closed where configured |
| Records processing | Awaiting Scan; Scan QC; Awaiting Final PDF; PDF Failed; Records Check |
| Issue/distribution | Not Issued; Issued; Transmitted; Re-transmitted |
| Record lifecycle | Active; Final; Superseded; Archived; Closed where configured |

A status in one dimension must not silently imply another. For example, "Approved" does not automatically mean "PDF Archived", and "Uploaded" does not mean "Submitted".

## 5. Document-family isolation

The common lifecycle is a framework, not a universal workflow template:
- **WIR:** inspection request and inspection-specific scheduling, site attendance, inspection result, reinspection/closure rules must be separately specified.
- **RFI:** engineering question, responsible discipline/party, response/clarification, possible follow-up, and closure rules must be separately specified. It is not an inspection request.
- **MQR:** independent Monthly Quality Report review and reporting rules; do not apply generic response codes by default.
- **Other submittals, drawings, method statements, material approvals, NCRs, and correspondence:** each requires its own approved workflow profile and action vocabulary.

No detailed WIR/RFI/MQR state machine is approved by this proposal.

## 6. Roles and capability boundaries

Apply DEC-021. Candidate capabilities include create draft, edit own-party draft, submit, view submitted document, comment, review, return, approve, sign, issue, transmit, archive, retrieve, and read audit history.

These are capabilities, not automatic role grants. The detailed party-specific role bundles, grant/revocation authority, permitted role combinations, emergency access, records-control authority, and assignment of final issue/archive actions remain open. Roster membership alone is not document access; PM oversight alone is read-only.

## 7. Required audit and integrity evidence

At minimum, each formal transition should preserve:
- event ID and event type;
- document ID and revision ID;
- actor account ID and displayed identity snapshot;
- effective party, project assignment, role/capability and workflow step;
- prior and resulting state dimensions;
- server timestamp;
- reason/comment where required by the configured action;
- content snapshot/hash or exact file/version reference where relevant;
- workflow configuration version;
- correlation/reference to related submission, review, approval, signature, issue, or transmittal events.

Events are append-only. Corrections to metadata or state must be recorded as new authorized events; no history rewriting.

## 8. Exception and failure handling

- **Validation fails:** remain draft; show actionable errors; no recipient visibility.
- **Unauthorized submit/review/approval/issue:** deny server-side; record an appropriate security audit event.
- **Wrong party or recipient:** stop distribution; correct through an auditable administrative process, not silent reassignment.
- **Content changes after submission:** preserve the old snapshot and require a controlled revision/restart.
- **Reviewer unavailable:** reassignment only through a separately approved authority and audit process; never impersonate.
- **Duplicate number or collision:** block issuance and resolve through a controlled numbering process; never silently renumber historical records.
- **PDF/scan failure:** preserve approval history and mark records processing as failed/retry-required; do not claim final archive completion.
- **Distribution failure:** preserve the approved record and record failed/retried delivery separately.
- **Later correction:** create a new revision/superseding record; preserve prior final record.

## 9. Acceptance scenarios for future implementation

1. A draft is not visible to another party before formal submission, except authorized PM read-only oversight.
2. Project membership alone does not reveal another party's draft, revision, comments, attachments, or files.
3. Uploading a file does not submit, approve, issue, or change document numbering.
4. Submission requires all type-specific validation gates and an authorized originator.
5. Submission creates an immutable snapshot and auditable event.
6. Only assigned reviewers can perform the actions configured for their workflow step.
7. A comment does not count as an approval unless the configured workflow explicitly defines that action.
8. Return/revision preserves all prior comments and decisions and binds them to their original snapshot.
9. A changed revision cannot inherit signatures/approvals from a different content snapshot.
10. Self-approval, proxy signing, impersonation, and cross-party admin bypass are denied.
11. PM oversight remains read-only across direct API and Storage paths.
12. Approval does not imply final PDF/archive completion.
13. Paper scanning cannot start before required paper approvals; electronic final PDF generation cannot start before final approval, per POL-SCAN-003.
14. Issue/transmittal identifies the exact final document revision and recipient set.
15. Re-transmission does not create a false new revision or approval.
16. A later revision does not overwrite the prior final record.
17. WIR, RFI, and MQR retain separate forms, numbering, permissions, workflow semantics, and reporting.
18. Historical records and superseded documents remain traceable and are never silently deleted.

## 10. Decisions required before this proposal can be approved

The following items are intentionally unresolved. No defaults should be inferred:

1. **Number allocation — DEC-022-A (PARTIALLY APPROVED):** internal draft identifier at draft creation; official document number fixed only on successful first formal submission; abandoned drafts consume no official number. The approved rule is recorded in §12. No number is reserved at draft or validation stage.
2. **Revision rules — DEC-022-B (APPROVED COMPONENT):** first formal issue is Rev.00; a controlled-content change after return/correction increments the revision (Rev.01, Rev.02, ...); resubmission without content change retains the same revision; prior revisions and their events remain immutable; signatures/approvals do not carry across revisions. Detailed minor/major labels and metadata-only change treatment remain open if needed.
3. **Initial document-type scope — DEC-023 (APPROVED):** the Phase 1 type list and separate control modules are owner-approved and recorded in §13. Type-specific metadata, validation rules, and detailed lifecycle transitions remain to be specified; approval of the scope does not approve a common workflow for all types.
4. **Review outcomes:** for each type, which actions are available (comment, return, approve, reject, information-only, cancel, withdraw, close), and what exact labels apply?
5. **Sequence model:** sequential vs parallel review, mandatory quorum, optional reviewers, and rules when a required person becomes inactive.
6. **Return vs reject vs withdraw vs cancel:** definitions, initiators, authority, consequences, and whether a document number/revision remains consumed.
7. **Resubmission:** whether the same revision may be resubmitted after non-material correction or every return creates a new revision; who decides materiality?
8. **Issue/transmittal:** whether issue and transmittal are one or two controlled events; recipient rules, due dates, acknowledgements, and failed delivery behavior.
9. **Records control:** exact roles allowed to register, issue, scan, QC, archive, correct metadata, and initiate supersession.
10. **Retention/legal hold:** retention periods, export, legal hold, physical original custody, destruction authority, and archival format.
11. **Closure:** what closure means for each document family and whether closed items may be reopened, by whom, and with what audit trail.
12. **Migration of existing records:** how existing documents with incomplete metadata, mixed states, or historical workflow labels are mapped without rewriting their history.

## 11. Explicit non-authorization

This proposal authorizes design review only. It does not authorize:
- database/schema/table/column/enum/function/trigger changes or migrations;
- generated type changes or data migrations;
- Storage bucket/object/policy/upload/download changes;
- authentication, authorization, RLS, grants, or production configuration changes;
- workflow engine, numbering engine, PDF/transmittal service, UI, or application code changes;
- tests against live data, merge to main, or deployment.

Any implementation requires a separate exact plan, ownership-compliant workflow, complete database and Storage backups, successful isolated restore, security review, acceptance tests, and separate explicit owner approval.

## 12. Owner decisions recorded against DEC-022

### DEC-022-A — Official document-number allocation

**Status:** APPROVED COMPONENT — owner approval recorded 2026-11-11. This approves only the numbering rule below; DEC-022 and the remainder of POL-DOC-001 remain proposed and are not thereby approved.

1. At draft creation, assign an internal identifier for system tracking only. It is not an official document number and must not be presented externally as one.
2. Allocate and fix the official document number only when the first formal submission successfully passes validation and is committed.
3. A draft that is abandoned before successful formal submission consumes no official document number.
4. Once allocated, the official number remains associated with that document through return and correction; revision identity and increment rules are recorded separately in DEC-022-B (§12).
5. Uploading files, editing a draft, validating, commenting, or saving does not allocate an official number.

**Owner authority:** explicit owner approval in conversation, 2026-11-11.

**Implementation boundary:** approved design rule only. No numbering logic, database/schema, migration, generated type, UI, API, code, test, merge, or deployment change is authorized or made.

### DEC-022-B — Revision numbering and resubmission after return

**Status:** APPROVED COMPONENT — owner approval recorded 2026-11-11. This approves only the revision rules below; DEC-022 and the remainder of POL-DOC-001 remain proposed.

1. The first formal issue uses revision **Rev.00**.
2. When a returned document is corrected and its controlled content is changed, the next revision is created and numbered sequentially: Rev.01, Rev.02, and so on.
3. If a document is returned but resubmitted without any change to its controlled content, it retains the same revision number.
4. Every revision remains a distinct preserved record with its own content snapshot and linked comments, review decisions, approvals, signatures, and audit events. Earlier revisions are never overwritten or deleted.
5. Signatures and approvals from one revision do not transfer to another revision. A changed revision must pass its applicable review/approval/signature steps again.
6. The official document number remains stable across revisions; the revision identifier distinguishes each controlled content version.

**Owner authority:** explicit owner approval in conversation, 2026-11-11.

**Remaining detail:** minor/major revision labels and treatment of metadata-only changes may be specified in the relevant document-type profile without weakening the approved rules above.

**Implementation boundary:** approved design rule only. No revision engine, database/schema, migration, generated type, UI, API, code, test, merge, or deployment change is authorized or made.

## 14. WIR initial scope and item-level inspection outcomes (DEC-024 — approved requirements)

**Status:** owner-approved WIR requirements — 2026-11-11. This approval covers the flexible request scope and item-level outcome behavior below only; the complete WIR form, workflow, permissions, validation, and implementation remain under design.

### 14.1 Flexible inspection scope

- A WIR may cover one or multiple work activities and/or locations.
- A company may choose to submit one consolidated WIR covering several locations/activities or separate WIRs for individual locations/activities.
- Location and activity selection is optional; the request must not be forced to use one predefined or fixed location.
- The request may be created with an open/general scope where a precise location or activity is not known or is not applicable at initiation.
- The design must support adding multiple scope items and must not impose a fixed business rule that every WIR represents exactly one location or one activity.
- Where several scope items are included in one WIR, each item must remain individually identifiable for inspection records, findings, evidence, and follow-up.

### 14.2 Item-level outcomes and partial correction

- Record inspection outcome independently for each scope/inspection item; do not force one single outcome across the entire WIR.
- An item may be accepted while another item in the same WIR requires correction.
- A correction-required item remains open for corrective action and re-inspection; accepted items retain their recorded outcomes and must not be reopened or overwritten merely because another item needs correction.
- The WIR remains active while any item requires correction, re-inspection, or other outstanding action. Do not close the entire WIR solely because some items have been accepted.
- Record item-level findings, comments, evidence, corrective-action follow-up, and re-inspection history against the relevant item, while retaining an overall WIR status that reflects outstanding items.
- Final WIR closure is permitted only when all applicable items have reached their required terminal disposition and no required follow-up remains, subject to the detailed WIR workflow still to be designed.

**Approved item-level inspection outcome vocabulary (DEC-025):**
- **Accepted** — the inspected item is accepted.
- **Accepted with Comments** — the item is accepted, with recorded comments that do not prevent acceptance.
- **Requires Correction** — corrective action is required; the item remains open for correction and re-inspection.
- **Not Ready for Inspection** — inspection could not proceed because the item/work was not ready or required prerequisites were incomplete.
- These four outcomes apply independently to each WIR scope/inspection item. No separate generic **Rejected** outcome is added at this stage.
- The outcome of one item must not overwrite or force the outcome of another item in the same WIR. Overall WIR status continues to reflect outstanding item-level actions.

**Approved disposition for Not Ready for Inspection (DEC-026):**
- When an inspection item receives **Not Ready for Inspection**, the contractor must submit a **new WIR** for that item after the work is ready; the original WIR item is not simply rescheduled and reused.
- Preserve the original WIR and its Not Ready outcome as an immutable historical record. Do not reuse its official WIR number for the new request.
- Link the new WIR to the original WIR/item as a follow-up or successor reference so the inspection history remains traceable.
- In a multi-item WIR, apply this rule only to the item marked Not Ready. Other items retain their own outcomes and continue through their applicable workflow without being cancelled or reset.
- The detailed relationship display, numbering configuration, and any required closure handling for the original WIR remain part of the detailed WIR workflow design.

### 14.3 Formal correction/rejection record and sequential re-inspection attempts (DEC-027 — approved)

**Status:** owner-approved WIR requirements — 2026-11-11.

- Retain exactly the four approved item-level outcomes in DEC-025. Do not add a fifth outcome or a separate selectable **Rejected** result.
- **Requires Correction** is the formal consultant rejection disposition for the affected inspection item. The recorded outcome remains **Requires Correction**; preserve the rejection decision, rationale/findings, comments, evidence, decision-maker, and timestamp in the immutable review history. This does not create another outcome label.
- For a correction-required item, each re-inspection is submitted as a new attempt in the same WIR attempt series: **WIR-00** (initial request), **WIR-01** (first re-inspection), **WIR-02** (next re-inspection), and sequentially thereafter as needed.
- Each attempt is a distinct, separately preserved request/inspection record, linked to its immediate predecessor and to the same WIR series/base identity. Never overwrite, delete, or reuse a prior attempt; retain its outcome, findings, comments, evidence, attachments, decisions, and audit history.
- Apply the attempt sequence to the affected correction-required item. In a multi-item WIR, do not reset or reopen other items that were accepted; their outcomes and records remain intact.
- The attempt suffix (00/01/02/...) is an inspection-attempt identifier, not the official WIR document number and not the document content revision (Rev.00/Rev.01). These identifiers must remain distinct in data, display, and audit records.
- This correction/re-inspection series is distinct from DEC-026: **Not Ready for Inspection** requires a new WIR with a new official WIR number after readiness, linked to the original request; it does not reuse the original attempt series.

### 14.4 WIR requested inspection date and optional time (DEC-028 — approved)

**Status:** owner-approved WIR form requirement — 2026-11-11.

- A requested inspection date is mandatory for every WIR submission.
- Requested inspection time is optional. The submitter may either:
  1. provide both the requested date and a specific requested time; or
  2. provide the requested date only, without a time.
- The form and validation must accept both modes. Missing requested date blocks formal submission; missing time does not.
- Do not infer or silently assign a requested time when the submitter selects date-only.
- The recorded date and optional time must remain available in the WIR record and audit history. Detailed scheduling, time-window selection, timezone display, and rescheduling rules remain part of the WIR type-profile design.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved form/validation requirement only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved design requirements only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.



### 14.5 Consultant assignment of the inspection engineer (DEC-029 — approved)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

- The contractor is not required to select or nominate a specific consultant inspection engineer when submitting a WIR.
- After receipt of the WIR, the consultant organization is responsible for reviewing the request and assigning the appropriate engineer or inspection team.
- Assignment must be made from eligible consultant personnel according to the relevant discipline/scope, active project assignment, availability, and granted permissions.
- The assignment and any reassignment must be recorded against the WIR with the responsible assigner, assigned person(s), and timestamps in the audit history.
- The assigned engineer's authority remains limited to the applicable workflow step and permissions; assignment alone does not grant unrelated document or approval capabilities.
- Detailed assignment roles, delegation rules, notification behavior, reassignment conditions, and service-level scheduling remain open for the WIR type profile.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved workflow requirement only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.

### 14.6 Flexible reassignment of the consultant inspection engineer (DEC-030 — approved)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

- The consultant may reassign a WIR inspection to another eligible consultant engineer or team whenever operationally necessary; the workflow must not impose an unnecessary fixed-assignee restriction.
- Reassignment is performed by a consultant user authorized for assignment management, and the replacement assignee(s) must have an active project assignment and the permissions relevant to the inspection scope.
- A reason for reassignment may be recorded but is not mandatory. The system must not block a valid reassignment solely because no reason was entered.
- Preserve every assignment and reassignment event, including the assigner, previous assignee(s), new assignee(s), timestamp, and any supplied reason. Never overwrite the prior assignment history.
- Reassignment does not erase, transfer, or rewrite any inspection findings, comments, evidence, decisions, signatures, or audit events already created by another person. Each action remains attributed to its actual actor.
- Current assignment and historical assignments must be distinguishable. Assignment does not itself grant unrelated document access or approval authority.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved workflow requirement only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.

### 14.7 Optional corrective-action target date (DEC-031 — approved)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

- When an inspection item receives **Requires Correction**, the contractor remains responsible for carrying out the required correction, and the consultant records the findings and required corrective action.
- The consultant may set a target completion date for the correction, but this date is optional. The workflow must allow the consultant to leave it unspecified when a fixed target is not appropriate.
- An absent target date must not block recording the outcome, issuing the correction requirement, or continuing the applicable WIR/reinspection workflow.
- If a target date is supplied, preserve who set it, when it was set, and any later changes as traceable history; do not silently overwrite prior values.
- The target date is a planning/control date and does not itself change the inspection outcome, grant an extension, or close the corrective action.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved workflow requirement only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.

### 14.8 Optional evidence of corrective action (DEC-032 — approved)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

- The contractor may attach photographs, documents, or other relevant evidence showing that a correction has been completed.
- Such evidence is optional by default. The system must not block a correction/reinspection request solely because the contractor did not attach evidence.
- The consultant may request additional or specific evidence where the nature of the finding, work, or verification need makes it appropriate. Any such requirement must be communicated and recorded against the affected inspection item.
- Evidence supplied for a correction must remain linked to the relevant WIR series/attempt and inspection item, with its uploader and timestamp preserved. New evidence must not overwrite or erase earlier evidence or history.
- Evidence submission does not itself establish acceptance or close the corrective action; the applicable inspection/review decision remains necessary.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved workflow requirement only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.

### 14.9 Contractor confirmation before formal WIR reinspection submission (DEC-033 — approved)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

- After completing the required correction, the contractor user records the correction as completed using the applicable **Correction Completed** action.
- This action records the contractor's completion declaration but does not, by itself, formally submit a reinspection request or notify the consultant that a new inspection is officially requested.
- The contractor must then explicitly confirm and perform a separate **Submit for Reinspection** action to send the request formally to the consultant.
- The confirmation step must make clear that it is a formal submission. The workflow must not submit automatically merely because the contractor marked the correction complete.
- Preserve the completion declaration and the formal reinspection submission as distinct, timestamped audit events attributed to the authenticated user.
- Any optional correction evidence under DEC-032 may be attached before formal submission; absence of optional evidence must not block submission unless the consultant has recorded a specific evidence requirement for that inspection item.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved workflow requirement only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.

### 14.10 Consultant request for correction-information/evidence completion before reinspection (DEC-034 — approved)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

- Before proceeding with a reinspection, the consultant may determine that the contractor's correction-completion information or supporting evidence is insufficient or unclear.
- The consultant may return the affected inspection item/request to the contractor with a clearly recorded request specifying the missing, unclear, or additional information/evidence required and the reason.
- This is an administrative completion request within the current correction/reinspection attempt. It is **not** a new inspection outcome, does not create a new inspection attempt, and must not increment the WIR attempt sequence.
- The contractor may provide the requested information/evidence and then separately confirm **Submit for Reinspection** again. This formal resubmission follows DEC-033.
- Preserve each consultant request, its reason and author, timestamps, contractor responses, uploaded evidence, and subsequent resubmission as append-only history. Do not overwrite or erase earlier submissions or evidence.
- The request does not itself mean the correction is accepted or rejected. The applicable inspection outcome remains one of the four DEC-025 outcomes and is recorded only through the inspection decision process.
- This mechanism must not be used to bypass the inspection process or to silently change the current WIR attempt or its recorded outcome.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved workflow requirement only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.

### 14.11 Contractor withdrawal of a formally submitted reinspection request before inspection begins (DEC-035 — approved)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

- The contractor who formally submitted the reinspection request may withdraw that request, provided the consultant has **not yet started the inspection**.
- Withdrawal is permitted even if the consultant has assigned an inspector, provided the inspection itself has not started.
- The contractor must provide a withdrawal reason. The system records the authenticated actor, timestamp, affected WIR/item and current attempt, reason, and prior submission/assignment state.
- Withdrawal is a controlled workflow event, not deletion or alteration of the original submission. Preserve the submitted request and all related records as immutable history.
- Once the consultant has started the inspection, ordinary contractor withdrawal is not permitted. Any exceptional handling after inspection start must follow a separately authorized process and must not erase inspection activity or history.
- A withdrawn request does not create a new inspection outcome and does not silently increment or reset the WIR attempt sequence. Any later reinspection request must follow the applicable correction/reinspection workflow and retain links to the earlier withdrawn request.
- The withdrawal capability does not grant authority to withdraw another contractor user's request unless a separately approved delegation rule explicitly permits it.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved workflow requirement only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.

### 14.12 Consultant cancellation of an inspection assignment and reassignment (DEC-036 — approved)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

- The consultant's authorized assignment manager may cancel/revoke the current inspector assignment and assign the inspection to another eligible consultant engineer or team when operationally necessary.
- This is an assignment-management action only. It does not cancel, withdraw, close, or otherwise alter the WIR request; it does not change the affected inspection item, correction/reinspection attempt number, official WIR number, or any recorded inspection outcome.
- The replacement assignee(s) must have an active project assignment and the relevant discipline/scope permissions, consistent with DEC-029 and DEC-030.
- The authorized actor, timestamp, previous assignee(s), new assignee(s), assignment state change, and any supplied reason must be preserved as immutable audit history. A reason remains optional under DEC-030.
- Current assignment state must be distinguishable from the full assignment/reassignment history. Cancelling an assignment must not erase prior assignment records, findings, comments, evidence, decisions, signatures, or actor attribution.
- Assignment cancellation or reassignment does not itself authorize the new assignee to perform unrelated document actions or bypass the applicable inspection workflow and capability checks.
- This decision does not introduce a contractor-side ability to change consultant assignments.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved workflow requirement only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.

### 14.13 Separate WIR-level lifecycle status from inspection-item status (DEC-037 — approved)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

**A. WIR-level status**
- The WIR record must display an overall lifecycle status that describes the state of the request as a whole, independently of the outcome of any individual inspection item.
- The approved overall status vocabulary is:
  1. **Draft**
  2. **Submitted**
  3. **Assigned**
  4. **In Progress**
  5. **Awaiting Contractor Action**
  6. **Awaiting Reinspection Submission**
  7. **Reinspection Submitted**
  8. **Closed**
  9. **Withdrawn**
- The overall status is derived from the current workflow state and all active inspection items; it must not overwrite or replace item-level outcomes.
- **Closed** is used only when no further action remains on the WIR and all applicable items have reached a terminal state. A WIR with any outstanding correction, required response, or pending reinspection must not be shown as Closed.
- **Withdrawn** records a valid withdrawal under the applicable approved withdrawal rules; it is not a substitute for an inspection outcome.

**B. Inspection-item status and outcome**
- Each separately identifiable activity/location/scope item within a multi-item WIR must maintain its own current status, outcome, and history.
- Item-level inspection outcomes remain exactly the four DEC-025 outcomes: **Accepted**, **Accepted with Comments**, **Requires Correction**, and **Not Ready for Inspection**. No additional inspection outcome is created by this decision.
- Item-level workflow status must distinguish at least: **Pending Inspection**, **Inspection In Progress**, **Awaiting Contractor Correction**, **Awaiting Reinspection Submission**, **Reinspection Submitted**, and **Completed**. These are workflow states, not additional inspection outcomes.
- An item with **Not Ready for Inspection** follows DEC-026: the original item/outcome remains immutable, and a new WIR is created when the work is ready, linked to the original item.
- An item with **Requires Correction** remains open through the correction/reinspection workflow and is completed only after the applicable inspection decision resolves it.
- In a multi-item WIR, accepted items may be completed while other items remain active. The WIR overall status must reflect outstanding work and must not falsely close the whole request.
- The UI/reporting layer must show both overall WIR status and each item status/outcome clearly, including the relevant attempt sequence where applicable.

**C. Integrity and history**
- Every status transition must be authorized by the relevant workflow action and capability checks; status must not be freely editable as ordinary text.
- Preserve status transitions with actor, timestamp, source action, and links to the WIR, affected item, and applicable attempt as immutable audit history.
- Status changes must remain consistent with DEC-024 through DEC-036, including correction evidence, formal resubmission, administrative completion requests, contractor withdrawal, and consultant assignment changes.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved workflow requirement only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.

### 14.14 WIR notification channels and user preferences (DEC-038 — approved)

**Status:** owner-approved WIR workflow requirement — 2026-11-11.

- In-app notifications are the mandatory primary notification channel for SiteDocs WIR workflow events.
- Email is an additional notification channel and is optional per user, controlled through that user's notification preferences.
- Disabling email notifications must not disable, suppress, or replace mandatory in-app notifications for events the user is authorized to receive.
- Notifications must be routed only to the relevant authorized users/teams according to project assignment, party, discipline, document visibility, and the specific workflow event. Notification delivery must not disclose draft or otherwise unauthorized information.
- Notifications that require a user action must be distinguishable from informational updates and should identify the relevant WIR/item and the action required, subject to the recipient's access permissions.
- Notification history and read/unread state should be retained within the application. Channel preference affects delivery channel only; it does not alter the underlying WIR workflow, decision, or audit record.
- Event-by-event recipient mapping, urgency rules, batching/deduplication, retry/failure handling, and any additional channels remain to be specified in subsequent design decisions; this decision does not approve SMS, push, or other channels.

**Owner authority:** explicit approval in conversation, 2026-11-11.

**Implementation boundary:** approved workflow requirement only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.

**Remaining WIR design work:** exact form fields; scope-item structure; handling of open/general scope; item outcomes and terminology; partial acceptance; corrective-action ownership and due dates; re-inspection and repeated correction cycles; overall status derivation; authorized reviewer roles; evidence requirements; cancellation/withdrawal; and final closure rules.

**Implementation boundary:** requirements/design only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.


**End of POL-DOC-001 proposal.**


## 13. Phase 1 document-type scope (DEC-023 — approved)

**Status:** owner-approved Phase 1 scope — 2026-11-11. This decision approves the initial catalogue and module boundaries below; it does not approve detailed forms, metadata, numbering profiles beyond DEC-022-A, workflow state machines, role grants, or implementation.

### 13.1 Controlled document types

The initial Phase 1 catalogue includes:

| Type / code | Meaning |
|---|---|
| WIR | Work Inspection Request — inspection of executed work |
| MIR | Material Inspection Request |
| RFI | Request for Information — engineering clarification; fully separate from WIR |
| NCR | Non-Conformance Report |
| SOR | Site Observation Report |
| DLR | Daily Labour Report |
| MQR | Monthly Quality Report — independent review lifecycle |
| Snag List | Defects / outstanding works list |
| WPR | Weekly Progress Report |
| Test Results | Test results and test submissions |

**Type isolation:** WIR, MIR, RFI, NCR, SOR, DLR, MQR, Snag List, WPR, and Test Results are distinct document types. Each requires its own approved type profile for fields, validation, permissions, numbering configuration, workflow actions, reporting, and retention as applicable. RFI must never be treated as an inspection request or merged with WIR. MQR retains its independent review lifecycle and does not inherit generic A/B/C/D/E/I response codes by default.

### 13.2 Phase 1 control modules

The following are approved as control modules/capabilities, not additional document types in the list above:

- Incoming / Outgoing Correspondence — register and control incoming and outgoing communications.
- Transmittals — controlled records of document/file distribution.
- Document Register — searchable register of controlled documents and their identifiers/statuses.
- Archive — permission-controlled preservation and retrieval of records.
- Reports & KPI — reporting and performance indicators across approved document types and workflows.

These modules must preserve links to the underlying document, revision, party, project, workflow, and audit history. A correspondence item or transmittal must not silently become a WIR, RFI, or other document type.

### 13.3 Scope and implementation boundaries

- The catalogue is the approved initial Phase 1 scope. Additional document types may be proposed and approved incrementally without changing the identity or history of existing records.
- Approval of the catalogue does not mean every type is implemented, configured, tested, or available in the current application.
- Detailed per-type form fields, validation gates, review outcomes, sequencing/quorum, return/reject/withdraw/cancel rules, issue/transmittal behavior, retention, closure, and legacy mapping remain open design work.
- The modules listed in §13.2 are approved as functional scope; their exact screens, permissions, integrations, and reporting definitions remain to be designed.
- This is design/requirements approval only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, live-data test, merge, or deployment change is authorized or made.

**Owner authority:** explicit approval of the Phase 1 catalogue and control modules in conversation, 2026-11-11.


## 14.15 — WIR notification priority and acknowledgement (DEC-039 — approved requirement)

**Status:** owner-approved WIR notification requirement — 2026-11-11.

**Approved priority levels:**
- **Critical:** high-impact workflow decisions or events that materially affect the WIR lifecycle or require immediate awareness, such as a formal inspection disposition, withdrawal/cancellation event, or another explicitly classified critical transition. Critical notifications are prominently distinguished and delivered promptly to authorized relevant recipients.
- **Action Required:** an assigned task or response is required from the recipient, such as completing a correction, supplying requested information/evidence, accepting an inspection assignment, or taking a required workflow step.
- **Informational:** status changes or updates that are useful to know but do not require the recipient to act.

**Acknowledgement and retention:**
- Notifications retain their priority, event reference, recipient, creation/delivery timestamps, and read/unread state.
- Reading a Critical notification does not delete it or remove it from notification history. It may be marked as read/acknowledged while remaining retrievable.
- Action-required notifications must remain distinguishable from informational notifications until the required action is completed or the notification is otherwise validly resolved; reading alone does not complete the underlying workflow action.
- Preserve the underlying WIR event and audit history independently of notification state.

**Noise control:**
- Non-urgent informational updates may be batched or deduplicated where doing so does not hide a material event.
- Critical and time-sensitive Action Required notifications must not be delayed or suppressed by informational batching.
- Detailed event-to-priority mapping, acknowledgement semantics beyond read state, escalation timing, delivery retries, and exact presentation remain for later design.
- This decision does not approve SMS, push, or other additional channels; DEC-038 remains controlling for channels.

**Implementation boundary:** requirements/design only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.


## 14.16 — WIR Notification Matrix (DEC-040 — approved requirements direction)

**Status:** owner-approved design direction — 2026-11-11. The WIR Notification Matrix is the central event-to-recipient reference for notification behavior. It operationalizes DEC-038 and DEC-039 without changing WIR workflow outcomes or authority.

| WIR event | Intended recipient(s), subject to authorization and relevance | Priority | Action required? | Resolution rule |
|---|---|---|---|---|
| Formal WIR submission | Authorized consultant intake/discipline team | Action Required | Yes — triage/assignment | Resolved when the authorized intake step is completed |
| Inspector assignment | Newly assigned engineer/team | Action Required | Yes — review/perform assigned step | Resolved by the required assignment/inspection action or valid reassignment |
| Inspector assignment changed | New assignee: Action Required; previous assignee: Informational; authorized assignment manager: Informational | Action Required for new assignee; otherwise Informational | New assignee only | New assignment task is resolved through the required action; history remains |
| Inspection started | Relevant contractor contact/team | Informational | No | Historical event; no acknowledgement required |
| Item disposition **Requires Correction** | Contractor users authorized for the affected WIR/item | Action Required | Yes — carry out correction | Resolved only by the applicable accepted inspection decision, not by reading or declaring correction complete |
| Item disposition **Not Ready for Inspection** | Relevant contractor users | Action Required | Yes — prepare work and submit a new linked WIR when ready | Resolved through the new linked WIR process; original record remains immutable |
| Consultant requests correction details/evidence | Contractor users responsible for the affected item | Action Required | Yes — provide requested details/evidence | Resolved when the requested response is recorded and the contractor separately submits for reinspection where applicable |
| Contractor records **Correction Completed** (without formal resubmission) | Relevant consultant assignee/team | Informational | No formal review action until resubmission | Does not count as reinspection submission; formal submission remains a separate event under DEC-033 |
| Formal **Submit for Reinspection** | Current authorized consultant assignee/team | Action Required | Yes — proceed with reinspection | Resolved by the next authorized inspection workflow action |
| Contractor withdraws a pre-start reinspection request | Relevant consultant assignee/team | Informational | No | Withdrawal event is retained; no attempt increment |
| WIR/item inspection result recorded | Relevant authorized contractor users; other parties only where specifically relevant and authorized | Critical for formal disposition; Action Required for Requires Correction/Not Ready follow-up; otherwise Informational | Depends on result | Read state does not resolve correction/readiness; accepted outcomes are informational unless another configured action remains |
| WIR closes | Relevant authorized parties/users involved in the WIR | Informational | No | Closure is a workflow event; notification remains in history |

**Matrix-wide rules:**
- This matrix is the baseline mapping. Recipient resolution must use active project assignment, party, discipline, item responsibility, document visibility, and relevant capability at event time. Never broadcast to an entire project merely because a person is a member.
- A recipient must not receive a notification that reveals a draft or content they are not authorized to view. Notification previews must contain only information the recipient is permitted to see.
- One underlying event may create distinct recipient-specific notifications with different priorities/actions; preserve one event reference and each delivery/recipient record.
- An Action Required notification is resolved by the corresponding authorized workflow action, not by opening or reading the notification. If the underlying task is reassigned, cancelled, withdrawn, or otherwise validly superseded, update the notification's actionable state while retaining its history.
- Critical events remain promptly delivered and retained. Informational events may be batched/deduplicated only if the event remains discoverable and no material information is hidden.
- Exact event triggers, recipient roles/rosters, notification content templates, escalation/SLA rules, retry behavior, and delivery-failure handling remain detailed design work. Email remains optional under DEC-038; no SMS/push channel is approved.

**Implementation boundary:** requirements/design only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.


## 14.17 — WIR Notification Center (DEC-041 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11. Provide a centralized Notification Center in SiteDocs as the user's in-app workspace for relevant WIR notifications. This operationalizes DEC-038 through DEC-040; it does not replace the underlying WIR workflow, audit trail, or authorization model.

**Core capabilities:**
- Present a chronological notification feed, with priority clearly visible and Critical notifications prominently distinguished.
- Provide views/filters for **All**, **Unread**, **Action Required**, and **Critical** notifications.
- Support filtering by project, document type, and date, subject to the user's authorized project/document scope.
- Each notification must state what happened, the relevant WIR/item where authorized, its priority, and the specific action expected from the recipient when action is required.
- Opening a notification may navigate to the related document/item only after current server-side authorization is verified. If access is absent or has been revoked, do not disclose protected content; show a safe access-unavailable response.
- Preserve read/unread state and notification history. Reading/opening does not complete the underlying workflow action. Action Required status changes only when the linked authorized workflow action is completed or validly superseded, consistent with DEC-039/040.
- Keep notification presentation and status distinct from the authoritative WIR/item status and audit records.

**Access and confidentiality:**
- Display only notifications and preview details the user is currently authorized to see.
- Re-check access when opening a linked document; never rely solely on a previously generated notification or cached link.
- Do not expose draft content or cross-party/project information through titles, snippets, counts, filters, or navigation.
- Email preferences and delivery channel settings remain governed by DEC-038; the Notification Center is the mandatory in-app channel.

**Open design details:** exact screen layout, pagination/retention policy, search behavior, bulk read actions, accessibility, mobile presentation, and notification-history retention period remain to be specified. No additional delivery channel is approved.

**Implementation boundary:** requirements/design only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, tests, merge, or deployment changes are authorized or made.


## 14.18 — WIR Action Reminders and Escalation Policy (DEC-042 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11. Define controlled reminders and escalation for unresolved WIR actions. This supplements DEC-038 through DEC-041; it does not change WIR outcomes, deadlines already governed by other decisions, authority, or workflow state.

**1. Scope and trigger**
- Reminder/escalation applies to an outstanding **Action Required** item/action with a valid responsible recipient and an unresolved workflow action.
- Critical notifications are delivered promptly under DEC-039; they must not wait for a reminder interval or batching cycle. Additional reminders/escalations may apply while the underlying action remains unresolved, according to its configured policy.
- Informational notifications do not generate action reminders.
- A read receipt, notification open, login, or acknowledgement alone does not resolve an action or reset its workflow deadline.

**2. Reminder behavior**
- Send reminders only to the currently responsible, authorized recipient(s) for the specific project, party, discipline, document/item, and action.
- Each reminder must identify the pending action, relevant due/target date when one exists, and a safe link to the authorized WIR/item context.
- Reminders must not imply that a target date exists where none was set, invent a contractual deadline, or change the underlying due date.
- Avoid duplicate or excessive reminders by applying a configurable cadence, deduplication, and quiet-hour/business-calendar rules where applicable. Critical delivery must not be delayed by quiet hours or batching.
- The in-app Notification Center remains the mandatory channel. Email remains optional under DEC-038 and user preferences; no SMS/push channel is approved.

**3. Escalation behavior**
- If an action remains unresolved after its configured escalation threshold, notify only the designated authorized escalation role(s) for that project/party/workflow.
- Escalation is visibility and accountability only. It does not transfer the action, assign an inspector, grant permissions, approve/reject work, submit a WIR, close an item, or perform an action on behalf of the responsible person.
- The original responsible recipient remains accountable unless a separate authorized workflow reassignment is performed and recorded.
- Escalation recipients must be resolved from active assignments and least-privilege capabilities at the time of each escalation. No project-wide or cross-party broadcast.

**4. Stop, pause, and reassessment conditions**
- Stop reminders/escalation for an action once the authoritative workflow records that action as completed, validly superseded, withdrawn, or no longer required.
- Pause or recalculate pending reminders when the workflow is formally placed in a state that removes the recipient's need to act, or when a valid reassignment changes the responsible recipient. Do not silently discard history.
- On reassignment, stop future reminders to the former assignee for that action and resolve the new recipient from the active authorized assignment. Preserve all prior notifications and escalation history.
- Reading/opening a notification does not stop reminders. A reminder must never be used to reopen a closed action.

**5. Audit and reliability**
- Preserve an auditable history of trigger, policy/version, intended recipient, actual delivery attempt/result, reminder sequence, escalation threshold/event, actor/system origin, timestamps, and stop/pause/resume reason.
- Deduplicate repeated processing so retries or background reprocessing do not create duplicate logical reminders/escalations.
- Delivery failure must be visible and retried under a separately defined bounded retry policy; failure to deliver must not falsely mark an action as completed or acknowledged.
- Notification history remains distinct from authoritative WIR workflow and audit records.

**6. Configuration and unresolved details**
- Reminder intervals, escalation thresholds, escalation-role mapping, business calendars/time zones, quiet hours, retry limits, and any event-specific exceptions must be configurable and approved per project/workflow policy. No fixed numeric SLA or contractual deadline is approved by DEC-042.
- Define behavior for overdue items with no target date, recipient unavailability, holidays, and unresolved delivery failures in subsequent detailed design.
- Configuration changes must be versioned and auditable; changes apply prospectively unless an explicitly approved migration rule says otherwise.

**Implementation boundary:** requirements/design only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, scheduler/automation, tests, merge, or deployment changes are authorized or made.


## 14.19 — WIR Role-Based Dashboard and Performance Monitoring (DEC-043 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11. Establish a WIR dashboard with role- and scope-appropriate operational views. The dashboard is a read-oriented monitoring and navigation surface; it does not replace the authoritative WIR workflow, grant permissions, or perform workflow actions.

**1. Role-based views**
- **Contractor view:** show the contractor's authorized WIRs and items, including drafts visible to that contractor, formally submitted requests, assigned/ongoing inspections where visible, items awaiting contractor correction, target dates where recorded, correction evidence status, reinspection submissions, and closed/withdrawn history.
- **Consultant view:** show only the consultant party's authorized workload, including newly submitted WIRs awaiting triage/assignment, assigned inspections, inspections in progress, items awaiting consultant action/decision, reinspection submissions, and overdue/at-risk actions where a valid applicable date/policy exists. Support authorized filtering by discipline, project, assignee, status, and date.
- **Project Manager view:** provide a project-level supervisory overview across the documents and workflow states the PM is authorized to view, including drafts where DEC-021 permits supervisory visibility. This remains read-only for workflow content and decisions: PM visibility does not grant editing, assignment, inspection, review, approval, signature, or closure authority.
- Other roles, including owner/developer and administrative users, see only their explicitly authorized project/party scope and capabilities. No role receives broader access merely because a dashboard exists.

**2. Operational indicators**
- Counts by authoritative WIR status and item status, with clear separation between document-level and item-level states under DEC-037.
- Counts of submitted/unassigned requests, assigned/in-progress inspections, items awaiting contractor action, reinspection submissions awaiting consultant action, and closed/withdrawn records.
- Aging and overdue indicators only where a valid target/due date or separately approved SLA policy exists. Clearly distinguish a target completion date (DEC-031) from a contractual due date or SLA; do not infer one from the other.
- Attempt/reinspection counts must respect DEC-027 and distinguish attempt suffixes from official document numbers and revision numbers.
- Display WIR outcomes separately from workflow statuses. Do not create or imply additional outcomes beyond DEC-025's four approved results.

**3. Filters, drill-down, and data integrity**
- Provide authorized filters for project, party, discipline, responsible assignee, WIR/item status, outcome, and date range where relevant to the user's role.
- Drill-down opens the authoritative WIR/item record only after current server-side authorization is checked. Dashboard cards, counts, charts, search results, and exports must not reveal unauthorized records or metadata.
- Dashboard metrics must be derived from authoritative workflow records and auditable events, not notification read state or client-side assumptions.
- Refresh/last-updated context must be clear; avoid presenting stale or delayed aggregates as live state.
- Preserve distinction between WIR-level status, item-level status, inspection outcome, attempt sequence, and document revision.

**4. KPI governance and fairness**
- KPI definitions, numerator/denominator, exclusions, time basis, grouping, and reporting period must be documented before implementation.
- Separate contractor-controlled durations from consultant-controlled durations and neutral/waiting periods; do not attribute elapsed time to a party that did not own the pending action.
- Do not rank or penalize individuals/parties using raw counts without workload, scope, and time-period context.
- Do not treat Not Ready as Requires Correction, or treat a request for additional information/evidence under DEC-034 as a new inspection attempt.
- No KPI may silently change contractual obligations, workflow outcomes, or authority.

**5. Access, privacy, and audit**
- Enforce deny-by-default, least-privilege server-side authorization for every metric, filter, drill-down, and export.
- Respect draft visibility and party/project boundaries. PM supervisory visibility remains read-only under DEC-021.
- Any future export must use the same authorization and confidentiality rules and have a defined audit trail.
- Dashboard access and relevant exports should be auditable without changing source workflow records.

**6. Open design details**
- Exact dashboard layouts, chart types, KPI formulas and thresholds, refresh cadence, time-zone/calendar rules, export formats, saved views, and retention of aggregate snapshots remain detailed design work and require review before implementation.
- No specific performance target, SLA, contractual deadline, or KPI threshold is approved by this decision.

**Implementation boundary:** requirements/design only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, application code, analytics pipeline, tests, merge, or deployment changes are authorized or made.


## 14.20 — Reports & Analytics: WIR Reporting Foundation (DEC-044 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11. Establish a governed Reports & Analytics capability, beginning with WIR reporting. This is a reporting layer over authoritative workflow records; it does not create or modify WIR decisions, approvals, assignments, or financial entitlements.

**1. Initial WIR report catalogue**
- **WIR Register / Status Report:** WIR identifiers, project, discipline, authorized party context, submission/assignment dates, current WIR status, item-level statuses, and closure/withdrawal state.
- **Inspection Results Report:** the four DEC-025 outcomes, with item-level breakdown and the associated decision date/actor where authorized.
- **Correction & Reinspection Report:** Requires Correction items, correction submissions, requests for further information/evidence under DEC-034, reinspection submissions, and attempt sequence under DEC-027. Distinguish a new inspection attempt from additional information/evidence completion.
- **Not Ready Report:** Not Ready cases and linked subsequent WIR submissions under DEC-026; never merge Not Ready into Requires Correction.
- **Workload & Assignment Report:** unassigned submissions, assigned inspectors, reassignment history, workload by discipline/authorized assignee, and inspection progress.
- **Aging / Turnaround Report:** elapsed time across defined workflow stages, separated by responsible party and neutral/waiting periods. Show overdue only against a valid recorded date or separately approved SLA policy; a DEC-031 target completion date is not automatically a contractual due date.
- **Trend / Recurrence Report:** outcome and correction trends over time, recurring item/observation categories where consistently classified, and discipline/project breakdowns. Avoid implying causation from correlation or incomplete classification.

**2. Common filters and report definitions**
- Support authorized filtering by project, date range, discipline, party, contractor, consultant, assignee, WIR/item status, outcome, and attempt where relevant.
- Each report must define its purpose, data source, row grain (WIR, item, attempt, event), numerator/denominator where applicable, inclusion/exclusion rules, date basis, timezone, and refresh/last-updated behavior.
- Display WIR-level status, item-level status, inspection outcome, attempt sequence, and document revision as separate concepts.
- Use authoritative workflow records and auditable events. Do not derive workflow truth from notification read state, dashboard cache, or user-entered report labels.
- Preserve historical state and actor/time context so reports do not rewrite past decisions when current assignments or status change.

**3. KPI and time-accounting safeguards**
- Separate contractor-controlled duration, consultant-controlled duration, and neutral/waiting duration. Define start/end events and pause/resume rules for every duration metric.
- Do not attribute elapsed time to a party that did not own the pending action.
- Do not rank people or organizations using raw counts without scope, workload, reporting-period, and denominator context.
- Do not count DEC-034 information/evidence follow-up as a new inspection attempt; do not classify Not Ready as Requires Correction.
- No KPI threshold, performance target, SLA, or contractual deadline is approved by DEC-044. Any such threshold requires a separately documented and approved rule.

**4. Access, export, and confidentiality**
- Every report query, filter, aggregate, drill-down, and export must enforce current server-side authorization and project/party/document visibility, including draft restrictions.
- Aggregates must not leak the existence or content of unauthorized records through totals, charts, filter options, or small-group breakdowns.
- Provide PDF and spreadsheet export as the intended report-output formats, subject to authorization, defined column sets, safe handling of formulas/untrusted text, and an audit record of export actor/time/scope. Exact formats and export controls remain detailed design work.
- Clearly label report generation time, selected filters, timezone, and any data freshness limitation. Exports must not be presented as real-time if sourced from delayed aggregates.

**5. Phased scope**
- DEC-044 establishes the Reports & Analytics foundation and the initial WIR report catalogue.
- Reports for other Phase 1 document types/modules must be specified against their own authoritative workflows and approved definitions; WIR rules must not be copied blindly to RFI, MQR, NCR, MIR, or other modules.
- Payment Certificates / financial reporting are explicitly outside this initial WIR reporting scope and will require a separately designed financial module, calculation rules, approval workflow, and data model before reporting is defined for them.

**6. Open design details**
- Exact report layouts, column dictionaries, KPI formulas, chart types, classification taxonomy, refresh cadence, retention, export templates, scheduled distribution, and report-specific role mapping remain detailed design work.
- No scheduled email distribution or new delivery channel is approved by this decision.

**Implementation boundary:** requirements/design only. No database/schema/migration/generated type, Storage, authentication/authorization/RLS, API, UI, reporting/analytics pipeline, export service, tests, merge, or deployment changes are authorized or made.


## 14.21 — Official Report Templates and Controlled Report Outputs (DEC-045 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Purpose:** establish a consistent, auditable template framework for official project reports, beginning with the WIR catalogue defined by DEC-044. A report template is a presentation and records-control layer; it does not replace or amend the authoritative source document or workflow.

**1. Standard report structure**
- Project identity and approved project/party branding, using only authorized and current branding assets.
- Report title/type, unique report reference where configured, reporting period, generation date/time, and issuing context.
- Report purpose, scope, selected filters, inclusion/exclusion criteria, and applicable date basis/timezone.
- Data freshness/last-updated statement and any known source or aggregation limitations.
- Report-specific summary, tables, indicators, definitions, notes, and recommendations where relevant.
- Supporting appendices, attachments, and source references where authorized.
- Report version/revision and a traceable change history for regenerated or corrected report definitions/outputs.

**2. Preparation and review attribution**
- Prepared by, Reviewed by, and Approved by fields may be displayed only when the corresponding action was actually performed by an authenticated, authorized person under the applicable workflow.
- Record the person's identity, role/assignment context, action, and timestamp from authoritative records.
- Do not populate approval fields decoratively, infer approval from report generation, or insert a signature image as a substitute for an authenticated approval event.
- A report's review/approval status is distinct from the approval status of the underlying WIR or other source documents. Generating or exporting a report must not approve, sign, close, or change any source record.
- Electronic signatures on reports are not assumed or approved by DEC-045; any such requirement needs a separate decision.

**3. Report identity, versioning, and reproducibility**
- Distinguish Draft/Preview from Official Generated Report.
- An Official Generated Report must carry a stable report reference/version and a generation timestamp, plus its exact scope, filters, timezone, and data-freshness context.
- Preserve an immutable generated snapshot or equivalent reproducible record of the official output and the report-definition version used to produce it. Regeneration or correction must create a traceable new output/version; never silently overwrite a previously issued report.
- Report numbering rules, version increments, snapshot storage, retention, and correction/supersession labels remain to be specified and approved.

**4. Output formats and usability**
- PDF is intended for controlled, readable, print-ready distribution, with page numbering, consistent headers/footers, and clear continuation of tables across pages.
- Excel/spreadsheet output must contain structured, usable data and meaningful column headings; it must not be merely a screenshot or flattened image of the report.
- Spreadsheet generation must safely handle untrusted text and formula-like values to prevent formula injection. Define column types, date/time representation, numeric precision, and treatment of null/unknown values.
- Exact templates, layouts, column dictionaries, multilingual behavior, and accessibility requirements remain open design details.

**5. Access, export, and distribution controls**
- Recheck server-side authorization at generation, preview, download, and distribution time. Apply the user's current project, party, document, and report-scope permissions to source rows, aggregates, filters, and exported content.
- Prevent unauthorized draft, cross-party, cross-project, or small-group aggregate disclosure in both visible reports and metadata.
- Audit each official generation/export/distribution event with actor, timestamp, report type/definition version, authorized scope, filters, output format, output identity/hash where available, and delivery outcome.
- Distribution recipients and channels must be explicitly authorized and governed; DEC-045 does not approve scheduled email delivery or any new notification channel.
- An official generated report is not automatically an approved report. Any formal report approval or controlled distribution step must be separately defined for the relevant report type.

**6. Scope and exclusions**
- Apply the framework initially to the WIR reports in DEC-044. Other Phase 1 modules require their own report-specific content, metrics, and templates; WIR definitions must not be copied blindly.
- Payment Certificates, valuations, balances, and other financial reporting remain excluded until a separate financial module and its governing rules are approved.
- Reports remain derivative records: they must not modify source WIRs, item statuses, inspection outcomes, attempts, revisions, or audit history.

**7. Open design details**
- Report-specific templates and mandatory fields; branding asset ownership/versioning; report reference and version policy; snapshot storage/retention; formal review/approval workflow; electronic signature requirements; distribution/recipient controls; Excel column schemas and safe-value rules; print layouts; multilingual and accessibility requirements.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, authentication/authorization/RLS/grants, API, UI, reporting pipeline, export service, scheduler, tests, merge, or deployment changes are authorized or made.


## 14.22 — Official Report Review, Approval, Issue, and Distribution Lifecycle (DEC-046 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Purpose:** define controlled governance for reviewing, approving, issuing, and distributing official reports under DEC-045. This lifecycle applies to the WIR reporting catalogue initially; it does not replace the underlying WIR workflow or approve the source records.

**1. Distinct report lifecycle stages**
- **Draft / Preview:** report is being prepared or previewed. It is not an official issued report and must not be represented as approved.
- **Submitted for Report Review:** an authorized preparer submits a fixed report snapshot and its report-definition version, scope, filters, date basis/timezone, generation timestamp, and freshness context for review.
- **Under Review:** assigned authorized reviewer(s) assess the report content, source scope, calculations/definitions, confidentiality, and presentation against the approved report definition.
- **Returned for Correction:** reviewer records the required corrections and reason; the preparer creates a corrected report output/snapshot and resubmits it. Prior snapshots and review events remain preserved.
- **Approved:** the designated authorized approver records an explicit approval against the exact report snapshot/version. Approval cannot be inferred from generation, review completion, silence, or distribution.
- **Issued:** an authorized report-issuing function formally releases the approved snapshot as an official report, with a stable report reference/version and issue timestamp.
- **Distributed:** the issued report is made available or sent to the explicitly authorized recipient set through a separately approved distribution route. Distribution outcome is recorded per recipient/destination where supported.
- **Superseded / Withdrawn:** an issued report later found inaccurate or no longer current is not silently edited or deleted. A controlled superseding report or withdrawal event must identify the affected prior issue, authority, reason, and timestamp; prior recipients and history remain traceable.

These are distinct report-record states, not WIR workflow states. Exact state labels and whether every report type requires every stage remain report-specific configuration decisions.

**2. Role and separation-of-duty controls**
- Preparation, review, approval, issue, and distribution are distinct capabilities. No capability is granted solely because a person belongs to a project team or holds a broad job title.
- Apply DEC-021 deny-by-default, current server-side authorization, active assignment/party/project scope, and separation-of-duties constraints.
- The preparer cannot approve their own report where independent approval is required. Any permitted role combination or exception must be explicitly configured and approved; no self-approval or proxy action is assumed.
- Reviewers and approvers act using their own authenticated accounts. Preserve actor identity, effective role/assignment, action, timestamp, decision, and reason/comments where applicable.
- Project Manager oversight remains read-only unless a separate explicit capability is granted under an approved rule; visibility does not imply review, approval, issue, or distribution authority.
- Recipient access is not an approval capability. Being copied, notified, or able to view/download a report does not authorize changing its status or issuing it.

**3. Snapshot binding and correction control**
- Review and approval apply to one exact immutable report snapshot, including its report-definition version, selected scope/filters, date basis/timezone, generation context, and output identity/hash where available.
- Any material change to report data, scope, filters, calculations, report definition, or content after submission invalidates the pending review/approval for the changed output and requires a new snapshot and applicable review cycle.
- No approval or signature transfers from an earlier snapshot/version to a corrected or regenerated output.
- A non-material presentation-only change may be treated differently only under a separately defined and approved change classification; do not infer this exception.
- If an issued report requires correction, preserve the issued copy and distribution evidence. Issue a new linked version or formally withdraw it through an authorized, auditable action.

**4. Issue and distribution controls**
- Issuance is a distinct authorized action after required report approval and records checks are complete.
- Define recipients by project, party, role, purpose, and explicit report visibility. Apply least privilege and recheck access at distribution and every later preview/download.
- Do not broadcast reports to all project members by default. Do not expose draft previews, restricted party data, or unauthorized aggregates through recipient lists, email subjects/previews, download links, or metadata.
- Distribution must identify the exact issued report version/snapshot, recipient or destination, actor/system authority, channel, timestamp, and success/failure outcome. Retries must not create duplicate or ambiguous issues.
- DEC-046 does not approve a specific channel, automatic/scheduled distribution, public links, or email attachments. Distribution channels, link expiry/revocation, recipient acknowledgement, and failure/retry rules remain open pending separate detailed design.
- A delivery/read/acknowledgement event does not constitute approval of the report or acceptance of its underlying source records.

**5. Audit, retention, and operational integrity**
- Preserve append-only events for submission, reviewer assignment, review decision, return, correction/resubmission, approval, issue, recipient resolution, distribution attempts/results, withdrawal, and supersession.
- Each event should bind to report identity, exact snapshot/version, actor or authorized system process, effective capability/scope, timestamp, and reason/decision where applicable.
- Keep current report state separate from the immutable event history and per-recipient delivery/read state.
- Preserve prior official snapshots and their recipient/distribution history according to a separately approved retention policy. Do not silently overwrite, hard-delete, or rewrite an issued report.
- Report approval/issue/distribution must never modify WIR status, item status, inspection outcome, attempt sequence, revision, source approvals, or source audit history.

**6. Open design details**
- Report-specific mandatory review/approval gates and authorized role mapping; permitted separation-of-duty combinations; reviewer assignment/reassignment; return categories and correction classification; report numbering and supersession/withdrawal conventions; recipient-resolution rules; approved delivery channels; link security/expiry/revocation; recipient acknowledgement semantics; retry/failure handling; retention and legal-hold rules; and whether any report class may be informational-only without formal approval.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, authentication/authorization/RLS/grants, API, UI, reporting pipeline, export service, distribution integration, scheduler, tests, merge, or deployment changes are authorized or made.


## 14.23 — Controlled Document and Official Report Registers (DEC-047 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Purpose:** define controlled registers for locating and monitoring official project documents and generated reports while preserving their distinct identities, workflows, permissions, and histories. The register is an index and navigation layer over authoritative records; it is not a substitute for those records and must not create or alter their lifecycle state.

**1. Separate record classes and register views**
- Provide a controlled Document Register for source project documents and a distinct Official Report Register for report outputs governed by DEC-045 and DEC-046.
- The two registers may be presented through a common navigation area or consolidated search experience, but must retain separate record types, numbering namespaces, lifecycle semantics, permissions, and reporting definitions.
- A report entry must link to its source scope and report-definition version where authorized; it must never be mistaken for a source WIR, revision, transmittal, or approval record.
- A document entry must retain its own document identity and revision history; report generation, issue, or distribution must not create a false document revision or source approval.
- WIR, RFI, MQR, and other document families remain distinct under their approved workflows. Do not impose WIR-specific fields or statuses on other document types.

**2. Minimum register metadata**
- **Document Register:** project, document type, official document number, title/subject, originating party, discipline where applicable, current revision, document-level lifecycle/status dimensions, key issue/submission dates, responsible assignment where authorized, and links to revision, review, transmittal, and archive records where available.
- **Official Report Register:** project, report type, stable report reference, report version, reporting period, generation timestamp, report snapshot/definition version, report lifecycle state under DEC-046, issue date, and distribution summary where authorized.
- Show metadata only when supported by authoritative records. Distinguish unavailable, not applicable, and unknown values; do not fabricate dates, revisions, approvals, recipients, or status.
- Keep current-state summaries separate from historical event details. A current assignee or current revision must not overwrite historical attribution.

**3. Search, filtering, and navigation**
- Support authorized search/filtering by project, record class/type, official reference/number, title/subject, party, discipline, revision/version, lifecycle state, date range, and other type-specific metadata where approved.
- Search results, result counts, autocomplete suggestions, filter options, facets, exports, and error messages must not reveal the existence or metadata of records outside the user's authorized scope.
- Open a record only after current server-side authorization is rechecked. Register visibility does not grant permission to view the underlying file, draft, revision, comments, signatures, or audit events.
- Preserve separate status dimensions and clearly label document status, revision, report status, report version, issue/distribution state, and archive state.
- Provide links between related records only where the relationship is authoritative and the user is authorized to see both sides. Examples include a report and its source WIR scope, a document and its revisions, and a document and its transmittal/archive references.

**4. Integrity, history, and record relationships**
- Registers must derive entries from authoritative document/report records and controlled events, not manually maintained duplicate status fields or notification read state.
- Preserve stable identifiers and historical numbering. Corrections, revisions, supersession, withdrawal, report regeneration, and reissue create traceable linked events/records; never silently overwrite or delete historical register entries.
- Retain provenance for each entry, including source record identity and applicable project/party scope. Register rows must not become an alternative authority for approvals, signatures, inspection outcomes, or distribution.
- Reconcile current register summaries against authoritative source state. Any indexing/cache delay must be disclosed with freshness/last-updated context; stale summaries must not be presented as authoritative real-time status.
- A withdrawn or superseded record remains discoverable to users with historical access, clearly labelled, without being presented as current.

**5. Role-based access and confidentiality**
- Apply DEC-021 deny-by-default and current server-side authorization to list, search, filter, count, preview, drill-down, download, and export operations.
- Enforce project, party, document type, draft visibility, assignment, discipline, capability, and retention/legal-hold restrictions as applicable.
- PM supervisory visibility remains read-only and does not confer document edit, review, approval, signature, issue, or distribution capabilities.
- Avoid cross-party leakage through aggregate counts, small-group filters, recent-activity summaries, or related-record links.
- Exports must apply the same authorization and confidentiality rules as the on-screen register and be auditable by actor, time, scope, filters, and output format.

**6. Scope and exclusions**
- Establish the register design initially for Phase 1 controlled document types and the WIR Official Report Register under DEC-044 to DEC-046.
- Payment Certificates, valuations, balances, and financial registers remain outside this decision until a separate financial module and its governance are approved.
- Exact fields and views remain document-family-specific; this decision does not approve a universal lifecycle or numbering scheme.

**7. Open design details**
- Exact columns and mandatory metadata by document/report type; register ownership and records-control roles; numbering display/search rules; advanced search and saved filters; pagination/sorting; indexing and freshness targets; retention/legal-hold presentation; bulk actions (none assumed); export formats/templates; and report-to-source scope link granularity.

**Implementation boundary:** requirements/design only. No DB/schema/migration/generated type, Storage, authentication/authorization/RLS/grants, API, UI, search/indexing service, reporting pipeline, export service, tests, merge, or deployment changes are authorized or made.


## 14.24 — Advanced Document Search and Retrieval (DEC-048 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Purpose:** provide fast, dependable retrieval across controlled project documents, revisions, official reports, and archived records without weakening confidentiality or confusing record identity.

**Approved search direction:**
- Provide a governed advanced-search experience over the Document Register and Official Report Register established by DEC-047. A unified search entry point is acceptable, but document and report record classes, identifiers, lifecycle semantics, and authorization remain distinct.
- Support exact and partial search where applicable for official document/report reference, title/subject, type, project, originating party, discipline, revision/version, authorized status dimensions, date ranges, current responsible party/assignee, recipient, and transmittal/distribution reference.
- Search related records through explicit, typed relationships: parent/child, prior/superseding revision or record, WIR/item/attempt links where relevant, report-to-source references, and transmittal/distribution links. Do not infer relationships from similar titles or numbers.
- Search archived and superseded records when the user is authorized to retrieve them; clearly identify historical status and preserve the current-versus-historical distinction.
- Results must identify the record class and relevant identity dimensions. Never conflate official document number, document revision, WIR attempt sequence, report reference, or report version.
- Search suggestions, autocomplete, facets, result counts, pagination totals, snippets, highlights, previews, and “no results” behavior must not reveal the existence or metadata of records outside the caller's current authorized scope.
- Enforce current server-side authorization before returning each result and again before opening, previewing, downloading, following a related-record link, or exporting. Search/index permissions must not become a substitute for source-record authorization.
- Apply party, project, discipline, assignment, document visibility, draft confidentiality, and PM read-only oversight rules under DEC-021 and related decisions. A register/search hit does not grant access to the underlying document, revision, attachment, signature, audit trail, or workflow action.
- Search indexes and caches are derived retrieval aids, not authoritative records. They must respect source authorization, support timely permission/revocation changes, and disclose indexing delay or stale freshness where relevant. If authorization cannot be revalidated, fail closed rather than expose cached content.
- Preserve source identities and links when records are revised, superseded, withdrawn, archived, or reissued. Search must not rewrite or silently collapse history; historical results remain distinguishable and traceable.
- Any future export of search results must reapply server-side authorization to the exact result set and fields at export time, record the export event, and protect spreadsheet outputs against formula injection. Export does not authorize bulk access beyond the user's scope.

**Open design details:** exact searchable fields and per-type metadata; tokenization, language/Arabic-English normalization and transliteration; exact-versus-fuzzy matching; ranking and relevance; indexing technology and refresh targets; permission-change invalidation; search syntax; saved searches; pagination limits; retention/indexing of archived records; attachment full-text/OCR scope; result snippets/highlighting; bulk selection; export templates and audit details; and role-specific search layouts. These require separate design and validation before implementation.

**Implementation boundary:** requirements/design only. No database/schema/migration/generated type, Storage, auth/RLS/grants, API/UI/code, search engine/index, OCR pipeline, cache, export service, tests, merge, or deployment changes are authorized or made. See DEC-048 in the Master Decision Register and Section 53 in the Decision Implementation Traceability document.


## 14.25 — Document and Report Notifications (DEC-049 — approved design direction)

**Status:** owner-approved design direction — 2026-11-11.

**Purpose:** establish a coherent notification framework for controlled documents and official reports while preserving each document family's workflow, priority rules, recipients, and action semantics.

**Approved notification direction:**
- Provide a central in-app notification experience across authorized Phase 1 document and report modules. The central experience is a common presentation and retrieval layer, not a single generic workflow or a replacement for module-specific notification rules.
- Preserve the WIR notification matrix and its priorities/reminder rules under DEC-038–DEC-042. WIR events, outcomes, recipient logic, and action-resolution semantics must not be reinterpreted by this cross-module framework.
- Support notifications for other document families and official report lifecycle events only from their authoritative, separately governed workflow events. Candidate event families include formal submission, assignment/reassignment, review/return, correction request, approval, issue, transmittal/distribution, withdrawal, supersession, archive/records exception, and delivery failure where an authorized response is required.
- Distinguish **Critical**, **Action Required**, and **Informational** priorities consistently at the presentation layer. Priority assignment and event-to-recipient mapping must be defined per document family/report lifecycle; do not assume every event uses the same priority or that every report event requires action.
- Each notification must identify the event, record class and authorized reference, relevant project/context, priority, timestamp, intended recipient, and expected action when one is genuinely required. Show only metadata and snippets permitted to that recipient.
- Resolve recipients using current authorized project assignment, party, discipline, responsibility, workflow step, record visibility, and required capability. Project membership, a historical assignment, or a broad role label alone is insufficient.
- Recheck current server-side authorization when listing notifications, calculating counts/facets, opening a notification, navigating to a record, previewing or downloading related content, and taking the linked action. Revoked access must not be bypassed by an old notification or deep link.
- Reading, opening, dismissing, or acknowledging a notification does not perform, approve, sign, issue, distribute, or close the underlying workflow action. Action Required is resolved only by the authoritative action or valid supersession/cancellation defined by that document family's policy.
- Preserve immutable event/recipient history, priority, creation time, delivery attempts/outcomes, read/acknowledgement state, linked workflow resolution, and any policy/version used to generate the notification. Notification state remains distinct from source-document/report status and audit history.
- Deduplicate repeated technical delivery attempts without hiding distinct material business events. Grouping/batching may be used for non-urgent informational items only where each underlying event remains individually retrievable. Do not delay Critical or urgent Action Required notifications through batching.
- In-app delivery is the mandatory baseline. Email remains optional and user-preference-dependent under DEC-038. SMS, push, public links, and default broadcast distribution are not approved by this decision.
- Reminders and escalation must follow DEC-042 principles: unresolved Action Required only, current responsible authorized recipients, configurable separately approved thresholds, no responsibility transfer or capability grant, and complete audit. Do not invent fixed SLA/contractual deadlines.
- Report notifications must identify the exact report snapshot/version and distinguish review, approval, issue, and distribution events under DEC-045/046. They must not imply that report approval approves source WIRs/documents or changes their lifecycle.
- Notification previews, search, filters, counts, email content, and grouped summaries must not expose drafts, confidential content, unauthorized party/project records, or hidden recipients. PM supervisory visibility remains read-only under DEC-021.

**Open design details:** per-document-family event catalogues and priority mapping; role/recipient resolution matrix; templates and localization; aggregation and deduplication windows; user preference controls; read/acknowledgement labels; reminder schedules and escalation thresholds; quiet-hour behavior for non-critical events; delivery retry/failure handling; email content/link security; retention; pagination/search; accessibility/mobile presentation; and operational monitoring. These require separate review and must not be inferred as defaults.

**Implementation boundary:** requirements/design only. No notification tables/schema/migration/generated types, event bus, scheduler, API/UI/code, email provider/configuration, push/SMS integration, auth/RLS/grants, tests, merge, or deployment changes are authorized or made. WIR-specific rules in DEC-038–DEC-042 remain controlling for WIR.


### 14.26 DEC-050 — Document Transmittals & Distribution Control

**Decision status:** owner-approved design direction — 2026-11-11. Requirements/design only.

**Purpose and separation**
1. Establish a controlled Transmittal record for the formal issue or distribution of documents and Official Reports between authorized project parties.
2. A Transmittal is a distribution record, not a source document, report, revision, approval, review decision, or workflow completion. Creating, issuing, delivering, acknowledging, re-sending, or withdrawing a Transmittal must not itself revise or approve a source record or complete a WIR, RFI, or other source workflow.
3. Keep Document Register and Official Report Register records distinct from Transmittal records. A shared interface may be considered, but record identity, numbering, lifecycle, authorization, and audit history remain separate.

**Controlled transmittal manifest**
4. Each Transmittal has a stable internal identity and a controlled reference; reference format and numbering rules remain open.
5. Preserve an immutable manifest identifying each included record by its authoritative ID and record class, exact document revision or exact Official Report snapshot/version, title/reference, relevant file identity and integrity hash where applicable, stated purpose/status, and intended recipient(s).
6. Record the initiating and issuing actors, their authority, originating party, project, issue timestamp and timezone, distribution channel, recipient identity and party, and stated purpose. Candidate purposes such as For Review, For Approval, For Information, For Construction, and As-Built are examples only; applicability and controlled values require document-family/contract review and are not universal defaults.
7. Validate eligibility before issue: source record exists and is accessible to the sender; required source approval/issue gates are satisfied; exact frozen revision/snapshot is selected; manifest and recipients are complete and authorized; and drafts or unintended versions are excluded.

**Recipient authorization and access**
8. Resolve recipients as individually identified, authorized parties/users under the applicable project assignment, party, document visibility, and capability rules. Project membership or historical involvement alone is insufficient. No default project-wide broadcast.
9. A Transmittal does not grant access to its listed documents, reports, revisions, files, or attachments. Each recipient's access must be independently authorized and rechecked server-side at preview, retrieval, download, and any acknowledgement/action.
10. Do not expose hidden recipients, unauthorized manifest entries, titles, counts, previews, or file metadata to other recipients. PM supervisory visibility remains read-only under DEC-021 unless a separate explicit capability is approved.

**Issue, delivery, and acknowledgement**
11. Keep dispatch, technical delivery, and human acknowledgement as distinct facts. A successful technical receipt does not prove that a person read, reviewed, accepted, approved, or acted on the contents.
12. Model lifecycle dimensions without conflating them: Draft/Created, Validated, Issued/Dispatched, Delivered, Partially Delivered, Failed, Acknowledged (only where acknowledgement is required), and controlled Superseded/Cancelled/Withdrawn states where an authorized action permits them. Exact state machine and whether acknowledgement is required are open.
13. Track each recipient separately: intended recipient, channel, dispatch attempts, outcome, timestamps, technical receipt evidence, human acknowledgement where required, and failure reason. A mixed outcome must never be represented as fully delivered; partial failure remains visible.
14. Retries must be bounded, deduplicated, and auditable. A retry of the same issue preserves the exact manifest and Transmittal identity/history unless a separately controlled reissue creates a new Transmittal.
15. Re-sending the same exact package must not create a source revision. Any changed content, recipient scope, or manifest requiring a new issue must create a new controlled Transmittal with an explicit relationship such as supersedes or withdraws the prior Transmittal; preserve both histories and their delivery evidence.

**Channels, records, and security**
16. No particular channel, email attachment, public link, or externally accessible link is approved by this decision. Channel selection, secure-link design, expiry, authentication, packaging, and delivery evidence require separate approval. Public links are not a default.
17. Preserve an append-only issue snapshot/manifest and audit trail, including actor, authority, exact included record versions, recipient resolution, policy context, channel, timestamps, attempts, outcomes, acknowledgements, and supersession/withdrawal relationships.
18. Link Transmittals to the relevant Document Register and Official Report Register records without changing those source records. Transmittals must be searchable by reference, project, date, sender, recipient, record type/reference, and authorized status, subject to server-side authorization for results, counts, facets, previews, downloads, and exports.
19. Apply DEC-021 deny-by-default and least privilege to create, validate, issue, send, resolve recipients, preview, download, acknowledge, retry, cancel, supersede, and withdraw. Recheck authorization at action time and audit every material action. Possession of a Transmittal reference or link must not bypass access revocation.
20. Transmittal actions do not substitute for source workflow actions, approvals, signatures, review responses, or contractual notices unless a separate approved policy expressly defines a specific legal/contractual effect. No delivery deadline, deemed receipt, acceptance, or contractual service level is established here.

**Open design details:** numbering/reference format; record-family eligibility gates and purpose vocabulary; sender/issuer role mapping; recipient resolution and external-recipient identity; per-recipient acknowledgement requirements and legal effect; delivery channels and secure-link controls; file packaging and size/type limits; retry/deduplication rules; partial delivery/reissue semantics; cancellation/withdrawal authority; retention/legal hold; multilingual templates; and report/transmittal export formats. Resolve these in separately reviewed designs without assuming contractual rules.

**Implementation boundary:** design only. No database/schema/migration/generated types, storage/bucket changes, auth/RLS/grants, API, UI, delivery provider/channel configuration, public links, tests, merge, or deployment changes are authorized or made by DEC-050.


### 14.27 DEC-051 — Controlled Document Distribution & Access Receipts

**Decision status:** owner-approved design direction — 2026-11-11. Requirements/design only.

**Purpose and separation**
1. Define how each authorized Transmittal recipient obtains access to the exact records and versions listed in its manifest, and how access-related evidence is recorded.
2. Keep four concepts distinct: dispatch/delivery under DEC-050; authorization to access a source record; technical access events (such as opening or downloading); and any separately required human acknowledgement. None of these, by itself, constitutes review, acceptance, approval, consent, or completion of a source workflow.
3. An access receipt is an audit fact about a specific access event and identified recipient/account. It is not a signature, legal proof of comprehension, or evidence that the recipient accepted the contents.

**Recipient access control**
4. Access must be granted only to individually resolved recipients who are authenticated and currently authorized for the specific project, party, record, revision/report snapshot, and requested operation. A Transmittal listing alone does not confer access.
5. Re-evaluate authorization server-side at each preview, open, download, attachment retrieval, and acknowledgement action. Enforce least privilege and deny by default under DEC-021; do not rely on client-side hiding, possession of a URL/reference, cached membership, or a prior successful access.
6. A recipient may access only the manifest entries explicitly intended for that recipient and independently authorized. Do not reveal other recipients, hidden manifest entries, or unauthorized metadata through the transmittal page, counts, previews, search, notifications, or error messages.
7. Access is bound to the exact immutable document revision or report snapshot/version in the Transmittal manifest. It must not silently resolve to the latest revision or a replacement file. If the exact version is unavailable or its authorization cannot be confirmed, fail closed and record the access failure without exposing content.
8. Recipient identity must be attributable to an authenticated account or a separately approved controlled external-recipient identity process. Shared accounts, anonymous public links, and attribution based only on a typed name are not acceptable evidence of an individual access event.

**Access receipts and audit evidence**
9. Where technically observable, record distinct events such as access-link issuance, successful authentication, authorized preview/open, download initiation, completed download where reliably measurable, access denial, and acknowledgement submission. Do not label a download as completed if only its initiation is known.
10. Each event should bind to Transmittal ID, exact manifest entry/source record and revision or report snapshot, recipient identity, actor/session context sufficient for security audit, event type, timestamp/timezone, authorization outcome/policy context, and relevant technical result. Avoid collecting unnecessary device or personal data; exact telemetry fields and retention remain open.
11. Preserve access events append-only. Corrections or annotations must be additional auditable events; no rewriting a prior receipt to imply a different outcome.
12. Distinguish system-generated access evidence from an explicit recipient acknowledgement. If acknowledgement is required by an approved transmittal policy, capture the authenticated actor, exact Transmittal/manifest version, acknowledgement wording/type, timestamp, and policy version. Do not infer acknowledgement from opening, viewing, downloading, email delivery, or link clicks.
13. Acknowledgement labels and meaning must be explicit and neutral (for example, receipt acknowledged versus review response submitted). Do not use ambiguous “Accepted” or “Approved” acknowledgements unless a separately governed workflow and authority expressly require that decision.
14. Access receipt or acknowledgement does not satisfy a source document review, technical response, approval, signature, WIR inspection, RFI response, or contractual notice requirement unless a separately approved policy expressly defines that effect.

**Revocation, supersession, and withdrawal**
15. When recipient assignment, project membership, party authorization, record visibility, or a relevant capability is revoked or expires, prevent future access as soon as the authoritative change takes effect. Recheck authorization on every request; cached pages, tokens, signed URLs, and sessions must not bypass revocation. Token invalidation and maximum exposure windows require separate security design.
16. Revocation affects future system-controlled access; it cannot guarantee deletion or recall of files already downloaded, printed, copied, or otherwise retained outside the system. Do not claim remote deletion or recall unless a separately approved technical control can prove it.
17. When a source revision/report snapshot is superseded, withdrawn, corrected, or made unavailable, preserve the original Transmittal and its access history. Mark the relationship and status clearly, prevent accidental substitution, and notify affected authorized recipients according to the approved notification policy. Access to historical versions remains subject to current authorization and retention/legal-hold rules.
18. A replacement or corrected version must be distributed through a new controlled Transmittal under DEC-050, explicitly linked to the superseded/withdrawn package. Do not mutate the original manifest or its receipts.
19. Transmittal cancellation/withdrawal or recipient removal must not erase prior dispatch, access, or acknowledgement evidence. The authority and effect of cancellation/withdrawal remain governed by DEC-050 and separately approved rules.

**User experience, reporting, and governance**
20. Authorized senders may see per-recipient delivery and access states only within their permitted scope. Recipients see only their own authorized manifest entries and their own access/acknowledgement state. Any broader oversight view requires a separately granted capability; PM remains read-only and must not gain issue, revoke, or recipient-management powers from supervisory visibility.
21. Display states precisely, distinguishing not yet accessed, access attempted, preview/open recorded, download initiated/completed where measurable, access denied, acknowledgement pending, and acknowledged. Do not imply a person has read or understood a file from a technical event.
22. Access receipts may support audit and reporting, but analytics must disclose the event definition, measurement limitations, timezone, and freshness. Do not use access telemetry alone as a performance score or proof of contractual notice.
23. Apply authorization to access histories, recipient-level reports, exports, search, notifications, and audit views. Prevent cross-party leakage and unauthorized inference from recipient counts or aggregate access states.

**Open design details:** external-recipient identity proofing; authentication strength and step-up requirements; secure viewer/download behavior; token/session expiry and revocation latency; offline/print controls and their limits; exact event taxonomy and telemetry minimization; acknowledgement wording and when it is mandatory; recipient and sender visibility; notification rules for supersession/revocation; retention/legal hold; audit export; and any contractual/legal evidentiary effect. These require separate security, operational, and contractual review.

**Implementation boundary:** design only. No identity provider/auth configuration, session/token changes, signed URL implementation, storage/bucket changes, schema/migration/generated types, RLS/grants, API/UI, telemetry, notification provider, tests, merge, or deployment changes are authorized or made by DEC-051.


### 14.28 DEC-052 — Document Acknowledgement & Response Management

**Decision status:** owner-approved design direction — 2026-11-11. Requirements/design only.

**Purpose and distinct action types**
1. Establish a controlled framework for recording recipient acknowledgements and formal responses to Transmittals without conflating them with delivery, access, source-document review, approval, or contractual acceptance.
2. Keep these action types distinct:
   - **Delivery receipt:** technical evidence that a delivery channel reported a delivery outcome, governed by DEC-050.
   - **Access receipt:** system evidence of an authenticated access event, governed by DEC-051.
   - **Acknowledgement of receipt:** an explicit recipient confirmation that a specified Transmittal/package was received.
   - **Acknowledgement of review/awareness:** an explicit confirmation of review or awareness, only where the applicable process requests it. It is not technical approval.
   - **Formal response:** a substantive response submitted by an authorized person against a defined request and exact Transmittal manifest/version.
   - **Source workflow decision:** review, approval, rejection, acceptance, inspection result, or other decision governed by the source document's own workflow and authority.
3. No action type implies another. Delivery, opening, downloading, receipt acknowledgement, or review acknowledgement must not be treated as a formal response, approval, acceptance, signature, or completion of a source workflow.
4. Silence, non-response, email read status, or expiry of a requested response period must not be interpreted as deemed acceptance, approval, consent, or waiver.

**Request and response definition**
5. A Transmittal may specify whether a recipient response is required, optional, or not requested. The requirement must be explicit per recipient and, where relevant, per manifest entry; it must not be inferred from a generic Transmittal status.
6. For each requested response, preserve the request originator and authority, intended recipient, exact Transmittal and manifest version, relevant source record/version, requested response type, clear instructions, requested-by timestamp, and any target response date if supplied.
7. A target response date is for tracking only unless separately governed by an approved contractual/SLA policy. This decision creates no response deadline, deemed receipt rule, escalation threshold, or contractual consequence.
8. Response categories and templates must be selected by document family and approved process. Candidate categories such as Acknowledged, Comments Provided, Clarification Requested, No Objection, Objection, or Formal Review Response are examples for later design, not a universal status or approval code set. Existing WIR/RFI/MQR and other source-specific outcomes remain governed by their own decisions.
9. Do not use a generic “Approved” or “Accepted” response to bypass a source workflow, required reviewer, authority matrix, signature, or separation-of-duties control.

**Submission, identity, and integrity**
10. A formal acknowledgement or response must be submitted by an authenticated individual whose current assignment and capability authorize that specific action for the recipient party, project, Transmittal, and requested response type.
11. Preserve the acting account/person, represented party, role/capability context, timestamp/timezone, exact Transmittal/manifest version, source record/revision references, response category, structured answers and narrative, and attachments/evidence identities and hashes where applicable.
12. The response is an immutable event/record. Corrections or supplements create linked subsequent records with explicit relationship and history; they do not overwrite or erase the original submission.
13. The submitter must be able to review the exact response and included evidence before final submission. Draft response content remains private to its authorized author/team until formally submitted, subject to separately approved supervisory visibility; it must not leak to other recipients.
14. A submitted response may be withdrawn or superseded only through an explicitly authorized, auditable action and only where the applicable source/contract process permits it. Preserve the original and its status/history.
15. A response attachment does not automatically become a source document revision or official record attachment. Its classification, retention, visibility, and any formal incorporation into a source record require explicit rules.

**Routing, status, and follow-up**
16. Route each response only to the authorized originator/recipient roles and source workflow participants who need it, applying server-side authorization and least privilege. Do not broadcast responses to every Transmittal recipient by default.
17. Track response state separately from Transmittal delivery and access state. Candidate tracking labels include Not Requested, Requested, Draft, Submitted, Under Review (only if a defined review is required), Clarification Requested, Superseded, Withdrawn, and Closed. These are tracking candidates, not a universal lifecycle; per-family state models remain open.
18. If a response is incomplete or clarification is needed, record the request, actor, reason, scope, and timestamps. A clarification exchange does not silently alter the original Transmittal manifest or source revision and does not itself constitute a source workflow decision.
19. Reassignment, recipient changes, or access revocation must not rewrite prior authorship or responses. Future actions require current authorization; preserve historical identity and access evidence.
20. Notifications and reminders follow DEC-049 and DEC-042 principles: notify only authorized relevant recipients; reading/acknowledging a notification does not submit a response; no unapproved fixed SLA or escalation threshold.
21. Dashboards and reports must distinguish delivery, access, acknowledgement, response submission, source review, and approval. Do not calculate completion from a read/open event or infer acceptance from non-response.

**Security, audit, and legal boundaries**
22. Apply DEC-021 deny-by-default, capability separation, active assignment checks, server-side authorization, and separation of duties to request creation, recipient routing, acknowledgement, response drafting/submission, review, withdrawal, and access to response history.
23. Preserve append-only audit evidence for request creation/change, recipient resolution, draft visibility where audited, submission, clarification, reassignment, withdrawal/supersession, notification, and resolution. Record policy/version context and outcomes.
24. Protect response content and attachments in search, previews, notifications, exports, and analytics; no cross-party or unauthorized recipient leakage. PM visibility remains read-only and does not confer response, review, or approval authority.
25. Legal effect, contractual notice, deemed receipt, required acknowledgement, response deadlines, retention, evidentiary admissibility, and external-party identity assurance require separate legal/contractual and security review. This decision does not establish them.

**Open design details:** response type catalogue by document family; mandatory versus optional acknowledgements; recipient and originator routing; response forms and attachment rules; review/clarification cycles; response due-date and calendar semantics; reminders/escalation; external recipients; withdrawal/correction rights; retention/legal hold; localization; reporting metrics; and legal/contractual effect.

**Implementation boundary:** design only. No schema/database/migration/generated types, notification changes, auth/RLS/grants, API/UI, storage, response forms, workflow automation, tests, merge, or deployment changes are authorized or made by DEC-052.


### 14.29 DEC-053 — Document Revision, Supersession & Withdrawal Control

**Decision status:** owner-approved design direction — 2026-11-11. Requirements/design only.

**Identity and revision integrity**
1. Maintain one stable logical identity for each controlled document and a separately identifiable, immutable record for every formal revision. A revision is not a new unrelated document; it is a new controlled version within the same document identity unless an approved document-family rule explicitly defines otherwise.
2. Preserve the distinctions among official document number, revision identifier, WIR attempt suffix, report reference/version, Transmittal reference, and internal draft ID. These identifiers must never be substituted for one another.
3. Apply DEC-022-A/B: allocate the official document number at first successful formal submission; initial formal revision is Rev.00; a material change to controlled content after return creates the next revision; resubmission without a material controlled-content change retains the same revision. Revision numbering must be sequential and auditable within the document identity.
4. Each revision is an immutable snapshot of its controlled content and associated metadata, with creator/submitter, timestamps, source file identities/hashes, submission and workflow events, review/approval/signature evidence, and links to predecessor/successor revisions. No overwrite, destructive replacement, or reuse of a revision identifier.
5. Define material versus non-material changes by separately governed document-family rules. Do not silently classify a content change as metadata-only to avoid a new revision. Record the comparison basis and actor when a change classification is made.
6. A revision under preparation remains a draft and must not replace the current formally issued/approved revision in registers, Transmittals, reports, or recipient views. Draft visibility follows DEC-021.

**Current revision and supersession**
7. Distinguish the latest created revision from the current effective/issued revision. A newer draft, submitted revision, or unapproved revision does not automatically supersede the current effective revision.
8. A revision becomes current/effective only after the applicable document-family workflow and formal issue gate are completed by authorized actors. The exact gate varies by family and remains subject to the relevant approved workflow.
9. Supersession is an explicit, auditable relationship from a prior revision to a specific replacement revision. Preserve the superseded revision and all its prior approvals, signatures, Transmittals, access receipts, acknowledgements, responses, and audit events.
10. Display a clear historical/superseded marker and identify the replacement revision where the viewer is authorized to see it. Do not silently redirect an old reference or link to a new revision.
11. Historical revisions remain retrievable only where current authorization and retention/legal-hold rules permit. Historical availability does not mean the revision remains valid for current construction/use.
12. A controlled current-revision indicator must be derived from authoritative lifecycle events, not from maximum revision text, upload time, or client-side sorting. Registers and search must disclose status and freshness and must not leak restricted revisions.

**Withdrawal, cancellation, and suspension**
13. Distinguish withdrawal of a document/revision from cancellation of a Transmittal, rejection/return within review, and supersession by a replacement. These are separate actions with separate authority and consequences.
14. Withdrawal is an explicit controlled action by a specifically authorized actor under the relevant document-family policy. Require a reason, scope (whole document identity or specific revision), timestamp, actor, authority, and any required supporting reference. The exact eligible states and approval gates remain open.
15. Withdrawal must not delete or rewrite the document, revision, approval/signature history, or past distribution/access evidence. Mark the affected record as withdrawn and prevent new issue/use actions according to approved policy.
16. If withdrawal affects previously distributed material, identify affected Transmittals and authorized recipients, preserve historical access evidence, and issue controlled notifications/instructions under DEC-049/050/051. Do not claim that external downloaded/printed copies have been recalled or deleted.
17. If withdrawal is followed by a replacement, create a new revision or new controlled document identity as required by the document-family rule, link the relationship explicitly, and distribute the replacement through a new Transmittal. Never mutate the withdrawn snapshot.
18. Cancellation of an unissued draft or pending submission must be distinguished from withdrawal of an issued/effective revision. Cancellation rules must preserve audit evidence and must not consume or erase an already allocated official identity/number contrary to DEC-022.
19. A temporary hold/suspension may be considered as a separate status for urgent safety/quality/legal controls, but is not established as a universal status by this decision. Its authority, scope, notifications, release conditions, and effect on ongoing work require separate approval.

**Cross-system consistency and security**
20. Bind Transmittals (DEC-050), access receipts (DEC-051), acknowledgements/responses (DEC-052), reports, registers, and search results to exact document identity and revision. No component may silently resolve to “latest” when the recorded relationship identifies a specific revision.
21. When a revision is superseded or withdrawn, update derived current-status indicators and authorized recipient notices without modifying historical events or manifests. Preserve exact prior state at each event time.
22. Recheck server-side authorization for current and historical revisions, files, previews, exports, and relationship navigation. Supersession or withdrawal does not itself grant access to replacement versions.
23. Prevent a stale download link or cached UI from presenting an old revision as current. Link validity, cache invalidation, and signed URL/session revocation require separately reviewed technical controls; fail closed when status or authorization cannot be verified.
24. Apply DEC-021 deny-by-default and separation of duties to revision creation, submission, review, approval, issue, supersession, withdrawal, restoration/reinstatement if ever approved, and historical access. PM visibility remains read-only and does not confer these capabilities.
25. Preserve append-only audit of revision creation, material-change classification, submission, review/approval, issue, supersession, withdrawal/cancellation, notifications, affected Transmittals, and recipient impact.

**Reporting and operational use**
26. Reports and registers must separately expose document identity, revision, lifecycle/effective status, supersession/withdrawal status, and relevant dates. Do not conflate latest revision with current effective revision.
27. Historical analytics must use the status and relationships applicable at the selected reporting time or explicitly disclose current-state reporting. Never rewrite historical outcomes because a later revision superseded an earlier one.
28. Prevent withdrawn or superseded revisions from being presented as current in construction-facing views, dashboards, exports, or search. Any permitted historical retrieval must be clearly labelled and access-controlled.

**Open design details:** material-change taxonomy by document family; revision numbering exceptions; issue/effective gates; authority and evidence for withdrawal; cancellation of drafts/pending submissions; temporary hold/suspension policy; reinstatement rules; effect on open workflows and linked records; recipient notification/instruction templates; retention/legal hold; historical access; cache/link invalidation; and register/report display semantics. Resolve through separately reviewed family-specific and security designs.

**Implementation boundary:** design only. No schema/database/migration/generated types, file/storage mutation, auth/RLS/grants, API/UI, numbering logic, workflow automation, notifications, search/index changes, tests, merge, or deployment changes are authorized or made by DEC-053.


### 14.30 DEC-054 — Document Retention, Archiving & Legal Hold

**Decision status:** owner-approved design direction — 2026-11-11. Requirements/design only.

**Purpose and records in scope**
1. Establish governed retention, archival, preservation, legal-hold, and authorized disposition controls for project documents and their associated records throughout the document lifecycle.
2. Apply the policy, subject to approved record-class schedules, to source documents and all revisions; drafts where retention is required; submissions, review comments, decisions, approvals, signatures, and audit events; attachments and scan evidence; Transmittals and manifests; access receipts; acknowledgements and formal responses; official reports and their snapshots; register entries; and relevant notification/delivery evidence.
3. Preserve relationships and provenance across the record set. A source document must not become unintelligible because its revision, attachment, approval, Transmittal, response, or audit evidence was retained or disposed of independently.
4. Distinguish operational status (current, superseded, withdrawn, closed, archived) from retention status (active retention, eligible for review, legal hold, approved for disposition, disposed). Archiving does not itself mean retention has expired or that deletion is permitted.

**Retention schedules and start events**
5. Define retention schedules by record class, project/contract context, jurisdiction, and approved business/legal requirements. No universal retention period, statutory period, contractual period, or expiry date is established by this decision.
6. For each schedule, document the authoritative retention trigger (candidate examples include project completion, final handover, contract closeout, final account, warranty expiry, or record creation), calculation rules, applicable calendar/timezone, minimum period, review owner, and governing source. These are candidate triggers, not defaults.
7. Where multiple applicable requirements exist, preserve the record for the longest applicable approved period unless a competent legal/records authority directs otherwise. Conflicts, uncertainty, or missing schedule classification must prevent automatic disposition and route to an authorized review.
8. Retention clocks and eligibility calculations must be explainable and reproducible from recorded source events and the schedule version applied. Schedule changes must be versioned and must not silently rewrite historical calculations.
9. A retention date passing makes a record eligible for review only; it does not automatically authorize deletion or destruction.

**Archive and preservation**
10. Archive is a controlled state/location for records no longer in active operational use, not a deletion mechanism. Preserve stable identity, original content, revision/version, metadata, relationships, approvals/signatures, and audit provenance.
11. Archived records remain discoverable only to authorized users under current access rules. Archive status does not grant broader visibility or weaken DEC-021 authorization. Historical access must be clearly labelled and must not imply current validity for construction or operational use.
12. Preserve file integrity through recorded identities and hashes where technically supported, with periodic integrity verification and auditable results. Any migration, format conversion, or archival packaging must preserve the original and document the transformation, tool/version, actor/process, time, and validation outcome.
13. Preserve sufficient rendering capability and contextual metadata to interpret records over time, including relevant timezones, controlled vocabularies, relationships, and signatures. Format migration must not silently alter the authoritative original.
14. Backups, replicas, exports, and disaster-recovery copies are not substitutes for a governed archive or retention schedule. Define their separate lifecycle, restoration, expiration, and legal-hold behavior.
15. Storage lifecycle, encryption, key management, geographic residency, redundancy, recovery objectives, archival media, and integrity-check intervals require separate security/operations design; this decision does not select a technology or service.

**Legal hold and preservation suspension**
16. Support a controlled Legal Hold as an overriding preservation restriction that suspends otherwise scheduled disposition for the records within its defined scope. A hold does not itself change source-document approval, revision, or operational status.
17. A hold must be created or released only by an explicitly authorized legal/records authority under an approved policy. Record hold identifier, matter/reference, authority, creator, timestamp, reason/category, scope, affected projects/record classes/identities, custodians or parties where applicable, effective date, review date, and release authority/evidence.
18. Scope must be explicit and sufficiently granular to identify relevant records and associated evidence, including revisions, attachments, Transmittals, access/response history, reports, and audit records. Preserve relationships and prevent dependent evidence from being disposed of while needed to interpret held records.
19. On hold activation, suspend automatic and manual disposition for affected records and controlled copies under system control. Record which scheduled actions were blocked and notify authorized records administrators. Fail closed if hold applicability cannot be determined.
20. A record may be subject to multiple holds. Releasing one hold does not release another; disposition review may proceed only when all applicable holds and other preservation restrictions are cleared.
21. Hold release requires recorded authority, timestamp, scope, reason, and review of remaining retention obligations. Release does not trigger immediate deletion; the record returns to the appropriate retention/review state.
22. Emergency preservation or hold extensions require an approved procedure and audit. Exact response time, escalation, periodic review cadence, and external legal notification are open; do not invent them.

**Disposition and destruction**
23. At the end of an approved retention period, route records to a controlled disposition review. Verify schedule, trigger, record class, project/contract obligations, open claims/disputes/audits/investigations, legal holds, linked records, and any required approvals before disposition.
24. Require an authorized disposition decision with recorded reviewer/approver identities and authority, scope, schedule/version, rationale, date, and evidence. Separation of duties and DEC-021 capability controls apply; no self-approval where prohibited.
25. Preserve a non-content disposition audit record sufficient to prove what class/identity was disposed of, under which authority and schedule, when, by whom/process, and with what result, subject to applicable law and privacy requirements. The required audit content and whether limited metadata must remain are open for legal/records review.
26. Destruction must be controlled across primary storage, managed replicas, caches, search indexes, and backup cycles to the extent technically and contractually possible. Record limitations and completion evidence; do not claim immediate erasure from immutable/offline backups unless verified.
27. No hard delete, bulk cleanup, or automatic expiry is authorized by this decision. Records with uncertain classification, unresolved holds, incomplete relationships, or unavailable authority must be preserved and escalated for review.

**Governance, access, and audit**
28. Maintain a versioned retention schedule catalogue with owner, approval authority, effective date, superseded version, applicable record classes, trigger, period, review process, and source requirement. Schedule authorship or administrative access does not itself authorize disposition.
29. Apply server-side authorization to archive, hold, release, review, export, restore, and disposition actions. Restrict legal-hold details and sensitive matter references to authorized users; do not expose them in ordinary search, notifications, or reports.
30. Preserve append-only audit for schedule changes, archive transitions, integrity checks, hold creation/scope changes/release, blocked disposition attempts, disposition approvals, and destruction outcomes. Record actor/process, authority, time, affected record identities, policy version, and result.
31. Search, registers, reports, and Transmittal navigation must respect retention and hold restrictions while preserving authorized historical traceability. Legal hold does not make otherwise confidential content broadly visible.
32. Define privacy/data-minimization and access-review rules for retained personal data, including how to reconcile preservation duties with applicable privacy requirements. Do not infer that retention authorizes unrestricted processing or disclosure.

**Open design details:** record-class taxonomy and schedules; applicable jurisdictions/contracts and authoritative sources; retention triggers and calculation; archive tiers and formats; integrity verification; backup/replica lifecycle; hold authority/scope/review/release workflow; multi-hold handling; disposition approval matrix; deletion behavior across storage/index/cache/backup; retained audit metadata; privacy/data-subject request handling; reporting; and operational monitoring. Resolve with legal, contractual, security, and records-management review before implementation.

**Implementation boundary:** design only. No schema/database/migration/generated types, storage lifecycle or deletion configuration, backup/restore operation, archive service, legal-hold tooling, auth/RLS/grants, API/UI, automated retention jobs, disposition/destruction, tests, merge, or deployment changes are authorized or made by DEC-054.


### 14.31 DEC-055 — Document Audit Trail & Accountability

**Decision status:** owner-approved design direction — 2026-11-11. Requirements/design only.

**Purpose and audit principles**
1. Establish a governed, attributable, append-only audit trail for material actions and security-relevant events affecting documents, revisions, attachments, workflows, reports, Transmittals, acknowledgements, retention, legal holds, archive, and access.
2. The audit trail must answer, to the extent recorded: who or what acted; under which authenticated identity and authority; what action was attempted; which project, record, revision, item, attachment, or recipient was affected; when it occurred; what changed; whether it succeeded, failed, or was denied; and the applicable policy/workflow context.
3. Audit records are evidence of system-recorded events, not automatic proof of a person's intent, comprehension, physical presence, legal consent, or the legal validity of a signature.
4. Preserve attribution to the actual actor. Never rewrite an event to attribute it to another user, substitute a manager's identity, or use a shared account. Delegation or service execution must be explicit, authorized, and separately attributable.
5. Audit events are append-only for application users and ordinary administrators. Corrections are additional linked events with reason and authority; no silent edit, deletion, replacement, or backdating of prior events.

**Event coverage**
6. Capture material lifecycle events, including creation, draft changes where governed, formal submission, revision creation, return, resubmission, review, decision, approval, issue, withdrawal, supersession, closure, and reopening where separately permitted.
7. Capture identity and authorization context for assignment, reassignment, roster membership/status, capability or policy changes, invitation/acceptance, suspension, and termination of project assignment.
8. Capture attachment and scan events: upload attempt/result, quarantine, validation, primary designation/change, withdrawal, download/access where measurable, integrity check, and denied operations.
9. Capture signature-related events separately: signer authentication, explicit approval/sign action, signature application, signature validation, snapshot/hash reference, and failure. Merely opening a document, logging in, uploading an image, or viewing a stored signature is not a signature or approval.
10. Capture report definition/snapshot, review, approval, issue, distribution, Transmittal manifest and recipient outcomes, delivery/access receipts, acknowledgement, and formal response events.
11. Capture search/export/download and access events where required by the approved security/privacy policy, plus authorization denials, suspicious or prohibited attempts, and relevant administrative access. Do not treat every UI interaction as a material business event.
12. Capture retention schedule changes, archive transitions, integrity verification, legal-hold creation/change/release, blocked disposition, disposition approval, and destruction outcome in accordance with DEC-054.
13. Capture notification generation, recipient resolution, delivery attempts/results, read/acknowledgement, and authoritative action resolution without confusing notification state with source workflow state.
14. Event catalogues, mandatory fields, risk tiers, and exact event coverage by module must be defined and versioned before implementation. This decision does not assert that every candidate event is currently captured.

**Required event envelope**
15. Each event should carry a stable unique event ID; event type and schema version; event time in UTC and, where useful, recorded display timezone; server-recorded timestamp; actor identity and actor class (human, service, scheduled process, integration); authenticated session/context reference where appropriate; active project assignment and relevant party/capability/policy version at event time; and correlation/request/causation identifiers where available.
16. Identify the affected project and exact record class/stable record ID, official reference where assigned, revision/version, item/attempt, attachment/file identity, report snapshot, Transmittal/manifest entry, recipient, or other applicable object. Never rely on mutable titles or “latest” aliases as sole identity.
17. Record action, target, outcome (success, failure, denial, partial completion), reason or structured reason code where applicable, and safe error category. For changes, capture a controlled before/after representation or field-level change set sufficient for accountability, subject to data minimization and confidentiality.
18. Record authority context: capability evaluated, policy/rule version, relevant workflow state/step, and authorization decision where material. Do not store credentials, access tokens, passwords, private keys, raw session secrets, or unnecessary sensitive payloads in audit records.
19. Record content integrity references such as exact revision/file hash or immutable snapshot identity where relevant. A hash identifies content for comparison; it does not alone prove who authored, reviewed, or approved it.
20. Distinguish event occurrence time from ingestion/recording time, and preserve original source timestamps for trusted integrations. Clock synchronization, time precision, timezone display, and handling of delayed/offline events require explicit technical design.

**Integrity, sequencing, and failure behavior**
21. Audit storage must resist alteration by ordinary application roles and be protected from unauthorized update/delete. Administrative and infrastructure access to audit stores must itself be controlled and audited.
22. Evaluate tamper-evidence controls such as hash chaining, signed checkpoints, protected append-only storage, independent replication, and periodic verification. No specific cryptographic architecture or claim of absolute immutability is approved by this decision.
23. Preserve event ordering where causal sequence matters using server sequence/correlation/causation metadata; timestamps alone may not establish total ordering across distributed systems.
24. For critical state-changing actions, the business action and its required audit event must be committed consistently. If the system cannot durably record a mandatory event, it must not report the action as successfully completed; exact transactional/outbox architecture and recovery behavior remain open.
25. Failed and denied attempts should be captured where security-relevant without disclosing protected content to the requester. Prevent logging failures from causing silent loss; define bounded durable retry, alerting, reconciliation, and operational monitoring.
26. Never fabricate a successful event to fill a gap. Missing, delayed, duplicated, or corrupted audit records must be identifiable and handled through a separately recorded incident/reconciliation process.

**Review, access, export, and retention**
27. Provide authorized audit review with filters by project, record identity/class, actor, action, outcome, time range, event family, and correlation ID, subject to server-side authorization at query, count, facet, preview, and export stages.
28. Audit access is a separate capability from document access, project membership, or PM supervisory visibility. PM remains read-only and receives no authority to modify records or bypass audit confidentiality.
29. Restrict sensitive audit details (including legal matters, personal data, security denials, and privileged administrative actions) to authorized reviewers. Search snippets, notifications, dashboards, and aggregate counts must not leak protected records or hidden activity.
30. Exported audit evidence must preserve event IDs, ordering/causation metadata, timestamps, filters/scope, schema/policy versions, generation actor/time, and integrity verification information where available. Export access and generation must themselves be audited; protect exports against formula injection and unauthorized redistribution.
31. Apply DEC-054 retention schedules and legal holds to audit records as their own governed record class. Audit evidence must not be deleted merely because the associated document is superseded or withdrawn. Any permitted redaction, minimization, or disposal must be authorized, documented, and preserve the legally required accountability record.
32. Audit review must distinguish recorded facts, system-derived interpretations, and missing/unverified evidence. Do not present a delivery attempt as successful delivery, an open as acknowledgement, an acknowledgement as approval, or an approval as a signature unless the relevant separate event proves it.

**Open design details:** event taxonomy and mandatory coverage; field-level change capture and redaction; actor/session attribution; service and integration identity; timestamp precision/timezone and offline events; correlation and ordering; tamper-evidence architecture and independent verification; transactional audit failure/recovery; security monitoring and alerting; audit access roles; retention schedule and legal hold; export/evidence format; privacy/data minimization; and incident reconciliation. Resolve through separately reviewed security, privacy, legal, architecture, and records-management designs.

**Implementation boundary:** design only. No audit schema/table, trigger, logging pipeline, database/storage change, cryptographic implementation, auth/RLS/grants, API/UI, monitoring integration, data backfill, tests, merge, or deployment changes are authorized or made by DEC-055.


### 14.32 DEC-056 — System Administration, Configuration & Governance Control

**Decision status:** owner-approved design direction — 2026-11-11. Requirements/design only.

**Purpose and governing boundary**
1. Establish controlled administration of system, organization, project, reference-data, workflow, and presentation configuration while preserving the approved governance baseline and separation between operational administration and policy authority.
2. Administrative access is capability-based and deny-by-default under DEC-021. A person does not gain authority to alter workflow rules, approve records, grant themselves privileges, or override a governed decision merely by holding a system/project administrator title.
3. Configuration changes must not silently rewrite, reinterpret, renumber, reassign, approve, or otherwise mutate historical documents, revisions, reports, signatures, Transmittals, acknowledgements, responses, audit events, or retention records.
4. The system must distinguish configuration from governed policy/decision. A configuration interface cannot amend or supersede an approved decision; material policy changes require the applicable decision authority, documented decision, impact assessment, and traceability update before controlled activation.
5. Configuration is effective only within its defined scope and effective period. No retroactive effect on completed or in-flight records unless a separately approved migration/transition plan explicitly defines permitted behavior and preserves the original state.

**Configuration classification and ownership**
6. Maintain a controlled catalogue of configuration items, including at minimum:
   - global/platform settings and security controls;
   - organization/company and project settings;
   - project parties, team roster references, disciplines, and assignment parameters;
   - document types, reference codes, numbering sequences, and controlled vocabularies;
   - workflow definitions, states, transitions, required fields, decision gates, and role/capability mappings;
   - forms, templates, report definitions, and notification event/recipient/priority rules;
   - retention schedules, archive/hold rules, and audit settings;
   - localization, display preferences, and non-authoritative presentation settings.
7. Classify each item by risk and authority: ordinary operational configuration; controlled reference data; security/authorization configuration; workflow or business-rule configuration; and governance/legal/contractual policy. Classification determines required owner, review, approval, testing, activation, and audit.
8. Every item must have a stable key/identity, description, scope (platform/organization/project/module), accountable owner, permitted editors/reviewers/approvers, current version, status, effective-from/to dates where applicable, source/decision reference, and change history.
9. Define authoritative ownership for each configuration family. Avoid competing project-level and global settings with unclear precedence. Where inheritance is permitted, show the inherited source and effective value; local overrides must be explicit, scoped, authorized, and auditable.
10. Reference-data values must have stable identifiers and lifecycle states (e.g. active, deprecated, retired) rather than destructive replacement. Historical records retain the exact value/label or version context used at the time; retired values remain resolvable for history but cannot be selected for new transactions unless explicitly permitted.
11. Do not treat free-text labels, UI visibility, feature flags, or roster membership as authorization. Security policy and server-side capability enforcement remain authoritative.

**Change proposal, review, and approval**
12. Every controlled change begins with a proposal identifying the configuration item, current version, proposed version/value, reason, owner, scope, intended effective date, affected projects/modules/record classes, dependencies, and source authority.
13. Require impact assessment before approval, covering active and draft transactions, in-flight workflows, numbering/revision semantics, permissions and segregation of duties, integrations, notifications, reports/search, historical interpretation, retention/legal holds, data migration needs, and user communication where relevant.
14. Changes to workflow states/transitions, numbering, access control, roles/capabilities, signatures/approvals, record visibility, retention/disposition, legal hold, audit, or contractual/legal rules are high-impact controlled changes. They require review and approval by the separately designated competent authority; an administrator cannot approve their own proposal or bypass separation of duties.
15. Low-risk presentation preferences may follow a simpler approval path only when their classification and boundaries are explicitly approved. A visual/display setting must never alter access, workflow outcome, record meaning, or audit evidence.
16. Approval must bind to the exact proposed configuration version and impact assessment. Any material amendment after approval requires a new review/approval; approval cannot be carried over to changed content.
17. Record proposal, review comments, approval/rejection/return, approver identity and authority, timestamps, exact version/hash, scope, effective date, and decision references as append-only audit events under DEC-055.
18. No configuration change becomes active merely because it was saved, drafted, imported, or approved in principle. Activation is a separate controlled event after required validation and release gates.

**Validation, activation, and rollback**
19. Validate configuration against schema, allowed values, dependencies, cross-field constraints, authority rules, and compatibility with the approved governance baseline before activation.
20. For high-impact changes, require documented test scenarios and expected outcomes, including negative authorization tests, representative in-flight/historical records, boundary conditions, and failure/recovery behavior. Test evidence must identify the exact candidate version.
21. Support draft, under review, approved, scheduled, active, superseded, rejected, and withdrawn lifecycle states as applicable. The precise state model and gates by configuration class remain open.
22. Activation must be explicit, scoped, timestamped, attributable, and auditable. Show administrators the exact version and scope being activated and any known impact. Where safe and supported, stage changes by project/module rather than global activation.
23. Preserve the previously active version and its effective interval. Rollback is not silent deletion or rewriting: it is a new controlled activation of a known-good prior configuration as a new version/event, with reason, authority, scope, and impact review.
24. Emergency changes require a separately approved break-glass procedure, limited scope and duration, immediate audit, prompt independent review, and documented expiry/normalization. Emergency access must not permit self-approval, concealment, or retroactive alteration of history. No specific emergency roles or time limits are established here.
25. Failed, partial, or interrupted activation must be visible and reconciled. Do not report a configuration release as successful until the authoritative active version and its scope are verified.

**Versioning, effective context, and historical integrity**
26. Configuration versions are immutable once approved/activated. Changes create new versions; no overwrite of a version used by a record or transaction.
27. For each governed transaction, preserve the relevant configuration/policy version context used at initiation and at each material decision or transition, including applicable workflow, numbering, template, role/capability policy, reference data, and report definition as relevant.
28. A later configuration change applies prospectively from its approved effective point. It must not silently change the interpretation of completed approvals, prior audit events, issued reports, Transmittal manifests, signatures, or historical reports.
29. For in-flight transactions, define explicit transition rules: continue under the original version, migrate under an approved transition plan, or pause for authorized review. No automatic migration or mixed-version behavior is assumed.
30. Numbering and identifiers already issued remain unchanged. Configuration changes to prefixes, sequences, or document-type mappings must preserve uniqueness and historical resolution; no reset or reuse of issued numbers.
31. Configuration import/export and replication between environments must preserve version identity, provenance, scope, dependencies, approval status, and secret references without copying live credentials or environment-specific secrets.

**Administration, security, and oversight**
32. Separate capabilities for viewing configuration, proposing changes, editing drafts, reviewing, approving, activating, emergency administration, and auditing. Grant only the minimum scope required; project administrators cannot modify platform-wide controls unless separately authorized.
33. Enforce authorization server-side at read, write, review, approval, activation, import/export, and rollback. Recheck active assignment, scope, capability, and segregation-of-duties constraints at the moment of action.
34. No self-grant, privilege escalation, self-approval, impersonation, shared administrator account, or hidden bypass. Changes to users, roles, roster, and capability mappings must be independently authorized and fully audited.
35. Protect secrets, credentials, keys, integration tokens, and sensitive security settings through a separately governed secret-management design. Do not expose secret values in configuration screens, logs, exports, or audit payloads.
36. Provide a read-only configuration register showing current and scheduled versions, scope, owner, approval status, effective dates, dependencies, and history to authorized reviewers. Display inherited values and overrides clearly.
37. Configuration health checks should detect missing owners, expired/scheduled conflicts, duplicate identifiers, invalid references, unapproved active versions, dependency mismatch, and drift from the approved baseline. Alerts must not expose restricted configuration or secrets.
38. Administrative reporting and exports are read-only evidence; they do not change configuration or grant authority. PM remains supervisory/read-only under DEC-021 unless a distinct capability is separately approved.

**Open design details:** detailed configuration taxonomy and risk tiers; authority/owner matrix; inheritance and precedence; exact lifecycle states and approval gates; version/hash format; effective-date and timezone rules; in-flight transition policy; validation/test catalogue; staged activation and recovery; emergency access procedure; environment promotion/import/export; secret management; drift detection; admin register/report design; and notification/communication rules. Resolve through separately reviewed security, architecture, operational, and governance designs.

**Implementation boundary:** design only. No configuration tables/schema, migrations/generated types, settings/UI, authorization/RLS/grants, workflow or numbering logic, feature flags, secret management, environment promotion, data migration, tests, merge, or deployment changes are authorized or made by DEC-056.


### 14.33 DEC-057 — Integration, API & External System Governance

**Decision status:** owner-approved design direction — 2026-11-11. Requirements/design only.

**Purpose and authority boundary**
1. Establish governed, secure, traceable exchange of data and documents between SiteDocs and external systems, services, applications, contractors, consultants, owners, and approved integration partners.
2. SiteDocs remains authoritative for its governed document identities, revisions, workflow states, review/approval decisions, signatures, Transmittals, acknowledgements, audit evidence, and retention records unless a separately approved data-ownership agreement explicitly defines another source of authority for a specific data domain.
3. External connectivity, API credentials, integration registration, or successful data exchange does not grant a partner user or system authority to create approvals, issue documents, change workflow states, sign, assign responsibility, bypass validation, or access records beyond explicitly authorized capabilities.
4. An integration may perform only its approved, scoped operations on explicitly defined data objects and projects. Human decisions and signatures remain attributable to authenticated authorized individuals under the relevant module workflow; service identities cannot impersonate a person or provide a human approval.
5. Integration failure, outage, delay, or conflicting external data must not silently change a governed SiteDocs record or imply acceptance, approval, delivery, receipt, or contractual effect.

**Integration inventory and ownership**
6. Maintain a controlled integration register. Each integration entry must identify stable integration ID, name/purpose, business owner, technical owner, provider/system, environment, data domains, projects/parties in scope, direction (inbound/outbound/bidirectional), approved interfaces, permitted operations, data classification, authentication method, credential owner, lifecycle status, support/escalation contacts, and approval/source reference.
7. Classify integrations by risk and impact: read-only retrieval, controlled data import, document/file exchange, event/webhook delivery, and privileged workflow-adjacent operations. Higher-risk classes require stronger review, testing, monitoring, and approval.
8. Register all machine identities, service accounts, API clients, webhook endpoints, certificates, secrets, and external destinations. No undocumented integration or unmanaged credential may be used for production data.
9. Assign a named accountable owner for data mapping, access scope, operational support, incident response, credential rotation, and end-of-life decommissioning. Ownership does not itself grant operational permissions.
10. Define data ownership and field-level source-of-truth rules for each exchanged domain. Resolve conflicts explicitly; do not assume last-write-wins or allow an external update to overwrite SiteDocs-controlled fields.

**API and access governance**
11. All API access must be authenticated, authorized server-side, scoped to the approved integration identity, project, data domain, operation, and record visibility. Apply deny-by-default and least privilege.
12. Separate API capabilities for read, search, create draft, upload attachment, submit, update permitted metadata, receive event, acknowledge delivery, and any other approved action. Do not expose a generic unrestricted CRUD or administrator endpoint to integrations.
13. APIs must enforce the same business rules, workflow gates, revision rules, attachment validation, record visibility, and separation of duties as the user interface. UI hiding is not an authorization control.
14. No API operation may create a human approval/signature, impersonate a named user, bypass self-approval restrictions, or use a service identity as a substitute for an authorized reviewer/approver/signer.
15. Scope access to exact projects, parties, record classes, and operations. Recheck current access and integration status on every request; credential possession alone is insufficient.
16. Define versioned API contracts with stable resource identities, schemas, validation rules, error models, pagination, filtering, sorting, rate limits, compatibility policy, and deprecation lifecycle. Never rely on mutable display labels or implicit “latest” records as sole identifiers.
17. API responses, error messages, counts, filters, and metadata must not disclose unauthorized record existence, draft presence, other-party content, or sensitive workflow state.
18. Protect transport and credentials using approved security controls. Secrets must be stored and rotated through governed secret management, never embedded in source code, client-side applications, logs, URLs, or exported configuration. Exact protocols and cryptographic profiles remain subject to security architecture review.

**Data exchange and document/file handling**
19. Define each data exchange contract with purpose, owner, source/target authority, field mapping, required/optional fields, allowed transformations, validation, classification, retention, error handling, and reconciliation owner.
20. Preserve source provenance: external system ID, external record/version, source timestamp, receiving integration ID, correlation ID, import time, transformation/mapping version, validation outcome, and exact linked SiteDocs identity.
21. Imported records or files must enter the appropriate controlled intake/validation path. Import does not automatically make a document official, create an approval, satisfy a signature, issue a Transmittal, or bypass draft/formal submission rules.
22. File exchange must enforce the applicable attachment and scan controls, including file type/size validation, malware/quarantine handling where approved, opaque storage identities, content integrity checks, project/document/revision binding, and authorized download. No public or permanently accessible storage link is implied.
23. Export only explicitly authorized data and exact record/revision/report snapshot versions. Recheck authorization at generation and delivery; preserve manifest, recipient/destination, file identity/hash, export time, actor/integration, and outcome.
24. External transformations, conversions, OCR, or metadata enrichment must be identified and versioned. Preserve the original received/sent content and record transformation provenance; derived content is not silently substituted for the authoritative source.
25. Bidirectional synchronization requires field-level ownership, conflict rules, version/concurrency checks, and an auditable resolution path. Do not use silent last-write-wins for governed fields, approvals, signatures, revisions, or workflow state.

**Reliability, idempotency, and event delivery**
26. Every state-changing integration request must use a stable idempotency key or equivalent deduplication identity and record request/correlation IDs. Repeated delivery must not create duplicate documents, attachments, submissions, approvals, Transmittals, or responses.
27. Use explicit processing outcomes such as accepted, rejected, pending, completed, partially completed, and failed where appropriate. An HTTP/API acknowledgement must not be represented as successful business completion unless the authoritative transaction has completed.
28. Define retry policies with bounded attempts, backoff, dead-letter/quarantine handling, alerting, and operator reconciliation. Retries must not bypass validation or duplicate business effects.
29. Webhooks/events must be authenticated, scoped, versioned, replay-resistant where applicable, and delivered with event identity, timestamp, schema version, and correlation context. Consumers must tolerate duplicate and out-of-order delivery without corrupting state.
30. Distinguish event creation, dispatch attempt, transport delivery, consumer receipt, processing success, and business acknowledgement. These are separate facts; none implies another.
31. Record partial failures and per-object/per-recipient outcomes. Do not report a batch as wholly successful if only some items completed.
32. Monitor availability, latency, failure rates, queue depth, retry exhaustion, schema drift, credential expiry, suspicious activity, and reconciliation gaps without exposing sensitive data. Define service objectives separately; none is set by this decision.

**Audit, privacy, retention, and incident control**
33. Record integration registration/approval, credential lifecycle, authentication outcomes, authorization decisions, request metadata, exact object references, validation, changes, exports, webhook delivery, retries, failures, and administrative operations under DEC-055.
34. Audit payloads must exclude passwords, tokens, private keys, full secrets, and unnecessary personal or confidential content. Use safe identifiers and redaction.
35. Apply DEC-054 retention, archive, and legal-hold rules to integration logs, exchanged files, manifests, acknowledgements, and reconciliation evidence. External copies are not automatically recalled by SiteDocs withdrawal or access revocation.
36. Define data minimization, purpose limitation, residency/transfer restrictions, privacy notices/agreements, and deletion responsibilities for each integration and jurisdiction. No cross-border transfer or external processing permission is implied.
37. Maintain incident procedures for compromised credentials, unauthorized access, data leakage, corruption, duplicate processing, provider outage, schema drift, and disputed exchanges. Include disable/revoke controls, containment, evidence preservation, notification authority, reconciliation, and recovery.
38. Decommissioning must revoke credentials, disable endpoints/webhooks, stop scheduled transfers, reconcile in-flight messages, preserve required audit/retention records, and document external data disposition responsibilities. Decommissioning must not erase SiteDocs history.

**Governance lifecycle**
39. New integrations and material scope changes require documented business need, data-flow diagram, risk/security/privacy assessment, data ownership and mapping, authorization matrix, test evidence, operational owner, support/incident plan, retention treatment, and approval by competent authorities before production activation.
40. Changes to API contract, scopes, destination, data domains, authentication, field mappings, webhook events, or privileged operations are versioned and reviewed. Material changes require renewed approval and compatibility assessment.
41. Separate capabilities for register/view, propose, configure, approve, activate, rotate/revoke credentials, inspect logs, export, and decommission. No self-approval or self-grant; all administrative actions are audited.
42. Provide an integration register with current version, environment, owner, status, scopes, last successful exchange, recent errors, credential expiry/rotation status, and deprecation/decommission notices, subject to least-privilege visibility.
43. No production integration is authorized solely by this design decision. Each connector, API consumer, provider, data domain, and destination requires its own approval and technical security review.

**Open design details:** integration catalogue and risk tiers; API resource/contract inventory; authentication and authorization profiles; service identity lifecycle; rate limits and quotas; idempotency and concurrency model; webhook signing/replay controls; file exchange patterns; data mapping/ownership/conflict rules; event ordering; retry/dead-letter/reconciliation; monitoring and service objectives; data residency/privacy agreements; retention and external-copy obligations; incident response; decommissioning; and per-integration approvals. Resolve through separately reviewed architecture, security, privacy, legal, and operational designs.

**Implementation boundary:** design only. No API endpoints, integration credentials, service accounts, webhooks, external connections, data imports/exports, synchronization jobs, schema/database/storage/auth/RLS/grants, UI, tests, merge, or deployment changes are authorized or made by DEC-057.


## 14.34 DEC-058 — Data Import, Export & Migration Governance

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

**Purpose and governing principles**

1. Govern controlled data import, export, bulk exchange, and migration into or out of SiteDocs, including initial project onboarding, legacy-system migration, recurring imports, user-initiated exports, administrative extracts, and archive transfers.
2. Distinguish import, migration, synchronization, export, backup, restore, and archival transfer. They have different purposes, authority, risk, validation, and evidence requirements; none is a substitute for another.
3. Preserve SiteDocs' authoritative record identity, revision, workflow, approval, signature, Transmittal, acknowledgement, response, audit, and retention rules. A successful file transfer or row insertion does not make imported content an official or approved record.
4. No bulk operation may bypass DEC-021 authorization, DEC-022 numbering/revision controls, family-specific workflows, attachment security, confidentiality, or separation of duties.
5. No destructive overwrite, silent merge, historical renumbering, or deletion of existing records is authorized by this decision.

**Import and migration intake**

6. Every import/migration requires a documented purpose, accountable business/data owner, source system and authority, target project and record classes, approved scope, source snapshot/cut-off, mapping specification/version, responsible operator, and competent approval before execution.
7. Maintain a controlled import manifest identifying source files/objects/records, stable source identifiers, source versions/timestamps where available, target mapping, expected counts, file sizes, hashes, and batch/correlation identity.
8. Preserve source provenance: source system, source record ID, source revision/version, originator where lawfully available, source timestamps/timezone and their meaning, extraction time, import time, operator/integration identity, transformation/mapping version, validation results, and target identity.
9. Classify each item before processing: new candidate, exact duplicate, possible duplicate, update candidate, conflicting record, invalid/incomplete, unsupported, quarantined, or explicitly excluded. Ambiguous matches require controlled human reconciliation; never guess identity from title similarity alone.
10. Validate schema, required fields, data types, controlled vocabularies, project/party/discipline references, numbering collisions, revision relationships, parent/child links, attachment bindings, timestamps, and referential integrity before commit.
11. Imported legacy statuses, approvals, signatures, and workflow events must retain their source meaning and provenance. Do not translate an ambiguous legacy state into a current SiteDocs approval or decision. Record unmapped/uncertain states for review.
12. Legacy document numbers and historical identifiers must be preserved as source identifiers. Any SiteDocs official identity or number must follow the applicable governed allocation rule; migration must not fabricate historical SiteDocs issuance.
13. Import does not automatically create a current assignment, grant access, notify unauthorized parties, activate a workflow, satisfy a review, or imply acceptance. Any required post-import workflow must be separately authorized and initiated through the normal controlled process.
14. Files and attachments must pass the applicable quarantine, malware, type/size, integrity, opaque-key, private-storage, and document/project/company/revision binding controls. A metadata row without verified bytes, or bytes without a verified record binding, is an incomplete import.
15. Stage large or high-risk imports in an isolated/quarantined intake area. Keep staged data non-authoritative and invisible to ordinary business workflows until validation and approval gates pass.
16. Define batch atomicity explicitly: all-or-nothing where feasible, or item-level partial processing with clear per-item outcomes. Never report a partially successful batch as wholly successful.
17. Reconcile source and target counts, identities, relationships, file counts/bytes, hashes, rejected/quarantined items, and exceptions. Differences must be explained and approved before the batch is declared complete.
18. Failed or interrupted batches must be safely resumable using stable batch/item identities and idempotency controls. Reprocessing must not create duplicate records, attachments, revisions, events, notifications, or workflow actions.

**Export and disclosure control**

19. Every export requires a defined purpose, authorized requester/operator, approved scope, record classes/projects/parties, exact selection criteria, destination/recipient, format, and handling classification.
20. Recheck server-side authorization for every included record and exact revision/report snapshot at selection, generation, and delivery. Counts, filters, previews, manifests, and error details must not disclose unauthorized record existence or content.
21. Export only the exact authorized version requested; never silently substitute the latest-created or latest-effective revision. Preserve relationships and distinguish source records from derived reports or transformed files.
22. Generate an export manifest with scope/filters, timezone and date basis, generation time, actor/integration, recipient/destination, record identities and versions, file identities and hashes, transformation/export-tool version, outcome, and any exclusions or partial failures.
23. Protect exported data in transit and at rest according to its classification. No public link, unrestricted bulk endpoint, uncontrolled email attachment, or third-party destination is approved by default.
24. Spreadsheet exports must defend against formula injection and unsafe external content. Structured exports must define encoding, schema/version, null handling, timezone, locale, and stable identifiers. PDF or image exports must not be treated as editable source records.
25. Exported copies are outside SiteDocs' direct control once delivered. Define recipient obligations, access expiry/revocation where supported, onward-sharing restrictions, retention/deletion responsibility, and incident notification. SiteDocs must not claim it can recall copies already downloaded or replicated.

**Migration cutover, rollback, and reconciliation**

26. Each migration requires a separately approved runbook covering source freeze/cut-off or change capture, backup/export of source evidence, staging, mapping/version lock, dry run, validation, authorization, execution window, reconciliation, exception handling, acceptance, and operational handover.
27. Define whether the migration is one-time, phased, incremental, or delta-based. For incremental migration, define change-watermark semantics, conflict ownership, ordering, and a final reconciliation gate.
28. Before production migration, require a representative isolated rehearsal and verified recovery path. Where a live-system backup/restore is relevant, follow the approved backup and isolated-restore safeguards; this decision does not itself authorize database or storage mutation.
29. Rollback must be planned before execution and must identify the exact batch, affected records/files, dependencies, recovery point, authority, and reconciliation steps. Do not use broad destructive rollback that erases valid post-migration activity.
30. If a clean rollback is no longer safe because new authoritative activity has occurred, stop and use a separately approved forward-reconciliation/correction plan that preserves history.
31. Migration completion requires signed-off reconciliation evidence, unresolved exception inventory and owner, source-to-target traceability, access/security verification, file/hash verification, and explicit acceptance by the accountable data owner.

**Security, audit, retention, and governance**

32. Separate capabilities for propose, map, validate, approve, execute, pause/resume, reconcile, accept, export, and inspect evidence. No self-approval or self-grant; high-risk operations require separation of duties.
33. Enforce least privilege, project/party/record-class scope, secure operator identity, environment separation, secrets protection, rate/volume limits, and additional approval for privileged or sensitive exports.
34. Record immutable audit evidence under DEC-055 for request, approval, manifest, mapping version, dry run, validation, every batch/item outcome, retries, operator actions, exceptions, reconciliation, export delivery, rollback/correction, and final acceptance.
35. Apply DEC-054 retention, archive, and legal-hold rules to source snapshots, manifests, mapping specifications, staged files, exported packages where retained, reconciliation evidence, exception records, and audit trails.
36. Minimize data copied into logs and error reports; redact credentials and unnecessary personal/confidential content. Failed imports must not leak source payloads to unauthorized users.
37. Define retention and secure disposition for temporary staging data and generated export packages. Do not delete staged/source evidence while a legal hold, investigation, reconciliation, or approved retention obligation remains active.
38. Monitor batch progress, validation failures, duplicate/conflict rates, rejected/quarantined items, hash mismatches, retries, partial completion, export volume, and reconciliation gaps. Monitoring does not itself authorize data access.
39. A data-import/export register must expose only authorized operational metadata: batch/export identity, owner, source/destination class, scope, mapping version, status, counts, exceptions, approvals, timestamps, and evidence references.
40. No import, export, migration, or cutover is authorized solely by DEC-058. Each operation and its scope must receive specific approval and a reviewed technical runbook.

**Open design details:** canonical data dictionary and record-class mappings; supported import/export formats; duplicate-resolution policy; legacy approval/status mapping; source-of-truth ownership; staging/quarantine architecture; batch transaction and idempotency model; volume/rate limits; encryption and destination controls; migration cutover and change capture; rollback/reconciliation acceptance; export package expiry; temporary-data disposal; and per-operation approval matrix. Resolve through separately reviewed data, security, privacy, legal, architecture, and operational designs.

**Implementation boundary:** design documentation only. No import/export job, migration, database/storage mutation, backup/restore, schema/mapping code, API, UI, authorization/RLS/grant, file transfer, production data processing, tests, merge, or deployment change is authorized or made by DEC-058.


## 14.35 DEC-059 — System Backup, Disaster Recovery & Business Continuity

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

**Purpose and scope**

1. Establish governed protection and recovery for SiteDocs service components and business records, including database contents, private object-storage bytes, file metadata and bindings, configuration, integration state, audit evidence, report snapshots, and operational dependencies.
2. Distinguish backup, replication, archive, restore, disaster recovery (DR), high availability, and business continuity (BC). They provide different protections; replication is not an independent backup, archive is not a recovery plan, and a successful backup is not proof of recoverability.
3. Maintain a component inventory and dependency map covering database, object storage, identity/authentication, application/runtime, secrets/configuration, integrations, DNS/network, monitoring, and external providers. Record ownership, recovery dependencies, criticality, and evidence source.
4. Define recovery objectives per service and record class only through separately approved business-impact analysis. No RPO, RTO, retention period, availability target, or contractual service level is set by DEC-059.

**Backup policy and integrity**

5. Define backup scope, method, frequency, consistency model, retention, encryption, key custody, location/residency, immutability/tamper resistance, access control, monitoring, and deletion lifecycle for each component.
6. Database backups and object-storage file bytes must be protected independently and coordinated through a recoverable consistency point. A database export alone does not back up stored files; object metadata alone does not preserve file content.
7. Preserve relationships among documents, revisions, attachment metadata, storage object identities, file bytes, hashes, signatures, report snapshots, Transmittals, audit events, and access/response evidence.
8. Backup capture must identify its timestamp/cut-off, source environment, component versions, schema/configuration references, included/excluded scope, job identity, outcome, and integrity evidence.
9. Protect backups from the same failure domain as production where feasible, including compromised credentials, destructive administration, ransomware, provider outage, and accidental deletion. Consider isolated/offline or immutable copies subject to security and cost review.
10. Encrypt backups in transit and at rest; separate key administration from backup operation; control key rotation, recovery, expiry, and loss scenarios. Never place credentials or keys in backup manifests or ordinary logs.
11. Apply least-privilege access, dual control for destructive or sensitive operations, isolated backup administration, and immutable audit of backup creation, access, copy, restore, deletion, and policy changes.
12. Verify backup completion and integrity through automated checks and periodic restore sampling. A job marked successful without verified content, dependencies, and readable restore evidence is not sufficient.
13. Detect missing, stale, partial, corrupted, unexpectedly small, or inaccessible backup sets and escalate according to an approved operational policy. Failed backup runs remain visible and cannot silently replace the last known-good recovery point.
14. Define backup retention and disposal under DEC-054, including legal holds, regulatory/contractual obligations, secure deletion, provider-managed replicas, and evidence of disposition.

**Restore and recovery validation**

15. Restore into an isolated, access-restricted environment first unless an explicitly approved emergency procedure requires otherwise. Never experiment on production data.
16. A restore plan must specify the selected recovery point, required database and object-storage sets, configuration/schema compatibility, encryption keys, identity dependencies, application version, integration state, and recovery order.
17. Validate restored schema and policies, record counts, referential integrity, document/revision links, attachment bytes and hashes, signatures, report snapshots, audit-chain continuity, permissions, and representative user workflows before any recovered environment is declared usable.
18. Reconcile database rows and storage objects as separate but linked inventories. Identify missing/orphaned metadata, missing bytes, unexpected objects, hash mismatches, and records outside the recovery point; preserve evidence and resolve through an approved plan.
19. A restore must not silently roll back legitimate records created after the selected recovery point. Define recovery-point gaps, business reconciliation, replay/catch-up sources, and conflict resolution before reopening writes.
20. Preserve audit history of restore operator, approver, source backup IDs, timestamps, environment, selected recovery point, validation evidence, exceptions, and go/no-go decision. A restored environment must not masquerade as production without authorized cutover.
21. Any recovery that could overwrite or alter production data requires a separately approved change plan, verified pre-change backup, isolated rehearsal, rollback strategy, and explicit authorization. DEC-059 itself grants no such permission.

**Disaster recovery and continuity**

22. Maintain a documented business-impact analysis identifying critical business processes, dependencies, impact over time, maximum tolerable disruption, data-loss tolerance, and recovery priorities. Owners must approve the resulting RPO/RTO targets; do not infer them from technical capability.
23. Create scenario-specific recovery playbooks for database loss/corruption, storage loss, regional/provider outage, credential compromise, ransomware, accidental deletion, application release failure, integration outage, network/DNS failure, and loss of key personnel.
24. Define activation authority, incident command, technical recovery roles, business decision owners, communications authority, escalation, evidence preservation, status reporting, and criteria for invoking/deactivating DR.
25. Continuity procedures must identify safe manual or alternate processes during outage, including controlled temporary records, unique references, restricted access, reconciliation into SiteDocs after recovery, and safeguards against duplicate or conflicting official actions.
26. Temporary/manual records must be clearly marked, access-controlled, attributable, time-stamped, and reconciled through an approved process. They do not become official SiteDocs records or approvals merely because they were used during an outage.
27. Define recovery dependencies and sequencing for identity/authentication, secrets/keys, database, object storage, application services, integrations, notifications, DNS/network, and monitoring. Do not restore external integrations or resume outbound actions until their credentials, queues, scopes, and in-flight operations are reconciled.
28. Define controlled failover/failback and split-brain prevention where applicable. A secondary environment must not independently issue conflicting official numbers, revisions, approvals, signatures, or notifications.
29. Communications must distinguish confirmed facts, estimated recovery, affected scope, known data gaps, and pending validation. Do not claim full recovery until business and technical acceptance gates pass.

**Testing, governance, and continuous improvement**

30. Conduct periodic backup restore tests, component recovery tests, and end-to-end DR/BC exercises under approved scope. Include realistic database-plus-storage recovery, access-control checks, attachment integrity, audit continuity, and business workflow validation.
31. Test failure modes including corrupted/incomplete backup, unavailable encryption key, missing storage objects, stale configuration, revoked credentials, provider outage, and interrupted recovery. Record actual results and gaps.
32. Exercises must use isolated or approved test environments and synthetic/de-identified data where possible. No destructive test on production without a separately authorized plan.
33. Maintain a controlled register of backup sets, component coverage, last successful verification, restore-test evidence, recovery playbook versions, owners, exceptions, and remediation status.
34. Review the plan after material architecture/provider changes, security incidents, data-class changes, migrations, failed tests, or changes to business criticality.
35. Apply DEC-021 least privilege and separation of duties, DEC-054 retention/legal hold, DEC-055 audit accountability, DEC-056 configuration control, and DEC-057 integration/decommissioning controls throughout backup and recovery operations.
36. No administrator, developer, provider, or project manager may use backup/restore access to bypass document authorization, conceal activity, erase audit evidence, or rewrite historical business decisions. PM remains supervisory/read-only for business records absent separately approved capability.
37. Recovery success requires both technical verification and accountable business-owner acceptance. Record residual data loss, unresolved exceptions, recovered scope, service limitations, and formal authorization to resume operations.

**Open design details:** business-impact analysis and criticality tiers; component inventory and architecture; backup technology/provider; frequency and retention; RPO/RTO targets; geographic/residency requirements; immutability and key custody; database/object-storage consistency; restore order; reconciliation and replay; failover/failback architecture; manual continuity procedures; activation authority; test cadence and evidence; recovery acceptance; and operational ownership/cost. Resolve through separately reviewed architecture, security, legal, privacy, provider, and business-continuity designs.

**Implementation boundary:** design documentation only. No backup job, provider configuration, database export/restore, storage copy/replication, encryption key operation, failover, production recovery, infrastructure change, schema/database/storage/auth/RLS/API/UI modification, test execution, merge, or deployment change is authorized or made by DEC-059.

## 14.36 DEC-060 — System Monitoring, Logging, Alerting & Operational Observability

**Decision status:** Approved design direction for governance documentation only. This decision establishes the observability control framework; it does not approve a particular monitoring product, provider, deployment, service-level target, alert threshold, retention period, or automated remediation.

### Purpose and scope
Establish governed monitoring and operational observability across the SiteDocs application, APIs, database, private object storage, authentication and authorization services, background jobs and queues, notifications, integrations, reporting and export services, backup/restore and disaster-recovery processes, and supporting infrastructure/provider dependencies. The objective is to detect service degradation, failed or delayed processing, security-relevant anomalies, integrity risks, and recovery-readiness exceptions early enough for accountable personnel to investigate and respond.

### Distinct evidence and telemetry classes
The design shall distinguish:
1. **Operational logs:** structured records of component activity, errors, denials, retries, and processing outcomes.
2. **Metrics:** time-series measurements of availability, latency, throughput, saturation, queue state, error rates, and other defined indicators.
3. **Distributed traces:** correlated timing and dependency paths across services and asynchronous processing.
4. **Security events:** authentication, authorization, suspicious activity, policy violations, and security-control outcomes.
5. **Business/workflow events:** authoritative domain events emitted by governed workflows.
6. **Audit trail:** the accountable, append-only record governed by DEC-055.
7. **Alerts and dashboards:** derived operational views and notifications, not authoritative source records.

Operational logs, metrics, traces, dashboards, and alerts do not replace or weaken DEC-055 audit requirements. A dashboard or alert acknowledgement does not constitute a business action, approval, or workflow completion.

### Structured telemetry and data protection
Telemetry should use consistent, machine-readable event structures and, where appropriate, include synchronized event time, service/component, environment, software/configuration version, request/trace/correlation identifiers, safe actor or service identifiers, operation category, outcome, error classification, duration, and references to affected records only where access and data-minimization rules permit.

All components should use a consistent time basis (UTC for stored event timestamps) while retaining relevant timezone context for user-facing presentation and business dates. Clock synchronization and detection of material clock drift are operational controls; timestamps must not be silently rewritten to conceal discrepancies.

Telemetry must not contain passwords, access tokens, session secrets, private keys, signing secrets, or unnecessary document contents, personal data, attachment bytes, or sensitive request payloads. Apply data classification, minimization, masking/redaction, controlled field allowlists, and review of exception/debug output. Correlation identifiers must not become credentials or grant access. Telemetry search, export, and drill-down are themselves access-controlled and audited where appropriate.

### Monitoring indicators
The observability catalogue should consider, as relevant to each component:
- service availability, health/readiness, response latency distributions, throughput, error rates, and resource saturation;
- API failures, rate-limit events, authorization denials, unusual access patterns, and elevated authentication failures;
- database availability, connection/resource pressure, query failures, and replication/consistency warnings where applicable;
- object-storage availability, upload/download failures, quarantine processing, missing-object or integrity exceptions;
- background-job and queue depth, oldest-item age, processing latency, retries, dead-letter items, and stalled workers;
- notification generation and delivery outcomes, delayed or failed delivery, and unresolved processing backlogs;
- integration authentication, webhook verification/replay rejection, API errors, rate limiting, reconciliation exceptions, and dead-letter processing;
- report generation/export failures, long-running jobs, and snapshot-integrity exceptions;
- backup coverage/freshness, backup-job failures, restore-verification results, and database/object-storage reconciliation exceptions under DEC-059;
- security signals such as repeated denied access, suspicious credential use, unusual bulk retrieval/export, privilege/configuration changes, and suspected data exfiltration.

Each indicator must have a documented definition, source, owner, scope, freshness expectation, and known limitations. Metrics and derived indicators must not imply facts that their source data cannot support.

### Alert governance and operational severity
Operational alert severity is a separate classification from the user-notification priorities in DEC-039. The design shall define operational severity levels, criteria, response expectations, ownership, and any mapping to incident-management processes in a separately reviewed catalogue. No fixed severity thresholds, response times, SLA, SLO, or contractual commitment is approved by DEC-060.

Alert rules should define the triggering condition, evaluation window, threshold or anomaly logic, affected service/scope, owner, deduplication and grouping behavior, suppression conditions, escalation path, and recovery/closure criteria. Avoid alert fatigue and duplicate storms, but do not silently suppress a critical unresolved condition. Suppression, maintenance windows, and routing changes must be authorized, time-bounded where appropriate, visible, and auditable. Monitoring-system failure or loss of telemetry must itself be detectable through independent checks where feasible.

Alerts should route to designated, currently authorized operational owners or responders according to service ownership and approved on-call arrangements. Alert content and previews must reveal only the minimum operational context needed by the recipient; document contents, draft existence, project data, and customer information must not leak through alert subjects, payloads, or dashboards. Specific channels, paging arrangements, escalation schedules, and contact methods require separate approval; DEC-060 does not approve SMS, telephone, or any particular external channel.

### Health checks, dashboards, and tracing
Health checks should distinguish process liveness from readiness to serve traffic and from dependency health. Publicly exposed health/status responses must not disclose secrets, internal topology, exploitable configuration, or sensitive customer/project information.

Dashboards should be role-based, show data freshness and known gaps, and separate service-level operational views from business workflow reporting. Access to detailed telemetry, security dashboards, and exports requires least privilege. Project Manager access remains supervisory/read-only under DEC-021 and does not grant operational administration or workflow authority.

Distributed tracing should propagate correlation context across synchronous and asynchronous boundaries where supported. Sampling may be used for performance and cost management only where it does not compromise mandatory audit, security-event, or required diagnostic evidence. Traces are diagnostic aids, not the sole evidence of a security event or business action.

### Security monitoring and incident evidence
Security monitoring should identify patterns requiring investigation, including anomalous authentication, repeated authorization failures, unexpected privilege/configuration changes, unusual document or attachment access, bulk export behavior, suspicious integration activity, and attempts to bypass workflow controls. Detection is not proof of malicious intent; preserve relevant evidence and require authorized investigation before consequential action.

Potential incidents should follow an approved incident-response process with accountable incident ownership, evidence preservation, containment authority, communications, recovery, and post-incident review. Monitoring tools must not autonomously approve documents, sign records, alter permissions, change numbering, delete evidence, withdraw records, or change business workflow state. Any narrowly scoped automated remediation requires a separate risk assessment and explicit approval, with safeguards, rollback, and auditability.

### Reliability of the observability pipeline
The design should address telemetry buffering, delivery failure, backpressure, storage exhaustion, loss detection, and recovery of the monitoring pipeline. Failure of non-authoritative diagnostic telemetry should not unexpectedly corrupt or block ordinary business processing; however, mandatory audit events and controls under DEC-055 must remain reliable and must not be downgraded to best-effort diagnostic logging. The system must expose material telemetry gaps rather than presenting incomplete monitoring as healthy.

Synthetic checks and canary transactions may be used to validate critical paths, monitoring freshness, and alert behavior, provided they use clearly identifiable non-production or controlled test identities/data and cannot create misleading official records. Alert tests and operational exercises must be distinguishable from real incidents and audited as appropriate.

### Governance, retention, and dependencies
Maintain an observability register covering monitored components, event/metric definitions, data classification, owners, access roles, alert rules, dependencies, retention basis, known blind spots, and review history. Apply DEC-054 retention, archive, and legal-hold requirements to telemetry and incident evidence. Apply DEC-055 audit integrity and accountability. Configuration and alert-rule changes follow DEC-056. Integration telemetry follows DEC-057. Backup and recovery observability follows DEC-059.

Review monitoring coverage after material architecture, provider, security, integration, workflow, or data-flow changes and after significant incidents. Operational telemetry access and configuration changes should be attributable and auditable.

### Open design details
The following require separate design and approval: component inventory and ownership; monitoring architecture/provider/tooling; event taxonomy and severity definitions; indicator catalogue and formulas; thresholds and evaluation windows; SLI/SLO/SLA decisions; alert routing and on-call roles; escalation and maintenance-window policy; channels and contact integrations; sampling and trace propagation; telemetry storage/residency/encryption; retention periods; dashboard layouts; security detection rules; incident-response runbooks; synthetic test design; monitoring-pipeline resilience; cost and operational ownership.

**Implementation boundary:** design documentation only. DEC-060 does not authorize or record installation of agents/tools, creation of monitoring infrastructure, provider or cloud configuration, code/API/database/storage/auth/RLS changes, telemetry schema changes, alert or dashboard deployment, integration credentials, automated remediation, production tests, merge, or deployment.

## 14.37 DEC-061 — Incident Management & Problem Management

**Decision status:** Approved design direction for governance documentation only. This decision defines the incident/problem-management control framework; it does not approve operational runbooks, response-time commitments, regulatory conclusions, notification channels, staffing/on-call arrangements, or automated remediation.

### Purpose and scope
Establish a controlled process for identifying, recording, assessing, coordinating, resolving, and learning from incidents that affect SiteDocs availability, confidentiality, integrity, authenticity, accountability, or business continuity. The framework covers operational/service incidents, security and privacy incidents, data-integrity incidents, backup/restore and disaster-recovery incidents, integration/provider incidents, and significant failures in monitoring or audit evidence.

An **incident** is an event or set of related events requiring coordinated response because actual or credible potential impact exists. A **problem** is the underlying cause, contributing condition, or recurring risk that explains one or more incidents and requires investigation or durable corrective action. An incident may be resolved while its associated problem remains open. A problem may exist before an incident where a material weakness or recurring risk is identified.

### Classification and impact assessment
Every incident record should capture, as known and updated:
- unique incident identifier, detection and occurrence times (including uncertainty), reporter/detection source, affected service/component and environment;
- incident category and operational severity, affected projects/parties/record classes where safely identifiable, and current incident owner;
- actual and potential impact on availability, confidentiality, integrity, authenticity, auditability, safety of records, and continuity;
- scope, duration, affected users/recipients, data or workflow exposure, dependencies, and whether the issue is ongoing;
- containment, recovery, communication, evidence, decision, and review milestones;
- links to related alerts, logs, traces, audit events, support reports, changes, problems, and recovery records.

Operational incident severity is distinct from DEC-039 user-notification priority and from any WIR/document workflow status. A separately governed severity matrix should define impact/urgency criteria, cross-project/system-wide scope, escalation, and reclassification. Initial classification is provisional and must be revisable with an auditable reason; uncertainty must be stated rather than concealed. No fixed severity thresholds, response times, SLA, SLO, contractual consequence, or regulatory classification is approved by DEC-061.

### Incident lifecycle and accountability
The governed lifecycle should cover:
1. **Detect and report:** receive alerts, user/provider reports, monitoring signals, audit/security findings, or continuity warnings; provide a controlled reporting route.
2. **Register and acknowledge:** create a traceable incident record, assign an accountable owner, record initial scope and severity, and preserve original report details.
3. **Triage and assess:** validate the signal, identify impact and uncertainty, classify the incident, identify related incidents/problems, and determine whether specialist security, privacy, legal, provider, or business-owner review is required.
4. **Coordinate response:** appoint an incident lead/commander for material incidents, establish authorized responders and decision rights, maintain a timeline and action log, and define a controlled communication cadence.
5. **Contain:** take proportionate, authorized steps to limit ongoing impact while preserving evidence and avoiding unnecessary destruction or alteration of records.
6. **Eradicate or correct:** address the immediate fault or threat through an approved change or response path, with testing and review appropriate to risk.
7. **Recover and validate:** restore affected services or processes in a controlled order; verify security boundaries, data integrity, record/revision/attachment relationships, audit completeness, and business functionality before declaring recovery.
8. **Resolve and close:** document resolution evidence, residual risks, affected scope, required follow-up, accountable acceptance, and closure authority. Closing an incident does not automatically close its linked problem or waive obligations.
9. **Review and learn:** conduct a proportionate post-incident review, identify root and contributing causes, corrective/preventive actions, owners, due dates where approved, and effectiveness checks.

Incident roles and separation of duties must be explicit. Reporting an incident does not grant response authority. An incident commander coordinates but does not automatically gain permission to approve documents, sign, change project assignments, access unrelated project content, or bypass DEC-021. Technical responders receive only the temporary and least-privilege access necessary for their assigned response. Emergency access, if separately approved, must be time-limited, attributable, monitored, and reviewed after use.

### Security, privacy, and data-integrity incidents
Suspected unauthorized access, credential compromise, privilege escalation, data exfiltration, exposure of drafts or restricted records, tampering, malicious uploads, signing/approval abuse, or audit-log compromise must be treated as security-relevant incidents pending authorized assessment. Potential personal-data or contractual/regulatory implications must be escalated to designated privacy/legal/compliance owners for determination under applicable requirements; the system must not infer or declare legal notification duties or deadlines.

For suspected data-integrity or audit compromise, preserve relevant source records, immutable audit evidence, object metadata and bytes, hashes, configuration/version history, access decisions, and chain-of-custody details. Avoid destructive cleanup, log rotation, evidence overwrite, or restoration actions that could destroy evidence before authorized preservation decisions. Containment must not silently rewrite historical records or fabricate missing audit events.

Security incident records and evidence are restricted to authorized responders. General status updates and user-facing communications must disclose only verified, necessary information and must not reveal sensitive detection methods, affected-party data, or another party's confidential content.

### Emergency changes and recovery
Urgent changes may be required to contain or resolve an incident, but urgency does not create unrestricted authority. Emergency change handling must define the authorized approver(s), scope, risk assessment, separation of duties, implementation operator, validation, rollback/forward-fix plan, time of authorization, and retrospective review. Where immediate action is necessary to prevent imminent harm, the separately approved emergency policy must specify the narrow permitted actions and required contemporaneous or promptly subsequent records.

Incident response must align with DEC-056 configuration governance and DEC-059 backup/disaster recovery. Recovery must not promote unverified data, silently discard legitimate post-recovery activity, bypass revision/approval rules, or create split-brain official records. Any temporary manual continuity records must remain attributable, time-stamped, controlled, and reconciled after service restoration; they are not automatic approvals or substitutes for official workflow actions.

### Communications and stakeholder coordination
Maintain an incident communication record identifying audience, authorized sender, purpose, verified content, channel, timestamp, and delivery outcome. Distinguish internal responder coordination, affected-user/service notices, project/party communications, provider coordination, and any legally required notification determined by authorized specialists.

Communications must be accurate, proportionate, timely under separately approved policy, and updated when material facts change. Do not promise restoration times, declare data unaffected, confirm breach scope, or state regulatory conclusions without evidence and proper authority. Do not use broad project broadcasts where recipient authorization and need-to-know are not established. Specific channels, templates, audience matrices, status-page use, and notification timing remain open for separate approval.

### Problem management and root-cause analysis
A problem record should link all known related incidents and capture the affected service/process, symptoms, known error or suspected cause, evidence, root-cause analysis, contributing factors, workaround, risk assessment, corrective/preventive actions, owners, target dates where approved, and verification of effectiveness.

Root-cause review should examine technical, process, configuration, human-factor, supplier, capacity, security, and governance contributors without defaulting to individual blame. Distinguish confirmed cause, contributing factor, hypothesis, and unknown. A workaround is not permanent resolution. Recurrence, high impact, unresolved risk, repeated control failure, or a material near miss should trigger problem review under separately defined criteria.

Corrective actions must be tracked to completion with evidence and accountable acceptance. Where a proposed action changes product behavior, permissions, data, architecture, policy, or infrastructure, it follows the relevant approval and change-control gates; a problem record itself does not authorize implementation. Effectiveness checks should verify that the cause or risk has been reduced and that no new control weakness was introduced.

### Records, audit, and retention
Incident and problem records are controlled records with stable identifiers and append-only history for material events, classification changes, assignments, decisions, containment/recovery actions, access to evidence, communications, approvals, closure, and review outcomes. Corrections are recorded as new linked entries rather than overwriting the original account. Link to DEC-055 audit trail without treating ordinary operational notes as a substitute for authoritative audit evidence.

Apply DEC-054 retention, archive, and legal-hold controls to incident records and evidence. Preserve evidence under relevant holds and approved incident/legal instructions. Access, export, sharing, and disposal require authorization and audit. Retention periods, legal holds, and disposal authority are not set by this decision.

### Governance, metrics, and continuous improvement
Maintain controlled incident and problem registers and review trends such as incident volume by category/severity, recurrence, time to detect/acknowledge/contain/recover (where reliably measured), affected service/project scope, unresolved problems, overdue corrective actions under approved dates, and action effectiveness. Metrics must disclose definitions, data completeness, exclusions, and time basis; they must not be used as unsupported contractual SLA or individual-performance judgments.

Review incident/problem policies after major incidents, architecture/provider changes, security findings, exercises, or material changes to workflows and data. Link operational detection to DEC-060, audit to DEC-055, configuration to DEC-056, integration governance to DEC-057, and backup/DR to DEC-059.

### Open design details
The following require separate design and approval: incident/problem taxonomy; severity and impact matrix; reporting channels; incident commander and responder roles; on-call and escalation; emergency-access and emergency-change policy; security/privacy/legal escalation criteria; communication audiences/templates/channels; provider coordination; response and recovery objectives; evidence-handling and chain-of-custody procedures; root-cause method; problem review triggers; corrective-action governance; metrics and reporting; retention and legal-hold mapping; exercises and lessons-learned cadence; ownership, staffing, and cost.

**Implementation boundary:** design documentation only. DEC-061 does not authorize or record creation of incident tooling, ticketing integrations, on-call/paging configuration, security operations tooling, emergency access, production containment, credential rotation, data restoration, code/API/database/storage/auth/RLS/configuration changes, automated remediation, incident exercises against production, merge, or deployment.

## 14.38 DEC-062 — Change Management & Release Governance

**Decision status:** Approved design direction for governance documentation only. This decision establishes controlled change and release requirements; it does not approve any specific product change, production release, deployment pipeline, release calendar, emergency-change execution, database migration, or infrastructure modification.

### Purpose and scope
Establish a consistent, risk-based control process for changes to SiteDocs software, application behavior, UI, APIs, database schema/data, storage, authentication and authorization, RLS and security policies, integrations, infrastructure/provider configuration, operational procedures, report definitions, controlled templates, and governance configuration. It also governs packaging, validation, approval, deployment, verification, release communication, rollback/forward-fix, and post-release review.

A **change** is a proposed modification to a controlled system, configuration, process, or service. A **release** is an identified, versioned and authorized package or set of changes made available to a defined environment or user scope. A deployment is the technical act of placing an approved release into an environment; deployment success alone does not establish business acceptance or workflow approval.

### Change records and classification
Every change request should have a stable identifier and capture:
- requester, accountable owner, affected service/components, environment and intended scope;
- business/technical reason, expected outcome, alternatives, dependencies, and linked incident/problem/decision where relevant;
- change category and risk/impact assessment, including security, privacy, data integrity, availability, continuity, compatibility, regulatory/contractual, and user impact;
- affected projects, roles, record classes, workflows, integrations, data and external parties, as applicable;
- implementation plan, prerequisites, test and validation evidence, deployment window, communications, rollback/forward-fix plan, and acceptance criteria;
- reviewers, approvers, implementation operator, authorization time, actual execution times, outcomes, deviations, and post-implementation review.

Classify changes using a separately governed taxonomy, such as application/code, database/schema/data, security/access, storage, infrastructure/provider, integration/API, configuration, operational procedure, content/template/report, and documentation-only. Classification must not be used to bypass risk assessment. Related changes should be assessed together where splitting them would hide cumulative risk or dependencies.

A risk-based change model may distinguish routine pre-authorized changes, normal changes requiring case-specific review, and emergency changes needed to address an urgent threat or outage. The eligibility criteria, pre-authorization catalogue, approver roles, and evidence requirements for each class remain subject to separate approval. No change is automatically low-risk solely because it is small, reversible, or previously performed.

### Impact and risk assessment
Before authorization, assess:
- affected architecture, components, environments, dependencies, interfaces, data flows, users, projects, and third parties;
- security boundaries, least privilege, RLS/policies, identity, secrets, auditability, signing/approval integrity, and possible data exposure;
- data/schema compatibility, historical records, revision identity, attachment/storage bindings, numbering, workflow state, and referential integrity;
- availability, performance, capacity, reliability, recoverability, and business continuity;
- migration or transformation risks, backup/restore coverage, rollback feasibility, irreversible effects, and external copies;
- test scope, observability, operational readiness, support burden, user impact, training, and communications;
- interaction with other in-flight changes, open incidents/problems, legal holds, retention, and contractual constraints.

The assessment must identify assumptions, unknowns, residual risk, affected control owners, and any required specialist review. A risk acceptance must be explicit, attributable, within the approver's authority, scoped, and time-bounded where appropriate. No approval may waive mandatory security, audit, data-protection, or previously approved governance controls without a separately authorized policy decision.

### Review, approval, and separation of duties
Change request, technical review, security/privacy review, data-owner review, approval, implementation, validation, and release authorization are distinct capabilities. Not every change requires every specialist reviewer, but the risk assessment must explain which reviews apply and why.

The requester or implementer must not approve their own change where separation of duties is required. Approvals must identify the exact change scope, version/package, target environment, conditions, evidence reviewed, approver identity and authority, and time. Any material scope, artifact, dependency, or risk change after approval invalidates or reopens the relevant approval; approval cannot be carried forward to an unreviewed package.

Changes affecting project workflows, official records, signatures, document numbering, permissions, audit, retention, or data integrity require review by the accountable domain/control owners. Changes to governance decisions or approved baselines must follow the applicable decision and configuration governance process, including DEC-056. Documentation-only changes must be clearly distinguished from executable code, configuration, or schema changes.

### Development, environments, and validation
Use controlled and appropriately separated development, test/staging, and production environments. Production data must not be copied into lower environments unless separately authorized with privacy/security safeguards; use synthetic or appropriately masked data where possible. Access and credentials must be environment-specific and least-privileged.

Each change must have acceptance criteria and proportionate validation evidence. Depending on risk, this may include peer review, automated checks, unit/integration/system tests, security and authorization tests, migration rehearsal, performance checks, accessibility checks, regression tests, backup/restore verification, and business-owner acceptance. Test evidence must identify the build/change version, environment, test data class, execution time, result, exceptions, and responsible actor.

Passing automated checks alone is not sufficient for high-impact changes where business, security, data, or operational review is required. Failed, skipped, flaky, or incomplete tests must be disclosed; they must not be represented as passed. Test scope and evidence must cover relevant negative authorization cases, including draft visibility, party/project isolation, revision boundaries, and privileged actions where affected.

### Database, data, storage, and security-sensitive changes
Database migrations, data transformations, generated schema/types, RLS and grants, storage policies/buckets, attachment bindings, identity/authorization, secrets, signing, and numbering are high-impact control areas and require explicit change-specific planning and review.

For database or storage changes, require verified backups of both database state and relevant object-storage bytes/metadata, an isolated restore rehearsal, reconciliation of record counts and relationships, hashes and attachment bindings, and a documented recovery/rollback or forward-correction strategy appropriate to the change. A database-only backup is not sufficient evidence of recoverability for stored files. No migration or production data mutation may proceed merely because a change ticket exists.

For authorization or security-policy changes, include positive and negative access tests, role/party/project/revision scope checks, privilege-diff review, and evidence that deny-by-default boundaries remain effective. For secrets and signing-related changes, use approved secret/key lifecycle controls; never place secret values in change records, logs, or release notes.

Irreversible or destructive changes require explicit justification, affected-record inventory, legal-hold/retention review, dependent-record assessment, independent approval, and verified recovery/disposition plan. Where a safe rollback is impossible, the approval must explicitly consider forward recovery and residual risk.

### Release identity and release package
Each release must have a unique, immutable release identifier and identify:
- exact source commit(s), build/artifact identity and integrity hash where applicable;
- included change-request IDs and approved scope;
- application/service/configuration/schema versions and dependencies;
- target environment and deployment strategy;
- test, security, migration, and acceptance evidence;
- release notes, known issues, compatibility constraints, and operational instructions;
- approval records, deployment actor, timestamps, result, and post-deployment verification.

A release package must be traceable to the exact approved artifacts. Rebuilding or modifying the package after approval requires revalidation and any renewed approval dictated by the changed scope. Tags, branch names, or a successful build alone do not constitute release approval. Source-control merges, branch protection, signing/provenance, artifact registry, and pipeline controls require separately specified technical implementation.

### Deployment, verification, and rollback
Deploy only the exact authorized release to the approved environment and scope. Use a controlled deployment window and communications where required. Record pre-deployment checks, operator, approvals, artifact identity, start/end time, deployment steps, automated/manual outcomes, deviations, and resulting version.

Post-deployment verification must confirm service health, critical user journeys, security and authorization boundaries, data integrity, integrations, background jobs, notifications, monitoring, and business acceptance as applicable to the change. A technically successful deployment is not sufficient if required verification fails.

Each change must define rollback, roll-forward, or compensating-action criteria and decision authority. Consider database and data compatibility, external side effects, queued work, generated records, and external copies before rollback. Do not assume that reverting application code reverses a schema/data change or recalls distributed documents. If rollback is unsafe or impossible, use a pre-approved forward-fix/recovery plan and document residual risk. Any rollback is itself a controlled and auditable change.

### Emergency changes
Emergency changes may be used only to address a material, time-critical threat, outage, integrity issue, or comparable urgent risk under a separately approved emergency policy. Emergency status does not remove accountability, scope control, evidence capture, or security boundaries.

The emergency process must define who may declare an emergency, authorized approvers/responders, permitted scope, minimum risk checks, separation-of-duties exceptions if any, contemporaneous record requirements, communication, validation, rollback/forward-fix, and mandatory retrospective review. Where prior review is impracticable, the policy must specify the narrow authorization route and prompt post-action review. Emergency classification must not be used to accelerate routine feature delivery or avoid normal review.

### Release communication and operational readiness
Release communications should identify the release and affected scope, expected user impact, planned timing, material changes, known issues, required user actions, support route, and any service interruption, without exposing secrets or sensitive security details. Recipients must be selected according to role, project, and need-to-know; no broad distribution by default.

Before release, confirm operational ownership, monitoring/alert coverage under DEC-060, incident readiness under DEC-061, backup/recovery arrangements under DEC-059, support documentation, and any training or handover needed. Release notes and communication do not themselves change official document records or workflow states.

### Post-implementation review and records
For material or risk-significant changes, conduct a post-implementation review to compare expected and actual outcomes, confirm control effectiveness, record incidents/deviations, assess rollback/forward-fix performance, and identify follow-up problems/actions. Define review triggers and timing separately; no universal time limit is set here.

Retain immutable change history linking request, risk assessment, reviews, approvals, exact release artifacts, test evidence, deployment events, verification, communications, exceptions, rollback, and review outcomes. Corrections and later findings are appended and linked, not used to overwrite the approved history. Apply DEC-054 retention/legal-hold, DEC-055 audit, DEC-056 configuration governance, DEC-060 observability, and DEC-061 incident/problem management.

### Open design details
The following require separate design and approval: change taxonomy and class eligibility; risk matrix; pre-authorized change catalogue; review/approval role matrix; emergency criteria and authority; environment architecture and data masking; test evidence standards; CI/CD and branch protections; artifact provenance/signing; release numbering/versioning; deployment strategies/windows; migration and storage recovery standards; rollback/forward-fix decision criteria; release communications; operational readiness checklist; post-implementation review triggers; retention; metrics; ownership and costs.

**Implementation boundary:** design documentation only. DEC-062 does not authorize any code change, branch merge, build/deployment pipeline configuration, release, production deployment, database migration, data mutation, storage/auth/RLS/grant/secret/key change, infrastructure/provider configuration, integration change, automated remediation, production test, or operational execution.

## 14.39 DEC-063 — Access Reviews & Periodic Permission Recertification

**Decision status:** Approved design direction for governance documentation only. This decision establishes access-review and permission-recertification controls; it does not approve a review schedule, automatic revocation mechanism, identity-provider configuration, or production permission change.

### Purpose and scope
Establish a repeatable process to verify that every human, service, integration, and privileged identity has a valid business purpose, an accountable owner, an active relationship to the relevant project or service, and only the capabilities required for its current duties. Reviews cover organization/project membership, Project Team Roster assignments, account lifecycle, role and capability grants, document/revision visibility, draft access, attachment and storage operations, reporting/export, administration, integrations, emergency access, and other privileged paths.

Access review is a governance control over existing identity and authorization decisions. It does not replace DEC-020 roster lifecycle, DEC-021 capability-based authorization, authentication controls, or server-side authorization checks. A completed review does not make an otherwise invalid permission valid.

### Review population and evidence
Each review cycle should establish a scoped, reproducible snapshot of:
- human user identities and account status, including invited, pending, active, suspended, and ended relationships;
- project, party, discipline, and role assignments, including assignment start/end dates and responsible roster owner;
- effective capabilities and inherited/derived grants, including privileged and exceptional access;
- access to projects, documents, drafts, revisions, attachments, reports, exports, archives, transmittals, notifications, audit evidence, and administrative functions;
- service accounts, API credentials, integration identities, automation identities, and other non-human principals, with technical owner, business purpose, scope, credential owner, and last-used evidence where reliably available;
- temporary, emergency, delegated, exceptional, and time-limited grants, including expiry and approval references;
- access paths through groups, policies, service roles, storage policies, APIs, and other indirect mechanisms where technically applicable.

The review evidence must identify the review scope, snapshot/as-of time, source systems, extraction or policy version, reviewer, accountable approver, findings, exceptions, decisions, completion status, and evidence references. Reviewers must be able to distinguish directly assigned capabilities from inherited or effective permissions; incomplete visibility into an access path must be recorded as a limitation, not treated as proof that access does not exist.

### Review triggers and cadence
Reviews should be both periodic and event-driven. Potential triggers include:
- scheduled recertification for users, privileged identities, projects, and service accounts;
- onboarding, project assignment, transfer, promotion, role or discipline change;
- assignment expiry, contract completion, offboarding, suspension, or termination;
- change of party, project scope, responsibility, or delegated authority;
- material permission, role, roster, policy, integration, or organizational change;
- prolonged inactivity or unexpected use, where reliable evidence and policy support review;
- security incident, suspected compromise, audit finding, or detected access anomaly;
- creation, renewal, or extension of emergency or temporary access.

Exact intervals, event triggers, grace periods, and escalation windows must be defined in a separately approved risk-based review schedule. DEC-063 does not set a universal monthly, quarterly, or annual interval, nor does it establish an SLA. High-impact and privileged access should receive appropriately stronger and more frequent scrutiny under the approved schedule.

### Reviewer independence and decision rights
The review process must separate the identity/access administrator who prepares the evidence, the business or project owner who confirms the continuing need, the relevant capability/security owner who validates the technical scope, and the authorized approver who accepts or rejects the review outcome, as applicable.

Users must not certify their own access as the sole reviewer or approver. Project managers may confirm supervisory business need within their authority but do not gain permission to approve documents, sign, perform technical administration, or alter another party's records. Project/party owners cannot approve access outside their authority or visibility. Privileged and security-sensitive grants require independent review by an appropriately authorized owner.

Reviewers must assess actual duties and least-privilege need, not merely job title, historical possession of access, project membership, convenience, or the fact that a user previously performed an action. A review is not complete merely because a notification was sent or acknowledged.

### Review outcomes and remediation
Each reviewed access item should receive an explicit outcome, such as:
- **Retain:** current purpose and scope are confirmed;
- **Modify:** reduce, correct, or otherwise change capabilities or scope;
- **Revoke/End:** access is no longer justified or the underlying assignment has ended;
- **Time-bound exception:** retain narrowly scoped access until an approved expiry or review point;
- **Investigate:** evidence is incomplete, conflicting, or indicates unexpected access;
- **Not applicable:** identity or grant is outside the defined scope, with reason and owner.

Findings must identify the affected identity, grant, project/service, decision, reason, accountable decision-maker, effective date/time, remediation owner, and completion evidence. Exceptions require documented justification, scope, compensating controls, approving authority, expiry/review date, and escalation if not resolved. No indefinite exception by default.

Remediation must use the controlled identity, roster, and authorization change processes. Revocation or modification must be verified against effective access paths, including API, storage, inherited, cached, and session-related paths where applicable. The design must define how promptly access is blocked and how existing sessions, tokens, signed URLs, credentials, caches, and background jobs are handled. DEC-063 itself sets no universal revocation time. Failed or partial remediation remains open and visible until verified.

### Joiner, mover, leaver and assignment lifecycle
Access should be granted only after identity verification, approved sponsorship, active project/party assignment where required, and explicit capability authorization. A pending invitation or roster entry does not grant active access. A role or assignment change must trigger review of both removed and newly required capabilities; new access is not automatically inherited from a previous role.

When an assignment ends, is suspended, or a person leaves the organization/project, future access and actions must be blocked according to approved lifecycle policy, while records of prior activity remain attributable and intact. This includes stopping future signing, approval, review, submission, upload, download, export, and administrative actions where the relevant authority has ended. Reassignment of open work must be performed through the governed workflow and must not rewrite the historical actor.

Historical signatures, approvals, decisions, comments, uploads, audit events, and document attribution must not be deleted, reassigned, or falsely attributed because an account is suspended or access is revoked. Retention and authorized historical access follow DEC-054 and applicable record controls. A former user's historical action does not grant that user continuing access.

### Non-human and privileged access
Every service account, integration identity, API credential, automation principal, and privileged identity must have a named accountable owner, documented purpose, approved scope, environment, dependency, credential/key custody, rotation/review requirements, and expiry or renewal basis where applicable. Shared human accounts and unattributed service credentials are prohibited by design. Secrets must never appear in review exports or evidence.

Non-human identities must be reviewed for least privilege, unused permissions, obsolete integrations, excessive scopes, interactive-login capability, environment crossover, and credential age/rotation status where available. Privileged access should be separately inventoried and reviewed, with just-in-time or time-bounded access considered where appropriate; no specific technical mechanism is mandated here.

Emergency/break-glass access must be exceptional, attributable, narrowly scoped, time-limited, monitored, and subject to independent post-use review. A review cannot normalize permanent emergency access or convert it into ordinary entitlement.

### Verification, audit, and reporting
The process must verify that approved changes were actually applied and that removed capabilities no longer work through relevant access paths. Where practical, use positive and negative tests for representative identities and resources; preserve test scope, result, timestamp, environment, and responsible actor. A database or UI display of a role is not sufficient evidence that all effective permissions are correct.

Retain a review record linking the exact access snapshot, identities and grants reviewed, decisions, exceptions, remediation actions, verification results, and closure. Record non-response, overdue review, incomplete inventory, unavailable source, and unresolved discrepancy explicitly. Do not treat silence as approval or automatically retain access because a reviewer failed to respond.

Review completion and exception metrics should disclose population, coverage, overdue items, unreviewed grants, remediation age, failed revocations, privileged access, and source-data limitations. Aggregate dashboards and exports must obey the same access controls and must not expose another party's project or identity information.

Apply DEC-054 retention/legal-hold controls and DEC-055 append-only audit. Changes to role/capability definitions and access policy follow DEC-056. Incident-triggered reviews align with DEC-061; monitoring of anomalous access aligns with DEC-060; roster and capability model align with DEC-020 and DEC-021.

### Open design details
The following require separate design and approval: review frequency and risk tiers; complete identity/grant inventory and source-of-truth mapping; reviewer/approver role matrix; evidence snapshot format; effective-permission calculation; joiner/mover/leaver timelines; revocation/session/token/cache handling; service-account ownership and credential lifecycle; privileged and emergency access policy; exception duration and escalation; positive/negative verification method; review tooling and reminders; reporting and metrics; retention and evidence format; ownership and cost.

**Implementation boundary:** design documentation only. DEC-063 does not authorize identity-provider changes, account suspension, access grants/revocations, RLS/grant/policy modifications, token or secret rotation, service-account creation, integration changes, production access tests, automated recertification/remediation, code/database/storage/auth/API/UI changes, merge, or deployment.

## 14.40 DEC-064 — Data Classification, Privacy & Information Protection

**Decision status:** Approved design direction for governance documentation only. This decision establishes information-protection principles and classification governance; it does not determine a legal basis for processing, declare regulatory compliance, approve a data-residency location, select encryption/DLP products, or authorize production data-handling changes.

### Purpose and scope
Establish a consistent framework to classify, handle, store, access, use, transmit, disclose, export, retain, archive, and dispose of information processed by SiteDocs. Scope includes project and contract records, controlled documents and revisions, drafts, drawings, inspection records, reports, correspondence, transmittals, signatures and approval evidence, attachments and scans, user and roster data, personal information, credentials and secrets, audit/security/incident evidence, operational telemetry, backups, and metadata that may reveal the existence or context of protected records.

Information protection applies to content and metadata across user interfaces, APIs, database records, object storage, caches, logs, search indexes, notifications, exports, integrations, support workflows, lower environments, backups, archives, and third-party services.

### Classification model
Adopt a governed classification scheme with at least the following proposed levels, subject to a controlled classification catalogue and approval:

1. **Public:** information explicitly approved for unrestricted public release by an authorized owner. Information is not Public merely because it is visible on a website, sent externally, or marked as such by a user.
2. **Internal:** routine non-public business or operational information intended for authorized SiteDocs users and approved internal purposes; disclosure outside the authorized context is not presumed permitted.
3. **Confidential:** project, contractual, commercial, technical, personnel, or other information whose unauthorized access or disclosure could cause material harm or breach a duty of confidence. Access is restricted to specifically authorized parties, projects, roles, and purposes.
4. **Restricted:** highly sensitive information requiring narrowly scoped, explicit authorization and enhanced handling, such as authentication secrets, private keys, signing credentials, security-sensitive evidence, highly sensitive personal information, or exceptionally sensitive contractual/project material.

The catalogue must define examples, handling rules, default classification by record family, ownership, review triggers, and permitted exceptions. Legal or regulatory categories may require additional tags or handling overlays; they do not replace the baseline classification.

Classification is not itself an access grant. A user must satisfy both the classification handling requirements and the applicable project/party/document/revision capability checks under DEC-021. Conversely, a record's classification cannot be used to bypass a stricter workflow or confidentiality rule. Access must be denied when classification, ownership, scope, or handling requirements are unknown or unresolved.

### Classification ownership and lifecycle
Each information asset or record family must have an accountable information owner or data steward responsible for assigning and reviewing classification, purpose, permitted use, sharing conditions, and retention linkage. The system may apply approved defaults based on record type or source, but automated defaults must remain reviewable and must not silently downgrade protection.

Classification should be assigned at creation or ingestion, inherited by derivatives and exports unless a documented assessment justifies a different classification, and reviewed when content, purpose, recipient, contractual context, or applicable requirements change. Mixed-content packages must follow the highest applicable classification unless separately segmented and protected.

Downgrading or declassification requires documented rationale, evidence, owner approval, effective time, and audit history. A change in classification must not retroactively erase prior access restrictions or historical disclosure events. Where classification is disputed or missing, apply the more protective reasonable handling until the authorized owner resolves it.

### Privacy and purpose limitation
Personal information must be processed only for a defined, documented, authorized SiteDocs purpose and limited to what is reasonably necessary for that purpose. Define data categories, collection source, purpose, authorized users/recipients, sharing, retention trigger, and responsible owner. Avoid collecting sensitive or unnecessary personal information in free-text fields, attachments, logs, notifications, and reports.

Privacy design should address transparency and notices, data minimization, accuracy, access correction where applicable, purpose limitation, retention, secure disposal, data-subject or individual requests where legally applicable, and privacy impact assessment for higher-risk processing. The applicable legal basis, controller/processor roles, statutory rights, cross-border transfer requirements, breach-notification duties, and exact response deadlines must be determined by qualified legal/privacy owners for the relevant jurisdiction and contract; DEC-064 does not decide them.

Do not infer or create sensitive personal profiles from operational data unless a separately approved lawful and necessary purpose exists. Avoid using document, inspection, access, or performance data for unrelated employee monitoring or profiling. Any secondary use, analytics, model training, or product improvement involving project or personal data requires separate purpose, legal/privacy, contract, and security review; no such secondary use is authorized by this decision.

### Handling controls throughout the information lifecycle
The classification catalogue should define minimum controls for:
- **Creation and collection:** approved purpose, required fields, source/provenance, ownership, classification, and validation; avoid collecting data not needed for the transaction.
- **Viewing and use:** least privilege, authenticated identity, current assignment and capability, server-side checks, restricted previews, and no exposure through search counts, autocomplete, notifications, or dashboards.
- **Storage:** approved locations and services, private-by-default object storage for non-public content, encryption and key-management requirements, environment separation, access logging, and protection of temporary files, caches, and replicas.
- **Transmission and sharing:** approved channels and recipients, authenticated access, minimum necessary content, protected transfer, explicit purpose, expiry/revocation where supported, and no anonymous public links by default.
- **Printing and physical handling:** controlled print/download, appropriate labels and handling instructions, recipient verification, secure transport and storage, and disposition of working copies.
- **Export and reporting:** exact authorized record/revision/snapshot selection, reauthorization at generation and delivery, classification carried into output, recipient and destination controls, export audit, and protection against spreadsheet formula injection.
- **Support and troubleshooting:** masked or synthetic data where possible, restricted temporary access, purpose and approval, time limits, and audit; support convenience does not create unrestricted access.
- **Lower environments and testing:** synthetic or appropriately masked data by default; production data only under separate authorization and safeguards, with no uncontrolled copies.
- **Archive, backup, and disposal:** apply DEC-054 and DEC-059, preserve legal holds, and ensure classification/retention controls follow copies and derivatives.

### Drafts, documents, attachments, signatures, and metadata
Drafts remain subject to the strict visibility rules in DEC-021 and must not leak through registers, search, previews, notifications, exports, support tools, or metadata. Classification labels do not make a draft visible to otherwise unauthorized parties.

Document and revision classification must be bound to the exact immutable record/revision and its authorized files. An attachment inherits the parent record's protection at least; an attachment containing more sensitive material may require a higher classification. Scans, OCR text, thumbnails, extracted metadata, previews, temporary conversions, and generated PDFs are protected derivatives and must not be less restricted than their source without an approved assessment.

Signatures, signing credentials, approval evidence, identity attributes, and security evidence require enhanced protection. A visible signature image is not a credential and must not be treated as proof of approval; DEC-018 and the governed signing workflow remain controlling. Secrets and private keys must never be stored in ordinary document fields, attachments, logs, or exports.

Metadata such as document titles, project names, reference numbers, parties, assignees, timestamps, status, notification previews, and even the existence of a record may itself be confidential. Apply access control to metadata, search results, counts, facets, snippets, and error messages, not only to file bytes.

### Sharing, recipients, and third parties
External disclosure must have an authorized purpose, data owner approval where required, verified recipient identity, minimum necessary scope, approved channel, and documented conditions. A transmittal or recipient list does not itself grant access to source records; apply DEC-050 and DEC-051 exact-version and recipient-level authorization. Delivery, access, acknowledgement, and approval remain distinct under DEC-052.

Third-party processors, cloud providers, support vendors, and integration partners require documented service purpose, data categories, access scope, security responsibilities, confidentiality, subcontracting, incident cooperation, retention/deletion, location/transfer terms, and return/disposal expectations as applicable. Provider access must be least-privileged, attributable, time-bounded where feasible, and reviewed. No vendor, provider, or cross-border transfer is approved by DEC-064.

### Protection, monitoring, and incident response
Apply protection proportionate to classification, including encryption in transit and at rest where approved, key separation and custody, access logging, integrity verification, malware/quarantine controls for uploads, controlled export, and secure deletion/disposal. Exact cryptographic standards, key custody, residency, and technology choices require separate security architecture approval.

Monitoring and telemetry must follow DEC-060 minimization and redaction requirements. Security/privacy incidents, misdirected disclosures, lost devices/media, unauthorized exports, compromised credentials, or suspected exposure must be handled under DEC-061 with evidence preservation and appropriate privacy/legal escalation. Do not conceal or silently reclassify a disclosure event.

### Governance, review, and evidence
Maintain a controlled information-asset/classification register with record family, data owner/steward, classification, purpose, source, permitted uses/recipients, storage/transfer locations, retention category, processing dependencies, third parties, and review history. Review classifications and handling rules after material changes to data content, workflow, purpose, recipients, contract, provider, architecture, or applicable legal requirements.

Classification and privacy-policy changes follow DEC-056; access follows DEC-021 and DEC-063; retention and disposal follow DEC-054; audit follows DEC-055; sharing/transmittals follow DEC-050 through DEC-052; revision control follows DEC-053; imports/exports follow DEC-058; backup/DR follows DEC-059; monitoring and incident response follow DEC-060 and DEC-061.

### Open design details
The following require separate design and approval: classification labels and detailed catalogue; record-family defaults and owners; privacy data inventory and purposes; applicable jurisdictional legal basis and controller/processor allocation; notices and individual request processes; privacy impact assessment criteria; residency and cross-border transfers; encryption and key custody; approved channels and external-sharing rules; third-party assurance and contracts; watermark/print controls; DLP and export controls; retention mapping; data masking; classification review cadence; incident notification decision process; audit evidence and metrics.

**Implementation boundary:** design documentation only. DEC-064 does not authorize data collection changes, production classification changes, encryption/key operations, DLP tooling, data masking or migration, provider or residency changes, external sharing, new integrations, legal notices, data-subject request execution, retention/disposal operations, code/database/storage/auth/RLS/API/UI changes, production tests, merge, or deployment.

### 14.41 DEC-065 — Data Integrity, Validation & Consistency Governance

**Status:** Design proposal / requirements baseline only. This decision does not authorize implementation.

**Purpose**
Establish end-to-end controls so that SiteDocs records remain accurate, complete, attributable, internally consistent, and reproducible across modules, revisions, attachments, workflow events, reports, imports/exports, integrations, and recovery operations.

**Decision requirements**
1. **Authoritative source and ownership:** Every governed data element and record family must have a defined authoritative source, accountable business owner, permitted writers, and correction path. Derived values, caches, dashboards, search indexes, exports, and integrations must not silently become authoritative.
2. **Validation layers:** Define validation at user input, API/service boundary, database constraints, workflow transition, file/attachment processing, import, integration, report generation, and restore/reconciliation. Client-side validation is usability support only; server-side validation is authoritative.
3. **Structural and semantic validation:** Validate required fields, data types, ranges, formats, enumerations, units, date/time zones, cross-field rules, project/party/discipline scope, and family-specific business rules. Distinguish syntactic validity from business eligibility and authorization.
4. **Referential integrity:** Verify that linked projects, parties, users, assignments, documents, revisions, items, attempts, attachments, signatures, reports, transmittals, receipts, and financial references exist, belong to the correct scope, and are valid for the referenced lifecycle state. Reject or quarantine broken or ambiguous links; do not guess relationships.
5. **Identity and numbering integrity:** Preserve stable internal identities and governed official references. Enforce uniqueness within the approved numbering scope, prevent reuse, and distinguish document number, revision, WIR attempt, report version, transmittal reference, and draft/internal identifiers.
6. **Revision and snapshot integrity:** Bind every action, approval, signature, attachment, report, and transmittal to the exact immutable revision or snapshot intended. Never substitute “latest” implicitly. Material changes require the applicable new revision/snapshot and workflow; prior evidence remains historically attributable.
7. **Workflow consistency:** Permit state changes only through authorized, defined transitions and valid preconditions. Keep record status, item status, review outcome, revision, attempt, notification state, delivery state, and payment state as separate dimensions where their meanings differ. Prevent impossible combinations and unauthorized direct status edits.
8. **Atomicity and concurrency:** Define transaction boundaries for multi-record operations, including primary attachment selection, number allocation, submission, approvals, signature capture, payment posting, and linked updates. Use concurrency controls/idempotency to prevent duplicate submissions, double posting, lost updates, race conditions, and partial inconsistent commits. Where atomic processing is not possible, expose item-level outcomes and reconciliation requirements.
9. **Precision and financial arithmetic:** Financial and quantity calculations must use explicitly defined precision, rounding mode, currency, unit, tax/retention/deduction treatment, and effective calculation rules. Preserve source quantities/rates and calculation breakdowns; do not rely on binary floating-point for authoritative financial amounts. No tax, accounting, payroll, or contractual rule is approved by this decision.
10. **Temporal integrity:** Store authoritative event timestamps consistently with timezone context where needed; distinguish event time, effective date, target date, due date, posting date, and display time. Preserve historical values and the actor/time of changes; do not rewrite history to reflect current configuration.
11. **Data correction:** Corrections to official records must follow family-specific authority and lifecycle rules. Use append-only correction, amendment, reversal, or superseding records where required; retain original value, corrected value, reason, actor, authority, and timestamp. No silent overwrite or deletion of authoritative history.
12. **Duplicate and anomaly handling:** Detect exact duplicates, probable duplicates, conflicting records, orphaned references, impossible transitions, missing required evidence, and out-of-range values. Distinguish automated detection from confirmed findings; route ambiguous cases for authorized human resolution.
13. **File and evidence integrity:** Validate file type/content, size, malware/quarantine state, object identity, parent scope, revision binding, checksum/hash, and storage availability. A metadata row without its bytes, or bytes without a valid authorized binding, is an integrity exception. Hash equality supports integrity checking but does not prove authorship or approval.
14. **Derived data and reporting:** Document lineage, source record IDs, source revisions/snapshots, calculation version, extraction time, and freshness for derived metrics and reports. Reconcile totals to authoritative records and disclose stale, incomplete, excluded, or failed inputs. Reports do not repair or mutate source records.
15. **Import, export, integration, and migration:** Apply DEC-057/058 provenance, schema mapping, validation, idempotency, duplicate/conflict classification, reconciliation, and human exception handling. External updates cannot overwrite governed SiteDocs records without an approved ownership and conflict rule.
16. **Backup and recovery consistency:** Apply DEC-059 coordinated database/object-storage recovery, link and hash reconciliation, and controlled replay/catch-up. A technically successful restore is not complete until integrity exceptions are identified, reconciled, and accepted by the accountable business owner.
17. **Audit and observability:** Record validation failures, rejected transitions, duplicate/idempotency outcomes, correction events, reconciliation exceptions, and resolution evidence under DEC-055. Operational telemetry follows DEC-060 without replacing the authoritative audit trail.
18. **Security and privacy:** Validation and error messages must not disclose unauthorized record existence or sensitive values. Access checks remain server-side under DEC-021/063; integrity controls do not grant access or override confidentiality classifications under DEC-064.
19. **Exception management:** Every accepted exception must have an accountable owner, reason, scope, risk/impact, compensating control, approval where required, expiry/review condition, and resolution evidence. Unresolved high-impact integrity exceptions remain visible and must block dependent official actions when their correctness cannot be established.
20. **Testing and assurance:** Define positive, negative, boundary, concurrency, idempotency, reconciliation, historical-data, import/export, file-integrity, and recovery tests for each applicable record family. Test evidence must identify environment, dataset, version, expected/actual result, failures, and reviewer. Production testing requires separate authorization.

**Cross-decision dependencies**
DEC-021/055/056/057/058/059/060/061/062/063/064; DEC-022 and DEC-053 for numbering/revisions; DEC-025–044 for WIR lifecycle and reporting; DEC-045–052 for reports, registers, transmittals, and receipts. Financial calculations and payroll rules require a separately governed financial-module design.

**Open design details**
Record-family validation catalogues; authoritative-field ownership matrix; numbering scopes; precision/currency/unit rules; correction authority by family; transaction and concurrency strategy; duplicate thresholds; reconciliation frequency and ownership; integrity exception severity and blocking gates; hash algorithms and file scanning standards; historical-data remediation; test coverage and acceptance criteria; financial, payroll, tax, and contractual calculation rules.

**Implementation boundary:** design documentation only. DEC-065 does not authorize code, database/schema/constraint/trigger, storage, auth/RLS, API, UI, migration, data correction, production validation, integration, financial posting, payroll processing, backup/restore, test execution, merge, or deployment.

### 14.42 DEC-066 — Business Continuity of Records & Controlled Operational Handover

**Status:** Design proposal / requirements baseline only. This decision does not authorize implementation.

**Purpose**
Ensure project work, records, decisions, evidence, and accountable responsibilities remain controlled when personnel change, assignments end, a project changes phase or operator, a service interruption occurs, or records are transferred between authorized teams. Handover must preserve history and authority rather than transfer personal identity or silently reassign decisions.

**Decision requirements**
1. **Continuity principle:** The project record is institutional and remains with the governed project record set. It must not depend on one employee's personal account, mailbox, device, or local files. No handover changes the original actor attribution.
2. **Triggering events:** Support planned and unplanned personnel departure, leave or unavailability, role/assignment change, contractor/consultant/owner replacement, project management transition, organizational restructuring, project phase transition, contract closeout, service-provider transition, and recovery/continuity events.
3. **Handover authority:** Define who may initiate, prepare, review, accept, and close each handover by project, party, record family, and risk. A person may hand over their own assigned work but cannot grant access, approve their own replacement, or transfer authority beyond their capability.
4. **Handover scope:** Generate an authorized inventory of open and recently active records, pending actions, deadlines/target dates, assigned owners, current workflow states, drafts visible to the authorized handover roles, pending reviews/approvals/signatures, unresolved comments, evidence, linked records, transmittals/responses, exceptions, and known dependencies. Include financial and administrative records only where that module is separately enabled and the handover role is authorized.
5. **Exact record context:** Each handover entry must identify the stable record ID and exact document revision, WIR item/attempt, report snapshot/version, transmittal manifest, or other applicable immutable context. Never replace a historical reference with “latest” or silently change the source record.
6. **Status and action distinction:** Clearly distinguish informational context, action required, overdue/target-date tracking, blocked work, awaiting external response, and completed work. A handover acknowledgement is not completion of the underlying workflow, review, approval, signature, payment, or contractual obligation.
7. **Successor assignment:** New responsibility becomes effective only after the successor's identity, active project/party assignment, scope, discipline, competence/qualification where required, and capability are validated under DEC-020/021. A handover package alone does not grant access or authority.
8. **No identity transfer:** Never transfer passwords, sessions, MFA factors, personal signatures, signing keys, tokens, or accounts. Historical actions remain attributed to the original authenticated actor. The successor must act through their own identity and authorization.
9. **Controlled reassignment:** Reassignment of a workflow owner, reviewer, inspector, approver, custodian, or action recipient follows the applicable module's rules and authorized action. Preserve prior and new assignee, actor, time, reason where required, effective time, affected scope, and result. Do not change pending approval/signature attribution or imply that the successor performed prior work.
10. **Separation of duties:** Handover preparation, validation, acceptance, access provisioning, and high-risk reassignment should be separated according to risk and authority. No self-approval, proxy signature, or automatic transfer of approval authority.
11. **Handover package:** Provide a controlled, versioned manifest containing scope, source systems, as-of time, record identifiers and exact versions, outstanding actions, responsible parties, access prerequisites, exceptions, attachments/evidence references, reconciliation results, preparer, reviewers, recipient, and acceptance state. Package contents remain subject to classification and recipient authorization under DEC-064.
12. **Validation and reconciliation:** Before acceptance, verify record counts and categories, open-action inventory, exact version links, attachment availability and hashes where applicable, financial/custody balances where in scope, and unresolved exceptions. Distinguish verified, unverified, missing, disputed, and not-applicable items. Do not mark complete when material discrepancies remain unexplained.
13. **Acknowledgement and acceptance:** Record the recipient's authenticated acknowledgement, acceptance or qualified acceptance, timestamp, scope, exceptions, and any requested correction. A refusal or partial acceptance remains visible and escalates to the authorized project owner; silence is not acceptance.
14. **Temporary coverage:** Temporary delegation or acting coverage must be explicit, narrow, time-bound, approved by an authorized independent role, and limited to specified actions and records. It does not allow signature sharing, blanket role inheritance, self-approval, or access to unrelated projects. Expiry and revocation must be enforced and audited.
15. **Unavailability and emergency continuity:** Provide an authorized continuity route when a person is unavailable or an organization exits unexpectedly. Emergency access, if separately approved, is time-bound, monitored, least-privilege, and independently reviewed under DEC-061/063. It must not fabricate the unavailable person's approval or signature.
16. **Access lifecycle coordination:** On transfer or end of assignment, update roster and capabilities through controlled processes, verify revocation across application, API, storage, integrations, sessions, and cached access paths, and provision successor access separately. Revocation must not remove historical attribution or records.
17. **Project and provider transition:** For project handover, closeout, or provider change, define transfer scope, authoritative system, custody, destination, recipients, legal/contractual constraints, data format, integrity manifest, secure transfer, acceptance, and residual obligations. Apply DEC-057/058 and DEC-064; a transfer does not itself authorize external disclosure or migration.
18. **Financial and physical custody:** Where the financial module is enabled, separately reconcile project cash advances, petty-cash custody, outstanding advances, receipts, expense claims, payroll period status, approved/unpaid amounts, payment evidence, and accountable custodians. Separate accounting records from physical cash/asset custody and require independent verification where risk warrants. No financial or payroll posting authority is created by this decision.
19. **Communications and continuity plan:** Identify critical contacts, approved communication channels, escalation owners, service dependencies, and fallback procedures. Do not expose restricted records in broad handover notifications or personal email. Manual fallback records must be attributable, dated, controlled, and reconciled after service restoration; they do not automatically become approved system records.
20. **Audit and retention:** Preserve handover creation, scope changes, exports, access decisions, reassignment, acceptance, exceptions, corrections, and closure as append-only auditable events under DEC-055. Retain packages and evidence under DEC-054 and apply legal holds.
21. **Monitoring and review:** Monitor overdue or incomplete handovers, expired temporary coverage, unaccepted critical responsibilities, failed access revocations, and unresolved reconciliation exceptions under DEC-060. Incidents and suspected compromise follow DEC-061.
22. **Reporting:** Provide authorized handover status and exception reporting without leaking drafts, restricted records, or cross-party information. Counts and summaries must follow the same server-side authorization as underlying records.
23. **Business ownership:** Each project/organization must define critical roles, handover thresholds, acceptance authority, minimum inventory, reconciliation tolerances, and escalation path. No universal handover SLA or fixed acceptance period is established here.

**Cross-decision dependencies**
DEC-020/021/055/054/056/057/058/059/060/061/062/063/064/065; DEC-038–044 for WIR notifications and actions; DEC-050–053 for transmittals, access receipts, responses, revisions and withdrawal; DEC-059 for recovery; and the separately governed financial-module design for cash, expenses, payroll, and payment custody.

**Open design details**
Handover types and templates; authority matrix by project/party/module; minimum inventory and lookback period; acceptance and dispute workflow; qualification checks; temporary coverage limits; emergency-access procedure; reconciliation tolerances; financial/physical custody forms; retention periods; notifications/escalation; provider transition controls; export formats; mobile/offline support; operational metrics and training.

**Implementation boundary:** design documentation only. DEC-066 does not authorize production handover, account or role changes, access provisioning/revocation, workflow reassignment, financial or payroll posting, data export/migration, external transfer, emergency access, code/database/storage/auth/RLS/API/UI changes, tests, merge, or deployment.


## 14.43 DEC-067 — Project Closeout, Final Records Handover & Completion Governance

**Purpose:** Establish a controlled, auditable framework for project closeout and final records handover, ensuring that technical, administrative, contractual, financial, operational, and records obligations are assessed without conflating their distinct meanings or authorities.

**Core requirements**

1. **Distinct closeout concepts:** Distinguish practical completion, taking-over/operational handover, contractual completion, administrative closeout, financial closeout/final account, archive transfer, and final records handover. Their definitions, legal effects, prerequisites, and sequence must be defined by the applicable project and contract; no universal equivalence or legal effect is assumed.
2. **Workstream-specific closeout gates:** Establish separately governed checklists and accountable owners for technical/quality completion, inspections and tests, commissioning, NCR/SOR/snags, outstanding WIR items and reinspection actions, as-built records, O&M manuals, warranties, training, permits, correspondence, transmittals, approvals, and required project records.
3. **Unresolved actions and exceptions:** Do not represent a project or workstream as unconditionally complete while material actions, discrepancies, claims, defects, or exceptions remain unresolved. Where an authorized process permits qualified closeout, record each residual item with scope, owner, risk/impact, evidence, approved target date if applicable, approving authority, and continuing tracking route. An exception is not a fabricated completion or approval.
4. **Final records completeness index:** Build a traceable inventory of exact source record IDs and classes, document revisions, report snapshots, approvals and signatures, inspection/test evidence, transmittal manifests, delivery/access receipts, acknowledgements and responses, audit evidence, metadata, and file hashes. Never substitute an implicit latest revision or mutable live view for the exact record required at closeout.
5. **Final records handover package:** Define the authorized recipient (owner, client, operator, or other approved custodian), purpose, classification, scope, exact versions, manifest, file identities/hashes, export format, custody controls, delivery evidence, exceptions, and acceptance route. Verify recipient authority and access at each relevant stage. A handover manifest or link does not itself grant access; no anonymous public links or default broad distribution are approved.
6. **Delivery, receipt, and acceptance remain distinct:** Record package preparation, validation, dispatch, technical delivery, recipient access, acknowledgement of receipt, review/acceptance, and custody transfer as separate events where applicable. A technical delivery receipt or acknowledgement does not by itself prove review, acceptance, contractual taking-over, or approval.
7. **Financial closeout, if the separately governed Finance module is enabled:** Provide a distinct reconciliation workstream for interim/final payment certificates, contractor submissions, contract/BOQ or progress-based valuation, variations and claims, retention, advance recovery, deductions, unpaid amounts, taxes where applicable, and final account balances. Preserve source evidence, calculation basis, period, approvals, disputes, and outstanding liabilities. No automatic certification, approval, payment, tax treatment, or accounting rule is created by this decision.
8. **Project cash and expense custody, if enabled:** Reconcile advances, petty cash, receipts, expense records, balances, custodians, and return/settlement evidence. Distinguish physical custody reconciliation from accounting recognition and approval; closeout does not itself authorize a posting or payment.
9. **Payroll and workforce closeout, if enabled:** Reconcile relevant payroll periods, approved and unpaid amounts, engineer/worker assignments and end dates, and supporting evidence under separately approved policies. Leave, overtime, deductions, statutory entitlements, and legal obligations require jurisdiction- and policy-specific review; none are inferred here.
10. **Assets, materials, tools, and equipment:** Where applicable, inventory items and custody, record return/transfer/disposal, condition and outstanding exceptions, and identify the authorized receiving party. Financial valuation and disposal authority remain separately governed.
11. **Separated approvals and accountability:** Define preparation, technical verification, financial reconciliation, records validation, review, approval, issue, and recipient acceptance as distinct capabilities and actions. Apply DEC-021 deny-by-default and separation-of-duties controls; no self-approval, proxy approval, or assumed authority from project membership. Project Manager supervisory visibility remains read-only as specified by DEC-021.
12. **Project status versus record lifecycle:** Keep project operational/contractual status separate from the lifecycle of individual records. Archiving is not deletion. Project closeout must not erase open warranty, defect-liability, latent-defect, claims, dispute, or other post-closeout obligations; where applicable, track them under an explicitly defined residual-obligations process.
13. **Reopening and post-closeout supplements:** Define authorized grounds, scope, approver, and audit for reopening a closed workstream or project status. New evidence or supplemental records must be appended and linked; the approved closeout snapshot/package is never silently overwritten.
14. **Final closeout snapshot and reports:** Preserve an immutable closeout snapshot containing its as-of time, included records and exact versions, manifest, exceptions, reconciliations, approvals, and integrity evidence. Later supplements create separately identified records or package versions. A generated closeout report or certificate is not a legal taking-over/completion certificate unless the applicable contract and authority explicitly establish that effect.
15. **Retention, security, and integrity:** Apply DEC-054 retention/legal hold, DEC-055 append-only audit, DEC-059 backup/recovery, DEC-064 classification/privacy, DEC-065 data integrity, and DEC-066 controlled handover. Verify exact links, hashes, recipient authorization, and reconciliation results; disclose missing, disputed, unverified, or inaccessible records rather than silently excluding them.
16. **Reporting and visibility:** Provide authorized closeout status, completeness, outstanding-action, residual-obligation, reconciliation, and handover reports. Enforce server-side authorization for records, counts, filters, summaries, exports, previews, and downloads; do not leak drafts, restricted metadata, or cross-party information.
17. **Project-specific governance:** Each project must define applicable closeout phases, gates, authority matrix, contract/jurisdiction requirements, responsible roles, recipient/custodian, required records, residual-work rules, financial controls, reconciliation tolerances, retention basis, and reopening authority. No universal SLA, completion deadline, retention period, financial formula, or contractual acceptance rule is approved here.

**Cross-decision dependencies:** DEC-020/021/054/055/056/057/058/059/060/061/062/063/064/065/066; DEC-050–053 for transmittals, access receipts, responses, revisions and withdrawal; DEC-044/045/046/047/048/049 for reporting, registers, search and notifications. Financial and payroll processes require their own separately governed module design and approvals.

**Open design details:** Project phase and completion definitions; closeout checklists and gates; authority matrix; contract/jurisdiction mappings; residual works and defects tracking; final document index; recipient/custody model; package formats and transfer channels; financial/final-account rules; payroll and workforce controls; asset custody forms; approval and acceptance workflow; reconciliation tolerances; retention and legal hold interactions; reopening policy; report templates and certificate wording.

**Implementation boundary:** design documentation only. DEC-067 does not authorize an actual project closeout, contractual certification or taking-over, financial/payroll posting or payment, data export/migration or external transfer, archive/disposal operation, access or role changes, workflow reassignment, code/database/storage/auth/RLS/API/UI changes, tests, merge, or deployment.


## 14.44 DEC-068 — Project Performance, Cost Control & Management Oversight Governance

**Purpose:** Establish a governed framework for monitoring project delivery, operational performance, cost position, commitments, risks, and management actions while preserving the separation between operational records, financial records, analytical indicators, and formal approval authority.

**Core requirements**

1. **Distinct performance dimensions:** Report technical progress, schedule, quality, safety, resources, procurement, document/workflow performance, commercial/financial position, risk, and closeout readiness as distinct but linkable dimensions. A single composite score must not conceal material failures or replace discipline-specific evidence.
2. **Authoritative source and ownership:** Each metric must identify its authoritative source record/system, accountable data owner, permitted updater, calculation/definition version, refresh frequency, effective date, and known limitations. Dashboards and analytical stores are derived views, not authoritative transaction records.
3. **Project baseline governance:** Distinguish approved baseline, current approved forecast, actual performance, target, and management scenario. Baselines and material re-baselines require authorized approval, effective date, rationale, version history, impact assessment, and audit. No retrospective overwrite or silent baseline reset.
4. **Progress measurement:** Define measurable work packages, activities, milestones, quantities, weights, rules of credit, evidence requirements, and cut-off dates. Distinguish physical progress, earned progress, planned progress, and financial progress. A submitted quantity or contractor-reported percentage is not automatically verified or accepted progress.
5. **Schedule performance:** Track planned/forecast/actual dates, milestone variance, critical dependencies, slippage, recovery plans, and constraints using an approved calendar and data date. Do not infer contractual delay, entitlement, extension of time, or liability from a dashboard variance alone.
6. **Quality and inspection performance:** Derive indicators from authoritative inspection, WIR, NCR, SOR, snag, test, and commissioning records. Preserve the four WIR outcomes under DEC-025 and distinguish Not Ready from Requires Correction. Counts, rates, repeat defects, aging, and closure times must state their population, exclusions, date basis, and item/document grain.
7. **Safety and environmental indicators:** Where these records are within approved SiteDocs scope, define source, classification, reporting thresholds, event severity, verification, and privacy controls separately. Do not invent incident rates, lost-time definitions, regulatory classifications, or targets without approved standards and project rules.
8. **Cost structure and control accounts:** If the Finance module is enabled, define project budget, approved budget changes, commitments, actual costs, accruals, forecasts, variations/claims, retention, advances, deductions, cash position, and final account as distinct measures with explicit inclusion/exclusion rules. No accounting policy, chart of accounts, tax treatment, or contract valuation formula is approved by this decision.
9. **Commitment and procurement visibility:** Distinguish requisitions, purchase orders, subcontracts, awarded commitments, received goods/services, invoices, certified amounts, paid amounts, and remaining commitments. Each state must be sourced from its governed record and must not be treated as interchangeable.
10. **Forecasting and estimate at completion:** Forecasts must disclose assumptions, remaining scope, productivity basis, price/escalation assumptions where authorized, risks, contingency treatment, confidence/uncertainty, owner, and version. Forecasts are management estimates, not approved budgets, payment certificates, or contractual commitments.
11. **Variance and exception management:** Define variance against the correct approved baseline or target, threshold source, calculation, severity, owner, explanation, corrective action, due date if approved, escalation, and closure evidence. Thresholds must be configurable only by authorized roles and versioned; no universal thresholds or SLA are set here.
12. **Risk, issue, and opportunity linkage:** Link material risks, issues, assumptions, constraints, and opportunities to affected work packages, schedule/cost/quality measures, owner, response, status, and review date. Preserve the distinction between a risk, an actual incident, a problem/root cause, and an approved change.
13. **Change and trend governance:** Assess approved scope, design, schedule, cost, resource, and contract changes against the current baseline. Show pending, approved, rejected, and implemented changes distinctly. Do not incorporate unapproved changes into approved baseline or actual cost without an authorized accounting/contract rule.
14. **Resource and productivity reporting:** Where reliable data exists, report planned versus actual staffing, equipment, utilization, output, and productivity with explicit units, periods, work scope, source, and exclusions. Avoid misleading comparisons across unlike trades, locations, shifts, or project phases.
15. **Cash flow and payment visibility:** If Finance is enabled, distinguish forecast cash flow, submitted applications, reviewed/certified amounts, approved amounts, due amounts, paid amounts, and outstanding balances. A dashboard must not initiate payment, certify an application, alter a ledger, or imply that a forecast is a contractual payment obligation.
16. **Role-based management views:** Provide views appropriate to contractor, consultant, owner/client, project controls, finance, quality, HSE, procurement, and project management responsibilities. Apply DEC-021 deny-by-default and current project/party/discipline/capability scope. Project Manager supervisory access remains read-only and does not grant approval, assignment, inspection, review, signature, or financial posting authority.
17. **Cross-project portfolio reporting:** Portfolio comparisons require consistent metric definitions, comparable data periods, approved normalization, and disclosed differences in contract type, scope, phase, currency, calendar, and data completeness. Do not rank projects or personnel using incomparable or unverified data.
18. **Metric dictionary and calculation control:** Maintain a controlled catalogue for each KPI/metric: name, purpose, owner, source, record grain, formula, numerator/denominator, units, filters, exclusions, time basis/timezone, aggregation, refresh/freshness, version, threshold, and interpretation. Changes to formulas or definitions are versioned and must not silently rewrite historical reports.
19. **Data quality and confidence:** Show source freshness, missing/late data, incomplete populations, unresolved mappings, estimates, provisional values, and reconciliation exceptions. Distinguish verified, reported, estimated, forecast, and unavailable values. Do not present false precision or hide missing data as zero.
20. **Drill-down, exports, and audit:** Drill-downs, counts, filters, comparisons, previews, exports, and scheduled outputs require server-side authorization for the underlying records and exact scope. Record report definition/version, data cut-off, filters, actor, generation time, output identity/hash, and delivery outcome. Apply DEC-045/046/047/048/049 and DEC-064 controls, including spreadsheet formula-injection protection.
21. **Management actions:** Dashboards may identify exceptions and support assignment of follow-up actions only through separately authorized workflows. Opening, acknowledging, or viewing an indicator does not resolve the underlying issue or change a source record. Escalation and closure must preserve accountable actor, authority, time, evidence, and history.
22. **Confidentiality and fair use:** Restrict commercially sensitive rates, payroll, personal information, claims, estimates, and party-specific data to authorized recipients. Do not expose one party's confidential data to another through aggregate comparisons, trends, exports, tooltips, notifications, or inferred values. Do not use raw performance metrics as automatic disciplinary or contractual determinations.
23. **Financial and operational separation:** Operations and Finance may share approved project identifiers and controlled references, but retain distinct records, permissions, workflows, calculations, and audit trails. Integration does not make an operational status a financial approval or a financial record an operational acceptance.
24. **Business ownership and review:** Each project must approve its metric catalogue, baselines, calendars, cost structure, thresholds, role views, data owners, review cadence, and exception governance. No universal KPI target, budget, productivity norm, schedule tolerance, or financial rule is established by DEC-068.

**Cross-decision dependencies:** DEC-020/021/044–049/054/055/056/057/058/059/060/061/062/063/064/065/066/067; WIR-specific outcomes and workflow under DEC-024–044; report governance under DEC-045/046; registers and search under DEC-047/048; notifications under DEC-049; financial module design remains separately governed.

**Open design details:** Metric catalogue and formulas; project control account structure; progress measurement rules; approved baseline and re-baseline authority; schedule calendar and data date; cost classification and accounting basis; currency and exchange-rate treatment; commitment and accrual rules; forecast methodology; risk scoring; threshold levels; role-specific dashboards; portfolio normalization; data refresh and reconciliation; export templates; retention and review cadence.

**Implementation boundary:** design documentation only. DEC-068 does not authorize creation or alteration of budgets, baselines, schedules, ledgers, payment certificates, forecasts, accounting entries, payroll, financial approvals/payments, KPI thresholds, production dashboards, data exports, access changes, code/database/storage/auth/RLS/API/UI changes, tests, merge, or deployment.


## 14.45 DEC-069 — Project Risk, Claims, Variations & Change Impact Governance

**Purpose:** Establish controlled and auditable management of project risks, issues, claims, variations, and changes, including their potential or approved effects on scope, time, cost, quality, resources, and contractual obligations. These record classes are related but are not interchangeable and must retain distinct authority, status, evidence, and decision paths.

**Core requirements**

1. **Separate record classes:** Distinguish a risk (uncertain future event or condition), issue (event or condition that has occurred and requires action), claim (a party's asserted contractual or commercial entitlement), variation/change request (a proposed or instructed alteration to scope or requirements), approved change (a change authorized under the applicable governance), and incident/problem under DEC-061. A record's existence or label does not establish cause, liability, entitlement, approval, or financial recognition.
2. **Risk register:** Maintain a controlled risk record with stable ID, description, cause, potential event, consequences, affected objectives/work packages, owner, originator, date identified, status, inherent and residual exposure, response strategy, actions, review date, evidence, and linked records. Preserve history when ownership, assessment, response, or status changes.
3. **Risk assessment method:** Use a project-approved method for likelihood, impact dimensions, scoring, exposure bands, and escalation. Show the method/version and assessment date. No universal probability scale, risk appetite, score threshold, contingency percentage, or escalation SLA is approved here.
4. **Risk responses and monitoring:** Distinguish avoid, reduce/mitigate, transfer/share, accept, and exploit/enhance where applicable. Each response has an accountable owner, actions, approved resources if any, target dates if set, residual exposure, evidence, and review cadence. A response plan does not itself eliminate exposure or transfer contractual liability.
5. **Issue management:** Record actual issues separately from risks, with occurrence/detection time, impact, affected records/work packages, immediate containment, owner, corrective action, dependencies, evidence, and closure verification. Conversion from risk to issue preserves the original risk history and creates a linked issue record rather than overwriting it.
6. **Change initiation and classification:** Every proposed change receives a stable ID, originator, reason, description, source instruction/request, affected scope, urgency, affected parties, and supporting evidence. Classify change types and distinguish proposed, under assessment, rejected, withdrawn, approved, instructed, implemented, verified, and closed states as separately governed events.
7. **Change impact assessment:** Before approval, assess effects on scope, drawings/specifications, quantities/BOQ, quality, safety/environment where applicable, schedule/milestones/critical path, resources, procurement, interfaces, cost, cash flow, risks, permits, deliverables, operations, and closeout. Record assumptions, exclusions, uncertainty, dependencies, alternatives, and affected baseline versions.
8. **Approval before implementation:** A proposal, estimate, meeting minute, email, field instruction, or dashboard entry is not automatically an approved change. Only an authorized person acting under the applicable project/contract authority matrix may approve or issue a change. Emergency or urgent work must follow a separately approved controlled procedure with scope limits, authority, contemporaneous evidence, time-bound review, and formal reconciliation; no blanket retrospective approval is assumed.
9. **Baseline and forecast control:** Approved changes may alter baselines only through the separate authorized baseline-change process under DEC-068. Pending, rejected, withdrawn, or unapproved changes remain visible as such and must not silently enter approved scope, budget, schedule, earned progress, or actual cost. Preserve prior baseline and forecast versions.
10. **Variation register:** Maintain a distinct variation/change register with links to source request/instruction, affected contract/project scope, assessment, approvals, agreed or disputed valuation, schedule effect, implementation evidence, and closeout. Do not treat a variation as a claim or a claim as an approved variation; relationships may be many-to-many and must be explicit.
11. **Claims register:** Record each claim with claimant/respondent, contract/project reference, claim type/category, factual basis, alleged cause, event chronology, notices and correspondence, contractual references supplied by authorized users, requested relief, time and/or cost components, evidence, mitigation, assessment, response, determination, dispute status, and links to related changes/risks/issues. Submission is not acceptance or proof of entitlement.
12. **Notice and time-bar controls:** Where a contract or applicable rule specifies notice requirements or deadlines, capture the source clause/rule, triggering event, date/time basis, responsible party, required recipient, notice method, deadline calculation, submission evidence, and review status. Do not invent a universal notice period, deem a notice valid/invalid automatically without approved rules, or provide a legal conclusion from a reminder.
13. **Claim substantiation and assessment:** Preserve contemporaneous records supporting cause, responsibility asserted, causation, effect, mitigation, time impact, cost build-up, assumptions, rates, quantities, records, and calculation versions. Distinguish submitted amount/time, assessed amount/time, recommended amount/time, agreed amount/time, determined amount/time, certified amount, and paid amount; each requires its own source and authority.
14. **Schedule impact analysis:** Link alleged or approved events to affected activities, logic, calendars, data dates, critical/near-critical path, float, mitigation, concurrency assumptions, and schedule versions. Methodology and contract-specific rules require approval. A calculated delay or forecast movement does not itself grant an extension of time or establish responsibility.
15. **Cost impact analysis:** Link estimates and assessments to controlled quantities, rates, currency, pricing basis, taxes where applicable, overhead/profit treatment if authorized, contingency, escalation, deductions, retention, and supporting evidence. Preserve estimate versus submitted versus assessed versus agreed versus certified versus paid values. No valuation formula, tax treatment, or accounting recognition is approved by DEC-069.
16. **Negotiation and determination history:** Preserve each party's submissions, questions, responses, meetings, offers, counteroffers, partial agreement, disagreement, determination, review, and dispute/escalation events with actor, authority, timestamp, exact version, and evidence. Never overwrite an earlier position or represent silence as agreement.
17. **Partial, linked, and cumulative effects:** Support changes/claims affecting multiple work packages or documents and multiple changes affecting the same baseline element. Explicitly record dependencies, cumulative impacts, overlap, potential double counting, concurrent events, and allocation methodology where approved. Do not automatically sum overlapping claims or impacts.
18. **Implementation and verification:** Following approval/instruction, track implementation owner, authorized scope, effective date, affected documents/revisions, procurement/work execution, verification, cost/schedule updates, residual actions, and closeout evidence. Implementation status does not itself establish final valuation, payment, or claim settlement.
19. **Authority and separation of duties:** Separate initiation, technical assessment, commercial/contract assessment, schedule analysis, cost review, recommendation, approval/instruction, implementation, certification, payment, and dispute determination as required by project governance. Apply DEC-021 deny-by-default, active assignment and capability checks, and separation of duties; no self-approval, proxy action, or authority inferred from job title or project membership. Project Manager supervisory visibility remains read-only unless a separate approved capability explicitly applies.
20. **Party confidentiality and access:** Restrict each party's claim submissions, internal assessments, rates, negotiation positions, privileged material, and commercially sensitive evidence to authorized recipients. Prevent leakage through registers, counts, search suggestions, dashboard aggregates, notifications, exports, and linked records. Shared visibility must be explicitly governed.
21. **Audit and immutable evidence:** Preserve append-only chronology for record creation, amendments, status changes, ownership, notices, submissions, assessments, approvals, instructions, determinations, and implementation. Corrections are new linked events; preserve the exact documents, revisions, report snapshots, schedules, estimates, correspondence, attachments, and hashes relied upon at each decision.
22. **Reporting and performance:** Report exposure, aging, ownership, status, notice deadlines, pending assessments, approved changes, disputed claims, and realized impacts using explicit definitions, as-of date, source, population, and exclusions. Do not equate risk exposure with committed cost, a claim amount with liability, a variation estimate with approved budget, or a forecast with actual cost.
23. **Retention, integration, and closeout:** Apply DEC-054/055/057/058/059/064/065/066/067/068 for retention, audit, integrations, import/export, recovery, privacy, integrity, handover, closeout, and performance reporting. Preserve open claims, disputes, warranties, and residual obligations through project closeout under DEC-067; closeout must not silently extinguish them.
24. **Project-specific governance:** Each project must define its risk methodology, authority matrix, change categories, approval thresholds, notice rules, claim assessment process, schedule/cost methodologies, confidentiality, dispute route, and records requirements based on applicable contract and legal review. No universal risk scale, notice period, valuation rule, approval limit, or dispute outcome is approved here.

**Cross-decision dependencies:** DEC-020/021/054/055/056/057/058/059/060/061/062/063/064/065/066/067/068; DEC-045/046/047/048/049 for reports, registers, search and notifications; DEC-050–053 for transmittals, access receipts, responses and revisions. Financial valuation, accounting, and payment rules remain separately governed.

**Open design details:** Risk taxonomy and scoring; appetite and escalation thresholds; issue workflow; change categories and authority matrix; emergency change route; baseline reapproval; notice calendars and clause mapping; claim categories and assessment roles; time-impact methodology; cost build-up/valuation rules; currency and tax handling; concurrency and cumulative-impact methodology; confidentiality boundaries; dispute stages; reporting templates; retention and closeout treatment.

**Implementation boundary:** design documentation only. DEC-069 does not authorize actual contractual notices, claim acceptance/rejection/determination, variation approval/instruction, scope execution, baseline/budget/schedule/ledger changes, financial certification/payment, legal interpretation, access changes, data export, code/database/storage/auth/RLS/API/UI changes, tests, merge, or deployment.
## 14.46 DEC-070 — Project Procurement, Subcontracts, Materials & Inventory Governance

**Purpose:** Define controlled procurement and materials records across the project lifecycle while preserving distinct commercial, operational, quality, inventory, and financial decisions. Procurement records may reference Operations and Finance records, but must not collapse their workflows or imply that ordering, delivery, inspection, invoice receipt, certification, or payment are equivalent events.

**Core requirements**

1. **Distinct procurement record classes:** Keep requisitions, scope/specifications, requests for quotation or tender, supplier quotations, bid clarifications, technical/commercial evaluations, recommendations, awards, purchase orders, contracts, subcontracts, amendments, delivery notices, goods-received records, material inspections, stock movements, material issues/returns, invoices, payment applications, certificates, and payments as separately identified records. Link related records explicitly; do not treat one record as proof of another.
2. **Authority and segregation:** Define project-specific authority for requisition, budget check, sourcing, evaluation, recommendation, award, purchase-order/contract issue, receipt, inspection, invoice verification, certification, and payment. Apply DEC-021 deny-by-default and separation of duties. No authority is inferred from job title, project membership, or possession of a quotation.
3. **Requisition and scope control:** A request identifies project/package, requester, need-by date if applicable, scope/specification, quantity, unit, delivery location, cost code/work package where configured, supporting evidence, and urgency. Requisition approval is not a supplier award, purchase order, or budget amendment.
4. **Sourcing and evaluation:** Preserve the issued RFQ/tender scope and version, invited suppliers, submission deadlines, received quotations and revisions, clarifications, exclusions, validity, currency, delivery terms, technical evaluation, commercial comparison, recommendation, conflicts/declarations where required, and decision authority. Late, incomplete, withdrawn, or non-comparable offers remain identifiable. No universal minimum bid count or evaluation formula is imposed.
5. **Supplier and subcontractor records:** Maintain controlled supplier/subcontractor identity, qualification evidence, scope/category, status, authorized contacts, insurance/licence/registration evidence where required, performance history, suspension/expiry, and review provenance. Qualification does not itself award work or establish contractual compliance. Sensitive commercial and personal information is access-restricted.
6. **Award, PO, contract and subcontract:** Record the selected supplier, approved scope, price basis, currency, quantities/rates, schedule/delivery obligations, terms and conditions, authorized signatories, effective dates, attachments, and source approval. Issued purchase orders/contracts are versioned and immutable; amendments are new linked controlled records. A draft, recommendation, or award proposal is not an issued commitment.
7. **Commitment and budget linkage:** Where Finance is enabled, link an issued authorized PO/subcontract to the relevant project budget/control account and commitment record under DEC-068. Preserve original and revised commitment values, approved amendments, currency, tax/pricing basis where configured, remaining commitment, and source versions. A requisition, quotation, forecast, or pending award must not silently become an approved commitment or change the approved budget.
8. **Delivery and receipt:** Delivery notice, physical arrival, quantity/condition check, goods-received note (GRN), and inventory posting are distinct events. A GRN records what was received, when, where, by whom, against which PO/line, measured quantity/unit, shortages, overages, damage, batch/serial/lot details where relevant, and evidence. Receipt into custody does not constitute technical acceptance, contractual acceptance, invoice approval, or payment entitlement.
9. **Quality and technical acceptance:** Material inspection, testing, certificates, traceability, quarantine, rejection, concession, and release follow the applicable quality workflow and authorized inspection records. Where relevant, link to MIR or other approved quality records without merging their identities or outcomes into the GRN. Uninspected, quarantined, rejected, or conditionally accepted stock must remain distinguishable and must not be represented as freely available inventory.
10. **Inventory ledger:** Track controlled stock by project, store/location, item/material, unit, batch/lot/serial where applicable, custody/status, and effective movement. Use append-only receipts, transfers, issues, returns, adjustments, quarantine, release, and disposal movements with actor, timestamp, source document, quantity, unit, and reason. Corrections use reversing/adjusting movements; never overwrite historical quantities or silently delete movement history.
11. **Material issue, return and consumption:** Record requests, authorization, issue-to-person/team/work package/location, quantity/unit, date, purpose, and acknowledgement where required. Returns, unused material, waste, damage, and transfers are separately recorded. Issued quantity is not automatically installed quantity, earned progress, accepted work, or financial consumption; reconciliation rules and wastage allowances require project approval.
12. **Tools and equipment custody:** Where included, distinguish owned, rented, hired, and subcontractor-provided assets. Record receipt, condition, unique identifier, custodian, location, assignment, inspection/maintenance, transfer, return, loss/damage, and closeout. Custody assignment does not transfer ownership or establish a financial valuation.
13. **Invoice matching and commercial review:** Where Finance is enabled, link each supplier invoice/payment application to the relevant contract/PO lines, receipt evidence (including partial deliveries), quality/acceptance evidence where contractually required, approved variations, deductions/retention/advance recovery where applicable, and prior invoices. Record mismatches, duplicate checks, disputed quantities/rates, taxes, and review outcomes. A three-way or multi-way match is a control framework, not automatic approval; exceptions require authorized resolution and evidence.
14. **Certification and payment separation:** Distinguish invoice received, checked, disputed, recommended, certified/approved, scheduled, paid, partially paid, withheld, and reversed states. Certification and payment are separate authorized events. A GRN, stock posting, invoice upload, or match result does not itself authorize certification or payment. Preserve payment references and remittance evidence without exposing bank or personal data beyond authorized roles.
15. **Subcontract administration:** Maintain subcontract scope, milestones, deliverables, personnel/equipment obligations, insurances/qualifications, instructions, progress evidence, variations, claims, applications, assessments, certificates, deductions/retention, payment, completion, defects, and closeout as linked but distinct records. Subcontractor progress does not automatically establish entitlement or acceptance.
16. **Returns, credits and supplier disputes:** Preserve return authorizations, dispatch/collection evidence, credit notes, replacements, warranty claims, supplier disputes, negotiated settlements, and their links to original PO/GRN/invoice/stock movements. Do not erase the original transaction; record reversals and adjustments with authority and chronology.
17. **Reconciliation and reporting:** Support PO-to-receipt, receipt-to-inspection, receipt-to-inventory, issue-to-work-package, invoice-to-PO/receipt, commitment-to-budget, and payment-to-certificate reconciliation. Reports disclose scope, cut-off, units, currency, source, version, exclusions, unmatched/held items, and data freshness. Missing or unreconciled values must not be shown as zero or fully settled.
18. **Confidentiality and access:** Apply party/project scope and DEC-064 classification to supplier quotations, bid evaluations, negotiated rates, subcontract terms, payroll/personnel details, invoices, and bank/remittance evidence. Protect against leakage through search, counts, notifications, dashboards, exports, and linked records. Project Manager oversight remains read-only unless a separately approved capability applies.
19. **Audit, integrity and retention:** Preserve immutable versions and append-only events for requisitions, offers, evaluations, awards, orders, receipts, inspections, stock movements, invoices, certifications, payments, returns, disputes, and closeout. Bind decisions to exact document revisions, quantities, units, rates, currency, evidence, and calculation versions. Apply DEC-054/055/057/058/059/064/065/066/067/068/069.
20. **Project-specific configuration:** Each project must define procurement categories, sourcing methods, supplier qualification, evaluation rules, authority limits, item catalogue, units of measure, store structure, batch/serial requirements, inspection gates, inventory valuation/accounting policy, tax treatment, payment terms, retention/advance rules, subcontract templates, and reconciliation tolerances through authorized configuration and qualified review. No universal bid threshold, accounting method, tax rule, payment term, valuation formula, or SLA is approved here.

**Cross-decision dependencies:** DEC-020/021/054/055/056/057/058/059/060/061/062/063/064/065/066/067/068/069; DEC-024–044 for WIR; DEC-023 and applicable quality document workflows including MIR; DEC-047/048/049 for registers, search and notifications; DEC-050–053 for controlled distribution, receipt, response and revision. Financial commitment, invoice, certification, accounting and payment rules remain subject to separate Finance design and approval.

**Open design details:** procurement authority matrix; sourcing and evaluation templates; supplier qualification catalogue; item catalogue and units; PO/contract numbering and amendment rules; GRN and MIR linkage; inspection/quarantine/release gates; inventory costing and accounting; batch/serial traceability; material wastage and reconciliation; invoice matching tolerances; tax/currency/payment rules; subcontract progress/certification; reporting; retention and project-specific controls.

**Implementation boundary:** design documentation only. DEC-070 does not authorize supplier onboarding, RFQ issue, award, PO/contract/subcontract execution, goods receipt, inspection acceptance, inventory posting/adjustment, invoice certification, accounting entry, payment, access change, data import/export, code/database/storage/auth/RLS/API/UI changes, migrations, tests, merge, or deployment.


## 14.47 DEC-071 — Project Operating Modes, Paper Submission & Controlled Printing

**Purpose:** Support electronic, paper-based, and hybrid projects. SiteDocs must never assume that every project or recipient accepts electronic submissions.

**Requirements**
1. Configure each project as **Electronic**, **Paper-based**, or **Hybrid**; allow channel rules by document/request type and recipient where needed. Changes are authorized, versioned, effective-dated, and audited.
2. Electronic mode retains the normal electronic submission, receipt, review, response, approval, signature, and distribution events. Printing does not change electronic status or create a second official submission.
3. Paper-based mode prepares the controlled record inside SiteDocs, generates its official print representation, and supports physical submission outside the electronic workflow. Paper submission and external outcomes may be recorded by authorized users. Printing is not electronic dispatch, receipt, approval, or signature.
4. Hybrid mode identifies the controlling channel per transaction and links paper/electronic evidence without silent duplicate official submissions.
5. Provide preview and print-ready output for applicable requests, forms, reports, transmittals, and correspondence. Preserve project, document ID, exact revision, parties, date, pagination, attachment index, and controlled-copy markings. Templates are versioned.
6. Allow authorized printer selection or the supported device print flow. Printer unavailability must not corrupt or lose the source record.
7. Print timing is configurable per project/document type; no universal before/after-submit rule is imposed. A draft must not be misrepresented as an official issue.
8. Maintain a print register: event ID, actor, timestamp, project, document/revision, output/template version, printer/destination where available, copy/page count where available, purpose, and distinct states for output generated, sent to printer, and physically printed (if confirmable).
9. Reprints preserve the original document identity/revision and create new audited events. Controlled/uncontrolled copy markings and reprint reasons are configurable.
10. Paper delivery/submission, recipient, date, location/method, receipt/stamp/signature evidence, reference number, external review, return, and scan-back are distinct events. Print completion never proves delivery or receipt.
11. Scanned external signatures/stamps are evidence linked to the exact revision; scanning does not create an in-system electronic signature or imply the external reviewer acted in SiteDocs.
12. Preserve all printed/submitted revisions and paper trails. Corrections, withdrawals, and superseding issues are linked events, never overwrites.
13. Apply role permissions, confidentiality, watermark/classification, audit, archive, and retention controls. PM oversight remains read-only unless separately authorized.
14. Project/contract review defines accepted channels, print templates, controlled-copy rules, timing, paper receipt evidence, scan-back, authorized submitters, and retention. No universal legal equivalence between paper and electronic actions is assumed.

**Dependencies:** DEC-020/021/047–067 and document-specific workflows; Finance printouts use this print service but retain Finance authority and records.

**Open details:** channel settings, printer/device capability, templates, timing, copy marking, receipt evidence, scan-back, bulk print restrictions, offline limitations, retention.

**Implementation boundary:** design only; no printer installation, external submission, electronic dispatch, approval, signature, status change, bulk export, access/code/database/storage/auth/RLS/API/UI change, test, merge, or deployment is authorized.



## 14.48 DEC-072 — SiteDocs Finance Functional Scope & Project Financial Records

**Purpose:** Define a distinct SiteDocs Finance module to consolidate project financial workbooks and documents, with controlled links to Operations/Core while keeping Finance records, calculations, permissions, approvals, and audit separate from WIR and quality workflows.

**Requirements**
1. Support contractor/subcontractor interim and final payment applications: application/period, contract/PO/subcontract, contractor request letter, BOQ or schedule-of-values (SOV), percentage/milestone/lump-sum bases where contractually configured, previous/current/cumulative quantities and values, measurements, attachments, deductions, retention, advance recovery, taxes/currency where configured, net claim, comments, and version history.
2. Preserve source quantities, units, rates, formulas, rounding, template, and calculation versions. No universal valuation method or formula is assumed.
3. Separate draft, submitted, received, review, return, resubmission, assessment, recommendation, certification, rejection/dispute, supersession, and closure. Submission is not approval; recommendation is not certification; certification is not payment.
4. Keep assessed, recommended, certified, scheduled, actually paid, partially paid, withheld, and outstanding amounts distinct. Record certificate identity, authority, application version, deductions, retention, advance recovery, payment reference, remittance evidence, and reconciliation. No automatic certification or payment.
5. Link applications to issued contracts/POs/subcontracts and approved variations. Pending changes do not silently alter approved contract value or payable amounts.
6. Support project work orders with scope, location/work package, responsible party, quantities/cost basis, authorization, issue/receipt, progress/completion evidence, changes, cost impact, and closeout. Distinguish internal work orders from purchase orders, subcontract instructions, and contractual variations.
7. Support project custody/petty-cash advances by custodian, authorized amount, purpose, currency, project/cost code, issue and custody status. Record itemized expenses with payee, date, category, amount, receipts/invoices, tax evidence where applicable, review, accepted/rejected amounts, returned balance, replenishment, outstanding custody, and settlement. An advance is not automatically an expense.
8. Distinguish requested, committed, incurred, submitted, reviewed, accepted/rejected, reimbursable, settled, and paid expenses. Flag missing receipts, duplicates, policy exceptions, and unreconciled balances without silently zeroing them.
9. Support engineer/staff/labour payroll as configured: worker/role/trade, project assignment, approved pay basis/rates, attendance/timesheets, normal hours, overtime, allowances, deductions, advances, adjustments, gross/net pay, period, review, approval, and payment status. Attendance alone does not authorize payroll payment.
10. Payroll calculations, statutory deductions, tax/social insurance, currencies, overtime, and local labour rules require qualified jurisdiction-specific configuration; no universal payroll formula is approved.
11. Restrict payroll/personnel, bank, supplier rates, claims, commercial and custody data by role, party, project, and sensitivity. PM oversight remains read-only unless separately authorized.
12. Provide controlled Excel/document import and mapping: sheet/column selection, validation, duplicate detection, units/currency/dates, formula-versus-value distinction, source filename/version, import batch, exceptions, and reconciliation. Imported data remains provisional until authorized review; never silently overwrite source data or treat extracted text as verified formulas.
13. Provide registers/reports for applications, certificates, payments, contract/variation values, work orders, commitments, custody, expenses, payroll, balances, cash flow, and reconciliation. State period/cut-off, currency, source, calculation version, population, exclusions, freshness, and exceptions.
14. Preserve immutable submitted versions, calculation snapshots, approvals, certificates, custody movements, expense evidence, payroll changes, payment events, imports, and reconciliations. Separate preparation, review, recommendation, certification, and payment.
15. Configure payment cycles, BOQ/SOV, valuation, retention, advances, deductions, taxes, currency, payroll, overtime, expense/custody policies, accounting treatment, and authority matrix per project/jurisdiction. No universal accounting, tax, employment, payroll, or payment rule is approved.

**Dependencies:** DEC-020/021/054–070, especially DEC-068/069/070; DEC-071 for paper/electronic printing. WIR/MIR/RFI and quality reports remain distinct Operations/quality records.

**Open details:** finance accounts, numbering/templates, BOQ import, measurement evidence, certification/payment authority, retention/advance, work-order taxonomy, custody/expense policy, payroll rules, attendance, currency/tax/accounting, Excel migration, reports, permissions, audit.

**Implementation boundary:** design only; no transactions, certification, bank transfers, payroll/expense/custody payment, accounting entry, tax/payroll determination, production import, access/code/database/storage/auth/RLS/API/UI change, migration, test, merge, or deployment is authorized.

## 14.49 DEC-073 — Finance Document Taxonomy, Registers & Lifecycle Governance

**Purpose:** Establish authoritative financial document classes, identifiers, registers, lifecycle states, evidence packages, and cross-references before individual Finance workflows are implemented.

**Requirements**
1. Maintain a Finance Document Register separate from Operations, WIR, and correspondence registers. Each record carries stable internal ID, project, type, official number when issued, title, originating party, owner, status, dates/period, currency, classification, contract/package/cost-code links, source references, current revision, and audit history.
2. Distinguish at minimum: budgets and revisions; control accounts/cost codes; commitments; requisitions; work orders; POs/contracts/subcontracts; variations/claims; payment applications/interim/final accounts; contractor cover letters; BOQ/SOV and measurement sheets; progress valuations; invoices; delivery/GRN evidence; payment certificates; deduction/retention/advance schedules; payment instructions/remittances; receipts/vouchers; custody issues/settlements; expense claims; payroll registers/payslips; attendance/timesheets; overtime/allowance/deduction adjustments; reconciliations; financial reports; final accounts. Configured project-specific types require governance.
3. Preserve submission package manifest: cover letter, form, BOQ/SOV sheets, measurement/progress evidence, invoices, delivery/inspection references, approved changes, deductions/retention/advances, and other required attachments. Attachments retain identity, revision, origin and parent relation; attachment is not independent approval.
4. Assign internal IDs at draft creation, never reused. Issue official numbers only at configured formal issue/submission events. Keep numbering series distinct by project/type where configured; do not conflate revision, application period, certificate, work-order, voucher, payroll-period, or payment-reference numbers.
5. Preserve immutable submitted snapshots. Material correction creates linked revision/resubmission; unchanged resubmission is a separate event under configured rules. Certified/paid records are not silently edited; use controlled adjustment, reversal, supplemental certificate, or linked replacement.
6. Define type-specific states as applicable: draft, submitted, received, under review, returned, resubmitted, assessed, recommended, approved/certified, rejected, disputed, partially certified, superseded, withdrawn/cancelled, scheduled, partially paid, paid, closed, archived. Every transition is authorized, timestamped, and audited.
7. Separate preparation, submission, receipt, verification, measurement, assessment, recommendation, approval, certification, accounting recognition, payment instruction, bank execution, remittance, reconciliation, and closeout. A status cannot imply an event that did not occur.
8. Preserve evidence provenance: issuer/author, source, received date, file identity/version/hash where supported, parent package, related line/item and review status. Original files and extracted/normalized data are separate. OCR, spreadsheet extraction, and imports do not validate source data or calculations.
9. Link Finance to exact Operations/procurement/GRN/inspection/WIR/MIR/approved variation/work-progress/closeout IDs and revisions without merging ownership, visibility, or approval. WIR acceptance is not a payment certificate; GRN is not invoice approval; progress percentage is not automatically payable.
10. Preserve stable line IDs, descriptions, units, quantities, rates, currency, valuation basis, source version, and previous/current/cumulative values for BOQ/SOV, cost, payroll, expense, and commitment lines. Corrections remain traceable.
11. Provide separate registers for applications, certificates, payments, contracts/POs/commitments, variations/claims, work orders, custody, expenses, payroll, budgets/control accounts, and reconciliations. A unified Finance view is only an authorized index, not a merged ledger.
12. Enforce confidentiality for commercial, supplier, payroll, personal, banking, and custody records across metadata, amounts, attachments, search, notifications, dashboards, exports, and print. Even record existence may be restricted.
13. Apply immutable audit, revision retention, legal/contract holds, controlled archive and disposal review. Archive is not deletion.
14. Finance printouts follow DEC-071. Every print ties to exact Finance document ID/revision; paper receipt, stamp, external review, scan-back and electronic actions remain separate events.
15. Financial closeout reconciles applications, certificates, payments, balances, commitments, variations/claims, retention, advances, custody, expenses, payroll liabilities, supplier/subcontractor balances and final account. It remains distinct from technical/administrative closeout under DEC-067; unresolved disputes/liabilities remain visible.

**Dependencies:** DEC-020/021/047–069/071/072; especially DEC-050–055, DEC-067–070 and DEC-071/072. WIR and quality reporting remain separate.

**Open details:** type catalogue, numbering series, per-type state maps, package manifest, attachment controls, calculation snapshots, line model, Finance search permissions, retention, paper receipt metadata, reconciliation/closeout checklists.

**Implementation boundary:** design only. No financial document issuance, certification, ledger posting, payment, payroll run, import, disposal, permission change, code/database/storage/auth/RLS/API/UI change, migration, test, merge, or deployment is authorized.


## 14.50 DEC-074 — Finance Roles, Authority Matrix & Segregation of Duties

**Purpose:** Ensure financial records and actions are accessible only to authorized people; no authority is inferred from project membership or job title.

**Requirements**
1. Apply DEC-021 deny-by-default at project, party, document type, record, line, attachment, and action level. Distinguish view metadata, view amounts, view attachments, create, edit draft, submit, receive, verify, measure, assess, recommend, approve, certify, instruct payment, execute payment, reconcile, export, configure, and audit.
2. Support configurable Finance profiles such as Finance Administrator, Project Accountant/Cost Controller, Commercial/Quantity Surveyor, Preparer, Reviewer/Verifier, Recommender, Certifying Authority, Payment/Treasury Officer, Custody Holder, Expense Submitter, Payroll Preparer/Reviewer/Approver, Auditor, and Project Manager Read-only. These are capability profiles, not fixed job titles or headcounts.
3. Scope users by project, party, effective dates, and explicit capabilities. Contractors cannot see consultant/owner internal assessments or another party's financial data unless expressly authorized; suppliers/subcontractors see only permitted records and responses.
4. Separate preparation, verification, recommendation, approval/certification, payment execution, and reconciliation as configured. Prohibit self-approval where segregation applies; high-risk transactions may require dual authorization.
5. Configure authority by project, party, currency, transaction type, cost code, value band, and effective date. Thresholds, signatories, delegation limits and dual-control rules are project/contract settings; no universal monetary limit is set.
6. Delegation must be explicit, limited by action/project/party/value/time, approved and audited. No credential sharing, impersonation, proxy signature, or silent substitution; prior actions retain original attribution.
7. Certifying authority and payment execution are separate capabilities and events. Certification does not itself prove bank execution or remittance.
8. Custodians may acknowledge custody and submit expenses but cannot approve their own expenses or independently reconcile their own custody without separate authorized control. Issue, replenishment, expense acceptance, cash return and settlement are distinct.
9. Separate attendance/time approval, payroll preparation, review, approval, and payment. Users cannot approve their own pay/rate/attendance adjustments. Payslips and bank details are restricted to the employee and authorized payroll roles subject to applicable rules.
10. Project Manager oversight remains read-only by default; summaries/status may be visible where authorized, but PM access does not confer editing, certification, payment, payroll disclosure, or party-confidential details.
11. Temporary/emergency access requires purpose, scope, approver, start/end and audit; emergency access is time-bound and reviewed after use. It cannot bypass immutable records or self-approval.
12. Revoke/suspend access on assignment end and perform periodic/event-triggered recertification. Preserve historical authorship and records.
13. Apply permissions consistently to search, reports, totals, notifications, exports, print queues, generated PDFs and attachments; no confidential amount leakage through previews or aggregates.
14. Audit grants/denials, role changes, delegation, sensitive access, downloads/exports/prints, approvals, certification, payment instructions, payroll access and privileged actions. Audit is append-only.
15. Changes to roles, limits, routes, signatories, segregation or sensitive-data access require versioned authorized change control under DEC-056/062/063. No user approves their own privilege elevation.

**Dependencies:** DEC-020/021/054–070/071/072/073; supplements but does not weaken PM read-only and no-self-approval rules.

**Open details:** role-capability matrix, authority templates/value bands, dual-control cases, payroll confidentiality, custody separation, emergency access, access-review cadence, export/print permissions, audit owner.

**Implementation boundary:** design only. No live permission, financial authority, signatory, delegation, RLS/storage/API/UI configuration, code, migration, test, merge, or deployment is authorized or changed.

## 14.51 DEC-075 — Finance Budget, Cost Breakdown & Commitment Control

**Purpose:** Define how SiteDocs Finance establishes and monitors approved financial baselines, cost structures, commitments, forecasts, and actuals without conflating contractual value, budget, earned progress, invoices, certificates, or cash payments.

**Requirements**
1. Maintain distinct project financial baselines: approved budget, cost plan, contract sum, approved variations, control budget, commitments, actual cost, accruals, forecast final cost, cash-flow forecast, and approved funding where configured. These are separate measures with explicit source, owner, currency, effective date, and approval status.
2. Support configurable cost breakdown structures (CBS), cost codes, control accounts, work packages, BOQ/SOV mappings, and links to WBS/project areas. Preserve stable codes and versioned mapping tables; a code change must not rewrite historical allocations.
3. Establish an approved budget baseline and controlled revisions. Each revision records reason, author, reviewer, approving authority, effective date, prior baseline, changed lines, source evidence, and impact. Draft/proposed budgets do not replace approved baselines.
4. Separate original contract value, approved variations, pending variations, provisional sums/allowances, taxes where configured, and current authorized contract value. Only approved changes affect the authorized contract baseline; pending claims/variations remain visible but excluded from approved totals unless explicitly configured otherwise.
5. Track commitments at source-document and line level: contracts, subcontracts, POs, authorized work orders, approved amendments, and other configured commitments. Distinguish original, approved amendments, released/cancelled balance, committed-to-date, invoiced, certified, paid, and remaining commitment.
6. Avoid double counting across a subcontract, PO, work order, and downstream invoice/certificate. Define parent-child/relationship and commitment-consumption rules for each procurement model. A work order is not automatically an additional commitment if it is already included in a parent contract/PO.
7. Distinguish actual cost, accrued cost, invoice received, invoice verified, application assessed, certificate issued, payment scheduled, and cash paid. Each measure must identify its accounting/operational basis and cannot be inferred from another status.
8. Support forecast-to-complete and estimate-at-completion by cost code/package, with explicit quantity/rate/assumption basis, risk/contingency treatment, source date, preparer, review and version. Forecast is not an approved budget, commitment, certificate, or payable liability.
9. Provide variance analysis against approved baseline, prior forecast, and current period. Explain scope/quantity/rate/productivity/time/price/FX/tax/approved change drivers where data exists; do not assert causal attribution from arithmetic alone.
10. Support period cut-off and accrual journals/exports only where the accounting model is approved. Preserve posting period, source transaction, preparer/reviewer, adjustment/reversal relationship and external accounting reference. No general ledger posting behavior is assumed by this design.
11. Cash-flow forecasts distinguish expected applications, assessed/certified amounts, scheduled payments, actual receipts/disbursements, retention, advances, deductions, and timing assumptions. Forecast timing is not a payment promise.
12. Provide budget, commitment, actual/accrual, forecast, variation, cost-to-complete, cash-flow, and reconciliation reports with filters and drill-down to source records. Totals must disclose data freshness, included statuses, currency and aggregation rules.
13. Support multiple currencies only with configured source currency, reporting currency, rate source/date, conversion method, and FX variance treatment. Never silently sum unlike currencies.
14. Imports from Excel preserve source workbook/sheet/row/column, original values/formulas where obtainable, mapping version, batch, validation issues and reconciliation. Imported budgets/commitments remain provisional until authorized validation and approval.
15. Restrict sensitive rates, commercial evaluations, contingency, margins, and party-specific commitments by capability. Apply DEC-074 and retain immutable history of baseline, mapping, forecast, and commitment changes.

**Dependencies:** DEC-068 performance/cost oversight; DEC-069 variations/claims; DEC-070 procurement; DEC-072 Finance scope; DEC-073 register/lifecycle; DEC-074 authority; DEC-065 data integrity.

**Open details:** project CBS template, budget authority, contingency treatment, accrual policy, FX sources, period close, commitment consumption, forecast methodology, report definitions, accounting integration.

**Implementation boundary:** design only. No live budget approval, commitment creation, ledger posting, accounting integration, import, payment, code/database/storage/auth/RLS/API/UI change, migration, test, merge, or deployment is authorized.

## 14.52 DEC-076 — Payment Application Measurement, Assessment & Certification Controls

**Purpose:** Define an auditable workflow for contractor/subcontractor payment applications from submission through measurement, assessment, recommendation, certification, and return/dispute, while preserving contractual evidence and preventing application totals from being mistaken for certified or paid amounts.

**Requirements**
1. A payment application is a controlled, versioned submission with project, contract/subcontract, applicant/payee, application type, period/cut-off, currency, official reference, submission date, cover letter, claimed gross/net amount, and complete attachment manifest.
2. Support interim, final, advance, milestone, lump-sum, remeasurement, daywork, and additional-quantity applications only where the governing contract/payment model enables them. Do not impose one universal valuation model.
3. Preserve BOQ/SOV line identity and contract reference. For each line capture original contract quantity/value, approved variation quantity/value, previous certified quantity/value, current claimed quantity/value, cumulative claimed quantity/value, cumulative certified quantity/value, balance, unit/rate, measurement basis, location/WBS/cost code, and supporting evidence as applicable.
4. Keep claimed, measured, assessed, recommended, certified, disputed, withheld, and paid quantities/values distinct. Record differences with reason, reviewer, evidence, and response; do not overwrite contractor claims with assessed figures.
5. For percentage/milestone/lump-sum valuations, preserve the agreed basis, milestone definition, evidence, prior achievement, current achievement, cumulative achievement, and reviewer decision. A physical progress percentage does not automatically establish contractual entitlement.
6. Link additional work and changed quantities to exact approved variation/instruction/contract clauses and source revisions. Pending/unapproved changes remain separately identified and cannot silently increase certified value or approved contract baseline.
7. Calculate gross valuation and adjustments through versioned, transparent rules: previous certificates, retention, advance recovery, materials on/off site where permitted, deductions, contra charges, taxes, discounts, penalties/liquidated damages only where authorized, and other contract-specific adjustments. Every rule has a source clause/policy, effective date, calculation version and audit record.
8. Show gross claimed, gross assessed, gross recommended, gross certified, deductions by type, retention held/released, advance recovered/outstanding, tax, net certified, prior certified, current certified, and cumulative certified as separate values. No hidden netting or unexplained residual.
9. Support retention/advance/deduction schedules with opening balance, current movement, release/recovery, closing balance, source, rate/basis, cap/floor and contract reference. Configurations are contract-specific; no universal rates or formulas.
10. Maintain independent review steps for quantity/measurement verification, commercial assessment, technical evidence where required, recommendation, and authorized certification. The same person cannot self-approve where DEC-074 segregation applies.
11. Record review outcomes including accepted, partially accepted, returned for correction, rejected, disputed, and certified as distinct decisions with comments, line-level reasons, responsible reviewer, timestamp, and supporting evidence.
12. Returned/resubmitted applications retain prior snapshots, comments, and differences. A resubmission is linked to its predecessor; previously certified amounts are not silently revised by a later application.
13. Payment certificate is a distinct issued record derived from authorized assessment/certification, with certificate number, date, revision/snapshot, certified lines, deductions, net amount, approvers/signatures, and linked application. Certificate issue is not payment execution.
14. Support partial certification, disputed portions, withholding, and agreed undisputed portions without forcing the entire application into one outcome. Preserve disputed amounts and reason, without assuming legal determination.
15. Reconcile application and certificate lines to contract/BOQ, approved variations, progress evidence, WIR/MIR or other inspection references, procurement/GRN where applicable, prior certificates, retention/advance schedules, and Finance registers by exact IDs/revisions.
16. Provide application comparison views: contractor claim versus assessed/certified values; previous versus current/cumulative; original versus revised; and supporting evidence gaps. Display currency, units, rounding precision, and calculation version.
17. Exports/printouts under DEC-071 show exact document revision, package manifest, calculation snapshot, page numbers, confidentiality and controlled-copy markings. Paper receipt or external stamp is evidence, not in-system certification.
18. Preserve full audit trail for calculation inputs, formulas, manual adjustments, reviewer comments, authority, approval, certificate issuance, reissue, reversal and supersession. No silent edits to issued certificates.

**Dependencies:** DEC-067 closeout/final account; DEC-068 cost control; DEC-069 variations/claims; DEC-070 procurement/GRN; DEC-071 paper/print; DEC-072 Finance scope; DEC-073 document lifecycle; DEC-074 segregation; DEC-065 integrity.

**Open details:** contract valuation models, measurement evidence, allowable adjustments, rounding, tax treatment, retention/advance clauses, approval matrix, partial/disputed certification, certificate templates, application periods and cut-off rules.

**Implementation boundary:** design only. No application submission, assessment, certification, payment, contract interpretation, accounting/tax determination, code/database/storage/auth/RLS/API/UI change, migration, test, merge, or deployment is authorized.

## 14.53 DEC-077 — Finance Payment Execution, Receipts & Reconciliation Governance

**Purpose:** Separate certified liabilities from actual cash movement and establish controlled records for payment execution, receipts, bank evidence, allocation, reconciliation, and outstanding balances.

**Requirements**
1. Treat payment certificate/approved payable, payment authorization, payment instruction, bank execution, remittance advice, beneficiary receipt, and reconciliation as distinct records/events. A certificate or payment schedule is not proof that funds were transferred.
2. Create payment instruction only from an authorized source obligation and within delegated authority. Capture payee identity, verified beneficiary details/reference, bank/account data under restricted access, currency, amount, deductions, due date, payment method, source certificate/invoice/expense/payroll record, and approval evidence.
3. Apply dual control and segregation as configured: preparation, independent verification of payee/bank changes, approval, release/execution, and reconciliation. A preparer cannot approve or reconcile their own payment where policy requires separation.
4. Verify beneficiary and bank-detail changes through a separately authorized process with independent confirmation and immutable history. Do not accept changed bank details solely from an invoice attachment or unverified email.
5. Support full, partial, multiple, split, grouped, withheld, rejected, cancelled, reversed, and returned payments. Link each movement to the exact obligation and preserve allocation across multiple certificates/invoices/payees.
6. Capture bank/payment reference, execution date, value date, amount/currency, fees, FX, remittance advice, bank statement evidence, payment status and source system. Distinguish instruction created, approved, released, bank accepted, settled, rejected, returned and beneficiary-confirmed where evidence supports each.
7. Support receipts/incoming funds separately from outgoing payments: client/owner receipts, advances, refunds, reimbursements, deposits and other configured inflows. Capture payer, amount/currency, date, bank reference, purpose, project, allocation, supporting evidence and unapplied balance.
8. Maintain allocation rules linking receipts/payments to certificates, invoices, advances, retention releases, expenses, payroll, custody replenishments, refunds and other authorized obligations. Unallocated and partially allocated amounts remain explicit; no automatic allocation based only on similar amounts.
9. Reconcile payment register, receipts register, bank statements, certificates, invoices, cashbook/accounting export and project ledgers by period, currency, account and reference. Show matched, partially matched, unmatched, duplicate, timing difference, bank fee/FX variance and unresolved exceptions.
10. Bank statement import supports source file provenance, account identity, statement period, opening/closing balances, transaction IDs, duplicate detection, column mapping, currency/date normalization and validation. Imported transactions are not posted or treated as reconciled until authorized review.
11. Preserve reconciliation snapshots, rules, match decisions, manual adjustments, reviewers, approval, exception resolution and re-open history. Reconciliation does not itself approve a disputed liability or alter the underlying certificate.
12. Keep cashbook/ledger export separate from source records. If accounting integration is enabled, use controlled mapping, idempotency/reference keys, acknowledgements, rejection handling, period locks and reconciliation; no silent duplicate posting or destructive overwrite.
13. Distinguish bank balance, book balance, available cash, committed cash, forecast inflow/outflow, restricted funds, retention, advances, custody balances and outstanding liabilities. Do not label a forecast as cash or a certificate as a paid amount.
14. Support payment cancellation, reversal, returned funds and corrections through linked compensating records; preserve original instruction, bank evidence, reason, authority and resulting balance. Never erase a completed payment history.
15. Restrict bank account details, beneficiary data, payroll payments, supplier payments and cash positions to authorized roles under DEC-074. Mask sensitive values in ordinary lists, exports, notifications and print where appropriate.
16. Reports include payment due/overdue, certified unpaid, partially paid, paid, returned/rejected, receipt allocation, bank reconciliation, outstanding commitments/liabilities, retention/advance balances and cash flow. Each report states cut-off, source freshness, currency and inclusion rules.
17. Support paper payment vouchers/remittance records under DEC-071; printing or stamping is not bank execution or proof of beneficiary receipt.
18. Financial closeout under DEC-067 must reconcile outstanding payments/receipts, unapplied cash, bank accounts, advances, retention, custody, liabilities and unresolved exceptions before the relevant closeout state is recorded.

**Dependencies:** DEC-067/068/069/070/071/072/073/074/075/076; DEC-055 audit; DEC-059 backup/DR; DEC-065 integrity.

**Open details:** supported bank statement formats, account verification method, payment methods, bank integration, matching tolerance, FX/fees, accounting export, approval thresholds, period close, evidence requirements and local regulatory review.

**Implementation boundary:** design only. No payment instruction, bank transfer, receipt posting, bank/account integration, ledger posting, reconciliation sign-off, accounting/tax/legal determination, code/database/storage/auth/RLS/API/UI change, migration, test, merge, or deployment is authorized.

## 14.54 DEC-078 — Custody, Petty Cash, Expense Claims & Reimbursement Controls

**Purpose:** Establish auditable handling of advances, custody, petty cash, project expenses, reimbursement, settlement, and replenishment without treating cash issued as an expense or a submitted receipt as approval.

**Requirements**
1. Maintain distinct records for cash/bank advance authorization, custody issue, custodian acknowledgement, expense claim, receipt/invoice evidence, review, approval, reimbursement, cash return, replenishment, settlement, and reconciliation.
2. Each custody issue identifies project, custodian, authorized issuer, purpose, amount/currency, issue date, expected settlement date if configured, funding source, cost code, approval reference, and opening balance. Custodian acknowledgement records actual receipt and any discrepancy.
3. Cash issued to a custodian is an outstanding advance/custody balance, not automatically a recognized expense. Expense recognition occurs only through the configured review/accounting process.
4. Support petty cash imprest and float models only where configured: authorized float limit, opening balance, replenishment threshold, custodian, approved uses, currency, and reconciliation rules. No universal float limit or replenishment threshold is assumed.
5. Expense claims capture claimant, vendor/payee, transaction date, project, cost code, category, description, amount, currency, tax where applicable, payment method, business purpose, receipt/invoice, and related contract/work order/activity. Personal and project expenses remain distinguishable.
6. Expense categories and eligible/ineligible rules are configurable by project and policy. Mileage, travel, accommodation, meals, tools, materials, transport, site petty cash and other categories require supporting policy and jurisdiction-specific review.
7. Preserve original receipts/invoices and provenance. Record missing, unreadable, duplicate, altered, incomplete, or out-of-period evidence as exceptions. OCR/extraction is not proof of authenticity or eligibility.
8. Route expenses through submit, completeness check, line review, budget/cost-code validation, independent approval, accounting treatment, reimbursement/payment, and reconciliation as separate events. The claimant/custodian cannot approve their own expense where segregation applies.
9. Distinguish claimed, verified, approved, rejected, disputed, reimbursable, paid, and posted values. A manager's acknowledgement or receipt upload is not financial approval.
10. Support direct vendor payment, employee reimbursement, cash disbursement, card transactions and advance settlement as separate payment methods, with links to DEC-077 payment/receipt records. Prevent duplicate reimbursement across methods or claims.
11. Settlement reconciles opening advance + additional authorized advances + replenishments against approved expenses + returned cash + documented outstanding balance. Show each component and variance; no unexplained write-off or automatic zeroing.
12. Replenishment is based on approved eligible expenses and verified remaining cash, subject to configured controls. Replenishment does not approve the underlying expenses retroactively.
13. Handle foreign currency with source currency, transaction date, configured exchange-rate source, rate, reporting currency, and FX difference. Do not silently convert or sum unlike currencies.
14. Allow return of unused funds, recovery, adjustment, disputed expense, lost receipt exception, and write-off only through separately authorized, reasoned and audited actions. Write-off is not a default resolution.
15. Provide custody register, custodian statement, expense register, pending approval, missing evidence, unsettled advance, replenishment, reimbursement, aging, and project/category/cost-code reports.
16. Apply confidentiality and DEC-074 segregation. Custodian visibility does not imply approval rights; PM remains read-only by default. Preserve immutable changes, attachments, audit, retention and closeout reconciliation.
17. Paper vouchers and printed expense packs follow DEC-071; printing or a physical signature is not by itself system approval or payment.

**Dependencies:** DEC-055/065/067/072/073/074/077; DEC-071 for paper records.

**Open details:** float policy, expense categories/eligibility, evidence rules, limits, approval matrix, FX source, settlement periods, lost-receipt exceptions, accounting treatment and local tax rules.

**Implementation boundary:** design only. No cash issue, reimbursement, expense approval, write-off, payment, accounting posting, code/database/storage/auth/RLS/API/UI change, migration, test, merge, or deployment is authorized.

## 14.55 DEC-079 — Payroll, Timesheets, Attendance & Workforce Cost Controls

**Purpose:** Define controlled payroll and workforce-cost records while separating attendance evidence, timesheet approval, payroll calculation, payroll approval, payslip disclosure, and payment.

**Requirements**
1. Maintain separate records for worker/personnel identity, employment/engagement terms, pay profile, attendance, timesheet, overtime, leave/absence where enabled, allowance, deduction, advance, payroll adjustment, payroll run, payslip, payment instruction, and reconciliation.
2. Support employees, engineers, supervisors, site staff, direct labour, temporary labour and configured subcontract labour categories without assuming all workforce categories are on the same payroll or employment model.
3. Payroll profile includes authorized worker identifier, role/category, project/cost allocation, pay basis (monthly/daily/hourly/piece-rate where applicable), approved rate, effective dates, currency, allowances, deductions, and source/approval reference. Rate changes are versioned and effective-dated; historical periods retain the rate actually applied.
4. Attendance records capture worker, date, project/site, shift/time entries, attendance status, source, recorder, correction history, and supervisor validation. Biometric or sensitive identity data is not required by this design and must not be introduced without separate privacy/legal review.
5. Timesheets capture regular hours, overtime hours/type, task/cost code, work location, supervisor, period, supporting evidence, and approval status. Attendance does not automatically prove productive hours, overtime entitlement, or payroll approval.
6. Separate attendance correction, timesheet preparation, supervisor validation, payroll preparation, payroll review, payroll approval, payment execution, and reconciliation according to DEC-074. No user approves their own attendance/rate/pay adjustment where segregation applies.
7. Overtime, shift premiums, allowances, travel, accommodation, bonuses, deductions, penalties, advances and leave adjustments use explicit configured rules, source authority, effective date, calculation version and evidence. No universal labour-law or payroll formula is assumed.
8. Payroll runs are period-scoped immutable snapshots. Record included workers, source attendance/timesheets, rate versions, adjustments, calculation version, gross pay, each earning/deduction, net pay, currency, exceptions, reviewers, approvals and run status.
9. Distinguish calculated, reviewed, approved, instructed, paid, partially paid, held, rejected, reversed and reconciled payroll values. Payroll approval does not prove bank payment; bank payment follows DEC-077.
10. Support corrections after payroll approval through controlled supplemental run, adjustment, reversal or recovery linked to the original payroll period and payslip. Never silently rewrite an issued payslip or paid payroll record.
11. Provide individual payslips with restricted employee access, period, earnings, allowances, overtime, deductions, advances, gross/net values, payment reference/status and correction history. Bulk payroll exports and bank files require elevated permissions and audit.
12. Restrict personnel identity, salary, bank details, attendance and payroll data to the individual and authorized HR/payroll/finance roles. Protect reports, search, notifications, exports, print and dashboard aggregates from unauthorized disclosure.
13. Allocate workforce cost across project, cost code, work package, department or multiple projects using approved allocation basis and version. Preserve split percentages/hours and prevent duplicate allocation of the same payable time.
14. Reconcile payroll register to payment records, bank evidence, advances, custody/cash payments where authorized, and accounting export. Unpaid, held, returned and unallocated payroll remain visible.
15. Support payroll summary, worker-level restricted register, attendance variance, overtime, allowances/deductions, project labour cost, payroll aging, exceptions, and period reconciliation reports.
16. Configure jurisdiction-specific wage, overtime, leave, statutory deduction, tax, social insurance, record-retention and payslip requirements only after qualified legal/payroll review. SiteDocs must not present generic calculations as legal compliance.
17. Preserve immutable audit for rate changes, attendance edits, approvals, payroll runs, payslip issuance, bank file export, payment and corrections. Retain payroll records under applicable retention and privacy requirements.

**Dependencies:** DEC-055/063/064/065/067/068/072/073/074/077; DEC-071 for controlled print.

**Open details:** workforce categories, payroll periods, time rules, overtime/allowance policy, leave model, rate authority, statutory rules, payslip fields, cost allocation, retention, banking/export integration.

**Implementation boundary:** design only. No personnel data import, payroll calculation/run, payslip issue, salary/rate change, wage payment, tax/statutory determination, code/database/storage/auth/RLS/API/UI change, migration, test, merge, or deployment is authorized.

## 14.56 DEC-080 — Finance Spreadsheet Import, Validation & Reconciliation Controls

**Purpose:** Define safe ingestion of financial workbooks and tabular data into SiteDocs without treating file upload or automated extraction as approval, verified calculation, or authoritative transaction posting.

**Requirements**
1. Support controlled import for approved financial domains such as budgets, BOQ/SOV, variations, payment applications, measurements, cost reports, commitments, expenses, custody, payroll, receipts, payments and bank statements. Each import is bound to a project, module, document type, period, currency and authorized operator.
2. Preserve original source file unchanged, with file name, source location/provider, uploader, upload time, size, file type, hash where supported, source revision/date, workbook sheet names, and import batch ID. The original remains available as evidence subject to access/retention.
3. Provide workbook inspection before mapping: sheet selection, header/data range, hidden sheets/rows/columns where detectable, merged cells, formulas, cached values, named ranges, tables, date/number formats, units, currencies and blank/error cells. State clearly when a parser cannot inspect a feature.
4. Map source sheets/columns to explicit SiteDocs fields. Save mapping profile/version, project, document type, units, currency, date convention, decimal/thousands separators, formula handling and transformation rules. Never infer ambiguous mappings silently.
5. Distinguish formula text, cached formula result, manually entered value, and calculated SiteDocs value. Preserve formula/value provenance where available; flag missing or stale cached results and formula errors such as #VALUE!, #REF!, #DIV/0!, #NAME? and other workbook errors.
6. Validate required fields, data types, IDs, dates, units, currencies, sign conventions, totals, duplicate rows, duplicate documents, line references, contract/BOQ references, approved variation references and cross-sheet consistency. Report row/sheet/cell coordinates and actionable exception reasons.
7. Reconcile imported totals to source workbook totals and related source documents. Any unexplained difference, rounding variance, missing row, duplicate, formula error, date conflict, or inconsistent amount is an exception; do not silently force totals to match.
8. Support preview, dry-run, staging, validation report, exception resolution, authorized approval, controlled commit, and post-import reconciliation as separate stages. Uploading or previewing never writes authoritative Finance transactions.
9. Imported records are provisional until authorized validation and approval. No silent overwrite of existing records. Match by stable identifiers and explicit duplicate rules; changed source data creates a new import version/batch or controlled amendment with full lineage.
10. Preserve source row identity and lineage from each imported value to workbook, sheet, row, column/cell, mapping version, import batch, operator, transformation and approval. For multi-sheet workbooks, retain cross-sheet dependency references where available.
11. Handle large files through bounded processing, sheet-by-sheet extraction, chunking and resumable batches. Record incomplete processing and do not report full workbook validation when only selected sheets/ranges were parsed.
12. Provide import exception queue for unsupported formats, encrypted/corrupt files, oversized workbooks, formula errors, hidden or protected content, unsupported macros, external links, missing values and ambiguous fields. Macros and external links are never executed as part of import.
13. Support CSV/XLSX and other formats only where a tested parser and project-approved mapping exist. Preserve original file even if normalized output is generated. Do not treat PDF/OCR extraction as a structured spreadsheet source without human validation.
14. Provide import history, batch status, rollback/compensation plan for committed data, and duplicate prevention. Rollback must not erase immutable audit or downstream approved/paid records; use controlled reversal/adjustment if already relied upon.
15. Enforce role and segregation controls for upload, mapping, validation, approval, commit, exception override, export and deletion/retention. High-impact financial imports require independent review under DEC-074.
16. Export templates include controlled headers, field definitions, units, currency, date conventions, required IDs, revision and version. Exported spreadsheets do not become authoritative source records until re-imported and validated through this process.
17. Provide a reconciliation summary: rows read/accepted/rejected/duplicate; totals by currency and sheet; formula/error counts; unresolved exceptions; source-to-target totals; records created/updated/rejected; and final approval/commit state.
18. Protect confidential workbook content, payroll, bank details, supplier rates and claims throughout staging, temporary processing, logs, error messages, exports and retention. Temporary files are governed by secure cleanup and audit policy.

**Dependencies:** DEC-058 import/export governance; DEC-059 backup/DR; DEC-065 integrity; DEC-072 Finance; DEC-073 document lifecycle; DEC-074 authority; DEC-075–079 domain workflows.

**Open details:** supported file formats/limits, parser capabilities, formula recalculation policy, hidden content handling, mapping templates, duplicate rules, staging retention, commit/compensation, import authority and external accounting formats.

**Implementation boundary:** design only. No workbook processing pipeline, production import, database write, authoritative update, macro execution, accounting posting, code/database/storage/auth/RLS/API/UI change, migration, test, merge, or deployment is authorized.


## DEC-081 — Finance Reporting, Management Dashboards & KPI Governance

**Purpose:** Define a trustworthy, role-aware financial reporting layer that presents financial position and trends without changing or conflating the authoritative source records.

1. Provide distinct reporting domains for budget and cost, commitments, procurement, payment applications/certificates, accounts payable/receivable where enabled, cash and treasury, custody/expenses, payroll/workforce cost, variations/claims, tax/retention/advances, and financial closeout. Cross-domain summaries may aggregate only through governed definitions and authorized access.
2. Every metric must have a versioned definition: business meaning, formula, unit/currency, source record types and fields, inclusion/exclusion rules, time basis/cut-off, status treatment, aggregation grain, owner, refresh cadence, effective date, and known limitations.
3. Keep approved budget, control budget, contract sum, approved variations, pending changes, commitments, actual cost, accruals, invoices, assessed/certified values, scheduled payments, paid amounts, receipts, forecast and cash position distinct. Never label one as another or infer approval, liability, entitlement or payment from a dashboard total.
4. Provide period, project, contract, cost code/CBS, WBS, supplier/payee, package, currency and status filters only where the underlying records support those dimensions. Preserve source currency and reporting currency with disclosed FX source/date/rate and conversion policy.
5. Support drill-down from portfolio/project KPI to contributing registers, records, line items and source evidence, subject to the same record-, field-, attachment- and action-level permissions. Aggregates must not leak restricted amounts, salary, bank data, claims strategy, supplier rates or confidential attachments.
6. Show data freshness, last successful refresh, source coverage, missing/late feeds, provisional/imported data, unresolved reconciliation exceptions, stale baselines and incomplete periods. A partial or stale dataset must be visibly qualified and must not appear complete.
7. Distinguish actual, approved baseline, current approved forecast, pending scenario and target. Preserve historical snapshots and definition versions so prior reports can be reproduced; corrections create controlled restatements or new snapshots, not silent rewrites.
8. Provide role- and party-specific views for authorized finance, commercial, project leadership, owner/developer, contractor and auditor users. Project Manager remains read-only under DEC-021/074; dashboard access does not grant source-record edit, review, certification or payment authority.
9. KPI comparisons require consistent scope, currency, period, denominator and calculation version. Portfolio benchmarking must flag incomparable projects and must not rank or score incomplete datasets as if equivalent.
10. Alerts and thresholds are project-configurable and versioned. No universal financial KPI threshold, SLA, warning limit or automatic escalation is established by this decision. Alerts inform; they do not approve, reject, certify, post or pay.
11. Exports and printed reports preserve report ID, generation time, filters, metric-definition version, source snapshot/cut-off, currency/FX basis, confidentiality marking and issuing authority. Export permissions are independently controlled and logged.
12. Reconcile report totals to their authoritative registers and disclose exclusions, rounding and aggregation rules. A dashboard is a read model, not an accounting ledger or substitute for signed/certified source documents.

**Dependencies:** DEC-021/048/055/060/063/064/065/068/072–080.

**Open details:** metric dictionary, report catalogue, role-specific visibility, refresh expectations, historical snapshot policy, FX/reporting currency, thresholds, export formats and accounting/BI integration.

**Implementation boundary:** design only; no dashboard, reporting service, KPI calculation, data warehouse, accounting ledger, export pipeline, notification, code/database/storage/auth/RLS/API/UI change, migration, test, merge or deployment is authorized.

## DEC-082 — Supplier Invoices, Payables & Three-Way Matching Controls

**Purpose:** Govern supplier/subcontractor invoices and payable evidence while keeping procurement, physical receipt, quality inspection, invoice assessment, certification and payment as distinct controls.

1. Maintain separate identities and lifecycle records for supplier invoice, credit note, debit note, purchase order/contract, approved amendment, delivery record/GRN, inspection evidence, invoice verification, payable assessment, payment certificate/authorization, payment instruction, remittance and reconciliation.
2. Capture invoice issuer/payee identity, tax/commercial identifiers where applicable, invoice number/date, received date, currency, tax presentation, contract/PO references, line references, quantities, units, rates, gross/net/tax/retention/advance/deduction values, due-date basis, attachments and source provenance. Validate required fields against configured jurisdiction and contract rules.
3. Detect potential duplicate invoices using configurable combinations of supplier identity, invoice number, date, currency, amount and source document fingerprints. Flag for human resolution; do not silently reject or merge records solely on fuzzy matching.
4. Support configurable two-way, three-way or contract-specific matching. Three-way comparison may relate authorized PO/contract lines, accepted receipt/GRN quantities and invoice lines, but each source remains authoritative only for its own purpose.
5. GRN confirms recorded receipt/custody evidence; it does not by itself prove quality acceptance, installation, earned progress, contractual entitlement, invoice approval or payment. MIR/WIR and other quality records remain in Operations and are linked by exact IDs/revisions where relevant, not merged into Finance.
6. Matching rules must account for partial deliveries, split invoices, consolidated invoices, service/daywork invoices, milestone payments, approved variations, returns, credits, rejected/quarantined goods, unit conversions and tolerances. Each exception has reason, owner, evidence, disposition and audit history.
7. Compare invoice quantities/rates/amounts to authorized contract/PO lines and accepted receipt/measurement evidence as applicable. Differences become explicit exceptions (quantity, price, tax, currency, missing receipt, overbilling, duplicate, unapproved change); no automatic price amendment or contract variation is permitted.
8. Preserve line-level mapping and allocation to project, contract, cost code/CBS, WBS, package, asset/material or expense category. Split allocations must reconcile to invoice totals and retain the original line identity.
9. Separate invoice received, completeness checked, matched, exception-held, verified, assessed, recommended, approved, certified/posted where configured, scheduled, paid, disputed, credited and closed. A verified invoice is not automatically approved; approval is not payment.
10. Link payment execution to DEC-077 and commitments/actuals/accruals to DEC-075/068 without double counting parent contract, PO, GRN, invoice, certificate and payment. Define the authoritative recognition point for each report separately.
11. Supplier statements and account reconciliations are independent evidence. Differences, unapplied credits, debit balances, disputed items and unallocated payments remain visible until resolved with a documented disposition.
12. Enforce DEC-074 segregation across invoice creation/upload, receipt recording, quality inspection, matching, verification, assessment, approval, payment and reconciliation. No self-approval or self-reconciliation of a material transaction.
13. Retain original invoice files and immutable submitted snapshots. OCR/extraction is provisional and must be validated; corrections use versioned amendments, credit/debit notes or controlled adjustments, never silent replacement of issued records.
14. Restrict invoice rates, supplier banking, tax IDs, subcontract terms and dispute material by party, project, contract, record and field. Search, notifications, reports, exports and print follow the same permissions.

**Dependencies:** DEC-021/050–055/064/065/070/072–080/074/077.

**Open details:** applicable invoice types, matching policy per procurement category, tolerances, receipt acceptance source, tax validation, duplicate rules, payment terms, posting/recognition policy, supplier statement formats and local regulatory review.

**Implementation boundary:** design only; no supplier invoice intake, matching engine, payable approval, accounting posting, tax calculation, bank validation, payment or code/database/storage/auth/RLS/API/UI change, migration, test, merge or deployment is authorized.

## DEC-083 — Tax, Withholding, Retention, Advances & Financial Security Schedules

**Purpose:** Define a configurable evidence and calculation framework for contract-specific and jurisdiction-specific financial adjustments without asserting universal legal, tax or accounting treatment.

1. Maintain separate schedules and line-level histories for VAT/sales taxes, withholding taxes, contractual retention, advance payments and recovery, discounts, liquidated damages/other deductions, contra charges, bonds/guarantees, insurance/security instruments and other configured adjustments.
2. For every rule capture jurisdiction, legal/contractual source reference, clause or authority, applicability, taxable/withholding base, rate or amount, calculation order, effective dates, currency, rounding method, cap/floor, exemption status, responsible reviewer and approval evidence. Rules must be versioned and project/contract scoped.
3. Do not hard-code a universal VAT rate, withholding rate, retention percentage, advance recovery formula, deduction cap, guarantee requirement, due date or statutory treatment. Require qualified local tax/legal/accounting review before activating jurisdictional rules.
4. Distinguish tax invoice data, tax determination, tax withheld, tax reported/remitted, tax credit/recovery and tax reconciliation. A tax field on an invoice is not proof of legal validity, recoverability, filing or remittance.
5. Retention must be tracked by contract, certificate, invoice/application, line or milestone as configured, including cumulative withheld, released, due, disputed and paid amounts; release requires its own evidence and authority and is not inferred from completion alone.
6. Advance records distinguish approved advance, disbursement, outstanding balance, recovery basis, recovered amount, remaining balance, security instrument, expiry and release. Recovery is calculated only from the applicable approved contractual rule and certified base; never silently net against unrelated obligations.
7. Deductions and damages preserve asserted, assessed, recommended, agreed, determined, certified and collected values separately, with source clause, notice, evidence, response, dispute status and decision authority. Pending or disputed amounts do not automatically reduce approved budget, certified value or payment.
8. Bonds and guarantees record instrument type, issuer, beneficiary, amount/currency, covered obligation, effective/expiry dates, claim conditions, amendments, verification evidence, custody/location, status, release/return and claim history. Expiry alerts are informational; no automatic claim, extension or release.
9. Support multi-currency adjustments with explicit transaction currency, settlement/reporting currency, FX source/date and realized/unrealized difference treatment as configured. Preserve source amounts and conversion lineage.
10. Reconcile each schedule to related applications, certificates, invoices, payment instructions, remittances and final account. Prevent duplicate withholding/recovery across records and show outstanding balances and exceptions.
11. Keep calculation outputs reproducible from immutable input snapshots and versioned rules. Any retrospective rule change creates a controlled recalculation proposal and impact report; it must not rewrite previously approved/certified/paid records.
12. Enforce role separation for rule configuration, tax/contract interpretation, calculation review, approval, certification, payment, guarantee custody and reconciliation. High-risk rule changes require independent authorization and audit.
13. Financial closeout must identify unresolved tax filings/credits, retention, advance balances, guarantees, deductions, claims and disputed amounts. Technical completion or archive transfer does not settle these balances.

**Dependencies:** DEC-067/069/072–079/081/082/074/077.

**Open details:** jurisdiction and tax regimes, contract clauses, tax invoice requirements, withholding certificates, retention release events, advance security and recovery, guarantee verification, FX policy, rounding and statutory reporting.

**Implementation boundary:** design only; no tax/legal/accounting determination, rule activation, calculation, deduction, withholding, retention release, guarantee claim/release, payment, code/database/storage/auth/RLS/API/UI change, migration, test, merge or deployment is authorized.

## DEC-084 — Finance Correspondence, Contract Packages & Commercial Document Control

**Purpose:** Control the documentary evidence exchanged among employer, consultant, contractor, subcontractors, suppliers and finance teams without confusing correspondence with approval or transactional records.

1. Support finance-related incoming/outgoing letters, payment application cover letters, invoice submissions, payment notices, commercial clarifications, statements, certificates, claims notices, tax/withholding certificates, guarantees, bonds, insurance documents and contractual financial attachments.
2. Keep correspondence, transmittals, finance registers, source documents, contractual instruments and workflow decisions as distinct linked records. A letter may reference an application or invoice but does not replace it or change its status.
3. Give each formal item a stable internal ID at draft creation and an official number only on successful formal issue, consistent with DEC-022. Numbering series are configurable by project, party, type and year where approved.
4. A package manifest records sender, recipients, authorized distribution, purpose, exact document IDs/types/revisions, attachments, confidentiality, issue date/time, delivery channel and dispatch evidence. The manifest is immutable after issue; corrections create a superseding package or supplemental issue.
5. Separate prepared, reviewed, approved-for-issue, issued, dispatched, delivered, acknowledged, responded, superseded, withdrawn and archived events. Delivery/receipt does not mean content reviewed, accepted, agreed, certified or paid.
6. Preserve exact links between correspondence and financial records: contract/PO, variation/claim, application/certificate, invoice/credit note, payment/remittance, guarantee, reconciliation and closeout record. Link exact revision and line references where applicable.
7. Capture subject, sender/recipient capacity, dates, contractual clause/reference, response due basis if configured, requested action, attachments, response chain and chronology. Do not invent a universal notice period; contract-specific notice rules are separately configured and reviewed under DEC-069.
8. Restrict commercially sensitive correspondence, claim strategy, rates, bank/tax details, payroll and legal advice by party, project, record, field and attachment. Permissions apply to search snippets, notifications, package manifests, exports and print.
9. Preserve source files, signed copies, email-origin metadata where lawfully captured, delivery evidence, hashes and audit history. OCR and extracted metadata remain provisional until verified.
10. Finance correspondence does not itself approve a variation, determine a claim, certify an application, authorize payment, accept goods, approve quality or amend a contract. Those decisions must be recorded in their respective governed workflows.
11. Support Arabic and English content, linked translations and bilingual correspondence while preserving the authoritative source language/version and translation provenance.
12. Retention, legal hold, archive transfer and disposal follow DEC-054/067/086; paper and hybrid dispatch follow DEC-050/051/071.

**Dependencies:** DEC-017/022/050–055/064/067/069/070/072/073/077/082/083.

**Open details:** numbering series, correspondence types, party distribution matrices, notice calendar/contract rules, delivery integrations, bilingual template policy, email capture and retention classes.

**Implementation boundary:** design only; no email integration, external dispatch, signature, contract amendment, approval, payment, correspondence UI, database/storage/auth/RLS/API/code change, migration, test, merge or deployment is authorized.

## DEC-085 — Finance Period Close, Subledger Reconciliation & Accounting Export Governance

**Purpose:** Establish controlled financial period close and reconciliation readiness while distinguishing SiteDocs operational finance records from a formal general ledger or ERP.

1. Define project-configurable financial periods, cut-off dates, time zone, opening/closing status, late-entry handling, adjustment windows, reopening authority and evidence. No universal fiscal calendar or accounting basis is assumed.
2. Period close is a controlled snapshot and checklist, not a claim that all liabilities are settled. Include bank/cash, supplier/customer balances where enabled, payment applications/certificates, invoices, commitments, accrual proposals, advances, retention, taxes, payroll, expenses/custody, variations/claims, inventory-related financial records and unresolved exceptions.
3. Maintain separate subledger-style registers and reconciliation schedules for payables, receivables, certificates, payments, receipts, bank, cash, custody, payroll, retention, advances, tax and commitments where configured. Do not represent these as a general ledger unless a separate accounting design and authority are approved.
4. Reconciliation records identify source and target accounts/records, period, currency, opening balance, movements, closing balance, unmatched items, timing differences, FX differences, adjustments, evidence, preparer, independent reviewer, status and resolution history.
5. Distinguish bank statement balance, book/cashbook balance, available funds, restricted funds, uncleared instruments, outstanding payments, deposits in transit, committed cash and forecast cash. Imported statements remain provisional until validated and reconciled under DEC-077/080.
6. Accruals are proposals with source, basis, estimate, period, owner, confidence/assumptions, review and reversal/settlement linkage. They do not become approved actual cost, invoice, liability or accounting posting merely by appearing in a close pack.
7. Late invoices, backdated documents, corrections and prior-period adjustments require a reason, effective/recorded dates, impact assessment and authorized treatment. Closed-period source records are not silently edited; corrections use supplemental, reversal or controlled reopening mechanisms.
8. Reopening a closed period requires defined authority, reason, affected reports/records, impact preview, independent review and a new close snapshot. Preserve prior snapshots and the full audit chain.
9. Provide controlled export packages for external accounting/ERP systems only through approved, versioned mappings. Each export records target system/profile, chart/account mapping version, period, currency, source IDs, totals, row counts, exceptions, generation time and operator.
10. Exported data is not proof of successful posting. Capture external batch/reference and reconciliation outcome when returned; distinguish prepared, exported, received, accepted, rejected, posted and reconciled. No duplicate export/posting on retry.
11. Support compensating/reversal exports and reconciliation for rejected or corrected batches without deleting source or audit records. Protect credentials and secrets; integrations follow DEC-057.
12. Enforce segregation between period preparation, reconciliation, review, close approval, reopening, export and external posting confirmation. PM remains read-only; auditor access is controlled and non-transactional.
13. Reports disclose accounting basis, cut-off, source coverage, unresolved items, provisional balances, FX policy and whether figures are management estimates or externally posted values.

**Dependencies:** DEC-055/057–060/063–068/072–080/077/081–083.

**Open details:** accounting basis, fiscal periods, accrual policy, chart mapping, external ERP formats, close authority, reopening windows, FX and reconciliation tolerances, audit evidence and retention.

**Implementation boundary:** design only; no general ledger, journal posting, fiscal close, accounting integration, external export/posting, period lock, reconciliation automation or code/database/storage/auth/RLS/API/UI change, migration, test, merge or deployment is authorized.

## DEC-086 — Finance Archive, Retention, Legal Hold & Search Governance

**Purpose:** Ensure finance records remain complete, discoverable, confidential and evidentially reliable throughout retention and final closeout.

1. Finance archive covers issued applications, certificates, invoices, contracts/POs, variations/claims, payment and receipt evidence, payroll records, expense/custody, tax/withholding schedules, guarantees, correspondence, reconciliation packs, period-close snapshots, exports and final accounts.
2. Archive records retain stable IDs, type, project/party, exact revision, status history, issue/receipt dates, source file, attachments, manifest, approvals/signatures, links to related records, hashes, retention class and audit events.
3. Archive is a controlled state/location, not deletion or loss of workflow history. Superseded, withdrawn, disputed, rejected and corrected records remain discoverable subject to permissions and retention.
4. Retention schedules are configurable by record class, jurisdiction, contract, project and legal requirement, with effective dates and authority. No universal retention duration or automatic disposal date is established here.
5. Legal hold and dispute preservation can suspend normal disposal for scoped records, attachments, versions, custodians and related evidence. Hold initiation/release requires authorized reason, scope, owner, dates, review and immutable history.
6. Disposal is a separate approved process after eligibility checks, hold checks, contract/regulatory review, evidence of authorization and auditable disposition. No automated deletion based only on age or project closure.
7. Search supports exact IDs, document numbers, supplier/payee, contract/PO, invoice, certificate, payment reference, period, cost code, WBS, status, amount range and dates only where authorized and supported. Search results, facets, counts, snippets and exports must not leak confidential values.
8. Preserve lineage across revisions, transmittals, correspondence, source spreadsheets, imports, report snapshots, accounting exports and linked Operations evidence. Search must not silently substitute “latest” for a requested historical revision.
9. Hashes and integrity checks support detection of file alteration; a hash alone does not prove authorship, legal validity, signature validity or content correctness.
10. Archive retrieval and download are logged with user, purpose where required, record/version, time, action and outcome. Bulk export requires separate authorization, scope limits and manifest.
11. Financial closeout links the final account, outstanding claims, retention/advance balances, tax matters, guarantees, unpaid invoices, payment evidence and unresolved reconciliation exceptions to the project closeout snapshot under DEC-067.
12. Maintain confidentiality and data minimization for payroll, bank, identity, tax, supplier pricing and legal/claim information through archive, search, backup, export and authorized handover.

**Dependencies:** DEC-054/055/058/059/063/064/065/066/067/072–084.

**Open details:** retention classes/durations, legal hold authority, disposal evidence, hash algorithms, archive tiers, search indexing, bulk retrieval, export limits and cross-border data requirements.

**Implementation boundary:** design only; no archive migration, deletion/disposal, retention activation, legal hold action, search index, storage lifecycle, database/storage/auth/RLS/API/UI/code change, migration, test, merge or deployment is authorized.

## DEC-087 — Finance Templates, Bilingual Reports & Controlled Document Rendering

**Purpose:** Define consistent, accessible and auditable finance forms and report outputs while preserving exact source records and issued versions.

1. Provide configurable templates for finance applications, valuation/measurement sheets, certificates, invoices and invoice registers, payment/remittance advice, receipts/vouchers, custody/expense forms, payroll outputs, tax/retention/advance schedules, reconciliation packs, commercial correspondence, period-close packs and final accounts.
2. Templates are versioned assets with owner, type, language, effective date, approval status, project/party scope, field mapping, calculation references, layout, revision history and retirement/supersession history. A template change does not rewrite previously issued documents.
3. Support Arabic and English layouts, right-to-left and left-to-right direction, mixed-language fields, numerals/date conventions, currency display, page numbering and approved bilingual labels. Preserve the original entered value and locale metadata; display formatting must not alter stored amounts, dates or identifiers.
4. Support controlled PDF and spreadsheet outputs where suitable. CSV is a data interchange format, not a faithful page-layout document. XLSX outputs must distinguish source values, formulas, calculated values and protected template cells; exported workbooks are not authoritative until governed re-import/validation under DEC-080.
5. A generated report or certificate captures immutable report/document ID, source record IDs and revisions, exact line snapshots, calculation/rule versions, template version, filters, currency/FX basis, cut-off, generated timestamp, issuing party and confidentiality marking.
6. Separate preview, draft generation, internal review, approval-for-issue, formal issue and reissue. Preview/export is not approval or issue; issued outputs are immutable. Corrections create a controlled superseding revision or supplemental document.
7. Provide project/party-specific branding configuration (logo, legal name, address, project identifiers, contract references, approved headers/footers) with authorized ownership and validation. Do not embed unverified branding or personal data.
8. Support page size, margins, pagination, repeating headers, tables, signatures/approval evidence, attachments index, watermark, QR/reference code and controlled print settings as configured. A watermark or QR code does not itself prove authenticity; verification resolves to a permission-controlled record.
9. Apply classification and access restrictions to rendered content, hidden workbook sheets, formulas, metadata, attachments, print, download and export. Do not leak hidden payroll, bank, supplier pricing, claims or personal information through template fields or cached files.
10. Record every generation, preview where material, download, print, reprint, issue, replacement and failed rendering event with actor, time, source snapshot, template version and outcome.
11. Validate numeric precision, rounding, units, currency symbols, negative values, long Arabic/English text, Unicode fonts, page breaks, totals and line carry-forward. Displayed rounding must reconcile to the underlying precision and disclosed rounding policy.
12. Templates for statutory tax/payroll documents, contractual certificates and legally prescribed forms require qualified jurisdictional/contract review before activation; no universal mandatory layout or wording is asserted.

**Dependencies:** DEC-017–022/045–047/050/054/055/064/071/072–086/080.

**Open details:** template catalogue, approved brand assets, language/locale policy, supported fonts, PDF/XLSX rendering capabilities, signature evidence, watermark/QR verification, retention and statutory forms.

**Implementation boundary:** design only; no template engine, document renderer, PDF/XLSX generation, signature stamping, print service, branding deployment, code/database/storage/auth/RLS/API/UI change, migration, test, merge or deployment is authorized.

## DEC-088 — Subcontractor Commercial Administration & Subcontract Accounts

**Purpose:** Govern subcontract commercial obligations and balances while preserving the distinction between subcontract procurement, work execution/quality, valuation, certification, payment and closeout.

1. Maintain separate records for subcontractor qualification, tender/quotation, evaluation, award recommendation, authorized subcontract, scope/schedule of rates, amendments/variations, work orders, insurance/bonds, mobilization, progress evidence, applications, assessments, certificates, invoices, deductions, payments, claims, statements and final account.
2. Every subcontract has a unique identity and links to the main project, subcontractor legal entity, authorized contracting party, scope/package, work breakdown, cost codes, currency, effective dates, authorized signatories, commercial terms, attachments and versioned schedules.
3. Preserve original executed subcontract and each authorized amendment as immutable snapshots. Tender clarifications or correspondence do not amend the subcontract unless the contractually authorized amendment process is completed.
4. Separate subcontractor work progress, site inspection/quality acceptance, measured quantities, commercial assessment, recommendation, approval, certification and payment. WIR/MIR and other Operations records remain in their own workflows; links require exact IDs/revisions and do not imply automatic valuation or acceptance.
5. Support subcontract valuation bases where configured: BOQ/remeasurement, lump sum, milestones, daywork, approved variations, provisional sums and other contract-defined schedules. Preserve original, approved amended, previous, current and cumulative quantities/values.
6. Track subcontract applications and certificates at line level, including claimed, measured, assessed, recommended, certified, disputed, withheld and paid amounts. Partial assessment/certification and reasoned exceptions are supported; no silent alteration of prior certificates.
7. Track advance, recovery, retention, tax/withholding, contra charges, back charges, materials supplied, plant/equipment, attendance/time-based labour, insurance, bonds and other deductions only under applicable approved subcontract terms and configured rules. No universal formula or percentage is set.
8. Record back-to-back clauses or flow-down obligations explicitly by source clause and scope. Do not assume all main contract provisions automatically apply to every subcontract or create legal conclusions about enforceability.
9. Support subcontractor invoices, credit/debit notes and statement reconciliation under DEC-082. Invoice verification, subcontract certification, payment authorization, bank execution and reconciliation remain separate.
10. Commitments and cost forecasts link to the authorized subcontract value and approved changes under DEC-075/068. Avoid double counting subcontract commitment, work order, invoice, certificate and payment; pending claims/variations remain distinct from approved contract value.
11. Provide subcontractor account statement with opening balance, certified amounts, advances, recoveries, retention, deductions, invoices, payments, credits, disputes, outstanding balances and source references by currency and period.
12. Enforce party-level confidentiality and segregation for tender rates, subcontract terms, payroll/labour details, bank information, claims and internal commercial assessments. Subcontractor users see only their authorized records and issued outputs, not internal recommendations or other parties' data.
13. Subcontract closeout reconciles scope completion, defects/claims, final measurements, variations, final certificate, retention/advance balances, bonds/guarantees, tax documents, invoices, payments, releases and archive handover. A final statement or zero balance is not inferred without reconciliation and authorized disposition.
14. All delegated commercial authority is project/contract/value/currency/date scoped and auditable; no shared accounts, proxy approvals or self-certification.

**Dependencies:** DEC-020/021/050–055/063–070/072–086/074–083/087.

**Open details:** subcontract forms, qualification, valuation rules, flow-down clause handling, material/labour charging, account statement design, authority thresholds, retention/security release and closeout requirements.

**Implementation boundary:** design only; no subcontract award/amendment, commitment posting, application assessment, certification, payment, legal enforceability determination, code/database/storage/auth/RLS/API/UI change, migration, test, merge or deployment is authorized.

## DEC-089 — Finance Claims, Deductions, Damages & Dispute Account Governance

**Purpose:** Provide a finance-side record of monetary/time claims and deductions coordinated with the risk/change/claims framework without deciding contractual entitlement or legal liability.

1. Maintain distinct linked records for contractor claims, employer claims, subcontractor claims, supplier claims, variations, compensation events, deductions, back charges, damages, liquidated damages assertions, contra charges, disputes, settlements and determinations. A claim is not an approved variation or certified payable merely because it is submitted or registered.
2. Each claim/deduction record captures claimant/respondent, contract/subcontract and clause references, notice trigger/source, event chronology, cause, scope, requested relief (time/cost/other), currency, valuation basis, calculation version, evidence index, mitigation, related risk/issue/change IDs, responsible owner and confidentiality.
3. Preserve contractual notice evidence: applicable clause, triggering event, contractual deadline as interpreted by an authorized reviewer, recipient, required method, dispatch/delivery evidence, response and any reservation. Do not establish universal notice periods or infer waiver/entitlement from silence.
4. Distinguish asserted, submitted, acknowledged, assessed, recommended, disputed, negotiated, agreed, determined, approved, certified, invoiced, paid, withdrawn and closed values/statuses. Partial agreement does not erase the disputed remainder.
5. Separate time entitlement, cost entitlement, quantum assessment, liability/fault analysis, contractual determination, certification and payment. Schedule analysis or cost estimate is evidence only; it does not itself award EOT, damages or compensation.
6. Deductions and damages require explicit source authority, clause, factual basis, calculation, notice/response, assessment, approval and recovery mechanism. Do not automatically deduct disputed or unapproved amounts from a payment certificate or payable balance.
7. Track claim components and cumulative effects at line level, including direct cost, prolongation, disruption, acceleration, overhead, finance charges and other contract-defined heads only where supported. Record assumptions, exclusions, concurrency, mitigation, overlap and potential double counting.
8. Preserve negotiation history, offers, counteroffers, reservations, without-prejudice/confidential classification where applicable, meeting records, partial settlements, dispute escalation, adjudication/arbitration/litigation references and final outcomes with access restrictions.
9. Settlement/compromise requires authorized approval and explicit scope: claims/releases affected, amount/currency, time consequences, tax/retention treatment, payment schedule, reservations, conditions, effective date and signatories. Do not infer a global release from a partial payment or correspondence.
10. Link financial impact to DEC-068/075 forecasts and commitments as scenario/pending exposure until authorized recognition. Approved/determined amounts are still distinguished from certified and paid values. Avoid double counting across claim, variation, invoice, certificate and payment.
11. Support claim aging and exposure reports with transparent age basis, notice dates, response status, owner, next action and data freshness. Aging or risk score is not a legal deadline or entitlement assessment.
12. Enforce strict confidentiality for legal advice, negotiation strategy, privileged material, internal assessment, counterparty submissions and personal/commercial data. Party-specific views expose only approved communications and outputs.
13. Preserve immutable chronology and evidence snapshots; corrections append clarifications or superseding assessments without erasing prior positions. Unresolved claims and deductions remain visible in final account and project closeout under DEC-067/085/086.
14. Segregate claim initiation, evidence preparation, commercial assessment, legal review, recommendation, determination/approval, certification, payment and dispute administration. No person may approve their own claim or deduction.

**Dependencies:** DEC-055/061/063/064/067–069/072–086/081–085.

**Open details:** contract-specific claim categories, notice calendars, valuation methodology, damages clauses, approval authority, settlement powers, legal privilege, dispute forums, reporting and final account treatment.

**Implementation boundary:** design only; no entitlement/liability determination, notice issuance, deduction, damages assessment approval, settlement, certification, payment, legal advice, code/database/storage/auth/RLS/API/UI change, migration, test, merge or deployment is authorized.
 

## DEC-090 — Project Reference Records: Project Drawings (PDW), Project Documents (PDOC) & Meeting Minutes (MOM)

**Purpose:** Establish three separately classified project-reference record categories in the document classification structure, each with its own abbreviation, register classification and controlled lifecycle. These categories are not WIR/RFI/MQR workflows and are not finance records by default.

1. Add the following three entries as distinct values in a dedicated **Project Reference Records** classification column, preserving the exact English display names and abbreviations:
   - **Project Drawings (PDW)** — issued design, construction, coordination, shop, as-built and other project drawing sets, with drawing number, title, discipline, originator, suitability/status, revision, sheet identity, scale where relevant, issue purpose, related package/area and supersession links.
   - **Project Documents (PDOC)** — controlled project reference documents not classified more specifically as drawings or meeting minutes, such as specifications, project procedures, plans, schedules, method statements, manuals, technical submittals/reference material and other approved project records. The category is a controlled residual class, not a catch-all that overrides dedicated document types or operational/finance workflows.
   - **Meeting Minutes (MOM)** — formal records of project meetings, including meeting identity, date/time, venue or mode, chair, attendees and roles, agenda, discussion summary, decisions, action items, responsible parties, target dates, attachments, distribution and confirmation/correction history.
2. Each category has its own abbreviation and must remain independently filterable, reportable, searchable and configurable. Do not combine the three into one document type or reuse their abbreviations for unrelated records.
3. Preserve the distinction between a drawing/document revision and its transmittal or distribution event. A transmittal identifies the exact document IDs and revisions sent; it does not create or replace the source record.
4. For PDW and PDOC, retain source identity, originator, received/issued status, revision, status/suitability, issue purpose, effective/superseded relationships, related disciplines/locations/packages and source attachments where applicable. Never infer that a received or distributed document is approved for construction or use.
5. For MOM, distinguish draft preparation, internal review, formal issue/distribution, acknowledgement, correction/addendum and action tracking. Acknowledgement of receipt is not agreement with every statement; silence is not approval. Preserve original issued minutes and append controlled corrections or addenda rather than silently rewriting the issued record.
6. Decisions recorded in MOM are evidence of what was recorded, not automatic authorization to amend a contract, approve a variation, certify payment, change design, close an NCR or bypass the applicable delegated workflow. Link each action/decision to the separately authorized record where one exists.
7. Support cross-links to project, contract/package, WBS, location, discipline, correspondence, transmittal, RFI, change/variation, claims, quality and finance records using exact IDs and revisions. Links do not merge permissions or lifecycle states.
8. Apply role-, party-, project- and classification-based access to source files, revisions, comments, attachments, download, print, search snippets and distribution. Draft minutes and internal review copies remain restricted until formally issued under configured authority.
9. Keep category-specific numbering configurable by project and record class. The abbreviations PDW, PDOC and MOM are classification codes, not a mandate for a particular full numbering syntax; uniqueness, legacy mapping and migration policy remain open.
10. Include the three categories in the project Document Register and archive/search model while preserving their distinct classification column, source identity, revisions, transmittal history, issue/receipt evidence and audit trail. Do not create duplicate source records merely because a document appears in multiple packages or transmittals.
11. **Dedicated column rule:** In the project document-type/classification matrix, show these three labels together under a separate **Project Reference Records** column, distinct from operational forms, correspondence/transmittals, finance records and reports. Their labels must appear exactly as “Project Drawings (PDW)”, “Project Documents (PDOC)” and “Meeting Minutes (MOM)”.
12. This decision establishes design classification only. It does not approve any drawing, specification, meeting decision, design change, contractual notice, variation, payment or implementation action.

**Dependencies:** DEC-017–022/045–055/063–067/069–073/084/086–089.

**Open details:** drawing status/suitability vocabulary, drawing register attributes, project document residual-class boundaries, meeting minute confirmation policy, numbering syntax, legacy document mapping, distribution lists, retention classes and authority matrix.

**Implementation boundary:** design only; no document import/migration, renumbering, approval, design release, transmittal, minute issuance, contract/design/finance decision, database/storage/auth/RLS/API/UI/code change, migration, test, merge or deployment is authorized.


## DEC-091 — Financial Final Account & Project Financial Closeout

**Purpose:** Define a controlled, evidence-based final account and financial closeout process that reconciles the project's contractual and financial history without conflating measured work, approved contract value, assessed/certified amounts, invoices, payments, unresolved claims or accounting treatment.

1. Maintain distinct but linked final-account views for the main contract, each subcontract, other material project commercial packages and the consolidated project financial closeout. A consolidated view must preserve party, contract, package, currency and source-ledger boundaries; it must not conceal or net unrelated balances.
2. Establish a frozen closeout cut-off and scope: project/contract identity, contracting parties, contract baseline, applicable amendments, valuation basis, currency, relevant periods, included packages, exclusions, open records and responsible preparers/reviewers. Any later adjustment is a controlled supplemental/reopened closeout event with preserved prior snapshot and reason.
3. Reconcile the contract value bridge: original executed contract value; approved variations/amendments; approved omissions/credits; other authorized contract adjustments; revised contract value; and separately identified pending/proposed/disputed changes. Only authorized contractual changes enter the approved value; pending items remain visible as exposure, not silently included.
4. Reconcile final scope and measurement by BOQ/WBS/cost code/package/location where applicable: original and amended quantities, measured quantities, previously certified quantities, final assessed quantities, accepted valuation basis, omissions/additions, dayworks/provisional sums and supporting records. Link exact source IDs/revisions for measurement and evidence. Execution progress, WIR/MIR acceptance, delivery or completion status is not automatically a final payable valuation.
5. Reconcile each payment application and certificate chronologically, including submitted, assessed, recommended, certified, invoiced, scheduled, paid, withheld, disputed, rejected, superseded and reversed/adjusted values. Preserve line-level source snapshots and do not overwrite issued certificates or infer payment from certification or invoice receipt.
6. Reconcile cash and settlement by transaction evidence: payment instructions/authorizations, remittance, bank/cash execution, receipts, returned/reversed transactions and allocation to certificates/invoices. A payment register entry or remittance advice is not proof of cleared funds unless supported by the configured reconciliation evidence.
7. Reconcile all contract adjustments and deductions separately: advance payments and recovery, retention withheld/released, tax/withholding, discounts, contra charges, back charges, damages, penalties, materials/plant deductions, credits and other contract-defined items. Each item requires its own contractual/configuration basis, source, currency, calculation version, approval and balance history; no universal rate or automatic netting is assumed.
8. Reconcile claims, variations, disputes, settlements and determinations under DEC-069/089. Show asserted, pending, disputed, agreed, determined, approved, certified and paid states separately. Unresolved or reserved claims remain disclosed as contingent/open exposure; they are not treated as zero, approved income/cost or automatically settled by a final account statement.
9. Reconcile securities and obligations: performance/advance/retention guarantees, bonds, insurance, warranties, releases, expiry dates, claims and return evidence. Record release/return status only when authorized evidence exists; expiry alone does not prove discharge or release.
10. Reconcile supplier and subcontract accounts, payroll/workforce costs, custody/expenses, inventory/materials and other relevant subledgers to their source records and approved period-close outputs. Preserve each subledger's own reconciliation and authority; the final account summary is not a substitute for detailed records or an assumed general ledger.
11. Provide a final account statement with transparent opening balances, cumulative approved contract value, final measured/assessed value, certificates, invoices, adjustments, receipts/payments, retention/advance/tax balances, disputed/open items, securities and calculated closing balance. Every line identifies currency, source, cut-off, status, calculation basis and whether it is agreed, provisional, disputed or subject to further approval.
12. Support reconciliation exceptions and sign-off packs: missing evidence, unmatched payments, duplicate allocations, quantity/value differences, unapproved changes, unallocated receipts, tax/retention differences, unreleased securities, unresolved claims and unclosed commitments. Assign owner, reason, materiality, action, target and disposition; do not hide exceptions through manual balancing entries.
13. Distinguish **commercial final account agreement**, **authorized certification/payment**, **accounting period/subledger close**, **project financial closeout** and **administrative project closure**. Completion of one does not automatically establish the others. Final account agreement does not itself prove all funds have cleared or all legal/contractual obligations have been discharged.
14. Permit controlled outcomes such as draft, under reconciliation, internally reviewed, submitted to counterparty, partially agreed, agreed subject to stated reservations, disputed, approved/certified where authorized, financially settled, closed with disclosed residual obligations, or reopened by approved supplemental event. Do not force a false “zero balance” outcome.
15. Require independent preparation, commercial/quantity review, finance reconciliation, contract/legal review where needed, delegated approval, counterparty agreement where contractually required and payment execution as separate capabilities. No self-approval, proxy signature or unilateral conversion of a disputed account into an agreed account.
16. Preserve immutable snapshots of the final account versions, supporting registers, source document IDs/revisions, calculations/rule versions, FX inputs if applicable, approvals, reservations, signatures, transmittals, correspondence and audit events. Corrections append a superseding version or supplemental statement; prior submissions and agreements remain retrievable.
17. Provide final account and closeout reports by contract, subcontract, party, package, cost code, currency and period with controlled access. Management summaries must drill down to source records and disclose provisional/unreconciled data; confidential commercial/legal material remains restricted.
18. The process may link to project progress and closeout evidence, including approved VO records, measured work, progress reports and payment application packs, but no source workbook, request letter, percentage complete or submitted amount is treated as approval or payment without its own verification and authority.
19. No universal final-account deadline, release wording, tax treatment, retention release rule, payment period, currency conversion rule, rounding tolerance or legal discharge is prescribed. These depend on executed contracts, applicable jurisdiction and qualified review.

**Dependencies:** DEC-055/063–070/072–089/075–085/087–090.

**Open details:** contract-specific final measurement and agreement process, cut-off rules, final account format, authority thresholds, residual claims treatment, tax/retention/security release, FX/rounding policy, counterparty sign-off and reopening conditions.

**Implementation boundary:** design only; no final measurement approval, account agreement, certification, payment, release of security/retention, tax/legal/accounting determination, period lock, ledger posting, import/migration, database/storage/auth/RLS/API/UI/code change, migration, test, merge or deployment is authorized.


## DEC-092 — Project Finance Configuration, Currency, Units & Calculation Policies

**Purpose:** Establish versioned, project- and contract-scoped configuration for financial currencies, exchange rates, units of measure, precision, rounding and calculation rules so that finance records and outputs are consistent, reproducible and auditable without imposing universal commercial, tax or accounting assumptions.

1. Maintain an explicit finance configuration profile with unique identity, project scope, effective dates, owner, status, approval evidence, version, change reason and audit history. Support controlled inheritance from organization/project defaults to contract/package settings, with explicit overrides and visible provenance; no silent inheritance or retroactive rewriting.
2. Distinguish project reporting/base currency, contract currency, application/certificate currency, invoice currency, payment/settlement currency, bank account currency and source transaction currency. Each financial record states its currency; a project may involve multiple contract currencies. Do not add or compare amounts in different currencies as if they were the same unit.
3. Permit configured ISO 4217 currency codes where applicable, while retaining support for contract-defined or legacy currency identifiers through a governed mapping. Currency symbols and localized display strings are presentation only; codes and numeric values are the stored identity. Currency minor-unit conventions must be versioned/configurable where the applicable currency or contract requires it.
4. Define an exchange-rate policy per project/contract and transaction purpose: source/provider or approved manual source, rate type, base/quote currency pair, rate value, effective date/time, applicable event date, retrieval/entry timestamp, approval, evidence and rate version. Distinguish transaction-date, invoice-date, certificate-date, payment-date, period-end and management-reporting rates where configured. Never invent a rate or silently substitute the latest available rate.
5. Preserve the original transaction amount and currency alongside any converted reporting amount, exchange rate, direction, calculation timestamp, rate source and conversion rule. Revaluation or corrected FX inputs create a traceable adjustment/recalculation record; they do not overwrite the original booked/source amount. Do not assume a single FX rate is appropriate for every accounting, tax, contractual or management purpose.
6. Support explicit unit-of-measure dictionaries for quantity and rate schedules, including code, localized label, dimension/category, permitted precision, canonical/reference unit, conversion factor, conversion direction, effective dates and approval. Examples may include m, m², m³, kg, tonne, item, day and hour, but project/contract usage is configured and not presumed universal.
7. Keep units dimensionally valid. Conversion is permitted only where a governed conversion exists and dimensions are compatible; do not convert unlike dimensions or infer equivalence from similar labels. Preserve original entered quantity/unit and the normalized quantity/unit plus conversion provenance. Unit changes to executed BOQ or contract schedules require authorized contractual control, not merely a configuration edit.
8. Define precision independently for quantities, unit rates, currency amounts, FX rates, percentages, tax bases and displayed ratios. Preserve calculation precision separately from display precision. Do not truncate source values or round intermediate values unless an explicitly versioned rule requires it.
9. Configure rounding method, scale, stage and scope (for example per line, tax component, certificate subtotal, invoice total or final payable) by applicable contract/jurisdiction/purpose. Possible methods must be explicitly selected and documented; no universal half-up, half-even or other method is assumed. Show the effect of line-level versus aggregate rounding and retain reconciliation differences.
10. Version calculation policies and formulas with identifier, description, inputs, units, currency, precision, rounding stage, effective dates, approval, test examples and change history. A calculation result records the exact policy version and source inputs used so it can be reproduced. A later policy change applies prospectively unless an authorized, reasoned recalculation is approved.
11. Define configurable calculation components for valuation, tax/withholding, retention, advance recovery, deductions, discounts, escalation/indexation, fees and other contractual items only where supported by the executed contract and qualified jurisdictional review. Store the source clause/rule, base, inclusions/exclusions, rate, cap/floor, trigger, effective period, priority, currency and approval. Do not hardcode statutory rates or contractual percentages as universal defaults.
12. Separate tax determination from display and arithmetic. Tax configuration must identify jurisdiction, tax type, taxable basis, exemptions/zero-rating/reverse-charge or other treatment where applicable, rate source, effective dates, rounding and required evidence; applicability requires qualified review. The system must not infer legal tax status solely from supplier location, invoice wording or a user-entered label.
13. Support configured calculation order and dependency graphs where one component's base depends on another (for example retention, tax, advance recovery or deductions). Make ordering, inclusions/exclusions and whether components are calculated before/after other adjustments explicit. Detect circular dependencies, invalid negative bases, missing rates, expired rules and incompatible units/currencies; surface exceptions instead of silently producing totals.
14. For imported spreadsheets, preserve original workbook and source values, formulas, cached results, sheet/cell lineage and extraction limitations. Distinguish imported static values from formulas recalculated by SiteDocs. Do not execute macros or treat a workbook's displayed result as authoritative without validation and reconciliation under DEC-080.
15. Every material calculation output should disclose or link to source record IDs/revisions, input quantities/rates/amounts, unit conversions, FX source/rate/date, calculation policy and version, rounding method/stage, exceptions, actor and timestamp. Historical issued outputs retain the original snapshot even if configuration later changes.
16. Provide validation controls for missing configuration, conflicting effective periods, overlapping rates, invalid unit conversion, currency mismatch, precision overflow, unexpected negative values, stale FX rates, unapproved policy versions and reconciliation tolerances. Exceptions require reasoned resolution and authorized override; no silent default substitution.
17. Allow authorized preview/simulation of proposed configuration changes against representative historical/current scenarios, showing before/after deltas and affected records. Simulation does not alter live records or approve a policy; applying a new version requires separate approval and effective date.
18. Reports must distinguish source currency amounts, converted amounts and presentation currency; show the conversion basis and date. Consolidated totals across currencies require an explicitly selected and disclosed reporting conversion policy. Never sum unlike currencies without conversion or hide FX effects.
19. Configuration changes are subject to segregation of duties: preparation, review, approval, activation and retrospective recalculation are distinct capabilities. No user may approve their own high-impact financial rule change or use configuration privileges to amend executed contract terms.
20. **No universal settings are imposed:** project base currency, accepted currencies, FX source/frequency, units, decimal places, rounding mode, tax rules, retention/advance rates, conversion tolerances and recalculation authority remain project-, contract- and jurisdiction-specific open configuration items until approved.

**Dependencies:** DEC-055/063–065/072–085/087–091/080/083.

**Open details:** base/reporting currency, permitted currency list, FX sources and cut-off rules, currency minor units, UOM catalogue and precision, rounding method/stage, calculation order, tax configuration ownership, tolerances, approval thresholds and historical recalculation policy.

**Implementation boundary:** design only; no configuration activation, FX feed connection, tax/rate determination, contract amendment, calculation execution or recalculation, spreadsheet import, database/storage/auth/RLS/API/UI/code change, migration, test, merge or deployment is authorized.


## DEC-093 — Finance Data Model, Relationships & Canonical IDs

**Purpose:** Define a conceptual, implementation-neutral finance information model with stable record identity, explicit relationships, source lineage and lifecycle boundaries. This decision describes logical entities and links only; it does not prescribe database tables, physical schemas, APIs or migrations.

1. Use a stable, system-generated canonical ID for each independently governed record. Canonical IDs are immutable, globally unique within the agreed system identity boundary, non-semantic and never recycled. Human-readable document numbers, contract numbers, invoice numbers, certificate numbers and display codes are separate business identifiers that may follow configurable project/party/year sequences and must not be used as primary identity.
2. Every canonical record carries common governance metadata as applicable: record type, project/organization scope, owning party, creator, creation time, status, current version/revision, effective date, source/provenance, confidentiality/classification, retention class, and audit reference. Do not force irrelevant fields onto every record; use type-specific metadata.
3. Establish a conceptual entity catalogue, including at minimum:
   - **Project & commercial foundation:** Project, Organization/Party, Party Role, Contract, Contract Party, Contract Package, Contract Amendment/Variation, BOQ/Rate Schedule, BOQ Line, WBS/Cost Code, Location/Work Package, Commitment.
   - **Measurement & payment:** Measurement Record, Measurement Line, Payment Application, Application Line, Assessment, Assessment Line, Payment Certificate, Certificate Line, Invoice, Credit/Debit Note, Payment Instruction, Payment Transaction, Remittance, Receipt, Allocation and Reconciliation.
   - **Financial balances & security:** Advance, Recovery, Retention Balance/Movement, Tax/Withholding Assessment, Deduction/Contra Charge, Financial Security/Guarantee, Security Event, Release/Return Evidence, Custody Account, Expense Claim, Payroll/Timesheet Cost Record and Inventory/Material Cost Record where enabled.
   - **Commercial exposure & closeout:** Claim, Claim Component, Dispute, Offer/Counteroffer, Settlement, Determination, Final Account, Final Account Line, Closeout Snapshot, Reconciliation Exception and Residual Obligation.
   - **Configuration & calculation:** Finance Configuration Profile, Currency, FX Rate Snapshot, Unit of Measure, Unit Conversion, Calculation Policy, Calculation Run, Calculation Input/Output and Approval/Authorization Evidence.
   - **Shared records and evidence:** Document/Attachment, Document Revision, Transmittal/Package Manifest, Correspondence, Meeting Minute/Action reference, Approval, Signature Evidence, Audit Event and External System Reference.
4. Treat the catalogue as logical concepts, not a requirement to create a separate physical table for every named concept. Related concepts may later be represented through governed implementation patterns, provided identity, access, lifecycle, history and audit semantics are preserved.
5. Model relationships explicitly with relationship type, source and target canonical IDs, cardinality, effective period where relevant, provenance, status and creator. Define whether each link is required, optional, one-to-one, one-to-many or many-to-many. Avoid implicit joins based only on matching names, amounts, dates or spreadsheet row positions.
6. Preserve project, contract, party and package scope on every financial record or through an unambiguous governed parent relationship. A record must not become visible across projects or counterparties merely because it shares a supplier, contract reference or document number.
7. Separate contract value, approved amendment, commitment, measured quantity/value, submitted application, assessed amount, certified amount, invoice liability, payment transaction, cash receipt and reconciled balance as different record concepts. Links support traceability but do not collapse their statuses or imply authorization.
8. Define core relationship paths without treating them as automatic approvals:
   - Project → Contract → Contract Package → BOQ/Rate Schedule → BOQ Line.
   - Contract → Amendment/Variation → affected BOQ/WBS lines and revised contract value snapshot.
   - Work/Measurement Evidence → Measurement Line → Application Line → Assessment Line → Certificate Line.
   - Certificate/Invoice → Payment Instruction → Payment Transaction/Remittance → Allocation → Reconciliation.
   - Advance/Retention/Tax/Deduction → individual balance movements → application/certificate/payment/final-account references.
   - Claim/Dispute/Settlement → related contract, event, change, evidence, financial exposure and final-account line.
   - Contract/Package/Subledger → Final Account → Closeout Snapshot → Reconciliation Exceptions/Residual Obligations.
9. Allow a single source item to be referenced by multiple downstream records without duplicating or mutating the source. Use explicit allocation/link records where amounts or quantities are split across multiple applications, certificates, invoices, payments, cost codes or packages. Allocations must preserve allocated and unallocated balances and prevent duplicate consumption beyond configured tolerances.
10. Define canonical identity separately from revision identity. A document/contract/application may have one stable parent ID and immutable revision/version IDs or snapshots. A revision-specific link must identify the exact revision used; “latest” must never be inferred for historical approvals, calculations or issued outputs.
11. Preserve source lineage for imported records: source file ID/hash, source system, import batch, sheet/row/cell or external record key where available, mapping version, original value, normalized value, validation outcome and responsible actor. A failed or partial import remains distinguishable from an accepted record; retries must be idempotent or explicitly reconciled.
12. Support external references as namespaced identifiers (system/provider, external ID, object type, mapping status and effective period). External IDs do not replace canonical IDs and must not be assumed globally unique outside their namespace.
13. Model financial amount and quantity values with explicit currency/unit references, sign convention, precision, calculation policy version and source. Avoid generic untyped “amount” or “quantity” fields where their meaning, currency, unit, period or valuation basis is material.
14. Represent status transitions and material changes as attributable events or immutable history entries, including prior/new state, actor, timestamp, reason, authority and evidence. Current status is a governed projection of history; it must not erase previous states. Corrections create a superseding record, adjustment or append-only event according to record type.
15. Define lifecycle ownership and source-of-truth boundaries. Operations WIR/MIR, document control, finance, procurement, payroll, inventory and external accounting systems may reference one another by canonical IDs, but each remains authoritative for its own workflow and decision. For example, WIR acceptance is not a payment certificate; GRN is not quality acceptance; a meeting minute is not a contract amendment; an invoice is not proof of payment.
16. Enforce party/project/record/field-level access independently of relationship traversal. A user who can view one linked record does not automatically gain access to the linked record, attachment, bank detail, payroll data, tender rate, claim strategy or legal material. Search, reports, exports and graph navigation must apply the same permission checks.
17. Define deletion and retention semantics as governed lifecycle states. Canonical IDs are never reassigned; referenced records are not hard-deleted merely to clean up relationships. Corrections, cancellation, supersession, archival and approved disposal retain required tombstone/audit and referential integrity evidence under DEC-054/055/086.
18. Establish data-quality constraints for required parent links, valid status transitions, unique business identifiers within their configured scope, currency/unit compatibility, date/effective-period consistency, referential integrity, allocation totals, duplicate detection and cross-project isolation. Exceptions are recorded and resolved through controlled workflow rather than silent auto-correction.
19. Keep the model extensible through versioned record types and governed optional extensions. New types or relationship semantics require impact assessment across registers, reports, permissions, audit, retention, integrations and migration; do not create ungoverned free-text types that bypass validation.
20. The conceptual model must support reproducible finance reporting and final-account reconstruction: every material aggregate must be traceable to exact source record IDs/revisions, allocation links, calculation policy and cut-off snapshot.
21. **Implementation boundary:** This is a conceptual data model only. It does not authorize physical database design, schema/table creation, key generation code, API contracts, RLS/policies, storage changes, data migration, import execution, generated types, application code or deployment.

**Dependencies:** DEC-017–022/047/050–065/067–070/072–092/080/082/085/086/091.

**Open details:** canonical ID format/namespace, business numbering rules, physical mapping strategy, entity ownership by module, relationship cardinalities, revision strategy, source-of-truth matrix, external ID mapping, allocation tolerance, data migration/legacy crosswalk and retention implementation.

**Implementation boundary:** design only; no physical schema/table/index/constraint creation, migration, data import, API/RLS/auth/storage/UI/code change, generated types, test, merge or deployment is authorized.


## DEC-094 — Supplier Qualification & Approval Governance

**Status:** Design decision recorded; qualification criteria, evidence schedules, authority thresholds and validity periods remain project-, contract- and jurisdiction-specific open details.

**Decision:** Establish a dedicated Supplier Qualification & Approval workflow, separate from material approval, procurement award, purchase order, delivery acceptance and payment.

1. Maintain a controlled supplier profile with canonical identity, legal/trading names, registered details, authorized contacts, supplier categories, disciplines, products/services, operating locations, ownership declarations where lawfully required, and project/organization scope. Preserve verified source and effective dates for material profile changes.
2. Support supplier registration, prequalification, evaluation, clarification, approval, conditional approval, rejection, suspension, expiry, renewal/requalification and withdrawal as distinct states/events. State transitions require authorized actors, reason, evidence and timestamps; no silent status overwrite.
3. Capture configurable qualification evidence according to supplier category and applicable project/contract requirements. Evidence may include registration/licensing, tax or statutory records, insurance, quality/HSE credentials, technical capability, experience/references, financial capacity and manufacturer/distributor authorization. Do not impose universal documents, thresholds, scores or validity periods.
4. Separate completeness checks, technical evaluation, commercial/financial due diligence, HSE/quality review, compliance review, recommendation and final approval. Apply a configurable authority matrix and segregation of duties; submission or document upload is not approval.
5. Allow conditional approval only with explicit scope, conditions, owner, due date/review trigger and expiry or reassessment rule. A condition must not be treated as satisfied until evidence is reviewed by an authorized role.
6. Maintain supplier status and approval scope by project, organization, category, discipline, product/service and validity period where needed. An approval for one project, category or service does not automatically extend to another.
7. Support periodic and event-triggered reassessment, document expiry alerts, performance feedback, nonconformance/complaint linkage and controlled suspension/reinstatement. Preserve prior assessments and reasons; do not erase historical approval.
8. Provide controlled supplier register, evaluation history, expiring-document queue, pending-review inbox, approved/conditional/suspended/expired views and audit-ready reports. Search, exports and dashboards must enforce party/project/field permissions.
9. Link supplier records to procurement enquiries, tender/award, subcontract, purchase orders, material submittals, deliveries, invoices and performance records through exact canonical IDs. These links do not create or imply award, commitment, material approval, receipt acceptance, invoice certification or payment.
10. Supplier-facing access, if enabled, is limited to the supplier's own authorized profile, submissions, clarification requests and issued decisions. Internal scoring, competitor data, commercial strategy and confidential assessments remain restricted.
11. Preserve immutable evidence versions, reviewer comments, decisions, conditions, notifications, acknowledgements and audit events. Corrections or renewals create controlled versions/events rather than replacing issued history.
12. **Implementation boundary:** design only. This decision does not authorize supplier onboarding, qualification or approval decisions, procurement awards, purchase orders, external invitations, integrations, data imports, physical schema, database/storage/auth/RLS/API/UI/code changes, migrations, tests, merge or deployment.

**Dependencies:** DEC-020/021/050–065/070/072–089/093; procurement, subcontract and material workflows.

**Open details:** supplier categories, mandatory evidence by category, evaluation criteria/scoring, financial/HSE thresholds, validity/renewal periods, conditional approval policy, authority matrix, supplier self-service scope, cross-project recognition and performance rating method.

## DEC-095 — Material Submittal & Approval Governance

**Status:** Design decision recorded; material-specific review codes, technical criteria, sample/testing requirements and authority remain specification- and contract-dependent open details.

**Decision:** Establish a dedicated Material Submittal & Approval workflow, distinct from supplier qualification, procurement, purchase orders, delivery/inspection (MIR), installation release and payment.

1. Each material submittal has a canonical record ID, controlled business number, project/package/location scope, submitting contractor, proposed manufacturer, brand, supplier (where known), material/product identity, intended use, specification references, drawing/detail references, BOQ/WBS links where applicable, and required submission date/revision context.
2. Support material families and configurable technical metadata without hard-coding one universal field set. Capture product data, catalogue/datasheet, technical compliance matrix, certificates, test reports, samples/mock-ups, country/manufacturing source, warranty, sustainability or safety data where relevant and contractually required.
3. Require explicit clause/specification/drawing references for each compliance claim where applicable. Distinguish contractor-declared compliance, reviewer verification, test evidence and approved deviations; do not infer compliance from a product name or supplier status.
4. Model review stages and outcomes as configurable and authority-controlled. The workflow must support submission, completeness screening, technical review, comments/clarification, resubmission, recommendation, approval/rejection/conditional approval and supersession. Exact review codes and whether multi-party/discipline reviews are sequential or parallel remain open until approved.
5. A returned-for-revision or incomplete submission remains in its own history. A materially changed product, manufacturer, specification, source or technical property requires a new controlled revision or linked resubmission; preserve the prior submitted and reviewed versions and identify what changed.
6. Conditional approval must record exact permitted scope, restrictions, outstanding evidence, owner and closure/verification requirement. It must not be treated as unconditional approval or as permission to bypass stated conditions.
7. Keep material approval separate from supplier approval: an approved supplier does not make every product acceptable, and an approved material does not qualify every supplier or source. Where procurement policy requires both, validate both approvals independently at the relevant transaction stage.
8. Keep material approval separate from procurement award/PO, delivery receipt, MIR inspection, sampling/testing at delivery, installation approval and payment. An approved submittal identifies an accepted proposed material under its stated scope/revision; it does not prove that delivered goods match, are undamaged, meet quantity, passed site inspection or are payable.
9. Link approved material identity and exact revision to purchase order lines, delivery records, MIR, test results, nonconformance records, installed locations and closeout/as-built records. A mismatch between approved and delivered manufacturer/product/source/revision is a controlled exception requiring authorized disposition, not silent substitution.
10. Provide role-specific contractor, consultant/discipline reviewer, owner/developer and document-control work queues; role permissions distinguish prepare, submit, screen, review, comment, recommend, approve, issue, supersede and archive. No self-approval, proxy identity or authority inferred from visibility.
11. Support attachments with version/hash/provenance, review markups, comparison of revisions, comment-response matrices, sample/test tracking, notification history and immutable audit trail. Issued decisions point to exact submitted revision and evidence set.
12. Provide searchable material register, pending/returned/approved/conditional/rejected/superseded views, expiry/revalidation alerts where certificates are time-limited, and reports by project/package/discipline/manufacturer/supplier/material status. Enforce permissions on records, attachments, search, exports and dashboards.
13. **Implementation boundary:** design only. No material technical approval, deviation acceptance, procurement commitment, purchase order, delivery acceptance, MIR outcome, installation release, testing instruction, database/storage/auth/RLS/API/UI/code change, migration, import, test, merge or deployment is authorized.

**Dependencies:** DEC-020/021/022/047/050–065/070/071/072–089/090/093; WIR/MIR and procurement/subcontract workflows.

**Open details:** material categories, submission forms, technical compliance matrix, review codes, reviewer sequence, authority matrix, sample/mock-up/testing rules, conditional approval limits, resubmission/revision rules, substitution controls, certificate expiry and supplier cross-validation.


## 14.57 DEC-096 — Finance User Journeys, Logical Screens & Workflow Specifications

**Decision:** Define role-based finance journeys and a logical screen/workflow inventory before any Finance UI or application implementation. This is a functional design specification, not a final visual design, physical schema, or authorization to build.

**Core journeys and boundaries:**
1. **Contractor/commercial team:** select project/contract/package; view authorized budgets, BOQ/WBS and commitments; prepare and submit payment applications with measured quantities, period, supporting records and tax/retention/advance breakdowns; submit supplier invoices/claims/expense requests where applicable; answer clarification requests and resubmit controlled revisions; track status, certified amounts, deductions and remittance/receipt without treating submission as approval or payment.
2. **Consultant/quantity-surveying team:** receive assigned applications; check completeness; reconcile quantities and rates to contract/BOQ, approved variations and source evidence; record measured/assessed quantities and reasons for adjustments; raise queries; prepare recommendation and draft certificate; preserve contractor-applied, consultant-assessed and owner-certified values as distinct facts. Assessment/recommendation does not itself authorize payment.
3. **Owner/developer/commercial authority:** review commercial exposure, commitments, variations, claims, assessments, certificates and exceptions; approve/reject/return only within delegated authority and segregation rules; view pending liabilities and forecast exposure. Approval must be attributable to the authorized individual and exact revision.
4. **Finance/accounts payable and receivable:** register and validate invoices; perform configured PO/receipt/approved-service matching where applicable; manage due dates, tax/withholding/retention/advance schedules, payment proposals, execution references, receipts and bank reconciliation; preserve invoice, certificate, payment and settlement as separate records.
5. **Cash, expenses and workforce finance:** submit/review petty cash, expense and reimbursement claims, advances, timesheets and payroll-cost records under their distinct confidentiality and approval rules; no general finance screen may expose payroll or personal data by default.
6. **Project Manager:** oversight dashboards and project-wide read-only visibility, including drafts where previously authorized for supervision; no edit, review, recommendation, approval, signature or payment action merely by virtue of PM role.
7. **Document Controller:** register, classify, version, issue, distribute, archive and retrieve finance records; document-control access does not confer commercial review, certification or payment authority.
8. **System/configuration administrator:** manage only approved configuration and access assignments through governed, versioned processes; technical administration is not business approval.

**Logical screen inventory:** project/contract finance overview; budget and commitment register; BOQ/WBS and variation linkage; payment application workspace; measurement and assessment workspace; query/response inbox; certificate preparation and approval; invoice/AP and receivable registers; payment proposal/execution and remittance; receipt and reconciliation workspace; advance/retention/tax/deduction schedules; claims/disputes and subcontract accounts; expense/petty-cash workspace; workforce-cost restricted workspace; final-account/closeout workspace; finance document register/transmittal/archive; dashboards/reports; audit and configuration views. Final labels, navigation and visual layouts remain subject to usability validation.

**Screen specification minimum:** each screen/action must identify intended role and delegated authority, project/contract/package scope, data classification, source-of-truth links, displayed fields, permitted actions, required evidence, validation rules, revision behaviour, audit events, notifications, and empty/loading/error/permission-denied/success states. Search, exports, dashboards and attachments enforce the same server-side access scope as record detail.

**Workflow controls:** distinguish Draft, Submitted, Completeness Review, Under Assessment, Clarification/Returned, Recommended, Approved/Certified, Rejected, Superseded, Payment Proposed, Payment Executed, Partially Paid, Paid and Reconciled only where applicable to the relevant record type. These are conceptual state families, not one universal state machine. Each transition defines actor, preconditions, evidence, reason/comment requirements, authority, notification and immutable event. No silent state jumps, implied approval from silence, self-approval, proxy signing or automatic payment. Reopening/correction creates traceable events or new revisions rather than overwriting issued history.

**Cross-module lineage:** finance journeys may link to contracts, variations, BOQ/WBS, progress evidence, WIR/MIR, supplier/material approvals, procurement, delivery, invoices, correspondence, transmittals and closeout. A link is not an approval or source-of-truth transfer: progress is not payable measurement by itself; material/supplier approval is not a PO or receipt; MIR acceptance is not a payment certificate; certificate is not proof of payment.

**Experience and operational requirements:** support Arabic/English labels and controlled bilingual outputs, localized date/number/currency presentation with canonical stored values, desktop and field/mobile-responsive use, accessible keyboard/focus/contrast behaviour, clear task inboxes and actionable notifications. Offline capture, electronic signature, external accounting integration and mobile approval remain subject to separate security and integration decisions.

**Open details:** final role catalogue and authority thresholds; screen naming/navigation; state labels and transition matrix by document type; required evidence by contract/jurisdiction; payment execution integration; offline support; localization conventions; accessibility conformance target; detailed notification/escalation rules.

**Dependencies:** DEC-020/021/022/047–066/068–089/091–095; especially finance taxonomy, authority, payment application, invoice, configuration and canonical-ID decisions.

**Implementation boundary:** design only. No UI/code, database/schema/RLS/API, workflow engine, accounting integration, migration, import, production test, merge or deployment is authorized.


## 14.58 DEC-097 — SiteDocs Non-Functional Requirements & Quality Attributes

**Decision:** Establish a cross-module quality-attribute baseline for SiteDocs Operations, Finance and shared Core capabilities. Requirements apply to web/mobile experiences, APIs, background processing, document/file handling, integrations, reporting and administration as applicable. This is a requirements baseline only; numeric service objectives, architecture choices and implementation remain subject to measurement, threat/risk assessment and approval.

### A. Security, identity and authorization
1. Enforce authenticated individual identities, secure session lifecycle, least privilege, deny-by-default and server-side authorization on every read/write/action path, including search, exports, attachments, reports, notifications and APIs.
2. Enforce project, organization, party, contract, package, discipline, record classification and workflow-stage boundaries. UI hiding is not an authorization control.
3. Preserve segregation of duties and capability boundaries: creator/reviewer/approver/signer/payer separation where required; no self-approval, shared accounts, impersonation or proxy action. PM oversight remains read-only.
4. Protect credentials, secrets, tokens and sensitive data in transit and at rest using approved cryptographic controls and managed key/secret lifecycle. Exact algorithms, key custody and rotation intervals require security approval.
5. Apply secure development practices: input validation, output encoding, injection prevention, CSRF protections where applicable, rate limiting, abuse protection, dependency and vulnerability management, secure configuration, and controlled administrative access.
6. Require auditable privileged actions, access changes, authentication/security events and sensitive-data access. Do not expose secrets or unnecessary personal/financial data in logs.

### B. Privacy, confidentiality and data governance
1. Classify information and apply purpose-limited access, data minimization, controlled disclosure, export safeguards and privacy-aware logging.
2. Separate sensitive payroll, personal, bank, supplier commercial, claims and dispute information by explicit permissions and need-to-know scope.
3. Define retention, legal hold, archival and disposal by approved contract, jurisdiction and organizational policy; no universal retention period is assumed.
4. Support subject/data requests and incident response only through governed procedures that preserve legal holds, audit evidence and record integrity.

### C. Availability, resilience and recoverability
1. Define availability objectives per service tier and critical workflow, including planned maintenance, dependencies, degraded operation and user communication. No percentage/SLA is set by this decision.
2. Design for graceful degradation and safe retry of transient failures. Idempotency and duplicate prevention are required for submissions, payments, imports, notifications and integrations where repeated requests could create duplicate effects.
3. Treat database and object/file storage as separate but coordinated recovery domains. Backups must be protected, monitored and restore-tested; recovery rehearsal must verify references, permissions, versions and file-object integrity.
4. Define RPO, RTO, backup frequency, retention, geographic placement, failover, restore sequencing and disaster-recovery responsibilities through a separate approved continuity plan. These values remain open.
5. Preserve immutable business history and avoid partial transactions that leave workflow, financial ledger-like records, audit events and file references inconsistent.

### D. Performance and scalability
1. Establish measurable performance budgets for sign-in, navigation, record retrieval, search, document preview/download/upload, workflow submission, dashboards, reports and exports.
2. Define targets by workload, dataset size, concurrency, geographic/network conditions, device class and percentile (not averages alone). Numeric thresholds require baseline measurements and stakeholder approval.
3. Support horizontal/vertical scaling and controlled background processing where justified; isolate long-running reports, imports, exports and file processing from interactive workflows.
4. Prevent unbounded queries, oversized payloads and uncontrolled report/export jobs. Provide pagination, filtering, progress feedback, cancellation where safe and resource limits.
5. Performance tests must use representative synthetic or approved masked datasets and must not expose production personal or commercial information.

### E. Integrity, correctness and auditability
1. Preserve canonical IDs, business identifiers, exact revisions, source lineage, timestamps and actor attribution. Never silently overwrite issued or approved records.
2. Use consistent transactional boundaries and concurrency controls for competing edits, approvals, numbering, allocations and financial state changes.
3. Make calculations reproducible from versioned configuration, inputs, rates, rounding rules and source evidence. Distinguish display formatting from stored precision.
4. Time handling must preserve source timestamp and applicable timezone; localized display must not change event chronology.
5. Audit records must be tamper-evident/append-only in accordance with DEC-055 and protected against unauthorized alteration or deletion.

### F. Usability, accessibility and localization
1. Support Arabic and English across core navigation, forms, validation, notifications, reports and generated documents. RTL/LTR layouts must preserve mixed-language identifiers, numbers, dates and technical terms.
2. Use consistent terminology, clear workflow state/action labels, accessible validation messages, confirmation for consequential actions and understandable error recovery.
3. Design responsive experiences for supported desktop, tablet and mobile browsers. Critical workflows must identify any mobile limitations explicitly.
4. Provide keyboard operation, visible focus, semantic structure, sufficient contrast, scalable text and accessible status/error announcements. Target conformance level and formal test standard remain open for approval.
5. Support locale-aware date, number and currency presentation while preserving canonical values and configured project/contract rules. Localization must not change calculations or legal/business meaning.

### G. Compatibility, interoperability and maintainability
1. Publish a supported browser/device matrix and version policy; avoid relying on unsupported browser behaviour. Exact support windows remain open.
2. Define versioned API and integration contracts, authentication, authorization, retries, idempotency, error mapping, observability and deprecation policy in accordance with DEC-057.
3. Keep modules loosely coupled through governed contracts; failures in optional integrations must not corrupt authoritative SiteDocs records.
4. Require maintainable architecture, documented configuration, traceable changes, code review, dependency inventory, automated quality checks and controlled release/rollback procedures.
5. Provide operational runbooks, ownership, support escalation, diagnostics and user-facing incident communication for critical services.

### H. Observability, support and operations
1. Collect structured application, security, audit and infrastructure telemetry with correlation IDs and synchronized time; keep business audit history distinct from diagnostic logs.
2. Monitor service health, workflow backlogs, integration failures, storage capacity, backup status, suspicious access, performance and error rates.
3. Alert on actionable conditions with severity, owner, runbook and escalation; avoid alerts that disclose protected content.
4. Define incident, problem, change, release and service-continuity processes consistent with DEC-060–062 and DEC-066.

### I. Quality verification
1. Derive measurable acceptance criteria for each quality attribute and critical journey; test positive, negative, boundary, concurrency, permission-denied, failure/recovery and degraded-network cases.
2. Include threat modelling, security testing, dependency scanning, accessibility evaluation, localization/RTL checks, load/stress/soak tests, backup-restore drills and integration contract tests.
3. Verify that performance and security controls do not bypass workflow authority, audit, revision immutability or data segregation.
4. Record test environment, dataset characteristics, tool/version, results, exceptions, residual risks and approvals. No production testing or release is authorized by this design decision.

**Open details requiring approval:** service tiers and availability objectives; numeric latency/throughput/concurrency budgets; RPO/RTO and backup schedule; data residency and cryptographic/key-management standards; supported browsers/devices; accessibility conformance target; security assurance/certification requirements; retention schedules; operational support hours and escalation; capacity assumptions and cost envelope.

**Dependencies:** DEC-020/021/047–066/071/092/093/096 and all module-specific workflows.

**Implementation boundary:** requirements/design only. No architecture selection, infrastructure provisioning, security configuration, code/UI/API/database/storage changes, migration, production test, merge or deployment is authorized.


## 14.59 DEC-098 — Test Strategy, Verification Governance & Acceptance Criteria

**Decision:** Establish a risk-based, traceable test and acceptance framework for SiteDocs Operations, Finance and shared Core services. Testing must prove not only that intended actions work, but that unauthorized actions fail safely, records remain consistent, history is preserved and recovery is possible. This is a strategy and acceptance baseline; it does not authorize execution against production or implementation changes.

### A. Verification principles and traceability
1. Every approved requirement, decision, role permission, workflow transition, calculation rule, integration contract and quality attribute must map to one or more verifiable acceptance criteria and test cases.
2. Maintain bidirectional traceability: requirement/DEC → risk → test scenario → expected result → evidence → defect/exception → retest → approval. Untested or waived criteria remain visible; no implied pass.
3. Define test scope, owner, independent reviewer, environment, build/version, configuration, dataset, prerequisites, expected result, evidence and exit decision before execution.
4. Use risk-based prioritization: authorization, financial correctness, record integrity, signatures, document lifecycle, privacy and recovery are high-impact areas requiring stronger negative and boundary testing.
5. Separate test data from production data. Use synthetic or formally approved masked data; prohibit uncontrolled copies of personal, payroll, banking, supplier-confidential or project-commercial data.
6. A test result is valid only for the exact build, configuration, permissions, data snapshot and integration versions recorded in its evidence.

### B. Test levels and types
1. **Requirements/design reviews:** completeness, consistency, ambiguity, authority separation, edge cases and traceability reviews before implementation.
2. **Unit/component tests:** deterministic rules, calculations, validators, state transitions, permission predicates and error handling.
3. **API/service/contract tests:** request validation, authorization, idempotency, version compatibility, error mapping, integration contracts and data boundaries.
4. **Integration tests:** identity/Core, document/file storage, notifications, reporting, finance workflows and approved external systems using controlled test endpoints.
5. **End-to-end journey tests:** representative journeys for contractor, consultant, owner/developer, finance, PM, document control, supplier/material reviewers and administrators.
6. **Security/privacy tests:** authentication/session, privilege escalation, cross-project/party isolation, IDOR/object access, attachment/export/search leakage, injection, rate limits, secrets and audit protection.
7. **Data and migration tests:** canonical ID uniqueness, referential integrity, revision lineage, historical preservation, import reconciliation, duplicate detection and rollback/recovery. Any migration requires a separately approved plan and rehearsal.
8. **Non-functional tests:** load, stress, spike, soak, resilience, accessibility, localization/RTL, browser/device compatibility, backup/restore and disaster recovery.
9. **User acceptance testing (UAT):** authorized business representatives verify realistic workflows against agreed acceptance criteria; UAT sign-off is distinct from technical test completion and release approval.
10. **Regression tests:** rerun impacted critical suites after fixes, configuration changes, dependency upgrades or releases.

### C. Mandatory cross-cutting acceptance gates
1. **Identity and authorization:** each action is allowed only to the correct authenticated actor, project/party scope, capability and workflow state. Negative tests prove unauthorized users cannot retrieve or mutate records through UI, API, search, reports, exports, notifications or direct attachment references.
2. **Segregation of duties:** creator cannot approve own submission where prohibited; PM cannot mutate/review/approve/sign/pay by virtue of oversight; document control cannot make commercial/technical decisions; administrator cannot assume business authority.
3. **Workflow integrity:** invalid transitions are rejected server-side with no partial side effect; valid transitions record actor, timestamp, reason/evidence, exact revision and notification outcome. Silence never equals approval.
4. **Revision and audit integrity:** issued/approved records remain immutable; resubmission creates governed revisions; previous approvals remain bound to exact prior revisions; audit history is append-only and attributable.
5. **Financial correctness:** test decimal precision, rounding stages, tax/retention/advance/deduction rules, FX source/date/purpose, UOM conversions, allocations, negative/zero/large values, partial payments and reconciliation. Expected results must derive from approved versioned configuration; no universal tax or rounding assumptions.
6. **Document/file integrity:** upload, preview, download, versioning, transmittal and archive preserve correct file-to-record association, access scope, integrity metadata and revision. Failed upload/processing must not create a falsely complete record.
7. **Idempotency and concurrency:** duplicate clicks, retries, network timeouts, simultaneous approvals, numbering contention and repeated webhook/import events do not create duplicate business effects or inconsistent state.
8. **Recovery and resilience:** backup restore and failure simulations reconcile database records with object storage, IDs, versions, permissions, audit events and workflow state.
9. **Localization/accessibility:** critical journeys pass Arabic/English and RTL/LTR checks, locale presentation, keyboard navigation, focus, contrast and accessible error/status feedback against the approved target.
10. **Observability:** critical failures produce actionable, correlated telemetry without leaking protected data; alerts and runbooks are exercised.

### D. Module-specific scenario families
- **WIR/MIR and site operations:** all permitted outcomes; item-level and overall status consistency; Not Ready creates a linked new WIR; correction attempts preserve sequence and history; reinspection requires contractor confirmation; withdrawal only under permitted preconditions; MIR receipt/inspection remains distinct from material approval and payment.
- **RFI/MQR and document control:** independent numbering, permissions and workflows; draft confidentiality; MQR independent response model; transmittal manifest/revision fidelity; receipt/acknowledgement distinct from response or approval; archive/legal hold and supersession.
- **Supplier approval:** completeness, evidence expiry, conditional scope, suspension/requalification, project/category scope, conflict/duplicate supplier identity and confidentiality of internal evaluation.
- **Material approval:** exact material/manufacturer/source/revision, specification compliance, samples/tests, conditional restrictions, resubmission, substitution, supplier cross-check and delivered-versus-approved mismatch; approval does not auto-create PO or MIR acceptance.
- **Procurement/inventory:** commitment/PO authority, receipt/quantity/quality discrepancy, inventory movements, subcontract and material traceability without double counting.
- **Finance:** budget/commitment controls; measurement-to-application-to-assessment-to-certificate separation; invoice matching; advance/retention/tax/deduction schedules; split allocations; payment proposal/execution/receipt/reconciliation; claims/disputes and final-account snapshots.
- **Project oversight:** PM read-only visibility, including authorized drafts, must not expose prohibited mutation or decision actions.
- **Administration/integrations:** versioned configuration approval, permission recertification, API retries/idempotency, import validation and external-system failure isolation.

### E. Defect severity, triage and retest
1. Classify defects by impact, exploitability, scope, data loss/corruption, financial exposure, safety/contractual consequence and availability. Define severity taxonomy and response times in a separate approved test plan.
2. Critical authorization bypass, cross-project data exposure, unauthorized approval/payment, financial corruption, lost/altered official records or unrecoverable data integrity defects block acceptance.
3. Record reproduction steps, affected build/configuration, evidence, root cause, impact, remediation, regression scope and retest outcome.
4. Risk acceptance or waiver must identify owner, rationale, affected requirements, compensating controls, expiry/review date and authorized approver. No silent waiver.
5. Reopened or regressed defects invalidate the relevant acceptance evidence until retested.

### F. Test environments and release gates
1. Separate development, test/QA, UAT, staging/pre-production and production with governed identities, access, secrets, network boundaries and datasets.
2. Production data access for testing is prohibited by default; any exception requires privacy/security/legal approval, minimization and controlled handling.
3. Release candidate must have a fixed build identifier, configuration baseline, dependency inventory, migration/rollback plan where relevant, backup/recovery evidence, monitoring readiness and approved release authorization.
4. Exit requires all mandatory critical tests passed, no open release-blocking defects, approved residual-risk register, traceability completeness, UAT sign-off where required, security review and operational readiness.
5. Passing tests does not itself authorize merge, deployment, data migration or production activation; those require explicit separate approval.

### G. Evidence and reporting
Maintain a controlled test register with requirement/DEC reference, case ID, priority/risk, preconditions, steps, expected/actual results, pass/fail/blocked/not-run status, environment/build/configuration, data reference, execution timestamp, tester/reviewer, evidence link/hash, defect ID, retest and sign-off. Dashboards must distinguish test coverage from pass rate and must not count unexecuted tests as passed.

**Open details:** test tooling and ownership; test coverage thresholds; critical journey inventory; severity taxonomy and response targets; approved performance budgets; security assurance standards; accessibility conformance target; UAT representatives/sign-off; environment architecture; masked-data method; automation strategy; release gate approvers.

**Dependencies:** DEC-020/021/022/047–066/071/092–097 and all module-specific lifecycle/finance decisions.

**Implementation boundary:** test strategy/design only. No test execution, production probing, penetration testing against live systems, migration, import, code/UI/API/database/storage change, merge or deployment is authorized by this decision.

 
## 14.60 DEC-099 — SiteDocs Master Blueprint & Requirements Traceability

**Status:** Consolidated design blueprint recorded as a navigation and traceability baseline. It does not elevate the approval status of underlying decisions, close unresolved details, approve POL-DOC-001, or authorize implementation.

### A. Purpose, authority and interpretation
1. Establish one navigable, cross-domain blueprint connecting the recorded decision set (DEC-001–DEC-098) to product domains, logical capabilities, user journeys, requirements, dependencies, verification and approval gates.
2. Treat the three governance documents as a coordinated reference set: this proposal contains lifecycle/design detail; the Master Decision Register records decision intent/status; the Traceability Register maps decisions to capabilities, evidence and boundaries.
3. Preserve each source decision's own status and scope. “Recorded”, “baseline”, “proposed”, “open” and “approved” are not interchangeable. This blueprint is a consolidation aid, not blanket ratification.
4. POL-DOC-001 remains overall **PROPOSED — NOT APPROVED**. Any separately recorded component decision retains only its own stated status and authority.
5. Phase 1 scope recorded under DEC-023 is a scope baseline, not proof that screens, workflows, data structures, integrations or implementation are complete. Finance and other later domain decisions expand the design record but do not silently amend the Phase 1 approval boundary.

### B. Product-domain map
| Domain | Capability groups / subdomains | Principal decision anchors |
|---|---|---|
| SiteDocs Core & governance | Identity, project/team roster, role and capability authorization, configuration, audit, security, privacy, retention, operations, incident/change/release and continuity governance | DEC-020/021, DEC-055–067, DEC-056, DEC-060–066, DEC-097/098 |
| Project document control | Document identity/register, revisions, transmittals, correspondence, controlled distribution, acknowledgements, archive, search, templates and official reports | DEC-022, DEC-047–058, DEC-064/065, DEC-071, DEC-087, DEC-090 |
| Quality & site operations | WIR, MIR, NCR, SOR, DLR, Snag List, WPR, Test Results, MQR and distinct inspection/report workflows | DEC-023–049, DEC-045/046, DEC-071, DEC-098 |
| Engineering information | RFI and technical clarification lifecycle, separated from WIR; discipline routing and controlled technical records | DEC-023, DEC-021, DEC-048/049 and applicable lifecycle decisions |
| Procurement & supply chain | Supplier qualification, material submittals, procurement/PO, subcontract administration, delivery/receipt, inventory and traceability | DEC-070, DEC-082, DEC-088, DEC-094/095 |
| Finance & commercial control | Budget/commitment, measurement, applications, assessment/certification, invoices/payables, payment execution/receipt/reconciliation, payroll/expenses, tax/security schedules, claims, period close and final account | DEC-068/069, DEC-072–093 |
| Project oversight & closeout | PM oversight, progress/cost visibility, risk/variation/claims oversight, handover and closeout records | DEC-067–069, DEC-090/091 |
| Cross-cutting quality attributes | Security, privacy, availability, recovery, performance, integrity, accessibility, localization, compatibility, observability and support | DEC-059–066, DEC-097/098 |

The table is a logical domain map, not a finalized deployment topology or physical database schema. SiteDocs Operations, SiteDocs Finance, SiteDocs Core and any integration layer remain conceptual architectural boundaries unless separately approved.

### C. Record taxonomy and workflow invariants
1. Keep WIR and RFI independent in identity/numbering, forms, permissions, routing, review cycles and reporting. Keep MQR on its independent review path and do not impose A/B/C/D/E/I codes by default.
2. Preserve the five discipline codes ARC, CIVSTR, MEC, ELE and SUR; normalize legacy CIV/STR values only under the recorded compatibility rule, without rewriting historical identities or numbering.
3. Keep draft visibility restricted until formal submission, subject to the recorded read-only project-manager oversight exception. Visibility does not grant mutation, review, approval or signature authority.
4. Issue the official document number at first successful formal submission; retain internal draft identity separately. Keep revision identity distinct from WIR attempt suffixes. Revisions and attempts remain separately traceable and immutable under their respective lifecycle rules.
5. Preserve the WIR result/attempt model and the rule that Not Ready for Inspection leads to a new linked WIR, while Requires Correction follows the defined linked attempt sequence. Do not collapse item-level outcomes into the overall WIR state.
6. Keep transmittal dispatch, delivery and acknowledgement distinct; acknowledgement is not approval, receipt is not proof of reading, silence is not consent, and no implicit “latest revision” may replace an explicitly identified revision.
7. Keep supplier qualification, material approval, procurement award/PO, delivery receipt, MIR acceptance, installation and payment as distinct decisions/events. A supplier approval does not approve a material; a material approval does not award a contract or authorize payment.
8. Keep commercial agreement, measurement, payment application, assessment/certification, accounting recognition, payment execution and project closeout distinct and reconcilable. Progress percentage alone is not proof of payment entitlement.
9. Preserve append-only audit, historical records, exact revision lineage, controlled cancellation/withdrawal and archive/retention/legal-hold rules. Archive is not deletion.

### D. Roles, authority and segregation baseline
- Individual user identity and centrally governed project roster are the basis for access; no shared accounts or impersonation.
- Authorization is capability-based, deny-by-default and enforced server-side at the time of each action, not merely by hiding UI controls.
- Separate visibility, create/edit, submit, assign, review, approve, sign, distribute, archive, configure, export and financial execution capabilities.
- Apply segregation of duties and prohibit self-approval/proxy signing. A signature upload is not approval; an authenticated authorized approval action is required before a transaction-specific signature is applied.
- Project Manager oversight remains read-only, including the specifically permitted visibility of drafts; it does not confer authority to alter records or act for another party.
- Document Controller and administrative visibility do not create technical, commercial, payment or approval authority.
- Party roster capacities and categories are governed by the relevant roster decision; capacity is not an obligation to fill every slot or evidence of a required signature.

### E. Cross-domain ownership and dependencies
| Information / event | Owning capability (logical source of truth) | Downstream use; no implied authority |
|---|---|---|
| Person, project membership, role/capability | Core identity and project roster | All modules consume scoped identity; no module may widen authority |
| Official document, revision, lifecycle, transmittal and audit | Document-control capability | Quality, engineering, finance and closeout reference exact records/revisions |
| Inspection/quality outcome | Relevant quality workflow (e.g. WIR/MIR/NCR) | May inform progress/measurement; does not itself certify payment |
| Supplier qualification status | Supplier qualification capability | Procurement may enforce eligibility; no automatic award |
| Approved material and exact revision | Material submittal capability | PO, delivery, MIR and installed-location records link to exact approved source |
| Contract/VO/BOQ and commercial baseline | Governed contract/commercial records | Measurement and finance reference versioned contractual basis; no silent overwrite |
| Progress and measured quantities | Operational progress/measurement records | Finance consumes traceable quantities subject to separate assessment and approval |
| Application, certificate, invoice, payment and reconciliation | Separate finance subledgers/workflows | Linked by canonical IDs and allocations; one stage does not impersonate another |
| Configuration, currency, UOM and calculation policy | Versioned finance/configuration governance | Every calculation retains the policy/version and inputs used |
| Test result and acceptance evidence | Verification/test register | Supports acceptance gates; does not authorize release by itself |

Dependencies must be explicit and version-aware. Cross-module links reference canonical immutable IDs and exact revisions where applicable; business numbers are display/search attributes, not substitutes for canonical identity. No module may silently duplicate another module's authoritative state.

### F. User journeys and logical screen coverage
The blueprint groups screens by user task rather than assuming a finalized navigation design:
- **Project setup and access:** project selection, roster/invitations, role assignment, capability review and configuration change approval.
- **Operational execution:** discipline/project dashboards, task inbox, create/edit draft, submit, assign, inspect/review, respond, correct, resubmit and record history.
- **Document control:** registers, document detail/revision timeline, transmittal preparation/manifest, dispatch/receipt/acknowledgement, correspondence, search, archive and official report register.
- **Supply chain:** supplier onboarding/qualification, evidence/evaluation, material submittal/review/resubmission, procurement/PO, delivery/receipt, inventory and traceability.
- **Finance:** budget/commitment, measurement, payment application, assessment/certificate, invoice matching, payment proposal/execution, receipt/reconciliation, expenses/payroll, period close, claims and final account.
- **Oversight and closeout:** read-only management dashboards, risk/variation visibility, handover completeness and closeout reconciliation.
- **Cross-cutting states:** loading, empty, validation, denied access, conflict/concurrency, failed upload, retry, notification, audit history, Arabic/English and RTL/LTR presentation.

DEC-096 remains the detailed finance journey/screen baseline. Detailed screen inventory, transitions, field-level validation, responsive layouts and navigation remain subject to refinement and approval.

### G. Requirements-to-verification traceability model
Every implementable requirement should have a stable requirement ID and trace the following chain:
**Source DEC / clause → domain & capability → actor and authority → user journey / logical screen → data ownership and exact record/revision → workflow/state rule → risk/control → acceptance criterion → test case → evidence → defect/retest → authorized sign-off.**

Minimum traceability fields: requirement ID; source decision and clause; decision status; domain/module; capability; priority/risk; actor/permission; dependencies; acceptance criterion; test level/case ID; evidence reference/hash; implementation status; defect/waiver; reviewer and approval status. Distinguish “not designed”, “designed”, “implemented”, “verified”, “accepted” and “released”; do not infer a later state from an earlier one.

DEC-098 governs test levels, evidence and blocking gates. Critical authorization, confidentiality, financial integrity, official-record integrity and recoverability failures block acceptance. Passing tests do not by themselves authorize merge, deployment, migration or production activation.

### H. Approval gates and unresolved work
Before implementation, require (as applicable): approved scope and authority; resolved domain-specific open decisions; reviewed logical/physical architecture; security/privacy and segregation review; data ownership and migration plan; DB and object-storage backup plus isolated restore/reconciliation rehearsal before any DB change; test plan and acceptance thresholds; operational support/recovery readiness; and separate explicit approval for code changes, migrations, merge and deployment.

Open items remain open until assigned, resolved with evidence and approved by the proper authority. In particular, do not infer numeric SLO/RPO/RTO, retention periods, tax treatment, commercial authority thresholds, supplier scoring, material review codes, payment approval limits, accessibility conformance or release signatories where the underlying decisions leave them open.

### I. Scope and implementation boundary
This is a logical consolidation and traceability proposal only. It does not create a physical schema, API contract, deployment topology, screen implementation, migration, integration, test execution or production configuration. No code/UI/database/schema/RLS/storage/auth change, import, migration, merge or deployment is authorized. No backup or restore operation is claimed to have been performed. Each such activity requires its own reviewed plan and explicit authorization.

**Subsequent decision link:** DEC-101 adds the user-confirmed legacy naming/numbering continuity rule for Project Drawings (PDW), Project Documents (PDOC) and Meeting Minutes (MOM). It supplements this blueprint as a later decision; it is not represented as part of the original DEC-001–DEC-098 consolidation.

## 14.61 DEC-100 — Implementation Readiness, Work Packages & Controlled Delivery Plan

**Status:** Delivery-planning framework recorded. No work package is authorized to change code, infrastructure, data, access configuration or production state. Package sizing, owners, estimates, sequencing dates and release authorities remain to be confirmed.

### A. Purpose and governing principles
1. Translate the DEC-099 blueprint into bounded work packages with explicit outcomes, dependencies, readiness evidence, acceptance gates and stop conditions.
2. Use staged delivery: establish the baseline, validate scope and authority, prepare architecture and assurance, then implement only individually authorized packages.
3. Prefer vertical, independently verifiable slices over broad simultaneous rewrites. Preserve official records, immutable history, segregation of duties and cross-module source-of-truth ownership.
4. Do not treat this plan as a commitment to a schedule, staffing level, technology choice, architecture, procurement decision or production rollout.
5. A package may be “defined” or “ready for review” without being “approved”, “started”, “implemented”, “verified”, “accepted” or “released”. These states must remain explicit and separately evidenced.

### B. Readiness stages and gates
| Gate | Required evidence | Exit decision |
|---|---|---|
| G0 — Governance baseline | Current decision set and statuses; scope boundaries; unresolved-decision register; named decision owners/approvers | Baseline acknowledged; unresolved items remain visible |
| G1 — Requirements readiness | Requirement IDs, source DEC/clause, actor, workflow, acceptance criteria, dependencies, risk and traceability owner | Package requirements are sufficiently complete for architecture review |
| G2 — Architecture and security readiness | Logical architecture, trust boundaries, data ownership, identity/authorization model, threat/privacy review, integration contracts and operational design | Architecture/security approval by authorized reviewers |
| G3 — Data and migration readiness | Data inventory/classification, canonical-ID mapping, source-to-target reconciliation, migration rehearsal, rollback/recovery plan; for any DB change, DB backup and separate object-storage backup plus isolated restore/reconciliation rehearsal | Explicit data/change approval; no DB change before all required safeguards and approval |
| G4 — Build authorization | Bounded work package, implementation plan, repository/branch scope, reviewers, test plan, acceptance criteria, risk/rollback plan and explicit authorization | Only the specifically authorized package may begin |
| G5 — Verification and acceptance | Fixed build/configuration identity, traceable test evidence, defect status, security/accessibility/recovery evidence, UAT where required and authorized sign-off | Package accepted or returned for remediation |
| G6 — Release authorization | Release notes, deployment/rollback plan, backup/recovery readiness, monitoring/support ownership, communications and explicit release approval | Separate authorization to merge/deploy/activate |
| G7 — Operational review | Post-release health, incidents, audit integrity, reconciliation, user feedback and lessons learned | Continue, remediate, rollback or close under authorized governance |

A gate is not passed by the existence of a document alone. Evidence must be reviewed by the authorized role, and approval must be recorded. No inferred or blanket approval.

### C. Proposed work-package portfolio
| Package | Scope and deliverable | Principal dependencies | Readiness / acceptance focus |
|---|---|---|---|
| WP-00 — Baseline and decision closure | Confirm scope, decision statuses, open issues, owners, glossary and traceability index | DEC-099/100 and source decisions | No hidden conflicts; open items assigned or explicitly accepted as blockers |
| WP-01 — Product and security architecture | Logical components, trust boundaries, identity, authorization, audit, privacy, tenancy/project isolation and operational boundaries | WP-00; DEC-020/021/055–066/097 | Architecture and threat/privacy review; no physical design presumed approved |
| WP-02 — Core identity and project governance | Individual accounts, project roster, invitations, membership states, capabilities, configuration governance and access review | WP-01; DEC-020/021/056/063 | Negative authorization tests, segregation and PM read-only constraints |
| WP-03 — Document-control foundation | Canonical document identity, numbering, revisions, register, file association, audit, archive, search and controlled distribution/transmittals | WP-01/02; DEC-022/047–058/064/065/071/087/090 | Exact revision lineage, immutable history, access and transmittal/acknowledgement distinctions |
| WP-04 — Quality and site workflows | WIR, MIR, NCR, SOR, DLR, Snag List, WPR, Test Results and independent MQR; RFI remains a separate engineering workflow | WP-02/03; DEC-023–049 and DEC-098 | State-transition and role tests; WIR/RFI/MQR separation; item and attempt integrity |
| WP-05 — Supplier, material and procurement | Supplier qualification, material submittals, PO/commitment, subcontract, delivery/receipt, inventory and traceability | WP-02/03; DEC-070/082/088/094/095 | Independent supplier/material decisions; exact approved revision; no implied award/receipt/payment |
| WP-06 — Finance and commercial controls | Budget/commitment, measurement, application, assessment/certification, invoice, payment, reconciliation, expenses/payroll, claims, close and final account | WP-02/03/05; DEC-068/069/072–093 | Reproducible calculations, authority/SoD, allocations, reconciliation and audit evidence |
| WP-07 — Project oversight and closeout | Read-only management oversight, risk/variation visibility, handover and operational/commercial closeout | WP-03/04/05/06; DEC-067–069/090/091 | PM visibility without mutation; complete reconciled closeout records |
| WP-08 — Integration, import and migration | Approved external interfaces, import validation, canonical-ID mapping, reconciliation, retry/idempotency and cutover/rollback | WP-01–07 as applicable; DEC-057–059/065/093 | Contract tests, source/target reconciliation, duplicate prevention, recovery rehearsal and explicit data approval |
| WP-09 — Verification, release and operations | Test automation/strategy, security/accessibility/performance/recovery verification, support, monitoring, release and post-release review | Cross-package; DEC-060–066/097/098 | Evidence-based acceptance, no critical blockers, separate release authority |

This portfolio is a planning decomposition, not a mandatory delivery order in every detail. WP-00 and WP-01 are foundational. WP-02 is a prerequisite for controlled multi-user workflows. WP-03 is a common records foundation. WP-04, WP-05 and WP-06 may be sequenced or split into smaller slices only after dependencies and shared controls are validated. WP-07 depends on trustworthy source records. WP-08 is deliberately gated and may be deferred. WP-09 is continuous assurance, not a final afterthought.

### D. Package definition of ready and done
**Definition of Ready (DoR):**
- Scope, exclusions, intended users and accountable owner are explicit.
- Source decisions and statuses are linked; unresolved decisions affecting the package are closed or named as blockers.
- Requirements and acceptance criteria are testable and traceable.
- Dependencies, data owners, permission boundaries and affected integrations are identified.
- Threat/privacy, operational, accessibility/localization and recovery impacts are assessed as applicable.
- A bounded implementation and test plan, rollback approach and required approvals are prepared.
- The exact repository, branch, environment and change boundary are identified.

**Definition of Done (DoD):**
- Only the authorized scope was changed and the change is reviewable.
- Required tests and negative authorization/segregation checks pass with evidence.
- Audit, revision, canonical-ID and reconciliation requirements are demonstrated where applicable.
- No open critical/blocking defect remains; any permitted residual risk has explicit authorized, time-bounded waiver.
- Documentation, traceability, operational runbooks and support ownership are updated.
- Reviewer and acceptance authority sign off against a fixed build/configuration.
- Release remains a separate decision; DoD does not itself authorize deployment.

### E. Sequencing, slicing and prioritization
1. Prioritize foundational security, identity, canonical records, audit and recovery controls before dependent business workflows.
2. Deliver one bounded end-to-end workflow slice at a time, including permissions, record lifecycle, notifications, audit, reports/search and verification—not UI-only fragments.
3. Avoid parallel changes to shared authorization, canonical identity, document lifecycle or financial calculation foundations unless interface contracts and ownership are agreed.
4. Prioritize by risk reduction, legal/contractual importance, operational value, dependency centrality, reversibility and verification feasibility; do not invent numeric scoring weights.
5. Finance must be sliced by coherent subledger/workflow and reconciliation boundary. Do not launch payment execution merely because application or certification screens exist.
6. Defer optional integrations, automation and migration until source ownership, failure behavior, idempotency, recovery and approvals are established.

### F. Delivery controls and change boundaries
- Use isolated feature branches and reviewable commits; no direct production change. Branch protection, reviewer counts and CI policy require repository-owner approval and are not set here.
- Every change must reference its authorized work package, requirement IDs and source DEC decisions.
- Keep code, schema, generated types, API, authorization policy, storage and configuration changes within the specific approved scope.
- Any database change requires a separately reviewed plan, a verified database backup and a separate object-storage objects backup, isolated restore/rehearsal, reconciliation and explicit approval before execution.
- Migration/import requires source inventory, mapping, dry run, reconciliation, exception handling, rollback and data-owner sign-off.
- No shared secrets or production credentials in repository files, issues, logs or test evidence.
- A merge approval, deployment approval and data-change approval are distinct authorizations.

### G. Planning information still required
Package owners, delivery team/capacity, estimates, milestones, target environments, technology choices, architecture approval, deployment strategy, CI/security controls, test ownership, service objectives, UAT representatives, support model, data migration scope and release authorities remain open. No dates or delivery commitments are assigned by this decision.

### H. Explicit boundary
DEC-100 defines readiness and delivery governance only. It does not approve any package for implementation, allocate budget or staff, select vendors/technology, authorize production access, create or alter code/UI/API/auth/RLS/database/schema/storage, run migrations/imports/tests, merge branches or deploy. Each package requires its own scope review and explicit approval. POL-DOC-001 remains PROPOSED — NOT APPROVED.


## 14.62 DEC-101 — Project Reference Records: Legacy Naming & Numbering Continuity

**Status:** User-confirmed design rule recorded for Project Drawings (PDW), Project Documents (PDOC) and Meeting Minutes (MOM). The legacy naming/numbering convention is to be preserved; detailed pattern transcription remains subject to the supplied reference samples being available for direct verification.

### Decision
1. Treat Project Drawings, Project Documents and Meeting Minutes as three distinct Project Reference Record categories, represented by the abbreviations **PDW**, **PDOC** and **MOM**, respectively.
2. Preserve the legacy naming and numbering method demonstrated by the user's historical samples. The only intended change to the legacy identifier is replacement of the old document-type abbreviation with the applicable new abbreviation (PDW, PDOC or MOM).
3. Do not redesign, reorder, normalize or invent other identifier components, separators, sequence rules, prefixes, suffixes or formatting as part of this change. Retain the legacy pattern as supplied, including its component order and numbering behavior.
4. Keep the three categories separately identifiable in the relevant register/classification fields. Do not merge them into WIR, RFI, MQR, forms, financial records or one another.
5. Use the supplied historical samples as the controlling reference for internal metadata, naming and numbering behavior. Do not infer missing pattern details from a sample whose contents have not been inspected.
6. Preserve historical identifiers and records unchanged. This rule governs new controlled identifiers and classification; it does not authorize bulk renaming, renumbering, migration or overwrite of existing records.

**Verification requirement before implementation:** transcribe and validate at least one representative legacy identifier for each category from the actual supplied sample set; confirm the old type token and the exact one-for-one replacement while checking that every other character/component remains unchanged. If the samples are unavailable or ambiguous, mark the exact pattern as open and do not fabricate an example.

**Dependencies:** DEC-047/050–055/065/071/090/093/099; the source reference samples supplied by the user.

**Implementation boundary:** Design rule only. No register/schema/UI/API/storage/auth change, automated renaming, backfill, migration, import, merge or deployment is authorized. POL-DOC-001 remains PROPOSED — NOT APPROVED.
