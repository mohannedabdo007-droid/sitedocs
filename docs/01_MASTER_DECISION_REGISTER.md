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
