# DD-08 Evidence Security Cross-Specification Review — Working Draft

**Document type:** Exact-version cross-specification desk review  
**Date:** 2026-11-12  
**Status:** DOCUMENT-LEVEL REVIEW COMPLETE — SECURITY / RECORDS / ARCHITECTURE / OWNER VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Primary specification:** [docs/76 — RFI Attachment and Evidence Security](76_RFI_ATTACHMENT_AND_EVIDENCE_SECURITY_WORKING_DRAFT.md)  
**Related specifications:** docs/75 (DD-07), docs/77–78 (DD-09/DD-10), docs/82 (DD-14), docs/83 (DD-15)  
**Related decision matrix:** docs/128 (DD-04 DM-01–DM-20)  
**Prior cross-review:** docs/126 and docs/129  
**Controlling decisions:** DEC-021, DEC-051, DEC-053, DEC-103, DEC-104, DEC-107, DEC-108, DEC-109, DEC-110

> This is a desk review of working drafts. It does not approve a security architecture, storage provider, cryptographic mechanism, file policy, records schedule, capability model, or test plan. It does not authorize implementation or operational file handling.

## 1. Executive result

**No direct normative contradiction was identified** between DD-08 (docs/76), DD-14 (docs/82), DD-15 (docs/83), DD-07 (docs/75) dependencies, and the exact-version evidence/access requirements referenced by DD-04 (docs/127–128).

DD-08 has a sound principle-level foundation: stable evidence/version identities, immutable snapshots, quarantine and fail-closed scanning, server-side integrity verification, per-operation authorization, derivative/cache restrictions, append-only custody events, and isolated recovery reconciliation.

However, **the evidence-security design is not yet a complete, test-ready evidence contract**. The principal gaps are not contradictions; they are unresolved identity/linkage semantics, security-control decisions, operational failure rules and test traceability. The document must not be promoted to implementation-ready on the strength of its current principle-level coverage.

**Review classification:** Aligned at principle level; detailed design and authority dependencies remain open. No implementation, test execution, backup/restore, or production-data operation was performed.

## 2. Exact source set and review method

The desk review considered:
- docs/76 §§1–18 — evidence taxonomy, identity/versioning, manifests, intake/quarantine, file validation, integrity, authorization, linked records, encryption, derivatives/cache, custody, retention, recovery, concurrency, acceptance and open decisions;
- docs/75 — idempotency, concurrency, transaction and recovery dependencies;
- docs/82 — records inventory, classification, archive, retention, hold, disposition, backup/replica and residual-copy boundaries;
- docs/83 §§7, 11, 15–16, 18–21 — negative authorization, attachment tests, records/recovery tests, scenario inventory and approval boundaries;
- docs/127–128 — exact-version review package, evidence/access decision points DM-10/DM-11/DM-15/DM-16/DM-19;
- docs/126 and docs/129 — prior cross-specification findings and dependencies;
- DEC-021, DEC-051, DEC-053, DEC-103, DEC-104, DEC-107, DEC-108, DEC-109 and DEC-110 as controlling constraints.

Finding classes:
- **Aligned:** compatible requirements reinforce one another.
- **Dependency / open design:** a required detailed rule, authority, mechanism or evidence is missing.
- **Clarification required:** wording or traceability should be made explicit to prevent divergent implementation.
- **Conflict:** applicable rules cannot both be followed. No direct conflict was identified.

## 3. Cross-specification findings

### EVD-01 — Business evidence identity, content-version identity and storage identity

**Sources:** docs/76 §4; docs/75; docs/82 §§3 and 8; docs/128 DM-10.

**Finding:** Aligned in principle, but canonical identity relationships remain underspecified. DD-08 correctly says that evidence ID and version ID are distinct and that storage object keys, URLs, filenames and hashes are not business identity. It does not yet define the authoritative relationship among:
- logical evidence item ID;
- immutable content-version ID;
- physical storage-object/generation reference;
- relationship/link ID to an RFI, contribution, review, response or Transmittal;
- frozen manifest-entry identity;
- derived artifact ID and transformation version.

