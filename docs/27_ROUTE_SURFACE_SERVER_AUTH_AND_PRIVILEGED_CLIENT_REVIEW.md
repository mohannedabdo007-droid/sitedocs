# 27 — Route Surface, Server Authentication Boundary, and Privileged Client Review

**Branch:** `dev/review-fixes`  
**Review scope:** route tree, route/component directory inventory, Supabase server middleware and clients  
**Review type:** Static source inspection only; no runtime calls

## 1. Executive summary

The checked-in route tree contains exactly two route files: `__root.tsx` and `index.tsx`. The generated route tree registers only `/`. The only application route renders a Lovable blank-page SVG placeholder. The component directory contains only the `ui` directory (no product-specific page/component modules were found at the inspected level), while the hooks directory contains only `use-mobile.tsx`.

The Supabase integration includes a server middleware that validates a bearer token with Supabase `getClaims`, and a separate service-role client that bypasses RLS. These are important foundations, but the route tree currently provides no visible application routes or server-function call sites through which their correct use can be established. The service-role client therefore remains a high-sensitivity boundary requiring a strict usage inventory before implementation.

## 2. Findings

### ROUTE-01 — Only the root route is registered
**Priority:** P1 / product readiness blocker  
**Evidence:** `src/routes` contains `README.md`, `__root.tsx`, and `index.tsx`. `src/routeTree.gen.ts` imports only `__root` and `index` and declares only the `/` route.

**Impact:** There are no registered routes for authentication, dashboard, projects, companies, central register, document detail, settings, import, audit, or reporting in this branch snapshot.

**Required work:** Design the route map and access boundaries before implementing pages. Generate `routeTree.gen.ts` through TanStack Router tooling; never hand-edit the generated file.

**Acceptance:** Each approved product area has a route, explicit auth requirement, project/company scope, role/party visibility rule, localized metadata and route-level tests.

### ROUTE-02 — Root route is still a blank placeholder
**Priority:** P0 / release blocker  
**Evidence:** `src/routes/index.tsx` renders `https://cdn.gpteng.co/blank-app-v1.svg` with `data-lovable-blank-page-placeholder="REMOVE_THIS"`.

**Impact:** The checked-in application does not yet present the Project Doc Control experience at its root route.

**Required work:** Replace the placeholder with the approved public landing or authenticated entry experience, with clear session-aware navigation. This is application implementation work, not merely a metadata change.

**Acceptance:** Root route renders the approved product experience in Arabic and English, with correct signed-in/signed-out behavior and no Lovable blank placeholder.

### ROUTE-03 — Product-specific component inventory is absent at the inspected source level
**Priority:** P1  
**Evidence:** The `src/components` directory lists only `ui`; `src/hooks` lists only `use-mobile.tsx`; `src/lib` contains shared domain, KPI, numbering, i18n and import utility modules, but no feature/page modules.

**Impact:** There is no checked-in component architecture yet for document lifecycle, review actions, role-aware navigation, project administration, import preview/commit, or audit history.

**Required work:** Establish feature boundaries (for example auth, projects, documents, workflow, imports, reporting, administration) and keep UI affordances derived from the approved server-side policy. Do not build the entire application as one oversized route component.

**Acceptance:** Feature modules have clear data-access and authorization boundaries, reusable accessible components, and tests for both allowed and denied actions.

### SERVER-AUTH-01 — Bearer token validation exists, but token parsing is not a substitute for authorization
**Priority:** P1  
**Evidence:** `requireSupabaseAuth` checks for a Bearer header, verifies a JWT-shaped token, calls `supabase.auth.getClaims(token)`, requires a subject, and adds `supabase`, `userId`, and `claims` to function context.

**Impact:** This is a useful identity-verification layer. It does not by itself establish project membership, party authority, document-level access, reviewer assignment, PM read-only behavior, X1/P2 scope, or workflow transition eligibility.

**Required work:** Every server function must combine verified identity with explicit server-side authorization using the document/project/company context and the approved policy. Treat all client-provided IDs, role labels, party labels, mapped statuses and transition intents as untrusted input.

**Acceptance:** Direct invocation tests cover unauthenticated, invalid-token, valid-but-unrelated-user, wrong-party, wrong-project, PM read-only, X1 scope, originator self-review, admin bypass and valid authorized paths.

