# P0 Membership Invitation and Auth-Bound Acceptance Design

**Status:** Technical proposal for the approved identity-remediation direction; not a database migration or implementation approval.  
**Date:** 2026-11-18  
**Related work:** PR #20 — P0 profile-email identity spoofing remediation  
**Approved baseline:** `97bd978db782335b0f6bc42800e78709bc25d5e6`

## 1. Current verified source state

The checked-in membership RPCs currently accept an email supplied by the caller and resolve it through mutable `public.profiles.email`. This is the P0 identity-spoofing defect.

The current migration journal contains migrations 0000–0004. The checked-in core schema has `profiles`, `companies`, `company_members`, `projects`, and `project_members`, but no membership-invitation table. The inspected source tree also contains no invitation-acceptance server function or invite UI flow.

The repository does contain a generated Supabase auth middleware that validates a bearer token with `auth.getClaims` and exposes the verified `sub` as `userId` in server-function context. A generated server-only service-role client also exists. These are building blocks, not evidence of a working invitation workflow. Generated files must not be edited directly.

## 2. Security objective

Separate the authority to invite from the identity that becomes a member:

- A currently authorized project/company manager may create an invitation for an email address and a bounded role/party.
- The invitee must complete the configured Supabase Auth invitation or sign-in/confirmation flow.
- Membership acceptance must derive the member identity exclusively from the authenticated request's `auth.uid()`; it must not accept a caller-supplied `user_id`.
- The accepted Auth account must have exactly the invited normalized email, a confirmed email, and must not be deleted or anonymous.
- A pending, expired, revoked, already-consumed, or email-mismatched invitation must fail closed.
- No email/profile lookup may be used as the source of the final membership `user_id`.

## 3. Proposed lifecycle

1. **Create invitation:** A server function uses the existing verified-user middleware. It invokes a server-authoritative operation that checks the caller using the existing project/company authorization predicates. The invitation records target scope, intended role/party, normalized email, inviter, creation time, expiry, and lifecycle state. Company-owner assignment remains prohibited through this path.
2. **Deliver invitation:** Use the Supabase Auth email-delivery mechanism configured for the actual target project. New-account invitation and existing-account sign-in may require different Auth operations. The implementation must inspect the target project's actual Auth settings and redirect allowlist; do not assume delivery configuration or introduce an unapproved email provider.
3. **Authenticate invitee:** The recipient follows the Auth link and establishes a valid session. The server validates the bearer token and obtains the immutable Auth subject. The browser cannot nominate a user UUID.
4. **Accept invitation:** An authenticated acceptance RPC receives only the invitation identifier (and, if the chosen delivery design requires it, a one-time opaque proof). Inside the database transaction it obtains `auth.uid()`, loads that exact `auth.users` row, and checks:
   - `email_confirmed_at IS NOT NULL`;
   - `deleted_at IS NULL`;
   - `is_anonymous = false`;
   - normalized current Auth email equals the invitation's normalized target email;
   - invitation is pending, not expired, not revoked, and not already accepted by another identity;
   - the invitation target and role/party remain valid.
5. **Commit atomically:** The same transaction creates the project/company membership with `user_id = auth.uid()`, records `accepted_by` and `accepted_at`, and consumes the invitation. Replays must be idempotent for the same accepted identity or return a generic rejection; they must never transfer the invitation to another identity.
6. **Audit:** Record invitation creation, delivery outcome where available, acceptance, expiry, revocation, and rejected acceptance attempts without logging bearer tokens or secret material.

## 4. Database/API shape to evaluate (not yet approved schema)

A single invitation relation may support both scopes, provided constraints make the target unambiguous:

- `id` (UUID primary key);
- `target_kind` (project or company);
- exactly one of `project_id` / `company_id`;
- `email_normalized`;
- invited `party` and `project_role` for project invitations, or `company_role` for company invitations;
- `invited_by` (Auth user ID);
- `created_at`, `expires_at`, `accepted_at`, `revoked_at`;
- `accepted_by` (Auth user ID);
- optional delivery/provider reference that contains no reusable Auth token.

Constraints and indexes must prevent malformed scope/role combinations, prevent owner assignment through ordinary company invitations, and support efficient pending-invitation checks. The exact schema, uniqueness policy for multiple pending invitations, expiry duration, resend behavior, and retention period remain to be designed against the existing authorization model before any migration is generated.

## 5. RPC and privilege boundary

- Keep invitation creation authorization server-side; never trust client-supplied inviter identity, project/company scope, or authority flags.
- Acceptance must derive `auth.uid()` internally. Do not accept `user_id`, `profiles.id`, or a free-form email as the membership identity.
- Use a narrowly scoped SECURITY DEFINER acceptance function only if required; fix `search_path`, fully qualify objects, validate every argument, and revoke EXECUTE from `public` and `anon`. Grant only the intended authenticated entry point.
- Internal membership-write helpers should not remain directly executable by untrusted clients.
- Service-role operations, if needed for Auth invitation delivery, belong only in a trusted server module after caller authorization. Never send service-role credentials to the browser.
- Existing project/company manager predicates remain the authority source. Project Manager read-only visibility does not imply invitation or membership-management authority.
- Avoid distinguishable responses that disclose whether an email already has an Auth account.

## 6. Required acceptance tests

### Identity and ownership
- Attacker changes their own profile email to the victim's email; cannot obtain the victim's membership.
- Invitee accepts while authenticated as the matching confirmed Auth user; membership uses exactly that `auth.uid()`.
- A different authenticated user cannot accept the invitation even if they know the invitation UUID.
- Client-supplied user UUID/email cannot override the Auth subject.
- Unconfirmed, anonymous, deleted, missing-email, or email-mismatched Auth users cannot accept.
- Pending Auth email change is not treated as confirmed; acceptance after confirmed email change succeeds only if the current Auth email still matches the invitation.

### Invitation lifecycle
- Expired, revoked, already-consumed, malformed, and cross-scope invitations fail closed.
- Concurrent acceptance attempts create at most one membership and consume the invitation once.
- Replay by the same accepted identity is deterministic and does not change role/party.
- Re-invitation cannot downgrade an existing company owner or grant owner through the ordinary invitation path.
- Revoking/resending an invitation invalidates the prior acceptance capability.
- Generic failure behavior does not reveal account existence.

### Authorization and regression
- Unauthorized users cannot create invitations for projects or companies they do not manage.
- PM read-only access does not permit invitation creation or membership changes.
- Existing membership upsert behavior is preserved only where explicitly intended; invitation acceptance must not silently overwrite an existing member's authority.
- All checks run with separate inviter, attacker, and invitee identities in an isolated Supabase project, plus direct SQL/RPC/PostgREST tests.

## 7. Implementation gates

1. Restore authorized read access to the actual SiteDocs Supabase project and independently verify its project identity.
2. Obtain a separate isolated project/branch. The unrelated restored project `ndbcldrgrfkecqryscba` must not be used as a SiteDocs test environment.
3. Complete the independent database AND Storage backup/restore gate required by the approved governance directive.
4. Have Lovable generate the exact schema/RPC changes through its managed workflow. Do not hand-edit `drizzle/` or `supabase/migrations/`.
5. Review the generated migration, ACLs, RLS, trigger behavior, server-function boundary, Auth email configuration, and rollback plan.
6. Run the full acceptance suite with independent identities against the isolated target.
7. Keep production application, deployment, and merge to `main` separately gated by explicit approval.

**Disposition:** This design supports the approved combination of trusted Auth identity and recipient-accepted invitation. It is a proposal only. No schema, migration, application code, Auth setting, live database, or deployment was changed by this document.
