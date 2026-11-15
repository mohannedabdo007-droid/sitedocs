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
      and project_id is not null
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

  -- Never copy comment bodies or bulky/private document fields into audit.
  if tg_table_name = 'comments' then
    diff := diff - 'body';
  elsif tg_table_name = 'documents' then
    diff := diff - 'description' - 'location' - 'metadata' - 'legacy_ref' - 'import_batch_id';
  end if;

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
