# DD-07 / DD-08 Evidence Transaction and Manifest Contract — Working Draft

**Document type:** Cross-specification transaction and evidence identity contract  
**Date:** 2026-11-12  
**Status:** CANDIDATE DESIGN — ARCHITECTURE / SECURITY / RECORDS / QA / OWNER REVIEW PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Primary sources:** docs/75 (DD-07), docs/76 (DD-08), docs/130 (DD-08 cross-spec review)  
**Related sources:** docs/82 (DD-14), docs/83 (DD-15), docs/127–128 (DD-04 exact-version review), docs/71 (backlog)  
**Controlling decisions:** DEC-021, DEC-051, DEC-053, DEC-103, DEC-104, DEC-107, DEC-108, DEC-109, DEC-110

> This document proposes an architecture-neutral contract for the boundary between RFI evidence handling and authoritative RFI transactions. It does not select a database, object-storage provider, scanner, queue, locking strategy, digest algorithm, token mechanism, file policy or retention schedule. It does not authorize schema, API, Storage, auth/RLS, code, test execution or operational file handling.

## 1. Purpose and governing principle

DD-07 defines safe command identity, idempotency, compare-and-commit, atomic business outcomes and recovery. DD-08 defines evidence identity, immutable versions, quarantine, integrity, authorization, manifests and custody. This document connects them.

**Core rule:** a business transaction may commit a reference to an evidence version only when that version is a known, immutable, integrity-verified and policy-eligible object for the exact intended purpose. A file transfer, scan worker or storage operation must never independently mutate an RFI lifecycle, review clearance, formal issue or frozen manifest.

The system must distinguish:
1. A file transfer attempt from a logical upload command.
2. A provisional intake from an accepted evidence version.
3. A logical evidence item from each immutable content version.
4. A content version from its physical storage object/generation.
5. A business relationship from a manifest entry.
6. A mutable working collection from a frozen, purpose-specific manifest.
7. A source file from any derivative (preview, OCR, thumbnail, normalized rendition or export).
8. A storage/scanning side effect from an authoritative RFI business outcome.

## 2. Conceptual identity model

The following are separate conceptual identities. Their physical representation is an architecture decision.

| Identity | Meaning | Required invariant |
|---|---|---|
| Evidence item ID | Stable logical identity for a file/evidence item | Never reused for unrelated content; not a URL, filename, digest or storage key |
| Evidence version ID | Immutable identity for one exact byte sequence and its approved metadata context | A replacement or changed byte sequence creates a new version; prior versions remain traceable |
| Storage object/generation reference | Physical location and exact stored generation | Not business identity, not authorization and not sufficient proof of integrity |
| Evidence relationship ID | Explicit link to RFI, cycle, contribution, review, response or Transmittal context | Relationship has its own scope, purpose, attribution and lifecycle; unlinking does not rewrite evidence history |
| Manifest ID/version | Purpose-specific frozen set of exact evidence relationships and versions | Frozen membership and entries cannot be silently changed |
| Manifest entry ID | Stable identity of one item in one manifest | Binds exact evidence item/version, relationship, intended purpose and any derivative reference |
| Derivative ID/version | Derived artifact and transformation lineage | Identifies exact source version, transformation profile/version and derivative bytes; never substitutes for source |
| Upload command/session ID | Logical upload intent across transport attempts | Retry attempts resolve to the same logical intent; key is not a bearer credential |
| Scan/verification operation ID | One attributable operation against exact content version | Result cannot be transferred to another version or byte sequence |
| Business command ID/idempotency key | One logical RFI/business action under DD-07 | Replays return the original result; key/payload mismatch is rejected |

No relationship may be inferred solely from matching filenames, hashes, storage paths, timestamps or user-supplied IDs. The same content bytes may legitimately be linked to more than one business record only through separately authorized relationship records. The design must decide whether deduplication is permitted and, if so, how it avoids cross-party existence disclosure and shared-retention/hold ambiguity. No deduplication behavior is assumed here.

