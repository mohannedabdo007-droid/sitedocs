# P0 Identity Remediation — Execution Checkpoint (2026-11-18)

**Status:** Investigation advanced; remediation not yet applied  
**Repository:** `mohannedabdo007-droid/sitedocs`  
**Working branch:** `security/p0-identity-remediation-2026-11-18`  
**Approved baseline:** `97bd978db782335b0f6bc42800e78709bc25d5e6`  
**Safety boundary:** No production database, migration, Auth setting, deployment, or `main` change was made.

## 1. Git baseline and repository constraints

- At the initial checkpoint the working branch had not yet diverged from the approved baseline. The current branch state is recorded in Section 9 below; do not use this historical statement as the current status.
- `AGENTS.md` was reread from the working branch. It explicitly prohibits manual edits to `supabase/migrations/` and `drizzle/`; database changes must be requested through Lovable. It also prohibits rewriting published history and requires evidence tied to exact SHAs.
- The current Lovable project `Project Doc Control` (`8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`) is connected to a different GitHub repository context, but its tracked `supabase/config.toml` explicitly declares `project_id = "jezpyxuxjzxotxjykhky"`, matching the intended Supabase target. This is strong evidence that the Lovable-managed database belongs to the target project. The direct Supabase MCP connection still rejects access; until a second independent project-identity signal is available, distinguish the matching configured project ref from verified direct Supabase API access.

## 2. Supabase target access — still blocked

Read-only `get_project` was attempted against target project `jezpyxuxjzxotxjykhky` through all four currently available connections:

- `Primary`
- `SiteDocs`
- `الأرشيف الذكي`
- `sit`

All four returned permission error `MCP error -32600: You do not have permission to perform this action`.

Project listings show:
- `Primary`: no visible projects.
- `SiteDocs`: `ndbcldrgrfkecqryscba`, not the target project.
- `الأرشيف الذكي`: `wlbdcjwxzfzemjojilgw`, not the target project.
- `sit`: no visible projects.

Neither visible project may be substituted for the target. No branch was created and no cost was incurred in this checkpoint.

## 3. Read-only findings in the separate Lovable database

The Lovable database status reports enabled. Read-only catalog queries reconfirmed:

- `authenticated` has table UPDATE privilege on `public.profiles`.
- The `profiles: update self` policy scopes the row to `auth.uid()`, but does not constrain updated columns.
- Column-level UPDATE privilege on `profiles.email` is available to `authenticated`.
- Both `add_project_member` and `add_company_member` resolve the target by matching `lower(profiles.email)` to the supplied email.
- The visible profile creation trigger copies `auth.users.email` on user insertion; no visible Auth-email update synchronization trigger was found in the inspected trigger catalog.
- Aggregate-only counts in this separate database: one Auth user, confirmed; one profile; no normalized duplicate confirmed Auth emails; no normalized duplicate profile emails; no profile/Auth email mismatch; no deleted Auth users.

Because the Lovable project's `supabase/config.toml` matches the intended target ref, these observations are now strongly attributable to the intended SiteDocs project, subject to the remaining limitation that direct Supabase MCP metadata access is denied. They establish the unsafe live database design through Lovable's database query path; no exploit attempt was performed.

## 4. Implementation constraints and required design

The remediation must be performed through the Lovable-managed database workflow, then reconciled into the approved `sitedocs` branch without editing migration directories manually.

Required invariants:

1. `auth.users.id` remains the stable membership identity.
2. Invitation lookup must use a trusted Auth identity and must fail closed for unconfirmed, deleted, missing, or ambiguous matches.
3. Users must not directly update `profiles.email` or `profiles.id`.
4. Auth email-change confirmation lifecycle must be inspected before defining profile synchronization.
5. Existing project-member upsert semantics and company-owner protections must remain unchanged.
6. No duplicate or mismatched existing profile is to be auto-merged or deleted.
7. Do not expose service-role credentials or perform account impersonation using production users.

## 5. Acceptance tests required before closure

### Negative
- Authenticated user cannot directly update `profiles.email` or `profiles.id`.
- Attacker cannot claim a victim's email in profile and receive the victim's project/company membership.
- Unconfirmed, deleted, missing, and ambiguous Auth identities cannot be provisioned.
- Unknown and ambiguous addresses do not reveal account existence through distinguishable errors.
- Non-admin callers remain forbidden.
- Existing company owners cannot be downgraded or replaced through re-invitation.
- Unconfirmed Auth email changes do not become trusted profile lookup values.

### Positive and regression
- Confirmed, normalized email resolves to exactly the corresponding Auth user ID.
- Confirmed email changes synchronize according to the actual Auth confirmation lifecycle.
- Existing memberships retain their `user_id`.
- Project party/role/organization upsert behavior remains intact.
- Company role upsert behavior remains intact without weakening owner protection.
- Users can still edit permitted profile fields such as full name and locale.
- Tests execute with isolated test identities and are rolled back or run in a disposable database.

