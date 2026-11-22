# 22 — Consolidated Remediation Master Matrix and Execution Gates

**Baseline:** Report 21 — Current Approved Baseline and Superseded Rules  
**Evidence set:** Reports 12–21 on `dev/review-fixes`  
**Review mode:** Static source and documentation synthesis  
**Execution status:** Planning only; no application, database, storage, settings, or deployment changes were performed.

## 1. Purpose and control

This is the single planning index for the findings documented in reports 12–20. Report 21 defines which requirements are current when older implementation or documentation conflicts with approved decisions.

A finding in this matrix is not considered fixed merely because it is documented. Each item must move through these explicit states:

- **Identified:** static evidence recorded.
- **Designed:** target behavior and migration/compatibility strategy approved.
- **Implemented:** source change exists on a review branch.
- **Verified:** required automated and adversarial tests pass.
- **Accepted:** review evidence is complete and user approval is obtained where required.
- **Released:** explicitly approved merge/deployment completed.

Never label a finding fixed based only on a proposed change or a UI-only check.

## 2. Prioritized master matrix

| ID | Priority | Workstream | Required outcome | Main evidence | Dependencies / release gate |
|---|---|---|---|---|---|
| SEC-01 | P0 | Draft confidentiality | Other parties cannot read drafts or draft metadata before formal submission; PM has explicit read-only exception | 19 | Define party visibility matrix; verify RLS on documents, revisions, reviews, comments, audit metadata |
| SEC-02 | P0 | Attachment authorization | File reads, uploads, signed URLs and object paths are bound to authorized document/revision/party/lifecycle | 19 | Document-aware storage policy design; direct storage and signed-URL adversarial tests |
| WF-01 | P0 | Workflow party authority | Admin cannot bypass current workflow party for submit/start/respond/return | 20, 15 | Final role/party matrix; authoritative RPC enforcement and direct-call tests |
| WF-02 | P0 | Self-approval prevention | Originator cannot review/respond/approve own submission at defined identity boundary | 20, 15 | Decide user/company/party identity rule; test overlapping memberships |
| IMP-01 | P0 | Import commit integrity | Commit RPC revalidates all security-critical mapped fields server-side and rejects forged validation state | 18, 15 | Define canonical import schema and allowed values; adversarial RPC tests |
| DB-01 | P0 | Function privileges | Verify and harden EXECUTE privileges including PUBLIC, anon and authenticated for every function | 16, 14 | Live catalog inventory, owner/role review, explicit grant matrix; backup/restore gate before migration |
| SEC-03 | P1 | Project role model | PM is distinct read-only role; company admin fallback cannot silently elevate workflow authority | 19, 14 | Approve role capability matrix; membership and fallback tests |
| SEC-04 | P1 | X1/P2 access | X1 can access only P2 documents for its company, including related revisions, comments and attachments | 19 | Define all related-resource visibility rules; cross-company negative tests |
| WF-03 | P1 | Close transition | Generic close authority is explicitly scoped; I closure is handled by its response semantics | 20, 17 | Define close actor per type and state; test duplicate and wrong-party close |
| WF-04 | P1 | Response code semantics | A/B/C/D/E/I canonical meanings, actor eligibility and lifecycle outcomes cannot drift through project settings | 20, 17 | Lock/validate reserved codes; test E cancellation and I close/archive |
| CFG-01 | P1 | MQR workflow | Monthly Quality Report has independent workflow and no generic response-code defaults | 17, 21 | Confirm full type/configuration inventory; project creation and legacy-project tests |
| CFG-02 | P1 | RFI definition | RFI means Request for Inspection only and remains separate from WIR | 17, 21 | Update type labels/help/import aliases; test seed and project initialization |
| REF-01 | P1 | Disciplines | Canonical set is ARC/CIVSTR/MEC/ELE/SUR; STR/CIV map to CIVSTR without losing historical traceability | 17, 12 | Data mapping plan; import, filters, reports, KPIs and seed consistency tests |
| KPI-01 | P1 | KPI denominator | I excluded from B/C outcomes; define eligible denominators and E treatment independently from inventory totals | 20, 17 | Approve metric definitions before changing SQL/TS aggregation |
| UI-01 | P1 | UI/server parity | UI action availability mirrors corrected server policy but is never treated as security enforcement | 20, 15 | Complete RPC policy and test matrix first |
| CFG-03 | P2 | Workflow configuration validation | Reject duplicate parties/order anomalies and invalid workflow step definitions | 17 | Define allowed workflow templates and backward compatibility |
| QA-01 | P2 | Test coverage | Add direct RPC, RLS, Storage, import, lifecycle, role, regression and project-creation tests | 13–20 | Test environment and controlled test identities; no production mutation |
| DOC-01 | P2 | Knowledge alignment | Update Lovable Knowledge and decision register to report 21 baseline when workspace credits permit | 12, 21 | Lovable workspace availability; plan-only first, then approved knowledge update |
| OPS-01 | P2 | Release readiness | Establish CI evidence, backup/restore proof, branch review, and explicit release checklist | 13, 16, 21 | CI access; independent backup and successful restore before DB migration |

