# 64 - MQR Independent Workflow and Response-Code Isolation Review

**Repository:** `mohannedabdo007-droid/sitedocs`  
**Branch:** `dev/review-fixes`  
**Review type:** Static migration review of MQR type configuration, project workflow defaults, document initialization, and shared transition RPC

## Executive summary

The inspected migration snapshot does not implement the approved MQR separation as the default behavior. The seeded `MQR` document type is configured with both `uses_response_codes = true` and `requires_review = true`. Project creation seeds the standard A/B/C/D/E/I response-code set and a generic Contractor -> Consultant workflow, but does not seed an MQR-specific workflow. Document initialization therefore falls back to the generic project workflow and inherits the MQR type's response-code setting unless a project-specific override has been configured.

The shared `transition_document` RPC requires an active project response code for a `respond` action whenever the document's `uses_response_codes` flag is true. Consequently, the default seeded MQR configuration is coupled to the general response-code mechanism, contrary to the approved rule that Monthly Quality Report has its own review workflow and does not use A/B/C/D/E/I by default.

This is a static source/configuration finding. It does not establish the current deployed rows or prove how every existing project is configured.

## Findings

### 1. Seeded MQR explicitly enables the general response-code mechanism

In `drizzle/migrations/0000_core_schema.sql`, the MQR seed row is:

```sql
('MQR','Material Quality Report','تقرير جودة المواد','quality',true,true,false,11)
```

The two boolean values after category set `uses_response_codes = true` and `requires_review = true`.

**Impact:** A newly seeded MQR type is configured to use response codes by default. This conflicts with the approved domain decision that MQR is Monthly Quality Report and has an independent review process without default A/B/C/D/E/I response-code behavior.

### 2. Project creation supplies general response codes and no MQR-specific workflow

In `drizzle/migrations/0001_triggers_and_rpcs.sql`, `create_project` seeds the project's general response codes A, B, C, D, E, and I. It then inserts a generic workflow with steps `{contractor,consultant}`, plus special per-type workflows only for SOR, NCR, and SNAG. The inspected insert does not include MQR.

**Impact:** Unless a separate MQR workflow is configured later, MQR creation falls back to the generic project workflow. The existence of a configurable per-type workflow table is useful, but does not by itself provide an independent MQR default or guarantee that the default configuration meets the approved rule.

### 3. Document initialization inherits the response-code setting and generic workflow

The `documents_before_insert` trigger in `0001_triggers_and_rpcs.sql` selects a type-specific workflow and a project-wide fallback workflow. It assigns:

- `workflow_steps := coalesce(type_workflow.steps, default_workflow.steps, '{contractor,consultant}')`
- `requires_review := coalesce(type_workflow.requires_review, document_type.requires_review)`
- `uses_response_codes := coalesce(type_workflow.uses_response_codes, document_type.uses_response_codes)`

Because the seeded MQR type has `uses_response_codes = true`, and the project-creation path does not insert an MQR-specific override, a newly created MQR document inherits the general response-code behavior unless a project-wide or later per-type override changes it.

### 4. Shared review transition requires a response code for MQR under the default configuration

In `transition_document`, the `respond` path selects an active project response-code row and raises `RESPONSE_CODE_REQUIRED` when `d.uses_response_codes` is true and no matching code is found. The transition then applies the selected row's generic `proceed`, `return`, or `close` outcome.

**Impact:** The shared RPC does not establish a distinct MQR response/action model. With the seeded default flag, MQR review responses are coupled to the same configurable response-code records and generic outcome handling used by other document types.

This finding is about default configuration and shared transition coupling; it is not a claim that all deployed MQR documents currently use these settings.

## Approved requirement and target behavior

The approved domain rule is:

- MQR means **Monthly Quality Report**, not Material Quality Report.
- MQR has its own review workflow.
- A/B/C/D/E/I response-code behavior must not be applied to MQR by default.
- MQR review completion and history must remain auditable, without misusing document response codes or contaminating B/C response-code KPIs.

A remediation design should explicitly decide whether MQR uses a dedicated action/result vocabulary, a dedicated transition path, or a carefully constrained no-response-code workflow. Merely changing the display label or hiding response-code controls in the UI would not be sufficient if the trusted RPC still requires and applies general response codes.

## Recommended remediation for a separately approved change

1. Correct the MQR reference-data definition to Monthly Quality Report and set its default response-code behavior to disabled.
2. Define and seed an explicit MQR-specific workflow for new projects, with approved parties, sequence, review requirements, and completion behavior.
3. Ensure document initialization resolves MQR's workflow and response behavior deterministically; avoid accidental fallback to a general workflow when MQR requires its own configuration.
4. Implement or adapt the trusted transition path so MQR review actions do not require, store, or interpret A/B/C/D/E/I codes by default.
5. Keep MQR review history and audit events distinct and reportable without counting MQR outcomes as B/C response-code KPI results.
6. Add targeted tests for new-project defaults, MQR document creation, each MQR workflow step, completion, returned/revised cases if applicable, and attempts to submit general response codes to MQR.
7. Review existing project overrides and historical MQR records before any data correction. Preserve historical records and distinguish superseded configuration from current configuration.
8. Before any database change, obtain an independent backup, demonstrate a successful restore, review the exact migration and rollback plan, and obtain explicit approval.

## Scope and limitations

- Static inspection of `drizzle/migrations/0000_core_schema.sql` and `drizzle/migrations/0001_triggers_and_rpcs.sql` on `dev/review-fixes`.
- The checked source contains the MQR seed, project creation defaults, document initialization fallback, and shared response transition described above.
- No live database, deployed document-type rows, per-project workflow overrides, MQR records, or production workflow events were queried.
- No frontend MQR screens, downstream exports, or all KPI consumers were exhaustively inspected in this report.
- No automated tests, lint, build, or runtime actions were executed.
- No source files, migrations, generated files, database objects, or project settings were changed.
- This report records findings and recommendations only; it does not authorize remediation or deployment.

## Conclusion

The checked migration defaults MQR into the general response-code path and does not seed an MQR-specific workflow when a project is created. This is inconsistent with the approved independent MQR workflow rule. Remediation should address the trusted workflow and data model—not only labels or UI visibility—and must preserve historical records. Any database implementation remains subject to backup, successful restore evidence, an exact reviewed migration, and explicit approval.
