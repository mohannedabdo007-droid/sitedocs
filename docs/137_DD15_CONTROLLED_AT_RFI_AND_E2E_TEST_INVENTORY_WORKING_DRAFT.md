# DD-15 Controlled AT-RFI and E2E Scenario Inventory — Working Draft

**Document type:** Source-preserving test inventory and candidate traceability map  
**Date:** 2026-11-12  
**Status:** SOURCE INVENTORY VERIFIED AGAINST WORKING-DRAFT SOURCE — QA / OWNER / SPECIALIST VALIDATION PENDING — NO TEST EXECUTION OR PASS CLAIM  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Controlling governance:** DEC-103–DEC-110, especially DEC-110  
**Exact source:** `docs/69_RFI_WORKFLOW_DESIGN_WORKING_DRAFT.md` on the same branch  
**Source blob SHA at inventory:** `23e892245c4120ce361e5673585539136707b70e`  
**Source locations:** §8, lines 507–522 (AT-RFI); §21.4, lines 1540–1567 (E2E)

> This file imports the exact scenario descriptions and candidate outcomes from the cited working-draft source. It does not promote those descriptions into final approved expected behavior, alter DEC-103–DEC-110, or claim execution. Every case remains a test-design item until the relevant prerequisites, expected outcomes, environment, authority and evidence are approved.

## 1. Inventory result

<badge>Source definitions located</badge>

- AT-RFI scenarios: **13 of 13** located and transcribed from `docs/69` §8.
- E2E race/edge-case scenarios: **28 of 28** located and transcribed from `docs/69` §21.4.
- Original identifiers preserved without renumbering.
- Candidate DD/DEC crosswalk added below for QA review; mappings are not an approved requirement baseline.
- No scenario was executed in this inventory work.
- No source definition was invented, renamed or marked Passed.

The earlier DD-15 statement that the definitions were not imported was accurate at the time of the first review. This file closes the source-discovery/import gap only. It does not close the broader traceability, authority, fixture, evidence or test-execution gaps.

## 2. AT-RFI acceptance scenario inventory

**Source:** `docs/69_RFI_WORKFLOW_DESIGN_WORKING_DRAFT.md`, §8, lines 507–522.  
**Source status:** Proposed test definitions in a non-authoritative working draft.  
**Candidate map status:** QA validation required.

| ID | Source title and definition | Candidate DD mapping | Candidate governing references |
|---|---|---|---|
| AT-RFI-01 | **Engineering inquiry:** an authorized originator can create and formally submit an RFI containing the approved required fields; an inspection-only WIR action cannot create or resolve it. | DD-01, DD-02, DD-05 | DEC-002, DEC-021, DEC-104, DEC-105, DEC-107 |
| AT-RFI-02 | **Type isolation:** RFI and WIR use distinct document-type configuration, numbering stream, permission checks, workflow actions, reports, and audit events; no conversion or substitution occurs implicitly. | DD-01, DD-02, DD-06, DD-13 | DEC-002, DEC-021, DEC-022-A/B, DEC-104 |
| AT-RFI-03 | **Authorized resolution:** only the actor and capability explicitly approved for the relevant response/closure step can issue the technical response or close the RFI; draft response, comment, delivery, read, and silence do not count as an issued engineering resolution. | DD-01, DD-02, DD-10, DD-11 | DEC-021, DEC-104, DEC-105, DEC-106, DEC-108 |
| AT-RFI-04 | **Cross-type and cross-party security:** unauthorized parties cannot read drafts, attachments, responses, or audit data; no PM read-only, administrator, originator, responder, or WIR permission grants unrelated RFI authority. | DD-02, DD-08, DD-09, DD-13 | DEC-021, DEC-105, DEC-107, DEC-109 |
| AT-RFI-05 | **Snapshot integrity:** submitted question, references, and attachments remain bound to the exact submitted version; later edits create a traceable new version or approved linked event. | DD-07, DD-08 | DEC-022-B, DEC-107, DEC-110 |
| AT-RFI-06 | **Response history:** every response, clarification, review, issue, cancellation, withdrawal, and closure event retains actor, timestamp, scope, and prior history; no silent overwrite. | DD-07, DD-08, DD-11, DD-14 | DEC-106, DEC-107, DEC-109, DEC-110 |
| AT-RFI-07 | **Multidisciplinary completeness:** if multiple responders are approved, no final consolidated response or closure occurs while a required contribution remains outstanding. | DD-03, DD-04, DD-01 | DEC-104, DEC-105, DEC-110 |
| AT-RFI-08 | **No false closure:** delivery, acknowledgement, read state, due-date expiry, or a draft answer does not silently close the RFI. | DD-01, DD-09, DD-10, DD-11, DD-12 | DEC-103, DEC-106, DEC-108, DEC-109 |
| AT-RFI-09 | **Reopen/linkage:** any approved reopening or follow-up creates the correct auditable link and does not rewrite the prior closed record. | DD-05, DD-11, DD-14 | DEC-106, DEC-107, DEC-109 |
| AT-RFI-10 | **Number integrity:** drafts and failed validation do not consume official numbers if the approved numbering rule says otherwise; RFI numbers never collide with or reuse WIR numbers. | DD-06, DD-07 | DEC-002, DEC-022-A/B, DEC-107 |
| AT-RFI-11 | **Metric counting units:** dashboard tests distinguish unique RFI identities, cycles, response events, open action assignments, recipients and clarification events; no mixed-unit total is presented as an RFI count. | DD-13 | DEC-103, DEC-109, DEC-110 |
| AT-RFI-12 | **Metric cut-off and dates:** the same source dataset and explicit timezone/as-of cut-off produce reproducible period totals; requested dates without an approved target meaning do not become overdue actions. | DD-13 | DEC-109, DEC-110 |
| AT-RFI-13 | **Recipient aggregation:** package delivery and acknowledgement summaries reconcile to individual recipient/manifest-entry outcomes; partial delivery and acknowledgement-required scope remain visible without implying technical resolution. | DD-09, DD-10, DD-13 | DEC-103, DEC-108, DEC-109 |

