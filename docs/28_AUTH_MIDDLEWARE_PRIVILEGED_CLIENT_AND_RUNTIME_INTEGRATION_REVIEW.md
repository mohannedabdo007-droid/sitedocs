# 28 — Authentication Middleware, Privileged Client, and Runtime Integration Review

**Branch:** `dev/review-fixes`  
**Review type:** Static source review only  
**Scope:** `src/start.ts`, Supabase auth attacher/middleware/clients, cron auth helper, server entry, root route, i18n provider, error handling, and tracked source tree.  
**Baseline:** Current `dev/review-fixes` tree at review time.

## Executive summary

The repository contains several security-relevant Supabase and runtime helpers, but the tracked application surface is still a minimal shell. The presence of an authentication helper is not proof that protected server functions or routes exist or are protected. Equally, the presence of a service-role client is not proof that it is currently invoked; its use must be constrained and audited before application features are added.

No source, generated file, SQL, database, secret, deployment, or project setting was changed during this review. No runtime tests were executed.

## Findings

### F-28-01 — Authentication middleware exists but is not registered in the Start instance (High; integration gap)

`src/integrations/supabase/auth-middleware.ts` exports `requireSupabaseAuth`. It validates a Bearer token using Supabase `auth.getClaims(token)`, rejects missing/malformed tokens and missing subject, and provides a user-scoped Supabase client plus claims in middleware context.

However, `src/start.ts` imports and registers `attachSupabaseAuth` as function middleware, but does not import or globally register `requireSupabaseAuth`. This may be intentional: the latter is a guard to be attached to protected server functions, not necessarily a global middleware. The source tree currently contains no application server-function modules or API route handlers that demonstrate per-function attachment. Therefore there is no source evidence yet that any future privileged operation is protected by it.

**Required control:** Every server function/API route must explicitly apply the verified user-auth middleware (or an equivalently reviewed guard) before accessing project/document data. Verify actual request context and denial behavior in runtime tests. Do not treat client-side route guards as authorization.

### F-28-02 — Service-role client bypasses RLS and is exported as a reusable server module (High; sensitive capability)

`src/integrations/supabase/client.server.ts` reads `SUPABASE_SERVICE_ROLE_KEY` and creates a Supabase client using that key. Its own comments correctly state that this bypasses RLS and must only be used for trusted server-side operations. It is exported through a lazy proxy.

The tracked source tree reviewed here contains no server-function or route call site importing `supabaseAdmin`; this is a bounded static observation, not proof that no external/runtime consumer exists. The client must remain server-only and must never be imported by browser-reachable modules, route components, or client bundles.

**Required control:** Default to the authenticated user-scoped client and RLS. Any service-role use must be narrowly justified, server-only, independently authorize the user and target resource, validate all input, and write auditable events. Add a build/bundle guard and a code-search review for service-role imports before release. Never expose the key or service-role client to the browser.

### F-28-03 — Client auth token attachment is registered, but end-to-end protection is not demonstrated (Medium)

`src/integrations/supabase/auth-attacher.ts` obtains the current Supabase session and attaches its access token as a Bearer header to server-function requests. `src/start.ts` registers this as `functionMiddleware`.

This is transport plumbing, not authorization. The server must validate the token and separately authorize company, project, party, document, lifecycle, and action. The repository currently has no application server-function call site proving the complete chain.

**Required control:** Test absent session, expired/revoked token, valid user without project membership, wrong party, wrong company, and authorized user. Ensure no trust is placed in client-supplied IDs, role labels, party values, or context.

### F-28-04 — Cron authentication helper has no tracked invocation site (Medium; readiness gap)

`src/integrations/supabase/cron-auth.ts` compares a Bearer token against current and optional previous cron secrets using SHA-256 digests and `timingSafeEqual`. The current secret is mandatory. This is a reasonable primitive, but the tracked source tree reviewed here contains no scheduled endpoint or route invoking it.

