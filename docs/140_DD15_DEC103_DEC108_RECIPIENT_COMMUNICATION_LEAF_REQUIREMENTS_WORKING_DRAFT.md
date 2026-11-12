# DD-15 DEC-103 / DEC-108 Recipient Communication Leaf Requirements — Working Draft

**Document type:** Leaf-level requirement decomposition for recipient delivery, Transmittal and acknowledgement  
**Date:** 2026-11-12  
**Status:** GOVERNANCE-ALIGNED LEAF DECOMPOSITION — QA / OWNER / RECORDS / SECURITY VALIDATION PENDING — NO TEST EXECUTION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Authoritative source:** `governance/scan-lifecycle-design-2026-11-11/docs/01_MASTER_DECISION_REGISTER.md`, DEC-103 and DEC-108  
**Detailed design references:** `docs/77` §§3, 5–16; `docs/78` §§3–14; cross-review `docs/132`; baseline `docs/139`; scenario inventory `docs/137`

> Each row is an independently verifiable candidate leaf requirement derived from owner-approved DEC-103/DEC-108. Requirement IDs are traceability references only; they are not new governance decisions. The expected result is stated only to the extent the controlling decision fixes it. Provider-specific states, unknown delivery treatment, recipient identity assurance, channel and other open details remain blocked until approved.

## 1. Leaf requirements

| Leaf ID | Atomic requirement / invariant | Approved authority | Detailed-design location | Candidate scenario | Coverage | Expected-result authority / blocker |
|---|---|---|---|---|---|---|
| RFI-COM-L001 | Every intended recipient in the issued Transmittal manifest has an independently recorded delivery outcome. | DEC-103; DEC-108 | docs/77 §10 | AT-RFI-13; E2E-17 | Partial | Per-recipient recording approved; exact provider evidence and event schema open. |
| RFI-COM-L002 | Aggregate Delivered is permitted only when every intended recipient has confirmed technical delivery. | DEC-103; DEC-108 | docs/77 §10 | AT-RFI-13 | Partial | Aggregate rule approved; explicit all-success assertion not separately named in source cases. |
| RFI-COM-L003 | Aggregate Partially Delivered applies when at least one intended recipient succeeds and at least one intended recipient fails. | DEC-103; DEC-108 | docs/77 §10 | AT-RFI-13; E2E-17 | Candidate direct | Aggregate rule approved; must assert exact intended-recipient denominator. |
| RFI-COM-L004 | Aggregate Failed applies when all intended recipients fail technical delivery. | DEC-103; DEC-108 | docs/77 §10 | AT-RFI-13 | Uncovered | Approved aggregate rule; no explicit all-fail E2E case. |
| RFI-COM-L005 | Acknowledgement completion requires an explicit acknowledgement from every recipient whose requirement is Required. | DEC-103; DEC-108 | docs/77 §11; docs/78 §§3–4,12 | AT-RFI-13; E2E-16–17 | Partial | Required-only rule approved; authentication and acknowledgement evidence standard open. |
| RFI-COM-L006 | Optional recipients are excluded from the acknowledgement-required denominator. | DEC-103; DEC-108 | docs/78 §§3,12 | AT-RFI-13 | Uncovered | Approved; no explicit Optional-denominator test case. |
| RFI-COM-L007 | Not Requested recipients are excluded from the acknowledgement-required denominator. | DEC-103; DEC-108 | docs/78 §§3,12 | AT-RFI-13 | Uncovered | Approved; no explicit Not Requested-denominator test case. |
| RFI-COM-L008 | If no recipient is marked Required, aggregate acknowledgement status is Not Required. | DEC-103; DEC-108 | docs/78 §12.1 | AT-RFI-13 | Uncovered | Approved; no explicit zero-Required case. |
| RFI-COM-L009 | A failed technical delivery must not be counted as an acknowledgement. | DEC-103; DEC-108 | docs/77 §§10–11; docs/78 §§4,12 | E2E-17 | Partial | Approved distinction; source E2E focuses mixed outcomes, not explicit failed-delivery/ack equivalence rejection. |
| RFI-COM-L010 | Technical delivery confirmation and recipient access/read evidence are separate event types. | DEC-103; DEC-108 | docs/77 §11; docs/78 §4 | E2E-16–17 | Partial | Approved distinction; exact observable access evidence and provider Unknown handling open. |
| RFI-COM-L011 | Recipient access/open/download does not by itself satisfy an explicit acknowledgement requirement. | DEC-103; DEC-108 | docs/77 §11; docs/78 §4 | E2E-16 | Candidate direct | Approved distinction; authenticated acknowledgement mechanism and evidence standard open. |
| RFI-COM-L012 | Explicit acknowledgement and substantive response are separate recipient events and requirements. | DEC-108 | docs/78 §§3–9,12 | E2E-16–17 | Partial | Approved distinction; exact catalogue and requirement granularity require QA/owner review. |
| RFI-COM-L013 | Recipient acknowledgement or substantive response does not itself approve or technically resolve the source RFI. | DEC-103; DEC-108 | docs/77 §11; docs/78 §§5,9 | E2E-16; E2E-22 | Partial | Approved separation; source cases do not enumerate every false-transition attempt. |
| RFI-COM-L014 | An unchanged-package retry retains the original Transmittal identity. | DEC-103; DEC-108 | docs/77 §12; docs/78 §13 | E2E-18 | Candidate direct | Approved; exact retry command/idempotency key semantics remain detailed-design dependencies. |
| RFI-COM-L015 | An unchanged-package retry retains the original immutable manifest. | DEC-103; DEC-108 | docs/77 §§9,12 | E2E-18 | Candidate direct | Approved; manifest identity/content hash mechanism open. |
| RFI-COM-L016 | A retry appends attempt history and must not reset previously successful recipient outcomes. | DEC-108 | docs/77 §12 | E2E-18 | Partial | Approved behavior; source scenario says preserve attempt history/deduplicate, but successful outcome preservation needs explicit assertion. |
| RFI-COM-L017 | A changed package requires a new Transmittal linked to the prior Transmittal; the prior manifest is not rewritten. | DEC-103; DEC-108 | docs/77 §§9,12 | E2E-19 | Candidate direct | Approved; exact linkage and package-difference classification open. |
| RFI-COM-L018 | A changed recipient scope requires a new linked Transmittal; the prior manifest is not rewritten. | DEC-103; DEC-108 | docs/77 §§9,12 | E2E-19 | Candidate direct | Approved; recipient-scope change authority and recipient identity model open. |
| RFI-COM-L019 | The Transmittal manifest is frozen before dispatch and binds the exact issued response package and evidence/file versions. | DEC-108 | docs/77 §9 | E2E-19; E2E-20 | Partial | Approved; package manifest schema, evidence integrity reference and freeze transaction open. |
| RFI-COM-L020 | The frozen manifest records recipient roster, party/identity, authorized scope, distribution purpose and per-recipient acknowledgement requirement. | DEC-108 | docs/77 §§3–7,9 | E2E-15–17, E2E-19 | Partial | Approved fields; recipient identity assurance, nomination/approval and access method open. |
| RFI-COM-L021 | Formal external distribution of an issued RFI response uses a controlled Transmittal. | DEC-104 ODM-18; DEC-108 | docs/77 §§8–10 | AT-RFI-13; E2E-14–20 | Partial | Approved channel control; provider/channel implementation intentionally unselected. |
| RFI-COM-L022 | A separately authorized internal issue-only/access route remains distinct from formal external Transmittal distribution. | DEC-108 | docs/77 §§8–9 | E2E-15 | Uncovered | Approved distinction; no explicit source scenario tests the two route classes. |
| RFI-COM-L023 | RFI identity, formal revision, response version and Transmittal ID remain distinct identifiers. | DEC-107; DEC-108 | docs/74 §§1–3; docs/77 §9 | AT-RFI-02, AT-RFI-10; E2E-19 | Partial | Approved identity separation; complete cross-identifier collision/association assertions absent. |
| RFI-COM-L024 | Technical issue and RFI closure remain independent of dispatch, delivery, access, acknowledgement, substantive response and silence. | DEC-104 ODM-13; DEC-106; DEC-108 | docs/72 §§3.3–3.5; docs/77 §11; docs/78 §§9,11 | AT-RFI-08; E2E-14, E2E-16, E2E-22, E2E-24 | Partial | Approved; each communication event's non-effect requires explicit assertions. |
| RFI-COM-L025 | No default SLA, deadline, deemed receipt, contractual notice, delivery channel or additional legal effect is created by DEC-108. | DEC-108 | docs/77 §§8,15,17 | No explicit scenario | Uncovered | Absence of default is approved; project-specific contract/channel rules remain external prerequisites. |

