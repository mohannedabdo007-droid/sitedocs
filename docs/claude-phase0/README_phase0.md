# Phase 0: independent backup and restore test (draft)

Rules: the live DB is only read. No migration runs until this passes and the owner confirms.

1. Create a separate empty Supabase project for the restore test.
2. Run backup_and_restore_test.sh with SRC_DB_URL (live) and TEST_DB_URL (test).
3. Expected last line: RESTORE TEST PASSED.
4. Not covered by pg_dump of schema public: (a) auth users (schema auth), (b) Storage files in bucket document-files. Export both separately (Supabase dashboard / CLI) before Phase 2.
5. Keep one copy of the dump outside Supabase and outside GitHub (contains data).
6. Owner confirms in writing: "backup verified" -> only then Phase 2 migrations go to Lovable.

Note: the repo snapshot says there are 0 business rows today. The test still matters for schema, RLS policies, functions and triggers.
