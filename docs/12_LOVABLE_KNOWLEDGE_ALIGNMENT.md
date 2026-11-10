# 12 — Lovable Project Knowledge Alignment

**Date:** 2026-11-10  
**Lovable project:** Project Doc Control  
**Lovable project ID:** `8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`  
**Inspected source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Repository branch:** `dev/review-fixes`

## 1. Purpose

Align the persistent Lovable project knowledge with the latest user-approved Project Doc Control decisions, so future Lovable implementation work does not follow superseded requirements.

## 2. Conflict discovered

The existing project knowledge contained legacy statements that Civil and Structural were separate disciplines. This directly conflicted with the later approved decision to combine them as `CIVSTR` and add `SUR` as the fifth discipline.

## 3. Knowledge amendment applied and verified

The Lovable project knowledge was updated in place, preserving the existing project instructions and adding a concise authoritative section that supersedes conflicting legacy wording.

The latest authoritative rules now state:

- Exactly five disciplines: `ARC`, `CIVSTR`, `MEC`, `ELE`, and `SUR`.
- `STR` and `CIV` are legacy aliases to normalize to `CIVSTR` in current workflows and KPI reporting.
- RFI means Request for Inspection only and remains separate from WIR.
- MQR means Monthly Quality Report and has an independent workflow without default A/B/C/D/E/I response codes.
- E is an originating-contractor cancellation, not a reviewer decision.
- I closes the review cycle and archives the document; exclude I from B/C KPI metrics.
- Project Manager is a distinct role with read-all oversight, including drafts, but no implied editing, submission, review, response, return, approval, or close authority.
- Administrative privileges do not bypass workflow-party authorization or permit submitter self-approval.
- No production data changes, migrations, generated schema/type edits, or merge to `main` without explicit approval and a verified recovery plan.

The updated knowledge was read back from Lovable and verified to contain the authoritative discipline, workflow, and Project Manager decisions. The obsolete separate-discipline sentence is no longer present.

## 4. Source inspection findings

A read-only inspection of the current Lovable source confirmed that implementation work is still required:

- `src/routes/index.tsx` still renders the Lovable blank-page placeholder.
- `src/lib/domain.ts` still grants project `admin` a UI reviewer bypass and permits admin submission without the originating-party match.
- `src/lib/domain.ts` currently lists only `admin`, `controller`, `reviewer`, and `viewer`; the distinct `project_manager` role is not represented there.
- `src/lib/import/mapping.ts` maps discipline values only by exact current database code/name; no explicit legacy `STR`/`CIV` normalization to `CIVSTR` is present.
- `src/lib/kpi.ts` groups directly by raw `discipline_code`; no normalization layer is present.

These are static source observations, not runtime test results.

## 5. Change boundaries and status

- **Changed:** Lovable project knowledge only.
- **Not changed:** application source code, SQL migrations, generated files, database records, Supabase configuration, deployment, or GitHub branch protection.
- **Tests:** none run.
- **Database:** status check reported enabled; no SQL query or database connection was used.
- **Next implementation step:** prepare a small, reviewable application-code change plan for the UI authorization helper and discipline normalization, then route any schema/RLS/migration work through Lovable with a separate approval and verified recovery plan.

This report documents the knowledge alignment and static inspection only. It does not claim that the application defects have been fixed.
