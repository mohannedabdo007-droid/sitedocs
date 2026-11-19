#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MIGRATIONS="$ROOT/drizzle/migrations"
FIXTURE="$ROOT/.github/fixtures/p0-membership-identity-remediation.sql"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Load the exact existing RPC definitions first, then apply a test-only
# candidate patch. The candidate is never applied to a live database.
awk 'index($0, "create or replace function public.add_project_member(") { capture=1 } capture { print } capture && $0 == "end $$;" { exit }' \
  "$MIGRATIONS/0001_triggers_and_rpcs.sql" > "$TMP_DIR/add_project_member.sql"
awk 'index($0, "create or replace function public.add_company_member(") { capture=1 } capture { print } capture && $0 == "end $$;" { exit }' \
  "$MIGRATIONS/0003_import_validation_and_kpi_buckets.sql" > "$TMP_DIR/add_company_member.sql"

grep -q 'create or replace function public.add_project_member' "$TMP_DIR/add_project_member.sql"
grep -q 'create or replace function public.add_company_member' "$TMP_DIR/add_company_member.sql"
test -s "$FIXTURE"

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 <<'SQL'
create schema auth;
create role authenticated nologin;
create role anon nologin;
create type public.company_role as enum ('owner', 'admin', 'member');
create type public.project_party as enum ('contractor', 'consultant', 'owner', 'pmc');
create type public.project_role as enum ('admin', 'controller', 'reviewer', 'viewer');

-- Deliberately omit email uniqueness so normalized ambiguity is exercised.
create table auth.users (
  id uuid primary key,
  email text,
  email_confirmed_at timestamptz,
  email_change text,
  deleted_at timestamptz,
  is_anonymous boolean not null default false
);
create table public.profiles (
  id uuid primary key references auth.users(id),
  email text,
  full_name text,
  locale text not null default 'ar'
);
create table public.companies (id uuid primary key);
create table public.projects (
  id uuid primary key,
  company_id uuid not null references public.companies(id)
);
create table public.project_members (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id),
  company_id uuid not null references public.companies(id),
  user_id uuid not null,
  party public.project_party not null,
  role public.project_role not null,
  organization text,
  unique (project_id, user_id)
);
create table public.company_members (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id),
  user_id uuid not null,
  role public.company_role not null,
  unique (company_id, user_id)
);

create function public.can_manage_project(uuid)
returns boolean language sql stable as $$ select true $$;
create function public.is_company_admin(uuid)
returns boolean language sql stable as $$ select true $$;
grant usage on schema auth to authenticated;
grant usage on type public.company_role, public.project_party, public.project_role to authenticated;
grant select, insert, update on public.project_members, public.company_members to authenticated;
-- Simulate both unsafe table-level and pre-existing column-level grants.
-- REVOKE UPDATE on the table alone must not be assumed to clear these.
grant select, insert, update on public.profiles to authenticated;
grant update (email, id) on public.profiles to authenticated;
SQL

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "$TMP_DIR/add_project_member.sql"
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "$TMP_DIR/add_company_member.sql"
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "$FIXTURE"

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 <<'SQL'
insert into auth.users (id, email, email_confirmed_at, is_anonymous) values
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'attacker@example.com', now(), false),
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'victim@example.com', now(), false),
  ('cccccccc-cccc-4ccc-8ccc-cccccccccccc', 'unconfirmed@example.com', null, false),
  ('dddddddd-dddd-4ddd-8ddd-dddddddddddd', null, null, false),
  ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee', 'ambiguous@example.com', now(), false),
  ('ffffffff-ffff-4fff-8fff-ffffffffffff', 'AMBIGUOUS@example.com', now(), false),
  ('99999999-9999-4999-8999-999999999999', 'owner@example.com', now(), false),
  ('77777777-7777-4777-8777-777777777777', 'deleted@example.com', now(), false);

update auth.users set deleted_at = now()
 where id = '77777777-7777-4777-8777-777777777777';

insert into public.profiles (id, email) values
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'victim@example.com'),
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'old-victim-address@example.net'),
  ('cccccccc-cccc-4ccc-8ccc-cccccccccccc', 'unconfirmed@example.com'),
  ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee', 'ambiguous@example.com'),
  ('ffffffff-ffff-4fff-8fff-ffffffffffff', 'ambiguous@example.com'),
  ('99999999-9999-4999-8999-999999999999', 'owner@example.com');

