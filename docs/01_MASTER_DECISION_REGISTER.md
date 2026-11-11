# PROJECT DOC CONTROL — Master Decision Register

**Register ID:** REG-DEC-001  
**Version:** 1.2  
**Effective date:** 2026-11-11  
**Status:** CURRENT / APPROVED BASELINE  
**Controlling directive:** [POL-GOV-001 — Current Approved Governance Directive](00_CURRENT_APPROVED_GOVERNANCE_DIRECTIVE.md)  
**Branch:** governance/current-approved-baseline-2026-11-11  
**Purpose:** Trace approved business decisions, identify superseded wording, preserve historical evidence, and direct future reconciliation work.

> This register records decisions approved by the project owner. It is not evidence that the current source code, migrations, live database, or deployed application already complies. Static findings below must remain clearly distinguished from approved target behavior.

## Status vocabulary

- **APPROVED** — current approved rule; implementation must follow it.
- **APPROVED-REVISED** — current rule explicitly replaces an older interpretation.
- **ARCHIVE-ONLY** — historical material preserved for traceability; not valid implementation authority.
- **DIAGNOSTIC-EVIDENCE** — a report describing observed source state; preserve its factual findings until independently re-verified.
- **UNRESOLVED** — requires a separate decision; agents must not invent a rule.
- **PROPOSED** — recommendation only; not approved until the owner explicitly approves it.

## Decision register

| Decision ID | Current approved decision | Status | Previous/superseded interpretation | Evidence / controlling reference | Required document treatment |
|---|---|---|---|---|---|
| DEC-001 | WIR means Work Inspection Request and is the request to inspect executed work. | APPROVED | Do not conflate it with RFI or engineering clarification. | POL-GOV-001 §2; approved project discussions. | Update current requirements/specification copies; preserve old references as historical with a separate supersession note. |
| DEC-002 | RFI means Request for Information: an engineering inquiry/clarification. It is fully separate from WIR in forms, numbering, permissions, lifecycle, reporting, and audit trail. | APPROVED-REVISED | “RFI = Request for Inspection” is superseded and must not be used as current behavior. | POL-GOV-001 §2; project-owner confirmation on 2026-11-11. | Correct current baseline, requirements, roadmaps, matrices, prompts, and agent instructions. Preserve original documents; mark/index conflicting copies as superseded rather than silently rewriting them. |
| DEC-003 | MQR means Monthly Quality Report and has an independent review workflow. General A/B/C/D/E/I response-code behavior is not applied by default. | APPROVED-REVISED | “Material Quality Report” and use of the generic response-code workflow are superseded. | POL-GOV-001 §2 and §6; source-state diagnostic docs/64. | Current requirements must say Monthly Quality Report and independent workflow. Preserve diagnostic report 64 unchanged as evidence of the inspected seed/source defect. |
| DEC-004 | The five current selectable disciplines are ARC, CIVSTR, MEC, ELE, SUR. Civil & Structural is one discipline. | APPROVED-REVISED | Separate CIV and STR as current selectable disciplines is superseded. | POL-GOV-001 §3; docs/06_DISCIPLINE_AND_NUMBERING_AUDIT.md. | Align current reference-data requirements and UI/import/report specs. Preserve legacy identifiers and historical numbers; do not merge numbering streams without inventory, collision analysis, recovery plan, and explicit approval. |
| DEC-005 | Legacy CIV and STR values remain historically traceable and map to canonical CIVSTR for current selectors/imports/filters/reports/KPIs through a controlled compatibility strategy. | APPROVED | Destructive rewrite or automatic renumbering is not authorized. | POL-GOV-001 §3; docs/06. | Document compatibility mapping and tests. Preserve raw historical values and issued numbers. |
| DEC-006 | For document types configured to use the general response-code workflow, E means Cancelled by Contractor and may be initiated only by the originating contractor under explicit authority checks. | APPROVED-REVISED | E as reviewer response, generic close, “Reviewed – no further action”, or admin bypass is invalid. | POL-GOV-001 §4 and §6; docs/63; docs/05_RPC_WORKFLOW_SOURCE_AUDIT.md. | Preserve docs/63 and docs/05 as diagnostic evidence. Update current workflow requirements and acceptance tests. |
| DEC-007 | For applicable general workflows, I means For Information Only, closes the applicable review cycle, and preserves the document in the archive. It is not a B/C KPI result. | APPROVED-REVISED | I as a generic “proceed” state without guaranteed cycle closure/archive is insufficient. | POL-GOV-001 §4; docs/63. | Update current workflow/KPI specifications and tests; retain docs/63 unchanged as source evidence. |
| DEC-008 | Drafts are confidential to their originating party before formal submission, with the explicit project-manager oversight exception below. | APPROVED | Project membership alone is not sufficient reason to expose another party's draft or its files. | POL-GOV-001 §5; docs/51, 52, 53, 54. | Current access-control requirements must include document-level and attachment-level visibility. Keep security reviews as diagnostic evidence. |
| DEC-009 | Project Manager may view all project documents, including drafts, for oversight only; visibility is read-only and grants no edit, submit, review, response, approval, cancellation, or closure authority. | APPROVED | Read visibility must not be interpreted as workflow authority or general admin authority. | POL-GOV-001 §5; prior explicit owner decision. | Add separate PM read-only tests to permission matrix and acceptance catalogue. Do not silently equate PM with company admin or project admin. |
| DEC-010 | No self-approval; an originator must not issue a review decision on their own document where separation of duties applies. | APPROVED | No role or admin convenience bypass. | POL-GOV-001 §5; docs/05 and docs/59. | Keep diagnostic findings; add direct API/server-side negative tests. |
| DEC-011 | Membership party and project role are separate authorization dimensions. Admin must not bypass party/workflow boundaries. | APPROVED | Admin as universal reviewer or submitter on behalf of another party is not allowed. | POL-GOV-001 §5; docs/05, docs/59, src/lib/domain.ts finding. | Update permission matrix and server-side acceptance tests. Preserve source findings until fixed and re-tested. |
| DEC-012 | Superseded decisions and files must not be deleted or silently overwritten. Preserve originals; access/reuse of archive material requires concrete need and explicit user permission. | APPROVED | Routine reliance on old archive content or automatic reactivation is not allowed. | POL-GOV-001 §1; explicit owner approval on 2026-11-11. | Maintain separate archive/supersession index and annotations. Do not alter forensic diagnostic reports or historical snapshots. |
| DEC-013 | A diagnostic report that accurately describes a source defect must remain intact as evidence; the approved target behavior is recorded separately. | APPROVED | Do not rewrite audit findings to make historical code appear compliant. | POL-GOV-001 §1 and §6. | Preserve reports 05, 51–64 and related source reviews as applicable; append a separate remediation status record only after verified changes. |
| DEC-014 | No database/schema/migration/generated-type/production change without required backup, successful isolated restore, reviewed exact plan, authorized ownership workflow, and separate explicit user approval. | APPROVED | A general “continue” instruction is not authorization to bypass safety gates or repository ownership controls. | POL-GOV-001 §1 and §9; PHASE_0_BACKUP_RESTORE_CHECKLIST.md; AGENTS.md constraints. | Keep migration and DB work blocked until all gates are met. No claim of live DB state based solely on static SQL review. |
| DEC-015 | Current approved definitions take precedence over old reports, seed labels, prompts, comments, generated files, and agent assumptions for current business behavior. | APPROVED | Historical material does not automatically override current owner decisions. | POL-GOV-001 §1 and §7. | Require all agents/tools/reviewers to read the directive before acting; link it in project issues and PRs. |

## DEC-016 — Primary scanned file and additional scan attachments

| Decision ID | Approved decision | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-016 | Each transaction/document may have one designated primary scanned file and zero or more additional scanned files. Each file is linked to the transaction's stable document identity; where applicable, it is also linked to the exact revision. The short file name is displayed in the transaction's register row and opens the selected file in an authorized viewer. | APPROVED — owner decision, 2026-11-11 | Scanned copies are supporting records, not numbering inputs or workflow events. A file upload/open action must not change document number, revision sequence, review status, response code, approval authority, or KPI counts. Preserve previous revision/file associations; do not silently replace historical files. | Explicit owner approval in conversation, 2026-11-11. | Add a dedicated scan-file relation and register column in a separately reviewed implementation. Enforce private project/document-scoped storage and authorization on every preview/download. Keep one primary designation per transaction, allow additional files, and retain revision association where applicable. File types/size limits, uploader/deleter permissions, retention, and replacement/version policy require a separate technical/policy proposal before implementation. No DB/migration/storage policy changes are authorized by this decision alone. |

## DEC-017 — Paper scanning and in-SiteDocs electronic signature lifecycle

| Decision ID | Approved decision | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-017 | The paper route may enter final scanning only after all required paper signatures and approvals are complete. The electronic route uses signatures/approvals inside SiteDocs from each person's own authenticated account and assigned permissions. The detailed lifecycle is governed by POL-SCAN-003, subject to its listed open items and implementation gates. | APPROVED — route selections; detailed design submitted for review, 2026-11-11 | The final archival PDF for the in-SiteDocs route is generated after the last required signature and final approval. The content snapshot is frozen before signing; final PDF generation/validation is a separate records-finalization stage. Paper route includes a pre-scan completeness gate and post-scan quality control. This decision does not establish legal enforceability or authorize technical changes. | Explicit owner approval in conversation, 2026-11-11. | Maintain separate paper/electronic route states; bind all signatures/files to the exact document and revision; preserve audit history and immutable final records. No database, migration, Storage, auth, or production change is authorized. |

## DEC-018 — Reusable and per-transaction personal signature assets

| Decision ID | Approved decision | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-018 | SiteDocs must support both (a) a reusable personal signature asset saved in the user's own account and (b) a different signature asset uploaded for an individual transaction. Both PDF and JPEG uploads are supported. Every asset and every applied visual signature must be attributable to its owner and linked to the exact approval/document revision record. Applying the asset requires an explicit authorized signing action by that same authenticated user. | APPROVED — owner decision, 2026-11-11 | Uploading a signature file alone is not an approval. A visual mark is not by itself cryptographic identity proof or legal enforceability. PDF signature-source files require a reviewed page/region selection or equivalent placement method; no blind multi-page stamping. | Explicit owner approval in conversation, 2026-11-11. | Add a private personal signature library and one-off transaction upload capability in a separately reviewed design/implementation. Preserve asset versions and completed signature history. No DB/schema/Storage/auth/PDF service change is authorized by this decision. Detailed controls are in POL-SCAN-003 §12. |

## Unresolved decisions — do not invent

| Decision ID | Unresolved item | Required next step |
|---|---|---|
| UNR-001 | Exact MQR stages, actor sequence, status names, and outcome vocabulary. | Prepare a dedicated MQR workflow proposal and acceptance matrix for owner approval. Do not reuse general response codes by default. |
| UNR-002 | Full project-specific configuration model and validation constraints for document types, numbering, and workflows. | Inventory current source/configuration read-only; propose versioned configuration and non-retroactivity rules. |
| UNR-003 | Detailed B/C/D semantics and their project-specific permitted transitions, beyond the approved high-level response-code model. | Reconcile current contractual procedures and obtain owner approval where not already specified. |
| UNR-004 | Exact archival retention periods and authorized archive custodians. | Propose retention/access policy separately; do not invent statutory or contractual periods. |
| UNR-005 | Production database identity/state and verified backup/restore readiness. | Identify the actual backend and environment, take independent backup, restore to isolated environment, and verify before any migration proposal. |

## Evidence classification and handling

### A. Historical documents containing superseded or conflicting business wording
Initial known list; not an exhaustive search:
- docs/03_IMPLEMENTATION_READINESS_REVIEW.md
- docs/04_SECURITY_REMEDIATION_SPEC.md
- docs/07_MASTER_REMEDIATION_ROADMAP.md
- docs/09_PULL_REQUEST_1_REVIEW.md
- docs/11_APPLICATION_REQUIREMENTS_GAP_REVIEW.md
- docs/12_LOVABLE_KNOWLEDGE_ALIGNMENT.md
- docs/14_EXPANDED_STATIC_AUTHORIZATION_AUDIT.md
- docs/17_REFERENCE_DATA_AND_WORKFLOW_CONFIGURATION_DRIFT.md
- docs/20_WORKFLOW_AUTHORITY_SELF_APPROVAL_AND_KPI_REVIEW.md
- docs/21_CURRENT_APPROVED_BASELINE_AND_SUPERSEDED_RULES.md
- docs/22_CONSOLIDATED_REMEDIATION_MASTER_MATRIX.md
- docs/24_OPEN_POLICY_DECISIONS_AND_RECOMMENDED_RESOLUTIONS.md
- docs/CLAUDE_INDEPENDENT_REVIEW.md

**Treatment:** Preserve each original. Create a corrected current copy or a separate supersession note/index. Do not claim all files have already been reconciled.

