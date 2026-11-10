# 10 — Repository Security Baseline and Next Actions

**Review date:** 2026-11-10  
**Repository:** `mohannedabdo007-droid/sitedocs` (private)  
**Review branch:** `dev/review-fixes`  
**Scope:** read-only GitHub metadata and tracked-file inspection. No repository settings, branches, PRs, secrets, database, or deployments were changed.

## 1. Current repository state observed

### Branches

GitHub's branch listing returned these three branches, all with `protected: false`:

| Branch | Observed head | Protected |
|---|---|---|
| `main` | `92447994021be9b16f4678aa178921c267a01e33` | false |
| `dev/review-fixes` | `100f81ece7552d660623f00d23b1b4332689048a` | false |
| `backup/lovable-2026-11-10` | `7e0135f279fa3924e7b48f82fb319b8872d14ebf` | false |

This is direct evidence that GitHub did not report classic branch protection as enabled for these branch records at the time of inspection.

The branch-protection detail endpoint returned HTTP 403 (Resource not accessible by integration). Therefore individual protection settings could not be read. Do not infer additional settings from that failed request.

### Rulesets and plan/access limitation

The repository rulesets endpoint returned HTTP 403 with GitHub's message: "Upgrade to GitHub Pro or make this repository public to enable this feature." No ruleset configuration could be inspected or changed through this connection.

This is an access/plan limitation, not proof that a hidden ruleset exists. Re-check from the repository owner's GitHub Settings UI if the plan or permissions change.

### CI / GitHub Actions

The recursive tracked-file tree for the backup commit contained no `.github/workflows/` files. The backup commit also had:
- 0 check runs;
- 0 commit statuses;
- status reported as pending with zero statuses.

The PR head has no recorded automated check evidence. The project does define `test`, `lint` and `build` scripts in `package.json`, but they have not been shown to run successfully.

### Secret-handling evidence

The backup branch's `.gitignore` excludes:
- `.env` and `.env.*`;
- `.dev.vars`;
- local build outputs and dependency directories.

It explicitly allows `.env.example` and `.env.sample`. This is a useful preventive rule only; it does not remove previously committed secrets or establish that the Git history is clean.

GitHub's secret-scanning/secret APIs were not accessible through the connected read interface. No secret values were requested or read. Secret scanning and history scanning remain unverified.

### Collaborator access

The connected read interface did not expose the collaborators collection. The account's previously observed repository permission set (admin/maintain/push/triage/pull) describes the connected account only; it is not a collaborator inventory. Access for other users remains unverified.

## 2. Repository configuration observations

- Repository visibility is private.
- Default branch is `main`.
- The backup manifest explicitly says environment files were excluded.
- `AGENTS.md` states that Lovable owns database schema/migrations, generated files and project secrets; these must not be manually rewritten in Git.
- The repository contains no tracked GitHub Actions workflow files at the inspected backup commit.
- The backup branch is a source and lookup snapshot, not a verified restorable database backup; see `docs/09_PULL_REQUEST_1_REVIEW.md`.

## 3. Recommended target controls

These are recommendations, not controls currently confirmed as active.

### A. Protect `main`

When the GitHub plan and owner permissions permit:
1. Require pull requests before changes reach `main`.
2. Require at least one independent approval where a second reviewer is available.
3. Dismiss stale approvals when new commits are pushed.
4. Require all configured status checks to pass.
5. Require conversation resolution.
6. Block force pushes and branch deletion.
7. Restrict direct pushes to a minimal maintainer set.
8. Do not allow bypass by default; document any emergency exception.

If the current private-repository plan does not support the needed controls, keep `main` unchanged and use a documented manual review process until the plan/permissions are resolved. Do not make the repository public merely to obtain protection features.

### B. Add CI without exposing secrets

Create a minimal GitHub Actions workflow on a dedicated PR after reviewing the project's supported runtime/package manager. Suggested checks:
- install using the committed lockfile and a pinned runtime;
- `npm run lint` (or the verified package-manager equivalent);
- `npm test`;
- `npm run build`.

The first workflow should not require production Supabase credentials or deployment secrets. Use least-privilege workflow permissions and pin third-party actions to reviewed versions/SHAs. Confirm the commands and lockfile compatibility before making the workflow required.

### C. Audit secrets and access

1. Run GitHub secret scanning if available, plus a repository-history scan using a trusted tool.
2. If a credential is exposed, rotate/revoke it at its issuing service; deleting a file alone is insufficient.
3. Review collaborators and teams in GitHub Settings; remove only confirmed unnecessary access.
4. Keep production credentials in the approved secret manager, never in source, docs, issue comments or generated reports.
5. Review deploy keys, GitHub Apps, webhooks and environments from the owner interface; these were not verified here.

### D. Preserve separation of environments and data

1. Keep the backup branch immutable as historical source evidence.
2. Keep development, test/restore and production Supabase projects separate.
3. Verify the Lovable-to-Supabase project identity before connecting.
4. Obtain an independent database backup and complete a restore drill in an isolated project.
5. Never apply imported migrations directly to production as part of merging a source snapshot.
6. Do not edit Lovable-managed migrations, generated types or schema files by hand.

## 4. PR #1 and branch relationship

At the time of comparison:
- `main` head: `92447994021be9b16f4678aa178921c267a01e33`;
- backup head: `7e0135f279fa3924e7b48f82fb319b8872d14ebf`;
- compare status: `diverged`;
- backup branch: 2 commits ahead and 1 behind `main`;
- merge base: `249fdd07fb6e80da76260ccd1dc95bdec3f9403b`.

PR #1 remains open and unmerged. Its changes include 107 added files and 12,302 additions. Do not merge it as a security-hardening action. Its separate review and required disposition are in `docs/09_PULL_REQUEST_1_REVIEW.md`.

## 5. Priority order

| Priority | Action | Current state |
|---|---|---|
| 1 | Keep PR #1 unmerged; preserve backup branch | Recommended; no changes made |
| 2 | Confirm owner plan/permissions for branch protection | Blocked by current API access/plan response |
| 3 | Enable protection on `main` when supported | Not enabled according to branch listing |
| 4 | Add least-privilege CI workflow | No workflow files observed |
| 5 | Run secret and collaborator audits in owner UI | Unverified |
| 6 | Verify correct Supabase project and independent backup/restore | Not completed |
| 7 | Run application and database security tests in isolated environment | Not completed |

## 6. Explicit non-actions

- No branch protection or ruleset setting was changed.
- No collaborator, team, deploy key, webhook, GitHub App, environment, or secret was changed.
- No CI workflow was created or executed.
- No branch was deleted, renamed, rebased, force-pushed or merged.
- No PR was approved, closed, retargeted or merged.
- No Supabase connection, migration, backup or restore was performed.
- No deployment was performed.

This document records the evidence available through the connected GitHub read interface. Unavailable settings are marked unverified rather than assumed secure or insecure.
