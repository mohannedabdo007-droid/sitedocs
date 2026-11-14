# Claude phase-0 contribution (documentation only)

Added on 2026-11-14 to `dev/review-fixes`. Nothing here changes the application, the database or any existing file.
These files do NOT replace the existing `docs/01_SCHEMA_INVENTORY.md`, `docs/02_RLS_TEST_PLAN.md`,
`docs/PHASE_0_BACKUP_RESTORE_CHECKLIST.md` or `scripts/backup/restore-verify.ps1` (branch `fix/restore-test-fail-fast-2026-11-13`).
Those remain authoritative; compare and merge the useful parts, then remove duplicates.

| file | purpose |
|---|---|
| CLAUDE_INDEPENDENT_REVIEW.md | independent review: findings A-E, RLS/Storage design, workflow fix without data loss, package notes, least-risk order |
| CLAUDE_01_SCHEMA_INVENTORY_DRAFT.md | earlier inventory draft extracted from migrations 0000-0003 (not verified on a live DB) |
| CLAUDE_02_RLS_TEST_PLAN_DRAFT.md | earlier RLS matrix draft (visibility, writes, storage, RPC, numbering/import) |
| backup_and_restore_test.ps1 / .sh | draft backup + restore-test scripts (read-only on source; NOT executed) |
| README_phase0.md / README_phase0_windows.md | how to run them |

Rules kept: no live DB contact, no migration, no change to `main` or `backup/lovable-2026-11-10`.
