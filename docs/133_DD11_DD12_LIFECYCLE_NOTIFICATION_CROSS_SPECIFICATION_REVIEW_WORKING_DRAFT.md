# DD-11 / DD-12 Lifecycle and Notification Cross-Specification Review — Working Draft

**Document type:** Non-authoritative desk-review record  
**Date:** 2026-11-12  
**Status:** REVIEW FINDINGS — FOR OWNER / SPECIALIST VALIDATION — NOT GOVERNANCE APPROVAL — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Reviewed specifications:**
- `docs/79_RFI_REOPENING_WITHDRAWAL_CANCELLATION_GATE_MATRIX_WORKING_DRAFT.md` — DD-11
- `docs/80_RFI_NOTIFICATION_EVENT_CATALOGUE_WORKING_DRAFT.md` — DD-12
**Controlling governance:** DEC-049, DEC-104, DEC-105, DEC-106, DEC-108, DEC-109, DEC-110  
**Related specifications:** DD-01/02/05/07/09/10 and the approved governance baseline on `governance/scan-lifecycle-design-2026-11-11`

> This is a cross-specification consistency review of existing working drafts. It records alignment findings, risks and candidate clarifications. It does not approve unresolved triggers, recipients, priorities, channels, authority mappings or implementation mechanisms.

## 1. Review purpose and method

Review whether DD-11's lifecycle actions and DD-12's notification projections remain distinct, correctly ordered, authorization-bound, recipient-specific and historically traceable. The review checks:
- source-event authority and commit ordering;
- action authority versus notification audience;
- current-cycle versus historical-cycle identity;
- withdrawal, cancellation and reopening side effects;
- external communication versus in-app notification;
- recipient delivery, access, acknowledgement and substantive response separation;
- retry, deduplication, privacy and acceptance evidence.

The review is a document-level desk review only. It does not execute software, inspect production data or certify security controls.

## 2. Executive findings

The two drafts are directionally consistent with DEC-049 and DEC-104–110. DD-11 defines source lifecycle actions and immutable cycle history; DD-12 treats notifications as projections of committed source events and explicitly prevents notification read/dismissal from performing workflow actions.

No contradiction requiring a change to an owner-confirmed governance decision was identified in the reviewed text. The following details remain unresolved and must stay blocked:
1. exact eligible lifecycle states and authority/capability mapping for DD-11 actions;
2. exact committed event identifiers and event-to-recipient rules for DD-12;
3. distinction between an originator's withdrawal request, validation decision and final disposition notification;
4. exact notification recipients and content visibility for reopened, withdrawn and cancelled records;
5. transactional event publication/outbox and failure-reconciliation mechanism;
6. priority classification, channels, cadence, escalation, retention and templates.

## 3. Cross-specification control matrix

| Control area | DD-11 source rule | DD-12 notification rule | Review result / required treatment |
|---|---|---|---|
| Source event | Withdrawal, cancellation or reopening requires authorized decision and recorded outcome | Generate only from authoritative committed events | Aligned. A request event and a final decision event must remain distinct |
| Authority | Originator requests withdrawal; designated authority validates; technical-lead concurrence applies after substantive work begins; designated technical authority reopens | Recipient resolution and action links require current authorization; notification grants no capability | Aligned. Receiving a notice must never imply authority to decide the underlying action |
| Issue race | Withdrawal/cancellation must not defeat a successfully committed formal issue | No success notice for uncommitted/rejected command | Aligned. Issue-versus-withdrawal/cancellation winner must be resolved by source transaction before notification generation |
| Reopening | New cycle under same official RFI identity; prior response/closure immutable | Historical notification remains bound to prior cycle/version; new-cycle notice identifies the new cycle | Aligned. Never retarget old notification to the reopened cycle |
| Withdrawal | Pre-issue only; request is not final withdrawal | Request/pending decision/outcome may have distinct notifications | Aligned subject to explicit event names and audience rules; do not imply request submission equals approval |
| Cancellation | Narrow administrative disposition; not technical rejection; record retained | Informational notice only to authorized affected participants/records roles | Aligned. Content must not label cancellation as rejection, acceptance or technical outcome |
| Distribution | Prior Transmittal and recipient events remain immutable; a new issued response uses controlled distribution | Corrective external instruction requires authorized Transmittal; notification is not recall | Aligned with DEC-108. Never imply prior external copies have been revoked |
| Acknowledgement | Recipient acknowledgement remains tied to exact Transmittal/package | Notification read/open/dismissal is not acknowledgement | Aligned with DEC-103/DD-10. Keep separate event types and denominators |
| Assignment changes | Reopened cycle requires reassessment of assignments; withdrawal/cancellation may resolve work under approved rules | Former assignee receives no new actionable reminders after effective reassignment | Aligned. Preserve old notifications and stop future reminders only after authoritative reassignment commit |
| Failure/retry | DD-11 requires idempotency and conflict-race protection | DD-12 requires stable source-event/recipient/channel identity and retry history | Partially specified. Architecture must define durable event publication, reconciliation and duplicate suppression before implementation |
| Privacy | DD-11 preserves evidence and role-scoped records | DD-12 minimizes metadata and rechecks access at every boundary | Aligned as requirements; field-level disclosure matrix and security tests remain open |
| Audit | DD-11 preserves request, decision, actor, authority, cycle and history | DD-12 preserves recipient resolution, notification and channel attempts separately | Aligned. Keep source event as authority and notification as a linked projection |

