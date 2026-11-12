# OR-03 Specialist Validation and Evidence Matrix

**Document type:** Specialist-validation coordination matrix and evidence checklist  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — OR03-D01–D12 CONDITIONALLY APPROVED BY OWNER — SPECIALIST VALIDATION NOT EVIDENCED — OR-03 NOT CLOSED — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Owner decision package:** [docs/112](112_OR03_DISCIPLINE_CONFLICT_AND_INDEPENDENT_REVIEW_OWNER_DECISION_PACKAGE_WORKING_DRAFT.md)  
**Owner review package:** [docs/86](86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md)  
**Disposition register:** [docs/87](87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md)  
**DD-03 candidate specification:** [docs/111](111_RFI_DD03_DISCIPLINE_RESPONSIBILITY_TECHNICAL_LEADERSHIP_AND_CONFLICT_GOVERNANCE_WORKING_DRAFT.md)  
**Cross-specification review:** [docs/126](126_DD03_DD04_DD14_CROSS_SPECIFICATION_CONSISTENCY_REVIEW_WORKING_DRAFT.md)  
**DD-04 detailed candidate specification:** [docs/127](127_RFI_DD04_INDEPENDENT_REVIEW_AND_SEPARATION_OF_DUTIES_SPEC_WORKING_DRAFT.md)  
**DD-04 decision matrix:** [docs/128](128_RFI_DD04_DECISION_AND_REVIEW_CONTROL_MATRIX_WORKING_DRAFT.md)  
**DD-04 matrix cross-specification review:** [docs/129](129_DD04_DECISION_MATRIX_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md)  
**Related specifications:** docs/72–docs/83; especially DD-02, DD-03, DD-04 and DD-14  
**Related owner dispositions:** docs/113–docs/124  
**Protected governance:** DEC-103–DEC-110

> This matrix coordinates evidence collection and specialist findings for the twelve conditionally approved OR-03 owner dispositions. It does not appoint reviewers, establish authority, approve a risk matrix, convert conditional owner dispositions into final technical approval, or authorize implementation, test execution or operational use.

## 1. Purpose and current status

OR03-D01–D12 are conditionally approved by the owner only within their exact recorded scopes. This matrix translates each disposition into review questions, evidence requirements, acceptance criteria and explicit blockers. It supplements docs/85 and the OR-01-specific matrix in docs/104; it does not replace either or alter the owner records in docs/87.

**Current specialist evidence status: Pending for every OR-03 review package.** No reviewer assignment, appointment, competence finding, specialist sign-off or project-specific authority evidence is asserted by this document. A listed review domain is a required validation category, not proof that a qualified person has been identified or assigned.

### 1.1 Status vocabulary

| Status | Meaning |
|---|---|
| Pending | No attributable review evidence has been recorded. |
| Assigned — evidence pending | A reviewer identity may be entered only when actual assignment/appointment evidence is available; review is not complete. |
| In review | Reviewer has accepted the exact version, scope and review questions; activity is evidenced. |
| Findings issued | Attributable findings exist; their disposition and any required re-review remain open. |
| Conditional validation | Reviewer validates only the explicitly stated scope subject to listed conditions. |
| Validated for stated scope | Evidence supports completion of the defined specialist review for the exact version and scope; this is not owner approval, appointment or implementation authority. |
| Blocked — Pending Decision/Prerequisite | Required authority, source instrument, competence, evidence, decision or dependency is missing, disputed, ambiguous or stale. |
| Not applicable — justified | A domain is excluded only with a written rationale accepted by the competent authority; omission is not an exclusion. |

## 2. Required evidence record — one record per review domain and disposition

Every specialist review record must capture:

1. Unique review ID and linked OR03-D decision ID(s).
2. Reviewer identity, organization/party and whether the input is advisory, validation or an exercise of decision authority.
3. Relevant competence and its evidence for the exact subject and scope.
4. Appointment, delegation and governing instrument, including effective period and scope, whenever the reviewer exercises a decision, approval or authority function.
5. Exact document paths, revisions/commit SHAs or content hashes, sections, exclusions and review date.
6. Review questions and acceptance criteria used.
7. Findings, each classified as observation, required change, condition, objection/dissent, blocked prerequisite or justified not-applicable item.
8. Rationale, supporting evidence references, date/time and any applicable limitations.
9. Response to each finding, accountable disposition owner, closure evidence and residual open issue.
10. Confirmation that the reviewed material is the same exact version referenced by the finding.
11. Independent status check showing that no finding was marked closed by silence, administrative completion or an unverified assertion.