### B. Diagnostic documents describing observed source defects
Examples:
- docs/05_RPC_WORKFLOW_SOURCE_AUDIT.md
- docs/35_MIGRATION_LINEAGE_SCHEMA_SOURCE_AND_TYPE_GENERATION_REVIEW.md
- docs/51_DRAFT_CONFIDENTIALITY_RLS_AND_AUDIT_DISCLOSURE_REVIEW.md
- docs/52_DOCUMENT_STORAGE_OBJECT_AUTHORIZATION_AND_VISIBILITY_REVIEW.md
- docs/53_SIGNED_URL_LIFECYCLE_AND_DOWNLOAD_AUTHORIZATION_REVIEW.md
- docs/54_ATTACHMENT_LIFECYCLE_DELETION_REPLACEMENT_RETENTION_AND_ORPHAN_REVIEW.md
- docs/57_SECURITY_DEFINER_RPC_EXECUTE_PRIVILEGES_AND_AUTHORIZATION_REVIEW.md
- docs/58_SECURITY_DEFINER_SEARCH_PATH_AND_INTERNAL_BYPASS_FLAGS_REVIEW.md
- docs/59_DOCUMENT_WORKFLOW_SEPARATION_OF_DUTIES_AND_ADMIN_BYPASS_REVIEW.md
- docs/60_DOCUMENT_REVIEW_HISTORY_IMMUTABILITY_AND_RECORD_INTEGRITY_REVIEW.md
- docs/61_PROJECT_WORKFLOW_CONFIGURATION_VALIDATION_AND_PARTY_SEQUENCE_INTEGRITY_REVIEW.md
- docs/62_SEEDED_REFERENCE_DATA_DRIFT_AGAINST_APPROVED_DOMAIN_RULES.md
- docs/63_RESPONSE_CODE_SEMANTIC_INTEGRITY_AND_CANCELLATION_AUTHORITY_REVIEW.md
- docs/64_MQR_INDEPENDENT_WORKFLOW_AND_RESPONSE_CODE_ISOLATION_REVIEW.md

**Treatment:** DIAGNOSTIC-EVIDENCE. Preserve findings exactly. Add verified remediation status separately only after source changes and tests.

### C. Immutable historical snapshots
- backup/database-seed-snapshot.json
- migration files and migration journal
- historical numbering and issued document records

**Treatment:** ARCHIVE-ONLY / immutable evidence. Do not retrofit current business labels into historical snapshots. Use a separate correction note.

### D. Compatible reference material
- docs/06_DISCIPLINE_AND_NUMBERING_AUDIT.md

**Treatment:** Preserve as compatible technical evidence. Its warnings about legacy codes, numbering streams, collision analysis, and non-destructive migration remain relevant.

## Work sequence

1. Publish and reference POL-GOV-001 and this register.
2. Complete a read-only inventory of all current project documents and agent instructions for conflicting business definitions.
3. Build a file-by-file reconciliation plan: preserve original, issue current replacement, or add supersession annotation.
4. Build a decision-to-requirement-to-source-to-test traceability matrix.
5. Verify current source state and distinguish it from the target baseline.
6. Keep database changes blocked until backup/restore and explicit approval gates are satisfied.
7. Reconcile documentation and implementation in small reviewable changes; do not merge/deploy without explicit approval.

## Change log

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-11-11 | Initial register of current approved decisions, superseded interpretations, unresolved items, and evidence-handling rules. |
| 1.1 | 2026-11-11 | Added DEC-016 for one primary scanned file plus additional scan attachments per transaction, with isolated storage/access and no workflow or numbering side effects. |
| 1.2 | 2026-11-11 | Added DEC-017 for paper scanning only after paper approvals and in-SiteDocs account-based electronic signatures; linked detailed lifecycle design POL-SCAN-003. |

**End of register.**


## DEC-019 — Multi-party signature rosters and role-specific slots

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-019 | Signature workflow supports up to 10 contractor signatory slots, up to 10 consultant slots, and up to 5 developer/owner slots. Specialty/role categories are repeatable: one specialty may have multiple individually assigned signers (e.g. three contractor ELE engineers), each with a separate slot, account, signature action, and approval audit record. Required/optional status, actual people, role-to-document mapping, and signer sequence are configured per project/contract. | APPROVED DESIGN DIRECTION — 2026-11-11; multiplicity clarification added 2026-11-11 | The nine contractor role categories named are categories, not a one-person-per-category limit. Slot 10 remains configurable/optional until its role is specified. The 10/10/5 figures are party roster capacities, not fixed counts per specialty or mandatory signer counts for every document. Repeated people consume separate individual slots. Any quorum/representative rule or capacity increase requires explicit configuration approval. | Explicit owner direction in conversation, 2026-11-11. | Design repeatable specialty assignments and per-person signer slots within each party roster; never combine multiple engineers into one signature slot. Select required individuals per document workflow. Detailed rules in POL-SCAN-003 §13. No implementation or DB changes authorized. |


## DEC-020 — Central project team roster and authenticated individual registration

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-020 | SiteDocs must provide a central, party-scoped Project Team Roster to register named project personnel and link each person to their own authenticated SiteDocs account and active project/party/role assignment. Support Contractor (up to 10), Consultant (up to 10), and Developer/Owner (up to 5) roster capacities in line with DEC-019; multiple people may share a specialty, with a distinct person/assignment identity for each. Only active, accepted, account-linked assignments may be selected as signer candidates. Document-specific workflow selection and action-time authorization remain mandatory. | APPROVED DESIGN DIRECTION — 2026-11-11 | A central roster avoids repeatedly typing names into transaction signature fields and provides accountable person-level assignment. A name alone, shared account, or administrator-entered identity is not sufficient for signing. Roster management does not grant blanket document access or signing authority. | Explicit owner approval in conversation, 2026-11-11. | Design party-scoped roster management, authenticated invitation/account linking, active/suspended/ended assignment lifecycle, and integration with DEC-019 person-level signer slots. Roster management, document access, and approval/signing permissions remain separate. Detailed rules in POL-SCAN-003 §14. Design only; no implementation or DB changes authorized. |

 
## DEC-021 — Capability-based permission matrix

| Decision ID | Proposed direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-021 | Adopt a deny-by-default, capability-based authorization model. Separate roster administration, document visibility, draft visibility, authoring, submission, review, approval, individual signing, attachment operations, records archiving, and audit reading. Evaluate project/party/document/revision/workflow scope and separation-of-duties rules server-side at every action. | APPROVED DESIGN DIRECTION — 2026-11-11 | Prevents project membership, job title, specialty, roster management, or PM oversight from becoming blanket access or approval authority. The proposed capability catalogue and acceptance scenarios are in POL-SCAN-003 §15. | Explicit owner approval in conversation, 2026-11-11. | No permission grants or role templates are activated. No DB/RLS/Storage/auth/API/UI/code changes. Detailed grant authority, role bundles, combined responsibilities, emergency access, and audit/denial settings remain to be specified before implementation; the approved separation principles remain controlling. |


## DEC-022 — Common controlled document lifecycle framework

| Decision ID | Proposed direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-022 | Adopt a common controlled-document lifecycle framework from draft and validation through formal submission, review, correction/resubmission, approval, final records processing, issue/transmittal, archive, and supersession. Preserve separate workflow profiles and semantics for WIR, RFI, MQR, and other document families. | PROPOSED — partial component DEC-022-A approved; framework remains under owner review; 2026-11-11 | Provides consistent control gates without forcing distinct document families into one generic state machine. Official numbering rule is separately approved in DEC-022-A / POL-DOC-001 §12. Per-type actions, review sequence, return/reject/cancel semantics, issue/transmittal, retention, closure, and legacy-record mapping remain unresolved. Revision numbering and resubmission behavior are separately approved in DEC-022-B / POL-DOC-001 §12. | Assistant-prepared proposal; owner explicitly approved DEC-022-A only on 2026-11-11. | Do not treat the overall lifecycle framework as approved. Only the internal-draft-ID / official-number-at-first-successful-submission / no-number-consumed-by-abandoned-draft rule and the revision rules in DEC-022-B are approved. No numbering logic or other implementation is authorized. |


## DEC-022-B — Revision numbering and resubmission after return

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-022-B | First formal issue is Rev.00. A controlled-content change after return/correction creates the next sequential revision (Rev.01, Rev.02, ...). Resubmission without controlled-content change retains the same revision. Each revision preserves its own immutable content snapshot and review/approval/signature/audit history; prior revisions are not overwritten, and signatures/approvals never carry across revisions. The official document number remains stable across revisions. | APPROVED COMPONENT — 2026-11-11 | Separates document identity from content revision and prevents approvals/signatures from being misapplied to changed content. Minor/major labels and metadata-only change treatment remain open for document-type profiles. | Explicit owner approval in conversation, 2026-11-11. | Design rule only. No revision engine, database/schema, migration, generated type, UI/API/code, test, merge, or deployment changes authorized. |


## DEC-024 — Flexible WIR scope and item-level inspection outcomes

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-024 | A WIR may cover one or multiple activities and/or locations, or use an open/general scope; location/activity selection is optional and companies may choose consolidated or separate requests. Where a WIR contains multiple scope items, inspection outcomes and follow-up are recorded per item. Accepted items retain their outcomes while correction-required items remain open for correction and re-inspection; the whole WIR is not closed merely because some items are accepted. | APPROVED REQUIREMENTS — 2026-11-11 | Supports different contractor/company operating practices without forcing one WIR per location/activity, while preserving traceable inspection evidence and independent corrective-action follow-up for each item. | Explicit owner approval in conversation, 2026-11-11. | Design flexible WIR scope items, item-level outcomes and follow-up, and an overall status reflecting outstanding items. Detailed WIR fields, states, validation, roles, and closure rules remain open. No implementation or DB changes authorized. Detailed requirements in POL-DOC-001 §14. |

## DEC-023 — Phase 1 document-type catalogue and control modules

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-023 | Approve the Phase 1 controlled-document catalogue: WIR (Work Inspection Request), MIR (Material Inspection Request), RFI (Request for Information), NCR (Non-Conformance Report), SOR (Site Observation Report), DLR (Daily Labour Report), MQR (Monthly Quality Report), Snag List, WPR (Weekly Progress Report), and Test Results. Also approve Incoming/Outgoing Correspondence, Transmittals, Document Register, Archive, and Reports & KPI as separate control modules/capabilities, not additional document types. | APPROVED SCOPE — 2026-11-11 | Establishes an explicit initial operating scope while allowing later incremental additions. WIR/RFI remain fully separate; MQR retains its independent review lifecycle. Approval of scope does not approve detailed per-type forms, fields, validation, workflow, permissions, retention, or implementation. | Explicit owner approval in conversation, 2026-11-11. | Design distinct type profiles and module boundaries; do not force all types into one generic workflow. Additional types require later approval. No DB/schema/migration/generated type, Storage, auth/RLS, API/UI/code, tests, merge, or deployment changes authorized. Detailed catalogue and boundaries in POL-DOC-001 §13. |


## DEC-025 — WIR item-level inspection outcome vocabulary

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-025 | Adopt four independent outcomes for each WIR inspection item: Accepted; Accepted with Comments; Requires Correction; and Not Ready for Inspection. Do not add a separate generic Rejected outcome at this stage. Outcomes remain item-specific; one item's result does not overwrite another's, and the overall WIR remains active while required item-level correction/re-inspection or other follow-up is outstanding. | APPROVED REQUIREMENTS — 2026-11-11 | Distinguishes acceptance with non-blocking comments, required corrective action, and inability to inspect due to lack of readiness, while preserving partial acceptance in multi-item WIRs. | Explicit owner approval in conversation, 2026-11-11. | Define item-level result capture and overall status derivation consistently with DEC-024. Detailed transitions, evidence, corrective-action and re-inspection rules remain open. No implementation or DB changes authorized. Detailed vocabulary in POL-DOC-001 §14. |


## DEC-026 — New WIR required after Not Ready for Inspection

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-026 | If a WIR inspection item receives **Not Ready for Inspection**, the contractor must submit a new WIR for that item after readiness; the original item is not merely rescheduled/reused. Preserve the original WIR and outcome, do not reuse its official number, and link the new WIR to the original WIR/item. In a multi-item WIR, this applies only to the Not Ready item; other items retain their own outcomes and workflow. | APPROVED REQUIREMENTS — 2026-11-11 | Keeps the record of an unsuccessful readiness attempt intact and gives the later inspection a distinct, traceable formal request without disrupting other items in a consolidated WIR. | Explicit owner approval in conversation, 2026-11-11. | Design successor/follow-up linkage and item-specific handling. Exact closure/display rules remain open. No implementation or DB changes authorized. Detailed rule in POL-DOC-001 §14. |


## DEC-027 — Formal WIR correction rejection and sequential re-inspection attempts

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-027 | Keep exactly the four DEC-025 outcomes; do not add a fifth **Rejected** outcome. **Requires Correction** is the formal consultant rejection disposition, with its rationale/findings and decision history preserved. For correction/re-inspection, create distinct linked attempts in one WIR series: WIR-00, WIR-01, WIR-02, and onward. Each attempt links to its predecessor and preserves its own outcomes, evidence, comments, decisions, attachments, and audit history. The attempt suffix is separate from the official WIR number and content revision. | APPROVED REQUIREMENTS — 2026-11-11 | Preserves every consultant rejection and re-inspection as a traceable record without expanding the approved four-outcome vocabulary or overwriting earlier attempts. | Explicit owner approval in conversation, 2026-11-11. | Design a sequential attempt series for correction-required items; do not reset accepted items in a multi-item WIR. Not Ready for Inspection remains governed separately by DEC-026 and requires a new WIR with a new official number. Detailed presentation/configuration and closure rules remain open. Design only; no implementation or DB changes authorized. Detailed requirements in POL-DOC-001 §14.3. |


