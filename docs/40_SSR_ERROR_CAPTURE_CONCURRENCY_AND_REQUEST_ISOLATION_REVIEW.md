# 40 — SSR Error Capture Concurrency and Request Isolation Review

**Review type:** Static source review  
**Branch:** `dev/review-fixes`  
**Reviewed source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Status:** Findings documented; no source or runtime changes made.

## 1. Scope

This review examines the server-side error capture and SSR response-normalization path in:

- `src/lib/error-capture.ts`
- `src/server.ts`
- `src/start.ts`
- `src/routes/__root.tsx`
- `src/lib/lovable-error-reporting.ts`

This is a focused follow-up to the prior runtime/error-handling reviews. It addresses request isolation and concurrent SSR behavior, rather than repeating the broader deployment, middleware, or generic error-logging inventories.

## 2. Executive summary

The current SSR error recovery mechanism stores a single process/module-scoped `lastCapturedError` value and later consumes it while normalizing a generic h3 500 response. The captured value is not associated with a request identifier or request-local context.

Under concurrent requests, one request can overwrite the captured error belonging to another request before either response consumes it. This creates a plausible cross-request diagnostic mix-up: a response may be logged with another request's error, while the original error is lost or attributed to the wrong request.

This is a source-level concurrency risk, not a demonstrated production incident. No concurrent runtime test was executed.

## 3. Findings

### F40-01 — Process-scoped last-error slot is not request-isolated

**Severity:** High — diagnostic integrity / request isolation  
**Evidence:** `src/lib/error-capture.ts` defines one module-level `lastCapturedError`; `record()` overwrites it; `consumeLastCapturedError()` reads and clears it. `src/server.ts` consumes this shared slot while normalizing a swallowed SSR error response.

**Failure scenario:**

1. Request A encounters an error and records error A.
2. Before request A consumes the slot, request B encounters an error and records error B.
3. Request A normalizes its response and consumes error B.
4. Request B may then find the slot empty, expired, or overwritten by a later request.

The five-second TTL limits how long an entry remains eligible, but it does not provide request ownership or prevent interleaving.

**Impact:**
- Incorrect error-to-request attribution in server logs.
- Loss of the original diagnostic cause for one or more requests.
- Misleading incident investigation and potentially incorrect operational conclusions.
- If error objects contain request-specific details, those details may be logged while processing a different request.

**Required remediation direction (not implemented):**
- Replace the single shared slot with request-scoped error context or an explicit correlation mechanism.
- Ensure the error captured for a response can only be consumed by that same request.
- If the framework/runtime cannot safely propagate request-local context, avoid recovering a global "last error"; preserve a safe generic server error instead.
- Add deterministic overlapping-request tests that prove A can never consume B's captured error.

### F40-02 — Global console.error interception couples unrelated error producers

**Severity:** Medium — observability integrity  
**Evidence:** `src/lib/error-capture.ts` replaces `console.error` globally and records every Error-like argument in the same shared slot. This means the slot is not limited to the specific h3 SSR failure that `src/server.ts` later attempts to recover.

**Impact:**
- An unrelated error logged by another layer can replace the error intended for SSR response normalization.
- A handled or background error may be consumed as if it were the cause of a separate 500 response.
- The capture path depends on global logging side effects rather than an explicit error handoff.

**Required remediation direction (not implemented):**
- Narrow capture to the exact framework error boundary or request execution context.
- Avoid using a global console monkey-patch as the correlation channel for response-specific error recovery.
- Preserve the original console behavior and verify error handling for both handled and unhandled exceptions.

### F40-03 — Browser and server telemetry paths need an explicit data-minimization boundary

**Severity:** Medium — diagnostic data exposure review  
**Evidence:** The server capture helper expands Error stacks and cause chains before logging. The browser helper forwards exception objects to optional telemetry and forwards a message/stack/path payload to an editor runtime hook.

**Impact / uncertainty:**
- Stack traces and nested causes can contain file paths, query values, identifiers, or implementation details depending on the thrown error.
- The inspected code does not itself demonstrate that all downstream telemetry destinations redact sensitive values or enforce retention/access controls.
- This is not proof that secrets or personal data are currently being transmitted; the downstream collectors and redaction configuration were outside this static review.

**Required remediation direction (not implemented):**
- Define an allowlisted diagnostic payload and redact sensitive fields before export.
- Confirm telemetry destination, access, retention, and redaction settings in the actual deployed environment.
- Keep detailed stack/cause data in a restricted server log channel where justified; do not expose it to end users.

## 4. Positive controls observed

- SSR responses with status below 500 are returned without the catastrophic-error normalization path.
- The server checks the h3 JSON marker before replacing a response with the generic HTML error page.
- The recovery slot has a short TTL and is cleared on consumption or expiry; these reduce stale retention but do not solve concurrency.
- The browser error reporter avoids running when `window` is unavailable.
- The browser reporter uses optional hooks, so the application does not require editor telemetry to exist.

## 5. Required verification before closure

1. Add a deterministic test with two overlapping SSR requests that throw distinct sentinel errors; assert each request is associated only with its own sentinel.
2. Add a test where an unrelated handled error is logged while another request is awaiting normalization.
3. Verify no error details are included in client responses.
4. Review deployed telemetry configuration for redaction, access, and retention.
5. Re-run the test suite and relevant build/type checks after an approved implementation change.

## 6. Boundaries and non-actions

- Static source inspection only.
- No application source files changed.
- No SQL, migration, schema, generated type, Supabase, or storage changes.
- No database connection or live catalog inspection.
- No tests, lint, typecheck, or build were executed.
- No deployment or pull-request merge was performed.
- This report does not authorize a remediation implementation; implementation must follow the approved change-control and backup/restore gates.

## 7. Conclusion

The principal issue is the process-scoped, single-entry error capture slot: it is not safe as a request-correlation mechanism under concurrent SSR traffic. The next implementation should make error ownership request-local or remove cross-request recovery entirely, then prove isolation with deterministic concurrency tests before release.