**Required control:** Any future cron endpoint must call the helper before doing work, reject all other methods/inputs as appropriate, be idempotent, and avoid exposing secrets in logs or responses. Test missing secret, wrong token, current token, previous token, malformed header, and replay/idempotency behavior. Remove the previous secret after a controlled rotation window.

### F-28-05 — Root document defaults to English before client locale initialization (Low; localization consistency)

`src/routes/__root.tsx` emits `<html lang="en">`. `src/lib/i18n.tsx` defaults the React locale state to Arabic and updates document `lang` and `dir` in a client effect, with localStorage override. This creates a possible initial SSR/hydration interval where the document language/direction is English/LTR while the app's default locale is Arabic/RTL. The locale provider is not visibly mounted in the current root component, so its actual application wiring remains unproven.

**Required control:** When building the app shell, mount the provider intentionally and establish a consistent SSR-safe initial locale/direction strategy. Test Arabic default, saved English preference, hydration, reload, and navigation. Do not assume the provider currently affects the rendered application.

### F-28-06 — Error handling may log detailed server error chains (Medium; operational data exposure review)

`src/lib/error-capture.ts` expands Error stacks and cause chains before forwarding them to `console.error`; `src/server.ts` also logs caught errors. This aids diagnosis, but stack traces and nested error messages can contain SQL fragments, identifiers, request data, or other sensitive context depending on upstream errors.

No evidence in these files proves that logs are public; the finding is a logging hygiene requirement rather than a confirmed disclosure.

**Required control:** Define log redaction and access/retention policy before production. Never log access tokens, service-role keys, secrets, full document contents, or uploaded file data. Return generic client errors with correlation IDs while preserving appropriately redacted server diagnostics.

## Verified implementation facts

- `start.ts` registers `attachSupabaseAuth` as function middleware and CSRF plus error middleware as request middleware.
- `auth-middleware.ts` validates the Bearer token via Supabase `getClaims` and returns user ID/claims and a user-scoped Supabase client in context.
- `client.server.ts` uses `SUPABASE_SERVICE_ROLE_KEY`; its comments explicitly identify RLS bypass.
- `cron-auth.ts` supports current and previous cron secrets with constant-time digest comparison.
- `__root.tsx` sets initial HTML language to English; the i18n provider defaults state to Arabic and updates document attributes in an effect.
- The tracked source tree has no application API/server-function/cron endpoint modules beyond the listed helpers and the minimal root/index routes.

## Acceptance tests required before implementation sign-off

1. Unauthenticated server-function call is rejected before any database operation.
2. Invalid, expired, revoked, malformed, and wrong-project tokens are rejected.
3. Valid user with no company/project membership cannot read or mutate protected data.
4. Valid project member cannot cross company, party, document, or lifecycle boundaries.
5. PM remains read-only, including drafts; role claims from the browser cannot grant PM/admin powers.
6. Service-role client is absent from client bundles and is never exposed through responses or logs.
7. Every service-role call site independently checks the authenticated actor and resource/action authorization.
8. Cron endpoints reject missing/wrong secrets and are idempotent under duplicate delivery.
9. Logs redact tokens, secrets, document content, and sensitive request payloads.
10. Arabic/English initial render and hydration preserve correct `lang`, `dir`, and user preference.

## Boundaries and next steps

- Static review only; no live Supabase catalog, secrets, deployed routes, logs, browser, build, lint, or test suite were inspected/executed.
- No migration or database change is proposed by this report.
- Do not modify Lovable-generated auth/client files manually. Any required generated integration change must be made through the owning Lovable workflow when credits/access are available, then reviewed.
- Keep service-role usage disabled by default until concrete server operations and their authorization contracts are implemented and tested.
- Continue with source inventory and then produce a feature-by-feature server-function authorization map before any implementation.

**Conclusion:** The repository has useful auth primitives, but the end-to-end security chain is not yet demonstrated. This report is not a penetration test, runtime security certification, or evidence of a deployed vulnerability.
