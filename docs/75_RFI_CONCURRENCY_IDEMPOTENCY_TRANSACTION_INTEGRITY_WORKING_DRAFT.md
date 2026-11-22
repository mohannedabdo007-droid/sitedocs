# RFI Concurrency, Idempotency and Transaction Integrity — Working Specification

**Document type:** Detailed-design working specification; non-authoritative  
**Date:** 2026-11-12  
**Status:** WORKING — FOR ARCHITECTURE / SECURITY / RECORDS / OWNER REVIEW — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Controlling governance baseline:** `governance/scan-lifecycle-design-2026-11-11`  
**Related work:** RFI-DD-07 in `docs/71_RFI_DETAILED_SPECIFICATION_BACKLOG.md`; lifecycle and authority in `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`; classification in `docs/73_RFI_CLARIFICATION_REVISION_CLASSIFICATION_WORKING_DRAFT.md`; numbering in `docs/74_RFI_OFFICIAL_NUMBERING_AND_LEGACY_RECONCILIATION_WORKING_DRAFT.md`

> This specification translates existing approved constraints into a candidate transaction contract. It does not amend DEC-104–DEC-110, approve unresolved lifecycle transitions, select a database/locking technology, or authorize implementation. All storage, isolation, idempotency retention and retry details remain subject to architecture and security review.

## 1. Purpose and core safety properties

RFI operations may be submitted more than once, executed concurrently, interrupted by network failures, or retried after an uncertain outcome. The system must preserve one authoritative result and must never create a misleading partial state.

The candidate contract aims to ensure:

1. **At-most-one committed effect per logical command:** duplicate delivery of the same valid command must not create a second official number, revision, clarification round, contribution decision, review outcome, issue or closure.
2. **Atomic business outcomes:** related state, identity, snapshot and history changes either commit together or do not commit.
3. **No lost updates:** a command based on stale state/version cannot silently overwrite a newer committed change.
4. **Stable ordering:** consequential events for one RFI/cycle/version have a defensible authoritative order.
5. **Authorization at commit time:** permissions, appointment, project/party/discipline scope and separation-of-duties rules are rechecked when the action is committed, not trusted from a prior screen load.
6. **Immutable history:** committed events and issued/submitted snapshots are not silently overwritten.
7. **Recoverable uncertainty:** a timeout after a successful commit is distinguishable from failure before commit; retry resolves the original result.
8. **Fail-closed behavior:** unresolved conflicts, missing prerequisites, uncertain identity or authorization failures block the action.

“Exactly once” is not assumed as a transport guarantee. The design instead combines unique command identity, durable idempotency outcomes, atomic state changes and safe replay so that one logical command has one committed business effect.

## 2. Terminology and command envelope

### 2.1 Logical command

A logical command is one user-intended state-changing operation, such as first formal submission, adding a clarification round, submitting a contribution, recording a review outcome, issuing a response, reopening, or creating a linked RFI.

A browser click, HTTP request, job delivery or retry is a delivery attempt; multiple attempts may represent the same logical command.

### 2.2 Candidate command envelope

Each consequential command should carry or resolve a server-validated envelope containing:

- Stable command/idempotency key.
- Authenticated actor identity and active session/authentication context.
- Command type and schema/version.
- Target RFI identity (or internal draft identity before official submission).
- Project and party scope.
- Expected aggregate/version token and, where relevant, cycle, revision, response version, assignment, contribution or review IDs.
- Canonical request payload or a server-computed payload fingerprint.
- Request creation/received timestamp as recorded by the service; client timestamps are informational only.
- Correlation/trace ID for diagnostics, separate from business identity.
- Authority/capability and appointment context resolved by the server at action time.

The client must not be trusted to supply its own actor authority, project membership, official number, current state, event sequence, approval result or canonical version.

### 2.3 Idempotency key scope

The key must uniquely identify one logical command within a documented scope, such as actor/tenant/project plus command type, subject to architecture review. It must not be so broad that unrelated commands collide or so narrow that a retry with a new connection is treated as a new action.

