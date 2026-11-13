import { McpServer } from "@modelcontextprotocol/server";
import { createMcpHandler } from "agents/mcp/server";
import { z } from "zod";
import { isAuthorized } from "./auth.js";

const SERVER_NAME = "sitedocs-mcp-gateway";
const SERVER_VERSION = "0.1.0";

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

function createServer() {
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
          mode: "read-only-bootstrap",
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
          github: { status: "not_configured_in_gateway", access: "none" },
          cloudflare: { status: "hosting_account_available", api_access: "not_configured" },
          supabase: { status: "blocked_pending_authorized_access", project: "jezpyxuxjzxotxjykhky" },
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
              enabledTools: ["health_check", "integration_status", "gateway_capabilities"],
              phase: "bootstrap",
            }),
      }],
    }),
  );

  return server;
}

const mcpHandler = createMcpHandler(createServer);

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
