# RFI Detailed Specification Backlog

**Document type:** Non-authoritative planning backlog  
**Date:** 2026-11-12  
**Status:** WORKING — FOR REVIEW — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Controlling governance baseline:** `governance/scan-lifecycle-design-2026-11-11`  
**Approved policy decisions:** DEC-104–DEC-110  
**Parent assessment:** `docs/70_RFI_DESIGN_CLOSEOUT_AND_IMPLEMENTATION_READINESS.md`

> This backlog decomposes the remaining detailed-design dependencies after owner confirmation of Packages A–F. It does not amend approved policy, approve unresolved values, grant permissions, or authorize implementation. Items affecting consequential behavior remain blocked until the relevant decision authority approves their specification.

## 1. Backlog rules

1. Preserve the distinction between owner-approved policy direction and unapproved technical/detail specifications.
2. Every work item must cite its controlling decision(s), identify the required decision authority, record assumptions and unresolved questions, and define its acceptance evidence.
3. A blocked item must remain blocked; no developer default, UI label, provider behavior or existing data pattern may silently resolve it.
4. Any proposed change to DEC-104–DEC-110 or the cross-document baseline returns for explicit owner decision and governance reconciliation.
5. This backlog is a planning artifact only. No API/UI/code, DB/schema/migration/generated types, Storage, auth/RLS/grants, provider integration, production-data operation, live test, backup/restore, merge or deployment is authorized.

## 2. Work item register

