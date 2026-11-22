# DD-14 Records Lifecycle — Governance Leaf Requirements

**Document type:** Atomic governance-traceability and candidate test-mapping working draft  
**Date:** 2026-11-12  
**Status:** INITIAL LEAF BASELINE — QA / OWNER / RECORDS / LEGAL / SECURITY VALIDATION PENDING — NO TEST EXECUTION — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Primary specification:** `docs/82_RFI_RECORDS_RETENTION_ARCHIVE_LEGAL_HOLD_DISPOSITION_WORKING_DRAFT.md`  
**Cross-specification reviews:** `docs/135_DD14_RECORDS_LIFECYCLE_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md`; related DD-03/DD-04/DD-14 review in docs/126  
**DD-15 inputs:** docs/137, docs/138, docs/139 and docs/83  
**Controlling governance:** DEC-012, DEC-021, DEC-049, DEC-053, DEC-054, DEC-104, DEC-107, DEC-109, DEC-110

> Leaf IDs are traceability keys only. They do not establish a retention schedule, legal interpretation, hold authority, archive technology, destruction method or implementation approval. Candidate mappings are not test evidence.

## 1. Purpose and method

This document decomposes DD-14's records-lifecycle boundaries and the eleven findings in docs/135 into atomic traceability leaves. It deliberately distinguishes governance constraints from candidate records controls that require records/legal/security/architecture decisions.

Coverage labels:
- **Partial:** an imported scenario touches the subject but does not assert the complete leaf.
- **Candidate:** a review scenario is proposed but has not been validated as an imported test.
- **Uncovered:** no explicit imported scenario has been identified.
- **Blocked:** the expected result depends on an unresolved authority, schedule, hold instrument or technical prerequisite.

No retention period, schedule owner, legal-hold power, archive tier, destruction mechanism or backup policy is invented here.

## 2. Records lifecycle leaf requirements

| Leaf ID | Atomic invariant / traceability requirement | Authority basis | DD-14 / review location | Candidate source scenario | Coverage | Open authority / expected-result boundary |
|---|---|---|---|---|---|---|
| RFI-REC-L001 | Technical closure, withdrawal, cancellation, reopening or supersession is not, by itself, archive eligibility, retention expiry or authority to destroy a record. | DEC-104, DEC-106, DEC-109 | docs/82 §§2,4,7,13; CR-135-01 | AT-RFI-09, E2E-25 | Partial | Final lifecycle and records-series rules require owner/records approval. |
| RFI-REC-L002 | Archive is controlled preservation and retrieval; it does not change technical status, create acceptance, grant broader access or imply deletion. | DEC-109; DEC-110 | docs/82 §§2,7–9; CR-135-01 | E2E-26 | Candidate | Archive eligibility and completeness rules remain unapproved. |
| RFI-REC-L003 | Record-series classification, accountable ownership and record-set boundaries must be established by the competent records authority before retention or disposition is applied. | DEC-012, DEC-109 | docs/82 §§3,5; CR-135-01/05 | AT-RFI-06, E2E-26 | Partial | Records series, classification schedule and accountable owners are open. |
| RFI-REC-L004 | Exact historical cycles, revisions, issued response versions, evidence manifests, Transmittals, recipient events and attributable history must remain identifiable and traceable as records. | DEC-012, DEC-107, DEC-109 | docs/82 §§3–5,8,15; CR-135-05/07 | AT-RFI-06, AT-RFI-09, E2E-24 | Partial | Canonical identity, record-set grouping and retention mapping depend on DD-01/06/07/08/09/11. |
| RFI-REC-L005 | Retention duration, trigger, schedule version and applicability must come from an approved records schedule; none may be inferred from technical closure, last access, upload or supersession. | DEC-012, DEC-109 | docs/82 §§5–6; CR-135-02/05 | None identified | Uncovered | Records/legal/contract authority must approve schedules, triggers and effective-date rules. |
| RFI-REC-L006 | Retention expiry is a trigger for authorized review only; it must not cause automatic deletion or disposition. | DEC-012, DEC-109 | docs/82 §§2,6,13; CR-135-02/08 | E2E-26 | Candidate | Exact review workflow, decision authority and evidence remain open. |
| RFI-REC-L007 | Legal hold creation, amendment, scope and release require an evidenced authorized instrument and competent authority; application must fail closed when authority or scope is unclear. | DEC-012, DEC-109 | docs/82 §§10–11; CR-135-03/04 | E2E-26 | Candidate | Legal/records authority, instrument form, confidentiality and scope rules are unresolved. |
| RFI-REC-L008 | Hold scope must account for the authorized record set and applicable related copies; releasing one hold must not silently release another active hold. | DEC-012, DEC-109 | docs/82 §§10–12; CR-135-04 | E2E-26 | Candidate | Cross-record/copy scope, overlap precedence and hold reconciliation require legal/records/security approval. |
| RFI-REC-L009 | A hold or disposition restriction must not mutate the technical RFI lifecycle, assignment, response, review or recipient communication state. | DEC-104, DEC-106, DEC-108, DEC-109 | docs/82 §§4,10–13; CR-135-01/04 | E2E-24, E2E-26 | Partial | Cross-process event boundaries and acceptance evidence require QA/architecture validation. |
| RFI-REC-L010 | Historical retrieval and archive access remain subject to current authorization and applicable row-, field-, party-, project- and attachment-level restrictions. | DEC-021, DEC-105, DEC-109 | docs/82 §9; CR-135-06/10 | AT-RFI-04, E2E-26 | Partial | Historical access entitlements, linked-record scope and revocation behavior require security/owner approval. |
| RFI-REC-L011 | Recipient-held, forwarded, downloaded and externally controlled copies must be treated as distinct from copies controlled by the repository; remote recall or complete erasure must not be claimed without evidence. | DEC-103, DEC-108, DEC-109 | docs/82 §§3,12,14; CR-135-06/09 | E2E-24 | Partial | Contractual duties, recipient-copy handling and residual-copy proof remain open. |
| RFI-REC-L012 | Backup, replica, immutable media, cache and restore copies have distinct lifecycles and must be reconciled with current holds, access policy and disposition history before restored service is exposed. | DEC-109, DEC-110 | docs/82 §12; CR-135-07 | E2E-26 | Partial | Backup architecture, rotation, restore objectives, hold effects and reconciliation method are unapproved. |
| RFI-REC-L013 | Disposition requires an approved schedule/trigger basis, competent authority, required independent concurrence, scoped dependency review and retained evidence before action. | DEC-012, DEC-109, DEC-110 | docs/82 §13; CR-135-08/11 | E2E-26 | Candidate | Exact authority, concurrence matrix, eligibility gates and project/contract rules remain open. |
| RFI-REC-L014 | Destruction or deletion completion must be reported only to the extent verified; residual, recipient-held, backup or otherwise unverifiable copies prevent an unsupported complete-erasure claim. | DEC-012, DEC-109 | docs/82 §14; CR-135-09 | E2E-24, E2E-26 | Partial | Approved sanitization methods, proof standard and exception treatment remain open. |
| RFI-REC-L015 | Reclassification, schedule change and record correction must preserve prior classification, schedule version, trigger calculation and attributable change history. | DEC-012, DEC-109 | docs/82 §15–16; CR-135-02/05 | None identified | Uncovered | Records authority must approve correction/reclassification procedure and effective-date treatment. |
| RFI-REC-L016 | Restricted legal-hold or disposition metadata must not leak through ordinary search, facets, counts, notifications, exports or user interfaces. | DEC-021, DEC-049, DEC-105, DEC-109 | docs/82 §§9–11,16; CR-135-10 | AT-RFI-04, E2E-26 | Partial | Field-level classification, privacy rules and notification boundaries require security/legal/records approval. |
| RFI-REC-L017 | Each disposition attempt and outcome must be attributable, including authority, scope, schedule/trigger basis, concurrence, method, time, exceptions and verification evidence. | DEC-012, DEC-109, DEC-110 | docs/82 §§13–16; CR-135-08/09/11 | AT-RFI-06, E2E-26 | Partial | Exact audit event schema, retention and evidence requirements require records/architecture/QA review. |
| RFI-REC-L018 | Failed, partial, unauthorized or unverifiable disposition must not be represented as complete and must retain its incident/audit evidence. | DEC-012, DEC-109, DEC-110 | docs/82 §§14,16–17; CR-135-09/11 | E2E-26 | Candidate | Failure taxonomy, recovery and release criteria remain open. |

