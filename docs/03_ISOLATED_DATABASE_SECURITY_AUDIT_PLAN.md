# Isolated Database Security Audit Plan

**Document:** POL-DB-SEC-001  
**Prepared:** 2026-11-11  
**Status:** Approved-plan support document; execution blocked pending verified isolated restore and explicit authorization  
**Source baseline:** `dev/review-fixes` at `1aae68808318dbe0cbaa0bd55d19f9238b587453`  
**Scope:** Read-only catalog inspection and negative authorization testing. This document does not authorize production access or schema changes.

## 1. Non-negotiable safety gates

No query in this plan is to be run against a live/production database as part of this work. Before database-level testing:

1. Identify the exact Supabase project and environment; record project reference, owner, region, and whether it is production, staging, or development.
2. Obtain explicit confirmation from the user and project owner that the selected source database may be backed up and restored for testing.
3. Create a fresh, independently stored backup using the provider-supported process; record timestamp, scope, encryption/access controls, and checksum where available.
4. Restore that backup into a separate isolated Supabase project/database, not into the source project.
5. Verify restore completion, schema/object counts, and representative row counts without changing the restored data.
6. Ensure outbound email, webhooks, storage notifications, scheduled jobs, and external integrations are disabled or safely redirected in the isolated environment.
7. Use a dedicated least-privilege audit identity. Preserve raw query output and timestamps.
8. Run only the read-only catalog queries in Section 4 first. Run negative functional tests only after the isolated environment is proven safe.
9. Any corrective SQL, migration, role/ACL change, data mutation, or deployment requires a separate reviewed change and explicit approval. Repository `AGENTS.md` reserves database/migration edits for Lovable; do not hand-edit `drizzle/` or Supabase migrations.

**Current gate status:** backup not performed; restore not performed; live database identity not established; catalog ACLs not inspected; no database test has run.

## 2. Static migration inventory

Read-only inspection of migration source at the stated baseline identified **27 SECURITY DEFINER function definitions** across migrations 0000, 0001 and 0003. The following list is a source-code inventory, not proof of deployed/live definitions or effective privileges.

### 2.1 `0000_core_schema.sql` — 9 definitions

| Function | Identity arguments |
|---|---|
| `public.is_company_member` | `_company uuid` |
| `public.is_company_admin` | `_company uuid` |
| `public.project_role_of` | `_project uuid` |
| `public.project_party_of` | `_project uuid` |
| `public.is_project_member` | `_project uuid` |
| `public.can_manage_project` | `_project uuid` |
| `public.can_edit_documents` | `_project uuid` |
| `public.can_comment` | `_project uuid` |
| `public.shares_scope_with` | `_other uuid` |

All nine definitions include `SET search_path = public` in the inspected migration source. No explicit per-function EXECUTE revocation was observed in this migration excerpt; effective ACLs must be read from the isolated database catalog.

### 2.2 `0001_triggers_and_rpcs.sql` — 17 definitions

| Function | Identity arguments |
|---|---|
| `public.handle_new_user` | none |
| `public.set_scope_from_project` | none |
| `public.set_scope_from_document` | none |
| `public.comments_before_insert` | none |
| `public.import_rows_scope` | none |
| `public.resolve_numbering_scheme` | `_project uuid, _type uuid, _disc uuid` |
| `public.preview_document_number` | `_project uuid, _type uuid, _disc uuid` |
| `public.documents_before_insert` | none |
| `public.documents_after_insert` | none |
| `public.revisions_before_insert` | none |
| `public.revisions_after_insert` | none |
| `public.audit_row` | none |
| `public.create_company` | `_name text, _code text, _name_ar text` |
| `public.create_project` | `_company uuid, _code text, _name text, _party project_party, _name_ar text, _client text, _location text` |
| `public.add_project_member` | `_project uuid, _email text, _party project_party, _role project_role, _organization text` |
| `public.transition_document` | `_doc uuid, _action text, _response_code text, _notes text` |
| `public.commit_import_rows` | `_batch uuid, _limit int` |

All listed definitions include `SET search_path = public` in source. The migration explicitly revokes EXECUTE from `anon` on selected RPCs (`create_company`, `create_project`, `add_project_member`, `transition_document`, `commit_import_rows`, `preview_document_number`). It explicitly revokes EXECUTE from `public`, `anon`, and `authenticated` on `resolve_numbering_scheme(uuid, uuid, uuid)`. These source statements do not establish the effective deployed ACL, inherited role access, default privileges, or grants applied later.

### 2.3 `0003_import_validation_and_kpi_buckets.sql` — 1 definition

| Function | Identity arguments |
|---|---|
| `public.add_company_member` | `_company uuid, _email text, _role company_role` |

The definition includes `SECURITY DEFINER` and `SET search_path = public` in source. The other functions introduced/updated in this migration were inspected as invoker functions, not added to this SECURITY DEFINER inventory.

### 2.4 Exclusions and source observations

