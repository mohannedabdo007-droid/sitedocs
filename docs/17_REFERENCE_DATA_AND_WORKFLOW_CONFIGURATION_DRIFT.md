# 17 — Reference Data & Workflow Configuration Drift

**Review type:** Static migration/source review  
**Branch:** `dev/review-fixes`  
**Source:** `drizzle/migrations/0000_core_schema.sql` and `0001_triggers_and_rpcs.sql`  
**Database access:** None. No live seed data or project configuration was queried.  
**Changes:** Documentation only. No source, migration, database, or application changes.

## Executive summary

The baseline seed data and project-creation defaults do not yet reflect several decisions explicitly approved for Project Doc Control. The most important mismatches are the discipline taxonomy, the RFI document-type label, MQR response-code configuration, and the generic workflow defaults. These are confirmed in the reviewed migration source, but the live database may differ if migrations or seed operations have been changed or applied selectively.

## Findings

### 1. Discipline seed data conflicts with the approved five-discipline model

The baseline migration seeds:

- ARC — Architectural
- STR — Structural
- MEC — Mechanical
- ELE — Electrical
- CIV — Civil

Approved canonical model:

1. ARC — Architectural
2. CIVSTR — Civil & Structural (one combined discipline)
3. MEC — Mechanical
4. ELE — Electrical
5. SUR — Survey

**Gap:** The source still seeds separate STR and CIV, does not seed CIVSTR, and does not seed SUR. This is a confirmed source-level mismatch.

**Required treatment:** Define one canonical CIVSTR code and SUR. Normalize historical CIV and STR aliases to CIVSTR at import/reporting boundaries while retaining original historical values for traceability. Do not silently rewrite existing records without a reviewed migration and a data mapping plan.

### 2. RFI label combines two different meanings

The migration seeds RFI as:

- Code: `RFI`
- English: `Request for Inspection / Information`
- Arabic: `طلب فحص / استفسار`
- Category: `inspection`

The approved definition is **RFI = Request for Inspection**, separate from WIR. The current label conflates inspection with information/inquiry and should be corrected in the canonical reference data. Do not merge RFI with WIR.

### 3. MQR is seeded as a response-code workflow

The migration seeds MQR with:

- Category: `quality`
- `uses_response_codes = true`
- `requires_review = true`

The approved MQR definition is **Monthly Quality Report**, with an independent workflow and no default A/B/C/D/E/I response-code set.

**Gap:** The current seed enables response codes for MQR. The label itself is also `Material Quality Report`, not Monthly Quality Report.

**Required treatment:** Correct the canonical label and disable the generic response-code model for MQR unless a separately approved MQR-specific process explicitly requires another controlled decision mechanism. Define and test the independent workflow before changing live project configurations.

### 4. Project creation installs generic A/B/C/D/E/I codes for every project

The `create_project` function inserts the six default codes A, B, C, D, E, I for each new project. In particular:

- E is seeded as “Reviewed – no further action” with outcome `proceed`, contrary to the approved meaning **Cancelled by Contractor**, initiated by the originating contractor rather than a reviewer response.
- I is seeded as “For information only” with outcome `proceed`, but the approved behavior is to close the review cycle and archive the document, excluding it from B/C KPI metrics.

**Gap:** The current `response_outcome` enum contains only `proceed`, `return`, `close`. A generic code row with outcome `proceed` does not itself express the approved I close/archive behavior, nor does it encode the originator-only E action.

**Required treatment:** Model E as a controlled originator cancellation action, not a reviewer response code. Model I as a controlled information-only close/archive transition. Define KPI denominator and exclusion semantics explicitly. Do not simply relabel E or change I's outcome without reviewing the transition function, UI, audit events, and historical data.

### 5. Generic workflow and quality-report defaults need explicit per-type design

The project-creation function inserts a generic workflow `{contractor,consultant}`, then inserts `{consultant,contractor}` for document types whose codes are SOR, NCR, and SNAG.

MQR is not included in that special-case list, so it inherits the generic workflow unless another project-specific configuration overrides it. This is inconsistent with the approved independent MQR workflow.

The special-case list is also hard-coded by document type code. It should be covered by characterization tests so future type additions or renames cannot silently inherit an inappropriate sequence.

### 6. Workflow configuration permits repeated parties

The `project_workflows.steps` constraint checks only that the array length is between 1 and 6. It does not prevent duplicate parties or validate that the workflow sequence is appropriate for the document type. The document snapshot field similarly has no visible constraint enforcing valid step membership or uniqueness.

This is a validation gap in the migration source. The exact allowed multi-step patterns must be defined before adding constraints; some legitimate workflows may intentionally involve more than one stage for the same organization/party.

## Recommended remediation sequence — NOT APPLIED

1. Update canonical reference definitions in the application/project knowledge and seed strategy: ARC, CIVSTR, MEC, ELE, SUR; RFI = Request for Inspection; MQR = Monthly Quality Report.
2. Add deterministic import/report normalization for legacy CIV and STR → CIVSTR while preserving raw source values and auditability.
3. Design and approve explicit E and I actions in the domain model and server-side transition RPC; do not treat E as a reviewer response.
4. Define a separate MQR workflow and remove it from generic A/B/C/D/E/I defaults.
5. Review whether SOR/NCR/SNAG special handling is still correct and document the rationale per type.
6. Add migration-level seed assertions and domain tests for every canonical type/discipline mapping and response behavior.
7. Compare live reference data and existing project configurations with the intended model before any data migration.

## Required tests

- Exactly five canonical disciplines are presented for new project configuration.
- Legacy CIV and STR imports map to CIVSTR without losing the raw input.
- SUR imports and KPI grouping work end-to-end.
- RFI and WIR remain distinct document types with distinct labels and workflows.
- MQR is Monthly Quality Report, has an independent workflow, and does not inherit generic response codes.
- E can only be initiated by the originating contractor and is auditable as contractor cancellation.
- I closes the review cycle, is archived, and is excluded from B/C KPI numerator/denominator as explicitly defined.
- Generic project creation does not reintroduce obsolete defaults.
- Existing projects with customized workflows are preserved unless separately approved for migration.

## Status and approval boundary

- Source-level mismatches: **confirmed in the reviewed migrations**.
- Live database seed/configuration parity: **not verified**.
- No SQL, seed, schema, source, or live data changed.
- No tests, build, deployment, or migration executed.
- Any database correction requires a verified backup, tested restore, reviewed migration, and explicit approval.
