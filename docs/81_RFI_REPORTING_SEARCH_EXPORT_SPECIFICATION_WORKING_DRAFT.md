# RFI Reporting, Search and Export Specification — Working Draft

**Document type:** Non-authoritative detailed-design working draft  
**Date:** 2026-11-12  
**Status:** PROPOSED FOR REVIEW — NOT GOVERNANCE APPROVAL — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Controlling governance baseline:** `governance/scan-lifecycle-design-2026-11-11`  
**Primary decisions:** DEC-021, DEC-049, DEC-103, DEC-104, DEC-105, DEC-108, DEC-109, DEC-110  
**Dependencies:** RFI-DD-01, RFI-DD-02, RFI-DD-06, RFI-DD-07, RFI-DD-08, RFI-DD-09, RFI-DD-10, RFI-DD-11, RFI-DD-12  
**Backlog item:** RFI-DD-13

> This document proposes a controlled specification for RFI reporting, dashboards, search and exports. It does not approve report entitlements, metric definitions, export formats, retention periods, BI integrations, scheduled distribution or implementation.

## 1. Purpose and decision discipline

Define how RFI information may be found, counted, compared, reported and exported without creating a second source of truth or disclosing information beyond the viewer's current authority.

Classify statements as:
- **Approved constraint:** directly required by DEC-021, DEC-049, DEC-103 or DEC-104–DEC-110.
- **Candidate design:** proposed report/search/export behavior requiring owner, records, security or technical review.
- **Open decision:** unresolved definition, authority, value or mechanism.

## 2. Governing principles

1. Authoritative RFI records and attributable append-only event history are the sources; dashboards, saved filters, search indexes, caches and exports are derived views.
2. Every displayed metric declares its source, counting unit, population, inclusion/exclusion, period, timezone, as-of cut-off and authorization scope.
3. Enforce current server-side row-, field-, party-, project-, discipline-, assignment- and attachment-level authorization for list, search, autocomplete, facets, counts, drill-downs, previews and exports.
4. Fail closed when authorization or source integrity cannot be established. Do not leak restricted metadata through counts, empty-state differences, timing, snippets or error messages.
5. Preserve the difference between unique RFI identity, cycle, revision, response, contribution, assignment, review, Transmittal, recipient and event.
6. Preserve historical cycles and exact versions; never silently replace prior values with the latest state.
7. Reports and exports are not technical decisions, approvals, source records or workflow transitions.
8. No default SLA, due date, timezone/calendar policy, performance ranking, retention duration, scheduled external distribution, export format or BI integration is established.

## 3. Data sources and lineage

Candidate authoritative source families:
- RFI identity and immutable official number/creation/submission record;
- lifecycle cycle and transition/event history;
- question, clarification, formal revision and response snapshots;
- discipline assignments, contributions, consolidation and conflict records;
- independent review, issue and closure events;
- withdrawal, cancellation, reopening and linked-RFI relationships;
- evidence manifests, file/version/integrity references (not unrestricted file contents);
- Transmittals, frozen manifests and recipient-specific delivery/access/acknowledgement/substantive-response events;
- notification events and action-resolution references, used only for notification metrics;
- approved project target-date configuration and its authority/source, if any.

Every report definition must identify the authoritative source fields/events and version. Derived indexes may accelerate retrieval but must be reconcilable to source records and cannot independently define status, authority or event truth. If lineage is missing, stale beyond an approved bound, contradictory or unverifiable, mark the affected result unavailable or visibly stale rather than infer a value.

## 4. Reporting domains and counting units

Keep independent domains; do not collapse them into one progress score.

