# DD-12 Notification Governance Leaf Requirements — Working Draft

**Document type:** Atomic governance-requirement decomposition and candidate test traceability  
**Date:** 2026-11-12  
**Status:** INITIAL LEAF BASELINE — QA / OWNER / SPECIALIST VALIDATION PENDING — NO TEST EXECUTION — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Primary sources:** DEC-049; DEC-104 ODM-21; DEC-105; DEC-108; DEC-109; DEC-110  
**Detailed specification:** `docs/80_RFI_NOTIFICATION_EVENT_CATALOGUE_WORKING_DRAFT.md`  
**Cross-specification reviews:** `docs/133_DD11_DD12_LIFECYCLE_NOTIFICATION_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md`; `docs/143_DD12_NOTIFICATION_FRAMEWORK_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md`  
**DD-15 inputs:** `docs/137_DD15_CONTROLLED_AT_RFI_AND_E2E_TEST_INVENTORY_WORKING_DRAFT.md`; `docs/138_DD15_AT_RFI_E2E_CANDIDATE_REQUIREMENT_TRACEABILITY_MATRIX_WORKING_DRAFT.md`; `docs/139_DD15_APPROVED_GOVERNANCE_REQUIREMENT_COVERAGE_BASELINE_WORKING_DRAFT.md`; `docs/140_DD15_DEC103_DEC108_RECIPIENT_COMMUNICATION_LEAF_REQUIREMENTS_WORKING_DRAFT.md`

> This document decomposes already approved governance constraints into traceability leaves. IDs below are test/traceability references only, not new governance decisions. Candidate mappings do not establish test completeness, approved implementation details or execution readiness.

## 1. Purpose and method

The existing DD-15 material contains a 39-row governance coverage baseline and a 25-row DEC-103/DEC-108 recipient-communication leaf matrix. Neither is a notification-specific leaf baseline. This document fills that traceability gap for the notification requirements in DEC-049 and the RFI notification direction in DEC-104 ODM-21 / DEC-109, while retaining the source scenario IDs and their exact definitions.

Each row records:
- a single independently verifiable governance invariant;
- its exact authority source;
- the relevant DD-12/DD-15 location;
- candidate source scenarios, where a real imported scenario addresses the behavior;
- coverage status; and
- the boundary between approved expected behavior and unresolved design detail.

Coverage labels:
- **Direct candidate:** an imported scenario explicitly addresses the principal behavior, but still needs atomic assertions and QA validation.
- **Partial:** the scenario touches the behavior but does not explicitly test the complete leaf.
- **Uncovered:** no imported scenario explicitly verifies the leaf as stated.
- **Blocked:** expected behavior depends on an unresolved authority, project rule or technical prerequisite.

## 2. Notification leaf requirements

