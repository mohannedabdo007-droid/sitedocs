# DD-09 / DD-10 — Recipient Identity, Controlled Distribution, Acknowledgement and Substantive Response: Atomic Leaf Requirements

**Document type:** Governance and detailed-specification traceability decomposition — working draft  
**Date:** 2026-11-13  
**Status:** WORKING DRAFT — CANDIDATE LEAVES — OWNER / CONTRACT-LEGAL / DOCUMENT CONTROL / IDENTITY-SECURITY / PRIVACY / ARCHITECTURE / RECORDS / QA REVIEW PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent specifications:** `docs/77_RFI_RECIPIENT_IDENTITY_AND_DISTRIBUTION_CHANNEL_WORKING_DRAFT.md`; `docs/78_RFI_ACKNOWLEDGEMENT_AND_SUBSTANTIVE_RESPONSE_CATALOGUE_WORKING_DRAFT.md`  
**Cross-specification review:** `docs/132_DD09_DD10_RECIPIENT_COMMUNICATION_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md`  
**Related contracts:** DEC-050/051/052, DEC-103, DEC-108; DD-02 docs/149; DD-07 docs/155; DD-08 docs/156; DD-14 docs/146; DD-15 docs/147

> This decomposition preserves the approved separation between technical delivery, access, acknowledgement, substantive response and source-RFI technical decisions. It does not select a provider/channel, identity-proofing method, legal notice mechanism, wording, response category, due date, retry policy or request granularity. It does not authorize external communication or implementation.

## 1. Atomic leaf requirements

### A. Identity and immutable communication context

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-RCP-L001 | Every formal distribution shall have one stable Transmittal identity distinct from the source RFI, response version, manifest, recipient entry and dispatch attempt. | Identity crosswalk and immutable linkage. | DEC-050/108; DD-09 |
| RFI-RCP-L002 | Every intended recipient entry shall have a stable identity within its Transmittal and shall not be identified solely by a mutable email string or display name. | Recipient-entry identity and destination reference. | DD-09 §3; RCP-01 |
| RFI-RCP-L003 | The frozen Transmittal context shall bind the exact source RFI/response version, manifest identity/version, purpose, recipient-entry set and approved request context. | Frozen context and integrity evidence. | DEC-108; DD-08; RCP-01 |
| RFI-RCP-L004 | A person identity, represented party/organization, destination endpoint and recipient-entry identity shall remain distinct data concepts. | Identity/party/endpoint relationship evidence. | DD-09 §§3–6; RCP-05 |
| RFI-RCP-L005 | A recipient nomination shall record its source, project/party scope, intended purpose, validation authority and applicable validity evidence. | Attributable nomination and validation record. | DD-09 §5; DEP-RCP-05/06 |
| RFI-RCP-L006 | A destination address or organization mailbox shall not by itself prove the identity or authority of the person who accesses or acknowledges the package. | Negative identity/authority checks. | DEC-051/052; RCP-05 |
| RFI-RCP-L007 | Any required external identity assurance or organization-endpoint verification shall be satisfied under an approved policy before protected access or an identity-attributed acknowledgement is accepted. | Approved identity policy and verification evidence; policy remains open. | DD-09 §6; DEP-RCP-05 |
| RFI-RCP-L008 | The recipient, destination and manifest snapshots used for a formal dispatch shall be preserved after freeze; corrections shall be represented by linked successor records rather than silent rewrite. | Immutable snapshot and successor lineage. | DEC-108; DD-09 §9/12 |

### B. Authorization, access and distribution scope

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-RCP-L009 | Recipient eligibility shall be evaluated for the exact project, represented party, purpose, package and intended action before dispatch. | Action-specific eligibility decision. | DEC-021/051; DD-02/DD-09 |
| RFI-RCP-L010 | Access to a Transmittal summary shall not grant access to every linked RFI record, response, evidence item, manifest entry or other recipient's information. | Per-resource and per-entry authorization evidence. | DEC-051; DD-08 |
| RFI-RCP-L011 | Every preview, metadata view, download and other protected evidence access shall re-evaluate current actor identity and exact recipient/manifest scope server-side. | Current per-operation authorization and audit. | DD-08; DD-02 |
| RFI-RCP-L012 | Possession of an old URL, prior delivery, email read state, project membership or earlier participation shall not independently authorize current access. | Negative authorization cases. | DEC-021/051; RCP-06 |
| RFI-RCP-L013 | Revocation or changed scope shall prevent subsequent unauthorized access without rewriting the frozen dispatch history. | Revocation event and immutable prior snapshot. | DD-09 §13; DEP-RCP-07 |
| RFI-RCP-L014 | Revocation shall not be represented as recall or deletion of bytes already downloaded, printed, copied or otherwise retained outside system control. | Accurate incident/correction record and residual-copy treatment. | DD-09 §12–14; DD-14 |
| RFI-RCP-L015 | Distribution shall expose only the exact frozen manifest entries and versions authorized for the particular recipient and purpose. | Recipient-to-manifest-entry scope proof. | DEC-051/108; DD-08; RCP-06 |

