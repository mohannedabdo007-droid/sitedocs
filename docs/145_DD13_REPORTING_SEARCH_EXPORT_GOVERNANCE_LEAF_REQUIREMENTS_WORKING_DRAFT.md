# DD-13 Reporting, Search and Export — Governance Leaf Requirements

**Document type:** Atomic governance-traceability and candidate test-mapping working draft  
**Date:** 2026-11-12  
**Status:** INITIAL LEAF BASELINE — QA / OWNER / SPECIALIST VALIDATION PENDING — NO TEST EXECUTION — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Primary specification:** `docs/81_RFI_REPORTING_SEARCH_EXPORT_SPECIFICATION_WORKING_DRAFT.md`  
**Cross-specification review:** `docs/134_DD13_REPORTING_SEARCH_EXPORT_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md`  
**DD-15 inputs:** docs/137, docs/138, docs/139 and docs/83  
**Controlling governance:** DEC-021, DEC-049, DEC-103, DEC-104–DEC-110

> Leaf IDs are traceability keys only. They do not create new DEC decisions, approve candidate formulas or entitlements, or authorize implementation. Scenario mappings are candidate references, not evidence of coverage or execution.

## 1. Purpose and method

This document decomposes the existing DD-13 specification and its ten cross-specification findings into independently reviewable traceability leaves. It keeps approved governance constraints separate from unresolved design detail.

Coverage labels:
- **Partial:** an imported AT-RFI/E2E scenario touches the subject but does not assert the complete leaf.
- **Candidate:** a cross-review scenario is proposed, but no imported scenario explicitly proves the leaf.
- **Uncovered:** no explicit imported scenario has been identified.
- **Blocked:** expected behavior depends on an unresolved authority, formula, threshold or technical prerequisite.

No candidate report formula, audience entitlement, privacy threshold, timezone, export format or retention period is treated as approved by this matrix.

## 2. Reporting, search and export leaf requirements

| Leaf ID | Atomic invariant / traceability requirement | Authority basis | DD-13 / review location | Candidate source scenario | Coverage | Open authority / expected-result boundary |
|---|---|---|---|---|---|---|
| RFI-RPT-L001 | Reports, dashboards, search indexes, caches and exports are derived views; authoritative RFI records and attributable event history remain the source of truth. | DEC-109; DEC-110 | docs/81 §§2–3,16; CR-134-05 | AT-RFI-06, AT-RFI-11 | Partial | DD-01/07 source-event contract and reconciliation rules remain pending. |
| RFI-RPT-L002 | A metric must identify its counting unit and must not silently substitute RFI identity, cycle, assignment, contribution, response, review, Transmittal, recipient or event counts for one another. | DEC-104–DEC-110; DEC-110 | docs/81 §§4,8; CR-134-02 | AT-RFI-11 | Partial | Exact metric catalogue, formulas and terminal-state treatment require owner/QA approval. |
| RFI-RPT-L003 | Reopened cycles remain traceable as separate cycles without double-counting the unique parent RFI identity. | DEC-104, DEC-106, DEC-109 | docs/81 §§4,8,12; CR-134-02 | AT-RFI-11 | Partial | Final lifecycle/cycle model and formula remain dependent on DD-01/DD-11. |
| RFI-RPT-L004 | Withdrawn, cancelled, superseded and other terminal/exceptional records must follow an approved lifecycle-based metric rule; unresolved cases must not be assigned an invented default. | DEC-104, DEC-106, DEC-109, DEC-110 | docs/81 §§8–9; CR-134-02 | AT-RFI-11 | Blocked | Exact terminal-state formulas and authoritative status dictionary remain open. |
| RFI-RPT-L005 | Search results, exact-ID lookup, autocomplete, snippets, facets, counts and empty states must not disclose records or metadata outside the actor's current authorized scope. | DEC-021, DEC-105, DEC-109 | docs/81 §§6–7,15; CR-134-01/03/04/09 | AT-RFI-04 | Partial | Report-by-report row/field/party/project/discipline entitlements and privacy controls require security/owner approval. |
| RFI-RPT-L006 | Aggregates and counts must be computed from the authorized population; hiding unauthorized rows only after global aggregation is not an acceptable substitute. | DEC-021, DEC-105, DEC-109 | docs/81 §§7,15; CR-134-01/03 | AT-RFI-04 | Partial | Exact entitlement matrix and aggregate implementation remain open. |
| RFI-RPT-L007 | Repeated or overlapping filters, small populations and time-series comparisons must not be used to infer protected records or small-count values. | DEC-021, DEC-109 | docs/81 §15; CR-134-03 | None identified | Uncovered | Suppression thresholds, differencing controls and reporting authority are unapproved. |
| RFI-RPT-L008 | Authorization must be current at each relevant search, preview, drill-down, export request and export retrieval; stale index/cache state must not preserve revoked access. | DEC-021, DEC-105, DEC-109 | docs/81 §§6,11,15; CR-134-04 | AT-RFI-04, E2E-27 | Partial | Revocation/cache/index consistency targets and failure behavior require security/architecture/operations approval. |
| RFI-RPT-L009 | A report described as historical or as-of must declare and consistently apply its event-time basis, timezone, period boundary, source snapshot and cut-off. | DEC-109, DEC-110 | docs/81 §§8–9,16; CR-134-05 | AT-RFI-12, E2E-27 | Partial | Timezone/calendar policy, date source and index-lag bounds remain open. |
| RFI-RPT-L010 | A stale, incomplete or unreconciled derived view must not be presented as current and complete when source lineage or reconciliation cannot be established. | DEC-109, DEC-110 | docs/81 §§3,16–17; CR-134-05/07 | E2E-27 | Partial | Freshness bounds, tolerances, ownership and unavailability states require approval. |
| RFI-RPT-L011 | Recipient delivery and acknowledgement reporting must preserve recipient-level semantics; delivery, read/access and acknowledgement are not interchangeable. | DEC-103, DEC-108, DEC-109 | docs/81 §§13–14; CR-134-08 | AT-RFI-13 | Partial | DEC-103 recipient aggregation and exact report presentation require QA/Document Control validation. |
| RFI-RPT-L012 | Required-only acknowledgement denominators and zero-Required cases must follow DEC-103; optional recipients must not silently inflate the required denominator. | DEC-103 | docs/81 §13; CR-134-08 | AT-RFI-13 | Partial | Exact expected-result assertions and fixtures remain to be authored by QA. |
| RFI-RPT-L013 | Export generation must preserve a versioned snapshot and audit lineage; source changes must not silently mutate an already generated export. | DEC-109, DEC-110 | docs/81 §§11,16; CR-134-06/10 | E2E-27 | Partial | Export identity/version, purpose, format, classification, expiry and retention require owner/security/records decisions. |
| RFI-RPT-L014 | Export request, generation and retrieval are distinct controlled actions, each subject to applicable current authorization and audit evidence. | DEC-021, DEC-105, DEC-109 | docs/81 §§11,15–16; CR-134-01/04/06 | AT-RFI-04, E2E-27 | Partial | Exact export capabilities, field scope and separate export-record access remain open. |
| RFI-RPT-L015 | Linked-record existence or metadata (including WIR, MQR, MOM and related RFI records) must not be inferred or disclosed without independent authorization for the linked record. | DEC-021, DEC-105, DEC-109 | docs/81 §12; CR-134-09 | AT-RFI-04 | Partial | Cross-family relationship visibility and field-level authorization remain open. |
| RFI-RPT-L016 | Export retry, correction or regeneration must preserve logical identity and prior versions; a retry must not create duplicate logical exports or erase audit lineage. | DEC-109, DEC-110 | docs/81 §§11,16–17; CR-134-10 | E2E-27 | Candidate | Idempotency, retry outcome, correction identity and reconciliation contract depend on DD-07/architecture. |

