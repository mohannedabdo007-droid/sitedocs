# DD-03 — Discipline Responsibility, Technical Leadership and Conflict Governance: Atomic Leaf Requirements

**Document type:** Governance traceability decomposition — working draft  
**Date:** 2026-11-13  
**Status:** WORKING DRAFT — CANDIDATE LEAVES — OR03-D01–D12 CONDITIONALLY APPROVED WITHIN RECORDED SCOPE — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent specification:** `docs/111_RFI_DD03_DISCIPLINE_RESPONSIBILITY_TECHNICAL_LEADERSHIP_AND_CONFLICT_GOVERNANCE_WORKING_DRAFT.md`  
**Owner decision package:** `docs/112_OR03_DISCIPLINE_CONFLICT_AND_INDEPENDENT_REVIEW_OWNER_DECISION_PACKAGE_WORKING_DRAFT.md`  
**Authority dependency:** DD-02 / `docs/149_DD02_CAPABILITY_APPOINTMENT_GOVERNANCE_LEAF_REQUIREMENTS_WORKING_DRAFT.md`  
**Acceptance catalogue:** `docs/83_RFI_TEST_GOVERNANCE_AND_ACCEPTANCE_CATALOGUE_WORKING_DRAFT.md`

> This document decomposes DD-03 candidate governance into atomic traceability requirements. It does not approve new policy, appoint people, create capability identifiers, establish project engineering criteria, approve C0–C4 thresholds, or authorize tests or implementation. OR03-D01–D12 remain conditionally approved only within their recorded scopes; specialist validation and project-specific authority evidence remain pending.

## 1. Purpose and decomposition rules

The leaves below are intended to make each independently verifiable governance obligation explicit. A leaf is not a test case, system enum, permission, role assignment or approval. Candidate mappings to AT-RFI/E2E scenarios must be checked against exact source wording and approved expected-result authority before DD-15 promotion.

The controlled discipline codes are **ARC** (Architectural), **CIV** (Civil / Structural), **MEC** (Mechanical), **ELE** (Electrical) and **SURVE** (Survey). CIV is one combined discipline code here; no separate Structural code is introduced by this decomposition. The project's approved taxonomy and any subdiscipline splits still require validation.

## 2. Atomic leaf requirements

### A. Discipline scope, taxonomy and assignment

| Leaf ID | Atomic requirement | Control / evidence expected | Candidate source / dependency |
|---|---|---|---|
| RFI-DIS-L001 | Every RFI technical scope determination shall identify the engineering question, affected project scope and relevant interfaces used to determine required disciplines. | Attributable scope decision and rationale linked to exact RFI/cycle. | DD-03 §4.1; OR03-D01 |
| RFI-DIS-L002 | Required discipline selection shall be made only by a currently appointed authority whose project, party, subject and action scope covers the determination. | Appointment/delegation provenance and effective scope. | DD-02; OR03-D01 |
| RFI-DIS-L003 | The controlled discipline set for this design baseline shall use ARC, CIV, MEC, ELE and SURVE; CIV shall not be split into a separate Structural code without an approved taxonomy change. | Versioned discipline taxonomy and change authority. | OR03-D07; project taxonomy validation |
| RFI-DIS-L004 | Discipline inclusion and exclusion shall be reasoned from technical scope, not inferred solely from keywords, staff availability, historical participation or coordinator preference. | Inclusion/exclusion rationale; no keyword-only auto-assignment. | DD-03 §4.1; OR03-D01 |
| RFI-DIS-L005 | Each required discipline assignment shall identify the RFI, active response cycle, discipline, bounded subject/scope, accountable contributor and effective period. | Versioned assignment record and authority reference. | DD-03 §4.1–4.2; DD-02 |
| RFI-DIS-L006 | A discipline assignment or scope change shall preserve predecessor assignment, work status, contribution lineage and downstream review/readiness impact. | Before/after scope, reason, effective date and impact record. | DD-03 §4.3; OR03-D11 |
| RFI-DIS-L007 | Reassignment shall not silently transfer authorship or accountability for a predecessor's technical judgement. | Successor explicitly adopts, validates or replaces a position through an attributable action. | DD-03 §4.3; OR03-D02/D11 |

