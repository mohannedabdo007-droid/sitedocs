# RFI Notification Event Catalogue — Working Draft

**Document type:** Non-authoritative detailed-design working draft  
**Date:** 2026-11-12  
**Status:** PROPOSED FOR REVIEW — NOT GOVERNANCE APPROVAL — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Controlling governance baseline:** `governance/scan-lifecycle-design-2026-11-11`  
**Primary decisions:** DEC-049, DEC-104, DEC-105, DEC-108, DEC-109, DEC-110  
**Dependencies:** RFI-DD-01, RFI-DD-02, RFI-DD-09, RFI-DD-10, RFI-DD-11  
**Backlog item:** RFI-DD-12

> This document defines candidate RFI-specific notification requirements under the central notification framework in DEC-049. It does not approve event triggers, recipient rosters, priorities, channels, cadence, escalation thresholds, templates, provider behavior or workflow transitions. It does not authorize implementation.

## 1. Purpose and design boundary

Provide an auditable event-to-recipient catalogue for RFI notifications while preserving the RFI source record as the authority for lifecycle, assignments, decisions and evidence. Notifications are a communication projection of authoritative events, not workflow records and not a substitute for them.

Classify every statement as:
- **Approved constraint:** directly required by DEC-049 or DEC-104–DEC-110.
- **Candidate design:** proposed event, recipient or presentation behavior requiring owner/authority review.
- **Open decision:** a value, policy, authority or mechanism not yet approved.

## 2. Controlling principles

1. Generate notifications only from authoritative, committed business events; never infer an event from a screen label, client action, free text, stale cache or an uncommitted command.
2. Resolve each recipient individually using current authorization, project and party scope, discipline, active assignment, workflow responsibility, visibility and the event's permitted audience. Membership, past participation or historical assignment alone is insufficient.
3. Recheck current authorization when listing, counting, previewing, opening, navigating, downloading or taking a linked action. A notification or old deep link never grants access.
4. Reading, opening, dismissing or acknowledging a notification does not perform, approve, sign, issue, distribute, withdraw, cancel, reopen or close an RFI.
5. Keep business-event history, notification records, channel-delivery attempts, read state, action resolution and source workflow state distinct and attributable.
6. Do not establish default SLA, reminder cadence, quiet hours, retry limit, priority mapping, escalation threshold or contractual consequence.
7. Apply DEC-038–DEC-042 where their WIR-specific rules are relevant only to WIR; do not import WIR statuses, recipient rules or priority assumptions into RFI.
8. Follow DEC-049's central in-app notification framework; no SMS, push or other unapproved channel is implied.

## 3. Notification object and event relationship

Candidate logical record (not a database schema):
- immutable source event reference and source record class;
- RFI identity, cycle and exact response/revision/version reference where relevant;
- event type and policy/catalogue version;
- recipient identity, party/project/discipline/assignment basis and authorization decision reference;
- notification purpose: Action Required, Critical awareness, or Informational;
- minimal authorized display metadata and safe navigation reference;
- created timestamp, priority (only when approved), channel attempt references and outcomes;
- read/open/dismiss state, if supported, separate from workflow resolution;
- authoritative action reference and resolution/supersession event, if action-required;
- deduplication/idempotency reference and attributable exception history.

One source event may produce separate recipient-specific notification records with different permitted content or action. Do not reveal hidden recipients or recipient counts where that would disclose restricted information.

## 4. Candidate event catalogue

The table is a design inventory, not an approved trigger matrix. Recipient eligibility and priority remain conditional on the approved authority and project rules.

