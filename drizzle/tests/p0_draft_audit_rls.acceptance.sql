\set ON_ERROR_STOP on
-- Run with psql against an isolated restored SiteDocs database only.
-- Required -v variables:
-- creator_user_id, originator_peer_user_id, wrong_party_user_id, current_reviewer_user_id,
-- project_manager_user_id, company_admin_user_id, other_tenant_user_id,
-- draft_document_id, submitted_document_id, self_review_document_id,
-- attachment_path, project_id, other_party_import_batch_id, draft_ocr_job_id.
-- Fixtures must be synthetic. The PM must have project_members.is_project_manager=true.
-- Each actor must have a distinct authenticated JWT subject.

begin;

select set_config('test.draft_document_id', :'draft_document_id', true);
select set_config('test.submitted_document_id', :'submitted_document_id', true);
select set_config('test.self_review_document_id', :'self_review_document_id', true);
select set_config('test.attachment_path', :'attachment_path', true);
select set_config('test.project_id', :'project_id', true);
select set_config('test.other_party_import_batch_id', :'other_party_import_batch_id', true);
select set_config('test.draft_ocr_job_id', :'draft_ocr_job_id', true);

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
  if exists (select 1 from public.audit_log where document_id = current_setting('test.draft_document_id')::uuid and (changes ? 'description' or changes ? 'metadata' or changes ? 'location')) then
    raise exception 'P0_FAIL audit payload contains excluded private document fields';
  end if;
  if exists (select 1 from public.audit_log where document_id = current_setting('test.draft_document_id')::uuid and changes ? 'body') then
    raise exception 'P0_FAIL audit payload contains comment body';
  end if;
  if exists (
    select 1
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
      cross join lateral aclexplode(coalesce(p.proacl, acldefault('f', p.proowner))) acl
     where n.nspname = 'public'
       and p.proname in ('transition_document','commit_import_rows','add_project_member','create_project','create_company','add_company_member','preview_document_number')
       and acl.grantee = 0
       and acl.privilege_type = 'EXECUTE'
  ) then
    raise exception 'P0_FAIL privileged SECURITY DEFINER RPC still executable by PUBLIC';
  end if;
  if has_function_privilege('anon', 'public.transition_document(uuid,text,text,text)', 'EXECUTE') then
    raise exception 'P0_FAIL anon can execute transition_document';
  end if;
  if exists (
    select 1 from pg_policies
     where schemaname = 'public' and tablename = 'documents'
       and policyname = 'documents: editors insert'
  ) then
    raise exception 'P0_FAIL legacy permissive document INSERT policy remains';
  end if;
  if exists (
    select 1 from pg_policies
     where schemaname = 'public' and tablename = 'documents'
       and policyname = 'documents: editors update'
  ) then
    raise exception 'P0_FAIL legacy permissive document UPDATE policy remains';
  end if;
  if exists (
    select 1 from pg_policies
     where schemaname = 'storage' and tablename = 'objects'
       and policyname = 'document files: contributors upload'
  ) then
    raise exception 'P0_FAIL legacy broad Storage upload policy remains';
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
  if not exists (select 1 from public.import_batches where id = current_setting('test.other_party_import_batch_id')::uuid) then
    raise exception 'P0_FAIL import batch creator cannot read own batch';
  end if;
  if not exists (select 1 from public.audit_log where entity_type = 'import_batches' and entity_id = current_setting('test.other_party_import_batch_id')::uuid) then
    raise exception 'P0_FAIL import batch creator cannot read own audit';
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
  if exists (select 1 from public.comments where document_id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL other party read draft comments';
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

-- A party code such as pmc does not itself grant Project Manager oversight.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'wrong_party_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'wrong_party_user_id', 'role', 'authenticated')::text, true);
do $$
declare pid uuid; changed integer;
begin
  pid := current_setting('test.project_id')::uuid;
  update public.documents set title = title where id = current_setting('test.draft_document_id')::uuid;
  get diagnostics changed = row_count;
  if changed <> 0 then raise exception 'P0_FAIL other party edited draft'; end if;
  if public.is_project_manager(pid) then
    raise exception 'P0_FAIL pmc/party membership was treated as Project Manager';
  end if;
  if exists (select 1 from public.documents where id = current_setting('test.draft_document_id')::uuid) then
    raise exception 'P0_FAIL non-originating party can read draft';
  end if;
  if exists (select 1 from public.import_batches where id = current_setting('test.other_party_import_batch_id')::uuid) then
    raise exception 'P0_FAIL other party read another user's raw import batch';
  end if;
  if exists (select 1 from public.import_rows where batch_id = current_setting('test.other_party_import_batch_id')::uuid) then
    raise exception 'P0_FAIL other party read raw import rows';
  end if;
  if exists (select 1 from public.audit_log where entity_type = 'import_batches' and entity_id = current_setting('test.other_party_import_batch_id')::uuid) then
    raise exception 'P0_FAIL other party read import batch audit';
  end if;
  if exists (select 1 from public.ocr_jobs where id = current_setting('test.draft_ocr_job_id')::uuid) then
    raise exception 'P0_FAIL other party read OCR extraction for protected draft';
  end if;
end $$;

-- Project Manager: explicit flag grants read-only oversight, not role elevation.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'project_manager_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'project_manager_user_id', 'role', 'authenticated')::text, true);
do $$
declare pid uuid;
begin
  select project_id into pid from public.documents where id = current_setting('test.draft_document_id')::uuid;
  if public.project_role_of(pid) <> 'viewer' then
    raise exception 'P0_FAIL PM project role was unexpectedly elevated';
  end if;
  if public.can_manage_project(pid) or public.can_edit_documents(pid) or public.can_comment(pid) then
    raise exception 'P0_FAIL PM oversight flag granted write capability';
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
  if not exists (select 1 from public.ocr_jobs where id = current_setting('test.draft_ocr_job_id')::uuid) then
    raise exception 'P0_FAIL PM cannot read authorized draft OCR result';
  end if;
  if exists (select 1 from public.import_batches where id = current_setting('test.other_party_import_batch_id')::uuid) then
    raise exception 'P0_FAIL PM can read raw import staging data';
  end if;
  if exists (select 1 from public.audit_log where entity_type = 'import_batches' and entity_id = current_setting('test.other_party_import_batch_id')::uuid) then
    raise exception 'P0_FAIL PM can read import staging audit';
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
declare pid uuid;
begin
  select project_id into pid from public.documents where id = current_setting('test.draft_document_id')::uuid;
  if public.project_role_of(pid) is not null or public.is_project_member(pid) then
    raise exception 'P0_FAIL company admin inherited project membership';
  end if;
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

-- Only the originator and the currently assigned workflow party can
-- read a submitted document. A future/unassigned party cannot enumerate it.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'wrong_party_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'wrong_party_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  if exists (select 1 from public.documents where id = current_setting('test.submitted_document_id')::uuid) then
    raise exception 'P0_FAIL non-current workflow party read submitted document';
  end if;
end $$;

-- Current workflow reviewer has legitimate access to the submitted document.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'current_reviewer_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'current_reviewer_user_id', 'role', 'authenticated')::text, true);
do $$
declare v_status public.doc_lifecycle;
begin
  if not exists (select 1 from public.documents where id = current_setting('test.submitted_document_id')::uuid) then
    raise exception 'P0_FAIL current workflow party cannot read submitted document';
  end if;
  select (public.transition_document(current_setting('test.submitted_document_id')::uuid, 'start_review', null, null)).status into v_status;
  if v_status <> 'under_review' then raise exception 'P0_FAIL current workflow reviewer cannot start review'; end if;
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

-- Creator is allowed to submit their own eligible draft; a different member
-- of the originating party must not submit it on their behalf.
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'originator_peer_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'originator_peer_user_id', 'role', 'authenticated')::text, true);
do $$
begin
  begin
    perform public.transition_document(current_setting('test.draft_document_id')::uuid, 'submit', null, null);
    raise exception 'P0_FAIL non-creator submitted draft';
  exception when others then
    if sqlerrm = 'P0_FAIL non-creator submitted draft' then raise; end if;
    if sqlerrm <> 'CREATOR_ONLY_SUBMIT' then raise; end if;
  end;
end $$;

reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', :'creator_user_id', true);
select set_config('request.jwt.claims', json_build_object('sub', :'creator_user_id', 'role', 'authenticated')::text, true);
do $$
declare v_status public.doc_lifecycle;
begin
  select (public.transition_document(current_setting('test.draft_document_id')::uuid, 'submit', null, null)).status into v_status;
  if v_status <> 'submitted' then raise exception 'P0_FAIL creator could not submit own draft'; end if;
end $$;

reset role;
rollback;