**Priority meaning:** P0 = security/integrity blocker before production use; P1 = high-risk business-rule correctness; P2 = supporting quality/governance and release readiness. Priority is a proposed sequencing classification, not a claim that the live system is exposed or exploitable.

## 3. Recommended execution sequence

### Phase A — Resolve policy definitions (no code or DB changes)
1. Approve the identity boundary for self-approval prevention.
2. Finalize role/party/action capability matrix, including PM, company admin, project admin, controller, reviewer, viewer, X1.
3. Define draft visibility for each resource: document, revision, review, comment, audit metadata, attachment, signed URL.
4. Define E cancellation timing/actor and I close/archive behavior.
5. Define KPI denominators and treatment of cancelled E.
6. Define the MQR workflow template and non-review document close authority.

**Exit gate:** No unresolved ambiguity in the authorization and lifecycle rules.

### Phase B — Establish verification environment
1. Confirm actual Supabase project reference and environment identity; do not infer it from unrelated IDs.
2. Obtain an independent database backup.
3. Restore the backup into a separate controlled environment and verify it is usable.
4. Inventory live PostgreSQL function privileges, policies, storage policies, triggers, enum/reference data, and schema drift.
5. Create controlled identities representing every role, party, company, originator and PM scenario.

**Exit gate:** Verified restore and repeatable test environment. No production migration at this phase.

### Phase C — Implement P0 security and integrity corrections
1. Function EXECUTE privilege hardening, including PUBLIC grants.
2. Draft/document/revision/review RLS and PM read-only exception.
3. Document-aware Storage read/upload/signed-URL authorization.
4. Server-side workflow party checks and self-approval denial.
5. Server-side import commit revalidation and privilege-boundary checks.

**Exit gate:** Direct authenticated RPC/RLS/Storage negative tests pass, including attempts that bypass the UI.

### Phase D — Implement P1 business semantics and reference alignment
1. Canonical response-code semantics and actor eligibility.
2. Independent MQR workflow and corrected RFI type definition.
3. Canonical discipline mapping and legacy alias handling.
4. X1/P2 visibility enforcement across related resources.
5. KPI denominator and I/E treatment.
6. Workflow configuration validation and explicit close semantics.

**Exit gate:** Seed/project-creation tests, legacy-data tests, import tests, workflow lifecycle tests and KPI golden-dataset tests pass.

### Phase E — UI, regression, documentation and release
1. Align UI actions with authoritative RPC policy.
2. Run full automated test, lint, build and CI checks.
3. Review source diffs and database migration plan.
4. Update Lovable Knowledge and repository decision index.
5. Conduct independent review and obtain explicit release approval.

**Exit gate:** No unresolved P0/P1 issue, verified backup/restore evidence, passing checks, reviewed PR, and explicit user authorization before merge/deployment.

## 4. Mandatory test evidence

For each implemented item, preserve:
- Test ID and requirement ID.
- Role, party, company and actor identity.
- Resource state and workflow step before action.
- Exact RPC/API/storage operation invoked.
- Expected and actual authorization result.
- Database state before/after, with sensitive values redacted.
- Audit event generated.
- Regression result and test environment identifier.

At minimum, security tests must invoke server operations directly rather than relying only on disabled/hidden UI controls.

## 5. Legacy and historical material policy

Per report 21:
- Older conflicting defaults and rules are superseded for current operation.
- Historical rows, audit events, backups, and source history remain preserved.
- Legacy aliases may be normalized through explicit mappings; do not silently rewrite audit history.
- Any legacy rule still active in code, seeds, configuration, imports, or database must be tracked as an implementation gap until verified corrected.
- A timestamp alone does not make an unapproved proposal authoritative.

## 6. Non-negotiable safety gates

- No live database changes until an independent backup exists and a restore test succeeds.
- No migration application without explicit approval of that specific migration.
- No secret, permission, collaborator, branch protection, or external setting changes without specific approval.
- Keep work on `dev/review-fixes` pending review.
- PR #1 remains unmerged; do not retarget or merge it.
- Do not spend Lovable credits while the workspace reports zero credits.
- Do not claim build, tests, runtime security, or deployment success unless actually executed and evidenced.

## 7. Current state at publication

- Reports 12–21 are documentation/audit artifacts on `dev/review-fixes`.
- Report 21 is the approved current-baseline and superseded-rules policy.
- This report consolidates findings and orders the work; it does not implement any fix.
- Live database state, runtime RLS/Storage behavior, and current deployment remain unverified.
- Lovable agent request was blocked by workspace credits; no agent plan response was received.
