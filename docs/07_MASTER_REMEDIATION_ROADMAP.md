# 07 — Master Remediation Roadmap & Priority Register

**Review date:** 2026-11-10  
**Target branch:** `dev/review-fixes`  
**Status:** consolidated planning document based on static source reviews 03–06. No application code, database, migration, deployment, or tests were changed or executed while preparing this roadmap.

## 1. Purpose

This document consolidates the findings from:
- `03_IMPLEMENTATION_READINESS_REVIEW.md`
- `04_SECURITY_REMEDIATION_SPEC.md`
- `05_RPC_WORKFLOW_SOURCE_AUDIT.md`
- `06_DISCIPLINE_AND_NUMBERING_AUDIT.md`

It defines a dependency-aware order of work. Priority reflects potential impact and implementation dependency, not proof of a live exploit. All findings remain source-level until verified against the correct isolated restored database and runtime tests.

## 2. Executive status

| Area | Source review | Live verification | Implementation |
|---|---|---|---|
| Workflow authority and separation of duties | Findings recorded | Not performed | Not started |
| Draft confidentiality and Storage access | Findings recorded | Not performed | Not started |
| Membership, tenant and RPC privilege boundaries | Findings recorded | Not performed | Not started |
| Import privileged path | Findings recorded | Not performed | Not started |
| Five-discipline catalogue and legacy mapping | Findings recorded | No live inventory | Not started |
| Numbering schemes and collision analysis | Source logic reviewed | No live inventory/concurrency test | Not started |
| RFI/WIR/MQR and E/I semantics | Requirements recorded | Not performed | Not started |
| Usable product routes and screens | Readiness gap recorded | Not applicable | Not started |
| Automated tests, lint and production build | Test gaps identified | Not run | Not started |

## 3. Priority register

### P0 — Establish a safe, testable environment (blocking gate)

**Scope**
1. Verify the exact Project Doc Control Supabase project identity from the connected Lovable project; do not infer it from an unrelated Supabase reference.
2. Reconcile the current Lovable revision with GitHub source and identify the authoritative application branch.
3. Produce an independent backup.
4. Restore that backup into a separate isolated environment and prove the restore is usable.
5. Capture read-only baseline evidence from the restored target: schema/migration state, RLS, effective function grants, Storage policies, reference data, row counts, discipline usage, numbering schemes and document-number collision checks.

**Exit criteria**
- Correct backend identity documented.
- Backup artifact and restore result evidenced.
- Isolated target is confirmed not to be production.
- Baseline inventory is timestamped and reproducible.
- No production writes have occurred.

**Why first:** all database security and data-migration work depends on a known, recoverable environment. Until this gate passes, implementation is limited to source review, documentation, and isolated non-production preparation.

### P0 — Authorization, workflow integrity and confidentiality

**Scope / linked findings**
- RPC-01 / RPC-02: remove implicit admin bypass of current workflow party and originator-party checks.
- RPC-03: enforce submitter-versus-reviewer separation using persisted identity and trusted server-side data.
- SEC-01 / SEC-02 / SEC-03: verify current reviewer authority, separation of duties, and PM read-only access to drafts.
- RPC-07 / SEC-06 / SEC-07 / SEC-11: make draft visibility consistent across documents, revisions, comments, reviews, attachment metadata, Storage objects, search, counts and exports.
- Ensure X1 cannot read or mutate another tenant's P1 data through tables, RPCs, Storage, KPI or indirect metadata.
- Preserve valid positive paths for originator submission, assigned reviewer response, and PM read-only oversight.

**Exit criteria**
- Negative and positive integration tests pass using distinct authenticated identities.
- Direct table, RPC and Storage access enforce the same server-side policy as the UI.
- PM can read project drafts and related files but cannot edit, submit, review, respond, approve, return or close.
- Other parties cannot discover draft content or files through guessed IDs or paths.
- Audit evidence exists for successful privileged actions; denied actions do not create business workflow events.

### P0 — Business workflow semantics

**Scope / linked findings**
- RPC-04 / RPC-05 and SEC-09 / SEC-10: correct response-code and document-type semantics.
- E is an originating-party cancellation action, not a reviewer response.
- I closes the review cycle while retaining the document in the archive.
- I is excluded from B/C KPI metrics.
- MQR (Monthly Quality Report) has an independent workflow and no default A/B/C/D/E/I response-code scheme.
- RFI means Request for Inspection and remains separate from WIR.

**Exit criteria**
- Role/party authorization for E is explicit and tested.
- I produces the approved closed/archive state and cannot advance to another review party.
- MQR defaults and workflow are independently tested.
- RFI and WIR remain distinct document types.
- KPI fixtures prove I is excluded from B/C measures without disappearing from archive totals.

### P1 — Membership, tenant boundaries and RPC privilege hardening

**Scope / linked findings**
- RPC-06 / SEC-04: prevent self-targeting, self-promotion, party reassignment and unauthorized role assignment.
- RPC-08: inventory effective EXECUTE grants for every exposed function, including PUBLIC, anon, authenticated and service roles as applicable.
- RPC-10: decide whether company owner/admin status implies project administration; separate project administration from document edit/review authority.
- SEC-05 / SEC-08 / SEC-12: verify tenant isolation and direct-write restrictions for documents, revisions, comments, attachments and imports.
- Review every SECURITY DEFINER function for fixed safe search_path, qualified references and server-side authorization.

