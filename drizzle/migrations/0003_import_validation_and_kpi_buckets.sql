-- Save client-computed validation results in one set-based call (RLS applies; committed rows are never touched)
create or replace function public.save_import_validation(_batch uuid, _rows jsonb)
returns int language plpgsql security invoker set search_path = public as $$
declare n int;
begin
  if not public.can_edit_documents((select project_id from public.import_batches where id = _batch)) then
    raise exception 'FORBIDDEN';
  end if;
  update public.import_rows r
     set mapped = x.mapped, validation_status = x.validation_status, messages = coalesce(x.messages, '[]'::jsonb), decision = x.decision
    from jsonb_to_recordset(_rows) as x(id uuid, mapped jsonb, validation_status text, messages jsonb, decision text)
   where r.id = x.id and r.batch_id = _batch and r.commit_status is null;
  get diagnostics n = row_count;
  return n;
end $$;
revoke execute on function public.save_import_validation(uuid, jsonb) from anon;

create or replace function public.add_company_member(_company uuid, _email text, _role public.company_role)
returns uuid language plpgsql security definer set search_path = public as $$
declare uid uuid; mid uuid;
begin
  if not public.is_company_admin(_company) then raise exception 'FORBIDDEN'; end if;
  if _role = 'owner' then raise exception 'FORBIDDEN'; end if;
  select id into uid from public.profiles where lower(email) = lower(btrim(_email)) limit 1;
  if uid is null then raise exception 'USER_NOT_FOUND'; end if;
  insert into public.company_members (company_id, user_id, role) values (_company, uid, _role)
  on conflict (company_id, user_id) do update set role = excluded.role
  where public.company_members.role <> 'owner'
  returning id into mid;
  return mid;
end $$;
revoke execute on function public.add_company_member(uuid, text, public.company_role) from anon;

drop function if exists public.document_kpi_matrix(uuid);
create or replace function public.document_kpi_matrix(_project uuid default null)
returns table (
  project_id uuid, type_code text, discipline_code text, status public.doc_lifecycle, response_code text,
  docs bigint, overdue bigint, resubmitted bigint, pending_days_sum bigint, pending_n bigint, max_pending int,
  revisions_total bigint, aging_0_7 bigint, aging_8_14 bigint, aging_15_30 bigint, aging_31p bigint)
language sql stable security invoker set search_path = public as $$
  with d as (
    select d.*, t.code as type_code, coalesce(di.code, 'GEN') as disc_code,
      case when d.status in ('submitted','under_review') and d.submitted_at is not null
           then current_date - d.submitted_at::date end as pending
    from public.documents d
    join public.document_types t on t.id = d.document_type_id
    left join public.disciplines di on di.id = d.discipline_id
    where _project is null or d.project_id = _project
  )
  select project_id, type_code, disc_code, status, current_response_code,
    count(*),
    count(*) filter (where status in ('submitted','under_review') and due_date < current_date),
    count(*) filter (where current_rev_index > 0),
    coalesce(sum(pending), 0)::bigint,
    count(pending),
    max(pending),
    sum(current_rev_index + 1)::bigint,
    count(*) filter (where pending between 0 and 7),
    count(*) filter (where pending between 8 and 14),
    count(*) filter (where pending between 15 and 30),
    count(*) filter (where pending > 30)
  from d
  group by 1,2,3,4,5
$$;