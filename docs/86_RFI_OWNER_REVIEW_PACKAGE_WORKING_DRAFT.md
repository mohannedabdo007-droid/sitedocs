# RFI Owner Review Package — Working Draft

**Document type:** Structured owner decision and specialist review pack  
**Date:** 2026-11-12  
**Status:** PREPARED FOR CONTROLLED REVIEW — PARTIAL OWNER DISPOSITIONS RECORDED — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Parent documents:** `docs/71` backlog, `docs/84` cross-specification review, `docs/85` owner/specialist review matrix  
**Detailed specifications:** `docs/72`–`docs/83`  
**Governance baseline:** DEC-103–DEC-110 on the controlled governance branch

> This pack structures review and does not make decisions on behalf of technical authorities, records/legal authorities, security, QA or any appointed operational authority. Candidate options are prompts for deliberation, not approved defaults. DISP-OR01-001, DISP-OR01-003, DISP-OR01-004, DISP-OR01-005 and DISP-OR01-006 have conditional owner dispositions for the exact scopes recorded in docs/87; other decision fields and specialist reviews remain open.

## 1. Purpose and review protocol

This pack turns CR-01–CR-12 into twelve discrete review items. It is designed to prevent blanket approvals, accidental policy changes and premature implementation.

For each item:
1. Read the linked detailed specification and the corresponding row in `docs/85`.
2. Obtain the required specialist review before asking for a consequential owner disposition.
3. Confirm who actually holds the decision authority for the subject. The project owner is the overall decision point for project policy where appropriate, but cannot replace a separately mandated legal, contractual, technical, records or statutory authority.
4. Record one disposition for each discrete rule, not merely one for the whole CR group.
5. Record objections, conditions, evidence, scope and dependencies.
6. Update the detailed specification and backlog only after the disposition is evidenced.
7. If a disposition changes a confirmed governance rule, stop and process a formal governance amendment; do not silently edit the detailed specification.

**Permitted review dispositions:** Approve; Approve with stated conditions; Amend and return for review; Reject; Defer — Pending Decision/Prerequisite. “No comment”, silence, attendance, or a specialist review without delegated authority is not approval.

## 2. Review status dashboard

| Review ID | Cross-risk | Primary DD files | Owner disposition | Specialist review | Current control |
|---|---|---|---|---|---|
| OR-01 | CR-01 | `docs/72` DD-01 | DISP-OR01-001, DISP-OR01-003, DISP-OR01-004 and DISP-OR01-005 conditionally approved; DISP-OR01-006 and DISP-OR01-007 conditionally approved; remaining OR-01 items pending | Pending | Controlled refinement only; DISP-OR01-004 review prepared; block final state-machine promotion |
| OR-02 | CR-02 | `docs/72` DD-02 | Not recorded | Pending | No grants/appointments |
| OR-03 | CR-03 | `docs/72` DD-03/DD-04 | Not recorded | Pending | No inferred technical authority/review clearance |
| OR-04 | CR-04 | `docs/73`–`docs/74` DD-05/DD-06 | Not recorded | Pending | No allocator or legacy migration |
| OR-05 | CR-05 | `docs/75` DD-07 | Not recorded | Pending | No state-changing transaction implementation |
| OR-06 | CR-06 | `docs/76` DD-08 | Not recorded | Pending | No file-service/Storage operation |
| OR-07 | CR-07 | `docs/77` DD-09 | Not recorded | Pending | No provider/channel/external access selection |
| OR-08 | CR-08 | `docs/78` DD-10 | Not recorded | Pending | Candidate acknowledgement/response catalogue only |
| OR-09 | CR-09 | `docs/79` DD-11 | Not recorded | Pending | No unresolved lifecycle exception action |
| OR-10 | CR-10 | `docs/80`–`docs/81` DD-12/DD-13 | Not recorded | Pending | No notification/report/search/export defaults |
| OR-11 | CR-11 | `docs/82` DD-14 | Not recorded | Pending | No archive/hold/disposition/backup operation |
| OR-12 | CR-12 | `docs/83` DD-15 | Not recorded | Pending | No test execution/pass or release claim |

