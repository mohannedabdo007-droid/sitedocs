# 42 — Server Error Response Security Headers and Cache-Control Review

**Review type:** Static source review  
**Branch:** `dev/review-fixes`  
**Reviewed source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Status:** Findings documented; no source or runtime changes made.

## 1. Scope

This review inspects application-generated HTML error responses and their response headers in:

- `src/server.ts`
- `src/start.ts`
- `src/lib/error-page.ts`

It is deliberately limited to response construction in application code. It does not claim that the deployed hosting edge or upstream proxy fails to add headers.

## 2. Executive summary

The custom SSR error wrapper and the request middleware each construct HTML 500 responses with only a `content-type` header. The static error-page renderer also emits a standalone HTML document with an inline event-handler attribute (`onclick`) and inline style content.

The inspected application code does not attach explicit cache directives or a documented baseline of browser security headers to these custom error responses. An edge platform may add headers later, but that behavior and its coverage of every error path have not been verified.

The inline event handler and style block also mean that a strict Content-Security-Policy cannot be enabled safely without either nonces/hashes or refactoring the error page to avoid inline execution/style.

## 3. Findings

### F42-01 — Custom 500 responses do not set explicit no-store cache directives

**Severity:** Medium — error response caching / confidentiality assurance

**Evidence:** Both `normalizeCatastrophicSsrResponse()` and the catch block in `src/server.ts` create status-500 HTML responses with a content-type header only. The error middleware in `src/start.ts` does the same for caught non-status errors.

**Impact / uncertainty:**
- The application code does not explicitly instruct browsers or shared intermediaries not to store these error responses.
- The page currently contains generic text and no user-specific content, so this is not evidence of an observed private-data leak.
- Actual caching behavior may be changed by the hosting edge or CDN; deployed response headers were not inspected.

**Required verification/remediation direction (not implemented):**
- Define a consistent cache policy for all application-generated error responses, normally including `Cache-Control: no-store` where appropriate.
- Verify the policy across SSR-normalized errors, middleware-caught errors, route errors, and hosting-generated failures.
- Confirm that authenticated document pages and error responses cannot be cached by shared intermediaries contrary to policy.

### F42-02 — Error response security-header policy is not explicit in application response construction

**Severity:** Medium — browser hardening / policy consistency

**Evidence:** The custom HTML response constructors set only `content-type`. No application-level setting for `X-Content-Type-Options`, `Referrer-Policy`, `X-Frame-Options` or a CSP is visible in the inspected response construction paths.

**Impact / uncertainty:**
- The application code alone does not establish a consistent security-header baseline for these responses.
- Hosting-level injection may provide some or all headers; this review did not inspect deployed HTTP responses or edge configuration.
- This is a configuration-coverage gap, not proof that the live site is missing these headers.

**Required verification/remediation direction (not implemented):**
- Establish the authoritative layer for security headers (application, hosting edge, or both) and document ownership.
- Verify headers on normal HTML, redirects, 4xx/5xx responses, static assets, and server-function responses.
- Avoid conflicting duplicate policies between application and edge layers.

### F42-03 — Standalone error page uses inline CSS and an inline event handler, constraining strict CSP

**Severity:** Low/Medium — CSP compatibility and defense-in-depth

**Evidence:** `src/lib/error-page.ts` includes a `<style>` block and a button with `onclick="location.reload()"`.

**Impact:**
- A strict CSP that disallows inline styles and inline script/event handlers would block parts of this error page.
- Teams may be tempted to weaken `style-src` or `script-src` with `unsafe-inline` solely to preserve this fallback page.

**Required verification/remediation direction (not implemented):**
- Prefer an external stylesheet or minimal browser-default styling and a regular link for retry, removing the inline event handler.
- If inline content is retained, use a nonce/hash strategy compatible with the hosting runtime; do not broadly enable `unsafe-inline` as a shortcut.
- Add a browser test that loads the error page under the intended production CSP.

## 4. Positive controls observed

- Error-page text is generic and does not render the thrown exception message or stack into the HTML body.
- The response explicitly declares UTF-8 HTML content.
- The server wrapper checks for the expected h3 swallowed-error marker before replacing a response.
- The error page offers a normal home link in addition to its retry action.

## 5. Required verification before closure

1. Capture deployed response headers for successful HTML, redirects, 401/403, 404, 500, and server-function responses.
2. Confirm cache directives on authenticated and error responses at both origin and CDN/edge.
3. Confirm the effective CSP and whether the standalone error page renders without unsafe inline allowances.
4. Add automated response-header assertions to the release acceptance suite.
5. Repeat checks after any approved hosting or application configuration change.

## 6. Boundaries and non-actions

- Static source inspection only.
- No application source, hosting configuration, or generated files changed.
- No SQL, migration, schema, generated type, Supabase, or storage changes.
- No live HTTP request or deployed header inspection was performed.
- No tests, lint, typecheck, or build were executed.
- No deployment or pull-request merge was performed.
- This report does not authorize a remediation implementation.

## 7. Conclusion

The application-owned error response paths should share an explicit cache and security-header policy. The standalone fallback page should also be made compatible with the intended CSP without weakening script policy. These points remain open until verified against actual deployed responses and an approved implementation.
