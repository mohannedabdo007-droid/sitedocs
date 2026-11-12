# DD-12 Notification Framework Cross-Specification Review — Working Draft

**Document type:** Exact-version desk-review and governance traceability record  
**Date:** 2026-11-12  
**Status:** REVIEW FINDINGS — OWNER / SECURITY / PRIVACY / ARCHITECTURE / OPERATIONS / RECORDS / QA VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Primary specification:** `docs/80_RFI_NOTIFICATION_EVENT_CATALOGUE_WORKING_DRAFT.md` (DD-12)  
**Lifecycle review:** `docs/133_DD11_DD12_LIFECYCLE_NOTIFICATION_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md`  
**Controlling governance:** DEC-049, DEC-104, DEC-105, DEC-108, DEC-109, DEC-110; DEC-021 remains relevant to read-only PM oversight  
**Related specifications:** DD-01/02/07/09/10/11/13/14/15; `docs/75`, `docs/77`, `docs/78`, `docs/81`, `docs/82`, `docs/83`, `docs/131`, `docs/137`, `docs/139`, `docs/140`

> This review evaluates the DD-12 candidate catalogue against the exact governance constraints and adjacent specifications listed above. It is a document-level desk review only. Findings are not new owner decisions, do not amend DEC-049 or other governance, and do not approve event IDs, recipient matrices, priorities, channels, timing, templates, retention values, architecture or implementation.

## 1. Review objective and method

The review checks whether RFI notifications remain a permission-safe projection of authoritative events, and whether the DD-12 catalogue is sufficiently precise about:
- source-event identity, commit point and event version;
- notification, recipient fan-out and channel-attempt identity;
- action ownership and resolution;
- current authorization, privacy and recipient-specific disclosure;
- priority, batching, reminder and escalation boundaries;
- retry, uncertain delivery, reconciliation and recovery;
- historical cycle/version behavior and records lifecycle; and
- actual DD-15 source scenarios and atomic governance requirements.

The governance source for DEC-049 was fetched from `governance/scan-lifecycle-design-2026-11-11/docs/01_MASTER_DECISION_REGISTER.md`. DEC-049 establishes a central in-app notification framework for presentation and retrieval only; module-specific event and recipient rules remain separate. It makes in-app mandatory, keeps email optional and preference-dependent under DEC-038, does not approve SMS/push/public links/default broadcast, and requires action-time authorization, separation from source workflow, auditable history, deduplication and controlled reminder/escalation.

## 2. Executive result

**No direct normative contradiction was identified** between DD-12 and DEC-049 / DEC-104–110 in the reviewed material. The draft correctly treats notifications as projections, not workflow records; keeps read/open/dismiss separate from source actions; rejects historical assignment as a current audience basis; preserves exact historical cycle/version links; and leaves unapproved priorities, cadence, channels and provider mechanisms unresolved.

However, DD-12 is **not ready for promotion or implementation planning**. The review records 12 findings (NTF-01–NTF-12) and 12 dependencies (DEP-NTF-01–DEP-NTF-12). The highest-risk gaps are: (a) no complete event-to-authoritative-commit crosswalk; (b) no stable identity and state model across source event, recipient notification and channel attempts; (c) no explicit durable publication/reconciliation contract connected to DD-07/docs/131; and (d) no atomic leaf-level DD-15 coverage for all DEC-049 notification requirements.

## 3. Governance and specification crosswalk

| Control area | Controlling source | DD-12 position | Review treatment |
|---|---|---|---|
| Central framework | DEC-049 | Central in-app presentation/retrieval; RFI-specific catalogue | Aligned; do not merge RFI/WIR workflows |
| Source-event authority | DEC-049; DEC-104–106 | Only authoritative committed business events generate business notifications | Aligned; exact event IDs and commit points remain open |
| Recipient resolution | DEC-049; DEC-105; DEC-109 | Current project/party/discipline/assignment/visibility/capability scope | Aligned; needs explicit event-to-recipient matrix and evidence model |
| Read/action separation | DEC-049; DEC-103; DEC-108 | Read/open/dismiss does not resolve source task or recipient obligation | Aligned; retain negative assertions |
| In-app/email/channels | DEC-049 | In-app mandatory; email optional/preference-dependent under DEC-038; SMS/push/public links/default broadcast not approved | Clarify DD-12 §9 with exact DEC-049 wording; do not broaden channels |
| Priority and batching | DEC-049 | No RFI priority map; critical/urgent action not delayed by informational batching | Aligned; no invented RFI classification |
| Reminder/escalation | DEC-049 and DEC-042 where incorporated by DEC-049 | Only unresolved Action Required; current authorized responsible recipients; separately approved configurable thresholds; no transfer of authority | Add explicit cross-reference; no fixed SLA or cadence |
| Retry and audit | DEC-049; DEC-107; DD-07/docs/131 | Stable retry identity and attempt history proposed | Partially specified; source-event publication and reconciliation remain open |
| Historical/records | DEC-109; DD-11; DD-14/docs/82 | Preserve history, exact cycle/version and access revalidation | Aligned; notification retention/hold/residual-copy rules unresolved |
| Test/acceptance | DEC-110; DD-15/docs/83, 137–140 | 14 candidate DD-12 scenarios in docs/80; source inventory includes E2E-28 | Partial; no atomic requirement coverage or execution claim |

