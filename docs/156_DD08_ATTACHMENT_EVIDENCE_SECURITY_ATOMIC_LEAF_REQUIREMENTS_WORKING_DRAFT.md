# DD-08 — Attachment and Evidence Security: Atomic Leaf Requirements

**Document type:** Security and evidence-governance traceability decomposition — working draft  
**Date:** 2026-11-13  
**Status:** WORKING DRAFT — CANDIDATE LEAVES — SECURITY / ARCHITECTURE / RECORDS / OWNER / QA VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent specification:** `docs/76_RFI_ATTACHMENT_AND_EVIDENCE_SECURITY_WORKING_DRAFT.md`  
**Cross-specification review:** `docs/130_DD08_EVIDENCE_SECURITY_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md`  
**Transaction/manifest contract:** `docs/131_DD07_DD08_EVIDENCE_TRANSACTION_AND_MANIFEST_CONTRACT_WORKING_DRAFT.md`  
**Related atomic leaves:** DD-02 docs/149; DD-04 docs/152; DD-07 docs/155; DD-14 docs/146  
**Controlling decisions:** DEC-021, DEC-051, DEC-053, DEC-103, DEC-104, DEC-107, DEC-108, DEC-109, DEC-110

> These leaves decompose the evidence-security candidate specification and its cross-review dependencies. They do not select a storage provider, scanner, cryptographic algorithm, file-type policy, size limit, token mechanism, retention schedule or legal authority. No real file operation, Storage implementation, DB/schema change, test execution or production operation is authorized.

## 1. Atomic leaf requirements

### A. Evidence identity, provenance and version integrity

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-EVD-L001 | Every logical evidence item shall have a stable evidence identity distinct from filename, URL, storage key or content digest. | Canonical evidence identity record. | DD-08 §4; EVD-01 |
| RFI-EVD-L002 | Each accepted content version shall have a distinct immutable version identity; changed bytes or approved replacement metadata shall create a successor version. | Immutable version lineage. | DD-08 §4; DEC-107 |
| RFI-EVD-L003 | Physical storage object/generation identity shall remain separate from business evidence identity and shall not itself confer authorization. | Storage-to-evidence reference and access separation. | docs/131 §2; EVD-01 |
| RFI-EVD-L004 | Each evidence relationship to an RFI, cycle, contribution, review, response or Transmittal shall be explicit, attributable and purpose-scoped. | Relationship identity, target, purpose and authority. | DD-08 §§3–4; docs/131 |
| RFI-EVD-L005 | Evidence provenance shall identify uploader, originating party, project, purpose, timestamp, classification and applicable business context. | Provenance metadata and source attribution. | DD-08 §§3–4; DEC-107 |
| RFI-EVD-L006 | Replacing, correcting or unlinking evidence shall preserve prior versions, relationships and submitted/issued snapshot history. | Successor events and predecessor references; no destructive overwrite. | DEC-107; DD-08 §4 |
| RFI-EVD-L007 | A derivative shall identify its exact source version and transformation/profile version and shall never silently substitute for the original evidence. | Derivative lineage and source-version reference. | DD-08 §11; docs/131 §2 |

### B. Intake, quarantine, validation and scanning

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-EVD-L008 | Upload intent shall be authenticated and authorized for the exact target, party/project scope, evidence class and purpose before intake. | Action-time upload authorization. | DD-08 §5; DD-02 |
| RFI-EVD-L009 | Partial or interrupted transfer shall remain provisional and shall not be represented as accepted evidence or manifest-eligible content. | Transfer completion and provisional-intake evidence. | DD-08 §5; docs/131 §3 |
| RFI-EVD-L010 | Received content shall remain in a non-public quarantine/staging boundary until required validation, scanning and integrity checks are complete. | Quarantine isolation and promotion gate. | DD-08 §5 |
| RFI-EVD-L011 | File-type validation shall compare declared metadata with independently detected content characteristics under an approved policy. | Detected/declaration comparison and outcome. | DD-08 §6 |
| RFI-EVD-L012 | Malware/security scanning shall apply to the exact content version later promoted; a scan result shall not transfer to different bytes or a successor version. | Scan operation/version binding. | DD-08 §§5,7; EVD-04 |
| RFI-EVD-L013 | Failed, unavailable, timed-out, stale or indeterminate scan/validation outcomes shall not be treated as clean or eligible for ordinary access. | Fail-closed scan disposition. | DD-08 §§5–6; EVD-04 |
| RFI-EVD-L014 | Rescanning shall create an attributable new verification event and preserve the original scan result and policy version. | Scan history and policy/version lineage. | DD-08 §5; EVD-04 |
| RFI-EVD-L015 | Unsupported, encrypted, password-protected or uninspectable files shall remain blocked or follow only an expressly approved restricted exception route. | Approved file policy and exception authority; both remain open. | DD-08 §§5–6 |
| RFI-EVD-L016 | File-abuse controls shall address malformed/polyglot files, active content, nested archives, path traversal and resource-exhaustion risks under an approved threat model. | Security test/evidence profile; limits remain unselected. | DD-08 §6; EVD-05 |

