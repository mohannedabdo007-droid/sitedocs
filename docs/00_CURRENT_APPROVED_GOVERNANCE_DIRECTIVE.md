# PROJECT DOC CONTROL — Current Approved Governance Directive

**Directive ID:** POL-GOV-001  
**Version:** 1.0  
**Effective date:** 2026-11-11  
**Authority:** Explicit user-approved project decisions  
**Status:** CURRENT / APPROVED  
**Branch containing this directive:** governance/current-approved-baseline-2026-11-11  
**Base:** dev/review-fixes

> This directive is the controlling business and governance baseline for all contributors, tools, coding agents, reviewers, and project documentation. If any older document, prompt, seed label, generated artifact, or agent assumption conflicts with this directive, follow this directive for current work and preserve the conflicting material as historical evidence.

## 1. Mandatory precedence and archival policy

1. This current approved directive takes precedence over older project documents and historical assumptions.
2. Do not delete, overwrite, silently rewrite, or discard superseded decisions, reports, snapshots, migration history, audit evidence, or historical identifiers.
3. Preserve old material in its original form. Mark or index it as **SUPERSEDED / HISTORICAL / NOT VALID FOR CURRENT IMPLEMENTATION** through a separate index or annotation; do not alter forensic evidence merely to make it appear correct.
4. Historical archive material is not part of routine implementation context. Do not retrieve, quote, reuse, or act on it unless there is a concrete need and the user has explicitly authorized access for that purpose.
5. No archived decision may be reactivated without a new explicit user approval.
6. Every future decision change must record a decision ID, version, effective date, reason, approver, affected documents, and the prior decision it supersedes.
7. When a diagnostic report accurately describes an existing code or database defect, preserve that finding as a statement about observed source state. Do not rewrite it to pretend the defect has already been fixed. Add the approved target behavior separately.
8. This directive authorizes documentation and implementation planning only. It does not authorize database migrations, schema changes, data rewrites, production deployment, merging to main, or bypassing repository/Lovable ownership controls.

## 2. Approved document types and meanings

| Code | Approved full name | Meaning |
|---|---|---|
| WIR | Work Inspection Request | Request to inspect executed work |
| RFI | Request for Information | Engineering clarification / information request |
| MQR | Monthly Quality Report | Monthly quality report with an independent review workflow |

WIR and RFI are completely separate processes. They must have separate forms, numbering, permissions, lifecycle transitions, reporting, and audit trails. Never use the historical expansion “RFI = Request for Inspection” as a current rule.

MQR means **Monthly Quality Report**, not Material Quality Report. MQR must have its own review workflow and history. A/B/C/D/E/I response-code behavior is not applied to MQR by default. The exact MQR stages and action vocabulary must be explicitly designed and approved; do not invent them or silently fall back to the general WIR/RFI review model.

## 3. Approved disciplines

Exactly five current selectable disciplines:

| Code | English name |
|---|---|
| ARC | Architectural |
| CIVSTR | Civil & Structural |
| MEC | Mechanical |
| ELE | Electrical |
| SUR | Surveying |

Civil and Structural are one discipline, not two selectable disciplines. Legacy CIV and STR values must remain historically traceable and be mapped to canonical CIVSTR in current selectors, imports, filters, reports, and KPIs through a controlled compatibility strategy. Preserve issued document numbers and historical records. Do not merge or rewrite numbering streams without a complete read-only inventory, collision analysis, tested recovery plan, and separate explicit approval.

## 4. Response-code semantics

For document types that are approved to use the general response-code workflow:

- A — Approved
- B — Approved as Noted
- C — Revise and Resubmit
- D — Rejected
- E — Cancelled by Contractor
- I — For Information Only

E is a distinct cancellation initiated only by the originating contractor under the approved authority checks. It is not a reviewer response, generic close action, or administrator bypass.

I closes the applicable review cycle and preserves the document in the archive. I is not a B/C result and must not be counted in B/C metrics.

Do not apply these general response codes to MQR by default. Keep MQR review results and KPIs distinct.

## 5. Roles, confidentiality, and separation of duties

1. Drafts remain confidential to their originating party before formal submission, subject only to the explicitly approved project-manager oversight visibility below.
2. The project manager may view all project documents, including drafts, for oversight. This is read-only visibility and does not grant permission to edit, submit, review, respond, approve, reject, cancel, or close on behalf of an authorized party.
3. Membership party and project role are separate dimensions. A role such as admin, controller, reviewer, or viewer does not automatically change a user's party or grant authority to act for another party.
4. No self-approval. The document originator must not issue a review decision on their own document.
5. Administrative privileges must not bypass workflow-party boundaries, confidentiality, separation of duties, or originating-party restrictions.
6. The originating party submits its own documents. Review actions belong to the authorized reviewing party and workflow step.
7. Enforce all security and workflow rules server-side; frontend helpers are not an authorization boundary.

