# POL-SCAN-003 — Paper Scanning and In-SiteDocs Electronic Signature Lifecycle Design

**Document ID:** POL-SCAN-003  
**Version:** 1.0 — DESIGN FOR OWNER REVIEW  
**Date:** 2026-11-11  
**Status:** APPROVED DESIGN DIRECTION / DETAILED WORKFLOW PROPOSAL — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `governance/scan-lifecycle-design-2026-11-11`  
**Related decisions:** DEC-016 (primary scanned file and additional scan attachments); DEC-017 (paper and electronic lifecycle selection)  
**Related specifications:** POL-SCAN-001 and POL-SCAN-002

> This document defines the proposed operational lifecycle for two distinct document-finalization routes. It does not authorize schema, database, Storage, authentication, signing-provider, or production changes. All technical controls below are target requirements until separately implemented and verified.

## 1. Owner-approved route selections

1. **Electronic route:** signatures and approvals are performed inside SiteDocs, by each person's own authenticated account and within that person's assigned role, party, workflow step, and permissions.
2. **Paper route:** final scanning begins only after all required handwritten signatures and paper approvals have been completed on the controlled paper copy.

The routes share document identity, revision control, auditability, final-record handling, and access-control principles, but they must not be collapsed into one ambiguous workflow.

## 2. Core lifecycle principles

- A document's business review/approval state is distinct from its PDF-rendering, scanning, and archival state.
- No user may sign, approve, or complete another person's assigned action merely because they can view the document or hold an administrative role.
- The project manager's approved oversight visibility remains read-only; it grants no signature or approval authority.
- Draft confidentiality and separation of duties apply throughout both routes.
- A signature/approval event must identify the authenticated actor, their effective role/party, the exact document and revision, the action, and a trusted server timestamp.
- Final records are immutable. A correction after finalization creates a new controlled revision or formally superseding record; it does not silently replace the prior final PDF.
- A scan or PDF attachment does not itself create approval, alter numbering, advance a revision, or change review outcomes/KPIs.
- The final PDF must be traceable to the exact content/revision that was reviewed and approved.
- WIR and RFI remain separate document workflows; this design does not merge them. MQR remains governed by its independent workflow.

## 3. Route A — Paper document: sign on paper, then scan

### A1. Prepare and register the controlled document
1. The originating authorized party creates or registers the document in SiteDocs and selects the applicable project, document type, discipline, and workflow configuration.
2. SiteDocs assigns/retains the stable document identity and revision according to the existing approved numbering rules.
3. The document is marked as a paper-signature route. The controlled paper issue must identify the document number, revision, issue date, and page count or equivalent completeness marker.
4. The controlled paper copy is issued to the authorized review/signature sequence. SiteDocs records the issue event and intended recipients/steps; this is not yet a completed signature.

### A2. Complete paper review and signatures
5. Each authorized reviewer/approver examines the same controlled revision and records the required handwritten signature, printed name/role where required, date, and decision/approval evidence on the paper copy.
6. The paper sequence follows the configured project/contract procedure. No missing signature may be inferred from a later person's signature.
7. If comments, rejection, or a required revision prevents final approval, the document returns to the appropriate correction/revision path. The incomplete paper copy is not treated as the final approved record.
8. Where a new revision is required, issue and sign the new controlled revision. Preserve the previous paper trail and its status; do not relabel it as the newly approved revision.

### A3. Paper completion gate — before scanning
9. The responsible records/document-control user verifies that every required signature and approval is present for the exact document number and revision.
10. Verify signer identity/role as evidenced by the project's procedure, signature dates, legibility, page completeness, attachments/annexes, and that no pages belong to another revision.
11. Record a paper-completion checklist outcome: **Ready to Scan** or **Returned — Incomplete/Defective**. This is a records-control gate, not a substitute for the authorized technical approval.
12. **Only a Ready to Scan copy may enter the final scanning queue.** Interim/final scanning before completion is not part of this approved route.

### A4. Scan and quality control
13. Scan the complete signed paper set using the approved scanning equipment/process.
14. Combine pages into one primary PDF for that document/revision, preserving the paper page order and orientation. Additional annexes or supporting records may be separate additional files linked to the same transaction/revision.
15. Check page count, readability, resolution, orientation, cropping, missing/duplicate pages, signature visibility, stamps, annotations, and attachment completeness.
16. If the scan fails quality control, rescan the affected set before final registration. Do not delete or silently overwrite an already registered final record; use a documented replacement/supersession event if a registered file must be corrected.