## 3. E2E race and edge-case scenario inventory

**Source:** `docs/69_RFI_WORKFLOW_DESIGN_WORKING_DRAFT.md`, §21.4, lines 1540–1567.  
**Source status:** Proposed end-to-end design scenarios.  
**Candidate map status:** QA and relevant authority validation required.

| ID | Competing events / edge case (source wording) | Required safe outcome (source wording) | Candidate DD mapping |
|---|---|---|---|
| E2E-01 | Two originators submit competing first-submission requests for the same draft or duplicate inquiry | One valid official allocation per accepted submission; no duplicate number or silent merge; duplicate handling follows authorized review | DD-06, DD-07 |
| E2E-02 | Two first submissions attempt to allocate the next RFI number concurrently | Official allocation is unique within the approved project scope; failed/abandoned submissions consume no number | DD-06, DD-07 |
| E2E-03 | Coordinator changes a discipline assignment while the responder submits a contribution | Preserve the contribution's author, assignment context and version; determine validity against the authoritative assignment at submission; do not rewrite authorship | DD-02, DD-03, DD-07 |
| E2E-04 | A discipline contribution arrives while the technical lead is consolidating | Preserve both versions; consolidation must reference the exact contribution versions used; changed inputs require explicit reconciliation | DD-03, DD-07, DD-08 |
| E2E-05 | A technical conflict is escalated while a response is marked Ready for Issue | Escalation alone is not resolution; block issue until an authorized resolution or permitted documented disposition satisfies the gate | DD-03, DD-04, DD-01 |
| E2E-06 | Reviewer approves candidate V1 while author submits changed candidate V2 | Review remains attached to V1; V2 cannot inherit V1's review; apply the required new review gate | DD-04, DD-07, DD-08 |
| E2E-07 | Reviewer appointment or capability is revoked after review assignment but before review action | Recheck current authority; deny the action if no longer authorized; preserve prior valid events | DD-02, DD-04 |
| E2E-08 | A clarification request is raised while a response is being prepared for issue | Keep the clarification request and response candidate distinct; apply the approved blocking rule; no silent issue against stale scope | DD-05, DD-07 |
| E2E-09 | A formal revision is submitted while an earlier response candidate is under review | Bind each review to its exact revision/candidate; determine supersession and active-cycle behavior explicitly; no review transfer | DD-05, DD-06, DD-07 |
| E2E-10 | Two authorized issuers attempt to issue competing response versions | Only one version may become the authoritative issue for the applicable cycle under the approved gate; preserve rejected/stale attempts and reasons | DD-01, DD-02, DD-07 |
| E2E-11 | Issue succeeds but the client times out before receiving confirmation | A retry must discover the authoritative recorded result and must not issue or close twice | DD-07 |
| E2E-12 | Formal issue is attempted while a mandatory review or blocking conflict remains open | Reject issue; retain the candidate and outstanding gate; no technical closure | DD-01, DD-03, DD-04 |
| E2E-13 | A separate closure action is configured and attempted before formal issue | Reject closure; preserve the RFI as not technically closed | DD-01 |
| E2E-14 | A delivery failure occurs after successful technical issue and closure | Keep the RFI technically closed; show the recipient/Transmittal delivery failure independently | DD-09, DD-10, DD-11 |
| E2E-15 | A recipient's access is revoked after dispatch but before opening an exact manifest entry | Deny future system-controlled access under current authorization; preserve dispatch and denial evidence; do not claim remote recall | DD-02, DD-08, DD-09 |
| E2E-16 | Recipient opens/downloads a package while acknowledgement is required | Record observable access separately; acknowledgement remains pending until explicit authenticated acknowledgement | DD-09, DD-10 |
| E2E-17 | One required recipient fails delivery while others succeed and acknowledge | Aggregate remains Partially Delivered and acknowledgement incomplete; do not average or suppress the failed recipient | DD-09, DD-10 |
| E2E-18 | A retry is attempted for the unchanged package | Preserve the same Transmittal identity and immutable manifest; append recipient attempt results and deduplicate repeated commands | DD-07, DD-09 |
| E2E-19 | Recipient list or package contents change after dispatch | Do not mutate the issued manifest; create a linked new Transmittal for changed scope/package under authorized rules | DD-08, DD-09, DD-10 |
| E2E-20 | A correction is required after response issue and after some recipients have accessed the original | Preserve the original issued response and access history; create the controlled corrected version/package and notify affected authorized recipients under approved rules | DD-05, DD-08, DD-09, DD-10, DD-11 |
| E2E-21 | Reopening is requested while a new linked RFI is being created for materially independent scope | Apply the technical authority's recorded classification; prevent duplicate active handling or silent redirection; retain links and reasons | DD-05, DD-11 |
| E2E-22 | Reopening is approved while a historical Transmittal acknowledgement is still pending | Preserve old recipient obligations/history as historical facts; define any new distribution/acknowledgement request separately for the new cycle | DD-09, DD-10, DD-11 |
| E2E-23 | Withdrawal is requested while a formal issue or distribution event is in progress | Do not infer withdrawal from the request; resolve ordering and authority before the consequential event; preserve any already completed issue/distribution facts | DD-07, DD-11 |
| E2E-24 | Source response is withdrawn after a Transmittal was issued | Source withdrawal and Transmittal withdrawal/cancellation remain separate authorized events; preserve the package and all recipient receipts; assess controlled notice | DD-09, DD-10, DD-11 |
| E2E-25 | Duplicate cancellation is requested after both records have contributions or reviews | Preserve both histories; authorized decision identifies surviving record and relationship; no silent transfer of contributions, approvals or acknowledgements | DD-01, DD-03, DD-11 |
| E2E-26 | Archive is requested while a legal hold or linked evidence dependency exists | Fail closed for disposition; preserve all in-scope records and exact relationships; archival must not erase or broaden access | DD-08, DD-14 |
| E2E-27 | A user exports a register while their party scope or assignment changes | Reauthorize the export at execution; filter rows/fields/attachments under current scope; preserve report parameters and as-of cut-off | DD-02, DD-13 |
| E2E-28 | A notification is delayed or opened after its underlying action is completed or revoked | Notification read state does not change workflow; destination rechecks current authorization and authoritative state | DD-02, DD-12 |

