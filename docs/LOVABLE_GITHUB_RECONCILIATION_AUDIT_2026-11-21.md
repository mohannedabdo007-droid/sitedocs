# Lovable / GitHub Reconciliation Audit — 2026-11-21

## Authoritative source
- Repository: `mohannedabdo007-droid/sitedocs`
- Approved source branch: `fix/project-membership-authorization-2026-11-16`
- Approved source commit: `9291d340634912b371e0d0a63dd212b75c4269f9`
- Working branch created for reconciliation: `work/lovable-reconciliation-2026-11-21`
- The working branch was created directly from the approved commit; it initially contains no code changes.

## Evidence collected
- GitHub commit metadata confirms the approved SHA and subject:
  `docs(security): record P0 identity follow-up audit`.
- Recursive GitHub tree at the approved SHA contains 331 tracked file blobs.
- Lovable project `Project Doc Control` (`8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`) exposes 128 file entries across two pages.
- Path-only comparison: 227 GitHub paths are not listed in the Lovable project; 24 Lovable paths are not present in the approved GitHub tree.
- The GitHub-only set includes the `docs/` governance corpus, `.github/workflows/`, and other reference assets.
- Lovable-only paths include `.env` (existence observed only; secret values were not read), `.lovable/plan.md`, PWA icons, and current application components/routes/tests including `src/routes/auth.tsx` and `src/routes/reset-password.tsx`.
- Lovable reports latest project SHA `a6b1decc2c3e83c7b20434f1c29551e1b746e1d0`. GitHub's commit API returned 422 / no commit found for that SHA in this repository. Therefore it is not currently verifiable as a commit in the authoritative repository.
- Both repositories' `.lovable/project.json` contents match (same template and revision); this does not establish which Git branch is connected.

## Migration boundary
The Lovable project currently lists Drizzle migrations `0000`–`0003` and its own migration journal. The approved GitHub source has a different migration sequence through `0008`. This is a material lineage conflict. No migration, journal, schema, SQL, DDL, DML, seed, RLS policy, or database setting was changed or executed.

## Safe reconciliation plan
1. Keep the approved GitHub commit as the sole source baseline and work only on this isolated branch.
2. Preserve all Lovable-only environment/configuration and application files until their dependencies and behavior are reviewed. Do not read or copy secret values from `.env`.
3. Reconcile non-operational documentation and service assets first; review workflow files individually before adopting them.
4. Perform a file-by-file dependency and behavior review before merging application routes, libraries, components, or tests.
5. Keep all migration files and migration journals untouched until the actual target database identity and applied migration lineage are independently established.
6. Do not deploy, merge to `main`, or change production/database state without separate explicit approval.

## Current outcome
- Working branch created successfully from the exact approved SHA.
- No application files have yet been changed on the working branch.
- No database or production operation was performed.
- The P0 identity vulnerability remains open; this reconciliation audit is not remediation or proof of closure.
- Lovable's current internal project SHA remains unmatched to a commit in the connected GitHub repository. The exact Lovable-connected branch still needs to be established before any push intended to synchronize the editor.

## Security finding confirmed during code-level review
- Lovable migration `0001_triggers_and_rpcs.sql` defines `public.add_project_member` as `SECURITY DEFINER` and resolves the target account using `profiles.email`. This is the exact mutable-profile-email identity boundary under investigation.
- Lovable migration `0003_import_validation_and_kpi_buckets.sql` defines `public.add_company_member` using the same `profiles.email` lookup.
- The approved GitHub baseline's `0003_import_validation_and_kpi_buckets.sql` still contains the same `add_company_member` lookup. Its `0006_company_search_and_joint_ventures.sql` rebuilds `add_project_member`, but still resolves the target via `profiles.email`; the rebuild adds company-affiliation checks, not an immutable identity binding.
- The current `sitedocs-branch-validation.yml` includes a rollback-only profile-email/company-membership assertion, but the workflow does not directly invoke `add_project_member` for the second-account identity-spoof case.
- Consequently, neither the Lovable implementation nor the approved GitHub baseline can be declared P0-remediated from this evidence. The P0 issue remains open and requires a separate code/security remediation with two independent authenticated identities and direct SQL/PostgREST coverage for both membership RPCs.
- This review was source-only. No SQL was executed against any database and no migration or RLS policy was changed.

## Application compatibility findings
- The Lovable-only auth/dashboard components and routes form the active UI around `src/routes/index.tsx`; the generated route tree registers `/`, `/auth`, and `/reset-password`. These are not safe to discard as incidental files.
- The Lovable-only query/auth/governance libraries are tightly coupled to the Lovable-only dashboard UI and the Lovable-generated Supabase type definitions. They cannot be copied into the approved GitHub tree as isolated files without resolving imports, route generation, schema/type compatibility, and server/client auth behavior.
- Several GitHub app modules, including `src/lib/document-register.ts`, have no same-path counterpart in the Lovable inventory. Conversely, the Lovable dashboard is implemented with a separate set of query and presentation modules. This is an architectural divergence, not a simple missing-file sync.
- Recommended disposition: preserve the Lovable app modules as a separately reviewed integration set; do not transplant or delete them in this documentation-only reconciliation PR.
