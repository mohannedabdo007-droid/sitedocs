# DD-02 — Capability and Appointment Governance Atomic Leaf Requirements

**Document type:** Governance and acceptance traceability working draft  
**Date:** 2026-11-13  
**Status:** WORKING DRAFT — CANDIDATE ATOMIC REQUIREMENTS — OWNER/PROJECT-GOVERNANCE/SECURITY VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** implementation/ui-foundation-2026-11-11  
**Work item:** RFI-DD-02 — Capability and appointment model  
**Controlling governance:** DEC-104, DEC-105, DEC-106, DEC-109, DEC-110  
**Source set:** docs/72 §§4–8; docs/110 §§4–8; related DD-03 docs/111; DD-04 docs/127–128  
**Related lifecycle leaf layer:** docs/148

> These leaves decompose existing policy boundaries and candidate authority controls into reviewable traceability units. They do not approve capability identifiers, role bundles, grant owners, appointment instruments, emergency access, function combinations or live permissions. Candidate responsibility matrices remain design aids, not active access-control rules.

## 1. Purpose and decomposition rules

This document provides atomic governance leaves for capability authorization, appointment/delegation evidence and separation-of-duties controls.

- **Policy boundary** identifies an established restriction or authority separation from DEC-104/105/106/109.
- **Candidate control** identifies a proposed control requiring project governance and identity/security validation.
- **Open authority** means no role title, roster membership, organizational seniority, UI visibility or operational convenience can fill the missing approval.
- Capability names below describe responsibility families only. They are not machine-readable IDs, role names, permission grants or database fields.
- No actual person is appointed; no grant, revocation, delegation, impersonation or break-glass access is activated.
- Authorization must be evaluated at action time. Client-side hiding, stale session claims or prior access cannot substitute for current server-side authorization.

## 2. Atomic capability and appointment leaves