- The same logical action retry must reuse the same key.
- A genuinely new action must use a new key, even if the payload is identical.
- Key reuse with a different command type, target, expected version or materially different payload must be rejected as an idempotency conflict.
- A key must not be reused after a terminal outcome to initiate another action.
- The exact key format, entropy, storage period, privacy treatment and retention policy remain open.

## 3. Required processing model

The following is a candidate implementation-neutral sequence for a consequential command:

1. Authenticate the caller.
2. Parse and validate command shape and schema version.
3. Resolve the target and its current authoritative scope.
4. Resolve current capability, appointment, party/project/discipline scope and separation-of-duties constraints.
5. Resolve the idempotency key:
   - If an identical committed command exists, return its original stored outcome without repeating side effects.
   - If the same key is in progress, return a safe pending/conflict response or wait according to a bounded policy; do not execute a second copy.
   - If the same key exists with a different payload or target, reject it.
6. Verify expected aggregate/version, lifecycle preconditions and all dependent object versions.
7. Re-evaluate business guards against current authoritative records, including current assignments, review outcomes, conflict decisions, submitted/issued snapshots and any relevant revocation.
8. Execute the atomic business transition, identity allocation and immutable event/snapshot writes required for that operation.
9. Persist the idempotency outcome in the same logical commit as the business effect.
10. Commit.
11. Return the committed result, including authoritative identity/version and correlation reference.
12. Publish any separately governed downstream notification/event only from a durable post-commit record; never publish a success notification before commit.

A previous UI validation, cached state, client-side disabled button or earlier authorization check is not sufficient. All security and lifecycle guards are enforced at the authoritative service/data boundary.

## 4. Atomic transaction boundaries by operation

The exact database transaction boundaries require architecture review. The following business outcomes are required.

| Operation | Must commit atomically as one business outcome | Must not be included or inferred |
|---|---|---|
| First formal RFI submission | Validate final required fields and authority; allocate one official number; persist submitted snapshot/attachment manifest reference; create initial lifecycle event; persist idempotency outcome | No number reservation at draft/save/preview; no external Transmittal delivery |
| Return / resubmission | Authorized return/resubmission event, relevant version/snapshot references and applicable revision decision under DEC-022-B | No revision increment for unchanged controlled content; no silent overwrite |
| Clarification request/response | Clarification-round identity, request/response event, scope/blocking reference and version linkage | No new official RFI number or automatic formal revision |
| Discipline contribution | Contribution version/snapshot, assignment relationship, attributable event and aggregate/version update | No implicit concurrence or automatic issue readiness |
| Conflict disposition | Authorized decision, rationale, affected contributions, dissent preservation and event history | No majority-vote or coordinator-derived technical authority |
| Independent review outcome | Outcome bound to exact frozen response version, reviewer authority/independence evidence and event history | No carry-forward to a changed response version |
| Formal response issue and technical closure | Recheck issue authority and all gates; freeze exact response/evidence manifest; record formal issue and technical closure together; persist idempotency outcome | No partial issued-but-not-closed state; no external delivery/acknowledgement implied |
| Reopening | Authorized reopening event, new cycle identity/sequence, predecessor response/closure link and updated active-cycle reference | No deletion or mutation of prior issue/closure; no automatic transfer of approvals |
| Withdrawal/cancellation | Authorized decision, reason, scope, actor/authority, lifecycle event and final-state update | No deletion, number reuse or automatic effects on unrelated linked records |
| Linked new RFI | New draft/formal submission identity and source relationship; allocate new official number only on successful first submission | No partial mutation or closure of source RFI |
| Transmittal creation/dispatch | Separate Transmittal identity, frozen manifest/recipient snapshot and per-recipient attempt events under DEC-103/108 | Not part of RFI technical issue/closure transaction; delivery cannot roll back technical issue |

