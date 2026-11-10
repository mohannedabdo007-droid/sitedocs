# 26 — Application Shell, Localization, and Supabase Integration Readiness Review

**Branch:** `dev/review-fixes`  
**Reviewed files:** `src/routes/__root.tsx`, `src/routes/index.tsx`, `src/lib/i18n.tsx`, `src/lib/i18n-dict.ts`, `src/start.ts`, `src/integrations/supabase/client.ts`, `src/integrations/supabase/auth-attacher.ts`, `src/integrations/supabase/previewAuthStorage.ts`, `src/server.ts`, `src/lib/error-page.ts`  
**Baseline:** Reports 21–25  
**Review type:** Static source inspection only

## 1. Executive summary

The repository contains useful foundations — a bilingual dictionary, an i18n provider, a Supabase client, a server-function auth-attacher, CSRF middleware, and SSR error handling. However, the current route tree still contains only a root shell and a placeholder home route. The root shell does not mount the i18n provider, declares the document language as English, and retains Lovable placeholder metadata. The Arabic/English translation model also does not yet express the approved Project Manager role or the complete E/I lifecycle semantics.

This means the repository has infrastructure fragments, but not yet a complete, integrated application shell. The findings below are not proof of a live authentication or backend failure; runtime configuration and behavior were not tested.

## 2. Findings

### SHELL-01 — Root shell does not mount the localization provider
**Priority:** P1  
**Evidence:** `src/lib/i18n.tsx` exports `I18nProvider`, but `src/routes/__root.tsx` mounts only `QueryClientProvider` around `Outlet`. No visible root provider integration exists in the reviewed route shell.

**Impact:** Routes using `useI18n()` would fail unless another provider is introduced elsewhere; the locale preference, translation function and locale state are not guaranteed to be available application-wide.

**Required work:** Mount the i18n provider at the correct application boundary, while preserving SSR-safe behavior and avoiding hydration mismatch. Confirm whether locale should be selected per user/profile or browser-local preference before changing persistence.

**Acceptance:** Both Arabic and English render without missing-provider errors; language choice persists according to approved policy; no hydration mismatch; all routes inherit the provider.

### SHELL-02 — Root document language and fallback error pages are English-only
**Priority:** P1  
**Evidence:** `RootShell` emits `<html lang="en">`; `NotFoundComponent`, `ErrorComponent`, and `src/lib/error-page.ts` contain English-only text. The i18n provider changes document lang/dir only after it mounts in the browser.

**Impact:** Initial server-rendered document metadata and error/not-found experiences do not reliably respect Arabic/RTL locale. A runtime failure can bypass the React provider and show English-only output.

**Required work:** Define an SSR-aware locale source and set lang/dir before page rendering. Localize not-found and error experiences, including the standalone catastrophic SSR error page, without exposing stack traces or secrets to end users.

**Acceptance:** Arabic responses render `lang="ar"` and `dir="rtl"` on the initial HTML; English renders `lang="en"` and `dir="ltr"`; error and not-found states follow the same locale policy.

### SHELL-03 — Generic Lovable metadata remains in the root document
**Priority:** P2  
**Evidence:** Root metadata uses title `Lovable App`, description `Lovable Generated Project`, author `Lovable`, and Lovable social metadata. The source comment explicitly says these are placeholders.

**Impact:** Browser tabs, search previews and shared links do not identify Project Doc Control correctly.

**Required work:** Replace generic metadata with approved product name and accurate description. Set page-specific metadata on content routes; do not invent public marketing claims or expose private project/customer details.

**Acceptance:** No generic Lovable metadata remains in production-rendered HTML; page title and description are correct for each route and locale.

### I18N-01 — Translation dictionary does not encode the approved role and lifecycle vocabulary
**Priority:** P1  
**Evidence:** `src/lib/i18n-dict.ts` includes roles admin/controller/reviewer/viewer only; status labels draft/submitted/under_review/returned/approved/closed only; and generic outcomes proceed/return/close. The same role/status vocabulary appears in the Arabic dictionary.

**Impact:** PM, contractor cancellation (E), information-only archive (I), and other approved domain distinctions cannot be expressed as explicit localized concepts. Generic labels risk reintroducing superseded workflow behavior.

**Required work:** Once the authoritative server/database domain contract is approved, extend both dictionaries with the exact current terminology. Avoid frontend-only role/status strings that the server cannot represent. Mark obsolete generic labels as historical or remove them from active flows only after checking all call sites.

**Acceptance:** Arabic and English labels cover every active role, state, action and outcome; E and I labels reflect their actor and lifecycle semantics; no active UI presents superseded defaults.

### I18N-02 — Translation coverage and fallback behavior need completeness checks
**Priority:** P2  
**Evidence:** The English dictionary defines the `DictKey` union and Arabic is typed as `Record<DictKey, string>`, which is a useful compile-time completeness constraint. However, no dedicated translation parity/RTL test was found in the reviewed test directory, and several root-level fallback experiences bypass the dictionary.

**Impact:** New keys are structurally required in Arabic, but layout direction, mixed Arabic/English identifiers, tables, validation errors, date/number formatting, and server-rendered fallback pages can still regress without tests.

**Required work:** Add locale parity tests and RTL smoke tests for navigation, forms, tables, dialogs, document numbers, import errors and workflow history. Preserve Latin document identifiers and numbers where required by the project standard.

