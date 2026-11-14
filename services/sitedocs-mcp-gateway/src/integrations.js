const REPOSITORY = "mohannedabdo007-droid/sitedocs";
const DEVELOPMENT_BRANCH = "fix/cloudflare-workers-build-2026-11-13";
const SUPABASE_PROJECT = "jezpyxuxjzxotxjykhky";
const CLOUDFLARE_ACCOUNT = "8443941e05881f4c5ea550c7ee0b2097";
const GATEWAY_WORKER = "sitedocs-mcp-gateway";

function textResult(value) {
  return { content: [{ type: "text", text: JSON.stringify(value) }] };
}

async function getJson(url, token, service) {
  if (!token) return { configured: false, service, status: "not_configured" };
  const response = await fetch(url, {
    method: "GET",
    headers: {
      authorization: `Bearer ${token}`,
      accept: "application/vnd.github+json, application/json",
      "user-agent": "SiteDocs-MCP-Gateway",
      "x-github-api-version": "2022-11-28",
    },
  });
  if (!response.ok) {
    return {
      configured: true,
      service,
      status: response.status === 401 || response.status === 403 ? "credentials_rejected_or_insufficient_scope" : "upstream_error",
      http_status: response.status,
    };
  }
  return { configured: true, service, status: "connected", data: await response.json() };
}

function safeRepoPath(path) {
  if (typeof path !== "string" || !path || path.length > 240) return false;
  if (path.startsWith("/") || path.includes("\\") || path.split("/").some((part) => !part || part === "." || part === "..")) return false;
  return /^[A-Za-z0-9._/-]+$/.test(path);
}

export function registerIntegrationTools(server, env = {}) {
  server.registerTool(
    "github_repo_status",
    {
      description: "Read-only status of the fixed SiteDocs GitHub repository and approved development branch.",
      inputSchema: {},
    },
    async () => {
      const result = await getJson(`https://api.github.com/repos/${REPOSITORY}`, env.GITHUB_TOKEN, "github");
      if (result.status !== "connected") return textResult(result);
      const branch = await getJson(`https://api.github.com/repos/${REPOSITORY}/branches/${encodeURIComponent(DEVELOPMENT_BRANCH)}`, env.GITHUB_TOKEN, "github");
      if (branch.status !== "connected") return textResult({ repository: { full_name: result.data.full_name, private: result.data.private, default_branch: result.data.default_branch }, branch });
      return textResult({
        status: "connected",
        repository: { full_name: result.data.full_name, private: result.data.private, default_branch: result.data.default_branch },
        approved_development_branch: { name: branch.data.name, sha: branch.data.commit?.sha, protected: branch.data.protected },
        policy: "read-only; main is not modified",
      });
    },
  );

  server.registerTool(
    "github_read_file",
    {
      description: "Read a text file from the fixed SiteDocs repository on the approved development branch. No writes are possible.",
      inputSchema: { path: { type: "string", minLength: 1, maxLength: 240 } },
    },
    async ({ path }) => {
      if (!safeRepoPath(path)) return textResult({ status: "rejected", reason: "invalid_repository_path" });
      if (!env.GITHUB_TOKEN) return textResult({ status: "not_configured", service: "github" });
      const url = `https://api.github.com/repos/${REPOSITORY}/contents/${path.split("/").map(encodeURIComponent).join("/")}?ref=${encodeURIComponent(DEVELOPMENT_BRANCH)}`;
      const result = await getJson(url, env.GITHUB_TOKEN, "github");
      if (result.status !== "connected") return textResult(result);
      if (result.data.type !== "file" || typeof result.data.content !== "string") {
        return textResult({ status: "not_a_text_file_or_not_found", path });
      }
      const bytes = Uint8Array.from(atob(result.data.content.replace(/\s/g, "")), (char) => char.charCodeAt(0));
      const content = new TextDecoder().decode(bytes);
      return textResult({ status: "ok", repository: REPOSITORY, branch: DEVELOPMENT_BRANCH, path, sha: result.data.sha, content });
    },
  );

  server.registerTool(
    "github_recent_workflow_runs",
    {
      description: "List recent read-only CI workflow run summaries for the SiteDocs repository.",
      inputSchema: {
        workflow: { type: "string", enum: ["sitedocs-mcp-gateway.yml", "sitedocs-mcp-gateway-auth-smoke.yml"] },
      },
    },
    async ({ workflow }) => {
      const result = await getJson(`https://api.github.com/repos/${REPOSITORY}/actions/workflows/${encodeURIComponent(workflow)}/runs?branch=${encodeURIComponent(DEVELOPMENT_BRANCH)}&per_page=10`, env.GITHUB_TOKEN, "github");
      if (result.status !== "connected") return textResult(result);
      return textResult({
        status: "ok",
        workflow,
        runs: (result.data.workflow_runs ?? []).map((run) => ({
          id: run.id, name: run.name, event: run.event, status: run.status,
          conclusion: run.conclusion, head_sha: run.head_sha, html_url: run.html_url,
          created_at: run.created_at, updated_at: run.updated_at,
        })),
      });
    },
  );

  server.registerTool(
    "cloudflare_gateway_status",
    {
      description: "Read-only deployment and binding metadata for the isolated SiteDocs MCP Gateway Worker.",
      inputSchema: {},
    },
    async () => {
      if (!env.CLOUDFLARE_API_TOKEN) return textResult({ status: "not_configured", service: "cloudflare" });
      const base = `https://api.cloudflare.com/client/v4/accounts/${CLOUDFLARE_ACCOUNT}/workers/scripts/${GATEWAY_WORKER}`;
      const [settings, deployments] = await Promise.all([
        getJson(base + "/settings", env.CLOUDFLARE_API_TOKEN, "cloudflare"),
        getJson(base + "/deployments", env.CLOUDFLARE_API_TOKEN, "cloudflare"),
      ]);
      if (settings.status !== "connected") return textResult(settings);
      if (deployments.status !== "connected") return textResult(deployments);
      const active = deployments.data.result?.deployments?.[0];
      return textResult({
        status: "connected",
        worker: GATEWAY_WORKER,
        compatibility_date: settings.data.result?.compatibility_date,
        bindings: (settings.data.result?.bindings ?? []).map((binding) => ({ name: binding.name, type: binding.type })),
        latest_deployment: active ? {
          id: active.id, source: active.source, created_on: active.created_on,
          versions: (active.versions ?? []).map((version) => ({ version_id: version.version_id, percentage: version.percentage })),
        } : null,
        policy: "read-only metadata; no deployment or configuration changes",
      });
    },
  );

  server.registerTool(
    "supabase_project_status",
    {
      description: "Read-only Supabase project metadata. Does not query tables or mutate database state.",
      inputSchema: {},
    },
    async () => {
      if (!env.SUPABASE_ACCESS_TOKEN) return textResult({ status: "not_configured", service: "supabase", project_ref: SUPABASE_PROJECT });
      const result = await getJson(`https://api.supabase.com/v1/projects/${SUPABASE_PROJECT}`, env.SUPABASE_ACCESS_TOKEN, "supabase");
      if (result.status !== "connected") return textResult({ ...result, project_ref: SUPABASE_PROJECT });
      return textResult({
        status: "connected",
        project: {
          id: result.data.id, name: result.data.name, region: result.data.region,
          status: result.data.status, database: result.data.database?.host ? { host: result.data.database.host } : undefined,
        },
        policy: "metadata only; no SQL, table reads, schema changes, or migrations",
      });
    },
  );
}