## DEC-028 — WIR requested inspection date and optional time

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-028 | A requested inspection date is mandatory on every WIR. Requested time is optional: the submitter may provide date plus a specific time, or date only. Missing date blocks formal submission; missing time does not. Do not infer or silently assign a time for date-only requests. Preserve the entered date and optional time in the WIR record and audit history. | APPROVED REQUIREMENT — 2026-11-11 | Keeps a definite inspection date for planning and traceability while allowing contractors to submit without committing to a specific time. | Explicit owner approval in conversation, 2026-11-11. | Implement date-required/time-optional validation in the WIR type profile. Scheduling windows, timezone display, and rescheduling rules remain open. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.4. |


## DEC-029 — Consultant-side WIR inspection engineer assignment

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-029 | The contractor is not required to select or nominate a consultant inspection engineer when submitting a WIR. After receipt, the consultant organization selects and assigns the appropriate eligible engineer or inspection team according to discipline/scope, active project assignment, availability, and granted permissions. Record assignment/reassignment, assigner, assignee(s), and timestamps in the WIR audit history. Assignment alone does not grant unrelated document or approval capabilities. | APPROVED REQUIREMENT — 2026-11-11 | Keeps responsibility for consultant-side resource allocation with the consultant while avoiding a submission dependency on knowing its internal roster. | Explicit owner approval in conversation, 2026-11-11. | Contractor submits without engineer nomination; consultant performs and records assignment after receipt. Assignment roles, delegation, notifications, reassignment conditions, and service-level scheduling remain open. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.5. |


## DEC-030 — Flexible reassignment of the consultant inspection engineer

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-030 | The consultant may reassign a WIR inspection to another eligible consultant engineer or team whenever operationally necessary. Reassignment is performed by an authorized assignment manager; replacement assignees must have an active project assignment and relevant permissions. A reason may be recorded but is not mandatory. Preserve the assigner, previous and new assignee(s), timestamp, and any supplied reason as immutable assignment history. Reassignment never rewrites prior findings, comments, evidence, decisions, signatures, or actor attribution. | APPROVED REQUIREMENT — 2026-11-11 | Provides operational flexibility while maintaining traceability and preserving each person's actions and authority boundaries. | Explicit owner approval in conversation, 2026-11-11. | Support flexible reassignment without unnecessary fixed-assignee restrictions or mandatory reason entry. Distinguish current assignment from historical events; assignment alone grants no unrelated access or approval authority. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.6. |


## DEC-031 — Optional target date for WIR corrective action

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-031 | When a WIR inspection item receives **Requires Correction**, the consultant may specify a target completion date for the contractor's corrective action, but the date is optional. Leaving it blank must not block recording or issuing the correction requirement or continuing the applicable workflow. If supplied or later changed, preserve the setter, timestamp, and prior values in traceable history. The target date is a planning/control date only; it does not alter the inspection outcome, grant an extension, or close the action. | APPROVED REQUIREMENT — 2026-11-11 | Allows practical, case-specific corrective-action planning without imposing an inflexible deadline on every observation. | Explicit owner approval in conversation, 2026-11-11. | Support an optional target date, preserve its change history, and keep corrective-action responsibility with the contractor. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.7. |


## DEC-032 — Optional evidence of WIR corrective action

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-032 | The contractor may attach photographs or documents as evidence that a correction has been completed, but evidence is optional by default. A correction/reinspection request must not be blocked solely because no evidence was attached. The consultant may request specific or additional evidence when justified by the finding or verification needs; that request must be recorded against the affected inspection item. Preserve each evidence item, uploader, timestamp, and its links to the WIR series/attempt and inspection item; never overwrite earlier evidence. Evidence alone does not establish acceptance or close the corrective action. | APPROVED REQUIREMENT — 2026-11-11 | Avoids unnecessary submission barriers while preserving the consultant's ability to require evidence when appropriate and maintaining traceable records. | Explicit owner approval in conversation, 2026-11-11. | Support optional contractor evidence and consultant-requested evidence; retain immutable evidence history and keep acceptance subject to the applicable inspection decision. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.8. |


## DEC-033 — Separate correction completion from formal reinspection submission

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-033 | After completing a required correction, the contractor first records **Correction Completed**. This declaration does not itself submit a reinspection request. The contractor must separately and explicitly confirm **Submit for Reinspection** to send the request formally to the consultant. Preserve both actions as distinct timestamped audit events attributed to the authenticated user. Do not auto-submit on correction completion. Optional evidence under DEC-032 may be attached before submission; optional evidence absence must not block submission unless a specific evidence requirement has been recorded for the affected item. | APPROVED REQUIREMENT — 2026-11-11 | Prevents accidental formal submissions while giving the contractor a clear opportunity to verify the correction and request before sending. | Explicit owner approval in conversation, 2026-11-11. | Provide separate correction-completion and formal-reinspection-submit actions with explicit confirmation and immutable event history. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.9. |


## DEC-034 — Consultant request for correction-information/evidence completion without creating a new inspection attempt

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-034 | Before proceeding with reinspection, the consultant may return the affected item/request to the contractor with a recorded, reasoned request for missing, unclear, or additional correction information/evidence. This is an administrative completion request within the current attempt: it is not a new inspection outcome and does not increment the WIR attempt sequence. The contractor may provide the requested information/evidence and must separately confirm **Submit for Reinspection** again under DEC-033. Preserve each request, reason, author, timestamps, response, evidence, and resubmission as append-only history. The request itself is not an acceptance/rejection; the four DEC-025 outcomes remain unchanged. | APPROVED REQUIREMENT — 2026-11-11 | Provides procedural flexibility while protecting the integrity of inspection outcomes and attempt numbering. | Explicit owner approval in conversation, 2026-11-11. | Add a traceable administrative completion-request loop within the current attempt; do not create a new attempt or fifth outcome. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.10. |


## DEC-035 — Contractor withdrawal of a submitted reinspection request before inspection starts

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-035 | The contractor who formally submitted a reinspection request may withdraw it with a recorded reason, but only before the consultant has started the inspection. This remains allowed after inspector assignment if inspection has not started. Record authenticated actor, timestamp, affected WIR/item and attempt, reason, and prior submission/assignment state. Withdrawal is an immutable workflow event; it does not delete the submission, create an inspection outcome, or silently increment/reset the attempt sequence. Once inspection starts, ordinary contractor withdrawal is not permitted; exceptional handling requires a separately authorized process preserving all activity/history. | APPROVED REQUIREMENT — 2026-11-11 | Allows correction of mistaken submissions while protecting the integrity of an inspection already underway and preserving the audit trail. | Explicit owner approval in conversation, 2026-11-11. | Provide a controlled pre-inspection withdrawal action with mandatory reason and immutable audit event. Do not allow ordinary withdrawal after inspection start. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.11. |


## DEC-036 — Consultant cancellation and reassignment of an inspection assignment

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-036 | An authorized consultant assignment manager may cancel/revoke the current inspector assignment and assign the inspection to another eligible consultant engineer/team when operationally necessary. This affects assignment only; it does not cancel/withdraw/close or otherwise alter the WIR, change its official number, affected item, attempt number, or recorded outcome. Replacement assignees must have active project assignment and relevant discipline/scope permissions under DEC-029/030. Preserve actor, timestamp, previous/new assignees, state change, and any supplied reason as immutable history; reason remains optional under DEC-030. Current assignment must remain distinguishable from full assignment history. | APPROVED REQUIREMENT — 2026-11-11 | Supports operational flexibility without corrupting the WIR lifecycle or losing accountability for prior assignments. | Explicit owner approval in conversation, 2026-11-11. | Provide controlled consultant-side assignment cancellation/reassignment with eligibility checks and append-only history. Do not alter WIR or attempt lifecycle. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.12. |


## DEC-037 — Separate WIR-level lifecycle status from inspection-item status

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-037 | Each WIR has an overall lifecycle status, separate from the status/outcome of every individual inspection item. Overall statuses: **Draft, Submitted, Assigned, In Progress, Awaiting Contractor Action, Awaiting Reinspection Submission, Reinspection Submitted, Closed, Withdrawn**. Each item maintains its own status, outcome, and history. Item outcomes remain exactly the four DEC-025 outcomes: **Accepted, Accepted with Comments, Requires Correction, Not Ready for Inspection**. Item workflow statuses distinguish **Pending Inspection, Inspection In Progress, Awaiting Contractor Correction, Awaiting Reinspection Submission, Reinspection Submitted, Completed**; these are workflow states, not new outcomes. A multi-item WIR remains open while any item needs action; it is Closed only when no further action remains and all applicable items are terminal. Not Ready follows DEC-026 and requires a new linked WIR when ready. All transitions are authorized and preserved with actor/time/action/item/attempt traceability. | APPROVED REQUIREMENT — 2026-11-11 | Prevents mixed item results from being hidden by a single WIR status and avoids confusing workflow progress with formal inspection outcomes. | Explicit owner approval in conversation, 2026-11-11. | Display and maintain overall WIR lifecycle separately from per-item status/outcome; derive overall status consistently from active item/workflow states. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.13. |


## DEC-038 — Mandatory in-app notifications with optional user-controlled email

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-038 | In-app notifications are the mandatory primary channel for authorized SiteDocs WIR workflow events. Email is an additional, optional channel controlled by each user's notification preferences. Disabling email must not disable in-app notifications. Route notifications only to relevant authorized users/teams, respecting project assignment, party, discipline, document visibility, and event relevance; do not leak drafts or unauthorized content. Distinguish action-required notifications from informational updates. Retain in-app notification history and read/unread state. Event-specific recipient mapping, urgency, batching/deduplication, retry handling, and other channels remain for later decisions; SMS/push are not approved by this decision. | APPROVED REQUIREMENT — 2026-11-11 | Ensures a consistent in-product notification record while allowing users to control additional email delivery and protecting document confidentiality. | Explicit owner approval in conversation, 2026-11-11. | Design in-app notifications as mandatory and email as an optional per-user channel. No implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.14. |


## DEC-039 — WIR notification priority and acknowledgement

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-039 | Classify WIR notifications into **Critical**, **Action Required**, and **Informational**. Critical covers high-impact lifecycle decisions/events and is prominently distinguished and delivered promptly to authorized relevant recipients. Action Required identifies a recipient task or response. Informational covers updates requiring no action. Reading a Critical notification does not delete it or remove it from history; it may be marked read/acknowledged while remaining retrievable. Reading an Action Required notification does not complete the underlying workflow action. Non-urgent informational updates may be batched/deduplicated, but batching must not delay or suppress Critical or time-sensitive Action Required notifications. Exact event mapping, escalation, delivery retry, and presentation remain open. No SMS/push approval. | APPROVED REQUIREMENT — 2026-11-11 | Makes urgency and recipient responsibility clear while retaining critical history and controlling notification noise without hiding important workflow events. | Explicit owner approval in conversation, 2026-11-11. | Implement three notification priority classes, preserve read/acknowledged history, distinguish read state from task completion, and protect urgent notifications from batching. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.15. |


## DEC-040 — Central WIR Notification Matrix

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-040 | Establish a central **WIR Notification Matrix** as the reference mapping workflow events to authorized relevant recipients, priority (Critical / Action Required / Informational), whether action is required, and the rule that resolves the notification. The baseline covers formal submission, assignment/reassignment, inspection start, Requires Correction, Not Ready, requests for correction details/evidence, Correction Completed without formal resubmission, formal reinspection submission, contractor withdrawal before inspection start, inspection disposition, and WIR closure. Resolve recipients using active project assignment, party, discipline, item responsibility, document visibility, and relevant capability at event time; do not broadcast by project membership alone. Reading does not complete an underlying action. Preserve event/recipient/delivery history; Critical remains prompt and retained; non-urgent Informational may be batched/deduplicated without hiding material events. Exact role mapping, templates, escalation/SLA, retry/failure handling remain open. Email remains optional under DEC-038; no SMS/push approval. | APPROVED DESIGN DIRECTION — 2026-11-11 | Provides one consistent, auditable source for who receives each WIR notification, its urgency, required action, and resolution, while protecting confidentiality and preventing notification state from changing workflow state. | Explicit owner approval in conversation, 2026-11-11. | Maintain a central event-to-recipient/priority/action/resolution matrix and enforce authorization at event time. Design only; no implementation or DB changes authorized. Detailed matrix in POL-DOC-001 §14.16. |


## DEC-041 — Central in-app WIR Notification Center

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-041 | Establish a centralized in-app **Notification Center** for WIR notifications. It provides a chronological feed and views for **All**, **Unread**, **Action Required**, and **Critical**; filters by project, document type, and date within the user's authorized scope; clearly shows priority and the specific action expected; and may navigate to the related WIR/item only after current server-side authorization is rechecked. Preserve notification history and read/unread state. Opening/reading does not complete the underlying workflow action; Action Required resolves only through the linked authorized workflow action or valid supersession. Never disclose drafts or unauthorized content in feeds, previews, filters, counts, or links. Exact layout, pagination/retention, search, bulk actions, accessibility, and mobile presentation remain open. | APPROVED DESIGN DIRECTION — 2026-11-11 | Gives users one clear place to understand, prioritize, and act on WIR notifications without confusing notification state with document workflow state or weakening confidentiality. | Explicit owner approval in conversation, 2026-11-11. | Design a centralized in-app Notification Center with the approved views, filters, action context, and authorization-safe navigation. Design only; no implementation or DB changes authorized. Detailed requirement in POL-DOC-001 §14.17. |


