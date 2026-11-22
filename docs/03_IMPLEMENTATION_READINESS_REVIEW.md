# 03 — Implementation Readiness Review

**Review date:** 2026-11-10  
**Repository:** `mohannedabdo007-droid/sitedocs`  
**Working branch:** `dev/review-fixes`  
**Scope:** Read-only inspection of the current Git branch and the connected Lovable project.  
**Status:** Findings recorded; no application code, dependencies, migrations, database data, or deployment settings changed.

## 1. Evidence and revision alignment

- Git branch head observed during this review: `4c3cb43ad0bc371921a30cf3a74dc6a6b49c4909`.
- Lovable project ID: `8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`.
- Lovable latest commit reported during this review: `963a4af6226e1451b0b155913abb2a4f6770485f`.
- The two revisions differ. The Lovable revision was used only for read-only source inspection; the branch head was used for repository documentation inspection.
- Do not assume the branch and Lovable editor are fully synchronized until their refs are reconciled. Do not overwrite either side or attempt a history rewrite.

## 2. Confirmed application-code findings

### 2.1 Home route is still a scaffold placeholder

At the inspected Lovable revision, `src/routes/index.tsx` renders the blank-app illustration and includes the marker `data-lovable-blank-page-placeholder="REMOVE_THIS"`. It does not render a Project Doc Control dashboard or document-management workflow.

**Consequence:** The functional UI build has not yet started at the root route. Build product screens only after the domain, authorization, and data contracts are agreed and tested.

### 2.2 Drizzle schema is intentionally blank

`drizzle/schema.ts` contains only the generated-file warning and is intentionally blank. `AGENTS.md` prohibits manually editing generated files and Lovable-managed database migration paths.

**Consequence:** Do not hand-author Drizzle schema or edit historical migrations. Database schema changes must be requested through Lovable and reviewed as forward migrations.

### 2.3 Workflow helper allows an admin bypass

At the inspected revision, `src/lib/domain.ts` defines `reviewer = isAdmin || party === currentParty(doc)`. This means the client-side action helper treats any project admin as a reviewer regardless of the current workflow party. The SQL review also identified an admin party-check bypass in `public.transition_document`.

**Consequence:** The UI helper and server transition RPC must be corrected together. The server remains authoritative. An admin role must not bypass party separation or submitter-versus-approver separation. Project Manager read-all-drafts permission remains read-only and must not be conflated with admin/reviewer rights.

### 2.4 Import mapping is reference-data driven

`src/lib/import/mapping.ts` matches a discipline only against the discipline records supplied to it (code, English name, Arabic name). It does not independently define the approved target catalogue or alias old codes.

**Consequence:** When the five-discipline catalogue is implemented, the server-provided catalogue and explicit legacy aliases must be handled consistently. Legacy `STR` and `CIV` values must not silently map to arbitrary records; they require an explicit, tested mapping to the combined `CIVSTR` record.

### 2.5 KPI grouping uses discipline codes

`src/lib/kpi.ts` groups KPI rows using the `discipline_code` supplied by the database. The SQL KPI function also joins the discipline reference table.

**Consequence:** Adding Survey and consolidating Civil/Structural must be reflected in the reference data and database KPI source, then verified in the UI and reports. A UI-only label change is insufficient.

## 3. Approved product decisions to preserve

- Exactly five selectable disciplines: `ARC` Architectural / معماري; `CIVSTR` Civil & Structural / مدني وإنشائي; `MEC` Mechanical / ميكانيكي; `ELE` Electrical / كهربائي; `SUR` Survey / مساحة.
- Civil and Structural are one combined discipline, not separate options.
- Legacy `STR` and `CIV` references require a controlled compatibility/migration plan; preserve document numbers, revisions, and audit history.
- RFI means **Request for Inspection** and remains separate from WIR.
- MQR means **Monthly Quality Report**, has an independent workflow, and has no default response-code scheme.
- Response code E is an originating-party cancel action, not a reviewer response and not authorization to add a `cancelled` enum value.
- Response code I closes the review cycle while retaining the document in the archive; exclude I from B/C KPI counts.
- Drafts are hidden from other parties before formal submission.
- Project Manager may read all project documents, including drafts, for oversight only; this does not grant edit, submit, review, approval, or closure rights.
- Do not merge to `main` without explicit approval.

## 4. Required implementation sequence

