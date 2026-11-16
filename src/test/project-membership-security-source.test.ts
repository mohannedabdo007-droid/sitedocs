import { readFileSync } from "node:fs";
import { describe, expect, it } from "vitest";

const migration = readFileSync(
  "drizzle/migrations/0005_company_acceptance_membership.sql",
  "utf8",
);
const acceptance = readFileSync(
  "drizzle/tests/project_company_invitation.acceptance.sql",
  "utf8",
);
const supabaseTypes = readFileSync(
  "src/integrations/supabase/types.ts",
  "utf8",
);

describe("project company invitation and membership security", () => {
  it("defaults external company membership to explicit acceptance", () => {
    expect(migration).toContain(
      "external_company_acceptance_required boolean not null default true",
    );
    expect(migration).toContain("raise exception 'COMPANY_ACCEPTANCE_REQUIRED'");
    expect(acceptance).toContain("company acceptance is not the default");
  });

  it("requires the invited company's administrator to accept", () => {
    expect(migration).toContain(
      "if not public.is_company_admin(v_inv.invited_company_id) then raise exception 'FORBIDDEN'; end if;",
    );
    expect(migration).toContain("public.accept_project_company_invitation");
    expect(acceptance).toContain("public.accept_project_company_invitation");
  });

  it("removes the unsafe email upsert and direct membership updates", () => {
    expect(migration).toContain(
      "drop function public.add_project_member(uuid, text, public.project_party, public.project_role, text);",
    );
    expect(migration).toContain(
      "revoke insert, update on public.project_members from authenticated;",
    );
    expect(migration).not.toContain(
      "on conflict (project_id, user_id) do update set party",
    );
  });

  it("requires party-company affiliation before creating a member", () => {
    expect(migration).toContain("COMPANY_NOT_ACCEPTED_FOR_PARTY");
    expect(migration).toContain("MEMBER_NOT_ELIGIBLE");
    expect(migration).not.toContain("USER_NOT_FOUND");
    expect(migration).toContain("create trigger project_members_affiliation_guard");
  });

  it("makes future policy changes privileged and auditable", () => {
    expect(migration).toContain("public.set_project_membership_policy");
    expect(migration).toContain("POLICY_CHANGE_REASON_REQUIRED");
    expect(migration).toContain("'policy_changed'");
    expect(acceptance).toContain("Approved future policy test");
  });

  it("expires stale invitations and protects membership events as append-only", () => {
    expect(migration).toContain("'company_invitation_expired'");
    expect(migration).toContain("MEMBERSHIP_EVENTS_APPEND_ONLY");
    expect(migration).toContain("create trigger project_membership_events_append_only");
    expect(migration).toContain("revoke all on function public.revoke_project_company_invitation(uuid, text) from public, anon;");
    expect(acceptance).toContain("MEMBERSHIP_EVENTS_APPEND_ONLY");
  });

  it("keeps generated Supabase RPC types aligned with the migration", () => {
    expect(supabaseTypes).toContain("_member_company?: string");
    expect(supabaseTypes).toContain("accept_project_company_invitation");
    expect(supabaseTypes).toContain("invite_project_company");
    expect(supabaseTypes).toContain("reject_project_company_invitation");
    expect(supabaseTypes).toContain("revoke_project_company_invitation");
    expect(supabaseTypes).toContain("set_project_membership_policy");
  });

  it("revokes project access when company membership is removed", () => {
    expect(migration).toContain("company_member_project_access_revoked");
    expect(migration).toContain("delete from public.project_members pm");
    expect(acceptance).toContain(
      "project access remained after company membership removal",
    );
  });
});
