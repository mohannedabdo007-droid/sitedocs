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

test("rejects all HTTP header control characters in credentials before fetch", async (t) => {
  const originalFetch = globalThis.fetch;
  t.after(() => { globalThis.fetch = originalFetch; });
  let called = false;
  globalThis.fetch = async () => { called = true; throw new Error("fetch should not be called"); };

  const server = mockServer();
  registerIntegrationTools(server, { CLOUDFLARE_API_TOKEN: "token\u0000with-control" });
  const result = await server.tools.get("cloudflare_gateway_status")({});
  const payload = JSON.parse(result.content[0].text);
  assert.equal(payload.status, "invalid_credential_format");
  assert.equal(called, false);
});

test("returns safe upstream error diagnostics without leaking response secrets", async (t) => {
  const originalFetch = globalThis.fetch;
  t.after(() => { globalThis.fetch = originalFetch; });
  globalThis.fetch = async () => new Response(JSON.stringify({
    success: false,
    errors: [{ code: 10000, message: "Invalid API token" }],
    secret: "must-not-be-returned",
  }), { status: 400, headers: { "content-type": "application/json" } });

  const server = mockServer();
  registerIntegrationTools(server, { CLOUDFLARE_API_TOKEN: "fake-token" });
  const result = await server.tools.get("cloudflare_gateway_status")({});
  const payload = JSON.parse(result.content[0].text);
  assert.equal(payload.status, "upstream_error");
  assert.equal(payload.http_status, 400);
  assert.deepEqual(payload.upstream_errors, [{ code: 10000, message: "Invalid API token" }]);
  assert.equal(JSON.stringify(payload).includes("must-not-be-returned"), false);
});

test("uses provider-appropriate accept headers", async (t) => {
  const originalFetch = globalThis.fetch;
  t.after(() => { globalThis.fetch = originalFetch; });
  const seen = [];
  globalThis.fetch = async (_url, options) => {
    seen.push(options.headers);
    return new Response(JSON.stringify({ result: { deployments: [] } }), {
      status: 200, headers: { "content-type": "application/json" },
    });
  };
  const server = mockServer();
  registerIntegrationTools(server, { CLOUDFLARE_API_TOKEN: "fake-token" });
  await server.tools.get("cloudflare_gateway_status")({});
  assert.equal(seen.length, 2);
  assert.ok(seen.every((headers) => headers.accept === "application/json"));
  assert.ok(seen.every((headers) => !("x-github-api-version" in headers)));
});

test("includes redacted upstream response previews for diagnosis", async (t) => {
  const originalFetch = globalThis.fetch;
  t.after(() => { globalThis.fetch = originalFetch; });
  const exposedLikeToken = "ghp_" + "A".repeat(44);
  globalThis.fetch = async () => new Response(JSON.stringify({
    success: false,
    errors: [{ code: 9106, message: "Authentication failed" }],
    debug: exposedLikeToken,
  }), {
    status: 400,
    headers: {
      "content-type": "application/json",
      "cf-ray": "test-ray-id",
    },
  });

  const server = mockServer();
  registerIntegrationTools(server, { CLOUDFLARE_API_TOKEN: "fake-token" });
  const result = await server.tools.get("cloudflare_gateway_status")({});
  const payload = JSON.parse(result.content[0].text);
  assert.equal(payload.upstream_content_type, "application/json");
  assert.equal(payload.upstream_request_id, "test-ray-id");
  assert.ok(payload.upstream_body_preview.includes("Authentication failed"));
  assert.equal(payload.upstream_body_preview.includes(exposedLikeToken), false);
});

test("redacts bearer credentials from non-JSON upstream error bodies", async (t) => {
  const originalFetch = globalThis.fetch;
  t.after(() => { globalThis.fetch = originalFetch; });
  globalThis.fetch = async () => new Response(
    "upstream proxy error Bearer short-test-secret",
    { status: 502, headers: { "content-type": "text/plain" } },
  );

  const server = mockServer();
  registerIntegrationTools(server, { CLOUDFLARE_API_TOKEN: "fake-token" });
  const result = await server.tools.get("cloudflare_gateway_status")({});
  const payload = JSON.parse(result.content[0].text);
  assert.ok(payload.upstream_body_preview.includes("upstream proxy error"));
  assert.ok(payload.upstream_body_preview.includes("Bearer [redacted]"));
  assert.equal(payload.upstream_body_preview.includes("short-test-secret"), false);
});