## DEC-042 — WIR Action Reminders and Escalation Policy

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-042 | Establish controlled reminders and escalation for unresolved WIR **Action Required** actions. Reminders target only the currently responsible authorized recipient; escalation after a configurable threshold notifies only designated authorized project/party/workflow roles. Critical notifications are delivered promptly and are not delayed by reminder cadence, batching, or quiet hours. Informational notices do not trigger action reminders. Reading/opening/acknowledging a notice alone does not resolve an action or reset its deadline. Stop reminders when the authoritative workflow action is completed, validly superseded, withdrawn, or no longer required; reassignment stops future notices to the former assignee and resolves the new authorized recipient. Escalation is visibility/accountability only and never transfers authority, grants permissions, or performs workflow actions. Preserve auditable reminder/escalation and delivery history; deduplicate processing and define bounded delivery retries. Cadence, thresholds, role mapping, calendars/time zones, quiet hours, retry limits, and exceptions remain configurable and require detailed approval; no fixed numeric SLA or contractual deadline is approved. | APPROVED DESIGN DIRECTION — 2026-11-11 | Prevent unresolved WIR actions from being overlooked while preserving authorization, responsibility, workflow integrity, and auditability. | Explicit owner approval in conversation, 2026-11-11. | Design configurable reminders/escalation only for unresolved actionable WIR events. No scheduler, automation, application, or DB implementation authorized. Detailed requirement in POL-DOC-001 §14.18. |


## DEC-043 — WIR Role-Based Dashboard and Performance Monitoring

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-043 | Establish a read-oriented WIR dashboard with role- and scope-appropriate views: contractor operational follow-up; consultant intake, assignment, inspection, and decision workload; and a project-manager supervisory overview that remains read-only and respects DEC-021. Show authoritative WIR- and item-level statuses separately, four approved outcomes, reinspection attempts, and actionable workload indicators. Aging/overdue metrics may be shown only when supported by a valid recorded target/due date or separately approved SLA; distinguish DEC-031 target dates from contractual due dates. Metrics must derive from authoritative workflow records, distinguish contractor-controlled, consultant-controlled, and neutral waiting periods, and define KPI formulas/exclusions before implementation. Filters, drill-downs, and any future exports must enforce current server-side authorization and draft/party/project confidentiality. Exact layouts, KPI formulas/thresholds, refresh cadence, calendars/time zones, exports, and aggregate retention remain open. No SLA, contractual deadline, or KPI threshold is approved. | APPROVED DESIGN DIRECTION — 2026-11-11 | Gives each party useful operational visibility and management oversight without weakening role boundaries, misattributing delays, or confusing workflow states and outcomes. | Explicit owner approval in conversation, 2026-11-11. | Design role-based WIR dashboard and governed metrics only. No UI, analytics pipeline, application, or DB implementation authorized. Detailed requirements in POL-DOC-001 §14.19. |


## DEC-044 — Reports & Analytics: WIR Reporting Foundation

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-044 | Establish a governed Reports & Analytics foundation, initially covering WIR: WIR register/status, inspection results, correction/reinspection, Not Ready and linked resubmissions, workload/assignment, stage aging/turnaround, and trends/recurrence. Define each report's source, row grain, filters, numerator/denominator, exclusions, date basis/timezone, and freshness. Keep WIR status, item status, outcome, attempt sequence, and revision distinct. Use authoritative workflow/audit records; separate contractor-controlled, consultant-controlled, and neutral durations; do not misclassify DEC-034 follow-up or DEC-026 Not Ready. Every query, aggregate, filter, drill-down, and PDF/spreadsheet export must enforce current server-side authorization and prevent aggregate leakage. PDF and spreadsheet export are intended formats, with exact controls still to be designed. Other Phase 1 modules require module-specific report definitions. Payment Certificates/financial reporting are outside this initial scope and require a separate financial design. No KPI threshold, SLA, contractual deadline, scheduled distribution, or implementation is approved. | APPROVED DESIGN DIRECTION — 2026-11-11 | Provides reliable, comparable operational reporting without corrupting workflow semantics, misattributing elapsed time, or exposing unauthorized information. | Explicit owner approval in conversation, 2026-11-11. | Specify the WIR report catalogue and governed reporting rules. Design only; no UI, database, analytics pipeline, export service, or scheduled reporting implementation authorized. Detailed requirements in POL-DOC-001 §14.20. |


## DEC-045 — Official Report Templates and Controlled Report Outputs

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-045 | Establish a controlled template framework for official project reports, initially for the WIR catalogue under DEC-044. Standard structure includes project/authorized branding, report title/type/reference, reporting period, generation timestamp, scope/filters/date basis/timezone, data freshness, report-specific summaries/tables/indicators/notes, appendices/references, and report version/change history. Prepared/Reviewed/Approved attribution may appear only when the corresponding authenticated, authorized action actually occurred; report generation is not approval, and report approval is distinct from approval of source WIRs. Distinguish Draft/Preview from Official Generated Report. Preserve an immutable official output/snapshot or equivalent reproducible record with its definition version and generation context; regeneration creates a traceable new output rather than overwriting history. PDF should be print-ready; spreadsheet output must be structured and safely handle untrusted/formula-like values. Recheck server-side authorization at preview/generation/download/distribution and audit actor, time, report definition, scope, filters, format, output identity/hash where available, and delivery outcome. Reports are derivative and must not alter source records. Payment Certificates and financial reporting remain excluded pending separate approval. Numbering/versioning, retention, signature, distribution, detailed templates, Excel schema, print, multilingual, and accessibility rules remain open. No implementation is authorized. | APPROVED DESIGN DIRECTION — 2026-11-11 | Provides consistent, reproducible, and auditable reporting while preventing decorative approvals, source-record mutation, unauthorized disclosure, and unsafe spreadsheet output. | Explicit owner approval in conversation, 2026-11-11. | Specify report templates and controlled output requirements only. No DB, UI, API, reporting pipeline, export service, scheduler, tests, merge, or deployment implementation authorized. Detailed requirements in POL-DOC-001 §14.21. |


## DEC-046 — Official Report Review, Approval, Issue, and Distribution Lifecycle

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-046 | Establish a controlled report lifecycle distinct from source-document workflows: Draft/Preview; Submitted for Report Review; Under Review; Returned for Correction; Approved; Issued; Distributed; and, where needed, Superseded/Withdrawn. Review and approval bind to one exact immutable report snapshot and definition version. Material changes require a new snapshot and applicable review cycle; prior approvals do not transfer. Preparation, review, approval, issue, and distribution are separate capabilities governed by DEC-021, deny-by-default, current server-side authorization, and separation of duties; no self-approval or proxy action is assumed. PM oversight remains read-only absent a separately approved capability. Issuance follows required approval and records checks. Distribution is limited to explicitly authorized recipients and must record exact report version, recipient/destination, actor/authority, channel, timestamp, and outcome. No default broadcast, public links, specific channel, scheduled distribution, or email attachment route is approved. Preserve append-only review/approval/issue/distribution/withdrawal/supersession history and prior official snapshots. Report actions never alter WIR/source-document states or decisions. Detailed role mapping, gates, channels, recipient rules, link security, acknowledgement, retries, retention, and report-specific exceptions remain open. No implementation is authorized. | APPROVED DESIGN DIRECTION — 2026-11-11 | Separates report governance from source-document approval and ensures every official report is approved, issued, and distributed only through traceable authorized actions. | Explicit owner approval in conversation, 2026-11-11. | Specify report review/approval/issue/distribution requirements only. No DB, UI, API, reporting/export/distribution service, scheduler, tests, merge, or deployment implementation authorized. Detailed requirements in POL-DOC-001 §14.22. |


## DEC-047 — Controlled Document and Official Report Registers

| Decision ID | Approved direction | Status | Rationale / boundary | Authority | Implementation consequence |
|---|---|---|---|---|---|
| DEC-047 | Establish a controlled Document Register for source project documents and a distinct Official Report Register for generated reports under DEC-045/046. They may share a navigation/search experience but must preserve separate record classes, identifiers/numbering, workflows, permissions, and history. Document entries expose authorized authoritative metadata such as project, type, official number, title, party, discipline, revision, lifecycle/status dimensions, dates, and relevant controlled links. Report entries expose authorized report type/reference/version, reporting period, generation context, definition/snapshot version, report lifecycle, issue date, and distribution summary. Search, filters, counts, previews, drill-downs, downloads, and exports must enforce current server-side authorization and must not leak unauthorized records or aggregates. Stable identifiers, revisions, supersession, withdrawal, report regeneration/reissue, and history remain traceable; register summaries derive from authoritative records and disclose freshness limitations. Registers are indexes, not workflow authorities, and do not alter source documents or report states. WIR/RFI/MQR remain distinct; financial registers are excluded pending separate approval. Exact fields, ownership, search behavior, indexing/freshness, retention, bulk actions, exports, and relationship granularity remain open. No implementation is authorized. | APPROVED DESIGN DIRECTION — 2026-11-11 | Provides reliable discovery and oversight without conflating source documents with derivative reports, weakening confidentiality, or replacing authoritative workflow records. | Explicit owner approval in conversation, 2026-11-11. | Specify controlled register requirements only. No DB, UI, API, search/indexing, reporting/export service, tests, merge, or deployment implementation authorized. Detailed requirements in POL-DOC-001 §14.23. |


## DEC-048 — Advanced Document Search and Retrieval

**Status:** owner-approved design direction — 2026-11-11. **Implementation status:** design only; no implementation authorized.

**Decision:** SiteDocs shall provide governed advanced search and retrieval across the controlled Document Register and Official Report Register defined by DEC-047. A unified search entry point is permitted, but source documents and official reports must remain distinct record classes with separate identifiers, numbering, lifecycle, and authorization semantics.

**Approved requirements:**
1. Support exact/partial retrieval by official document/report reference, title/subject, record type, project, originating party, discipline where applicable, revision/version, authorized status dimensions, date range, current responsible party/assignee, recipient, and transmittal/distribution reference.
2. Support explicit typed navigation among parent/child records, revisions and superseding records, relevant WIR/item/attempt relationships, report source references, and transmittal/distribution records. Do not infer links from textual similarity.
3. Include archived, withdrawn, and superseded records only within the caller's authorized scope and clearly distinguish historical from current records.
4. Keep official document number, document revision, WIR attempt sequence, report reference, and report version separate in indexing, matching, display, and navigation.
5. Enforce current server-side authorization for results and for counts, facets, suggestions, autocomplete, snippets, highlights, previews, pagination, drill-downs, downloads, and exports. No metadata or existence leakage is permitted.
6. Apply DEC-021 deny-by-default, party/project/discipline/assignment/document-visibility restrictions, draft confidentiality, and PM read-only oversight. A search result grants no underlying file, attachment, revision, signature, audit, or workflow capability.
7. Treat indexes/caches as derived, non-authoritative aids. Permission changes and revocations must be respected; disclose material freshness/indexing delays. Fail closed when access cannot be revalidated.
8. Preserve immutable source identity and historical links through revision, supersession, withdrawal, archive, and report reissue. Search must not collapse or rewrite history.
9. Reauthorize the exact result set and fields at export time; audit exports and protect spreadsheet output from formula injection.

**Open design details:** per-type searchable fields; Arabic/English tokenization and normalization; transliteration; exact/fuzzy matching and ranking; search syntax; indexing technology/refresh targets; permission invalidation; saved searches; pagination/limits; archived-record indexing; attachment full-text/OCR scope; snippets/highlights; bulk actions; export layouts and audit detail; and role-specific presentation. These are not approved defaults and require further design before implementation.

**Implementation boundary:** this decision authorizes requirements/design documentation only. It does not authorize database/schema/migration/generated types, Storage, authentication/RLS/grants, API/UI/code, search/indexing infrastructure, OCR, caching, export services, tests, merge, or deployment.


## DEC-049 — Document and Report Notifications

**Status:** owner-approved design direction — 2026-11-11. **Implementation status:** design only; no implementation authorized.

**Decision:** establish a central in-app notification framework across authorized document and official-report modules. This framework standardizes notification presentation and retrieval only; it does not merge module workflows or replace document-family-specific event and recipient rules.