### A5. Register, verify, and archive
17. Upload/register the primary scanned PDF against the stable document identity and exact revision; add supplementary files as additional attachments.
18. Show the short primary-file name in the document register row. Opening/previewing/downloading must enforce the parent document's authorization and confidentiality rules.
19. Record scan operator, scan timestamp, source route = paper, document/revision identity, quality-control result, page count, and file integrity metadata (such as size and cryptographic hash) as target audit evidence.
20. Mark the record **Scanned — QC Passed** and then **Archived/Final Record** only after the required metadata and file checks succeed.
21. Retain the physical original according to the separately approved project/contract retention policy. This design does not invent a retention period or authorize destruction of paper originals.

**Paper route terminal states:** Ready to Scan → Scanned — QC Passed → Archived/Final Record; or Returned — Incomplete/Defective; or Scan QC Failed (rescan required).

## 4. Route B — Electronic document: sign and approve inside SiteDocs

### B1. Create and prepare the electronic document
1. An authorized originator creates the document in SiteDocs, selects project/type/discipline, and prepares the content and supporting references.
2. The document remains a draft and confidential to its originating party until formally submitted, subject to the approved project-manager read-only oversight exception.
3. Before submission, validate required fields, attachments, document identity, revision, and configured review sequence.
4. Freeze a reviewable content snapshot for the submitted revision. Subsequent edits must not mutate the content already being signed; material edits require a controlled new revision or a restart of the applicable approval sequence.

### B2. Submit and route actions
5. The originator formally submits the revision. SiteDocs records the submission event and routes it to the first authorized workflow step.
6. Each assigned person signs in using their own SiteDocs account. The system checks account authentication, active project membership, party, role, assigned workflow step, document/revision visibility, and action-specific permission at the time of action.
7. The signer reviews the exact submitted revision and records the permitted action: sign/approve, return for correction, reject, or another explicitly configured action. Do not expose actions that are not permitted for that step.
8. On a successful signature/approval, record an append-only event containing actor user ID, displayed identity snapshot, effective role/party, action, document ID, revision ID, content snapshot/hash, server timestamp, and relevant workflow step. Do not store passwords, session tokens, or other secrets in the audit event.
9. Advance to the next configured authorized signer only after the current step succeeds. Parallel steps may run only where the approved project workflow explicitly defines them.
10. A user cannot sign for another user, self-approve their own originating document where separation of duties applies, or use admin/PM visibility as a substitute for an assigned approval.
11. If returned/rejected, stop the current approval chain and route the document to the originator for correction or the configured resolution path. A changed content revision must be resubmitted and signed against its own frozen snapshot; prior signature events remain in history and are not carried forward as signatures on changed content.

### B3. Final signature and finalization gate
12. After all mandatory signatures and approvals for the exact revision are complete, SiteDocs performs a server-side completeness check against the configured workflow. A missing, revoked, expired, or invalid required authorization prevents finalization.
13. The system records the final approval event and transitions the revision to **Approved — Awaiting Final PDF**.
14. The system then locks the approved content snapshot against ordinary editing and generates the final PDF rendition from that exact approved snapshot.
15. The PDF must include or reliably accompany the document number, revision, finalization timestamp, and an approval/signature summary identifying each signer, role/step, action, and timestamp. The rendered content and approval evidence must be bound together so a later content change cannot appear to retain the prior approval.
16. Validate PDF generation success, page count, readability, content/hash correspondence, and presence of the expected approval summary. If generation or validation fails, retain the approval event but mark finalization as **PDF Generation Failed / Retry Required**; do not claim the final PDF exists.
17. On successful validation, store/register the final PDF as the primary final record for that revision, mark the revision **Finalized — PDF Archived**, and preserve the signed approval event history.
18. Any later correction requires a new controlled revision or superseding record and a new approval cycle as configured. Never overwrite the prior final PDF.

### B4. Electronic route terminal states
- In Progress — Awaiting Signature
- Returned for Correction
- Rejected/Closed (only where configured)
- Approved — Awaiting Final PDF
- PDF Generation Failed / Retry Required
- Finalized — PDF Archived