### SERVER-AUTH-02 — Service-role client bypasses RLS and requires a narrow server-only call graph
**Priority:** P0 security gate  
**Evidence:** `src/integrations/supabase/client.server.ts` creates a Supabase client with `SUPABASE_SERVICE_ROLE_KEY`; its own comments explicitly state that this client bypasses RLS and must be used only for trusted server-side operations. It exports a lazy `supabaseAdmin` proxy.

**Impact:** Any server function or route using this client can bypass database RLS. Correctness depends entirely on explicit authorization in the trusted server code. A misplaced import or insufficiently guarded operation could undermine the RLS controls documented elsewhere.

**Required work:** Inventory every import and call site of `supabaseAdmin`; keep it out of browser-shipped modules and user-facing request paths unless a narrowly justified privileged operation rechecks identity and authorization first. Prefer user-scoped clients with RLS for ordinary user operations. Add tests that prove privileged operations reject unauthorized callers.

**Acceptance:** Complete call-site inventory; no service-role key in client bundles or logs; every privileged operation has explicit actor, tenant, project, party and resource checks; negative authorization tests pass.

### SERVER-AUTH-03 — Middleware wiring is not evidence that every sensitive server function uses it
**Priority:** P0 security gate  
**Evidence:** `src/start.ts` registers global function middleware including `attachSupabaseAuth` and CSRF middleware. The reviewed route tree has no product server-function modules or route handlers demonstrating protected data operations. The repository search performed for common server-function/auth identifiers did not establish a complete branch-scoped call graph.

**Impact:** Global token attachment forwards a token; it does not prove that every sensitive function invokes `requireSupabaseAuth`, nor that the verified context is required by all operations.

**Required work:** Produce an exhaustive inventory of server functions, server routes, cron endpoints and RPC call sites using the full repository tree and generated bundle boundaries. Classify each as public, authenticated, privileged-admin, or cron-only. Fail closed when required middleware/context is absent.

**Acceptance:** Every server entry point has a documented auth class and test; public endpoints are intentionally public; privileged and cron endpoints reject missing/invalid credentials; no user operation silently falls back to service role.

### SERVER-AUTH-04 — Cron secret authentication must be isolated from user-session authentication
**Priority:** P1  
**Evidence:** `authenticateCronRequest` compares a bearer token to `LOVABLE_CRON_SECRET` and optional previous secret using SHA-256 digests and `timingSafeEqual`. It returns 500 when the current secret is missing and 401 for invalid credentials.

**Impact:** The helper has a dedicated shared-secret boundary. Static inspection does not show which endpoint calls it, whether the endpoint is externally reachable, or whether the secret is rotated and scoped safely.

**Required work:** Inventory cron handlers and verify every scheduled endpoint invokes this helper before any privileged action. Confirm secrets are not exposed to client bundles, logs, query strings or repository files. Define rotation and previous-secret retirement.

**Acceptance:** Cron endpoint tests cover missing secret, missing/malformed bearer token, wrong token, current token, previous token during rotation, and successful authorized execution; user JWTs cannot substitute for cron credentials.

## 3. Important distinctions

- `attachSupabaseAuth` attaches the browser's current access token to server-function requests; it is not an authorization decision.
- `requireSupabaseAuth` verifies token claims and constructs an authenticated request context; project/document policy checks remain separate.
- `supabaseAdmin` uses a service-role key and bypasses RLS; it is not an ordinary user client.
- `authenticateCronRequest` is a separate shared-secret mechanism for scheduled jobs.
- The existence of these helpers does not prove that all application entry points call them correctly.

## 4. Required next sequence

1. Enumerate the complete repository tree and every server entry point, including nested functions and API routes.
2. Build a server-function authorization matrix (public/authenticated/privileged/cron).
3. Trace every `supabaseAdmin` import and every privileged operation.
4. Add isolated tests for missing middleware, invalid identity, cross-tenant access and privileged service-role paths.
5. Implement the route map and product shell only after the approved role, lifecycle and workflow contracts are reflected in the server policy.
6. Run typecheck, lint, build and targeted tests in an isolated environment; retain logs and exact commit SHA.

## 5. Verification status and limitations

- No source, SQL, migration, auth configuration or secret was changed.
- No server function, cron endpoint, auth flow, database, Storage bucket, or browser session was executed.
- Repository directory listings and selected source files were inspected on `dev/review-fixes`.
- GitHub code search results are not a substitute for a branch-pinned full-tree call graph; the call-site inventory remains open.
- This is a static readiness review, not a runtime security certification.
