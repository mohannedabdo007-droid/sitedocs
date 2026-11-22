# 01 - Schema inventory (reference, documentation only)

Source: static extraction from drizzle/migrations 0000-0003 in backup `lovable-2026-11-10`.
Status: NOT verified against the live database. Step 1 of Phase 1 is to compare this file with the live catalog
(queries at the bottom) and record every difference. No database was contacted to produce this file.

## Counts (from the migrations)

- 21 tables in `public`, all with RLS enabled (no table without RLS).
- 48 policies in `public` + 2 on `storage.objects` (select, insert). 22 policy groups listed below.
- 35 function definitions (document_kpi_matrix appears twice: redefined in 0003), most `security definer`.
- 28 triggers (updated_at, scope, numbering, guard, revisions, audit on 12 tables, `on_auth_user_created` on auth.users).
- 6 enums.

## Enums

| enum | values |
|---|---|
| company_role | owner, admin, member |
| project_party | contractor, consultant, owner, pmc |
| project_role | admin, controller, reviewer, viewer |
| doc_lifecycle | draft, submitted, under_review, returned, approved, closed (no `cancelled` enum change approved or applied) |
| response_outcome | proceed, return, close (E is an originating-party cancel action, not a reviewer response) |
| comment_visibility | internal, external |

## Discipline reference data

The checked-in migration `drizzle/migrations/0000_core_schema.sql` currently seeds five separate rows: ARC Architectural, STR Structural, MEC Mechanical, ELE Electrical, and CIV Civil. This is the repository snapshot, not proof of live database contents.

**Approved target catalogue (documentation/design decision; not yet migrated): exactly five disciplines:**

| code (proposed) | English name | Arabic name |
|---|---|---|
| ARC | Architectural | معماري |
| CIVSTR | Civil & Structural | مدني وإنشائي |
| MEC | Mechanical | ميكانيكي |
| ELE | Electrical | كهربائي |
| SUR | Survey | مساحة |

Civil and Structural are one combined discipline, not two separate options. Survey is a distinct fifth discipline. The proposed codes `CIVSTR` and `SUR` are target identifiers only; before implementation, inspect existing foreign-key references, document numbering counters, imports, and historical records. Do not edit an already-applied historical migration or delete/merge live reference rows without an approved forward migration and a verified backup/restore. No database change has been made as part of this inventory update.

## Tables, grants to `authenticated`, and policies

| table | grants (authenticated) | policy actions |
|---|---|---|
| profiles | select, insert, update | select (shared scope), insert self, update self |
| companies | select, update | select (member), update (admin) |
| company_members | select, insert, update, delete | all four (role <> 'owner' on writes) |
| projects | select, update | select (member), update (can_manage_project) |
| project_members | select, insert, update, delete | all four (can_manage_project) **see finding A** |
| disciplines | select | select (true) |
| document_types | select | select (true) |
| project_response_codes | select, insert, update | select, insert, update |
| project_workflows | select, insert, update | select, insert, update |
| numbering_schemes | select, insert, update | select, insert, update |
| documents | select, insert, update | select (any member), insert/update (can_edit_documents) |
| document_revisions | select, insert | select (any member), insert (can_edit_documents) |
| document_reviews | select | select only (written by transition_document) |
| attachments | select, insert | select (member), insert (can_comment) |
| comments | select, insert | select (external or own party), insert (contributors) |
| audit_log | select | select (project members) |
| import_batches | select, insert, update | editors |
| import_rows | select, insert, update | editors |
| integration_connections | select | company admins |
| sync_jobs | select | company admins |
| ocr_jobs | select | project editors |
| storage.objects (bucket document-files) | - | select (member by first path segment), insert (can_comment) |

Immutability today relies on grants only: no DELETE grant on documents/reviews/revisions/audit_log; no UPDATE on reviews/revisions/audit_log. No trigger enforces it (finding: add triggers).

## Functions

Security definer helpers (RLS building blocks): is_company_member, is_company_admin, project_role_of, project_party_of,
is_project_member, can_manage_project, can_edit_documents, can_comment, shares_scope_with.
Security definer RPCs callable by `authenticated`: create_company, create_project, add_project_member, add_company_member,
transition_document, commit_import_rows, preview_document_number. Invoker: save_import_validation, document_kpi_matrix,
existing_revisions_for_numbers, format_doc_number, storage_project_id, documents_guard_update, set_updated_at.
Trigger functions (definer): handle_new_user, set_scope_from_project, set_scope_from_document, comments_before_insert,
import_rows_scope, documents_before_insert/after_insert, revisions_before_insert/after_insert, audit_row.
`resolve_numbering_scheme`: execute revoked from public, anon, authenticated (correct). Others: `revoke ... from anon` only.

## Known gaps referenced by this inventory (see CLAUDE_INDEPENDENT_REVIEW.md)

A party/role change by admins (project_members UPDATE + add_project_member upsert + admin bypass in transition_document);
B anon execute via PUBLIC grant; C storage not tied to document visibility; D email enumeration in add_*_member;
E response codes are free text (no FK); F documents/revisions company_id and storage_path integrity;
G drizzle/schema.ts and meta snapshots are empty.

## Live-catalog queries (read-only; run on the TEST project after restore first, live only if allowed)

```sql
-- tables and RLS
select c.relname, c.relrowsecurity, c.relforcerowsecurity
from pg_class c join pg_namespace n on n.oid=c.relnamespace
where n.nspname='public' and c.relkind='r' order by 1;

-- policies
select schemaname, tablename, policyname, cmd, roles, qual, with_check
from pg_policies where schemaname in ('public','storage') order by 1,2,3;

-- function privileges (finding B)
select p.proname,
       has_function_privilege('anon', p.oid, 'execute') as anon_exec,
       has_function_privilege('authenticated', p.oid, 'execute') as auth_exec,
       p.prosecdef as definer
from pg_proc p join pg_namespace n on n.oid=p.pronamespace
where n.nspname='public' order by 1;

-- table grants
select table_name, grantee, privilege_type
from information_schema.role_table_grants
where table_schema='public' and grantee in ('anon','authenticated') order by 1,2,3;

-- triggers
select event_object_table, trigger_name, action_timing, event_manipulation
from information_schema.triggers
where trigger_schema in ('public','auth') order by 1,2;

-- storage bucket settings
select id, public, file_size_limit, allowed_mime_types from storage.buckets;
```