| ID | Workstream | Priority / sequence | Controlling decisions | Required authority / reviewers | Main output | Blocking dependency |
|---|---|---|---|---|---|---|
| RFI-DD-01 | Lifecycle state and transition model | P0 — first | DEC-104, DEC-106, DEC-109, DEC-110 | Owner; technical/process authority; Document Control; security reviewer | State dictionary, transition matrix, guards, terminal semantics, event catalogue and parent/child aggregation | No implementation until all consequential transitions and authorities are explicit |
| RFI-DD-02 | Capability and appointment model | P0 — parallel with DD-01 | DEC-104, DEC-105, DEC-106, DEC-109 | Owner; identity/security authority; project/party authority | Capability catalogue, appointment records, grant/revoke, scope, delegation, expiry and deny matrix | No grants or role mapping until approved and security-reviewed |
| RFI-DD-03 | Discipline, technical lead and conflict handling | P0 — depends on DD-02 | DEC-104, DEC-105 | Owner; discipline authorities; technical authority | Discipline responsibility matrix, technical-lead appointment, tie-break and conflict-disposition procedure | Technical conflict cannot be resolved by coordinator or inferred role |
| RFI-DD-04 | Independent review and separation of duties | P0 — depends on DD-02/DD-03 | DEC-104, DEC-105, DEC-110 | Owner; technical/risk authority; quality/security reviewers | Risk/authority matrix, review triggers, self-review deny cases and reviewer substitution rules | Mandatory review gate remains unresolved until approved |
| RFI-DD-05 | Clarification/revision/linked-new-RFI classification | P0 — initial draft prepared; review after DD-01/authority alignment | DEC-002, DEC-022-A/B, DEC-104, DEC-106, DEC-107, DEC-110 | Owner; technical authority; Document Control; document-family governance | Decision tree, materiality criteria, examples, version and linkage rules in `docs/73_RFI_CLARIFICATION_REVISION_CLASSIFICATION_WORKING_DRAFT.md` | Exact controlled-content fields, RFI return/correction applicability and authority mapping remain open; no classification may mutate an issued/submitted snapshot |
| RFI-DD-06 | Official numbering and legacy reconciliation | P0 — initial detailed draft prepared; owner / Document Control / records review pending | DEC-002, DEC-004/005, DEC-022-A/B, DEC-023, DEC-104, DEC-107, DEC-110 | Owner; Document Control; data/records authority; architecture/security reviewers | Numbering lifecycle, display-pattern criteria, uniqueness questions, source inventory, collision model, legacy mapping and allocator requirements in `docs/74_RFI_OFFICIAL_NUMBERING_AND_LEGACY_RECONCILIATION_WORKING_DRAFT.md` | Final display pattern, uniqueness boundary, complete source inventory and collision dispositions remain open; no allocator, sequence reservation or migration until approved reconciliation |
| RFI-DD-07 | Concurrency, idempotency and transaction contract | P0 — initial detailed draft prepared; architecture/security/records review pending | DEC-022-A/B, DEC-104, DEC-106, DEC-107, DEC-110 | Architecture/engineering; data/security reviewers; records authority; owner approval for behavior | Command envelope, idempotency/replay semantics, aggregate versioning, atomic boundaries, race catalogue, failure recovery, event ordering and acceptance scenarios in `docs/75_RFI_CONCURRENCY_IDEMPOTENCY_TRANSACTION_INTEGRITY_WORKING_DRAFT.md` | Exact key scope/retention, transaction and lock strategy, final state guards, event/outbox architecture and recovery mechanics remain open; no state-changing implementation |
| RFI-DD-08 | Attachment and evidence security | P0 — before Storage design | DEC-021, DEC-051, DEC-053, DEC-104, DEC-107, DEC-109, DEC-110 | Security; records authority; owner | File policy, integrity verification, scanning/quarantine, encryption, access, retention and recovery requirements | No upload, preview, download, replacement or deletion implementation |
| RFI-DD-09 | Recipient classes, identity and distribution channel | P0 — before provider integration | DEC-050/051/052, DEC-103, DEC-104, DEC-108, DEC-110 | Owner; project/contract communication authority; security/identity; Document Control | Recipient catalogue, external identity assurance, approved channel/access pattern, retry and exception rules | No provider, channel, public link or external identity mechanism selected by assumption |
| RFI-DD-10 | Acknowledgement and substantive response catalogue | P1 — depends on DD-09 | DEC-052, DEC-103, DEC-108, DEC-110 | Owner; Document Control; technical authority; contract/records/security as applicable | Acknowledgement types and wording; independent acknowledgement and substantive-response requirements; recipient authority; response categories; immutable submissions and aggregation/reporting rules | No new acknowledgement denominator, response code set, deemed acceptance, SLA or source-workflow effect may be assumed |
| RFI-DD-11 | Reopening, withdrawal and cancellation gate matrix | P1 — depends on DD-01/DD-05/DD-07 | DEC-104, DEC-106, DEC-108, DEC-109, DEC-110 | Owner; technical authority; records/Document Control; contract/security/QA as applicable | Pre-issue withdrawal request/approval gates, narrow administrative cancellation grounds, post-closure reopening as a new cycle, scope/record preservation, concurrency and acceptance scenarios in `docs/79_RFI_REOPENING_WITHDRAWAL_CANCELLATION_GATE_MATRIX_WORKING_DRAFT.md` | Exact eligible states, “substantive work begun” threshold, authority/delegation, permitted cancellation grounds, reopening scope and external concurrence remain unresolved; no source/Transmittal scope effects may be inferred |
| RFI-DD-12 | Notification event catalogue | P1 — initial detailed draft prepared; review pending | DEC-049, DEC-104, DEC-105, DEC-108, DEC-109, DEC-110 | Owner; security/privacy; project operations; Document Control; architecture/operations; records authority | Candidate event/action matrix, recipient resolution, content classification, channel boundaries, deduplication, reminder/escalation safeguards and acceptance scenarios in `docs/80_RFI_NOTIFICATION_EVENT_CATALOGUE_WORKING_DRAFT.md` | Exact triggers, recipient matrix, RFI priority rules, content templates, channel/provider, cadence/escalation, retry/recovery and retention remain open; no notification implementation or defaults |
| RFI-DD-13 | Reporting, search and export specification | P1 — initial detailed draft prepared; review pending | DEC-021, DEC-049, DEC-103, DEC-104, DEC-105, DEC-108, DEC-109, DEC-110 | Owner; reporting authority; security/privacy; records; architecture; QA | Candidate report catalogue, metric dictionary, counting units, search/facet controls, timezone/as-of semantics, export contract, audit lineage and acceptance scenarios in `docs/81_RFI_REPORTING_SEARCH_EXPORT_SPECIFICATION_WORKING_DRAFT.md` | Exact report audiences/entitlements, metric formulas, searchable fields/indexing, small-count suppression, date rules, export formats/retention, revocation/cache consistency and acceptance thresholds remain open; no report/search/export implementation |
| RFI-DD-14 | Records retention, archive, legal hold and disposition | P0 — initial detailed draft prepared; records/legal/security/architecture review pending | DEC-012, DEC-021, DEC-049, DEC-053, DEC-054, DEC-104, DEC-107, DEC-109, DEC-110 | Owner; records authority; legal/contract authority as applicable; Document Control; security; architecture; operations; QA | Records inventory and series design, lifecycle separation, archive package/readiness, controlled retrieval, hold authority/scope/overlap, backup/replica lifecycle, disposition gates, audit and DEC-110 scenarios in `docs/82_RFI_RECORDS_RETENTION_ARCHIVE_LEGAL_HOLD_DISPOSITION_WORKING_DRAFT.md` | Retention durations/triggers, schedule ownership, archive tier/format, legal-hold authority/scope/release, backup rotation/restore, destruction method/proof and residual-copy rules remain open; no archive, hold, deletion or backup/restore implementation |
| RFI-DD-15 | Test governance and acceptance catalogue | P1 — after DD-01–DD-14 stabilize | DEC-103, DEC-104–DEC-110 | Owner; QA/test lead; security; records; architecture | Test traceability, AT-RFI/E2E expansion, ownership, environments, thresholds, severity, evidence, waiver and release gates | No test pass or release readiness claim without actual evidence |

