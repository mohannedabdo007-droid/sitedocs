# 19 — Application Shell, Routing & Runtime Readiness Review

**Review type:** Static application architecture review  
**Branch:** `dev/review-fixes`  
**Files reviewed:** `src/routes/index.tsx`, `src/routes/__root.tsx`, `src/router.tsx`, `src/routeTree.gen.ts`, `src/server.ts`, `src/start.ts`, `src/routes/README.md`, Supabase client and auth-attacher references  
**Database access:** None. No running application, browser session, API, or live Supabase project was accessed.  
**Changes:** Documentation only.

## Executive summary

The reviewed source is currently an application scaffold rather than a complete Document Control user interface. The root route renders a Lovable blank-page placeholder, and the route directory contains only the root shell, the index route, and routing instructions. There are no feature routes for authentication, company/project selection, document registers, reviews, imports, dashboards, administration, or project-manager read-only access in the reviewed branch tree.

The runtime setup contains TanStack Start, React Query, Supabase client initialization, CSRF middleware for server functions, and an auth-attacher middleware reference. These are useful foundations, but they do not demonstrate that application screens, route-level authorization, or end-to-end workflows exist.

## Confirmed source observations

### 1. Home route is still the generated placeholder

`src/routes/index.tsx` renders:

- the Lovable blank-app SVG;
- alt text "Your app will live here!";
- a `data-lovable-blank-page-placeholder="REMOVE_THIS"` marker;
- a comment explicitly instructing replacement of the placeholder.

This is a confirmed blocker for a usable Document Control front end.

### 2. No feature routes are present in the reviewed route directory

The route listing contains:

- `__root.tsx`
- `index.tsx`
- `README.md`

No route files were found for login/session handling, company or project workspace, document register, document details/revisions, review inbox, response submission, imports, KPI dashboards, project members, or administration.

This finding is limited to the reviewed `dev/review-fixes` source tree. It does not rule out functionality hosted elsewhere or a separate uncommitted branch.

### 3. Root shell still has generic Lovable metadata and English document language

`src/routes/__root.tsx` sets:

- document language to `en`;
- title to `Lovable App`;
- description to `Lovable Generated Project`;
- author and social metadata to Lovable placeholders.

There is no visible route-specific product identity or Arabic/English language direction handling in the root shell. This should be completed as part of the bilingual product shell, not treated as a database security issue.

### 4. Router uses a per-request QueryClient

`src/router.tsx` creates a new QueryClient inside `getRouter()`. The source comment correctly notes that a module-level QueryClient can leak cached data between SSR requests. This is a positive design choice to preserve.

### 5. Server function CSRF middleware is explicitly installed

`src/start.ts` installs `createCsrfMiddleware` filtered to server functions and includes `attachSupabaseAuth` in function middleware. This is a positive baseline. However, source presence alone does not prove correct runtime token propagation, CSRF enforcement, or authorization of every server function; those require runtime tests.

### 6. Supabase client uses a publishable key and brokered preview storage

`src/integrations/supabase/client.ts` reads the Supabase URL and publishable key from environment variables and uses `brokeredPreviewStorage()`. The inspected code does not hardcode a service-role key. Server URL rewriting is conditional on matching runtime and public publishable-key configuration.

This is a source observation only; environment values and deployed runtime behavior were not inspected.

### 7. Error capture has a process-global last-error slot

`src/lib/error-capture.ts` stores the most recently captured error in a module-level variable with a five-second TTL, then `src/server.ts` consumes it when normalizing a swallowed SSR error response.

Because server workers can process concurrent requests, a module-global slot could associate one request's captured error with another request's generic SSR failure under a narrow timing overlap. This primarily affects diagnostic attribution, not by itself a demonstrated data disclosure. Consider request-scoped correlation (request ID/context) and a concurrency test before changing this mechanism.

## Readiness assessment

| Area | Static source status | Required next evidence |
|---|---|---|
| Application home | Placeholder | Implemented product landing/workspace |
| Authentication UI | Not present in route tree | Login, logout, session-expiry tests |
| Project workspace | Not present in route tree | Company/project selection and membership tests |
| Document workflows UI | Not present in route tree | Register, details, review inbox, response UI |
| Import UI | Domain mapping logic exists; route absent | End-to-end import workflow |
| KPI UI | Summary logic exists; route absent | Dashboard and KPI parity tests |
| CSRF foundation | Middleware configured | Runtime cross-site request tests |
| Supabase auth attachment | Middleware referenced | Verify JWT propagation and user context |
| SSR error diagnostics | Global last-error slot | Concurrent request correlation test |
| Bilingual shell | Generic English metadata | Arabic/English language and RTL tests |

## Recommended implementation sequence — NOT APPLIED

1. Establish the application shell and bilingual navigation, including correct Arabic RTL and English LTR behavior.
2. Implement authentication/session lifecycle and protected route boundaries.
3. Implement company/project selection using server-verified membership.
4. Build document register and detail/revision screens, then review inbox and workflow actions.
5. Build import screens around the existing mapping logic, while preserving server-side commit validation requirements from Report 18.
6. Add KPI dashboards only after SQL/TypeScript parity and approved discipline/code semantics are implemented.
7. Add distinct Project Manager read-all-drafts/read-only experience without reusing admin privileges.
8. Add route-level integration tests and server-side authorization tests. Client route guards are usability controls only; database/RPC authorization remains authoritative.
9. Replace generic page metadata and implement accessibility, responsive layouts, and localization.
10. Make SSR error capture request-scoped or correlation-ID-based and test concurrent failures.

## Approval and status boundary

- Static architecture findings: recorded.
- Running application/browser verification: **not performed**.
- Live authentication, CSRF, and Supabase verification: **not performed**.
- No source, route, configuration, environment, database, or deployment changes applied.
- No test suite, build, or deployment run.
- Implementation should be planned with Lovable when workspace credits are available; do not spend credits or attempt production changes without the user's approval.
