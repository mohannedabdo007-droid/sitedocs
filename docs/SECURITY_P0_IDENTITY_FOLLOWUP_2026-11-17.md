# SiteDocs P0 Identity Boundary — Follow-up Audit 2026-11-17

## Scope and source
- Repository: `mohannedabdo007-droid/sitedocs`
- Approved development branch: `fix/project-membership-authorization-2026-11-16`
- Audit performed against the current contents of that branch and the connected Lovable project.
- This is a source audit and execution plan; it is not a database change or a claim that the vulnerability is fixed.

## Confirmed findings

1. `drizzle/migrations/0003_import_validation_and_kpi_buckets.sql` defines `public.add_company_member` by resolving `_email` against `public.profiles.email`.
2. `drizzle/migrations/0006_company_search_and_joint_ventures.sql` defines `public.add_project_member` using the same mutable profile-email lookup.
3. `drizzle/migrations/0000_core_schema.sql` grants `SELECT, INSERT, UPDATE` on `public.profiles` to `authenticated`. The effective RLS policies must also be considered; table-level grants alone do not prove a particular update succeeds.
4. The revised workflow contains a rollback-only behavioral assertion for the profile-email mutation and the company-membership path. It does not directly call `add_project_member` in that identity-boundary assertion.
5. Therefore the revised CI assertion is useful but incomplete: it does not independently prove that project-member assignment is protected against the same identity-confusion class.
6. Lovable project `Project Doc Control` (`8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`) currently lists migrations `0000`–`0003`; the approved GitHub branch contains `0000`–`0008`. This is a source synchronization gap, not proof by itself of which migrations were applied to any hosted database.
7. The project's `AGENTS.md` explicitly says not to edit `drizzle/` or `supabase/migrations/` manually; database schema changes must be requested through Lovable.

## Required remediation design (not yet implemented)

- Treat the authenticated identity provider as the source of truth. Membership RPCs must not select a user identity from a client-editable `profiles.email` value.
- Prefer an explicit target `user_id` for administrative membership operations where the UI can select a known account. If email-based invitations remain a product requirement, resolve only against the authoritative Auth identity/email source and require the appropriate verified-email state; do not fall back to `profiles.email`.
- Make `profiles.email` system-managed: authenticated users must not be able to insert or update that identity field. Preserve permitted profile edits (for example, display name and locale) with column-level grants/policies as appropriate.
- Ensure profile email synchronization, if retained, is driven by trusted Auth-side events rather than client profile writes.
- Apply equivalent protections to both `add_company_member` and `add_project_member`; audit any other RPC that resolves account identity from profile email.

## Required regression tests

1. As authenticated user A, attempt to change A's profile email to an address associated with account B. Assert the write is denied or cannot persist.
2. As a company administrator in a separate authenticated session, attempt company membership assignment using the spoofed address. Assert no membership is created for A or B except the explicitly intended, Auth-resolved target.
3. As an authorized project administrator in a separate authenticated session, attempt project membership assignment using the spoofed address. Assert no unauthorized project membership is created.
4. Include a positive control proving a legitimate, verified target can still be invited/assigned through the supported flow.
5. Assert the identity-resolution source in both RPC definitions is not `public.profiles.email`; behavioral tests remain mandatory and must run against the migrated disposable database.
6. Run the tests with separate JWT subjects/identities and verify database state after each attempted attack. Keep all fixtures isolated and rollback-only.

## Verification status

- [x] Re-read current GitHub source for migrations `0000`, `0003`, `0006`, `0007`, and `0008`.
- [x] Re-read the current CI workflow and its identity-boundary assertion.
- [x] Re-read Lovable `AGENTS.md` and enumerate project files.
- [x] Confirmed Lovable's listed migration inventory ends at `0003`.
- [ ] Database RPC remediation — not implemented.
- [ ] Direct `add_project_member` identity-attack regression — not implemented.
- [ ] GitHub Actions result for the latest CI-guard commit — not verified in this audit.
- [ ] Hosted database/API identity-boundary tests — not run.

## Safety

No migration, database, production setting, deployment, or `main` branch was changed. The P0 issue remains open. Do not describe the identity boundary as fixed until both membership RPCs are remediated and the independent positive/negative tests pass.
