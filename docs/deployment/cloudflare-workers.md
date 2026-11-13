# Cloudflare Workers deployment

This repository uses TanStack Start through the existing Lovable Vite wrapper. The
wrapper already provides Nitro; do not add a second framework adapter or a separate
static-assets build.

## Build output

The Vite configuration pins Nitro to the `cloudflare_module` preset and enables
Nitro's generated Wrangler deployment configuration. It also fixes the Worker name
to `sitedocs` so a deployment does not create a second Worker from the package name.
The TanStack Start server entry remains `src/server.ts`, preserving the SSR error
wrapper.

## Cloudflare Workers Builds settings

For a validation build from this branch, use:

- Git repository: `mohannedabdo007-droid/sitedocs`
- Branch: `fix/cloudflare-workers-build-2026-11-13`
- Root directory: `/`
- Build command: `bun run build`
- Deploy command: `npx wrangler deploy`

The build command must run before Wrangler. Running `wrangler deploy` alone is
insufficient because the Nitro Worker bundle and generated Wrangler configuration
do not exist until after the Vite/Nitro build completes.

Do not point the production build at this branch until it has passed validation and
the branch has been reviewed. Do not merge or deploy as part of this change.

## Local command

Run `bun run deploy:cloudflare` from the repository root to build and then invoke
Wrangler. This command deploys to Cloudflare and should only be used intentionally
by an authorized operator; it is not part of the read-only validation process.