| Domain | Primary unit | Example measure | Prohibited inference |
|---|---|---|---|
| Technical lifecycle | Unique RFI and/or cycle, explicitly labelled | Current cycle stage; closed RFIs | Delivery or acknowledgement means closed |
| Cycle history | RFI cycle | Reopened cycles; cycle duration if approved | Reopened cycle is a new RFI identity |
| Workload | Assignment | Open discipline assignments by authorized scope | Assignment count equals unique RFI count |
| Contributions | Contribution/version | Submitted or pending contributions | Contribution count equals response count |
| Review | Review instance/version | Reviews pending/completed | Review completion means issue |
| Response/issue | Formal response/version | Issued responses by period | Draft answer means official response |
| Communication | Transmittal / recipient / event | Delivery and acknowledgement outcomes | Notification read means acknowledgement |
| Evidence | Evidence item/version/manifest | Evidence availability/integrity exceptions | Attachment count reveals protected files |
| Notification | Notification/recipient/channel attempt | Delivery attempts; Action Required tasks | Notification state is RFI lifecycle state |
| Records oversight | Record / hold / archive event | Authorized records exceptions | Archive means delete or close |

Each tile, chart, table, CSV or API response must visibly label its counting unit and aggregation rule. A single RFI may have multiple cycles, responses, assignments, contributions, Transmittals and recipient events.

## 5. Candidate report catalogue

The following catalogue is proposed for owner and reporting-authority review; it is not an approved entitlement or screen inventory.

| Report/view | Candidate audience basis | Candidate content | Key safeguards |
|---|---|---|---|
| RFI register | Authorized project/party users | Official identity, subject and permitted lifecycle summary | Current party/field visibility; drafts excluded unless specifically authorized |
| My actionable work | Current assignee / authorized delegate | Own active assignments and action state | No historical assignment entitlement; current assignment recheck |
| Discipline workload | Authorized discipline leadership | Counts and scoped assignments | No cross-party or unrelated discipline leakage |
| Technical cycle history | Authorized oversight/technical roles | Cycle dates, outcomes, reopening links | Preserve each cycle and prior closure |
| Clarification and response history | Authorized participants | Requests, rounds, response versions | Field-level access and immutable snapshots |
| Review and issue register | Authorized technical/quality authority | Review gates and issue events | Reviewer comments and confidential rationale protected |
| Transmittal/recipient report | Authorized sender/Document Control/records roles | Recipient-specific delivery and acknowledgement | DEC-103 aggregation; hidden recipients protected |
| Evidence integrity exceptions | Authorized security/records roles | Missing, quarantined or mismatched evidence references | Do not expose file content/name to unauthorized viewers |
| Notification operations | Authorized operational support | Processing failures, attempts and backlog | Separate operational details from business-user views |
| Records/hold oversight | Authorized records/legal roles | Archive/hold/disposition events | Sensitive hold details restricted |

A report audience is not granted merely by a job title, project membership or possession of a URL. Exact capabilities and scope remain governed by DD-02 and the approved authority matrix.

## 6. Search and retrieval behavior

Candidate searchable dimensions, subject to field-level authorization:
- official RFI number and explicitly authorized aliases;
- project and permitted party/discipline context;
- authorized subject/question terms;
- lifecycle stage and cycle reference;
- authorized assignment, technical lead or reviewer;
- submission, clarification, issue and closure date ranges;
- linked RFI / revision / Transmittal references;
- permitted response and evidence metadata.

Search requirements:
1. Apply authorization before returning results, snippets, suggestions, counts, facets or ranking features.
2. Do not disclose that a hidden record exists through “no result” differences, autocomplete, exact-number lookup, related-record suggestions or aggregate totals.
3. Search only fields and attachments the actor is entitled to discover; full-text indexing must respect source-level and field-level restrictions.
4. Recheck authorization on result open, preview, download, linked-record navigation and export; search-time entitlement is not a durable access grant.
5. Do not include draft records in external-party results unless a specific approved oversight/party rule permits it. PM read-only visibility follows DEC-021 and does not grant editing, review or issue authority.
6. Do not use notification read state, user-entered labels or cached client status as searchable workflow truth.
7. Preserve exact historical cycle/version references in results; clearly distinguish current and historical records.
8. Unauthorized or ambiguous searches fail closed without revealing protected field names, attachment names, recipients or counts.

Search indexing technology, refresh latency, ranking, stemming/language behavior, OCR inclusion, exact-match precedence and pagination remain open architecture/product decisions.

## 7. Filters, facets, counts and aggregates