If a command spans multiple independent records, the design must explicitly state whether it is one atomic aggregate transaction or a coordinated multi-step process with durable progress and recovery. Do not claim atomicity across external services that cannot participate in the same transaction.

## 5. Aggregate versioning and stale-write prevention

### 5.1 Version model

Each RFI aggregate should expose a monotonically advancing authoritative version (or equivalent concurrency token) updated by every committed event that changes the aggregate's guarded business state.

Where an action is scoped to a subordinate object, its own version may also be required. Candidate version dimensions include:

- RFI aggregate version.
- Active cycle version.
- Formal revision and submitted snapshot version.
- Response candidate/version.
- Discipline assignment and contribution version.
- Clarification-round version.
- Review decision/version.
- Evidence manifest version.

The exact version decomposition is an architecture decision. The system must not use a display timestamp as the sole concurrency token.

### 5.2 Compare-and-commit rule

A command based on expected version V may commit only if the authoritative guarded version is still V and every dependent guard still holds at commit time.

If the current version is different:

- Reject as a stale/conflicting command or require a fresh read and explicit user reconfirmation.
- Return the current authoritative version and a safe explanation without disclosing restricted fields.
- Do not silently merge conflicting lifecycle, technical, revision, review or issue changes.
- Do not automatically replay the command against the new version unless the action is explicitly proven safe and its authority remains valid.

### 5.3 Disjoint subordinate changes

Two changes to distinct contributions may be logically independent, but must not be assumed mergeable merely because they target different rows. The aggregate's issue-readiness, conflict and review guards may depend on both. Any allowed parallelism must be explicitly specified and tested.

## 6. Race-condition catalogue and expected outcomes

| Concurrent / racing actions | Required outcome |
|---|---|
| Two first submissions for different drafts in one project | Each receives a distinct official number; allocator is concurrency-safe within approved namespace |
| Two retries of the same first submission | One official RFI identity and one committed submission; both retries resolve to the same result |
| Two different commands use the same idempotency key | One may own the key; the other is rejected as key/payload conflict |
| Same RFI submitted from two browser tabs with same expected version | At most one conflicting transition commits; the other receives stale-version response |
| Two originator edits/resubmissions race | No lost update; later command must rebase/reconfirm against the new authoritative version |
| Two coordinators assign or return the same RFI concurrently | Conflicting changes serialize or one is rejected; no last-write-wins overwrite |
| Two technical leads attempt conflicting scope/classification decisions | No silent overwrite; authorized conflict resolution is required |
| Two contributions for one assignment arrive concurrently | Distinct attributable versions/events; assignment rules determine whether both are valid; no silent replacement |
| Contribution submitted while RFI is being made Ready for Issue | Readiness transaction rechecks contribution completeness and version; cannot issue on stale incomplete state |
| Reviewer completes review while response changes | Review remains bound to reviewed version; changed candidate cannot reuse it |
| Two reviewers attempt incompatible outcomes on same review item/version | Apply explicit review assignment/decision policy; absent policy, block conflict and preserve both attempts |
| Issuer and reopening authority act concurrently | One valid transition wins under authoritative ordering; the other must be rejected/re-evaluated; no issue/closure plus stale reopening inconsistency |
| Issuer submits twice after timeout | One issue and one closure event; retry returns original issue result |
| Withdrawal/cancellation races with formal issue | Recheck eligibility and ordering; no state can be both validly issued/closed and withdrawn/cancelled through stale command |
| Linked RFI creation races with source RFI update | Linked RFI transaction must not overwrite source; relationship records the exact source version assessed |
| Permission revocation races with command | Authorization is rechecked at commit boundary; a command not yet committed cannot rely solely on a stale earlier permission check |
| Transmittal retry races with a recipient-list change | Same frozen package retry retains same Transmittal identity; changed package/recipient scope requires a new Transmittal under DEC-108 |
| Notification worker receives duplicate event | Notification side effect is deduplicated by durable event identity; source workflow is not repeated or changed |

## 7. Idempotency behavior and replay contract

### 7.1 Outcome classes

