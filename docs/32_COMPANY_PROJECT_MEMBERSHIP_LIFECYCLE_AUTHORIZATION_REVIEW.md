# 32 — Company and Project Membership Lifecycle & Authorization Review

**Status:** Static source/migration review only  
**Branch:** `dev/review-fixes`  
**Scope:** `0000_core_schema.sql`, `0001_triggers_and_rpcs.sql`, membership helpers, RLS policies, and company/project creation and member-management RPCs.  
**Not performed:** No live database/catalog inspection, runtime authorization tests, SQL execution, source changes, migration, or deployment.

## Executive summary

The membership model has a concrete authorization ambiguity: company owners/admins are implicitly elevated to project admins, but an explicit project-membership row takes precedence over that inherited role. This creates inconsistent access depending on whether a project row exists for that user. The schema also has no visible company-owner transfer/recovery workflow, and member lifecycle controls are split between direct table policies and RPCs.

These are static findings against the reviewed migrations, not proof of exploitability in a live Supabase project.

## Findings

### F32-01 — Company administrator inheritance conflicts with explicit project membership
**Priority: High — policy decision required**

`project_role_of(project)` first returns the user's explicit `project_members.role`; only if no row exists does it fall back to `admin` for company owners/admins. `can_manage_project`, `can_edit_documents`, `can_comment`, and `is_project_member` all depend on this helper.

Consequences:
- A company owner/admin without a project row implicitly becomes a project admin.
- If the same user receives an explicit project row with role `viewer`, `controller`, or `reviewer`, that row shadows the inherited admin role.
- A company-level administrator's effective project permissions therefore change merely by adding or changing a project membership row.
- Company administrators may inherit broad project-management and document permissions without an explicit project assignment, which conflicts with a least-privilege model unless this inheritance is intentional and approved.

**Required decision:** Should company owner/admin be a company-wide administrative role only, or automatically grant project administration? If inheritance is retained, define whether explicit project membership may narrow it and how that exception is represented.

### F32-02 — Company membership and project membership use different authority paths
**Priority: High — governance / lifecycle**

Company membership RLS permits company admins to insert, update, and delete non-owner memberships. Project membership RLS permits project admins to insert and update rows and delete other users' rows. The `add_project_member` RPC separately resolves an existing profile by email and upserts party/role/organization.

The database therefore exposes more than one membership-management path. Direct table writes and the RPC must enforce identical rules for:
- who may invite/add a person;
- whether the person must already belong to the company;
- whether external consultant/owner/PMC parties may be added without company membership;
- who may change party, role, organization, or user identity;
- how removal affects existing document visibility and historical audit records.

The reviewed project-member scope trigger derives `company_id` from `project_id` only on insert or update of `project_id`; it does not itself define invitation, company-affiliation, or role-transition policy.

**Required decision:** Confirm whether project membership is intentionally allowed to include users who are not company members (likely necessary for external project parties), and define the authoritative invitation/removal process.

### F32-03 — No visible company-owner transfer or recovery workflow
**Priority: Medium — operational continuity**

The company-members policies prevent inserting, updating, or deleting rows whose existing/new role is `owner`. The `create_company` RPC creates the initial owner, but the reviewed migration contains no owner-transfer or recovery RPC.

This protects the owner row from ordinary company-admin edits, but it also leaves no visible supported path to transfer ownership if the owner leaves, loses access, or the account is disabled. This is a design gap in the reviewed source, not proof that no external administrative recovery exists.

**Required decision:** Define an auditable owner-transfer/recovery process with strong identity verification and safeguards against self-promotion.

### F32-04 — Project administrators can edit membership identity and authority directly
**Priority: Medium — integrity / audit control**

Authenticated users have direct INSERT/UPDATE/DELETE grants on `project_members`; RLS limits these to project administrators (with deletion excluding the acting user's own row). The update policy does not visibly restrict which columns may change. The helper `add_project_member` also upserts the target user's party, role, and organization.

The reviewed policy does not visibly require an approval step, immutable membership history, or explicit reason for changing a person's party/role. Audit triggers record row changes, but the audit design is not a substitute for an explicit authorization and approval policy.

**Required control:** Restrict membership mutations to a single validated server-side path (or make direct writes enforce exactly the same constraints), record actor/reason/old and new authority, and test privilege escalation and self-modification cases.

### F32-05 — Project membership does not visibly validate company affiliation
**Priority: Medium — conditional on intended external-party model**

The project-member row stores both `project_id` and `company_id`, and a trigger derives `company_id` from the project. However, neither the visible `add_project_member` RPC nor the membership RLS policy requires the target user to be a member of that company.

This may be intentional because consultant, owner, and PMC parties can be external to the project-creating company. If so, the design still needs an explicit invitation/acceptance and party-organization validation rule rather than assuming company membership.

**Required decision:** Confirm the cross-company membership model and the evidence required to associate an external user with a project party.

## Recommended acceptance tests

1. Company owner/admin with no project row: verify intended effective project permissions.
2. Same user after explicit project membership is added as viewer/controller/reviewer/admin: verify deterministic role precedence.
3. Company admin updates/removes an ordinary company member; verify owner rows remain protected.
4. Attempt owner promotion, owner duplication, owner transfer, and recovery through every exposed path.
5. Project admin adds an existing company member and an external-party user; verify the intended policy for both.
6. Attempt direct table writes that alter `user_id`, `party`, `role`, `organization`, `project_id`, and `company_id`.
7. Remove or downgrade a member who authored documents, reviews, comments, or attachments; verify historical records and audit attribution remain intact.
8. Verify company-level admin inheritance cannot accidentally grant project workflow authority contrary to the approved party rules.
9. Verify membership changes invalidate/recompute access promptly for documents, drafts, Storage objects, and signed URLs.

## Safe remediation sequence

1. Approve the company-admin inheritance and external-party membership policies.
2. Define owner transfer/recovery and membership lifecycle rules.
3. Implement one authoritative server-side membership mutation path with column-level validation and immutable audit evidence.
4. Reconcile RLS, table grants, RPC grants, and UI controls.
5. Test using separate company owners/admins, project admins, controllers, reviewers, viewers, and external-party accounts.
6. Verify against the actual Supabase project and deployed schema before applying any migration.

## Boundary and disposition

- This report is a static review of the named tracked migrations.
- It does not establish the live database's actual policies, grants, or deployed function bodies.
- No database, Storage, source, settings, secrets, branch protection, or deployment was changed.
- No tests were executed.
- Do not apply a migration or merge to `main` based on this report alone.