## 2. Coverage findings

The 25 leaf requirements are not all covered by the current 41 source scenarios. Explicit gaps include:

- all-recipient delivery failure;
- Optional and Not Requested acknowledgement denominator handling;
- zero Required recipients and Not Required aggregation;
- failed delivery not counting as acknowledgement;
- retry preservation of successful recipient outcomes;
- internal route versus formal external Transmittal;
- complete identifier separation and collision handling;
- non-effect of each communication event on technical issue/closure;
- no default SLA/deemed receipt/legal-notice/channel semantics.

No new test IDs are assigned. QA must decide whether to extend AT-RFI-13/E2E-16–19 or propose new cases under an approved naming/versioning convention. Any expected result depending on provider behavior, recipient identity assurance or project contract matrix remains **Blocked — Pending Design Decision/Prerequisite**.

## 3. Required detailed-design validation

Before execution, QA/owner/records/security must resolve or explicitly record as blocked:

1. Intended-recipient manifest definition and recipient-removal/change authority.
2. Provider delivery evidence, delivery Unknown/pending states, duplicate callbacks and retry semantics.
3. Recipient identity assurance, authentication and revocation behavior.
4. Required/Optional/Not Requested assignment authority and whether acknowledgement request is per recipient or per manifest entry.
5. Acknowledgement evidence authenticity, timestamp, version binding and correction/revocation rules.
6. Substantive-response categories and authority to submit/withdraw/correct each response.
7. Transmittal manifest fields, immutable identity, package comparison and linked-transmittal semantics.
8. Internal issue-only route eligibility and its separate access controls.
9. Project/contract-specific communication matrix, if any; no legal effect or default deadline may be inferred from this design.
10. Evidence retention, privacy, recipient-held copies, export and recovery controls.

## 4. Acceptance assertion template

For every leaf requirement, the eventual QA case must record:

- leaf requirement ID and exact DEC source/version;
- exact DD section/version and open prerequisite state;
- source scenario ID or approved new test ID;
- synthetic manifest/recipient fixtures and their authority scope;
- actor, party, project and current recipient authorization;
- deterministic action and any injected delivery/retry failure;
- expected outcome with its approval basis;
- actual result, build/configuration, timestamp and retained evidence;
- pass/fail/blocked/not-applicable disposition and reviewer;
- defect, waiver, retest and release-gate linkage.

## 5. Explicit non-authorization

This document authorizes no test execution, external dispatch, real recipient notification, production-data access, provider/channel integration, permission/account change, DB/schema/migration/generated types, Storage, auth/RLS/grants, backup/restore, archive, legal hold, deletion/disposition, API/UI/code, merge, deployment or release. Execution requires separate explicit owner authorization, approved synthetic non-production environment and identities, evidence controls and required specialist reviews.
