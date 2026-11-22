# 33 — Profile Identity, Email Synchronization, and Account Provisioning Review

**Status:** Static source/migration review only  
**Branch:** `dev/review-fixes`  
**Scope:** Profile schema and RLS, new-auth-user profile trigger, profile indexes, and email-based project-member provisioning in `0000_core_schema.sql` and `0001_triggers_and_rpcs.sql`.  
**Not performed:** No live Auth inspection, database/catalog query, runtime account test, SQL execution, source change, or deployment.

## Executive summary

The reviewed schema allows authenticated users to update their entire own profile row, including `email`, while the email-based project-member provisioning RPC later treats `profiles.email` as the lookup key for selecting an account. The profile email is initially copied from `auth.users` only when a user is created; no corresponding email-change synchronization trigger is visible in the reviewed migration.

This creates an identity-data integrity risk: the profile email used for membership lookup is not visibly constrained to remain the verified Auth email, and the index is non-unique. The live behavior and exploitability must be tested against the deployed Auth configuration before any remediation.

## Findings

### F33-01 — Self-service profile update includes the email identity field
**Priority: High — identity integrity**

The profile table grants authenticated users `UPDATE` on the table. The RLS update policy checks only that the row's `id` equals `auth.uid()`; it does not restrict the columns that can be changed. The table includes `email` and `full_name` fields.

As written in the migration, the policy therefore permits a user to update their own profile email independently of the Auth account email, subject to ordinary table constraints. RLS row ownership is not equivalent to verified email ownership.

**Risk:** Other application flows may trust `profiles.email` as an account identifier even though the reviewed policy does not bind it to the verified Auth identity.

### F33-02 — Email-based member provisioning trusts a mutable, non-unique profile email
**Priority: High — account selection integrity**

The `add_project_member` SECURITY DEFINER RPC resolves a user with:

`select id into uid from public.profiles where lower(email) = lower(btrim(_email)) limit 1`

The profile email index is on `lower(email)`, but it is not declared UNIQUE. The lookup has no deterministic ordering and does not reject multiple matches.

Combined with F33-01, the account selected for a requested email may be ambiguous or may no longer correspond to the verified Auth email. The RPC then upserts that selected user into `project_members` with the supplied party and role.

**Risk:** Membership could be assigned to an unintended account if profile email values are stale, duplicated, or modified independently of Auth.

### F33-03 — New-user profile creation has no visible Auth email-change synchronization
**Priority: Medium — lifecycle consistency**

The `handle_new_user()` trigger inserts a profile using `new.email` when a row is inserted into `auth.users`. The reviewed migration does not define a corresponding trigger for updates to `auth.users.email`.

This means the reviewed schema does not demonstrate how profile email is kept synchronized after a verified Auth email change. This is a bounded static observation; synchronization could exist in external Supabase configuration or application code not present in the reviewed migrations.

**Risk:** Email-based invitation and account lookup may use stale profile data after account email changes.

### F33-04 — Profile changes are not included in the visible row-audit trigger set
**Priority: Medium — accountability**

The visible audit trigger list covers companies, company members, projects, project members, response codes, workflows, numbering, documents, revisions, attachments, comments, and import batches. It does not include `profiles`.

Consequently, profile email/name/locale changes are not shown as being captured by the same row-audit mechanism. Auth provider logs may record account events, but that is not established by these migrations and is not a substitute for a joined, application-level identity change trail.

**Risk:** Investigating unexpected account selection or profile identity changes may lack a single auditable application record.

## Recommended acceptance tests

1. User changes their own `profiles.email` while leaving `auth.users.email` unchanged; verify the intended policy rejects or safely handles the mismatch.
2. User changes Auth email through the supported verified flow; verify profile synchronization and membership lookup update atomically or safely.
3. Attempt two profiles with the same normalized email; verify provisioning fails closed with an ambiguity error.
4. Attempt case-variant and whitespace-variant email matches; verify normalization and uniqueness rules.
5. Provision a project member by email and confirm the selected Auth user ID matches the verified Auth account.
6. Verify unauthorized users cannot update another user's profile or protected identity attributes.
7. Verify profile identity changes are attributable to an actor and recorded without exposing unnecessary personal data.
8. Verify profile deletion/account deactivation does not silently corrupt historical project membership or audit attribution.

## Recommended remediation design (not approved or implemented)

- Treat the Auth user ID as the stable identity key; do not use a mutable profile email as sole proof of account identity.
- Make profile email server-managed and synchronized from the trusted Auth record, or remove it as an independently editable field.
- If email lookup remains part of invitations, require normalized uniqueness and reject zero/multiple/ambiguous matches; consider an explicit invitation/acceptance flow bound to the target Auth user.
- Restrict profile updates to safe user-editable fields (for example display name and locale) through column grants or a validated RPC; do not rely on row-level ownership alone.
- Define a controlled audit event for identity/email changes, with privacy-conscious retention.
- Test Auth email-change, duplicate, invite, and deactivation flows against the actual Supabase project before migration.

## Boundary and disposition

- This is a static review of tracked migrations only.
- No claim is made about live Auth triggers, deployed grants, existing duplicate profile emails, or current production exploitability.
- No source, SQL, database, Storage, Auth settings, secrets, or deployment was changed.
- No tests were executed.
- Do not apply a migration or merge to `main` based on this report alone.
