# DD-13 Reporting, Search and Export — Cross-Specification Review Working Draft

**Document type:** Non-authoritative document-level review  
**Date:** 2026-11-12  
**Status:** REVIEW FINDINGS — OWNER / SPECIALIST VALIDATION PENDING — NOT GOVERNANCE APPROVAL — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Primary specification:** `docs/81_RFI_REPORTING_SEARCH_EXPORT_SPECIFICATION_WORKING_DRAFT.md`  
**Related specifications:** DD-01/02/06/07/08/09/10/11/12/14/15  
**Controlling governance:** DEC-021, DEC-049, DEC-103, DEC-104–DEC-110

> This review checks internal consistency and cross-specification boundaries. It does not approve report entitlements, metric formulas, index technology, privacy thresholds, export formats, retention schedules or implementation.

## 1. Review objective and scope

Review DD-13 against the controlling governance and adjacent detailed specifications for:
- authoritative source lineage and distinct counting units;
- lifecycle, cycle and terminal-state treatment;
- current authorization across search, aggregates, drill-downs and exports;
- privacy and inference through counts/facets;
- recipient communication and notification metrics;
- historical/as-of reproducibility and export snapshots;
- records, retention, recovery and acceptance evidence.

The review is limited to the document text and the related working drafts available on the stated branch. It is not a security assessment, legal/records opinion, architecture approval or test execution.

## 2. Executive outcome

DD-13 is structurally comprehensive and directionally consistent with DEC-021, DEC-049, DEC-103 and DEC-109, and with the separation principles in DD-09–DD-12 and DD-14. The reviewed specification correctly treats dashboards/search/indexes/exports as derived views, requires current server-side authorization, distinguishes counting units, preserves historical versions and prohibits unsupported inferences.

No direct contradiction with the owner-confirmed governance baseline was identified in the reviewed text. However, the specification is not implementation-ready. The most consequential open matters are:
1. exact audience/capability/field entitlements for each report and search dimension;
2. authoritative formulas and lifecycle treatment for withdrawn, cancelled, reopened and superseded records;
3. privacy controls against small-count and repeated-filter differencing;
4. source/index/cache freshness, revocation consistency and as-of reproducibility;
5. export purpose, output classification, field selection, expiry and residual-copy handling;
6. metric ownership, reconciliation tolerances and acceptance thresholds.

## 3. Cross-specification control matrix

| Control area | DD-13 proposal | Controlling / adjacent rule | Review result |
|---|---|---|---|
| Source of truth | Authoritative records and append-only events; derived indexes reconcile to source | DEC-109 requires authoritative records/history; DD-01/07 define lifecycle and transaction source | Aligned; exact source/event contract remains dependent on DD-01/07 |
| Identity/counting | RFI, cycle, assignment, contribution, response, review, Transmittal, recipient and event are distinct units | DD-01/05/06/09/10/11/12 preserve separate identities and lifecycle dimensions | Aligned; each published metric still needs a stable distinctness key |
| PM oversight | PM read-only visibility follows DEC-021 and does not imply editing/review/issue authority | DEC-021 and DD-02 capability boundary | Aligned; exact field-level PM view still requires entitlement matrix |
| Search authorization | Filter before results, snippets, autocomplete, facets and counts; recheck on open/export | DEC-109 server-side authorization; DD-08/09/12 access checks | Aligned as requirement; no implementation or security validation claimed |
| Aggregates/privacy | Permission filter before aggregation; small-count/differencing safeguards | DEC-109 prevents metadata leakage; DD-12 protects counts and previews | Aligned; threshold/suppression policy intentionally unresolved |
| Recipient communication | Separate dispatch, delivery, access, Required acknowledgement and substantive response | DEC-103, DEC-108; DD-09/10 | Aligned; do not mix acknowledgement denominator or infer acknowledgement from read/access |
| Notification metrics | Separate source events, notifications, attempts, read/dismiss and Action Required tasks | DD-12 | Aligned; notification metrics must not become lifecycle metrics |
| Historical cycles | Reopened cycle separately reported under same official RFI identity | DEC-106; DD-11 | Aligned; exact cycle count and current-cycle selection formulas await DD-01 |
| Dates/as-of | Event time, ingestion/index time and report time separated; timezone/as-of declared | DEC-109 prohibits default SLA/date consequence; DD-12/14 records lineage | Aligned; project timezone/calendar/target rules remain open |
| Export | Immutable snapshot with new identity/version on regeneration; current auth at request/generation/retrieval | DD-08 evidence controls; DD-14 retention/hold; DEC-109 records | Aligned; secure storage, expiry, classification and residual copies need approval |
| Linked records | Independent authorization for WIR/MQR/MOM and related RFIs | Document-family separation and DEC-109 | Aligned; safe relationship indicators need exact field rules |
| Recovery | Reconcile source, report definitions, exports and access controls before restore availability | DD-07/08/14/15 | Directionally aligned; operational recovery sequence and evidence remain unapproved |

