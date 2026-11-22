# 18 — Import Commit Server-Side Validation Gaps

**Review type:** Static source and test-coverage review  
**Branch:** `dev/review-fixes`  
**Files reviewed:** `src/lib/import/mapping.ts`, `src/test/domain-rules.test.ts`, `drizzle/migrations/0001_triggers_and_rpcs.sql`, `drizzle/migrations/0003_import_validation_and_kpi_buckets.sql`  
**Database access:** None. No live import batch or RPC execution was performed.  
**Changes:** Documentation only.

## Executive summary

The import UI performs useful client-side mapping and validation, but the database commit RPC relies substantially on values stored in `import_rows.mapped` and on client-supplied `validation_status` and `decision`. The validation-save RPC is SECURITY INVOKER and checks that the caller can edit documents in the batch project; it does not independently recompute the full import validation rules.

The commit RPC does enforce several important controls (batch authorization, batch state, required document number/status, enum casting, foreign keys, and duplicate revision handling). However, the reviewed source does not show a complete server-side revalidation of response-code validity, response-code applicability, date consistency, discipline policy, or all field constraints before writing the privileged import records.

This is a confirmed source-level validation gap. It is not a claim that an unauthorized user can invoke the RPC: the RPC checks `can_edit_documents`. The concern is data integrity and policy enforcement at the privileged commit boundary.

## Source-level observations

### 1. Validation status and decision are client-writable staging fields

`save_import_validation(_batch, _rows)` updates `mapped`, `validation_status`, `messages`, and `decision` from a JSON recordset. It checks `can_edit_documents` for the batch project and updates only rows belonging to the batch that have not yet been committed.

The commit RPC then selects rows using:

- `decision = 'import'`
- `commit_status is null`
- `validation_status in ('valid','warning')`

The selection criteria are therefore based on editable staging fields, rather than a server-generated validation result that cannot be forged by the client. Project editors are authorized to import, but the commit boundary should still enforce canonical data rules independently.

### 2. Response-code validation is incomplete at commit

The client validator checks a response code against `ctx.activeCodes` and `usesResponseCodes`. The commit RPC reads `m->>'response_code'` and inserts it into document/revision fields, but the reviewed commit body does not re-check that the code:

- exists and is active for this project;
- is applicable to the batch's document type;
- is allowed when the document type does not use response codes;
- has the expected outcome and permitted lifecycle effect.

The document and revision response-code columns are text fields, so a foreign key does not enforce membership in the project's active response-code set.

### 3. Discipline validation is only partly enforced

The client checks the mapped discipline identifier against the IDs supplied in its validation context. The commit RPC casts `discipline_id` from mapped JSON to UUID and inserts it. The schema foreign key can ensure that the ID refers to an existing discipline, but the reviewed code does not show a server-side check against the approved canonical set or a project-specific allowed discipline set.

This matters because the current seed taxonomy itself is out of alignment with the approved ARC/CIVSTR/MEC/ELE/SUR model (see Report 17).

### 4. Date and cross-field consistency are not revalidated

The client parser validates date syntax and uses an explicit DMY/MDY/YMD selection. The commit RPC casts submitted/response/due dates but does not visibly enforce business consistency such as:

- response date not preceding submission date;
- due date semantics for imported historical records;
- lifecycle/status consistency with required timestamps;
- whether a closed record has a defensible closure/response timestamp;
- whether response metadata is permitted for a type that does not use response codes.

Invalid casts are caught per row and recorded as failed, but successful casts do not prove the values are semantically consistent.

### 5. Server-side checks that are already present

The reviewed RPC does enforce several useful constraints:

- caller must be able to edit the batch project;
- batch must exist and be in validated/committing state;
- batch document type must be present;
- document number and status must be present;
- lifecycle status is cast to the database enum;
- revision index/label uniqueness is checked before adding a revision;
- cross-type document-number collisions are rejected;
- the function processes a bounded chunk and records per-row failures.

These controls should be retained and extended, not replaced.

## Required remediation design — NOT APPLIED

1. Treat `validation_status`, `messages`, and `decision` as UI workflow hints, not security evidence.
2. In `commit_import_rows`, re-read the batch, document type, active project response codes, and discipline reference data from trusted database tables.
3. Validate every mapped row on the server immediately before insert/update:
   - required fields and length limits;
   - document type / batch consistency;
   - canonical discipline membership and approved alias normalization;
   - response-code existence, active status, type applicability, and outcome;
   - response-code prohibition for types that do not use codes;
   - date parse and chronology rules;
   - lifecycle and timestamp consistency;
   - revision index and label validity;
   - safe metadata/extra payload limits.
4. Make the server produce the final row decision, or store a server-verifiable validation hash/version tied to the exact mapped payload. Do not trust a client-set `valid` flag.
5. Keep the import operation idempotent and preserve the existing never-overwrite behavior.
6. Ensure one invalid row cannot leave session flags or transaction state enabled; add rollback and subsequent-operation tests for exception paths.
7. Return stable machine-readable error codes rather than exposing raw `sqlerrm` text to ordinary users, while retaining diagnostic detail in a restricted audit channel.

## Adversarial test matrix to add

| Scenario | Expected server behavior |
|---|---|
| Client marks malformed row as valid/import | Reject row at commit |
| Inactive or unknown response code | Reject row |
| Response code from another project | Reject row |
| Response code supplied for a no-code type | Reject or explicitly ignore under documented rule |
| Forged discipline UUID | Reject row |
| Existing but noncanonical discipline | Normalize only through approved alias rule or reject |
| Invalid date string | Reject row |
| Response timestamp before submission timestamp | Reject unless an explicit legacy exception is approved |
| Lifecycle/timestamp contradiction | Reject or route to a documented legacy exception |
| Negative revision index | Reject row |
| Overlong title/revision label | Reject row cleanly |
| Same document/revision submitted twice | Idempotently skip existing revision |
| Same number under another document type | Reject without overwriting |
| Row ID from another batch | Do not update or commit it |
| Caller lacks project edit permission | Reject entire RPC |
| Per-row exception followed by next valid row | Continue safely with no leaked privileged state |
| Failed transaction followed by a new operation in same session | No stale import/transition flags |

## Status and approval boundary

- Client-side validation behavior: statically reviewed.
- Commit RPC validation: statically reviewed.
- Live RPC, RLS, and JWT behavior: **not tested**.
- No SQL, source, staging data, or database changes applied.
- No test suite, build, or deployment executed.
- Any remediation requires an approved exact migration, verified backup, tested restore, and explicit approval.