## 4. Required event separation for DD-11 actions

The following is a candidate event taxonomy for review, not an approved event catalogue:

| Source event candidate | Must not be conflated with | Notification guard |
|---|---|---|
| Withdrawal request submitted | Withdrawal approved, rejected or completed | Notify only the authorized validation/decision audience and the requester as permitted; identify it as pending |
| Withdrawal validated / decision recorded | Request submission | Notify affected authorized participants only after final decision commits |
| Administrative cancellation decided | Technical rejection, closure or deletion | Use neutral administrative wording and restricted audience |
| Reopening authorized / new cycle created | Prior issue, prior closure or recipient feedback | Identify new cycle and preserve prior-cycle references |
| New assignment created in reopened cycle | Historical assignment | Action Required only for the current assignee with a current actionable task |
| Formal response issued in reopened cycle | Reopening itself or notification of reopening | Issue notification only after the authoritative issue transaction commits |
| Corrective external communication required | Notification delivery or historical Transmittal mutation | Use a new authorized linked Transmittal where required; never imply recall of copies |

The source workflow must define which events actually exist and their authoritative commit points before any event is implemented.

## 5. Specific consistency findings and candidate clarifications

### CR-133-01 — Request versus decision notification

DD-12 currently lists withdrawal request submitted, approved, rejected or otherwise resolved. Refine the eventual event catalogue into separate event types for request submission, decision, and final source disposition. A request notification must say pending and must not imply the RFI is Withdrawn.

**Required authority:** Owner; technical/process authority; Document Control.

### CR-133-02 — Commit-before-notify and issue race

DD-11 and DD-12 are consistent that only committed source events create business notifications. The architecture must prevent a notification from announcing withdrawal/cancellation if a competing formal issue committed first, and prevent a formal-issue notice from being generated for a rejected/stale issue command.

**Required reviewers:** Architecture/engineering; records; QA; owner for business outcome.

### CR-133-03 — Reopened-cycle notification identity

Every notification for a reopened cycle must carry an explicit cycle reference and, where relevant, exact response/revision version. Prior-cycle notifications remain historical and must not navigate to a mutable “latest” target.

**Required reviewers:** Owner; Document Control; architecture; QA.

### CR-133-04 — Recipient matrix after disposition

DD-11 identifies affected originator, participants and records roles in principle; DD-12 requires individual current-authorization resolution. The exact recipients for request, decision, cancellation, reopening and new-cycle assignment remain open. Avoid blanket notification to all historical participants.

**Required authority:** Owner; project/party authority; security/privacy; Document Control.

### CR-133-05 — Notification read state versus task state

Keep notification read/open/dismiss state independent from withdrawal validation, cancellation decision, technical reopening, assignment completion, recipient acknowledgement and substantive response. A read notification must not satisfy any of these obligations.

**Review result:** Aligned; preserve as an explicit negative acceptance test.

### CR-133-06 — External recipient correction and recall boundary

A notification may alert an authorized internal user to a source event. Any corrective instruction to external recipients must follow the authorized communication/Transmittal process. Do not edit a historical Transmittal, reset its delivery/acknowledgement history or claim to revoke downloaded/printed/forwarded copies.

**Review result:** Aligned with DEC-108; external correction wording and recipient authority remain open.

