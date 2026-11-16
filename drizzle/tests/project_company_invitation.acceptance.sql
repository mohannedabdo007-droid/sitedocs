-- Acceptance tests for 0005_company_acceptance_membership.sql.
-- Run ONLY against an isolated restored test database, never production.
-- Required psql variables:
-- project_id, project_company_id, owner_admin_user_id,
-- invited_company_id, invited_company_admin_user_id, invited_member_user_id,
-- invited_member_email, unlinked_company_id, unlinked_company_admin_user_id,
-- unlinked_member_user_id, unlinked_member_email.
-- Fixture requirements:
-- * project_company_id owns project_id and its initial party is contractor.
-- * invited_company_id and unlinked_company_id are separate companies.
-- * invited_company_admin_user_id is an admin of invited_company_id.
-- * invited_member_user_id is a non-admin member of invited_company_id.
-- * unlinked_member_user_id is a member of unlinked_company_id.
-- * consultant and pmc parties are not already assigned to the project.

\set ON_ERROR_STOP on
begin;

select set_config('test.project_id', :'project_id', true);
select set_config('test.project_company_id', :'project_company_id', true);
select set_config('test.invited_company_id', :'invited_company_id', true);
select set_config('test.unlinked_company_id', :'unlinked_company_id', true);
select set_config('test.invited_member_user_id', :'invited_member_user_id', true);
select set_config('test.unlinked_member_user_id', :'unlinked_member_user_id', true);\nselect set_config('test.invited_member_email', :'invited_member_email', true);\nselect set_config('test.unlinked_member_email', :'unlinked_member_email', true);