**Acceptance:** All dictionary keys are covered; no raw key leaks; representative screens pass Arabic RTL and English LTR visual/accessibility checks.

### AUTH-01 — Supabase auth middleware exists, but route-level auth integration is not evidenced
**Priority:** P1  
**Evidence:** `src/start.ts` registers `attachSupabaseAuth` as function middleware and CSRF middleware for server functions. `auth-attacher.ts` forwards the current session access token in the Authorization header. The reviewed route tree contains no sign-in, sign-up, reset-password, protected dashboard or project routes.

**Impact:** Infrastructure to attach tokens to server functions is present, but the checked-in route surface does not demonstrate a complete user authentication journey or route protection.

**Required work:** Design sign-in, sign-up, email confirmation, password reset, session expiry, sign-out, and protected-route redirect behavior. Verify every privileged server function independently authenticates and authorizes the caller; middleware token forwarding is not authorization.

**Acceptance:** Auth journey works end-to-end in isolated environment; unauthenticated users cannot access protected data/routes; expired/invalid sessions fail closed; direct server-function calls enforce server-side identity and permissions.

### AUTH-02 — Backend environment identity must be verified before runtime validation
**Priority:** P0 release gate  
**Evidence:** `src/integrations/supabase/client.ts` resolves backend URL and publishable key from Vite/process environment variables and throws if missing. `src/start.ts` comments refer to Lovable Cloud or a user-managed Supabase project. Static source alone does not identify the actual deployed backend project.

**Impact:** A test could accidentally target the wrong Supabase project or environment if configuration is assumed from repository metadata, a preview, or an unrelated project identifier.

**Required work:** Before any live verification, obtain the exact environment URL/project reference through the authorized project configuration, confirm it against the intended deployment, and use isolated credentials. Do not expose or copy secrets into repository documentation.

**Acceptance:** Environment identity is recorded using non-secret project reference and environment label; test credentials are scoped; production and staging are unmistakably distinguished; no database mutation occurs during identity verification.

### AUTH-03 — Preview session broker requires dedicated security regression tests
**Priority:** P1  
**Evidence:** `previewAuthStorage.ts` brokers auth session data through `postMessage`, validates editor origins, uses request IDs and timeouts, and falls back to localStorage.

**Impact:** This code handles session material across preview/editor contexts. Static inspection shows explicit origin checks, but does not prove browser-origin, frame, timeout, logout-tombstone, storage-blocking or multi-tab behavior is secure in all supported hosting configurations.

**Required work:** Add focused tests for trusted/untrusted origins, forged replies, mismatched request IDs, no ancestor origin, localStorage exceptions, timeout/retry, logout propagation, concurrent tabs, and preview hostname parsing. Keep the allowed-origin list narrow and never log tokens.

**Acceptance:** Only configured trusted editor origins receive session messages; malformed/untrusted messages are ignored; logout cannot resurrect stale sessions; blocked storage does not break safe fallback; no auth token appears in logs.

### OPS-01 — SSR error normalization needs concurrency and information-disclosure tests
**Priority:** P2  
**Evidence:** `src/server.ts` stores a module-level `serverEntryPromise`, normalizes certain 500 JSON responses, and consumes a module-level last-captured error from `error-capture.ts`. The error capture module stores one module-level last error with a short TTL.

**Impact:** Under concurrent SSR requests, a shared last-error slot may associate a captured error with the wrong response or lose diagnostic context. This is a testable concurrency concern, not a confirmed defect. Error details must remain server-side.

**Required work:** Exercise simultaneous failing requests and verify each response/log correlates to its own request. Prefer request-scoped error context if the runtime supports it. Ensure user-facing HTML remains generic and does not include stack/cause/token/SQL details.

**Acceptance:** Concurrent failure tests show correct request/error correlation; no sensitive details leak into client responses; server logs retain sufficient diagnostics with secrets redacted.

## 3. Positive foundations worth preserving

- `I18nProvider` defines Arabic and English locale support, RTL/LTR direction, localized field selection, and date/number formatting.
- Arabic dictionary is typed as `Record<DictKey, string>`, enforcing key coverage at compile time.
- Supabase client uses a publishable key and does not embed a service-role secret in the reviewed client module.
- Server functions have CSRF middleware configured in `src/start.ts`.
- Supabase auth token attachment is separated into a generated integration module.
- Root error boundaries and server-level error normalization provide a starting point for robust failure handling.
- The Supabase integration files are marked generated; changes should be made through the owning integration workflow, not hand-edited.

## 4. Required integration sequence

1. Complete report 24 policy decisions affecting PM, lifecycle, workflow and auth.
2. Confirm actual backend/environment identity without mutating data.
3. Define SSR-compatible locale/session context and mount application providers.
4. Build authentication routes and protected route guards.
5. Build the root application shell and product metadata.
6. Align localized role/status/action/outcome labels with the approved server contract.
7. Add preview broker, SSR error correlation, localization and auth regression tests.
8. Run test, lint, build and isolated end-to-end checks; retain exact logs and source commit.

## 5. Change and verification status

- No source, integration, SQL, migration or configuration file was changed.
- No auth flow, preview broker, SSR concurrency, localization test, build or deployment was run.
- No live Supabase environment was accessed.
- Findings are based on static source on `dev/review-fixes`.
- This report is not a runtime authentication/security certification.
