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
| RFI-DD-05 | Clarification/revision/linked-new-RFI classification | P0 — depends on DD-01 | DEC-104, DEC-106, DEC-107 | Owner; technical authority; document-family governance | Decision tree, materiality criteria, examples, version and linkage rules | No classification may silently mutate an issued/submitted snapshot |
| RFI-DD-06 | Official numbering and legacy reconciliation | P0 — before allocator design | DEC-002, DEC-022-A/B, DEC-104, DEC-107, DEC-110 | Owner; Document Control; data/records authority | Display-pattern decision, uniqueness scope, inventory, collision map and reconciliation report | No allocator or migration until legacy baseline is verified |
| RFI-DD-07 | Concurrency, idempotency and transaction contract | P0 — after DD-01/DD-06 | DEC-022-A, DEC-104, DEC-106, DEC-107, DEC-110 | Architecture/engineering; data/security reviewers; owner approval for behavior | Preconditions, idempotency semantics, event ordering, atomic boundaries, conflict/retry rules | No state-changing implementation until transaction contract is approved |
| RFI-DD-08 | Attachment and evidence security | P0 — before Storage design | DEC-021, DEC-051, DEC-053, DEC-104, DEC-107, DEC-109, DEC-110 | Security; records authority; owner | File policy, integrity verification, scanning/quarantine, encryption, access, retention and recovery requirements | No upload, preview, download, replacement or deletion implementation |
| RFI-DD-09 | Recipient classes, identity and distribution channel | P0 — before provider integration | DEC-050/051/052, DEC-103, DEC-104, DEC-108, DEC-110 | Owner; project/contract communication authority; security/identity; Document Control | Recipient catalogue, external identity assurance, approved channel/access pattern, retry and exception rules | No provider, channel, public link or external identity mechanism selected by assumption |
| RFI-DD-10 | Acknowledgement and substantive response catalogue | P1 — depends on DD-09 | DEC-052, DEC-103, DEC-108, DEC-110 | Owner; Document Control; technical authority | Exact acknowledgement wording, Required/Optional/Not Requested model, per-entry rules and substantive-response categories | No acknowledgement meaning or denominator may deviate from DEC-103/108 |
| RFI-DD-11 | Reopening, withdrawal and cancellation gate matrix | P1 — depends on DD-01/DD-05 | DEC-104, DEC-106, DEC-108, DEC-109 | Owner; technical authority; records/Document Control | Eligible-state matrix, scope effects, linked-record handling and notice requirements | No source/Transmittal scope effects may be inferred |
| RFI-DD-12 | Notification event catalogue | P1 — depends on DD-01/DD-02/DD-09 | DEC-049, DEC-104, DEC-108, DEC-109, DEC-110 | Owner; security; project operations | Event/action matrix, recipient resolution, content classification, priority/cadence if separately approved | Notifications cannot confer access, transfer authority or change source workflow |
| RFI-DD-13 | Reporting, search and export specification | P1 — depends on DD-01/DD-02/DD-09/DD-12 | DEC-021, DEC-049, DEC-103, DEC-109, DEC-110 | Owner; reporting authority; security/privacy; records | Report catalogue, counting units, populations, filters, timezone/as-of, export fields and audit evidence | No report or aggregate may disclose restricted metadata |
| RFI-DD-14 | Records retention, archive, legal hold and disposition | P0 — before records implementation | DEC-053, DEC-054, DEC-104, DEC-109, DEC-110 | Records authority; legal/compliance authority as applicable; owner | Records classification, retention schedule, archive trigger, hold authority, disposition and backup lifecycle | No retention duration, legal authority or deletion behavior may be invented |
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
| RFI-DD-01 through RFI-DD-15 | Not started as detailed specifications; dependencies inventoried only |
| Working-draft reconciliation (D1) | Completed on the working branch; see `docs/69_RFI_WORKFLOW_DESIGN_WORKING_DRAFT.md` |
| Design closeout assessment | Created; see `docs/70_RFI_DESIGN_CLOSEOUT_AND_IMPLEMENTATION_READINESS.md` |
| Implementation plan | Not approved |
| Implementation authorization | **NOT GRANTED** |

## 6. Next recommended work

Start with RFI-DD-01 and RFI-DD-02. Prepare the lifecycle transition matrix and capability/appointment matrix as linked design artifacts, explicitly marking unresolved state names, appointment authorities and project-specific rules as pending decisions. Do not begin workflow implementation or permission grants while those dependencies remain open.

**Boundary:** This backlog is non-authoritative planning only. It does not amend DEC-104–DEC-110, settle unresolved rules, execute tests, change application behavior or authorize implementation, migration, DB/Storage/auth/RLS changes, production-data operations, merge or deployment.
