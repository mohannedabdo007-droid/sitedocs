-- P0-1 / P0-2: document-aware draft visibility, audit filtering and workflow authority.
-- Apply only to an isolated restored database until all security tests pass.
-- The explicit project_members.is_project_manager flag represents the approved
-- read-only oversight exception; it never grants mutation or workflow authority.

alter table public.project_members
  add column if not exists is_project_manager boolean not null default false;

create or replace function public.is_project_manager(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from public.project_members pm
      join public.projects p on p.id = pm.project_id and p.company_id = pm.company_id
     where pm.project_id = _project
       and pm.user_id = auth.uid()
       and pm.is_project_manager = true
  )
$$;

-- Company ownership is not project membership and must not be inherited as
-- project admin. Project authority requires an explicit project_members row.
create or replace function public.project_role_of(_project uuid)
returns public.project_role
language sql
stable
security definer
set search_path = public
as $p0$
  select pm.role
    from public.project_members pm
    join public.projects p on p.id = pm.project_id and p.company_id = pm.company_id
   where pm.project_id = _project
     and pm.user_id = auth.uid()
   limit 1
$p0$;

create or replace function public.project_party_of(_project uuid)
returns public.project_party
language sql
stable
security definer
set search_path = public
as $p0$
  select pm.party
    from public.project_members pm
    join public.projects p on p.id = pm.project_id and p.company_id = pm.company_id
   where pm.project_id = _project
     and pm.user_id = auth.uid()
   limit 1
$p0$;