## 6. Historical and current-source truth must remain distinct

The following are known source-level findings from static inspection and must remain visible in remediation tracking until verified fixed:

- Historical seed data includes legacy discipline codes ARC, STR, MEC, ELE, CIV and does not itself establish the approved current five-discipline selector model.
- The inspected seed has an obsolete RFI label/meaning and an obsolete MQR label/meaning; these are source defects, not current business definitions.
- The inspected MQR seed enables general response codes and the project-creation path does not establish a dedicated MQR workflow by default.
- The inspected response-code workflow does not fully enforce the approved semantics and actor restrictions for E and I.
- The inspected workflow RPC and UI helper contain administrator party-bypass behavior requiring remediation and adversarial tests.
- The inspected RLS/storage policies require draft/document-level visibility review; project membership alone must not expose confidential draft content or attachments.
- SECURITY DEFINER effective EXECUTE ACLs, service-role call sites, import trust boundaries, and transaction-local bypass flags require verification and testing.

These findings are based on static source review only. They do not prove the state of a deployed database or that an exploit has occurred. Do not claim remediation, runtime validation, or production compliance without fresh evidence.

## 7. Mandatory instructions for every tool, agent, and contributor

Before acting on this repository or project:

1. Read this directive first.
2. Treat its approved definitions and constraints as mandatory.
3. Do not infer approval from an old report, seed row, code comment, prompt, or generated file.
4. Do not modify migrations, database schema/data, generated types, or production settings without the required backup, isolated restore, reviewed exact change plan, ownership-compliant workflow, and separate explicit user approval.
5. Preserve historical artifacts; use a separate supersession index rather than destructive edits.
6. Report exactly what was inspected, changed, tested, and not tested.
7. If a requirement is not defined here, mark it unresolved and ask for approval rather than inventing a policy.
8. Do not merge this governance branch into main or deploy it without explicit approval.

## 8. Known superseded material — initial index

This is an initial pointer list, not an exhaustive archive inventory. Preserve the original files unchanged unless a separately approved archival operation says otherwise.

- docs/21_CURRENT_APPROVED_BASELINE_AND_SUPERSEDED_RULES.md — reconcile against this directive; older RFI wording is not current.
- docs/22_CONSOLIDATED_REMEDIATION_MASTER_MATRIX.md — reconcile requirement rows against this directive.
- docs/24_OPEN_POLICY_DECISIONS_AND_RECOMMENDED_RESOLUTIONS.md — reconcile decision status and wording against this directive.
- docs/03_IMPLEMENTATION_READINESS_REVIEW.md
- docs/04_SECURITY_REMEDIATION_SPEC.md
- docs/07_MASTER_REMEDIATION_ROADMAP.md
- docs/09_PULL_REQUEST_1_REVIEW.md
- docs/11_APPLICATION_REQUIREMENTS_GAP_REVIEW.md
- docs/12_LOVABLE_KNOWLEDGE_ALIGNMENT.md
- docs/14_EXPANDED_STATIC_AUTHORIZATION_AUDIT.md
- docs/17_REFERENCE_DATA_AND_WORKFLOW_CONFIGURATION_DRIFT.md
- docs/20_WORKFLOW_AUTHORITY_SELF_APPROVAL_AND_KPI_REVIEW.md
- docs/CLAUDE_INDEPENDENT_REVIEW.md
- backup/database-seed-snapshot.json — immutable historical snapshot; do not edit to retrofit current definitions.
- docs/63_RESPONSE_CODE_SEMANTIC_INTEGRITY_AND_CANCELLATION_AUTHORITY_REVIEW.md and docs/64_MQR_INDEPENDENT_WORKFLOW_AND_RESPONSE_CODE_ISOLATION_REVIEW.md — retain as source-state diagnostic evidence; do not erase their findings.

## 9. Status and implementation gates

This directive records approved business rules. It does not assert that the current application, migrations, live database, or deployed environment already complies.

Implementation must proceed through:
- documentation reconciliation and traceability;
- read-only source and environment verification;
- independent backup and demonstrated isolated restore before database work;
- exact change design and acceptance tests;
- explicit user approval for each database/schema/data change;
- implementation through the repository's authorized ownership workflow;
- tests and evidence before merge or deployment.

**End of current approved governance directive.**