| Leaf ID | Atomic requirement / invariant | Approved authority | Detailed-design location | Candidate source scenario | Coverage | Expected-result authority / blocker |
|---|---|---|---|---|---|---|
| RFI-NTF-L001 | An RFI business notification is generated only from an authoritative committed source-workflow event; an attempted, rejected, stale or uncommitted command must not be represented as a successful business event. | DEC-049 items 1–2; DEC-104–106 | docs/80 §§2,4,18; docs/143 NTF-01/07 | E2E-23/24; E2E-28 | Partial | Commit-before-notify invariant is approved; exact RFI event IDs, source record and commit point remain open. |
| RFI-NTF-L002 | Notification presentation/retrieval remains a central framework concern and does not merge RFI with WIR or other module workflows. | DEC-049 decision and item 1 | docs/80 §§1–2,18 | No explicit scenario | Uncovered | Separation is approved; module-specific event and recipient catalogues remain separate. |
| RFI-NTF-L003 | Each notification identifies its event, record class/reference, authorized context, priority, timestamp, recipient and expected action where applicable, limited to information that recipient may see. | DEC-049 item 4 | docs/80 §§3,7,15 | E2E-28; AT-RFI-04 | Partial | Required content dimensions and least disclosure are approved; field-level content matrix and exact templates remain open. |
| RFI-NTF-L004 | Recipient eligibility is resolved individually from current authorized project assignment, party, discipline, responsibility, workflow step, visibility and capability; membership or historical assignment alone is insufficient. | DEC-049 item 5; DEC-104 ODM-21; DEC-105; DEC-109 | docs/80 §6; docs/143 NTF-03/04 | AT-RFI-04; E2E-15; E2E-28 | Partial | Current authorization is approved; event × recipient-class entitlement matrix and evidence model remain open. |
| RFI-NTF-L005 | Server-side authorization is rechecked for notification lists, counts/facets, opening, navigation, previews, downloads and linked actions; a notification or deep link never bypasses revoked access. | DEC-049 item 6; DEC-109 | docs/80 §§2,6–7,13–15; docs/143 NTF-03/04/10 | AT-RFI-04; E2E-15; E2E-28 | Partial | Action-time/server-side reauthorization is approved; exact negative assertions and revocation/cache behavior require security/QA validation. |
| RFI-NTF-L006 | Read, open, dismiss or acknowledge of a notification does not complete the underlying task or approve, issue, distribute, withdraw, cancel, reopen or close an RFI. | DEC-049 item 7; DEC-104 ODM-13/21; DEC-108; DEC-109 | docs/80 §§2,5,13,16; docs/143 CR-133-05 / NTF-05 | AT-RFI-03; AT-RFI-08; E2E-28 | Partial | Non-equivalence is approved; test each prohibited source action independently rather than infer full coverage from a broad no-false-closure case. |
| RFI-NTF-L007 | Source business-event history, recipient-specific notification history, channel attempts/outcomes, read/ack state, policy/version and linked workflow resolution remain distinct and attributable. | DEC-049 item 8; DEC-103; DEC-108; DEC-109 | docs/80 §§3,9–10,15; docs/143 NTF-02/06/08 | E2E-14; E2E-17/18; E2E-28 | Partial | Separation and auditable history are approved; canonical identity relationships and channel outcome vocabulary remain open. |
| RFI-NTF-L008 | Technical retries are deduplicated without suppressing distinct business events; non-urgent informational grouping preserves every underlying event as individually retrievable. | DEC-049 item 9 | docs/80 §§10,13,15–16; docs/143 NTF-07/08 | E2E-18; E2E-28 | Partial | Deduplication and retrievability are approved; idempotency scopes, grouping identity and replay/recovery contract remain open. |
| RFI-NTF-L009 | Critical or urgent Action Required notifications are not delayed by batching or grouping of informational notifications. | DEC-049 item 9 | docs/80 §§8,10–11,16; docs/143 NTF-09 | No explicit scenario | Uncovered | Non-delay constraint is approved; no RFI-specific Critical/urgent event mapping is approved. |
| RFI-NTF-L010 | In-app notification is mandatory for governed notification events; email remains optional and preference-dependent under DEC-038; SMS, push, public links and default broadcast are not approved. | DEC-049 item 10 | docs/80 §9; docs/143 NTF-09 | No explicit scenario | Uncovered | Channel boundary is approved; email applicability/preferences and any future channel change require separate authority. |
| RFI-NTF-L011 | Reminders/escalation apply only to unresolved Action Required tasks and current authorized responsible recipients, under separately approved configurable thresholds; no fixed SLA/contractual deadline is created. | DEC-049 item 11; DEC-104 ODM-21; DEC-109 | docs/80 §§5,8,11,14; docs/143 NTF-05/09 | E2E-28 | Partial | Governing boundary is approved; task identity, thresholds, calendar, timezone, cadence and escalation audience remain open. |
| RFI-NTF-L012 | Reminder/escalation does not transfer responsibility, change assignment, grant capability or confer technical authority. | DEC-049 item 11; DEC-105; DEC-109 | docs/80 §§6,11; docs/143 NTF-05/09 | AT-RFI-04; E2E-28 | Partial | Non-authority effect is approved; explicit escalation actor/capability negative assertions remain to be designed. |
| RFI-NTF-L013 | Notification content, previews, snippets, search, filters, counts and grouped summaries do not disclose information to unauthorized recipients. | DEC-049 item 13; DEC-021; DEC-109 | docs/80 §§6–7,13–15; docs/143 NTF-04 | AT-RFI-04; E2E-15; E2E-28 | Partial | Privacy boundary is approved; field-level disclosure matrix and mixed-authority/fan-out tests remain open. |
| RFI-NTF-L014 | Project Manager oversight remains read-only and does not create authority to execute a linked RFI action or view otherwise restricted notification content. | DEC-021; DEC-049 item 13; DEC-105 | docs/80 §§6–7; docs/143 NTF-03/04 | AT-RFI-04 | Partial | Read-only PM boundary is approved; precise field and action tests require the approved capability/appointment model. |
| RFI-NTF-L015 | A notification for a historical cycle or response remains bound to its exact source event/version and is not silently redirected to the latest cycle/version. | DEC-049 items 7–8; DEC-108; DEC-109; DEC-106 | docs/80 §12; docs/133 CR-133-03; docs/143 NTF-10 | E2E-22; E2E-28 | Partial | Historical identity preservation is approved; exact source-event and response-version references remain to be specified. |
| RFI-NTF-L016 | Notification read/open/dismissal and channel delivery outcomes remain separate from Transmittal recipient delivery, access, acknowledgement and substantive response. | DEC-103; DEC-108; DEC-049 items 7–8 | docs/80 §§5,9,14–15; docs/133 CR-133-05/06; docs/143 NTF-06 | AT-RFI-08/13; E2E-14–18 | Partial | Semantic separation is approved; no notification aggregate may reuse DEC-103 Transmittal aggregate semantics without a separate decision. |
| RFI-NTF-L017 | Notification records and recipient/channel history remain subject to applicable records, retention and legal-hold controls; no default expiry deletion or retention period is inferred. | DEC-109; DEC-110; applicable records governance | docs/80 §§15,17–18; docs/82; docs/143 NTF-11 | No explicit scenario | Uncovered | Records classification, schedule, hold scope, residual copies and disposition authority remain open under DD-14. |
| RFI-NTF-L018 | Notification-processing failure or replay must not roll back a committed source workflow or create duplicate source events, recipient obligations or false delivery claims. | DEC-049 items 7–9; DEC-104; DEC-109; DEC-110 | docs/75; docs/80 §§9–10,16; docs/131; docs/143 NTF-06–08 | E2E-11; E2E-14; E2E-18; E2E-28 | Partial | Source transaction separation is approved; durable publication, reconciliation, uncertain provider outcome and retry mechanics remain architecture decisions. |

