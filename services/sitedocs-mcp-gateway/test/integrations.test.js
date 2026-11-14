import test from "node:test";
import assert from "node:assert/strict";
import { registerIntegrationTools } from "../src/integrations.js";

function mockServer() {
  const tools = new Map();
  return {
    tools,
    registerTool(name, _schema, handler) { tools.set(name, handler); },
  };
}

test("registers only explicit read-only integration tools", () => {
  const server = mockServer();
  registerIntegrationTools(server, {});
  assert.deepEqual([...server.tools.keys()], [
    "github_repo_status",
    "github_read_file",
    "github_recent_workflow_runs",
    "cloudflare_gateway_status",
    "supabase_project_status",
  ]);
});

test("reports missing credentials without attempting network access", async () => {
  const server = mockServer();
  registerIntegrationTools(server, {});
  for (const name of ["github_repo_status", "cloudflare_gateway_status", "supabase_project_status"]) {
    const result = await server.tools.get(name)({});
    const payload = JSON.parse(result.content[0].text);
    assert.equal(payload.status, "not_configured");
  }
});

test("rejects path traversal before making a request", async () => {
  const server = mockServer();
  registerIntegrationTools(server, { GITHUB_TOKEN: "test-token" });
  const result = await server.tools.get("github_read_file")({ path: "../secrets" });
  assert.deepEqual(JSON.parse(result.content[0].text), { status: "rejected", reason: "invalid_repository_path" });
});