### B. Discipline contribution accountability and completeness

| Leaf ID | Atomic requirement | Control / evidence expected | Candidate source / dependency |
|---|---|---|---|
| RFI-DIS-L008 | Every required discipline shall provide a separately attributable contribution for its assigned scope unless that scope is validly removed by an authorized change. | Required-contribution register and scoped removal evidence. | DD-03 §§3–5; DISP-OR01-006 |
| RFI-DIS-L009 | A contribution shall identify its RFI/cycle, discipline, assignment version, contributor, question addressed, technical position, basis, assumptions, interfaces, limitations and version history as applicable to its approved record profile. | Contribution completeness record; mandatory field profile remains to be approved. | DD-03 §5.1; OR03-D02 |
| RFI-DIS-L010 | Submission, administrative completeness, technical assessment, technical confirmation and acceptance for consolidation shall remain distinguishable conditions. | Separate attributable evidence for each applicable condition; no status conflation. | DD-03 §5.2; OR03-D02 |
| RFI-DIS-L011 | Assignment acceptance, file upload, read/view activity or coordinator status change shall not by itself constitute technical confirmation or concurrence. | Negative control and audit evidence. | DD-03 §§4–5; DEC-105 |
| RFI-DIS-L012 | A missing, blank or ambiguous contribution field or position shall not be interpreted as agreement, completion or waiver. | Explicit unresolved/unknown handling and scoped blocker. | DD-03 §§5.1–5.2; OR03-D02/D06 |
| RFI-DIS-L013 | Required contribution scope shall not be reduced because a contribution is late, difficult to obtain or administratively inconvenient. | Scope-removal authority, reason and retained predecessor scope. | DD-03 §5.2; DISP-OR01-006 |
| RFI-DIS-L014 | Each contribution shall preserve the exact source versions, evidence references, assumptions and cross-discipline dependencies relied upon. | Version-bound references and attributable change summary. | DD-03 §§5–6; DD-08; OR03-D11 |

### C. Discipline-specific interface accountability

| Leaf ID | Atomic requirement | Control / evidence expected | Candidate source / dependency |
|---|---|---|---|
| RFI-DIS-L015 | ARC contribution review shall consider relevant architectural scope and interfaces without granting ARC authority to approve another discipline's professional conclusion. | ARC-scoped review evidence; project-specific checklist validation. | DD-03 §6.2; OR03-D07 |
| RFI-DIS-L016 | CIV contribution review shall consider relevant civil/structural scope and interfaces under the single CIV code without creating an unapproved separate Structural discipline. | CIV-scoped review evidence; project-specific checklist validation. | DD-03 §6.2; OR03-D07 |
| RFI-DIS-L017 | MEC contribution review shall consider relevant mechanical scope and interfaces without treating mechanical coordination as approval of electrical, civil or architectural conclusions. | MEC-scoped review evidence; project-specific checklist validation. | DD-03 §6.2; OR03-D07 |
| RFI-DIS-L018 | ELE contribution review shall consider relevant electrical scope and interfaces without treating electrical coordination as approval of other disciplines' conclusions. | ELE-scoped review evidence; project-specific checklist validation. | DD-03 §6.2; OR03-D07 |
| RFI-DIS-L019 | SURVE contribution review shall consider relevant survey control, datum, coordinate, setting-out and verification interfaces without extending survey scope into design approval. | SURVE-scoped evidence and approved project survey criteria. | DD-03 §6.2; OR03-D07 |
| RFI-DIS-L020 | Discipline interface prompts shall remain illustrative until validated by the relevant competent discipline authority and approved for the project context. | Versioned checklist approval and applicability evidence. | DD-03 §6.2; OR03-D07 |
| RFI-DIS-L021 | Cross-discipline interface issues shall identify affected disciplines, exact contribution versions, issue scope, action owner, decision authority and resolution evidence. | Traceable interface issue record. | DD-03 §6.3; OR03-D11 |

