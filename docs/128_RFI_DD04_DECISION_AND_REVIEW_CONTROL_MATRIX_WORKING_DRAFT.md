# RFI-DD-04 — Decision and Review Control Matrix

**Document type:** Detailed decision/control matrix — working draft  
**Date:** 2026-11-12  
**Status:** CANDIDATE FOR OWNER / SPECIALIST REVIEW — NO APPROVED PROJECT RISK MATRIX OR REVIEWER APPOINTMENTS EVIDENCED  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent specification:** `docs/127_RFI_DD04_INDEPENDENT_REVIEW_AND_SEPARATION_OF_DUTIES_SPEC_WORKING_DRAFT.md`  
**Originating design:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md` §10  
**Owner decisions:** OR03-D08, OR03-D09 and OR03-D10  
**Specialist coordination:** `docs/125_OR03_SPECIALIST_VALIDATION_AND_EVIDENCE_MATRIX_WORKING_DRAFT.md`  
**Cross-specification desk review:** `docs/126_DD03_DD04_DD14_CROSS_SPECIFICATION_CONSISTENCY_REVIEW_WORKING_DRAFT.md`

> **Status and authority warning:** This is a decision-design aid, not an approved delegation schedule, risk matrix, role/permission matrix, workflow specification or operational appointment. Role labels below identify the kind of authority that must be evidenced; they do not name or appoint a person. No numerical threshold, mandatory trigger, reviewer count, SLA or role-combination exception is created here.

## 1. Purpose

This matrix converts the DD-04 candidate framework into auditable decision points. For every control it identifies:
- the question that must be answered;
- the authority category that must be evidenced;
- minimum input and decision evidence;
- permitted candidate outcomes;
- fail-closed behavior and the scope of any hold;
- the relationship to downstream review and parent RFI controls.

It is intended to expose missing authority and evidence before any implementation proposal is prepared.

## 2. Reading rules

1. “Competent authority” always means the authority identified by an applicable approved project instrument and supported by current appointment/delegation evidence for the exact project, subject and action.
2. “Owner” means the project/process owner who must confirm the governance design; the title alone does not confer technical, appointment or issue authority.
3. “Appointing authority” means only the office/person expressly empowered by the approved instrument to appoint or revoke a reviewer.
4. “Technical authority” and “discipline authority” are limited to their evidenced competence, scope and delegation.
5. “Coordinator” and “Document Control” perform administrative controls only unless a separate, evidenced authority exists for a specific action.
6. All outcomes and status words in this matrix are proposed design vocabulary, not approved system enums.
7. A missing, stale, contradictory or ambiguous prerequisite is recorded as **Pending Authority Decision** or **Blocked — Pending Prerequisite**; it is never silently treated as “Not Required”.
8. A hold applies to the affected review/response scope and its evidenced dependencies, not automatically to unrelated work or the entire project.

## 3. Decision matrix

| ID | Decision point / question | Required authority category | Minimum inputs and evidence | Candidate outcome / record | Fail-closed rule and effect |
|---|---|---|---|---|---|
| DM-01 | Which risk-and-authority instrument governs this RFI? | Project governance / instrument custodian; owner confirms governance source | Instrument ID, controlled version, approval record, effective dates, scope and supersession history | Applicable instrument identified, or Pending Authority Decision | No draft, informal email or historical practice treated as approved instrument |
| DM-02 | Does the instrument apply to this project, contract, RFI class, subject and response cycle? | Authority named by the instrument | Project/contract context, RFI subject, scope, discipline/interfaces, effective date and applicability clauses | Applicable / Not Applicable / Pending Authority Decision, with rationale | If applicability is ambiguous or conflicting, hold trigger determination for affected scope |
| DM-03 | Does the approved instrument require independent review for this exact response scope? | Trigger decision authority explicitly named in the instrument | Exact instrument clauses, evidence mapped to criteria, exact response scope and assessor appointment/delegation | Mandatory / Not Required / Pending Authority Decision | No universal or invented threshold; no default Not Required; if potentially mandatory and unresolved, block affected issue gate |
| DM-04 | What review scope is required? | Technical/risk authority named by the instrument, with affected discipline input | Question, disciplines, interfaces, assumptions, response sections, evidence manifest, criteria and exclusions | Defined review scope, boundaries and rationale | Undefined or unsupported scope cannot be assigned as a valid review |
| DM-05 | Who may appoint the reviewer? | Appointing authority expressly named by approved instrument | Appointment authority reference, delegation, project scope and current validity | Appointment decision with attributable identity/time | Coordinator, roster admin, technical lead or reviewer cannot self-appoint absent express authority |
| DM-06 | Is the proposed reviewer competent for this subject and scope? | Appointing authority; relevant discipline/technical authority validates competence | Identity, qualifications/experience or equivalent competence evidence, subject relevance, scope and currency | Competence confirmed / insufficient / pending | Job title, seniority, availability, membership or past participation is not proof |
| DM-07 | Is the reviewer independent of the exact work being reviewed? | Appointing authority under approved independence rules; quality/assurance validation where required | Authorship, contribution, consolidation, technical decision, conflict-of-interest declaration, prior involvement and applicable separation rules | Independent / disqualified / pending assessment | Self-review prohibited where applicable approved rule requires separation; no relabelling to cure it |
| DM-08 | Is a conflict of interest present and how is it handled? | Competent authority specified by instrument; security/privacy or compliance input where relevant | Declaration, identified interest, relationship to subject/parties, risk assessment and mitigation/recusal decision | No conflict / managed under approved control / disqualified / pending | No self-clearance by reviewer; unresolved conflict prevents assignment or continuation |
| DM-09 | Is a role-combination exception permitted? | Only the exception authority expressly identified by approved instrument | Express permission, case-specific necessity, risk assessment, residual risk, controls, scope, duration and traceable approval | Exception approved for stated scope / denied / pending | No implied or default exception; silence or resource shortage does not authorize combination |
| DM-10 | Is the review package complete, frozen and exact-version bound? | Document/evidence custodian under approved controls; reviewer confirms receipt of defined package | Response version, cycle ID, manifest, evidence/file version IDs, integrity references, applicable instrument and scope | Package bound and review may start / unable to start | Missing, corrupt, mutable-only or mismatched evidence blocks valid review outcome |
| DM-11 | May the reviewer access the package and each evidence item? | Authorized access-control authority under approved project security rules; system enforces | Reviewer identity, current appointment, project/party/discipline scope, record/file/version, action and purpose | Access permitted/denied with audit event | Review assignment does not itself grant access; each request must be authorized server-side |
| DM-12 | Has the appointed reviewer completed a valid review of the exact package and scope? | Appointed reviewer within exact appointment and review scope | Exact package, criteria, review work, findings, limitations, dependencies and evidence | A review outcome from docs/127 §9.3, excluding trigger-only outcomes; reasons and version binding required | Reviewer cannot issue/close RFI or decide matters outside mandate; silence is not clearance; trigger determination remains DM-03 |
| DM-13 | Who resolves a finding or technical conflict? | Affected discipline authority, bounded technical lead or appointed conflict authority according to DD-03 and OR03-D04/D05 | Attributed finding, affected discipline input, conflict classification, authority/delegation and technical evidence | Accepted response / revised contribution / conflict decision / escalation | Reviewer cannot silently replace discipline authority or waive unresolved material conflict |
| DM-14 | Are findings resolved sufficiently for review clearance? | Reviewer determines adequacy of response within review scope; technical/discipline authorities own technical response | Finding ID, response, updated contribution/evidence versions, rationale and dissent disposition | Finding resolved / remains open / escalated, tied to exact version | Blocking finding remains open until evidenced disposition; no silent deletion or inferred concurrence |
| DM-15 | Has a change affected the previously reviewed version? | Change-impact authority expressly identified by approved governance; affected technical/discipline authorities provide input | Predecessor/successor versions, change description, affected scope/evidence/assumptions/interfaces/findings and dependency analysis | Impact assessment complete / pending | Any potentially relevant change is captured; uncertain materiality or dependency holds affected clearance |
| DM-16 | Given the documented impact assessment, what review scope is required and does the approved instrument require independent re-review? | Competent technical authority determines materiality/affected scope under evidenced delegation; the separately named trigger authority applies the approved matrix where independent-review applicability must be reassessed; affected disciplines and QA contribute as required | DM-15 impact assessment; approved matrix/version and relevant clauses; bounded affected scope; dependency map; separate authority evidence and rationale for each determination | Scope: targeted / full / no further review where permitted. Trigger: Mandatory / Not Required / Pending Authority Decision, recorded separately | Do not merge materiality assessment with matrix trigger authority; no arbitrary “minor” exemption; unresolved authority, dependency or trigger holds affected clearance |
| DM-17 | Does prior clearance remain usable for any unchanged scope? | Competent authority under approved instrument; reviewer/QA input as required | Exact predecessor clearance, successor change map, unaffected-scope rationale and matrix permission | Limited reliance for named scope/version / re-review / pending | No blanket carry-forward; prior clearance remains historical for its original exact version |
| DM-18 | May a reviewer be substituted, suspended or reinstated? | Appointing authority named by instrument | Reason, old/new appointment, effective time, competence, independence, handover and prior work history | Substitute / suspend / revoke / reinstate with evidence | No inherited appointment or clearance; prior work and partial findings remain preserved |
| DM-19 | Is the review record closed and retained correctly? | Records authority under approved records schedule; process owner owns record completeness | Trigger decision, instrument, appointments, package, findings, responses, outcome, changes, access/audit history and records classification | Review record complete / incomplete / blocked for records prerequisite | Review closure does not close RFI; no invented retention period, legal hold or deletion authority |
| DM-20 | Can review be treated as a satisfied parent RFI gate? | Parent lifecycle transition authority under approved DD-01 and owner decisions | Valid trigger decision, valid reviewer appointment, exact-version review outcome, finding disposition and all parent guards | Parent gate satisfied / not satisfied / pending | Review event does not autonomously change parent state, issue or close RFI |

### 3.1 Separation of trigger decisions, review outcomes and change-impact decisions

DM-03 is the only matrix row that determines whether independent review is Mandatory, Not Required or Pending Authority Decision for the assessed scope. “Not Applicable / Not Required” in docs/127 §9.3 is a trigger determination, not a completed review outcome; it must not be recorded as a reviewer finding or clearance. DM-12 records only an outcome of a review actually performed. A change-impact assessment under DM-15 identifies and scopes the change; DM-16 then records (a) the competent technical authority’s materiality/scope determination and (b), separately, the approved-instrument trigger authority’s decision whether independent re-review is required. The authority for one determination must not be inferred from the other.

## 4. Minimum decision-record template

Each decision record should contain the following fields, subject to owner and architecture review:

| Field | Required value |
|---|---|
| Decision ID | DM-01 through DM-20 |
| RFI identity | Official parent RFI ID and active response-cycle ID |
| Decision subject | Exact response candidate/version and bounded scope |
| Governing instrument | ID, version, approval evidence, effective status |
| Decision question | The exact question being decided |
| Decision authority | Attributable identity/office, appointment/delegation and scope evidence |
| Inputs | Evidence references and versions relied upon |
| Decision | Candidate outcome and explicit scope |
| Rationale | Criteria, facts, assumptions and limitations |
| Conditions | Required action, owner authority category and evidence needed |
| Blockers | Missing, ambiguous, conflicting or expired prerequisites |
| Dissent | Attributed dissent/qualified position and treatment |
| Time | Decision timestamp and instrument effective date |
| Supersession | Predecessor decision and successor link, if any |
| Audit lineage | Event IDs and immutable references under approved design |

This is a candidate content contract. It does not prescribe a database schema or authorize creation of fields in a live system.

## 5. Candidate outcome and blocking map

| Situation | Candidate state | Review/issue effect |
|---|---|---|
| Applicable approved matrix expressly requires review | Mandatory | Review gate required |
| Applicable approved matrix expressly supports no review and authorized basis is recorded | Not Required | No review record is implied; other RFI gates remain |
| Matrix absent, draft, stale, contradictory or scope unclear | Pending Authority Decision | Hold affected review determination and issue gate where review could be mandatory |
| Reviewer competence/appointment not evidenced | Blocked — Pending Prerequisite | No valid assignment or clearance |
| Reviewer independence/conflict unresolved | Blocked — Pending Prerequisite | No valid review start/continuation |
| Review package/version/integrity invalid | Unable to Complete / Blocked | No clearance |
| Blocking finding unresolved | Changes Required / Conflict Escalated | Affected review gate remains open |
| Change impact not assessed | Pending Impact Assessment | Prior clearance cannot be relied upon for changed scope |
| Targeted/full scope not justified | Pending Authority Decision | Affected clearance held |
| Review complete for exact version with no blocking findings | Reviewed — No Blocking Comment (candidate) | May satisfy only the review gate; no automatic issue/closure |
| Reviewer substitution without fresh authority/independence checks | Blocked — Pending Prerequisite | No inherited appointment or clearance |

## 6. Authority and separation crosswalk

| Decision / action | Authority source required | Functions that must not be inferred |
|---|---|---|
| Matrix approval | Approved project governance | Owner title alone; developer; coordinator |
| Trigger determination | Authority expressly named by matrix | Reviewer; coordinator; Document Control |
| Reviewer appointment | Appointing authority named by matrix | Reviewer self-appointment; roster admin |
| Competence validation | Relevant discipline/technical authority and appointing authority | HR title alone; seniority |
| Independence/conflict assessment | Appointing authority under approved rules, with required assurance input | Reviewer self-clearance |
| Technical finding response | Responsible discipline authority / bounded technical lead | Document Control; reviewer outside mandate |
| Conflict resolution | Appointed competent conflict authority under DD-03 | Majority vote; silence; coordinator |
| Review outcome | Appointed independent reviewer within scope | Technical issuer; project manager without appointment |
| Change impact/re-review scope | Authority named by approved instrument | Developer; coordinator; arbitrary “minor” label |
| Parent transition/readiness/issue | Separate approved RFI authorities and guards | Reviewer by virtue of review role |

## 7. Open authority and evidence register

No values are pre-filled as if approved. Each item requires attributable evidence.

| ID | Missing input / unresolved decision | Evidence required before promotion | Status |
|---|---|---|---|
| OPEN-01 | Approved matrix and custodian | Controlled approved copy, approval authority, version history and applicability | Pending |
| OPEN-02 | Trigger criteria and thresholds | Explicit project-approved criteria and evidence rules | Pending |
| OPEN-03 | Trigger decision authority | Appointment/delegation, project scope and permitted action | Pending |
| OPEN-04 | Reviewer competence criteria | Approved profile/standard and reviewer-specific evidence | Pending |
| OPEN-05 | Independence and conflict rules | Approved separation rules, declaration and assessment route | Pending |
| OPEN-06 | Exception authority and safeguards | Express approved permission and case-specific controls, if any | Pending |
| OPEN-07 | Finding/outcome vocabulary | Owner-approved definitions, blocking meaning and disposition authority | Pending |
| OPEN-08 | Change materiality and re-review criteria | Project-approved criteria, dependency assessment and authority | Pending |
| OPEN-09 | Review package/integrity architecture | DD-08 validated manifest, version and integrity design | Pending |
| OPEN-10 | Access and confidentiality model | Security/privacy-approved authorization and audit design | Pending |
| OPEN-11 | Records classification and lifecycle | DD-14 records authority, schedule, hold and disposition rules | Pending |
| OPEN-12 | Test acceptance ownership | Imported actual test scenarios, expected results, evidence and authorized acceptance | Pending |

## 8. Decision traceability to owner dispositions and specifications

| Matrix rows | Source / controlling rule | Required preservation |
|---|---|---|
| DM-01–DM-04 | OR03-D09; DEC-105; docs/127 §§5–6 | Approved matrix only; no inferred threshold or authority |
| DM-05–DM-09 | OR03-D01/D08/D09; docs/127 §7 | Appointment, competence, independence and role separation evidence |
| DM-10–DM-11 | DEC-107; DD-08 docs/76; docs/127 §8 | Exact-version evidence and per-operation authorization |
| DM-12–DM-14 | OR03-D02–D06; DD-03 docs/111; docs/127 §9 | Discipline accountability, dissent and conflict authority |
| DM-15–DM-17 | OR03-D10; docs/127 §10 | Impact assessment and no silent clearance carry-forward |
| DM-18 | OR03-D01/D08; docs/127 §11 | Appointment evidence and preserved history |
| DM-19 | OR03-D11; DEC-109; DD-14 docs/82 | Records lifecycle remains separately authorized |
| DM-20 | DEC-106; OR03-D09/D10; DD-01 docs/72 | Review is subordinate; parent guards remain authoritative |
| Test coverage | DD-15 docs/83; DEC-110 | Negative tests, exact permissions, evidence and acceptance traceability |

## 9. Specialist review questions

Reviewers should answer each question against the exact document version and cite evidence:

1. Does every decision have one clearly identified authority source, without implying that a job title or administrative role grants authority?
2. Are trigger determination and reviewer appointment separate where the approved governance requires it?
3. Are competence, independence and conflict-of-interest tests sufficiently objective to be evidenced, without inventing thresholds?
4. Does the matrix prevent a reviewer from approving their own work or overriding discipline accountability?
5. Are review outcomes and blocking effects unambiguous and scoped?
6. Does the change-impact path prevent silent reuse of old clearance while avoiding automatic full restart when targeted review is justified?
7. Are package/version binding and server-side access controls consistent with DD-08?
8. Are review records, dissent and decision history consistent with DD-14 and DEC-109?
9. Are all negative cases mapped to actual DD-15 test definitions and acceptance evidence?
10. Are any additional project/contract/legal authority requirements missing?

## 10. Acceptance and promotion gates

This matrix may be promoted only when:
- the owner confirms the exact matrix version and its intended use;
- the approved risk-and-authority instrument and its applicability are evidenced;
- all authority categories are mapped to real, current appointments/delegations by competent project governance (this document itself makes no appointments);
- project trigger criteria and Not Required rules are explicit;
- reviewer competence, independence, conflict and exception controls are validated;
- outcome, findings and change-impact criteria are confirmed;
- DD-08 evidence/access design and DD-14 records lifecycle are reconciled;
- actual DD-15 scenario definitions and acceptance ownership are imported and mapped;
- all specialist findings, dissent, conditions and blockers are dispositioned;
- a fresh cross-specification review is performed against the exact revised documents.

A completed desk matrix or passing document-integrity check is not owner approval, specialist validation, test execution or implementation authorization.

## 11. Implementation boundary

This matrix does not authorize:
- project matrix approval or reviewer appointment;
- assignment, role grants, capabilities or permission changes;
- workflow/status/transition implementation;
- UI/API/code, database/schema/migration/generated types, Storage, authentication or authorization/RLS changes;
- production-data access or modification;
- test execution or a claim of test pass;
- backup/restore, merge, deployment or release.

Any implementation or test proposal requires a separate scoped plan, resolved prerequisites, exact approvals, evidenced authority, approved non-production environment and synthetic data, and explicit owner authorization. DB/Storage work additionally requires verified backup, isolated restore/rehearsal and reconciliation before change.

---

**End of DD-04 Decision and Review Control Matrix — candidate governance aid only; all project-specific authorities, matrix criteria and specialist validations remain pending.**