## 4. Detailed findings

### NTF-01 — Authoritative event catalogue lacks a committed-event crosswalk

DD-12 §4 labels events as candidates, but it does not identify for each event the authoritative source record, exact event identity, commit boundary, cycle/version reference, and the action that makes the event eligible. For example, assignment/reassignment, withdrawal request/decision, reopening authorization, response issue, recipient exception and records hold must not be inferred from UI state or attempted commands.

**Required treatment:** create an event-to-source crosswalk with event owner, authoritative record, commit point, scope/version, candidate recipient rule, source decision and unresolved authority. A rejected, stale or uncommitted command must not create a success notification.

**Reviewers:** owner; process/technical authority; architecture; QA; Document Control.

### NTF-02 — Three identity layers need explicit separation

The candidate notification object lists source event, recipient, channel attempt and idempotency references, but no canonical relationship contract defines their distinct identities and lifecycles.

**Required treatment:** distinguish at minimum (1) immutable source business event, (2) recipient-specific notification instance, (3) each channel delivery attempt, and (4) user read/open/dismiss state and linked authoritative action resolution. One source event may fan out to multiple recipient-specific notifications; channel retry must not create another business event or recipient obligation.

**Reviewers:** architecture; security; operations; records; QA.

### NTF-03 — Recipient resolution requires an explicit event-specific entitlement matrix

DD-12 correctly requires current authorization and prohibits relying on membership or historical assignment. It does not yet supply the complete event × recipient class × project/party/discipline/assignment × field visibility matrix.

**Required treatment:** define separately who may receive a notification, who may see its minimal metadata, who may open the source record, and who may execute a linked action. These are distinct permissions. Former assignees must not receive new actionable reminders after effective reassignment; prior records remain subject to current access controls.

**Reviewers:** owner; project/party authority; identity/security; privacy; Document Control.

### NTF-04 — Fan-out and hidden-recipient privacy need explicit negative controls

The draft addresses hidden recipients, counts, previews and grouped summaries, but does not define the protected disclosure boundary for mixed-authority audiences or shared project/party views.

**Required treatment:** define field-level disclosure for recipient-specific notification content, badge counts, grouping, search/facets, email subject/preview (if permitted), error messages and operational logs. Exclude unauthorized recipients without revealing roster membership, recipient counts or event existence where those facts are restricted.

**Reviewers:** security/privacy; architecture; QA; owner.

### NTF-05 — Action Required must bind to an authoritative task identity

DD-12 says Action Required exists only for a specific actionable task, and is resolved by source workflow outcomes. The task identity, owner-change/supersession lineage and relationship to due-date/overdue indicators remain underspecified.

**Required treatment:** bind Action Required to an authoritative task/action identity and current responsible assignment. A notification read/dismiss/ack event cannot resolve it. Reassignment, valid cancellation, withdrawal, completion or approved supersession must resolve or re-target the task under source rules, without rewriting prior notification history. Do not invent due dates or SLA.

**Reviewers:** process owner; technical authority; project operations; architecture; QA.

### NTF-06 — Channel state vocabulary must not imply confirmed delivery

DD-12 §9 distinguishes created, queued, attempted, provider accepted, delivered, bounced/failed, opened/read and action resolved. It does not yet define evidence standards for uncertain/unknown outcomes or aggregate semantics.

**Required treatment:** preserve `Unknown / Unconfirmed` where the provider outcome cannot be established. Do not infer Delivered from provider acceptance, an API success response or an open/read signal. Notification channel outcomes must remain separate from DEC-103 Transmittal recipient-level delivery and acknowledgement aggregates.

**Reviewers:** architecture; operations; security; Document Control; QA.

### NTF-07 — Durable source-event publication and recovery are not closed

DD-12 §10 proposes deduplication and retries, while DD-07/docs/131 separates atomic authoritative business commits from external side effects. The integration does not yet specify how notification processing discovers a committed event after interruption, reconciles missing/duplicate projections, or handles a stale worker.