A title, seniority, project membership, authorship, system access, distribution-list membership, prior participation or availability does not prove appointment, competence, independence or authority. Advisory feedback must not be represented as approval. Preserve dissent and qualified findings.

## 3. OR-03 decision-by-decision specialist validation matrix

| Review package | Owner-approved scope requiring validation | Required specialist domains | Validation questions and evidence sought | Acceptance criteria | Current status |
|---|---|---|---|---|---|
| SV-OR03-01 / D01 — discipline scope and responsibility | Competent technical authority determines required disciplines from the engineering question, project scope and interfaces; coordinator remains administrative. | Project/process owner; appointing/project-governance authority; technical authority; affected discipline authorities; Document Control; security/architecture. | Identify the actual authority instrument, appointment, scope, term and delegation. Validate discipline inclusion/exclusion rationale, interface assessment, evidence currency and hold/escalation route when authority is unclear. | No discipline scope or assignment is inferred from title, membership, availability or convenience; each scope decision is attributable, evidenced, project-specific and reviewable. | Pending |
| SV-OR03-02 / D02 — contribution accountability | Separate attributable contribution per required discipline; distinguish submitted, administratively complete, technically assessed and technically confirmed. | Discipline authorities (ARC/CIV/MEC/ELE/SURVE as applicable); technical authority; Document Control/records; architecture; QA. | Validate contribution ownership, exact assignment/version, competence evidence, completeness vs technical confirmation, change lineage, interface and evidence requirements. | Upload/receipt or administrative completion cannot equal technical confirmation; each confirmation is by an evidenced authority for the exact discipline, scope and version. | Pending |
| SV-OR03-03 / D03 — technical-lead mandate | Technical lead has only bounded powers supported by competence, appointment, explicit delegation and scope; reserved matters are referred. | Appointing/project-governance authority; technical authority; discipline authorities; process owner; QA; security. | Validate mandate wording, competence/scope limits, permissible coordination/consolidation, reserved decisions, referral route, reassignment boundaries and no technical tie-break by coordinator. | Every permitted and reserved action maps to evidenced authority; no inferred appointment or power to override discipline positions, waive gates or issue/confirm readiness. | Pending |
| SV-OR03-04 / D04 — conflict classification and scoped blocking | C0–C4 remain conflict descriptors, not severity ranking; unresolved material technical conflict blocks affected content; authority dispute holds affected decision. | Technical authority; discipline authorities; risk/quality authority; independent assurance/QA; project governance. | Test each illustrative conflict class against worked cases; validate materiality and affected-scope reasoning; confirm C4 is not automatically more severe than C2; identify approved criteria or record their absence. | No unsupported severity scale or universal threshold; unresolved material conflict blocks affected content; block scope is evidence-based and not automatically the whole RFI/project. | Pending |
| SV-OR03-05 / D05 — conflict decision authority and escalation | Only competent appointed authority resolves matters within evidenced competence, project scope and delegation; otherwise hold and escalate while preserving competing positions. | Appointing/project-governance authority; technical authority; affected discipline authorities; contract/project governance where external authority is implicated; QA. | Validate authority hierarchy only from actual instruments; assess escalation routes, conflict-of-interest handling, decision rationale, scope, limitations, dissent and unresolved-authority holds. | No fallback by title, seniority, availability or convenience; escalation does not itself transfer authority; no majority vote, silence-as-concurrence or silent override. | Pending |
| SV-OR03-06 / D06 — dissent and qualified positions | Preserve original positions and evidence; record reasoned disposition; non-adoption is not proof of error or author withdrawal. | Discipline authorities; technical authority; Document Control/records; legal/contract/privacy specialists as applicable; QA. | Validate attribution, exact versions, disposition vocabulary, qualified response treatment, formal-response representation, disclosure constraints and preservation of predecessor material. | No false concurrence or destructive overwrite; adopted/partially adopted/not adopted/unresolved treatment is reasoned and attributable; material unresolved conflict and independent-review gates remain effective. | Pending |
| SV-OR03-07 / D07 — discipline interface checklists | ARC/CIV/MEC/ELE/SURVE checklist prompts are illustrative until approved for a project by competent appointed discipline authority. | Each affected discipline authority; technical authority; project/process owner; Document Control; QA. | Review discipline-specific relevance, interface coverage, project tailoring, additions/exclusions, versioning, evidence and authority approval route. | No checklist is treated as universally mandatory or as waiver; project use requires evidenced competent approval, scope and version; omissions do not waive obligations. | Pending |
| SV-OR03-08 / D08 — separation of functions | Distinguish contribution, technical assessment, lead coordination, conflict decision, independent review, readiness, issue, administration, distribution and acknowledgement. | Project governance/appointing authority; technical authority; QA/independent assurance; security/privacy; Document Control; HR/competence or conflict-of-interest function where applicable. | Validate action-specific appointments, competence, self-review restrictions under actual instruments, conflict disclosure/mitigation and any exceptional role combination/compensating controls. | No role bundle or default dual-signature rule is invented; administrative and distribution functions confer no technical authority; any exception is case-specific, approved and evidenced. | Pending |
| SV-OR03-09 / D09 — independent-review trigger boundary | Mandatory independent review only when an approved/versioned risk-and-authority matrix or expressly applicable approved instrument defines trigger and competent decision authority. | Risk/quality authority; appointing/project-governance authority; QA/independent assurance; technical and discipline authorities; security/records. | Review docs/127–129; identify the actual approved matrix and disposition the cross-review findings, version, scope, trigger criteria, decision authority and control; validate reviewer competence, appointment, independence and conflict declaration. If absent, document the blocker. | No substitute trigger or threshold is invented; disagreement alone is not an automatic trigger; conflict resolution cannot waive a matrix-required review. | Pending |
| SV-OR03-10 / D10 — re-review after changes | Changes are assessed against exact reviewed version; targeted/full re-review is proportionate to evidenced impact and applicable matrix. | Technical authority; affected discipline authorities; QA/independent assurance; Document Control/records; architecture; project governance. | Review docs/127–129 with OR03-D10; validate change-impact record and the DM-15/DM-16 authority split, materiality/dependency assessment, affected scope, prior clearance version binding, targeted/full re-review rationale and matrix-driven mandatory re-review. | Prior clearance is not silently transferred; uncertainty about authority, materiality or dependency holds affected clearance; no universal thresholds are invented. | Pending |
| SV-OR03-11 / D11 — conflict record and history | Preserve original positions/classifications/evidence, decision authority/rationale/time, predecessor/successor lineage and traceable corrections; conflict closure does not close parent RFI. | Document Control/records; discipline and technical authorities; project/process governance; architecture/data; security/privacy; legal/records specialists. | Reconcile record identity and lineage with RFI/cycle/contribution/evidence identities; validate correction/audit trail, authorized access, preservation, retention, archive, legal hold, backup/replica and disposition dependencies. | No destructive replacement or untraceable correction; record access is authorized; retention/deletion controls derive from approved records instruments and remain blocked until validated. | Pending |
| SV-OR03-12 / D12 — external authority and contractual boundary | External involvement only where an applicable governing instrument requires it; no inferred authority; internal RFI outcomes and communication events do not imply external approval. | Contract/commercial; legal; project governance; regulatory/authority liaison; technical authority; Document Control/records; security/privacy. | Identify actual contracts, statutory/regulatory instruments, appointment/mandate, notice route, recipient, exact version, conditions and effect. Validate distinctions among advisory review, consent, approval, no-objection and formal instruction. | No legal/contractual effect or deadline is inferred; delivery/access/acknowledgement is not substantive acceptance; unclear authority or notice requirements remain held for competent review. | Pending |