-- The default must require acceptance.
set local role authenticated;
select set_config('request.jwt.claim.sub', :'owner_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'owner_admin_user_id', 'role', 'authenticated')::text, true);

do $$
begin
  if not exists (
    select 1 from public.project_membership_policies
     where project_id = current_setting('test.project_id')::uuid
       and external_company_acceptance_required = true
  ) then
    raise exception 'P5_FAIL: company acceptance is not the default';
  end if;
end
$$;

-- Invite a company to the consultant party.
select set_config('test.invitation_id',
  public.invite_project_company(
    current_setting('test.project_id')::uuid,
    current_setting('test.invited_company_id')::uuid,
    'consultant'
  )::text, true);

do $$
begin
  if not exists (
    select 1 from public.project_company_invitations
     where id = current_setting('test.invitation_id')::uuid
       and status = 'pending'
       and party = 'consultant'
  ) then
    raise exception 'P5_FAIL: invitation was not created as pending';
  end if;
end
$$;

-- An unrelated company administrator cannot accept this invitation.
set local role authenticated;
select set_config('request.jwt.claim.sub', :'unlinked_company_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'unlinked_company_admin_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  begin
    perform public.accept_project_company_invitation(current_setting('test.invitation_id')::uuid);
    raise exception 'P5_FAIL: non-admin accepted a company invitation';
  exception when others then
    if sqlerrm like 'P5_FAIL:%' then raise; end if;
  end;
end
$$;

-- The invited company's administrator accepts.
set local role authenticated;
select set_config('request.jwt.claim.sub', :'invited_company_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'invited_company_admin_user_id', 'role', 'authenticated')::text, true);
select public.accept_project_company_invitation(current_setting('test.invitation_id')::uuid);

do $$
begin
  if not exists (
    select 1 from public.project_party_companies
     where project_id = current_setting('test.project_id')::uuid
       and participant_company_id = current_setting('test.invited_company_id')::uuid
       and party = 'consultant'
  ) then
    raise exception 'P5_FAIL: accepted company was not linked to consultant party';
  end if;
end
$$;

-- The project admin can now add only a member of the accepted company.
set local role authenticated;
select set_config('request.jwt.claim.sub', :'owner_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'owner_admin_user_id', 'role', 'authenticated')::text, true);
select public.add_project_member(
  current_setting('test.project_id')::uuid,
  current_setting('test.invited_member_email'),
  'consultant',
  'controller',
  'Test consultant'
);

do $$
begin
  if not exists (
    select 1 from public.project_members
     where project_id = current_setting('test.project_id')::uuid
       and user_id = current_setting('test.invited_member_user_id')::uuid
       and party = 'consultant'
       and company_id = current_setting('test.project_company_id')::uuid
  ) then
    raise exception 'P5_FAIL: invited company member was not added to the correct party';
  end if;
end
$$;

-- Re-adding the same user cannot silently change party or role.
do $$
begin
  begin
    perform public.add_project_member(
      current_setting('test.project_id')::uuid,
      current_setting('test.invited_member_email'),
      'consultant',
      'viewer',
      'Attempted reassignment'
    );
    raise exception 'P5_FAIL: duplicate membership was silently reassigned';
  exception when unique_violation then
    null;
  end;
end
$$;

-- Direct INSERT/UPDATE must not bypass the validated RPC.
do $$
begin
  begin
    update public.project_members
       set party = 'contractor'
     where project_id = current_setting('test.project_id')::uuid
       and user_id = current_setting('test.invited_member_user_id')::uuid;
    raise exception 'P5_FAIL: direct membership UPDATE succeeded';
  exception when insufficient_privilege then
    null;
  end;
end
$$;

-- An unaccepted company cannot be added while acceptance is required.
do $$
begin
  begin
    perform public.add_project_member(
      current_setting('test.project_id')::uuid,
      current_setting('test.unlinked_member_email'),
      'pmc',
      'viewer',
      null,
      current_setting('test.unlinked_company_id')::uuid
    );
    raise exception 'P5_FAIL: unaccepted company member was added';
  exception when others then
    if sqlerrm like 'P5_FAIL:%' then raise; end if;
    if sqlerrm <> 'COMPANY_ACCEPTANCE_REQUIRED' then raise; end if;
  end;
end
$$;

-- An external company's admin cannot weaken the owning project's policy.
set local role authenticated;
select set_config('request.jwt.claim.sub', :'invited_company_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'invited_company_admin_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  begin
    perform public.set_project_membership_policy(
      current_setting('test.project_id')::uuid, false, 'Unauthorized policy change'
    );
    raise exception 'P5_FAIL: external company changed the project policy';
  exception when others then
    if sqlerrm like 'P5_FAIL:%' then raise; end if;
    if sqlerrm <> 'FORBIDDEN' then raise; end if;
  end;
end
$$;

-- The owning company's admin may explicitly switch to the future
-- project-admin-approval mode; the change must be recorded with a reason.
set local role authenticated;
select set_config('request.jwt.claim.sub', :'owner_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'owner_admin_user_id', 'role', 'authenticated')::text, true);
select public.set_project_membership_policy(
  current_setting('test.project_id')::uuid, false, 'Approved future policy test'
);

do $$
begin
  if not exists (
    select 1 from public.project_membership_events
     where project_id = current_setting('test.project_id')::uuid
       and action = 'policy_changed'
       and policy_before = true
       and policy_after = false
       and reason = 'Approved future policy test'
  ) then
    raise exception 'P5_FAIL: policy change was not immutably recorded';
  end if;
end
$$;

-- Under the alternative policy, only the owning company's admin can link
-- an additional company, and must identify the user's company explicitly.
select public.add_project_member(
  current_setting('test.project_id')::uuid,
  current_setting('test.unlinked_member_email'),
  'pmc',
  'viewer',
  null,
  current_setting('test.unlinked_company_id')::uuid
);

do $$
begin
  if not exists (
    select 1 from public.project_party_companies
     where project_id = current_setting('test.project_id')::uuid
       and participant_company_id = current_setting('test.unlinked_company_id')::uuid
       and party = 'pmc'
  ) then
    raise exception 'P5_FAIL: admin-approved company link was not recorded';
  end if;
  if not exists (
    select 1 from public.project_members
     where project_id = current_setting('test.project_id')::uuid
       and user_id = current_setting('test.unlinked_member_user_id')::uuid
       and party = 'pmc'
  ) then
    raise exception 'P5_FAIL: member was not added under the alternative policy';
  end if;
end
$$;

-- Removing the user from their company revokes the corresponding project
-- membership automatically and the existing audit trigger records deletion.
set local role authenticated;\nselect set_config('request.jwt.claim.sub', :'unlinked_company_admin_user_id', true);\nselect set_config('request.jwt.claims',\n  json_build_object('sub', :'unlinked_company_admin_user_id', 'role', 'authenticated')::text, true);\ndelete from public.company_members\n where company_id = current_setting('test.unlinked_company_id')::uuid
   and user_id = current_setting('test.unlinked_member_user_id')::uuid;

do $$
begin
  if exists (
    select 1 from public.project_members
     where project_id = current_setting('test.project_id')::uuid
       and user_id = current_setting('test.unlinked_member_user_id')::uuid
  ) then
    raise exception 'P5_FAIL: project access remained after company membership removal';
  end if;
end
$$;

rollback;
