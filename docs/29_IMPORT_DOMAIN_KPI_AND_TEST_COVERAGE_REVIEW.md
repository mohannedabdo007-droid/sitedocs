# 29 — Import Pipeline, Domain Rules, KPI Semantics, and Test Coverage Review

**Branch:** `dev/review-fixes`  
**Review type:** Static source and test review only  
**Scope:** `src/lib/domain.ts`, `src/lib/import/mapping.ts`, `src/lib/import/excel.ts`, `src/lib/kpi.ts`, `src/lib/numbering.ts`, `src/test/domain-rules.test.ts`, `src/test/app-routing.test.tsx`, `src/routes/index.tsx`.

## Executive summary

The repository has useful client-side helpers for workflow action display, Excel parsing/mapping, document numbering, and KPI aggregation. Their tests cover selected happy paths and basic edge cases. They do not establish server-side enforcement, RLS correctness, or conformance to the latest approved business baseline.

Several concrete mismatches remain between current helper logic and approved decisions: the UI still grants admins broad workflow action visibility, the domain lifecycle and role vocabularies omit approved concepts, import date parse failures are warnings that remain importable, and KPI grouping uses raw discipline codes. The root route is still the blank placeholder.

No source, test, SQL, database, generated file, deployment, or project setting was changed. No tests, lint, build, or browser session were executed.

## Findings

### F-29-01 — Client workflow helper still grants administrator party bypass (Critical; UI policy mismatch)

`availableActions()` treats `role === "admin"` as a universal reviewer and allows admin submission regardless of originating party. This conflicts with the approved rule that project administration does not automatically confer workflow authority or permit bypassing the authorized party. The helper is UI-only, but it can expose prohibited actions and encourage reliance on an incorrect policy.

**Required control:** Align UI affordances with the approved party/role matrix, but enforce every transition in the database/server independently. No broad admin override. Add negative tests for admin from the wrong party, originator self-review, wrong current party, and PM read-only behavior.

### F-29-02 — Domain enums omit approved Project Manager, cancellation, and archive concepts (High)

`PROJECT_ROLES` is limited to admin/controller/reviewer/viewer; no distinct PM role exists. `LIFECYCLE` contains draft/submitted/under_review/returned/approved/closed only; there are no explicit cancelled or archived states. The approved baseline requires a distinct read-only PM role and recognizes E as cancellation by the originating contractor and I as closing the review cycle with archival. Exact operational transitions remain subject to the unresolved policy decisions register, so this report does not prescribe an unapproved state machine.

**Required control:** Model PM separately from company/project administration. Resolve the outstanding cancellation/archive transition semantics before expanding lifecycle enums or migrations. Preserve historical values and records.

### F-29-03 — Revision creation helper permits broad role-based action without party/lifecycle context (High)

`canAddRevision()` allows admin or controller when status is returned or approved. Its input does not include party, originator, or document ownership, so it cannot establish that the caller is the authorized originating party. This is a presentation helper only; the server/RPC must be authoritative.

**Required control:** Define the approved revision-creation authority and mirror it in UI only after server policy is fixed. Add server-side authorization tests.

### F-29-04 — Invalid import dates are warnings and rows remain importable (High; data integrity)

In `validateRows()`, invalid submitted/responded/due dates are converted to null and appended to `warnings`, not `errors`. A row with an invalid date can therefore receive `validation_status = "warning"` and `decision = "import"`. This risks silently importing incomplete chronology while the user may assume all mapped dates were retained.

**Required control:** Decide explicitly whether invalid optional dates should block the row or require a separately acknowledged warning. Show the original invalid value and require an explicit decision if importing with the date discarded. Revalidate on the server at commit; do not trust the client validation result.

### F-29-05 — Client import validator does not enforce semantic date chronology (Medium)

The visible client validator parses individual dates but does not compare submitted, responded, and due dates for chronology or consistency with lifecycle status. Server-side commit gaps are already recorded in Report 18; this is a further UI/test parity requirement, not evidence of a server exploit.

**Required control:** Agree chronology rules, implement them server-side first, then mirror them client-side. Cover date-only and timestamp cases, null dates, returned/closed/cancelled/archived states, and imported legacy records.

### F-29-06 — Canonical discipline aliases are not normalized (Medium; reporting and import consistency)

Value mapping matches discipline code/name exactly (case-insensitive for English code/name, exact Arabic name). It does not normalize the legacy STR/CIV values into the approved CIVSTR discipline, nor does it provide a canonical SUR mapping for the newly approved Survey discipline unless the project reference data already contains it. Unmatched values remain unresolved, which is safer than guessing, but it creates a required controlled mapping step and KPI alias risk.

