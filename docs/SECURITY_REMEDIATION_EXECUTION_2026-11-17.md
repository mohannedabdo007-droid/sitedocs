# SiteDocs Security Remediation Execution — 2026-11-17

## Execution baseline

- Repository: `mohannedabdo007-droid/sitedocs`
- Source branch: `fix/project-membership-authorization-2026-11-16`
- Source SHA: `b9c449720729baea4d6157c8834be69959e92e12`
- Execution branch: `security/remediation-identity-workflow-2026-11-17`
- Lovable project is not treated as a source of truth: its latest project SHA and migration inventory do not match this repository/branch.
- `AGENTS.md` prohibits hand-editing `drizzle/` and `supabase/migrations/`; database schema changes must be made through Lovable.
- No database, migration, production, or `main` changes are authorized by this execution.

## Verified blockers and findings

### P0 — Account identity can be spoofed during membership creation

The current `drizzle/migrations/0006_company_search_and_joint_ventures.sql` implementation of `public.add_project_member` resolves `v_user` from `public.profiles` using:

```sql
select id into v_user
  from public.profiles
 where lower(email) = lower(btrim(_email))
 limit 1;
```

This is unsafe while the caller can update their own profile email under the current broad self-update policy and the normalized email is not a unique, trusted account identifier. The membership grant must bind to a trusted Auth user identity, not an email selected from mutable profile data.

Required database remediation (must be performed through the approved Lovable database-change workflow, not by editing migrations here):
1. Remove authenticated users' ability to update `profiles.email` through the self-profile update path; explicitly allow only safe profile columns.
2. Make the trusted account identity originate from `auth.users.id` / `auth.uid()`, and redesign membership invitation/acceptance so the invited account is resolved to a stable Auth UUID before membership is granted. Do not use `LIMIT 1` email lookup as an identity resolver.
3. If email is retained for invitation delivery or lookup, normalize and enforce uniqueness as appropriate, but never treat a caller-editable profile email as proof of identity.
4. Preserve the accepted-company affiliation checks and membership audit events.
5. Add positive and negative SQL acceptance cases with two authenticated identities and separate companies.

Required attack tests:
- User A changes their own profile email to User B's address; the update must be rejected.
- User A attempts to create/invite a project membership that resolves to User B; no membership for B may be created by A's action.
- Duplicate/case-variant emails cannot produce ambiguous account resolution.
- A valid invitation accepted while authenticated as User B grants membership only to `auth.uid() = B`.
- Existing company-affiliation and project authorization controls remain enforced.

### P1 — Project Manager assignment authority

The current source has `project_members.is_project_manager` and guards ordinary membership updates, but no dedicated application RPC for assigning/removing PM was identified in migration 0007. Do not invent the assigning authority. The previously approved requirement is that PM has oversight read access, not edit/review/approval powers. A dedicated audited operation requires the project owner's still-unresolved authority decision if no prior approved rule defines it.

### P1 — Response code semantics

Required approved behavior:
- `I` means For Information Only and closes the review cycle while retaining the document in the archive.
- `E` is not a reviewer response code; cancellation is a distinct action initiated by the originating entity.
- The database must enforce these meanings; UI labels alone are insufficient.
- Do not invent additional response-code behavior or change historical records without an approved migration and review.

### P1 — MQR and RFI

Required approved behavior:
- MQR means **Monthly Quality Report** (التقرير الشهري للجودة), has an independent review workflow, and does not use A/B/C/D/E/I response codes by default.
- The detailed MQR stage sequence is not yet approved; do not invent it.
- RFI means **Request for Information**, and is separate from WIR.
- Preserve historical documents and project-specific workflow configuration during any eventual data correction.

## Execution sequence and acceptance gates

1. Close the account-identity vulnerability through the Lovable-managed database workflow, with an isolated target and explicit migration review.
2. Execute the attack tests above using independent authenticated users; verify both denied and valid membership paths.
3. Define the authorized PM assignment actor from an existing approved decision or obtain that one missing authority decision; then implement an audited least-privilege RPC and tests.
4. Enforce immutable I/E semantics and a distinct originator cancellation path.
5. Correct MQR/RFI defaults and trusted workflow behavior without inventing MQR stages.
6. Run SQL/PostgREST/Storage acceptance tests, application tests, lint, typecheck, and build; record exact branch/SHA and CI run.
7. Submit the changes as reviewable PRs. Do not merge to `main`, apply production migrations, or deploy without explicit approval.

## Current execution status

- [x] Confirmed GitHub repository permissions and source branch SHA.
- [x] Created isolated execution branch from the verified source branch.
- [x] Confirmed Lovable migration inventory is stale/incomplete relative to the GitHub branch; no reconnect/disconnect action taken.
- [x] Reconfirmed the identity-resolution vulnerability in migration source.
- [ ] Database identity fix — blocked until the Lovable project is confirmed to target the correct source/database workflow.
- [ ] Authenticated multi-user attack tests.
- [ ] PM authority RPC and audit tests.
- [ ] I/E semantic enforcement and cancellation action.
- [ ] MQR/RFI database/workflow correction.
- [ ] Runtime test suite and CI evidence.

## Safety statement

This document records the execution plan and verified source findings only. It does not claim that any vulnerability is fixed. No migration, database, production setting, deployment, or `main` branch was modified.
