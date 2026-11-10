# 13 — Application Remediation Execution Plan

**Date:** 2026-11-10  
**Project:** Project Doc Control  
**Inspected Lovable source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Target review branch:** `dev/review-fixes`

## Purpose

Convert the confirmed static source findings into a small, testable implementation sequence. This is a plan, not a claim that defects have been fixed.

## Confirmed source observations

1. `src/lib/domain.ts`
   - `PROJECT_ROLES` contains admin, controller, reviewer and viewer only; Project Manager is not represented as a distinct role in this frontend domain type.
   - `availableActions` treats admin as reviewer regardless of the current workflow party.
   - The submit condition allows admin to bypass the originating-party match.
   - These are UI/domain helper findings only. Server/RLS/RPC enforcement must be inspected and tested separately before concluding the effective security boundary.

2. `src/lib/import/mapping.ts`
   - Discipline suggestions require exact code/name matches.
   - No explicit legacy STR/CIV alias normalization is present.
   - Do not automatically map ambiguous historical values without a clear, reviewed alias table.

3. `src/lib/kpi.ts`
   - KPI grouping uses raw `discipline_code`.
   - No normalization layer maps STR/CIV to CIVSTR.
   - I response exclusion is not visible in this aggregation helper and must be verified in its data source/query as well.

4. `src/routes/index.tsx`
   - The home route still renders the Lovable blank-page placeholder.

## Recommended implementation sequence

### Phase A — tests before behavior changes
Add focused unit tests for:
- Admin cannot start/respond/return on a workflow step assigned to another party.
- Submitter/originator cannot approve or review their own submission.
- Project Manager read scope is separate from action permissions.
- Exactly five current disciplines are represented: ARC, CIVSTR, MEC, ELE, SUR.
- STR and CIV normalize to CIVSTR for imports and KPI grouping without rewriting historical document identifiers.
- MQR does not inherit default response codes.
- I closes/archives a review and is excluded from B/C KPI counts.
- RFI and WIR remain distinct document types/workflows.

### Phase B — pure frontend domain and normalization helpers
After tests are in place, implement a narrow, reviewable change to:
- Remove UI admin bypasses and require the designated workflow party for reviewer actions.
- Model Project Manager as a read-only oversight role in the UI, without implying any server authority.
- Add a single explicit discipline alias normalization helper used by import mapping and KPI presentation.
- Keep unknown discipline values unmapped for human review.

### Phase C — server authorization audit
Inspect the actual RPCs, RLS policies, and Storage policies. Do not infer security from UI helpers. Prove:
- Party checks cannot be bypassed by administrative UI role.
- Submitter self-approval is blocked.
- Project Manager read access does not imply mutation or review access.
- Draft visibility follows the approved exception for PM oversight only.
- Storage access follows document visibility and action authorization.

Any SQL/schema changes remain Lovable-managed and require a separately reviewed migration, verified backup, successful restore rehearsal, and explicit approval.

### Phase D — workflows, reporting and product UI
Only after authorization and domain tests pass:
- Implement distinct RFI/WIR and MQR workflow handling.
- Normalize legacy disciplines in reports while preserving historical identifiers.
- Replace the blank home route with the approved product shell and navigation.
- Build screens against verified data contracts rather than mock-only assumptions.

### Phase E — verification and release readiness
Run and record:
- `npm test`
- `npm run lint`
- `npm run build`
- Targeted adversarial authorization tests against the actual backend in a safe test environment.
- Import, numbering, revision, archive, attachment/storage and KPI integration tests.

Do not describe a phase as complete unless its tests and evidence are recorded. Do not merge PR #1 or deploy until the release gates are met and the user explicitly approves.

## Current execution status

- Static source review: completed for the four files listed above.
- New application tests: not added.
- Application source changes: none.
- SQL/migrations/database: untouched.
- Build, lint and tests: not run.
- Next safe action: inspect the remaining test and server authorization source files, then produce a test-first change proposal for Lovable. Confirm available Lovable credits before requesting code-generation/build work.
