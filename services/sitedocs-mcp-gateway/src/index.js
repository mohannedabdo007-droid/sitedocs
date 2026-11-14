import { McpServer } from "@modelcontextprotocol/server";
import { createMcpHandler } from "agents/mcp/server";
import { z } from "zod";
import { isAuthorized } from "./auth.js";
import { registerIntegrationTools } from "./integrations.js";

const SERVER_NAME = "sitedocs-mcp-gateway";
const SERVER_VERSION = "0.2.0";

function json(body, status = 200, headers = {}) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json; charset=utf-8", ...headers },
  });
}

function corsHeaders(origin) {
  return {
    "access-control-allow-origin": origin || "*",
    "access-control-allow-methods": "GET, POST, OPTIONS",
    "access-control-allow-headers": "Authorization, Content-Type, Accept, Mcp-Protocol-Version, Mcp-Session-Id, Last-Event-ID",
    "access-control-max-age": "86400",
    "vary": "Origin",
  };
}

function createServer(env = {}) {
  const server = new McpServer({
    name: SERVER_NAME,
    version: SERVER_VERSION,
  });

  server.registerTool(
    "health_check",
    {
      description: "Returns non-sensitive service health and version metadata.",
      inputSchema: {},
    },
    async () => ({
      content: [{
        type: "text",
        text: JSON.stringify({
          status: "ok",
          service: SERVER_NAME,
          version: SERVER_VERSION,
          mode: "read-only-integrations",
        }),
      }],
    }),
  );

  server.registerTool(
    "integration_status",
    {
      description: "Lists integration setup status without exposing credentials or claiming unverified connections.",
      inputSchema: {},
    },
    async () => ({
      content: [{
        type: "text",
        text: JSON.stringify({
          github: { status: env.GITHUB_TOKEN ? "credential_configured_pending_live_check" : "not_configured", access: "read-only allowlist" },
          cloudflare: { status: env.CLOUDFLARE_API_TOKEN ? "credential_configured_pending_live_check" : "not_configured" },
          supabase: { status: env.SUPABASE_ACCESS_TOKEN ? "credential_configured_pending_live_check" : "blocked_pending_authorized_access", project: "jezpyxuxjzxotxjykhky" },
          lovable: { status: "api_capability_unverified" },
          policy: "read-only; writes, database mutations, production deployments, and main merges are disabled",
        }),
      }],
    }),
  );

  server.registerTool(
    "gateway_capabilities",
    {
      description: "Describes the currently enabled gateway capabilities and safety boundaries.",
      inputSchema: { detail: z.enum(["summary", "security"]).optional() },
    },
    async ({ detail = "summary" }) => ({
      content: [{
        type: "text",
        text: JSON.stringify(detail === "security"
          ? {
              authentication: "Bearer token required for /mcp",
              authorization: "explicit read-only allowlist",
              secrets: "Cloudflare Worker secrets only; never returned by tools",
              prohibited: ["database writes", "production deploys", "main merges", "credential disclosure"],
            }
          : {
              transport: "MCP Streamable HTTP",
              endpoint: "/mcp",
              enabledTools: [
                "health_check", "integration_status", "gateway_capabilities",
                "github_repo_status", "github_read_file", "github_recent_workflow_runs",
                "cloudflare_gateway_status", "supabase_project_status",
              ],
              phase: "read-only-integrations",
            }),
      }],
    }),
  );

  registerIntegrationTools(server, env);
  return server;
}

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const cors = corsHeaders(request.headers.get("origin"));

    if (request.method === "OPTIONS") {
      return new Response(null, { status: 204, headers: cors });
    }

    if (url.pathname === "/health") {
      return json({
        status: "ok",
        service: SERVER_NAME,
        version: SERVER_VERSION,
      }, 200, cors);
    }

    if (url.pathname !== "/mcp") {
      return json({ error: "not_found" }, 404, cors);
    }

    if (!isAuthorized(request, env.GATEWAY_BEARER_TOKEN)) {
      return json(
        { error: "unauthorized", message: "A valid gateway bearer token is required." },
        401,
        { ...cors, "www-authenticate": 'Bearer realm="SiteDocs MCP Gateway"' },
      );
    }

    const mcpHandler = createMcpHandler(() => createServer(env));
    const response = await mcpHandler(request, env, ctx);
    const headers = new Headers(response.headers);
    for (const [key, value] of Object.entries(cors)) headers.set(key, value);
    headers.set("cache-control", "no-store");
    return new Response(response.body, {
      status: response.status,
      statusText: response.statusText,
      headers,
    });
  },
};
