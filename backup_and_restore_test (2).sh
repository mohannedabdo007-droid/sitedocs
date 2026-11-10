#!/usr/bin/env bash
# PHASE 0 (DRAFT, read-only on the source). Independent backup + restore test.
# Usage:
#   export SRC_DB_URL='postgresql://...'   # LIVE db, from Supabase dashboard > Database > Connection string (use a read-only role if possible)
#   export TEST_DB_URL='postgresql://...'  # a SEPARATE, EMPTY Supabase project (never the live one)
#   bash backup_and_restore_test.sh
set -euo pipefail
: "${SRC_DB_URL:?set SRC_DB_URL}"; : "${TEST_DB_URL:?set TEST_DB_URL}"
if [ "$SRC_DB_URL" = "$TEST_DB_URL" ]; then echo "REFUSED: source and test must differ"; exit 1; fi
TS=$(date +%Y%m%d-%H%M%S); OUT="backup-$TS"; mkdir -p "$OUT"

# 1) Dump (source is only read). Custom format + plain SQL schema copy.
pg_dump "$SRC_DB_URL" --format=custom --no-owner --schema=public --file="$OUT/public.dump"
pg_dump "$SRC_DB_URL" --schema-only --no-owner --schema=public --file="$OUT/public_schema.sql"
sha256sum "$OUT"/* > "$OUT/SHA256SUMS"

# 2) Restore into the SEPARATE project
pg_restore --no-owner --dbname="$TEST_DB_URL" "$OUT/public.dump"

# 3) Compare counts of tables, rows, policies, functions, triggers, enums
Q=$(cat <<'SQL'
select 'tables', count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE'
union all select 'policies', count(*) from pg_policies where schemaname='public'
union all select 'functions', count(*) from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public'
union all select 'triggers', count(*) from pg_trigger t join pg_class c on c.oid=t.tgrelid join pg_namespace n on n.oid=c.relnamespace where n.nspname='public' and not t.tgisinternal
union all select 'enums', count(*) from pg_type where typtype='e' and typnamespace='public'::regnamespace
order by 1
SQL
)
psql "$SRC_DB_URL" -At -F'|' -c "$Q" > "$OUT/src_counts.txt"
psql "$TEST_DB_URL" -At -F'|' -c "$Q" > "$OUT/test_counts.txt"
# exact row counts per table
ROWS="select relname||'|'||n_live_tup from pg_stat_user_tables where schemaname='public' order by 1"
psql "$SRC_DB_URL" -At -c "select 'x'" >/dev/null
for U in SRC TEST; do
  URL_VAR="${U}_DB_URL"; URL="${!URL_VAR}"
  for T in $(psql "$URL" -At -c "select tablename from pg_tables where schemaname='public' order by 1"); do
    echo "$T|$(psql "$URL" -At -c "select count(*) from public.\"$T\"")"
  done > "$OUT/${U,,}_rows.txt"
done
diff "$OUT/src_counts.txt" "$OUT/test_counts.txt" && diff "$OUT/src_rows.txt" "$OUT/test_rows.txt" \
  && echo "RESTORE TEST PASSED: counts and rows match" || { echo "RESTORE TEST FAILED"; exit 2; }
echo "Backup kept in $OUT. Store a copy OUTSIDE the project (e.g. encrypted drive). Auth users and Storage files are NOT in this dump: export them separately (see README)."