## 3. Sequencing and dependency graph

### Wave 1 — Authority and lifecycle foundation

- RFI-DD-01 — lifecycle state/transition model.
- RFI-DD-02 — capability and appointment model.
- RFI-DD-03 — discipline/technical leadership and conflict handling.
- RFI-DD-04 — independent review and separation of duties.

DD-01 and DD-02 are parallel starting points; DD-03 and DD-04 depend on the authority model being sufficiently specified. Their outputs constrain all later workflow, API, data and UI design.

### Wave 2 — Identity, evidence and transactional integrity

- RFI-DD-05 — clarification/revision/new-RFI classification.
- RFI-DD-06 — numbering and legacy reconciliation.
- RFI-DD-07 — concurrency/idempotency/transaction contract.
- RFI-DD-08 — attachment/evidence security.

DD-07 depends on the state and identity rules from DD-01/DD-06. DD-08 must be reviewed before any Storage or file-handling design.

### Wave 3 — Communication and records

- RFI-DD-09 — recipient identity and distribution.
- RFI-DD-10 — acknowledgement and substantive response.
- RFI-DD-11 — reopening/withdrawal/cancellation gate matrix.
- RFI-DD-12 — notification events.
- RFI-DD-13 — reporting/search/export.
- RFI-DD-14 — retention/archive/legal hold/disposition.

DD-10 depends on DD-09. DD-12 and DD-13 depend on approved lifecycle, authority and communication semantics. DD-14 is a prerequisite to records/storage disposition implementation.

### Wave 4 — Verification and release planning

- RFI-DD-15 — test governance and acceptance catalogue.

Use AT-RFI-01–13 and the 28 E2E scenarios as initial test-design material only. Map each test to the final approved rule, actor/capability context, expected result, negative cases and retained evidence. Expand cases where the detailed specifications add behavior. Do not mark tests passed until executed in the approved environment with recorded evidence.

## 4. Definition of ready for each detailed specification

A work item is ready for owner/authority review only when it includes:

- Exact requirement and controlling decision references.
- Scope and explicit non-scope.
- Actors, authority/capability and relevant party/project/discipline scope.
- Preconditions, transition/action, side effects and immutable events where applicable.
- Positive, negative, boundary, concurrency and failure scenarios relevant to the workstream.
- Dependencies and unresolved questions, each with the decision authority identified.
- Security, records, privacy and data-integrity impact.
- Testable acceptance criteria and required evidence.
- Explicit statement of what remains blocked pending approval.

## 5. Current execution status