## 4. Cross-package dependencies and sequencing

1. D01 and D03 cannot be validated as operationally usable until DD-02 appointment/delegation evidence and appointing authority are identified.
2. D02 and D07 require validation by the disciplines actually affected by the engineering scope; the taxonomy ARC/CIV/MEC/ELE/SURVE is not an instruction to appoint every discipline to every RFI.
3. D04 and D05 depend on competent technical authority and evidence-based project scope; unresolved authority or missing materiality criteria remain blockers.
4. D06 and D11 depend on authoritative identity, version lineage, access and records controls; retention, legal hold, archive, backup and disposition require separate records/legal/security validation under DD-14 and DEC-109.
5. D08, D09 and D10 depend on DD-04 and an actual approved/versioned risk-and-authority matrix where mandatory independent-review triggers are asserted. If that instrument is absent, the result is Blocked, not an inferred approval.
6. D12 requires actual governing instruments and project-specific contract/legal/regulatory review; this matrix does not interpret those instruments.
7. Cross-check all findings against DEC-103 and DEC-108: delivery, access and acknowledgement remain distinct from technical agreement, formal issue and external approval.
8. No child contribution, conflict, review or communication event autonomously changes the parent RFI lifecycle.

## 5. Review acceptance and blocker rules

A review package may be marked **Validated for stated scope** only when all of the following are present:

- reviewer identity and relevant competence evidence;
- appointment/delegation and authority evidence wherever the reviewer exercises an authority function;
- exact version, scope and sections reviewed;
- completed review questions and explicit findings;
- supporting evidence references and date;
- each finding has a documented disposition, or is explicitly retained as an open blocker/condition;
- dissent and limitations are preserved;
- cross-dependencies and affected owner dispositions are reconciled;
- an independent status check confirms that the recorded result matches the evidence.

Use **Blocked — Pending Decision/Prerequisite** where the governing instrument, authority, appointment, competence, risk matrix, exact-version evidence, discipline input or legal/records prerequisite is missing, ambiguous, disputed or stale. Do not downgrade a blocker to an observation for schedule convenience.

Specialist validation is not the same as:
- owner disposition;
- appointment or operational authority;
- final approval of the complete DD-03/DD-04 specifications;
- permission or capability grant;
- implementation authorization;
- test execution or test pass;
- production readiness or release approval.

## 6. Consolidated evidence ledger — blank template

| Field | Entry |
|---|---|
| Review ID / OR03-D ID | |
| Review domain / advisory or authority function | |
| Reviewer identity / organization | |
| Competence evidence | |
| Appointment/delegation instrument and scope (if applicable) | |
| Exact files / revisions / SHAs / sections reviewed | |
| Review questions and criteria | |
| Findings and evidence references | |
| Dissent / limitations / conditions | |
| Required action / accountable party | |
| Disposition and closure evidence | |
| Residual blocker / dependency | |
| Review status and date | |
| Independent verification | |

## 7. Promotion gates and implementation boundary

OR-03 may be considered for formal specialist closeout only after all applicable review packages have evidence-backed outcomes, unresolved findings are either closed or explicitly retained as blockers under competent authority, appointment and governing-instrument prerequisites are reconciled, and the exact revised DD-03/DD-04 documents pass a fresh cross-specification review.

This matrix does **not**:
- appoint any reviewer, technical authority, discipline authority, lead, coordinator or external authority;
- approve a risk-and-authority matrix or create universal severity/materiality thresholds;
- establish legal, contractual, statutory, notice or deemed-consent effects;
- create schema, workflow, event model, permission, capability or role grants;
- authorize UI/API/code, DB/schema/migrations/generated types, Storage, authentication, authorization/RLS, production-data operations, test execution, backup/restore, merge, deployment or release.

Any later implementation or test execution requires a separate scoped plan, resolved prerequisites, required owner and specialist approvals, evidenced appointments, approved non-production environment and synthetic data, and explicit owner authorization. DB/Storage work additionally requires verified backups, isolated restore/rehearsal and reconciliation before changes.

---

**Current result:** OR03-D01–D12 remain conditionally approved by owner within their recorded scopes. All specialist validation entries in this matrix remain Pending until attributable exact-version evidence is supplied and reviewed. OR-03 is not formally closed.
