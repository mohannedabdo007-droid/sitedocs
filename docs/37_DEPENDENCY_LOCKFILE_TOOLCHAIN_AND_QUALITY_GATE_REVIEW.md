# 37 — Dependency Lockfile, Toolchain Reproducibility, and Quality-Gate Review

**Status:** Static repository review only  
**Branch:** `dev/review-fixes`  
**Scope:** `package.json`, `bun.lock`, `bunfig.toml`, `tsconfig.json`, `eslint.config.js`, `vitest.config.ts`, `.gitignore`, and `README.md`.  
**Not performed:** No package installation, audit command, dependency update, typecheck, lint, test, build, or network package download.

## Executive summary

The repository has a committed Bun lockfile with resolved package versions and integrity hashes, plus a 24-hour minimum release-age guard. These are positive reproducibility and supply-chain controls. However, the documented developer setup instructs users to run npm while the repository's committed lockfile is Bun's format. Some important build/database tooling remains declared with broad ranges, the Nitro runtime dependency is a beta release, and there is no dedicated TypeScript typecheck script or demonstrated CI gate.

This report does not claim that any dependency is currently vulnerable. It records reproducibility and governance risks that require verification in an authorized environment.

## Findings

### F37-01 — Developer instructions use npm despite Bun lockfile being authoritative in repository
**Priority: Medium — reproducibility**

The root README instructs developers to run `npm i`, while the repository commits `bun.lock` and configures Bun-specific installation controls in `bunfig.toml`. No npm lockfile was visible in the inspected tree.

**Risk:** Different developers or automation may resolve different dependency graphs, update package metadata inconsistently, or fail to reproduce the dependency tree represented by the committed Bun lockfile.

**Required action:** Choose and document one package manager as authoritative. If Bun is intended, update setup/CI instructions to use the pinned Bun version and frozen-lockfile installation. If npm is intended, deliberately introduce and maintain its lockfile. Do not mix package managers casually.

### F37-02 — Runtime/build tooling includes beta and broad dependency declarations
**Priority: High — release stability**

The manifest declares `nitro` as `3.0.260603-beta`, and declares `drizzle-kit` and `drizzle-orm` using `0.x` ranges. The lockfile currently resolves exact versions (including Nitro beta and Drizzle 0.31.11 / 0.45.4), but the manifest ranges allow a future lock refresh to move within those ranges.

**Risk:** Toolchain behavior can change during a routine dependency refresh, especially around a beta deployment runtime and schema/migration tooling. This matters to a project whose database schema is controlled by Lovable and must not be regenerated casually.

**Required action:** Record the reason for each prerelease/broad range, define an approved upgrade window, and require compatibility review plus build/test evidence before refreshing the lockfile. Do not independently run Drizzle generation or migrations.

### F37-03 — No dedicated TypeScript typecheck command is declared
**Priority: Medium — defect detection**

Scripts include `lint`, `test`, and `build`, but no explicit `typecheck` script (for example, `tsc --noEmit`). The TypeScript configuration enables strict checks such as `strict`, `noImplicitReturns`, `noUncheckedIndexedAccess`, and `exactOptionalPropertyTypes`, but the repository does not demonstrate that a CI workflow actually invokes the compiler.

**Risk:** Type-level errors may not be caught as a separately visible quality gate, depending on the bundler/build configuration.

**Required action:** Add a separately reported typecheck gate through the authorized project workflow, then verify it on pull requests. Do not claim the current build performs full type checking without evidence.

### F37-04 — ESLint file scope omits JavaScript configuration files
**Priority: Low/Medium — configuration quality**

The ESLint flat config's primary file selector is `**/*.{ts,tsx}`. Configuration files such as `vite.config.ts` are covered, but JavaScript configuration files such as `eslint.config.js` are not included by that selector. The ignore list excludes generated build folders.

**Risk:** Lint coverage may not include all executable project configuration. This is a maintainability gap, not evidence of exploitable code.

**Required action:** Decide which JS/MJS configuration files should be linted and include them explicitly, while keeping generated/vendor files excluded.

### F37-05 — Supply-chain age guard has explicit package exceptions
**Priority: Medium — supply-chain governance**

`bunfig.toml` sets `minimumReleaseAge = 86400` (24 hours), a useful delay against immediately published packages. It also exempts five `@lovable.dev/*` packages from that delay.

**Risk:** Exemptions reduce the protection for those packages. The configuration comment says each bypass requires confirmation, but no accompanying review record was found in the inspected files explaining the rationale, owner, or periodic reassessment.

**Required action:** Keep the exceptions only when required by the platform; document the reason, approving owner, date, and review trigger. Do not add further exemptions without approval.

### F37-06 — Direct SheetJS tarball dependency uses an external package host
**Priority: Medium — provenance and availability**

The `xlsx` dependency is declared as a direct tarball URL at `cdn.sheetjs.com`, and the Bun lockfile records the resolved tarball and an integrity hash. The hash is a useful integrity control, but the dependency is not represented as a conventional registry version.

**Risk:** Availability and provenance rely on the external host and the exact tarball URL. A future URL/version change needs explicit review.

**Required action:** Preserve integrity verification; document the upstream source and update process. Review license, provenance, and security notices before changing the URL or version. Do not substitute an unverified package mirror.

### F37-07 — Environment ignore rules are sensible, but no example template is present
**Priority: Low — onboarding/configuration clarity**

`.gitignore` excludes `.env`, `.env.*`, and `.dev.vars`, while explicitly allowing `.env.example` and `.env.sample`. The inspected tree did not contain either example file.

**Risk:** New contributors lack a safe, non-secret inventory of required environment-variable names and may guess configuration.

**Required action:** Once the authoritative deployment environment is confirmed, provide a sanitized example containing names and placeholders only. Never place actual values, tokens, or credentials in the repository.

## Positive controls observed

- A committed Bun lockfile records resolved versions and integrity hashes.
- Bun installation is configured with a 24-hour minimum release age.
- TypeScript strictness options are substantially enabled.
- Generated build outputs and local environment files are ignored.
- Vitest has a dedicated test environment and a scoped test-file include pattern.

## Safe acceptance checks (not executed)

1. Confirm the authoritative package manager and pin its runtime version.
2. Perform a frozen-lockfile install in an isolated environment.
3. Run a dependency vulnerability/provenance audit and retain the timestamped output; distinguish direct from transitive findings.
4. Run typecheck, lint, unit tests, and production build as separate gates against one recorded commit SHA.
5. Verify that lockfile regeneration produces no unexplained diff.
6. Review the Nitro beta dependency and Lovable package exceptions before any upgrade.
7. Confirm the required environment-variable names from the actual deployment configuration without exposing values.

## Required boundaries

- No package versions, lockfiles, scripts, or configuration files were changed.
- No dependency audit/install/update, typecheck, lint, tests, or build was run.
- No secret values or hosting environment variables were accessed.
- This is a static reproducibility review, not a vulnerability scan or dependency security certification.

## Conclusion

The lockfile and age-delay policy provide a useful baseline, but package-manager ambiguity, a beta runtime, broad Drizzle ranges, absent explicit typecheck gate, and undocumented package-age exceptions should be resolved before treating the repository as reproducibly releasable. Dependency upgrades must remain controlled and must not bypass Lovable's database/schema ownership rules.