## 3. Coverage gaps and DD-15 actions

1. AT-RFI-04, AT-RFI-06, AT-RFI-09, E2E-24, E2E-25 and E2E-26 are candidate mappings only; preserve the exact source wording from docs/137.
2. No imported scenario has been identified that directly verifies approved schedule versioning, retention trigger calculation, record reclassification history or complete residual-copy reconciliation.
3. The 18 candidate scenarios in docs/135 §5 are design prompts, not imported test IDs and not evidence of coverage.
4. QA must add atomic assertions and negative cases only after the relevant records/legal/security authority supplies an approved expected result. Otherwise retain Blocked status.
5. Records/legal authority must validate the record-series and hold/disposition scope before any operational acceptance test can be authorized.

## 4. Open dependencies retained from docs/135

- Approved records series, classification, record-set boundaries and accountable ownership.
- Retention schedule authority, durations, triggers, versioning and applicability.
- Archive eligibility, completeness, package format, integrity evidence and storage tier.
- Legal-hold issuing/amending/release authority, instrument evidence, confidentiality, scope and overlap.
- Related records, evidence, Transmittals, recipient-held copies, exports and backup/replica treatment.
- Restore reconciliation, access-policy reapplication, disposition history and residual-copy exceptions.
- Disposition authority, concurrence, sanitization method, proof standard and failed/partial outcome handling.
- QA owners, synthetic fixtures, evidence retention, severity and release sign-off.

All dependencies remain open until the named authority supplies a versioned decision or instrument.

## 5. Required QA completion fields

For each leaf, QA must record: exact source version; authority class; scenario ID and exact source text; actor and capability; positive and negative assertions; approved expected-result source; synthetic fixture; record-set and copy scope; evidence artifact and retention basis; severity; reviewer; execution environment; result and defect linkage. Missing authority, schedule, hold instrument or fixture means **Blocked**, not Pass.

## 6. Relationship to existing DD-15 material

This document supplements, but does not replace, docs/137 source inventory, docs/138 scenario crosswalk, docs/139 governance coverage baseline, docs/83 acceptance catalogue, docs/126 cross-specification review or docs/135 DD-14 review. It creates no test IDs and claims no execution.

## 7. Explicit non-authorization

No archive, legal hold, retention schedule, backup/restore, deletion, destruction, disposition, permission, API/UI/code, DB/schema/migration/generated type, Storage, authentication/RLS/grant, production-data, test execution, merge, deployment or release activity is authorized by this document. No test is claimed passed. Any implementation or execution requires resolved prerequisites, required owner/specialist approvals, a separate scoped plan, approved synthetic non-production environment and explicit authorization. DB/Storage changes additionally require verified backups, isolated restore/rehearsal and reconciliation.