**Approved requirements:**
1. Preserve WIR notification behavior under DEC-038–DEC-042 without reinterpretation. Other document families and reports generate notifications only from their separately governed authoritative workflow events.
2. Candidate cross-module event families include formal submission, assignment/reassignment, review/return, correction request, approval, issue, transmittal/distribution, withdrawal, supersession, archive/records exception, and relevant delivery failure. Exact events and priorities are defined per family.
3. Present Critical, Action Required, and Informational consistently, but do not assume a universal event-to-priority map. Not every event requires action.
4. Each notification identifies its event, record class/reference, authorized context, priority, timestamp, recipient, and expected action where applicable. Content is limited to what the recipient may see.
5. Resolve recipients by current authorized project assignment, party, discipline, responsibility, workflow step, visibility, and capability. Membership or historical assignment alone is insufficient.
6. Recheck server-side authorization for notification lists, counts/facets, opening, navigation, previews, downloads, and linked actions. A notification/deep link cannot bypass revoked access.
7. Read/open/dismiss/acknowledge does not complete the underlying action. Action Required resolves only through the authoritative workflow action or valid family-specific supersession/cancellation.
8. Preserve append-only event and recipient history, priority, timestamps, delivery attempts/outcomes, read/ack state, policy/version, and linked workflow resolution. Notification state is not source-record status.
9. Deduplicate technical retries without hiding distinct business events. Batch/group non-urgent informational items only if each event remains retrievable. Never delay Critical or urgent Action Required events by batching.
10. In-app is mandatory. Email remains optional and preference-dependent under DEC-038. SMS, push, public links, and default broadcast are not approved.
11. Reminders/escalation follow DEC-042: unresolved Action Required only, current authorized responsible recipients, separately approved configurable thresholds, no responsibility transfer or capability grant, and full audit. No fixed SLA/contractual deadline is created.
12. Report notifications bind to the exact report snapshot/version and distinguish review, approval, issue, and distribution under DEC-045/046. They do not approve or alter source WIRs/documents.
13. Prevent leakage through previews, snippets, search, filters, counts, email, and grouped summaries. PM oversight remains read-only under DEC-021.

**Open design details:** event catalogues and priority mapping by family; recipient matrix; templates/localization; aggregation/deduplication windows; preferences; read/ack semantics; reminder/escalation thresholds; quiet hours; retries/failure handling; email link/content security; retention; pagination/search; accessibility/mobile; and monitoring.

**Implementation boundary:** this decision authorizes requirements/design documentation only. It does not authorize notification schema/tables/migrations/generated types, event bus, scheduler, API/UI/code, email provider, push/SMS, auth/RLS/grants, tests, merge, or deployment. WIR-specific DEC-038–DEC-042 remain controlling.


## DEC-050 — Document Transmittals & Distribution Control

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

1. Establish a controlled Transmittal record, separate from source document and Official Report records. A Transmittal records distribution; it does not create a source revision, approve a record, or complete a source workflow.
2. Give each Transmittal a stable internal identity and controlled reference. Numbering/reference format remains open.
3. Preserve an immutable manifest containing authoritative record IDs/classes, exact document revisions or report snapshots/versions, titles/references, relevant file identities/hashes, purpose/status, and intended recipients.
4. Record sender/issuer and authority, originating party, project, issue timestamp/timezone, channel, recipient identities/parties, and stated purpose. Candidate purpose labels (For Review, For Approval, For Information, For Construction, As-Built) are examples only; controlled values require separate review.
5. Before issue, validate source eligibility and required source gates, exact frozen version, sender authority, recipient authorization, manifest completeness, and exclusion of unintended drafts/versions.
6. Resolve recipients individually under active project assignment, party, visibility, and capability rules. No project-wide broadcast by default. A Transmittal does not grant access; each source record/file remains independently authorized and rechecked server-side.
7. Distinguish dispatch, technical delivery, and human acknowledgement. Technical receipt is not proof of reading, review, acceptance, approval, or action.
8. Keep lifecycle facts distinct: Draft/Created, Validated, Issued/Dispatched, Delivered, Partially Delivered, Failed, Acknowledged where required, and authorized Superseded/Cancelled/Withdrawn. Exact state machine and acknowledgement requirements remain open.
9. Track delivery attempts/outcomes/timestamps separately for each recipient. Partial failure must remain visible; never mark the whole Transmittal delivered when any required recipient has failed. Retries are bounded, deduplicated, and audited.
10. Re-send of the exact package preserves its identity and manifest history. A changed package/scope requiring a new issue creates a new Transmittal linked by explicit supersession/withdrawal; never overwrite prior history or change source revisions merely by distributing them.
11. No delivery channel, email attachment, public link, or external link is approved as a default. Secure channel, link, authentication, expiry, packaging, and evidence rules require separate approval.
12. Preserve an append-only manifest snapshot and audit of actor/authority, exact versions, recipients, policy context, channel, timestamps, attempts, outcomes, acknowledgements, and relationships.
13. Link Transmittals to Document Register and Official Report Register records while preserving separate record classes and workflows. Search and all counts/facets/previews/downloads/exports remain subject to server-side authorization.
14. Apply DEC-021 deny-by-default and least privilege to all Transmittal actions. PM visibility remains read-only unless a separate capability is approved. Possession of a reference/link never bypasses revoked access.
15. A Transmittal does not itself approve/sign/review a source record or complete WIR/RFI/other workflow. No contractual delivery deadline, deemed receipt, acceptance, or legal effect is established by this decision.

**Open design details:** numbering, family-specific eligibility gates and purpose vocabulary, issuer authority, recipient/external identity, acknowledgement and legal effect, channels/secure links, packaging, retry/deduplication, partial delivery/reissue, cancellation/withdrawal authority, retention/legal hold, localization, and output formats.

**Implementation boundary:** design documentation only. No schema/database/storage/auth/API/UI/provider/channel/test/merge/deployment changes are authorized or made.


## DEC-051 — Controlled Document Distribution & Access Receipts

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

1. Define recipient access to the exact manifest entries in a Transmittal and preserve evidence of access-related events. Dispatch/delivery, authorization, technical access, and human acknowledgement are separate concepts.
2. An access receipt records an observable event for an identified recipient/account and exact source version. It is not a signature, proof of comprehension, acceptance, approval, or completion of a source workflow.
3. Require authenticated, individually resolved recipients and current server-side authorization for each preview/open/download/attachment/acknowledgement request. Apply DEC-021 deny-by-default and least privilege. A Transmittal, reference, or URL never grants access by itself.
4. Restrict each recipient to manifest entries intended for them and independently authorized. Prevent leakage of other recipients or unauthorized entries through UI, counts, search, previews, notifications, and errors.
5. Bind access to the exact document revision or report snapshot/version in the immutable manifest. Never silently substitute the latest revision. Fail closed if exact-version access or authorization cannot be established.
6. Do not rely on shared accounts, anonymous public links, typed names, cached membership, or client-side controls as proof of individual authorization/access.
7. Where reliably observable, record separate events for link issuance, authentication, preview/open, download initiation, completed download where measurable, denial, and explicit acknowledgement. Do not claim completion when only initiation is observable.
8. Append-only event evidence should bind Transmittal and manifest entry, exact source record/version, recipient/account, event type, timestamp/timezone, authorization outcome/policy context, and technical result. Minimize telemetry; detailed fields/retention remain open.
9. Explicit acknowledgement, if required by an approved policy, must be separately authenticated and identify the exact Transmittal/manifest version, actor, acknowledgement type/wording, timestamp, and policy version. Opening/downloading/email delivery is not acknowledgement. Ambiguous Accepted/Approved labels are not permitted without a separately governed authority and workflow.
10. Access and acknowledgement do not satisfy source review, technical response, approval, signature, WIR/RFI action, or contractual notice unless separately and expressly approved.
11. Revocation/expiry of assignment, membership, visibility, or capability must block future system-controlled access as soon as the authoritative change takes effect. Recheck every request; cached content, sessions, or tokens must not bypass revocation.
12. Revocation cannot guarantee recall/deletion of files already downloaded, printed, copied, or retained outside the system. Do not claim remote deletion.
13. Supersession/withdrawal preserves the original Transmittal, manifest, and access history. Clearly identify the relationship, prevent silent substitution, and notify affected authorized recipients under approved notification rules. Distribute replacements through a new DEC-050 Transmittal.
14. Cancellation, withdrawal, or recipient removal never erases prior dispatch/access/acknowledgement evidence.
15. Senders see recipient-level states only within their authority; recipients see only their own authorized entries and states. PM remains read-only absent a separate capability.
16. Label technical states precisely: not accessed, attempted, preview/open recorded, download initiated/completed where measurable, denied, acknowledgement pending, acknowledged. Access telemetry alone is not proof of reading, understanding, contractual notice, or performance.
17. Secure access histories, reports, exports, search, notifications, and aggregates with server-side authorization; prevent cross-party leakage and unauthorized inference.

**Open design details:** external identity proofing; authentication/step-up; secure viewer/download; token/session expiry and revocation latency; offline/print limitations; event taxonomy and telemetry minimization; acknowledgement wording/mandatory cases; visibility; supersession/revocation notifications; retention/legal hold; audit export; and legal/contractual evidentiary effect.

**Implementation boundary:** design documentation only. No identity/auth/session/token, signed URL, storage, schema/database, RLS/grants, API/UI, telemetry, notification provider, tests, merge, or deployment changes are authorized or made.


## DEC-052 — Document Acknowledgement & Response Management

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

1. Establish separate records and semantics for technical delivery receipt (DEC-050), access receipt (DEC-051), explicit acknowledgement of receipt, optional acknowledgement of review/awareness, formal substantive response, and source-workflow decision.
2. None implies another. Delivery, opening, downloading, acknowledgement, silence, or non-response never constitutes approval, acceptance, consent, waiver, or completion of a source workflow.
3. A Transmittal must state explicitly whether a response is required, optional, or not requested, per recipient and where relevant per manifest entry.
4. Preserve request originator/authority, intended recipient, exact Transmittal and manifest version, source record/version, response type, instructions, request timestamp, and any target response date.
5. Target response dates are tracking information only unless a separately approved contractual/SLA policy defines otherwise. No deadline, deemed receipt, escalation threshold, or contractual consequence is created here.
6. Response categories/templates are document-family-specific. Candidate labels are not universal status codes; WIR/RFI/MQR and other source workflows retain their own governed outcomes.
7. Do not use generic Approved/Accepted responses to bypass source workflow authority, required review, signature, or separation of duties.
8. Require authenticated individual and current assignment/capability for the specific party, project, Transmittal, and response action. Preserve actor, authority context, timestamps/timezone, exact manifest/version, source references, response type/content, and evidence identities/hashes where applicable.
9. Submitted acknowledgements/responses are immutable records. Corrections/supplements create linked subsequent records; no overwrite or deletion. Drafts remain restricted until formal submission.
10. Withdrawal/supersession requires explicit authority and audit and must preserve the original. Response attachments do not automatically become source revisions or official attachments.
11. Route responses only to authorized relevant originators/participants; no broadcast to all Transmittal recipients by default. Track response state separately from delivery/access and source workflow state.
12. Clarification exchanges preserve request, reason, scope, actors, and timestamps; they do not alter the original manifest/source revision or constitute a source decision.
13. Reassignment or revocation does not rewrite prior authorship. Future actions require current authorization.
14. Notifications/reminders follow DEC-049/042; notification read state is not response submission. Reports distinguish delivery, access, acknowledgement, response, source review, and approval.
15. Apply DEC-021 deny-by-default, least privilege, separation of duties, server-side authorization, and append-only audit to request, routing, draft, submission, review, withdrawal, and history access. PM remains read-only.
16. Protect response content and evidence across search, previews, notifications, exports, and analytics. No cross-party leakage.
17. Legal effect, contractual notice, deemed receipt, mandatory acknowledgement, deadlines, evidentiary status, retention, and external identity assurance require separate review; this decision establishes none.

**Open design details:** family-specific response catalogue; mandatory/optional acknowledgement; routing; forms/evidence; review and clarification cycles; due-date semantics; reminders/escalation; external recipients; correction/withdrawal; retention/legal hold; localization; metrics; and legal/contractual effect.

**Implementation boundary:** design documentation only. No schema/database/notification/auth/RLS/API/UI/storage/workflow automation/tests/merge/deployment changes are authorized or made.


## DEC-053 — Document Revision, Supersession & Withdrawal Control

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

1. Maintain stable logical document identity and immutable individual revision records. Every formal revision is a distinct snapshot; never overwrite, delete, or reuse a revision identity.
2. Keep official document number, revision, WIR attempt, report reference/version, Transmittal reference, and draft ID distinct.
3. Apply DEC-022-A/B: official number at first successful formal submission; initial revision Rev.00; material controlled-content change after return increments revision; unchanged controlled content on resubmission retains the revision.
4. Preserve revision content/metadata, file identities/hashes, actors/timestamps, workflow and approval/signature evidence, and predecessor/successor links. Define material/non-material change by family-specific rules; record classification and actor.
5. Distinguish latest created revision from current effective/issued revision. Draft, submitted, or unapproved revisions do not automatically supersede the current effective revision.
6. A revision becomes current/effective only after its applicable authorized workflow and formal issue gate. Supersession is an explicit relationship to a specific replacement; preserve all history and clearly label the old revision. Never silently redirect old references to the latest revision.
7. Historical revisions remain available only under current authorization and retention/legal-hold rules; historical availability does not make them valid for current construction/use.
8. Distinguish withdrawal of a document/revision from Transmittal cancellation, review return/rejection, and supersession. Withdrawal requires an authorized actor, reason, scope, timestamp, authority, and audit. Eligible states/gates remain open.
9. Withdrawal never deletes or rewrites the source, revision, approvals/signatures, distribution, access receipts, acknowledgements, responses, or audit history. It prevents future issue/use as defined by family policy.
10. Identify affected Transmittals/recipients and notify/instruct authorized recipients under DEC-049/050/051. Do not claim downloaded/printed copies are recalled.
11. A replacement is a new immutable revision or new document identity as required by family rules, linked explicitly and distributed by a new Transmittal. Never mutate the withdrawn snapshot.
12. Distinguish cancellation of an unissued draft/pending submission from withdrawal of an issued/effective revision. Preserve audit and official numbering history under DEC-022.
13. Temporary hold/suspension is a possible separate control, not a universal approved status; authority, scope, notices, release conditions, and work impact need separate approval.
14. Bind Transmittals, access receipts, acknowledgements/responses, reports, registers, and search to exact identity/revision. Never silently substitute latest.
15. Update derived current-status indicators and authorized notices without changing historical events/manifests. Reauthorize all current/historical access server-side. Supersession/withdrawal does not grant access to replacement versions.
16. Prevent stale links/caches from presenting old revisions as current. Technical invalidation/session/link controls require separate design; fail closed if status or authorization is uncertain.
17. Apply DEC-021 deny-by-default and separation of duties to revision creation, submission, review, approval, issue, supersession, withdrawal, and historical access. PM remains read-only.
18. Preserve append-only audit of all material lifecycle actions and recipient impact.
19. Registers/reports must distinguish document identity, revision, latest-created, current-effective, lifecycle, supersession/withdrawal, and dates. Historical analytics must preserve status at the selected time. Never present withdrawn/superseded revisions as current.