The exact business outcome vocabulary for each document type must remain aligned with its approved workflow. This design does not impose WIR/RFI response codes on MQR.

## 5. PDF timing — controlling distinction

For the approved **in-SiteDocs signature route**, the final archival PDF is generated **after the last required signature and final approval**. The content snapshot is frozen for review before signatures, but the final PDF is produced only after the approval-completeness gate succeeds.

This differs from a third-party PDF-signing workflow, where a PDF may need to exist before signatures are applied. That external-PDF-signing route is not selected by the owner and is outside this design.

## 6. Shared record model and user-facing status separation

The UI should present separate, clearly named status dimensions rather than one overloaded status:

| Dimension | Paper route examples | Electronic route examples |
|---|---|---|
| Review/approval | Awaiting Paper Signatures; Paper Approval Complete | Awaiting Signature; Returned; Approved |
| Records processing | Ready to Scan; Scanning; QC Failed; QC Passed | Awaiting Final PDF; PDF Generation Failed; PDF Archived |
| Archive | Archived/Final Record | Finalized — PDF Archived |

These are design labels, not a claim that the existing database already supports them.

## 7. Audit, integrity, and access requirements

- Enforce authorization on the server for every submit, sign, approve, return, reject, finalize, upload, preview, and download action.
- Re-check permissions at action time; do not rely on a stale UI state or a previously opened page.
- Bind every signature event and final PDF to an immutable document/revision/content snapshot.
- Preserve a chronological append-only audit trail. Corrections are new events; do not erase earlier attempts or decisions.
- A project manager may view records for oversight only and cannot sign/approve unless separately assigned a permitted action under an explicitly approved role/party policy.
- Draft visibility and attachment visibility must follow the parent document's party/document-level access rules, not project membership alone.
- The primary PDF and additional attachments follow DEC-016 and POL-SCAN-001/002. One primary designation per transaction/document at the relevant point in time; preserve superseded files and historical revision associations.
- Do not let scan/upload/preview/download actions alter document numbering, revision sequencing, workflow outcomes, response codes, or KPIs.
- Do not infer legal enforceability, identity-proofing level, certificate status, or compliance with a jurisdiction-specific e-signature law from an account login alone. These require a separate legal/contractual and technical assessment before production use.

## 8. Exception handling

| Exception | Required handling |
|---|---|
| Missing paper signature/stamp/page | Stop before scanning; return as incomplete. |
| Illegible or damaged paper scan | QC fail; rescan; preserve registered history if already filed. |
| Wrong revision scanned | Quarantine/flag; do not mark final; correct the document/revision association through an audited process. |
| Electronic signer lacks permission | Deny action server-side and record a security-relevant denial event where appropriate. |
| Signer unavailable/replaced | Use a formally authorized reassignment/delegation policy if separately approved; never impersonate the original signer. |
| Content changes after one or more signatures | Invalidate completion for the changed content; issue/restart on a new controlled revision; retain earlier events. |
| Final PDF generation fails | Keep approval history; mark retry-required; do not mark archived/final until a validated PDF exists. |
| Duplicate upload or replacement request | Preserve the earlier file and record a supersession/replacement event; no silent overwrite. |

## 9. Acceptance scenarios for later implementation

1. Paper scan cannot enter final queue while any required paper signature is missing.
2. Paper scan is rejected if document number/revision does not match the registered transaction.
3. A complete paper set produces one primary PDF and may include additional annex files.
4. QC detects missing, duplicate, unreadable, or incorrectly oriented pages.
5. Only authorized records personnel can register/mark QC completion, subject to the final role matrix.
6. Electronic signature is accepted only from the signer's own authenticated account and an authorized workflow assignment.
7. An unassigned user, project viewer, or PM acting only under oversight visibility cannot sign or approve.
8. Originator self-approval is denied where separation of duties applies.
9. Every electronic signature event is bound to the exact document/revision/content snapshot.
10. A content edit after a signature prevents the changed content from inheriting the prior signature.
11. Final PDF generation does not start before all required signatures and approvals succeed.
12. A failed PDF generation does not falsely mark the record as finalized or archived.
13. Final PDF content and approval summary correspond to the same approved revision.
14. A later revision preserves the earlier final PDF and signature history.
15. Scan and PDF operations do not alter numbering, workflow decisions, response-code results, or KPIs.
16. Unauthorized preview/download of either paper scan or final electronic PDF is denied server-side.

