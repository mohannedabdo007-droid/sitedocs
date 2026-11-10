# Security Remediation Plan — Project Doc Control

**Date:** 2026-11-10  
**Repository:** `mohannedabdo007-droid/sitedocs`  
**Working branch:** `dev/review-fixes`  
**Protected reference:** `backup/lovable-2026-11-10` at `7e0135f279fa3924e7b48f82fb319b8872d14ebf`

## 1. Scope and safety boundaries

This document is a remediation plan only. It does not change dependency versions, source code, database schema, migrations, Supabase settings, secrets, or deployment configuration.

- Work only on `dev/review-fixes`; do not modify `main` or `backup/lovable-2026-11-10`.
- Do not merge the existing PR or any future PR without the user's explicit approval.
- No database migrations, schema changes, Supabase writes, or storage changes are part of this security-dependency plan.
- Do not expose or copy credentials, tokens, environment variables, or connection strings.
- Every dependency change must be isolated, reviewed, tested, and submitted as a separate PR.
- If tests cannot run, report them as not run; do not mark the phase complete.

## 2. Baseline observed in the checked-in lockfile

The current `dev/review-fixes` `bun.lock` resolves:

| Package | Resolved version | Finding |
|---|---:|---|
| `vite` | 8.1.5 | Affected by multiple Vite advisories; a Critical RCE advisory published 2026-11-10 is fixed in 8.1.7 for the 8.1 line. |
| `rolldown` | 1.2.1 | Forced by `package.json` override. Must be checked against the exact Rolldown version expected by the patched Vite release; do not assume this override is safe. |
| `zod` (direct) | 3.25.76 | Falls below the advisory's fixed version 4.6.6; migration impact must be assessed before moving from Zod 3 to Zod 4. |
| `zod` (TanStack nested copies) | 4.6.5 | Below the advisory's fixed version 4.6.6. |
| `picomatch` | 4.0.5 and 4.0.7 | Both are within the published CVE-2026-112366 affected range (through 4.0.7); no verified upstream fixed version was identified in this review. |
| `@tanstack/react-start` | 1.168.60 | At the published patched version for GHSA-qx66-fv34-fjm8. |
| `@tanstack/start-server-core` | 1.169.39 | At the published patched version for GHSA-qx66-fv34-fjm8. |
| `@tanstack/router-plugin` | 1.168.42 | Not among the malicious versions listed in the TanStack supply-chain advisory reviewed. No direct vulnerability established here. |
| `@tailwindcss/vite` | 4.3.3 | No direct vulnerability established in this review; transitive dependencies still require a complete audit. |

This inventory is based on the checked-in `package.json` and `bun.lock`, not a live install or runtime scan. Lovable's alert count (6 High / 6 Medium) has not yet been independently reproduced.

## 3. Phased remediation

### Phase 0 — Containment and reproducible baseline (no package edits)

1. Confirm whether any Vite development server is running with `--host`, `server.host`, or otherwise reachable from an untrusted network.
2. Until the patched dependency set is validated, do not expose a Vite development server to public or untrusted networks. Stop any publicly reachable dev server; keep development bound to localhost or a trusted private network.
3. Capture the exact branch commit, lockfile hash, package-manager version, and current GitHub security alerts.
4. Run a lockfile-aware vulnerability scan that explicitly supports Bun lockfiles. Record scanner name/version, timestamp, direct/transitive paths, advisory IDs, and severity. Do not convert a parser failure into a clean bill of health.
5. Search the complete repository for Zod imports and APIs, including `zod`, `z.infer`, `.parse()`, `.safeParse()`, and schemas consumed by TanStack or form resolvers.

**Exit criteria:** baseline report saved; dev-server exposure status known; Zod usage inventory complete. No source or dependency changes in this phase.

### Phase 1 — Vite / Rolldown (highest priority)

1. Prepare an isolated dependency-only change targeting Vite `8.1.7` or a later release confirmed to contain the same fix and compatible with the current TanStack/Lovable config.
2. Re-evaluate the existing `overrides.rolldown = 1.2.1`. The Vite advisory says the 8.1.7 fix relies on Rolldown 1.1.7. Do not keep the 1.2.1 override blindly and do not replace it blindly: verify Vite's declared range, all other consumers, platform packages, and the resulting lockfile. Prefer the dependency graph supported by the patched Vite release.
3. Regenerate `bun.lock` using the repository's Bun version and frozen/locked reproducibility checks. Review the entire lockfile diff for unrelated upgrades.
4. Verify the Vite 8.1.6 fixes for the October file-serving and middleware advisories are also covered by the selected patched release.
5. Run install-from-lockfile, lint, unit tests, production build, and a targeted dev-server security smoke test. Confirm the development server is not unintentionally exposed.

