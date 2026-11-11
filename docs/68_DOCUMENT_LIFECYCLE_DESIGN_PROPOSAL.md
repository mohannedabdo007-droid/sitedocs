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
