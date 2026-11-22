# 16 — PostgreSQL Function Privilege & RLS Inventory

**Review type:** Static source review only  
**Reviewed branch:** `dev/review-fixes`  
**Reviewed migrations:** `0000_core_schema.sql`, `0001_triggers_and_rpcs.sql`, `0002_storage_policies.sql`, `0003_import_validation_and_kpi_buckets.sql`  
**Database access:** None. No live grants, roles, policies, or function ACLs were queried.  
**Changes made:** Documentation only; no SQL, application code, schema, or database changes.

## Executive finding

The migration source creates multiple functions, including `SECURITY DEFINER` functions, but the visible migrations do not establish a global default-privilege rule that removes function execution from `PUBLIC`. PostgreSQL grants EXECUTE on newly created functions to `PUBLIC` by default unless altered by database defaults or explicitly revoked.

Several migrations revoke EXECUTE from `anon` only. Revoking from `anon` does **not** revoke the inherited grant to `PUBLIC`; therefore, those statements alone do not prove anonymous execution is blocked. This is a **high-priority privilege-hardening finding to verify against the live database**, not proof that the deployed database currently has the default ACLs.

## Relevant source evidence

### Functions created as SECURITY DEFINER

The source defines the following security-definer permission helpers in `0000_core_schema.sql`:

- `is_company_member(uuid)`
- `is_company_admin(uuid)`
- `project_role_of(uuid)`
- `project_party_of(uuid)`
- `is_project_member(uuid)`
- `can_manage_project(uuid)`
- `can_edit_documents(uuid)`
- `can_comment(uuid)`
- `shares_scope_with(uuid)`

The source also defines security-definer business/RPC functions in `0001_triggers_and_rpcs.sql`, including:

- `create_company(text,text,text)`
- `create_project(uuid,text,text,project_party,text,text,text)`
- `add_project_member(uuid,text,project_party,project_role,text)`
- `transition_document(uuid,text,text,text)`
- `commit_import_rows(uuid,int)`
- `preview_document_number(uuid,uuid,uuid)`

And `0003_import_validation_and_kpi_buckets.sql` adds:

- `add_company_member(uuid,text,company_role)` (SECURITY DEFINER)
- `save_import_validation(uuid,jsonb)` (SECURITY INVOKER)

### Visible EXECUTE revokes

The source contains revokes from `anon` for selected functions, including `create_company`, `create_project`, `add_project_member`, `transition_document`, `commit_import_rows`, `preview_document_number`, `save_import_validation`, and `add_company_member`.

The source also explicitly revokes `resolve_numbering_scheme(uuid,uuid,uuid)` from `PUBLIC, anon, authenticated`. This is materially stronger than revoking from `anon` alone.

No `ALTER DEFAULT PRIVILEGES ... REVOKE EXECUTE` statement was found in the reviewed migration files. The repository source therefore does not demonstrate that future functions are denied to PUBLIC by default.

## Risk interpretation

1. **Anonymous callable surface may remain:** An explicit `REVOKE ... FROM anon` does not remove an EXECUTE grant inherited from PUBLIC. The affected functions may remain callable by the anon database role if the deployed ACLs retain PostgreSQL defaults.
2. **SECURITY DEFINER requires a tighter allowlist:** These functions execute with owner privileges. Their internal authorization checks reduce risk but do not replace explicit EXECUTE ACLs. Permission helpers should be granted only to the roles that need them (normally authenticated, where required by RLS), and business RPCs only to their intended caller roles.
3. **Do not infer direct data exposure from callability alone:** Several RPCs check `auth.uid()` or project/company authorization. The practical impact depends on each function's body, live ACLs, PostgREST exposure, and role context. This review does not claim unauthenticated data access or privilege escalation has been demonstrated.
4. **Trigger functions are a separate case:** Trigger execution privileges and RPC-callable function privileges must be inventoried separately; do not blanket-grant every function merely because it is referenced by a trigger.

