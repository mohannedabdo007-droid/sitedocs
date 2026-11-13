# DD-06 — Official RFI Numbering and Legacy Reconciliation: Atomic Leaf Requirements

**Document type:** Governance traceability decomposition — working draft  
**Date:** 2026-11-13  
**Status:** WORKING DRAFT — CANDIDATE LEAVES — OWNER / DOCUMENT CONTROL / DATA-RECORDS REVIEW PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent specification:** `docs/74_RFI_OFFICIAL_NUMBERING_AND_LEGACY_RECONCILIATION_WORKING_DRAFT.md`  
**Classification dependency:** `docs/73_RFI_CLARIFICATION_REVISION_CLASSIFICATION_WORKING_DRAFT.md`  
**Transaction dependency:** DD-07 / `docs/75_RFI_CONCURRENCY_IDEMPOTENCY_TRANSACTION_INTEGRITY_WORKING_DRAFT.md`  
**Controlling decisions:** DEC-002, DEC-004/005, DEC-022-A/B, DEC-023, DEC-104, DEC-107, DEC-110

> This document decomposes the DD-06 working specification into candidate atomic requirements. It does not select a display pattern, settle the final uniqueness namespace, certify a complete legacy inventory, approve a sequence baseline, implement an allocator or authorize data migration. Raw historical values and records must remain preserved.

## 1. Identity separation

The following identities remain distinct: internal draft ID, official RFI number, formal revision, clarification-round ID, response version, discipline contribution ID/version, Transmittal ID and legacy/source reference. RFI numbering remains independent of WIR and other document-family numbering.

## 2. Atomic leaf requirements

### A. Official identity and allocation boundary

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-NUM-L001 | Draft creation shall create only an internal draft identity and shall not allocate an official RFI number. | Draft/official identity separation. | DEC-022-A; DD-06 §2 |
| RFI-NUM-L002 | Official RFI number allocation shall occur only upon successful first formal submission and successful authoritative commit. | Submission result and allocation event bound together. | DEC-022-A; DEC-107 |
| RFI-NUM-L003 | Failed, rejected, abandoned or unsuccessful draft/submission attempts shall not consume an official RFI number. | Negative allocation evidence. | DEC-022-A |
| RFI-NUM-L004 | Saving, editing, uploading, commenting, validation preview or administrative routing shall not allocate or reserve an official RFI number. | No-reservation controls. | DEC-022-A; DD-06 §§3,11 |
| RFI-NUM-L005 | Each official RFI number shall map to one official RFI identity within the owner-approved uniqueness namespace. | Authoritative uniqueness proof; namespace remains open. | DEC-104; DEC-107 |
| RFI-NUM-L006 | An allocated official RFI number shall remain permanently consumed and shall never be reused after withdrawal, cancellation, closure, archive or supersession. | Non-reuse register and historical checks. | DEC-022-A; DEC-107 |
| RFI-NUM-L007 | An RFI's official number shall remain stable across formal revisions, clarification rounds, response cycles, discipline changes and Transmittals. | Identity invariance checks. | DEC-022-B; DEC-104/107 |
| RFI-NUM-L008 | A linked new RFI shall receive its own distinct official number only after its own successful first formal submission. | Independent submission/allocation lineage. | DD-05; DEC-022-A |

### B. Identifier and namespace integrity

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-NUM-L009 | Official RFI identity and numbering shall remain separate from WIR and all other document-family numbering streams. | Namespace separation evidence. | DEC-002; DEC-023 |
| RFI-NUM-L010 | Official number, revision, clarification-round ID, response version, contribution ID and Transmittal ID shall not be conflated or substituted for one another. | Identifier crosswalk and validation. | DEC-107/108; DD-05 |
| RFI-NUM-L011 | The human-readable display pattern shall remain unapproved until owner and Document Control explicitly select and record it. | Approved versioned numbering profile. | DD-06 §4 |
| RFI-NUM-L012 | The uniqueness boundary shall remain blocked until the owner confirms project/portfolio namespace behavior, including project reuse, merger and consolidation cases. | Explicit namespace decision and exception rules. | DD-06 §5 |
| RFI-NUM-L013 | A visible discipline marker shall not be embedded in the official number without explicit approval and a rule for multidisciplinary scope and later discipline changes. | Owner decision and non-renaming rule. | DD-06 §4 |
| RFI-NUM-L014 | Project renaming, code change or merger shall not silently rewrite previously issued official RFI numbers. | Stable identity and approved alias/cross-reference. | DD-06 §§4–5 |

### C. Legacy source inventory and provenance

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-NUM-L015 | A read-only inventory shall identify every accessible source system, register, archive, export and import batch that may contain RFI identities. | Source catalogue and coverage statement. | DD-06 §6 |
| RFI-NUM-L016 | Each inventoried record shall preserve source system/file/table, source primary key, project attribution, raw document type and raw number exactly as found. | Provenance-complete inventory. | DD-06 §6 |
| RFI-NUM-L017 | Inventory shall distinguish confirmed official RFI, probable RFI, unverified reference, draft, duplicate candidate, non-RFI misclassification and unresolved record. | Evidence-based source classification. | DD-06 §6 |
| RFI-NUM-L018 | A textual reference to an RFI number shall not by itself prove the existence or official status of an RFI record. | Source-authority evidence and classification rationale. | DD-06 §6 |
| RFI-NUM-L019 | Raw legacy identifiers and source records shall remain preserved alongside any normalized comparison key or proposed canonical mapping. | Raw/canonical dual representation and integrity check. | DD-06 §§6–7,9 |
| RFI-NUM-L020 | Inventory coverage limitations, inaccessible sources and unverified source completeness shall be explicitly disclosed. | Coverage statement with exclusions and reasons. | DD-06 §§6,12 |