## 3. Evidence intake and promotion lifecycle

Candidate conceptual stages (not an approved state vocabulary):

1. **Upload intent established:** authenticate actor, validate current action authority and scope, create or resolve a logical upload command/session.
2. **Transfer in progress:** receive bytes into a non-user-accessible staging/quarantine boundary. Partial bytes are not an accepted evidence version.
3. **Transfer completed:** verify transfer completion and expected length where available; bind the exact received byte sequence to the provisional intake. Client-supplied digest is advisory until independently verified.
4. **Server-side integrity recorded:** calculate the approved digest/profile over exact received bytes and retain algorithm/profile version, byte length and operation evidence. The approved profile remains a security decision.
5. **Validation and scanning:** perform approved file/type/content validation and scanning against the exact version candidate. Indeterminate, failed, stale or unsupported outcomes remain blocked under the approved fail-closed policy.
6. **Promotion eligibility assessed:** recheck actor authority, project/party/discipline scope, classification, purpose, integrity and scan result against the exact same content version.
7. **Evidence version registered:** establish immutable evidence version identity and its verified storage generation reference, together with attributable custody history.
8. **Business relationship created:** separately authorize and record the link to the relevant RFI/contribution/review/response purpose.
9. **Manifest inclusion/freeze:** only an eligible exact version and authorized relationship may be included; freeze is governed by Section 5.
10. **Later correction/replacement:** create a new version and new attributable events/relationships as required. Never overwrite the frozen version or rewrite a historical manifest.

A provisional intake may be abandoned or expire only under an approved operational/records policy. It must not be represented as a registered evidence version or as part of a complete manifest. No provisional expiry duration is set here.

## 4. Transaction boundaries: atomic database outcomes versus external side effects

DD-07 requires atomic business outcomes but explicitly does not assume a distributed transaction across external services. Evidence handling therefore requires two distinct classes of boundary.

### 4.1 Atomic authoritative metadata/business commit

Where an operation is represented within one authoritative transactional boundary, the following related metadata changes must commit together or not at all, as applicable:
- evidence version registration and its exact storage-generation reference after storage verification;
- custody event describing that registration;
- authorized business relationship creation;
- manifest membership/version change or freeze;
- authoritative RFI aggregate/version change where the operation changes guarded RFI state;
- business event and idempotency outcome for the logical command.

The exact subset depends on the operation. The architecture must identify the aggregate and transaction boundary; it must not imply that unrelated records or external storage/scanner operations are part of the same database transaction.

### 4.2 External storage, transfer and scanning side effects

Byte transfer, object-store writes, malware scanning, rendering, OCR and provider calls generally cannot be assumed to participate in the same database transaction as the RFI aggregate. Treat them as independently observable side effects with durable progress, unique operation identity, retry/reconciliation rules and explicit promotion gates.

A safe candidate sequence is:
- record a provisional upload intent;
- write to isolated staging/quarantine;
- verify exact stored bytes/generation and scan/validation outcome;
- atomically register the eligible immutable evidence version and custody event in the authoritative metadata boundary;
- separately create authorized business relationships and manifest entries;
- reconcile abandoned, duplicated or incomplete external objects under an approved policy.

This sequence is a design pattern, not a selected architecture. If the storage write succeeds but metadata registration fails, the object is an unregistered/quarantined orphan and is not user-accessible evidence. If metadata references a missing or unverifiable object, access and manifest use are blocked and a reconciliation incident is recorded. No compensating delete or silent repair is presumed.

## 5. Manifest membership, freeze and exact-version binding

### 5.1 Mutable working collection

Before freeze, a working collection may change only through authorized, attributable relationship operations. Each change must reference the expected collection/aggregate version. Concurrent add/remove/replace operations cannot silently overwrite one another.

### 5.2 Freeze preconditions

