# 44 — Runtime Error Telemetry Privacy, Redaction, and Failure Isolation Review

**Review type:** Static source review  
**Branch:** `dev/review-fixes`  
**Reviewed source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Status:** Findings documented; no source or runtime changes made.

## 1. Scope

This review examines application-level error capture and browser telemetry forwarding:

- `src/lib/error-capture.ts`
- `src/lib/lovable-error-reporting.ts`
- `src/routes/__root.tsx`
- `src/server.ts`

It does not inspect the vendor telemetry backend, retention settings, access controls, or actual production log contents.

## 2. Executive summary

The application captures error stacks and cause chains, wraps `console.error` on the server, and forwards root React boundary errors to optional Lovable telemetry hooks. These controls improve diagnostic visibility.

However, the reviewed code serializes error objects and cause chains without a visible redaction stage. Error messages, stacks, causes, and plain-object properties can contain request data, identifiers, tokens, or other sensitive values depending on the upstream exception. The code does not prove that such values are present in production logs, but it does not provide an application-level minimization boundary before forwarding them.

There is also no visible guard around optional telemetry hook invocation. If a vendor hook throws synchronously, reporting itself can interfere with the original error-boundary path. This needs an isolation test.

## 3. Findings

### F44-01 — Error stack and cause serialization has no explicit sensitive-data redaction

**Severity:** High — potential sensitive information in logs/telemetry

**Evidence:**
- `describeError()` preserves `Error.stack`, `Error.message`, status values, and up to five cause levels.
- Non-Error values are serialized by `safeStringify()`.
- The server wrapper sends the consumed captured error to `console.error`.
- The browser reporter forwards the error object to `captureException` and may forward a message and stack to the preview runtime hook.

**Impact / uncertainty:**
- Depending on the originating exception, these values can include URLs, query parameters, SQL details, request identifiers, user-supplied content, or credentials accidentally embedded by upstream libraries.
- No actual production secret exposure was established in this static review.
- Vendor-side scrubbing may exist, but was not inspected and must not be assumed.

**Required verification/remediation direction (not implemented):**
- Define a data-minimization policy for logs and telemetry before external forwarding.
- Redact authorization headers, cookies, access/refresh tokens, API keys, connection strings, sensitive query parameters, and user/document content.
- Prefer structured, allowlisted diagnostic fields over arbitrary object serialization.
- Keep full raw exception details only in a tightly controlled server-side channel when justified by operational need.
- Test redaction using synthetic secrets embedded in messages, stacks, causes, URLs, and nested objects.

### F44-02 — Browser telemetry forwarding passes the original error object and stack without application-level minimization

**Severity:** High — client telemetry privacy assurance

**Evidence:** `reportLovableError()` calls `captureException(error, context, options)` with the original error. It also forwards the stack when the error is an `Error`; non-Error values can be serialized by `describeThrown()` up to a fixed length.

**Impact / uncertainty:**
- A length cap limits volume, not sensitivity.
- Route path and caller-supplied context are included; current call site uses a static boundary label, but future call sites may supply more data.
- Actual telemetry SDK scrubbing and vendor retention/access controls are outside this repository review.

**Required verification/remediation direction (not implemented):**
- Inspect and document the telemetry provider's data handling, retention, access controls, and built-in scrubbing.
- Minimize context to stable error category, route template (not raw query), boundary name, and opaque correlation ID.
- Do not send request bodies, document text, user identifiers, session values, or raw URL query strings.
- Add tests proving synthetic secrets are absent from all telemetry payload fields.

### F44-03 — Optional telemetry hooks are not visibly isolated from the original error-reporting path

**Severity:** Medium — diagnostic failure isolation

**Evidence:** `reportLovableError()` invokes optional `captureException` and `__lovableReportRuntimeError` callbacks directly. Optional chaining protects against a missing function, but does not catch a synchronous exception thrown by an existing callback.

**Impact / uncertainty:**
- A broken telemetry integration could throw while the React error boundary effect is reporting an existing application error.
- This may create secondary errors or noisy reporting and make diagnosis harder.
- No runtime evidence confirms that the vendor hooks throw in the current deployment.

**Required verification/remediation direction (not implemented):**
- Ensure telemetry delivery is best-effort and cannot replace or obscure the original application failure.
- Add tests with hooks absent, hooks throwing synchronously, and hooks rejecting asynchronously if their contract permits promises.
- Avoid recursive reporting of telemetry failures through the same failing telemetry path.

## 4. Positive controls observed

- Error serialization has bounded cause depth and bounded output length.
- The error page itself renders generic user-facing text rather than interpolating stack traces.
- Browser reporting returns immediately during server-side rendering.
- The current root boundary supplies a static boundary label and pathname rather than an arbitrary application object.
- Telemetry hooks are optional, allowing the application to run when the preview-specific integration is absent.

## 5. Required verification before closure

1. Inspect vendor telemetry configuration and confirm retention, access, and scrubbing controls.
2. Add synthetic-secret tests covering message, stack, nested causes, plain objects, URLs, and route context.
3. Verify that no token, cookie, request body, document content, or sensitive identifier reaches external telemetry.
4. Simulate synchronous and asynchronous telemetry failures and verify they cannot disrupt the original error boundary.
5. Review server log access and retention separately from browser telemetry.
6. Re-run the checks after approved implementation changes.

## 6. Boundaries and non-actions

- Static source inspection only.
- No source, logging, telemetry, or vendor configuration changed.
- No live telemetry account, production logs, database, or user session accessed.
- No tests, lint, typecheck, or build were executed.
- No deployment or pull-request merge was performed.
- This report does not authorize a remediation implementation.

## 7. Conclusion

Error diagnostics are useful, but stack and cause capture should be paired with explicit redaction, data minimization, documented telemetry governance, and failure isolation. Closure requires synthetic-secret tests and confirmation of the external telemetry provider's controls; static code alone cannot establish whether sensitive data has already been transmitted.