## 3. Coverage gaps and DD-15 actions

1. AT-RFI-02, AT-RFI-04, AT-RFI-11, AT-RFI-12, AT-RFI-13 and E2E-27 are candidate source mappings only; their exact source wording must be preserved from docs/137.
2. The current imported scenario set does not explicitly establish small-count/differencing protection, export retry identity, correction-version lineage or all index/cache revocation paths.
3. The 18 candidate scenarios in docs/134 §5 are review prompts, not imported test IDs and not proof of coverage.
4. QA must create atomic assertions, negative cases, actor/capability context, approved expected results, synthetic fixtures, severity and retained evidence. Do not expand the scope of an imported scenario silently.
5. Every leaf must be classified as approved governance, candidate detailed rule or blocked prerequisite before it is promoted into a test baseline.

## 4. Open dependencies retained from docs/134

- Report audience, purpose and exact row/field/party/project/discipline entitlements.
- Metric dictionary, formulas, cycle/terminal-state treatment and metric ownership.
- Searchable fields, full-text/OCR scope, ranking, indexing and refresh.
- Small-count suppression and differencing-risk thresholds.
- Timezone, calendar, period-boundary and date-source rules.
- Export purpose, format, field selection, classification, expiry, retention and residual-copy treatment.
- Index/cache invalidation, revocation consistency, reconciliation tolerances and stale/unavailable behavior.
- QA ownership, acceptance thresholds, severity and release evidence.

All dependencies remain open until the named authority supplies a versioned decision or instrument.

## 5. Required QA completion fields

For each leaf, QA must record: exact source version; authority class; scenario ID and exact source text; actor and capability; positive and negative assertions; approved expected-result source; synthetic fixture; evidence artifact and retention basis; severity; reviewer; execution environment; result and defect linkage. Missing authority or fixture means **Blocked**, not Pass.

## 6. Relationship to existing DD-15 material

This document supplements, but does not replace, docs/137 source inventory, docs/138 scenario crosswalk, docs/139 governance coverage baseline, docs/83 acceptance catalogue or docs/134 cross-specification review. It creates no test IDs and claims no execution.

## 7. Explicit non-authorization

No report, search, index, dashboard, export, scheduled distribution, BI integration, permission, API/UI/code, DB/schema/migration/generated type, Storage, authentication/RLS/grant, production-data, archive, backup/restore, test execution, merge, deployment or release activity is authorized by this document. No test is claimed passed. Any implementation or execution requires resolved prerequisites, required owner/specialist approvals, a separate scoped plan, approved synthetic non-production environment and explicit authorization.