**Required clarification:** Define these as distinct conceptual identities and specify their cardinality, ownership, lineage and immutability rules in a technology-neutral identity contract. A single version may have multiple business relationships only where each relationship is explicit; a physical object reference must not become a permission token or business identity. Derivatives must point to their exact source version and transformation lineage.

**Open dependency:** Architecture, security, Document Control and records authorities must validate canonical relationships and lifecycle behavior. Do not invent database tables, keys or schema here.

### EVD-02 — Manifest freeze, exact-version binding and concurrency

**Sources:** docs/76 §§4, 15 and 16; docs/75; docs/127 §8; docs/128 DM-10/DM-15/DM-16; docs/83 §§10–11.

**Finding:** Aligned. The documents consistently require immutable manifests and exact-version review/issue binding. DD-08 further states that concurrent replacement cannot mutate a frozen manifest and that a scan result applies only to the exact bytes scanned.

**Required clarification:** The eventual contract must define the freeze boundary, membership ordering or canonical representation, manifest revision/identity, treatment of duplicate relationship entries, atomicity/idempotency expectations, and how a concurrent replacement or delayed worker is rejected or reconciled. A frozen manifest must remain independently verifiable after later uploads, relinking, revocation or storage migration.

**Open dependency:** DD-07 transaction design and architecture/security review. No distributed atomicity or storage consistency behavior is assumed.

### EVD-03 — Integrity digest and authenticity boundary

**Sources:** docs/76 §7; docs/82 §8; docs/83 §11; DEC-107.

**Finding:** Aligned. DD-08 requires server-side calculation, exact-byte binding, algorithm identifier, content length, verification result and fail-closed handling of mismatch. It correctly states that a digest alone does not prove authorship, authenticity, malware clearance or technical approval.

**Required clarification:** Before implementation, the approved integrity profile must specify algorithm/version identifiers, exact byte representation, calculation point, storage-read verification semantics, metadata protection, migration/algorithm agility, and how verification failures are preserved and dispositioned. Any canonicalization must be explicit and justified; binary evidence should not be normalized implicitly. Distinguish a digest of source bytes from any digest of a derivative or manifest representation.

**Open dependency:** Security/architecture/records decision. No algorithm or key-management choice is made by this review.

### EVD-04 — Quarantine, scanning, promotion and rescanning

**Sources:** docs/76 §§5–6 and 14–16; docs/75; docs/83 §§11 and 16.

**Finding:** Aligned. Fail-closed behavior for scanner outage, timeout, indeterminate result and unscannable files is consistent across DD-08 and DD-15. Promotion must apply to the exact bytes/version scanned, and authorization/context must be rechecked before promotion.

**Required clarification:** Define the allowed scan state vocabulary and transition ownership; what constitutes a completed scan; treatment of encrypted/password-protected and unsupported files; signature/rule database freshness; rescan triggers for new threat intelligence or scanner compromise; quarantine retention/release authority; and behavior when a previously accepted version is later identified as malicious. Preserve the original scan result and add a new attributable rescan event rather than rewriting history.

**Open dependency:** Security authority and architecture must approve file policy, scanner operation, exception authority and incident process. No scanner/provider, file type list, limit or rescan interval is inferred.

### EVD-05 — File abuse resistance and safe derivative generation

**Sources:** docs/76 §§6 and 11; docs/83 §11.

**Finding:** Aligned but not yet operationally testable. The drafts identify MIME spoofing, malformed/polyglot files, active content, archive bombs, nested archives, path traversal, resource exhaustion and isolated rendering. They leave supported formats, parser policy, limits and preview guarantees open.

**Required clarification:** Security/architecture must define validation stages and failure outcomes for detected-vs-declared type, archives and nested content, active content/macros, password-protected files, parser/rendering failures, resource ceilings, and derivative provenance. A derivative must never silently replace the original or inherit broader access. Unsupported/uninspectable content must remain blocked or use an expressly approved restricted handling route.