**Open design details:** family-specific material-change taxonomy and numbering exceptions; issue/effective gates; withdrawal authority/evidence; draft cancellation; hold/suspension; reinstatement; impact on open workflows/links; recipient instructions; retention/legal hold; historical access; cache/link invalidation; and register/report semantics.

**Implementation boundary:** design documentation only. No schema/database/files/storage/auth/RLS/API/UI/numbering/workflow/notification/search/index/tests/merge/deployment changes are authorized or made.


## DEC-054 — Document Retention, Archiving & Legal Hold

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

1. Establish controlled retention, archive, legal-hold, preservation, and disposition governance for source documents/revisions, drafts where required, attachments/scans, review and approval evidence, Transmittals/manifests, access receipts, acknowledgements/responses, official reports/snapshots, registers, and relevant audit/notification records.
2. Preserve provenance and relationships so no record becomes unintelligible through independent retention/disposition of linked evidence.
3. Distinguish operational lifecycle status from retention status. Archiving is not deletion and does not authorize disposal or broaden access.
4. Define versioned retention schedules by record class, project/contract, jurisdiction, and approved requirement. No universal retention period or expiry is established here.
5. Each schedule must specify authoritative trigger, calculation, period, owner, review process, and source. Candidate triggers are examples only. Where approved requirements conflict or classification is uncertain, preserve and escalate; apply the longest applicable approved period unless competent authority directs otherwise.
6. Expiry only makes a record eligible for review; it never automatically authorizes destruction. Schedule changes are versioned and do not silently rewrite historic calculations.
7. Archive preserves stable identity, original content, revision/version, metadata, relationships, approvals/signatures, and audit provenance. Historical access remains subject to current authorization and must be labelled as historical.
8. Preserve file integrity with identities/hashes and auditable checks where supported. Any format migration/packaging preserves the original and records tool/version, actor/process, time, transformation, and validation.
9. Backups/replicas/exports are distinct from archive and require separate lifecycle and legal-hold behavior. No storage technology, residency, encryption, recovery target, or integrity interval is selected.
10. Legal Hold is an overriding preservation restriction suspending disposition within explicit scope; it does not change operational approval/revision status.
11. Only authorized legal/records authorities may create, amend, or release a hold. Record identifier/matter, authority, reason, scope, affected projects/records/versions/attachments/related evidence, custodians where relevant, effective/review dates, and release evidence.
12. Hold activation blocks automatic and manual disposition for affected records and controlled copies; uncertain applicability fails closed. Multiple holds are independent: releasing one does not release another.
13. Hold release requires authority, scope, reason, and review of remaining obligations. Release returns records to retention review; it does not trigger immediate deletion.
14. At retention expiry, require controlled disposition review covering schedule, trigger, linked records, claims/disputes/audits/investigations, holds, and approvals. Require authorized decision, separation of duties, rationale, scope, schedule version, actor, authority, timestamp, and outcome.
15. Preserve sufficient disposition audit evidence subject to legal/privacy review. Destruction across primary storage, replicas, caches, indexes, and backup cycles must be controlled and its limitations disclosed. Do not claim immediate erasure unless verified.
16. No hard delete, bulk cleanup, or automatic expiry is authorized. Uncertain records or unresolved holds must be preserved and escalated.
17. Maintain versioned schedule catalogue and append-only audit of schedule changes, archive transitions, integrity checks, hold lifecycle, blocked disposition, approvals, and destruction outcomes.
18. Restrict hold details and sensitive matter references to authorized users. Apply server-side authorization to archive, hold, release, review, export, restore, and disposition. PM visibility remains read-only absent separate capability.
19. Reconcile preservation with privacy/data-minimization obligations; retention does not authorize unrestricted processing or disclosure.

**Open design details:** record taxonomy/schedules, jurisdiction and contract sources, triggers/calculation, archive tiers/formats, integrity checks, backup lifecycle, hold authority/scope/review/release, multiple holds, disposition matrix, deletion across storage/index/cache/backup, retained audit metadata, privacy requests, reporting, and monitoring.

**Implementation boundary:** design documentation only. No schema/database/storage lifecycle/deletion/backup/restore/archive/hold tooling/auth/RLS/API/UI/retention jobs/disposition/destruction/tests/merge/deployment changes are authorized or made.


## DEC-055 — Document Audit Trail & Accountability

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

1. Establish governed, attributable, append-only audit evidence for material document, revision, attachment, workflow, report, Transmittal, acknowledgement/response, notification, access, retention, archive, and legal-hold events.
2. Audit must identify actor/system, authenticated identity and authority context, action/target, exact affected record and revision/version, event and recording times, outcome, reason where applicable, and relevant policy/workflow context.
3. Preserve actual actor attribution. No shared accounts, impersonation, proxy attribution, silent edits, deletion, replacement, or backdating. Corrections are new linked events with reason and authority.
4. Capture lifecycle and material changes; roster/assignment/capability changes; upload/scan/attachment operations; authentication and explicit signature/approval actions; report review/issue; Transmittal manifest and recipient outcomes; access/denial events where required; notification delivery/action resolution; and DEC-054 retention/archive/hold/disposition events. Exact mandatory event catalogue is open.
5. Event envelope includes stable event ID, event type/schema version, UTC event and server-recorded times, actor class and identity, relevant assignment/capability/policy context, correlation/causation identifiers, exact affected object identities, action/outcome, reason/error category, and controlled before/after change evidence where appropriate.
6. Never log credentials, tokens, passwords, private keys, raw session secrets, or unnecessary sensitive payloads. Distinguish event time from ingestion time; timestamp and offline integration rules remain open.
7. Audit storage must resist alteration by ordinary application roles. Evaluate tamper-evidence mechanisms (e.g. hash chaining, signed checkpoints, protected append-only storage, independent replication); no architecture or absolute immutability claim is approved.
8. Preserve causal ordering where needed; timestamps alone may not establish total ordering. Critical state-changing actions must commit consistently with mandatory audit evidence. If durable audit cannot be recorded, do not report the action as successfully completed. Exact architecture/recovery remains open.
9. Capture relevant denied/failed attempts without exposing protected content. Identify gaps, duplicates, delay, corruption, and reconciliation through separately audited processes; never fabricate events.
10. Audit review, counts, filters, snippets, previews, and exports require server-side authorization. Audit access is a distinct capability; PM remains read-only. Sensitive security/legal/personal details are restricted.
11. Exported evidence preserves event identity/order/time/scope/schema/policy context and available integrity verification; export generation/access is audited and formula injection controlled.
12. Apply DEC-054 retention and legal holds to audit records as a governed record class. Supersession/withdrawal of a document does not itself permit deletion of its audit history.
13. Clearly distinguish facts, system interpretations, and missing evidence. Access/open is not acknowledgement; acknowledgement is not approval; approval is not signature unless separate authoritative events establish each.

**Open design details:** event catalogue/coverage, change capture/redaction, actor/session and service identity, time precision/timezones/offline events, ordering/correlation, tamper-evidence architecture, transactional failure/recovery, monitoring/alerts, audit roles, retention/holds, export format, privacy, and incident reconciliation.

**Implementation boundary:** design documentation only. No audit schema/table/triggers/pipeline/database/storage/cryptography/auth/RLS/API/UI/monitoring/backfill/tests/merge/deployment changes are authorized or made.


## DEC-056 — System Administration, Configuration & Governance Control

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

1. Establish controlled administration for platform, organization, project, reference data, workflow, forms/templates, reports, notifications, retention, audit, and presentation configuration.
2. Administrative title or access does not grant policy authority, workflow override, approval, privilege escalation, or permission to alter governed decisions. Apply DEC-021 deny-by-default capability controls.
3. Distinguish configuration from governance policy. Material changes to approved rules require the competent decision authority, documented decision, impact assessment, and traceability update; an admin screen cannot amend an approved decision.
4. Maintain a configuration catalogue with stable identity, class/risk tier, owner, scope, permitted editors/reviewers/approvers, version, lifecycle status, effective dates, source authority, dependencies, and history.
5. Classify ordinary operational settings, controlled reference data, security/authorization settings, workflow/business rules, and governance/legal/contractual policy. Classification controls approval and release gates.
6. Define global/organization/project ownership and explicit inheritance/override precedence. No ambiguous competing settings; show inherited and overridden values.
7. Use stable reference-data IDs and active/deprecated/retired states. Never destructively replace historical values; retain exact historical labels/version context and prevent retired values from new use unless explicitly allowed.
8. Every change proposal records current/candidate version, reason, scope, owner, intended effective date, source, dependencies, and affected modules/projects/record classes.
9. Require impact assessment for in-flight and draft transactions, historical records, numbering/revisions, authorization/separation of duties, signatures, integrations, notifications, reports/search, retention/holds, migration, and communication.
10. High-impact changes (workflow, numbering, access, visibility, signatures/approvals, retention/disposition, legal hold, audit, contractual/legal rules) require independent competent review and approval. No self-approval; approval binds to the exact candidate version and material changes require reapproval.
11. Saving or approving in principle does not activate a setting. Validate schema, dependencies, compatibility, authority, and required tests; activate explicitly with scope, time, actor, and audit.
12. Preserve immutable approved/active versions. Prospective changes only; never silently rewrite historical or completed records. Preserve the applicable configuration/policy version used at transaction initiation and material transitions.
13. In-flight transactions require an explicit rule: continue on original version, migrate under an approved transition plan, or pause for authorized review. No automatic migration is assumed.
14. Numbering changes cannot reset/reuse issued identifiers. Existing document/revision/report/transmittal identities remain stable and resolvable.
15. Rollback is a new controlled activation of a known-good version, not deletion or rewriting of history; record reason, authority, scope, time, and impact.
16. Emergency/break-glass change requires a separately approved limited procedure, immediate audit, independent review, and documented expiry/normalization. No specific roles or time limits are set here.
17. Separate view/propose/edit/review/approve/activate/emergency/audit capabilities. Enforce server-side scope and current authority at every action. No self-grant, impersonation, shared admin accounts, or hidden bypass.
18. Protect credentials, keys, and integration secrets through separate secret-management governance; never expose them in UI, logs, exports, or audit payloads.
19. Provide an authorized read-only configuration register and health/drift checks for invalid references, ownership gaps, conflicting versions, dependency mismatch, and unauthorized drift.
20. PM remains supervisory/read-only absent separately approved capability. Admin reports/exports are evidence, not authority.

**Open design details:** taxonomy/risk tiers, owner/authority matrix, inheritance/precedence, lifecycle/approval gates, version/hash format, effective-date/timezone rules, in-flight transition, validation/testing, staged activation/recovery, emergency procedure, environment promotion/import/export, secrets, drift detection, register/report, and communications.

**Implementation boundary:** design documentation only. No configuration schema/tables/migrations/generated types/settings UI/auth/RLS/workflow/numbering/feature flags/secret management/environment promotion/data migration/tests/merge/deployment changes are authorized or made.


## DEC-057 — Integration, API & External System Governance

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

