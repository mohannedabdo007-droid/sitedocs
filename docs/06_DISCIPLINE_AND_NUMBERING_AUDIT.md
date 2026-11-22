# 06 — Discipline Consolidation & Document Numbering Audit

**Review date:** 2026-11-10  
**Target branch:** `dev/review-fixes`  
**Status:** static source audit and migration-planning requirements only. No live database access, data mutation, migration, or test execution.

## 1. Approved discipline model

The application must expose exactly these five selectable disciplines:

| Code | English | Arabic |
|---|---|---|
| `ARC` | Architectural | معماري |
| `CIVSTR` | Civil & Structural | مدني وإنشائي |
| `MEC` | Mechanical | ميكانيكي |
| `ELE` | Electrical | كهربائي |
| `SUR` | Survey | مساحة |

Civil and Structural are one discipline, not separate selectable disciplines. Existing historical `STR` and `CIV` records must be preserved and mapped to `CIVSTR` through a controlled compatibility strategy. Do not rewrite historical migration files or erase historical identifiers.

## 2. Source inventory

| Source | Relevant source behavior |
|---|---|
| `drizzle/migrations/0000_core_schema.sql` | Discipline table has unique code; seed currently inserts ARC, STR, MEC, ELE, CIV. |
| `drizzle/migrations/0001_triggers_and_rpcs.sql` | Number format uses discipline code; numbering scheme resolves exact discipline first, then project/type generic scheme; insert trigger locks the selected scheme row and increments next_seq. |
| `drizzle/migrations/0003_import_validation_and_kpi_buckets.sql` | KPI RPC groups by raw discipline code. |
| `src/lib/import/mapping.ts` | Import suggestions match exact code, English name, or Arabic name; no visible STR/CIV legacy aliases. |
| `src/lib/kpi.ts` | UI groups discipline rows by `discipline_code`; no visible STR/CIV consolidation. |

## 3. Findings

### DISC-01 — Existing reference seed does not match the approved five-discipline model

**Source:** `0000_core_schema.sql`, lines 528–533.

The historical seed contains ARC, STR, MEC, ELE, CIV. It has no CIVSTR or SUR. This is expected historical state and must not be edited in-place.

**Required change:** add a new forward migration managed by Lovable after backup/restore gates. Seed CIVSTR and SUR idempotently. Preserve STR/CIV rows as legacy reference values until every dependent record and import compatibility path is accounted for. The user-facing selector must expose only the five approved current disciplines.

### DISC-02 — Legacy STR/CIV records will remain split in reporting unless normalized

**Source:** `0003_import_validation_and_kpi_buckets.sql`, KPI CTE and GROUP BY; `src/lib/kpi.ts`, `groupBy` and `byDiscipline`.

The SQL groups by the stored discipline code and the client groups by the returned discipline code. Existing STR and CIV documents will therefore remain separate KPI buckets unless the migration or a canonical reporting layer maps both to CIVSTR.

**Required change:** define a single canonical reporting mapping: STR → CIVSTR and CIV → CIVSTR, while retaining the original historical mapping in audit/legacy metadata if needed. Verify project/type/status/response/aging totals remain invariant before and after normalization. Ensure SUR appears in every applicable KPI and report dimension.

### DISC-03 — Import mapping has no legacy aliases

**Source:** `src/lib/import/mapping.ts`, lines 112–132 and 254–273.

Discipline value suggestions compare exact current code/name values. No explicit alias table for STR/CIV is visible. After the current selector changes, historical spreadsheets containing Structural/STR or Civil/CIV could become unmapped unless aliases are added.

**Required change:** accept legacy values STR, Structural, CIV, Civil as aliases to the canonical CIVSTR discipline ID for new imports, while preserving the original imported cell/value in row raw data and import audit metadata. Add SUR and Survey/مساحة aliases. Never silently map ambiguous or unknown values.

### DISC-04 — Numbering schemes are discipline-scoped but require migration inventory

**Source:** `0000_core_schema.sql`, numbering_schemes unique key; `0001_triggers_and_rpcs.sql`, `resolve_numbering_scheme` and `documents_before_insert`.

A numbering scheme is unique per project, document type, and nullable discipline. Resolution prefers an exact discipline scheme and falls back to a generic (NULL discipline) scheme. The document insert trigger locks the resolved scheme row, increments next_seq, and checks candidate collisions within the project.

**Risk:** merging STR and CIV into one discipline can create duplicate scheme keys or competing sequence histories for the same project/type. A careless choice of one next_seq can generate collisions or cause a sequence to regress. Different patterns can also produce different numbering conventions.