## Required live verification (read-only)

Run these only against the confirmed project database, after confirming the correct Supabase project/ref. Do not use a guessed ref.

### 1. Enumerate function ACLs and security mode

```sql
select
  n.nspname as schema_name,
  p.proname as function_name,
  pg_get_function_identity_arguments(p.oid) as identity_arguments,
  p.prosecdef as security_definer,
  coalesce(p.proacl, acldefault('f', p.proowner)) as effective_acl
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
order by p.proname, identity_arguments;
```

### 2. Identify PUBLIC and anon EXECUTE grants

```sql
select
  n.nspname as schema_name,
  p.proname as function_name,
  pg_get_function_identity_arguments(p.oid) as identity_arguments,
  grantee,
  privilege_type
from information_schema.routine_privileges rp
join pg_proc p
  on p.proname = rp.routine_name
join pg_namespace n
  on n.oid = p.pronamespace
where n.nspname = 'public'
  and rp.specific_schema = 'public'
  and privilege_type = 'EXECUTE'
  and grantee in ('PUBLIC', 'anon', 'authenticated')
order by p.proname, grantee;
```

The second query should be reviewed carefully for overloads; use `pg_proc` OIDs and `aclexplode(coalesce(proacl, acldefault('f', proowner)))` for an unambiguous production inventory.

### 3. Inspect default privileges

```sql
select
  defaclrole::regrole as grantor,
  defaclnamespace::regnamespace as schema_name,
  defaclobjtype,
  defaclacl
from pg_default_acl
where defaclobjtype = 'f';
```

### 4. Confirm PostgREST exposed schemas and roles

Verify the configured exposed schemas and database roles in the actual Supabase project settings. Do not assume every public-schema function is reachable through the API merely because it exists.

## Remediation proposal — NOT APPLIED

1. Establish a deliberate function EXECUTE allowlist. Revoke EXECUTE from `PUBLIC` for application functions by default, including future functions through appropriate default privileges for the actual migration owner.
2. Explicitly grant EXECUTE on policy helper functions to `authenticated` only where RLS policies or application queries require it.
3. Explicitly grant intended RPCs to `authenticated` (or a narrower role) after reviewing each function's authorization checks.
4. Keep trigger-only functions non-RPC-callable; do not grant them to API roles.
5. For every `SECURITY DEFINER` function, verify fixed `search_path`, fully qualified object references, authorization checks, and least-privilege owner. The reviewed functions generally set `search_path = public`, but this is not a substitute for ACL control.
6. Add automated catalog assertions that fail if an unintended function has EXECUTE for PUBLIC or anon.
7. Re-run adversarial tests under actual `anon` and `authenticated` JWT contexts after the live ACL inventory and an approved migration.

**Approval boundary:** No ACL or migration changes are authorized by this report. Before any database change, require a verified backup, a tested restore, a reviewed exact migration, and explicit approval.

## Additional RLS observations from static source

- The `documents: members read` policy grants project members SELECT without a draft-state or party condition. This conflicts with the approved requirement that drafts remain invisible to other parties before formal submission, unless another independently verified layer enforces that rule. No such database-layer condition appears in the reviewed policy.
- The `attachments: members read` policy and the Storage SELECT policy both use project membership, not document lifecycle/party visibility. Signed URL and object access behavior still requires live testing.
- `attachments: contributors insert` and Storage INSERT permit users with `can_comment` to upload, but the storage object policy does not bind the object path to an existing attachment row or a specific document/revision. This is a consistency and authorization test requirement, not proof of exploitability.
- Project manager read-all-drafts/read-only access is not represented as a distinct project role in the schema enum reviewed; the current roles are admin, controller, reviewer, viewer.

## Status

- Static source findings recorded.
- Live database ACLs and RLS behavior: **not verified**.
- No migrations or application changes applied.
- No tests, build, or deployment run.
