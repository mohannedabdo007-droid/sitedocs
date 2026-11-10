# 41 — Preview Auth Session Broker and Browser Storage Review

**Review type:** Static source review  
**Branch:** `dev/review-fixes`  
**Reviewed source commit:** `963a4af6226e1451b0b155913abb2a4f6770485f`  
**Status:** Findings documented; no source or runtime changes made.

## 1. Scope

Focused review of the browser-side Supabase session storage and Lovable preview session broker:

- `src/integrations/supabase/previewAuthStorage.ts`
- `src/integrations/supabase/client.ts`
- `src/integrations/supabase/auth-attacher.ts`

The files identify themselves as automatically generated. This report is therefore a review record, not authorization to edit generated integration files manually.

## 2. Executive summary

The preview broker uses `postMessage` to synchronize a Supabase auth session with a Lovable editor ancestor. It validates the message origin and request identifier, and it restricts outbound messages to configured editor origins. These are useful controls.

However, the inspected reply handler does not verify that the message source is the actual `window.parent`. In addition, storage fallback paths can still throw when browser storage is unavailable, despite a guarded local read helper. These are concrete hardening and reliability items requiring browser-level verification.

## 3. Findings

### F41-01 — Broker replies validate origin and request ID but not message source

**Severity:** Medium — session-broker message authenticity hardening  
**Evidence:** The `onMessage` handler checks `e.origin` against `editorOrigins` and validates the request ID through `readBrokerReply()`. It does not check `e.source === window.parent`.

**Impact / threat model:**
- A message from another browsing context hosted on an allowed editor origin could satisfy the origin and request-ID checks if it can learn or obtain the active request identifier.
- The request ID is generated per request and is not intentionally exposed as a credential, but it is not a substitute for binding the reply to the expected browsing context.
- This finding does not establish that an exploitable cross-origin attack currently exists; it identifies a missing message-source binding in the inspected handler.

**Required remediation direction (not implemented):**
- Require the reply source to equal the exact parent/editor browsing context expected for the request.
- Keep strict origin validation and request-ID correlation; all three checks should be applied together.
- Add browser tests with a trusted-origin non-parent frame and an incorrect source, confirming that neither can complete the request.

### F41-02 — Storage fallback is not consistently protected against browser storage exceptions

**Severity:** Medium — authentication availability / resilience  
**Evidence:** `readLocal()` catches exceptions from `localStorage.getItem()`. However, other paths call `localStorage.getItem()`, `setItem()`, or `removeItem()` directly, including the fallback return in `getItem()`, initial write in `setItem()`, and removal in `removeItem()`.

**Impact:**
- In browser contexts where storage access is blocked or throws (for example, privacy restrictions, sandbox settings, or quota/security failures), the storage adapter can reject or throw rather than completing a controlled fallback.
- The comment that blocked third-party storage should not break broker reads is only partially reflected in the implementation because the final fallback read remains unguarded.

**Required remediation direction (not implemented):**
- Define explicit behavior for unavailable local storage across get/set/remove.
- Ensure broker success can still be used when local storage is unavailable, where the Supabase storage contract permits it.
- Where neither broker nor local storage is available, return a controlled failure rather than leaking an unhandled browser storage exception.
- Add tests using a storage stub whose methods throw independently.

### F41-03 — Broker timeout and fallback behavior can silently switch session authority

**Severity:** Medium — session consistency / sign-in reliability  
**Evidence:** The broker request has a two-second timeout; the first GET retries once after 250 ms. When the broker does not return a usable reply, `getItem()` falls back to local storage. `setItem()` writes locally before awaiting the broker; `removeItem()` removes locally before awaiting the broker.

**Impact / uncertainty:**
- A broker outage or delayed editor response can cause one preview surface to use its local copy while another uses the editor-held session.
- The implementation includes a logout tombstone for a successful broker response, which is a positive mitigation, but timeout and failed-reply paths still require explicit consistency tests.
- This is a resilience concern, not proof that sessions currently diverge in production.

**Required remediation direction (not implemented):**
- Define and document which store is authoritative during broker timeout, logout, and editor reconnect.
- Test delayed GET/SET/REMOVE replies, stale local sessions, logout tombstones, new tabs, and broker recovery.
- Ensure stale credentials cannot be resurrected after a confirmed logout.

## 4. Positive controls observed

- Preview hostname zones are explicitly allowlisted before project ID extraction.
- Project ID parsing is constrained to known hostname positions and a UUID pattern.
- Outbound broker messages use explicit target origins rather than `*`.
- Reply origin and request ID are checked.
- Requests have a timeout and event listeners are removed on completion.
- A logout tombstone is used to avoid resurrecting a local copy after a confirmed broker logout.
- Supabase browser client uses the publishable key; the service-role client is separated into a server-only module.

## 5. Required verification before closure

1. Browser test: trusted-origin message from a non-parent window must be rejected.
2. Browser test: wrong origin and wrong request ID must be rejected.
3. Storage tests: getItem/setItem/removeItem each throw independently; adapter behavior must remain controlled.
4. Race tests: overlapping broker requests, delayed responses, timeout/retry, and logout during pending GET/SET.
5. Multi-tab tests: session synchronization and confirmed logout must not resurrect an old token.
6. Confirm the generated integration files are updated only through their owning Lovable integration/generation process.

## 6. Boundaries and non-actions

- Static source inspection only.
- No generated integration or application source files changed.
- No SQL, migration, schema, generated type, Supabase, or storage changes.
- No browser runtime or cross-origin tests executed.
- No tests, lint, typecheck, or build were executed.
- No live auth session, Supabase account, or deployed preview was accessed.
- No deployment or pull-request merge was performed.
- This report does not authorize implementation; any generated-file changes must follow the project's ownership rules and approved change-control gates.

## 7. Conclusion

The preview session broker already has meaningful origin, request-ID, timeout, and logout-tombstone controls. The next hardening step is to bind replies to the expected parent browsing context and make storage failure behavior consistent across every adapter operation. Both changes need deterministic browser tests before release.
