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
as $
  select pm.role
    from public.project_members pm
   where pm.project_id = _project
     and pm.user_id = auth.uid()
   limit 1
$;

create or replace function public.can_manage_project(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $
  select public.project_role_of(_project) = 'admin'
     and not public.is_project_manager(_project)
$;

create or replace function public.can_edit_documents(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $
  select public.project_role_of(_project) in ('admin','controller')
     and not public.is_project_manager(_project)
$;

create or replace function public.can_comment(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $
  select public.project_role_of(_project) in ('admin','controller','reviewer')
     and not public.is_project_manager(_project)
$;

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
      join public.project_members pm
        on pm.project_id = d.project_id
       and pm.company_id = d.company_id
       and pm.user_id = auth.uid()
     where d.id = _document
       and (
         pm.is_project_manager = true
         or (
           d.status <> 'draft'
           and pm.user_id = auth.uid()
         )
         or (
           d.status = 'draft'
           and (
             d.created_by = auth.uid()
             or pm.party = d.originator_party
           )
         )
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

-- Documents and every document child use the same visibility decision.
drop policy if exists "documents: members read" on public.documents;
create policy "documents: authorized readers" on public.documents
  for select to authenticated
  using (public.can_read_document(id));

drop policy if exists "revisions: members read" on public.document_revisions;
create policy "revisions: authorized readers" on public.document_revisions
  for select to authenticated
  using (public.can_read_document(document_id));

drop policy if exists "reviews: members read" on public.document_reviews;
create policy "reviews: authorized readers" on public.document_reviews
  for select to authenticated
  using (public.can_read_document(document_id));

drop policy if exists "attachments: members read" on public.attachments;
create policy "attachments: authorized readers" on public.attachments
  for select to authenticated
  using (public.can_read_document(document_id));

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
