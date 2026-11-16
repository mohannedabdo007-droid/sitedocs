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
const jointVentureMigration = readFileSync(
  "drizzle/migrations/0006_company_search_and_joint_ventures.sql",
  "utf8",
);
const jointVentureAcceptance = readFileSync(
  "drizzle/tests/company_search_and_joint_ventures.acceptance.sql",
  "utf8",
);
const invitationRoute = readFileSync(
  "src/routes/project-company-invitations.tsx",
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

  it("includes typed rows for every new membership table", () => {
    expect(supabaseTypes).toContain("project_membership_policies: {");
    expect(supabaseTypes).toContain("project_company_invitations: {");
    expect(supabaseTypes).toContain("project_party_companies: {");
    expect(supabaseTypes).toContain("project_membership_events: {");
    expect(supabaseTypes).toContain("external_company_acceptance_required: boolean");
    expect(supabaseTypes).toContain("invited_company_id: string");
  });

  it("serializes project membership grants against company-member removal", () => {
    expect(migration).toContain("for key share of cm");
    expect(migration).toContain("company_member_project_access_revoked");
    expect(migration).toContain("delete from public.project_members pm");
    expect(acceptance).toContain(
      "project access remained after company membership removal",
    );
  });
  it("supports several companies within one JV party without allowing company reassignment", () => {
    expect(jointVentureMigration).toContain("drop constraint if exists project_party_companies_one_company_per_party");
    expect(migration).toContain("unique (project_id, participant_company_id)");
    expect(jointVentureMigration).toContain("MEMBER_COMPANY_REQUIRED");
    expect(jointVentureMigration).toContain("COMPANY_ALREADY_ASSIGNED");
    expect(jointVentureMigration).toContain("create or replace function public.invite_project_company");
    expect(jointVentureMigration).not.toContain("raise exception 'PARTY_ALREADY_ASSIGNED'");
    expect(jointVentureMigration).toContain("Lock order is project first, invitation second");
    expect(jointVentureAcceptance).toContain("already occupied consultant party");
    expect(jointVentureMigration).toContain("for update");
    expect(jointVentureMigration).toContain("add column participant_company_id uuid references public.companies(id)");
    expect(jointVentureMigration).toContain("cm.company_id = ppc.participant_company_id");
    expect(jointVentureMigration).toContain("cm.user_id = pm.user_id");
    expect(jointVentureMigration).toContain("pm.participant_company_id = old.company_id");
    expect(jointVentureMigration).toContain("new.participant_company_id is distinct from old.participant_company_id");
    expect(jointVentureMigration).toContain("v_member_company, v_user, _party");
    expect(jointVentureAcceptance).toContain("first JV member company affiliation was not persisted");
    expect(jointVentureAcceptance).toContain("removing one JV company member revoked another company member");
    expect(jointVentureAcceptance).toContain("multiple companies could not join the same party");
    expect(jointVentureAcceptance).toContain("ambiguous JV member company was silently selected");
  });

  it("limits company search and invitation inbox to authorized administrators", () => {
    expect(jointVentureMigration).toContain("length(v_query) < 3 or length(v_query) > 80");
    expect(jointVentureMigration).toContain("limit 20");
    expect(jointVentureMigration).toContain("public.can_manage_project(_project)");
    expect(jointVentureMigration).toContain("public.is_company_admin(v_owner_company)");
    expect(jointVentureMigration).toContain("revoke all on function public.search_companies_for_project_invitation(uuid, text) from public, anon");
    expect(jointVentureMigration).toContain("revoke all on function public.list_project_company_invitations(uuid) from public, anon");
    expect(supabaseTypes).toContain("search_companies_for_project_invitation:");
    expect(supabaseTypes).toContain("list_project_company_invitations:");
  });

  it("connects the invitation UI to the protected RPC workflow", () => {
    expect(invitationRoute).toContain('supabase.rpc("search_companies_for_project_invitation"');
    expect(invitationRoute).toContain('supabase.rpc("invite_project_company"');
    expect(invitationRoute).toContain('supabase.rpc("accept_project_company_invitation"');
    expect(invitationRoute).toContain('supabase.rpc("reject_project_company_invitation"');
    expect(invitationRoute).toContain('supabase.rpc("revoke_project_company_invitation"');
    expect(invitationRoute).toContain("invitation.can_respond");
    expect(invitationRoute).toContain("invitation.can_revoke");
  });
});
