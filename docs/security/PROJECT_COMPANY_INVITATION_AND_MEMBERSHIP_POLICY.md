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
- Invitations expire no later than 90 days after creation; the default expiry is 30 days. Expired pending invitations are marked and audited when acceptance/rejection/revocation is attempted or when a replacement invitation is created for the same party/company. There is no scheduled background expiry job yet.
- A company cannot be assigned to more than one party in the same project. Multiple companies may be linked to the same party to represent a JV or consortium.

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

## 4. Security controls in migrations 0005 and 0006

- Adds project-scoped policy, invitation, company-party link, and append-only membership-event tables. A database trigger rejects UPDATE and DELETE on membership events.
- Backfills the owning-company party only where the existing project has one unambiguous admin party whose user is an actual member of the owning company. Ambiguous cases are not guessed.
- Adds a composite project/company foreign key for new membership tables.
- Replaces the email-based `add_project_member` upsert. Duplicate memberships now fail; they do not rewrite party, role, or organization.
- Requires active company membership matching the party-company link for every new project-member row. Migration 0006 persists the exact participating company in `project_members.participant_company_id`; this prevents company-member removal from revoking another JV participant's member access.
- Revokes direct authenticated INSERT and UPDATE on `project_members`; validated SECURITY DEFINER RPCs are the write path.
- Restricts project-member deletion: project administrators may remove members of their own party; owning-company administrators may remove members across parties.
- A project administrator cannot assign project-admin role to an external-company member.
- Company-membership removal automatically deletes corresponding project memberships and triggers the existing membership audit.
- Invitation creation, acceptance, rejection, revocation, expiration, direct company linking, member addition, and policy changes are recorded in `project_membership_events`.

## 5. Known limitations requiring review before production

1. Multiple companies may now share one project party, while each participating company remains unique within that project. When a party has multiple companies, `add_project_member` requires the caller to pass `_member_company`; it will not guess which JV participant employs the user.
2. Historical `project_members` rows are backfilled to `participant_company_id` only when exactly one company is mapped to their party and the user is an active member of that company. Ambiguous, unmapped, or unverified historical rows remain `NULL` and require controlled reconciliation before relying on company-specific removal behavior for those legacy memberships.
3. The invitation-management route is present in source and uses the protected RPCs. The existing member-administration screen still needs a company selector when adding a member to a multi-company party.
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
- revocation of project access after company membership removal;

`drizzle/tests/company_search_and_joint_ventures.acceptance.sql` additionally covers:
- bounded and permission-scoped company search;
- sending a second invitation after another company is already linked to the same party;
- invitation inbox visibility for invited-company administrators;
- multiple companies and their members under one JV party;
- explicit member-company selection when a party has multiple companies;
- persistence of the member's actual participating company;
- revoking only the removed company's member while preserving another JV participant's access.
- append-only protection for membership events.

Run only against an isolated restored test database with synthetic users and companies.

## 7. Validation boundary

- Migrations 0005/0006, both PostgreSQL acceptance scripts, typed RPC declarations, and the invitation-management route have been added to the isolated Git branch.
- The Drizzle migration journal has been updated.
- No SQL migration was executed.
- No PostgreSQL instance or test database was available in this work session.
- No build, typecheck, Vitest run, or live RLS test has been performed.
- No live database, production environment, or `main` branch was changed.
