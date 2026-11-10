# 25 — Frontend Route, Domain Model, and KPI Readiness Review

**Branch:** `dev/review-fixes`  
**Reviewed source:** `src/routes/index.tsx`, `src/routes/README.md`, `src/router.tsx`, `src/lib/domain.ts`, `src/lib/kpi.ts`  
**Baseline:** Reports 21–24  
**Review type:** Static source inspection only

## 1. Executive summary

The checked-in frontend is not yet a usable Project Doc Control application. The root route renders an explicit Lovable blank-page placeholder marked `REMOVE_THIS`. The shared domain model also lacks several approved concepts and contains UI authorization behavior that mirrors known server-side policy gaps. KPI aggregation calculates B/C counts but does not define an eligible denominator or canonicalize legacy discipline aliases.

These are source-level findings. No application was run, no tests/build/lint were executed, and no live backend was inspected.

## 2. Findings

### FE-01 — Root route is still a blank placeholder
**Priority:** P0 for product readiness  
**Evidence:** `src/routes/index.tsx` renders `https://cdn.gpteng.co/blank-app-v1.svg` and includes `data-lovable-blank-page-placeholder="REMOVE_THIS"`. The only visible route entry in `src/routes` is the root route plus root shell and route README.

**Impact:** The current branch does not present the actual document-control product at the root route. It is not evidence of a completed or deployable application.

**Required work:** Define the approved application shell, authentication/session gate, project selection, navigation, document register, workflow views, reporting and error/empty states before replacing the placeholder. Do not hand-edit generated `routeTree.gen.ts`; use the documented file-based routing conventions.

**Acceptance:** Root route renders the approved authenticated application experience; unauthenticated access follows the approved sign-in/redirect policy; projectless and error states are handled; route tree generation and build pass.

### FE-02 — Frontend lifecycle enum omits approved terminal states
**Priority:** P1  
**Evidence:** `src/lib/domain.ts` defines lifecycle values as `draft`, `submitted`, `under_review`, `returned`, `approved`, `closed`. It does not model explicit contractor-cancelled or archived/information-only terminal states.

**Impact:** E cancellation and I archive semantics cannot be represented clearly in the current shared TypeScript lifecycle type without overloading generic `closed`. UI filters, status labels, import parsing, tests and KPI logic may become inconsistent.

**Required work:** Design explicit domain representation for cancellation and archive outcomes, aligned with the authoritative database enum and transition model. Do not add TypeScript-only enum members that the server/database cannot persist.

**Acceptance:** Domain and database lifecycle/status mapping is exhaustive; every transition has valid source and destination states; old records map without rewriting audit history.

### FE-03 — Project Manager role is absent from frontend role model
**Priority:** P1  
**Evidence:** `PROJECT_ROLES` includes only `admin`, `controller`, `reviewer`, `viewer`.

**Impact:** The approved distinct read-only PM role cannot be represented as an explicit project capability. Mapping PM to viewer would lose project-wide draft oversight; mapping to admin would grant forbidden mutation/workflow powers.

**Required work:** Add PM only in coordination with the authoritative database role/capability model and RLS. Prefer capability-based permissions over scattered role-name shortcuts. PM must have read-all project visibility, including drafts, but no mutation, upload, submit, review, respond, return, approve or close authority.

**Acceptance:** PM can read authorized project documents and related resources; every direct mutation/RPC/Storage write attempt is denied.

### FE-04 — UI action helper still grants admin workflow bypass
**Priority:** P0 security parity  
**Evidence:** `availableActions` sets `reviewer = isAdmin || party === currentParty(doc)` and permits admin submission independent of originating party. This mirrors the known RPC bypass documented in report 20.

**Impact:** UI advertises actions to administrators outside the authorized workflow party. Although server-side authorization is decisive, UI/server parity is also required to prevent misleading controls and accidental privileged actions.

**Required work:** Correct authoritative server RPC first; then update the UI helper to use the same approved party/action matrix. Do not treat this helper as a security boundary.

**Acceptance:** Wrong-party admin sees no action and direct RPC call is denied; correct-party authorized actor sees and can perform the permitted action; PM sees no mutation/workflow actions.

### FE-05 — Generic close action is role/lifecycle based, not document-policy based
**Priority:** P1  
**Evidence:** `availableActions` adds `close` for admin/controller when status is approved, or when review is not required and status is submitted. No current-party or document-type-specific closure rule is applied.

**Impact:** Generic close can bypass party authority and conflict with I-specific close/archive behavior or future MQR/non-review lifecycle.

**Required work:** Wait for DEC-B03 (report 24). Model closure as an explicit authorized transition per document type and lifecycle; I closure must occur as part of the authorized I transition.

**Acceptance:** All close attempts pass document-type, lifecycle, actor and party authorization on server; unauthorized direct calls are denied.

### FE-06 — KPI implementation has no approved B/C denominator
**Priority:** P1  
**Evidence:** `src/lib/kpi.ts` aggregates `codeB`, `codeC`, and `bc = codeB + codeC`; it exposes counts but no eligible final-outcome denominator or rate. The source groups rows by raw `discipline_code`.

**Impact:** B/C rate cannot be computed consistently against the approved exclusion of I, and legacy CIV/STR values can appear as separate discipline groups instead of CIVSTR.

**Required work:** Wait for DEC-B04 (report 24); then implement explicit named numerator/denominator measures and canonical discipline grouping at the domain/report boundary while preserving raw source traceability.

**Acceptance:** Golden dataset verifies numerator, denominator, I/E exclusions, D treatment, date cohort and alias normalization. The same expected totals are returned by server and frontend aggregation.

### FE-07 — Response outcome type is too generic for approved E/I semantics
**Priority:** P1  
**Evidence:** `RESPONSE_OUTCOMES` contains only `proceed`, `return`, `close`. This does not encode E as an originator cancellation action or I as a controlled close/archive outcome.

**Impact:** A display label or generic outcome can be changed without enforcing the required actor or lifecycle semantics.

**Required work:** Represent E as a separate cancellation transition and I as an authorized information-only closure/archive transition in the authoritative domain/server model. Keep response-code identity separate from lifecycle transition and actor authorization.

**Acceptance:** Reviewer cannot execute E; authorized originating contractor can execute E only within approved timing; I closes and archives through the authorized review path; all transitions are auditable.

## 3. Routing and application-shell observations

- `src/routes/README.md` documents TanStack Start file-based routing and says `routeTree.gen.ts` is generated.
- `src/router.tsx` creates a QueryClient per router/request, which avoids sharing module-level query cache across SSR requests.
- No route tree or application UI changes were made during this review.
- The root placeholder must be replaced by the product implementation owner; avoid introducing Next.js/Remix routing conventions into this TanStack project.

## 4. Required implementation order

1. Resolve report 24 decisions DEC-B01 through DEC-B08 that affect lifecycle, authority, PM and KPI.
2. Confirm database schema and backend environment; do not invent frontend-only states or roles.
3. Implement authoritative server/RLS/Storage behavior and verify direct-call denial.
4. Align shared domain types and UI action helpers with the verified server contract.
5. Implement root application shell and document-control routes.
6. Implement KPI measures only after denominator approval.
7. Run tests, lint and build; preserve logs and commit SHA.

## 5. Change and verification status

- No source or SQL was changed.
- No tests, lint, build, browser run or deployment was executed.
- No database or Lovable workspace was accessed.
- Findings are based on the checked-in source files on `dev/review-fixes`.
- This is not a runtime security certification or release approval.
