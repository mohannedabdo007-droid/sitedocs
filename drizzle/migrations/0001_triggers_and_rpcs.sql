-- ===== Generic helpers =====
create or replace function public.set_updated_at()
returns trigger language plpgsql set search_path = public as $$
begin new.updated_at := now(); return new; end $$;

create trigger profiles_updated before update on public.profiles for each row execute function public.set_updated_at();
create trigger companies_updated before update on public.companies for each row execute function public.set_updated_at();
create trigger projects_updated before update on public.projects for each row execute function public.set_updated_at();
create trigger documents_updated before update on public.documents for each row execute function public.set_updated_at();
create trigger workflows_updated before update on public.project_workflows for each row execute function public.set_updated_at();
create trigger numbering_updated before update on public.numbering_schemes for each row execute function public.set_updated_at();
create trigger import_batches_updated before update on public.import_batches for each row execute function public.set_updated_at();

-- New user -> profile
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email, full_name)
  values (new.id, new.email, coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name', split_part(new.email,'@',1)))
  on conflict (id) do nothing;
  return new;
end $$;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_user();

-- Tenant scope is always derived from the parent, never trusted from the client
create or replace function public.set_scope_from_project()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  select company_id into new.company_id from public.projects where id = new.project_id;
  if new.company_id is null then raise exception 'PROJECT_NOT_FOUND'; end if;
  return new;
end $$;
create trigger project_members_scope before insert or update of project_id on public.project_members for each row execute function public.set_scope_from_project();
create trigger response_codes_scope before insert or update of project_id on public.project_response_codes for each row execute function public.set_scope_from_project();
create trigger workflows_scope before insert or update of project_id on public.project_workflows for each row execute function public.set_scope_from_project();
create trigger numbering_scope before insert or update of project_id on public.numbering_schemes for each row execute function public.set_scope_from_project();
create trigger import_batches_scope before insert or update of project_id on public.import_batches for each row execute function public.set_scope_from_project();

create or replace function public.set_scope_from_document()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  select project_id, company_id into new.project_id, new.company_id from public.documents where id = new.document_id;
  if new.project_id is null then raise exception 'DOCUMENT_NOT_FOUND'; end if;
  if new.revision_id is not null and not exists (
    select 1 from public.document_revisions where id = new.revision_id and document_id = new.document_id) then
    raise exception 'REVISION_MISMATCH';
  end if;
  return new;
end $$;
create trigger attachments_scope before insert on public.attachments for each row execute function public.set_scope_from_document();

create or replace function public.comments_before_insert()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  select project_id, company_id into new.project_id, new.company_id from public.documents where id = new.document_id;
  if new.project_id is null then raise exception 'DOCUMENT_NOT_FOUND'; end if;
  if new.revision_id is not null and not exists (
    select 1 from public.document_revisions where id = new.revision_id and document_id = new.document_id) then
    raise exception 'REVISION_MISMATCH';
  end if;
  new.author_id := auth.uid();
  new.author_party := public.project_party_of(new.project_id);
  if new.author_party is null then raise exception 'NOT_A_PROJECT_PARTY'; end if;
  return new;
end $$;
create trigger comments_scope before insert on public.comments for each row execute function public.comments_before_insert();

create or replace function public.import_rows_scope()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  select project_id, company_id into new.project_id, new.company_id from public.import_batches where id = new.batch_id;
  if new.project_id is null then raise exception 'BATCH_NOT_FOUND'; end if;
  return new;
end $$;
create trigger import_rows_scope before insert on public.import_rows for each row execute function public.import_rows_scope();

-- ===== Document numbering =====
create or replace function public.format_doc_number(_pattern text, _project text, _type text, _disc text, _seq int, _at timestamptz default now())
returns text language plpgsql stable set search_path = public as $$
declare res text := _pattern; m text[]; s text := _seq::text; w int;
begin
  res := replace(res, '{PROJECT}', coalesce(_project, ''));
  res := replace(res, '{TYPE}', coalesce(_type, ''));
  res := replace(res, '{DISC}', coalesce(nullif(_disc, ''), 'GEN'));
  res := replace(res, '{YYYY}', to_char(_at, 'YYYY'));
  res := replace(res, '{YY}', to_char(_at, 'YY'));
  loop
    m := regexp_match(res, '\{SEQ:(\d+)\}');
    exit when m is null;
    w := least(m[1]::int, 10);
    res := regexp_replace(res, '\{SEQ:\d+\}', case when length(s) >= w then s else lpad(s, w, '0') end);
  end loop;
  res := replace(res, '{SEQ}', s);
  return res;
end $$;

create or replace function public.resolve_numbering_scheme(_project uuid, _type uuid, _disc uuid)
returns public.numbering_schemes language plpgsql security definer set search_path = public as $$
declare sch public.numbering_schemes;
begin
  select * into sch from public.numbering_schemes
   where project_id = _project and document_type_id = _type and discipline_id is not distinct from _disc;
  if not found then
    select * into sch from public.numbering_schemes
     where project_id = _project and document_type_id = _type and discipline_id is null;
  end if;
  return sch;
end $$;
revoke execute on function public.resolve_numbering_scheme(uuid, uuid, uuid) from public, anon, authenticated;

-- Preview the next number without consuming it
create or replace function public.preview_document_number(_project uuid, _type uuid, _disc uuid)
returns text language plpgsql stable security definer set search_path = public as $$
declare sch public.numbering_schemes; p text; t text; d text;
begin
  if not public.is_project_member(_project) then raise exception 'FORBIDDEN'; end if;
  sch := public.resolve_numbering_scheme(_project, _type, _disc);
  select code into p from public.projects where id = _project;
  select code into t from public.document_types where id = _type;
  select code into d from public.disciplines where id = _disc;
  return public.format_doc_number(coalesce(sch.pattern, '{PROJECT}-{TYPE}-{DISC}-{SEQ:4}'), p, t, d, coalesce(sch.next_seq, 1));
end $$;

-- ===== Documents: before insert (numbering, workflow snapshot) =====
create or replace function public.documents_before_insert()
returns trigger language plpgsql security definer set search_path = public as $$
declare
  importing boolean := coalesce(current_setting('app.doc_import', true), '') = 'on';
  proj public.projects; typ public.document_types; disc_code text;
  tw public.project_workflows; dw public.project_workflows;
  sch public.numbering_schemes; candidate text; seq int;
begin
  select * into proj from public.projects where id = new.project_id;
  if not found then raise exception 'PROJECT_NOT_FOUND'; end if;
  select * into typ from public.document_types where id = new.document_type_id;
  if not found then raise exception 'TYPE_NOT_FOUND'; end if;
  select code into disc_code from public.disciplines where id = new.discipline_id;

  new.company_id := proj.company_id;
  if not importing then
    new.created_by := auth.uid();
    new.source := 'manual';
    new.status := 'draft';
    new.current_response_code := null;
    new.submitted_at := null; new.last_response_at := null; new.closed_at := null;
    new.import_batch_id := null;
  end if;
  new.current_revision_id := null;
  new.current_rev_index := 0;

  select * into tw from public.project_workflows where project_id = new.project_id and document_type_id = new.document_type_id;
  select * into dw from public.project_workflows where project_id = new.project_id and document_type_id is null;
  new.workflow_steps := coalesce(tw.steps, dw.steps, '{contractor,consultant}'::public.project_party[]);
  new.review_days := coalesce(tw.review_days, dw.review_days, 7);
  new.requires_review := coalesce(tw.requires_review, typ.requires_review);
  new.uses_response_codes := coalesce(tw.uses_response_codes, typ.uses_response_codes);
  new.originator_party := new.workflow_steps[1];
  new.current_step := case when new.status in ('submitted','under_review') and new.requires_review and array_length(new.workflow_steps,1) >= 2 then 2 else 1 end;
  if not typ.has_direction then new.direction := null; end if;

  if new.doc_number is null or btrim(new.doc_number) = '' then
    sch := public.resolve_numbering_scheme(new.project_id, new.document_type_id, new.discipline_id);
    if sch.id is null then
      insert into public.numbering_schemes (project_id, company_id, document_type_id, discipline_id, pattern, next_seq)
      values (new.project_id, proj.company_id, new.document_type_id, null, '{PROJECT}-{TYPE}-{DISC}-{SEQ:4}', 1)
      on conflict do nothing;
      sch := public.resolve_numbering_scheme(new.project_id, new.document_type_id, new.discipline_id);
    end if;
    select * into sch from public.numbering_schemes where id = sch.id for update;
    seq := sch.next_seq;
    loop
      candidate := public.format_doc_number(sch.pattern, proj.code, typ.code, disc_code, seq);
      seq := seq + 1;
      exit when not exists (select 1 from public.documents where project_id = new.project_id and doc_number = candidate);
      if seq > sch.next_seq + 100000 then raise exception 'NUMBERING_EXHAUSTED'; end if;
    end loop;
    update public.numbering_schemes set next_seq = seq where id = sch.id;
    new.doc_number := candidate;
  else
    new.doc_number := btrim(new.doc_number);
  end if;
  return new;
end $$;
create trigger documents_before_insert before insert on public.documents for each row execute function public.documents_before_insert();

-- After insert: create initial revision 00 (manual creation only)
create or replace function public.documents_after_insert()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if coalesce(current_setting('app.doc_import', true), '') <> 'on' then
    insert into public.document_revisions (document_id, project_id, company_id, rev_index, rev_label, change_note, created_by)
    values (new.id, new.project_id, new.company_id, 0, '00', 'Initial issue', auth.uid());
  end if;
  return new;
end $$;
create trigger documents_after_insert after insert on public.documents for each row execute function public.documents_after_insert();

-- Guard: lifecycle / workflow / identity columns change only through controlled functions
create or replace function public.documents_guard_update()
returns trigger language plpgsql set search_path = public as $$
begin
  if coalesce(current_setting('app.doc_transition', true), '') = 'on' then return new; end if;
  if new.status is distinct from old.status
     or new.current_response_code is distinct from old.current_response_code
     or new.current_step is distinct from old.current_step
     or new.workflow_steps is distinct from old.workflow_steps
     or new.requires_review is distinct from old.requires_review
     or new.uses_response_codes is distinct from old.uses_response_codes
     or new.review_days is distinct from old.review_days
     or new.originator_party is distinct from old.originator_party
     or new.submitted_at is distinct from old.submitted_at
     or new.last_response_at is distinct from old.last_response_at
     or new.closed_at is distinct from old.closed_at
     or new.current_revision_id is distinct from old.current_revision_id
     or new.current_rev_label is distinct from old.current_rev_label
     or new.current_rev_index is distinct from old.current_rev_index
     or new.doc_number is distinct from old.doc_number
     or new.document_type_id is distinct from old.document_type_id
     or new.project_id is distinct from old.project_id
     or new.company_id is distinct from old.company_id
     or new.created_by is distinct from old.created_by
     or new.source is distinct from old.source
     or new.import_batch_id is distinct from old.import_batch_id then
    raise exception 'PROTECTED_FIELDS: use workflow actions or a new revision';
  end if;
  return new;
end $$;
create trigger documents_guard_update before update on public.documents for each row execute function public.documents_guard_update();

-- ===== Revisions =====
create or replace function public.revisions_before_insert()
returns trigger language plpgsql security definer set search_path = public as $$
declare importing boolean := coalesce(current_setting('app.doc_import', true), '') = 'on'; d public.documents;
begin
  select * into d from public.documents where id = new.document_id for update;
  if not found then raise exception 'DOCUMENT_NOT_FOUND'; end if;
  new.project_id := d.project_id;
  new.company_id := d.company_id;
  if not importing then
    new.created_by := coalesce(auth.uid(), new.created_by);
    new.source := 'manual';
    new.submitted_at := null; new.response_code := null; new.responded_at := null; new.response_by := null; new.response_notes := null;
    if exists (select 1 from public.document_revisions where document_id = d.id) then
      if d.status not in ('returned','approved') then
        raise exception 'REVISION_NOT_ALLOWED: a new revision requires status Returned or Approved';
      end if;
      select coalesce(max(rev_index), -1) + 1 into new.rev_index from public.document_revisions where document_id = d.id;
    else
      new.rev_index := 0;
    end if;
  end if;
  if new.rev_label is null or btrim(new.rev_label) = '' then
    new.rev_label := lpad(new.rev_index::text, 2, '0');
  end if;
  return new;
end $$;
create trigger revisions_before_insert before insert on public.document_revisions for each row execute function public.revisions_before_insert();

create or replace function public.revisions_after_insert()
returns trigger language plpgsql security definer set search_path = public as $$
declare importing boolean := coalesce(current_setting('app.doc_import', true), '') = 'on'; d public.documents;
begin
  select * into d from public.documents where id = new.document_id;
  perform set_config('app.doc_transition', 'on', true);
  if d.current_revision_id is null or new.rev_index >= d.current_rev_index then
    update public.documents set current_revision_id = new.id, current_rev_label = new.rev_label, current_rev_index = new.rev_index
     where id = new.document_id;
    if not importing and new.rev_index > 0 then
      update public.documents set status = 'draft', current_step = 1, current_response_code = null,
             submitted_at = null, due_date = null, closed_at = null
       where id = new.document_id;
    end if;
  end if;
  if not importing then perform set_config('app.doc_transition', '', true); end if;
  return new;
end $$;
create trigger revisions_after_insert after insert on public.document_revisions for each row execute function public.revisions_after_insert();

-- ===== Audit trail =====
create or replace function public.audit_row()
returns trigger language plpgsql security definer set search_path = public as $$
declare
  n jsonb := case when tg_op <> 'DELETE' then to_jsonb(new) end;
  o jsonb := case when tg_op <> 'INSERT' then to_jsonb(old) end;
  r jsonb := coalesce(n, o);
  diff jsonb := '{}'::jsonb; k text; v_company uuid; v_project uuid; v_doc uuid;
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
  -- never copy comment bodies into the shared audit trail
  if tg_table_name = 'comments' then diff := diff - 'body'; end if;

  v_company := coalesce((r->>'company_id')::uuid, case when tg_table_name = 'companies' then (r->>'id')::uuid end);
  v_project := coalesce((r->>'project_id')::uuid, case when tg_table_name = 'projects' then (r->>'id')::uuid end);
  v_doc := case when tg_table_name = 'documents' then (r->>'id')::uuid else (r->>'document_id')::uuid end;

  insert into public.audit_log (company_id, project_id, document_id, entity_type, entity_id, action, actor_id, changes)
  values (v_company, v_project, v_doc, tg_table_name, (r->>'id')::uuid, lower(tg_op), auth.uid(), diff);
  return coalesce(new, old);
end $$;

create trigger audit_companies after insert or update or delete on public.companies for each row execute function public.audit_row();
create trigger audit_company_members after insert or update or delete on public.company_members for each row execute function public.audit_row();
create trigger audit_projects after insert or update or delete on public.projects for each row execute function public.audit_row();
create trigger audit_project_members after insert or update or delete on public.project_members for each row execute function public.audit_row();
create trigger audit_response_codes after insert or update or delete on public.project_response_codes for each row execute function public.audit_row();
create trigger audit_workflows after insert or update or delete on public.project_workflows for each row execute function public.audit_row();
create trigger audit_numbering after insert or update or delete on public.numbering_schemes for each row execute function public.audit_row();
create trigger audit_documents after insert or update or delete on public.documents for each row execute function public.audit_row();
create trigger audit_revisions after insert or update or delete on public.document_revisions for each row execute function public.audit_row();
create trigger audit_attachments after insert or update or delete on public.attachments for each row execute function public.audit_row();
create trigger audit_comments after insert or update or delete on public.comments for each row execute function public.audit_row();
create trigger audit_import_batches after insert or update or delete on public.import_batches for each row execute function public.audit_row();

-- ===== RPC: companies & projects =====
create or replace function public.create_company(_name text, _code text, _name_ar text default null)
returns uuid language plpgsql security definer set search_path = public as $$
declare cid uuid;
begin
  if auth.uid() is null then raise exception 'NOT_AUTHENTICATED'; end if;
  insert into public.companies (name, name_ar, code, created_by) values (btrim(_name), nullif(btrim(_name_ar), ''), upper(btrim(_code)), auth.uid()) returning id into cid;
  insert into public.company_members (company_id, user_id, role) values (cid, auth.uid(), 'owner');
  return cid;
end $$;

create or replace function public.create_project(
  _company uuid, _code text, _name text, _party public.project_party,
  _name_ar text default null, _client text default null, _location text default null)
returns uuid language plpgsql security definer set search_path = public as $$
declare pid uuid;
begin
  if not public.is_company_admin(_company) then raise exception 'FORBIDDEN'; end if;
  insert into public.projects (company_id, code, name, name_ar, client_name, location, created_by)
  values (_company, upper(btrim(_code)), btrim(_name), nullif(btrim(_name_ar), ''), nullif(btrim(_client), ''), nullif(btrim(_location), ''), auth.uid())
  returning id into pid;
  insert into public.project_members (project_id, company_id, user_id, party, role) values (pid, _company, auth.uid(), _party, 'admin');
  -- Default response codes (labels/outcomes are editable per project)
  insert into public.project_response_codes (project_id, company_id, code, label_en, label_ar, outcome, sort) values
    (pid, _company, 'A', 'Approved', 'معتمد', 'proceed', 1),
    (pid, _company, 'B', 'Approved with comments', 'معتمد مع ملاحظات', 'proceed', 2),
    (pid, _company, 'C', 'Revise and resubmit', 'يُعدّل ويُعاد تقديمه', 'return', 3),
    (pid, _company, 'D', 'Rejected', 'مرفوض', 'return', 4),
    (pid, _company, 'E', 'Reviewed – no further action', 'تمت المراجعة – لا إجراء', 'proceed', 5),
    (pid, _company, 'I', 'For information only', 'للعلم فقط', 'proceed', 6);
  -- Default workflow Contractor -> Consultant; quality reports originate from the consultant
  insert into public.project_workflows (project_id, company_id, document_type_id, steps, review_days)
  values (pid, _company, null, '{contractor,consultant}', 7);
  insert into public.project_workflows (project_id, company_id, document_type_id, steps, review_days)
  select pid, _company, t.id, '{consultant,contractor}', 7 from public.document_types t where t.code in ('SOR','NCR','SNAG');
  return pid;
end $$;

create or replace function public.add_project_member(
  _project uuid, _email text, _party public.project_party, _role public.project_role, _organization text default null)
returns uuid language plpgsql security definer set search_path = public as $$
declare uid uuid; mid uuid;
begin
  if not public.can_manage_project(_project) then raise exception 'FORBIDDEN'; end if;
  select id into uid from public.profiles where lower(email) = lower(btrim(_email)) limit 1;
  if uid is null then raise exception 'USER_NOT_FOUND'; end if;
  insert into public.project_members (project_id, company_id, user_id, party, role, organization)
  values (_project, (select company_id from public.projects where id = _project), uid, _party, _role, nullif(btrim(_organization), ''))
  on conflict (project_id, user_id) do update set party = excluded.party, role = excluded.role, organization = excluded.organization
  returning id into mid;
  return mid;
end $$;

-- ===== RPC: workflow transitions =====
create or replace function public.transition_document(_doc uuid, _action text, _response_code text default null, _notes text default null)
returns public.documents language plpgsql security definer set search_path = public as $$
declare
  d public.documents; r public.project_role; p public.project_party; cur public.project_party;
  rc public.project_response_codes; n_steps int; new_status public.doc_lifecycle; new_step int;
begin
  select * into d from public.documents where id = _doc for update;
  if not found then raise exception 'NOT_FOUND'; end if;
  r := public.project_role_of(d.project_id);
  p := public.project_party_of(d.project_id);
  if r is null or r = 'viewer' then raise exception 'FORBIDDEN'; end if;
  n_steps := coalesce(array_length(d.workflow_steps, 1), 1);
  cur := d.workflow_steps[d.current_step];
  new_step := d.current_step;
  perform set_config('app.doc_transition', 'on', true);

  if _action = 'submit' then
    if d.status not in ('draft','returned') then raise exception 'INVALID_TRANSITION'; end if;
    if r not in ('admin','controller') then raise exception 'FORBIDDEN'; end if;
    if r <> 'admin' and p is distinct from d.workflow_steps[1] then raise exception 'FORBIDDEN: only the originating party submits'; end if;
    new_status := 'submitted';
    new_step := case when d.requires_review and n_steps >= 2 then 2 else 1 end;
    update public.documents set status = new_status, current_step = new_step, submitted_at = now(),
      current_response_code = null, closed_at = null,
      due_date = case when d.requires_review then current_date + d.review_days else d.due_date end
     where id = d.id;
    update public.document_revisions set submitted_at = now() where id = d.current_revision_id;

  elsif _action = 'start_review' then
    if not d.requires_review or d.status <> 'submitted' then raise exception 'INVALID_TRANSITION'; end if;
    if r <> 'admin' and p is distinct from cur then raise exception 'FORBIDDEN: not the reviewing party'; end if;
    new_status := 'under_review';
    update public.documents set status = new_status where id = d.id;

  elsif _action in ('respond','return') then
    if not d.requires_review or d.status not in ('submitted','under_review') then raise exception 'INVALID_TRANSITION'; end if;
    if r <> 'admin' and p is distinct from cur then raise exception 'FORBIDDEN: not the reviewing party'; end if;
    if _action = 'respond' and d.uses_response_codes then
      select * into rc from public.project_response_codes where project_id = d.project_id and code = upper(btrim(_response_code)) and active;
      if not found then raise exception 'RESPONSE_CODE_REQUIRED'; end if;
    elsif _response_code is not null and btrim(_response_code) <> '' then
      raise exception 'RESPONSE_CODES_NOT_USED';
    end if;
    if _action = 'return' and coalesce(btrim(_notes), '') = '' then raise exception 'NOTES_REQUIRED'; end if;

    if _action = 'return' or rc.outcome = 'return' then
      new_status := 'returned'; new_step := 1;
    elsif rc.outcome = 'close' then
      new_status := 'closed';
    elsif d.current_step < n_steps then
      new_status := 'submitted'; new_step := d.current_step + 1;
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
    if not (d.status = 'approved' or (not d.requires_review and d.status = 'submitted')) then raise exception 'INVALID_TRANSITION'; end if;
    new_status := 'closed';
    update public.documents set status = new_status, closed_at = now() where id = d.id;
  else
    raise exception 'UNKNOWN_ACTION';
  end if;

  insert into public.document_reviews (document_id, revision_id, project_id, company_id, step, party, action, from_status, to_status, response_code, notes, actor_id)
  values (d.id, d.current_revision_id, d.project_id, d.company_id, d.current_step, p, _action, d.status, new_status, rc.code, nullif(btrim(_notes), ''), auth.uid());

  perform set_config('app.doc_transition', '', true);
  select * into d from public.documents where id = _doc;
  return d;
end $$;

-- ===== RPC: KPI matrix (RLS applies: security invoker) =====
create or replace function public.document_kpi_matrix(_project uuid default null)
returns table (
  project_id uuid, type_code text, discipline_code text, status public.doc_lifecycle, response_code text,
  docs bigint, overdue bigint, resubmitted bigint, pending_days_sum bigint, pending_n bigint, max_pending int, revisions_total bigint)
language sql stable security invoker set search_path = public as $$
  select d.project_id, t.code, coalesce(di.code, 'GEN'), d.status, d.current_response_code,
    count(*),
    count(*) filter (where d.status in ('submitted','under_review') and d.due_date < current_date),
    count(*) filter (where d.current_rev_index > 0),
    coalesce(sum(current_date - d.submitted_at::date) filter (where d.status in ('submitted','under_review') and d.submitted_at is not null), 0),
    count(*) filter (where d.status in ('submitted','under_review') and d.submitted_at is not null),
    max(current_date - d.submitted_at::date) filter (where d.status in ('submitted','under_review') and d.submitted_at is not null),
    sum(d.current_rev_index + 1)
  from public.documents d
  join public.document_types t on t.id = d.document_type_id
  left join public.disciplines di on di.id = d.discipline_id
  where _project is null or d.project_id = _project
  group by 1,2,3,4,5
$$;

-- ===== RPC: chunked import commit (never deletes or overwrites) =====
create or replace function public.commit_import_rows(_batch uuid, _limit int default 300)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  b public.import_batches; r record; doc public.documents; m jsonb;
  v_created int := 0; v_rev int := 0; v_skip int := 0; v_fail int := 0; v_remaining int;
  v_rev_index int; v_rev_label text; v_status public.doc_lifecycle; rid uuid;
begin
  select * into b from public.import_batches where id = _batch for update;
  if not found then raise exception 'BATCH_NOT_FOUND'; end if;
  if not public.can_edit_documents(b.project_id) then raise exception 'FORBIDDEN'; end if;
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
end $$;

-- Existing numbers in a project (used by import validation to flag conflicts before commit)
create or replace function public.existing_revisions_for_numbers(_project uuid, _numbers text[])
returns table (doc_number text, document_type_code text, rev_index int, rev_label text)
language sql stable security invoker set search_path = public as $$
  select d.doc_number, t.code, r.rev_index, r.rev_label
  from public.documents d
  join public.document_types t on t.id = d.document_type_id
  join public.document_revisions r on r.document_id = d.id
  where d.project_id = _project and d.doc_number = any(_numbers)
$$;

revoke execute on function public.create_company(text, text, text) from anon;
revoke execute on function public.create_project(uuid, text, text, public.project_party, text, text, text) from anon;
revoke execute on function public.add_project_member(uuid, text, public.project_party, public.project_role, text) from anon;
revoke execute on function public.transition_document(uuid, text, text, text) from anon;
revoke execute on function public.commit_import_rows(uuid, int) from anon;
revoke execute on function public.preview_document_number(uuid, uuid, uuid) from anon;