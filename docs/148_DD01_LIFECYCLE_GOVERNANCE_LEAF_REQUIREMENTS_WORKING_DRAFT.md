# DD-01 — Lifecycle Governance Atomic Leaf Requirements

**Document type:** Governance and acceptance traceability working draft  
**Date:** 2026-11-13  
**Status:** WORKING DRAFT — CANDIDATE ATOMIC REQUIREMENTS — OWNER/SPECIALIST/QA VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Work item:** RFI-DD-01 — Lifecycle state and transition model  
**Controlling governance:** DEC-104, DEC-105, DEC-106, DEC-107, DEC-108, DEC-109, DEC-110  
**Source set:** docs/72, docs/106, docs/108, docs/109, docs/110  
**Related cross-reviews:** docs/133, docs/142, docs/143

> These leaves decompose existing approved policy constraints and conditionally approved owner dispositions into reviewable traceability units. They do not convert candidate labels into approved enums, close G-01–G-06, resolve open authorities, create test IDs, or authorize implementation. Conditional owner dispositions remain conditional and specialist validation remains pending.

## 1. Purpose and decomposition rules

This document provides atomic lifecycle requirement leaves beneath the composite DD-01 design and DD-15 acceptance catalogue. Each leaf is independently reviewable and must be validated against its exact controlling source and expected-result authority.

- **Policy constraint** means a boundary already required by a controlling DEC decision.
- **Owner-bound candidate constraint** means a principle within a conditionally approved OR-01 disposition; it is not final specialist sign-off.
- **Candidate / blocked detail** means exact labels, eligibility, thresholds, authorities, transition mechanics or outcomes remain unresolved.
- Candidate scenario references are coverage prompts only. No AT-RFI/E2E ID is created, renamed, or asserted as passed.
- No default SLA, timeout, priority, retention period, legal effect, authority appointment, capability grant, or system behavior is inferred.

## 2. Atomic lifecycle leaves