- Facets and counts are themselves disclosures and must be authorized at the same granularity as the underlying records.
- Apply permission filters before aggregation; do not compute global counts and hide only the rows afterward.
- Avoid differencing attacks through small counts, repeated filter combinations or time-series comparisons. Thresholding/suppression policy, if needed, requires explicit privacy/security review.
- A zero count must not be used to distinguish “no records” from “records exist but are not visible” where that would leak metadata.
- Saved filters preserve query intent, not an entitlement; evaluate the current actor's permissions on every execution.
- Exported facet/count snapshots must record the exact filter and as-of context.
- No performance league table or individual response-time ranking is approved.

## 8. Metric dictionary and calculation contract

Before a metric is implemented, define:
- stable metric ID and owner;
- business question and non-purpose;
- authoritative source tables/events/fields (conceptual here; no schema approved);
- counting unit and distinctness key;
- numerator, denominator and aggregation;
- included/excluded states, parties, cycles and test/demo records;
- treatment of reopened, cancelled, withdrawn and superseded RFIs;
- period boundary, timezone, as-of cut-off and timestamp semantics;
- target-date source and authority, if applicable;
- permission scope and suppression behavior;
- refresh/freshness expectation and reconciliation tolerance;
- versioned definition and test evidence.

Candidate examples:
- **Open RFIs:** count distinct official RFI identities whose authoritative current lifecycle is not technically closed, with exact treatment of withdrawn/cancelled states still subject to final lifecycle design.
- **Open assignments:** count current active assignments, not unique RFIs.
- **Required acknowledgement completion:** use only Required recipients under DEC-103; Optional/Not Requested are excluded; zero Required recipients = Not Required, not 100% complete by implication.
- **Delivery outcome:** recipient-level outcomes aggregate to Delivered only when all intended recipients succeed, Partially Delivered when some succeed and some fail, Failed when all fail; unknown remains unknown.
- **Overdue:** only where an approved target-date rule exists; requested date alone is not an SLA or overdue trigger.
- **Cycle duration:** report each cycle separately; do not combine reopened cycles into a single unlabeled duration.

These examples are candidate definitions to be reconciled with final lifecycle and reporting authority; they are not production-ready formulas.

## 9. Time, dates and as-of semantics

- Preserve source timestamps for each event; do not overwrite submission, assignment, contribution, clarification, review, issue, dispatch, delivery, acknowledgement, reopening or closure times.
- Every period-based report identifies timezone, inclusive/exclusive boundaries and as-of cut-off.
- Distinguish event time from ingestion/index time and report-generation time.
- Requested response date is informational. A target date is usable only when its approved project rule, owner and source are identified.
- No default timezone, working calendar, SLA, pause-clock, deadline or contractual consequence is created.
- Historical/as-of reports must use events and versions known at the selected cut-off, not current values projected backward.
- If source timestamps or timezone context are unavailable, mark the metric unavailable or disclose the limitation; do not guess.

## 10. Dashboard and drill-down requirements

Candidate dashboard design:
- separate panels for lifecycle, assignments/workload, cycle aging/target monitoring, recipient communications and records exceptions;
- every KPI exposes its unit and definition;
- each chart/table has a permission-safe drill-down to the exact supporting population;
- filters preserve project, party, discipline, cycle, period and as-of context;
- no chart creates a new workflow state or authority;
- no aggregate may disclose hidden draft subjects, parties, recipients, attachment names or restricted activity;
- dashboard cache must not outlive authorization changes in a way that permits disclosure; exact invalidation/freshness mechanism remains open.

Dashboard totals must reconcile to the underlying authorized result population, not to a global population from which rows are hidden after calculation.

## 11. Export specification and safeguards

Export formats and delivery mechanisms are not selected. Before approving any format, define:
- permitted purpose and authorized requester/audience;
- exact records, fields, attachments and historical versions included;
- filters, sort order, counting units, timezone, period and as-of cut-off;
- current authorization checks at request, generation and retrieval;
- treatment of partial/blocked fields and inaccessible linked records;
- output classification, watermark/handling notice where approved, and integrity reference;
- generation timestamp, requester, authority context, metric/report definition version and source references;
- export event audit and controlled storage/access/expiry;
- retention, legal hold, backup and disposition requirements;
- failure, retry, cancellation and cleanup behavior.

