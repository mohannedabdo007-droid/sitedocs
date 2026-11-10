# 24 — Open Policy Decisions and Recommended Resolution Register

**Governing baseline:** Report 21  
**Execution/test plan:** Reports 22 and 23  
**Status:** Decision register and recommendations only. No decision below is treated as approved unless explicitly marked CURRENTLY APPROVED.

## 1. Purpose

Reports 21–23 establish the current baseline, remediation sequence and acceptance tests. Several implementation details still need precise definitions. This register prevents the implementation team from silently choosing behavior.

Use these statuses:
- **APPROVED:** explicitly decided by the project owner and binding.
- **PROPOSED:** recommended resolution for owner approval; not yet binding.
- **BLOCKED:** implementation must not guess or proceed until the decision is approved.

## 2. Decisions already approved — do not reopen or replace with legacy behavior

| ID | Status | Binding decision |
|---|---|---|
| DEC-A01 | APPROVED | Exactly five canonical disciplines: ARC, CIVSTR, MEC, ELE, SUR. Civil and Structural are one combined discipline. |
| DEC-A02 | APPROVED | Legacy CIV and STR values are aliases for CIVSTR in current mapping/reporting; preserve original historical values for traceability. |
| DEC-A03 | APPROVED | RFI means Request for Inspection only and is separate from WIR. |
| DEC-A04 | APPROVED | MQR means Monthly Quality Report and has an independent workflow, without generic A/B/C/D/E/I defaults. |
| DEC-A05 | APPROVED | A/B/C/D meanings are Approved / Approved as Noted / Revise and Resubmit / Rejected. |
| DEC-A06 | APPROVED | E means Cancelled by Contractor and is initiated by the originating contractor, not the reviewer. |
| DEC-A07 | APPROVED | I means For Information Only; it closes the review cycle, archives the document, and is excluded from B/C KPI calculations. |
| DEC-A08 | APPROVED | Drafts are hidden from other parties before formal submission, with the distinct read-only PM oversight exception. |
| DEC-A09 | APPROVED | PM is a distinct read-only role with visibility of all project documents including drafts; no document edits or workflow actions. |
| DEC-A10 | APPROVED | X1 visibility is restricted to P2 documents for that company. |
| DEC-A11 | APPROVED | Admin role does not automatically confer authority to act for another workflow party. |
| DEC-A12 | APPROVED | Originators must not review or approve their own submissions. |
| DEC-A13 | APPROVED | No database migration/change before independent backup, successful restore rehearsal and explicit approval of the exact migration. |
| DEC-A14 | APPROVED | Preserve historical records and superseded material for traceability; do not use conflicting legacy rules operationally. |

## 3. Blocked decisions — recommended resolutions

### DEC-B01 — Self-approval identity boundary
**Status:** BLOCKED  
**Why it matters:** The database currently distinguishes actor user, company and project party. A user-ID-only check can allow a colleague from the originating company to review its own submission; a party-only check may be insufficient if one company has multiple parties or memberships.

**Recommended resolution (PROPOSED):**
- Deny review/respond/return/approval when the actor belongs to the same originating company as the document originator.
- Also deny when actor's current project party equals the originator party.
- Deny when the actor is the original creator, regardless of later role changes.
- Evaluate trusted membership and document ownership server-side at action time.
- PM and admin status do not create an exception.

**Required approval:** Confirm whether same-company denial is the intended boundary, including multi-company joint ventures and consortium arrangements.

### DEC-B02 — E cancellation timing and transition
**Status:** BLOCKED  
**Approved meaning:** Originating contractor cancellation; never a reviewer response.

**Recommended resolution (PROPOSED):**
- Treat E as a distinct `cancel_by_originator` action, not as an ordinary reviewer response code.
- Permit only the originating contractor's authorized controller.
- Permit only while the document is still in an explicitly cancellable state and before a reviewer decision is recorded.
- Record actor, company/party, timestamp, reason, previous state and resulting terminal state in the audit trail.
- Do not overwrite prior review decisions or erase history.

**Required approval:** Decide whether cancellation is permitted only before formal submission, before review starts, or at any point before the first reviewer decision. Also decide whether cancellation requires a reason and whether withdrawal can be reversed.

### DEC-B03 — Generic close authority
**Status:** BLOCKED  
**Recommended resolution (PROPOSED):**
- Remove generic close as a broad admin/controller shortcut.
- Close should occur only as the deterministic outcome of an authorized workflow transition (including I) or a separately defined document-type-specific lifecycle action.
- Non-review document closure must have an explicit owner/party and prerequisites per document type.
- PM remains read-only and cannot close.
- Admin cannot close on behalf of another party by virtue of role alone.

**Required approval:** Identify who closes non-review documents (originator, receiving party, controller, or another explicitly named role) and whether any audited exceptional closure is required.

### DEC-B04 — KPI denominator and E treatment
**Status:** BLOCKED  
**Approved:** I is excluded from both B/C KPI numerator and denominator.