1. Govern all external systems, API consumers/providers, file exchanges, webhooks, integrations, and data synchronization through a controlled integration register and per-integration approval.
2. SiteDocs remains authoritative for its governed document identities, revisions, workflows, approvals, signatures, Transmittals, acknowledgements, audit, and retention unless a separately approved domain ownership agreement states otherwise.
3. External connectivity or credentials do not grant workflow authority, approval/signature power, unrestricted access, or permission to bypass SiteDocs controls. Service identities cannot impersonate human users or provide human approval.
4. Register each integration's stable identity, business/technical owners, provider, environment, data domains, projects/parties, direction, permitted operations, classification, authentication, credential owner, lifecycle, support contacts, and approval.
5. Define data ownership and field-level source-of-truth rules. No assumed last-write-wins for SiteDocs-controlled fields or workflow decisions.
6. API access is authenticated, server-authorized, deny-by-default, least-privilege, and scoped to integration identity, project, party, record class, and operation. Recheck current authorization on every request.
7. Expose only explicit capabilities; no generic unrestricted CRUD/admin endpoints. APIs enforce the same validation, workflow, revision, visibility, attachment, and separation-of-duties rules as the UI.
8. Version API contracts, schemas, resource identities, errors, pagination, filtering, quotas/rate limits, compatibility, and deprecation. Avoid mutable labels or “latest” aliases as sole identifiers.
9. Define each data exchange's purpose, owner, source/target authority, field mapping, validation, transformations, classification, retention, errors, and reconciliation owner. Preserve source IDs/versions, timestamps, mapping version, integration identity, correlation, and validation outcomes.
10. Imported documents/files enter controlled intake and attachment validation. Import does not make a record official, approved, signed, issued, or accepted.
11. Export only authorized exact revisions/report snapshots and destinations; audit manifests, file identities/hashes, actors/integration, time, and outcomes. Preserve originals and transformation provenance.
12. Bidirectional sync requires field ownership, conflict resolution, version/concurrency checks, and audit; no silent overwrite of governed fields.
13. State-changing requests require idempotency/deduplication identity. Retries must not create duplicate business effects. Distinguish API acknowledgement, dispatch, transport delivery, consumer receipt, processing success, and business acknowledgement.
14. Webhooks/events are authenticated, scoped, versioned, and replay-resistant where applicable; consumers handle duplicate/out-of-order events safely. Partial failures remain visible per item/recipient.
15. Define bounded retry, backoff, dead-letter/quarantine, alerting, and reconciliation. Monitor availability, latency, failures, queue depth, schema drift, credential expiry, and suspicious activity; no service objective is set here.
16. Audit integration registration, credentials, auth/authorization, requests, exact object references, changes, exports, webhooks, retries, failures, and administration under DEC-055. Never log secrets or unnecessary sensitive payloads.
17. Apply DEC-054 retention/legal hold to integration logs, exchanged files, manifests, acknowledgements, and reconciliation evidence. Revocation/withdrawal cannot recall external copies automatically.
18. Define privacy, purpose, data minimization, residency/cross-border transfer, external processing, and deletion responsibilities per integration. No transfer permission is implied.
19. Require incident procedures for compromise, leakage, corruption, duplication, outage, schema drift, and disputed exchanges; include revoke/disable, evidence preservation, notification authority, reconciliation, and recovery.
20. Decommission by revoking credentials, disabling endpoints/transfers, reconciling in-flight messages, preserving required records, and documenting external-copy responsibilities; do not erase SiteDocs history.
21. New integrations and material scope changes require business need, data-flow and risk/privacy/security assessment, ownership/mapping, access matrix, test evidence, operational/incident plan, retention treatment, and competent approval before production activation.
22. Separate register/view, propose, configure, approve, activate, rotate/revoke, inspect, export, and decommission capabilities. No self-approval or self-grant.
23. This decision does not authorize any production connector, API consumer/provider, destination, or external data exchange; each requires specific approval and technical review.

**Open design details:** integration catalogue/risk tiers, API contract inventory, auth profiles, service identity lifecycle, quotas, idempotency/concurrency, webhook security/replay, file exchange, data ownership/mapping/conflict, ordering, retry/dead-letter/reconciliation, monitoring/service objectives, privacy/residency, external-copy obligations, incident response, decommissioning, and per-integration approval.

**Implementation boundary:** design documentation only. No API endpoints, credentials/service accounts/webhooks/connections/import/export/sync jobs/schema/database/storage/auth/RLS/grants/UI/tests/merge/deployment changes are authorized or made.


## DEC-058 — Data Import, Export & Migration Governance

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

1. Govern imports, exports, bulk exchanges, legacy migrations, and archive transfers through a documented purpose, accountable data owner, approved scope, controlled manifest, and operation-specific authorization.
2. Distinguish import, migration, synchronization, export, backup, restore, and archival transfer. Each has separate authority, validation, evidence, and risk; none substitutes for another.
3. Preserve SiteDocs' governed identities, revisions, workflows, approvals, signatures, Transmittals, responses, audit, and retention rules. Successful transfer or insertion does not make content official, approved, or accepted.
4. Every import/migration records source system and authority, source IDs/versions/timestamps, extraction/cut-off, operator/integration, batch/correlation ID, mapping/transformation version, target identity, and validation outcome.
5. Require an import manifest with stable source identities, expected record/file counts, sizes, hashes, target mapping, and exclusions. Preserve legacy identifiers; never fabricate historical SiteDocs issuance or renumber historical records.
6. Validate schema, required fields, controlled vocabularies, project/party/discipline references, numbering collisions, revisions, relationships, attachment bindings, timestamps, and referential integrity before commit.
7. Classify items as new, exact duplicate, possible duplicate, update candidate, conflict, invalid, unsupported, quarantined, or excluded. Ambiguous matches require human reconciliation; no title-similarity guessing or silent overwrite.
8. Preserve the meaning and provenance of legacy statuses, approvals, signatures, and events. Ambiguous legacy states must not be translated into current SiteDocs approvals or decisions.
9. Imported data remains staged/non-authoritative until validation and competent approval. Import does not grant access, create assignments, notify unauthorized parties, or bypass normal workflow.
10. Files must satisfy applicable quarantine, malware, type/size, integrity, private-storage, opaque-key, and document/project/company/revision binding controls. Metadata without verified bytes or bytes without verified binding is incomplete.
11. Define batch atomicity and per-item outcomes. Partial success must remain explicit. Stable batch/item identities and idempotency make safe retries possible without duplicate business effects.
12. Reconcile source and target counts, identities, relationships, file counts/bytes, hashes, exceptions, and rejected/quarantined items. Explain and approve discrepancies before completion.
13. Every export defines purpose, authorized requester/operator, scope, exact record/revision/report snapshot, filters, destination/recipient, format, classification, and handling obligations.
14. Recheck server-side authorization at selection, generation, and delivery. Counts, previews, filters, manifests, and errors must not disclose unauthorized information. Never silently substitute a different or “latest” revision.
15. Export manifests preserve selection context, timezone/date basis, actor/integration, recipient/destination, exact identities/versions, file hashes, transformation/tool version, exclusions, partial failures, and delivery outcome.
16. Protect exports in transit and at rest. No public link, unrestricted bulk endpoint, uncontrolled email attachment, or third-party destination is approved by default. Spreadsheet exports must prevent formula injection.
17. External copies are not automatically recalled by SiteDocs. Define recipient handling, onward sharing, retention/deletion responsibility, access expiry where supported, and incident notification.
18. Each migration requires a reviewed runbook: source freeze/cut-off or change capture, source evidence, staging, mapping lock, dry run, validation, approval, execution, reconciliation, exceptions, acceptance, and handover.
19. Require isolated rehearsal and verified recovery path before production migration. Rollback must identify exact batch, affected records/files, dependencies, recovery point, authority, and reconciliation; do not erase valid post-migration activity.
20. If clean rollback is unsafe after new authoritative activity, stop and use an approved forward-reconciliation/correction plan preserving history.
21. Completion requires source-to-target traceability, count/hash/file reconciliation, security/access verification, exception ownership, and explicit acceptance by the accountable data owner.
22. Separate propose/map/validate/approve/execute/pause/resume/reconcile/accept/export/evidence-review capabilities. No self-approval or self-grant; high-risk operations require separation of duties.
23. Audit all requests, approvals, manifests, mappings, dry runs, validations, item outcomes, retries, exceptions, reconciliation, exports, rollback/correction, and acceptance under DEC-055. Apply DEC-054 retention and legal hold to source snapshots, staging, manifests, exports retained, and evidence.
24. Define temporary staging/export-package retention and secure disposition. No disposal during active legal hold, investigation, reconciliation, or retention obligation. Logs must redact secrets and unnecessary personal/confidential content.
25. Provide an authorized import/export register and monitoring for progress, failures, duplicates, conflicts, quarantined items, hash mismatches, partial completion, export volume, and reconciliation gaps.
26. No import, export, migration, cutover, or production data processing is authorized solely by DEC-058. Each operation requires specific approval and a reviewed technical runbook.

**Open design details:** canonical data dictionary and record-class mappings; supported formats; duplicate/conflict resolution; legacy status/approval mapping; source-of-truth ownership; staging/quarantine; batch atomicity/idempotency; volume limits; encryption/destination controls; cutover/change capture; rollback/reconciliation acceptance; export expiry; temporary-data disposal; and operation-specific approval matrix.

**Implementation boundary:** design documentation only. No import/export job, migration, database/storage mutation, backup/restore, schema/mapping code, API/UI/auth/RLS/grant, file transfer, production data processing, tests, merge, or deployment change is authorized or made.


## DEC-059 — System Backup, Disaster Recovery & Business Continuity

**Status:** owner-approved design direction — 2026-11-11. Design only; not implemented.

1. Govern protection and recovery of database, private object-storage bytes, metadata/bindings, configuration, identity dependencies, integrations, report snapshots, and audit evidence.
2. Distinguish backup, replication, archive, restore, disaster recovery, high availability, and business continuity. Replication is not an independent backup; successful backup is not proof of recoverability.
3. Maintain component/dependency inventory with owners, criticality, recovery dependencies, and evidence source.
4. Define scope, method, frequency, consistency, retention, encryption, key custody, residency, immutability, access, monitoring, and disposal for each backup component.
5. Database and object-storage bytes must be protected independently and coordinated to a recoverable consistency point. A database backup alone does not preserve stored file bytes.
6. Preserve document/revision/attachment links, storage identities, hashes, signatures, report snapshots, Transmittals, audit events, and response/access evidence.
7. Protect backup copies from production failure domains, destructive credentials, ransomware, accidental deletion, and provider outage where feasible; assess isolated/offline/immutable copies.
8. Enforce encryption, separated key administration, least privilege, dual control for destructive operations, and immutable audit of backup/access/copy/restore/disposal.
9. Verify content integrity and periodic restore readability. Failed, stale, partial, corrupted, or inaccessible backups must remain visible and cannot replace the last known-good recovery point silently.
10. Apply DEC-054 retention and legal holds to backups, replicas, and recovery evidence, including provider-managed copies and secure disposition.
11. Restore into an isolated restricted environment first. Specify recovery point, database and storage sets, schema/config compatibility, keys, identity, application version, and recovery order.
12. Validate schema/policies, record counts, relationships, document/revision links, attachment bytes/hashes, signatures, report snapshots, audit continuity, permissions, and representative workflows before declaring recovery usable.
13. Reconcile database rows and storage objects separately but together; identify missing/orphaned metadata, missing bytes, unexpected objects, hash mismatches, and recovery-point gaps.
14. Do not silently erase legitimate post-recovery-point activity. Define replay/catch-up, business reconciliation, conflict handling, and authorization before reopening writes.
15. Audit restore operator/approver, source backup IDs, recovery point, environment, validation, exceptions, and go/no-go decision. Production cutover requires separate approval.
16. Maintain a business-impact analysis defining critical processes, disruption impact, dependencies, tolerable outage, data-loss tolerance, and recovery priority. No RPO, RTO, availability target, retention period, or contractual SLA is set by DEC-059.
17. Create scenario-specific playbooks for database/storage loss, corruption, regional/provider outage, credential compromise, ransomware, accidental deletion, release failure, integration outage, DNS/network failure, and key-personnel loss.
18. Define DR activation authority, incident command, technical/business roles, communications, escalation, evidence preservation, and invocation/deactivation criteria.
19. Define safe manual continuity processes, temporary records, unique references, restricted access, timestamps, attribution, and post-recovery reconciliation. Temporary records do not automatically become official SiteDocs records or approvals.
20. Define recovery sequencing for identity, secrets/keys, database, storage, application, integrations, notifications, network/DNS, and monitoring. Reconcile queues, credentials, scopes, and in-flight actions before resuming external integrations.
21. Prevent split-brain and conflicting official numbers, revisions, approvals, signatures, and notifications during failover/failback.
22. Communicate confirmed facts, affected scope, estimates, known gaps, and validation status accurately. Do not claim full recovery before technical and business acceptance.
23. Periodically test backup restores and end-to-end DR/BC, including database-plus-storage integrity, authorization, audit continuity, and business workflows. Test corrupted backups, missing objects, unavailable keys, stale configuration, revoked credentials, and interrupted recovery.
24. Use isolated/approved test environments and synthetic/de-identified data where possible. No destructive production test without separate authorization.
25. Maintain a controlled register of backup sets, coverage, verification, restore tests, playbook versions, owners, exceptions, and remediation.
26. Review plans after architecture/provider changes, incidents, migrations, failed tests, or changes in business criticality.
27. Apply DEC-021, DEC-054, DEC-055, DEC-056, and DEC-057 controls. Backup/restore access must never bypass authorization, conceal activity, erase audit, or rewrite historical decisions. PM remains read-only for business records absent separately approved capability.
28. Recovery completion requires technical verification and accountable business-owner acceptance, documenting residual loss, exceptions, recovered scope, limitations, and authority to resume operations.

**Open design details:** business-impact analysis/criticality; component inventory; backup technology/provider; frequency/retention; RPO/RTO; residency; immutability/key custody; database/storage consistency; restore order; reconciliation/replay; failover/failback; manual continuity; activation authority; test cadence/evidence; acceptance; ownership/cost.

**Implementation boundary:** design documentation only. No backup job/provider configuration/database export or restore/storage copy or replication/key operation/failover/production recovery/infrastructure or schema/database/storage/auth/RLS/API/UI change/test execution/merge/deployment is authorized or made by DEC-059.