**Open dependency:** Approved file policy and threat model. No numeric limits or universal format support are invented.

### EVD-06 — Per-operation authorization, revocation and transport links

**Sources:** docs/76 §§8–9 and 11; docs/82 §§9 and 12; docs/83 §7; docs/128 DM-11; DEC-021/DEC-109.

**Finding:** Aligned. All sources require authorization against the exact actor, record, file/version, action and purpose. Notification, Transmittal, RFI visibility, reviewer assignment, historical status or possession of an old link does not itself grant file access.

**Required clarification:** The security contract must distinguish authorization at link issuance from authorization at content retrieval, define revocation behavior for in-flight streams and background exports, and state cache/index invalidation limits. If signed URLs or equivalent bearer mechanisms are later selected, their scope, lifetime, replay behavior, revocation limits and exposure through logs/referrers/browser history must be explicitly reviewed. Previously downloaded copies cannot be recalled and must remain an explicit residual risk.

**Open dependency:** DD-02 capability/appointment mapping, DD-09 recipient identity, and security/privacy/architecture review. No capability IDs or token design is selected.

### EVD-07 — Transmittal and recipient-specific evidence scope

**Sources:** docs/76 §9; docs/77–78; DEC-103/DEC-108; docs/83 §12.

**Finding:** Aligned. Recipient access is limited to exact manifest entries and authorized purpose; delivery, access, acknowledgement and substantive response remain separate events. A Transmittal must not expose sibling, draft or later evidence.

**Required clarification:** Reconcile the frozen Transmittal manifest to the evidence-version and relationship identities from EVD-01. Define how an intentionally included derivative is identified, how recipient-specific access is revoked or expires, and how a changed package or recipient scope creates a new controlled dispatch without mutating the old manifest.

**Open dependency:** DD-09/DD-10 identity, channel and recipient authority decisions. No external channel or public link is assumed.

### EVD-08 — Custody events, corrections and audit integrity

**Sources:** docs/76 §12; docs/82 §§3, 8 and 15–16; docs/83 §§11 and 15; DEC-107/DEC-109.

**Finding:** Aligned. Append-only, attributable history and traceable corrections are consistent. The documents correctly separate security/audit evidence from engineering evidence and prohibit silent repair or replacement.

**Required clarification:** Define the minimum event vocabulary and correlation/lineage requirements across upload, scan, verification, promotion, link/unlink, freeze, preview/download/export, denial, quarantine, rescan, incident, recovery and disposition. Record the applicable policy/appointment version without persisting raw secrets or unnecessary sensitive content. Specify how event integrity, clock source/time semantics, service identities and incomplete event publication are reconciled.

**Open dependency:** DD-07 event/transaction design, DD-14 records schedule, security and architecture. Do not infer an append-only database mechanism or tamper-proof log technology.

### EVD-09 — Records, legal hold, derivatives and residual copies

**Sources:** docs/76 §13; docs/82 §§3–14; docs/83 §15; DEC-109.

**Finding:** Aligned. DD-08 and DD-14 consistently refuse to invent retention periods or deletion authority and recognize originals, versions, derivatives, exports, caches, replicas, backups and recipient-held copies as potentially distinct lifecycle objects.

**Required clarification:** The records classification exercise must explicitly decide which evidence/version, manifest, scan result, derivative, access/custody event, Transmittal copy and recovery record belongs to which record series and whether they must be retained together. Hold scope must propagate to governed copies without assuming that every technical cache or recipient-held copy is controllable. Disposition evidence must distinguish inaccessible, logically removed, expired from backup and verified destroyed states.

**Open dependency:** Records/legal/contract authority, approved schedules, hold scope/release and residual-copy policy. Expiry is not deletion; no erasure claim is permitted without verification.

### EVD-10 — Failure recovery, orphan handling and reconciliation