| Leaf ID | Atomic requirement | Source / authority class | Candidate verification focus | Status / unresolved dependency |
|---|---|---|---|---|
| RFI-AUT-L001 | Every consequential RFI action must be authorized by an explicit action capability rather than inferred from a job title, team membership or UI role label. | DEC-105; docs/72 §4; docs/110 §4.1 | Title-only and membership-only attempts are denied. | Policy boundary; exact capability catalogue and identifiers open. |
| RFI-AUT-L002 | Authorization must be evaluated server-side at the time each consequential action is requested. | DEC-105; docs/72 §4.1; docs/110 §4.1/4.6 | Direct API/action invocation is denied when server-side proof is absent, regardless of rendered UI. | Policy boundary; implementation architecture not selected. |
| RFI-AUT-L003 | An authorization decision must be scoped to the authenticated actor and active account identity. | docs/72 §4.1; docs/110 §4.1 | Inactive account, mismatched actor or unauthenticated invocation is denied. | Candidate control; identity/session contract requires security review. |
| RFI-AUT-L004 | Authorization must verify the effective project and party scope for the requested action. | DEC-104/105; docs/72 §4.1; docs/110 §4.1 | Cross-project and cross-party action attempts are denied unless separately evidenced scope permits them. | Policy boundary; project/party scope source remains open. |
| RFI-AUT-L005 | Authorization must verify visibility/confidentiality entitlement for the exact target resource, independently of action capability. | DEC-105; docs/72 §4.1; docs/110 §4.1 | Possession of an action capability without record visibility does not expose or mutate the record. | Policy boundary; confidentiality classification and visibility matrix require validation. |
| RFI-AUT-L006 | Authorization must bind to the exact official RFI identity and, where applicable, response cycle, revision, assignment and resource version. | DEC-104/106/107; docs/72 §4.1; docs/110 §4.1 | Permission for one RFI/cycle/assignment/version cannot be replayed against another. | Candidate control; resource identity model and DD-07 guards remain open. |
| RFI-AUT-L007 | Where the action requires an appointment, authorization must verify a current appointment covering the exact function and scope. | DEC-105; docs/72 §4.1; docs/110 §§4.1/4.5 | Missing, expired, revoked or out-of-scope appointment is denied. | Policy boundary; appointment instrument and authoritative repository open. |
| RFI-AUT-L008 | Where authority is delegated, authorization must verify the complete valid delegation chain and the exact permitted subdelegation boundary. | DEC-105; docs/72 §§4.1/4.2; docs/110 §4.5 | Missing, broken, expired or exceeded delegation chain is denied. | Candidate control; whether subdelegation is permitted remains an explicit project decision. |
| RFI-AUT-L009 | Appointment evidence must identify the appointing authority and the approved governance instrument supporting that appointment. | docs/72 §§4.2/4.4; docs/110 §4.5 | Appointment without an attributable appointing authority/instrument remains invalid or pending. | Candidate control; actual appointing authorities and instruments not supplied/approved. |
| RFI-AUT-L010 | Appointment evidence must identify the appointee and their organization/party in a way that can be checked against the requested scope. | docs/110 §4.5 | Actor-to-appointee mismatch is denied without exposing unrelated identity data. | Candidate control; identity proof and privacy minimization require security review. |
| RFI-AUT-L011 | Appointment scope must explicitly state applicable project, party, RFI class, discipline, assignment and action types wherever relevant. | DEC-105; docs/72 §4.4; docs/110 §4.5 | A valid appointment for one scope cannot authorize a broader or adjacent scope. | Policy boundary; final scope dimensions and representation remain open. |
| RFI-AUT-L012 | Appointment evidence must state its effective period and the conditions under which it expires, is suspended or is revoked. | docs/72 §§4.4/6; docs/110 §4.5/4.6 | Before-effective, expired, suspended and revoked appointments fail closed. | Candidate control; time source, expiry and suspension policy require approval. |
| RFI-AUT-L013 | Appointment evidence must identify permitted decision/action types; a general appointment label must not imply unrestricted authority. | DEC-105; docs/72 §§4.2/4.4; docs/110 §4.5 | Attempted action outside the expressly permitted function is denied. | Policy boundary; detailed action catalogue and capability identifiers open. |
| RFI-AUT-L014 | Competence or qualification evidence must be checked where the appointed function requires technical or specialist competence. | DEC-105; docs/72 §§4.2/4.5; docs/110 §4.5 | Seniority, availability or job title alone cannot satisfy a competence requirement. | Candidate control; qualification standards and competent assessor remain open. |
| RFI-AUT-L015 | Conflict-of-interest and independence conditions must be checked for functions to which separation-of-duties rules apply. | DEC-105; docs/72 §4.5; docs/110 §4.6; docs/128 | Disqualifying authorship, consolidation, decision or conflict relationships block the affected appointment/action. | Policy boundary; project-specific conflict rules and exceptions remain open. |
| RFI-AUT-L016 | The coordinator's administrative function must not imply technical scope, discipline assignment, conflict-resolution, independent-review, readiness, issue or closure authority. | DEC-105; docs/72 §4.2; docs/110 §§4.2/4.6 | Coordinator-only actor is denied each technical/approval action absent a separate valid appointment. | Policy boundary; exact delegated administrative actions remain to be approved. |
| RFI-AUT-L017 | Project Manager oversight visibility, including permitted draft visibility, must remain read-only unless a separate explicit approved policy and appointment authorizes a specific action. | DEC-105; docs/72 §4.2; docs/110 §4.6 | Read access cannot be used to edit, assign, contribute, review, issue, cancel, reopen or close. | Policy boundary; any expansion requires separate owner decision. |
| RFI-AUT-L018 | Document Control/records administration and distribution authority must not imply technical approval, technical issue or alteration of issued technical content. | DEC-105/108; docs/72 §4.2; docs/110 §§4.2/4.6 | Dispatch/records-only actor cannot issue or alter response content. | Policy boundary; exact records and dispatch appointments remain open. |
| RFI-AUT-L019 | Reviewer appointment/capability must not imply technical issuer, readiness or parent-lifecycle closure authority. | DEC-105/106; docs/72 §§4.2/4.5; docs/110 §4.6 | Reviewer attempts to issue, close or confirm readiness without a separate appointment are denied. | Policy boundary; exact review/issue function mapping requires DD-04 alignment. |
| RFI-AUT-L020 | A response author or material consolidator must not perform mandatory independent review of the same response version where separation applies. | DEC-105; docs/72 §4.5; docs/110 §4.6; docs/128 | Same-person review is denied for the exact version when mandatory independence applies. | Policy boundary; any exception must be explicit in an approved authority matrix; none is assumed. |
| RFI-AUT-L021 | Technical lead authority must remain bounded to the exact appointment, subject, discipline and delegated decision scope. | DEC-105; docs/72 §§4.2/4.5; docs/110 §§4.2/4.3 | Technical lead cannot decide another discipline's professional position or resolve a conflict outside delegation. | Policy boundary; detailed DD-03 delegation matrix and technical authority appointments remain open. |
| RFI-AUT-L022 | System/roster administration must not imply RFI visibility, impersonation, workflow authority or capability grant/revoke authority. | DEC-105; docs/72 §§4.2/4.5; docs/110 §§4.2/4.6 | Roster administrator is denied RFI access and grant operations absent separate authority. | Policy boundary; separate administrative authority and safeguards remain open. |
| RFI-AUT-L023 | Capability grant and revocation must be performed only by a separately authorized grant authority under an approved scope and governance process. | DEC-105; docs/72 §§4.4/6; docs/110 §§4.4/6 | Ordinary roster administration or coordinator status cannot grant/revoke RFI capabilities. | Candidate control; grant/revoke authority, workflow and identifiers remain open. |
| RFI-AUT-L024 | Revocation, expiry, reassignment or scope reduction must prevent subsequent use of stale appointment/capability evidence. | DEC-105; docs/72 §§4.4/4.6; docs/110 §4.6 | Old sessions, links or cached role data cannot authorize a later consequential action. | Candidate control; propagation, cache and in-flight transaction semantics depend on DD-07. |
| RFI-AUT-L025 | Authorization must be checked independently for each protected resource path, including linked records, attachments, preview, download, search, facets, counts and export. | DEC-105/109; docs/72 §§4.1/4.6; docs/110 §4.1 | Access through an alternate path cannot reveal restricted content or existence. | Policy boundary; exact resource taxonomy and privacy rules require DD-08/09/13 alignment. |
| RFI-AUT-L026 | Allow/deny and consequential authorization outcomes must retain attributable audit evidence sufficient for review under approved privacy and records rules. | DEC-109; docs/72 §4.6; docs/110 §4.6 | Evidence records actor, scope, capability, resource, state, policy/configuration version, time and correlation reference where approved. | Candidate control; audit schema, access, retention and denial-detail policy remain open under DD-14. |
| RFI-AUT-L027 | Denial responses must not disclose restricted record existence, content or cross-party metadata. | DEC-105/109; docs/72 §4.6; docs/110 §4.6 | Compare unauthorized responses across known/unknown resource identifiers and indirect search/count paths. | Policy boundary; exact privacy-safe response contract requires security validation. |
| RFI-AUT-L028 | Permitted combinations of functions must be explicitly approved and checked on the exact consequential transaction; neither universal separation nor universal combination is inferred. | DEC-105; docs/72 §4.5; docs/110 §4.3/4.6 | Unapproved combinations fail closed; role switching/shared accounts/proxy signing do not bypass checks. | Candidate control; project/risk/security function-combination matrix remains open. |
| RFI-AUT-L029 | Temporary acting appointments or emergency/break-glass access must not be available by default and require a separately approved authority, scope, controls and evidence. | docs/72 §6; docs/110 §6 | No emergency path is inferred from absence, urgency or resource shortage. | Open authority; no mechanism or exception is approved. |
| RFI-AUT-L030 | Authorization and appointment evidence must be bound to the applicable policy/configuration version and effective time used for the decision. | DEC-109; docs/72 §4.6; docs/110 §4.5/4.6 | Historical allow/deny decision can be reconstructed against the governing policy version without treating it as current authority. | Candidate control; versioning and authoritative policy store remain open. |