- `public.set_updated_at`, `public.format_doc_number`, `public.documents_guard_update` are not SECURITY DEFINER.
- `public.document_kpi_matrix`, `public.existing_revisions_for_numbers`, and `public.save_import_validation` are declared SECURITY INVOKER in the inspected source.
- `public.storage_project_id` in migration 0002 is not SECURITY DEFINER.
- This inventory is based on the exact migration source files and hashes recorded below. It is not a substitute for querying `pg_proc` in the restored database.
- `SET search_path = public` is present in these definitions, but this alone does not prove safe ownership, schema CREATE restrictions, object resolution safety, or least-privilege EXECUTE grants.

## 3. Priority audit targets

1. **Workflow authorization:** `public.transition_document(uuid,text,text,text)` — source contains Admin bypass branches previously identified for submit/review/respond/return party checks. Validate all branches against the approved party-boundary rules and self-review prohibition.
2. **Membership escalation:** `public.add_project_member(uuid,text,project_party,project_role,text)` and `public.add_company_member(uuid,text,company_role)` — validate caller authority, target identity, self-targeting, role escalation, tenant boundary, and organization/party assignment.
3. **Import commit:** `public.commit_import_rows(uuid,int)` — validate authorization, ownership of batch, server-side revalidation of mapped JSON and validation decision, resource bounds, duplicate/conflict behavior, and audit trail.
4. **Tenant scope triggers:** `set_scope_from_project`, `set_scope_from_document`, `comments_before_insert`, `import_rows_scope` — verify they derive scope from trusted parent rows and fail closed when parent records are missing.
5. **Document/revision triggers:** `documents_before_insert`, `documents_after_insert`, `revisions_before_insert`, `revisions_after_insert` — verify lifecycle snapshots, WIR/RFI/MQR separation, discipline normalization and audit behavior.
6. **Audit trail:** `audit_row` — verify actor attribution, immutability, coverage and failure behavior.
7. **Numbering helpers:** `resolve_numbering_scheme`, `preview_document_number` — verify cross-project access boundaries and that preview does not consume a sequence.
8. **Identity/bootstrap:** `handle_new_user` — verify safe profile initialization and no trust in caller-controlled identity fields.
9. **Permission helpers:** the nine functions from migration 0000 — verify they derive identity from `auth.uid()`, respect tenant/project boundaries, and cannot be used to infer or expose other users' memberships.

## 4. Read-only catalog audit queries

Run these only after the isolated restore has passed the gates above. Do not run DDL/DML. Capture output as evidence with database identity and timestamp.

### 4.1 Inventory all deployed SECURITY DEFINER routines

```sql
select
  n.nspname as schema_name,
  p.proname as function_name,
  pg_get_function_identity_arguments(p.oid) as identity_arguments,
  pg_get_function_result(p.oid) as result_type,
  l.lanname as language,
  pg_get_userbyid(p.proowner) as owner_name,
  p.prosecdef as security_definer,
  p.proconfig as function_settings,
  p.proacl as explicit_acl
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
join pg_language l on l.oid = p.prolang
where n.nspname = 'public'
  and p.prosecdef
order by p.proname, pg_get_function_identity_arguments(p.oid);
```

### 4.2 Expand effective function ACL entries

```sql
select
  n.nspname as schema_name,
  p.proname as function_name,
  pg_get_function_identity_arguments(p.oid) as identity_arguments,
  pg_get_userbyid(p.proowner) as owner_name,
  case when a.grantee = 0 then 'PUBLIC' else grantee.rolname end as grantee,
  a.privilege_type,
  a.is_grantable
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
cross join lateral aclexplode(coalesce(p.proacl, acldefault('f', p.proowner))) a
left join pg_roles grantee on grantee.oid = a.grantee
where n.nspname = 'public'
  and p.prosecdef
order by p.proname, identity_arguments, grantee, a.privilege_type;
```

### 4.3 Check EXECUTE capability for platform/application roles

```sql
select
  p.proname as function_name,
  pg_get_function_identity_arguments(p.oid) as identity_arguments,
  r.rolname as role_name,
  has_function_privilege(r.oid, p.oid, 'EXECUTE') as can_execute
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
cross join pg_roles r
where n.nspname = 'public'
  and p.prosecdef
  and r.rolname in ('anon', 'authenticated', 'service_role', 'authenticator', 'postgres')
order by p.proname, identity_arguments, r.rolname;
```

### 4.4 Inspect default privileges affecting future functions

```sql
select
  pg_get_userbyid(d.defaclrole) as owner_role,
  n.nspname as schema_name,
  d.defaclobjtype,
  d.defaclacl
from pg_default_acl d
left join pg_namespace n on n.oid = d.defaclnamespace
where d.defaclobjtype = 'f'
order by owner_role, schema_name;
```

### 4.5 Inspect schema CREATE privileges and role membership

