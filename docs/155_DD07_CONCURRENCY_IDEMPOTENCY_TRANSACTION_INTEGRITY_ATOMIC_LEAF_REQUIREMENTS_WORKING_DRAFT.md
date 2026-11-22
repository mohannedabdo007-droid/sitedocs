# DD-07 — Concurrency, Idempotency and Transaction Integrity: Atomic Leaf Requirements

**Document type:** Governance and transaction-contract traceability decomposition — working draft  
**Date:** 2026-11-13  
**Status:** WORKING DRAFT — CANDIDATE LEAVES — ARCHITECTURE / SECURITY / RECORDS / OWNER REVIEW PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent specification:** `docs/75_RFI_CONCURRENCY_IDEMPOTENCY_TRANSACTION_INTEGRITY_WORKING_DRAFT.md`  
**Evidence integration contract:** `docs/131_DD07_DD08_EVIDENCE_TRANSACTION_AND_MANIFEST_CONTRACT_WORKING_DRAFT.md`  
**Related work:** DD-01 docs/148; DD-02 docs/149; DD-03 docs/150; DD-04 docs/152; DD-05 docs/153; DD-06 docs/154  
**Controlling decisions:** DEC-104–DEC-110 and applicable DEC-021/022/051/053/107/108

> This decomposition is architecture-neutral. It does not select a database, lock strategy, queue, storage provider, digest algorithm, key format, retention duration or distributed-transaction technology. It authorizes no code, schema, DB/Storage, auth/RLS, test execution or production operation.

## 1. Core safety model

A logical command may have multiple delivery attempts. The design must preserve one authoritative business effect through stable command identity, durable idempotency outcome, current authorization, compare-and-commit, atomic business boundaries, immutable history and recoverable uncertainty. “Exactly once” transport is not assumed.

## 2. Atomic leaf requirements

### A. Command identity and trust boundary

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-TXN-L001 | Each consequential state-changing user intent shall be represented by a stable logical command identity distinct from its network/browser delivery attempts. | Command identity and attempt correlation. | DD-07 §§2,7 |
| RFI-TXN-L002 | A command envelope shall resolve authenticated actor, command type/version, target identity, project/party scope and expected authoritative version. | Server-validated command context. | DD-07 §2.2 |
| RFI-TXN-L003 | Actor authority, appointment, capability and project/party/discipline scope shall be resolved by the authoritative service at action time and rechecked at commit. | Commit-bound authorization evidence. | DD-02; DD-07 §3 |
| RFI-TXN-L004 | Client-supplied actor authority, project membership, official number, current state, event sequence or approval result shall not be trusted as authoritative input. | Negative authorization/input validation. | DD-07 §§2–3 |
| RFI-TXN-L005 | A command identity shall be bound to command type, target, expected version and canonical payload or server-computed fingerprint. | Key/payload binding record. | DD-07 §2.3 |

### B. Idempotency and replay

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-TXN-L006 | A retry of the same logical command shall reuse the same idempotency identity and resolve the original committed outcome without repeating its business effect. | Durable replay result and one-effect evidence. | DD-07 §§2.3,7 |
| RFI-TXN-L007 | Reuse of one key with a different command type, target, expected version or materially different payload shall be rejected as an idempotency conflict. | Key/payload mismatch negative case. | DD-07 §2.3 |
| RFI-TXN-L008 | A genuinely new user-intended action shall use a new logical command identity even when its payload matches an earlier command. | Distinct command evidence. | DD-07 §2.3 |
| RFI-TXN-L009 | A terminal idempotency key shall not be reused to initiate a different action. | Terminal-key protection. | DD-07 §2.3 |
| RFI-TXN-L010 | In-progress, committed, failed-before-commit and unknown outcomes shall remain distinguishable; duplicate delivery shall not execute a second concurrent copy. | Durable command outcome model; exact vocabulary remains open. | DD-07 §§3,7 |
| RFI-TXN-L011 | A timeout after successful commit shall be resolved to the original authoritative result rather than treated as permission to create a second effect. | Timeout-after-commit recovery evidence. | DD-07 §§1,7 |
| RFI-TXN-L012 | Current authorization shall be checked before a replay result or restricted command outcome is disclosed. | Replay authorization and privacy-negative evidence. | DD-02; DD-07 |