For a given key, the system should distinguish:

- **Not seen:** no command record exists; command may be processed after validation.
- **In progress:** a command claim exists but no terminal result is committed; duplicate attempts must not execute a second copy.
- **Committed success:** return the exact original committed outcome and stable identifiers.
- **Committed business rejection:** return the recorded rejection for the same command/key; do not reinterpret it as a fresh command.
- **Transient failure before commit:** no business effect exists; a safe retry may be allowed under the same key.
- **Unknown outcome:** the caller cannot establish whether commit occurred; query/retry with the same key to resolve; never generate a new key merely to escape uncertainty.
- **Key/payload conflict:** reject; preserve evidence of misuse or client defect as appropriate.

Whether validation failures are stored as terminal idempotency outcomes or may be corrected and resubmitted under a new key is a policy detail to define per command. A corrected payload is a new logical command and must not reuse a key whose payload fingerprint differs.

### 7.2 Replay response

A replay of a committed success must return the same authoritative business result, including the same RFI number, revision/cycle/response identifiers and event reference. It may include current presentation metadata separately, but must not pretend that the old command created a newer state.

A replay must not:

- allocate another number;
- append a duplicate lifecycle event;
- increment a revision or clarification round;
- create a second contribution/review/issue/closure;
- resend external notifications or Transmittals unless a separately governed retry command explicitly requests that action;
- bypass current access checks when disclosing the stored result.

### 7.3 Key retention and privacy

The key/outcome record must survive long enough to cover supported retry and recovery windows, but the exact retention period is not defined here. Retention, payload minimization, hashing, encryption, access and deletion rules require security and records approval. A key must not become a bearer credential or allow unauthorized retrieval of an RFI result.

## 8. Event ordering and append-only history

- Each RFI aggregate should have an authoritative event order or sequence so committed events can be reconstructed consistently.
- Event timestamps alone are insufficient to determine order under concurrent requests.
- Preserve actor, authority/appointment context, command identity, target/version, outcome, reason and references to exact snapshots.
- A failed or denied attempt may be retained in security/operational logs under a separately approved policy; it must not be represented as a committed lifecycle event.
- A committed event is immutable. Corrections are represented by a new authorized event that references the event being corrected; no silent edit or deletion.
- Event ordering across separate RFI aggregates is not assumed to be globally sequential.
- Reopening creates a new cycle linked to the previous cycle; prior cycle and issue history remain unchanged.
- Clarification rounds, formal revisions, contributions, response versions and Transmittals retain distinct identifiers and event sequences.

## 9. Post-commit side effects and external boundaries

The technical issue/closure transaction must not depend on successful email delivery, recipient acknowledgement, notification read status or external provider response. Those are separate records and processes under DEC-103/108/109.

Candidate pattern for later architecture review:

1. Commit authoritative business state and a durable event/outbox record together.
2. A separate worker reads the committed outbox item.
3. The worker performs the downstream notification/integration action with its own idempotency/deduplication identity.
4. Record attempts and outcomes separately.
5. Retry transient downstream failures without repeating the source business transition.
6. Preserve the original source event identity and package/recipient snapshot.

This is a design option, not a selected technology. External delivery may be at-least-once; downstream deduplication and recipient-level event semantics must be explicit. A notification failure must not roll back an already committed RFI issue, and a delivery success must not imply technical acceptance.

## 10. Failure and recovery matrix

