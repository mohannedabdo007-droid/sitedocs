import assert from "node:assert/strict";

const url = process.env.API_URL;
const serviceKey = process.env.SERVICE_ROLE_KEY;
assert.ok(url, "API_URL is required");
assert.ok(serviceKey, "SERVICE_ROLE_KEY is required");

const password = "P0-Test-Password!";
const users = [
  ["00000000-0000-4000-8000-000000000010", "p0-creator@sitedocs.test", "P0 Creator"],
  ["00000000-0000-4000-8000-000000000011", "p0-peer@sitedocs.test", "P0 Originator Peer"],
  ["00000000-0000-4000-8000-000000000012", "p0-wrong@sitedocs.test", "P0 Wrong Party"],
  ["00000000-0000-4000-8000-000000000013", "p0-reviewer@sitedocs.test", "P0 Reviewer"],
  ["00000000-0000-4000-8000-000000000014", "p0-pm@sitedocs.test", "P0 Project Manager"],
  ["00000000-0000-4000-8000-000000000015", "p0-viewer@sitedocs.test", "P0 Viewer"],
  ["00000000-0000-4000-8000-000000000016", "p0-company-admin@sitedocs.test", "P0 Company Admin"],
  ["00000000-0000-4000-8000-000000000017", "p0-company-owner@sitedocs.test", "P0 Company Owner"],
  ["00000000-0000-4000-8000-000000000018", "p0-other-tenant@sitedocs.test", "P0 Other Tenant"],
];

for (const [id, email, fullName] of users) {
  const response = await fetch(url + "/auth/v1/admin/users/" + id, {
    method: "PUT",
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
  assert.equal(user.id, id, "GoTrue returned an unexpected user ID for " + email);
  process.stdout.write("PASS GoTrue created deterministic Auth user " + email + "\n");
}

process.stdout.write("Supabase GoTrue Auth fixture seeding: all 9 users created.\n");
