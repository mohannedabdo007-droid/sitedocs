-- 0005: Explicit company acceptance for cross-company project membership.
-- Default policy: an external company must accept an invitation before its users
-- can be assigned to a project party. No live database should receive this
-- migration until it has been reviewed and tested on an isolated restored DB.

alter table public.projects
  add constraint projects_id_company_unique unique (id, company_id);

create table public.project_membership_policies (
  project_id uuid primary key references public.projects(id) on delete cascade,
  external_company_acceptance_required boolean not null default true,
  updated_by uuid,
  updated_at timestamptz not null default now(),
  change_reason text
);
alter table public.project_membership_policies enable row level security;
grant select on public.project_membership_policies to authenticated;
insert into public.project_membership_policies (project_id)
select id from public.projects
on conflict (project_id) do nothing;

create or replace function public.create_default_project_membership_policy()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.project_membership_policies (project_id)
  values (new.id)
  on conflict (project_id) do nothing;
  return new;
end
$$;
create trigger projects_membership_policy_default
after insert on public.projects
for each row execute function public.create_default_project_membership_policy();

create table public.project_company_invitations (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null,
  project_company_id uuid not null,
  invited_company_id uuid not null references public.companies(id) on delete restrict,
  party public.project_party not null,
  status text not null default 'pending'
    check (status in ('pending','accepted','rejected','revoked','expired')),
  invited_by uuid not null,
  accepted_by uuid,
  accepted_at timestamptz,
  responded_at timestamptz,
  expires_at timestamptz not null default (now() + interval '30 days'),
  created_at timestamptz not null default now(),
  constraint project_company_invitations_project_fk
    foreign key (project_id, project_company_id)
    references public.projects(id, company_id) on delete cascade,
  constraint project_company_invitation_not_self
    check (project_company_id <> invited_company_id)
);
create unique index project_company_invitation_pending_party_uidx
  on public.project_company_invitations(project_id, party)
  where status = 'pending';
create unique index project_company_invitation_pending_company_uidx
  on public.project_company_invitations(project_id, invited_company_id)
  where status = 'pending';
alter table public.project_company_invitations enable row level security;
grant select on public.project_company_invitations to authenticated;

create table public.project_party_companies (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null,
  project_company_id uuid not null,
  participant_company_id uuid not null references public.companies(id) on delete restrict,
  party public.project_party not null,
  invitation_id uuid unique references public.project_company_invitations(id) on delete restrict,
  linked_by uuid not null,
  linked_at timestamptz not null default now(),
  constraint project_party_companies_project_fk
    foreign key (project_id, project_company_id)
    references public.projects(id, company_id) on delete cascade,
  constraint project_party_companies_one_company_per_party
    unique (project_id, party),
  constraint project_party_companies_one_party_per_company
    unique (project_id, participant_company_id)
);
alter table public.project_party_companies enable row level security;
grant select on public.project_party_companies to authenticated;

create table public.project_membership_events (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null,
  project_company_id uuid not null,
  actor_user_id uuid not null,
  action text not null check (action in (
    'company_invited','company_invitation_accepted','company_invitation_rejected','company_invitation_revoked',
    'company_invitation_expired','company_linked_by_project_admin','member_added','policy_changed'
  )),

  participant_company_id uuid,
  party public.project_party,
  member_user_id uuid,
  invitation_id uuid,
  policy_before boolean,
  policy_after boolean,
  reason text,
  created_at timestamptz not null default now(),
  constraint project_membership_events_project_fk
    foreign key (project_id, project_company_id)
    references public.projects(id, company_id) on delete cascade
);
alter table public.project_membership_events enable row level security;
grant select on public.project_membership_events to authenticated;

-- Membership events are an append-only security history.
create or replace function public.prevent_project_membership_event_mutation()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  raise exception 'MEMBERSHIP_EVENTS_APPEND_ONLY';
end
$$;
create trigger project_membership_events_append_only
before update or delete on public.project_membership_events
for each row execute function public.prevent_project_membership_event_mutation();

