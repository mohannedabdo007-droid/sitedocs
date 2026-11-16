import assert from "node:assert/strict";
import { appendFileSync } from "node:fs";

const url = process.env.API_URL;
const serviceKey = process.env.SERVICE_ROLE_KEY;
assert.ok(url, "API_URL is required");
assert.ok(serviceKey, "SERVICE_ROLE_KEY is required");

const password = "P0-Test-Password!";
const users = [
  ["P0_CREATOR_ID", "p0-creator@sitedocs.test", "P0 Creator"],
  ["P0_PEER_ID", "p0-peer@sitedocs.test", "P0 Originator Peer"],
  ["P0_WRONG_ID", "p0-wrong@sitedocs.test", "P0 Wrong Party"],
  ["P0_REVIEWER_ID", "p0-reviewer@sitedocs.test", "P0 Reviewer"],
  ["P0_PM_ID", "p0-pm@sitedocs.test", "P0 Project Manager"],
  ["P0_VIEWER_ID", "p0-viewer@sitedocs.test", "P0 Viewer"],
  ["P0_COMPANY_ADMIN_ID", "p0-company-admin@sitedocs.test", "P0 Company Admin"],
  ["P0_COMPANY_OWNER_ID", "p0-company-owner@sitedocs.test", "P0 Company Owner"],
  ["P0_OTHER_TENANT_ID", "p0-other-tenant@sitedocs.test", "P0 Other Tenant"],
];

for (const [envName, email, fullName] of users) {
  const response = await fetch(url + "/auth/v1/admin/users", {
    method: "POST",
    headers: {
      apikey: serviceKey,
      Authorization: "Bearer " + serviceKey,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      email,
      password,
      email_confirm: true,
      user_metadata: { full_name: fullName },
    }),
  });
  const body = await response.json().catch(() => ({}));
  if (!response.ok) {
    throw new Error("GoTrue admin create failed for " + email + ": HTTP " + response.status + " " + JSON.stringify(body));
  }
  const user = body.user ?? body;
  assert.ok(user.id, "GoTrue did not return a user ID for " + email);
  assert.ok(process.env.GITHUB_ENV, "GITHUB_ENV is required to publish synthetic user IDs to later CI steps");
  appendFileSync(process.env.GITHUB_ENV, envName + "=" + user.id + "\n");
  process.stdout.write("PASS GoTrue created Auth user " + email + " as " + envName + "\n");
}

process.stdout.write("Supabase GoTrue Auth fixture seeding: all 9 users created.\n");