### C. Integrity, manifests and transaction boundaries

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-EVD-L017 | Integrity verification shall be performed server-side against the exact received/stored bytes using an approved versioned integrity profile. | Algorithm/profile identifier, byte length, digest and verification event. | DD-08 §7; EVD-03 |
| RFI-EVD-L018 | A client-supplied digest shall not be accepted as proof of server-side integrity or authenticity. | Negative input-validation control. | DD-08 §7 |
| RFI-EVD-L019 | A digest shall not by itself be treated as proof of authorship, malware clearance, authenticity or technical approval. | Separate provenance, scan and technical decisions. | DD-08 §7; EVD-03 |
| RFI-EVD-L020 | Missing, mismatched, unverifiable or unexpectedly changed content shall create an integrity exception and block use for affected formal submission/review/issue purposes. | Fail-closed integrity incident. | DD-08 §7; EVD-03 |
| RFI-EVD-L021 | A frozen manifest shall bind exact evidence item/version, relationship, purpose, storage generation and applicable integrity/scan/derivative references. | Immutable manifest and entry-level evidence. | DD-08 §4; docs/131 §5 |
| RFI-EVD-L022 | A frozen manifest shall not be edited in place; any changed membership, evidence version, relationship, purpose or derivative shall follow a separately authorized successor-manifest operation. | Predecessor/successor manifest lineage. | docs/131 §5; EVD-02 |
| RFI-EVD-L023 | Manifest freeze shall recheck current authority, expected aggregate/collection version, evidence eligibility, relationship scope and all purpose-specific gates at the authoritative commit boundary. | Commit-time freeze preconditions. | docs/131 §5; DD-07 |
| RFI-EVD-L024 | Storage transfer, scanning, rendering and other external side effects shall remain distinct from authoritative business commits unless an approved architecture proves a shared transaction boundary. | Architecture-approved transaction/side-effect map. | docs/131 §4; DD-07 |
| RFI-EVD-L025 | A storage object without successful authoritative evidence registration shall remain unregistered/quarantined and shall not become ordinarily accessible evidence. | Orphan isolation and reconciliation. | docs/131 §4.2 |
| RFI-EVD-L026 | An authoritative evidence reference to missing or unverifiable stored content shall block retrieval/manifest use and create a reconciliation incident. | Missing-object incident and recovery evidence. | docs/131 §4.2; DD-07 |

### D. Authorization, privacy and recipient boundaries

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-EVD-L027 | Every list, metadata, preview, render, download, replace, link, export and retrieval action shall be authorized server-side for the exact actor, resource/version, purpose and current scope. | Per-operation authorization decision and audit. | DD-08 §8; DEC-021 |
| RFI-EVD-L028 | Prior RFI visibility, project membership, notification, Transmittal delivery, reviewer assignment or possession of an old link shall not independently grant file access. | Negative authorization cases. | DD-08 §§2,8–9; DEC-021/109 |
| RFI-EVD-L029 | Denial behavior shall not disclose protected file existence, filename, uploader, classification, content or cross-party metadata beyond the caller's authorized scope. | Privacy-safe denial and side-channel review. | DD-08 §8; DEC-109 |
| RFI-EVD-L030 | Access to a linked record or evidence item shall be independently authorized for each target record and action; a permitted relationship shall not imply permission to all linked resources. | Per-target authorization evidence. | DD-08 §8; DD-02 |
| RFI-EVD-L031 | Revocation and changed scope shall govern subsequent retrieval and access checks; cached metadata, old links and background retrieval must not silently bypass current authorization. | Revocation/cache/transport security review. | DD-08 §§8–11; EVD-06 |
| RFI-EVD-L032 | Transmittal evidence access shall be limited to the frozen manifest entries and recipient-specific scope; delivery, access and acknowledgement remain distinct. | Recipient-scoped manifest and separate event records. | DEC-103/108; EVD-07 |
| RFI-EVD-L033 | Derivatives, previews, thumbnails, OCR and exports shall not inherit broader access than their exact source version and authorized purpose. | Derivative authorization and cache isolation. | DD-08 §11; EVD-05/06 |