## 10. Items deliberately left open for separate approval

- Exact role/party mapping for paper records-control actions (paper issue, completeness check, scan upload, QC, archive).
- Exact signer sequence and whether any steps may be parallel, per project/document type.
- Whether the signer must enter a reason/comment with each approval or return.
- Whether a signer may withdraw/revoke an action before finalization, and the authority/audit requirements.
- Account assurance requirements (MFA, re-authentication, session freshness) for high-impact signatures.
- Whether a visual signature mark is rendered in the PDF, versus a verifiable approval register/summary, or both.
- Jurisdiction-specific legal/contractual e-signature requirements and any external identity/certificate integration.
- PDF generation engine, long-term preservation format, timestamps, hash algorithm, malware scanning, file limits, retention, and backup details.
- Paper original custody, retention duration, and authorized destruction process.
- Exact statuses and UI wording after reconciliation with each document type's workflow.

No default values above should be treated as approved where an item is listed as open.

## 11. Explicit non-authorization

POL-SCAN-003 authorizes design review only. It does **not** authorize:
- database/schema/table/column/enum/function/trigger changes;
- migrations or generated type changes;
- Storage bucket, object, policy, upload, or download changes;
- changes to authentication, authorization, RLS, grants, or production settings;
- implementation or activation of e-signature/PDF-generation services;
- merging to main or deployment.

All such work requires a separate exact plan, required PostgreSQL and Storage backup, successful isolated restore, ownership-compliant workflow, security review, acceptance tests, and explicit owner approval.

**End of POL-SCAN-003.**


## 12. Personal signature library and per-transaction signature upload — DEC-018

**Owner-approved selection (2026-11-11):** support both a reusable personal signature asset and a one-off signature asset for an individual transaction. Accept PDF and JPEG uploads. Every signature asset and every applied signature must be attributable to its owner and linked to the relevant approval record.

### 12.1 Signature library in the user's account
1. Provide a **My Signatures** area in the authenticated user's account.
2. Allow the user to upload a reusable signature asset in PDF or JPEG format.
3. Preview the uploaded asset and require the user to confirm that it is their signature before making it available for their own signing actions.
4. Bind the asset to the authenticated account owner. Other users must not be able to select, download, or apply it as their own.
5. Allow the owner to replace or retire their active signature asset. Preserve historical versions and the audit trail; do not silently replace the signature asset already used on a completed transaction.
6. Re-authenticate or otherwise apply an approved step-up check before high-impact use, subject to the still-open account-assurance policy in §10.

### 12.2 One-off signature for a transaction
1. At an assigned signing step, allow the authorized signer to use their saved personal signature or upload a different signature asset specifically for that transaction.
2. Accept PDF and JPEG for the one-off upload as well.
3. Require explicit confirmation by the authenticated signer before applying the asset to the document.
4. The one-off asset is scoped to that transaction/document revision and must not silently become the user's reusable default signature.
5. A signer may not upload or apply another person's signature, and an uploaded asset alone never constitutes an approval.

### 12.3 Applying the visual signature and recording approval
1. Show the signer a preview of the exact document revision and the proposed signature placement before confirmation.
2. Record the authenticated signer, role/party, workflow step, document ID, revision ID, content snapshot/hash, signature asset identifier/version, asset source (saved personal library or one-off transaction upload), action, and server timestamp.
3. Apply the visual signature only as part of the signer's explicit authorized approval action. Keep the approval event and visual mark bound to the same content snapshot.
4. After the final required signature and approval, generate the final PDF and validate the signature marks/approval summary against the recorded events before archival.
5. Preserve the original uploaded signature asset securely, with access limited to its owner and the authorized signing service/process. Do not expose a public URL or treat the signature image as an ordinary public attachment.
6. If the content changes after signing, do not carry the visual signature forward to the changed content. Start the required new revision/approval cycle and retain the earlier signed record.

### 12.4 File-format handling and safeguards
- **JPEG:** accept as a raster signature image, subject to file validation and safe rendering.
- **PDF:** accept as an uploaded signature source document. Before applying it, the interface/process must identify the intended page and signature region or provide a reviewed placement/selection method. Do not assume every PDF is a single-page image or automatically stamp every page.
- Validate actual file content against its declared type; reject malformed, encrypted/unreadable, oversized, or unsafe files according to limits that remain to be approved.
- Apply malware/content scanning and private storage controls before processing.
- Provide preview and explicit confirmation before a signature is applied.
- Do not permit a file upload, preview, or signature-asset update to create an approval event.
- A visual signature image is not, by itself, cryptographic proof of signer identity, non-repudiation, or legal enforceability. The authenticated approval event, immutable audit evidence, content binding, and applicable legal/contractual e-signature assurance are separate requirements.

