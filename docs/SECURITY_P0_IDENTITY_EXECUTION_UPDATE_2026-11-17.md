# SiteDocs P0 Identity Remediation — Execution Update 2026-11-17

## Baseline
- Repository: `mohannedabdo007-droid/sitedocs`
- Approved development branch: `fix/project-membership-authorization-2026-11-16`
- CI guard commit: `b324471a5db1967421c2ec1340aadbfd95a05654`
- Commit URL: https://github.com/mohannedabdo007-droid/sitedocs/commit/b324471a5db1967421c2ec1340aadbfd95a05654

## Verified source findings
1. `drizzle/migrations/0006_company_search_and_joint_ventures.sql` still resolves `add_project_member` by `lower(profiles.email)` with `LIMIT 1`.
2. `drizzle/migrations/0003_import_validation_and_kpi_buckets.sql` defines `add_company_member` by the same mutable `profiles.email` lookup.
3. The CI probe previously used `RAISE NOTICE` when it reproduced the membership assignment, so the workflow could remain green while the finding was present.
4. The disposable CI fixture contains the synthetic other-tenant account used by the probe. The probe runs inside a transaction and rolls back.

## Change made
- Replaced the non-blocking probe with an assertion step in `.github/workflows/sitedocs-branch-validation.yml`.
- The new gate fails if an authenticated user can persist a change to their own `profiles.email`.
- It then verifies that the spoofed address cannot create a company membership; only the expected `USER_NOT_FOUND` denial is accepted.
- The test remains rollback-only and uses disposable CI PostgreSQL fixtures.

## Verification
- [x] Updated workflow file on the approved development branch.
- [x] Read the workflow file back from GitHub and verified the new assertion block.
- [x] Fetched the resulting commit and verified the exact diff.
- [ ] GitHub Actions result for this SHA — not yet exposed by the available status/run queries; no CI pass is claimed.
- [ ] Database identity remediation — not implemented.
- [ ] Authenticated multi-user attack tests against the corrected schema — not run.

## Lovable / database blocker
- Lovable project inspected: `Project Doc Control` (`8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`).
- Its file inventory contains migrations `0000`–`0003` only; the approved GitHub branch contains migrations `0000`–`0008`.
- Its Project Knowledge still contains the superseded 13-November branch instruction. The approved 17-November GitHub branch decision must be synchronized into Lovable only after a safe repository/branch reconciliation.
- A Lovable plan-only review was attempted but rejected because the workspace has no remaining credits. No Lovable message was sent and no Lovable changes were made.
- Per `AGENTS.md`, do not edit `drizzle/` or `supabase/migrations/` by hand. Database schema remediation must be performed through Lovable's approved database workflow, after the source/database target is reconciled.

## Safety
No database, schema, migration, production setting, production deployment, or `main` branch was changed. The P0 vulnerability remains open until the schema fix and independent identity-boundary tests pass.
