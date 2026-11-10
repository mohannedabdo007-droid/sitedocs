# 11 — Application Domain and Requirements Gap Review

**Review date:** 2026-11-10  
**Source reviewed:** `backup/lovable-2026-11-10` at `7e0135f279fa3924e7b48f82fb319b8872d14ebf`  
**Review branch for this report:** `dev/review-fixes`  
**Method:** static inspection of tracked source and tests. No runtime tests were executed and no application, migration, generated file, or database was changed.

## 1. Executive summary

The application source snapshot is not yet ready to represent the approved Project Doc Control requirements. The most important gaps are:

1. The UI domain helper grants project administrators a bypass for submit/respond/return decisions that conflicts with the approved separation of duties.
2. The project role and party vocabularies do not explicitly represent the Project Manager role and its read-all/draft-read-only scope.
3. The discipline and KPI helpers do not normalize legacy STR/CIV into the approved CIVSTR discipline, and SUR is not covered by the visible tests.
4. The root route is an explicit Lovable blank-page placeholder.
5. Existing tests validate only a subset of required authorization, workflow, discipline and KPI edge cases.

These are static source findings. Server-side RPC and RLS remain the ultimate security boundary and must be audited/tested independently; a UI helper fix alone would not secure the backend.

## 2. Findings

### APP-11-01 — Project admin bypasses party checks in UI action calculation

**Severity: HIGH — requirements conflict; server authorization must also be tested.**

File: `src/lib/domain.ts`, function `availableActions`.

The helper sets:
- `isAdmin = role === "admin"`;
- `reviewer = isAdmin || party === currentParty(doc)`.

It also permits an admin to submit a draft/returned document regardless of whether the admin's party is the originating party. Therefore an admin can be offered `submit`, `start_review`, `respond` and `return` even when their party does not match the workflow party.

This conflicts with the approved rule that project administration/read visibility does not itself confer authority to act for the contractor, consultant, owner or PMC. It also conflicts with the earlier audit's identified SQL RPC admin bypass risk.

**Required correction:** define action authorization by both role and party/assignment, without an implicit admin override. Administrative visibility and operational authority must remain separate. Confirm equivalent checks in RPCs and RLS; do not rely on front-end hiding.

### APP-11-02 — Project Manager role and permissions are not represented

**Severity: HIGH — requirements coverage gap.**

File: `src/lib/domain.ts`.

The project role list is `admin`, `controller`, `reviewer`, `viewer`; the party list is `contractor`, `consultant`, `owner`, `pmc`. There is no explicit Project Manager role in the visible type vocabulary.

The approved requirement is that the Project Manager may read all project documents, including drafts, for oversight, but may not edit, submit, review, respond, approve, return or close documents merely because of the PM role. PM is distinct from Company Admin.

**Required correction:** model PM as a distinct, explicit read-only project role/permission set. Keep read-all access separate from all mutation/action permissions. Add positive and negative tests for draft visibility and every prohibited action. Verify server-side RLS/RPC enforcement.

### APP-11-03 — Discipline aliases and five-discipline catalogue are not normalized

**Severity: HIGH — data consistency and reporting gap.**

Files: `src/lib/import/mapping.ts`, `src/lib/kpi.ts`, `src/test/domain-rules.test.ts`.

The import helper suggests discipline mappings only by exact code or exact English/Arabic name in the active discipline context. The visible test fixture contains only `STR`. The KPI helper groups directly by the raw `discipline_code` string.

Approved current catalogue:
- ARC — Architectural
- CIVSTR — Civil & Structural
- MEC — Mechanical
- ELE — Electrical
- SUR — Survey

Legacy `STR` and `CIV` are aliases to `CIVSTR`, not separate current selectable disciplines. The current tests do not verify either alias, the new `SUR` discipline, or that old STR/CIV KPI rows aggregate into CIVSTR.

**Required correction:** implement a single shared, explicit normalization map at the import/reporting boundary; preserve historical raw values where auditability requires them, but aggregate and present them under CIVSTR. Add tests for all five current disciplines and both legacy aliases. The database reference-data migration must remain a separate Lovable-managed, reviewed change.

### APP-11-04 — RFI and MQR semantics need explicit workflow coverage

**Severity: HIGH — workflow acceptance gap.**