### D. Conflict classification, materiality and disposition

| Leaf ID | Atomic requirement | Control / evidence expected | Candidate source / dependency |
|---|---|---|---|
| RFI-DIS-L022 | Conflict classification shall describe the nature of the issue using candidate classes C0–C4 and shall not treat the class number as a severity or risk ranking. | Classification rationale distinct from risk/materiality assessment. | DD-03 §7.1; OR03-D04 |
| RFI-DIS-L023 | Conflict classification shall preserve the distinctions among compatible inputs, interface/assumption clarification, material technical disagreement, authority/scope dispute and external/unresolved dependency. | Exact class meaning and evidence; criteria remain subject to specialist validation. | DD-03 §7.1; OR03-D04 |
| RFI-DIS-L024 | Every conflict record shall identify the affected RFI/cycle/question, disciplines, exact source versions, positions, assumptions, evidence and affected scope. | Conflict record with immutable source references. | DD-03 §7.2; OR03-D11 |
| RFI-DIS-L025 | Materiality and blocking scope shall be assessed and recorded by an evidenced competent authority; neither may be inferred from C0–C4 class number. | Separate materiality decision, authority and rationale. | DD-03 §§7.1–7.4; OR03-D04/D05 |
| RFI-DIS-L026 | An unresolved material technical disagreement shall block the affected consolidated response content until an authorized disposition is recorded. | Scoped blocker linked to conflict and exact candidate. | DD-03 §7.4; OR03-D04 |
| RFI-DIS-L027 | An authority/scope dispute shall hold the affected decision until competent appointment and delegation are evidenced. | Fail-closed authority check; no coordinator tie-break. | DD-03 §§7.1, 7.3, 8; OR03-D05 |
| RFI-DIS-L028 | An external dependency shall block only the affected work or parent progression that genuinely depends on the missing input under an applicable approved gate. | Dependency, source, affected scope and lifecycle effect. | DD-03 §§7.1, 7.4; DISP-OR01-005 |
| RFI-DIS-L029 | A conflict record shall preserve each original position, options considered, technical rationale, decision authority, dissent, successor versions and review impact. | Append-only attributable decision/history chain. | DD-03 §§7.2–7.3, 9; OR03-D06/D11 |
| RFI-DIS-L030 | Conflict closure shall not autonomously close, advance or otherwise change the parent RFI lifecycle. | Separate conflict closure and parent transition evidence. | DD-03 §§7.3–7.4, 10; DISP-OR01-014 |

### E. Technical leadership, dissent and assurance boundary

