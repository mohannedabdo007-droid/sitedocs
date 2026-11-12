# OR-01 Specialist Validation and Evidence Matrix

**Document type:** Specialist-validation coordination matrix and evidence checklist  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — OWNER DISPOSITIONS CONDITIONALLY APPROVED — SPECIALIST VALIDATION NOT YET EVIDENCED — NOT DESIGN CLOSEOUT OR IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent assessment:** `docs/103_OR01_OWNER_DISPOSITION_RECONCILIATION_AND_REVIEW_CLOSEOUT_ASSESSMENT_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Specialist review matrix:** `docs/85_RFI_OWNER_AND_SPECIALIST_REVIEW_MATRIX_WORKING_DRAFT.md`  
**Detailed specification set:** `docs/72`–`docs/83`  
**Protected governance:** DEC-103–DEC-110

> This matrix identifies review domains and evidence to collect. It does not name or appoint reviewers, create authority, record a review as completed, convert conditional owner dispositions to final approval, or authorize implementation/testing.

## 1. Purpose and status

This matrix converts the 13 substantive conditional owner dispositions into individually trackable specialist-validation packages. It supplements, and does not replace, the cross-risk matrix in docs/85 or the authoritative owner-disposition records in docs/87.

**Current evidence status:** No specialist sign-off is evidenced by this matrix or by the reviewed OR-01 package. All review assignments and evidence fields below begin as **Pending**. A domain listed below is not proof that a qualified reviewer has been appointed or has reviewed the relevant material.

### 1.1 Status vocabulary

| Status | Meaning |
|---|---|
| Pending | Review not evidenced as completed. |
| Assigned — evidence pending | A reviewer may be recorded only after actual assignment/appointment evidence is supplied; review result is still pending. |
| In review | Exact version and scope have been accepted for review and work is evidenced. |
| Findings issued | Attributable findings exist; disposition/closure remains open. |
| Conditional validation | Reviewer validates only the expressly stated scope subject to listed conditions. |
| Validated for stated scope | Evidence demonstrates the requested specialist review is complete for the exact version/scope; this is not owner approval or operational appointment. |
| Blocked — Pending Decision/Prerequisite | Required authority, source evidence, decision, or prerequisite is missing, disputed or stale. |
| Not applicable — justified | A domain is excluded only with a recorded rationale and the responsible authority's acceptance; never by omission. |

## 2. Required evidence record — one per reviewer/domain

For every review entry, capture:

1. Review ID and linked DISP-OR01 ID(s).
2. Reviewer identity and organization/party.
3. Review domain and competence relevant to the subject.
4. Appointment/delegation/authority instrument and effective scope, where the reviewer is exercising a decision or approval function. Advisory reviewers must be identified as advisory.
5. Exact document path, revision/commit or content hash, sections and exclusions reviewed.
6. Review questions and criteria supplied to the reviewer.
7. Findings classified as accepted observation, required change, condition, objection/dissent, or not applicable with rationale.
8. Evidence references (minutes, signed review, controlled correspondence, marked-up copy or equivalent) and date.
9. Response/disposition for each finding, responsible owner/domain, closure evidence and residual risk.
10. Independent verification that the recorded status matches the evidence and exact reviewed version.

A reviewer's title, project membership, authorship, prior participation, or inclusion in a domain list does not prove appointment, competence, independence or decision authority. Preserve dissent; do not mark a finding closed merely because no response was received.

## 3. Decision-by-decision specialist validation matrix

| Owner disposition | Exact owner-approved scope to validate | Required specialist domains | Validation questions / evidence sought | Operational authority evidence (separate from specialist review) | Current status |
|---|---|---|---|---|---|
| DISP-OR01-001 | Draft and Abandoned Draft remain pre-submission draft-record conditions; retain 11 candidate official labels as a refinement baseline; Closed/Withdrawn/Cancelled distinct; indicators outside parent lifecycle | Process/RFI owner; technical/process authority; Document Control; architecture; security/privacy; records; QA | Test semantic separation of draft vs official identity; state entry/exit evidence; terminal distinctions; parent vs child/event boundaries; visibility and auditability. Identify any label ambiguity and proposed transition gaps. | Evidence for originator, coordinator, technical lead, reviewer, issuer and closure/terminal-outcome authorities; no role inferred from title | Pending |
| DISP-OR01-003 | Option C hybrid return/correction approach; no silent technical lifecycle reset; preserve history and technical activity | Process owner; Document Control; technical authority/lead; affected disciplines; architecture; QA; security | Confirm administrative return boundary, late material defect correction route, impact assessment, preserved contributions and no automatic technical rollback. Provide scenario analysis and exception boundaries. | Appointment/delegation for return decision, technical impact assessment and administrative execution; scopes and separation documented | Pending |
| DISP-OR01-004 | Two-key hand-off: technical authority establishes discipline scope/lead/assignments; coordinator verifies administrative readiness and executes transition; all required assignments complete | Project governance/appointing authority; technical authority; discipline authorities; Document Control; architecture; security/identity; QA | Confirm who may appoint, what constitutes valid assignment and scope evidence, mandatory lead criteria, unavailable-discipline escalation, acceptance/change controls, and whether the hand-off can be performed without inferring authority. | Actual appointing authority and appointment instruments; technical authority/lead and assignee scope, effective period, delegation and revocation evidence; coordinator's explicit execution delegation | Pending |
| DISP-OR01-005 | Clarification blocks only with authorized reasoned dependency and scope; contribution-only blockers remain scoped; parent waits only for parent blockers; preserve each exchange; resume exact prior stage after all parent blockers resolve and guards pass | Technical authority/lead; affected discipline specialists; process owner; Document Control; architecture; security; QA | Validate blocker classification and affected scope, partial response/sufficiency tests, multiple concurrent blockers, saved prior stage, Under Consolidation cases, stale evidence and resumption conditions. | Appointment/scope for technical blocker designation and sufficiency decision; authority for any parent-level lifecycle transition | Pending |
| DISP-OR01-006 | All required contributions complete/confirmed or validly removed from scope before parent enters Under Consolidation; limited provisional subordinate preparation may occur earlier without changing parent stage | Appointed technical lead/authority; discipline authorities; process owner; architecture; QA; Document Control | Define objective completion/confirmation evidence per contribution; validate required vs optional classification; provisional artifact attribution/versioning; late inputs, scope changes, stale versions and conflict behavior. | Valid appointment for technical lead and discipline decision-makers; evidenced authority to change required scope/assignments | Pending |
| DISP-OR01-007 | Material-gap return from Under Consolidation to Technical Assessment; bounded affected discipline return; preserve unaffected work, prior versions and candidate; re-entry only after gates re-satisfied | Technical lead/authority; affected discipline authorities; process owner; architecture; QA; records | Validate materiality examples, lead's return mandate, scope boundaries, candidate/version succession, preservation, re-entry criteria, clarification/review interactions and concurrency. | Current appointment/delegation for technical lead to authorize scoped return; technical authority to resolve scope/delegation disputes | Pending |
| DISP-OR01-008 | Mandatory independent review derives from approved/versioned risk-authority matrix; reviewer independence and exact-version package; changes trigger impact/re-review; blocking comments hold readiness | Risk/technical authority; QA/independent assurance; security; relevant disciplines; architecture; Document Control | Identify the governing risk matrix or explicitly record its absence; validate trigger ownership, reviewer competence/independence, conflicts, exact package manifest, conditional clearance rules and targeted/full re-review criteria. | Approved matrix authority and applicability decision authority; reviewer appointment, competence, scope, independence/conflict declaration and substitution evidence | Pending |
| DISP-OR01-009 | Ready for Issue is a separate exact-version readiness confirmation; all prerequisites and blockers checked; readiness authority distinct from issuer; issue-time revalidation | Technical authority/lead; QA; Document Control; architecture; security; records | Validate checklist completeness, evidence manifest, readiness record traceability, stale-state handling, materiality, final revalidation and separation from formal issue/Transmittal/closure. | Specific readiness confirmer and formal issuer appointments/delegations for project/party/RFI scope and actions; evidence they are distinct authorities where required | Pending |
| DISP-OR01-010 | Formal issue and technical closure are one indivisible successful business outcome with distinct linked evidence; exact package immutable; no assumed separate-closure exception | Technical authority; architecture/engineering; data integrity; security; QA; Document Control; records; contract governance as applicable | Validate business atomicity, exact candidate/package binding, failed-attempt behavior, duplicate/concurrent issue prevention, recovery/reconciliation, immutable issue/closure history and post-issue route boundaries. | Current formal issuer appointment/delegation and scope; operational recovery/change authority separately evidenced; no default dual-signature requirement inferred | Pending |
| DISP-OR01-011 | Pre-issue originator withdrawal request; evidence-based substantive-work threshold; technical-lead concurrence after work begins; separately appointed records/workflow authority decides; preserve whole-parent history | Process owner; technical lead/discipline authorities; records/workflow authority; Document Control; architecture; QA; contract/legal as applicable | Validate requester's party authority, substantive-work evidence taxonomy, concurrence meaning, eligible-state cutoff, partial-scope handling, issue race and record preservation. | Same-party originator delegate evidence; technical-lead appointment; records/workflow authority appointment and exact project/party/RFI scope; coordinator delegation if used | Pending |
| DISP-OR01-012 | Narrow pre-issue cancellation grounds: proven duplicate or objectively invalid registration; correction preferred for correctable defects; separately appointed records/workflow authority; preserve duplicate identities/history | Process owner; records/workflow authority; technical lead/discipline authorities; Document Control; architecture; QA; contract/legal as applicable | Validate evidence taxonomy for duplicate/invalid registration, exhaustive or bounded grounds, correction/cancellation boundary, canonical link rules, external concurrence only where an approved rule requires it, issue race and no silent merge. | Appointment of cancellation decision authority; technical-lead concurrence authority after substantive work begins; records custodian and any contract decision authority | Pending |
| DISP-OR01-013 | Authorized post-issue reopening creates distinct new response cycle for same question; preserve prior cycle; no clearance transfer or gate bypass | Technical authority/lead; affected discipline authorities; process owner; records; Document Control; architecture; security/privacy; QA/independent assurance; contract governance as applicable | Validate material reopening grounds, referral vs decision, same-RFI/new-cycle identity, starting-stage assessment, contribution revalidation, exact-version review/readiness, Transmittal history and idempotency. | Current technical authority appointment for exact project/party/RFI scope; technical lead's bounded assessment authority; any contract/project direction authority where relevant | Pending |
| DISP-OR01-014 | One authoritative parent stage; independent subordinate identities/history; child events affect parent only through explicit gates; communication, indicators and records do not autonomously change lifecycle | Process owner; technical authority/discipline authorities; architecture/data governance; security/privacy; Document Control; records; reporting authority; QA | Validate parent/cycle/child identity model, gate catalogue, event projection, distinct counting units, linked workflow independence, permission-safe aggregation, reporting/export lineage, retention and concurrency/recovery. | Appointments for lifecycle action authorities, reporting/export approvers, records custodians and linked-workflow authorities; each limited to project/party/scope | Pending |

## 4. Cross-disposition review packages and sequencing

The following packages reduce duplicated reviews while retaining a separate finding against each affected disposition.

| Package | Included dispositions | Lead review domains | Required output / exit evidence | Dependency |
|---|---|---|---|---|
| SV-01 — Lifecycle and authority foundation | 001, 003, 004, 014 | Process owner; technical authority; Document Control; architecture; security; QA | Reconciled parent-state dictionary, transition/gate crosswalk, actor/authority map, parent/subordinate event boundary and issue list | First; informs all later packages |
| SV-02 — Technical work and clarification gates | 005, 006, 007 | Technical lead/authority; discipline authorities; process owner; architecture; QA | Contribution completion criteria, blocker taxonomy, return/re-entry rules, provisional artifact controls and scenario findings | After SV-01 and authority evidence |
| SV-03 — Independent review and readiness | 008, 009 | Risk/technical authority; QA/independent assurance; security; architecture; Document Control | Approved/versioned risk-matrix reference or explicit blocked record; reviewer appointment criteria; exact-version review/readiness crosswalk | Depends on SV-01, SV-02 and actual risk-matrix authority |
| SV-04 — Formal issue and closure | 010 | Technical authority; architecture/data integrity; security; QA; records | Business transaction/recovery review, immutable evidence linkage, concurrency/failure-mode findings and authority map | Depends on SV-03 |
| SV-05 — Withdrawal, cancellation and reopening | 011, 012, 013 | Process/technical authority; records; Document Control; architecture; QA; contract/legal as applicable | Evidence thresholds, decision-authority matrix, eligible-state/cutoff analysis, post-issue cycle and preservation crosswalk | Depends on SV-01 and SV-04 |
| SV-06 — Independent indicators and records boundary | 014 (plus cross-checks against 008–013) | Architecture/data governance; security/privacy; reporting; records; QA | Parent/subordinate event map, distinct metric dictionary, permission-safe query/export review, archive/hold separation | Depends on detailed record models and protected DEC-103/108/109 |

A package may be reviewed in parallel only where its inputs are stable and the reviewer receives the exact controlled versions. A finding that depends on unresolved authority or another package remains conditional or blocked; parallel review does not waive dependencies.

## 5. Open evidence and design questions that must not be guessed

| ID | Open item | Primary disposition(s) | Required closure evidence | Interim treatment |
|---|---|---|---|---|
| OQ-01 | Actual appointed technical authorities, leads, discipline authorities, coordinators, reviewers, issuers and records/workflow authorities | 003–013 | Valid appointment/delegation instruments, scope, effective period, competence/independence where relevant, revocation/substitution | Block action requiring missing or disputed authority |
| OQ-02 | Approved/versioned risk and authority matrix, owner and applicability decision authority | 008, 009 | Controlled matrix and approval/effective-version evidence | Mandatory review trigger unresolved; do not infer no-review |
| OQ-03 | Final parent state labels and complete transition/guard dictionary | 001, 003–007, 014 | Reconciled DD-01 state/transition specification and cross-document review | Candidate labels remain working draft |
| OQ-04 | Required vs optional discipline assignments and contribution completion criteria | 004–007, 009, 014 | Discipline-authority-approved assignment and completion criteria | Do not progress gates by convenience |
| OQ-05 | Clarification blocker taxonomy, parent vs contribution scope, partial response and exact resume semantics | 005, 014 | Validated decision table and edge-case findings | Hold ambiguous parent progression |
| OQ-06 | Materiality threshold and examples for return, correction, re-review, withdrawal/cancellation substantive-work threshold and reopening | 003, 007, 008, 011–013 | Domain-approved examples, boundaries and evidence rules | No inferred threshold or automatic route |
| OQ-07 | Readiness/issuer appointment boundaries and exact package manifest | 009, 010 | Appointment evidence, readiness record requirements and immutable package/version manifest review | No readiness or issue action |
| OQ-08 | Atomic issue/closure transaction and recovery/idempotency/concurrency mechanics | 010–014 | Architecture review, failure/recovery analysis and reconciliation controls | No implementation or test execution |
| OQ-09 | Official number format, uniqueness namespace and legacy collisions | 002 consistency only; DD-06 | Owner/Document Control/records decision and complete source inventory/collision evidence through the proper review route | Preserve DEC-107; no allocator/renumbering |
| OQ-10 | Recipient distribution route, acknowledgement requirement and external authority | Cross-check DEC-103/108; DD-09/10 | Approved recipient/channel/authority design | No external distribution implementation |
| OQ-11 | Reporting metrics, audiences, search/export authorization and counting units | 014; DD-13 | Approved metric dictionary, audience/entitlement and privacy review | No default formulas or broad exports |
| OQ-12 | Records schedule, retention, legal hold, archive, backup/replica and disposition controls | 010–014; DD-14 | Records/legal/security/architecture evidence and approved schedule/authority | No automatic archive/deletion or retention default |
| OQ-13 | Actual AT-RFI-01–13 and 28 E2E scenario definitions and traceability | 005–014; DD-15 | Source scenario inventory, requirement mapping, expected outcomes and approved test governance | Proposed counts are not execution or pass evidence |

## 6. Protected governance consistency checklist

Every review package must explicitly confirm preservation of the applicable controls:

- [ ] DEC-103 — recipient-level delivery and required-recipient acknowledgement aggregation.
- [ ] DEC-104/105 — confirmed RFI operating direction; multidisciplinary responsibility and authority separation; no automatic grants/appointments.
- [ ] DEC-106 — clarification, withdrawal, cancellation, reopening, closure and date boundaries.
- [ ] DEC-107 — successful formal-submission numbering boundary, no number reuse, immutable evidence/version principles; no guessed display format or legacy resolution.
- [ ] DEC-108 — authorized technical issue separate from controlled external Transmittal distribution and recipient events.
- [ ] DEC-109 — lifecycle separate from workload, communication, monitoring and records indicators; no default SLA/cadence/retention/disposition.
- [ ] DEC-110 — traceable test governance; proposed scenario inventory is not execution evidence; unresolved prerequisites remain blockers.

Any actual conflict with a protected decision must be referred to the formal governance amendment process. This matrix cannot amend DEC-103–DEC-110.

## 7. Evidence completion dashboard

| Review package | Status | Evidence count | Blocking condition |
|---|---|---:|---|
| SV-01 — Lifecycle and authority foundation | Pending | 0 evidenced specialist reviews in this matrix | No attributable reviewer findings/authority evidence recorded |
| SV-02 — Technical work and clarification gates | Pending | 0 | No technical/discipline validation recorded |
| SV-03 — Independent review and readiness | Pending | 0 | Approved risk/authority matrix and reviewer appointments not evidenced |
| SV-04 — Formal issue and closure | Pending | 0 | Architecture/recovery and issuer authority evidence not recorded |
| SV-05 — Withdrawal, cancellation and reopening | Pending | 0 | Appointments, evidence thresholds and specialist findings not recorded |
| SV-06 — Parent/subordinate indicators and records | Pending | 0 | Architecture/data, security/privacy, reporting and records validation not recorded |

Evidence counts above refer only to this matrix at its creation/revision. They do not assert that no discussions exist elsewhere; any external review evidence must be linked and independently verified before changing status.

## 8. Rules for recording a completed review

1. Never change a row from Pending based on an informal conversation summary without an attributable evidence reference.
2. Record each specialist's scope and findings separately; one review may cover several dispositions only if it explicitly addresses each one.
3. Separate advisory validation from formal approval authority. Where the reviewer is also an appointed decision-maker, record both capacities and the authority instrument.
4. A finding may validate a principle while identifying unresolved design conditions; record the precise scope and do not mark the entire disposition or workstream closed.
5. If reviewers disagree, preserve both positions and refer the unresolved issue to the designated authority; no majority vote or silence-as-concurrence.
6. Changed source documents require impact assessment and, where material, renewed review against the new exact version.
7. Independent verification checks reviewer authority, exact version, evidence completeness, conditions, dissent and downstream reconciliation.
8. Only after all applicable reviews and conditions close may the owner be asked to approve the exact detailed-design version. Implementation authorization remains separate.

## 9. Immediate next actions

1. Confirm the project governance route for appointing the specialist reviewers and identify the actual authorized appointing authority; do not pre-fill names.
2. The preliminary desk review of SV-01 is recorded in docs/105_OR01_SV01_LIFECYCLE_AND_AUTHORITY_FOUNDATION_REVIEW_WORKING_DRAFT.md. It identifies six reconciliation gaps (G-01–G-06); this is not specialist validation and does not change the SV-01 evidence count.
3. In parallel, prepare the authority-evidence inventory for OQ-01 and obtain the approved risk/authority matrix or record OQ-02 as blocked.
4. After SV-01 findings, proceed to SV-02 and SV-03; do not advance a dependent package on stale or disputed inputs.
5. Record each review in docs/87 and update docs/85/86/103 only when actual evidence is received and verified.
6. Conduct a fresh cross-specification consistency review after findings are reconciled.

## 10. Explicit exclusions

This matrix does not appoint reviewers or operational authorities; grant capabilities; approve the final lifecycle state machine or detailed specifications; select providers or technologies; set SLA, notification, retention or legal defaults; execute tests; modify application code or data; change DB/schema/migrations/generated types, Storage, authentication, authorization/RLS/grants; access/change production data; perform backup/restore, archive, legal hold, deletion/disposition, merge, deployment or release.

Any such work requires a separate scoped plan, relevant authority and specialist approvals, safeguards, an approved non-production environment and synthetic data, and explicit owner authorization. DB/Storage work additionally requires verified backups, isolated restore/rehearsal and reconciliation before changes.

---
**End of working matrix — 13 owner dispositions remain conditionally approved; specialist validation evidence is pending; OR-01 detailed-design closeout and implementation remain blocked.**
