# RFI Owner and Specialist Review Matrix — Working Draft

**Document type:** Consolidated review, authority and disposition planning matrix  
**Date:** 2026-11-12  
**Status:** WORKING — OWNER / DOMAIN REVIEW PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Inputs:** `docs/71`, `docs/72`–`docs/84`; controlling governance decisions DEC-103–DEC-110  
**Purpose:** Convert cross-specification risks CR-01–CR-12 into a reviewable register that distinguishes owner decisions, specialist validation and formally appointed operational authority.

> This matrix assigns review domains, not named people, appointments, delegations, or approval powers. A job title, project membership, technical contribution or specialist review does not itself confer decision authority. No item is marked approved by inclusion in this matrix.

## 1. How to use this matrix

For each row:
1. The **owner decision** column identifies the policy/detail disposition that requires the project owner or another explicitly designated decision authority. Where the owner is the decision point, this matrix says so; it does not presume the owner can replace a legally, contractually or technically mandated authority.
2. The **specialist validation** column identifies domains that must assess feasibility, security, records integrity, technical correctness or operational consequences. Validation is advice/evidence unless a separate appointment grants approval authority.
3. The **operational authority evidence** column identifies the appointment, delegation, scope or competency evidence that must exist before a person can perform a controlled operational action.
4. Status is a planning control. It is not a test result, approval or implementation permission.

Use one disposition per decision/rule, preserve dissent and rationale, and link any governance change back through the formal decision register. Do not bundle unrelated decisions into a single blanket sign-off.

## 2. Status vocabulary

| Status | Meaning |
|---|---|
| Open | A substantive rule/value or authority decision has not been resolved. |
| Pending review | A draft exists and the required owner/specialist review has not been recorded. |
| Blocked — Pending Decision/Prerequisite | Dependent design, implementation or test activity must not proceed until the stated decision/evidence exists. |
| Confirmed governance constraint | A boundary already established by DEC-103–DEC-110; preserve it and do not reopen it through detailed design. |
| Editorial correction complete | A document/indexing defect was corrected; this does not approve the underlying policy. |

No status of “Approved” is pre-populated. An approved disposition may be recorded only after the actual authorized decision-maker has acted and the evidence is retained.

## 3. Owner and specialist review matrix