| Event family | Candidate event | Candidate recipient basis | Candidate purpose |
|---|---|---|---|
| Origination | Official RFI successfully submitted | Originator confirmation; designated coordinator/intake role | Informational / Action Required if a defined intake task exists |
| Coordination | Completeness deficiency or return recorded | Originator and authorized coordinator | Action Required for originator where correction is permitted |
| Assignment | Discipline contribution assigned or reassigned | Current assignee; relevant technical lead | Action Required |
| Contribution | Contribution submitted, returned, or changed | Technical lead and authorized assigned participants | Informational / Action Required only for a defined next task |
| Clarification | Originator clarification requested | Originator; responsible coordinator/technical lead | Action Required |
| Clarification | Clarification submitted | Requesting technical participant(s), coordinator | Informational / Action Required if an explicit review task follows |
| Conflict | Material technical conflict recorded or escalated | Authorized technical lead and designated decision authority | Candidate Critical or Action Required; trigger requires approval |
| Consolidation | Consolidated response submitted for independent review | Appointed independent reviewer and relevant technical lead | Action Required |
| Review | Review completed, returned, or material defect recorded | Technical lead, issuer/authority as permitted | Informational / Action Required |
| Issue | Formal response issued and RFI closed | Originator and authorized project parties according to visibility | Informational; does not imply recipient acknowledgement |
| Reopening | New technical cycle formally authorized | Originator, current responsible technical roles, relevant coordinator | Informational / Action Required only for newly assigned work |
| Withdrawal | Withdrawal request submitted, approved, rejected or otherwise resolved | Originator, coordinator, technical lead/authority as applicable | Action Required for pending authorized decision; informational on outcome |
| Cancellation | Administrative cancellation authorized | Originator and relevant current participants/records roles | Informational; do not imply technical rejection |
| Distribution | New or linked Transmittal dispatched; recipient delivery exception | Only authorized sender and affected recipient(s), with recipient-specific content | Informational / Action Required only where separately required |
| Recipient event | Required acknowledgement or substantive response received / overdue indicator | Authorized sender, Document Control or designated owner | Informational / Action Required subject to approved recipient policy |
| Records | Archive/hold/records exception | Authorized records roles only | Action Required for an authorized records task |
| System operations | Notification processing or delivery failure | Authorized operational support role; affected user only if policy requires | Operational alert, not an RFI workflow event |

A notification event must never be generated for an uncommitted or rejected source command as though the business action succeeded. A failed attempt may create a restricted operational/security event under separately governed observability rules, not a false RFI success notification.

## 5. Action Required versus Informational

- **Action Required** is permitted only when an authoritative event creates or exposes a specific, currently actionable task for that recipient.
- The notification must name the expected action in safe terms and link to the exact source object/task, subject to current authorization.
- It remains unresolved until the authoritative task is completed, reassigned, cancelled, withdrawn, superseded or otherwise resolved under the source workflow's approved rules.
- Reading, opening, dismissing, marking read or acknowledging the notification does not resolve the task or reset its due date.
- Informational notifications do not create action reminders.
- A substantive response, acknowledgement or source decision must be recorded through its own authorized process; notification controls cannot impersonate those actions.

## 6. Recipient resolution and authorization

Candidate resolution sequence:
1. Identify the committed source event and exact scope (RFI, cycle, response, assignment, recipient or Transmittal).
2. Identify the event's approved audience rule and action owner.
3. Resolve current user identities from active project/party/discipline/assignment appointments.
4. Apply party, field, record, draft, attachment and recipient visibility constraints.
5. Check capability only where the notification links to an action; receiving information does not itself confer capability.
6. Revalidate at delivery and again at every access/action boundary.
7. Record included and excluded recipient decisions with minimal audit detail, without exposing hidden roster data to ordinary recipients.

The Project Manager's supervisory visibility remains read-only under DEC-021. Coordinator status does not confer engineering authority. Document Control distribution duties do not confer issue authority. A former assignee should not receive new actionable reminders after effective reassignment, but prior notifications and event history remain preserved.

## 7. Content classification and privacy

- Default to minimal metadata: event category, safe RFI reference, project context only where permitted, timestamp, purpose and action label.
- Subject, question text, response text, discipline contributions, reviewer comments, attachments, recipient identity and external-party details are separately protected fields.
- Draft existence and content must not leak to unauthorized parties through notification body, subject line, email preview, badge count, search, grouping, analytics or error messages.
- External email content, if later approved, must not include protected response or attachment content by default; use only approved secure access patterns.
- Do not expose other recipients, hidden manifest entries, acknowledgement status or recipient-level delivery details unless the viewer is authorized for that information.
- PM oversight remains read-only and does not create entitlement to confidential party/discipline content beyond the approved scope.

