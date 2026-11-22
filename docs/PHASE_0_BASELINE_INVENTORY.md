# Phase 0 — Read-only Baseline Inventory

**Repository:** `mohannedabdo007-droid/sitedocs`  
**Working branch:** `dev/review-fixes`  
**Protected backup reference:** `backup/lovable-2026-11-10`  
**Purpose:** Establish a reproducible, read-only baseline before any code or database remediation.

## Safety boundary

This is an inventory and evidence checklist only. It does not authorize edits to application code, dependencies, migrations, Supabase configuration, database data, Storage policies, secrets, or deployment settings.

The repository's `AGENTS.md` explicitly reserves database and Drizzle migration changes for Lovable. Do not edit `drizzle/` or `supabase/migrations/` manually. No Lovable credits are assumed available.

## Known Git reference points (from the prior verified inspection)

- Backup branch commit: `7e0135f279fa3924e7b48f82fb319b8872d14ebf`.
- Existing remediation-plan commit on `dev/review-fixes`: `9273fff99c08e19039ef35964504b860a8df9227`.
- Existing plan: `docs/SECURITY_REMEDIATION_PLAN.md`.
- Do not rewrite pushed history, force-push, rebase, amend, or squash commits already synced to Lovable.

Re-check branch heads and compare refs before each write. Stop if the working branch has moved unexpectedly or the protected backup has changed.

## Baseline evidence register

| Area | Read-only evidence required | Current evidence / limitation |
|---|---|---|
| Git | branch head SHA; backup SHA; compare status; changed paths | Prior inspection recorded backup SHA above and one earlier plan commit. Reconfirm before further work. |
| Repository rules | `AGENTS.md`, generated-file headers, Lovable-managed paths | `AGENTS.md` prohibits manual edits to `drizzle/` and `supabase/migrations/`. |
| Database schema | migration files 0000–0003, schema definitions, Drizzle metadata/snapshots | Static review only. Do not generate migrations. |
| RLS | table grants, enabled/forced RLS, policies, helper functions, SECURITY DEFINER routines | Static migration review only; no live grants/policies verified. |
| Storage | bucket configuration, object path convention, SELECT/INSERT/UPDATE/DELETE policies | Migration 0002 defines project-level read and comment-level upload policies. Live bucket settings unknown. |
| Workflow | enums, transition RPC, response-code seed data, workflow configuration | Static code findings recorded in Claude review; no live row counts verified. |
| Import/KPI | validation RPCs, commit RPC, KPI invoker behavior | Static code review only; runtime behavior untested. |
| Dependencies | package.json, bun.lock, package manager version, advisory scan | Lockfile review exists; no successful Bun audit or reproducible install/build recorded. |
| Runtime exposure | Vite host flags/config, deployed preview, access boundaries | Not established conclusively; do not assume the dev server is or is not exposed. |
| Secrets | presence/configuration only | Do not read, print, copy, or commit secret values. |
| Tests | test inventory and exact commands/results | Test files exist, but execution results are not established. |

## Static findings requiring test coverage

1. `project_members` UPDATE path and `add_project_member` conflict behavior can mutate party/role.
2. `transition_document` grants `admin` a party-check bypass.
3. RPC revokes from `anon` must be checked against inherited `PUBLIC` EXECUTE.
4. Storage read/upload checks are project-level rather than document-level.
5. Email lookup responses may expose profile/account existence.
6. A service-role Supabase client exists; tenant-facing use must be prohibited unless explicitly reviewed.
7. PM's approved read-all-drafts exception must remain read-only and must not imply review authority.

These are static findings, not a statement about the live database's current grants, policies, rows, or exploitability.

## Required baseline capture before implementation

- [ ] Confirm current `dev/review-fixes` head SHA and working tree state.
- [ ] Confirm `backup/lovable-2026-11-10` still points to the approved backup SHA.
- [ ] Save a compare report listing all changed files and commits.
- [ ] Record Bun and Node versions from the controlled build environment.
- [ ] Record the exact lockfile hash and package manifest hash.
- [ ] Inventory all schema/migration/snapshot files without editing them.
- [ ] Inventory every SECURITY DEFINER function and its declared grants.
- [ ] Inventory all RLS policies and table grants.
- [ ] Inventory Storage buckets and policies from a safe non-production source.
- [ ] Identify the isolated test Supabase project; prove it is not production.
- [ ] Capture baseline test/build results, or explicitly mark each as not run.
- [ ] Record current Dependabot/GitHub alerts by advisory ID and dependency path.
- [ ] Establish whether any development server is reachable from an untrusted network.

## Stop conditions

Stop and request review if:
- the backup reference changes;
- the current branch contains unexpected application/schema/dependency changes;
- a task requires reading secrets or using a production service-role key;
- the only available database target is production;
- Lovable-managed database changes are proposed outside Lovable;
- a test would write to production;
- a migration is proposed before restore verification and written approval.