**Sources:** docs/76 §§14–15; docs/75; docs/82 §§12–14; docs/83 §§10–11 and 15.

**Finding:** Aligned at principle level, with recovery mechanics unresolved. The drafts cover interrupted uploads, partial promotion, orphaned objects, stale workers, duplicate retries, missing objects and isolated restore.

**Required clarification:** Define reconciliation outcomes for each mismatch class: object exists without metadata; metadata points to missing object; duplicate provisional intake; manifest entry references an unavailable version; event committed without promotion or vice versa; scan result stale relative to content; and restored object conflicts with current hold/disposition/access state. Specify quarantine/containment, retry/idempotency, repair authority and evidence of reconciliation. No restored content should become accessible before identity, integrity, policy and hold checks complete.

**Open dependency:** DD-07 transaction contract, DD-14 recovery/records design and a separate approved architecture/rehearsal plan.

### EVD-11 — DD-15 attachment test coverage is thematic, not yet traceable

**Sources:** docs/83 §§3, 7, 11, 15–16 and 20; docs/76 §16; DEC-110.

**Finding:** Aligned but incomplete for acceptance planning. DD-15 §11 contains useful candidate test themes. The actual AT-RFI-01–13 and E2E-01–28 definitions have since been located in `docs/69` and imported into `docs/137_DD15_CONTROLLED_AT_RFI_AND_E2E_TEST_INVENTORY_WORKING_DRAFT.md`. However, the DD-08 attachment requirements are not yet individually mapped to those scenario IDs, approved atomic requirements, actors/capabilities, expected results, evidence artifacts or failure injections.

**Required clarification:** Using the source-preserving inventory in `docs/137_DD15_CONTROLLED_AT_RFI_AND_E2E_TEST_INVENTORY_WORKING_DRAFT.md`, produce a traceability matrix for every DD-08 requirement and EVD-01–EVD-10 control. Include positive and negative cases for exact-version binding, unauthorized metadata/list/preview/download, revocation, stale link/cache, scanner fail-closed, stale scan result, digest mismatch, malformed/archive abuse, manifest race, retry/idempotency, partial promotion, orphan reconciliation, derivative isolation, hold/disposition and isolated restore. Preserve original AT-RFI/E2E identifiers; add new IDs only under an approved convention.

**Open dependency:** QA must validate the imported source version and candidate mappings, obtain owner-approved expected outcomes, named test ownership, approved synthetic environment/data and evidence retention. No test is run or passed by this review.

## 4. Consolidated dependencies and blockers

| ID | Dependency | Required authority / evidence | Interim treatment |
|---|---|---|---|
| DEP-EVD-01 | Canonical identity and lineage contract | Architecture; security; Document Control/records | No schema or storage design based on assumed identity |
| DEP-EVD-02 | Manifest freeze and transaction contract | Architecture; DD-07; records | No mixed or mutable snapshot; unresolved race blocks |
| DEP-EVD-03 | Integrity profile and exception authority | Security; architecture; records | No algorithm or silent recalculation |
| DEP-EVD-04 | File classes, format policy, scan/quarantine/rescan | Security; owner; architecture | Fail closed; unsupported/indeterminate files blocked |
| DEP-EVD-05 | Derivative/rendering threat model and limits | Security; architecture; records | No broad preview support or numeric limits inferred |
| DEP-EVD-06 | Capability/appointment and retrieval authorization | Identity/security; project/party authority; DD-02 | No grants; action-time authorization remains mandatory |
| DEP-EVD-07 | Recipient identity and Transmittal evidence scope | Owner; contract/communications; security; DD-09/10 | No public/transferable access assumption |
| DEP-EVD-08 | Custody/event integrity and reconciliation | Architecture; security; records; DD-07 | Preserve exceptions; no assumed event technology |
| DEP-EVD-09 | Records series, retention, hold and residual copies | Records; legal/contract; owner | No automatic expiry deletion or erasure claim |
| DEP-EVD-10 | Recovery/orphan reconciliation and restore plan | Architecture; operations; security; records; owner | No live backup/restore; isolate before any future access |
| DEP-EVD-11 | Imported scenario inventory validation and requirement mapping | QA; owner; security; records; architecture | Source import complete; mapping and test design remain incomplete; no execution/pass |