## 3. Explicit coverage gaps

The following approved governance requirements have no explicit dedicated scenario in the imported AT-RFI-01–13 / E2E-01–28 source set, or are only indirectly represented:

1. Critical/urgent Action Required must bypass informational batching.
2. Mandatory in-app versus optional/preference-dependent email and prohibited unapproved channels.
3. No notification default broadcast and no cross-module workflow merging.
4. Field-level privacy across badge counts, grouping, search/facets, snippets/previews and operational errors.
5. Reminder/escalation only for unresolved Action Required tasks and no transfer of authority.
6. Notification retention, legal hold, backup/replica/cache and residual-copy lifecycle.
7. Unknown / Unconfirmed channel outcomes and no false Delivered claim.
8. Distinct notification identity scopes for source event, recipient instance, channel attempt and grouping.
9. Notification failure after source commit, duplicate/out-of-order processing and replay/reconciliation without duplicate recipient obligations.

Do not invent new AT-RFI/E2E IDs or alter imported scenario wording. QA may propose extensions to existing cases or new controlled IDs under an approved naming/versioning convention. The need for a scenario does not approve its technical fixture or execution.

## 4. Source scenario mapping and non-inference rules

The source-preserving inventory in docs/137 is authoritative for scenario titles and exact definitions. The current candidate mapping uses only imported identifiers:

- **AT-RFI-04:** unauthorized parties cannot read drafts, attachments, responses or audit data; relevant to recipient and privacy leaves.
- **AT-RFI-08:** delivery, acknowledgement, read state, due-date expiry or draft answer does not silently close the RFI; relevant to source/action separation.
- **AT-RFI-13:** recipient aggregation and communication separation; adjacent only and not a notification-specific aggregate specification.
- **E2E-11:** issue success followed by client timeout; relevant to post-commit retry and duplicate avoidance, not a complete notification outbox test.
- **E2E-14:** delivery failure after successful technical issue/closure; distinguish Transmittal delivery from notification channel outcome.
- **E2E-15:** recipient access revoked before opening exact manifest entry; adjacent current-authorization coverage.
- **E2E-16/17:** access/acknowledgement and recipient delivery outcomes; do not treat as notification read/delivery semantics.
- **E2E-18/19:** unchanged-package retry and changed recipient/package scope; adjacent identity/retry and immutable-audience controls.
- **E2E-22:** reopening with historical acknowledgement pending; cross-cycle notification identity.
- **E2E-23/24:** withdrawal/issue race and source withdrawal after Transmittal; source-event commit and external communication separation.
- **E2E-28:** notification delayed/opened after underlying action completion or revocation; direct DD-12 scenario.

A scenario's presence in this table does not prove that it asserts every leaf mapped to it. No scenario execution, pass, coverage percentage or release readiness is claimed.

## 5. Required QA completion fields

Before a leaf is promoted into a controlled test baseline, QA must add:

1. exact leaf ID, requirement text, authority source/version and detailed-specification source/version;
2. whether the requirement is a fixed governance invariant, candidate design or blocked technical detail;
3. source scenario ID/version and exact original scenario text, or a separately approved new test ID;
4. test level and positive/negative/boundary/concurrency/failure dimensions;
5. synthetic actor, party, project, discipline, assignment and notification fixtures with evidenced scope;
6. exact authorization state at list/count/preview/open/navigation/download/action boundaries;
7. deterministic source commit, event publication, retry and provider simulation points;
8. expected result and the authority that approves it; unresolved results remain Blocked;
9. evidence artifacts, integrity/custody reference, reviewer, defect/waiver/retest and acceptance authority.

## 6. Open dependencies retained from docs/143

This matrix does not close NTF-01–NTF-12 or DEP-NTF-01–DEP-NTF-12. In particular, the following remain open:
- event IDs and authoritative commit crosswalk;
- canonical source-event / recipient-notification / channel-attempt / action-task identity;
- event-specific recipient, action and field-disclosure matrix;
- Action Required task ownership and supersession;
- Unknown / Unconfirmed channel evidence and aggregate semantics;
- durable publication, replay, idempotency and reconciliation architecture;
- exact DEC-049 / DEC-042 reminder and DEC-038 email applicability;
- historical version, revocation and external correction boundaries;
- DD-14 classification, retention, legal hold, backup and residual copies;
- QA/owner validation, synthetic fixtures, expected-result authority and execution approval.

Unresolved items remain **Blocked — Pending Decision / Prerequisite**.

## 7. Relationship to existing DD-15 baselines

- docs/137 remains the exact source scenario inventory; do not rewrite imported scenario text.
- docs/138 remains a scenario-to-specification section crosswalk, not an atomic matrix.
- docs/139 remains the 39-row approved governance coverage baseline; RFI-GOV-021 partially addresses notification authorization and escalation.
- docs/140 remains the 25-row DEC-103/DEC-108 recipient communication leaf matrix; it does not replace these notification leaves.
- docs/141 remains the repository test inventory; its 20 tests include zero RFI-specific acceptance tests.
- docs/136 remains the cross-review documenting that DD-15 is not execution-ready and that CR-136-03 remains open.

This document adds an RFI notification-specific leaf layer only. It does not claim complete DD-01–DD-14 traceability or close DD-15.

## 8. Explicit non-authorization

This document authorizes no test execution, test account/identity/permission creation or change, real notification or Transmittal, provider/channel integration, workflow operation, API/UI/code, DB/schema/migration/generated types, Storage, authentication/authorization/RLS/grants, production-data access/change, backup/restore, archive, legal hold, deletion/disposition, merge, deployment or release. It selects no event IDs, recipient roster, priority, channel, cadence, retry schedule, provider, retention period, security mechanism or technical architecture. Any implementation or execution requires a separate scoped plan, authority approval, specialist validation, synthetic non-production rehearsal and explicit owner authorization.

---
**End of working draft — 18 notification governance leaves recorded; all mappings are candidate, coverage is incomplete, and no test execution or implementation is authorized.**
