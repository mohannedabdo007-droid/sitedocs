-- 0006: safe company search, invitation inbox, and multi-company project parties.
-- Supports JV/consortium participants without allowing one company to occupy
-- multiple parties in the same project. Apply only through the reviewed migration workflow.

-- A project party may represent a JV/consortium of several companies.
alter table public.project_party_companies
  drop constraint if exists project_party_companies_one_company_per_party;

drop index if exists public.project_company_invitation_pending_party_uidx;

-- Keep one pending invitation per invited company/project. Multiple companies
-- may receive invitations for the same party.
create index if not exists project_party_companies_party_lookup_idx
  on public.project_party_companies(project_id, party);

-- Search is intentionally scoped to a project and returns only companies that
-- the authorized project/owner administrators may invite.
create or replace function public.search_companies_for_project_invitation(
  _project uuid,
  _query text
)
returns table (
  id uuid,
  code text,
  name text,
  name_ar text
)
language plpgsql
stable
security definer
set search_path = public, pg_temp
as $$
declare
  v_owner_company uuid;
  v_query text := lower(btrim(coalesce(_query, '')));
begin
  if auth.uid() is null then
    raise exception 'NOT_AUTHENTICATED';
  end if;
  if length(v_query) < 3 or length(v_query) > 80 then
    return;
  end if;

  select p.company_id into v_owner_company
    from public.projects p
   where p.id = _project;
  if v_owner_company is null
     or not public.can_manage_project(_project)
     or not public.is_company_admin(v_owner_company) then
    raise exception 'FORBIDDEN';
  end if;

  return query
  select c.id, c.code, c.name, c.name_ar
    from public.companies c
   where c.id <> v_owner_company
     and (
       position(v_query in lower(c.name)) > 0
       or position(v_query in lower(coalesce(c.name_ar, ''))) > 0
       or position(v_query in lower(c.code)) > 0
     )
     and not exists (
       select 1 from public.project_party_companies ppc
        where ppc.project_id = _project
          and ppc.participant_company_id = c.id
     )
     and not exists (
       select 1 from public.project_company_invitations i
        where i.project_id = _project
          and i.invited_company_id = c.id
          and i.status = 'pending'
          and i.expires_at > now()
     )
   order by c.name
   limit 20;
end
$$;

-- The inbox returns only invitations for which the current user is an
-- authorized administrator of the invited company, or a project+owner admin.
create or replace function public.list_project_company_invitations(
  _project uuid default null
)
returns table (
  id uuid,
  project_id uuid,
  project_code text,
  project_name text,
  owner_company_name text,
  invited_company_name text,
  party public.project_party,
  status text,
  expires_at timestamptz,
  created_at timestamptz,
  direction text,
  can_respond boolean,
  can_revoke boolean
)
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select
    i.id,
    i.project_id,
    p.code,
    p.name,
    owner_company.name,
    invited_company.name,
    i.party,
    case when i.status = 'pending' and i.expires_at <= now() then 'expired' else i.status end,
    i.expires_at,
    i.created_at,
    case
      when public.is_company_admin(i.invited_company_id) then 'received'
      else 'sent'
    end,
    (i.status = 'pending' and i.expires_at > now() and public.is_company_admin(i.invited_company_id)),
    (i.status = 'pending' and i.expires_at > now()
      and public.can_manage_project(i.project_id)
      and public.is_company_admin(i.project_company_id))
  from public.project_company_invitations i
  join public.projects p on p.id = i.project_id
  join public.companies owner_company on owner_company.id = i.project_company_id
  join public.companies invited_company on invited_company.id = i.invited_company_id
  where auth.uid() is not null
    and (_project is null or i.project_id = _project)
    and (
      public.is_company_admin(i.invited_company_id)
      or (
        public.can_manage_project(i.project_id)
        and public.is_company_admin(i.project_company_id)
      )
    )
  order by i.created_at desc
  limit 200
$$;

-- Allow additional companies to join a party that already has an accepted
-- participant; a company may still be assigned only once per project.
create or replace function public.invite_project_company(
  _project uuid,
  _invited_company uuid,
  _party public.project_party,
  _expires_at timestamptz default (now() + interval '30 days')
)
returns uuid
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_project_company uuid;
  v_invitation uuid;
