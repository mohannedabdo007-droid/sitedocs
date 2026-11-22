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


## Re-check at current GitHub HEAD — 2026-11-14

**GitHub HEAD:** 1269ae3f0cd1cbdeaa8c4114dce39b38bcd6de27  
**Lovable readable snapshot:** 34fdc2f274c183513671f3cf8ab38cc40c555731  
**Binding directive:** the user has confirmed that this Lovable project is connected to the specified repository and development branch. This confirmation is accepted; do not ask the user to prove it again. The comparison below tests file/SHA synchronization, not the user's binding decision.

### Current inventory

- GitHub recursive tree: 303 files.
- Lovable listing: 117 files.
- Shared paths: 104.
- GitHub-only paths: 199.
- Lovable-only paths: 13.
- 31 high-risk shared paths were opened and compared by content in this pass; the inventory does not claim that all 104 shared paths received a full content diff.

### File-by-file status for the critical set

| Path | GitHub HEAD | Lovable SHA | Status and impact |
|---|---|---|---|
| AGENTS.md | 4,496 chars | 1,462 chars | Different; GitHub contains expanded evidence, accountability and approval rules. |
| package.json | 3,456 chars | 3,357 chars | Different scripts; 79 dependency versions match. GitHub adds typecheck and deploy:cloudflare. |
| bun.lock | 193,399 chars | 193,399 chars | Exact match. |
| vite.config.ts | 1,274 chars | 1,046 chars | Different; GitHub configures Cloudflare Workers/Nitro and Worker name sitedocs. |
| tsconfig.json | 881 chars | 881 chars | Exact match. |
| vitest.config.ts | 395 chars | 395 chars | Exact match. |
| src/routes/index.tsx | 20,946 chars | 694 chars | Critical difference; Lovable is the blank-app placeholder, GitHub contains the dashboard. |
| src/routes/__root.tsx | 4,360 chars | 4,360 chars | Exact match. |
| src/router.tsx | 579 chars | 579 chars | Exact match. |
| src/routeTree.gen.ts | 1,796 chars | 1,796 chars | Exact match. |
| src/lib/domain.ts | 4,626 chars | 3,513 chars | Critical difference; GitHub adds Project Manager as a separate read-only actor and canReadDocument visibility logic. |
| src/lib/i18n.tsx | 3,235 chars | 3,213 chars | Different; small implementation delta, review before sync. |
| src/lib/i18n-dict.ts | 28,660 chars | 33,510 chars | Different; 341 keys in GitHub and 384 in Lovable per language; 43 keys exist only in Lovable. Call-site impact remains to be checked. |
| src/lib/import/excel.ts | 4,739 chars before final one-character regex correction | 2,664 chars | Critical difference; GitHub includes workbook size/sheet/row/column/cell/text limits. The final GitHub SHA also fixes whitespace normalization in buildRecords. |
| src/test/app-routing.test.tsx | 697 chars | 697 chars | Exact match. |
| src/test/domain-rules.test.ts | 9,442 chars | 6,751 chars | Different; GitHub includes Project Manager and draft visibility tests and updated discipline expectations. |
| src/test/dashboard-summary.test.ts | Present | Missing | GitHub-only test. |
| src/test/document-register.test.ts | Present | Missing | GitHub-only test. |
| src/test/excel-resource-limits.test.ts | Present | Missing | GitHub-only test; now includes header whitespace regression cases. |
| src/test/setup.ts | 445 chars | 445 chars | Exact match. |
| drizzle/schema.ts | 59 chars | 59 chars | Exact match. |
| drizzle/migrations/0000_core_schema.sql | 30,230 chars | 30,230 chars | Exact match. |
| drizzle/migrations/0001_triggers_and_rpcs.sql | 36,321 chars | 36,321 chars | Exact match. |
| drizzle/migrations/0002_storage_policies.sql | 721 chars | 721 chars | Exact match. |
| drizzle/migrations/0003_import_validation_and_kpi_buckets.sql | 3,406 chars | 3,406 chars | Exact match. |
| drizzle/migrations/meta/0000_snapshot.json | 335 chars | 335 chars | Exact match. |
| drizzle/migrations/meta/0001_snapshot.json | 335 chars | 335 chars | Exact match. |
| drizzle/migrations/meta/0002_snapshot.json | 335 chars | 335 chars | Exact match. |
| drizzle/migrations/meta/0003_snapshot.json | 335 chars | 335 chars | Exact match. |
| drizzle/migrations/meta/_journal.json | 655 chars | 655 chars | Exact match. |
| supabase/config.toml | 35 chars | 35 chars | Exact match. |

### Lovable-only paths — preserve all 13

- .env — not opened; never copy or disclose values.
- public/apple-touch-icon.png
- public/favicon.png
- public/icon-192.png
- public/icon-512.png
- src/components/app/AppHeader.tsx
- src/components/app/Brand.tsx
- src/components/app/States.tsx
- src/components/app/StatusBadge.tsx
- src/lib/error-capture.ts
- src/lib/errors.ts
- src/lib/queries.ts
- tests/db/core_flow_rollback.sql

### Updated reconciliation plan

1. Treat GitHub HEAD as the canonical source for application code. The user's confirmation of the Lovable binding is accepted; do not ask for it again.
2. Keep the current Lovable snapshot read-only until a safe write/sync path is explicitly available. No branch switch, disconnect/reconnect, agent message, or publish was attempted.
3. Preserve all 13 Lovable-only paths. Trace their imports and build/test use before proposing any merge or deletion.
4. Prioritize selective comparison/merge of index route, domain.ts, excel.ts, tests, package.json and vite.config.ts. Do not bulk-replace the project.
5. Review the 43 Lovable-only translation keys against current call sites before removing or restoring any key.
6. No migration copy is needed for the compared SQL/meta files because they are exact matches. This is file equality only, not proof that a live database has applied those migrations.
7. After any future authorized sync, require one SHA with typecheck, lint, unit, production build and Worker dry-run all passing before preview/deploy.

**Conclusion:** the project binding is accepted as user-confirmed, but the readable Lovable snapshot is not synchronized with the current GitHub HEAD. The 13 Lovable-only paths and the 43 extra translation keys make blind replacement unsafe. No Lovable write-side action is justified in this run.
