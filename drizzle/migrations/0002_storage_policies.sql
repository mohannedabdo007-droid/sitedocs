create or replace function public.storage_project_id(_name text)
returns uuid language plpgsql immutable set search_path = public as $$
declare seg text := split_part(_name, '/', 1);
begin
  if seg ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' then return seg::uuid; end if;
  return null;
end $$;

create policy "document files: project members read" on storage.objects for select to authenticated
  using (bucket_id = 'document-files' and public.is_project_member(public.storage_project_id(name)));
create policy "document files: contributors upload" on storage.objects for insert to authenticated
  with check (bucket_id = 'document-files' and public.can_comment(public.storage_project_id(name)));