### C. Compare-and-commit and concurrency

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-TXN-L013 | Every consequential command shall carry or resolve the expected authoritative aggregate/version token and all relevant subordinate versions. | Version-bound command record. | DD-07 §5 |
| RFI-TXN-L014 | A command based on a stale aggregate or dependent-object version shall not silently overwrite a newer committed state. | Stale-write rejection or explicit reconfirmation. | DD-07 §5.2 |
| RFI-TXN-L015 | A stale command shall not be automatically replayed against a newer version unless the action is explicitly proven safe and all authority/business guards are revalidated. | Rebase policy and evidence; default fail closed. | DD-07 §5.2 |
| RFI-TXN-L016 | Disjoint subordinate-record changes shall not be presumed mergeable when aggregate readiness, conflict, review or issue gates depend on both. | Dependency-aware concurrency review. | DD-07 §5.3 |
| RFI-TXN-L017 | Consequential events for one RFI/cycle/version shall have a defensible authoritative ordering that prevents contradictory terminal outcomes. | Ordering and race-resolution evidence. | DD-07 §§1,6 |
| RFI-TXN-L018 | Conflicting concurrent lifecycle, classification, assignment, contribution, review, issue, withdrawal or reopening commands shall not resolve through silent last-write-wins behavior. | Race catalogue and explicit conflict outcome. | DD-07 §6; DD-01/DD-05 |

### D. Atomic business outcomes and immutable history

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-TXN-L019 | Official number allocation and successful first formal submission shall form one logical atomic business outcome. | Single committed identity/submission result. | DD-06; DEC-022-A |
| RFI-TXN-L020 | Clarification-round identity, request/response event, blocker scope and version linkage shall commit as one coherent outcome without allocating a new official number. | Atomic clarification lineage. | DD-05; DD-07 §4 |
| RFI-TXN-L021 | A discipline contribution version, assignment relationship, attributable event and relevant aggregate/version update shall commit coherently. | Contribution transaction evidence. | DD-03; DD-07 §4 |
| RFI-TXN-L022 | Conflict disposition, rationale, affected contributions, dissent preservation and event history shall commit as one coherent authorized outcome. | Conflict-decision integrity evidence. | DD-03; DD-07 §4 |
| RFI-TXN-L023 | Independent review outcome shall be bound to the exact frozen response/evidence version and current reviewer authority. | Exact-version review transaction. | DD-04; DD-07 §4 |
| RFI-TXN-L024 | Formal response issue and technical closure shall commit as the indivisible business outcome required by the approved lifecycle decision. | No partial issued-but-not-closed outcome. | DISP-OR01-010; DD-01 |
| RFI-TXN-L025 | Reopening shall preserve predecessor issue/closure and establish a distinct new cycle without transferring prior approvals automatically. | Predecessor/successor cycle lineage. | DD-01; DD-11 |
| RFI-TXN-L026 | Linked-new-RFI creation/submission shall preserve source-RFI state and relationship integrity if the new submission fails or is retried. | No partial source mutation; DD-05/DD-06 linkage. | DD-05/DD-06 |
| RFI-TXN-L027 | Committed snapshots and events shall not be silently overwritten; corrections and successor versions shall preserve predecessor history. | Append-only semantic history and audit. | DEC-107; DD-07 §1 |