**Required control:** Use canonical project reference data ARC/CIVSTR/MEC/ELE/SUR. Provide explicit, reviewable legacy alias mappings (e.g. STR and CIV to CIVSTR only where project owners confirm meaning). Never auto-map ambiguous values.

### F-29-07 — KPI discipline grouping uses raw source code (Medium)

`summarizeKpis()` groups rows by `discipline_code` exactly as supplied. It does not canonicalize legacy aliases. This can split one approved discipline into multiple KPI buckets (e.g. CIVSTR versus legacy STR/CIV). B/C numerator counts are present, but the denominator remains undefined in this client summary and was already recorded as an open decision in Report 24.

**Required control:** Canonicalize discipline reference identifiers/codes at the server aggregation boundary, retain source labels for traceability, and implement the KPI formula only after approval of the denominator and E/I treatment.

### F-29-08 — Existing tests are narrow and do not test security boundaries (High; coverage gap)

`domain-rules.test.ts` tests numbering, a few UI workflow cases, pending/overdue calculations, KPI B/C aggregation, and import mapping/date/revision basics. `app-routing.test.tsx` only verifies that `/` matches a route; it does not render the route or assert a real application shell. No tests in these files exercise database RPC authorization, RLS, Storage object access, draft confidentiality, server-side import commit, service-role isolation, cron authentication, PM permissions, or self-approval.

**Required control:** Treat existing tests as unit-level helper coverage only. Implement the acceptance catalogue from Report 23 as server/database integration tests and execute it against a controlled restored test environment before release.

### F-29-09 — Root route remains a blank Lovable placeholder (P0 product readiness)

`src/routes/index.tsx` renders the blank-page SVG and carries `data-lovable-blank-page-placeholder="REMOVE_THIS"`. The routing test proves only that a route matches, not that the product UI exists. This is consistent with Report 25 and remains a release blocker.

**Required control:** Build the real application shell and protected route structure through the owning Lovable workflow, then test rendered pages and authorization. Lovable currently reported an out-of-credits block; do not claim implementation progress until that blocker is resolved.

## Additional verified implementation notes

- Excel parsing runs in the browser using the `xlsx` package; its comment says the file remains on-device until rows are staged.
- Column suggestions are heuristics; explicit value mapping is required for disciplines, statuses, and response codes.
- The client validator checks response codes against the supplied active-code list and warns when codes are present for a type that does not use response codes.
- Duplicate document/revision rows and existing conflicts are retained and flagged rather than silently dropped.
- Numbering helper supports project/type/discipline/sequence/date tokens, but `isValidPattern()` only checks that a sequence token appears and that the pattern length is at most 120; it does not validate all token syntax or semantic uniqueness.
- KPI B/C counting is a numerator only; it is not a complete approved KPI definition.

## Required test additions

1. Admin from a non-authorized party cannot submit, start review, respond, return, or close.
2. Originator cannot review or approve its own submission under the approved identity boundary.
3. PM can read all permitted records including drafts but cannot mutate or decide.
4. Draft visibility and attachment access are tested across parties and lifecycle states.
5. Invalid import dates cannot silently become accepted imports without an explicit policy/decision.
6. Import commit rejects forged client validation, inactive/unknown response codes, cross-project IDs, noncanonical discipline IDs, invalid chronology, and unauthorized rows.
7. CIV/STR legacy alias mapping is explicit; canonical KPI grouping produces one CIVSTR bucket.
8. E and I outcomes follow their approved meanings; MQR has its independent flow and no default response codes.
9. Numbering patterns reject malformed/unknown tokens and unsafe widths.
10. Route tests render the actual application shell and verify protected navigation and forbidden access states.

## Implementation boundary and sequence

1. Resolve the still-open policy decisions documented in Report 24 before choosing lifecycle transitions, self-approval identity boundary, KPI denominator, MQR details, and post-submission visibility.
2. Restore/verify a controlled test environment and backup/restore before any database change.
3. Implement server/RPC/RLS/Storage authorization first; client helpers are not security controls.
4. Implement import commit revalidation server-side, then align client validation and regression tests.
5. Canonicalize disciplines and KPI buckets from approved reference data.
6. Build the real route shell and feature pages through Lovable, then run unit, integration, security, and production-build checks.

**Conclusion:** Client-side helpers are a useful foundation, not a security boundary or proof of application readiness. This is a static review only and is not a runtime security certification.