**Exit criteria**
- One constrained membership-management path exists.
- Cross-company and self-escalation tests are denied.
- Effective grants are captured from the restored database and reduced to least privilege.
- Direct writes cannot forge actor, party, company or project identity.
- Company-level admin does not silently acquire document-review authority.

### P1 — Import boundary and data integrity

**Scope / linked finding**
- RPC-09: adversarially test `commit_import_rows` and its transaction-local flags.
- Validate batch/project/company consistency, imported statuses, response codes, revisions, originator identity, document type and lifecycle semantics.
- Verify unauthorized callers cannot execute privileged import operations.
- Verify exception rollback and post-import trigger behavior.
- Preserve raw imported values and traceability.

**Exit criteria**
- Authorized import positive controls pass.
- Malicious payload, cross-project references, invalid lifecycle values and unauthorized calls are denied.
- Failed chunks roll back safely and do not leave guard flags or partial business state.
- Duplicate and conflict behavior is deterministic and auditable.

### P1 — Five-discipline catalogue, legacy mapping and KPI normalization

**Scope / linked findings**
- Expose exactly ARC, CIVSTR, MEC, ELE and SUR as current selectable disciplines.
- Keep STR and CIV as historical/legacy identifiers, not separate current choices.
- Explicitly map STR / Structural and CIV / Civil to canonical CIVSTR for new imports, with original source values retained.
- Map SUR / Survey / مساحة to SUR.
- Normalize KPI grouping so legacy STR and CIV records appear in the CIVSTR reporting bucket.
- Include SUR in selectors, imports, filters, KPIs, reports and exports.

**Exit criteria**
- Reference-data and document dependency inventory is complete.
- Unknown/ambiguous values fail validation rather than silently defaulting.
- Before/after KPI totals reconcile.
- Document IDs, issued document numbers, revisions and audit history remain unchanged.
- No historical reference is deleted without a separately reviewed dependency proof.

### P1 — Numbering scheme consolidation and concurrency safety

**Scope / linked findings**
- Inventory every project × document type × discipline numbering scheme, including generic NULL-discipline schemes, patterns and next_seq.
- Identify duplicate scheme groups after mapping STR/CIV to CIVSTR.
- Simulate generated candidate numbers against all existing document numbers before selecting canonical sequences.
- Preserve existing issued doc_number values exactly; do not renumber as part of discipline consolidation by default.
- Test concurrent inserts sharing an exact scheme and disciplines sharing a generic fallback scheme.
- Treat preview as advisory, not a reservation.

**Exit criteria**
- No generated number collides with an existing number.
- No sequence regresses.
- Concurrent creation produces unique numbers with documented retry/error behavior.
- Canonical pattern and next_seq decisions are recorded per affected project/type.
- Recovery strategy is tested on the isolated restored environment.

### P2 — Application completeness and release quality

**Scope**
- Build the usable product routes, dashboards and workflows after authorization and data contracts are stable.
- Ensure screens expose the approved five disciplines and correct workflow terminology.
- Add regression coverage for admin bypass, submitter/approver separation, PM read-only drafts, tenant isolation, legacy import aliases, KPI normalization, E/I, MQR, RFI/WIR and numbering.
- Run application tests, database/RLS/RPC/Storage integration tests, lint and production build.

**Exit criteria**
- All required test suites pass in the controlled environment.
- Exact commands, versions, environment and results are recorded.
- No unresolved P0 issue remains.
- Release candidate is reviewed before any deployment decision.

## 4. Dependency order

1. Safe environment and evidence gate.
2. Canonical authorization and confidentiality model.
3. Workflow semantics and document-type-specific behavior.
4. Membership, tenant, RPC and import hardening.
5. Reference-data and numbering inventory on the restored database.
6. Five-discipline migration and canonical KPI/import behavior.
7. Numbering consolidation, concurrency and recovery validation.
8. Application screens, regression suite, lint and build.
9. Release review; deployment and merge remain separate approval decisions.

Some P0 workstreams can be designed in parallel, but no database change is to be applied before the environment gate and exact-change approval.

## 5. Mandatory change-control rules

- Documentation and read-only source inspection may continue on `dev/review-fixes`.
- Do not manually edit `drizzle/`, `supabase/migrations/`, or generated schema/types; Lovable owns those artifacts.
- Do not connect to or modify an unverified Supabase project.
- Do not change production data, apply migrations, deploy, or merge to `main` without the required explicit approval.
- A general instruction to continue does not replace approval of a specific database migration after its exact contents and recovery plan are reviewed.
- Every implementation change must include tests, evidence, a commit on `dev/review-fixes`, and fetch-verification.
- Keep proposed, source-confirmed, runtime-verified, implemented, and deployed states distinct.

## 6. Current stop conditions

The following remain unverified and block database implementation:
- Correct live Project Doc Control Supabase identity.
- Independent backup and successful isolated restore.
- Live RLS and effective function grants.
- Storage authorization against parent-document visibility.
- Live discipline usage and numbering scheme inventory.
- STR/CIV canonicalization collision analysis.
- Adversarial import-path tests.

## 7. Evidence references

- `03_IMPLEMENTATION_READINESS_REVIEW.md`
- `04_SECURITY_REMEDIATION_SPEC.md`
- `05_RPC_WORKFLOW_SOURCE_AUDIT.md`
- `06_DISCIPLINE_AND_NUMBERING_AUDIT.md`

This roadmap is a planning and prioritization record only. It is not an implementation, migration, deployment, or production-change authorization.