| Leaf ID | Atomic requirement | Source / authority class | Candidate verification focus | Status / unresolved dependency |
|---|---|---|---|---|
| RFI-LFC-L001 | An unsubmitted Draft is a draft-record condition, not an official parent RFI lifecycle stage. | DEC-107; DISP-OR01-001 conditional | Verify no official parent stage/number is created before successful submission. | Constraint traceable; draft ownership/retention details remain separate. |
| RFI-LFC-L002 | Abandoned Draft remains a pre-submission draft disposition and must not be represented as official RFI withdrawal. | DISP-OR01-001 conditional | Verify draft abandonment cannot create Withdrawn parent outcome or consume official number. | Conditional owner boundary; detailed draft-record controls pending. |
| RFI-LFC-L003 | A successful formal submission creates one stable official RFI identity and preserves the submitted snapshot. | DEC-107; docs/72 | Verify first-success identity allocation, immutable submitted evidence/version lineage and no number consumption on failed submission. | Exact allocator/transaction mechanics belong to DD-06/DD-07 and remain open. |
| RFI-LFC-L004 | Each official RFI identity has one authoritative current parent lifecycle stage. | DEC-104; DISP-OR01-014 conditional | Verify no two simultaneous current parent stages for one official RFI. | Parent/cycle projection mechanics remain open under G-01 / DEP-RCL-09. |
| RFI-LFC-L005 | Response-cycle identity and history are distinct from the official parent RFI identity and parent-stage projection. | DISP-OR01-013/014 conditional; docs/108 | Verify predecessor cycle history remains immutable while the active cycle is separately identified. | Cycle ID, sequence, pointer and projection unresolved. |
| RFI-LFC-L006 | A subordinate record state or event cannot autonomously mutate the parent lifecycle. | DEC-104–109; docs/108 | Verify assignment, contribution, clarification, review, Transmittal, recipient, notification and archive events only affect parent through an explicit authorized gate. | Exact gate catalog must be validated across DD-01–DD-14. |
| RFI-LFC-L007 | Events, decisions, indicators and records-control conditions retain distinct semantic types and ownership. | DEC-104/106/109; docs/108 | Verify an occurrence or metric is not persisted/rendered as a parent stage merely because it has a familiar label. | Final dictionary and report semantics remain under G-05. |
| RFI-LFC-L008 | Administrative coordination does not confer technical scope, assignment, review, readiness, issue or closure authority. | DEC-105; DISP-OR01-004 conditional | Negative authorization checks for coordinator-only identity and title-based inference. | Actual appointments, delegation and capability IDs remain DD-02/security dependencies. |
| RFI-LFC-L009 | Technical hand-off requires the distinct technical decision key and administrative execution key, with the complete required assignment set evidenced. | DEC-105; DISP-OR01-004 conditional | Verify missing/stale scope, lead, assignment, appointment or evidence holds hand-off in coordination. | Exact project appointment instruments and permitted function combination remain open. |
| RFI-LFC-L010 | Ordinary Returned for Completion is bounded to the permitted pre-technical administrative/information return and is not a technical rejection. | DISP-OR01-003 Option C conditional; docs/109 | Verify ordinary return preserves official identity and does not silently reset technical work. | Exact eligibility/content-field rules require DD-05 and specialist validation. |
| RFI-LFC-L011 | A late material administrative defect after technical work begins must not be handled by silently resetting the technical lifecycle. | DISP-OR01-003 Option C conditional; docs/91/109 | Verify a late-correction route is separately evidenced and preserves technical history. | Exact route, authority, state/event representation remain G-03. |
| RFI-LFC-L012 | Parent-progression clarification blockers are distinct from contribution-only blockers. | DISP-OR01-005/014 conditional | Verify only an authorized, reasoned parent dependency can place the parent into clarification waiting; contribution-only work remains scoped to its child record. | Eligible source stages and blocker aggregation remain G-02. |
| RFI-LFC-L013 | The parent may resume its exact prior active stage only after all valid parent-level clarification blockers are resolved and current guards pass. | DISP-OR01-005/014 conditional | Verify multiple blockers, partial responses, unresolved blockers and stale guards do not cause premature resumption. | Sufficiency decision and exact transition mechanics remain open. |
| RFI-LFC-L014 | Formal parent entry to Under Consolidation requires every required contribution to be complete and technically confirmed, or validly removed by an authorized scope change. | DISP-OR01-006 conditional | Verify incomplete required contribution blocks entry; a scope change is attributable, authorized and versioned. | Exact contribution completion criteria and scope-change authority require DD-03/authority review. |
| RFI-LFC-L015 | Limited provisional response preparation before the consolidation gate remains subordinate work and does not change the parent stage. | DISP-OR01-006 conditional; docs/109/110 | Verify provisional candidate activity cannot be reported as formal parent Under Consolidation or readiness. | Exact permissible preparation scope remains subject to technical/process review. |
| RFI-LFC-L016 | A scoped return from consolidation identifies the material gap and affected work while preserving unaffected completed contributions and exact versions. | DISP-OR01-007 conditional | Verify only affected scope is reopened for work and prior versions/history remain available. | Materiality, return authority and dependency rules remain specialist validation items. |
| RFI-LFC-L017 | Independent review is required only when an applicable approved/versioned risk-authority matrix triggers it, and it binds to the exact frozen candidate/package. | DEC-105; DISP-OR01-008/009 conditional | Verify no invented threshold, reviewer appointment or generic review requirement; stale package cannot reuse clearance. | Approved matrix and reviewer appointment/competence evidence remain absent. |
| RFI-LFC-L018 | Readiness confirmation is a distinct attributable decision bound to one exact candidate/package and is not formal issue. | DISP-OR01-009/010 conditional; DEC-106 | Verify readiness alone cannot set Closed, issue a response or create a Transmittal. | Readiness authority and final evidence contract remain open. |
| RFI-LFC-L019 | Formal issue and technical closure are distinct linked evidence identities but one indivisible successful business outcome. | DEC-106; DISP-OR01-010 conditional | Verify no partial success, issue-only closure gap, closure-only issue, or reversal of a committed issue. | Commit, serialization, idempotency and recovery details remain DD-07 / G-06. |
| RFI-LFC-L020 | Withdrawal is a whole-parent pre-issue outcome; a request alone does not change parent lifecycle. | DEC-106; DISP-OR01-011 conditional | Verify request, assessment and authorized disposition are distinct; post-issue withdrawal is denied. | Exact eligible pre-issue states, substantive-work threshold and authority remain open. |
| RFI-LFC-L021 | Cancellation is distinct from withdrawal and limited to the current narrow approved baseline: proven duplicate official registration or objectively invalid registration. | DISP-OR01-012 conditional; docs/100/142 | Verify technical disagreement, convenience, correctable defects, delay, silence, failed delivery and archive are not cancellation grounds. | Invalid-registration proof standard and exhaustive criteria remain open; no added grounds inferred. |
| RFI-LFC-L022 | Reopening after successful issue/technical closure creates a distinct new response cycle under the same official RFI identity; the predecessor cycle remains immutable. | DEC-106; DISP-OR01-013 conditional; docs/101/142 | Verify same official identity, unique new cycle and immutable predecessor history. | Parent projection, eligible grounds, authority and cycle identity remain DEP-RCL-07–10. |
| RFI-LFC-L023 | Prior contributions, independent-review clearance and readiness do not automatically transfer to a new response cycle or candidate version. | DISP-OR01-013 conditional; DEC-110 | Verify each reused contribution is revalidated for scope/version/relevance; review/readiness is exact-version bound. | Revalidation criteria and evidence requirements remain DEP-RCL-11. |
| RFI-LFC-L024 | Delivery, access, acknowledgement, substantive response, notification, reporting, archive and retention remain separate from technical parent issue/closure. | DEC-103/108/109; docs/108/133/143 | Verify recipient/channel/records events cannot close, reopen, withdraw or cancel the technical parent. | Recipient, notification and records semantics remain DD-09–DD-14 dependencies. |

## 3. Candidate scenario coverage and gaps

The following are candidate coverage prompts to be mapped against the exact source text in docs/137 and docs/138. They are not test IDs and are not evidence of execution.