-- The owning company's initial party is recoverable only when the existing
-- project has one unambiguous admin party whose user is an actual company member.
-- Ambiguous/legacy external party rows are deliberately not guessed.
insert into public.project_party_companies
  (project_id, project_company_id, participant_company_id, party, linked_by)
select p.id, p.company_id, p.company_id,
       min(pm.party::text)::public.project_party,
       p.created_by
  from public.projects p
  join public.project_members pm on pm.project_id = p.id
  join public.company_members cm
    on cm.company_id = p.company_id and cm.user_id = pm.user_id
 where pm.role = 'admin'
 group by p.id, p.company_id, p.created_by
having count(distinct pm.party) = 1
on conflict do nothing;

create policy "project membership policies: project admins read"
on public.project_membership_policies for select to authenticated
using (public.can_manage_project(project_id));

create policy "project company invitations: relevant admins read"
on public.project_company_invitations for select to authenticated
using (
  public.can_manage_project(project_id)
  or public.is_company_admin(invited_company_id)
);

create policy "project party companies: relevant admins read"
on public.project_party_companies for select to authenticated
using (
  public.can_manage_project(project_id)
  or public.is_company_admin(participant_company_id)
);

create policy "project membership events: relevant admins read"
on public.project_membership_events for select to authenticated
using (
  public.can_manage_project(project_id)
  or (participant_company_id is not null and public.is_company_admin(participant_company_id))
);

-- Membership rows are created only through the validated SECURITY DEFINER RPC.
-- Direct authenticated INSERT/UPDATE is removed; project admins retain the
-- existing controlled DELETE path for removing another member.
drop policy if exists "project_members: admins insert" on public.project_members;
drop policy if exists "project_members: admins update" on public.project_members;
revoke insert, update on public.project_members from authenticated;
drop policy if exists "project_members: admins delete" on public.project_members;
create policy "project_members: party admins delete within scope"
on public.project_members for delete to authenticated
using (
  public.can_manage_project(project_id)
  and user_id <> auth.uid()
  and (
    party = public.project_party_of(project_id)
    or exists (
      select 1 from public.projects p
       where p.id = project_id
         and public.is_company_admin(p.company_id)
    )
  )
);

create or replace function public.guard_project_member_affiliation()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_project_company uuid;
begin
  select company_id into v_project_company
    from public.projects
   where id = new.project_id;
  if v_project_company is null then
    raise exception 'PROJECT_NOT_FOUND';
  end if;

  if tg_op = 'UPDATE' then
    if new.project_id is distinct from old.project_id
       or new.company_id is distinct from old.company_id
       or new.user_id is distinct from old.user_id
       or new.party is distinct from old.party
       or new.role is distinct from old.role
       or new.organization is distinct from old.organization
       or new.is_project_manager is distinct from old.is_project_manager then
      raise exception 'MEMBERSHIP_IMMUTABLE: use an approved membership workflow';
    end if;
    return new;
  end if;

  new.company_id := v_project_company;
  if not exists (
    select 1
      from public.project_party_companies ppc
      join public.company_members cm
        on cm.company_id = ppc.participant_company_id
       and cm.user_id = new.user_id
     where ppc.project_id = new.project_id
       and ppc.project_company_id = v_project_company
       and ppc.party = new.party
  ) then
    raise exception 'COMPANY_NOT_ACCEPTED_FOR_PARTY';
  end if;
  return new;
end
$$;
create trigger project_members_affiliation_guard
before insert or update on public.project_members
for each row execute function public.guard_project_member_affiliation();