## 5. Required documentation clarifications before promotion

1. Extend docs/76 with a conceptual identity/lineage contract distinguishing evidence item, content version, storage object generation, business relationship, frozen manifest entry and derivative.
2. Use the candidate crosswalk in [docs/131 — DD-07 / DD-08 Evidence Transaction and Manifest Contract](131_DD07_DD08_EVIDENCE_TRANSACTION_AND_MANIFEST_CONTRACT_WORKING_DRAFT.md) to reconcile manifest freeze and concurrency with DD-07, including stale worker, replacement race, duplicate retry and partial event/promotion cases; obtain architecture/security/records review before promotion.
3. Define the minimum approved integrity profile and rescan/quarantine state model only after security/architecture authority supplies decisions; keep algorithm/provider/limits blank until then.
4. Reconcile recipient-specific Transmittal manifest entries to evidence identity/version and derivative lineage under DD-09/DD-10.
5. Reconcile evidence, derivatives, security events and residual copies to DD-14 record-series/hold/disposition decisions.
6. Use the imported AT-RFI/E2E inventory in `docs/137` and map each approved DD-08 requirement to deterministic expected outcomes and retained evidence.
7. Repeat exact-version cross-specification review after the above clarifications and actual specialist findings.

These are design and traceability actions only. They do not authorize database schema, object-storage layout, provider selection, permission grants or service implementation.

## 6. Verification checklist

- [ ] Evidence item, content version, storage object, relationship, manifest entry and derivative are distinct and traceable.
- [ ] Manifest freeze is reconciled with DD-07 concurrency/idempotency and DD-04 exact-version review.
- [ ] Integrity digest semantics and exception authority are approved without conflating digest with authenticity or technical approval.
- [ ] Quarantine, scan, promotion and rescan are fail-closed and version-bound.
- [ ] File validation, archive handling and rendering threat model are approved.
- [ ] Preview/download/export/link authorization and revocation are checked at action time.
- [ ] Transmittal recipient scope is limited to exact frozen evidence versions.
- [ ] Custody/audit events are attributable and reconcile across failures.
- [ ] DD-14 classification, hold, backup/replica/cache and disposition decisions cover evidence and derivatives.
- [x] Actual AT-RFI/E2E definitions are imported into `docs/137`; no inferred scenario names or outcomes.\n- [ ] DD-08 requirements are individually mapped to scenarios, approved expected results and retained evidence.
- [ ] Security, records, architecture, QA and owner findings are exact-version and attributable.

## 7. Conclusion and boundaries

**Conclusion:** DD-08, DD-14, DD-15 and DD-04 are coherent at principle level. No direct normative contradiction was identified. Eleven cross-specification findings and eleven explicit dependencies are recorded. The material work remaining is to define canonical evidence identity/lineage, freeze and concurrency semantics, security-control decisions, recipient/records reconciliation, recovery outcomes and test traceability.

This review does not:
- approve a security or storage architecture, scanner, file type list, limits, digest algorithm, encryption/key service, provider or region;
- appoint security, records, QA, architecture or project authorities;
- approve retention periods, legal holds, disposition or erasure;
- grant capabilities or access;
- create schema, APIs, workflow, events, object layout or application behavior;
- execute tests, access production files, perform backup/restore, merge or deploy.

Any later implementation or test execution requires a separate scoped plan, approved decisions, exact specialist/owner evidence, approved non-production environment and synthetic data, and explicit owner authorization. DB/Storage work additionally requires verified backups, isolated restore/rehearsal and reconciliation before changes.

---

**Review result:** 11 findings recorded; 0 direct normative contradictions identified; 11 dependencies/blockers retained; specialist validation pending; no implementation, test execution, backup/restore or deployment performed.