### C. Delivery outcome and retry integrity

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-RCP-L016 | Every intended recipient included in technical delivery shall be represented independently in the delivery population unless a separately approved distribution rule explicitly excludes that entry. | Frozen technical-delivery denominator. | DEC-103; DD-09 §10 |
| RFI-RCP-L017 | The acknowledgement denominator shall include only recipients classified Required for acknowledgement; Optional and Not Requested recipients shall not enter that denominator. | Separate frozen acknowledgement denominator. | DEC-103; DD-10 §12 |
| RFI-RCP-L018 | If no recipient is Required for acknowledgement, the acknowledgement aggregate shall be Not Required rather than zero-percent completion or an implied success. | No-required-recipient aggregate case. | DEC-103 |
| RFI-RCP-L019 | Delivered shall be reported only when every intended technical-delivery recipient has confirmed successful delivery under the approved channel evidence rule. | Recipient-level success evidence and aggregate proof. | DEC-103 |
| RFI-RCP-L020 | Partially Delivered shall be reported only when at least one intended recipient has confirmed success and at least one has confirmed failure under the approved evidence rule. | Mixed confirmed outcome evidence. | DEC-103 |
| RFI-RCP-L021 | Failed shall be reported only when every intended recipient has confirmed failure under the approved evidence rule. | All-failed evidence. | DEC-103 |
| RFI-RCP-L022 | An Unknown or Unconfirmed delivery outcome shall remain explicitly unresolved and shall not be silently treated as success, failure or a confirmed DEC-103 aggregate. | Uncertainty-preserving status and reconciliation record; aggregate mapping remains blocked. | RCP-03/04; DEP-RCP-03/04 |
| RFI-RCP-L023 | A retry of the same package, recipient set, destination scope and purpose shall retain the original Transmittal identity and add a distinct attributable attempt. | Same-scope retry lineage. | DEC-108; DD-07; RCP-07 |
| RFI-RCP-L024 | A changed package, manifest version, recipient set, destination, purpose or other material dispatch scope shall require a new linked Transmittal rather than mutation of the frozen original. | Changed-scope successor Transmittal and linkage. | DEC-108; DD-08; RCP-07 |
| RFI-RCP-L025 | Dispatch command identity, Transmittal identity, recipient-entry identity, attempt identity and any external callback/event identity shall not be conflated. | Stable identity/correlation model. | DD-07; RCP-01/07 |
| RFI-RCP-L026 | A duplicate callback or repeated delivery attempt shall not create duplicate authoritative delivery facts or erase prior outcomes. | Idempotent event processing and immutable attempt history. | DD-07; DEP-RCP-04 |

### D. Acknowledgement and substantive-response request separation

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-RCP-L027 | Acknowledgement requirement and substantive-response requirement shall be stored and governed as independent request dimensions. | Independent request fields and lifecycle. | DEC-052; DD-10 §3; RCP-09 |
| RFI-RCP-L028 | Required, Optional and Not Requested acknowledgement classifications shall not be inferred from recipient class, delivery result, access telemetry, read state or substantive-response requirement. | Negative inference controls. | DEC-103; DD-10 |
| RFI-RCP-L029 | Receipt acknowledgement and review/awareness acknowledgement shall remain distinct requested statements and evidence types. | Separate request type and attributable response. | DEC-052; DD-10 §4 |
| RFI-RCP-L030 | Acknowledgement of receipt or awareness shall not be treated as technical agreement, acceptance, approval, waiver, substantive response or source-RFI closure. | Explicit semantic separation in records and UI. | DEC-052/108 |
| RFI-RCP-L031 | The granularity of acknowledgement and substantive-response requests—per recipient, per manifest entry or another approved unit—shall remain blocked until owner, Document Control and architecture approve the request unit and roll-up rule. | Recorded authority decision; no inferred granularity. | RCP-10; DEP-RCP-02/10 |
| RFI-RCP-L032 | Any future request-level aggregation shall preserve separate counts for recipient population, request units and submitted response events and shall not alter DEC-103's Required-only recipient denominator. | Distinct aggregation dimensions and denominator tests. | DEC-103; RCP-03/10 |
| RFI-RCP-L033 | Acknowledgement wording, localization, substantive-response tri-state adoption and response categories shall remain unapproved until the authorized owner and relevant contract/technical reviewers decide them. | Approved versioned wording/catalogue; values remain open. | DEP-RCP-10 |
| RFI-RCP-L034 | A permission to view or acknowledge receipt shall not imply authority to submit a substantive technical response, review/close that response or make a source-RFI technical decision. | Action-specific capability and appointment evidence. | DEC-105/108; DD-02; RCP-11 |
| RFI-RCP-L035 | A substantive response shall bind to the exact request, Transmittal, manifest and response/package version to which it relates. | Immutable request-response linkage. | DD-10 §6–8; RCP-12 |
| RFI-RCP-L036 | A substantive response submission shall preserve its original content and attributable submitter/time; any correction or supplement shall be a linked successor record. | Immutable response event and correction lineage. | DD-10 §8/10; DD-07 |
| RFI-RCP-L037 | A substantive response shall not silently mutate the source RFI lifecycle, technical answer, issue/closure state or authority assignment. | Source/response boundary and negative state-change checks. | DEC-108; RCP-12 |
| RFI-RCP-L038 | A response that constitutes a new engineering question shall be routed for separate RFI classification under the approved DEC-106 rules rather than appended as an ungoverned expansion of the original inquiry. | New-RFI classification and independent identity. | DEC-106; DD-05 |

