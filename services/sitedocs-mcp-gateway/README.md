# SiteDocs MCP Gateway

An isolated, read-only bootstrap MCP service hosted as a separate Cloudflare Worker. It does not modify the SiteDocs application Worker.

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

## Initial tools

- `health_check`
- `integration_status`
- `gateway_capabilities`

These tools expose no connected service credentials and do not perform writes. Integration status is deliberately conservative: a connection is not marked active until tested from this Worker using its own scoped credentials.

## Preview deployment

The Worker is configured with `workers_dev = true` and a separate name, `sitedocs-mcp-gateway`. Configure the secret on this Worker, then deploy from this directory:

```sh
npx wrangler deploy
```

The resulting endpoint will be `https://sitedocs-mcp-gateway.<your-workers-subdomain>.workers.dev/mcp`.

## Security boundary

Do not add write tools, database mutations, production deployments, or main-branch merges without explicit human approval. Use Cloudflare Worker secrets for credentials. Prefer narrowly scoped service credentials and keep read/write permissions separate.