## 8. Priority model — unresolved

DEC-049 requires the central framework to preserve event-specific priorities and not delay Critical or urgent Action Required events through informational batching. This draft does not assign RFI event priorities.

Candidate classification questions for owner review:
- Which RFI events, if any, qualify as Critical due to safety, regulatory or material project risk?
- Which Action Required tasks are genuinely time-sensitive under an approved project rule?
- Who owns the priority classification and exception override?
- What evidence and audit trail support a priority change?

No default RFI priority map or numeric urgency threshold is selected. WIR Critical examples in DEC-039 are not automatically RFI rules.

## 9. Channels, delivery and preferences

- In-app notification is the central mandatory experience under DEC-049 for authorized notification events.
- Email remains subject to the governing notification/channel policy and user preferences where approved; DEC-049 does not by itself approve SMS, push, chat or a new external provider.
- A channel preference affects delivery channel only; it must not suppress a mandatory in-app notification or alter the source workflow.
- Distinguish notification created, queued, attempted, provider accepted, delivered (if technically confirmed), bounced/failed, opened/read and action resolved. These are not interchangeable.
- A provider acceptance or email open is not proof of human acknowledgement, technical acceptance or RFI closure.
- Channel selection, fallback, provider, retry policy, delivery evidence and external recipient identity assurance remain open and require DD-09/security review.

## 10. Deduplication, grouping and retry

- Deduplicate technical retries of the same notification delivery using a stable source-event/recipient/channel/idempotency identity.
- Do not collapse distinct business events merely because they concern the same RFI or recipient.
- Grouping may be considered for non-urgent informational notifications only; each underlying event must remain individually retrievable and auditable.
- Critical and urgent Action Required events must not be delayed by batching.
- Retry attempts preserve the same notification identity and record attempt history; they do not create a new business event or reset action state.
- Changed source scope or a new material event creates a distinct notification linked to its source event.
- Exact idempotency-key scope, retention, retry/backoff, dead-letter handling and provider reconciliation remain open under DD-07/architecture review.

## 11. Reminder and escalation boundaries

- No reminder is generated merely because a notification is unread.
- A reminder may be considered only for an unresolved authoritative Action Required task and only under an approved task-specific policy.
- No default cadence, quiet hours, working calendar, timezone, SLA, overdue threshold, pause-clock or escalation ladder is created.
- Escalation increases visibility only; it does not transfer technical authority, change assignment, grant permission, approve content or execute the action.
- Any escalation recipient must have an independently approved role and current authorization.
- Reassignment, task cancellation, withdrawal, closure or valid supersession must stop future reminders to an ineligible recipient while preserving all previous reminders and outcomes.
- Overdue is a monitoring indicator, not a lifecycle transition.

## 12. Source changes, supersession and historical notifications

- Preserve notification and delivery history when an RFI is clarified, revised, reopened, withdrawn, cancelled, closed or archived.
- A notification referring to a prior cycle or response must remain explicitly bound to that exact historical version; never silently redirect it to the latest response.
- If a source item is superseded or access is revoked, mark the relationship/status safely and recheck access; do not delete the historical notification or rewrite its original content/evidence.
- Any corrective notice or instruction to external recipients must use an authorized communication/Transmittal process under DEC-050/051/108. A notification alone is not an external recall.
- Never claim that downloaded, printed, forwarded or replicated copies have been recalled or deleted.
- Reopening a closed RFI creates a new cycle under the same official identity; notifications must identify the new cycle and preserve prior-cycle context without conflating them.

## 13. Notification Center and user controls

Candidate central views, subject to alignment with DEC-049:
- All notifications;
- Unread;
- Action Required;
- Critical (only if an approved RFI priority policy classifies any);
- event date and source-record filters, within the user's authorized scope.

Candidate controls: mark read/unread, dismiss from a personal view, open authorized source record. These controls affect only the user's notification presentation state. Dismissal must not erase the event or resolve the source task. Bulk operations, search, pagination, retention and personal preference details remain open.

## 14. Reporting and metrics

Keep separate measures for:
- source business events generated;
- recipient notifications created;
- channel attempts and confirmed outcomes;
- unread/read/dismissed notifications;
- open Action Required tasks;
- overdue tasks under an approved target rule;
- escalations and resolution events.