| Leaf ID | Atomic requirement | Control / evidence expected | Candidate source / dependency |
|---|---|---|---|
| RFI-DIS-L031 | The technical lead shall coordinate contributions, interfaces and consolidation only within evidenced competence, appointment and delegation. | Current scoped appointment and action evidence. | DD-03 §8; OR03-D03 |
| RFI-DIS-L032 | The technical lead shall not infer authority to determine discipline scope, appoint/reassign contributors, approve another discipline, waive required work, confirm readiness or formally issue. | Action-level authority checks and explicit deny cases. | DD-03 §8.2; OR03-D03/D08 |
| RFI-DIS-L033 | Escalation shall identify the decision required and intended authority but shall not itself transfer authority or cure a missing appointment. | Escalation record and recipient authority verification. | DD-03 §8.3; OR03-D05 |
| RFI-DIS-L034 | Material dissent and qualified positions shall remain attributable to their author, discipline, assignment, exact version and supporting evidence. | Preserved source position and lineage. | DD-03 §9; OR03-D06/D11 |
| RFI-DIS-L035 | A decision contrary to a discipline position shall record the selecting authority, appointment scope, rationale, alternatives, impacts and treatment of dissent. | Reasoned override record; no silent overwrite. | DD-03 §9; OR03-D05/D06 |
| RFI-DIS-L036 | Majority support, silence, late response, read receipt or administrative completion shall not be treated as technical concurrence. | Explicit negative control and audit trail. | DD-03 §§2, 7, 9; OR03-D04/D06 |
| RFI-DIS-L037 | Technical conflict disposition shall remain separate from independent-review trigger, reviewer appointment, review clearance, readiness confirmation and formal issue. | Separate records, authorities and exact-version gates. | DD-03 §10; DD-04; OR03-D08–D10 |
| RFI-DIS-L038 | Changes to discipline scope, contributions, assumptions, evidence or technical conclusions shall trigger a documented impact assessment of affected consolidation, review and readiness dependencies. | Change-impact record and targeted/full review decision by competent authorities. | DD-03 §§4, 7, 10; OR03-D10 |
| RFI-DIS-L039 | External owner/client/designer/engineer-of-record/statutory or contractual concurrence shall be required only where an applicable validated governing instrument expressly requires it. | Exact instrument, authority and version-bound external decision evidence. | DD-03 §12; OR03-D12 |
| RFI-DIS-L040 | A technical contribution, conflict decision or external concurrence record shall remain subject to separate approved evidence-access, records-retention and legal-hold controls. | DD-08/DD-14 mapping and access/custody evidence. | DD-03 §§10–12; DEC-109; DD-08/DD-14 |

## 3. Coverage and unresolved matters

The 40 leaves provide candidate atomic coverage across discipline scope, five discipline codes, assignment lineage, contribution accountability, interface review, conflict classification/disposition, bounded technical leadership, dissent, independent-review separation, change impact and external authority boundaries.

The following remain explicitly open and must not be supplied by developer defaults:

1. Actual appointing authorities, named appointments, competence records, delegations, effective periods and revocation.
2. Project-approved discipline taxonomy, subdiscipline breakdown and mandatory contribution fields.
3. Objective C0–C4 classification examples, materiality/risk criteria and scoped blocking thresholds.
4. Project-specific conflict authority, reserved matters and external escalation route.
5. Discipline-approved checklists and technical acceptance criteria.
6. Exact representation of dissent in the issued response versus retained controlled evidence.
7. Permitted function combinations and any approved exception under DD-04.
8. Applicable external/contractual instruments and required concurrence.
9. Records classification, retention, legal hold and disposition rules.
10. QA-approved expected results, fixtures, test owners and evidence requirements.

## 4. DD-15 candidate mapping instructions

- Map each leaf only to an exact controlled AT-RFI/E2E source definition where the scenario genuinely exercises the requirement.
- Do not invent test IDs or claim that the existing repository test inventory covers these RFI requirements.
- Mark a leaf Uncovered when no existing scenario genuinely tests it; do not force a mapping.
- Separate policy/authority evidence from product-behavior tests. An appointment instrument or specialist finding is not a passed software test.
- Add positive, negative, boundary, concurrency and failure assertions only after the responsible authority approves expected behavior.
- Keep candidate mapping, test design, execution and pass status separate.
- No test execution or pass is claimed by this document.

## 5. Governance and implementation boundary

This document does not amend DEC-104/105/110, promote OR03-D01–D12 beyond their conditional recorded scope, appoint a technical lead or discipline responder, grant capabilities, approve a risk matrix, set engineering acceptance criteria, or authorize workflow implementation. It does not authorize API/UI/code, DB/schema/migrations/generated types, Storage, auth/RLS/grants, production-data operations, real notifications, live tests, backup/restore, merge or deployment.

Any later implementation or execution requires exact-version owner and specialist approval, resolved DD-02 authority evidence, QA-approved acceptance criteria, security/records/architecture review, an approved isolated environment and a separate explicit implementation/test authorization.

**Current disposition:** 40 candidate leaves prepared for traceability. OR03-D01–D12 remain conditionally approved within their recorded scopes; specialist validation and project-specific instruments remain pending. No test execution, pass, formal DD-03 closeout or implementation authorization is claimed.