| Coverage area | Leaf IDs | Minimum positive / negative / boundary focus | Current mapping status |
|---|---|---|---|
| Draft, submission, identity and snapshot | L001–L003 | Draft/abandonment; failed submission; first-success numbering; duplicate/replay; immutable submitted snapshot | Candidate mapping; exact scenario references require QA validation |
| Parent/cycle/child semantics | L004–L007 | Singular parent projection; historical cycle; child event isolation; event vs state vs indicator | Partial; parent/cycle projection remains blocked |
| Authority and technical hand-off | L008–L009 | Coordinator-only denial; missing/stale appointment; incomplete assignment set; action-time scope | Candidate; capability/appointment evidence pending |
| Return and clarification | L010–L013 | Ordinary vs late return; parent vs contribution blocker; multiple blockers; partial clarification; exact prior-stage resume | Partial; G-02/G-03 open |
| Contribution and consolidation | L014–L016 | Required contribution incomplete; valid scope removal; provisional preparation; scoped return preserving unaffected work | Candidate; completion/materiality authority pending |
| Independent review and readiness | L017–L018 | Matrix not applicable/applicable; stale candidate; reviewer conflict; readiness cannot issue | Blocked pending matrix/appointments |
| Issue and closure | L019 | issue/closure atomicity; timeout-after-success; competing commands; recovery | Blocked pending DD-07 / G-06 |
| Withdrawal and cancellation | L020–L021 | Request vs decision; pre/post-issue; substantive work; narrow cancellation grounds; invalid-registration proof | Partial; authority and thresholds open |
| Reopening and new cycle | L022–L023 | Same official ID; immutable predecessor; unique active cycle; no inherited review/readiness | Blocked pending G-01 and DEP-RCL-07–11 |
| Communication and records separation | L024 | Delivery/acknowledgement/archive cannot mutate technical lifecycle | Candidate; cross-spec validation pending |

## 4. Required QA completion fields

For every leaf, QA/domain owners must record:
1. Exact source document version/SHA and clause.
2. Classification: DEC policy constraint, conditional owner-bound constraint, candidate design, or blocked detail.
3. Exact existing AT-RFI/E2E scenario ID and source wording, if a real mapping exists; otherwise mark uncovered.
4. Expected result and the authority that approved it.
5. Actor, current appointment/delegation evidence, project/party/RFI scope and action-time authorization context.
6. Positive, negative, boundary, concurrency and failure cases as applicable.
7. Synthetic fixture/environment and evidence artifact/retention reference.
8. Responsible test owner, independent reviewer where required, and validation status.
9. Any discrepancy, dissent, prerequisite or waiver request; no waiver authority is inferred.
10. Explicit execution status. “Designed”, “mapped”, “reviewed” and “passed” must remain separate states.

No new AT-RFI/E2E identifiers may be invented by this document. Unmapped requirements remain uncovered until the controlled test-ID governance route is approved.

## 5. Open authority and dependency register

| Dependency | Required authority / evidence | Status |
|---|---|---|
| G-01 / DEP-RCL-09: singular parent projection across reopened cycles | Owner, process/technical authority, architecture/data, Document Control, records, QA | Blocked |
| G-02: clarification eligible source stages and blocker aggregation | Owner, technical authority/lead, affected disciplines, architecture, QA | Blocked |
| G-03: late administrative correction route | Owner, records/correction authority, Document Control, technical authority, architecture, QA | Blocked |
| G-04: appointment/delegation and function combinations | Appointing/project governance, technical authority, identity/security | Blocked |
| G-05: final semantic dictionary and metric ownership | Process owner, technical authority, architecture, records/reporting, QA | Blocked |
| G-06: transition guard, failure and recovery contract | Architecture, security, QA, records, engineering | Blocked |
| DEP-RCL-03/04/05/07/08/10/11/12/13/14/15 | Exact DD-11 eligibility, grounds, authority, materiality, cycle, correction, communication, records and test decisions | Blocked |
| Independent review matrix and appointments | Risk/quality authority, technical authority, owner, security/QA | Blocked |
| Test scenario expected-result authority | QA/test authority and relevant domain decision authority | Pending |

## 6. Promotion and implementation boundary

- All 24 leaves remain working-draft traceability units pending exact-version QA, owner and specialist validation.
- Conditional owner dispositions are not promoted to unconditional approval.
- Candidate state labels are not final enum values or approved application states.
- G-01–G-06 and all listed DD-11 dependencies remain open.
- No test execution/pass, appointment, permission grant, API/UI/code, DB/schema/migration/generated type, Storage/auth/RLS change, production-data operation, backup/restore, merge or deployment is authorized.
- Any future implementation requires a separate scoped plan, resolved decisions, specialist sign-off, approved acceptance criteria, non-production rehearsal and explicit owner authorization. DB/Storage work additionally requires verified backups, isolated restore/rehearsal and reconciliation.

**Current disposition:** DD-01 lifecycle constraints decomposed into 24 atomic governance leaves; exact mappings and authority validation pending; no implementation or test execution authorized.

---

**End of DD-01 lifecycle governance leaf working draft.**
