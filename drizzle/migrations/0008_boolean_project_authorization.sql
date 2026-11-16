-- Authorization helpers exposed through PostgREST must return deterministic
-- booleans. A missing explicit project membership is denial, never SQL NULL.
create or replace function public.can_manage_project(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.project_role_of(_project) = 'admin', false)
$$;

create or replace function public.can_edit_documents(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.project_role_of(_project) in ('admin','controller'), false)
$$;

create or replace function public.can_comment(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.project_role_of(_project) in ('admin','controller','reviewer'), false)
$$;

-- These are caller-context authorization checks. They are needed by signed-in
-- application users and RLS policies, but must not be callable by anon/PUBLIC.
revoke all on function public.project_role_of(uuid) from public;
revoke all on function public.project_role_of(uuid) from anon;
grant execute on function public.project_role_of(uuid) to authenticated;

revoke all on function public.can_manage_project(uuid) from public;
revoke all on function public.can_manage_project(uuid) from anon;
grant execute on function public.can_manage_project(uuid) to authenticated;

revoke all on function public.can_edit_documents(uuid) from public;
revoke all on function public.can_edit_documents(uuid) from anon;
grant execute on function public.can_edit_documents(uuid) to authenticated;

revoke all on function public.can_comment(uuid) from public;
revoke all on function public.can_comment(uuid) from anon;
grant execute on function public.can_comment(uuid) to authenticated;

comment on function public.can_manage_project(uuid) is
  'Returns true only for an explicit project admin membership; all non-members return false.';