## 6. Next executable gates

1. Obtain an independent identity/metadata confirmation for the matching Supabase project ref, and restore direct Supabase MCP read access if possible.
2. Verify the target project's identity, Auth settings, deployed functions, policies, triggers, and backup/restore capability using read-only checks.
3. Obtain/verify the isolated test branch `sitedocs-p0-identity-test`; production data is not assumed to be present in a Supabase development branch.
4. Have Lovable generate the database changes in its managed workflow. Do not hand-edit migration directories.
5. Review the generated diff and reconcile it into this branch under `AGENTS.md`.
6. Run isolated SQL/RLS/PostgREST tests with separate attacker and victim identities.
7. Run CI on the exact resulting branch SHA and review the complete diff.
8. Stop before production application or merge to `main`; those remain separately gated by explicit approval.

## 7. Disposition

**P0 remains OPEN.** This checkpoint records investigation evidence and execution gates only. It is not a fix, migration, runtime exploit test, or security closure.


## 8. Follow-up access and isolation attempts (2026-11-18)

After the explicit approval to modify an isolated test database only:

- Re-listed Supabase organizations across all four connected accounts. The account named `Primary` exposes an organization named `SiteDocs-security-test` (organization ID `awbgclnsgbddgozvjwek`); this is an organization listing, not proof of access to target project `jezpyxuxjzxotxjykhky`.
- Re-quoted the development-branch compute cost for that organization: `$0.01344/hour`, matching the user's prior explicit cost approval.
- Issued a fresh cost confirmation and attempted to create `sitedocs-p0-identity-test` under that account. The create operation still returned `MCP error -32600: You do not have permission to perform this action`.
- A direct read-only `get_project` against the target project under the same account also returned the same permission error.
- The earlier attempt under the `SiteDocs` connector account failed identically. No Supabase branch was created, no hourly compute started, and no database write occurred.
- At that checkpoint, the only changed path was this document. A later regression-test commit and draft PR are recorded in Section 9 below.

**Current blocker:** the connected Supabase identity can enumerate the organization and quote branch cost but is not authorized to read or branch the target project. The next safe route is to restore project-level Supabase access for the connected identity or obtain an authorized isolated project/branch reference. Do not substitute another project or modify the Lovable database until the target identity and isolation boundary are independently verified.


## 9. Regression guard and draft review (2026-11-18)

- Added two source-level regression tests in `src/test/security-migration-source.test.ts`, covering both `add_project_member` and `add_company_member`. The tests reject membership identity lookup through mutable `public.profiles.email`.
- The tests intentionally expose the current unsafe migration source: the existing functions still contain the prohibited lookup. The test suite has **not** been executed in this environment, so no test result is claimed.
- No migration, database file, or live database was edited. The test additions do not remediate the runtime vulnerability.
- Opened draft PR [#20](https://github.com/mohannedabdo007-droid/sitedocs/pull/20), targeting the approved baseline branch `fix/cloudflare-workers-build-2026-11-13`; it remains unmerged and draft.
- Current PR head SHA: `d630b0f6d019b7ac502f7273d8605ca0965367e0`. The branch compares as 7 commits ahead, 0 behind the approved baseline; changed paths are this checkpoint document and `src/test/security-migration-source.test.ts`.
- GitHub Actions reports zero workflow runs for this branch and zero check-runs for the PR head at the time of this update. CI execution is therefore not verified.
- Direct Supabase project access remains denied across all four connected Supabase identities, including `list_branches`; no isolated branch was created and no hourly compute was started.

**Disposition remains P0 OPEN.** The source guard is a detection measure only. Runtime remediation still requires the authorized isolated database workflow, confirmed backup/restore boundary, Lovable-managed database changes, and independent-identity SQL/RLS acceptance tests.


## 10. CI follow-up after source-guard correction (2026-11-18)

- A first CI attempt at `d2b5ea3d34c2f1565450cc99fcd685b605007970` failed during TypeScript parsing because the newly added test helper contained an escaped template-literal delimiter. This was an implementation error in the test code, not a database finding.
- Corrected the helper to use ordinary string concatenation and committed `3e3bfcbda39ac190bc98935e81a1002dd6ee0e86`.
- On that corrected SHA, GitHub Actions run [44250173033](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/44250173033) started. At the time of this checkpoint update, dependency installation, TypeScript typecheck, and the configured ESLint step have passed; the unit-test step is still running. Build has not yet run.
- The earlier failed run [44250116834](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/44250116834) is superseded by the corrected head and must not be used as the current result.
- No runtime database change has been made. The new source guards are expected to detect the current unsafe profile-email lookup once the unit-test step completes.

**Current disposition: P0 OPEN; CI pending on corrected head.**
