-- Acceptance tests for 0006 company search and JV party membership.
-- Run ONLY on an isolated restored PostgreSQL test database.
-- Required psql variables:
-- project_id, project_company_id, owner_admin_user_id,
-- invited_company_id, invited_company_admin_user_id, invited_member_user_id,
-- invited_member_email, jv_company_id, jv_company_admin_user_id,
-- jv_member_user_id, jv_member_email.
-- Fixture requirements: project owner is contractor; invited and JV companies
-- are distinct; both have admin/member users; consultant is initially unassigned.

\set ON_ERROR_STOP on
begin;

select set_config('test.project_id', :'project_id', true);
select set_config('test.project_company_id', :'project_company_id', true);
select set_config('test.invited_company_id', :'invited_company_id', true);
select set_config('test.jv_company_id', :'jv_company_id', true);
select set_config('test.invited_member_user_id', :'invited_member_user_id', true);
select set_config('test.jv_member_user_id', :'jv_member_user_id', true);
select set_config('test.invited_member_email', :'invited_member_email', true);
select set_config('test.jv_member_email', :'jv_member_email', true);

set local role authenticated;
select set_config('request.jwt.claim.sub', :'owner_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'owner_admin_user_id', 'role', 'authenticated')::text, true);

-- Search rejects short input and returns eligible companies only.
do $$
begin
  if (select count(*) from public.search_companies_for_project_invitation(
      current_setting('test.project_id')::uuid, 'ab')) <> 0 then
    raise exception 'P6_FAIL: short search query returned companies';
  end if;
  if not exists (
    select 1 from public.search_companies_for_project_invitation(
      current_setting('test.project_id')::uuid, 'JV Co')
     where id = current_setting('test.jv_company_id')::uuid
  ) then
    raise exception 'P6_FAIL: eligible JV company was not found';
  end if;
end
$$;

-- Invite and accept the first company, then invite a second company to
-- the already occupied consultant party. This catches the former one-company gate.
select set_config('test.invitation_one', public.invite_project_company(
  current_setting('test.project_id')::uuid,
  current_setting('test.invited_company_id')::uuid,
  'consultant'
)::text, true);

-- The invited company's administrator sees and accepts the incoming invitation.
select set_config('request.jwt.claim.sub', :'invited_company_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'invited_company_admin_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  if not exists (
    select 1 from public.list_project_company_invitations(null)
     where id = current_setting('test.invitation_one')::uuid
       and direction = 'received' and can_respond = true
  ) then
    raise exception 'P6_FAIL: invited company admin could not see actionable inbox row';
  end if;
end
$$;
select public.accept_project_company_invitation(current_setting('test.invitation_one')::uuid);

-- A second company may join the same party after the first company is accepted.
-- Invitation creation is an owner-side action; restore the project administrator context
-- after the invited company's administrator has accepted the first invitation.
select set_config('request.jwt.claim.sub', :'owner_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'owner_admin_user_id', 'role', 'authenticated')::text, true);
select set_config('test.invitation_two', public.invite_project_company(
  current_setting('test.project_id')::uuid,
  current_setting('test.jv_company_id')::uuid,
  'consultant'
)::text, true);
select set_config('request.jwt.claim.sub', :'jv_company_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'jv_company_admin_user_id', 'role', 'authenticated')::text, true);
select public.accept_project_company_invitation(current_setting('test.invitation_two')::uuid);

-- Count both companies as the project owner administrator; the invited
-- company admin is intentionally scoped by RLS to its own participant row.
select set_config('request.jwt.claim.sub', :'owner_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'owner_admin_user_id', 'role', 'authenticated')::text, true);

do $jv$
begin
  if (select count(*) from public.project_party_companies
       where project_id = current_setting('test.project_id')::uuid
         and party = 'consultant') <> 2 then
    raise exception 'P6_FAIL: multiple companies could not join the same party';
  end if;
end
$jv$;

-- The project admin must identify the member company when a party has >1 company.
select set_config('request.jwt.claim.sub', :'owner_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'owner_admin_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  begin
    perform public.add_project_member(
      current_setting('test.project_id')::uuid,
      current_setting('test.invited_member_email'),
      'consultant', 'controller', null, null
    );
    raise exception 'P6_FAIL: ambiguous JV member company was silently selected';
  exception when others then
    if sqlerrm like 'P6_FAIL:%' then raise; end if;
    if sqlerrm <> 'MEMBER_COMPANY_REQUIRED' then raise; end if;
  end;
end
$$;

select public.add_project_member(
  current_setting('test.project_id')::uuid,
  current_setting('test.invited_member_email'),
  'consultant', 'controller', null,
  current_setting('test.invited_company_id')::uuid
);
select public.add_project_member(
  current_setting('test.project_id')::uuid,
  current_setting('test.jv_member_email'),
  'consultant', 'controller', null,
  current_setting('test.jv_company_id')::uuid
);

do $$
begin
  if (select count(*) from public.project_members
       where project_id = current_setting('test.project_id')::uuid
         and party = 'consultant'
         and user_id in (
           current_setting('test.invited_member_user_id')::uuid,
           current_setting('test.jv_member_user_id')::uuid
         )) <> 2 then
    raise exception 'P6_FAIL: members from both JV companies were not added';
  end if;
end
$$;

do $$
begin
  if not exists (
    select 1 from public.project_members
     where project_id = current_setting('test.project_id')::uuid
       and user_id = current_setting('test.invited_member_user_id')::uuid
       and participant_company_id = current_setting('test.invited_company_id')::uuid
  ) then
    raise exception 'P6_FAIL: first JV member company affiliation was not persisted';
  end if;
  if not exists (
    select 1 from public.project_members
     where project_id = current_setting('test.project_id')::uuid
       and user_id = current_setting('test.jv_member_user_id')::uuid
       and participant_company_id = current_setting('test.jv_company_id')::uuid
  ) then
    raise exception 'P6_FAIL: second JV member company affiliation was not persisted';
  end if;
end
$$;

-- Removing a member from one JV company must not revoke a different company's member.
set local role authenticated;
select set_config('request.jwt.claim.sub', :'invited_company_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'invited_company_admin_user_id', 'role', 'authenticated')::text, true);
delete from public.company_members
 where company_id = current_setting('test.invited_company_id')::uuid
   and user_id = current_setting('test.invited_member_user_id')::uuid;

-- Verify both companies' memberships as the project owner administrator.
-- The invited-company admin is RLS-scoped and cannot see the other JV company.
select set_config('request.jwt.claim.sub', :'owner_admin_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'owner_admin_user_id', 'role', 'authenticated')::text, true);

do $jv$begin
  if exists (
    select 1 from public.project_members
     where project_id = current_setting('test.project_id')::uuid
       and user_id = current_setting('test.invited_member_user_id')::uuid
  ) then
    raise exception 'P6_FAIL: removed company member retained project access';
  end if;
  if not exists (
    select 1 from public.project_members
     where project_id = current_setting('test.project_id')::uuid
       and user_id = current_setting('test.jv_member_user_id')::uuid
       and participant_company_id = current_setting('test.jv_company_id')::uuid
  ) then
    raise exception 'P6_FAIL: removing one JV company member revoked another company member';
  end if;
end
$jv$;

-- An unauthorized user cannot enumerate company names or invitation inbox rows.
set local role authenticated;
select set_config('request.jwt.claim.sub', :'jv_member_user_id', true);
select set_config('request.jwt.claims',
  json_build_object('sub', :'jv_member_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  begin
    perform * from public.search_companies_for_project_invitation(
      current_setting('test.project_id')::uuid, 'JV Co');
    raise exception 'P6_FAIL: non-admin searched companies';
  exception when others then
    if sqlerrm like 'P6_FAIL:%' then raise; end if;
    if sqlerrm <> 'FORBIDDEN' then raise; end if;
  end;
  if (select count(*) from public.list_project_company_invitations(null)) <> 0 then
    raise exception 'P6_FAIL: ordinary project member enumerated invitation inbox';
  end if;
end
$$;

rollback;