begin
  select company_id into v_project_company
    from public.projects where id = _project for update;
  if v_project_company is null then raise exception 'PROJECT_NOT_FOUND'; end if;
  if not public.can_manage_project(_project)
     or not public.is_company_admin(v_project_company) then
    raise exception 'FORBIDDEN';
  end if;
  if _invited_company = v_project_company then raise exception 'CANNOT_INVITE_OWN_COMPANY'; end if;
  if _expires_at <= now() or _expires_at > now() + interval '90 days' then
    raise exception 'INVALID_EXPIRY';
  end if;
  if not exists (select 1 from public.companies where id = _invited_company) then
    raise exception 'COMPANY_NOT_FOUND';
  end if;

  with expired as (
    update public.project_company_invitations
       set status = 'expired', responded_at = now()
     where project_id = _project
       and status = 'pending'
       and expires_at <= now()
       and (party = _party or invited_company_id = _invited_company)
    returning id, invited_company_id, party
  )
  insert into public.project_membership_events
    (project_id, project_company_id, actor_user_id, action,
     participant_company_id, party, invitation_id, reason)
  select _project, v_project_company, auth.uid(), 'company_invitation_expired',
         invited_company_id, party, id,
         'Expired automatically when a replacement invitation was created'
    from expired;

  if exists (
    select 1 from public.project_party_companies
     where project_id = _project
       and participant_company_id = _invited_company
  ) then
    raise exception 'COMPANY_ALREADY_ASSIGNED';
  end if;
  if exists (
    select 1 from public.project_company_invitations
     where project_id = _project
       and invited_company_id = _invited_company
       and status = 'pending'
  ) then
    raise exception 'COMPANY_INVITATION_ALREADY_PENDING';
  end if;

  insert into public.project_company_invitations
    (project_id, project_company_id, invited_company_id, party, invited_by, expires_at)
  values (_project, v_project_company, _invited_company, _party, auth.uid(), _expires_at)
  returning id into v_invitation;

  insert into public.project_membership_events
    (project_id, project_company_id, actor_user_id, action,
     participant_company_id, party, invitation_id)
  values (_project, v_project_company, auth.uid(), 'company_invited',
          _invited_company, _party, v_invitation);

  return v_invitation;
end
$$;

-- Rebuild add_project_member so party membership can resolve one company
-- explicitly when a party represents multiple JV/consortium participants.
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

  select id into v_user
    from public.profiles
   where lower(email) = lower(btrim(_email))
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
    (project_id, company_id, user_id, party, role, organization)
  values
    (_project, v_project_company, v_user, _party, _role, nullif(btrim(_organization), ''))
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

-- Serialize acceptance against other project-party/company link operations.
create or replace function public.accept_project_company_invitation(_invitation uuid)
returns uuid
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_inv public.project_company_invitations;
  v_link uuid;
  v_project_id uuid;
begin
  select project_id into v_project_id
    from public.project_company_invitations
   where id = _invitation;
  if v_project_id is null then raise exception 'INVITATION_NOT_FOUND'; end if;

  -- Lock order is project first, invitation second, matching invite_project_company.
  perform 1 from public.projects where id = v_project_id for update;

  select * into v_inv
    from public.project_company_invitations
   where id = _invitation
   for update;
  if not found then raise exception 'INVITATION_NOT_FOUND'; end if;
  if not public.is_company_admin(v_inv.invited_company_id) then raise exception 'FORBIDDEN'; end if;
  if v_inv.status <> 'pending' then raise exception 'INVITATION_NOT_PENDING'; end if;

  if v_inv.expires_at <= now() then
    update public.project_company_invitations
       set status = 'expired', responded_at = now()
     where id = _invitation;
    insert into public.project_membership_events
      (project_id, project_company_id, actor_user_id, action,
       participant_company_id, party, invitation_id, reason)
    values (v_inv.project_id, v_inv.project_company_id, auth.uid(), 'company_invitation_expired',
            v_inv.invited_company_id, v_inv.party, v_inv.id, 'Expired before company acceptance');
    return null;
  end if;

  if exists (
    select 1 from public.project_party_companies
     where project_id = v_inv.project_id
       and participant_company_id = v_inv.invited_company_id
  ) then
    raise exception 'COMPANY_ALREADY_ASSIGNED';
  end if;

  insert into public.project_party_companies
    (project_id, project_company_id, participant_company_id, party, invitation_id, linked_by)
  values
    (v_inv.project_id, v_inv.project_company_id, v_inv.invited_company_id,
     v_inv.party, v_inv.id, auth.uid())
  returning id into v_link;

  update public.project_company_invitations
     set status = 'accepted', accepted_by = auth.uid(),
         accepted_at = now(), responded_at = now()
   where id = _invitation;

  insert into public.project_membership_events
    (project_id, project_company_id, actor_user_id, action,
     participant_company_id, party, invitation_id)
  values
    (v_inv.project_id, v_inv.project_company_id, auth.uid(), 'company_invitation_accepted',
     v_inv.invited_company_id, v_inv.party, v_inv.id);

  return v_link;
end
$$;

-- The functions are deliberately callable only by signed-in users. Every
-- security-definer function performs its own authorization check.
revoke all on function public.search_companies_for_project_invitation(uuid, text) from public, anon;
grant execute on function public.search_companies_for_project_invitation(uuid, text) to authenticated;
revoke all on function public.list_project_company_invitations(uuid) from public, anon;
grant execute on function public.list_project_company_invitations(uuid) to authenticated;
revoke all on function public.add_project_member(uuid, text, public.project_party, public.project_role, text, uuid) from public, anon;
grant execute on function public.add_project_member(uuid, text, public.project_party, public.project_role, text, uuid) to authenticated;
revoke all on function public.accept_project_company_invitation(uuid) from public, anon;
grant execute on function public.accept_project_company_invitation(uuid) to authenticated;

notify pgrst, 'reload schema';