## 3. Capability family coverage — no identifiers approved

The following conceptual families must be independently specified and reviewed before any capability catalogue can be promoted. They are not machine-readable IDs and do not imply grants:

1. Draft create, view, edit and abandon.
2. Formal submit and controlled resubmit.
3. Record, field, attachment and version visibility.
4. Administrative intake, return, routing and coordination.
5. Technical scope determination and assignment authority.
6. Discipline assignment and scoped contribution.
7. Consolidation and bounded conflict disposition.
8. Independent review and review outcome.
9. Readiness confirmation.
10. Formal issue and technical closure.
11. Withdrawal request/validation, cancellation and reopening.
12. Transmittal preparation/dispatch and recipient-event recording.
13. Archive, retrieval and records disposition.
14. Roster administration.
15. Capability grant/revoke and workflow configuration.

Each family requires an exact action definition, resource scope, authority source, appointment requirement, permitted actor conditions, deny cases, audit evidence and review owner. No final identifier, grant owner, default grant or role bundle is selected.

## 4. Candidate appointment evidence contract

For each appointed function, the evidence model must be reviewed against the following distinct dimensions:

- appointing authority and approved governance instrument;
- appointee identity and organization/party;
- project and effective party scope;
- RFI class and exact RFI/cycle/assignment scope where applicable;
- discipline and subject scope where applicable;
- exact permitted decisions/actions;
- effective-from time and expiry/suspension/revocation conditions;
- delegation chain and permitted subdelegation, if any;
- competence/qualification evidence where required;
- independence/conflict declaration where relevant;
- appointment status at action time and audit reference.

