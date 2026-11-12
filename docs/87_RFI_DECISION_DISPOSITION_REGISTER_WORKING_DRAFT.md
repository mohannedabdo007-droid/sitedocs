# RFI Decision Disposition Register — Working Draft

**Document type:** Controlled index and status register for owner decisions and specialist reviews  
**Date:** 2026-11-12  
**Status:** WORKING — ALL DISPOSITIONS PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Companion records:** `docs/85_RFI_OWNER_AND_SPECIALIST_REVIEW_MATRIX_WORKING_DRAFT.md`, `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Detailed specifications:** `docs/72`–`docs/83`  
**Backlog:** `docs/71_RFI_DETAILED_SPECIFICATION_BACKLOG.md`  
**Governance baseline:** DEC-103–DEC-110

> This register is an index and control record. It does not approve any proposal, appoint any person, create authority, amend a governance decision, or authorize implementation, testing, data operations or deployment. All decision dispositions and evidence fields begin blank.

## 1. Purpose and relationship to companion documents

This register consolidates the status and evidence for owner decisions and specialist reviews arising from CR-01–CR-12.

1. **docs/87:** working index of disposition status, authority, evidence, dependencies and downstream impact.
2. **docs/86:** detailed decision questions and blank decision sheets OR-01–OR-12; captures deliberation.
3. **docs/85:** review domains, specialist validation and operational authority evidence; it does not appoint reviewers.

The detailed specifications (docs/72–83) remain working drafts. A register entry does not approve a specification. Update a specification and backlog only after a disposition is validly evidenced and reconciled.

## 2. Non-negotiable recording rules

1. Record one disposition per discrete consequential rule, not a blanket approval of an OR group or DD file.
2. Assign a stable unique Disposition ID. Never reuse an ID; later decisions create a linked revision/event.
3. Identify the actual decision authority and source/scope of authority. The project owner cannot substitute for a separately required technical, contractual, legal, records, security or statutory authority.
4. Specialist review is validation/advice unless a documented appointment explicitly grants decision authority for that subject and scope.
5. Record approval only when the authorized decision-maker's attributable decision and supporting evidence are available. Silence, attendance, delivery, acknowledgement or an unappointed review is not approval.
6. Record conditions, dissent, rationale, scope, effective date and dependencies. Preserve objections.
7. Conditional approval is not an implementation release. Conditions and independent prerequisites must close before dependent gates pass.
8. A conflict with DEC-103–DEC-110 stops the affected item and triggers formal governance amendment/reconciliation. This register cannot override governance.
9. If authority, evidence, scope or prerequisite is unclear, mark **Blocked — Pending Decision/Prerequisite**; do not infer a default.
10. This is a design register only. Implementation, test execution, DB/schema/migration, Storage, auth/RLS/grants, production-data operations, backup/restore, merge and deployment require separate reviewed plans and explicit approval.

## 3. Controlled status vocabulary

| Status | Entry rule | Interpretation |
|---|---|---|
| Open | Decision identified; review package not ready | No disposition |
| Pending review | Required owner/specialist review outstanding | Review outstanding |
| Blocked — Pending Decision/Prerequisite | Authority decision, evidence or prerequisite missing | Dependent activity must not proceed |
| Amend and return | Reviewer/authority requires revision | Not approved |
| Conditionally approved | Authorized decision-maker approves exact scope subject to explicit conditions | Conditions remain blocking; no dependent gate passes |
| Approved | Authority approved exact scope/version; evidence retained; required prerequisites satisfied | Approved only for recorded scope; not implementation authorization |
| Rejected | Authorized rejection with evidence | Do not proceed on proposal |
| Deferred | Explicitly deferred by authority or prerequisite | No implied approval |
| Superseded | Replaced by linked valid successor | Preserve history |

**Status integrity:** “Approved” never means draft complete, discussion held or comments received. Without attributable evidence, the status cannot be Approved.

## 4. Master disposition index

These twelve rows are workstream indexes, not twelve blanket decisions. Each OR sheet must be decomposed into atomic Disposition IDs before consequential approval.

| Review | Risk / detailed work | Source | Required decision domains (not appointments) | Initial status | Interim control |
|---|---|---|---|---|---|
| OR-01 | CR-01 lifecycle/transitions; DD-01 | docs/72; docs/86 §OR-01; [docs/88 OR-01 decomposition](88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md) | Owner/process authority; architecture; Document Control; security; QA | Pending review | 14 atomic review items mapped; no workflow implementation |
| OR-02 | CR-02 capabilities/appointments/delegation; DD-02 | docs/72; docs/86 §OR-02 | Owner; project/party governance; identity/security; privacy; architecture | Pending review | No inferred grants or appointments |
| OR-03 | CR-03 discipline/conflict/independent review; DD-03/04 | docs/72; docs/86 §OR-03 | Owner; discipline and technical/risk authorities; QA; security | Pending review | No coordinator tie-break, assumed concurrence or self-review |
| OR-04 | CR-04 classification/numbering/legacy identity; DD-05/06 | docs/73–74; docs/86 §OR-04 | Owner; technical authority; Document Control; records/data; architecture/security | Pending review | No allocator, guessed format, renumbering or migration |
| OR-05 | CR-05 concurrency/idempotency/transaction/recovery; DD-07 | docs/75; docs/86 §OR-05 | Owner for business outcomes; architecture; data integrity; security; records | Pending review | No state-changing implementation or live recovery |
| OR-06 | CR-06 attachment/evidence security; DD-08 | docs/76; docs/86 §OR-06 | Owner; security; privacy; records; architecture; operations | Pending review | No real file/storage operations |
| OR-07 | CR-07 recipient identity/external access/distribution; DD-09 | docs/77; docs/86 §OR-07 | Owner; communication authority; identity/security; Document Control | Pending review | No provider/channel/access pattern selected |
| OR-08 | CR-08 acknowledgement/substantive response; DD-10 | docs/78; docs/86 §OR-08 | Owner; Document Control; technical authority; contract/records/security as applicable | Pending review | Candidate catalogue only; no deemed acceptance/SLA |
| OR-09 | CR-09 reopening/withdrawal/cancellation; DD-11 | docs/79; docs/86 §OR-09 | Owner; technical authority; records/Document Control; contract/security/QA | Pending review | No unresolved exception action |
| OR-10 | CR-10 notifications/reporting/search/export; DD-12/13 | docs/80–81; docs/86 §OR-10 | Owner; operations; reporting authority; security/privacy; architecture; records; QA | Pending review | No defaults/provider/implementation |
| OR-11 | CR-11 retention/archive/legal hold/disposition; DD-14 | docs/82; docs/86 §OR-11 | Owner; records; legal/contract authority as applicable; security; architecture; operations; QA | Pending review | No archive/hold/deletion/backup/restore |
| OR-12 | CR-12 verification/acceptance; DD-15 | docs/83; docs/86 §OR-12 | Owner; QA/test authority; security; records; architecture | Pending review | No test execution/pass/release claim |

**Initial roll-up:** 12 review workstream indexes; 0 recorded dispositions; 0 approved items; 12 pending review. This is setup status, not evidence that reviews occurred.

### 4.1 OR-01 atomic decomposition

The OR-01 worksheet in [docs/88](88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md) decomposes the candidate lifecycle specification into **14 individually traceable review items**:

- DISP-OR01-001 — final parent lifecycle vocabulary and meanings.
- DISP-OR01-002 — draft/formal-submission boundary; consistency check only, not reopening DEC-107.
- DISP-OR01-003 — administrative return for completion.
- DISP-OR01-004 — administrative routing into technical assessment.
- DISP-OR01-005 — clarification blocking and resume behavior.
- DISP-OR01-006 — consolidation entry and sequencing.
- DISP-OR01-007 — return from consolidation to discipline work.
- DISP-OR01-008 — independent-review trigger and exact-version gate.
- DISP-OR01-009 — Ready for Issue entry criteria.
- DISP-OR01-010 — formal issue and technical closure.
- DISP-OR01-011 — withdrawal eligibility, cutoff and authority.
- DISP-OR01-012 — cancellation eligibility, grounds and authority.
- DISP-OR01-013 — reopening and new response cycle.
- DISP-OR01-014 — parent lifecycle versus subordinate records and indicators.

These are **13 substantive review/disposition items plus one governance-consistency check**. All remain pending; no decision, owner approval, specialist sign-off or implementation authorization is recorded. The worksheet identifies protected DEC-103–DEC-110 constraints separately so that a detailed lifecycle discussion cannot silently reopen or override them.


## 5. Atomic disposition record template

Create one record per discrete rule/value/authority question. Copy this template for each Disposition ID; retain completed records and revisions.

### DISPOSITION RECORD — [DISP-ORxx-NNN]

| Field | Required entry |
|---|---|
| Disposition ID / revision | Stable ID and revision |
| Review group / risk | OR-xx / CR-xx |
| Detailed work item | DD-xx and exact document/section/version |
| Decision statement | One precise, answerable question; no bundling |
| Proposed disposition | Exact proposed text/value and alternatives |
| Controlling governance | Applicable DEC references and consistency finding |
| Decision authority | Verified role/person, authority instrument and scope |
| Owner/authority disposition | Exact decision: approve / conditional / amend / reject / defer |
| Specialist validation | Domain, reviewer/appointment where applicable, finding, date, evidence |
| Operational authority prerequisite | Appointment/delegation/competence evidence required before action |
| Conditions/dependencies | Numbered condition, responsible authority, closure evidence, dependent gate |
| Dissent/objection | Author/domain, rationale, resolution or unresolved status |
| Rationale and impact | Lifecycle, roles, records, communication, reporting and test impact |
| Effective scope | Project, party, discipline, document family, workflow and exclusions |
| Version/effective date | Exact text version and date, if validly determined |
| Evidence references | Decision instrument/minutes, specialist review, attachments and repository paths |
| Status | Controlled status from §3 |
| Recorded by / timestamp | Attributable recorder; recorder is not thereby approver |
| Supersedes / superseded by | Linked prior/successor Disposition ID |
| Downstream updates | Specification, backlog, traceability, tests and documents |
| Independent verification | Check of status, authority, evidence, scope and linked documents |

Blank values are intentional. Never fill missing values by inference.

## 6. Review and approval workflow

1. **Prepare:** identify the exact rule in docs/72–83 and create a unique Disposition ID.
2. **Authority check:** verify decision-maker and authority instrument/scope; if unknown, mark Blocked.
3. **Specialist validation:** obtain reviews identified in docs/85 and record each finding separately.
4. **Disposition:** capture exact decision, conditions, rationale, dissent and evidence in the matching OR sheet and register.
5. **Consistency:** check DEC-103–DEC-110; any conflict triggers governance amendment/reconciliation before promotion.
6. **Reconcile:** update affected specification, backlog and traceability only after the disposition is evidenced.
7. **Independently verify:** confirm approved scope/version, authority, evidence, conditions and downstream links.
8. **Evaluate gate:** only then may the relevant design dependency be considered satisfied. Implementation/test authorization remains separate.

## 7. Conditions, dissent and change history

- Conditions are individually numbered and have a responsible authority, closure evidence and dependent gate.
- Conditional approval remains conditional until every condition is verified; no automatic conversion to Approved.
- Material dissent remains visible; no silence, majority-vote shortcut or deletion.
- A changed proposal receives a new revision and renewed review where meaning, risk, authority, scope or evidence changes.
- Superseding decisions link to prior IDs and explain the change. Preserve historical records.
- Clerical corrections log who/when/why and must not silently rewrite decision substance.
- If an approval authority is invalid or out of scope, flag the disposition, block dependent activity and obtain a valid decision; preserve the earlier record.

## 8. Governance invariants to preserve

- **DEC-103:** recipient-level delivery and acknowledgement aggregation remain distinct.
- **DEC-104:** confirmed RFI operating-model recommendations remain governing policy.
- **DEC-105:** administrative coordination, discipline contribution, technical leadership, independent review and formal issue authority remain distinct.
- **DEC-106:** clarification, revision, withdrawal, cancellation, reopening and closure retain approved boundaries.
- **DEC-107:** official numbering and immutable evidence requirements remain; unresolved display/legacy details are not guessed.
- **DEC-108:** formal external distribution, Transmittal identity, recipient acknowledgement and technical RFI closure remain separate.
- **DEC-109:** monitoring, notification, reporting, archive and retention do not create unapproved defaults or authority.
- **DEC-110:** verification criteria remain a design framework; proposed test counts are not executed/passed tests.

If a detailed disposition appears to alter a confirmed constraint, pause it and use the formal governance process. docs/87 cannot amend the governance baseline.

## 9. Promotion and implementation gates

A disposition may be considered **design-approved for its recorded scope** only when all applicable checks are true:

- [ ] Exact decision and affected specification version identified.
- [ ] Decision authority and scope evidenced.
- [ ] Required specialist validations recorded, including dissent.
- [ ] Exact disposition, rationale, conditions and scope attributable.
- [ ] Evidence references accessible and retained.
- [ ] DEC-103–DEC-110 consistency verified or formal governance amendment completed.
- [ ] Conditions/prerequisites closed or explicitly remain blocking.
- [ ] Downstream specification/backlog/traceability reconciled.
- [ ] Independent verification recorded.

Passing this checklist does **not** authorize implementation, test execution, production-data access/change, DB/schema/migration, Storage, auth/RLS/grants, backup/restore, merge or deployment. Those require separate scoped plans, safeguards and explicit approval.

## 10. Current open register actions

| Action | Work | Responsible domain (not named person) | Completion evidence | Status |
|---|---|---|---|---|
| REG-01 | Review OR-01 and decompose lifecycle proposal into atomic dispositions | Owner + process/technical authority + Document Control + security/QA | Completed OR-01 sheet and individual records | Open |
| REG-02 | Verify authority instruments and specialist assignments for each OR group | Project governance / relevant domain authorities | Verified authority and reviewer evidence | Open |
| REG-03 | Populate dispositions only after actual reviews and decisions | Authorized decision authority; register custodian records | Attributable decision evidence | Open |
| REG-04 | Reconcile valid dispositions into DD files, backlog and traceability | Document owner / Document Control | Verified cross-document links and version history | Blocked — Pending Decision/Prerequisite |
| REG-05 | Reassess readiness after conditions and prerequisites close | Owner + relevant technical/security/QA/records authorities | Gate review record | Blocked — Pending Decision/Prerequisite |

## 11. Explicit exclusions

This register does not create named reviewers, appoint authorities, grant permissions, approve the complete RFI specification, choose technology/providers, set SLA/cadence/retention defaults, execute tests, modify application code/data, alter DB/Storage/auth/RLS, perform backup/restore, or authorize merge/deployment.

---
**End of working draft — no owner dispositions or specialist sign-offs are recorded in this version.**
