# OR-01 / DISP-OR01-002 — Draft, Formal Submission and Official Identity Consistency Review

**Document type:** Governance-consistency review memorandum  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — CONSISTENCY REVIEW ONLY — NO NEW POLICY DISPOSITION — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Source detailed specification:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`, §§3.1–3.4 and numbering/evidence references  
**Controlling governance:** DEC-107; DEC-022-A/B where a later content change is classified

> This memorandum checks consistency with an already confirmed governance boundary. It does not reopen, amend, reinterpret or replace DEC-107, and it does not create a new numbering policy or authorize implementation.

## 1. Purpose and scope

DISP-OR01-002 is explicitly a **consistency check**, not a new owner policy decision. Its narrow question is whether the lifecycle draft's handling of draft creation, abandonment, formal submission and the first official lifecycle state is consistent with the protected DEC-107 numbering and identity boundary.

The review covers:
- separation of an unsubmitted draft from an official RFI;
- distinction between a submission attempt and a successful formal submission;
- the point at which official identity and number are allocated;
- preservation of submission evidence and history;
- consistency of the first official lifecycle state with the administrative intake stage.

It does not decide the official number's display format, uniqueness namespace, legacy reconciliation, allocator design, transaction technology, retention duration, draft deletion policy or implementation details.

## 2. Controlling DEC-107 constraints — preserved unchanged

For this review, the following are fixed constraints and are not open questions:

1. A draft does not consume an official RFI number.
2. A preview, incomplete form, save, failed validation, failed submission attempt or abandoned draft does not consume an official RFI number.
3. The official number is allocated only on the first successful formal submission.
4. The official number is not reused after withdrawal, cancellation or other later disposition.
5. The official RFI identity remains stable across the governed lifecycle; revision, clarification round, contribution, response version and Transmittal remain distinct identities.
6. The successful formal-submission boundary must preserve the required submission evidence and immutable version/snapshot principles.
7. Number allocation must be concurrency-safe and tied to the successful formal submission outcome; no reservation or allocator implementation is authorized by this review.

No item above is proposed for change. Any future proposal to alter these constraints must use the formal governance amendment route, not this OR-01 consistency item.

## 3. Source model examined

The current lifecycle working draft states:
- **Draft:** unsubmitted originating-party working record; no official RFI number.
- **Abandoned Draft:** unsubmitted draft no longer pursued; no official number consumed.
- **Submitted:** successful formal submission and official RFI identity allocation, subject to required fields, current originator capability, scope and snapshot checks succeeding atomically.
- **Submitted → Under Coordination:** appointed coordinator accepts the official RFI into administrative intake/routing.
- A failed initial submission must not be represented as **Returned for Completion**; that state is reserved for a successfully submitted official RFI returned for a separately defined post-submission deficiency.

The source model is consistent in principle with DEC-107. The wording and event/state distinction below should be made explicit in any later approved specification.

## 4. Consistency findings

### 4.1 Draft is not an official RFI

**Finding:** Consistent.

Draft creation, editing, saving, previewing and draft abandonment occur before official RFI identity allocation. They must not produce an official RFI number or appear as official RFI lifecycle records to parties who are not authorized to see the draft.

Draft access and oversight visibility remain governed by the applicable draft authorization rules. The existence of an authorized oversight view does not turn a draft into a formally submitted RFI.

**Technical recommendation:** Retain Draft as a separate pre-submission draft-record condition, outside the official numbered RFI lifecycle. Retain Abandoned Draft as a separate draft-record disposition. This aligns with the recommendation in docs/89 but does not itself approve that vocabulary decision.

### 4.2 Submission attempt is not successful formal submission

**Finding:** Consistent, provided the specification distinguishes attempt, validation and success.

A user action labelled “Submit” is only an attempted command. It must not by itself:
- allocate or reserve the official number;
- create an official submitted lifecycle record;
- freeze an authoritative submitted snapshot;
- trigger official routing or recipient distribution.

A failed attempt must remain distinguishable from a successful submission, with a safe retry path and no duplicate official identity. A preview or validation response must not be represented as a completed submission.

**Technical recommendation:** Define “successful formal submission” as the single business boundary at which all mandatory submission validations and current authorization/scope checks have succeeded, the required evidence snapshot is accepted, and the official identity/number is allocated as part of that successful outcome. The exact transactional mechanism is outside this review.

### 4.3 Official number allocation and submitted snapshot

**Finding:** Consistent with DEC-107.

The lifecycle draft correctly places official identity allocation at successful formal submission, not at draft creation or the beginning of a submission attempt. The submitted snapshot must identify the content and evidence that were actually submitted; later changes must not silently rewrite that historical submission.

**Technical recommendation:** Treat the formal-submission success record as the authoritative boundary linking:
- the stable official RFI identity/number;
- the accepted submitted content/version;
- the evidence manifest/snapshot required by DEC-107;
- the submitting party/originator and applicable project/scope;
- the authoritative submission event/time.

This list describes traceability requirements, not a database schema or field mandate.

### 4.4 First persistent official lifecycle state

**Finding:** The source vocabulary is understandable but has a modelling choice that must be made explicit.

Two interpretations are possible without changing DEC-107:

- **Option A — Submitted is a persistent parent state:** successful formal submission creates the official RFI in Submitted; a separate authorized coordinator acceptance transitions it to Under Coordination.
- **Option B — Submitted is the formal submission event, not a persistent state:** successful formal submission creates the official RFI and records a Submitted event; the first persistent post-submission state is Under Coordination once the administrative intake acceptance is recorded.

**Technical recommendation:** Prefer Option A for the current candidate vocabulary because it preserves a visible, auditable interval between successful submission and coordinator intake acceptance. It makes unaccepted intake work visible without inventing a new state. Option B can also be coherent if the owner prefers event-plus-state modelling, but the event, timestamp, responsible authority and intake queue must remain auditable and must not hide work between submission and coordination.

This is a design choice about representation after the fixed DEC-107 event; it does not change when the number is allocated.

### 4.5 Returned for Completion is post-submission only

**Finding:** Consistent if its gate is enforced.

A failed first submission is not a Returned for Completion RFI because no official RFI identity was successfully created. Returned for Completion can only apply after successful formal submission and only for a separately approved post-submission deficiency/return reason. It must preserve the official number and earlier submitted snapshot.

Any changed content must be classified under DEC-022-A/B where applicable; a return does not silently create a new official RFI identity or authorize overwriting the original submission.

**Technical recommendation:** Add an explicit negative rule to the lifecycle specification: failed pre-submission validation/attempts cannot enter Returned for Completion.

## 5. Recommended business-level sequence

The following sequence is illustrative and design-only:

1. Authorized originator creates a private/permitted draft record.
2. Draft may be saved, edited or previewed without an official number.
3. Originator initiates a formal submission attempt.
4. Required submission, authorization, project/party scope and evidence checks are evaluated.
5. If any mandatory check fails, the attempt fails; no official number is consumed and no official Submitted lifecycle state is created.
6. If all checks succeed, the first successful formal submission is recorded, the official number/identity is allocated under DEC-107, and the accepted submission evidence snapshot is preserved as one successful business outcome.
7. The official RFI is represented as Submitted (if Option A is selected) pending appointed coordinator intake acceptance.
8. The appointed coordinator records administrative intake acceptance, transitioning it to Under Coordination.
9. Any later post-submission return uses Returned for Completion only under its separately approved eligibility/reason rules; it preserves the official identity and prior submission evidence.

This sequence does not prescribe an API, database transaction, sequence generator, event bus, queue, retry implementation or user-interface behavior.

## 6. Negative consistency cases that the detailed design must guard against

| Scenario | Required business outcome under DEC-107 | Prohibited interpretation |
|---|---|---|
| Draft saved repeatedly | Remains a draft; no official number | Save creates an official RFI |
| Draft previewed/exported | Remains a draft; no official number | Preview reserves a number |
| Mandatory field missing | Formal submission fails; no number | Create Submitted or Returned for Completion |
| Originator lacks current submission authority | Submission fails; no number | Allocate number then reject authorization |
| Project/party/scope validation fails | Submission fails; no number | Treat as official submission pending correction |
| Evidence snapshot cannot be accepted | Submission fails; no official identity/number | Create official RFI with incomplete authoritative evidence |
| Submission attempt times out before outcome is known | Outcome must be reconciled safely; no duplicate identity | Blind retry creates another RFI/number |
| Concurrent repeated submission command | At most one official identity for the same accepted submission operation, with governed idempotency | Duplicate official numbers or duplicate RFI identities |
| Successful submission followed by coordinator delay | Official RFI remains auditable as Submitted if Option A is chosen | Pretend it was never submitted or allocate another number |
| Successful submission later returned for completion | Preserve number and prior submitted snapshot | Treat it as a failed initial submission or recycle its number |
| Abandoned draft | Draft disposition only; no official number | Treat as official Withdrawn or Cancelled |
| Official RFI later withdrawn/cancelled | Preserve official number and history; no reuse | Release/recycle the number |

These are required design/test scenarios to trace later; they have not been executed or passed.

## 7. Required wording clarification for future specification reconciliation

If and only if the relevant owner vocabulary decision is made and the detailed specification is later reconciled, the following clarifications are recommended:

- Replace ambiguous references to “Submit” with “successful formal submission” when describing the official identity boundary.
- State explicitly that draft save, preview, incomplete validation and failed submission attempts do not allocate or reserve official numbers.
- State that the Submitted candidate state, if retained, begins only after successful formal submission; it is not an in-progress command state.
- State whether Submitted is a persistent parent state (Option A) or a submission event followed by the first persistent state Under Coordination (Option B).
- State that Returned for Completion is post-submission only and cannot be used for a failed initial submission.
- Preserve the distinction between RFI number, revision, clarification round, contribution, response version and Transmittal.

No edit to docs/72 is made in this review because no owner disposition has been recorded for the dependent vocabulary/state model.

## 8. Specialist validation requested

| Domain | Narrow validation question | Evidence required |
|---|---|---|
| Document Control | Does the proposed evidence trail distinguish draft, formal submission, intake acceptance and post-submission return in the official register? | Written process review and record examples |
| Architecture | Can the chosen model guarantee one successful official identity allocation with no duplicate outcome under retries/concurrency? | Design review and transaction/idempotency analysis; no implementation implied |
| Security | Are originator capability, project/party scope and evidence access checked at the successful submission boundary and independently for later access? | Authorization review and negative-case matrix |
| Records / information governance | Are draft records and official submitted records distinguished for visibility, preservation and eventual disposition without inventing retention periods? | Records classification and applicable schedule/authority reference |

These are requested review domains, not named appointments. A reviewer title or participation does not by itself confer decision authority.

## 9. Disposition status

| Item | Result |
|---|---|
| DEC-107 consistency | **No conflict identified in the reviewed source wording, subject to the clarifications in this memo** |
| DEC-107 amendment | **None proposed; not reopened** |
| Draft lifecycle vocabulary | Remains subject to DISP-OR01-001 owner disposition |
| Submitted representation | Option A recommended; Option B remains an owner choice |
| Specialist validation | Pending |
| Owner disposition | **Not required for this consistency-only check; no new policy disposition recorded** |
| Implementation/test authorization | None |

This memo records a document-level consistency finding only. It is not a formal specialist sign-off, owner approval, operational acceptance or proof of system behavior.

## 10. Explicit exclusions

No number allocator, reservation, migration, database/schema/API/UI/code, Storage, authentication, authorization/RLS/grants, production data, live test, backup/restore, merge, deployment or release is created, changed or authorized by this memorandum.

---
**End of consistency review memorandum — DEC-107 preserved; no new policy disposition.**
