# 04 — End-to-End Import Pipeline: Current-State Findings and Remediation Plan

**Review date:** 2026-11-11  
**Reviewed application baseline:** `dev/review-fixes` as represented by the supplied `sitedocs-dev-review-fixes.zip` and the PR #15 head where relevant  
**Review type:** Static source and migration review  
**Status:** Findings and design sequence only; no import UI, server function, SQL, migration, database, or deployment changes made.

## 1. Purpose and governing constraints

This document establishes a verified starting point for completing the spreadsheet import journey from file selection through durable, server-authorized commit.

The currently approved governance baseline remains authoritative. In particular:
- Do not alter database schema, migrations, generated Supabase types, or live data without an independently verified backup, a tested restore, and explicit approval.
- Do not trust client-provided validation status, decision flags, mapped identifiers, or workflow outcomes at a privileged commit boundary.
- Preserve existing documents and revisions; imports must never silently overwrite historical records.
- Keep WIR and RFI separate, and apply the approved project-specific document-type and discipline rules.
- Do not claim runtime, database, or security tests have passed unless they are actually executed.

## 2. Verified current application surface

### 2.1 The workbook parser exists, but its application journey is not wired

The reviewed source inventory contains:
- `src/lib/import/excel.ts`
- `src/lib/import/mapping.ts`
- `src/routes/index.tsx`
- `src/routes/__root.tsx`
- `src/router.tsx`
- Supabase browser and server client integration files
- a small existing test set

The reviewed route tree contains only the root and index routes. `src/routes/index.tsx` explicitly renders the generated blank-page placeholder and includes `data-lovable-blank-page-placeholder="REMOVE_THIS"`. The source inventory contains no import route, import page component, import wizard, or active caller of `parseWorkbook`.

The `src/lib/import` directory contains only `excel.ts` and `mapping.ts`. Therefore, the available source does not establish a working user journey for file selection, sheet selection, header mapping, value mapping, validation review, staging, commit progress, or failed-row recovery. PR #15 hardens the parser library but does not create this missing UI journey.

### 2.2 Existing client-side domain logic

`mapping.ts` supplies reusable pure functions and types for:
- header suggestions and explicit column mappings;
- explicit value mappings for discipline, lifecycle status, and response code;
- date parsing with user-selected DMY/MDY/YMD order;
- row mapping and client-side validation;
- duplicate/conflict detection against a client-provided existing-record context.

These functions are useful for preview and user assistance, but they are not an authoritative server validation boundary. Their context is supplied by the caller and their outputs are client-controlled.

### 2.3 Workbook resource guard

PR #15 adds the following limits in `excel.ts`:
- 10 MiB input file;
- 20 worksheets;
- 10,000 rows per worksheet;
- 100 columns per worksheet;
- 500,000 aggregate declared-range cells;
- 10,000 characters per cell/header string.

The parser checks declared worksheet dimensions before converting each sheet to row arrays. The XLSX library still parses the compressed workbook after the byte-size gate; this is not a streaming parser. The caller/UI must still catch `WorkbookLimitError` and display a safe, localized message. That caller has not been identified in the reviewed application source.

## 3. Existing database import boundary — static migration evidence only

### 3.1 Staging validation RPC

Migration `0003_import_validation_and_kpi_buckets.sql` defines `save_import_validation(_batch, _rows)` as SECURITY INVOKER. It checks `can_edit_documents` for the batch project, then writes client-supplied `mapped`, `validation_status`, `messages`, and `decision` into uncommitted rows.

This is useful project authorization, but it does not independently recompute the business validation rules. These fields must be treated as staging/UI hints, not proof that a row is safe to commit.

### 3.2 Commit RPC

Migration `0001_triggers_and_rpcs.sql` defines `commit_import_rows(_batch, _limit)` as SECURITY DEFINER. It:
- locks the batch row;
- checks project edit permission and batch state;
- limits each chunk to at most 1,000 rows;
- selects rows based on client-writable `decision` and `validation_status` fields;
- casts selected values and inserts documents/revisions;
- preserves existing revisions by skipping duplicates;
- records per-row success/failure counters.

The reviewed body does not visibly revalidate all canonical rules against trusted project/type/reference data immediately before privileged writes. Examples include active project response-code membership and applicability, canonical discipline policy, date chronology and lifecycle/timestamp consistency, and bounded field/metadata constraints.

This is a source-level validation gap, not evidence of an unauthorized invocation or a live exploit. The function does check `can_edit_documents`; its privileged commit boundary still needs stronger independent data validation.

### 3.3 Batch completion and failure recovery

