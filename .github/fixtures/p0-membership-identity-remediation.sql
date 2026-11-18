-- TEST-ONLY candidate remediation. This file is not a database migration and
-- must never be applied to a live database. It is executed only by the
-- disposable PostgreSQL regression job to validate the proposed behavior.
create or replace function public.add_project_member(
  _project uuid,
  _email text,
  _party public.project_party,
  _role public.project_role,
  _organization text default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  uid uuid;
  matched_count integer;
  mid uuid;
begin
  if not public.can_manage_project(_project) then
    raise exception 'FORBIDDEN';
  end if;

  select count(*), (array_agg(u.id))[1]
    into matched_count, uid
    from auth.users u
   where lower(btrim(u.email)) = lower(btrim(_email))
     and u.email_confirmed_at is not null
     and u.deleted_at is null
     and u.is_anonymous = false;

  if matched_count <> 1 then
    raise exception 'USER_NOT_FOUND';
  end if;

  insert into public.project_members (
    project_id, company_id, user_id, party, role, organization
  )
  values (
    _project,
    (select p.company_id from public.projects p where p.id = _project),
    uid,
    _party,
    _role,
    nullif(btrim(_organization), '')
  )
  on conflict (project_id, user_id) do update
    set party = excluded.party,
        role = excluded.role,
        organization = excluded.organization
  returning id into mid;

  return mid;
end;
$$;

create or replace function public.add_company_member(
  _company uuid,
  _email text,
  _role public.company_role
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  uid uuid;
  matched_count integer;
  mid uuid;
begin
  if not public.is_company_admin(_company) then
    raise exception 'FORBIDDEN';
  end if;
  if _role = 'owner' then
    raise exception 'FORBIDDEN';
  end if;

  select count(*), (array_agg(u.id))[1]
    into matched_count, uid
    from auth.users u
   where lower(btrim(u.email)) = lower(btrim(_email))
     and u.email_confirmed_at is not null
     and u.deleted_at is null
     and u.is_anonymous = false;

  if matched_count <> 1 then
    raise exception 'USER_NOT_FOUND';
  end if;

  insert into public.company_members (company_id, user_id, role)
  values (_company, uid, _role)
  on conflict (company_id, user_id) do update
    set role = excluded.role
  where public.company_members.role <> 'owner'
  returning id into mid;

  return mid;
end;
$$;

-- Keep row ownership RLS. Table-level and pre-existing column-level grants are
-- independent, so revoke both identity-column grants explicitly.
revoke update on table public.profiles from authenticated;
revoke update (email, id) on table public.profiles from authenticated;
grant update (full_name, locale) on table public.profiles to authenticated;

-- Auth is authoritative. Profile email changes only after the Auth record
-- itself changes to a confirmed address; deleted/no-email accounts are cleared.
create or replace function public.sync_profile_email_from_auth()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.deleted_at is not null
     or new.email is null
     or new.email_confirmed_at is null
     or new.is_anonymous then
    update public.profiles
       set email = null
     where id = new.id;
  elsif new.email_confirmed_at is not null
        and new.is_anonymous = false then
    insert into public.profiles (id, email)
    values (new.id, new.email)
    on conflict (id) do update
      set email = excluded.email;
  end if;
  return new;
end;
$$;

revoke all on function public.sync_profile_email_from_auth()
  from public, anon, authenticated;

drop trigger if exists sync_profile_email_after_auth_change on auth.users;
create trigger sync_profile_email_after_auth_change
after update of email, email_confirmed_at, deleted_at, is_anonymous on auth.users
for each row
when (new.email is distinct from old.email
   or new.email_confirmed_at is distinct from old.email_confirmed_at
   or new.deleted_at is distinct from old.deleted_at
   or new.is_anonymous is distinct from old.is_anonymous)
execute function public.sync_profile_email_from_auth();