| Work item | Status |
|---|---|
| RFI-DD-01 — lifecycle state/transition model | Initial candidate specification drafted in `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md` §3; detailed owner/authority review pending |
| RFI-DD-02 — capability/appointment model | Initial candidate specification drafted in `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md` §4; exact capability IDs, grant authority and appointment detail remain open |
| RFI-DD-03 — discipline / technical leadership / conflict | Initial candidate specification drafted in `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md` §9; decision register §11 remains open |
| RFI-DD-04 — independent review / separation of duties | Initial candidate specification drafted in `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md` §10; trigger matrix and reviewer rules remain open |
| RFI-DD-05 — clarification / revision / linked new RFI | Initial detailed working specification in `docs/73_RFI_CLARIFICATION_REVISION_CLASSIFICATION_WORKING_DRAFT.md`; technical and owner review pending, with controlled-content fields and return/correction applicability unresolved |
| RFI-DD-06 — official numbering / legacy reconciliation | Initial detailed working specification in `docs/74_RFI_OFFICIAL_NUMBERING_AND_LEGACY_RECONCILIATION_WORKING_DRAFT.md`; owner / Document Control / records review pending, with display pattern, uniqueness boundary and full legacy inventory unresolved |
| RFI-DD-07 — concurrency / idempotency / transaction integrity | Initial detailed working specification in `docs/75_RFI_CONCURRENCY_IDEMPOTENCY_TRANSACTION_INTEGRITY_WORKING_DRAFT.md`; architecture / security / records review pending, with key scope/retention, transaction/lock strategy, final state guards and recovery mechanics unresolved |
| RFI-DD-08 — attachment and evidence security | Initial detailed working specification in `docs/76_RFI_ATTACHMENT_AND_EVIDENCE_SECURITY_WORKING_DRAFT.md`; security / records / architecture / owner review pending, with evidence classes, file limits, scanning, integrity mechanism, encryption, access mapping, retention and recovery details unresolved |
| RFI-DD-09 — recipient classes, identity and distribution channel | Initial detailed working specification in `docs/77_RFI_RECIPIENT_IDENTITY_AND_DISTRIBUTION_CHANNEL_WORKING_DRAFT.md`; owner / contract / security / identity / Document Control review pending, with recipient classes, nomination authority, identity assurance, channel selection, provider delivery semantics, revocation and privacy details unresolved |
| RFI-DD-10 — acknowledgement and substantive response catalogue | Initial detailed working specification in `docs/78_RFI_ACKNOWLEDGEMENT_AND_SUBSTANTIVE_RESPONSE_CATALOGUE_WORKING_DRAFT.md`; owner / Document Control / technical authority / contract / records / security review pending, with exact wording, response categories, requirement granularity, role authority, withdrawal/closure rules and legal effect unresolved |
| RFI-DD-11 — reopening, withdrawal and cancellation gate matrix | Initial detailed working specification in `docs/79_RFI_REOPENING_WITHDRAWAL_CANCELLATION_GATE_MATRIX_WORKING_DRAFT.md`; owner / technical authority / records / Document Control / contract / security / QA review pending, with eligible states, substantive-work threshold, authority/delegation, cancellation grounds, reopening scope, external concurrence and detailed transition rules unresolved |
| RFI-DD-12 — notification event catalogue | Initial detailed working specification in `docs/80_RFI_NOTIFICATION_EVENT_CATALOGUE_WORKING_DRAFT.md`; owner / security/privacy / project operations / Document Control / architecture / operations / records review pending, with exact triggers, recipient matrix, priority rules, templates, channels/providers, cadence/escalation, retry/recovery and retention unresolved |
| RFI-DD-13 — reporting, search and export specification | Initial detailed working specification in `docs/81_RFI_REPORTING_SEARCH_EXPORT_SPECIFICATION_WORKING_DRAFT.md`; owner / reporting authority / security/privacy / records / architecture / QA review pending, with report audiences, metric formulas, searchable fields/indexing, small-count suppression, date rules, export formats/retention, revocation/cache consistency and acceptance thresholds unresolved |
| Implementation authorization | **NOT GRANTED** |

## 6. Next recommended work

1. Review and resolve the candidate state vocabulary, transition guards and parent/subordinate aggregation in DD-01.
2. Resolve the capability catalogue, grant/revoke authority, appointment records and scope model in DD-02 with security review.
3. Resolve DD-03 conflict classes, technical-lead delegation, escalation authority, discipline interface checklist and dissent representation.
4. Resolve DD-04 risk/authority matrix, mandatory review triggers, reviewer competence/independence and re-review materiality rules.
5. Treat DD-05/06/07 as a connected identity-and-transaction specification set; resolve DD-01 and DD-06 dependencies before architecture selection or implementation planning.
6. Review DD-07/08/09 as a connected transaction, evidence-security and recipient-distribution boundary; resolve identity assurance, provider delivery semantics, per-recipient authorization and recovery before any external-channel architecture.
7. Review DD-09/10 as one recipient-communication control set, confirming identity assurance, package scope, acknowledgement wording, independent response requirements and recipient-specific authority before any provider or workflow implementation.
8. Review DD-11 against DD-01/05/07 and the owner-confirmed DEC-106/108/109 boundaries; resolve eligibility, authority, scope and race outcomes before implementation planning.
9. Review DD-12 against DEC-049 and DD-01/DD-02/DD-09/DD-10/DD-11; resolve event triggers, recipient eligibility, content/privacy, priority, channel, deduplication, reminder/escalation and retention before any notification implementation.
10. Review DD-13 against DEC-021/049/103/109 and DD-01/DD-02/DD-06–DD-12; resolve report audiences, metric dictionary, search fields, aggregation privacy, date/as-of rules, export controls and records lineage before implementation planning.
11. Review DD-14 against DEC-012/021/053/054/107/109 and DD-08/DD-13; resolve records series, schedule authority, archive package, hold scope, backup/restore, disposition gates and residual-copy evidence before any records implementation.
12. Prepare DD-15 — test governance and acceptance catalogue — consolidate traceable requirements, scenario ownership, non-production environments, evidence, severity, waivers and release gates across DD-01–DD-14.

Do not begin workflow implementation or permission grants while these dependencies remain open.

**Boundary:** This backlog is non-authoritative planning only. It does not amend DEC-104–DEC-110, settle unresolved rules, execute tests, change application behavior or authorize implementation, migration, DB/Storage/auth/RLS changes, production-data operations, merge or deployment.
