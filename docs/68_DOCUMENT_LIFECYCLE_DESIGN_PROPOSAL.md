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