Only the specifically scoped OR-01 atomic dispositions DISP-OR01-001, DISP-OR01-003, DISP-OR01-004, DISP-OR01-005 and DISP-OR01-006 are conditionally approved. All other owner dispositions and specialist reviews remain pending. This dashboard is not evidence that specialist reviews have occurred.

## 3. Decision sheets

### OR-01 — Final RFI lifecycle and transition rules

**Linked risk/work:** CR-01; DD-01; `docs/72`; DEC-104, DEC-106, DEC-109, DEC-110.

**Atomic review worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md` decomposes OR-01 into DISP-OR01-001–014 (13 substantive review items and one DEC-107 consistency check). Use one disposition per item in `docs/87`; DISP-OR01-001, DISP-OR01-003, DISP-OR01-004, DISP-OR01-005 and DISP-OR01-006 are conditionally approved for their recorded scopes; the remaining items are open and protected governance constraints are not reopened.

**DISP-OR01-001 owner disposition:** The project owner explicitly accepted the technical recommendation on 2026-11-12. The recorded status is **Conditionally approved**: Draft and Abandoned Draft remain outside the official lifecycle; the 11 official candidate labels form the controlled refinement baseline; Closed, Withdrawn and Cancelled remain distinct terminal outcomes; communication and records indicators remain separate. See [docs/89 §12](89_OR01_D01_STATE_VOCABULARY_REVIEW_WORKING_DRAFT.md) and [docs/87 §4.3](87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md). Specialist validation and remaining OR-01 decisions are pending.

**DISP-OR01-003 owner disposition:** The project owner conditionally approved Option C on 2026-11-12. Normal administrative return is limited to the pre-technical-assessment stage; a genuine administrative defect discovered after technical assessment begins is recorded and referred through a separately authorized correction/exception path, without a generic parent-state return or silent lifecycle reset. The parent lifecycle remains unchanged unless a distinct, explicit owner-approved transition rule governs the case. Specialist validation and detailed prerequisites remain pending. See [docs/91 §16](91_OR01_D03_COORDINATION_AND_RETURN_FOR_COMPLETION_WORKING_DRAFT.md) and [docs/87 §4.4](87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md).

**DISP-OR01-004 owner disposition:** The project owner conditionally approved the two-key hand-off and complete required-assignment gate on 2026-11-12. The appointed technical authority determines and records disciplines, scope, required lead and assignments; the coordinator verifies the complete routing package and performs only the administrative transition. The parent remains Under Coordination if required authority, assignments or access evidence are missing, expired, ambiguous or unauthorized. Specialist validation and detailed prerequisites remain pending. See [docs/92 §15](92_OR01_D04_ADMINISTRATIVE_ROUTING_TO_TECHNICAL_ASSESSMENT_WORKING_DRAFT.md) and [docs/87 §4.6](87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md).

**DISP-OR01-005 owner disposition:** The project owner conditionally approved the five principles in docs/93 §16 on 2026-11-12: explicit dependency-based blocking; contribution-only versus parent-progression effects; parent Awaiting while any valid parent blocker remains open; separate request/response records with technical sufficiency review; and guarded resumption to the exact prior parent state after all parent blockers are resolved. Specialist validation and detailed prerequisites remain pending. See [docs/93 §16](93_OR01_D05_CLARIFICATION_BLOCKING_AND_RESUME_BEHAVIOR_WORKING_DRAFT.md) and [docs/87 §4.9](87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md).

**DISP-OR01-006 owner disposition:** The project owner conditionally approved on 2026-11-12 the complete required-contribution gate before parent entry into Under Consolidation, and limited provisional subordinate preparation in parallel while the parent remains In Technical Assessment. Specialist validation, detailed prerequisites and downstream reconciliation remain pending; no implementation authorization. See [docs/94 §16](94_OR01_D06_UNDER_CONSOLIDATION_ENTRY_AND_SEQUENCING_WORKING_DRAFT.md) and [docs/87 §4.11](87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md).

**DISP-OR01-002 consistency review:** [docs/90 — Draft, Formal Submission and Official Identity](90_OR01_D02_SUBMISSION_BOUNDARY_CONSISTENCY_REVIEW_WORKING_DRAFT.md) checks the draft/submission boundary against DEC-107 without reopening it. No source conflict was identified subject to wording clarifications. The Submitted state-versus-event representation remains a design choice; no new policy disposition is recorded.

**DISP-OR01-006 decision question:** Must the parent wait until all required contributions are complete before entering Under Consolidation, and may limited preparatory consolidation proceed in parallel while the parent remains In Technical Assessment?

**Owner decision points**
- Confirm the complete required-contribution gate for the parent transition, including technically confirmed completion or authorized scope removal.
- Decide whether limited provisional subordinate preparation may proceed in parallel without changing the parent state.
- Confirm that incomplete required contributions cannot be reclassified as optional/non-blocking by convenience.
- Confirm that parent-progression blockers and unresolved blockers on required contributions prevent entry.
- Confirm the completeness authority, conflict/dissent handling and exact version/scope evidence.

**Candidate paths for discussion (none preselected):**
- Accept the recommended separation between provisional parallel preparation and formal parent-stage entry.
- Amend the parent entry gate or parallel-preparation limits and return the affected clauses for reconciliation.
- Defer entry criteria pending technical authority, discipline or records evidence.

**Required specialist review:** appointed technical lead/authority, discipline authorities, process owner, Document Control, architecture, security, QA and records as applicable.

**Must not be inferred:** provisional drafting is not parent-state transition, completion, technical agreement, readiness for issue or authority to issue.

**Disposition record:** DISP-OR01-006 — Conditionally approved on 2026-11-12 for the complete required-contribution parent-entry gate and limited provisional subordinate preparation; specialist validation and detailed prerequisites remain pending. See docs/94 §16 and docs/87 §4.11.

**Decision question:** What final lifecycle vocabulary, transition guards, terminal meanings and parent/subordinate aggregation rules should govern RFI records, once aligned with the confirmed policy constraints?

**Owner decision points**
- Confirm whether the candidate lifecycle model in DD-01 is accepted as the basis for detailed refinement, or must be amended/returned.
- Decide each consequential transition and terminal meaning individually; do not approve labels without their entry/exit guards.
- Decide parent-level aggregation behavior where child items/cycles have distinct outcomes.
- Confirm which items require a separate authority decision rather than owner-only disposition.

**Candidate paths for discussion (none preselected):**
- Accept the candidate model as a baseline for controlled refinement, with each transition still subject to explicit review.
- Amend named states/transitions and return the affected sections for reconciliation.
- Defer specific transitions pending process/technical authority evidence.

**Required specialist review:** process owner, technical architecture, Document Control, security and QA. Validate audit trail, invalid-transition denial, concurrency and separation from WIR.

**Must not be inferred:** a state name does not grant a capability; UI visibility does not grant authority; lifecycle closure does not imply external delivery or acknowledgement.

**Disposition record:** DISP-OR01-001 — Conditionally approved on 2026-11-12 for the scope in docs/87 §4.3; DISP-OR01-003 — Option C conditionally approved on 2026-11-12 for the scope in docs/87 §4.4; DISP-OR01-004 — two-key hand-off and complete required-assignment gate conditionally approved on 2026-11-12 for the scope in docs/87 §4.6. Specialist validation and all other OR-01 decisions beyond the recorded conditional approvals remain open.

### DISP-OR01-007 — Return from Consolidation to Technical Assessment

**Linked source:** CR-01; DD-01; docs/72 §3.3 Under Consolidation → In Technical Assessment; DEC-105–DEC-110 and DEC-022-A/B as applicable.

**Technical recommendation:** [docs/95 — Return from Consolidation to Technical Assessment](95_OR01_D07_RETURN_FROM_CONSOLIDATION_TO_TECHNICAL_ASSESSMENT_WORKING_DRAFT.md).

**Decision question:** Which material gaps or conflicts require a return from Under Consolidation to In Technical Assessment, who may initiate/authorize/execute the return, how narrowly may affected work be scoped, and what contribution/candidate history must be preserved?

**Owner decision points**
- Confirm that a return is limited to material technical gaps, new dependencies, invalidated contributions, material scope/evidence changes or conflicts requiring discipline reassessment beyond the consolidation mandate.
- Confirm that editorial corrections and issues resolvable within the appointed lead's authority do not automatically return the parent.
- Confirm the separation between contributor gap identification, technical lead decision within appointment, technical authority resolution of scope/delegation disputes, and administrative execution by Document Control only if expressly delegated.
- Decide whether return should be limited to affected discipline work where dependencies are bounded, preserving unaffected contributions.
- Require immutable prior contribution versions and preservation of the exact consolidated candidate; require attributable successor versions for substantive technical changes.
- Confirm originator clarification, independent-review changes, formal revision, linked new RFI and post-issue matters remain governed by their separate policies.
- Require re-entry to Under Consolidation to satisfy the DISP-OR01-006 gate again.

**Candidate paths for discussion (none preselected):**
- Accept the recommended materiality/authority test and selective return model.
- Amend the triggers, authority split, affected-scope or version-preservation requirements and return the affected clauses for reconciliation.
- Defer specific cases pending technical authority, discipline, architecture or records evidence.

**Required specialist review:** appointed technical lead/authority, relevant discipline authorities, project/process owner, Document Control, architecture, security, QA and records as applicable.

**Must not be inferred:** every disagreement requires return; coordinator may decide technical rework; return erases prior work; all disciplines automatically reopen; prior review clearance carries to changed candidate; re-entry is automatic.

**Disposition record:** DISP-OR01-007 — **Conditionally approved on 2026-11-12** for the seven business principles recorded in docs/95 §19 and indexed in docs/87 §4.12; specialist validation and detailed prerequisites remain pending. No implementation authorization.

### OR-02 — Capability, appointment and delegation authority

**Linked risk/work:** CR-02; DD-02; `docs/72`; DEC-104, DEC-105, DEC-106, DEC-109.

**Decision question:** Which authority appoints, scopes, delegates, expires and revokes each RFI capability for each project, party and discipline context?

**Owner decision points**
- Confirm the governing appointment model and the authority allowed to appoint for each project/party.
- Decide whether delegation is permitted for each capability class, and its scope/limits; do not assume universal delegation.
- Require an attributable appointment record and action-time authority check.
- Identify matters that must be approved by a separate identity/security or contractual authority.

**Candidate paths for discussion (none preselected):**
- Adopt a centralized appointment authority model with explicit scoped delegation only where separately approved.
- Adopt project/party-specific appointing authorities with a common minimum evidence record.
- Defer any capability lacking a demonstrable appointing authority or scope.

**Required specialist review:** identity/security, project/party governance, privacy and architecture.

**Must not be inferred:** job title, project membership, email domain, group membership or prior access is not an appointment.

**Disposition record:** Decision: ______  Conditions/amendments: ______  Rationale/evidence: ______  Appointing authority: ______  Date/version: ______

### OR-03 — Discipline responsibility, conflict and independent review

**Linked risk/work:** CR-03; DD-03/DD-04; `docs/72`; DEC-104, DEC-105, DEC-110.

**Decision question:** How are discipline responsibility, technical leadership, material conflict disposition, dissent and independent review governed?

**Owner decision points**
- Confirm the discipline responsibility framework and how discipline-specific accountability is evidenced.
- Decide how technical-lead appointments are made and bounded.
- Confirm that material dissent remains visible and unresolved material conflict is not converted into concurrence by silence or majority vote.
- Decide which risk classes require independent review, subject to technical/risk authority validation.
- Require self-review and conflict-of-interest controls.

**Candidate paths for discussion (none preselected):**
- Approve a risk-tiered independent-review framework after the technical/risk authority defines and validates the risk matrix.
- Return the risk triggers and conflict categories for specialist redesign.
- Defer any case where competence, independence or conflict disposition cannot be evidenced.

**Required specialist review:** relevant discipline authorities, technical/risk authority, QA and security.

**Must not be inferred:** RFI coordinator is administrative; coordination does not resolve technical conflict or issue the official answer.

**Disposition record:** Decision: ______  Risk/discipline scope: ______  Specialist findings: ______  Appointments required: ______  Date/version: ______

### OR-04 — Clarification, revision, numbering and legacy identity

**Linked risk/work:** CR-04; DD-05/DD-06; `docs/73`–`docs/74`; DEC-022-A/B, DEC-104, DEC-106, DEC-107, DEC-110.

**Decision question:** What detailed classification and identity rules should apply to clarification versus formal revision versus linked new RFI, and what official number format/uniqueness scope can be safely reconciled with legacy records?

**Owner decision points**
- Confirm the business distinction and controlled-content materiality criteria, with technical authority validation.
- Decide the visible number pattern only after Document Control and records/data review.
- Decide the intended uniqueness namespace (for example, project-scoped or another explicitly justified scope) only after complete source inventory and collision analysis.
- Require explicit disposition for every legacy collision/ambiguous record; no guessed winner or silent renumbering.

**Candidate paths for discussion (none preselected):**
- Approve a classification rule set with examples after technical and Document Control review.
- Approve a number-format proposal only after legacy inventory and collision report are complete.
- Defer numbering format/namespace where evidence is incomplete; preserve current historical identifiers without migration.

**Required specialist review:** technical authority, Document Control, document-family governance, records/data stewardship, architecture and security.

**Must not be inferred:** no number is consumed by a draft, preview or failed submission; formal allocation remains tied to the first successful formal submission under DEC-107.

**Disposition record:** Classification disposition: ______  Number format: ______  Uniqueness scope: ______  Legacy evidence/reference: ______  Date/version: ______

### OR-05 — Transaction, idempotency and recovery behavior

**Linked risk/work:** CR-05; DD-07; `docs/75`; DEC-104, DEC-106, DEC-107, DEC-110.

**Decision question:** Which user-visible outcomes and integrity guarantees must hold when commands are retried, duplicated, concurrent, interrupted or recovered?

**Owner decision points**
- Confirm required outcomes for duplicate submission, timeout-after-success, competing lifecycle commands and stale versions.
- Confirm that no partial or duplicate official identity, issue, closure, event or external dispatch may be accepted as a successful outcome.
- Approve business-level recovery and reconciliation expectations.
- Leave technology selection, locking/isolation and event architecture to architecture/security review and separate technical approval.

**Candidate paths for discussion (none preselected):**
- Approve the business integrity contract while architecture evaluates multiple implementation patterns.
- Return the required failure/recovery outcomes for clarification.
- Defer any command whose business outcome is not defined.

**Required specialist review:** architecture/engineering, data integrity, security and records.

**Must not be inferred:** owner approval of business outcomes is not approval of a database design, migration or production operation.

**Disposition record:** Business outcomes: ______  Specialist architecture findings: ______  Recovery evidence required: ______  Date/version: ______

### OR-06 — Attachment and evidence security policy

**Linked risk/work:** CR-06; DD-08; `docs/76`; DEC-021, DEC-051, DEC-053, DEC-104, DEC-107, DEC-109, DEC-110.

**Decision question:** Which evidence classes, custody rules, integrity checks and access conditions must be satisfied before an attachment can be accepted, previewed, downloaded or included in a frozen submission/response package?

**Owner decision points**
- Confirm evidence classification and business use requirements.
- Confirm immutability/versioning and custody expectations.
- Require explicit security/records validation for scanning, quarantine, encryption, key management, cache/preview, storage region and retention.
- Defer unresolved mechanisms rather than selecting a provider or algorithm by convenience.

**Candidate paths for discussion (none preselected):**
- Approve evidence/custody requirements while leaving technical mechanisms for architecture/security selection.
- Return classification or retention rules for records review.
- Defer a file class or operation pending security evidence.

**Required specialist review:** security, privacy, records, architecture and operations.

**Must not be inferred:** an RFI record entitlement does not automatically grant attachment access; every file operation needs its own current authorization.

**Disposition record:** Evidence classes: ______  Custody requirements: ______  Security findings: ______  Records findings: ______  Date/version: ______

### OR-07 — Recipient identity and distribution route

**Linked risk/work:** CR-07; DD-09; `docs/77`; DEC-050–DEC-052, DEC-103, DEC-104, DEC-108, DEC-110.

**Decision question:** Who may nominate external recipients, how is party representation and identity verified, and which approved route is used for formal external distribution?

**Owner decision points**
- Confirm recipient classes and nomination authority.
- Decide the required assurance level for identity and party representation with security/contract review.
- Confirm formal external distribution through controlled Transmittal as required by DEC-108.
- Define any separately authorized internal issue-only access without conflating it with external dispatch.
- Require revocation/offboarding and recipient correction procedures.

**Candidate paths for discussion (none preselected):**
- Approve recipient classes and nomination evidence while deferring provider/channel selection.
- Return identity assurance and party representation for specialist validation.
- Defer external distribution until the channel and authorization model are approved.

**Required specialist review:** contract/communications, identity/security, privacy, Document Control and architecture.

**Must not be inferred:** sending, delivery, access or recipient acknowledgement is not technical approval or deemed contractual acceptance.

**Disposition record:** Recipient classes: ______  Nomination authority: ______  Identity evidence: ______  Distribution route: ______  Date/version: ______

### OR-08 — Acknowledgement and substantive-response requirements

**Linked risk/work:** CR-08; DD-10; `docs/78`; DEC-103, DEC-108, DEC-110.

**Decision question:** Which recipient classes must acknowledge receipt/awareness, which may provide optional acknowledgement, and what substantive response categories are required or permitted?

**Owner decision points**
- Decide which recipient types are Required, Optional or Not Requested for acknowledgement in each applicable distribution context.
- Decide whether substantive response is required independently of acknowledgement.
- Review proposed response categories and exact wording with technical, contract and records authorities.
- Confirm that zero Required recipients yields Not Required and only Required recipients enter the acknowledgement denominator, preserving DEC-103.

**Candidate paths for discussion (none preselected):**
- Approve separate acknowledgement and substantive-response matrices.
- Amend response categories/wording after technical and contract review.
- Defer any category whose meaning or legal/contractual effect is unclear.

**Required specialist review:** technical authority, Document Control, contract/communications, records and UX/accessibility.

**Must not be inferred:** delivery/access/read receipt/silence does not constitute acknowledgement, substantive response, technical acceptance or contractual notice unless separately and validly established outside this design.

**Disposition record:** Required/Optional/Not Requested rules: ______  Response catalogue: ______  Specialist findings: ______  Date/version: ______

### OR-09 — Reopening, withdrawal and cancellation gates

**Linked risk/work:** CR-09; DD-11; `docs/79`; DEC-104, DEC-106, DEC-108–DEC-110.

**Decision question:** Which unresolved eligibility criteria, reasons, scope and authority evidence govern pre-issue withdrawal, administrative cancellation and post-closure reopening?

**Owner decision points**
- Confirm eligible states and the evidence required to establish eligibility.
- Define “substantive work begun” only after technical authority review.
- Confirm permitted administrative cancellation grounds and required evidence.
- Confirm reopening scope and new-cycle treatment while preserving prior issue/closure history.
- Confirm whether external recipient effects require separate treatment without altering source RFI history.

**Candidate paths for discussion (none preselected):**
- Approve only the gates supported by DEC-106 and defer undefined thresholds.
- Return the substantive-work threshold and cancellation grounds for technical/records review.
- Defer any action where authority or eligibility cannot be evidenced.

**Required specialist review:** technical authority, Document Control, records, QA and contract/security as applicable.

**Must not be inferred:** a pre-issue withdrawal does not retract an issued response; reopening does not erase the prior cycle.

**Disposition record:** Eligibility rules: ______  Authority: ______  Evidence: ______  History/recipient impact: ______  Date/version: ______

### OR-10 — Notifications, reporting, search and export

**Linked risk/work:** CR-10; DD-12/DD-13; `docs/80`–`docs/81`; DEC-021, DEC-049, DEC-103–DEC-110.

**Decision question:** Which source events may generate notifications, who may receive them, what metrics are authoritative, and under what audience/purpose controls may information be searched or exported?

**Owner decision points**
- Confirm business audiences and legitimate purposes for each report/export.
- Decide metric definitions and counting units; keep lifecycle, workload, aging and communication metrics separate.
- Decide event/recipient rules only after privacy/security review.
- Defer cadence, priority, provider, retry, escalation, small-count suppression and index freshness until the responsible authorities validate them.
- Confirm export lineage and revocation expectations.

**Candidate paths for discussion (none preselected):**
- Approve metric definitions and audiences as separate decisions.
- Approve notification event categories while deferring delivery channel/cadence.
- Defer any metric or export field that can disclose unauthorized metadata.

**Required specialist review:** security/privacy, reporting authority, operations, architecture, QA, Document Control and records.

**Must not be inferred:** notifications and reports do not create workflow authority; search results, facets, counts and exports must obey current server-side authorization.

**Disposition record:** Audience/purpose: ______  Metric decisions: ______  Event/recipient rules: ______  Security/records findings: ______  Date/version: ______

### OR-11 — Records retention, archive, legal hold and disposition

**Linked risk/work:** CR-11; DD-14; `docs/82`; DEC-012, DEC-021, DEC-053, DEC-054, DEC-104, DEC-107, DEC-109, DEC-110.

**Decision question:** Which approved records schedules, triggers, archive requirements, legal-hold authorities and disposition controls apply to RFI records and their copies?

**Owner decision points**
- Identify the competent records schedule owner and applicable records series.
- Do not set retention durations until the authorized schedule and trigger are evidenced.
- Confirm archive package and retrieval requirements after records/architecture review.
- Confirm legal-hold authority, scope, overlap and release only with competent legal/records authority.
- Confirm disposition and destruction evidence requirements; treat backup/replica/cache/export copies explicitly.

**Candidate paths for discussion (none preselected):**
- Approve records inventory and schedule mapping as a prerequisite, not a retention duration.
- Return unresolved legal/contract questions to the competent authority.
- Defer disposition where schedule, hold clearance or residual-copy evidence is incomplete.

**Required specialist review:** records management, legal/contract as applicable, security, architecture, operations and data/Storage.

**Must not be inferred:** retention expiry triggers controlled review only; it does not authorize automatic deletion.

**Disposition record:** Records series/schedule: ______  Authority: ______  Hold rules: ______  Copy lifecycle: ______  Date/version: ______

### OR-12 — Test governance, acceptance and release authority

**Linked risk/work:** CR-12; DD-15; `docs/83`; DEC-103–DEC-110.

**Decision question:** Who designs, executes, independently reviews and accepts tests; which environment/data controls apply; and what defect, waiver and release gates are authorized?

**Owner decision points**
- Confirm test ownership and the distinction between designer, executor, reviewer and acceptance authority.
- Require QA to import and verify the actual AT-RFI-01–13 and 28 E2E scenario definitions; do not infer their content from identifiers/counts.
- Approve isolated non-production environment and synthetic-data governance.
- Decide non-waivable blocker categories consistently with DEC-110.
- Decide severity/thresholds and waiver authority only after QA/security/records review.
- Identify the formally authorized release approver; no release readiness is implied by this pack.

**Candidate paths for discussion (none preselected):**
- Approve the governance structure and scenario inventory task, while leaving execution blocked.
- Return severity/waiver thresholds for QA/security/records validation.
- Defer test execution until expected behavior, owners, environment and data are approved.

**Required specialist review:** QA/test lead, security, records, architecture, operations and relevant technical authorities.

**Must not be inferred:** proposed scenarios are not passed tests; waiver cannot override confirmed governance/security/records constraints.

**Disposition record:** Test roles: ______  Scenario inventory evidence: ______  Environment/data approval: ______  Blockers/waiver/release authority: ______  Date/version: ______

## 4. Mandatory governance constraints checklist

Before recording any disposition, verify that it preserves:
- [ ] DEC-103 recipient-level delivery aggregation and Required-only acknowledgement denominator.
- [ ] DEC-104–DEC-105 authority, multidisciplinary contribution and independent-review boundaries; no automatic role grants.
- [ ] DEC-106 clarification, withdrawal, cancellation, reopening and closure distinctions; prior history preserved.
- [ ] DEC-107 official number allocation point and immutable evidence/version principles; unresolved display format/legacy reconciliation remain open until decided.
- [ ] DEC-108 technical issue versus Document Control distribution; controlled Transmittal for formal external distribution; separate delivery/access/acknowledgement/substantive response events.
- [ ] DEC-109 separate lifecycle/workload/communication/records indicators; no invented SLA/cadence/retention/deletion defaults.
- [ ] DEC-110 traceability and evidence requirements; unresolved prerequisites block dependent tests; mandatory blockers retained.

If any proposed disposition conflicts with a checked constraint, stop the detailed review and raise a formal governance change request. Do not edit around the conflict.

## 5. Consolidated disposition register

Copy one row per discrete rule/decision. Keep the source decision sheets and specialist evidence linked.

| Review ID / rule ID | Exact rule reviewed | Disposition | Conditions / amendments | Rationale and evidence reference | Owner / authority and basis | Specialist findings / dissent | Scope / effective version | Governance impact / linked DEC | Date |
|---|---|---|---|---|---|---|---|---|---|
| OR-__ / ______ |  |  |  |  |  |  |  |  |  |
| OR-__ / ______ |  |  |  |  |  |  |  |  |  |
| OR-__ / ______ |  |  |  |  |  |  |  |  |  |

**Record integrity rules**
- Never overwrite a prior disposition; issue a new version with a link to the superseded entry.
- Record “Defer” with the missing prerequisite, responsible authority/domain and review trigger.
- Record “Approve with conditions” with objectively verifiable conditions and a responsible verifier.
- Record “Amend and return” with exact affected sections and downstream DD items.
- Preserve dissent and minority technical findings; do not convert silence into agreement.
- An approval applies only to its stated scope/version and cannot be extended by implication.

## 6. Specialist review evidence sheet

| Review ID | Domain | Reviewer / organization | Competence / appointment basis | Sections reviewed | Findings | Open objections / conditions | Evidence reference | Date |
|---|---|---|---|---|---|---|---|---|
| OR-__ |  |  |  |  |  |  |  |  |

A specialist review records professional validation, not owner approval, unless an explicit delegation establishes otherwise.

## 7. Review completion and promotion gates

The package is ready to be reconciled into the working specifications only when:
1. Every consequential rule has a discrete disposition and scope/version.
2. The decision-maker's authority is evidenced and any separately mandated authority has acted.
3. Required specialist findings and objections are resolved or explicitly retained as blockers.
4. Operational appointments/delegations are evidenced where an action requires them.
5. Any governance conflict has been escalated through a formal DEC process.
6. Affected DD files and backlog rows are updated consistently and re-fetched for verification.
7. A new cross-specification review confirms that no decision was broadened or contradicted.

This completion gate is a proposed review control. It is not a claim that the package has been reviewed or accepted.

## 8. Explicit exclusions and implementation boundary

This pack does not approve DD-01–DD-15, amend DEC-103–DEC-110, appoint any person, create any permission, or authorize application/API/UI/code changes, DB/schema/migrations/generated types, Storage, authentication, authorization, RLS, grants, production-data access/change, live workflow, provider/channel integration, external communications, test execution, backup/restore, archive, legal hold, deletion, disposition, merge, deployment or release.

Any subsequent implementation or test execution requires a separate scoped plan, completed prerequisite decisions, required owner and specialist approvals, formally appointed authorities, approved non-production environment and synthetic data, and explicit owner authorization. DB/Storage work additionally requires verified backups, isolated restore/rehearsal and reconciliation before changes.

## 9. Current disposition

**Prepared:** twelve structured decision sheets (OR-01–OR-12), governance-preservation checklist, consolidated disposition register, specialist evidence sheet and promotion gates.

**Recorded:** three scoped conditional owner dispositions (DISP-OR01-001, DISP-OR01-003 and DISP-OR01-004). **Not recorded:** specialist sign-offs, appointments, final DD approvals, scenario execution or implementation readiness.

**Current result:** three atomic owner dispositions are conditionally approved within their recorded scopes; remaining substantive items and specialist validations remain open or blocked. No implementation, test execution, merge or deployment is authorized.