A freeze command must recheck at its authoritative commit boundary:
- current actor authority and appointment/scope;
- exact RFI, cycle, response/revision and purpose;
- expected aggregate and working-collection versions;
- every included relationship and exact evidence version;
- integrity and approved scan/validation eligibility for each exact version;
- access/classification constraints and any applicable hold/records restrictions;
- absence of prohibited duplicate or ambiguous manifest entries under the approved policy;
- all required business gates for the specific freeze purpose.

A file being present in storage, visible in a UI, uploaded by an authorized user, or scanned at some earlier time is not sufficient by itself.

### 5.3 Frozen manifest invariants

A successful freeze creates one immutable manifest identity/version and immutable entries. Each entry binds:
- manifest and entry identity;
- evidence item ID and exact evidence version ID;
- explicit business relationship and purpose;
- exact storage generation reference (or controlled resolution reference);
- integrity profile/result reference;
- exact scan/validation result reference and policy version;
- derivative identity/version if a derivative is intentionally included;
- source record/cycle/response version and actor/authority/time context.

The manifest representation must be independently verifiable. Its canonical ordering/serialization and any manifest-level digest are architecture/security decisions and remain open. Do not assume that a content digest alone proves manifest completeness, authorization or authenticity.

### 5.4 Post-freeze changes

A frozen manifest is never edited in place. A changed file, evidence version, relationship, purpose, recipient scope or included derivative requires a new manifest version/identity according to the approved business operation, linked to its predecessor where applicable. The prior manifest remains retrievable under current authorization and records policy.

A new manifest does not automatically supersede a prior formal issue, review clearance or Transmittal. The relevant lifecycle/authority rule must explicitly authorize the new business outcome.

## 6. Idempotency and replay contract for evidence operations

DD-07's logical-command principle applies to evidence operations, but each operation class has a distinct identity.

| Operation | Retry identity | Required replay behavior |
|---|---|---|
| Upload intent/session creation | Same upload command/session key and same immutable intent | Resolve same session; do not create duplicate logical intake |
| Chunk/part transfer | Same session plus provider/transport part identity where applicable | Duplicate part handling follows approved transfer protocol; no duplicate bytes or false completion |
| Finalize transfer | Same finalize command and exact received object generation | Return original finalized result; reject a different generation/payload under the same key |
| Scan/validation request | Same scan operation ID bound to exact version and policy profile | Return original operation result or explicit in-progress/unknown state; never apply result to another version |
| Evidence registration | Same registration command and exact version/storage generation | One evidence version and one registration/custody outcome |
| Relationship creation | Same relationship command, target and purpose | One relationship; conflicting target/purpose is rejected |
| Manifest mutation/freeze | Same command key and expected aggregate/collection version | Replay returns original manifest outcome; stale or changed payload is rejected |
| Derivative generation | Same derivative job identity, source version and transformation profile | One attributable derivative result; no source replacement |
| Orphan reconciliation | Same reconciliation operation ID and exact mismatch scope | Replays preserve one disposition record; no blind delete/recreate |

A retry using a new key to escape an unknown outcome is prohibited. A changed payload, source version, target, purpose or transformation profile is a new logical command and must use a new identity. Current authorization must be checked before disclosing any replay result. Idempotency keys and storage references are never credentials.

## 7. Race-condition catalogue and required outcomes