**Exit criteria:** Vite resolves to a patched release; Rolldown resolves to a compatible fixed release; no unexplained lockfile churn; all available checks pass. Submit a dedicated PR; do not merge it.

### Phase 2 — Zod direct and nested copies

1. Determine whether application code uses Zod 3-specific behavior or types, including integrations and generated types. Review all imports and runtime schema paths.
2. Prepare a separate migration branch/commit for Zod 4.6.6 or a later verified fixed release. Do not use a broad override to force every transitive dependency onto one major version.
3. Upgrade the direct dependency and compatible integrations deliberately; confirm TanStack's nested Zod copies resolve to at least 4.6.6.
4. Add tests for large arrays and malformed payloads with explicit length limits and bounded validation behavior. Add request/body size limits at trust boundaries where applicable.
5. Check TypeScript inference, server/client schema parity, import validation, forms, and all API validation paths.

**Exit criteria:** all resolved Zod copies are at a fixed version; compatibility and regression tests pass; no unreviewed major-version override remains. Submit a dedicated PR; do not merge it.

### Phase 3 — Picomatch transitive exposure

1. Trace every Picomatch instance to its parent package and determine whether any attacker-controlled or externally supplied glob/pattern reaches it.
2. Until an upstream patched release is verified, do not invent a patched version, install an unofficial fork, or force an arbitrary override.
3. Where the application itself accepts patterns, reject risky repeated-extglob constructs (including single-branch repeated extglobs such as `+(*)` and `+(*a)`), constrain pattern length, and apply execution/input limits. Prefer allowlisted server-owned patterns.
4. Add regression tests demonstrating that untrusted patterns cannot cause unbounded work. These are compensating controls, not a substitute for an upstream patch.
5. Recheck the advisory and parent-package release notes before updating the dependency graph.

**Exit criteria:** exposure path documented; any reachable untrusted pattern input is constrained and tested; upstream fixed release status recorded. If the dependency is only used with trusted static patterns, document that evidence rather than claiming the package is patched.

### Phase 4 — Full dependency audit and closure

1. Re-run the Bun-lockfile-aware scanner and GitHub Dependabot after the preceding PRs are reviewed.
2. Compare results by advisory ID and dependency path, not just alert counts.
3. Review all direct and transitive advisories for TanStack, Tailwind, Vite, Rolldown, Zod, and other packages.
4. Verify the TanStack patched versions remain installed and that the historical malicious package versions are absent.
5. Run: frozen install, lint, unit tests, production build, and the project's documented smoke tests. Record any skipped check and its reason.
6. Produce a final report with before/after package trees, advisory status, test logs, PR links, and remaining accepted risks.

**Exit criteria:** no unexplained High/Critical alerts; Medium/Low alerts either fixed or explicitly documented with exploitability rationale and owner; all required tests pass.

## 4. Release and rollback controls

- No production deployment until the relevant PR is reviewed and explicitly approved.
- Preserve the current backup branch unchanged.
- Roll back a dependency-only phase by reverting its dedicated commit/PR, not by restoring or overwriting the database.
- If a dependency change requires database or migration changes, stop and request a separate review and explicit approval. This plan does not authorize database work.
- Do not claim a fix based solely on a version string: confirm the resolved lockfile, advisory fixed range, build, and tests.

## 5. Primary advisory references

- Vite Critical RCE GHSA-p4f5-76q4-ffq7 (published 2026-11-10): https://github.com/vitejs/vite/security/advisories/GHSA-p4f5-76q4-ffq7
- Vite file-serving issue GHSA-rq7h-c2jc-7f22: https://github.com/vitejs/vite/security/advisories/GHSA-rq7h-c2jc-7f22
- Vite custom middleware issue GHSA-9jrq-w75r-8gcw: https://github.com/vitejs/vite/security/advisories/GHSA-9jrq-w75r-8gcw
- Zod GHSA-mrhx-c7xc-m3w5: https://github.com/advisories/GHSA-mrhx-c7xc-m3w5
- Picomatch CVE-2026-112366: https://nvd.nist.gov/vuln/detail/CVE-2026-112366
- TanStack Start GHSA-qx66-fv34-fjm8: https://github.com/TanStack/router/security/advisories/GHSA-qx66-fv34-fjm8

---
**Status:** Plan prepared only. No dependency, source-code, deployment, or database changes have been made.