An export is a snapshot, not a live view. It must not silently update when source records change. Regeneration creates a new export identity/version with a traceable relationship. A recipient's access to an export does not imply access to source records or linked attachments. Once a copy is downloaded or forwarded, SiteDocs cannot claim to recall or erase it.

No default CSV/XLSX/PDF format, public link, scheduled email, external distribution, BI connector or bulk download is approved.

## 12. Historical versions, linked records and cross-family boundaries

- Preserve official RFI identity, cycles, revisions, exact question/response snapshots, contributions, reviews and issue events.
- Reopening is a new cycle under the same official RFI identity; it is not a second unique RFI for identity-level counts.
- Clarification rounds, formal revisions, linked new RFIs, response versions and Transmittals remain separate dimensions and identifiers.
- Linked WIR/MQR/MOM or other records require independent authorization; access to an RFI does not cascade.
- A report may show a safe relationship indicator only where authorized; it must not reveal the linked record's protected contents or existence.
- Superseded or withdrawn versions remain historically distinguishable and must not be silently replaced by the latest version.
- Archival is separate from technical closure and does not imply deletion or broader access.

## 13. Recipient communications and DEC-103 reconciliation

Reporting must keep separate:
- Transmittal dispatch and package identity;
- recipient-level delivery outcomes;
- access/open/download evidence;
- Required acknowledgement requests and submissions;
- substantive recipient responses;
- source RFI technical issue/closure.

For aggregation:
- Delivered only when all intended recipients have confirmed successful delivery;
- Partially Delivered when at least one recipient succeeded and at least one failed;
- Failed when all intended recipients failed;
- unknown/unconfirmed delivery must not be presented as success;
- acknowledgement completion is calculated only against recipients explicitly marked Required;
- Optional and Not Requested are excluded; zero Required = Not Required.

Do not infer acknowledgement from access, download, mailbox read receipt, notification read state or silence. Do not infer technical acceptance, approval or closure from any communication metric.

## 14. Notification and reporting boundary

- Notification reports use DD-12's distinct units: source events, recipient notifications, channel attempts, read/open/dismiss events and open Action Required tasks.
- Notification counts and previews require current authorization and cannot disclose restricted source records.
- Reading/dismissing a notification does not resolve an action or change the RFI lifecycle.
- Escalation, overdue flags and aging indicators are oversight views only.
- Report delivery or export notification does not create recipient acknowledgement or contractual notice unless separately approved.

## 15. Privacy, security and non-disclosure controls

Mandatory design requirements:
1. Authorize at server side for every query, result, facet, count, preview, drill-down, export and file/linked-record retrieval.
2. Apply least privilege at row, field, party, project, discipline, assignment, recipient and attachment level.
3. Protect draft confidentiality and PM read-only boundaries.
4. Prevent inference via small counts, autocomplete, exact-ID lookup, timing, error messages, hidden filters, recipient aggregates and file metadata.
5. Recheck access after revocation and on every export retrieval/download; old URLs and cached results do not bypass current authorization.
6. Restrict audit/export access to authorized roles; privileged access and denials remain attributable.
7. Do not place sensitive question/response text, recipient lists, attachment names, legal-hold details or security findings into ordinary logs or report previews.
8. Use synthetic or appropriately controlled non-production data for security testing; no live production data tests are authorized by this draft.

Any unauthorized disclosure, cross-party leakage, unauthorized export or false lifecycle/recipient metric is an acceptance blocker under the DEC-110 framework.

## 16. Audit, reproducibility and records controls

Every generated report/export should record, as applicable:
- requester identity and authority context;
- report/metric definition and version;
- selected fields, filters, sort, grouping and counting unit;
- project/party/discipline scope;
- timezone, period and as-of cut-off;
- generation timestamp and source data/version references;
- authorization scope/result and any suppressed/unavailable fields;
- output identity/version and integrity reference;
- access/download events and controlled disposition references.