**Required change:** inventory every project × document type × discipline scheme, including pattern, next_seq, and actual document numbers. For each STR/CIV pair, decide the canonical CIVSTR pattern and next sequence based on existing issued numbers and collision analysis. Preserve numbering history; never use MAX(next_seq) alone without testing generated candidates against all existing document numbers and both legacy streams.

### DISC-05 — Document number identity and historical references need preservation

**Source:** documents unique constraint on `(project_id, doc_number)`; document discipline foreign key; revision and review relations.

Changing a discipline reference does not itself require changing doc_number, revisions, review history, or audit events. However, if numbering formats embed STR/CIV, changing the number would be a separate and high-impact renumbering operation.

**Required change:** preserve issued doc_number values exactly. Do not rewrite document numbers to CIVSTR by default. Keep legacy code traceability in a dedicated mapping/metadata record if needed. Ensure all revisions, attachments, reviews, comments, and audit history remain linked to the same document IDs.

### DISC-06 — Numbering concurrency and fallback behavior need explicit tests

**Source:** `0001_triggers_and_rpcs.sql`, `resolve_numbering_scheme`, `preview_document_number`, and `documents_before_insert`.

The allocation trigger locks the selected scheme row and checks existing document-number collisions. Preview reads next_seq without consuming it and is not a reservation. A generic fallback scheme may be shared by multiple disciplines when no exact discipline scheme exists.

**Required change:** test concurrent inserts for the same project/type/disc and for different disciplines sharing a generic fallback scheme. Verify no duplicate numbers, no sequence regression, and clear retry/error behavior. Document that preview results are advisory and can change before creation. Check uniqueness behavior when a scheme is first created concurrently.

### DISC-07 — Migration order and idempotency are critical

**Required change:** design the future migration to:
1. Create CIVSTR and SUR reference rows idempotently.
2. Build and validate a complete legacy STR/CIV-to-CIVSTR mapping.
3. Inventory all dependent references before changing any.
4. Resolve project/type numbering scheme collisions with a documented deterministic rule.
5. Update document discipline references in a transaction, preserving document IDs and all historical child records.
6. Keep old discipline rows/aliases available for historical imports and traceability unless a later, separately approved cleanup proves safe.
7. Validate row counts, foreign keys, unique constraints, number collisions, and before/after KPI totals.
8. Include a tested recovery plan; do not assume a reverse update can restore merged numbering decisions.

## 4. Required acceptance tests

- Exactly five current disciplines are offered in new-document selectors: ARC, CIVSTR, MEC, ELE, SUR.
- STR and CIV do not appear as separate current choices.
- Legacy imports containing STR, Structural, CIV, or Civil map to CIVSTR; original raw values remain traceable.
- SUR, Survey, and مساحة map to SUR.
- Unknown/ambiguous discipline values fail validation rather than silently defaulting.
- Existing documents retain their IDs, doc_number, revisions, reviews, attachments, comments, and audit references.
- Every existing STR/CIV document is represented in the canonical CIVSTR reporting bucket.
- KPI totals, overdue counts, aging buckets, revision counts, and B/C counts reconcile before/after mapping.
- SUR appears correctly in imports, document filters, KPIs, reports, and exports.
- Numbering scheme inventory is complete per project/type/discipline, including generic schemes.
- No duplicate document numbers occur under concurrent creation or after consolidation.
- Sequence values never regress; preview is explicitly non-reserving.
- Existing issued document numbers remain unchanged.

## 5. Required pre-migration inventory

Before any migration proposal is approved, produce a read-only inventory from the correct isolated restored database containing:
- discipline rows and usage counts;
- documents grouped by project, document type, discipline, status, and source;
- numbering schemes with pattern and next_seq;
- actual document-number collisions under the proposed CIVSTR mapping;
- duplicate scheme groups after canonicalization;
- KPI aggregates before and simulated after canonicalization;
- orphaned or unexpected discipline references;
- import mapping values observed in historical batches.

No real project IDs, customer names, or sensitive row-level values should be added to public repository documentation. Use aggregate counts and anonymized identifiers.

## 6. Change control and status

- Current source migrations inspected: yes.
- Current import and KPI source inspected: yes.
- Approved five-discipline model recorded: yes.
- Live database inventory: not performed.
- Numbering collision analysis: not performed.
- Backup and isolated restore: not evidenced.
- Migration drafted: no.
- Migration applied: no.
- Application code changed: no.
- Tests, lint, or build executed: no.

This document is a review plan, not permission to change schema or data. Follow `AGENTS.md`: never manually edit Lovable-managed migration files or generated schema/types. Any migration must be generated through the approved Lovable workflow after the correct Supabase project is verified, an independent backup is made, a separate restore succeeds, the exact migration and recovery plan are reviewed, and the user explicitly approves that exact database change. Do not merge to `main`.
