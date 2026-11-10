<#
 PHASE 0 - DRAFT. Not executed. Windows PowerShell 5.1 or PowerShell 7.
 Purpose: independent backup of schema "public" and a restore test into a SEPARATE, EMPTY Supabase project.
 The source (live) database is only READ. Nothing is written to it.

 Before running, set these in the same PowerShell window (do NOT save them in a file or in Git):
   $env:SRC_DB_URL  = "postgresql://USER:PASSWORD@HOST:PORT/postgres"   # live project
   $env:TEST_DB_URL = "postgresql://USER:PASSWORD@HOST:PORT/postgres"   # separate empty test project
 Run:
   powershell -ExecutionPolicy Bypass -File .\backup_and_restore_test.ps1
#>
$ErrorActionPreference = "Stop"

foreach ($tool in "pg_dump","pg_restore","psql") {
  if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) { throw "Missing $tool. Install PostgreSQL command-line tools (see README_phase0_windows.md)." }
}
if (-not $env:SRC_DB_URL)  { throw "Set SRC_DB_URL first." }
if (-not $env:TEST_DB_URL) { throw "Set TEST_DB_URL first." }
if ($env:SRC_DB_URL -eq $env:TEST_DB_URL) { throw "REFUSED: source and test are the same database." }

$out = "backup-" + (Get-Date -Format "yyyyMMdd-HHmmss")
New-Item -ItemType Directory -Path $out | Out-Null

# 1) Dump (read-only on source)
& pg_dump $env:SRC_DB_URL --format=custom --no-owner --schema=public --file="$out\public.dump"
if ($LASTEXITCODE -ne 0) { throw "pg_dump (custom) failed" }
& pg_dump $env:SRC_DB_URL --schema-only --no-owner --schema=public --file="$out\public_schema.sql"
if ($LASTEXITCODE -ne 0) { throw "pg_dump (schema) failed" }
Get-ChildItem $out -File | Get-FileHash -Algorithm SHA256 | ForEach-Object { "$($_.Hash)  $(Split-Path $_.Path -Leaf)" } | Set-Content "$out\SHA256SUMS.txt"

# 2) Restore into the separate test project
& pg_restore --no-owner --dbname=$env:TEST_DB_URL "$out\public.dump"
if ($LASTEXITCODE -ne 0) { Write-Warning "pg_restore reported messages (often harmless on Supabase). Check the comparison below." }

# 3) Compare structure counts
$q = @"
select 'tables', count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE'
union all select 'policies', count(*) from pg_policies where schemaname='public'
union all select 'functions', count(*) from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public'
union all select 'triggers', count(*) from pg_trigger t join pg_class c on c.oid=t.tgrelid join pg_namespace n on n.oid=c.relnamespace where n.nspname='public' and not t.tgisinternal
union all select 'enums', count(*) from pg_type where typtype='e' and typnamespace='public'::regnamespace
order by 1
"@
$srcCounts  = & psql $env:SRC_DB_URL  -At -F "|" -c $q
$testCounts = & psql $env:TEST_DB_URL -At -F "|" -c $q

# 4) Compare exact row counts per table
function Get-RowCounts($url) {
  $tables = & psql $url -At -c "select tablename from pg_tables where schemaname='public' order by 1"
  foreach ($t in $tables) { "$t|" + (& psql $url -At -c "select count(*) from public.""$t""") }
}
$srcRows  = Get-RowCounts $env:SRC_DB_URL
$testRows = Get-RowCounts $env:TEST_DB_URL

$srcCounts  | Set-Content "$out\src_counts.txt";  $testCounts | Set-Content "$out\test_counts.txt"
$srcRows    | Set-Content "$out\src_rows.txt";    $testRows   | Set-Content "$out\test_rows.txt"

$d1 = Compare-Object $srcCounts $testCounts
$d2 = Compare-Object $srcRows $testRows
if (-not $d1 -and -not $d2) { Write-Host "RESTORE TEST PASSED: structure counts and row counts match" -ForegroundColor Green }
else { Write-Host "RESTORE TEST FAILED" -ForegroundColor Red; $d1; $d2; exit 2 }
Write-Host "Keep a copy of $out OUTSIDE Supabase and OUTSIDE GitHub. Auth users and Storage files are NOT included."