-- Removing a user from a participating company also revokes that user's
-- project memberships for the company's assigned party. Existing audit_row
-- triggers retain the membership deletion event.
create or replace function public.revoke_project_memberships_after_company_removal()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from public.project_members pm
   using public.project_party_companies ppc
   where ppc.participant_company_id = old.company_id
     and ppc.party = pm.party
     and ppc.project_id = pm.project_id
     and pm.user_id = old.user_id;
  return old;
end
$$;
create trigger company_member_project_access_revoked
after delete on public.company_members
for each row execute function public.revoke_project_memberships_after_company_removal();

-- Project creation explicitly binds the creating company's first party.
create or replace function public.create_project(
  _company uuid, _code text, _name text, _party public.project_party,
  _name_ar text default null, _client text default null, _location text default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  pid uuid;
begin
  if auth.uid() is null then raise exception 'NOT_AUTHENTICATED'; end if;
  if not public.is_company_admin(_company) then raise exception 'FORBIDDEN'; end if;

  insert into public.projects (company_id, code, name, name_ar, client_name, location, created_by)
  values (_company, upper(btrim(_code)), btrim(_name), nullif(btrim(_name_ar), ''),
          nullif(btrim(_client), ''), nullif(btrim(_location), ''), auth.uid())
  returning id into pid;

  insert into public.project_party_companies
    (project_id, project_company_id, participant_company_id, party, linked_by)
  values (pid, _company, _company, _party, auth.uid());

  insert into public.project_members (project_id, company_id, user_id, party, role)
  values (pid, _company, auth.uid(), _party, 'admin');

  insert into public.project_response_codes
    (project_id, company_id, code, label_en, label_ar, outcome, sort)
  values
    (pid, _company, 'A', 'Approved', 'معتمد', 'proceed', 1),
    (pid, _company, 'B', 'Approved with comments', 'معتمد مع ملاحظات', 'proceed', 2),
    (pid, _company, 'C', 'Revise and resubmit', 'يُعدّل ويُعاد تقديمه', 'return', 3),
    (pid, _company, 'D', 'Rejected', 'مرفوض', 'return', 4),
    (pid, _company, 'E', 'Reviewed – no further action', 'تمت المراجعة – لا إجراء', 'proceed', 5),
    (pid, _company, 'I', 'For information only', 'للعلم فقط', 'proceed', 6);

  insert into public.project_workflows (project_id, company_id, document_type_id, steps, review_days)
  values (pid, _company, null, '{contractor,consultant}', 7);
  insert into public.project_workflows (project_id, company_id, document_type_id, steps, review_days)
  select pid, _company, t.id, '{consultant,contractor}', 7
    from public.document_types t
   where t.code in ('SOR','NCR','SNAG');

  return pid;
end
$$;

create or replace function public.invite_project_company(
  _project uuid,
  _invited_company uuid,
  _party public.project_party,
  _expires_at timestamptz default (now() + interval '30 days')
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_project_company uuid;
  v_invitation uuid;
begin
  select company_id into v_project_company from public.projects where id = _project for update;
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
  -- Expire stale pending invitations for this party/company under the project lock,
  -- so an abandoned invitation cannot permanently block a replacement.
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
    (project_id, project_company_id, actor_user_id, action, participant_company_id, party, invitation_id, reason)
  select _project, v_project_company, auth.uid(), 'company_invitation_expired',
         invited_company_id, party, id, 'Expired automatically when a replacement invitation was created'
    from expired;

  if exists (select 1 from public.project_party_companies where project_id = _project and party = _party) then
    raise exception 'PARTY_ALREADY_ASSIGNED';
  end if;
  if exists (select 1 from public.project_party_companies where project_id = _project and participant_company_id = _invited_company) then
    raise exception 'COMPANY_ALREADY_ASSIGNED';
  end if;

  insert into public.project_company_invitations
    (project_id, project_company_id, invited_company_id, party, invited_by, expires_at)
  values (_project, v_project_company, _invited_company, _party, auth.uid(), _expires_at)
  returning id into v_invitation;

  insert into public.project_membership_events
    (project_id, project_company_id, actor_user_id, action, participant_company_id, party, invitation_id)
  values (_project, v_project_company, auth.uid(), 'company_invited', _invited_company, _party, v_invitation);

  return v_invitation;
end
$$;

create or replace function public.accept_project_company_invitation(_invitation uuid)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_inv public.project_company_invitations;
  v_link uuid;
begin
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
      (project_id, project_company_id, actor_user_id, action, participant_company_id, party, invitation_id, reason)
    values (v_inv.project_id, v_inv.project_company_id, auth.uid(), 'company_invitation_expired',
            v_inv.invited_company_id, v_inv.party, v_inv.id, 'Expired before company acceptance');
    return null;
  end if;
  if exists (
    select 1 from public.project_party_companies
     where project_id = v_inv.project_id
       and (party = v_inv.party or participant_company_id = v_inv.invited_company_id)
  ) then
    raise exception 'PARTY_OR_COMPANY_ALREADY_ASSIGNED';
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
    (project_id, project_company_id, actor_user_id, action, participant_company_id, party, invitation_id)
  values
    (v_inv.project_id, v_inv.project_company_id, auth.uid(), 'company_invitation_accepted',
     v_inv.invited_company_id, v_inv.party, v_inv.id);

  return v_link;
end
$$;

create or replace function public.reject_project_company_invitation(_invitation uuid, _reason text default null)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare v_inv public.project_company_invitations;
begin
  select * into v_inv from public.project_company_invitations where id = _invitation for update;
  if not found then raise exception 'INVITATION_NOT_FOUND'; end if;
  if not public.is_company_admin(v_inv.invited_company_id) then raise exception 'FORBIDDEN'; end if;
  if v_inv.status <> 'pending' then raise exception 'INVITATION_NOT_PENDING'; end if;
  if v_inv.expires_at <= now() then
    update public.project_company_invitations set status = 'expired', responded_at = now()
     where id = _invitation;
    insert into public.project_membership_events
      (project_id, project_company_id, actor_user_id, action, participant_company_id, party, invitation_id, reason)
    values (v_inv.project_id, v_inv.project_company_id, auth.uid(), 'company_invitation_expired',
            v_inv.invited_company_id, v_inv.party, v_inv.id, 'Expired before company response');
    return false;
  end if;

  update public.project_company_invitations
     set status = 'rejected', responded_at = now()
   where id = _invitation;

  insert into public.project_membership_events
    (project_id, project_company_id, actor_user_id, action, participant_company_id, party, invitation_id, reason)
  values
    (v_inv.project_id, v_inv.project_company_id, auth.uid(), 'company_invitation_rejected',
     v_inv.invited_company_id, v_inv.party, v_inv.id, nullif(btrim(_reason), ''));

  return true;
end
$$;

create or replace function public.revoke_project_company_invitation(_invitation uuid, _reason text)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare v_inv public.project_company_invitations;
begin
  select * into v_inv
    from public.project_company_invitations
   where id = _invitation
   for update;
  if not found then raise exception 'INVITATION_NOT_FOUND'; end if;
  if not public.can_manage_project(v_inv.project_id)
     or not public.is_company_admin(v_inv.project_company_id) then
    raise exception 'FORBIDDEN';
  end if;
  if v_inv.status <> 'pending' then raise exception 'INVITATION_NOT_PENDING'; end if;
  if v_inv.expires_at <= now() then
    update public.project_company_invitations set status = 'expired', responded_at = now()
     where id = _invitation;
    insert into public.project_membership_events
      (project_id, project_company_id, actor_user_id, action, participant_company_id, party, invitation_id, reason)
    values (v_inv.project_id, v_inv.project_company_id, auth.uid(), 'company_invitation_expired',
            v_inv.invited_company_id, v_inv.party, v_inv.id, 'Expired before revocation');
    return false;
  end if;
  if length(btrim(coalesce(_reason,''))) < 5 then
    raise exception 'REVOCATION_REASON_REQUIRED';
  end if;

  update public.project_company_invitations
     set status = 'revoked', responded_at = now()
   where id = _invitation;

  insert into public.project_membership_events
    (project_id, project_company_id, actor_user_id, action, participant_company_id, party, invitation_id, reason)
  values
    (v_inv.project_id, v_inv.project_company_id, auth.uid(), 'company_invitation_revoked',
     v_inv.invited_company_id, v_inv.party, v_inv.id, 'Revoked: ' || btrim(_reason));
  return true;
end
$$;

-- A future, less restrictive mode is possible, but the default remains
-- company acceptance. Only an admin of the owning company can change it,
-- and every change requires a reason and produces an immutable event.
create or replace function public.set_project_membership_policy(
  _project uuid,
  _external_company_acceptance_required boolean,
  _reason text
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_company uuid;
  v_before boolean;
begin
  select company_id into v_company from public.projects where id = _project;
  if v_company is null then raise exception 'PROJECT_NOT_FOUND'; end if;
  if not public.can_manage_project(_project)
     or not public.is_company_admin(v_company) then
    raise exception 'FORBIDDEN';
  end if;
  if length(btrim(coalesce(_reason,''))) < 10 then
    raise exception 'POLICY_CHANGE_REASON_REQUIRED';
  end if;

  select external_company_acceptance_required into v_before
    from public.project_membership_policies
   where project_id = _project
   for update;

  insert into public.project_membership_policies
    (project_id, external_company_acceptance_required, updated_by, updated_at, change_reason)
  values (_project, _external_company_acceptance_required, auth.uid(), now(), btrim(_reason))
  on conflict (project_id) do update
    set external_company_acceptance_required = excluded.external_company_acceptance_required,
        updated_by = excluded.updated_by,
        updated_at = excluded.updated_at,
        change_reason = excluded.change_reason;

  insert into public.project_membership_events
    (project_id, project_company_id, actor_user_id, action, policy_before, policy_after, reason)
  values
    (_project, v_company, auth.uid(), 'policy_changed', v_before,
     _external_company_acceptance_required, btrim(_reason));

  return true;
end
$$;

-- Replace the old email-based upsert. An existing membership is never silently
-- reassigned or promoted. The optional company ID disambiguates users belonging
-- to more than one company when the project is in the admin-approval mode.
drop function public.add_project_member(uuid, text, public.project_party, public.project_role, text);

create function public.add_project_member(
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
set search_path = public
as $$
declare
  v_project_company uuid;
  v_member_company uuid;
  v_user uuid;
  v_member_id uuid;
  v_owner_party public.project_party;
  v_acceptance_required boolean;
begin
  select company_id into v_project_company from public.projects where id = _project;
  if v_project_company is null then raise exception 'PROJECT_NOT_FOUND'; end if;
  if not public.can_manage_project(_project) then raise exception 'FORBIDDEN'; end if;

  select participant_company_id into v_member_company
    from public.project_party_companies
   where project_id = _project and party = _party;

  if v_member_company is not null then
    if _member_company is not null and _member_company <> v_member_company then
      raise exception 'MEMBER_COMPANY_DOES_NOT_MATCH_PARTY';
    end if;
  else
    select coalesce(
      (select external_company_acceptance_required
         from public.project_membership_policies where project_id = _project),
      true
    ) into v_acceptance_required;

    if v_acceptance_required then
      raise exception 'COMPANY_ACCEPTANCE_REQUIRED';
    end if;
    if not public.is_company_admin(v_project_company) then
      raise exception 'ONLY_OWNING_COMPANY_ADMIN_CAN_LINK_COMPANY';
    end if;
    if _member_company is null then
      raise exception 'MEMBER_COMPANY_REQUIRED';
    end if;
    if _member_company = v_project_company then
      raise exception 'OWNING_COMPANY_PARTY_ALREADY_DEFINED';
    end if;
    if not exists (select 1 from public.companies where id = _member_company) then
      raise exception 'COMPANY_NOT_FOUND';
    end if;
    if exists (
      select 1 from public.project_party_companies
       where project_id = _project
         and (party = _party or participant_company_id = _member_company)
    ) then
      raise exception 'PARTY_OR_COMPANY_ALREADY_ASSIGNED';
    end if;
    select id into v_user
      from public.profiles
     where lower(email) = lower(btrim(_email))
     limit 1;
    if v_user is null then raise exception 'MEMBER_NOT_ELIGIBLE'; end if;
    if not exists (
      select 1 from public.company_members
       where company_id = _member_company and user_id = v_user
    ) then
      raise exception 'MEMBER_NOT_ELIGIBLE';
    end if;

    insert into public.project_party_companies
      (project_id, project_company_id, participant_company_id, party, linked_by)
    values (_project, v_project_company, _member_company, _party, auth.uid());

    insert into public.project_membership_events
      (project_id, project_company_id, actor_user_id, action, participant_company_id, party, member_user_id,
       reason)
    values (_project, v_project_company, auth.uid(), 'company_linked_by_project_admin',
            _member_company, _party, v_user, 'Approved under project membership policy');
    v_member_company := _member_company;
  end if;

  if v_user is null then
    select id into v_user
      from public.profiles
     where lower(email) = lower(btrim(_email))
     limit 1;
  end if;
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
    (project_id, project_company_id, actor_user_id, action, participant_company_id, party, member_user_id)
  values
    (_project, v_project_company, auth.uid(), 'member_added', v_member_company, _party, v_user);

  return v_member_id;
end
$$;

-- No direct writes to invitation, party-link, policy or event records.
revoke all on public.project_company_invitations from anon, authenticated;
revoke all on public.project_party_companies from anon, authenticated;
revoke all on public.project_membership_policies from anon, authenticated;
revoke all on public.project_membership_events from anon, authenticated;
grant select on public.project_company_invitations to authenticated;
grant select on public.project_party_companies to authenticated;
grant select on public.project_membership_policies to authenticated;
grant select on public.project_membership_events to authenticated;

revoke all on function public.create_default_project_membership_policy() from public, anon, authenticated;
revoke all on function public.guard_project_member_affiliation() from public, anon, authenticated;
revoke all on function public.prevent_project_membership_event_mutation() from public, anon, authenticated;
revoke all on function public.revoke_project_memberships_after_company_removal() from public, anon, authenticated;
revoke all on function public.invite_project_company(uuid, uuid, public.project_party, timestamptz) from public, anon;
grant execute on function public.invite_project_company(uuid, uuid, public.project_party, timestamptz) to authenticated;
revoke all on function public.accept_project_company_invitation(uuid) from public, anon;
grant execute on function public.accept_project_company_invitation(uuid) to authenticated;
revoke all on function public.reject_project_company_invitation(uuid, text) from public, anon;
grant execute on function public.reject_project_company_invitation(uuid, text) to authenticated;
revoke all on function public.revoke_project_company_invitation(uuid, text) from public, anon;
grant execute on function public.revoke_project_company_invitation(uuid, text) to authenticated;
revoke all on function public.set_project_membership_policy(uuid, boolean, text) from public, anon;
grant execute on function public.set_project_membership_policy(uuid, boolean, text) to authenticated;
revoke all on function public.create_project(uuid, text, text, public.project_party, text, text, text) from public, anon;
grant execute on function public.create_project(uuid, text, text, public.project_party, text, text, text) to authenticated;
revoke all on function public.add_project_member(uuid, text, public.project_party, public.project_role, text, uuid) from public, anon;
grant execute on function public.add_project_member(uuid, text, public.project_party, public.project_role, text, uuid) to authenticated;

notify pgrst, 'reload schema';
