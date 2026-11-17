<#
SiteDocs Phase 0 — fail-fast restore verification.
The source database is read-only. The target MUST be a separate, disposable,
empty test database. Never run this against production or a database with data.
Credentials must be supplied through environment variables, never saved here.
#>

$ErrorActionPreference = "Stop"

function Invoke-CheckedNative {
    param(
        [Parameter(Mandatory = $true)][string]$Executable,
        [Parameter(Mandatory = $true)][string[]]$Arguments,
        [Parameter(Mandatory = $true)][string]$Step
    )

    $output = & $Executable @Arguments
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "$Step failed (exit code $exitCode). Restore verification is ABORTED."
    }
    return $output
}

foreach ($tool in @("pg_dump", "pg_restore", "psql")) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        throw "Missing $tool. Install PostgreSQL command-line tools first."
    }
}
if ([string]::IsNullOrWhiteSpace($env:SRC_DB_URL))  { throw "Set SRC_DB_URL first." }
if ([string]::IsNullOrWhiteSpace($env:TEST_DB_URL)) { throw "Set TEST_DB_URL first." }

try {
    $srcUri = [System.Uri]$env:SRC_DB_URL
    $testUri = [System.Uri]$env:TEST_DB_URL
} catch {
    throw "SRC_DB_URL and TEST_DB_URL must be valid PostgreSQL connection URIs."
}
if ($srcUri.Scheme -notin @("postgres", "postgresql") -or
    $testUri.Scheme -notin @("postgres", "postgresql")) {
    throw "Both connection strings must use postgres:// or postgresql://."
}
$srcPort = if ($srcUri.Port -lt 0) { 5432 } else { $srcUri.Port }
$testPort = if ($testUri.Port -lt 0) { 5432 } else { $testUri.Port }
$srcIdentity = "{0}|{1}|{2}" -f $srcUri.Host.ToLowerInvariant(), $srcPort, $srcUri.AbsolutePath.TrimEnd("/")
$testIdentity = "{0}|{1}|{2}" -f $testUri.Host.ToLowerInvariant(), $testPort, $testUri.AbsolutePath.TrimEnd("/")
if ($srcIdentity -eq $testIdentity) {
    throw "REFUSED: source and target resolve to the same host, port, and database."
}

# Refuse any user-created schema or object in the target before invoking pg_restore.
# The query is read-only; system schemas and their objects are excluded.
$targetObjectCountSql = @"
select
  (select count(*) from pg_namespace
   where nspname <> 'public' and nspname <> 'information_schema' and nspname !~ '^pg_')
+ (select count(*) from pg_class c join pg_namespace n on n.oid=c.relnamespace
   where n.nspname <> 'information_schema' and n.nspname !~ '^pg_'
     and c.relkind in ('r','p','v','m','S','f'))
+ (select count(*) from pg_proc p join pg_namespace n on n.oid=p.pronamespace
   where n.nspname <> 'information_schema' and n.nspname !~ '^pg_')
+ (select count(*) from pg_type t join pg_namespace n on n.oid=t.typnamespace
   where n.nspname <> 'information_schema' and n.nspname !~ '^pg_'
     and t.typtype in ('e','d','r','m'))
"@
$targetObjectCount = @(Invoke-CheckedNative "psql" @(
    $env:TEST_DB_URL, "--no-psqlrc", "--set", "ON_ERROR_STOP=1", "-At", "-c", $targetObjectCountSql
) "Target emptiness preflight")
if ($targetObjectCount.Count -ne 1 -or [string]$targetObjectCount[0] -notmatch '^0$') {
    throw "REFUSED: target database is not empty or its emptiness could not be verified. No restore was attempted."
}