create or replace function public.can_manage_project(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $p0$
  select public.project_role_of(_project) = 'admin'
     and not public.is_project_manager(_project)
$p0$;

create or replace function public.can_edit_documents(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $p0$
  select public.project_role_of(_project) in ('admin','controller')
     and not public.is_project_manager(_project)
$p0$;

create or replace function public.can_comment(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $p0$
  select public.project_role_of(_project) in ('admin','controller','reviewer')
     and not public.is_project_manager(_project)
$p0$;

-- Single source of truth for document visibility. Drafts are visible to the
-- creator, members of the originating party, and explicitly assigned PMs.
-- PM access is read-only; all other non-draft visibility still requires
-- explicit project membership. Company membership alone is never sufficient.
create or replace function public.can_read_document(_document uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from public.documents d
      join public.projects p on p.id = d.project_id and p.company_id = d.company_id
      join public.project_members pm
        on pm.project_id = d.project_id
       and pm.company_id = d.company_id
       and pm.user_id = auth.uid()
     where d.id = _document
       and (
         pm.is_project_manager = true
         or (
           d.status = 'draft'
           and (d.created_by = auth.uid() or pm.party = d.originator_party)
         )
         or (
           d.status in ('submitted','under_review')
           and pm.party in (d.originator_party, d.workflow_steps[d.current_step])
         )
         or (
           d.status = 'returned'
           and pm.party = d.originator_party
         )
         or (
           d.status in ('approved','closed')
           and pm.party = any(d.workflow_steps)
         )
       )
  )
$$;

-- A creator can edit only their own draft/returned/approved document. Project
-- role alone never grants the ability to edit another party's document.
create or replace function public.can_edit_document(_document uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from public.documents d
      join public.projects p on p.id = d.project_id and p.company_id = d.company_id
      join public.project_members pm
        on pm.project_id = d.project_id
       and pm.company_id = d.company_id
       and pm.user_id = auth.uid()
     where d.id = _document
       and d.created_by = auth.uid()
       and d.status in ('draft','returned','approved')
       and pm.party = d.originator_party
       and pm.role in ('admin','controller')
       and pm.is_project_manager = false
  )
$$;

-- File upload rights are document-scoped: the originator can attach to a
-- draft/returned document; only the active workflow party can attach while
-- the document is under review.
create or replace function public.can_attach_document(_document uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from public.documents d
      join public.projects p on p.id = d.project_id and p.company_id = d.company_id
      join public.project_members pm
        on pm.project_id = d.project_id
       and pm.company_id = d.company_id
       and pm.user_id = auth.uid()
     where d.id = _document
       and pm.role in ('admin','controller','reviewer')
       and pm.is_project_manager = false
       and (
         (d.status in ('draft','returned') and d.created_by = auth.uid() and pm.party = d.originator_party)
         or
         (d.status in ('submitted','under_review') and pm.party = d.workflow_steps[d.current_step])
       )
  )
$$;

-- Comments are also document-scoped. Draft discussion is limited to the
-- originating party; submitted-document discussion is limited to the current
-- workflow party and originator. A project manager remains read-only.
create or replace function public.can_comment_document(_document uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from public.documents d
      join public.projects p on p.id = d.project_id and p.company_id = d.company_id
      join public.project_members pm
        on pm.project_id = d.project_id
       and pm.company_id = d.company_id
       and pm.user_id = auth.uid()
     where d.id = _document
       and pm.role in ('admin','controller','reviewer')
       and pm.is_project_manager = false
       and (
         (d.status = 'draft' and pm.party = d.originator_party)
         or
         (d.status in ('submitted','under_review') and pm.party in (d.originator_party, d.workflow_steps[d.current_step]))
         or
         (d.status in ('returned','approved','closed') and pm.party = d.originator_party)
       )
  )
$$;

-- Only the first workflow party can create a document of that type.
create or replace function public.can_create_document(_project uuid, _type uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from public.projects p
      join public.project_members pm
        on pm.project_id = p.id
       and pm.company_id = p.company_id
     where p.id = _project
       and pm.user_id = auth.uid()
       and pm.role in ('admin','controller')
       and pm.is_project_manager = false
       and pm.party = coalesce(
         (select w.steps[1] from public.project_workflows w where w.project_id = _project and w.document_type_id = _type),
         (select w.steps[1] from public.project_workflows w where w.project_id = _project and w.document_type_id is null),
         'contractor'::public.project_party
       )
  )
$$;

revoke all on function public.is_project_manager(uuid) from public, anon;
grant execute on function public.is_project_manager(uuid) to authenticated;
revoke all on function public.can_read_document(uuid) from public, anon;
grant execute on function public.can_read_document(uuid) to authenticated;
revoke all on function public.project_role_of(uuid) from public, anon;
grant execute on function public.project_role_of(uuid) to authenticated;

revoke all on function public.is_project_member(uuid) from public, anon;
grant execute on function public.is_project_member(uuid) to authenticated;
revoke all on function public.project_party_of(uuid) from public, anon;
grant execute on function public.project_party_of(uuid) to authenticated;
revoke all on function public.can_manage_project(uuid) from public, anon;
grant execute on function public.can_manage_project(uuid) to authenticated;
revoke all on function public.can_edit_documents(uuid) from public, anon;
grant execute on function public.can_edit_documents(uuid) to authenticated;
revoke all on function public.can_comment(uuid) from public, anon;
grant execute on function public.can_comment(uuid) to authenticated;
revoke all on function public.can_edit_document(uuid) from public, anon;
grant execute on function public.can_edit_document(uuid) to authenticated;
revoke all on function public.can_attach_document(uuid) from public, anon;
grant execute on function public.can_attach_document(uuid) to authenticated;
revoke all on function public.can_comment_document(uuid) from public, anon;
grant execute on function public.can_comment_document(uuid) to authenticated;
revoke all on function public.can_create_document(uuid, uuid) from public, anon;
grant execute on function public.can_create_document(uuid, uuid) to authenticated;

-- Import staging contains raw document content before records are committed.
-- Restrict it to its creator and explicit project administrators, never all
-- controllers/reviewers in the project.
create or replace function public.can_access_import_batch(_batch uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
      from public.import_batches b
      join public.projects p on p.id = b.project_id and p.company_id = b.company_id
      join public.project_members pm
        on pm.project_id = b.project_id
       and pm.company_id = b.company_id
       and pm.user_id = auth.uid()
     where b.id = _batch
       and pm.is_project_manager = false
       and pm.role in ('admin','controller')
       and (b.created_by = auth.uid() or pm.role = 'admin')
  )
$$;
revoke all on function public.can_access_import_batch(uuid) from public, anon;
grant execute on function public.can_access_import_batch(uuid) to authenticated;

create or replace function public.import_batches_guard_update()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if new.project_id is distinct from old.project_id
     or new.company_id is distinct from old.company_id
     or new.document_type_id is distinct from old.document_type_id
     or new.created_by is distinct from old.created_by then
    raise exception 'IMPORT_BATCH_SCOPE_IMMUTABLE';
  end if;
  return new;
end
$$;
drop trigger if exists import_batches_guard_update on public.import_batches;
create trigger import_batches_guard_update
before update on public.import_batches
for each row execute function public.import_batches_guard_update();
revoke all on function public.import_batches_guard_update() from public, anon, authenticated;

-- Documents and every document child use the same visibility decision.
drop policy if exists "documents: members read" on public.documents;
create policy "documents: authorized readers" on public.documents
  for select to authenticated
  using (public.can_read_document(id));

-- Replace broad project-role write policies with document-scoped checks.
drop policy if exists "documents: editors insert" on public.documents;
create policy "documents: authorized originators insert" on public.documents
  for insert to authenticated with check (public.can_create_document(project_id, document_type_id));
drop policy if exists "documents: editors update" on public.documents;
create policy "documents: creator update own document" on public.documents
  for update to authenticated using (public.can_edit_document(id)) with check (public.can_edit_document(id));

drop policy if exists "revisions: members read" on public.document_revisions;
create policy "revisions: authorized readers" on public.document_revisions
  for select to authenticated
  using (public.can_read_document(document_id));

drop policy if exists "revisions: editors insert" on public.document_revisions;
create policy "revisions: authorized creator insert" on public.document_revisions
  for insert to authenticated with check (public.can_edit_document(document_id));

drop policy if exists "reviews: members read" on public.document_reviews;
create policy "reviews: authorized readers" on public.document_reviews
  for select to authenticated
  using (public.can_read_document(document_id));

drop policy if exists "attachments: members read" on public.attachments;
create policy "attachments: authorized readers" on public.attachments
  for select to authenticated
  using (public.can_read_document(document_id));

drop policy if exists "attachments: contributors insert" on public.attachments;
create policy "attachments: authorized document upload" on public.attachments
  for insert to authenticated with check (public.can_attach_document(document_id));

drop policy if exists "comments: read external or own party" on public.comments;
create policy "comments: authorized document readers" on public.comments
  for select to authenticated
  using (
    public.can_read_document(document_id)
    and (
      public.is_project_manager(project_id)
      or visibility = 'external'
      or author_party = public.project_party_of(project_id)
    )
  );

drop policy if exists "comments: contributors insert" on public.comments;
create policy "comments: authorized document discussion" on public.comments for insert to authenticated
  with check (public.can_comment_document(document_id) and author_id = auth.uid() and author_party = public.project_party_of(project_id));

-- Import staging rows and OCR extraction are document-adjacent content;
-- they must not become side channels around document visibility.
drop policy if exists "import_batches: editors read" on public.import_batches;
create policy "import_batches: authorized readers" on public.import_batches
  for select to authenticated using (public.can_access_import_batch(id));
drop policy if exists "import_batches: editors insert" on public.import_batches;
create policy "import_batches: authorized creators insert" on public.import_batches
  for insert to authenticated with check (
    created_by = auth.uid()
    and public.can_create_document(project_id, document_type_id)
  );
drop policy if exists "import_batches: editors update" on public.import_batches;
create policy "import_batches: authorized creators update" on public.import_batches
  for update to authenticated using (public.can_access_import_batch(id))
  with check (public.can_access_import_batch(id));

drop policy if exists "import_rows: editors read" on public.import_rows;
create policy "import_rows: authorized batch readers" on public.import_rows
  for select to authenticated using (
    public.can_access_import_batch(batch_id)
    and exists (
      select 1 from public.import_batches b
       where b.id = batch_id and b.project_id = import_rows.project_id and b.company_id = import_rows.company_id
    )
  );
drop policy if exists "import_rows: editors insert" on public.import_rows;
create policy "import_rows: authorized batch insert" on public.import_rows
  for insert to authenticated with check (
    public.can_access_import_batch(batch_id)
    and exists (
      select 1 from public.import_batches b
       where b.id = batch_id and b.project_id = import_rows.project_id and b.company_id = import_rows.company_id
    )
  );
drop policy if exists "import_rows: editors update" on public.import_rows;
create policy "import_rows: authorized batch update" on public.import_rows
  for update to authenticated using (public.can_access_import_batch(batch_id))
  with check (
    public.can_access_import_batch(batch_id)
    and exists (
      select 1 from public.import_batches b
       where b.id = batch_id and b.project_id = import_rows.project_id and b.company_id = import_rows.company_id
    )
  );

drop policy if exists "ocr_jobs: project editors read" on public.ocr_jobs;
create policy "ocr_jobs: authorized document readers" on public.ocr_jobs
  for select to authenticated
  using (
    exists (
      select 1 from public.attachments a
       where a.id = attachment_id
         and a.project_id = ocr_jobs.project_id
         and public.can_read_document(a.document_id)
    )
  );

-- Audit entries tied to a document inherit the exact visibility of that
-- document. Project/company events without a document keep their own scope.
drop policy if exists "audit: project members read" on public.audit_log;
create policy "audit: document-aware readers" on public.audit_log
  for select to authenticated
  using (
    (
      document_id is not null
      and public.can_read_document(document_id)
    )
    or (
      document_id is null
      and entity_type = 'import_batches'
      and public.can_access_import_batch(entity_id)
    )
    or (
      document_id is null
      and project_id is not null
      and entity_type <> 'import_batches'
      and public.is_project_member(project_id)
    )
    or (
      document_id is null
      and project_id is null
      and company_id is not null
      and public.is_company_admin(company_id)
    )
  );

-- Storage objects must have a registered attachment row and the caller must
-- be allowed to read its parent document. A project-folder prefix alone is
-- not sufficient authorization.
drop policy if exists "document files: project members read" on storage.objects;
create policy "document files: authorized attachment readers" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'document-files'
    and exists (
      select 1
        from public.attachments a
       where a.storage_path = name
         and a.project_id = public.storage_project_id(name)
         and public.can_read_document(a.document_id)
    )
  );

drop policy if exists "document files: contributors upload" on storage.objects;
create policy "document files: authorized attachment upload" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'document-files'
    and exists (
      select 1
        from public.attachments a
       where a.storage_path = name
         and a.project_id = public.storage_project_id(name)
         and public.can_attach_document(a.document_id)
    )
  );

-- Minimize document audit payloads. The audit row remains linked to its
-- document and is filtered by the document-aware SELECT policy above.
create or replace function public.audit_row()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  n jsonb := case when tg_op <> 'DELETE' then to_jsonb(new) end;
  o jsonb := case when tg_op <> 'INSERT' then to_jsonb(old) end;
  r jsonb := coalesce(n, o);
  diff jsonb := '{}'::jsonb;
  k text;
  v_company uuid;
  v_project uuid;
  v_doc uuid;
  v_allowed_fields text[];
begin
  if tg_op = 'UPDATE' then
    for k in select jsonb_object_keys(n) loop
      if k not in ('updated_at') and (n->k) is distinct from (o->k) then
        diff := diff || jsonb_build_object(k, jsonb_build_object('from', o->k, 'to', n->k));
      end if;
    end loop;
    if diff = '{}'::jsonb then return new; end if;
    if tg_table_name = 'numbering_schemes' and (diff - 'next_seq') = '{}'::jsonb then return new; end if;
  elsif tg_op = 'INSERT' then
    diff := n;
  else
    diff := o;
  end if;

  -- Strict per-entity allowlists: do not copy full rows, free-text content,
  -- storage paths, raw import mappings, or private metadata into audit.
  v_allowed_fields := case tg_table_name
    when 'companies' then array['id','name','name_ar','code','created_by','created_at','updated_at']
    when 'company_members' then array['id','company_id','user_id','role','created_at']
    when 'projects' then array['id','company_id','code','name','name_ar','client_name','location','status','start_date','created_by','created_at','updated_at']
    when 'project_members' then array['id','project_id','company_id','user_id','party','role','organization','is_project_manager','created_at']
    when 'project_response_codes' then array['id','project_id','company_id','code','label_en','label_ar','outcome','active','sort']
    when 'project_workflows' then array['id','project_id','company_id','document_type_id','steps','review_days','requires_review','uses_response_codes','updated_at']
    when 'numbering_schemes' then array['id','project_id','company_id','document_type_id','discipline_id','pattern','next_seq','updated_at']
    when 'documents' then array['id','company_id','project_id','document_type_id','discipline_id','doc_number','title','direction','from_party','to_party','originator_party','status','current_response_code','current_rev_label','current_rev_index','workflow_steps','current_step','requires_review','uses_response_codes','review_days','submitted_at','due_date','last_response_at','closed_at','created_by','created_at','updated_at']
    when 'document_revisions' then array['id','document_id','project_id','company_id','rev_index','rev_label','submitted_at','response_code','responded_at','response_by','source','created_by','created_at']
    when 'document_reviews' then array['id','document_id','revision_id','project_id','company_id','step','party','action','from_status','to_status','response_code','actor_id','created_at']
    when 'attachments' then array['id','document_id','revision_id','project_id','company_id','mime_type','size_bytes','uploaded_by','created_at']
    when 'comments' then array['id','document_id','revision_id','project_id','company_id','visibility','author_id','author_party','created_at']
    when 'import_batches' then array['id','project_id','company_id','document_type_id','status','total_rows','created_by','created_at','updated_at']
    else array['id']
  end;
  select coalesce(jsonb_object_agg(e.key, e.value), '{}'::jsonb)
    into diff
    from jsonb_each(diff) e
   where e.key = any(v_allowed_fields);

  v_company := coalesce((r->>'company_id')::uuid, case when tg_table_name = 'companies' then (r->>'id')::uuid end);
  v_project := coalesce((r->>'project_id')::uuid, case when tg_table_name = 'projects' then (r->>'id')::uuid end);
  v_doc := case when tg_table_name = 'documents' then (r->>'id')::uuid else (r->>'document_id')::uuid end;

  insert into public.audit_log (company_id, project_id, document_id, entity_type, entity_id, action, actor_id, changes)
  values (v_company, v_project, v_doc, tg_table_name, (r->>'id')::uuid, lower(tg_op), auth.uid(), diff);
  return coalesce(new, old);
end
$$;
revoke all on function public.audit_row() from public, anon, authenticated;


-- Remove the default PUBLIC EXECUTE grant from the privileged workflow RPC.
-- It remains available to authenticated clients, with all authorization checks
-- performed server-side in the function body.
revoke all on function public.transition_document(uuid, text, text, text) from public, anon;
grant execute on function public.transition_document(uuid, text, text, text) to authenticated;

create or replace function public.transition_document(_doc uuid, _action text, _response_code text default null, _notes text default null)
returns public.documents
language plpgsql
security definer
set search_path = public
as $$
declare
  d public.documents;
  r public.project_role;
  p public.project_party;
  cur public.project_party;
  rc public.project_response_codes;
  n_steps int;
  new_status public.doc_lifecycle;
  new_step int;
begin
  select * into d from public.documents where id = _doc for update;
  if not found then raise exception 'NOT_FOUND'; end if;

  r := public.project_role_of(d.project_id);
  p := public.project_party_of(d.project_id);
  if r is null or r = 'viewer' or public.is_project_manager(d.project_id) then
    raise exception 'FORBIDDEN';
  end if;

  n_steps := coalesce(array_length(d.workflow_steps, 1), 1);
  cur := d.workflow_steps[d.current_step];
  new_step := d.current_step;
  perform set_config('app.doc_transition', 'on', true);

  if _action = 'submit' then
    if d.status not in ('draft','returned') then raise exception 'INVALID_TRANSITION'; end if;
    if r not in ('admin','controller') then raise exception 'FORBIDDEN'; end if;
    if auth.uid() is distinct from d.created_by then raise exception 'CREATOR_ONLY_SUBMIT'; end if;
    if p is distinct from d.workflow_steps[1] then
      raise exception 'FORBIDDEN: only the originating party submits';
    end if;
    new_status := 'submitted';
    new_step := case when d.requires_review and n_steps >= 2 then 2 else 1 end;
    update public.documents set status = new_status, current_step = new_step, submitted_at = now(),
      current_response_code = null, closed_at = null,
      due_date = case when d.requires_review then current_date + d.review_days else d.due_date end
     where id = d.id;
    update public.document_revisions set submitted_at = now() where id = d.current_revision_id;

  elsif _action = 'start_review' then
    if not d.requires_review or d.status <> 'submitted' then raise exception 'INVALID_TRANSITION'; end if;
    if auth.uid() = d.created_by then raise exception 'SELF_REVIEW_FORBIDDEN'; end if;
    if p is distinct from cur then raise exception 'FORBIDDEN: not the reviewing party'; end if;
    new_status := 'under_review';
    update public.documents set status = new_status where id = d.id;

  elsif _action in ('respond','return') then
    if not d.requires_review or d.status not in ('submitted','under_review') then raise exception 'INVALID_TRANSITION'; end if;
    if auth.uid() = d.created_by then raise exception 'SELF_REVIEW_FORBIDDEN'; end if;
    if p is distinct from cur then raise exception 'FORBIDDEN: not the reviewing party'; end if;
    if _action = 'respond' and d.uses_response_codes then
      select * into rc
        from public.project_response_codes
       where project_id = d.project_id
         and code = upper(btrim(_response_code))
         and active;
      if not found then raise exception 'RESPONSE_CODE_REQUIRED'; end if;
    elsif _response_code is not null and btrim(_response_code) <> '' then
      raise exception 'RESPONSE_CODES_NOT_USED';
    end if;
    if _action = 'return' and coalesce(btrim(_notes), '') = '' then raise exception 'NOTES_REQUIRED'; end if;

    if _action = 'return' or rc.outcome = 'return' then
      new_status := 'returned';
      new_step := 1;
    elsif rc.outcome = 'close' then
      new_status := 'closed';
    elsif d.current_step < n_steps then
      new_status := 'submitted';
      new_step := d.current_step + 1;
    else
      new_status := 'approved';
    end if;

    update public.documents set status = new_status, current_step = new_step, last_response_at = now(),
      current_response_code = case when rc.code is not null then rc.code else d.current_response_code end,
      closed_at = case when new_status = 'closed' then now() else closed_at end,
      due_date = case when new_status = 'submitted' then current_date + d.review_days else due_date end
     where id = d.id;
    update public.document_revisions set response_code = coalesce(rc.code, response_code), responded_at = now(),
      response_by = auth.uid(), response_notes = nullif(btrim(_notes), '')
     where id = d.current_revision_id;

  elsif _action = 'close' then
    if r not in ('admin','controller') then raise exception 'FORBIDDEN'; end if;
    if not (d.status = 'approved' or (not d.requires_review and d.status = 'submitted')) then
      raise exception 'INVALID_TRANSITION';
    end if;
    if d.requires_review then
      if p is distinct from d.workflow_steps[array_length(d.workflow_steps, 1)] then
        raise exception 'FORBIDDEN: close requires the final workflow party';
      end if;
    elsif p is distinct from d.originator_party then
      raise exception 'FORBIDDEN: close requires the originating party when review is disabled';
    end if;
    new_status := 'closed';
    update public.documents set status = new_status, closed_at = now() where id = d.id;
  else
    raise exception 'UNKNOWN_ACTION';
  end if;

  insert into public.document_reviews
    (document_id, revision_id, project_id, company_id, step, party, action, from_status, to_status, response_code, notes, actor_id)
  values
    (d.id, d.current_revision_id, d.project_id, d.company_id, d.current_step, p, _action, d.status, new_status, rc.code, nullif(btrim(_notes), ''), auth.uid());

  perform set_config('app.doc_transition', '', true);
  select * into d from public.documents where id = _doc;
  return d;
exception
  when others then
    perform set_config('app.doc_transition', '', true);
    raise;
end
$$;


create or replace function public.save_import_validation(_batch uuid, _rows jsonb)
returns int
language plpgsql
security invoker
set search_path = public
as $$
declare n int;
begin
  if not public.can_access_import_batch(_batch) then
    raise exception 'FORBIDDEN';
  end if;
  update public.import_rows r
     set mapped = x.mapped, validation_status = x.validation_status,
         messages = coalesce(x.messages, '[]'::jsonb), decision = x.decision
    from jsonb_to_recordset(_rows) as x(id uuid, mapped jsonb, validation_status text, messages jsonb, decision text)
   where r.id = x.id and r.batch_id = _batch and r.commit_status is null;
  get diagnostics n = row_count;
  return n;
end
$$;
revoke all on function public.save_import_validation(uuid, jsonb) from public, anon;
grant execute on function public.save_import_validation(uuid, jsonb) to authenticated;

create or replace function public.commit_import_rows(_batch uuid, _limit int default 300)
returns jsonb language plpgsql security definer set search_path = public as $
declare
  b public.import_batches; r record; doc public.documents; m jsonb;
  v_created int := 0; v_rev int := 0; v_skip int := 0; v_fail int := 0; v_remaining int;
  v_rev_index int; v_rev_label text; v_status public.doc_lifecycle; rid uuid;
begin
  select * into b from public.import_batches where id = _batch for update;
  if not found then raise exception 'BATCH_NOT_FOUND'; end if;
  if not public.can_access_import_batch(b.id) or not public.can_create_document(b.project_id, b.document_type_id) then raise exception 'FORBIDDEN'; end if;
  if b.status not in ('validated','committing') then raise exception 'BATCH_NOT_VALIDATED'; end if;
  if b.document_type_id is null then raise exception 'DOCUMENT_TYPE_REQUIRED'; end if;

  perform set_config('app.doc_import', 'on', true);
  perform set_config('app.doc_transition', 'on', true);
  update public.import_batches set status = 'committing' where id = b.id;

  for r in
    select * from public.import_rows
     where batch_id = b.id and decision = 'import' and commit_status is null and validation_status in ('valid','warning')
     order by mapped->>'doc_number', coalesce((mapped->>'rev_index')::int, 0), row_number
     limit greatest(1, least(_limit, 1000))
  loop
    begin
      m := r.mapped;
      if coalesce(btrim(m->>'doc_number'), '') = '' or m->>'status' is null then
        raise exception 'MISSING_REQUIRED_FIELDS';
      end if;
      v_status := (m->>'status')::public.doc_lifecycle;
      v_rev_index := coalesce((m->>'rev_index')::int, 0);
      v_rev_label := coalesce(nullif(btrim(m->>'rev_label'), ''), lpad(v_rev_index::text, 2, '0'));

      select * into doc from public.documents where project_id = b.project_id and doc_number = btrim(m->>'doc_number');
      if not found then
        insert into public.documents (project_id, document_type_id, discipline_id, doc_number, title, location, status,
          current_response_code, submitted_at, due_date, last_response_at, closed_at, source, import_batch_id, legacy_ref, metadata, created_by)
        values (b.project_id, b.document_type_id, nullif(m->>'discipline_id', '')::uuid, btrim(m->>'doc_number'),
          coalesce(nullif(btrim(m->>'title'), ''), btrim(m->>'doc_number')), nullif(m->>'location', ''), v_status,
          nullif(m->>'response_code', ''), (m->>'submitted_at')::timestamptz, (m->>'due_date')::date,
          (m->>'responded_at')::timestamptz,
          case when v_status = 'closed' then coalesce((m->>'responded_at')::timestamptz, now()) end,
          'import', b.id, btrim(m->>'doc_number'),
          jsonb_build_object('import', jsonb_build_object('batch', b.id, 'row', r.row_number, 'sheet', b.sheet_name), 'extra', coalesce(m->'extra', '{}'::jsonb), 'remarks', m->>'remarks'),
          auth.uid())
        returning * into doc;
        insert into public.document_revisions (document_id, project_id, company_id, rev_index, rev_label, submitted_at, response_code, responded_at, response_notes, source, created_by)
        values (doc.id, doc.project_id, doc.company_id, v_rev_index, v_rev_label, (m->>'submitted_at')::timestamptz,
          nullif(m->>'response_code', ''), (m->>'responded_at')::timestamptz, nullif(m->>'remarks', ''), 'import', auth.uid());
        update public.import_rows set commit_status = 'created', committed_document_id = doc.id, committed_at = now() where id = r.id;
        v_created := v_created + 1;
      elsif doc.document_type_id <> b.document_type_id then
        raise exception 'NUMBER_EXISTS_WITH_OTHER_TYPE';
      elsif exists (select 1 from public.document_revisions where document_id = doc.id and (rev_index = v_rev_index or rev_label = v_rev_label)) then
        update public.import_rows set commit_status = 'skipped_existing', committed_document_id = doc.id, committed_at = now(),
          messages = messages || jsonb_build_array('Revision already exists – existing data kept unchanged') where id = r.id;
        v_skip := v_skip + 1;
      else
        insert into public.document_revisions (document_id, project_id, company_id, rev_index, rev_label, submitted_at, response_code, responded_at, response_notes, source, created_by)
        values (doc.id, doc.project_id, doc.company_id, v_rev_index, v_rev_label, (m->>'submitted_at')::timestamptz,
          nullif(m->>'response_code', ''), (m->>'responded_at')::timestamptz, nullif(m->>'remarks', ''), 'import', auth.uid())
        returning id into rid;
        if v_rev_index > doc.current_rev_index then
          update public.documents set status = v_status, current_response_code = nullif(m->>'response_code', ''),
            submitted_at = (m->>'submitted_at')::timestamptz, last_response_at = (m->>'responded_at')::timestamptz,
            due_date = coalesce((m->>'due_date')::date, due_date),
            current_step = case when v_status in ('submitted','under_review') and requires_review and array_length(workflow_steps,1) >= 2 then 2 else 1 end,
            closed_at = case when v_status = 'closed' then coalesce((m->>'responded_at')::timestamptz, now()) end
           where id = doc.id;
        end if;
        update public.import_rows set commit_status = 'revision_added', committed_document_id = doc.id, committed_at = now() where id = r.id;
        v_rev := v_rev + 1;
      end if;
    exception when others then
      update public.import_rows set commit_status = 'failed', messages = messages || jsonb_build_array(sqlerrm) where id = r.id;
      v_fail := v_fail + 1;
    end;
  end loop;

  select count(*) into v_remaining from public.import_rows
   where batch_id = b.id and decision = 'import' and commit_status is null and validation_status in ('valid','warning');
  if v_remaining = 0 then
    update public.import_batches set status = 'committed' where id = b.id;
  end if;
  perform set_config('app.doc_import', '', true);
  perform set_config('app.doc_transition', '', true);
  return jsonb_build_object('created', v_created, 'revisions_added', v_rev, 'skipped_existing', v_skip, 'failed', v_fail, 'remaining', v_remaining);
end $

-- Keep authorization helpers callable only by authenticated sessions.
revoke all on function public.is_company_member(uuid) from public, anon;
grant execute on function public.is_company_member(uuid) to authenticated;
revoke all on function public.is_company_admin(uuid) from public, anon;
grant execute on function public.is_company_admin(uuid) to authenticated;
revoke all on function public.shares_scope_with(uuid) from public, anon;
grant execute on function public.shares_scope_with(uuid) to authenticated;

-- Trigger-only SECURITY DEFINER functions are not client RPCs.
revoke all on function public.handle_new_user() from public, anon, authenticated;
revoke all on function public.set_scope_from_project() from public, anon, authenticated;
revoke all on function public.set_scope_from_document() from public, anon, authenticated;
revoke all on function public.comments_before_insert() from public, anon, authenticated;
revoke all on function public.import_rows_scope() from public, anon, authenticated;
revoke all on function public.documents_before_insert() from public, anon, authenticated;
revoke all on function public.documents_after_insert() from public, anon, authenticated;
revoke all on function public.revisions_before_insert() from public, anon, authenticated;
revoke all on function public.revisions_after_insert() from public, anon, authenticated;

-- Explicitly remove default PUBLIC execution from callable privileged RPCs.
-- Only authenticated users may invoke them; each function performs its own
-- tenant, project, party, lifecycle and actor checks.
revoke all on function public.create_company(text, text, text) from public, anon;
grant execute on function public.create_company(text, text, text) to authenticated;
revoke all on function public.create_project(uuid, text, text, public.project_party, text, text, text) from public, anon;
grant execute on function public.create_project(uuid, text, text, public.project_party, text, text, text) to authenticated;
revoke all on function public.add_project_member(uuid, text, public.project_party, public.project_role, text) from public, anon;
grant execute on function public.add_project_member(uuid, text, public.project_party, public.project_role, text) to authenticated;
revoke all on function public.commit_import_rows(uuid, integer) from public, anon;
grant execute on function public.commit_import_rows(uuid, integer) to authenticated;
revoke all on function public.preview_document_number(uuid, uuid, uuid) from public, anon;
grant execute on function public.preview_document_number(uuid, uuid, uuid) to authenticated;
revoke all on function public.add_company_member(uuid, text, public.company_role) from public, anon;
grant execute on function public.add_company_member(uuid, text, public.company_role) to authenticated;
revoke all on function public.save_import_validation(uuid, jsonb) from public, anon;
grant execute on function public.save_import_validation(uuid, jsonb) to authenticated;
revoke all on function public.existing_revisions_for_numbers(uuid, text[]) from public, anon;
grant execute on function public.existing_revisions_for_numbers(uuid, text[]) to authenticated;