| Risk ID | Scope / linked work | Owner decision required | Specialist validation required | Operational authority / evidence required before action | Current status and interim control |
|---|---|---|---|---|---|
| CR-01 | DD-01; `docs/72`; lifecycle vocabulary, transition guards, terminal meaning, parent/child aggregation | Decide final state model, consequential transition rules, closure semantics and aggregation behavior; confirm alignment with approved RFI policy | Process design, technical architecture, Document Control, security/QA review of invalid transitions and auditability | Evidence of appointment and scope for originator, coordinator, discipline lead, reviewer, issuer and closure authority; action-level delegation and revocation rules | **Blocked — Pending Decision/Prerequisite.** Candidate lifecycle labels remain proposals; no state machine or workflow implementation. |
| CR-02 | DD-02; `docs/72`; capability catalogue, appointments, delegation, expiry/revocation | Decide the authority model and which project/party roles may nominate or appoint capabilities, including delegation boundaries | Identity/security, project/party governance, privacy and architecture validation; deny-matrix review | Verifiable appointment record: appointing authority, appointee, capability, project/party/discipline scope, permitted actions, effective period, delegation limits and revocation | **Blocked — Pending Decision/Prerequisite.** No role grants, permission mapping or appointment inferred from membership/title. |
| CR-03 | DD-03/DD-04; `docs/72`; discipline responsibility, technical leadership, conflict handling and independent review | Decide discipline accountability, technical-lead selection/authority, material-conflict disposition, dissent preservation and risk-based independent-review triggers | Relevant discipline specialists, technical/risk authority, QA and security; reviewer competence and independence assessment | Formal technical-lead and reviewer appointments, scope/competence evidence, conflict-of-interest declaration and authorized substitution route | **Pending review / Blocked — Pending Decision/Prerequisite.** No coordinator tie-break, majority-vote shortcut or self-review assumption. |
| CR-04 | DD-05/DD-06; `docs/73`–`docs/74`; clarification/revision classification, official number format, uniqueness namespace and legacy reconciliation | Decide final displayed number pattern, uniqueness scope, ambiguity/materiality decision ownership and acceptable legacy collision dispositions | Document Control, document-family governance, records/data stewardship, architecture/security validation of atomic uniqueness and historical traceability | Appointment of numbering/records custodians and authorized classification/legacy disposition decision-makers; approved complete source inventory and collision evidence | **Blocked — Pending Decision/Prerequisite.** No guessed numbering format, allocator, sequence reservation, renumbering or migration. |
| CR-05 | DD-07; `docs/75`; idempotency, concurrency, transaction boundaries, event ordering and recovery | Approve user-visible command semantics, duplicate/replay outcomes and acceptable recovery behavior; confirm lifecycle rules on which transactions depend | Architecture/engineering, data integrity, security and records review; failure-mode and reconciliation analysis | Authorized system operators and change/recovery approvers under a separately approved operational plan; named incident/recovery responsibilities | **Blocked — Pending Decision/Prerequisite.** Architecture-neutral design only; no state-changing implementation or live recovery. |
| CR-06 | DD-08; `docs/76`; attachment/evidence classification, scanning, integrity, encryption, access, cache and retention | Decide evidence classes, acceptable risk/control policy, retention dependencies and permitted evidence use | Security, privacy, records, architecture and operations validation; malware/active-content, integrity and access-control review | Explicitly authorized evidence custodians, security operators and records custodians; documented access purpose and per-operation authorization model | **Blocked — Pending Decision/Prerequisite.** No real upload, preview, download, replacement, storage configuration or deletion. |
| CR-07 | DD-09; `docs/77`; recipient identity, party representation, external access and channel/provider | Decide recipient classes, nomination/verification standard, external distribution route and any permitted exception; preserve DEC-108 distinction between formal external Transmittal and separately authorized internal access | Contract/communications, identity/security, privacy, Document Control and architecture validation | Evidence of authority to nominate recipients for a party; verified recipient identity/representation; approved channel operator and revocation/offboarding responsibility | **Blocked — Pending Decision/Prerequisite.** No provider/channel/public link or external recipient mechanism selected by assumption. |
| CR-08 | DD-10; `docs/78`; acknowledgement requirements and substantive-response catalogue | Decide which recipient classes require acknowledgement, exact meaning/wording, substantive-response categories and whether a response is required for a given distribution | Technical authority, Document Control, contract/communications, records and UX/accessibility review | Authorized issuer of response requirements and authorized recipient representatives; evidence distinguishing Required, Optional and Not Requested | **Pending review / Blocked — Pending Decision/Prerequisite.** Candidate catalogue only; preserve DEC-103 aggregation and do not infer acceptance from silence/access/delivery. |
| CR-09 | DD-11; `docs/79`; reopening, withdrawal, cancellation, closure and delegation gates | Decide unresolved eligibility criteria, substantive-work threshold, authorized reasons and reopening scope while preserving DEC-106 rules | Technical authority, Document Control, records and QA; concurrency/history impact review | Explicitly appointed withdrawal validator, cancellation authority, reopening authority and closure authority with project/RFI scope | **Blocked — Pending Decision/Prerequisite.** Preserve prior cycles and issued responses; no inferred lifecycle mutation. |
| CR-10 | DD-12/DD-13; `docs/80`–`docs/81`; notification events, recipient rules, metrics, search, reports and exports | Decide event/recipient policy, audiences, metric definitions, date/as-of semantics, export purposes and any thresholds/suppression rules | Security/privacy, reporting/operations, architecture, QA, Document Control and records validation | Authorized report owners/export approvers, notification administrators and data custodians; current entitlement and purpose checks | **Blocked — Pending Decision/Prerequisite.** No default cadence, SLA, channel, priority, metric formula, broad search or export permission. |
| CR-11 | DD-14; `docs/82`; records series, retention, archive, legal hold, backup copies and disposition | Decide records schedule ownership, retention triggers/durations, archive policy, hold authority/scope/release, disposition conditions and residual-copy treatment | Records management, legal/contract as applicable, security, architecture, operations and data/Storage validation | Evidence of authorized records disposition and legal-hold authorities, delegated custodians, approved schedule and hold/release instructions | **Blocked — Pending Decision/Prerequisite.** Expiry permits controlled review only; no automatic deletion, archive/hold operation or backup/restore. |
| CR-12 | DD-15; `docs/83`; test inventory, ownership, environments/data, severity, waivers and release gates | Approve test governance, acceptance ownership, non-waivable blockers, permissible waiver boundaries and release sign-off authority | QA/test lead, security, records, architecture, operations and relevant technical authorities; verify actual AT-RFI-01–13 and 28 E2E definitions | Named test designers/executors/reviewers/approvers with competence and independence evidence; approved isolated environment and synthetic-data owner; authorized release approver | **Blocked — Pending Decision/Prerequisite.** Scenario counts are proposed inputs only; no test execution, pass claim, waiver or release approval. |