$out = Join-Path (Get-Location) ("backup-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
New-Item -ItemType Directory -Path $out -ErrorAction Stop | Out-Null
$dumpPath = Join-Path $out "public.dump"
$schemaPath = Join-Path $out "public_schema.sql"
$restoreListPath = Join-Path $out "restore.list"

# 1. Dump only the public schema from the source.
Invoke-CheckedNative "pg_dump" @($env:SRC_DB_URL, "--format=custom", "--no-owner", "--schema=public", "--file=$dumpPath") "Source custom-format dump" | Out-Null
if (-not (Test-Path $dumpPath) -or (Get-Item $dumpPath).Length -eq 0) {
    throw "The custom-format dump is missing or empty. Verification is ABORTED."
}
Invoke-CheckedNative "pg_dump" @($env:SRC_DB_URL, "--schema-only", "--no-owner", "--schema=public", "--file=$schemaPath") "Source schema-only dump" | Out-Null
if (-not (Test-Path $schemaPath) -or (Get-Item $schemaPath).Length -eq 0) {
    throw "The schema-only dump is missing or empty. Verification is ABORTED."
}
Get-ChildItem $out -File |
    Get-FileHash -Algorithm SHA256 |
    ForEach-Object { "{0}  {1}" -f $_.Hash, (Split-Path $_.Path -Leaf) } |
    Set-Content -Path (Join-Path $out "SHA256SUMS.txt")

# 2. Exclude only pg_dump's CREATE SCHEMA public TOC entry: every PostgreSQL
# database already has its own public schema. Keep all tables, types, functions,
# triggers, policies, and data entries. Restore remains fail-fast and atomic.
$toc = @(Invoke-CheckedNative "pg_restore" @("--list", $dumpPath) "Read dump table of contents")
if ($toc.Count -eq 0) {
    throw "The custom-format dump table of contents is empty. Verification is ABORTED."
}
$filteredToc = foreach ($line in $toc) {
    if ($line -match '^\s*\d+;\s+\d+\s+\d+\s+SCHEMA\s+-\s+public(?:\s|$)') {
        ";$line"
    } else {
        $line
    }
}
$filteredToc | Set-Content -Path $restoreListPath -Encoding utf8
if (-not (Test-Path $restoreListPath) -or (Get-Item $restoreListPath).Length -eq 0) {
    throw "The filtered restore list is missing or empty. Verification is ABORTED."
}
Invoke-CheckedNative "pg_restore" @("--exit-on-error", "--single-transaction", "--no-owner", "--use-list=$restoreListPath", "--dbname=$($env:TEST_DB_URL)", $dumpPath) "Target restore" | Out-Null

# 3. Compare object counts. ON_ERROR_STOP makes SQL errors fatal.
$q = @"
select 'tables', count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE'
union all select 'policies', count(*) from pg_policies where schemaname='public'
union all select 'functions', count(*) from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public'
union all select 'triggers', count(*) from pg_trigger t join pg_class c on c.oid=t.tgrelid join pg_namespace n on n.oid=c.relnamespace where n.nspname='public' and not t.tgisinternal
union all select 'enums', count(*) from pg_type where typtype='e' and typnamespace='public'::regnamespace
order by 1
"@
$psqlBase = @("--no-psqlrc", "--set", "ON_ERROR_STOP=1", "-At", "-F", "|", "-c", $q)
$srcCounts = @(Invoke-CheckedNative "psql" (@($env:SRC_DB_URL) + $psqlBase) "Source structure query")
$testCounts = @(Invoke-CheckedNative "psql" (@($env:TEST_DB_URL) + $psqlBase) "Target structure query")
if ($srcCounts.Count -eq 0 -or $testCounts.Count -eq 0) {
    throw "A structure query returned no data. Verification is ABORTED."
}

# 4. Exact row counts per public table (not planner estimates).
function Get-ExactRowCounts {
    param([Parameter(Mandatory = $true)][string]$DatabaseUrl)

    $listSql = "select format('SELECT %L || ''|'' || count(*) FROM public.%I', tablename, tablename) from pg_tables where schemaname='public' order by tablename"
    $commands = @(Invoke-CheckedNative "psql" @($DatabaseUrl, "--no-psqlrc", "--set", "ON_ERROR_STOP=1", "-At", "-c", $listSql) "Table-list query")
    $rows = @()
    foreach ($command in $commands) {
        if ([string]::IsNullOrWhiteSpace($command)) { continue }
        $result = @(Invoke-CheckedNative "psql" @($DatabaseUrl, "--no-psqlrc", "--set", "ON_ERROR_STOP=1", "-At", "-c", $command) "Exact row-count query")
        if ($result.Count -ne 1) {
            throw "A table row-count query did not return exactly one result. Verification is ABORTED."
        }
        $rows += [string]$result[0]
    }
    return @($rows | Sort-Object)
}

$srcRows = @(Get-ExactRowCounts $env:SRC_DB_URL)
$testRows = @(Get-ExactRowCounts $env:TEST_DB_URL)

$srcCounts = @($srcCounts | Sort-Object)
$testCounts = @($testCounts | Sort-Object)
$srcCounts | Set-Content (Join-Path $out "src_counts.txt")
$testCounts | Set-Content (Join-Path $out "test_counts.txt")
$srcRows | Set-Content (Join-Path $out "src_rows.txt")
$testRows | Set-Content (Join-Path $out "test_rows.txt")

$countDiff = @(Compare-Object $srcCounts $testCounts)
$rowDiff = @(Compare-Object $srcRows $testRows)
if ($countDiff.Count -gt 0 -or $rowDiff.Count -gt 0) {
    Write-Host "RESTORE TEST FAILED: source and target counts differ." -ForegroundColor Red
    if ($countDiff.Count -gt 0) { $countDiff | Format-Table | Out-Host }
    if ($rowDiff.Count -gt 0) { $rowDiff | Format-Table | Out-Host }
    exit 2
}

Write-Host "RESTORE TEST PASSED: checked restore exit status, structure counts, and exact row counts." -ForegroundColor Green
Write-Host "Evidence folder: $out"
Write-Warning "This verifies public-schema restore/counts only. It does NOT verify Auth users, Storage objects, secrets, grants outside public, or behavioral equivalence of RLS/security policies."
