-- P0 identity hardening: membership RPCs must resolve verified Auth identities.
-- profiles.email is presentation/cache data and is not an identity authority.

create or replace function public.add_company_member(
  _company uuid,
  _email text,
  _role public.company_role
)
returns uuid
language plpgsql
security definer
set search_path = public, auth, pg_temp
as $$
declare
  v_user uuid;
  v_member_id uuid;
begin
  if not public.is_company_admin(_company) then
    raise exception 'FORBIDDEN';
  end if;
  if _role = 'owner' then
    raise exception 'FORBIDDEN';
  end if;

  select u.id into v_user
    from auth.users u
   where lower(u.email) = lower(btrim(_email))
     and u.email_confirmed_at is not null
   limit 1;

  if v_user is null then
    raise exception 'USER_NOT_FOUND';
  end if;

  insert into public.company_members (company_id, user_id, role)
  values (_company, v_user, _role)
  on conflict (company_id, user_id) do update
    set role = excluded.role
  where public.company_members.role <> 'owner'
  returning id into v_member_id;

  return v_member_id;
end
$$;

revoke all on function public.add_company_member(uuid, text, public.company_role) from public, anon;
grant execute on function public.add_company_member(uuid, text, public.company_role) to authenticated;

create or replace function public.add_project_member(
  _project uuid,
  _email text,
  _party public.project_party,
  _role public.project_role,
  _organization text default null,
  _member_company uuid default null
)
returns uuid
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_project_company uuid;
  v_member_company uuid;
  v_user uuid;
  v_member_id uuid;
  v_owner_party public.project_party;
  v_acceptance_required boolean;
  v_party_company_count integer;
begin
  select company_id into v_project_company
    from public.projects where id = _project for update;
  if v_project_company is null then raise exception 'PROJECT_NOT_FOUND'; end if;
  if not public.can_manage_project(_project) then raise exception 'FORBIDDEN'; end if;

  select count(*), (array_agg(participant_company_id))[1]
    into v_party_company_count, v_member_company
    from public.project_party_companies
   where project_id = _project and party = _party;

  select coalesce(
    (select external_company_acceptance_required
       from public.project_membership_policies where project_id = _project),
    true
  ) into v_acceptance_required;

  if _member_company is not null then
    if exists (
      select 1 from public.project_party_companies
       where project_id = _project
         and party = _party
         and participant_company_id = _member_company
    ) then
      v_member_company := _member_company;
    else
      if v_acceptance_required then
        raise exception 'COMPANY_ACCEPTANCE_REQUIRED';
      end if;
      if not public.is_company_admin(v_project_company) then
        raise exception 'ONLY_OWNING_COMPANY_ADMIN_CAN_LINK_COMPANY';
      end if;
      if _member_company = v_project_company then
        raise exception 'OWNING_COMPANY_PARTY_ALREADY_DEFINED';
      end if;
      if not exists (select 1 from public.companies where id = _member_company) then
        raise exception 'MEMBER_NOT_ELIGIBLE';
      end if;
      if exists (
        select 1 from public.project_party_companies
         where project_id = _project
           and participant_company_id = _member_company
      ) then
        raise exception 'COMPANY_ALREADY_ASSIGNED';
      end if;

      insert into public.project_party_companies
        (project_id, project_company_id, participant_company_id, party, linked_by)
      values (_project, v_project_company, _member_company, _party, auth.uid());

      insert into public.project_membership_events
        (project_id, project_company_id, actor_user_id, action,
         participant_company_id, party, reason)
      values (_project, v_project_company, auth.uid(), 'company_linked_by_project_admin',
              _member_company, _party, 'Approved under project membership policy');
      v_member_company := _member_company;
    end if;
  else
    if v_party_company_count = 0 then
      if v_acceptance_required then
        raise exception 'COMPANY_ACCEPTANCE_REQUIRED';
      end if;
      raise exception 'MEMBER_COMPANY_REQUIRED';
    elsif v_party_company_count > 1 then
      raise exception 'MEMBER_COMPANY_REQUIRED';
    end if;
  end if;

  -- Resolve identity only from Supabase Auth, never from mutable profile data.
  select u.id into v_user
    from auth.users u
   where lower(u.email) = lower(btrim(_email))
     and u.email_confirmed_at is not null
   limit 1;
  if v_user is null or not exists (
    select 1 from public.company_members
     where company_id = v_member_company and user_id = v_user
  ) then
    raise exception 'MEMBER_NOT_ELIGIBLE';
  end if;

  if _role = 'admin' then
    select party into v_owner_party
      from public.project_party_companies
     where project_id = _project and participant_company_id = v_project_company;
    if v_member_company <> v_project_company
       or not public.is_company_admin(v_project_company)
       or _party is distinct from v_owner_party then
      raise exception 'ONLY_OWNING_COMPANY_ADMIN_CAN_ASSIGN_PROJECT_ADMIN';
    end if;
  end if;

  insert into public.project_members
    (project_id, company_id, participant_company_id, user_id, party, role, organization)
  values
    (_project, v_project_company, v_member_company, v_user, _party, _role, nullif(btrim(_organization), ''))
  returning id into v_member_id;

  insert into public.project_membership_events
    (project_id, project_company_id, actor_user_id, action,
     participant_company_id, party, member_user_id)
  values
    (_project, v_project_company, auth.uid(), 'member_added',
     v_member_company, _party, v_user);

  return v_member_id;
end
$$;



comment on function public.add_company_member(uuid, text, public.company_role) is
  'Adds a company member by matching a verified Supabase Auth email; mutable profiles.email is never used for identity resolution.';
comment on function public.add_project_member(uuid, text, public.project_party, public.project_role, text, uuid) is
  'Adds a project member only when the supplied email resolves to a verified Supabase Auth user who belongs to the selected participant company.';

notify pgrst, 'reload schema';