This is a candidate evidence checklist, not a database schema or approved appointment form. The authoritative repository, approval route, evidence retention and actual appointment instruments remain open.

## 5. Candidate verification coverage and gaps

These are candidate coverage prompts to be reconciled against the exact controlled AT-RFI/E2E source definitions in docs/137 and the candidate mapping in docs/138. They are not test IDs, approved expected results or execution evidence.

| Coverage area | Leaf IDs | Minimum positive / negative / boundary focus | Current mapping status |
|---|---|---|---|
| Action-time identity and resource scope | L001–L008 | authenticated/inactive actor; project/party mismatch; wrong RFI/cycle/version; missing/stale appointment; broken delegation | Candidate; exact scenario mapping requires QA validation |
| Appointment provenance and scope | L009–L015 | missing instrument; wrong appointee/party; out-of-scope function; expired appointment; competence/independence missing | Partial; actual project appointment evidence absent |
| Role and function boundaries | L016–L022 | coordinator technical action; PM write attempt; DC issue/content edit; reviewer issue; roster-admin access; technical lead outside delegation | Candidate; expected results require authority validation |
| Grant/revoke and stale evidence | L023–L024 | unauthorized grant/revoke; revocation after session creation; reassignment; scope reduction; in-flight action race | Blocked pending grant authority and DD-07 mechanics |
| Protected resource paths and privacy | L025–L027 | direct API, attachments, preview, download, search/facets/counts/export; denial side-channel leakage | Partial; DD-08/DD-13/security contract pending |
| Function combinations and exceptions | L028–L029 | permitted vs prohibited combinations; shared account/proxy/role switching; acting/emergency request without approved instrument | Blocked pending project/risk/security authority |
| Policy version and audit reconstruction | L026/L030 | historical allow/deny evidence, policy version, timestamps, correlation, privacy-safe audit access | Partial; DD-14 retention/access rules pending |