The visible domain tests do not exercise RFI as Request for Inspection (separate from WIR) or MQR as Monthly Quality Report with an independent review workflow.

Approved requirements:
- RFI means Request for Inspection and is separate from WIR.
- MQR means Monthly Quality Report and has an independent review workflow.
- MQR does not use A/B/C/D/E/I response codes by default.
- I (For Information Only) closes the review cycle and archives the document.
- E (Cancelled by Contractor) is an originating-party cancellation, not a reviewer decision.
- Drafts are not visible to other parties before formal submission.

**Required correction:** add workflow-specific domain and integration tests for RFI, MQR, I, E and draft visibility. Do not infer that the generic lifecycle implementation already satisfies these semantics.

### APP-11-05 — Root route is a blank-page placeholder

**Severity: HIGH — application is not a usable product snapshot.**

File: `src/routes/index.tsx`.

The route contains a comment instructing replacement and renders the external blank-app illustration with `data-lovable-blank-page-placeholder="REMOVE_THIS"`.

**Required correction:** treat the current source snapshot as a scaffold, not a completed user interface. The actual product route and its authorization-aware navigation must be implemented through Lovable.

### APP-11-06 — Current tests do not cover critical authorization boundaries

**Severity: HIGH — assurance gap.**

File: `src/test/domain-rules.test.ts`.

The visible tests cover basic controller submission, current-party response, viewer no-actions, revision creation, a subset of KPI calculations, import mapping, and date/revision parsing.

They do not cover:
- Admin from a non-originating party cannot submit.
- Admin cannot respond/return on behalf of a different assigned party.
- Submitter cannot approve/review their own submission.
- Project Manager can read drafts but has no mutation/review actions.
- X1 sees only P2 documents for their company.
- Five current disciplines and STR/CIV legacy normalization.
- MQR independent workflow and absence of default response codes.
- I closes and archives; E is cancellation by the originating party.
- Drafts remain invisible to other parties before formal submission.

**Required correction:** add these as acceptance tests at both domain/unit level and server integration/RLS level. A passing UI unit test is not a substitute for server-side adversarial tests.

### APP-11-07 — Test/build/lint execution is unverified

**Severity: MEDIUM — validation not established.**

`package.json` defines `test`, `lint` and `build` scripts, but this review did not execute them. No GitHub Actions workflow or successful check evidence was found in the inspected snapshot.

**Required correction:** run these commands in a controlled environment using the committed lockfile and supported runtime; record exact results and fix failures in a separate reviewed change. Do not claim passing checks until actual output is captured.

## 3. Positive observations

- The domain module explicitly separates lifecycle states from response outcomes.
- Import value mapping avoids guessing ambiguous values such as `UR`.
- Import validation keeps duplicates and existing-revision conflicts visible rather than silently dropping them.
- Date parsing requires an explicit date order and rejects invalid calendar dates.
- The test suite already establishes a starting point for numbering, workflow, KPI and import tests.

These are useful foundations, but do not close the findings above.

## 4. Recommended implementation order

1. Resolve the role/party authorization model, including the PM read-only role and admin separation of duties.
2. Add domain-level tests for the full permission matrix before changing implementation.
3. Align backend RPC/RLS authorization with the same matrix and run adversarial integration tests.
4. Add the five-discipline canonical map and STR/CIV legacy aliases; test KPI normalization.
5. Add dedicated RFI/MQR/I/E/draft-visibility workflow tests.
6. Replace the placeholder route through Lovable and build the application screens against approved permissions.
7. Run lint, tests and production build; publish the results as CI checks.

## 5. Ownership and change-control restrictions

- Do not hand-edit `drizzle/`, `supabase/migrations/`, generated Supabase types or other Lovable-managed artifacts.
- Do not change production schema/reference data until a correct backend is verified, an independent backup is restored successfully in isolation, and the specific migration has been reviewed and approved.
- Preserve the backup branch unchanged.
- Keep implementation changes separate from the backup-import PR.
- No changes to application source, database, branches, PRs or deployments were made during this review.

## 6. Conclusion

The current source contains useful scaffolding and some sound validation patterns, but the role/party authorization gap, missing Project Manager permission model, discipline normalization gap and placeholder route prevent acceptance as a completed Project Doc Control implementation. Resolve these in controlled, separately reviewed work, with backend enforcement and tests—not by merging the source snapshot wholesale.
