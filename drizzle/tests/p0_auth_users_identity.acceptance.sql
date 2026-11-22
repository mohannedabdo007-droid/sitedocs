\set ON_ERROR_STOP on
-- Disposable CI-only regression test. The attacker has a legitimate company
-- membership but a forged profile email that does not belong to any Auth user.
begin;

-- Simulate a stale/forged legacy profile value using the trusted DB context.
-- The authenticated profile-email trigger intentionally permits trusted
-- server-side maintenance when auth.uid() is NULL.
select set_config('request.jwt.claim.sub', '', true);
select set_config('test.attacker_id', :'other_tenant_user_id', true);
update public.profiles
   set email = 'spoofed-invitee@sitedocs.test'
 where id = :'other_tenant_user_id';

-- Give the attacker an actual membership in the consultant company so the
-- legacy profiles.email lookup would accept the project-membership request.
insert into public.company_members(company_id, user_id, role)
values ('10000000-0000-4000-8000-000000000011', :'other_tenant_user_id', 'member')
on conflict (company_id, user_id) do nothing;

set local role authenticated;
select set_config('request.jwt.claim.sub', :'project_membership_admin_user_id', true);
select set_config(
  'request.jwt.claims',
  json_build_object('sub', :'project_membership_admin_user_id', 'role', 'authenticated')::text,
  true
);

-- A forged profile email with no matching verified Auth account must not
-- create a company membership for the attacker.
do $company_identity$
begin
  begin
    perform public.add_company_member(
      '10000000-0000-4000-8000-000000000010',
      'spoofed-invitee@sitedocs.test',
      'member'
    );
    raise exception 'P0_SECURITY_FAIL: forged profile email created a company membership';
  exception when others then
    if sqlerrm <> 'USER_NOT_FOUND' then
      raise;
    end if;
  end;

  if exists (
    select 1 from public.company_members
     where company_id = '10000000-0000-4000-8000-000000000010'
       and user_id = current_setting('test.attacker_id')::uuid
  ) then
    raise exception 'P0_SECURITY_FAIL: company membership was assigned to the caller';
  end if;
end
$company_identity$;

-- The same forged profile email must not create a project membership even
-- though the attacker belongs to the selected participant company.
do $project_identity$
begin
  begin
    perform public.add_project_member(
      '20000000-0000-4000-8000-000000000010',
      'spoofed-invitee@sitedocs.test',
      'consultant',
      'reviewer',
      null,
      '10000000-0000-4000-8000-000000000011'
    );
    raise exception 'P0_SECURITY_FAIL: forged profile email created a project membership';
  exception when others then
    if sqlerrm <> 'MEMBER_NOT_ELIGIBLE' then
      raise;
    end if;
  end;

  if exists (
    select 1 from public.project_members
     where project_id = '20000000-0000-4000-8000-000000000010'
       and user_id = current_setting('test.attacker_id')::uuid
  ) then
    raise exception 'P0_SECURITY_FAIL: project membership was assigned to the caller';
  end if;
end
$project_identity$;

rollback;