**Required treatment:** define an architecture-neutral publication/reconciliation contract that preserves source-event, recipient and attempt identity, handles commit-before-publish failure, uncertain provider response, replay, dead-letter/recovery and authorization changes. Do not select an outbox, queue, provider, locking mechanism or retry schedule without architecture approval.

**Reviewers:** architecture/engineering; operations; security; records; QA; owner.

### NTF-08 — Idempotency and grouping need separate scopes

The draft correctly says not to collapse distinct business events. It does not define the uniqueness boundary for one source event, recipient, notification purpose and channel, nor how a changed event version or changed recipient eligibility affects identity.

**Required treatment:** define idempotency scopes for notification creation, recipient fan-out, channel retry and grouping separately. Retry of the same attempt scope preserves identity; a distinct source event or authorized new recipient notification must not be suppressed as a duplicate. Grouping is presentation-only and preserves every underlying notification.

**Reviewers:** architecture; security; operations; QA.

### NTF-09 — Priority and reminder controls need exact DEC-049 alignment

DD-12 correctly avoids an RFI-specific default priority map and fixed cadence. DEC-049 additionally requires that reminders/escalation follow DEC-042: only unresolved Action Required tasks, current authorized responsible recipients, separately approved configurable thresholds, no fixed SLA/contractual deadline, and no transfer of responsibility or capability. In-app is mandatory; email remains optional and preference-dependent under DEC-038.

**Required treatment:** explicitly incorporate these controlling constraints into DD-12 §8–§11. Keep RFI-specific event priority, thresholds, quiet hours, working calendars and escalation recipients open for owner/project approval. Never let an escalation change assignment or grant authority.

**Reviewers:** owner; project operations; technical authority; security; QA.

### NTF-10 — Historical notification behavior needs stronger source-version and revocation contract

DD-12 §12 protects historical cycle/version links, but does not define what the notification displays after source correction, access revocation, recipient removal or a new linked Transmittal.

**Required treatment:** preserve the immutable source-event reference and original notification evidence; reauthorize every open/navigation/download/action; deny future system-controlled access after revocation; avoid silently retargeting to the latest cycle/version; and use a separately authorized Transmittal for external corrective communication. Do not claim recall of copies already downloaded, printed or forwarded.

**Reviewers:** owner; Document Control; security/privacy; records; contract/legal; QA.

### NTF-11 — Retention, legal hold and residual copies require DD-14 linkage

DD-12 §15 and §17 require history, but do not specify notification record classification, retention trigger, hold scope, archive/retrieval, backup/replica/cache lifecycle, or disposition authority. DD-14/docs/82 deliberately leaves these values open.

**Required treatment:** classify source event, recipient notification, channel attempt, read-state history and operational exception records within DD-14; map linked evidence and residual copies; preserve holds and backups independently; do not introduce expiry-driven deletion or a retention duration by inference.

**Reviewers:** records authority; legal/compliance; security; architecture; owner.

### NTF-12 — DD-15 coverage is not yet atomic or execution-ready

DD-12 §16 contains 14 proposed scenarios. The controlled source inventory docs/137 includes E2E-28 (delayed/opened notification after underlying action completion or revocation), AT-RFI-08 (no false closure), and related communication/access scenarios. Docs/139 and docs/140 decompose governance requirements, but do not yet provide a complete DEC-049 notification leaf baseline or validate the DD-12 candidate cases against the imported source definitions.

**Required treatment:** map each DD-12 scenario to exact atomic requirements, source decision, event/recipient/permission fixture, approved expected-result authority and actual source scenario. At minimum cover authorization at list/count/preview/open/navigation/download/action; stale/revoked recipient; fan-out privacy; action resolution; duplicate/replay; distinct events; provider uncertainty; batching; historical cycle; reminder/escalation boundaries; retention/hold and recovery. Mark unresolved expected outcomes Blocked. No test is claimed executed.

**Reviewers:** QA; security/privacy; architecture; operations; records; owner.

## 5. DD-15 source scenario mapping — candidate only

The following are source-preserving pointers, not newly invented test cases or approval of expected outcomes:

| Existing scenario | Source definition | DD-12 relevance | Coverage note |
|---|---|---|---|
| AT-RFI-08 | No false closure: delivery, acknowledgement, read state, due-date expiry or draft answer does not silently close RFI | Source/workflow vs notification separation | Direct subject relevance; exact notification control assertions need QA refinement |
| E2E-14 | Delivery failure after successful technical issue and closure | Channel failure cannot roll back source lifecycle | Partial; notification projection and Transmittal delivery must be distinguished |
| E2E-15 | Recipient access revoked after dispatch before opening exact manifest entry | Current authorization at access | Partial; notification link/preview/count behavior also needs coverage |
| E2E-16 | Recipient opens/downloads while acknowledgement required | Access differs from acknowledgement | Direct adjacent coverage; notification read is not acknowledgement |
| E2E-17 | Required recipient fails delivery while others succeed and acknowledge | Recipient-level aggregation | Adjacent Transmittal coverage; do not reuse as notification aggregation semantics |
| E2E-18 | Retry unchanged package | Delivery retry identity | Adjacent channel/Transmittal retry; notification retry needs separate identity assertions |
| E2E-19 | Recipient list/package changes after dispatch | Immutable manifest and new Transmittal | Notification audience/history must not silently mutate |
| E2E-20 | Correction after issue and recipient access | Historical notification and corrective communication | Partial; controlled notice vs recall boundary |
| E2E-22 | Reopening while historical Transmittal acknowledgement pending | Prior-cycle obligations remain historical | Direct cross-cycle relevance |
| E2E-23/24 | Withdrawal race / source response withdrawn after Transmittal | Source event commit and external communication separation | Cross-reference docs/133; no notification from losing/uncommitted action |
| E2E-28 | Notification delayed or opened after underlying action completed or revoked | Reauthorization and stale notification behavior | Direct DD-12 source scenario; expected action outcome must be tied to approved source authority |

QA must retain the original definitions and IDs from docs/137 and reconcile these mappings with docs/138–140 and the repository test inventory. Broad DD labels are not coverage evidence.

## 6. Dependency register

| ID | Open dependency | Required evidence / authority | Status |
|---|---|---|---|
| DEP-NTF-01 | Approved event taxonomy, stable event IDs and commit points | Owner/process authority and source-spec exact-version crosswalk | Open |
| DEP-NTF-02 | Notification/recipient/attempt/action identity model | Architecture, QA, records and security review | Open |
| DEP-NTF-03 | Event-specific recipient and action authority matrix | Owner, project/party and technical authorities; identity/security evidence | Open |
| DEP-NTF-04 | Field-level disclosure and hidden-recipient privacy | Security/privacy review and negative test assertions | Open |
| DEP-NTF-05 | Action Required task identity, reassignment and supersession semantics | Process owner and approved task rules | Open |
| DEP-NTF-06 | Channel outcome evidence and unknown/uncertain handling | Channel/operations architecture and QA | Open |
| DEP-NTF-07 | Durable event publication, replay and reconciliation | DD-07 architecture decision; docs/131 integration review | Open |
| DEP-NTF-08 | Idempotency and grouping scopes | Architecture/operations/QA decision with distinct-event tests | Open |
| DEP-NTF-09 | Priority, email preference and reminder/escalation applicability | Exact DEC-049/DEC-042/DEC-038 alignment and owner/project approval | Open |
| DEP-NTF-10 | Historical source-version, revocation and corrective communication | DD-09/10/11, DEC-108, security, records and contract review | Open |
| DEP-NTF-11 | Notification records classification, retention, hold and residual copies | DD-14 records/legal authority and recovery review | Open |
| DEP-NTF-12 | Atomic DD-15 traceability, fixtures and expected-result authority | QA/security/records/architecture/owner validation | Open |

## 7. Required controlled updates

1. Keep `docs/80` as the primary DD-12 specification. This review supplements it; it does not silently rewrite candidate policy or source rules.
2. Add this review as a cross-reference in docs/80 and docs/83.
3. Add a backlog action to resolve NTF-01–NTF-12 and DEP-NTF-01–DEP-NTF-12 with exact-version evidence.
4. Retain docs/133 as the DD-11/DD-12 lifecycle interaction review; this document is a deeper DD-12 framework review and does not replace CR-133-01–09.
5. Reconcile the accepted notification leaf requirements with docs/139/140 and DD-15 only after owner/specialist review.

## 8. Disposition

- No direct normative contradiction was identified in the reviewed documents.
- DD-12 remains a candidate working specification; NTF-01–NTF-12 are review findings, not owner decisions.
- DEP-NTF-01–DEP-NTF-12 remain open.
- No event trigger, recipient matrix, priority, channel, cadence, provider, escalation threshold, retention period, identity mechanism or permission is approved by this review.
- No specialist sign-off, test execution, implementation readiness, formal closeout or release readiness is claimed.

## 9. Explicit non-authorization

This review authorizes no notification schema/table/migration/generated types, event bus/outbox, scheduler, provider/channel integration, email configuration, SMS/push, API/UI/code, DB/Storage/auth/RLS/grants, production-data operation, real external notification, live test, backup/restore, archive, hold, disposition, merge, deployment or release. A separate implementation plan, architecture/threat/privacy/records review, approved test plan, synthetic non-production rehearsal and explicit owner authorization remain mandatory. DB/Storage changes additionally require verified backups, isolated restore/rehearsal and reconciliation.