| Failure point | Required interpretation | Recovery behavior |
|---|---|---|
| Before command validation | No business effect | Correct request/authority; submit a new logical command as appropriate |
| After idempotency claim, before business transaction | No committed business effect unless claim/outcome is durable by design | Same key safely resumes or expires through a controlled recovery rule |
| During transaction before commit | Atomic rollback/no partial business result | Retry same key after resolving transient cause |
| Commit succeeds but response is lost | Business effect exists | Same key resolves original committed result; no duplicate effect |
| Client times out while server is still processing | Outcome unknown to client | Query/retry same key; server resolves in-progress or committed result |
| Worker crashes after commit before external notification | Business effect remains committed | Durable outbox resumes downstream work |
| External provider accepts message but acknowledgement to worker is lost | External side effect may have occurred | Retry using downstream idempotency/deduplication; preserve attempt history |
| Deadlock / serialization conflict | Transaction not committed if the database confirms rollback | Bounded retry only when command remains safe and same idempotency identity is used |
| Stale version | No state change | Refresh and require explicit re-evaluation/reconfirmation |
| Authorization revoked before commit | Command denied; no protected state change | Require fresh authorization; no automatic privilege reuse |
| Partial infrastructure outage / unknown commit state | Do not guess | Resolve using authoritative command record and same key; block if unresolved |
| Backup/restore or event replay | Recovery operation only under separate approved plan | Verify DB/Storage consistency, replay boundaries, duplicate suppression and reconciliation before use |

Do not use compensating writes to disguise a partially committed authoritative action. If an external side effect cannot be rolled back, record its actual outcome and use a separately authorized corrective action.

## 11. Locking, isolation and architecture-neutral requirements

No particular database isolation level, lock type, sequence mechanism, queue, cache or distributed transaction technology is selected here.

The future architecture must demonstrate:

- Enforced uniqueness at the authoritative data boundary for official RFI numbers within the approved namespace.
- Safe serialization of conflicting transitions and allocator operations.
- Consistent lock/resource acquisition order or another deadlock-control strategy.
- Atomic state + event + snapshot/reference + idempotency outcome persistence where specified.
- No reliance on process-local mutexes or browser state for cross-instance correctness.
- No stale cache as authority for state transitions or authorization.
- Bounded, observable retry behavior with jitter/backoff where appropriate; retry policy must not turn a permanent business rejection into an infinite loop.
- Explicit handling of transaction isolation anomalies and phantom/conflicting assignment changes.
- Recovery after process restart, worker restart and network partition.
- Operational visibility for duplicate-key conflicts, stale writes, deadlocks, unresolved command outcomes and allocator contention.

Any chosen implementation must be reviewed against actual infrastructure and load patterns before approval. No numeric retry count, timeout, lock wait, throughput target or performance threshold is assumed by this document.

## 12. Security and authorization race controls

- Recheck authentication, current capability, appointment validity, project/party/discipline scope and required separation of duties at the authoritative commit boundary.
- Check that the actor is authorized for the exact action and exact RFI/cycle/version, not merely that the actor can view the RFI.
- Recheck issuer/reviewer/technical-lead appointments and revocation state; title or historical assignment alone is insufficient.
- Prevent time-of-check/time-of-use gaps between permission validation and commit.
- Do not reveal restricted current state, payload, idempotency result or existence of another party's RFI through replay, conflict or stale-version responses.
- Apply the same checks to direct service/API calls, background workers, retries, exports and linked-record resolution.
- PM read-only oversight remains read-only; concurrency mechanisms do not expand its authority.
- An idempotency key is not authorization and must never bypass current access checks.

## 13. Test and acceptance catalogue

The following are candidate scenarios to map to DEC-110. They are test-design requirements only; no tests are claimed executed.

### 13.1 Idempotency and duplicate delivery

- Same first-submission command sent repeatedly with one key yields one RFI number and one submitted event.
- Same key with changed payload, target or command type is rejected.
- New key for a genuinely new action is processed according to current state/guards.
- Commit-success/response-lost replay returns the original result.
- In-progress duplicate does not execute a second transaction.
- Unauthorized actor cannot retrieve an idempotent result by guessing or reusing a key.

### 13.2 Concurrency and stale state

- Concurrent first submissions under one project namespace cannot collide.
- Concurrent transitions against the same expected version cannot silently overwrite.
- Stale contribution/review/assignment version is rejected.
- Contribution arrival racing issue-readiness is handled deterministically.
- Review racing response mutation cannot approve a different version.
- Issue racing reopening/withdrawal/cancellation yields one coherent authorized outcome.
- Permission revocation racing a command prevents unauthorized commit.

