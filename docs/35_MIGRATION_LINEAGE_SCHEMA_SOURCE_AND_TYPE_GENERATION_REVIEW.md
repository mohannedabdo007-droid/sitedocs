# 35 — Migration Lineage, Schema Source-of-Truth, and Type Generation Review

**Status:** Static repository review only  
**Branch:** `dev/review-fixes`  
**Scope:** `drizzle/schema.ts`, `drizzle.config.ts`, migration journal and SQL migrations, Supabase generated TypeScript types, `package.json`, `AGENTS.md`, and backup/restore manifest.  
**Not performed:** No Drizzle command, migration generation, database connection, schema introspection, type generation, package install, tests, build, SQL execution, or deployment.

## Executive summary

The repository contains four PostgreSQL migration files and a Drizzle migration journal, but `drizzle/schema.ts` is intentionally blank while `drizzle.config.ts` explicitly points Drizzle Kit at that file. Supabase TypeScript database types exist as a separate generated-looking artifact. The repository instructions say Lovable owns database schema and generated files.

This arrangement is not proof that migrations are invalid or that the live database is out of sync. It does create a reproducibility and ownership ambiguity: the checked-in Drizzle schema is not a usable declarative representation of the SQL schema, and the exact supported workflow for generating, validating, and updating migration/type artifacts is not documented in the reviewed repository.

## Findings

### F35-01 — Drizzle schema input is intentionally empty while Drizzle Kit targets it
**Priority: High — migration reproducibility**

`drizzle/schema.ts` contains only the comment that it is auto-generated and intentionally left blank. `drizzle.config.ts` sets `schema: "./drizzle/schema.ts"` and `out: "./drizzle/migrations"`.

The SQL migration files contain the actual table, enum, constraint, policy, function, and trigger definitions. A Drizzle Kit schema-diff/generation workflow that relies on the configured schema file cannot be assumed to represent those SQL definitions. No command was run to test the exact behavior.

**Risk:** A future contributor may invoke Drizzle Kit expecting a complete schema snapshot and receive incomplete or misleading output, or may create a second, conflicting schema source.

**Required action:** Document the supported Lovable-owned migration workflow and explicitly state whether Drizzle Kit generation is disabled, intentionally unused, or requires a separately maintained schema source. Do not populate the generated file manually.

### F35-02 — Database ownership is split across SQL migrations, generated types, and Lovable
**Priority: High — change control**

The tracked SQL migrations define the database. `src/integrations/supabase/types.ts` separately describes tables, row/insert/update shapes, relationships, and enums. `AGENTS.md` says Lovable manages the database and generated files and instructs contributors not to edit `drizzle/` or generated files manually.

The repository does not contain a concise, executable procedure showing how a Lovable schema change is reflected consistently in SQL migrations, generated Supabase types, and the deployed database.

**Risk:** Source SQL, generated TypeScript types, and deployed schema can drift while each artifact appears individually plausible.

**Required action:** Establish one owner-controlled change path and require a post-change consistency check between migration history, generated types, and the actual target database. Keep generated artifacts out of manual edits.

### F35-03 — Migration journal records four migrations, but no restore/replay proof is present
**Priority: Medium — recoverability**

The Drizzle journal lists four ordered migrations: `0000_core_schema` through `0003_import_validation_and_kpi_buckets`. The backup manifest explicitly says the captured backup is source plus metadata/lookup snapshot, not a full physical Supabase backup or tested restore. The Phase 0 checklist remains preparation-only.

**Risk:** A migration sequence in Git is not, by itself, evidence that a clean environment can be provisioned or that a production database can be recovered.

**Required action:** After backend identity and independent backup are verified, replay migrations only in a disposable isolated environment and compare schema objects, grants, RLS, functions, triggers, and reference data. Do not use production as the replay target.

### F35-04 — Type artifact freshness cannot be established from repository inspection alone
**Priority: Medium — application correctness**

Generated Supabase types are present, but no recorded generation command, source database snapshot identifier, generation timestamp, or automated drift check is visible in the reviewed configuration. Static review cannot prove whether the file matches the four SQL migrations or the deployed backend.

**Risk:** Application code may compile against types that differ from the deployed schema, or generated types may omit newer SQL objects.

**Required action:** Record the authoritative generation method and backend/schema revision whenever Lovable regenerates types. Add a non-destructive CI consistency check where supported.

## Safe acceptance checks (not executed)

1. Confirm the exact Lovable/Supabase backend reference through authoritative project configuration; do not infer it from unrelated dashboard references.
2. Ask Lovable to state the supported migration and type-generation workflow once workspace credits are available.
3. In a disposable isolated database only, replay the four migrations in order and capture failures and object inventory.
4. Compare tables, columns, enums, constraints, indexes, functions, triggers, grants, RLS policies, Storage policies, and seed/reference rows.
5. Regenerate Supabase types using the supported owner-controlled method and compare the result without manually editing generated files.
6. Verify that any proposed Drizzle Kit command cannot write incomplete migrations from the blank schema input.
7. Record exact source commit, migration journal state, generated-types revision, and isolated test evidence.

## Required boundaries

- No edits to `drizzle/`, migrations, generated Supabase types, or database objects were made.
- No live database connection or catalog inspection was performed.
- No Drizzle generation, migration replay, package installation, tests, lint, build, or deployment was performed.
- No credentials, secrets, or connection strings were accessed or recorded.
- This report is a static readiness finding, not proof of deployed schema drift or a database security certification.
- Existing Lovable ownership instructions remain in force; any schema or generated-file change must be requested through Lovable and reviewed before approval.

## Conclusion

The migration history is useful documentation, but the configured Drizzle schema input is blank and the repository does not establish a reproducible owner-controlled workflow linking SQL migrations, generated Supabase types, and the deployed database. Resolve that workflow ambiguity before the next schema change. Preserve the current migrations and generated files unchanged until the authoritative workflow and recovery gates are verified.
