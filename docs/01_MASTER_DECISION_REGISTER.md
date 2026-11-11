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
| DEC-019 | Signature workflow supports up to 10 contractor signatory slots, up to 10 consultant slots, and up to 5 developer/owner slots. Contractor role categories explicitly named: ARC, CIVSTR, MEC, ELE, SUR, Quality, HSE, Procurement, and Document Controller. Each slot has its own assigned account, role, signature action, and approval audit record. Required/optional status and signer mapping are configured per project/contract. | APPROVED DESIGN DIRECTION — 2026-11-11 | Nine contractor role categories have been named for ten requested slots; slot 10 remains configurable/optional pending owner clarification. Capacity does not mean every slot is mandatory for every document. | Explicit owner direction in conversation, 2026-11-11. | Design distinct party rosters and per-role signature slots. Do not hard-code universal signer sequence or require unused slots. Detailed rules in POL-SCAN-003 §13. No implementation or DB changes authorized. |
