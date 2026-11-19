# P0 Membership Assignment — Immutable Auth User ID

**Status:** Replacement design for the email-based membership lookup. This supersedes the invitation-based proposal previously recorded in this file.  
**Date:** 2026-11-19  
**Related work:** PR #20 — P0 profile-email identity spoofing remediation  
**Approved baseline:** `97bd978db782335b0f6bc42800e78709bc25d5e6`

## 1. Decision

Remove email-based membership assignment from both `add_project_member` and `add_company_member`. Do not add an invitation table, invitation lifecycle, token delivery, or invitation-acceptance workflow as part of this remediation.

Replace the email parameter with the immutable Auth user UUID:

- `add_project_member(_project, _user_id, _party, _role, _organization)`
- `add_company_member(_company, _user_id, _role)`

The user picker in the management UI selects an existing account from the permitted directory and submits its stable Auth UUID. The UUID is the account identity; profile email is display/contact information only and must never be used to resolve the membership target.

## 2. Server-side validation

Each RPC must:

1. Check the existing authority predicate first:
   - `can_manage_project(_project)` for project membership.
   - `is_company_admin(_company)` for company membership.
2. Resolve the target only by exact `auth.users.id = _user_id`.
3. Require a non-null Auth email, `email_confirmed_at IS NOT NULL`, `deleted_at IS NULL`, and `is_anonymous = false`.
4. Reject a missing or ineligible account with `USER_NOT_FOUND`.
5. Preserve existing membership upsert behavior and all existing role/party validation.
6. Continue rejecting `company_role = 'owner'` through ordinary company membership assignment.

A caller-supplied UUID does not become trusted merely because it is a UUID. The RPC must validate it against `auth.users` and the caller's management authority. The user interface should present only accounts visible in the authorized company/project member directory; the server-side checks remain authoritative.

## 3. UI behavior

- Replace free-text email entry with an account picker/search over the existing authorized user directory.
- Display a useful label such as full name and email, but submit the selected immutable Auth UUID.
- Do not make email unique or use email as the lookup key.
- Do not expose Auth internals or service-role access to the browser.
- If the current UI cannot safely list eligible accounts, keep the assignment unavailable until a protected directory query is provided; do not fall back to email lookup.

## 4. Required regression tests

- A profile email forged to match another user's email cannot redirect membership; the exact selected UUID receives membership.
- An attacker cannot change `profiles.id` or use a mutable profile email as a membership identity.
- Unknown UUID, unconfirmed account, missing Auth email, deleted account, and anonymous account are rejected.
- A confirmed, active Auth UUID is accepted.
- Project membership upsert preserves the membership row ID and updates only the intended party/role/organization fields.
- Company role upsert remains unchanged; an existing owner cannot be downgraded and ordinary assignment cannot grant owner.
- Unauthorized callers remain rejected by the real project/company authority predicates.
- Test the actual UI directory query, RPC grants, RLS, and PostgREST behavior with separate identities in an isolated Supabase environment.

## 5. Scope and safety

- No invitation table or invitation acceptance flow is required for this replacement.
- No manual edits to `drizzle/` or `supabase/migrations/`; managed schema changes must be generated through the authorized Lovable workflow.
- The current CI PostgreSQL fixture is disposable and uses simplified authorization stubs. Its pass is not proof of production ACL/RLS or real authorization behavior.
- The tracked migration definitions remain unchanged until the managed workflow can safely generate the replacement.
- No production database write, deployment, or merge to `main` is authorized by this design.

**Disposition:** This is the simpler replacement: immutable Auth UUID selection instead of email resolution. P0 remains **OPEN** until the managed database functions and UI are changed and the complete isolated-environment regression passes.
