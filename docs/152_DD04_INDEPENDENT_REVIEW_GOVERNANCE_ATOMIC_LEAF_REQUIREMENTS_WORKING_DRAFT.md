# DD-04 — Independent Review and Separation of Duties: Atomic Leaf Requirements

**Document type:** Governance traceability decomposition — working draft  
**Date:** 2026-11-13  
**Status:** WORKING DRAFT — CANDIDATE LEAVES — NO APPROVED PROJECT RISK MATRIX OR REVIEWER APPOINTMENTS EVIDENCED — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent specification:** `docs/127_RFI_DD04_INDEPENDENT_REVIEW_AND_SEPARATION_OF_DUTIES_SPEC_WORKING_DRAFT.md`  
**Decision matrix:** `docs/128_RFI_DD04_DECISION_AND_REVIEW_CONTROL_MATRIX_WORKING_DRAFT.md`  
**Cross-specification review:** `docs/129_DD04_DECISION_MATRIX_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md`  
**Cross-specification dependencies:** `docs/126_DD03_DD04_DD14_CROSS_SPECIFICATION_CONSISTENCY_REVIEW_WORKING_DRAFT.md`  
**Owner boundary:** OR03-D08/D09/D10; specialist validation coordination in `docs/125`

> These leaves decompose DD-04 candidate controls. They do not approve a project risk-and-authority matrix, define universal review triggers or thresholds, appoint reviewers, grant permissions, approve role-combination exceptions or authorize implementation/testing. All project-specific instruments and reviewer evidence remain pending.

## 1. Decomposition rules

1. Trigger determination, review execution, technical finding disposition, readiness and formal issue are separate decisions.
2. DM-01–DM-20 are decision-control identifiers, not test IDs or system enums.
3. A missing or ambiguous instrument/appointment is not equivalent to “Not Required”.
4. A hold is scoped to the affected review/response and evidenced dependencies; unrelated work is not automatically blocked.
5. Exact response/evidence version binding is mandatory for any future valid review record.
6. Candidate leaves require QA/domain-owner validation against exact source scenarios and approved expected-result authority.

## 2. Atomic leaf requirements

### A. Governing instrument and applicability

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-REV-L001 | Each review-trigger determination shall identify the exact approved, versioned risk-and-authority instrument relied upon. | Instrument ID, version, approval, custodian and controlled source. | DD-04 §5; DM-01; DEP-01 |
| RFI-REV-L002 | The instrument's effective dates, supersession history and applicability to project/contract/RFI class/subject shall be checked before use. | Applicability record and rationale. | DD-04 §5; DM-02 |
| RFI-REV-L003 | The authority making the trigger determination shall be identified by the applicable instrument and supported by current appointment/delegation evidence. | Action-specific authority evidence. | DM-03; DEP-02 |
| RFI-REV-L004 | Trigger outcomes shall distinguish Mandatory, Not Required and Pending Authority Decision; absence of evidence shall not default to Not Required. | Exact trigger decision, evidence and scoped hold. | DD-04 §4; DM-03 |
| RFI-REV-L005 | Trigger determination shall remain distinct from a review outcome; Not Applicable/Not Required shall not be recorded as a completed review. | Separate trigger and review records. | docs/129 X-01; DM-12 |

### B. Review scope, package and evidence binding

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-REV-L006 | A required review shall define the exact technical scope, disciplines, interfaces, assumptions, exclusions and criteria within the authority of the governing instrument. | Scope statement and authority rationale. | DD-04 §4; DM-04 |
| RFI-REV-L007 | The review subject shall be bound to the exact response candidate/version and active response-cycle identity. | Immutable version references. | DD-04 §§4, 7; DM-10 |
| RFI-REV-L008 | The review package shall identify the exact evidence and attachment versions and integrity/manifest references actually reviewed. | Frozen manifest and evidence lineage. | DD-04; DD-08; DM-10 |
| RFI-REV-L009 | Missing, corrupt, mutable-only or mismatched review evidence shall prevent a valid review outcome for the affected scope. | Fail-closed package-integrity record. | DD-04; DM-10; DD-08 |
| RFI-REV-L010 | Reviewer assignment shall not itself grant access to the response or any evidence item; each resource/action request shall be independently authorized. | Per-operation server-side authorization and audit. | DM-11; DD-02; DD-08 |

### C. Reviewer appointment, competence and independence

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-REV-L011 | Reviewer appointment shall be made only by the appointing authority expressly identified in the approved governing instrument. | Appointment decision and authority reference. | DM-05; OR03-D08/D09 |
| RFI-REV-L012 | Reviewer competence shall be evidenced for the exact subject, discipline, technical scope and review type. | Competence evidence validated by authorized appointing route. | DM-06 |
| RFI-REV-L013 | Reviewer independence shall be assessed against authorship, contribution, consolidation, technical decision involvement and applicable separation rules. | Independence assessment and prior-involvement evidence. | DM-07; OR03-D08 |
| RFI-REV-L014 | Conflict-of-interest declarations and any recusal/mitigation decision shall be recorded by an authority other than the reviewer self-clearing their own conflict. | Declaration, assessment, decision and audit trail. | DM-08 |
| RFI-REV-L015 | Role-combination exceptions shall be permitted only where an approved instrument expressly authorizes the exception and the competent authority records scope, necessity, controls, duration and residual risk. | Explicit exception approval; otherwise deny/hold. | DM-09; OR03-D08 |
| RFI-REV-L016 | Reviewer substitution shall preserve predecessor appointment, work performed, findings, access history and the reason/effective scope of replacement. | Attributable substitution and continuity record. | DD-04 reviewer continuity controls; DM-05–09 |