## 4. Detailed review findings

### CR-134-01 — Report audience and entitlement matrix

The report catalogue uses candidate audience descriptions, appropriately disclaiming entitlement by title or membership. Before implementation, every report/view needs a field-level entitlement matrix identifying actor capability, project/party/discipline scope, record population, draft visibility, sensitive fields, attachments, recipient data and permitted drill-down/export actions.

**Required authority/reviewers:** Owner; reporting authority; DD-02 identity/security; project/party authority; Document Control.

### CR-134-02 — Terminal-state and cycle formulas

The candidate “Open RFIs” example explicitly leaves withdrawn/cancelled treatment unresolved. This is correct, but every lifecycle metric must specify whether it counts unique RFI identities, active cycles, terminal cycles or current parent state, and how reopening, cancellation, withdrawal, supersession and linked-new-RFI relationships affect numerator and denominator.

Do not resolve terminal-state semantics in the reporting layer; derive them only from the approved DD-01 transition model and DD-11 action outcomes.

**Required authority/reviewers:** Owner; technical/process authority; Document Control; QA.

### CR-134-03 — Small-count and differencing protection

DD-13 identifies differencing attacks and leaves suppression thresholds open. The eventual design must consider repeated queries over overlapping filters, time-series comparisons, exports, drill-downs, recipient/discipline dimensions and combinations of individually safe facets. A fixed universal threshold must not be invented; suppression, coarsening or query controls require privacy/security review and documented utility impact.

**Required reviewers:** Security/privacy; reporting authority; owner; QA.

### CR-134-04 — Authorization freshness across derived layers

Search-time access is not a durable grant. Define revocation behavior for indexes, autocomplete caches, dashboard caches, saved filters, precomputed aggregates, report snapshots and generated exports. Distinguish current access to source records from authorized access to a previously generated immutable export; an export is a separate controlled record with its own access and disposition rules.

**Required reviewers:** Architecture; security; operations; records authority.

### CR-134-05 — As-of reproducibility and index lag

DD-13 correctly distinguishes event time, ingestion/index time and report-generation time. A metric's as-of definition must specify whether it reflects source event-time truth known at cut-off, the index snapshot available at generation, or a reconciled source snapshot. If lag or reconciliation exceeds an approved bound, label stale/unavailable rather than silently presenting a current-looking result.

**Required reviewers:** Architecture/data; reporting authority; QA; records.

### CR-134-06 — Export scope, classification and residual copies

The export snapshot model is sound. Before approval, define purpose-bound fields and attachments, recipient/audience, classification, watermark/handling controls if required, generation and retrieval authorization, output storage, expiry, legal hold, backup/replica lifecycle, audit evidence and incident response. A downloaded/forwarded copy cannot be recalled by assertion; no UI status should claim erasure outside verified controlled copies.

**Required authority/reviewers:** Owner; security/privacy; records/legal/contract authority; architecture; operations.

### CR-134-07 — Metric ownership and reconciliation tolerances

Every metric requires a named owner, versioned formula, population, distinctness key, exclusions, timezone/as-of semantics, authorization scope, freshness target and reconciliation tolerance. These values are not currently approved. QA must verify calculations against authoritative synthetic fixtures, including multi-cycle/multi-assignment cases and partially delivered recipient populations.

**Required reviewers:** Reporting authority; owner; QA; architecture/data.

### CR-134-08 — Recipient and notification metric isolation

Preserve DEC-103 exactly: delivery is recipient-level before aggregate; acknowledgement completion denominator includes only explicitly Required recipients; zero Required means Not Required. Access/open/download, mailbox receipts and notification read state are not acknowledgement. DD-12 notification units remain distinct from Transmittal recipient units and source RFI lifecycle units.

**Review result:** Aligned; maintain explicit negative acceptance tests.

### CR-134-09 — Linked-record metadata and relationship inference

Independent authorization is required not only for linked WIR/MQR/MOM content but also for relationship existence, identifiers, counts, labels, dates and navigation suggestions. The specification should not expose a “related record exists” indicator unless that relationship metadata itself is authorized.

**Required reviewers:** Security/privacy; document-family owners; architecture; QA.

### CR-134-10 — Export retry and report correction identity