**Recommended resolution (PROPOSED):**
- Publish the B/C outcome rate as `(B + C) / eligible reviewed outcomes`.
- Exclude I, E, drafts, pending items, and records with no final eligible reviewer outcome from this denominator.
- Keep separate volume measures for total submitted, pending, cancelled (E), information-only (I), and completed review outcomes.
- Define whether D is included in the denominator; recommended yes, because it is a final review outcome but not a B/C numerator.
- Define cohort period by the timestamp of the final eligible review decision, not document creation date.
- Do not combine cancellation rate with B/C review outcome rate.

**Required approval:** Confirm D inclusion, treatment of A, and whether B/C is reported as share of all final outcomes or as a separate return/revision rate. Approve metric names and formulas before implementation.

### DEC-B05 — Lifecycle visibility after draft
**Status:** BLOCKED  
**Approved:** Before formal submission, drafts are visible to the originating party and PM read-only.

**Recommended resolution (PROPOSED):**
Create a document-type-independent lifecycle visibility table:
- Draft: originator party + PM.
- Submitted / under review: parties authorized by the approved workflow and PM.
- Returned: originator party + PM; other parties only where an explicit workflow/business need is approved.
- Approved / rejected / closed: project parties according to the approved final-record access policy + PM.
- Cancelled (E): originator party + PM by default; broader access only if required for project governance.
- Archived (I): preserve auditability and apply the approved final-record visibility policy; do not make it public to all parties merely because it is archived.

Apply the same parent visibility predicate to revisions, reviews, comments, attachments, Storage objects, signed URLs, search, counts and audit metadata.

**Required approval:** Confirm visibility for returned, cancelled, approved/rejected, closed and archived records. The proposed defaults above are not yet approved.

### DEC-B06 — MQR independent workflow definition
**Status:** BLOCKED  
**Approved:** MQR is Monthly Quality Report and must not use the generic A/B/C/D/E/I cycle by default.

**Recommended resolution (PROPOSED):**
- Define MQR as a controlled submit → review/acknowledge → close/archive lifecycle, with explicit roles and no generic response-code outcome.
- Store review comments/observations separately from the generic response-code table.
- Define whether review is mandatory, who acknowledges it, whether resubmission is possible, and how revisions are numbered.
- Exclude MQR from generic response-code KPIs unless a separate approved MQR metric is specified.

**Required approval:** Confirm MQR parties, required review, allowed outcomes, return/resubmission behavior and closure authority.

### DEC-B07 — SOR/NCR/SNAG workflow exceptions
**Status:** BLOCKED  
**Evidence:** Current project-creation function inserts a generic contractor→consultant workflow and reverses the order for SOR, NCR and SNAG.

**Recommended resolution (PROPOSED):**
- Preserve these exceptions only if each has an approved business rationale and matching UI/RPC/test behavior.
- Add a per-document-type workflow definition register.
- Do not carry forward exceptions solely because they exist in old seed logic.

**Required approval:** Confirm the intended parties and step order for SOR, NCR and SNAG.

### DEC-B08 — Project Manager role capability and assignment
**Status:** BLOCKED for implementation details; read-only capability is APPROVED.
**Recommended resolution (PROPOSED):**
- Add a dedicated PM role/capability that grants project-wide read access only.
- Do not map company owner/admin automatically to PM.
- Define who may assign/remove PM and whether one or multiple PMs are allowed.
- Ensure PM is excluded from every mutation and workflow authorization predicate, not merely hidden from the UI.

**Required approval:** Confirm the authorized PM assigner and whether multiple PMs per project are permitted.

## 4. Implementation blockers and owners

| Decision | Implementation blocked until | Primary owner |
|---|---|---|
| DEC-B01 | Identity boundary approved | Product owner + backend |
| DEC-B02 | E lifecycle timing approved | Product owner + workflow owner |
| DEC-B03 | Close authority by document type approved | Product owner + workflow owner |
| DEC-B04 | KPI formulas and cohort definitions approved | Product owner + reporting owner |
| DEC-B05 | Full lifecycle visibility table approved | Product owner + security/backend |
| DEC-B06 | MQR workflow states/roles/outcomes approved | Product owner + quality workflow owner |
| DEC-B07 | SOR/NCR/SNAG exceptions confirmed | Product owner + document control |
| DEC-B08 | PM assignment governance approved | Product owner + access-control owner |

## 5. What can proceed without these decisions

The following work can proceed as non-destructive preparation:
1. Static inventory of every document type, seed, workflow template, role, RPC and policy.
2. Trace each legacy rule to its active code/configuration location.
3. Prepare isolated test fixtures and synthetic test data.
4. Inventory live database grants and policies only after the correct backend/environment is confirmed and access is explicitly authorized.
5. Draft migration alternatives without applying them.
6. Improve report cross-references and implementation checklists.

Do not implement any blocked behavior by guessing.

## 6. Current completion boundary

- Approved decisions in section 2 are binding and supersede conflicting legacy material.
- Recommendations in section 3 are proposals only.
- No new business rule is approved by this document.
- No source code, SQL, migration, database, Storage, role assignment, project setting, or deployment was changed.
- The live database and deployed runtime remain unverified.
- Lovable agent planning remains blocked until workspace credits are available.

## 7. Next gate

Before implementation begins, close DEC-B01 through DEC-B08 or explicitly defer individual decisions with a documented safe default and owner approval. Then update the test catalogue and implementation specification to match the approved resolutions.
