# 61 - Project Workflow Configuration Validation and Party Sequence Integrity Review

**Repository:** `mohannedabdo007-droid/sitedocs`  
**Branch:** `dev/review-fixes`  
**Review type:** Static source and migration review only  
**Files inspected:**
- `drizzle/migrations/0000_core_schema.sql`
- `drizzle/migrations/0001_triggers_and_rpcs.sql`

## Executive summary

The checked schema constrains project workflow step arrays to a nominal length of 1–6, but the constraint does not reliably reject an empty array because PostgreSQL CHECK constraints accept an expression that evaluates to NULL. The schema also does not prevent duplicate parties in a workflow sequence. The document-initialization trigger copies configured steps directly into each new document snapshot, and the transition routine advances through that sequence. These gaps can permit unusable configurations or repeated sequential actions by the same party.

This is a static finding in the inspected migration snapshot. It does not establish that invalid rows exist in the deployed database or that the deployed schema exactly matches these migrations.

## Findings

### 1. Empty workflow step arrays can pass the declared CHECK constraint

In `0000_core_schema.sql`, `project_workflows.steps` is declared NOT NULL with:

```sql
steps public.project_party[] not null
  check (array_length(steps, 1) between 1 and 6)
```

For an empty PostgreSQL array, `array_length(steps, 1)` evaluates to NULL. A CHECK constraint rejects FALSE, but accepts TRUE or NULL. Therefore this expression does not reliably reject an empty array.

The document initialization trigger in `0001_triggers_and_rpcs.sql` selects the type-specific or project-default workflow and assigns:

```sql
new.workflow_steps := coalesce(tw.steps, dw.steps,
  '{contractor,consultant}'::public.project_party[]);
new.originator_party := new.workflow_steps[1];
```

An empty configured array is non-NULL, so COALESCE selects it rather than the fallback. Its first element is NULL, while `documents.originator_party` is NOT NULL. A document insert using this configuration can consequently fail rather than falling back to a valid workflow.

**Impact:** A project administrator may be able to save a workflow configuration that later prevents document creation for the affected type or project.

### 2. Duplicate parties are not prohibited in a workflow sequence

The checked constraint limits the reported array length but does not require distinct parties. The `project_party` enum permits the same party value to occur more than once in the array.

The document trigger snapshots the configured sequence into `documents.workflow_steps`. The `transition_document` routine reads the current party using `d.workflow_steps[d.current_step]` and, after a progressing response, increments the step while additional entries remain.

Consequently, a sequence such as `{contractor,consultant,consultant}` can direct two consecutive review steps to the same party. This is not proof that one individual user can act twice in every deployed role configuration; it is a configuration-level failure to enforce distinct-party sequencing.

**Impact:** Workflow configuration can encode repeated party stages, weakening intended separation between successive reviewing parties and creating redundant review steps.

### 3. Workflow sequence validity is not comprehensively constrained at configuration write time

The inspected `project_workflows` table has length and review-day checks, but no database constraint or trigger was identified in the checked migrations that validates:
- non-empty array semantics robustly;
- distinct party entries;
- consistency between the configured sequence and the intended originating/reviewing-party model.

The document creation trigger copies the selected sequence without a separate validation routine. The transition routine then trusts the stored snapshot and derives the current party from its indexed element.

**Impact:** Invalid or unintended workflow definitions can be persisted and propagated into document records rather than being rejected with a clear configuration validation error.

## Existing safeguards observed

- `project_workflows.steps` is NOT NULL and has a nominal 1–6 length check.
- Workflow rows are scoped by project and company fields and have a uniqueness constraint for project/type configuration.
- RLS policies in the inspected migration restrict workflow insert/update to project administrators.
- Document lifecycle and workflow fields are protected by `documents_guard_update` outside the controlled transition path.
- The document trigger snapshots workflow settings into the document, so later edits to the project workflow row do not, by themselves, rewrite existing document snapshots.

These safeguards do not address the NULL CHECK semantics or duplicate-party sequence issue described above.

## Recommended remediation for a separately approved change

1. Replace the array-length check with a NULL-safe condition that verifies cardinality is between 1 and 6 (and explicitly rejects empty arrays).
2. Add a validation function/constraint or controlled write path that rejects duplicate party values and validates the allowed sequence semantics.
3. Validate workflow configuration before it is copied into a new document, returning a clear domain-specific error rather than relying on a later NOT NULL failure.
4. Define and test the intended behavior for one-party workflows and for `requires_review = false`, without silently changing existing document snapshots.
5. Add migration-level tests for empty arrays, duplicate parties, minimum/maximum lengths, valid multi-party paths, and document creation with both type-specific and project-default workflows.
6. Before any database change, obtain an independent backup, demonstrate a successful restore, review the exact migration, and obtain explicit approval.

## Scope and limitations

- Static inspection of the two migration files on the stated branch only.
- No live database, deployed constraints, current workflow rows, effective grants, or production configuration were queried.
- No application runtime behavior, automated tests, lint, or build was executed.
- No source files, migrations, generated files, database objects, or project settings were changed.
- This report records findings and recommendations only; it does not authorize remediation or deployment.

## Conclusion

The workflow configuration schema should be hardened before relying on project-defined party sequences as an authoritative control. The most immediate defect is the empty-array CHECK behavior; duplicate party values are a separate sequence-integrity gap. Both should be addressed through a reviewed migration and targeted tests only after the required backup/restore gate and explicit approval.
