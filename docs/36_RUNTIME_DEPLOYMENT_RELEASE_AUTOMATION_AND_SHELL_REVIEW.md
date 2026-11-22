# 36 — Runtime Deployment Configuration, Release Automation, and Application Shell Review

**Status:** Static repository review only  
**Branch:** `dev/review-fixes`  
**Scope:** `vite.config.ts`, `src/start.ts`, `src/server.ts`, `src/routes/__root.tsx`, root route, package scripts, tracked repository tree, and deployment-related configuration presence.  
**Not performed:** No build, test, lint, deployment, hosting-dashboard inspection, environment-variable inspection, runtime request, or production configuration change.

## Executive summary

The application uses Lovable's Vite/TanStack configuration, which documents Nitro with Cloudflare as its default build target and edge compression assumptions. The repository does not show a tracked deployment workflow under `.github/workflows` or a clearly documented release pipeline in the inspected tree. The root shell still carries generic Lovable metadata and hard-codes English as the HTML language, while the root page remains a placeholder in the previously reviewed source.

The server entry and middleware are present: `src/server.ts` wraps the TanStack server entry, and `src/start.ts` registers CSRF and Supabase auth-attacher function middleware. These are useful foundations, but they do not establish that the production host, secrets, runtime compatibility, authentication enforcement at every privileged server function, or release process are correctly configured.

## Findings

### F36-01 — Deployment target and hosting contract are not explicitly documented in repository
**Priority: High — release reliability**

`vite.config.ts` delegates to `@lovable.dev/vite-tanstack-config`. Its comments state that Nitro is included with Cloudflare as a default target and that hosting performs edge compression. The repository does not contain a project-specific deployment manifest or concise record proving the actual production host/runtime and its required bindings.

**Risk:** Local assumptions about Node, Cloudflare Workers, environment bindings, request limits, or asset handling may differ from the deployed runtime.

**Required action:** Record the authoritative Lovable deployment target and runtime contract, required environment-variable names (never values), supported Node/Bun/build versions, asset behavior, and rollback procedure. Confirm the actual host in the Lovable dashboard before changing configuration.

### F36-02 — No tracked CI/release workflow is visible
**Priority: High — change assurance**

The recursive tree inspected on `dev/review-fixes` does not contain a `.github/workflows` directory. Package scripts define `test`, `lint`, and `build`, but repository inspection does not show an automated pipeline that runs them for pull requests or gates releases.

**Risk:** Changes may reach a connected Lovable branch without repeatable automated test/build evidence or a visible release gate.

**Required action:** After confirming Lovable/GitHub integration behavior and available plan capabilities, define a non-deploying PR validation workflow for dependency install, lint, tests, and production build. Deployment must remain a separate protected action requiring explicit approval.

### F36-03 — Root HTML language and metadata remain generic placeholders
**Priority: Medium — product readiness and accessibility**

`src/routes/__root.tsx` hard-codes `<html lang="en">` and generic metadata including title `Lovable App`, description `Lovable Generated Project`, and author `Lovable`. This conflicts with the approved Arabic-first application direction and the previously identified localization readiness gap. The root route's page content remains a placeholder according to the prior static route review.

**Risk:** Browser language, accessibility tools, search/social previews, and user-facing identity do not represent Project Doc Control. This is not a security finding.

**Required action:** When application-shell implementation is authorized, use the selected locale consistently for the HTML language and metadata; define product-specific titles/descriptions and ensure route-level metadata does not regress. Do not perform a partial cosmetic change while the root application shell is still unimplemented.

### F36-04 — Server error handling logs raw error objects without a visible redaction layer
**Priority: Medium — operational data minimization**

`src/start.ts`, `src/server.ts`, and the root error component call `console.error` with error objects. The repository snippets reviewed do not demonstrate a common sanitizer that removes tokens, request headers, personal data, SQL parameters, or provider payloads before logging.

**Risk:** Depending on the error object's contents and hosting log access, diagnostic logs may retain sensitive values. Static inspection does not establish that any secret has actually been logged.

**Required action:** Define a central redaction policy and structured error schema. Log stable error IDs, safe codes, route/operation context, and correlation IDs; exclude credentials, cookies, authorization headers, raw request bodies, and unfiltered provider/SQL payloads.

### F36-05 — Middleware registration is present, but auth attachment is not equivalent to authorization
**Priority: High — server access control**

`src/start.ts` registers `attachSupabaseAuth` in `functionMiddleware` and registers CSRF middleware for server functions. This corrects any interpretation that the auth attacher is simply absent. However, attaching/forwarding a bearer token is not itself a proof that each privileged server function validates the user, checks project/party/document scope, or prevents service-role bypass.

**Risk:** A server function may receive an authenticated context but still perform an operation without the required business authorization.

**Required action:** Inventory every server function and privileged client call site. Verify explicit authentication and least-privilege authorization at each operation boundary; retain database RLS as an independent enforcement layer. Do not treat middleware presence as an authorization certification.

## Safe acceptance checks (not executed)

1. Confirm the real deployment provider/runtime from Lovable project settings and a successful deployed build record.
2. Inventory required environment-variable names and bindings without reading or copying secret values.
3. Verify that preview and production use separate backend references and that no preview deployment can mutate production data.
4. Establish CI checks for lint, unit tests, and build without automatic production deployment.
5. Run those checks only in an authorized environment and record exact commit SHA and results.
6. Enumerate server functions, auth middleware, privileged clients, and all call sites; test unauthenticated, wrong-company, wrong-party, and unauthorized-document cases in isolation.
7. Verify Arabic/English locale behavior, HTML lang, route metadata, missing-asset handling, and SSR error behavior in a preview environment.
8. Confirm a rollback path and deployment approval gate before any release.

## Required boundaries

- No source files, deployment settings, workflows, secrets, database objects, or hosting settings were changed.
- No tests, lint, build, browser checks, or deployment were run.
- No live hosting environment or secret values were accessed.
- The absence of a tracked workflow in this tree does not prove no external Lovable automation exists.
- This report is a static release-readiness review, not a runtime or production security certification.

## Conclusion

The repository has a server entry and middleware foundations, but the actual deployment contract and release gates are not demonstrated in tracked configuration. Generic root metadata and English-only HTML language remain product-shell gaps. Establish the real runtime, non-deploying CI checks, server-function authorization inventory, and redacted logging policy before production release.
