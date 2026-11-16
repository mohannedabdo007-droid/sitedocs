-- Boolean authorization helpers must fail closed with an explicit FALSE.
-- project_role_of returns NULL for users without a project_members row; SQL
-- equality against NULL also returns NULL, which leaks an ambiguous RPC result
-- instead of the documented boolean permission contract.
create or replace function public.can_manage_project(_project uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.project_role_of(_project) = 'admin'::public.project_role, false)
$$;

comment on function public.can_manage_project(uuid) is
  'Returns true only for an explicit project admin membership; returns false when the caller has no project membership.';

-- Keep the RPC private to authenticated callers. Function owners can still
-- invoke it from security-definer routines and RLS policies.
revoke all on function public.can_manage_project(uuid) from public, anon;
grant execute on function public.can_manage_project(uuid) to authenticated, service_role;

notify pgrst, 'reload schema';