## 4. Confirmed governance constraints — preserve, do not reopen

The following are not open policy questions in this review. Specialists may validate how a detailed design preserves them, but may not silently alter them:

| Decision | Confirmed constraint to preserve | Review implication |
|---|---|---|
| DEC-103 | Delivery aggregation is recipient-level; Delivered only when all intended recipients succeed, Partially Delivered when some succeed and some fail, Failed when all fail. Acknowledgement completion counts only explicitly Required recipients. | DD-09/DD-10/DD-12/DD-13/DD-15 must use the same denominator and event distinctions. |
| DEC-104–DEC-105 | Owner-confirmed RFI operating direction, multidisciplinary contribution, technical leadership, authority and independent-review boundaries do not create automatic grants or appointments. | Review authority evidence and scope; do not infer permissions from a role label. |
| DEC-106 | Clarification, withdrawal, cancellation, reopening, closure and date controls retain their approved distinctions; reopening preserves prior history. | DD-05/DD-11 must refine, not reverse, these rules. |
| DEC-107 | Formal submission minimums, official number allocation point and immutable evidence/version principles remain distinct; final display format and legacy reconciliation remain unresolved. | DD-06/DD-08 may resolve detail only through explicit review; no guessed number pattern. |
| DEC-108 | Authorized technical issue is separate from Document Control distribution; formal external distribution uses controlled Transmittal; delivery, access, acknowledgement and substantive response are distinct. | DD-09/DD-10 must preserve separate events and authority boundaries. |
| DEC-109 | Lifecycle, workload, monitoring, communication and records indicators remain separate; no default SLA, notification cadence, retention duration or automatic disposition. | DD-12–DD-14 must not introduce defaults by convenience. |
| DEC-110 | Verification requires traceability and retained evidence; proposed scenarios are not execution evidence; unresolved prerequisites block dependent tests; specified security/integrity/authority/recipient/data-loss failures are blockers. | DD-15 must not claim execution or acceptance without approved conditions and evidence. |

Any proposed amendment to these constraints must return to the owner through the formal governance decision process and be recorded in the controlling decision register before dependent design changes.

## 5. Review outcome register — required record format

Create one entry per discrete decision or rule. Do not use a single signature to approve an entire workstream unless the authority explicitly approves every listed item and scope.

| Field | Required content |
|---|---|
| Review item ID | Unique stable ID, linked to CR-xx and DD-xx/section |
| Exact rule / question | The specific wording or value under review |
| Disposition | Approve / Amend / Reject / Defer — Pending Decision/Prerequisite |
| Rationale and evidence | Reason, supporting evidence, alternatives considered and preserved dissent |
| Scope and limitations | Project, party, discipline, workflow, record class, effective date/version and exclusions |
| Owner decision | Decision-maker identity and the documented basis of authority; or explicit statement that another mandated authority decides |
| Specialist validation | Reviewer identity, domain, findings, limitations and any unresolved objection |
| Operational authority evidence | Appointment/delegation reference, scope, competence and effective period where an operational action is involved |
| Date and version | Decision date, specification version and review record version |
| Governance linkage | Existing DEC reference; if policy changes, proposed new/amended DEC and register/traceability updates |
| Impact assessment | Affected DD documents, UI/API/DB/Storage/security/records/test impacts, dependencies and migration/reconciliation needs |
| Acceptance evidence | Required document, review record, test design or other evidence; never fabricate execution evidence |