### D. Collision analysis and legacy reconciliation

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-NUM-L021 | Normalization shall be used for comparison only and shall not automatically merge records or rewrite raw issued numbers. | Non-destructive comparison evidence. | DD-06 §7 |
| RFI-NUM-L022 | Exact, equivalent-format, cross-project, cross-type, sequence, alias, identity-split, identity-merge and unverified-reference collisions shall be separately identifiable. | Collision taxonomy and case register. | DD-06 §7.1 |
| RFI-NUM-L023 | Each collision disposition shall preserve affected raw records, provenance, project/type scope, evidence, proposed mapping, authority, review and recovery implications. | Attributable collision case file. | DD-06 §7.2 |
| RFI-NUM-L024 | No collision shall be resolved by maximum-number selection, blind suffixing, row overwrite, destructive merge or unsupported renumbering. | Explicit prohibited-action checks. | DD-06 §§7–9 |
| RFI-NUM-L025 | Duplicate representations of one RFI shall retain source identities and provenance through an authorized alias/duplicate relationship rather than destructive deletion. | Source-to-canonical relationship and reconciliation. | DD-06 §9 |
| RFI-NUM-L026 | A source record with unresolved official status or project attribution shall not influence the allocator baseline until authorized reconciliation resolves or explicitly contains it. | Blocked/unresolved inventory status. | DD-06 §§6,8–9 |

### E. Sequence baseline, allocator and user-facing controls

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-NUM-L027 | A proposed next-sequence baseline shall be derived from reconciled source evidence and shall not be inferred solely from MAX(sequence), a seed value or latest visible number. | Per-project evidence-based sequence report. | DD-06 §8 |
| RFI-NUM-L028 | Historical sequence gaps shall not be treated as reusable numbers without evidence that they were never allocated. | Gap investigation and non-reuse proof. | DD-06 §8 |
| RFI-NUM-L029 | Any future allocator shall bind allocation to successful first formal submission, enforce namespace uniqueness, non-reuse, idempotency and concurrency safety, and recover timeout-after-commit without a second number. | DD-07 architecture, transaction and acceptance evidence. | DD-06 §10; DD-07 |
| RFI-NUM-L030 | Client-supplied values and previews shall not reserve or assign official numbers; uncertain submission outcomes shall resolve the original committed result before retry. | Server-authoritative allocation and safe UI behavior. | DD-06 §10–11; DEC-110 |
| RFI-NUM-L031 | Legacy mapping or any later migration shall preserve original identifiers, revisions, attachments, reviews, Transmittals, acknowledgements and audit history. | Before/after lineage and reconciliation evidence. | DD-06 §9,12 |
| RFI-NUM-L032 | Any future allocator or data migration shall remain blocked until approved numbering profile, complete verified inventory, collision dispositions, security/records review, test plan, verified backups and isolated restore/rehearsal are accepted by the owner. | Separate scoped authorization and rehearsal evidence. | DD-06 §§12,15; DEC-110 |

## 3. Open decisions and blockers

- Final display pattern, characters, separators and project-code treatment.
- Project-only versus portfolio-wide uniqueness and project merger/reuse behavior.
- Discipline marker policy and multidisciplinary stability.
- Complete authoritative legacy source inventory and source hierarchy.
- Historical duplicate, split identity, cross-project and unverified-reference dispositions.
- Per-project sequence baseline and exception authority.
- Controlled manual correction/import process.
- DD-07 allocator transaction, idempotency, concurrency and recovery design.
- QA expected results, fixtures, test ownership and evidence.
- Any future migration requires separate verified DB/Storage backups, isolated restore/rehearsal and reconciliation.

No default value may be inferred from current code, seed data, WIR numbering or a historical maximum.

## 4. DD-15 candidate mapping instructions

Map leaves only to exact source AT-RFI/E2E definitions that exercise the requirement. Keep inventory/reconciliation evidence separate from software test execution. Do not invent test IDs, assume source inventory completeness, or mark any test passed without execution evidence. Mark uncovered and blocked requirements explicitly. Numbering, uniqueness, idempotency and collision cases require owner/Document Control/records/architecture/security/QA validation before expected-result promotion.

## 5. Implementation boundary

This document does not approve a numbering format, namespace, allocator, sequence start, legacy mapping, manual correction authority or migration. It authorizes no DB/schema/migration/generated types, data mutation, API/UI/code, Storage, auth/RLS/grants, production-data operation, live test, backup/restore, merge or deployment.

**Current disposition:** 32 candidate leaves prepared. Owner, Document Control, data/records, architecture, security and QA review remain pending. No inventory completeness, test execution/pass, allocator readiness or implementation authorization is claimed.