The checked-in RPC marks a batch `committed` once no eligible unprocessed rows remain, even if some rows were marked `failed`. The returned JSON includes separate failure counts, but the persisted batch status alone can be misread as full success.

The RPC selects only rows whose `commit_status` is null. Failed rows receive `commit_status = 'failed'`, and no dedicated retry/reset RPC was identified in the checked migration set. A subsequent call to the same RPC does not retry those rows.

### 3.4 Row-level audit trail

The checked migration set registers a generic audit trigger for `import_batches`, but no equivalent generic trigger for `import_rows` was identified. Validation and commit transitions at row level may therefore lack durable per-row change history in the shared audit log, unless another separately verified mechanism exists.

### 3.5 Database state is unknown

No live database catalog, deployed function definition, role grants, RLS behavior, trigger inventory, live import batch, or production data was inspected. The findings above describe checked-in migration source only. Do not assume the deployed database matches it.

## 4. Required end-to-end product journey

The import experience should be built as explicit, observable stages:

1. **Choose file** — accept supported Excel formats only; enforce byte limits before parser invocation; reject unexpected MIME/extension combinations; show safe file errors.
2. **Inspect workbook** — list sheets, dimensions, and header rows; allow explicit sheet selection; keep empty-sheet behavior predictable.
3. **Map columns** — show suggested mappings but require explicit mapping for required fields; prevent one source column being assigned ambiguously to multiple targets unless intentionally supported.
4. **Map values** — resolve discipline, lifecycle, and response values against trusted project-specific reference data; preserve unresolved values as pending; never guess ambiguous abbreviations.
5. **Preview and validate** — display row-level errors, warnings, duplicates, and conflicts; allow corrections; show exact date-order selection and never silently infer it.
6. **Stage batch** — persist original row evidence and mapped preview in a bounded, project-scoped staging batch; do not create documents at this stage.
7. **Server validation** — invoke a trusted server/database validation operation that reloads authoritative batch, type, project, discipline, and response-code data; recompute all policy checks from the stored payload.
8. **Commit preview** — present server-produced eligible/blocked counts and a clear explanation of what will be created, revised, skipped, or rejected.
9. **Chunked commit** — use idempotent server-side operations, stable row identities, bounded chunk sizes, concurrency protection, and per-row outcomes. Successful rows must never be replayed as new writes.
10. **Completion and recovery** — distinguish full success, completion with errors, in-progress, and failed states; expose safe failed-row inspection and controlled retry only after reconciliation.
11. **Audit and export** — retain a privacy-conscious row-level event history and allow authorized users to export a failure report without exposing other projects.

## 5. Server-authoritative validation contract

The final commit boundary must not trust client-supplied `validation_status`, `decision`, `messages`, or mapped reference IDs.

At minimum, server validation must independently verify:
- batch belongs to the requested project and is in an allowed state;
- caller has current project import/edit authority;
- batch document type is valid for the project and import operation;
- required fields, normalized lengths, and safe JSON/extra payload bounds;
- document number uniqueness and cross-type collision policy;
- revision index and label validity and idempotency;
- discipline identifier belongs to the approved canonical/project-specific set;
- legacy discipline aliases normalize only under the approved ARC/CIVSTR/MEC/ELE/SUR policy;
- response code exists, is active, belongs to the same project, is applicable to the document type, and is allowed by that type's response-code policy;
- date values parse strictly and comply with only explicitly approved chronology rules;
- lifecycle state and submitted/responded/due/closed timestamps are mutually consistent;
- no forbidden overwrite, self-approval, or workflow bypass is introduced by imported fields;
- errors are represented by stable machine-readable codes; unrestricted SQL error text is not returned to ordinary users.

The exact date chronology exceptions and MQR import policy remain unresolved governance items. They must not be invented in code.

## 6. Proposed implementation sequence and approval gates

### Phase A — Application surface and contract (no database mutation)
- Establish the route/component architecture and identify the intended project/type context.
- Define typed contracts for staged rows, server validation results, commit summaries, and row-level failures.
- Add a real import route and UI only after confirming current app shell/auth patterns.
- Wire parser errors, including `WorkbookLimitError`, to safe localized UI messages.
- Add pure unit tests for parser, mapping, preview, and UI state transitions.

### Phase B — Authenticated staging and server validation design
- Trace the verified-user middleware and user-scoped Supabase client pattern.
- Avoid importing the service-role client into client bundles or untrusted route modules.
- Prefer user-scoped RPCs with explicit authorization checks where feasible.
- Produce a proposed SQL/RPC change as a review artifact only; do not apply it.
- Ensure the server recomputes validation from stored staging data and trusted reference tables.