## DEC-060 — System Monitoring, Logging, Alerting & Operational Observability

**Status:** Approved design direction; documentation only.

**Decision:** Establish a governed observability framework across application services, APIs, database, private object storage, authentication/authorization, background jobs and queues, notifications, integrations, reporting/export, backup/restore/DR, and infrastructure/provider dependencies.

**Required controls:**
1. Distinguish operational logs, metrics, distributed traces, security events, authoritative business/workflow events, DEC-055 audit records, alerts, and dashboards. Diagnostic telemetry never substitutes for the immutable audit trail or authoritative workflow state.
2. Use structured, correlated telemetry with synchronized UTC timestamps, component/environment/version, safe actor/service identifiers, correlation identifiers, outcome, error class, and duration as appropriate. Detect material clock drift.
3. Minimize and redact telemetry. Never record passwords, tokens, session secrets, private keys, signing secrets, or unnecessary document contents/personal data. Correlation IDs are not credentials.
4. Monitor relevant availability, latency, throughput, errors, resource saturation, database/storage health, queue backlog and age, job retries/dead letters, authentication/authorization anomalies, integration and webhook failures, notification delivery, report/export processing, backup freshness, restore verification, and integrity exceptions.
5. Keep operational alert severity distinct from DEC-039 user-notification priority. Define alert criteria, ownership, deduplication, suppression, escalation, recovery, and routing in a separately governed catalogue. No fixed thresholds, SLA, SLO, RPO, or RTO is approved here.
6. Route alerts only to designated authorized operational owners. Minimize sensitive content in alert payloads and dashboards. Specific channels, on-call schedules, and contact methods require separate approval.
7. Separate liveness, readiness, and dependency health. Public health responses must not expose sensitive internal details. Dashboards are role-controlled and disclose freshness and gaps; PM remains read-only under DEC-021.
8. Use distributed tracing as a diagnostic aid, not as the sole audit/security/business evidence. Sampling must not omit mandatory audit or required security evidence.
9. Detect suspicious access, credential abuse, privilege/configuration changes, unusual bulk retrieval/export, integration abuse, and telemetry-pipeline failure. Preserve evidence and use an approved incident-response process.
10. Monitoring must not autonomously approve, sign, delete evidence, alter permissions/numbering, or change workflow state. Automated remediation requires separate explicit approval and safeguards.
11. Design for buffering, backpressure, loss detection, storage exhaustion, and recovery of telemetry pipelines. Diagnostic logging failure must not weaken DEC-055 mandatory audit reliability.
12. Govern telemetry ownership, classification, access, retention, legal hold, and change history under DEC-054/055/056; align integration and backup monitoring with DEC-057/059.

**Open details:** component inventory, tooling/provider, event taxonomy, severity, metrics/formulas, thresholds, SLI/SLO/SLA, alert routing/on-call, channels, escalation, sampling, residency/encryption, retention, dashboards, detection rules, incident runbooks, synthetic checks, pipeline resilience, ownership and cost.

**Implementation boundary:** no agents/tools, infrastructure/provider configuration, code/API/database/storage/auth/RLS changes, telemetry schema, dashboards/alerts deployment, integration credentials, automated remediation, production tests, merge, or deployment is authorized or made by DEC-060.

## DEC-061 — Incident Management & Problem Management

**Status:** Approved design direction; documentation only.

**Decision:** Establish a controlled incident and problem-management framework for SiteDocs covering operational/service, security/privacy, data-integrity, monitoring, integration/provider, backup/restore, and business-continuity incidents.

**Core distinctions:** An incident requires coordinated response to actual or credible potential impact. A problem is an underlying cause, contributing condition, or recurring risk. An incident may be resolved while its problem remains open; a problem may be identified before an incident occurs.

**Required controls:**
1. Maintain a stable incident record capturing detection/occurrence times and uncertainty, source, affected services/components, category, provisional severity, impact, scope, owner, timeline, actions, evidence, communications, related records, recovery validation, and closure.
2. Keep operational severity distinct from DEC-039 notification priority and all document/WIR workflow states. Define severity, impact, escalation, and reclassification in a separate matrix. No fixed SLA, SLO, response time, or contractual commitment is approved.
3. Govern lifecycle: detect/report → register/acknowledge → triage/assess → coordinate → contain → correct/eradicate → recover/validate → resolve/close → post-incident review.
4. Define accountable incident lead/commander and least-privilege responders. Incident coordination does not grant document approval, signature, project administration, unrelated data access, or DEC-021 bypass. Emergency access requires separate policy, time limits, attribution, monitoring, and retrospective review.
5. Treat suspected unauthorized access, credential compromise, data exposure/exfiltration, privilege abuse, tampering, signing/approval abuse, and audit compromise as security-relevant pending assessment. Escalate possible privacy/legal/regulatory duties to authorized specialists; do not infer legal obligations or deadlines.
6. Preserve evidence and chain of custody, including audit records, source data, storage objects/metadata/hashes, access decisions, and configuration history. Do not overwrite or destroy evidence during containment or recovery.
7. Govern emergency changes with explicit authority, scope, risk assessment, separation of duties, validation, rollback/forward-fix, and review. Urgency is not unrestricted permission.
8. Align recovery with DEC-059 and changes with DEC-056. Validate data integrity, revision/attachment relationships, audit completeness, access boundaries, and business functionality before declaring recovery. Manual continuity records remain attributable and are reconciled; they are not approvals.
9. Record stakeholder communications with authorized sender, audience, verified content, channel, timestamp, and outcome. No unsupported restoration promises, breach-scope declarations, or regulatory conclusions.
10. Maintain problem records linking related incidents, confirmed/suspected causes, contributing factors, workarounds, corrective/preventive actions, owners, approved target dates, and effectiveness checks. Hypotheses and unknowns must remain explicit; a workaround is not permanent resolution.
11. Track material incident/problem history append-only; corrections are linked new entries. Apply DEC-054 retention/legal hold and DEC-055 audit.
12. Review trends and corrective-action effectiveness with disclosed metric definitions and limitations. Link detection to DEC-060, configuration to DEC-056, integrations to DEC-057, and backup/DR to DEC-059.

**Open details:** taxonomy, severity matrix, reporting channels, roles/on-call, emergency access/change, security/privacy/legal escalation, communications, provider coordination, recovery objectives, evidence procedures, root-cause method, problem triggers, corrective-action governance, metrics, retention mapping, exercise cadence, staffing and cost.

**Implementation boundary:** no incident tooling/ticketing integration, paging/on-call configuration, security operations tooling, emergency access, production containment, credential rotation, restoration, code/API/database/storage/auth/RLS/configuration change, automated remediation, production exercise, merge, or deployment is authorized or made by DEC-061.

## DEC-062 — Change Management & Release Governance

**Status:** Approved design direction; documentation only.

**Decision:** Establish a risk-based, auditable lifecycle for changes and releases across SiteDocs software, UI, APIs, database/data, storage, authentication/authorization/RLS, integrations, infrastructure/provider configuration, operational procedures, report definitions, templates, and governance configuration.

**Required controls:**
1. Every change has a stable ID, requester, owner, scope, reason, dependencies, linked decisions/incidents/problems, risk assessment, implementation/test plan, approvals, execution record, verification, communications, and rollback/forward-fix plan.
2. Define a controlled taxonomy and risk-based classes (for example routine pre-authorized, normal, emergency) with separately approved eligibility and authority. Small or reversible does not automatically mean low-risk.
3. Assess security, privacy, data integrity, auditability, signing/approval, authorization, availability, continuity, compatibility, dependencies, migration, external copies, and user impact. Record unknowns and residual risks.
4. Separate request, review, approval, implementation, validation, and release authorization capabilities. Apply separation of duties; exact scope/artifact/environment and evidence must be approved. Material scope or artifact changes reopen approval.
5. Use separated development/test/staging/production environments and least-privilege environment-specific access. Protect production data in lower environments; use synthetic or appropriately masked data unless separately authorized.
6. Define acceptance criteria and retain proportionate peer-review, automated, functional, security, negative-authorization, regression, migration, performance, accessibility, recovery, and business-acceptance evidence. Disclose skipped/failed/incomplete tests honestly.
7. Treat database/schema/data, generated types, RLS/grants, storage/bindings, identity/authorization, secrets, signing, and numbering as high-impact controls requiring explicit change-specific review. DB/storage changes require verified database and object-storage backups, isolated restore rehearsal, reconciliation, and recovery strategy. A database-only backup is insufficient for stored files.
8. Give each release a unique immutable identity tied to exact source commits, artifact/hash, approved change IDs, versions/dependencies, target environment, evidence, release notes, approvals, deployment actor/time, and verification.
9. Deploy only the exact approved release and scope. Record prechecks, deployment, deviations, post-deployment health/security/data/integration/workflow verification, and business acceptance as applicable.
10. Define rollback, roll-forward, or compensating actions and authority. Do not assume code rollback reverses schema/data changes or recalls external copies. Rollback itself is controlled and audited.
11. Emergency changes require a separately approved narrow policy, declaration authority, scope, minimum checks, evidence, communication, validation, recovery plan, and mandatory retrospective review. Emergency status is not a routine bypass.
12. Confirm operational readiness including DEC-060 monitoring, DEC-061 incident readiness, DEC-059 recovery, support ownership, and user communication.
13. Preserve append-only change/release history and link later corrections/reviews. Apply DEC-054 retention, DEC-055 audit, DEC-056 configuration, DEC-060 observability, and DEC-061 incident/problem governance.

**Open details:** taxonomy, risk matrix, pre-authorized catalogue, approval roles, emergency policy, environments, data masking, test standards, CI/CD/branch protections, artifact provenance/signing, versioning, deployment strategy/windows, migration/storage recovery, rollback criteria, communications, readiness checklist, review triggers, retention, metrics, ownership and cost.

**Implementation boundary:** no code change, merge, pipeline configuration, release/deployment, database migration/data mutation, storage/auth/RLS/grant/secret/key change, infrastructure/provider or integration change, automated remediation, production test, or operational execution is authorized or made by DEC-062.

## DEC-063 — Access Reviews & Periodic Permission Recertification

**Status:** Approved design direction; documentation only.

**Decision:** Establish periodic and event-driven review of human and non-human identities, project/party assignments, effective capabilities, privileged access, integrations, service accounts, emergency grants, and access to documents, drafts, revisions, attachments, reports, exports, archives, transmittals, audit evidence, and administration.

**Required controls:**
1. Produce a reproducible access-review snapshot with as-of time, source systems, scope, policy/version, identities, assignments, effective/inherited grants, reviewers, approvers, findings, exceptions, and evidence references.
2. Review effective access paths, not merely visible role labels. Include indirect grants, groups, APIs, storage policies, service roles, caches, sessions, tokens, and non-human principals where applicable. Unknown inventory coverage is a recorded limitation, not proof of no access.
3. Use periodic and event-driven triggers: onboarding, transfer, role/discipline/project changes, assignment expiry, offboarding, suspension, permission/policy changes, inactivity/anomaly, incident, and emergency-access use. Exact cadence and deadlines require separate approval; no universal interval or SLA is set.
4. Separate evidence preparation, business-need confirmation, technical/security review, and approval as applicable. Users cannot be sole reviewers/approvers of their own access. PM supervisory confirmation does not grant technical or workflow authority.
5. Record explicit outcomes: Retain, Modify, Revoke/End, Time-bound exception, Investigate, or Not applicable with reason. Exceptions require scope, justification, compensating controls, approver, expiry/review date, and escalation.
6. Apply changes through governed identity/roster/authorization processes and verify effective revocation or modification across relevant paths. Failed/partial remediation remains open. No universal revocation time is approved here.
7. Joiner/mover/leaver controls must block future unauthorized access/actions when assignments end or change. Preserve historical signatures, approvals, decisions, comments, uploads, and audit attribution; never delete or reassign history because access ends.
8. Inventory non-human and privileged identities with accountable owner, purpose, approved scope, environment, dependency, credential/key custody, review/rotation basis, and expiry/renewal. No shared human accounts or unattributed service credentials.
9. Emergency/break-glass access is exceptional, attributable, least-privileged, time-limited, monitored, and independently reviewed after use.
10. Verify changes with evidence, including positive/negative access tests where appropriate. Non-response is not approval; incomplete inventories, overdue reviews, and unresolved discrepancies remain visible.
11. Preserve review snapshots, decisions, exceptions, remediation and verification under DEC-054 retention and DEC-055 audit. Align roster/capabilities with DEC-020/021, configuration with DEC-056, monitoring with DEC-060, and incident-triggered review with DEC-061.

**Open details:** cadence/risk tiers; source-of-truth inventory; reviewer/approver matrix; snapshot format; effective-permission calculation; joiner/mover/leaver timelines; session/token/cache revocation; service-account lifecycle; privileged/emergency access; exception duration/escalation; verification methods; tooling/reminders; metrics; retention; ownership and cost.

**Implementation boundary:** no identity-provider or account changes, grants/revocations, RLS/grant/policy changes, token/secret rotation, service-account creation, integration change, production access test, automated recertification/remediation, code/database/storage/auth/API/UI change, merge, or deployment is authorized or made by DEC-063.

