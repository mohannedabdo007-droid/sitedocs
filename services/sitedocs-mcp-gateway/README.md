# SiteDocs MCP Gateway

An isolated, read-only MCP service hosted as a separate Cloudflare Worker. It does not modify the SiteDocs application Worker.

## Local development

Requirements: Node.js 22+ and npm.

```sh
npm install
npm test
npx wrangler dev
```

Set a local secret before exercising the protected endpoint:

```sh
npx wrangler secret put GATEWAY_BEARER_TOKEN
```

Use a randomly generated value of at least 32 characters. Do not commit it or paste it into chat.

## Endpoints

- `GET /health` — public, non-sensitive liveness response.
- `POST /mcp` — MCP Streamable HTTP endpoint; requires `Authorization: Bearer <token>`.

## MCP tools

Core:
- `health_check`
- `integration_status`
- `gateway_capabilities`

GitHub (fixed repository and approved development branch only):
- `github_repo_status`
- `github_read_file`
- `github_recent_workflow_runs`

Cloudflare:
- `cloudflare_gateway_status` — metadata for this isolated gateway Worker only.

Supabase:
- `supabase_project_status` — project metadata only; no SQL, table reads, schema changes, or migrations.

All integration tools are GET-only and fail closed when their credential is absent. A configured credential is not considered connected until a live upstream request succeeds. Lovable remains unavailable until a supported, authorized API is verified.

## Integration credentials

Configure these as Cloudflare Worker secrets on `sitedocs-mcp-gateway`; never commit values or paste them into chat:

- `GITHUB_TOKEN` — fine-grained GitHub token limited to repository `mohannedabdo007-droid/sitedocs`, read-only Contents and Actions/Metadata permissions.
- `CLOUDFLARE_API_TOKEN` — account-scoped token with read-only Workers Scripts/Deployments permissions.
- `SUPABASE_ACCESS_TOKEN` — Supabase personal access token authorized to read project metadata for `jezpyxuxjzxotxjykhky`.

Do not use a Supabase service-role key or database password for these metadata tools. If a credential is not available, the related tools return `not_configured` and do not attempt a request.

## Preview deployment

The Worker is configured with `workers_dev = true` and a separate name, `sitedocs-mcp-gateway`. Configure the secret on this Worker, then deploy from this directory:

```sh
npx wrangler deploy
```

The resulting endpoint will be `https://sitedocs-mcp-gateway.<your-workers-subdomain>.workers.dev/mcp`.

## Security boundary

Do not add write tools, database mutations, production deployments, or main-branch merges without explicit human approval. Use Cloudflare Worker secrets for credentials. Prefer narrowly scoped service credentials and keep read/write permissions separate.