| Race | Required outcome |
|---|---|
| Two retries of the same upload intent | One logical intake/session; replay resolves original state |
| Same upload key reused with changed content or target | Reject key/payload conflict; do not bind new bytes to old intent |
| Upload interrupted after partial transfer | No registered evidence version or manifest eligibility |
| Storage write succeeds, metadata registration fails | Isolated orphan/quarantine record; no ordinary access; reconcile under approved policy |
| Metadata registration succeeds but storage generation is missing/unverifiable | Block retrieval and manifest freeze; raise integrity/reconciliation exception |
| Scan worker reports for an older/replaced content version | Reject stale result for the new version; retain old result against old version |
| Duplicate or delayed scan worker | Idempotent operation result; stale worker cannot overwrite newer scan/policy result |
| Replacement races manifest freeze | Compare expected versions at freeze; either freeze the exact prior eligible version or reject stale command; never silently include replacement |
| Link/unlink races freeze | Freeze must validate expected relationship-set version; no partially updated membership |
| Two manifest freezes race | One coherent authorized result under approved uniqueness/version rules; other receives stale/conflict outcome |
| Permission revoked during upload or before registration/freeze | Recheck at promotion/commit boundary; deny the protected transition; quarantine provisional object |
| RFI response changes while manifest is frozen for review | Review remains bound to the frozen response and manifest; new response requires its own governed package |
| Derivative generated from superseded source version | Derivative remains tied to that source version and cannot be silently attached to a newer manifest |
| Recovery restores object but not metadata, or vice versa | Keep inaccessible pending identity/integrity/hold reconciliation |
| Hold/disposition state changes while orphan cleanup is pending | Recheck current records/hold authority before any disposition; no automatic deletion |

No race is resolved by last-write-wins, browser state, wall-clock timestamps or worker completion order alone.

## 8. Custody and event ordering

For each consequential evidence operation, preserve attributable events sufficient to reconstruct:
- actor/service identity and authority/appointment context;
- logical command/session/operation identity;
- evidence item/version and storage generation references;
- prior and resulting state/version where applicable;
- project/party/discipline/record relationship and purpose;
- policy/profile versions used for validation, scanning or integrity;
- result, reason, timestamp and authoritative ordering/correlation reference;
- manifest identity/version and exact entry where relevant.

The business transaction and its required authoritative event/idempotency outcome must commit together where DD-07 requires atomicity. External worker/scan/transfer events must be separately recorded and correlated; a worker success must not fabricate a business commit. Failed/denied attempts may be security events under approved policy, not successful evidence custody events. Corrections append attributable events; they do not rewrite history.

## 9. Failure, recovery and orphan reconciliation

At minimum, architecture must define handling and retained evidence for:
- partial upload and interrupted transfer;
- object exists without evidence metadata;
- metadata points to missing or changed storage generation;
- duplicate provisional intake/session;
- storage write succeeded but scan or metadata registration failed;
- metadata registration succeeded but required custody/outbox event is missing;
- scan result missing, stale, indeterminate or bound to a different byte sequence;
- manifest references an unavailable, unverified or disallowed version;
- derivative without source lineage or mismatched transformation profile;
- restored backup/replica conflicts with current version, access, hold or disposition state.

Interim safe posture: block promotion, preview, download, manifest freeze and issue use for the affected item; preserve diagnostic/custody evidence; quarantine where applicable; require authorized reconciliation. A reconciliation process must not silently repair authoritative history, change a frozen manifest, or delete an orphan. Retention and disposition of provisional objects/orphans must be approved under DD-14 before any cleanup operation.

DB/Storage backup and restore require a separate approved plan, verified backups, isolated rehearsal and reconciliation. No such operation is authorized here.

## 10. Test traceability requirements for DD-15

After QA imports the actual controlled AT-RFI-01–13 and 28 E2E definitions, map them to this contract without inferring their contents from IDs or counts. Additional candidate evidence-focused cases should be assigned IDs only under an approved convention.

Required coverage includes:
1. same-key replay and changed-payload conflict for upload/finalize/register/freeze;
2. partial transfer and finalize timeout;
3. object-without-metadata and metadata-without-object;
4. exact-byte digest mismatch and stale scan result;
5. scan timeout/indeterminate/failure and policy-version change;
6. replacement versus freeze and relationship mutation versus freeze;
7. two concurrent manifest freezes and stale expected collection version;
8. permission revocation at upload/promotion/freeze/retrieval boundaries;
9. frozen manifest stability after later replacement, unlink, revocation or storage migration;
10. derivative source/version/profile lineage;
11. event/custody partial failure and replay;
12. orphan recovery, restore reconciliation and hold-aware disposition.

