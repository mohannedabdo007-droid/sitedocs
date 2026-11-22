# 43 — Server Function CSRF and Supabase Bearer Attachment Integration Review

**Review type:** Static source review  
**Branch:** `dev/review-fixes`  
**Reviewed source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Status:** Findings documented; no source or runtime changes made.

## 1. Scope

Focused review of the server-function request protection and browser-to-server Supabase token attachment path:

- `src/start.ts`
- `src/integrations/supabase/auth-attacher.ts`
- `src/integrations/supabase/client.ts`

The auth-attacher is marked automatically generated. This report does not authorize manual edits to generated integration files.

## 2. Executive summary

The Start instance explicitly registers a CSRF middleware filtered to `handlerType === "serverFn"`, and registers the Supabase auth attacher as global function middleware. These are important positive integration controls.

The attacher obtains the current browser session with `supabase.auth.getSession()` and forwards its access token as a Bearer header when present. It does not branch on the returned auth error; if no session is available, it continues the server-function request without an Authorization header.

That behavior is not itself an authorization bypass: the server must independently authenticate and authorize every protected operation. However, the inspected integration files do not establish that every sensitive server function rejects absent, invalid, expired, or malformed credentials. That enforcement must be verified at each server entry point and in the deployed runtime.

## 3. Findings

### F43-01 — CSRF protection is explicitly scoped to the server-function handler type

**Severity:** Informational / verification required

**Evidence:** `src/start.ts` configures `createCsrfMiddleware({ filter: (ctx) => ctx.handlerType === "serverFn" })` and places it in request middleware.

**Assessment:**
- The scope is explicit and consistent with the accompanying comment that this middleware protects server functions from cross-site requests.
- The source does not demonstrate that every other state-changing HTTP surface is either absent or protected by its own CSRF/origin strategy.
- This review does not establish that any unprotected state-changing route currently exists.

**Required verification (not implemented):**
- Inventory all state-changing endpoints and confirm which handler type serves each.
- Confirm that every cookie-authenticated state-changing endpoint is covered by CSRF or a documented equivalent origin-bound protection.
- Add negative tests for cross-origin requests and positive tests for legitimate same-origin server-function calls.

### F43-02 — Auth attachment continues when the browser session is absent or cannot be obtained

**Severity:** Medium — authentication integration assurance

**Evidence:** `auth-attacher.ts` destructures only `data` from `supabase.auth.getSession()`, reads `data.session?.access_token`, and calls `next()` with an Authorization header only when a token exists. It does not explicitly inspect the returned error.

**Impact / uncertainty:**
- Auth storage or session retrieval failures can result in a request being sent without a bearer token.
- This is safe only when the receiving server function independently rejects unauthenticated requests before any protected read or mutation.
- The client middleware is token transport, not an authorization boundary. No conclusion about a server-side bypass can be drawn from this file alone.

**Required verification/remediation direction (not implemented):**
- For every protected server function, prove that missing, invalid, expired, and wrong-audience tokens are rejected server-side.
- Distinguish public server functions from authenticated functions explicitly.
- Consider surfacing session retrieval errors as controlled client errors for protected calls, without treating a client-provided session as proof of identity.
- Never rely on `sendContext`, client-supplied user IDs, or UI role state as authorization evidence.

### F43-03 — Middleware registration and generated-file ownership need a release-level integration test

**Severity:** Medium — integration regression risk

**Evidence:** `start.ts` registers `attachSupabaseAuth` in `functionMiddleware`; the generated attacher comment states that without global registration the browser does not attach the bearer token to server-function RPCs. The generated client uses the publishable key and a separate server-only client path is referenced elsewhere in the project.

**Impact / uncertainty:**
- Removing or replacing the middleware array could silently break authenticated server-function calls.
- A successful browser login alone does not prove that the Authorization header reaches the server runtime or that the server verifies it.
- The actual deployed environment variables and middleware execution were not inspected.

**Required verification (not implemented):**
- Add an integration test that logs in, invokes a protected server function, and verifies authenticated identity on the server.
- Repeat with no session, expired token, malformed token, and session retrieval failure; all protected calls must fail closed.
- Verify middleware order and header propagation after any Lovable-generated integration refresh.
- Keep generated auth integration changes within the owning Lovable generation process.

## 4. Positive controls observed

- CSRF middleware is explicitly registered rather than assumed to be auto-installed after defining `src/start.ts`.
- CSRF middleware is filtered to server-function handlers, with its intended scope documented in source comments.
- Supabase auth attachment is globally registered as function middleware.
- The browser client uses a publishable key; the attacher forwards the access token separately as a Bearer credential.
- The middleware uses the current Supabase session token rather than accepting a user ID from arbitrary call context.

## 5. Required verification before closure

1. Enumerate all server functions and classify each as public or authenticated.
2. Verify server-side token validation and role/party authorization for every protected function.
3. Exercise CSRF rejection for cross-origin server-function requests.
4. Test absent, expired, malformed, and retrieval-error session states.
5. Confirm generated integration refreshes preserve middleware registration.
6. Run integration tests and build/type checks after an approved implementation change.

## 6. Boundaries and non-actions

- Static source inspection only.
- No application source or generated integration files changed.
- No SQL, migration, schema, generated type, Supabase, or storage changes.
- No live authentication session, deployed server function, or database was accessed.
- No tests, lint, typecheck, or build were executed.
- No deployment or pull-request merge was performed.
- This report does not authorize an implementation change.

## 7. Conclusion

The CSRF middleware and global bearer-token attacher are present and explicitly registered. The key remaining assurance requirement is server-side fail-closed enforcement for every protected function, independent of whether the browser could retrieve and attach a session token. This must be demonstrated with integration tests before release.
