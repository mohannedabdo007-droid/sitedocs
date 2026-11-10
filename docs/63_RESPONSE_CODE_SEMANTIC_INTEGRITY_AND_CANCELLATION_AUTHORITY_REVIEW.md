# 63 - Response Code Semantic Integrity and Cancellation Authority Review

**Repository:** `mohannedabdo007-droid/sitedocs`  
**Branch:** `dev/review-fixes`  
**Review type:** Static migration and application KPI source review

## Executive summary

The checked schema models project response codes as configurable records with a short alphanumeric code, labels, and one of three generic outcomes (`proceed`, `return`, `close`). The workflow transition routine applies those generic outcomes but does not enforce the approved meaning or actor restrictions of individual response codes.

This creates a gap between configurable code labels and the project's approved governance rules, most notably for E (Cancelled by Contractor). The checked KPI helper counts B/C for the B/C metric and therefore does not include I in that specific metric, but the general response-code breakdown still includes any non-null code. This report distinguishes these observed behaviors from requirements that are not fully enforced in the inspected source.

## Findings

### 1. Approved response-code meanings are not enforced as a fixed semantic mapping

The approved project vocabulary is:
- A — Approved
- B — Approved as Noted
- C — Revise and Resubmit
- D — Rejected
- E — Cancelled by Contractor
- I — For Information Only

In `0000_core_schema.sql`, `project_response_codes` stores a configurable `code`, labels, and an `outcome` drawn from the generic enum `proceed`, `return`, or `close`. The code constraint only checks an uppercase alphanumeric shape and length; it does not bind A/B/C/D/E/I to their approved semantics.

In `transition_document`, the active response-code row is looked up by project and code. The transition behavior is then selected by `rc.outcome` (return, close, or proceed to the next step/approved). The inspected function does not independently assert that each approved code maps to its required semantic outcome.

**Impact:** A project configuration can potentially assign an approved label/code an unintended generic outcome. A code's displayed label is therefore not, by itself, proof that the workflow action matches the approved governance meaning.

### 2. E cancellation is not restricted to the originating contractor in the inspected transition path

The approved rule is that E means “Cancelled by Contractor” and may be initiated by the contractor who created the document, not by a reviewer or an unrelated administrator.

The inspected `transition_document` routine accepts `respond` from the current reviewing party (with an admin exception already documented in report 59), looks up the selected active response code, and branches on its generic outcome. No E-specific check was identified that verifies:
- the selected code is E;
- the actor belongs to the contractor party;
- the actor is the document creator; and
- the cancellation is being initiated by that authorized originator rather than the reviewing party.

The current generic `close` outcome is also used for workflow closure, which is not equivalent to the distinct contractor-cancellation event required for E.

**Impact:** The inspected database workflow does not establish the required E-only contractor-originator authority. The semantic distinction between cancellation by contractor and closure by reviewer may be lost if both are represented by the generic close outcome.

This is a source-level authorization gap, not evidence that an unauthorized E cancellation has occurred in a live environment.

### 3. KPI treatment is partly aligned, but the general code breakdown still includes I

The inspected `src/lib/kpi.ts` defines `BC = new Set(["B", "C"])`, and both summary and grouped B/C metrics count only B and C. Thus I is excluded from the B/C KPI metric in this helper.

However, the same helper increments `byCode` for every non-null response code, including I. This is a general descriptive code breakdown, not the B/C metric. The inspected SQL KPI matrix groups records by `current_response_code` and does not itself filter I.

**Impact:** The B/C metric is correctly limited to B/C in this helper, but consumers of the general code breakdown must not interpret it as a B/C KPI. The intended treatment of I in any other dashboard totals, exports, or KPI calculations was not established by this limited source inspection.

## Existing safeguards and positive evidence

- The project response code value is selected from an active row belonging to the document's project.
- The response-code table is project-scoped and its write policies in the inspected migration are restricted to project administrators.
- The transition routine uses the configured outcome to determine progression, return, or close.
- The frontend KPI helper explicitly limits its B/C calculation to the literal codes B and C.

These safeguards do not enforce the complete approved code-to-meaning mapping or the contractor-only E cancellation rule.

## Recommended remediation for a separately approved change

1. Define a canonical response-code semantic map for A/B/C/D/E/I and validate every project configuration against it; do not rely on editable labels alone.
2. Give E a distinct cancellation action/outcome rather than treating it as generic reviewer closure.
3. Enforce E authorization in the trusted database transition path: verify the contractor party, document creator, and any required originating-company membership before allowing cancellation.
4. Ensure E cannot be submitted by consultant, owner, PMC, reviewer, or an administrator acting outside the contractor-originator authority.
5. Define I as For Information Only, ensure it closes the review cycle as approved, preserves the document in the archive, and excludes it from B/C KPI calculations.
6. Add tests for every code/outcome mapping and actor/party combination, including attempts to use E from each non-originating party and attempts to configure invalid mappings.
7. Review all KPI consumers, reports, exports, and charts separately so that the general by-code distribution is not confused with the B/C KPI.
8. Before any database change, obtain an independent backup, demonstrate a successful restore, review the exact migration, and obtain explicit approval.

## Scope and limitations

- Static inspection of `0000_core_schema.sql`, `0001_triggers_and_rpcs.sql`, `0003_import_validation_and_kpi_buckets.sql`, and `src/lib/kpi.ts` on `dev/review-fixes`.
- No live database, deployed response-code rows, current project configurations, effective ACLs, or production workflow events were queried.
- No automated tests, lint, build, or runtime actions were executed.
- No source files, migrations, generated files, database objects, or project settings were changed.
- Report 59 separately documents the broader administrator workflow-party bypass. This report focuses on response-code semantics and the distinct E cancellation authority requirement.
- This report records findings and recommendations only; it does not authorize remediation or deployment.

## Conclusion

The checked workflow supports generic configurable response outcomes, but does not itself guarantee the approved A/B/C/D/E/I semantics or the contractor-originator-only cancellation rule for E. The E rule should be implemented as a distinct, explicitly authorized transition, with tests proving that other parties cannot invoke it. The B/C KPI helper is aligned for its specific B/C metric, while broader I treatment should be verified across all KPI consumers before claiming system-wide compliance.