## 4. Candidate traceability and test-classification crosswalk

The DD mappings above are derived from scenario subject matter and the referenced sections in `docs/69`. QA must validate every mapping against the exact DD requirement and governing DEC. A scenario may map to multiple atomic requirements; a broad DD label is not sufficient coverage evidence.

| Test family | Baseline scenarios | Test dimensions to derive only after expected behavior is approved |
|---|---|---|
| RFI/WIR separation, origination, lifecycle and authority | AT-RFI-01–04, AT-RFI-08–10; E2E-01–02, E2E-10–13, E2E-21, E2E-25 | Authorized/unauthorized actors, draft vs formal submission, stale action, wrong document family, duplicate identity, transition guards |
| Multidisciplinary responsibility and independent review | AT-RFI-07; E2E-03–07, E2E-12 | Assignment races, contribution provenance, conflict, review independence, appointment revocation, exact candidate version |
| Clarification, revision, reopening, withdrawal and cancellation | AT-RFI-06, AT-RFI-09; E2E-08–09, E2E-20–25 | Same-RFI clarification vs formal revision vs linked RFI, history preservation, authority and concurrency |
| Numbering, idempotency and transaction integrity | AT-RFI-10; E2E-01–02, E2E-10–11, E2E-18, E2E-23 | Concurrent allocation, replay, timeout-after-success, changed payload, no duplicate consequence |
| Evidence, manifest, recipient and communication | AT-RFI-05, AT-RFI-13; E2E-14–20, E2E-22, E2E-24, E2E-26 | Exact version binding, action-time access, immutable manifest, recipient aggregate, acknowledgement distinction, external correction |
| Reporting, date semantics, notification and privacy | AT-RFI-11–12; E2E-27–28 | Counting units, timezone/as-of, permission changes, aggregate leakage, delayed notification |
| Records and recovery | AT-RFI-06; E2E-20, E2E-24–26 | Append-only history, linked records, legal hold scope, archive vs disposition, residual copies and restore reconciliation |