A blank register entry is not approval. “No objection” or silence is not an affirmative disposition.

## 6. Recommended review sequence and exit criteria

1. **Authority foundation:** CR-01 and CR-02 together. Do not approve lifecycle transitions without knowing who is entitled to perform each consequential action.
2. **Technical integrity:** CR-03. Resolve discipline accountability, conflict and independent review before approving issue gates.
3. **Identity and transaction integrity:** CR-04 and CR-05. Complete legacy inventory and architecture/security review before numbering or transaction design is promoted.
4. **Evidence security:** CR-06. Complete security/records/architecture review before Storage or file-service planning.
5. **Recipient communication:** CR-07 and CR-08. Confirm recipient identity/authority and distribution route before acknowledgement or response wording is finalized.
6. **Lifecycle exceptions:** CR-09. Confirm authorized reopening/withdrawal/cancellation routes and preserved history.
7. **Operational visibility:** CR-10. Approve recipient/event privacy, metric definitions and export boundaries.
8. **Records governance:** CR-11. Resolve schedule/hold/disposition authority and copy lifecycle before any records operation.
9. **Verification governance:** CR-12. QA imports the actual scenario definitions, maps each to approved rules and obtains environment/data/ownership approval. Only then may a separate test execution plan be submitted.
10. **Consolidated disposition:** publish the completed owner disposition register, update affected DD documents and backlog, and perform a new cross-specification consistency review. If governance policy changes, update the formal DEC register and traceability on the governance branch through its controlled process.

A workstream exits review only when every consequential rule has a recorded disposition, required specialist findings are addressed, operational appointments are evidenced where applicable, dependent CRs are reconciled, and no blocking objection remains unresolved. This is a proposed review gate, not a claim that any workstream has passed it.

## 7. Implementation and test blockers

Until the relevant decision and prerequisite evidence is recorded:
- Do not encode candidate lifecycle states, transitions, capabilities, grants, appointments or delegation.
- Do not allocate official RFI numbers, migrate or reconcile legacy identities, or change numbering data.
- Do not implement state-changing transaction, idempotency, event, retry or recovery behavior.
- Do not configure Storage, scanning, encryption, preview/download, external identity, provider/channel or Transmittal integration.
- Do not implement notifications, report/search/export permissions, retention schedules, archive, legal hold, deletion or disposition.
- Do not execute tests against real users, production data, live workflows or external recipients; do not claim proposed scenarios passed.
- Do not approve waivers, release readiness, merge or deployment under this matrix.

## 8. Explicit scope boundary

This document is a review-planning artifact only. It does not amend DEC-103–DEC-110, approve DD-01–DD-15, appoint any person, create any permission, or authorize application/API/UI changes, DB/schema/migrations/generated types, Storage, authentication, authorization, RLS, grants, production-data access/change, live workflow or external communications, test execution, backup/restore, archive, legal hold, deletion, disposition, merge or deployment.

Any later implementation or execution requires a separate scoped plan, resolved prerequisite decisions, relevant owner and specialist approvals, approved non-production environment and synthetic data, and explicit owner authorization. DB/Storage work additionally requires verified backups, isolated restore/rehearsal and reconciliation before any change.

## 9. Current disposition

**Prepared:** consolidated CR-01–CR-12 review matrix, status vocabulary, governance constraints, review outcome register template, sequence and implementation blockers.

**Recorded:** OR-01 owner dispositions DISP-OR01-001 and DISP-OR01-003–014 are conditionally approved for their exact scopes; DISP-OR01-002 is a DEC-107 consistency review only. **Not completed:** OR-02–OR-12 owner dispositions, specialist sign-offs, appointment evidence, final detailed-specification approvals, scenario inventory verification, test execution or implementation readiness.

**Result:** OR-01 owner-disposition recording is complete for its 13 substantive items, but specialist validation and detailed-design closeout remain pending; OR-02–OR-12 remain open or blocked. No implementation, test execution, merge or deployment is authorized.
