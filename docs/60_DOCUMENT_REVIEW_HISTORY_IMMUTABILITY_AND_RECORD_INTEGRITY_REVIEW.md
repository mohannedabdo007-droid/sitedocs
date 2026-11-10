# 60 - Document review history append-only controls and record integrity review

- Repository: `mohannedabdo007-droid/sitedocs`
- Branch: `dev/review-fixes`
- Review type: static migration review only
- Reviewed snapshot:
  - `drizzle/migrations/0000_core_schema.sql`
  - `drizzle/migrations/0001_triggers_and_rpcs.sql`
- Source blob SHAs:
  - `0000_core_schema.sql`: `6eeac6f0ddb29d77e0ab1320ac143bab6f834c47`
  - `0001_triggers_and_rpcs.sql`: `667f793732f8841c4d8394721eb3128e04181c7f`

## Executive summary

The inspected schema treats `document_reviews` as a read-only history table for authenticated users: it grants SELECT to `authenticated`, defines a project-member SELECT policy, and exposes no authenticated INSERT, UPDATE, or DELETE grant/policy in the reviewed migration. The workflow RPC inserts review rows as part of a document transition.

The review history nevertheless has integrity limitations in the inspected schema: `actor_id` is not declared as a foreign key to an identity record; the document, revision, project, and company references are separate foreign keys rather than composite constraints proving that all references belong to the same document/project/company; and the table has no database trigger preventing privileged mutation. The service role is granted ALL. These findings warrant stronger immutable-history and relational-integrity controls, but do not demonstrate that authenticated users can currently alter history or that the deployed database has the same effective grants.

No source, migration, database, permission, or deployment changes were made.

## Scope and method

Static inspection of the named migrations on `dev/review-fixes`, limited to:
- `document_reviews` table definition, grants, RLS, and indexes;
- policies affecting review-history visibility and writes;
- the insert path in `transition_document`;
- related identity and foreign-key declarations visible in the same migration snapshot.

No live Supabase catalog, effective ACL, role membership, table contents, or deployed trigger state was queried. No SQL, tests, lint, build, or authenticated role simulation was run.

## Findings

### F60-01 - Authenticated review-history writes are not granted in the inspected migration, but deployed effective ACL must be verified

**Evidence**

The migration declares:

```sql
grant select on public.document_reviews to authenticated;
grant all on public.document_reviews to service_role;
alter table public.document_reviews enable row level security;
create policy "reviews: members read" on public.document_reviews
for select to authenticated
using (public.is_project_member(project_id));
```

No authenticated INSERT, UPDATE, or DELETE grant or corresponding write policy for `document_reviews` appears in the inspected migration. The workflow RPC `transition_document` inserts a history row after a successful lifecycle action.

**Assessment**

This is a positive restriction in the migration snapshot: ordinary authenticated clients are intended to read project-scoped review history, while the controlled workflow RPC performs inserts. However, this static grant list does not establish effective deployed privileges, inherited role grants, default privileges, or any later migration changes.

**Required verification**

Inspect live effective table ACLs (including PUBLIC and inherited roles), RLS policies, and all later migrations before concluding that direct client writes are impossible.

### F60-02 - Review rows do not enforce same-document consistency across their related identifiers

**Evidence**

The `document_reviews` table separately references:
- `document_id` to `documents(id)`;
- `revision_id` to `document_revisions(id)`;
- `project_id` to `projects(id)`;
- `company_id` to `companies(id)`.

The reviewed definition does not declare a composite foreign key proving that the selected revision belongs to the specified document, or that the document's project/company match the review row's project/company.

**Assessment**

The foreign keys ensure that each referenced row exists, but do not by themselves guarantee that the four identifiers describe one consistent document context. The current `transition_document` RPC populates these values from the locked document row and its current revision, which is a safer normal write path. However, the schema does not make this relationship an invariant for every privileged writer or future maintenance process.

**Required design direction**