1. Reconcile the Git branch head and Lovable latest commit; document the authoritative connected branch and any unsynced commits.
2. Establish the correct Project Doc Control Supabase backend and a disposable isolated test target. Do not infer the backend from an unrelated Supabase project.
3. Complete independent backup and a successful restore into a separate compatible environment. The checklist in `docs/PHASE_0_BACKUP_RESTORE_CHECKLIST.md` remains preparation only; no successful restore is evidenced.
4. Capture a live read-only schema, grants, RLS, function privileges, Storage configuration, row counts, discipline references, and numbering-scheme inventory on the isolated restored target.
5. Write and run tests that demonstrate the current authorization failures before fixes.
6. Correct server-side party/role mutation, workflow bypass, submitter/approver separation, RPC grants, document visibility, Storage document-level authorization, and account-enumeration behavior.
7. Prepare a forward-only discipline migration plan after inspecting all references and numbering collisions. Preserve existing document numbers and audit records; do not delete legacy references without a proven dependency review.
8. Correct import aliases, KPI behavior, RFI/WIR terminology, and MQR/E/I workflow semantics with regression tests.
9. Build the application routes and screens only after the tested authorization and data contracts are stable.
10. Run lint, tests, and production build in a controlled environment; record exact commands and results.
11. Commit all approved changes and documentation to `dev/review-fixes`, fetch-verify each result, and do not merge to `main` without approval.

## 5. Verification status

| Item | Status |
|---|---|
| Static source inspection | Completed for the files listed above |
| Live database identity and catalog | Not verified |
| Independent backup | Not executed / not evidenced |
| Isolated restore | Not executed / not evidenced |
| RLS and workflow tests | Not run in this review |
| Lint, test suite, production build | Not run in this review |
| Lovable/Git branch synchronization | Mismatch observed; reconciliation required |
| Database migration | Not created or applied |
| Production data changes | None |
| Deployment or merge to main | None |

## 6. Stop conditions

Stop before any database or production change if the backend identity is uncertain, backup/restore is unverified, the target is production-only, numbering collisions have not been inspected, or the exact migration and rollback/forward-recovery plan have not been reviewed and explicitly approved.

This document records readiness findings only. It is not an authorization to modify the database, deploy, change dependencies, or merge branches.


### 2.6 Existing tests do not yet cover the approved target catalogue or admin bypass

The inspected `src/test/domain-rules.test.ts` contains useful unit coverage for numbering, workflow actions, KPIs, and import validation, but:
- the workflow tests do not include a project `admin` attempting to respond from the wrong party or approve a document the admin submitted;
- the import fixture still uses the legacy `STR` discipline ID and mapping;
- the KPI fixture still groups under `STR`;
- no test in the inspected test file asserts exactly five selectable disciplines or legacy `STR`/`CIV` compatibility with `CIVSTR`.

The routing test only confirms that a route matches `/`; it does not establish that a usable product dashboard exists. Test files were read, but no test command was run.

**Consequence:** Add explicit regression tests for the admin bypass, submitter/approver separation, PM read-only exception, five-discipline catalogue, legacy import aliases, and KPI grouping before accepting implementation changes.


## 7. Follow-up synchronization verification

A follow-up comparison was performed after this review was committed:

- Lovable latest revision remains `963a4af6226e1451b0b155913abb2a4f6770485f`.
- GitHub `dev/review-fixes` contains the review documentation commits and remains 14 commits ahead of the protected backup.
- The following application files were fetched from both Lovable and GitHub and their UTF-8 contents compared byte-for-byte; all matched exactly:
  - `src/lib/domain.ts`
  - `src/lib/import/mapping.ts`
  - `src/lib/kpi.ts`
  - `src/routes/index.tsx`
  - `src/routes/__root.tsx`
  - `drizzle/schema.ts`
  - `package.json`
  - `AGENTS.md`
  - `src/test/domain-rules.test.ts`
- The Lovable revision SHA is not present as a GitHub commit in this repository, so the two systems do not share a directly verifiable commit identity. However, the inspected source files match exactly. The documented branch difference is the repository-only review documentation; no application-source divergence was found in the files compared.
- The backup branch still points to `7e0135f279fa3924e7b48f82fb319b8872d14ebf`; it was not changed.

**Updated synchronization conclusion:** source-level alignment is verified for the listed files. Do not attempt a merge, force push, or copy commits solely to make the SHA values identical. Keep documentation in GitHub and continue verifying application files after future Lovable edits.
