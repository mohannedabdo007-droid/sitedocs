# RFI-DD-03 — Discipline Responsibility, Technical Leadership and Conflict Governance

**Status:** WORKING DRAFT — CONSOLIDATED CANDIDATE FOR OWNER / SPECIALIST REVIEW — NOT APPROVED FOR IMPLEMENTATION  
**Date:** 2026-11-12  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent specification:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md` §9  
**Unified DD-01/DD-02 dependency:** `docs/110_RFI_DD01_DD02_UNIFIED_LIFECYCLE_AND_AUTHORITY_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Owner review route:** OR-03 in `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Decision register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Specialist evidence:** `docs/104_OR01_SPECIALIST_VALIDATION_AND_EVIDENCE_MATRIX_WORKING_DRAFT.md`

> This document refines the existing DD-03 candidate material for owner and specialist review. It does not decide OR-03, approve the independent-review risk matrix (DD-04), appoint any person, grant a capability, or authorize workflow implementation or test execution.

## 1. Purpose and boundaries

DD-03 defines how an RFI question is decomposed into discipline responsibilities, how each discipline produces an accountable technical contribution, how the technical lead coordinates a consolidated response, and how disagreements, dissent and escalation are controlled.

It must preserve:
- DEC-104/105/110 and all applicable conditional owner dispositions;
- the administrative-only boundary of the RFI coordinator;
- technical authority and assignment decisions only through evidenced appointments/delegations;
- independently attributable discipline contributions and immutable predecessor versions;
- no majority-vote technical authority, no silence-as-concurrence and no silent overwrite;
- material unresolved conflict blocks the affected response content from issue;
- formal independent review remains a separate DD-04 gate governed by an approved/versioned risk-authority matrix;
- exact-version readiness, issue/closure and post-issue controls defined by DD-01 and later owner dispositions.

DD-03 does not define the complete parent lifecycle, capability identifiers, final appointment schema, technical standards, discipline-specific engineering acceptance criteria, risk matrix, formal issue mechanics, Transmittal rules or records-retention schedule.

## 2. Core governance principles

1. **Discipline accountability is explicit:** each required contribution has a defined discipline, bounded scope, accountable contributor, current assignment, required evidence and version.
2. **Technical responsibility is not generic:** one discipline cannot be treated as competent to approve another discipline's professional judgement merely because it coordinates the response.
3. **The technical lead coordinates, not absorbs:** the lead manages interfaces and consolidation within an evidenced appointment; the lead does not become the author or approver of every discipline conclusion by default.
4. **The coordinator is administrative:** the RFI coordinator routes and tracks records only within explicit delegation and cannot determine technical scope, settle engineering conflicts or declare technical concurrence.
5. **Conflict is a first-class record:** disagreement is captured, classified, scoped, assigned to an authorized decision path and preserved with its source evidence.
6. **No majority vote:** number of disciplines or contributors supporting a position is not a substitute for competence, delegated authority, governing design responsibility or project approval rules.
7. **No silence-as-concurrence:** no response, late response, read receipt, viewed file, assignment acceptance or administrative completion means technical agreement.
8. **No silent override:** a technical decision that selects a direction despite dissent must preserve the dissent and record the authority and rationale.
9. **Authority is evidence-bound:** the decision maker must be appointed for the project, party, RFI, subject/discipline and decision type; titles and availability do not establish authority.
10. **Issue is blocked when necessary:** material unresolved conflict, missing required contribution or unresolved technical dependency prevents the affected response from passing the applicable readiness/issue gate.
11. **History is append-only in meaning:** corrections and new technical positions create attributable versions/events; they do not rewrite prior contribution or decision history.
12. **Independent review remains separate:** a technical lead or conflict-resolution authority does not waive a mandatory independent-review trigger.

## 3. Responsibility and accountability model

### 3.1 Responsibility functions

| Function | Candidate responsibility | Authority boundary |
|---|---|---|
| Originator / originating party | State the engineering question, provide source information and respond to clarification requests | Does not select internal technical conclusions or appoint reviewers |
| Appointing / project governance authority | Establish appointments, delegations, project discipline scope and escalation authority | Must rely on an approved governance instrument; this document appoints nobody |
| Technical authority | Determine required discipline scope, appoint/delegate technical decision authority, resolve scope/competence disputes and decide matters reserved to the project technical authority | Acts only within evidenced project/party/subject/RFI authority |
| Assignment authority | Establish, change or remove required discipline assignments within explicit delegation | Must preserve old/new scope and assignment history |
| Discipline authority / discipline lead | Validate discipline responsibility, competence and technical position where project rules require it | A discipline lead title alone does not prove appointment or approval authority |
| Discipline responder | Produce an attributable technical contribution for the accepted assignment and scope | Cannot approve another discipline's contribution or issue the consolidated answer |
| Technical lead | Plan technical work, coordinate interfaces, monitor completeness, preserve positions, prepare consolidated candidate and resolve only conflicts within explicit authority | Cannot erase dissent, waive required contributions, expand scope or exceed competence/delegation |
| Conflict-resolution authority | Decide a conflict reserved to a higher technical authority within explicit scope and competence | Escalation recipient must have valid appointment; escalation alone grants no authority |
| Independent reviewer | Review exact candidate/version where required under DD-04 | Does not inherit authorship, consolidation or issue authority |
| Readiness authority | Confirm the exact candidate/package meets readiness conditions under DD-01 | Does not issue the response |
| Technical issuer | Formally issue the exact response after all gates pass | Cannot bypass missing contribution, unresolved material conflict or mandatory review |
| Coordinator / Document Control | Administrative routing, record completeness checks, controlled distribution after authorized issue | Cannot decide technical materiality, discipline scope, conflict outcome, readiness or issue |

### 3.2 RACI-like responsibility distinctions

The following are decision-function distinctions, not a final project RACI and not a grant matrix.

| Activity | Responsible work | Decision / approval authority | Administrative support | Required evidence |
|---|---|---|---|---|
| Determine required disciplines | Technical authority / delegated assignment authority | Same appointed authority | Coordinator may record and route | Scope rationale, project/party/RFI context |
| Define discipline assignment | Assignment authority and discipline authority as applicable | Appointed assignment authority | Coordinator records assignment | Discipline, scope, contributor, effective period |
| Produce contribution | Assigned discipline responder | Discipline authority only where project rules require validation | Coordinator tracks status | Signed/attributed version, evidence, assumptions, limitations |
| Coordinate interfaces | Technical lead and relevant discipline responders | Technical lead within appointment; otherwise technical authority | Coordinator tracks actions | Interface register, dependencies and decisions |
| Classify conflict | Technical lead with affected disciplines | Appointed conflict authority for materiality/disposition where required | Coordinator records only | Conflict record, affected scope, versions |
| Resolve conflict | Competent appointed technical decision maker | Authority specified by delegation and project governance | Coordinator communicates/records | Decision rationale, basis, scope, dissent |
| Consolidate response | Technical lead | Technical authority where lead's mandate is exceeded | Document Control prepares controlled record only after authorization | Candidate version and source map |
| Independent review | Appointed independent reviewer | Review authority under approved risk matrix | QA/Document Control supports | Exact-version review record |
| Readiness and issue | Separately appointed readiness authority and issuer | Each within own appointment | System/DC records authorized actions | Readiness record, issue record and package manifest |

## 4. Discipline scope and assignment model

### 4.1 Required discipline determination

The required discipline set is determined from the actual engineering question, project scope, interfaces, approved project discipline taxonomy and technical authority's appointment. It must not be inferred solely from:
- keywords in the RFI subject or description;
- a discipline's historical participation;
- available staff or convenience;
- who first opened or viewed the RFI;
- coordinator preference;
- an assumed default discipline set.

A required-discipline decision should record:
1. RFI identity and response-cycle identity;
2. engineering question and affected project scope;
3. each required discipline and reason for inclusion;
4. disciplines considered but not required and reason, where material;
5. cross-discipline interfaces/dependencies;
6. appointing/decision authority and evidence;
7. assignment scope, accountable contributor and effective period;
8. whether discipline authority validation or secondary review is required;
9. date/version and any later scope change.

### 4.2 Assignment lifecycle boundaries

Assignment labels and transition rules remain subject to detailed design. The following are candidate distinctions only:
- proposed / awaiting acceptance;
- assigned / accepted;
- in progress;
- clarification or additional information required;
- contribution submitted;
- changes requested;
- complete / technically confirmed;
- reassigned / superseded / cancelled.

An assignment's administrative state is not equivalent to technical contribution completeness. A contributor accepting an assignment does not mean the technical work is complete. A contribution being uploaded does not mean it is technically confirmed. A coordinator marking a routing task complete cannot close the discipline's technical obligation.

### 4.3 Assignment change and reassignment

Any addition, removal, transfer or material scope change must:
- be authorized by the appointed assignment/technical authority;
- state the reason and effective scope;
- preserve the prior assignment and contribution lineage;
- identify the status of work already performed;
- assess whether existing contribution versions remain valid;
- identify affected interfaces and downstream review/readiness consequences;
- be checked against current parent stage and concurrency guards.

A reassignment must not silently transfer authorship or accountability for a predecessor's technical judgement. A successor contributor must explicitly adopt, validate or replace the relevant technical position through an attributable action.

## 5. Discipline contribution contract

### 5.1 Minimum contribution record

Each required discipline contribution should contain, as applicable:

| Field | Required meaning |
|---|---|
| RFI and response-cycle identity | Exact parent and active cycle |
| Discipline / subdiscipline | Controlled project taxonomy |
| Assignment reference and version | Exact authorized scope and assignment |
| Contributor identity | Person accountable for the submitted position |
| Authority / competence reference | Appointment or validation evidence where required |
| Engineering question addressed | Explicit mapping to the question or sub-question |
| Technical response | Clear answer, recommendation or finding |
| Basis and references | Applicable drawings, specifications, standards, calculations and evidence |
| Assumptions and exclusions | Limits on the conclusion |
| Interfaces and dependencies | Other disciplines, inputs or decisions relied upon |
| Impacts | Safety, quality, constructability, sequence, cost, programme or operations where relevant |
| Position | Agreement, qualified agreement, disagreement, no position or further information required |
| Open matters | Clarifications, unresolved risks, dependencies and conditions |
| Version and timestamp | Immutable attributable contribution version |
| Change summary | What changed from predecessor and why |

The project must decide which fields are mandatory by RFI class and discipline. Blank or ambiguous fields must not be interpreted as agreement or completion.

### 5.2 Contribution completeness vs technical confirmation

These concepts must remain separate:

- **Submitted:** contributor has provided a version.
- **Administratively complete:** required record fields and evidence references are present.
- **Technically assessed:** a competent reviewer/discipline authority has assessed it where required.
- **Technically confirmed:** the authorized confirmation condition is met for the assignment.
- **Accepted for consolidation:** the contribution may be used as a current input to the consolidated candidate.
- **Superseded:** a later version replaces it for current work while preserving history.

These are candidate semantic distinctions, not final child-state labels. Their exact owner, authority and transition criteria must be agreed with discipline authorities and reconciled with DISP-OR01-006 and DD-01.

A required contribution cannot be treated as optional merely because it is late, difficult to obtain or administratively inconvenient. Any removal from required scope must be a separately authorized and evidenced scope change.

## 6. Discipline interface and completeness checks

### 6.1 Common interface checks

Every contribution should identify, where relevant:
- upstream information and source version relied upon;
- downstream disciplines affected;
- assumptions shared with other disciplines;
- physical, spatial, functional and operational interfaces;
- conflicts between drawings, specifications, calculations or site conditions;
- sequence, access, maintainability and constructability impacts;
- safety, quality and regulatory/authority dependencies;
- unresolved inputs or approvals;
- whether the conclusion remains valid if another discipline's assumption changes.

### 6.2 Candidate discipline interface prompts

The prompts below are illustrative review aids only. They are not engineering design criteria, mandatory checklists or a substitute for project standards.

| Discipline | Candidate interface prompts |
|---|---|
| Architectural (ARC) | Space planning, dimensions, levels, finishes, access/egress, envelope, openings, coordination with structural and building services, accessibility and functional requirements |
| Civil / Structural (CIV) | Site levels, grading, drainage interfaces, foundations, structural loads/supports, penetrations/openings, temporary/permanent works interfaces, utilities and geotechnical dependencies |
| Mechanical (MEC) | Plant/equipment space, loads, routes, sleeves/penetrations, ventilation, drainage, controls, power dependencies, access and maintainability |
| Electrical (ELE) | Power demand/supply, distribution routes, containment, equipment clearances, earthing/bonding, controls/interfaces, emergency systems and coordination with mechanical/civil/architectural works |
| Survey (SURVE) | Coordinate/reference system, control points, benchmarks, datum, setting-out tolerances, existing-condition verification, as-built evidence and interface with civil/structural/architectural locations |

The project must validate its discipline taxonomy and any subdiscipline split. This table does not authorize a discipline to approve another discipline's design.

### 6.3 Interface issue register

A cross-discipline interface issue should record:
- unique reference;
- originating and affected disciplines;
- exact contribution versions involved;
- interface description and impact;
- assumptions and references;
- responsible action owner;
- required technical decision authority;
- status and resolution evidence;
- whether the issue constitutes a material conflict;
- whether it affects parent progression, a contribution only, review or readiness.

An interface issue does not automatically become a parent clarification blocker. Its lifecycle effect must be explicitly classified under DD-01 and DISP-OR01-005.

## 7. Conflict governance

### 7.1 Candidate conflict classes

The following C0–C4 classes preserve the existing docs/72 proposal. They remain candidate labels; classification criteria, materiality thresholds, blocking scope and authority must be validated before adoption.

| Class | Candidate meaning | Candidate handling | Issue/readiness effect |
|---|---|---|---|
| C0 — Compatible inputs | Contributions address different aspects or are technically compatible | Technical lead records synthesis and source attribution | No conflict block, subject to all other gates |
| C1 — Interface / assumption clarification | Apparent inconsistency may be explained by differing assumptions, boundaries or reference versions | Targeted clarification to affected contributors; preserve original positions | Affected content held only if needed to establish technical correctness |
| C2 — Material technical disagreement | Incompatible technical recommendations, design basis or execution outcome | Record all positions/evidence; refer to competent appointed conflict authority | Affected response content blocked until authorized disposition |
| C3 — Authority / scope dispute | Proposed decision exceeds lead's competence/delegation or crosses project/contract authority | Hold and escalate to designated technical authority; no coordinator tie-break | Block affected decision and any dependent readiness/issue gate |
| C4 — External / unresolved dependency | Decision depends on originator, designer, owner, client, authority or unavailable project information | Use the correct clarification, linked RFI or external decision route under governing rules | Block affected content or parent progression only where valid dependency is recorded |

C1–C4 are not severity rankings. A higher class number does not itself imply greater safety or commercial severity. Classification must describe the nature of the issue, while risk/materiality is assessed under the applicable technical and project risk framework.

### 7.2 Conflict record minimum

Each conflict record should capture:
1. conflict ID and date;
2. parent RFI, response cycle and affected question;
3. originating and affected disciplines;
4. exact contribution, candidate and evidence versions;
5. each discipline's original position, basis and assumptions;
6. conflict class and reason;
7. materiality assessment and affected scope;
8. whether it blocks a contribution, parent progression, candidate, review or issue;
9. responsible technical lead and conflict authority evidence;
10. options considered and technical impacts;
11. decision, rationale, governing requirements and authority basis;
12. dissenting or qualified positions and response to them;
13. successor contribution/candidate versions;
14. review/re-review impact;
15. event history, communications and closure evidence.

### 7.3 Conflict disposition sequence

1. **Identify:** any participant may raise a potential conflict within their permitted access and scope. Raising a concern does not grant decision authority.
2. **Preserve:** retain the exact source contributions, versions, evidence and prior positions.
3. **Scope:** identify affected disciplines, work, interfaces and candidate content.
4. **Classify:** distinguish factual/assumption clarification, material technical disagreement, authority dispute and external dependency.
5. **Assess:** appointed technical lead evaluates within competence and appointment; materiality and blocking scope are explicitly recorded.
6. **Resolve or escalate:** lead resolves only within explicit delegation. Otherwise refer to the appointed conflict-resolution authority or project governance route.
7. **Hear affected disciplines:** provide a controlled opportunity to explain, correct factual errors or submit a revised contribution without overwriting predecessor evidence.
8. **Decide:** authorized decision maker records the chosen direction, technical basis, alternatives, impacts, scope and authority.
9. **Preserve dissent:** record any material contrary opinion and how it was considered.
10. **Version:** update the consolidated candidate through a new attributable version; assess review/readiness impact.
11. **Verify gates:** confirm no unresolved material blocker remains before readiness or issue.
12. **Close the conflict record:** only when disposition evidence and required follow-up are complete; conflict closure does not autonomously close the parent RFI.

### 7.4 Blocking rules

- An unresolved C2 material technical disagreement blocks the affected consolidated answer until an authorized disposition is recorded.
- A C3 authority/scope dispute blocks the affected decision until competent authority and scope are evidenced.
- A C4 external dependency blocks only the work or parent progression that genuinely depends on the missing external input, under the applicable clarification gate.
- A C1 interface clarification is not automatically a parent-level blocker; its effect depends on a reasoned technical dependency and affected scope.
- C0 does not waive any required contribution, review, readiness, evidence or authority gate.
- Where materiality or blocking scope is uncertain, hold the affected gate and refer to the designated technical authority. Do not default to “no conflict.”
- A conflict that is resolved within consolidation may remain Under Consolidation if no new discipline analysis, scope change or dependent technical work is required.
- Where resolution requires new or materially revised discipline analysis, apply DISP-OR01-007 and return only affected work, preserving unaffected contributions.
- No conflict status alone changes the parent lifecycle; parent transitions follow DD-01 guards.

## 8. Technical lead mandate and decision boundaries

### 8.1 Candidate mandate

The appointed technical lead may, within evidenced competence and delegation:
- plan and coordinate required technical contributions;
- identify missing inputs and cross-discipline interfaces;
- request clarification or further explanation from contributors;
- assess whether a disagreement can be resolved within the existing technical mandate;
- synthesize compatible positions with traceable attribution;
- recommend or authorize a scoped return from consolidation where DISP-OR01-007 permits and appointment covers it;
- prepare a consolidated response candidate;
- identify independent-review and readiness dependencies for action by the appointed authorities.

### 8.2 Explicit limits

The technical lead may not, unless separately and expressly appointed for the relevant action:
- determine or change required discipline scope;
- appoint or reassign contributors;
- approve another discipline's professional conclusion;
- waive a required contribution or project technical standard;
- decide a conflict beyond the lead's competence/delegation;
- remove or rewrite dissent;
- declare silence or non-response as concurrence;
- waive mandatory independent review;
- confirm readiness or formally issue merely by virtue of being technical lead;
- change a closed/issued response outside the post-issue governance route.

### 8.3 Higher authority and escalation

The project must identify, by approved appointment/delegation:
- who appoints the technical lead;
- who determines discipline scope and required assignments;
- who resolves cross-discipline conflicts beyond the lead's mandate;
- which matters are reserved to owner/client/designer/engineer-of-record or external authority;
- how absence, conflict of interest, unavailability or disputed appointment is handled;
- how acting appointments and revocation take effect.

Escalation must identify the decision required and intended recipient. It does not silently transfer authority. If the proper authority is unknown, unavailable or disputed, the affected decision remains on hold.

## 9. Dissent, qualification and authorized override

1. Every material dissent or qualification must remain attributable to its author, discipline, assignment and exact version.
2. A consolidated response may summarize a position but must preserve a traceable source link and material qualification.
3. No majority vote or numerical consensus is a technical disposition.
4. No-response, late response, read receipt or administrative status cannot be treated as concurrence.
5. If an authorized decision maker selects a direction contrary to a discipline position, the record must preserve:
   - the original position and supporting evidence;
   - the selected direction and technical rationale;
   - the decision maker's appointment/delegation;
   - affected scope and disciplines;
   - alternatives considered and consequences;
   - how the dissent was addressed or why it remains unresolved;
   - any residual risk, condition or required follow-up.
6. A dissenting opinion does not automatically veto all work. Its effect is determined by technical materiality, governing authority and whether it leaves a required technical question unresolved.
7. If dissent exposes a material unresolved safety, compliance, design-basis or interface issue, the affected content remains blocked pending competent disposition.
8. The dissent record is not removed when a conflict is closed, response issued or a new cycle opened.

## 10. Relationship to DD-01, DD-02 and DD-04

| Dependency | DD-03 rule | Required cross-reference |
|---|---|---|
| Parent lifecycle | Conflict does not autonomously change parent stage | DD-01 and DISP-OR01-014 |
| Required contribution gate | Incomplete required work prevents formal consolidation/readiness | DISP-OR01-006 |
| Clarification | Parent blocker vs contribution-only blocker remains distinct | DISP-OR01-005 |
| Return from consolidation | New discipline analysis triggers bounded return; preserve unaffected work | DISP-OR01-007 |
| Authority | Decision and execution functions require current scoped appointment | DD-02 / DISP-OR01-004 |
| Independent review | Conflict disposition does not replace matrix-triggered exact-version review | DD-04 / DISP-OR01-008 |
| Readiness and issue | No material unresolved conflict passes readiness/issue; issue and closure atomic | DISP-OR01-009/010 |
| Withdrawal/cancellation/reopening | Conflict history is preserved and does not create a separate terminal outcome | DISP-OR01-011–014 |
| Communication/records | Transmittal, acknowledgement and archive are separate from technical disposition | DEC-103/108/109 |

## 11. Open decisions requiring owner and specialist disposition

| ID | Open decision | Required authority / evidence | Interim control |
|---|---|---|---|
| DD03-01 | Who appoints technical lead, discipline responders and discipline leads; effective period, acting appointment and revocation | Owner, appointing/project governance, technical authority | No appointment inferred |
| DD03-02 | Exact technical subjects, RFI classes, disciplines and thresholds within technical lead delegation | Owner, technical authority and discipline authorities | Lead cannot decide beyond explicit scope |
| DD03-03 | Conflict taxonomy, materiality and blocking criteria | Owner, discipline authorities, technical/risk authority, QA | Material unresolved conflict blocks affected issue content |
| DD03-04 | Higher-level conflict authority and external escalation route | Owner, project/contract authority, technical governance | Hold where authority is absent or disputed |
| DD03-05 | Discipline-specific contribution fields and interface checklists | Discipline authorities, technical lead, QA | Blank/ambiguous input is not concurrence |
| DD03-06 | Dissent representation in response, evidence package and records | Owner, technical authority, Document Control, records | Preserve source position and rationale |
| DD03-07 | Rules for combining technical lead, discipline lead, contributor, reviewer, readiness and issuer functions | Project governance, technical/risk authority, security, QA | No function combination inferred |
| DD03-08 | Conflict record owner, closure authority and correction/supersession history | Process owner, technical authority, records, architecture | Preserve append-only decision history |
| DD03-09 | Which conflict decisions require independent review or re-review | Risk/quality authority and DD-04 matrix owner | Apply DD-04; no invented trigger threshold |
| DD03-10 | Discipline scope changes, late contributions and predecessor contribution revalidation | Technical authority, discipline authorities, architecture, QA | Hold stale or ambiguous scope/version |
| DD03-11 | Which matters require owner/client/designer/engineer-of-record or authority concurrence | Project/contract governance and competent technical authorities | Do not infer external concurrence requirement or waiver |
| DD03-12 | Conflict examples and objective calibration across ARC/CIV/MEC/ELE/SURVE | Discipline authorities and project technical authority | Candidate examples only; no discipline sign-off claimed |

## 12. Specialist review package

| Reviewer domain | Questions to answer | Required evidence |
|---|---|---|
| Project/process owner | Are responsibility boundaries, conflict outcomes and escalation consistent with project governance? | Exact-version disposition and authority instrument references |
| Appointing/project governance authority | Who appoints technical lead, discipline leads, responders and higher conflict authority? | Approved appointment/delegation instruments and scope |
| Technical authority | Which decisions may be delegated to technical lead? Which conflicts are reserved? | Subject/discipline/RFI decision matrix and examples |
| Discipline authorities (ARC/CIV/MEC/ELE/SURVE as applicable) | Are contribution fields, interface prompts, completeness and dissent controls technically adequate? | Discipline-specific checklist review and representative cases |
| Document Control | Can records preserve source contributions, successor versions, dissent and formal issue lineage? | Records workflow and package lineage review |
| Architecture/data | Can conflict, contribution, assignment and candidate identities remain distinct and version-linked? | Logical record/transition review; no schema change implied |
| Security/privacy | Are conflict visibility, decision actions and evidence access restricted by project/party/discipline/scope? | Positive/negative authorization review |
| QA/independent assurance | Are blocking criteria and review/re-review triggers objectively verifiable? | Acceptance criteria and negative test design |
| Records | Are conflict decisions, dissent and predecessor versions retained under approved schedule? | Records classification and retention review |
| Contract/project governance | Which external decisions or concurrences are required by actual approved project instruments? | Specific clause/authority reference; no inferred legal effect |

No specialist review is evidenced by this document. Each review must be recorded by reviewer identity, competence/appointment where applicable, exact version and section, finding, rationale, condition, dissent and evidence reference in the designated review register.

## 13. Candidate acceptance criteria for DD-03

- [ ] Discipline scope is determined by an evidenced technical authority and linked to the engineering question.
- [ ] Each required assignment has a named accountable contributor, scope, effective period and appointment evidence.
- [ ] Contribution completeness is distinct from submission and administrative completeness.
- [ ] Discipline-specific fields and interface checklists are validated by competent discipline authorities.
- [ ] Technical lead mandate and limits are explicit, evidenced and bounded by competence.
- [ ] Conflict taxonomy and materiality/blocking criteria are approved by competent authorities.
- [ ] Conflict disposition records preserve each position, evidence, authority, rationale, impact and dissent.
- [ ] No majority vote, silence, coordinator action or title substitutes for technical authority.
- [ ] Scoped return and contribution versioning align with DISP-OR01-006/007.
- [ ] Independent-review and re-review triggers remain aligned with DD-04.
- [ ] Function combination and separation-of-duties controls are explicitly reviewed.
- [ ] Parent, cycle and child records remain semantically distinct and no child event autonomously changes parent stage.
- [ ] Security, architecture, QA and records findings are evidenced and reconciled.
- [ ] Owner disposition is recorded for OR-03 against the exact final revision.

## 14. Promotion and implementation boundary

This is a working draft for review only. Before promotion:
1. complete owner OR-03 disposition;
2. obtain specialist validation from relevant disciplines and authority domains;
3. reconcile DD-03 with DD-01/DD-02, DD-04 and DISP-OR01-005–010;
4. resolve all blocking open decisions or record explicit owner-approved constraints;
5. update the decision register and specialist evidence matrix only from attributable evidence;
6. perform a fresh cross-specification review of the exact revised files.

No final RACI, appointment, capability, grant, workflow, UI/API/code, database/schema/migration/generated type, Storage, authentication, authorization/RLS, production-data operation, test execution, backup/restore, merge, deployment or release is authorized by this document.

---

**End of DD-03 working draft — candidate responsibility and conflict framework only; OR-03 and specialist validation remain pending.**
