# Lovable ↔ GitHub file reconciliation — 2026-11-14

## Scope and immutable references
- Lovable project: `Project Doc Control` (`8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`)
- Lovable readable snapshot: `34fdc2f274c183513671f3cf8ab38cc40c555731`
- GitHub repository: `mohannedabdo007-droid/sitedocs`
- GitHub development branch: `fix/cloudflare-workers-build-2026-11-13`
- GitHub source snapshot used for this comparison: `7b9242537bae77a599d48c0fbd9b1e870134339f`
- This is a read-only reconciliation. No Lovable files were written, no integration was disconnected/reconnected, and no branch switch or sync was attempted.

## Inventory
- GitHub tree: 286 files (complete recursive tree; not truncated).
- Lovable file listing: 117 entries.
- Shared paths: 105.
- GitHub-only paths: 181.
- Lovable-only paths: 12.
- All 105 shared paths were inventoried, but only the 8 high-risk shared files below were opened and compared line-for-line in this pass. Do not interpret inventory counts as a full-content comparison.

## High-risk shared file comparison
| Path | Lovable | GitHub | Finding |
|---|---:|---:|---|
| `src/routes/index.tsx` | 23 lines / 694 chars | 317 lines / 20,946 chars | Critical divergence: Lovable contains the blank-app placeholder; GitHub contains the working SiteDocs dashboard with Supabase reads, project/document lists and bilingual labels. |
| `src/lib/domain.ts` | 82 lines / 3,513 chars | 111 lines / 4,626 chars | Critical divergence: GitHub includes Project Manager as a distinct read-only workflow actor and document visibility rules; Lovable snapshot does not contain those additions. |
| `src/test/domain-rules.test.ts` | 153 lines / 6,751 chars | 203 lines / 8,782 chars | Critical divergence: GitHub adds tests for Project Manager read-only access and draft visibility. The Lovable snapshot still expects STR where GitHub expects CIV in discipline examples. |
| `AGENTS.md` | 30 lines / 1,462 chars | 50 lines / 4,496 chars | GitHub has expanded mandatory execution/accountability instructions, including evidence-based claims and explicit approval boundaries. |
| `package.json` | 102 lines / 3,357 chars | 105 lines / 3,456 chars | GitHub adds `typecheck` and Cloudflare deploy script. Presence of a deploy script does not mean a deployment occurred. |
| `vite.config.ts` | 18 lines / 1,046 chars | 31 lines / 1,274 chars | GitHub contains explicit Cloudflare Workers/Nitro configuration and Worker name `sitedocs`. |
| `src/lib/i18n.tsx` | 3,213 chars | 3,235 chars | Not identical; small textual delta still requires review before synchronization. |
| `src/lib/import/excel.ts` | 2,664 chars | 2,665 chars | Not identical; small textual delta still requires review before synchronization. |

## Lovable-only paths — preserve
The 12 paths present in the Lovable snapshot but absent from the GitHub tree are:
- `.env` — sensitive; deliberately not opened or copied.
- `public/apple-touch-icon.png`
- `public/favicon.png`
- `public/icon-192.png`
- `public/icon-512.png`
- `src/components/app/AppHeader.tsx`
- `src/components/app/Brand.tsx`
- `src/components/app/States.tsx`
- `src/components/app/StatusBadge.tsx`
- `src/lib/errors.ts`
- `src/lib/queries.ts`
- `tests/db/core_flow_rollback.sql`

Do not delete or overwrite these files. In particular, never expose or transfer `.env` values as part of a reconciliation.

## Functional risks that block blind sync
1. The Lovable home route is still a blank placeholder, while GitHub contains the operational dashboard.
2. Project Manager's read-only oversight permission is represented in GitHub domain rules/tests but absent in the Lovable snapshot.
3. Discipline test fixtures differ: Lovable uses `STR`; GitHub uses `CIV`. This needs a deliberate migration/compatibility assessment, not a bulk text replacement.
4. GitHub contains updated Cloudflare Worker build configuration; Lovable's Vite config retains its older wrapper-only setup.
5. The 12 Lovable-only files may be active dependencies or project-specific assets; preserve and trace imports/references before proposing any merge.

## Recommended safe reconciliation plan
1. Verify the actual Git Sync repository and active branch in Lovable UI. API file access does not prove Git Sync settings.
2. Preserve a complete snapshot/backup of Lovable-only files and any uncommitted project edits; exclude secrets from reports and archives.
3. Review import/reference graphs for all 12 Lovable-only paths and identify whether each is used by current UI/build/tests.
4. Create a file-level merge plan: GitHub canonical for the eight divergent files only after reviewing their dependencies; preserve Lovable-only components/assets and merge required imports deliberately.
5. Resolve discipline-code compatibility against the approved five disciplines (Arc, Civ, Mec, Surve, Ele); do not revive STR/CIVSTR as active discipline codes.
6. Run typecheck, lint, unit tests, production build and Worker build on the resulting single SHA before any preview or deployment.
7. No production deployment, DB/schema/migration change, main merge, disconnect/reconnect, or bulk synchronization without explicit authorization.

## Conclusion
The two snapshots are materially divergent and are not safe to synchronize blindly. GitHub contains the newer dashboard, domain protections, tests and Worker build setup. Lovable contains a placeholder route and 12 project-only files that must be preserved and traced. The next safe step is a verified Git Sync settings inspection and dependency-aware merge plan; no destructive or write-side Lovable action is justified by this comparison alone.
