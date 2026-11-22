# 58 - SECURITY DEFINER execution context, search_path and internal bypass flags review

- Repository: `mohannedabdo007-droid/sitedocs`
- Branch: `dev/review-fixes`
- Review type: static migration/source review only
- Reviewed snapshot: migrations `0000_core_schema.sql`, `0001_triggers_and_rpcs.sql`, and `0003_import_validation_and_kpi_buckets.sql`
- Source blob SHAs:
  - `0000_core_schema.sql`: `6eeac6f0ddb29d77e0ab1320ac143bab6f834c47`
  - `0001_triggers_and_rpcs.sql`: `667f793732f8841c4d8394721eb3128e04181c7f`
  - `0003_import_validation_and_kpi_buckets.sql`: `7f72ee1669c28d6724ee433e485c2d7e0208261c`

## Executive summary

The inspected SECURITY DEFINER functions consistently declare `SET search_path = public`, and the reviewed function bodies predominantly schema-qualify application tables, helper functions, and custom types. No dynamic SQL (`EXECUTE`) was identified in the inspected RPC/trigger migration. These are positive controls.

The review nevertheless identifies two hardening/verification items:

1. `search_path = public` does not explicitly pin `pg_temp` after trusted schemas. PostgreSQL's temporary-schema lookup behavior means this setting alone should not be treated as a complete SECURITY DEFINER search-path hardening pattern. Most inspected object references are explicitly schema-qualified, which materially reduces exposure in the reviewed bodies; the remaining risk depends on any unqualified relation/type/function references and effective schema privileges. The migrations inspected do not establish the deployed CREATE privileges on `public` or effective role memberships.
2. The document guard relies on transaction-local custom settings `app.doc_transition` and `app.doc_import` as internal bypass signals. The inspected SECURITY DEFINER routines set and clear these flags around controlled updates. This is not, by itself, evidence that an ordinary API user can exploit the flags: the review found no arbitrary-SQL interface or direct exploit path. However, the flags are not cryptographic capabilities; any path that permits arbitrary SQL in the same database session/transaction could attempt to set them. This trust boundary deserves explicit testing and documentation.

No confirmed exploitable vulnerability is established by this static review.

## 1. SECURITY DEFINER inventory and search_path

The reviewed migrations define SECURITY DEFINER routines for permission helpers, user/profile initialization, tenant-scope triggers, document/revision/audit triggers, numbering, document transitions, and import commit operations.

The inspected definitions consistently use `SET search_path = public`. The reviewed source also schema-qualifies many important references, for example `public.documents`, `public.project_role_of(...)`, `public.document_revisions`, and custom enum/type names under `public`. Auth helpers are referenced as `auth.uid()`.

**Positive evidence**
- Fixed search path is present on the reviewed SECURITY DEFINER declarations.
- Important application relations and helper calls in the reviewed bodies are generally schema-qualified.
- No dynamic SQL statement was identified in the inspected migration source.
- `resolve_numbering_scheme` is explicitly revoked from PUBLIC, anon, and authenticated in migration 0001 (as separately noted in report 57).

**Hardening recommendation**
- For future SECURITY DEFINER definitions, use a deliberately minimal trusted search path, preferably `SET search_path = ''` with fully schema-qualified references, or an explicitly controlled path that places `pg_temp` last.
- Audit every unqualified relation, type, operator, and function reference before changing existing routines.
- Verify who has CREATE on `public` and whether untrusted roles can create objects in any schema included in a SECURITY DEFINER search path.
- Treat a change to function search_path as a security migration requiring review and tests, not as a cosmetic edit.

The static migration snapshot does not show the effective deployed schema ACLs, role memberships, database-level default privileges, or any out-of-band grants. Therefore, this report does not claim that the `public` schema is writable by untrusted roles, nor that search-path shadowing is currently exploitable.

## 2. Transaction-local document bypass flags

The reviewed code uses the following custom settings:

- `app.doc_transition`: checked by `documents_guard_update()` to permit updates that would otherwise be rejected by the document-field guard.
- `app.doc_import`: checked by document/revision trigger logic to distinguish controlled import operations.

The main controlled writers set these settings transaction-locally:
- `transition_document(...)` sets `app.doc_transition = on` after loading and locking the target document and performing initial role checks, then clears it before returning.
- `commit_import_rows(...)` checks the batch and `can_edit_documents(...)`, sets both flags, processes rows, and clears both flags at the end.
- `revisions_after_insert()` temporarily sets the transition flag while updating the parent document as part of revision insertion, then clears it when not operating under the import flag.

**Assessment**
- The flags are implementation-level bypass signals, not independent authorization checks.
- Their safety therefore depends on all code paths that can set them being appropriately authorized and on there being no untrusted arbitrary-SQL execution path.
- Transaction-local scope limits persistence beyond the transaction, but does not make the setting itself unforgeable within that transaction.
- In `commit_import_rows`, row-level exceptions are caught inside the loop; the flags remain enabled while the controlled batch operation continues. The function clears them after the loop. A failure before the clear statements aborts the function's transaction scope, but deployed behavior should be tested rather than assumed from static inspection alone.

No direct user-callable route to set these flags was established in the reviewed source. This is a hardening/testing concern, not a confirmed bypass finding.

## 3. Authorization sequencing in privileged routines

The inspected privileged writers perform meaningful checks before sensitive writes:
- `transition_document` locks the target document, derives the caller's project role/party, rejects missing/viewer roles, and checks action-specific workflow conditions.
- `commit_import_rows` locks the batch and checks `can_edit_documents(b.project_id)` and batch state before enabling import flags.
- `preview_document_number` checks project membership before returning a preview.
- Tenant-scope trigger functions derive company/project scope from parent rows rather than trusting supplied scope values.

These controls are positive static evidence. They do not replace runtime tests for role/party edge cases, especially the admin exceptions and separation-of-duties cases already identified in report 57.

## 4. Required verification before any hardening migration

Before changing function definitions or grants:
1. Query the live database for `pg_proc.prosecdef`, `proconfig`, function owners, and effective EXECUTE ACLs for every SECURITY DEFINER routine.
2. Inspect schema ACLs and role memberships, including CREATE on `public`, default privileges, and any custom schemas in the effective search path.
3. Test whether any exposed RPC or application path can execute arbitrary SQL or invoke `set_config` in the same transaction; do not infer exploitability solely from the existence of a custom GUC.
4. Add negative tests proving ordinary authenticated users cannot bypass document lifecycle guards by directly updating protected fields or setting the custom flags through any exposed interface.
5. Add positive tests proving authorized transition and import RPCs still work, and that flags do not leak across operations or transactions.
6. Review all function overloads and ensure any replacement preserves intended ownership, grants, volatility, and SECURITY DEFINER/INVOKER behavior.

Any proposed migration must be backed up, restored and tested independently, then presented for explicit approval. No live database access or migration execution was performed for this report.

## Scope and limitations

This is a static review of the named migration files on `dev/review-fixes`. It is not a live database ACL inspection, penetration test, runtime RPC test, SQL injection test, or verification of deployed Supabase configuration. No application source, migration, database, branch setting, or deployment was changed. No tests, lint, or build were run.

## Disposition

- **Positive:** reviewed SECURITY DEFINER routines set a fixed search path; most application object references are schema-qualified; no dynamic SQL was identified in the inspected migration.
- **Hardening:** make `pg_temp` handling explicit or use an empty search path with fully qualified names; verify effective schema privileges.
- **Verification required:** prove custom transaction-local bypass flags cannot be set through any exposed untrusted execution path; test lifecycle and import paths.
- **No confirmed exploit:** none established from the inspected static evidence.