### CR-133-07 — Durable publication, retry and recovery

DD-12 describes deduplication and retry but does not select an outbox, queue, provider or reconciliation strategy. DD-07's transaction and idempotency design must establish how a committed source event is durably discoverable after notification-processing failure without duplicate notifications or a false source-workflow rollback.

**Required reviewers:** Architecture/engineering; security; operations; records.

### CR-133-08 — Priority and escalation remain unassigned

No RFI Critical map, urgent classification, reminder cadence, quiet hours, escalation threshold or escalation recipient is approved. WIR-specific priority rules cannot be imported by analogy. Escalation can increase visibility only and cannot transfer authority or change assignment.

**Required authority:** Owner; safety/quality/technical authority; project operations.

### CR-133-09 — Privacy and hidden metadata

Apply authorization not only to notification body and source link but also to badge counts, grouping, search, facets, recipient counts, delivery outcomes, previews and operational error messages. The field-level disclosure matrix remains a security/privacy review item.

**Required reviewers:** Security/privacy; architecture; QA; owner.

## 6. Candidate acceptance scenarios to map into DD-15

1. A withdrawal request creates no final Withdrawn notification until the authorized decision commits.
2. A withdrawal request that loses a race to formal issue is not reported as successful withdrawal.
3. Administrative cancellation is not presented as technical rejection, closure or deletion.
4. Reopening creates a new-cycle notification under the same RFI identity while prior-cycle notifications retain their exact version references.
5. A former assignee receives no new actionable reminder after a committed reassignment; prior history remains visible only within authorized scope.
6. A notification read/open/dismiss event cannot approve, validate, cancel, reopen, close, acknowledge or submit a substantive response.
7. A notification-processing failure after source commit can be reconciled without duplicate business events or a false workflow rollback.
8. A provider timeout after successful delivery does not create a duplicate notification or an unsupported delivery claim.
9. Restricted draft, discipline, recipient or attachment metadata does not leak through counts, previews, grouping or search.
10. External corrective communication preserves the prior Transmittal and recipient history and does not claim recall of uncontrolled copies.
11. A historical notification cannot silently navigate to a later RFI cycle or response version.
12. Critical/urgent handling, if later approved, is not delayed by informational batching; no priority is inferred before approval.

These are proposed test-design cases only. They have not been executed and require mapping to approved requirements, actors/capabilities, expected outcomes and evidence under DEC-110/DD-15.

## 7. Open decisions and review ownership

| Decision / evidence needed | Required authority / reviewers |
|---|---|
| Final DD-11 eligible states, action authority and delegation | Owner; technical authority; records/Document Control; security |
| Exact DD-12 event IDs, commit points and event versioning | Owner; architecture; process authority; QA |
| Per-event recipient matrix and field visibility | Owner; project/party authority; security/privacy |
| Withdrawal request/decision wording and notification audiences | Owner; technical authority; Document Control |
| Reopening cycle identifier and notification references | Owner; architecture; Document Control |
| Priority/criticality, reminder and escalation policy | Owner; safety/quality/technical authority; project operations |
| In-app/email/channel applicability and external communication boundaries | Owner; security/identity; communication/contract authority |
| Transactional publication, retry, idempotency and provider reconciliation | Architecture/engineering; operations; security; records |
| Notification retention, archive, export and legal hold | Records authority; legal/compliance as applicable |
| Test owners, synthetic data, evidence and release gates | QA; security; records; architecture; owner |

Unresolved items remain **Blocked — Pending Authority Decision / Prerequisite**. No default values are introduced by this review.

## 8. Disposition

- DD-11 and DD-12 are **consistent at the policy-boundary level** in the reviewed material.
- CR-133-01 through CR-133-09 are review findings and candidate clarifications, not owner decisions.
- Update DD-11/DD-12 only after the relevant authority accepts a specific clarification; preserve the original drafts and decision traceability.
- Reconcile these findings into DD-15 test design only after the expected behavior and authority are approved.
- No new governance DEC is created by this desk review.

## 9. Explicit non-authorization

This review authorizes no notification schema, event bus/outbox, scheduler, provider, email/SMS/push integration, API/UI/code, database/schema/migration/generated types, Storage, authentication/authorization/RLS/grants, production-data operation, live test, backup/restore operation, merge or deployment. A separate implementation plan, security/privacy/records review, test plan, non-production rehearsal and explicit owner authorization remain mandatory.