### E. Incidents, records and legal boundary

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-RCP-L039 | Wrong-recipient handling shall distinguish future-access suspension, corrective distribution, incident investigation, residual-copy handling and any separately authorized external notification. | Incident record with distinct actions and authorities. | RCP-08; DEP-RCP-07/09 |
| RFI-RCP-L040 | Delivery, access, acknowledgement, substantive response, correction, revocation and incident events shall be attributable, immutable and reconstructable under approved privacy/records controls. | Event lineage and records mapping. | DEC-107/109; DD-14 |
| RFI-RCP-L041 | No provider receipt, email read event, portal view, acknowledgement or silence shall be assigned contractual notice, deemed receipt, acceptance or other legal effect without an approved governing instrument. | Contract/legal decision reference; no inferred legal effect. | DEC-052; DD-09/10 |
| RFI-RCP-L042 | No default channel, provider, retry count, timeout, cadence, target date, SLA or escalation threshold shall be introduced without an authorized decision. | Approved policy configuration and traceable source. | DEC-109; DD-09/10 |
| RFI-RCP-L043 | QA acceptance shall cover identity/party mismatch, unauthorized access, frozen-scope changes, mixed/unknown delivery, same-scope retry, changed-scope Transmittal, duplicate callback, acknowledgement independence, wrong-recipient response and immutable correction cases using approved synthetic fixtures. | QA-approved scenario/fixture/expected-result evidence. | DEC-110; docs/137–147 |
| RFI-RCP-L044 | No external dispatch, recipient notification, access grant, identity integration, response workflow or production communication shall be enabled until the relevant owner, contract/legal, security/identity, architecture, records and QA gates are separately satisfied and explicitly authorized. | Separate scoped implementation/release authorization. | docs/70; docs/132; DEC-110 |

## 2. Cross-review dependency reconciliation

The exact-version desk review in docs/132 recorded RCP-01–RCP-12 and DEP-RCP-01–DEP-RCP-12. No direct normative contradiction was identified; the following dependencies remain open and must not be replaced by assumptions:

- Canonical identity/cardinality across Transmittal, recipient entry, manifest, request, response, attempt and callback.
- Request granularity and roll-up without changing DEC-103's Required-only recipient denominator.
- Channel-specific confirmed delivery evidence and Unknown/Unconfirmed aggregate treatment.
- Provider callback correlation, retry, timeout/unknown reconciliation and idempotency scope.
- Recipient classes, endpoint governance, external identity proofing and represented-party verification.
- Recipient nomination/validation and organizational endpoint authority.
- Per-recipient/per-entry access matrix, revocation, sessions/caches and residual-copy response.
- Wrong-recipient incident authority and contractual/legal notification consequences.
- Acknowledgement wording/localization, substantive-response requirement adoption and response categories.
- Action-specific acknowledgement/substantive-response/review/closure/source-decision appointments.
- Response lifecycle, target dates and any legal/evidentiary effect under DD-11 dependencies.

## 3. DD-15 candidate mapping instructions

Map each leaf only to exact AT-RFI/E2E source scenario text in docs/137 and exact expected-result authority. Preserve original scenario IDs. Mark uncovered, partial or blocked where the source inventory does not genuinely exercise the behavior. Do not invent scenarios, identity assurance levels, wording, channel outcomes, fixtures, due dates, test owners or pass status. A process/contract/security decision is not a passed software test.

## 4. Implementation boundary

No channel/provider, identity-proofing mechanism, mailbox model, legal effect, response code, request granularity, capability grant, retry policy, timeout, SLA, target date or escalation threshold is approved by this document. No external dispatch, email, recipient notification, access grant, DB/schema/migration/generated type, Storage, auth/RLS/grant, API/UI/code, production data operation, live workflow test, backup/restore, merge or deployment is authorized.

**Current disposition:** 44 candidate leaves prepared. RCP-01–RCP-12 and DEP-RCP-01–DEP-RCP-12 remain pending authority/specialist validation. No external communication, test execution/pass or implementation authorization is claimed.
