# Phase 0 on Windows: independent backup and restore test (documentation only)

Status: DRAFT. Nothing here has been run. It makes no change to files or databases until you run it.
Branch rule: any file added to the repo goes on `dev/review-fixes` only. Never `main`, never `backup/lovable-2026-11-10`.

## What you need
1. Windows 10/11 with PowerShell 5.1 (built in) or PowerShell 7.
2. PostgreSQL command-line tools (pg_dump, pg_restore, psql), same major version as the Supabase database or newer.
   - Install: `winget install PostgreSQL.PostgreSQL` (choose "Command Line Tools" only; no server needed), or the installer from postgresql.org.
   - Add `C:\Program Files\PostgreSQL\<version>\bin` to PATH, open a NEW PowerShell, check: `pg_dump --version`.
3. A second, EMPTY Supabase project used only for the restore test (never the live project).
4. Two connection strings (Supabase dashboard > Connect):
   - Live (source). Prefer a read-only role if available.
   - Test (target).
   - If your network has no IPv6, use the Session pooler string (it works over IPv4); the direct string may fail.
   - If the password has special characters (@ : / # ?), percent-encode them in the URI.

## Steps (when you decide to run)
1. Open PowerShell in a NEW empty folder (not inside the repo).
2. Set the variables in that window only:
   `$env:SRC_DB_URL = "..."`
   `$env:TEST_DB_URL = "..."`
3. `powershell -ExecutionPolicy Bypass -File .\backup_and_restore_test.ps1`
4. Success = last line `RESTORE TEST PASSED`. Send me only that line and the contents of `src_counts.txt` / `test_counts.txt` (no passwords, no dump).
5. Close the window (variables disappear). Never commit connection strings or the dump to Git.

## Not covered by this dump (export separately before Phase 2)
- Auth users (schema `auth`).
- Files in Storage bucket `document-files`.
- Secrets/environment variables managed by Lovable.
- Policies/functions that live outside schema `public` (none expected here).

## What counts as "backup verified"
- Script ended with RESTORE TEST PASSED.
- A copy of the dump + SHA256SUMS.txt stored outside Supabase and GitHub.
- You wrote: "النسخة الاحتياطية مؤكدة".
Only then do I prepare Phase 2 to 4 migrations for Lovable.

## Safety properties of the script
- Source is read with pg_dump/psql SELECT only.
- Refuses to run if source and test URLs are identical.
- Does not store credentials in files.
- Output folder is timestamped; nothing is overwritten.