### 13.3 Atomicity and failure injection

- Failure before commit leaves no partial number, snapshot, state or event.
- Failure after commit but before response is resolved by same-key replay.
- Issue and closure cannot be partially committed.
- Linked RFI failure does not mutate source RFI.
- Durable downstream event survives worker crash after source commit.
- Provider timeout after possible acceptance does not repeat the source action.
- Deadlock/serialization retry does not duplicate events or identities.

### 13.4 History and ordering

- Committed event sequence is stable and attributable under concurrency.
- Corrections append new events and preserve prior history.
- Revision, clarification, cycle, response and Transmittal identifiers remain distinct.
- Replay does not create duplicate audit or lifecycle events.
- Restore/replay rehearsal preserves idempotency and identity invariants.

### 13.5 Acceptance blockers

Any duplicate official RFI number, duplicate formal issue/closure, unauthorized commit, silent lost update, stale approval reuse, evidence/snapshot corruption, contradictory terminal states, or unreconciled recovery result is a release-blocking defect. A test not run, a blocked prerequisite, or an unknown outcome is not a pass.

## 14. Open decisions and architecture dependencies

1. Exact idempotency-key scope, format, entropy, payload canonicalization and retention.
2. Which command outcomes are durably recorded, including validation and business rejections.
3. Aggregate/subordinate version model and exact compare-and-commit boundary.
4. Final lifecycle transition table and all state/action preconditions (DD-01).
5. Final RFI number format, namespace, legacy baseline and uniqueness constraints (DD-06).
6. Which operations require one database transaction versus a recoverable multi-step process.
7. Event store/audit model, sequence allocation and correction-event policy.
8. Database isolation/locking/constraint design and deadlock strategy.
9. Outbox/worker/queue and downstream provider deduplication strategy, if needed.
10. Authorization revocation consistency and appointment-version checking.
11. Recovery semantics for unknown commit outcomes and prolonged outages.
12. Test ownership, environments, failure-injection tooling, evidence retention and quantitative acceptance thresholds (DD-15).
13. Operational monitoring, alert thresholds and manual intervention authority.

Where any prerequisite is unresolved, the affected operation remains **Blocked — Pending Design/Authority Decision**. Developers must not choose defaults that alter approved identity, authority, lifecycle or records behavior.

## 14.1 Evidence transaction and manifest crosswalk

The DD-07/DD-08 boundary is elaborated in [docs/131 — Evidence Transaction and Manifest Contract](131_DD07_DD08_EVIDENCE_TRANSACTION_AND_MANIFEST_CONTRACT_WORKING_DRAFT.md). It distinguishes logical upload/session identity, provisional intake, immutable evidence version, storage generation, business relationship, frozen manifest and derivative lineage. It also separates atomic authoritative metadata/business commits from external transfer, storage, scanning and rendering side effects, and records candidate idempotency, race, stale-worker and orphan-reconciliation outcomes. This crosswalk is a candidate design only; architecture, security, records, QA and owner review remain pending. It does not select transaction technology or authorize implementation.

## 15. Governance alignment and implementation boundary

This working specification is intended to remain consistent with DEC-022-A/B, DEC-104, DEC-106, DEC-107 and DEC-110, and to operationalize (without changing) the atomic issue/closure preference in DEC-106 and the non-reuse/identity rules in DEC-107.

**Design only:** no RFI workflow/state engine, allocator, idempotency store, database transaction/constraint/lock, event store/outbox/queue, API/UI/code, DB/schema/migration/generated types, Storage, auth/RLS/grants, notification/provider integration, production-data operation, live workflow test, backup/restore operation, merge or deployment is authorized. Any implementation requires a separately reviewed architecture and threat model, records/security impact assessment, migration and recovery plan where applicable, non-production rehearsal, complete verified DB and Storage backups for data changes, reconciliation and explicit owner approval.
