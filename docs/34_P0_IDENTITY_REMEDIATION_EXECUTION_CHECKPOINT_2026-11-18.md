# P0 Identity Remediation — Execution Checkpoint (2026-11-18)

**Status:** Investigation advanced; remediation not yet applied  
**Repository:** `mohannedabdo007-droid/sitedocs`  
**Working branch:** `security/p0-identity-remediation-2026-11-18`  
**Approved baseline:** `97bd978db782335b0f6bc42800e78709bc25d5e6`  
**Safety boundary:** No production database, migration, Auth setting, deployment, or `main` change was made.

## 1. Git baseline and repository constraints

- The working branch still compares as `identical` to the approved baseline: zero commits ahead and zero changed files before this checkpoint.
- `AGENTS.md` was reread from the working branch. It explicitly prohibits manual edits to `supabase/migrations/` and `drizzle/`; database changes must be requested through Lovable. It also prohibits rewriting published history and requires evidence tied to exact SHAs.
- The current Lovable project `Project Doc Control` (`8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`) is a separate project/repository context. Its database observations must not be represented as observations of Supabase project `jezpyxuxjzxotxjykhky`.

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

These observations establish the unsafe design in this Lovable database. They do **not** prove the same live state in the inaccessible Supabase target, and no exploit attempt was performed.

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

1. Restore read access to Supabase project `jezpyxuxjzxotxjykhky` through an authorized connection.
2. Verify the target project's identity, Auth settings, deployed functions, policies, triggers, and backup/restore capability using read-only checks.
3. Obtain/verify the isolated test branch `sitedocs-p0-identity-test`; production data is not assumed to be present in a Supabase development branch.
4. Have Lovable generate the database changes in its managed workflow. Do not hand-edit migration directories.
5. Review the generated diff and reconcile it into this branch under `AGENTS.md`.
6. Run isolated SQL/RLS/PostgREST tests with separate attacker and victim identities.
7. Run CI on the exact resulting branch SHA and review the complete diff.
8. Stop before production application or merge to `main`; those remain separately gated by explicit approval.

## 7. Disposition

**P0 remains OPEN.** This checkpoint records investigation evidence and execution gates only. It is not a fix, migration, runtime exploit test, or security closure.
