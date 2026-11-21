-- P0: profile.email is an identity lookup attribute used by membership RPCs.
-- Authenticated users may edit their own profile presentation fields, but must
-- not rewrite the email used to resolve another account during membership.
create or replace function public.prevent_authenticated_profile_email_change()
returns trigger
language plpgsql
set search_path = pg_catalog, public
as $$
begin
  if auth.uid() is not null and new.email is distinct from old.email then
    raise exception 'PROFILE_EMAIL_IMMUTABLE: change email through verified authentication';
  end if;
  return new;
end
$$;

drop trigger if exists profiles_email_identity_guard on public.profiles;
create trigger profiles_email_identity_guard
before update of email on public.profiles
for each row
execute function public.prevent_authenticated_profile_email_change();

comment on function public.prevent_authenticated_profile_email_change() is
  'P0 identity boundary: prevents authenticated users from changing the profile email used by membership lookup RPCs; trusted server-side auth maintenance remains permitted.';

-- Trigger functions are not RPC endpoints; revoke PostgreSQL's default PUBLIC EXECUTE.
revoke all on function public.prevent_authenticated_profile_email_change()
  from public, anon, authenticated;