insert into public.companies (id)
values ('11111111-1111-4111-8111-111111111111');
insert into public.projects (id, company_id)
values (
  '22222222-2222-4222-8222-222222222222',
  '11111111-1111-4111-8111-111111111111'
);
insert into public.company_members (company_id, user_id, role)
values (
  '11111111-1111-4111-8111-111111111111',
  '99999999-9999-4999-8999-999999999999',
  'owner'
);

-- Email and identity columns must no longer be directly writable by clients.
do $$
begin
  if has_column_privilege('authenticated', 'public.profiles', 'email', 'UPDATE')
     or has_column_privilege('authenticated', 'public.profiles', 'id', 'UPDATE') then
    raise exception 'P0_FAIL authenticated retains UPDATE on profile identity columns';
  end if;
  if not has_column_privilege('authenticated', 'public.profiles', 'full_name', 'UPDATE')
     or not has_column_privilege('authenticated', 'public.profiles', 'locale', 'UPDATE') then
    raise exception 'P0_FAIL safe profile fields lost UPDATE privilege';
  end if;
end
$$;

set role authenticated;

do $priv$
begin
  begin
    update public.profiles
       set email = 'victim@example.com'
     where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
    raise exception 'P0_FAIL authenticated directly changed profile email';
  exception when insufficient_privilege then
    null;
  end;

  begin
    update public.profiles
       set id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'
     where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
    raise exception 'P0_FAIL authenticated directly changed profile identity ID';
  exception when insufficient_privilege then
    null;
  end;
end
$priv$;

update public.profiles
   set full_name = 'Attacker Display Name', locale = 'en'
 where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';

-- A forged profile email must not redirect a membership to the attacker.
select public.add_project_member(
  '22222222-2222-4222-8222-222222222222',
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
  'contractor',
  'viewer',
  'Initial Org'
);
select public.add_company_member(
  '11111111-1111-4111-8111-111111111111',
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
  'member'
);

