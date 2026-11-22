# DD-05 — Clarification, Formal Revision and Linked-New-RFI Classification: Atomic Leaf Requirements

**Document type:** Governance traceability decomposition — working draft  
**Date:** 2026-11-13  
**Status:** WORKING DRAFT — CANDIDATE LEAVES — OWNER / TECHNICAL / DOCUMENT-CONTROL REVIEW PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent specification:** `docs/73_RFI_CLARIFICATION_REVISION_CLASSIFICATION_WORKING_DRAFT.md`  
**Lifecycle dependency:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`  
**Backlog:** `docs/71_RFI_DETAILED_SPECIFICATION_BACKLOG.md`  
**Controlling decisions:** DEC-002, DEC-022-A/B, DEC-104, DEC-106, DEC-107, DEC-110  
**Related traceability:** DD-01 docs/148; DD-02 docs/149; DD-03 docs/150; DD-15 docs/83

> These leaves decompose the existing DD-05 working specification. They do not create a general RFI revision workflow, change DEC-022-A/B, approve a controlled-content field list, appoint a classifier, establish final relationship enums or authorize implementation/testing. Unresolved transitions remain blocked.

## 1. Core classification model

A submitted-RFI follow-up must be classified into one of three distinct paths:

- **Clarification round:** further explanation, completion or evidence for the original engineering question without materially changing the controlled inquiry.
- **Formal revision:** controlled-content change to the same RFI only where the applicable approved correction/resubmission rule permits it under DEC-022-B.
- **Linked new RFI:** a materially independent engineering question or independently trackable scope with a separate RFI identity.

A post-issue follow-up is additionally subject to DEC-106 reopening boundaries; it must not revise, withdraw or replace an issued response in place. A linked RFI does not silently alter its source RFI.

## 2. Atomic leaf requirements

### A. Classification authority and source-version control

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-CLS-L001 | Every consequential follow-up classification shall identify the source RFI, active response cycle and exact submitted/controlled snapshot assessed. | Immutable source-version reference. | DD-05 §§3,7; DEC-107 |
| RFI-CLS-L002 | Technical relationship and materiality classification shall be made by a currently appointed technical lead or delegated technical authority whose scope covers the subject and action. | Appointment/delegation evidence and reasoned decision. | DD-05 §6; DEC-104/106; DD-02 |
| RFI-CLS-L003 | Coordinator or Document Control may identify a potential classification issue and route it, but shall not determine engineering materiality or classification solely for administrative convenience. | Administrative/technical action separation. | DD-05 §6; DEC-105 |
| RFI-CLS-L004 | Originator wording or preferred label shall not by itself determine whether a follow-up is clarification, revision or linked new RFI. | Independent technical classification and rationale. | DD-05 §§3,6 |
| RFI-CLS-L005 | A missing, expired, out-of-scope or disputed classifier appointment shall place the consequential classification on hold. | Fail-closed authority result. | DD-05 §6; DD-02 |
| RFI-CLS-L006 | Classification shall record the affected question, controlled fields/scope, technical objective, decision boundary, evidence and rationale. | Attributable classification record. | DD-05 §§3–5 |

### B. Clarification-round boundary

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-CLS-L007 | A follow-up that explains or completes the original question without materially changing the controlled inquiry shall use a clarification round under the same RFI identity. | Clarification classification and same-RFI linkage. | DEC-104 ODM-08/09; DD-05 §5.1 |
| RFI-CLS-L008 | A clarification round shall have a distinct identifier and preserve the exact request, requester, authority, response, timestamps and affected scope. | Attributable clarification-round record. | DD-05 §5.1 |
| RFI-CLS-L009 | A clarification round shall not allocate a new official RFI number or increment a formal revision solely because a clarification exchange occurred. | Identity separation and negative control. | DEC-022-A/B; DEC-107 |
| RFI-CLS-L010 | A clarification exchange shall not mutate or replace the original submitted inquiry snapshot or attachment manifest. | Immutable predecessor snapshot and separate evidence versions. | DEC-107; DD-05 §§5.1,7 |
| RFI-CLS-L011 | A clarification request shall identify whether it blocks parent progression or only a scoped contribution/action, under the approved lifecycle blocker rules. | Explicit blocker scope and resume-stage evidence. | DD-01; DISP-OR01-005 |
| RFI-CLS-L012 | A clarification response or newly supplied evidence shall not itself constitute technical acceptance, formal issue or parent closure. | Separate technical and lifecycle decisions. | DD-05 §5.1; DEC-105/108 |

### C. Formal revision boundary

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-CLS-L013 | Formal revision shall be available only where an applicable approved RFI correction/resubmission rule expressly permits the revision path. | Applicable rule and authorized transition evidence. | DEC-022-B; DD-05 §5.2 |
| RFI-CLS-L014 | Where DEC-022-B applies, the official RFI number shall remain stable and the first formal issue shall be Rev.00. | Number/revision lineage. | DEC-022-A/B |
| RFI-CLS-L015 | A controlled-content change after an authorized return/correction shall create the next sequential revision only where the approved rule applies. | Prior revision, return/correction authority and new revision evidence. | DEC-022-B |
| RFI-CLS-L016 | Resubmission without controlled-content change shall retain the same revision. | Controlled-content comparison and same-revision evidence. | DEC-022-B |
| RFI-CLS-L017 | Each formal revision shall preserve its own immutable content/evidence snapshot and prior revision history. | Versioned snapshot and manifest lineage. | DEC-022-B; DEC-107 |
| RFI-CLS-L018 | Review, approval and signature evidence shall be bound to the exact revision and shall not carry forward automatically to a successor revision. | Exact-version approval lineage. | DEC-022-B |
| RFI-CLS-L019 | Clarification-round identifiers, formal revision identifiers, response-version identifiers and Transmittal identifiers shall remain distinct. | Identifier crosswalk and validation. | DEC-107/108 |
| RFI-CLS-L020 | Metadata-only and controlled-content field classification shall remain blocked until the applicable document-family profile is approved. | Approved field profile; no developer-defined field list. | DD-05 §5.2; open dependency |

### D. Linked-new-RFI boundary and relationship integrity

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-CLS-L021 | A materially independent or independently trackable engineering question shall be classified as a linked-new-RFI candidate rather than silently appended to the original inquiry. | Separate-scope rationale and authorized classification. | DEC-104 ODM-08; DEC-106 |
| RFI-CLS-L022 | A linked new RFI shall receive a separate official number only upon successful first formal submission under DEC-022-A. | New identity and submission evidence. | DEC-022-A; DEC-107 |
| RFI-CLS-L023 | A relationship between source and linked RFI shall record source/target identities, relationship reason, classification authority, affected scope and date. | Typed, attributable relationship record; final relationship vocabulary remains open. | DD-05 §5.3 |
| RFI-CLS-L024 | A linked RFI shall not automatically inherit source assignments, contributions, authority, reviews, approvals, response or recipients. | Independent authority and scope validation. | DD-05 §5.3; DD-02/DD-03/DD-04 |
| RFI-CLS-L025 | Creating or submitting a linked RFI shall not automatically revise, reopen, close, withdraw or otherwise mutate the source RFI. | Independent lifecycle records and no-cascade guard. | DD-05 §5.3; DD-01 |
| RFI-CLS-L026 | Visibility of a linked relationship shall not disclose restricted metadata, evidence or attachments from either RFI without independent authorization to both records. | Per-record/action access checks and negative tests. | DD-05 §5.3; DD-02/DD-08 |

### E. Post-issue, ambiguity, concurrency and evidence preservation

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-CLS-L027 | After formal issue, the issued response and closure history shall not be revised, withdrawn or replaced in place. | Immutable issued response and guarded post-issue actions. | DEC-106; DD-05 §3 Gate 4 |
| RFI-CLS-L028 | Further work on the same issued question shall be routed through authorized reopening into a new response cycle; an independent question shall use a linked new RFI. | Competent authority and new-cycle/linked identity evidence. | DEC-106; DD-11 |
| RFI-CLS-L029 | Uncertain classification or a proposed path unsupported by an approved transition shall remain Blocked — Pending Design/Authority Decision. | Explicit blocked outcome; preserve source snapshot. | DD-05 §§3,6,11 |
| RFI-CLS-L030 | Classification decisions shall be bound to the exact source version; a changed source version before consequential action shall require reassessment. | Stale-version detection and reclassification evidence. | DD-05 §8; DD-07 |
| RFI-CLS-L031 | Concurrent or repeated classification commands shall not silently overwrite decisions or create duplicate clarification rounds/linked RFIs. | Idempotency, conflict and concurrency evidence. | DD-05 §8; DD-07 |
| RFI-CLS-L032 | Failed linked-RFI submission shall not partially mutate the source RFI or create an orphaned relationship. | Atomicity/recovery acceptance evidence. | DD-05 §8; DD-07 |
| RFI-CLS-L033 | Classification events shall preserve actor, authority, timestamp, source version, proposed change, outcome, rationale, scope, linked identifiers and dissent/escalation. | Auditable event and lineage record. | DD-05 §7; DD-14 |
| RFI-CLS-L034 | Access to classification records, evidence and linked RFI resources shall be authorized at action time and remain subject to current project/party scope. | Server-side authorization and revocation behavior. | DD-02; DD-08 |
| RFI-CLS-L035 | Classification and relationship events shall not conflate RFI identity, formal revision, clarification round, contribution, response version or Transmittal identity. | Identity-integrity checks and reconciliation. | DEC-107/108; DD-05 §7 |

## 3. Open dependencies and explicit non-decisions

The following remain unresolved and must not be filled by implementation defaults:

1. Exact controlled-content field set and metadata-only treatment.
2. Approved RFI return/correction route and the stages at which DEC-022-B applies.
3. Exact post-issue reopening authority and mapping to technical discipline scope.
4. Final relationship-type catalogue and split handling for mixed follow-ups.
5. Evidence/attachment classification for clarification versus revision.
6. Actual classifier appointment, delegation, competence and conflict-of-interest controls.
7. DD-07 transaction, idempotency, concurrency and recovery mechanics.
8. DD-01 blocker aggregation and resume semantics.
9. DD-08 evidence integrity/access and DD-14 records/retention mapping.
10. QA-approved expected results, fixtures, test owners and retained evidence.

## 4. DD-15 candidate mapping instructions

Map each leaf only to exact AT-RFI/E2E source definitions that genuinely exercise the rule. Do not invent test IDs, infer coverage from a document reference or mark a test Passed without execution evidence. Where the source inventory has no genuine case, record Uncovered and propose a new scenario through the approved DD-15 process. Distinguish governance/authority evidence from product-behavior testing. Candidate mappings and expected results require owner, technical authority, Document Control, QA, security, records and architecture review as applicable.

## 5. Implementation boundary

This document does not amend DEC-002/022-A/B/104/106/107/110, approve a free-standing RFI revision workflow, establish a controlled-content field profile, appoint classifiers, create relationship enums or authorize implementation. No API/UI/code, numbering allocator, DB/schema/migration/generated types, Storage, auth/RLS/grants, notification provider, production-data operation, live test, backup/restore, merge or deployment is authorized.

**Current disposition:** 35 candidate leaves prepared for traceability. Owner/technical/Document Control/QA/specialist validation remains pending. No test execution/pass, formal DD-05 closeout or implementation authorization is claimed.
