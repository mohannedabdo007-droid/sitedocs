# 38 — Document Numbering, Revision Integrity, and Historical Import Semantics Review

**Status:** Static source and migration review only  
**Branch:** `dev/review-fixes`  
**Scope:** `0000_core_schema.sql`, `0001_triggers_and_rpcs.sql`, `src/lib/numbering.ts`, and import revision handling in `commit_import_rows`.  
**Not performed:** No live database/catalog access, SQL execution, concurrent transaction test, data scan, source edit, migration, or runtime test.

## Executive summary

The document model has several useful safeguards: project-scoped document-number uniqueness, row locking of a numbering scheme during generated-number allocation, unique revision index and label per document, and a revision trigger that derives project/company scope from the parent document. The review nevertheless identifies important edge cases in preview consistency, revision referential integrity, imported historical revisions, and mutable configuration.

These are static findings against the checked-in migrations. They are not proof that a live database has these exact objects or that a specific record is currently corrupt.

## Findings

### F38-01 — Number preview does not apply the allocator's collision-skip logic
**Priority: Medium — user-facing consistency**

`preview_document_number()` formats the scheme's current `next_seq` and returns it directly. The actual `documents_before_insert()` allocator locks the scheme row, checks existing project document numbers in a loop, and skips occupied candidates before advancing `next_seq`.

**Risk:** If a scheme counter is stale (for example after imported/manual numbering or configuration changes), the preview can display a number already in use while actual creation silently advances to a later number. The preview is advisory, but users may rely on it when preparing correspondence or registers.

**Required action:** Make preview use the same collision-aware candidate logic without consuming the sequence, or explicitly label it as an approximate preview. Ensure any shared allocator logic is concurrency-safe and does not reserve a number until the actual insert.

### F38-02 — Current-revision foreign key does not visibly enforce same-document ownership
**Priority: High — referential integrity**

The schema defines `documents.current_revision_id` as a foreign key to `document_revisions(id)`. The constraint verifies that the revision exists, but the visible constraint is not composite with `documents.id`; therefore it does not, by itself, prove that the selected revision belongs to the same document.

The revision insert trigger normally updates the parent document to the newly inserted revision, which is a valid path. However, the schema-level invariant is weaker than the intended relationship.

**Risk:** A privileged or future code path that changes `current_revision_id` could associate a document with another document's revision unless every write path independently preserves the relationship.

**Required action:** Enforce same-document ownership with a composite unique key on revisions and composite foreign key from (document id, current revision id), or an equivalent database-enforced constraint/trigger. Verify migration compatibility and existing data before implementation.

### F38-03 — Historical import path bypasses manual revision normalization and lifecycle rules
**Priority: High — imported record integrity**

`revisions_before_insert()` applies important normalization and state checks when `app.doc_import` is not `on`: it derives the next revision index, requires Returned/Approved for a new manual revision, and clears response/submission fields. When import mode is enabled, these assignments are bypassed so the import can preserve supplied historical values.

The chunked import RPC casts the supplied revision index/label and creates imported revisions, but the static path does not demonstrate a complete semantic check that the imported revision's status, submitted/responded timestamps, response code, response actor, and ordering are mutually consistent with the project's historical policy.

**Risk:** An authorized importer could stage values that are syntactically valid but represent impossible or misleading history unless every field combination is revalidated at commit. This overlaps the server-side import validation gaps already recorded in reports 18, 29, and 31; it is specifically the revision-history semantic boundary.

**Required action:** Define a historical-import policy and enforce it inside the commit transaction: permitted lifecycle states, response-code applicability and active state, required actor/time combinations, chronological ordering, and which revision becomes current. Preserve legitimate historical records without converting import into a workflow bypass.

### F38-04 — Imported revision labels and indexes are structurally unique but not semantically canonical
**Priority: Medium — revision consistency**

The table enforces unique `(document_id, rev_index)` and unique `(document_id, rev_label)`, and the manual trigger computes the next index. The import path can preserve caller-supplied index and label. No visible database constraint requires a consistent mapping between a label such as `00`, `01`, or `A` and its numeric index.

**Risk:** Two distinct imported labels can represent the same revision sequence conceptually (for example, inconsistent numeric padding or mixed numeric/alphabetic schemes), affecting display order, resubmission counts, and user interpretation even while uniqueness constraints pass.

**Required action:** Define the supported revision-label convention per project/document type, including legacy labels. Validate the index-label pair server-side and retain an explicit legacy mapping where historical formats must be preserved.

### F38-05 — Numbering configuration accepts patterns that are only minimally validated
**Priority: Medium — configuration quality**

The schema's pattern check requires the text to contain `{SEQ` and limits its length to 120 characters. The frontend helper `isValidPattern()` applies a similar minimal test. The formatter replaces known placeholders and limits sequence padding width to 10, but the visible validation does not reject unknown placeholders, malformed sequence tokens, multiple competing sequence tokens, or a pattern that formats to an empty/ambiguous value.

**Risk:** A project administrator may configure a numbering pattern that appears valid in the UI but produces unexpected or colliding document numbers. The unique project/doc-number constraint prevents exact duplicates but does not make the format meaningful.

**Required action:** Use one shared server-side pattern grammar and test cases for all supported tokens, exactly one sequence token, width bounds, unknown-token rejection, and representative formatted outputs. Validate configuration before activation.

## Positive controls observed

- `documents` has a unique constraint on `(project_id, doc_number)`.
- Generated number allocation locks the selected numbering-scheme row with `FOR UPDATE` before advancing its counter.
- The allocator checks existing document numbers and skips occupied candidates.
- Revisions have per-document unique constraints on both revision index and label.
- The revision trigger derives project/company scope from the parent document.
- Authenticated table grants shown in the core schema allow revision SELECT/INSERT but not direct UPDATE/DELETE; live grants still require catalog verification.

## Acceptance tests required (not executed)

1. Preview with an unused counter; confirm it matches the next actual allocation.
2. Preview with a stale counter whose formatted candidate already exists; confirm preview communicates the collision and next candidate consistently without consuming a sequence.
3. Concurrently create documents under the same scheme; confirm no duplicate number and no lost sequence update.
4. Attempt to set a document's current revision to another document's revision; confirm the database rejects it.
5. Import historical revisions with valid and invalid chronology, response code/type combinations, lifecycle/timestamp contradictions, duplicate labels, and index-label mismatches.
6. Import multiple revisions out of order; confirm the intended current revision and document status are deterministic.
7. Test all accepted numbering placeholders, malformed tokens, multiple sequence tokens, unknown tokens, widths above 10, and maximum-length patterns.
8. Verify current production constraints, triggers, and grants through the authoritative database catalog after a verified backup/restore.

## Required boundaries

- No source, SQL, migration, schema, or database object was changed.
- No database was queried or modified; no data scan or concurrency test was performed.
- No test, build, or migration was executed.
- Findings are static and must be checked against the authoritative restored/live schema before remediation.

## Conclusion

The core numbering and revision model has sound foundational constraints, but preview/allocation parity and database-enforced current-revision ownership need attention. Historical imports require a clearly approved semantic contract so that preserving legacy records does not bypass lifecycle integrity. These should be resolved before relying on imported document history or treating numbering previews as definitive.