### E. Custody, records and recovery

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-EVD-L034 | Upload, scan, verification, promotion, relationship, freeze, preview/download, denial, rescan, incident and recovery events shall be attributable and reconstructable. | Custody/event lineage and privacy-safe audit. | DD-08 §12; EVD-08 |
| RFI-EVD-L035 | Evidence retention, archive, legal hold, backup/replica lifecycle and disposition shall follow separately approved records/legal controls; DD-08 shall not invent durations or authority. | DD-14 mapping and approved records instruments. | DD-08 §13; DD-14 |
| RFI-EVD-L036 | Recovery shall reconcile evidence identities, exact versions, storage generations, relationships, manifests, scan/integrity results and custody events without silent deletion or substitution. | Isolated recovery rehearsal and reconciliation evidence. | DD-08 §14; docs/131; DD-07 |
| RFI-EVD-L037 | Concurrency and idempotency controls shall prevent duplicate evidence registration, stale scan promotion, manifest mutation races and duplicate logical relationships. | DD-07 command/race evidence. | DD-08 §15; docs/131 §§6–7 |
| RFI-EVD-L038 | QA acceptance shall include positive, negative, boundary, stale-version, revocation, integrity-mismatch, quarantine, derivative, manifest and recovery cases using approved isolated fixtures. | QA-approved tests and retained execution evidence. | DD-08 §16; DEC-110 |

## 2. Cross-review findings and unresolved dependencies

The exact-version desk review in docs/130 recorded EVD-01–EVD-11 and DEP-EVD-01–DEP-EVD-11. No direct normative contradiction was identified, but the evidence contract is not yet test-ready. Preserve at minimum these open areas:

- Canonical identity/cardinality among evidence item, version, storage generation, relationship, manifest entry and derivative.
- Manifest freeze/canonicalization, duplicate entries, concurrency and replay.
- Approved integrity profile, exact byte representation, key/metadata protection and algorithm agility.
- Quarantine/scanning state ownership, unscannable files, rescan and malicious-after-acceptance response.
- File formats, active content, archive policy, limits and safe rendering.
- Per-operation authorization, revocation, in-flight streams, cache invalidation and any future bearer-link design.
- Recipient-specific Transmittal scope and derivative handling.
- Custody event taxonomy, correction, incident and audit integrity.
- Retention, hold, backup, replica, residual copies and disposition.
- Orphan/missing-object recovery and reconciliation.
- Exact source test definitions, expected-result authority, synthetic fixtures and QA ownership.

## 3. DD-15 candidate mapping instructions

Map only to exact AT-RFI/E2E definitions that genuinely exercise each leaf. Preserve source scenario wording and identify uncovered/partial/blocked requirements explicitly. Process/security/records approval evidence is not a passed product test. Do not invent test IDs, file limits, fixtures, scan results, test owners or pass status. No test execution is claimed.

## 4. Explicit exclusions and implementation boundary

No storage provider, scanner, file-type allowlist, size limit, digest algorithm, encryption/key-management design, token/URL mechanism, retention period, legal-hold authority, schema or capability ID is approved. No upload, preview, download, replacement, deletion, archive, hold, DB/Storage, API/UI/code, auth/RLS/grant, production-data, live test, backup/restore, merge or deployment is authorized.

Any future implementation requires exact-version security, architecture, records, QA and owner approval, approved file/records policies, a separate implementation plan and explicit authorization. DB/Storage changes additionally require verified backups, isolated restore/rehearsal and reconciliation.

**Current disposition:** 38 candidate leaves prepared. EVD-01–EVD-11 and DEP-EVD-01–DEP-EVD-11 remain open pending evidence. No test execution/pass or implementation authorization is claimed.