```sql
select
  n.nspname,
  r.rolname,
  has_schema_privilege(r.oid, n.oid, 'USAGE') as can_use,
  has_schema_privilege(r.oid, n.oid, 'CREATE') as can_create
from pg_namespace n
cross join pg_roles r
where n.nspname in ('public', 'auth', 'storage')
  and r.rolname in ('anon', 'authenticated', 'service_role', 'authenticator', 'postgres')
order by n.nspname, r.rolname;

select
  parent.rolname as granted_role,
  member.rolname as member_role,
  m.admin_option
from pg_auth_members m
join pg_roles parent on parent.oid = m.roleid
join pg_roles member on member.oid = m.member
order by parent.rolname, member.rolname;
```

### 4.6 Check function settings for every SECURITY DEFINER routine

Use query 4.1 output to verify each routine has a fixed safe `search_path`. Inspect the full function definition with `pg_get_functiondef(p.oid)` for every inventory item, then review unqualified object references and dynamic SQL manually. Do not export secrets or application data.

## 5. Negative functional test matrix — isolated environment only

Use synthetic test accounts and synthetic project/document records. Record caller role, caller party, target party, expected result, actual result, SQLSTATE/error, and audit evidence. No real user or production document data.

| ID | Scenario | Expected |
|---|---|---|
| DB-AUTH-01 | Admin attempts submit as a party other than the document originator | Denied |
| DB-AUTH-02 | Admin attempts start review/respond/return as a party other than current workflow party | Denied |
| DB-AUTH-03 | Reviewer from non-current party attempts response | Denied |
| DB-AUTH-04 | Originating contractor attempts review/approval of own document | Denied unless an explicitly approved, separately controlled workflow says otherwise |
| DB-AUTH-05 | Project admin attempts to add self/another user with unauthorized elevated party or role | Denied |
| DB-AUTH-06 | Company member attempts cross-company membership mutation | Denied |
| DB-IMPORT-01 | Import caller changes client-submitted validation status/decision to valid/import | Server recomputes/rejects tampered decision |
| DB-IMPORT-02 | Import caller commits batch owned by another project/user | Denied |
| DB-IMPORT-03 | Import row contains invalid dates, chronology, unknown discipline/code, duplicate/conflict | Server rejects or explicitly stages for review according to approved import policy |
| DB-SCOPE-01 | Child row supplies forged project/company IDs inconsistent with parent | Trigger derives correct scope or rejects; never trusts forged scope |
| DB-SCOPE-02 | Child row references missing parent | Fails closed |
| DB-RLS-01 | Non-member queries another project's documents/revisions/reviews/attachments | No rows / denied |
| DB-DRAFT-01 | Other party reads draft document or draft-linked attachment before formal submission | No rows / denied |
| DB-STORAGE-01 | Member guesses an object path for a hidden draft attachment | Download denied |
| DB-AUDIT-01 | Authorized workflow transition occurs | Actor, timestamp, action and immutable audit record are correct |
| DB-NUM-01 | User previews another project's number | Denied or safely scoped; no sequence consumed |
| DB-NUM-02 | Concurrent number generation in one project/type/discipline | No duplicates; sequence behavior is deterministic |
| DB-WIR-RFI-01 | WIR and RFI records use distinct forms, numbering scopes and workflow paths | No cross-type interpretation |
| DB-MQR-01 | MQR uses its separately approved review path | No default A/B/C/D/E/I code dependency |

The exact expected MQR transition cases remain blocked until the unresolved MQR workflow is explicitly decided. Do not invent an MQR approval model.

## 6. Evidence and exit criteria

The database security gate is not passed until all are true:

- Isolated restore identity and provenance are recorded.
- Query 4.1 inventory is reconciled against the 27-function source inventory; additions/removals/changed signatures are explained.
- Effective ACLs, default privileges, schema privileges, role memberships and owners are reviewed.
- Every SECURITY DEFINER function has a reviewed fixed search path and safe object resolution.
- Priority negative tests pass with raw logs and audit evidence.
- RLS and storage negative tests prove draft confidentiality, not just project membership.
- Findings are classified as pass/fail/not-run/blocked; no unsupported success claims.
- Any required database correction is implemented by the authorized Lovable/database-owner route, reviewed separately, and retested in isolation.
- No production rollout or merge occurs without explicit user approval.

## 7. Source evidence and limitations

Static source hashes at `dev/review-fixes`:

- `drizzle/migrations/0000_core_schema.sql`: `6eeac6f0ddb29d77e0ab1320ac143bab6f834c47`
- `drizzle/migrations/0001_triggers_and_rpcs.sql`: `667f793732f8841c4d8394721eb3128e04181c7f`
- `drizzle/migrations/0002_storage_policies.sql`: `8b49fc98fdeb656a76a10d203187dbd316d06b9f`
- `drizzle/migrations/0003_import_validation_and_kpi_buckets.sql`: `7f72ee1669c28d6724ee433e485c2d7e0208261c`

The inventory is static and limited to those four migration source files at the stated commit. It does not prove the current live schema, function owners, effective ACLs, default privileges, installed extensions, role membership, deployed function bodies, or runtime call paths.
