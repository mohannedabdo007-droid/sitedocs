#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MIGRATIONS="$ROOT/drizzle/migrations"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Load the exact RPC definitions from the repository migrations. The test
# fixture supplies only the minimum Supabase objects those two RPCs require.
awk '/^create or replace function public.add_project_member\\(/ { capture=1 } capture { print } capture && /^end \\$\\$;/ { exit }' \
  "$MIGRATIONS/0001_triggers_and_rpcs.sql" > "$TMP_DIR/add_project_member.sql"
awk '/^create or replace function public.add_company_member\\(/ { capture=1 } capture { print } capture && /^end \\$\\$;/ { exit }' \
  "$MIGRATIONS/0003_import_validation_and_kpi_buckets.sql" > "$TMP_DIR/add_company_member.sql"

grep -q 'create or replace function public.add_project_member' "$TMP_DIR/add_project_member.sql"
grep -q 'create or replace function public.add_company_member' "$TMP_DIR/add_company_member.sql"

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 <<'SQL'
create schema auth;
create role authenticated nologin;
create role anon nologin;
create type public.company_role as enum ('owner', 'admin', 'member');
create type public.project_party as enum ('contractor', 'consultant', 'owner', 'pmc');
create type public.project_role as enum ('admin', 'controller', 'reviewer', 'viewer');

create table auth.users (
  id uuid primary key,
  email text unique,
  email_confirmed_at timestamptz
);
create table public.profiles (
  id uuid primary key references auth.users(id),
  email text
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
SQL

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "$TMP_DIR/add_project_member.sql"
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f "$TMP_DIR/add_company_member.sql"

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 <<'SQL'
-- Synthetic identities: A's profile is spoofed to B's Auth email. B's profile
-- deliberately contains a stale email to prove Auth identity is authoritative.
insert into auth.users (id, email, email_confirmed_at) values
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'attacker@example.com', now()),
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'victim@example.com', now()),
  ('cccccccc-cccc-4ccc-8ccc-cccccccccccc', 'unconfirmed@example.com', null);

insert into public.profiles (id, email) values
  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'victim@example.com'),
  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'old-victim-address@example.net'),
  ('cccccccc-cccc-4ccc-8ccc-cccccccccccc', 'unconfirmed@example.com');

insert into public.companies (id)
values ('dddddddd-dddd-4ddd-8ddd-dddddddddddd');
insert into public.projects (id, company_id)
values (
  'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee',
  'dddddddd-dddd-4ddd-8ddd-dddddddddddd'
);

set role authenticated;
select public.add_project_member(
  'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee',
  ' Victim@Example.com ',
  'contractor',
  'viewer',
  null
);
select public.add_company_member(
  'dddddddd-dddd-4ddd-8ddd-dddddddddddd',
  'VICTIM@example.com',
  'member'
);

do $$
begin
  if not exists (
    select 1 from public.project_members
     where project_id = 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee'
       and user_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'
  ) then
    raise exception 'P0_FAIL project membership resolved mutable profile email instead of confirmed Auth identity';
  end if;
  if exists (
    select 1 from public.project_members
     where project_id = 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee'
       and user_id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'
  ) then
    raise exception 'P0_FAIL attacker received project membership through spoofed profile email';
  end if;
  if not exists (
    select 1 from public.company_members
     where company_id = 'dddddddd-dddd-4ddd-8ddd-dddddddddddd'
       and user_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'
  ) then
    raise exception 'P0_FAIL company membership resolved mutable profile email instead of confirmed Auth identity';
  end if;
  if exists (
    select 1 from public.company_members
     where company_id = 'dddddddd-dddd-4ddd-8ddd-dddddddddddd'
       and user_id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'
  ) then
    raise exception 'P0_FAIL attacker received company membership through spoofed profile email';
  end if;
end
$$;

do $$
begin
  begin
    perform public.add_project_member(
      'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee',
      'unconfirmed@example.com',
      'contractor',
      'viewer',
      null
    );
    raise exception 'P0_FAIL unconfirmed Auth email was accepted for project membership';
  exception when others then
    if sqlerrm = 'P0_FAIL unconfirmed Auth email was accepted for project membership' then
      raise;
    end if;
    if sqlerrm <> 'USER_NOT_FOUND' then raise; end if;
  end;

  begin
    perform public.add_company_member(
      'dddddddd-dddd-4ddd-8ddd-dddddddddddd',
      'unconfirmed@example.com',
      'member'
    );
    raise exception 'P0_FAIL unconfirmed Auth email was accepted for company membership';
  exception when others then
    if sqlerrm = 'P0_FAIL unconfirmed Auth email was accepted for company membership' then
      raise;
    end if;
    if sqlerrm <> 'USER_NOT_FOUND' then raise; end if;
  end;
end
$$;
reset role;
SQL

echo "P0 membership identity regression checks passed."