Do not mark a leaf covered solely because a broad scenario mentions roles or permissions. Exact source wording, actor, resource, expected result and authority must match; otherwise classify it as partial or uncovered.

## 6. Required QA and specialist completion fields

For each leaf, reviewers must record:
1. Exact source document version/SHA and clause.
2. Classification as DEC policy boundary, candidate control or open authority.
3. Exact existing AT-RFI/E2E scenario ID and source wording, if a genuine mapping exists; otherwise mark uncovered.
4. Expected result and the authority approving that expected result.
5. Actor identity class, organization/party, project/RFI/cycle/resource scope and action-time context.
6. Appointment/delegation instrument and effective status where required.
7. Positive, negative, boundary, stale-session, revocation, concurrency and alternate-path cases as applicable.
8. Synthetic fixture/environment, audit evidence and approved privacy/records treatment.
9. QA owner, security reviewer, project appointing authority and relevant technical authority.
10. Dissent, unresolved prerequisite, exception or waiver request; no waiver authority is inferred.
11. Explicit execution status. Design, mapping, review and pass are separate statuses.

No AT-RFI/E2E identifiers are created or changed by this document. Unmapped requirements remain uncovered until controlled test governance approves a new identifier and baseline revision.

## 7. Open authority and dependency register

| Dependency | Required authority / evidence | Status |
|---|---|---|
| A-01 capability identifiers, action semantics and resource dimensions | Owner, identity/security, project/party governance, architecture | Blocked |
| A-02 grant/revoke authority and approval process | Appointing/project governance and identity/security | Blocked |
| A-03 actual appointment instruments and authoritative repository | Project governance, appointing authority, records, identity/security | Blocked |
| A-04 effective period, expiry, suspension and revocation rules | Appointing authority, identity/security, architecture, records | Blocked |
| A-05 permitted function combinations and separation matrix | Owner, project governance, technical/risk/quality authority, security | Blocked |
| A-06 competence/qualification standards and assessor | Discipline/technical authority, appointing authority, quality | Blocked |
| A-07 delegation chain and subdelegation permission | Project governance, appointing authority, legal/contract authority as applicable | Blocked |
| A-08 emergency/acting/break-glass authority | Owner, project governance, security, records, legal/contract as applicable | No mechanism approved |
| A-09 action-time authorization, stale session and in-flight race semantics | Architecture, identity/security, engineering, QA | Blocked pending DD-07 |
| A-10 audit evidence access, retention and privacy | Security/privacy, records authority, QA | Blocked pending DD-14 |
| DD-03 appointment/delegation boundaries | Discipline authorities and technical authority | Specialist validation pending |
| DD-04 independent review trigger/appointment rules | Approved risk/authority matrix and appointing authority | Blocked |
| DD-08/09/13 protected resource path alignment | Security, records, communication and reporting authorities | Pending cross-spec validation |

## 8. Promotion and implementation boundary

- All 30 leaves remain working-draft traceability units pending exact-version owner, project-governance, identity/security, technical and QA validation.
- Candidate capability families are not approved machine-readable identifiers.
- Responsibility matrices are not role bundles, grant tables or actual appointments.
- No person or organization is appointed by this document.
- No grant, revocation, delegation, acting appointment, emergency access or break-glass mechanism is activated.
- No test execution/pass, security certification or release readiness is claimed.
- No UI/API/code, DB/schema/migration/generated type, Storage, authentication, authorization/RLS/grant, production-data, backup/restore, merge or deployment operation is authorized.
- Any implementation requires a separate scoped plan, resolved authorities, security/records/architecture review, approved non-production rehearsal and explicit owner authorization. DB/Storage work additionally requires verified backups, isolated restore/rehearsal and reconciliation.

**Current disposition:** DD-02 capability and appointment constraints decomposed into 30 atomic governance leaves; exact identifiers, appointing/granting authorities, function combinations, appointment instruments and specialist validation remain open; no permissions or implementation authorized.

---

**End of DD-02 capability and appointment governance leaf working draft.**