### D. Review conduct, findings and clearance

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-REV-L017 | A reviewer shall assess only the exact package, scope and criteria covered by their current appointment. | Scope-bound review record. | DD-04 §§4, 8; DM-12 |
| RFI-REV-L018 | Each review finding shall identify its author, exact reviewed version, affected scope, evidence and required disposition. | Attributable finding record. | DD-04 review record; DM-12–14 |
| RFI-REV-L019 | Technical response to a finding shall remain owned by the competent discipline/technical authority, not silently transferred to the reviewer. | Source discipline response and authority record. | DD-03; DM-13 |
| RFI-REV-L020 | A finding shall remain open until its disposition is evidenced and the reviewer records the outcome within their review mandate. | Finding status, response, rationale and exact version. | DM-14 |
| RFI-REV-L021 | Review clearance shall apply only to the exact response/evidence version and scope recorded in the review result. | Version-bound clearance record. | DD-04 §§7–9; OR03-D10 |
| RFI-REV-L022 | Silence, meeting attendance, read receipt, elapsed time or administrative completion shall not constitute review clearance. | Negative-case evidence and explicit outcome. | DD-04; DM-12; DEC-110 |

### E. Change impact, re-review and separation from lifecycle

| Leaf ID | Atomic requirement | Control / evidence expected | Source / dependency |
|---|---|---|---|
| RFI-REV-L023 | A change to reviewed response content, assumptions, discipline contributions, evidence or interfaces shall be captured with exact predecessor/successor references before prior clearance is relied upon. | Change event and version comparison. | OR03-D10; DM-15 |
| RFI-REV-L024 | Technical materiality and affected-scope determination shall be made by the competent technical authority separately from the approved-instrument re-review trigger decision. | Two separately attributable determinations. | docs/129 X-02; DM-16 |
| RFI-REV-L025 | Mandatory re-review trigger shall be determined only by the authority named in the applicable approved instrument. | Instrument clause and trigger authority evidence. | OR03-D09/D10; DM-16 |
| RFI-REV-L026 | Targeted or full re-review scope shall be reasoned from affected content, dependencies and applicable approved requirements; prior clearance shall not transfer automatically. | Re-review scope and rationale. | DD-04; DM-17 |
| RFI-REV-L027 | Review completion shall not itself confirm readiness, formally issue the response or change the parent RFI lifecycle. | Separate readiness/issue/parent transition records. | DD-01; DD-04; DM-18–20 |
| RFI-REV-L028 | Review records, findings, evidence and access events shall remain subject to separately approved records, retention, legal-hold and disposition controls. | DD-08/DD-14 records and custody mapping. | docs/126 CRX-04/05; DEC-109 |

## 3. Cross-specification findings and dependencies

The DD-04 desk review in docs/129 found no direct normative contradiction in its exact reviewed source set after two clarifications: (a) trigger determinations are distinct from actual review outcomes; and (b) technical materiality/affected-scope assessment is distinct from the approved-instrument authority's re-review trigger decision. This is documentary consistency only, not specialist sign-off.

Open dependencies include:
- DEP-01: actual approved/versioned risk-and-authority matrix;
- DEP-02: trigger decision authority and appointment evidence;
- DEP-03: reviewer appointment, competence and independence evidence;
- DEP-04: project materiality/dependency criteria;
- DEP-05: package-freeze/custody responsibility;
- DEP-06: approved access-control policy;
- DEP-07: records schedule and legal/contract hold authority;
- DEP-08: actual source scenario definitions and expected-result validation;
- DEP-09: specialist validation evidence.

These dependencies remain pending. A leaf cannot be promoted merely because a related document exists.

## 4. DD-15 candidate mapping instructions

- Preserve DM-01–DM-20 as decision-matrix identifiers; do not create test IDs from them.
- Map only to exact AT-RFI/E2E definitions that exercise the control.
- Mark process/appointment evidence requirements as governance evidence where no product scenario exists.
- Keep uncovered and blocked requirements visible.
- Obtain QA, security, records, architecture and domain-owner validation of expected outcomes, fixtures and evidence before execution.
- No test execution or pass is claimed.

## 5. Explicit exclusions

No project risk matrix, trigger threshold, reviewer, appointment, role combination, capability, access grant, workflow enum, SLA, retention period or legal effect is approved. No API/UI/code, DB/schema/migration/generated type, Storage, auth/RLS/grant, production-data, live test, backup/restore, merge or deployment activity is authorized.

**Current disposition:** 28 candidate leaves prepared. All project instruments, authority appointments, reviewer evidence, specialist validation and QA expected-result approval remain pending. No DD-04 formal closeout, test execution/pass or implementation authorization is claimed.
