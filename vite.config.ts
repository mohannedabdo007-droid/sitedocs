// @lovable.dev/vite-tanstack-config supplies the TanStack Start, React, Tailwind,
// path-alias, and development tooling used by the existing Lovable project.
// Keep this wrapper so the existing development/preview workflow is not replaced.
import { defineConfig } from "@lovable.dev/vite-tanstack-config";

export default defineConfig({
  // Build a Cloudflare Workers module explicitly. Nitro writes the Wrangler
  // deployment config alongside the generated Worker entry and static assets.
  nitro: {
    preset: "cloudflare_module",
    cloudflare: {
      deployConfig: true,
      wrangler: {
        // Keep deployments pointed at the existing Worker, not an auto-named
        // Worker derived from package.json.
        name: "sitedocs",
        compatibility_date: "2026-11-13",
        observability: { enabled: true },
      },
    },
  },
  tanstackStart: {
    // Preserve the custom SSR error wrapper in src/server.ts.
    server: { entry: "server" },
  },
});