Every metric must declare its counting unit, population, source, period, timezone, as-of cut-off and permission scope. Do not infer lifecycle state or task completion from notification read state, delivery receipt, badge count or user interface labels. Counts, facets, previews and drill-downs must enforce current authorization and avoid metadata leakage.

## 15. Audit and evidence

Preserve attributable records sufficient to reconstruct:
- source event and exact RFI/cycle/version;
- recipient resolution basis and policy/catalogue version;
- authorization outcome at generation/delivery/access/action boundaries;
- notification creation and content classification;
- each channel attempt and technical outcome;
- read/open/dismiss changes;
- action resolution, reassignment, supersession or cancellation;
- retries, deduplication and operational exceptions.

Keep notification history distinct from the authoritative RFI audit trail while retaining stable links to it. Sensitive security/recipient-resolution detail must be restricted to authorized reviewers.

## 16. Failure, recovery and security scenarios

Required design/test scenarios:
1. unauthorized user cannot list, count, preview, open or act on a notification;
2. revoked access after notification creation blocks source access and reveals no protected content;
3. draft event does not leak to another party through email preview, badge count, search or grouped summary;
4. former assignee receives no new actionable reminder after effective reassignment;
5. duplicate delivery retry does not create duplicate business notification or task;
6. distinct events on the same RFI remain individually traceable;
7. provider timeout after successful delivery is reconciled without false duplicate or false failure claim;
8. read/open/dismiss does not resolve Action Required or alter RFI state;
9. source task closure/supersession stops future reminders but preserves prior notification history;
10. Critical/urgent Action Required is not delayed by informational batching;
11. historical-cycle notification never silently redirects to a later cycle/version;
12. recipient-specific notification content cannot disclose other recipients or restricted Transmittal metadata;
13. notification processing failure does not roll back or falsely report source workflow success;
14. replay/recovery preserves source-event, recipient and idempotency identity.

These are proposed acceptance scenarios, not executed tests. Map them to DEC-110 and DD-07/DD-09 before test-plan approval.

## 17. Open decisions and required reviewers

| Open decision | Required authority / reviewer |
|---|---|
| Final RFI event taxonomy and exact committed source-event triggers | Owner; technical/process authority; Document Control |
| Recipient matrix by event, party, discipline, assignment and visibility | Owner; project/party authority; security |
| Which RFI events qualify as Critical or urgent Action Required | Owner; safety/quality/technical authority |
| Exact content templates and field-level disclosure rules | Security/privacy; Document Control; owner |
| In-app versus optional email applicability and external recipient channel | Owner; identity/security; communication/contract authority |
| Reminder cadence, quiet hours, working calendar, escalation thresholds and recipients | Owner; project operations; technical authority |
| Retry, idempotency, outbox/queue, provider reconciliation and failure handling | Architecture/engineering; security; operations |
| Notification history retention, archive, export and legal hold | Records authority; legal/compliance as applicable |
| Bulk read/dismiss, grouping, pagination, search and accessibility behavior | Product owner; accessibility/security |
| Operational alert audience and separation from business notifications | Operations/security; owner |

Unresolved decisions remain blocked; no implementation default may settle them.

## 18. Governance alignment and explicit exclusions

This draft operationalizes the RFI-facing portion of DEC-049 while preserving DEC-104/105 authority boundaries, DEC-108 recipient communication separation, DEC-109 notification/reporting/records safeguards and DEC-110 acceptance expectations. It does not amend those decisions. DEC-103 recipient delivery/acknowledgement aggregation remains authoritative for Transmittals; notification delivery/read state is not a substitute.

**Design-only boundary:** no notification schema/table/migration/generated types, event bus/outbox, scheduler, provider integration, email configuration, SMS/push, API/UI/code, auth/RLS/grants, production data, live tests, merge or deployment is authorized or performed. No reminder cadence, priority, escalation, recipient entitlement, channel or legal effect is approved by this draft. A separate implementation plan, security/privacy/records review, test plan, non-production rehearsal and explicit owner authorization are mandatory.
