# SiteDocs — Company Invitation and Project Membership Policy

**Implementation branch:** `fix/project-membership-authorization-2026-11-16`  
**Status:** Migration and acceptance-test draft committed; not executed against PostgreSQL.  
**Default rule:** External-company acceptance is required.

## 1. Approved behavior

1. A project belongs to one owning company.
2. A company outside the project owner must be linked to the project through an explicit invitation.
3. The invitation is addressed to a specific company and a specific project party (Contractor, Consultant, Owner, or PMC).
4. Only an owner/admin of the invited company can accept or reject it.
5. After acceptance, project administrators may add users who are active members of that invited company to the party assigned to that company.
6. A company administrator does not gain project access merely by belonging to the owning company. Project authority still requires an explicit project membership.
7. A user cannot be silently reassigned to another party or promoted by repeating the email-based add operation. Membership rows cannot be directly updated by authenticated clients.
8. Removing a user from the participating company revokes that user's project membership for the associated party. The existing project-member audit trigger records the deletion.

## 2. Invitation lifecycle

`pending → accepted | rejected | revoked | expired`

- The project-owning company's project administrator creates the invitation.
- The invited company's owner/admin accepts or rejects.
- Acceptance creates the project-to-company party link.
- A pending invitation can be revoked by the owning company's project administrator with a reason.
- Invitations expire no later than 90 days after creation; the default expiry is 30 days.
- A company or party cannot be assigned twice in the same project under this first implementation.

## 3. Future policy configuration

The project setting `external_company_acceptance_required` defaults to `true`.

| Setting | Behavior |
|---|---|
| `true` (default) | External company must accept an invitation before its users can be added. |
| `false` | Future/alternative mode: an administrator of the owning company may explicitly link a company while adding one of its members. The company ID must be supplied; company membership is still verified. |

Changing the setting requires:
- both project-management authority and owner-company administrator authority;
- a reason of at least 10 characters;
- an immutable `project_membership_events` record with the previous and new values.

Changing the setting does not retroactively remove companies already linked to the project. It governs creation of new external company links.

## 4. Security controls in migration 0005

- Adds project-scoped policy, invitation, company-party link, and append-only membership-event tables.
- Backfills the owning-company party only where the existing project has one unambiguous admin party whose user is an actual member of the owning company. Ambiguous cases are not guessed.
- Adds a composite project/company foreign key for new membership tables.
- Replaces the email-based `add_project_member` upsert. Duplicate memberships now fail; they do not rewrite party, role, or organization.
- Requires active company membership matching the party-company link for every new project-member row.
- Revokes direct authenticated INSERT and UPDATE on `project_members`; validated SECURITY DEFINER RPCs are the write path.
- Restricts project-member deletion: project administrators may remove members of their own party; owning-company administrators may remove members across parties.
- A project administrator cannot assign project-admin role to an external-company member.
- Company-membership removal automatically deletes corresponding project memberships and triggers the existing membership audit.
- Invitation acceptance and policy changes are recorded in `project_membership_events`.

## 5. Known limitations requiring review before production

1. **One company per party:** this first iteration enforces one company for each party within a project. If SiteDocs must support joint ventures or multiple companies under one party, the membership model must be extended with an explicit company ID on each project-member row before rollout. This cardinality is a technical assumption in this draft, not a separately approved business rule.
2. The current application route is a dashboard and does not yet expose invitation-management screens. Migration RPCs and RLS are the backend contract; UI integration remains a separate task.
3. Existing external project members are not automatically trusted or mapped to a company. Only unambiguous owning-company memberships are backfilled. Existing external party memberships need a controlled reconciliation plan before the migration is applied.
4. This branch does not establish the state of any live Supabase database. No database has been connected or modified.

## 6. Acceptance tests

`drizzle/tests/project_company_invitation.acceptance.sql` covers:
- acceptance by an invited-company administrator;
- rejection of acceptance by an unrelated/non-admin actor;
- adding a member only after company acceptance;
- duplicate membership not being used as an upsert to change party/role;
- direct UPDATE denial;
- unaccepted-company denial under the default policy;
- denial of policy changes by an external-company administrator;
- audited policy change by the owning-company administrator;
- the alternative admin-approval mode;
- revocation of project access after company membership removal.

Run only against an isolated restored test database with synthetic users and companies.

## 7. Validation boundary

- Migration SQL and the acceptance-test file have been added to the isolated Git branch.
- The Drizzle migration journal has been updated.
- No SQL migration was executed.
- No PostgreSQL instance or test database was available in this work session.
- No build, typecheck, Vitest run, or live RLS test has been performed.
- No live database, production environment, or `main` branch was changed.