do $$
declare project_member_id uuid;
begin
  select id into project_member_id from public.project_members
   where project_id = '22222222-2222-4222-8222-222222222222'
     and user_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
  if project_member_id is null then
    raise exception 'P0_FAIL project membership did not resolve confirmed Auth identity';
  end if;
  if exists (
    select 1 from public.project_members
     where project_id = '22222222-2222-4222-8222-222222222222'
       and user_id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'
  ) then
    raise exception 'P0_FAIL attacker received project membership through spoofed profile email';
  end if;
  if not exists (
    select 1 from public.company_members
     where company_id = '11111111-1111-4111-8111-111111111111'
       and user_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'
  ) then
    raise exception 'P0_FAIL company membership did not resolve confirmed Auth identity';
  end if;
  if exists (
    select 1 from public.company_members
     where company_id = '11111111-1111-4111-8111-111111111111'
       and user_id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'
  ) then
    raise exception 'P0_FAIL attacker received company membership through spoofed profile email';
  end if;

  -- Project upsert keeps the membership ID while updating approved fields.
  perform public.add_project_member(
    '22222222-2222-4222-8222-222222222222',
    'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
    'consultant',
    'reviewer',
    'Updated Org'
  );
  if (select count(*) from public.project_members
       where project_id = '22222222-2222-4222-8222-222222222222'
         and user_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb') <> 1
     or (select id from public.project_members
          where project_id = '22222222-2222-4222-8222-222222222222'
            and user_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb') <> project_member_id
     or (select party from public.project_members where id = project_member_id) <> 'consultant'
     or (select role from public.project_members where id = project_member_id) <> 'reviewer'
     or (select organization from public.project_members where id = project_member_id) <> 'Updated Org' then
    raise exception 'P0_FAIL project membership upsert behavior changed';
  end if;

  perform public.add_company_member(
    '11111111-1111-4111-8111-111111111111',
    'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
    'admin'
  );
  if (select role from public.company_members
       where company_id = '11111111-1111-4111-8111-111111111111'
         and user_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb') <> 'admin' then
    raise exception 'P0_FAIL company membership role upsert behavior changed';
  end if;
  perform public.add_company_member(
    '11111111-1111-4111-8111-111111111111',
    '99999999-9999-4999-8999-999999999999',
    'admin'
  );
  if (select role from public.company_members
       where company_id = '11111111-1111-4111-8111-111111111111'
         and user_id = '99999999-9999-4999-8999-999999999999') <> 'owner' then
    raise exception 'P0_FAIL company owner was downgraded';
  end if;
end
$$;

-- Mark the spoofing attacker anonymous before negative identity checks.
update auth.users set is_anonymous = true
 where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';

-- Unknown, unconfirmed, missing-email, deleted, and anonymous Auth IDs fail closed.
do $
declare supplied_user_id uuid;
begin
  foreach supplied_user_id in array array[
    'cccccccc-cccc-4ccc-8ccc-cccccccccccc'::uuid,
    'dddddddd-dddd-4ddd-8ddd-dddddddddddd'::uuid,
    'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee'::uuid,
    'ffffffff-ffff-4fff-8fff-ffffffffffff'::uuid,
    '77777777-7777-4777-8777-777777777777'::uuid
  ] loop
    begin
      perform public.add_project_member(
        '22222222-2222-4222-8222-222222222222',
        supplied_user_id,
        'contractor',
        'viewer',
        null
      );
      raise exception 'P0_FAIL ineligible Auth ID accepted for project membership: %', supplied_user_id;
    exception when others then
      if sqlerrm like 'P0_FAIL ineligible Auth ID accepted%' then raise; end if;
      if sqlerrm <> 'USER_NOT_FOUND' then raise; end if;
    end;
    begin
      perform public.add_company_member(
        '11111111-1111-4111-8111-111111111111',
        supplied_user_id,
        'member'
      );
      raise exception 'P0_FAIL ineligible Auth ID accepted for company membership: %', supplied_user_id;
    exception when others then
      if sqlerrm like 'P0_FAIL ineligible Auth ID accepted%' then raise; end if;
      if sqlerrm <> 'USER_NOT_FOUND' then raise; end if;
    end;
  end loop;
end
$$;

do $$
begin
  begin
    perform public.add_company_member(
      '11111111-1111-4111-8111-111111111111',
      'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
      'owner'
    );
    raise exception 'P0_FAIL owner role assignment was accepted';
  exception when others then
    if sqlerrm = 'P0_FAIL owner role assignment was accepted' then raise; end if;
    if sqlerrm <> 'FORBIDDEN' then raise; end if;
  end;
end
$$;

reset role;

-- Anonymous Auth identities must not retain a trusted profile email.
update auth.users
   set is_anonymous = true
 where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
do $anon$
begin
  if (select email from public.profiles
       where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa') is not null then
    raise exception 'P0_FAIL anonymous Auth identity retained profile email';
  end if;
end
$anon$;

update auth.users
   set is_anonymous = false
 where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
do $anon_restore$
begin
  if (select email from public.profiles
       where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa') <> 'attacker@example.com' then
    raise exception 'P0_FAIL permanent Auth identity did not restore trusted profile email';
  end if;
end
$anon_restore$;

-- Pending email change must not replace the profile email. Once Auth commits
-- the confirmed email, the trusted trigger synchronizes the profile.
update auth.users
   set email_change = 'new-victim@example.net'
 where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
do $$
begin
  if (select email from public.profiles
       where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb') <> 'old-victim-address@example.net' then
    raise exception 'P0_FAIL pending Auth email change was prematurely synchronized';
  end if;
end
$$;

-- GoTrue keeps the current email in place while the new address is pending.
-- Once the email-change OTP is confirmed, it commits email_change into email.
-- Existing confirmed users may retain their original email_confirmed_at value.
update auth.users
   set email = email_change,
       email_change = null
 where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
do $confirm$
begin
  if (select email from public.profiles
       where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb') <> 'new-victim@example.net' then
    raise exception 'P0_FAIL confirmed Auth email change did not synchronize to profile';
  end if;
  if (select email_confirmed_at from auth.users
       where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb') is null then
    raise exception 'P0_FAIL confirmed Auth identity unexpectedly lost its confirmation timestamp';
  end if;
end
$confirm$;

update auth.users
   set email = 'unconfirmed-new-address@example.net',
       email_confirmed_at = null
 where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
do $unconfirmed$
begin
  if (select email from public.profiles
       where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb') is not null then
    raise exception 'P0_FAIL Auth email that became unconfirmed retained the old profile email';
  end if;
end
$unconfirmed$;

-- A later confirmation-only update must restore the newly trusted Auth email.
update auth.users
   set email_confirmed_at = now()
 where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
do $unconfirmed$
begin
  if (select email from public.profiles
       where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb') <> 'unconfirmed-new-address@example.net' then
    raise exception 'P0_FAIL confirmation-only update did not synchronize the newly confirmed Auth email';
  end if;
end
$unconfirmed$;

update auth.users
   set deleted_at = now()
 where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
do $$
begin
  if (select email from public.profiles
       where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb') is not null then
    raise exception 'P0_FAIL deleted Auth identity retained a profile email';
  end if;
end
$$;

SQL

echo "P0 candidate identity remediation PostgreSQL regression checks passed."