### E. Evidence and external side-effect boundary

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-TXN-L028 | A business transaction shall reference only an evidence version whose identity, integrity, storage generation and policy eligibility have been verified for the intended purpose. | Evidence-version eligibility proof. | DD-08; docs/131 §1 |
| RFI-TXN-L029 | Evidence transfer, scanning, rendering and external provider operations shall remain distinct from authoritative RFI business commits unless a specific architecture proves a shared transaction boundary. | Explicit side-effect/transaction boundary. | docs/131 §4 |
| RFI-TXN-L030 | A storage write without authoritative metadata registration shall remain an isolated unregistered/quarantined object and shall not become ordinary user-accessible evidence. | Orphan/quarantine reconciliation record. | docs/131 §4.2 |
| RFI-TXN-L031 | A metadata reference to missing or unverifiable storage content shall block retrieval and manifest use and create a reconciliation incident. | Integrity failure and fail-closed behavior. | docs/131 §§4–5 |
| RFI-TXN-L032 | Frozen manifest identity and entries shall bind exact evidence item/version, relationship, purpose and integrity/scan evidence; post-freeze change shall not edit the predecessor manifest. | Immutable manifest and successor lineage. | docs/131 §5; DD-08 |
| RFI-TXN-L033 | Downstream notifications or external side effects shall be initiated only from durable post-commit records and shall not be published as success before the authoritative business commit. | Post-commit publication and replay evidence. | DD-07 §3; DD-12 |
| RFI-TXN-L034 | External Transmittal delivery and recipient acknowledgement shall remain separate from technical issue/closure and shall not roll back or mutate the technical business outcome. | Separate communication identity and state. | DEC-103/108; DD-07 §4 |

### F. Recovery, observability and acceptance boundary

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-TXN-L035 | Every consequential command shall retain sufficient actor, authority, target, expected/current version, outcome, timestamp and correlation evidence for reconstruction without exposing restricted data. | Privacy-safe audit reconstruction. | DD-02; DD-07 §§2,9 |
| RFI-TXN-L036 | Recovery shall distinguish failure before commit, commit success with lost response, partial external side effect and inconsistent metadata/storage state. | Failure-state catalogue and reconciliation plan. | DD-07 §§7–10; docs/131 |
| RFI-TXN-L037 | Recovery or replay shall not silently delete, duplicate, rewrite or reassign authoritative business/evidence history. | Reconciliation evidence and controlled exception path. | DD-07; DD-08/DD-14 |
| RFI-TXN-L038 | Any implementation test shall exercise positive, negative, boundary, concurrency, retry, timeout-after-commit, stale-version and recovery outcomes using approved isolated synthetic fixtures. | QA-approved scenarios, environment and retained evidence. | DEC-110; DD-15 |
| RFI-TXN-L039 | Architecture shall explicitly approve transaction boundaries, aggregate/version model, idempotency scope/retention, locking/ordering, external side effects and recovery mechanics before implementation. | Architecture decision record and owner approval. | DD-07; docs/131 |
| RFI-TXN-L040 | DB/Storage changes or recovery rehearsals shall require a separate approved plan, verified backups, isolated restore/rehearsal and reconciliation before any change. | Backup/restore and rehearsal evidence; explicit owner authorization. | Project safety gate; DD-14 |

## 3. Open architecture and governance dependencies

- Database/transaction technology and authoritative data boundary.
- Aggregate and subordinate version decomposition.
- Idempotency-key format, scope, entropy, storage and retention.
- Locking, ordering, isolation and stale-command response strategy.
- Atomic boundaries for each business operation.
- Durable publication/outbox or equivalent architecture and retry policy.
- Storage/scanning/derivative provider behavior and orphan reconciliation.
- Manifest canonicalization/integrity profile and evidence custody.
- Recovery/compensation policy, including what must never be automatically deleted.
- QA-approved expected outcomes, synthetic fixtures, test owners and retained evidence.
- Records/privacy/security review and owner approval.

No technology, duration, numeric retry count, timeout, SLA or implementation mechanism is selected by these leaves.

## 4. DD-15 candidate mapping instructions

Map each leaf only to exact controlled AT-RFI/E2E source definitions that exercise the behavior. Process/architecture approval evidence is not a passed product test. Mark uncovered where the inventory has no genuine scenario. Do not invent test IDs, fixtures, owners, expected results or test outcomes. Any future execution requires approved isolated synthetic data/environment, security/records controls and recorded evidence under DEC-110.

## 5. Implementation boundary

No API/UI/code, database/schema/migration/generated types, Storage, auth/RLS/grants, queue/provider, production-data operation, live workflow test, backup/restore, merge, deployment or release is authorized. DB/Storage work requires verified backups and isolated restore/rehearsal with reconciliation and explicit owner approval.

**Current disposition:** 40 candidate leaves prepared. Architecture, security, records, QA and owner validation remain pending. No test execution/pass, architecture selection, implementation readiness or authorization is claimed.