### Phase C — Database remediation proposal (blocked pending approval)
Prepare an isolated migration proposal for review covering:
- server-authoritative validation and commit eligibility;
- stable batch terminal states for mixed outcomes;
- controlled retry semantics with idempotency and row history;
- append-only, privacy-conscious import-row audit events;
- bounded input and safe error handling;
- grants, SECURITY DEFINER ownership/search_path, RLS interaction, and role tests.

No migration is to be applied until the project/database owner is identified, a fresh independent backup is taken, restore is verified in a separate project, the exact migration is reviewed, and the user explicitly approves execution.

### Phase D — Verification and release
- Run unit, integration, authorization-negative, multi-chunk, mixed-outcome, retry, and concurrency tests in an isolated environment.
- Verify that failures do not leak transaction/session flags and that a subsequent unrelated operation behaves normally.
- Verify refreshed/reopened batch state and per-row audit history.
- Only then request review/merge/deployment approval.

## 7. Acceptance tests

| Area | Required proof |
|---|---|
| Upload | Oversized file and invalid workbook are rejected before row materialization |
| Workbook | Sheet, row, column, total-cell, and cell-text limits produce safe messages |
| Mapping | Required columns and explicit date order are enforced |
| Values | Unknown/inactive/foreign-project discipline or response codes are rejected server-side |
| Dates | Invalid values and unapproved chronology contradictions are rejected |
| Staging | Row IDs cannot be used across batches or projects |
| Validation | Forged client `valid/import` flags do not bypass server validation |
| Commit | Caller without current project permission is rejected |
| Integrity | Existing document/revision data is never overwritten |
| Idempotency | Repeating a successful commit does not duplicate documents/revisions |
| Partial results | Batch status and UI accurately distinguish successes, skips, failures, and remaining rows |
| Retry | Only explicitly eligible failed rows can be retried; successful rows remain immutable |
| Audit | Row validation/commit/retry transitions are recorded with minimal safe data |
| Authorization | Cross-project reads/writes, service-role leakage, and unauthorized actions fail |
| Recovery | A row-level failure does not poison later chunks or subsequent operations |

## 8. Current blockers and explicit non-claims

- No actual import UI or active `parseWorkbook` caller was found in the reviewed source inventory.
- No live database or deployed RPC was inspected.
- No server-side import revalidation was implemented.
- No retry RPC or row-audit trigger was implemented.
- No batch-state schema change was proposed as an applied change.
- No SQL, migration, generated type, database, or stored data was modified.
- No Vitest, lint, typecheck, integration test, build, or deployment was run.
- PR #15 remains a draft, unmerged, and not deployed.
- The archive is a source snapshot; the findings must be reconciled with a fresh repository inventory before implementation begins.

## 9. Immediate next action

The next safe implementation task is to establish the real application route/authentication pattern from the current repository head and design the missing import route and server function contracts without touching generated files or database migrations. Once the route and server boundary are verified, implement the UI and parser integration in a dedicated branch. In parallel, prepare the database remediation as a separate review-only proposal behind the backup/restore and explicit-approval gate.


## 10. Authentication and staging-write boundary follow-up

Additional static inspection of `src/start.ts`, `src/integrations/supabase/auth-attacher.ts`, `src/integrations/supabase/auth-middleware.ts`, and `src/integrations/supabase/client.server.ts` established:

- `src/start.ts` registers `attachSupabaseAuth` globally for server functions; the client middleware attaches the current Supabase bearer token when a session exists.
- `requireSupabaseAuth` is a separate server middleware that validates the bearer token with `supabase.auth.getClaims(token)` and provides a user-scoped Supabase client and user ID in function context. A future import server function must explicitly use this verified-user middleware; the global token attacher alone is not authentication or authorization.
- The reviewed source inventory contains no `*.functions.ts` import server-function module and no import server route. Therefore there is no existing import handler whose auth chain can currently be confirmed.
- `src/integrations/supabase/client.server.ts` exposes a service-role client that bypasses RLS. It must not be imported by browser-shipped code or used as the default import path. Prefer the verified user-scoped client and database authorization checks. If a service-role operation is proven necessary, isolate it in a server-only module, validate the caller and project authority first, and document the privileged action.
- Report 31 also identifies direct authenticated UPDATE grants on import staging tables, including commit-control fields, and a scope trigger that runs on INSERT only. This means the database write surface needs more than just a safer UI or a server function: direct table writes must be constrained in an approved database remediation.

These observations remain static source/migration findings. No JWT, middleware, role, RLS, grant, or live database behavior was executed. Generated integration files must not be edited directly.