DD-13 requires immutable report/export versions and duplicate-safe retries. DD-07 must define idempotency scope and timeout-after-success behavior. A correction must create a new report/export version with explicit supersession/correction relationship, preserving the original audit trail; do not overwrite a previously generated artifact or imply that prior recipients' copies changed.

**Required reviewers:** Architecture; records; security; QA.

## 5. Candidate acceptance scenarios for DD-15 mapping

1. A user cannot infer hidden records through exact-ID lookup, autocomplete, facets, zero-count behavior or linked-record suggestions.
2. Dashboard aggregates are calculated only from the authorized population, not global totals with rows hidden afterward.
3. Current permissions are rechecked after revocation across index, cache, preview, drill-down and export retrieval.
4. PM read-only visibility does not grant editing, review, issue or access to fields outside the approved oversight scope.
5. Unique RFI counts remain distinct from cycle, assignment, contribution, response, Transmittal and recipient counts.
6. Reopened cycles remain separately traceable while unique RFI identity is not double-counted.
7. Withdrawn/cancelled treatment follows the approved lifecycle formula; unresolved cases remain blocked.
8. Repeated overlapping filters and time-series comparisons do not reveal protected small populations.
9. Index lag, stale cache, missing source lineage or reconciliation mismatch is visibly unavailable/stale under approved bounds.
10. Historical/as-of report uses its declared event-time, timezone, source snapshot and cut-off consistently.
11. Required-only acknowledgement and zero-Required semantics match DEC-103; access/read is not acknowledgement.
12. Recipient delivery aggregate handles all-success, mixed, all-failure and unknown without false success.
13. Export snapshot remains unchanged after source updates; regeneration creates a new identity/version.
14. Export request, generation and retrieval each enforce the applicable current authorization and separate export-record access.
15. Linked WIR/MQR/MOM and related RFI existence/metadata remain independently authorized.
16. Export timeout/retry does not create duplicate logical exports or lose audit lineage.
17. Report correction preserves prior version and identifies the correction relationship.
18. Restore/recovery reconciles source lineage, metric definitions, export records and access policy before restored service is exposed.

These are proposed scenarios only; no tests were executed. Map each to an approved requirement, actor/capability, exact expected outcome, synthetic fixture and retained evidence under DEC-110/DD-15.

## 6. Open decisions and review ownership

| Open decision / evidence | Required authority / reviewers |
|---|---|
| Report catalogue, audience, purpose and field-level entitlement | Owner; reporting authority; DD-02 identity/security; Document Control |
| Metric IDs, formulas, terminal-state treatment and distinctness keys | Owner; technical/process authority; reporting authority; QA |
| Searchable fields, OCR/full-text scope, ranking and index refresh/freshness | Product owner; architecture; security/privacy |
| Small-count suppression, differencing and inference controls | Security/privacy; reporting authority; owner |
| Timezone, period boundaries, as-of semantics and target-date source | Owner; project controls; technical authority |
| Recipient report fields and DEC-103 presentation | Owner; Document Control; security; records |
| Export format, purpose, classification, watermark, storage, expiry and audience | Owner; security/privacy; records/legal/contract; architecture |
| Cache/index invalidation and revocation consistency target | Architecture; security; operations |
| Retention, archive, legal hold, backup and disposition | Records authority; legal/compliance as applicable; owner |
| Reconciliation tolerances, test ownership, severity and release evidence | QA; architecture/data; security; records; owner |

Unresolved items remain **Blocked — Pending Authority Decision / Prerequisite**. No threshold, formula, format, audience or operational value is set by this review.

## 7. Disposition and backlog action

- DD-13 is **directionally consistent** with the reviewed governance and adjacent specification boundaries.
- CR-134-01 through CR-134-10 are candidate review findings, not approved changes or owner decisions.
- Keep DD-13 as the primary working specification; do not create a duplicate DD-13 document or silently change its candidate formulas.
- Link this review in the DD backlog and make it the next owner/specialist disposition task.
- Reconcile DD-13 only after specific owner/security/records/architecture decisions are recorded.
- Map acceptance scenarios into DD-15 after expected behavior and authorities are approved.

## 8. Explicit non-authorization

This review authorizes no report/dashboard/search/index/export implementation, API/UI/code, DB/schema/migrations/generated types, Storage, auth/RLS/grants, BI integration, scheduled distribution, external report delivery, production-data operation, live test, backup/restore, archive, legal hold, disposition, merge or deployment. A separate implementation plan, privacy/security/records review, architecture design, test plan, non-production rehearsal and explicit owner authorization remain mandatory.
