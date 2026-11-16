-- Project-level authority must come from an explicit project membership.
-- Company ownership/admin status is not an implicit project-admin grant.
-- Project creation already inserts the creator as an explicit project admin.
create or replace function public.project_role_of(_project uuid)
returns public.project_role
language sql
stable
security definer
set search_path = public
as $$
  select pm.role
    from public.project_members pm
   where pm.project_id = _project
     and pm.user_id = auth.uid()
   limit 1
$$;

comment on function public.project_role_of(uuid) is
  'Returns only the caller''s explicit project membership role. Company admin/owner status alone never grants project access.';
