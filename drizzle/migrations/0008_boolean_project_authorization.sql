-- Authorization helpers exposed through PostgREST must return a deterministic
-- boolean. A missing explicit project membership is denial, never SQL NULL.
create or replace function public.can_manage_project(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.project_role_of(_project) = 'admin', false)
$$;

comment on function public.can_manage_project(uuid) is
  'Returns true only for an explicit project admin membership; all non-members return false.';
