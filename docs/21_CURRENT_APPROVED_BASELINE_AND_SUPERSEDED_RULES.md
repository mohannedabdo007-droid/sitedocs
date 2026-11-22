# 21 — Current Approved Baseline and Superseded Rules Policy

**Status:** Approved project governance direction  
**Applies to:** Project Knowledge, application behavior, database configuration, workflow defaults, reference data, imports, reports, tests, and repository documentation  
**Branch:** `dev/review-fixes`

## 1. Governing decision

The project must operate only according to the latest explicitly approved requirements and decisions. Any older instruction, workflow rule, default, label, role mapping, reference-data value, configuration, or implementation that conflicts with a newer approved decision is **superseded and must not be used operationally**.

This does not authorize deleting historical records, audit trails, source backups, or old documentation. Preserve them for traceability, but clearly mark them as historical/superseded and prevent them from silently controlling current behavior.

## 2. Precedence rules

Apply the following order when determining what is current:

1. The user's latest explicit and approved decision for the project.
2. The consolidated current approved baseline and decision register.
3. The latest approved project requirements and architecture records.
4. Current implementation only where it conforms to the approved baseline.
5. Older documents, seed data, defaults, code, and imported conventions are historical evidence only where superseded.

A newer timestamp alone does not authorize an unapproved change. If two current approved decisions appear to conflict and precedence cannot be determined from explicit wording, record the conflict and request a decision; do not guess.

## 3. Current baseline that supersedes conflicting legacy rules

### Disciplines
Exactly five canonical disciplines:
- ARC — Architectural
- CIVSTR — Civil & Structural (one combined discipline)
- MEC — Mechanical
- ELE — Electrical
- SUR — Survey

Legacy STR and CIV values may remain in historical records for traceability, but must normalize to CIVSTR for current reporting and new reference-data use. Do not recreate a separate Structural discipline.

### Document types and workflows
- RFI means **Request for Inspection** only and is separate from WIR.
- MQR means **Monthly Quality Report** and follows its own independent workflow.
- MQR must not inherit the generic A/B/C/D/E/I response-code cycle by default.
- Drafts remain confidential from other parties before formal submission, subject to the approved read-only Project Manager oversight exception.
- Project Manager is a distinct read-only project role: may view all project documents, including drafts, but may not edit, submit, review, respond, return, approve, or close.
- X1 visibility is limited to P2 documents for that company, according to the approved access model.

### Response codes
Current approved meanings:
- A — Approved
- B — Approved as Noted
- C — Revise and Resubmit
- D — Rejected
- E — Cancelled by Contractor; initiated by the originating contractor, not a reviewer
- I — For Information Only; closes the review cycle and is archived, and is excluded from B/C KPI calculations

Older labels, outcomes, or default response-code seeds that conflict with these meanings are superseded. Updating a display label alone is not sufficient; lifecycle behavior, actor authorization, archive behavior, and KPI semantics must also conform.

### Workflow authority and security
- Workflow actions belong to the authorized party at the current workflow step.
- Admin status does not automatically grant authority to act for another workflow party.
- Originators must not review or approve their own submissions.
- Project Manager remains read-only.
- Draft confidentiality and document-aware attachment access must be enforced by authoritative server-side authorization, not UI visibility alone.

## 4. Required treatment of superseded material

For each legacy item discovered:

1. Preserve it if it is part of audit history, source history, imported history, or a backup.
2. Mark it as `SUPERSEDED` or `HISTORICAL — NOT FOR CURRENT OPERATION` in the relevant documentation/register.
3. Record the replacement decision and its source/report.
4. Identify whether it is merely documentation, or is still active in code, seed data, database configuration, imports, or UI.
5. If it remains operational, create a remediation item and a test proving the replacement behavior.
6. Do not silently rewrite historical audit events or imported source values. Use explicit canonical mapping while retaining original values where traceability requires it.

## 5. Application and repository controls

- Treat reports 12–20 as audit evidence and remediation analysis, not proof that implementation fixes have been applied.
- This policy is the governing rule for deciding which legacy findings/defaults conflict with current approved requirements.
- Update the consolidated decision register and Lovable Project Knowledge when the Lovable workspace is available; Lovable currently reported that the workspace was out of credits, so no claim is made that its Knowledge has been updated by this report.
- Keep changes on `dev/review-fixes` until reviewed.
- Do not merge PR #1 or deploy to `main` without explicit approval.
- Do not apply database changes or migrations without a verified independent backup, successful restore test, and explicit approval for the specific migration.
- Do not change permissions, secrets, branch protections, or external settings without specific authorization.

## 6. Status and verification boundary

This document records the approved governance rule and the current baseline. It does not itself change application code, database rows, live project configuration, Lovable Knowledge, or historical records. Operational conformance must be verified separately through source review, database catalog/configuration checks, and authorized integration tests.