## 5. Required record fields for each case

The source scenario text is only the baseline definition. Before a case is execution-ready, QA must add:

- atomic requirement IDs and exact source section/version;
- controlling DEC and status (approved, candidate, open prerequisite);
- exact DD document/section/version and applicability;
- test objective, risk and test level;
- preconditions, approved synthetic fixture IDs and environment;
- actor, capability, appointment, party/project/discipline scope;
- deterministic steps, race ordering or failure injection;
- expected result and its approved authority basis;
- actual result, execution timestamp and tested build/configuration;
- evidence references, integrity metadata and reviewer;
- outcome (Not Run / Pass / Fail / Blocked / Not Applicable with rationale);
- defect, waiver, retest and acceptance decision references.

## 6. Open prerequisites and blocked outcomes

The following are not resolved by importing the source scenario text:

1. Final lifecycle vocabulary and transition guards (DD-01).
2. Capability IDs, appointment/delegation evidence and action-time revocation semantics (DD-02).
3. Discipline responsibility, technical-lead and conflict decision authority (DD-03).
4. Approved risk/independent-review matrix and reviewer competence/independence evidence (DD-04).
5. Clarification/revision materiality examples and classification authority (DD-05).
6. Final official number format, uniqueness scope and legacy reconciliation (DD-06).
7. Idempotency, transaction boundaries, locking/isolation and recovery outcomes (DD-07).
8. Evidence identity, file security, integrity, scan/quarantine, manifest freeze and storage/access architecture (DD-08).
9. Recipient identity, channel/provider, delivery outcome evidence and recipient scope (DD-09).
10. Final acknowledgement wording and recipient-vs-manifest-entry request granularity (DD-10).
11. Reopening/withdrawal/cancellation eligibility and delegated authority details (DD-11).
12. Notification triggers, recipient matrix, priority/retry/cadence and privacy (DD-12).
13. Report formulas, audience/field entitlements, index freshness, privacy thresholds and export policy (DD-13).
14. Record series, schedules, hold authority/scope/release, backup/restore and disposition rules (DD-14).
15. Test owners, fixture catalogue, environment approval, evidence retention, severity, waiver authority and release sign-off (DD-15).

Any dependent test with an unresolved expected result remains **Blocked — Pending Design Decision/Prerequisite**. Do not treat the candidate outcomes copied from `docs/69` as an approved final state where later owner decisions or detailed specifications remain unresolved.

## 7. Source fidelity and review controls

- Original AT-RFI and E2E identifiers are preserved.
- Scenario titles, competing-event descriptions and required safe outcomes are transcribed from the exact source locations stated above.
- Candidate DD mappings are explicitly labelled and require QA review.
- The 28 E2E scenarios are not expanded into invented additional cases here.
- Additional cases require a controlled naming/versioning convention and traceability to an approved requirement.
- The source `docs/69` remains unchanged by this inventory.
- No test was executed, no result was marked Passed, and no release/implementation authorization is created.

## 8. Explicit non-authorization

This inventory authorizes no test execution, production-data access, live workflow, real external notification/Transmittal, permission/account creation or change, backup/restore, archive, legal hold, deletion/disposition, DB/schema/migration/generated types, Storage, auth/RLS/grants, API/UI/code, merge, deployment or release. Any execution requires a separate owner-approved plan, exact test scope, approved synthetic non-production environment and identities, evidence controls, required specialist reviews and explicit authorization. DB/Storage operations additionally require verified backups, isolated restore/rehearsal and reconciliation.