Preserve sufficient lineage to reproduce or explain a result. A corrected report creates a new version and does not rewrite source records or prior exports. Retention duration, archive tier, legal-hold authority, export expiry and deletion are unresolved and must not be invented. Backups, replicas, caches and downloaded copies have separately governed lifecycles.

## 17. Failure, reconciliation and acceptance scenarios

Proposed non-production scenarios under DEC-110:
1. unauthorized actor cannot enumerate a record through list, exact-ID search, autocomplete, facets, counts or linked suggestions;
2. draft and confidential fields do not leak through dashboard totals, chart labels, search snippets or export metadata;
3. current authorization is rechecked after revocation and before preview/export download;
4. PM read-only access does not expose editing, review, issue or restricted fields;
5. report population reconciles to authoritative source records at its declared as-of cut-off;
6. RFI identity count differs correctly from cycle, assignment, contribution, response, Transmittal and recipient counts;
7. reopened cycles remain separately visible without double-counting unique RFI identities;
8. requested dates do not create overdue metrics absent an approved target rule;
9. Required-only acknowledgement denominator and zero-Required behavior match DEC-103;
10. recipient delivery aggregation correctly handles all-success, mixed, all-failure and unknown outcomes;
11. historical exports remain immutable when source data later changes;
12. linked WIR/MQR/MOM records remain independently authorized;
13. small-count and filter-differencing attempts do not reveal hidden party/record metadata;
14. index lag, source inconsistency or missing fields are labelled unavailable/stale rather than inferred;
15. export retry/timeout does not create duplicate logical export or lose audit lineage;
16. report correction creates a new version and preserves prior report/export references;
17. notification read/dismissal and dashboard cache cannot alter workflow or authoritative metrics;
18. restore/recovery reconciles report definitions, source lineage, exports and access controls before availability resumes.

These are proposed test scenarios, not executed tests. Define exact expected results only after metric, authorization and lifecycle decisions are approved. Block unresolved cases rather than inventing behavior.

## 18. Open decisions and required reviewers

| Open decision | Required authority / reviewer |
|---|---|
| Final report catalogue, audience and purpose | Owner; reporting authority; Document Control |
| Exact metric dictionary, formulas and treatment of terminal states/cycles | Owner; technical/process authority; QA |
| Capability and row/field/party/discipline scope for each report | Owner; identity/security; project/party authority |
| Searchable fields, full-text/OCR scope, ranking and index refresh | Product owner; architecture; security/privacy |
| Small-count suppression and inference-risk thresholds | Security/privacy; reporting authority; owner |
| Timezone, period boundaries and target-date source rules | Owner; project controls; technical authority |
| Recipient report visibility and DEC-103 aggregate presentation | Owner; Document Control; security; records |
| Export formats, purpose controls, output classification and expiry | Owner; security/privacy; records |
| Scheduled distribution, BI integration and external recipients | Owner; contract/legal authority as applicable; security |
| Retention, legal hold, archive, backup and disposition | Records authority; legal/compliance as applicable; owner |
| Index/cache invalidation and revocation consistency targets | Architecture; security; operations |
| Test ownership, reconciliation tolerance, severity and release evidence | QA; architecture; security; records; owner under DD-15 |

## 19. Governance alignment and explicit exclusions

This draft elaborates DEC-109's reporting/search/export controls, preserves DEC-021 PM read-only oversight, applies DEC-049 notification boundaries, DEC-103 recipient delivery/acknowledgement aggregation, and DEC-104–DEC-110 lifecycle, authority, records and acceptance constraints. It does not amend those decisions or establish report entitlements, formulas, contractual effects or records schedules.

**Design-only boundary:** no dashboard/search/index/export implementation, API/UI/code, DB/schema/migration/generated types, Storage, auth/RLS/grants, BI integration, external distribution, scheduled report, production-data operation, live test, backup/restore operation, merge or deployment is authorized or performed. A separate metric/authority approval, privacy/security/records impact review, architecture plan, test plan, non-production rehearsal and explicit owner authorization are mandatory. Database/Storage work remains subject to verified backups, isolated restore/rehearsal and reconciliation gates.
