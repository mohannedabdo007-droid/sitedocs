\set ON_ERROR_STOP on
-- Run with psql against an isolated restored SiteDocs database only.
-- Required -v variables:
-- creator_user_id, originator_peer_user_id, wrong_party_user_id,
-- project_manager_user_id, company_admin_user_id, other_tenant_user_id,
-- draft_document_id, submitted_document_id, self_review_document_id,
-- other_project_document_id, attachment_path.
-- Fixtures must be synthetic. The PM must have project_members.is_project_manager=true.
-- Each actor must have a distinct authenticated JWT subject.

begin;

select set_config('test.draft_document_id', :'draft_document_id', true);
select set_config('test.submitted_document_id', :'submitted_document_id', true);
select set_config('test.self_review_document_id', :'self_review_document_id', true);
select set_config('test.other_project_document_id', :'other_project_document_id', true);
select set_config('test.attachment_path', :'attachment_path', true);

-- Creator: own draft and its audit trail are visible.
set local role authenticated;
select set_config('request.jwt.claim.sub', :'creator_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'creator_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  if not exists (select 1 from public.documents where id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL creator cannot read own draft';
  end if;
  if not exists (select 1 from public.audit_log where document_id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL creator cannot read own draft audit';
  end if;
  if not exists (select 1 from storage.objects where bucket_id = 'document-files' and name = current_setting('test.attachment_path')) then
    raise exception 'P0_FAIL creator cannot read own draft object';
  end if;
end $$;

-- Another member of the originating party may read the draft under the
-- approved party-level confidentiality rule.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'originator_peer_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'originator_peer_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  if not exists (select 1 from public.documents where id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL originating-party peer cannot read draft';
  end if;
end $$;

-- Different party: no draft row, child rows, or audit payload.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'wrong_party_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'wrong_party_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  if exists (select 1 from public.documents where id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL other party read draft';
  end if;
  if exists (select 1 from public.document_revisions where document_id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL other party read draft revisions';
  end if;
  if exists (select 1 from public.document_reviews where document_id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL other party read draft reviews';
  end if;
  if exists (select 1 from public.attachments where document_id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL other party read draft attachments';
  end if;
  if exists (select 1 from public.audit_log where document_id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL other party read draft audit';
  end if;
  if exists (select 1 from storage.objects where bucket_id = 'document-files' and name = current_setting('test.attachment_path')) then
    raise exception 'P0_FAIL other party read draft storage object';
  end if;
end $$;

-- Project Manager: read all drafts, but cannot mutate or transition them.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'project_manager_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'project_manager_user_id', 'role', 'authenticated')::text, true);
do $$
declare changed integer;
begin
  if not exists (select 1 from public.documents where id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL PM cannot read project draft';
  end if;
  if not exists (select 1 from storage.objects where bucket_id = 'document-files' and name = current_setting('test.attachment_path')) then
    raise exception 'P0_FAIL PM cannot read project draft object';
  end if;
  update public.documents
     set title = title
   where id = current_setting('test.draft_document_id')::uuid;
  get diagnostics changed = row_count;
  if changed <> 0 then
    raise exception 'P0_FAIL PM mutated a draft';
  end if;
  begin
    perform public.transition_document(current_setting('test.submitted_document_id')::uuid, 'start_review', null, null);
    raise exception 'P0_FAIL PM executed workflow RPC';
  exception when others then
    if sqlerrm = 'P0_FAIL PM executed workflow RPC' then raise; end if;
  end;
end $$;

-- Company admin without explicit project membership must not inherit project
-- membership or document visibility.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'company_admin_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'company_admin_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  if exists (select 1 from public.documents where id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL company admin inherited draft access';
  end if;
end $$;

-- Other tenant: neither draft nor submitted document nor audit data crosses tenant.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'other_tenant_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'other_tenant_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  if exists (select 1 from public.documents where id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL cross-tenant draft read';
  end if;
  if exists (select 1 from public.documents where id = current_setting('test.submitted_document_id')::uuid) then
    raise exception 'P0_FAIL cross-tenant submitted document read';
  end if;
  if exists (select 1 from public.audit_log where document_id in (
    current_setting('test.draft_document_id')::uuid,
    current_setting('test.submitted_document_id')::uuid
  )) then
    raise exception 'P0_FAIL cross-tenant audit read';
  end if;
end $$;

-- A project member of another party may read a submitted document, but not its
-- draft counterpart. This verifies that the policy is lifecycle-aware.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'wrong_party_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'wrong_party_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  if not exists (select 1 from public.documents where id = current_setting('test.submitted_document_id')::uuid) then
    raise exception 'P0_FAIL authorized project party cannot read submitted document';
  end if;
end $$;

-- The creator must never review/respond to their own submitted document.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'creator_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'creator_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  begin
    perform public.transition_document(current_setting('test.self_review_document_id')::uuid, 'start_review', null, null);
    raise exception 'P0_FAIL creator self-reviewed document';
  exception when others then
    if sqlerrm = 'P0_FAIL creator self-reviewed document' then raise; end if;
    if sqlerrm <> 'SELF_REVIEW_FORBIDDEN' then raise; end if;
  end;
end $$;

reset role;
rollback;