Where compatible with the existing data model, add declarative composite constraints using matching unique keys on parent tables, or use a narrowly controlled write routine with explicit consistency checks. Validate historical rows before introducing any constraint; do not silently rewrite or delete history.

### F60-03 - Actor identity is stored as an unconstrained UUID

**Evidence**

The review-history definition declares `actor_id uuid not null` but no foreign key to `auth.users(id)` or another identity table. The workflow RPC writes `auth.uid()` into `actor_id`.

**Assessment**

The normal RPC records the authenticated actor, but the table definition does not ensure referential validity of the actor identifier for all privileged writes. It also does not independently preserve a durable actor snapshot if the identity record is later removed. Whether a foreign key to the auth schema is operationally appropriate depends on the account-deletion and retention policy.

**Required design direction**

Define the identity-retention policy first. Consider a controlled actor reference plus immutable actor snapshot fields (for example, stable subject ID and recorded display identity) where legally and operationally appropriate. Avoid cascading deletion of audit identity evidence. Keep sensitive personal data out of history unless required.

### F60-04 - No table-level immutability trigger protects review history from privileged mutation

**Evidence**

The reviewed migration defines no trigger on `document_reviews` that rejects UPDATE or DELETE. The table grants ALL to `service_role`. The `audit_row()` trigger is attached to selected business tables including documents and revisions, but the inspected trigger list does not attach it to `document_reviews`.

**Assessment**

Authenticated users do not receive write privileges in the inspected grant/policy set, but privileged service-role or owner-level paths are not constrained by an append-only trigger in this migration snapshot. The history table therefore depends on privileged operational discipline and external audit/backup controls for tamper resistance.

**Required design direction**

Treat review history as append-only. Add database enforcement rejecting UPDATE/DELETE for normal operational roles, tightly restrict service-role access, and record any exceptional correction as a new compensating event with actor, reason, timestamp, and reference to the original row. Database owners can still alter triggers or schema; append-only controls are not a substitute for independent backups and audit monitoring.

## Recommended isolated verification

1. Query effective ACLs for `document_reviews`, including PUBLIC, `anon`, `authenticated`, `service_role`, inherited role membership, and default privileges.
2. Enumerate all policies and triggers on the deployed table, not just those present in this snapshot.
3. Test authenticated SELECT scope for members and non-members across projects.
4. Test direct INSERT/UPDATE/DELETE as authenticated and confirm denial; separately test the approved RPC and verify exactly one history row per successful transition.
5. Attempt privileged UPDATE/DELETE in an isolated restored database and verify the proposed append-only guard rejects them.
6. Seed deliberately mismatched document/revision/project/company identifiers in an isolated test and verify declarative constraints or controlled write logic rejects them.
7. Test actor deletion/deactivation against the agreed audit-retention policy without erasing historical accountability.

## Approved project rules considered

- Workflow decisions must be attributable to the actual acting user and authorized workflow party.
- Project Manager visibility is not authority to alter or decide workflow history.
- Creator self-approval and administrative party bypass remain separate high-priority findings from Report 59.
- Historical records must be preserved; corrections should be traceable rather than silently overwritten or deleted.
- No database migration may proceed before an independent backup, successful restore test, review of the exact migration, and explicit approval.

## Limitations

- Static evidence only from the two named migration files.
- No live database catalog, deployed grants, data consistency, user identities, or runtime RLS behavior was inspected.
- No claim is made that authenticated direct writes succeed.
- No source, SQL, migration, policy, grant, trigger, test, build, merge, or deployment changes were performed.
- This report authorizes no remediation or database change.

## Conclusion

The migration snapshot establishes a useful read-only access pattern for authenticated review-history consumers and routes ordinary history creation through the workflow RPC. The remaining weaknesses concern relational consistency, durable actor attribution, and the absence of append-only enforcement against privileged mutation. Verify deployed ACLs and historical data, then design any hardening as a separately reviewed migration after backup and restore validation.