### 12.5 Additional acceptance scenarios
1. A user can save a reusable PDF or JPEG signature asset in their own account.
2. A user can upload a different PDF or JPEG signature for one transaction without changing their saved default.
3. Another user cannot select or apply the asset as their own.
4. Uploading an asset without an explicit authorized sign action creates no approval.
5. The applied signature is linked to the exact document/revision/content snapshot and the signer account.
6. The audit record identifies whether the asset came from the saved library or a one-off upload and identifies its version.
7. A multi-page PDF signature source requires a defined page/region selection or equivalent reviewed placement; it is not blindly stamped across pages.
8. Replacing a saved signature does not alter previously signed records.
9. A content change after signature requires a new controlled approval cycle; the previous signature does not migrate to changed content.
10. A final PDF cannot be marked archived until signature placement and the approval-event summary pass validation.

**Boundary:** This feature is a design requirement only. No signature-file storage, database field, upload endpoint, PDF stamping service, account setting, permission, or production behavior has been implemented or changed.


## 13. Multi-role signature roster and signature slots by project party — DEC-019

**Owner direction (2026-11-11):** the signature workflow must support multiple named signatory slots for each participating party, not a single generic signature field. Each slot represents a distinct role/person and has its own signature and approval record.

### 13.1 Contractor signatory roster
Provide a contractor roster capacity of **10 signatory slots**. The owner identified these nine role categories:
1. Architectural engineer (ARC)
2. Civil & Structural engineer (CIVSTR)
3. Mechanical engineer (MEC)
4. Electrical engineer (ELE)
5. Surveying engineer (SUR)
6. Quality engineer
7. Health, Safety & Environment (HSE) engineer
8. Procurement engineer
9. Document Controller

The tenth slot is reserved as configurable/optional until the owner confirms its intended role. Do not invent a tenth role or force an unused slot to sign. The role catalogue and actual required slots may be configured per project/contract.

### 13.2 Consultant and owner/developer rosters
- **Consultant:** support up to 10 signatory slots, with role names, required/optional status, assigned people, and order configured per project/contract.
- **Developer/Owner:** support up to 5 signatory slots, likewise configurable by role and project/contract.
- These are roster capacities, not a requirement that every slot be populated or sign every document. Required signers depend on document type, discipline, contract, workflow, and approved delegation rules.

### 13.3 Slot identity, signature and completion rules
1. Each slot must identify the party (Contractor / Consultant / Developer-Owner), role, assigned individual account, and whether the slot is required or optional.
2. Each required slot has its own signing action, signature asset choice (saved personal asset or transaction-specific upload), and immutable approval event.
3. A signature in one slot cannot satisfy another slot, even if the same person holds multiple roles; each role assignment must be explicitly authorized and separately recorded.
4. A slot can only be signed by its assigned authenticated account with permission for that exact workflow step. No proxy signing or self-approval outside explicitly authorized role separation.
5. The system must show roster progress by party and slot (pending, signed/approved, returned/rejected, not required/waived with authorized reason); do not treat an empty optional slot as pending.
6. Finalization is blocked until all required slots across the applicable parties have completed the configured approval workflow. Optional slots do not block finalization.
7. Preserve the party, role, assigned account, slot, signature asset/version, document/revision/content hash, action, and server timestamp in the audit record.
8. Roster capacities and role definitions must be configurable without hard-coding a single universal signer sequence. The sequence/parallelism and role-to-document mapping remain project/contract configuration decisions.

### 13.4 Capacity note and unresolved point
The nine role categories explicitly named for the contractor do not yet account for all ten requested slots. Slot 10 is therefore reserved as configurable/optional pending owner clarification. The consultant's 10 and owner/developer's 5 are maximum supported capacities, not fixed mandatory signer counts.

**Boundary:** design only. No database/schema, user/role provisioning, signature slot UI, authorization policy, workflow engine, or production behavior has been implemented or changed.