Every test must identify requirement, controlling decision, exact spec version, actor/capability/party/project scope, operation and command identity, preconditions, injected failure/race, expected authoritative result, evidence artifact and defect/retest link. Any unresolved expected result remains **Blocked — Pending Design/Authority Decision**. No test is executed or passed by this document.

### 10.1 DD-09 / DD-10 recipient communication linkage

Recipient distribution, acknowledgement and substantive response are reviewed in [docs/132 — DD-09 / DD-10 Recipient Communication Cross-Specification Review](132_DD09_DD10_RECIPIENT_COMMUNICATION_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md). Apply the exact Transmittal/recipient snapshot and manifest version to every dispatch attempt, access event, acknowledgement and substantive submission. Keep recipient-entry, authenticated actor, represented party, request, manifest entry, response submission and provider-attempt identities distinct. Same-scope retries use DD-07 idempotency; changed package or recipient scope requires a new linked Transmittal under DEC-108. The per-recipient versus per-manifest-entry request granularity and unknown-delivery aggregate remain open; this linkage does not resolve them.

## 11. Unresolved architecture and authority decisions

| ID | Decision still required | Authority / review |
|---|---|---|
| TXE-01 | Canonical identity relationships, cardinality and permitted cross-record reuse/deduplication | Architecture, security, Document Control/records, owner |
| TXE-02 | Upload session/part identity, staging boundary and completion proof | Architecture, security, operations |
| TXE-03 | Approved integrity profile and exact byte semantics | Security, architecture, records |
| TXE-04 | Scan/validation state model, policy freshness, rescan and exception authority | Security, owner, architecture |
| TXE-05 | Atomic metadata boundary and external side-effect/reconciliation pattern | Architecture, security, records |
| TXE-06 | Manifest canonical representation, freeze boundary and uniqueness rules | Architecture, Document Control, records, owner |
| TXE-07 | Idempotency key scope/retention and payload fingerprint rules for each operation | Architecture, security, records |
| TXE-08 | Current authorization/revocation consistency for workers, streams and retrieval | Identity/security, project/party authority |
| TXE-09 | Orphan/quarantine retention and disposition | Records/legal, security, owner |
| TXE-10 | Actual scenario inventory, ownership, synthetic environment and acceptance evidence | QA, security, records, owner |

No default values, numeric thresholds, timeouts, retention periods, providers, algorithms or permission grants are supplied.

## 12. Promotion checklist and explicit boundary

- [ ] Conceptual identities and lineage approved.
- [ ] Upload, scan, registration and relationship lifecycle approved.
- [ ] Atomic authoritative metadata outcomes distinguished from external side effects.
- [ ] Idempotency and replay behavior approved per operation.
- [ ] Manifest freeze and exact-version binding approved.
- [ ] Race and stale-worker outcomes approved.
- [ ] Custody and recovery reconciliation approved.
- [ ] DD-14 orphan/hold/retention/disposition dependencies resolved.
- [ ] Actual DD-15 scenarios imported and mapped.
- [ ] Security, architecture, records, QA and owner reviews recorded against exact versions.

This document does not authorize implementation, DB/schema/migrations/generated types, Storage layout or provider, API/UI/code, authentication/authorization/RLS/grants, scanning or rendering services, production-file access, test execution, backup/restore, merge or deployment. Any future implementation or operational testing requires a separate scoped plan, approved decisions, threat model, records/security review, approved non-production environment and synthetic data, and explicit owner authorization. DB/Storage changes additionally require verified backups, isolated restore/rehearsal and reconciliation before changes.

---

**Current disposition:** Candidate DD-07/DD-08 contract drafted; architecture/security/records/QA/owner review pending; no implementation, operational file handling, test execution, backup/restore, merge or deployment authorized.
