# SiteDocs MCP Gateway — Architecture Decision Record
**Date:** 2026-11-14  
**Status:** Proposed implementation baseline (documentation only; no service deployed)

## Decision
Build a dedicated remote MCP server named `sitedocs-mcp-gateway` on Cloudflare Workers, isolated from the existing SiteDocs application Worker and its production deployment configuration.

Use the Cloudflare Agents SDK MCP handler (`createMcpHandler`) with the Streamable HTTP transport and expose the endpoint at `/mcp`. Do not add MCP routes or bindings to the existing SiteDocs Worker as part of the first implementation.

## Why isolation
- The existing SiteDocs Worker has a deployment history that is not yet tied to a verified Git SHA.
- Cloudflare Workers Builds currently targets the repository's `main` branch for production.
- The SiteDocs application and the MCP gateway have different security and release lifecycles.
- A separate Worker prevents gateway experiments from changing the live application.

## Initial security posture
1. Start with read-only tools only.
2. Use explicit allowlists for repositories, Cloudflare account resources, and operations.
3. Keep credentials in Cloudflare secrets; never commit tokens or paste them into chat.
4. Use OAuth or short-lived scoped credentials where supported; avoid broad personal tokens.
5. Separate read and write tools. Any write, database mutation, production deployment, or merge to `main` requires explicit human approval.
6. Log tool name, actor, target, decision, and result without logging credentials or sensitive payloads.
7. Reject unknown tools, unexpected arguments, and requests outside the allowlist.

## First integration sequence
- Phase 0: build and test the isolated MCP server locally / in preview; no production deployment.
- Phase 1: read-only GitHub access for the SiteDocs development branch, commit metadata, and CI results.
- Phase 2: read-only Cloudflare account and Worker metadata.
- Phase 3: Supabase only after access to the exact intended project is explicitly authorized; do not substitute another project.
- Phase 4: Lovable only through a supported, authenticated API. Do not assume Git Sync or file APIs are controllable through MCP.

## Known constraints
- An MCP gateway does not magically grant access to another service. Each connector still needs a supported API and its own narrowly scoped credentials.
- The current SiteDocs GitHub and Cloudflare connections in ChatGPT are separate integrations; the Worker cannot inherit those connector sessions automatically.
- Supabase project `jezpyxuxjzxotxjykhky` previously returned permission denied. The gateway must not work around that restriction or use a different Supabase project.
- Lovable's current API access does not establish the active Git Sync repository/branch, and prior Agent messaging was blocked by workspace credits.
- ChatGPT must support adding a remote custom MCP connector on the user's account before the hosted endpoint can be connected to this ChatGPT session. This is a separate compatibility check from building the server.

## Explicit non-goals for this phase
- No production deployment or DNS changes.
- No changes to the existing SiteDocs Worker or Cloudflare Workers Builds settings.
- No database changes, migrations, or data access beyond verified read-only authorization.
- No change to `main`, no merge, and no Lovable file synchronization.
- No secrets or credentials stored in the repository.

## Acceptance criteria for the first technical milestone
- The MCP server starts locally and responds to MCP initialization over Streamable HTTP.
- A harmless `health_check` tool returns service identity and build metadata only.
- No credentials are embedded in source or returned by tools.
- Automated tests cover unauthenticated access, rejected unknown tools, and read-only allowlist enforcement.
- Preview deployment is not performed until the local checks pass and its target is confirmed.
