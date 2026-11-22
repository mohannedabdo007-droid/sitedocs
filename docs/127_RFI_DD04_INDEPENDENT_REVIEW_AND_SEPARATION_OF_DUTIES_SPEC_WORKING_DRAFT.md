# RFI-DD-04 — Independent Review and Separation of Duties Specification

**Document type:** Consolidated detailed specification — working draft  
**Date:** 2026-11-12  
**Status:** CANDIDATE FOR OWNER / SPECIALIST REVIEW — RISK MATRIX NOT APPROVED — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent source:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md` §10  
**DD-03 dependency:** `docs/111_RFI_DD03_DISCIPLINE_RESPONSIBILITY_TECHNICAL_LEADERSHIP_AND_CONFLICT_GOVERNANCE_WORKING_DRAFT.md`  
**Owner decision:** OR03-D09 — `docs/121_OR03_D09_INDEPENDENT_REVIEW_TRIGGER_BOUNDARY_OWNER_DISPOSITION_WORKING_DRAFT.md`  
**Change-impact decision:** OR03-D10 — `docs/122_OR03_D10_REVIEW_IMPACT_AND_REASSESSMENT_AFTER_CHANGES_OWNER_DISPOSITION_WORKING_DRAFT.md`  
**Cross-specification review:** `docs/126_DD03_DD04_DD14_CROSS_SPECIFICATION_CONSISTENCY_REVIEW_WORKING_DRAFT.md`  
**DD-04 decision-matrix consistency review:** `docs/129_DD04_DECISION_MATRIX_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md`  
**Decision and review control matrix:** `docs/128_RFI_DD04_DECISION_AND_REVIEW_CONTROL_MATRIX_WORKING_DRAFT.md`  
**Specialist validation coordination:** `docs/125_OR03_SPECIALIST_VALIDATION_AND_EVIDENCE_MATRIX_WORKING_DRAFT.md`  
**Protected governance:** DEC-103–DEC-110; OR03-D01–D12 within their recorded conditional scopes

> **Critical status statement:** This document defines a review-control framework and the information a future approved project risk-and-authority matrix must supply. It does not approve that matrix, establish universal mandatory triggers or thresholds, appoint reviewers, approve role-combination exceptions, or authorize implementation or test execution.

## 1. Purpose and intended outcome

DD-04 defines how an RFI response is assessed for independent technical review, how a valid review is assigned and performed, how independence and conflicts of interest are checked, how findings are dispositioned, and how any change to reviewed material affects prior clearance.

Independent review is a controlled assurance function. It is:
- separate from discipline contribution and discipline confirmation;
- separate from technical-lead coordination and consolidation;
- separate from technical conflict resolution;
- separate from readiness confirmation and formal issue;
- separate from Document Control distribution, recipient access and acknowledgement;
- bound to an exact response candidate/version and the exact evidence reviewed.

Independent review is not a universal second signature, a substitute for competent discipline work, an automatic consequence of every disagreement, or a transfer of formal issue authority.

## 2. Controlling decisions and interpretation rules

This specification must preserve the following:

1. **DEC-105:** independent review is risk/authority governed; reviewer and issuer functions remain distinct where separation applies.
2. **DEC-110:** authorization, negative tests, evidence, concurrency and acceptance must be demonstrable; unresolved behavior is blocked rather than assumed.
3. **OR03-D08:** functions are distinct; self-review is prohibited where the applicable approved matrix/governance requires separation; role combinations are not automatic.
4. **OR03-D09:** mandatory independent review exists only where an approved, versioned project risk-and-authority matrix or expressly applicable approved governance instrument defines the trigger and competent decision authority.
5. A discipline disagreement alone does not automatically create an independent-review requirement. Conflict resolution cannot waive a review required by the approved instrument.
6. **OR03-D10:** a change potentially affecting the reviewed result requires a documented impact assessment; targeted or full re-review is based on evidenced impact, dependencies and applicable approved requirements. Prior clearance never silently transfers.
7. **DD-03:** material unresolved conflict and authority disputes retain their own scoped blocking rules. Independent review does not erase dissent or cure missing authority.
8. **DD-08:** review evidence and supporting files are exact-version-bound, integrity-protected and independently authorized for access.
9. **DD-14 / DEC-109:** review records are subject to a separately approved records classification, retention and legal-hold regime; no retention duration or deletion authority is created here.
10. **DEC-108:** review completion is not external delivery, acknowledgement or substantive recipient response.

Where this specification and an approved project instrument appear inconsistent, the conflict must be referred to the competent owner/project governance authority. No developer or coordinator may resolve it by selecting a convenient default.

## 3. Scope and exclusions

### 3.1 In scope

- determining whether the approved instrument requires independent review;
- recording the instrument, version, applicability and authorized trigger decision;
- defining the exact review scope and package;
- reviewer competence, appointment, independence and conflict-of-interest evidence;
- reviewer substitution and continuity of the audit trail;
- review findings, response and clearance outcomes;
- change-impact assessment and targeted/full re-review determination;
- exact-version evidence binding, access boundaries and records lineage;
- negative authorization, failure and acceptance requirements.

### 3.2 Out of scope

This document does not:
- create or approve a project risk-and-authority matrix;
- set risk scores, mandatory trigger thresholds, cost/schedule/safety limits or universal risk classes;
- appoint any person or organization;
- create project role grants, capabilities, permission bundles or delegated authorities;
- decide engineering conflicts or override discipline conclusions;
- approve readiness, formally issue an RFI response or close an RFI;
- establish SLA, review turnaround time, escalation cadence or deemed approval;
- establish statutory, contractual, regulatory or legal effects;
- set records classification, retention periods, legal-hold triggers or destruction methods;
- authorize UI/API/code, database/schema/migrations/generated types, Storage, authentication, authorization/RLS, production-data operations, test execution, backup/restore, merge, deployment or release.

## 4. Review control model

The candidate control sequence is:

1. **Identify applicable governing instrument.** Locate the approved, versioned project risk-and-authority matrix or other expressly applicable approved instrument.
2. **Verify applicability.** Confirm project, contract/governance context, RFI class, subject, discipline, scope and effective date/version.
3. **Determine trigger.** The authority named by that instrument determines whether review is Mandatory, Not Required, or Pending Authority Decision (candidate decision vocabulary).
4. **Freeze the review subject.** Identify the exact response candidate/version, scope, contributions and evidence manifest/version references.
5. **Appoint and verify reviewer.** Confirm current appointment, competence, independence, permitted scope and absence of disqualifying conflict.
6. **Conduct review.** Assess only within the appointed technical scope and applicable review criteria.
7. **Record findings.** Attribute every comment, condition, limitation, decision and evidence reference to its author and exact reviewed version.
8. **Disposition findings.** The responsible technical/discipline authorities address technical content; the reviewer records whether the review gate is satisfied for the exact version within their appointment.
9. **Assess changes.** Any potentially relevant change receives a documented impact assessment before prior clearance can be relied upon.
10. **Close the review record.** Record the final outcome, exact scope/version, unresolved matters, reviewer authority evidence and event history. Review closure does not itself issue or close the parent RFI.

No step may be skipped because of schedule pressure, coordinator convenience, a read receipt, a meeting minute, silence or an administrative status.

## 5. Approved risk-and-authority instrument contract

### 5.1 Mandatory attributes of the instrument

Before operational use, the applicable instrument must identify, at minimum:

- unique instrument identifier and controlled version;
- approving authority and approval evidence;
- owner/custodian and controlled publication location;
- project, contract, RFI class and subject applicability;
- effective-from and, where applicable, effective-to dates;
- trigger criteria and the evidence needed to assess each criterion;
- authority competent to determine applicability and trigger outcome;
- required review type, discipline/interface scope and expected independence boundary;
- reviewer competence and appointment requirements or a controlled reference to them;
- required review outputs and clearance conditions;
- applicable separation-of-duties and conflict-of-interest rules;
- change/re-review requirements or a controlled reference to them;
- precedence, interpretation and escalation route;
- supersession history and treatment of RFIs already in progress.

A title, file name, informal email, unapproved draft, historical practice or generic organization chart is not proof of an approved instrument.

### 5.2 Applicability decision record

For each RFI review determination, preserve:

| Field | Required content |
|---|---|
| RFI / response cycle | Stable parent RFI and cycle identity |
| Instrument | ID, exact version, approval reference and effective status |
| Applicability | Project, contract/governance scope, RFI class, subject and rationale |
| Assessed scope | Relevant question, disciplines, work/interfaces and response candidate |
| Decision | Mandatory / Not Required / Pending Authority Decision — proposed labels |
| Decision authority | Named individual/office, appointment/delegation evidence and scope |
| Basis | Applicable clauses/criteria and attributable supporting evidence |
| Limitations | Exclusions, dependencies, uncertainty and unresolved assumptions |
| Time | Decision timestamp and relevant effective date/time |
| Reassessment | Triggering changes and successor determination, if any |

The matrix may determine that review is not required only when the instrument expressly supports that result and an authorized assessor records the basis. Absence of a matrix, missing criterion or unknown risk is not a Not Required decision.

### 5.3 Blank matrix structure — no thresholds supplied

| Matrix field | Project-approved value / reference |
|---|---|
| Project / contract / RFI class applicability | Pending authority definition |
| Risk / assurance dimensions considered | Pending authority definition |
| Trigger criterion and evidence | Pending authority definition |
| Mandatory / not-required determination rule | Pending authority definition |
| Decision authority and delegation | Pending appointment evidence |
| Review scope and reviewer discipline/competence | Pending authority definition |
| Independence / conflict restrictions | Pending authority definition |
| Required outcome and blocking effect | Pending authority definition |
| Re-review/change-impact rule | Pending authority definition |
| Approval/version/effective date | Pending controlled instrument |

The following are candidate assessment dimensions only, not self-executing triggers: safety and life safety; statutory/authority compliance; design-basis or specification departure; permanent works/structural consequence; multi-discipline interfaces; uncertainty or novel solutions; quality concessions; external dependencies; cost/schedule/scope consequence; conflict/dissent; and material change or reopening. Only the approved instrument may convert any dimension into a mandatory trigger and define its threshold, scope and authority.

## 6. Trigger determination and fail-closed behavior

### 6.1 Decision outcomes

The following are proposed decision labels, not approved system enums:

- **Mandatory:** applicable approved instrument expressly requires independent review and an authorized assessor records the trigger basis.
- **Not Required:** the applicable approved instrument expressly supports no independent review for the assessed scope and an authorized assessor records the basis.
- **Pending Authority Decision:** instrument absent, stale, unapproved, inapplicable, contradictory or ambiguous; trigger criteria or decision authority unavailable; or relevant evidence insufficient.

### 6.2 Mandatory control

Where status is Pending Authority Decision:
- the affected response scope cannot pass the independent-review gate;
- Ready for Issue must remain blocked for the affected response where the unresolved determination could require review;
- no technical lead, coordinator, developer or reviewer may invent a substitute threshold or assume Not Required;
- the issue must be referred to the competent, evidenced project authority;
- the unresolved dependency and its impact must remain visible in the record.

A pending decision does not automatically block unrelated work or the whole project. The hold is scoped to the affected response and its actual dependencies, consistent with DD-03 and OR03-D04/D05.

### 6.3 Trigger re-evaluation

Reassess applicability where a relevant event occurs, including:
- changed project/contract governance or instrument version;
- changed RFI question, scope, discipline/interface or governing assumption;
- new or materially changed evidence or technical conclusion;
- conflict disposition or escalation that changes the reviewed technical basis;
- response reopening or successor cycle;
- reviewer/authority appointment or competence status change;
- a newly identified dependency or compliance condition.

This list identifies reassessment events; it does not independently make review mandatory. The applicable approved instrument controls the resulting decision.

## 7. Reviewer competence, appointment and independence

### 7.1 Appointment evidence

Before review begins, the record must establish:
- identity of the reviewer and appointing authority;
- appointment reference, effective period and current status;
- project, RFI class, discipline, subject and technical scope;
- competence evidence relevant to the exact subject and risk/specialty;
- any required professional qualification, experience or authorization;
- permitted review actions and limits;
- conflict-of-interest declaration and assessment;
- any applicable confidentiality/access conditions;
- substitution or revocation conditions.

No competence or authority is inferred from job title, seniority, membership, availability, prior participation, email distribution, system role or past review.

### 7.2 Independence assessment

Assess and record actual involvement in the exact subject/version, including whether the proposed reviewer:
- authored a relevant discipline contribution or response text;
- materially consolidated or determined the response;
- made or approved the substantive technical decision being reviewed;
- resolved the conflict whose disposition is under review;
- approved the same design/evidence in another capacity in a way that creates self-review;
- has a declared or identified personal, commercial or organizational conflict;
- is subject to an applicable separation rule in the approved instrument.

A person who authored the response, materially consolidated it or made the substantive technical decision under review must not independently review that same response version where the approved instrument requires independence. Changing job title, appointment label or workflow role after the work does not cure self-review.

### 7.3 Role boundaries

| Function | Permitted responsibility | Not implied |
|---|---|---|
| Discipline contributor | Provide attributable discipline input and evidence | Independent review or issue authority |
| Discipline authority | Confirm discipline position within appointment/scope | Cross-discipline override |
| Technical lead | Coordinate and consolidate within evidenced mandate | Independent clearance merely by being lead |
| Conflict decision authority | Decide conflict within evidenced authority | Independent review unless separately appointed and independent |
| Independent reviewer | Review exact frozen candidate within appointment | Formal issue, RFI closure or appointment of others |
| Readiness authority | Confirm readiness under applicable gate | Independent review unless separately appointed |
| Technical issuer | Formally issue exact authorized response | Review clearance by virtue of issue authority |
| Coordinator / Document Control | Administrative routing, recordkeeping and controlled distribution | Technical trigger decision, reviewer appointment or review outcome |
| System / roster administrator | Administrative identity and system maintenance under approved controls | Project technical authority or appointment decision |

### 7.4 Role combinations and exceptions

No role combination is automatically permitted. Any exception to an applicable separation rule must:
- be expressly allowed by the approved governing instrument;
- be approved by the competent authority identified in that instrument;
- document the specific necessity and exact scope;
- include a conflict-of-interest and residual-risk assessment;
- specify independent compensating controls, if required;
- define effective period and revocation;
- preserve a traceable decision record.

This document creates no exception and no default dual-signature rule. Where the governing instrument is silent or ambiguous, do not infer an exception.

## 8. Review package and evidence binding

### 8.1 Exact review package

The review package must identify immutable or controlled references for:
- parent RFI and active response cycle;
- exact response candidate/version;
- question and scope reviewed;
- required discipline contributions and their versions;
- conflict records and dispositions relevant to the response;
- drawings, specifications, calculations, models, correspondence and other evidence actually relied upon;
- evidence/file version IDs and integrity references;
- applicable codes, standards, project requirements and approved instrument version;
- prior review records and open conditions;
- review scope, exclusions and assumptions.

A link to a mutable “latest” file is not sufficient evidence of what the reviewer actually reviewed.

### 8.2 Freeze and integrity

At the approved review-binding point:
- freeze or otherwise immutably identify the review package manifest;
- record exact version identifiers and integrity references;
- ensure the reviewer can access only the authorized package and scope;
- preserve the original package even if a successor is created;
- record manifest changes, integrity exceptions and access denials;
- fail closed if required evidence is missing, corrupt, mismatched or cannot be verified.

A digest proves neither authorship nor technical correctness nor approval. Integrity algorithm, verification cadence and key protection remain subject to DD-08 security/architecture review.

### 8.3 Access

Review access is authorized server-side for the individual, current appointment, project/party/discipline scope, exact record/file/version, action and purpose. A review assignment or link does not automatically grant access to unrelated RFI records, drafts, sibling attachments or later versions. Revocation and scope changes apply to subsequent requests.

## 9. Review conduct, findings and response

### 9.1 Review scope

The reviewer assesses the exact package against the criteria within their appointment and the applicable governing instrument. The reviewer must record scope limitations, assumptions, excluded material and dependencies that prevent a conclusion.

The reviewer does not silently expand their authority, replace a discipline authority, decide a contractual/legal matter outside mandate or issue the RFI response.

### 9.2 Finding record

Each finding should include:
- finding ID and review ID;
- exact candidate and evidence version reference;
- author/reviewer identity and appointment reference;
- affected discipline, requirement, drawing/calculation/evidence and response section;
- finding description, technical basis and consequence;
- classification under the applicable approved project vocabulary, if one exists;
- whether it blocks the reviewed scope and why;
- required response/action and competent owner;
- disposition, rationale and evidence of resolution;
- any dissent, limitation or unresolved dependency;
- date/time and event history.

No severity scale or finding taxonomy is created here. A project may define one through its approved instrument.

### 9.3 Candidate review outcomes

Proposed outcome labels, subject to owner and specialist approval:

- **Reviewed — No Blocking Comment:** the reviewer has completed the assigned review and records no blocking finding for the exact version and scope. This is not formal issue or general project acceptance.
- **Changes Required:** one or more findings require changes; review gate remains open.
- **Clarification Required:** defined information is required before the reviewer can conclude; gate remains open.
- **Conflict Escalated:** matter exceeds reviewer authority or exposes a material unresolved conflict; gate remains open for affected scope.
- **Unable to Complete:** access, evidence, competence, scope or other prerequisite prevents a valid review; gate remains open.
- **Pending Authority Decision:** trigger, appointment, independence, interpretation or authority remains unresolved; gate remains blocked.
- **Not Applicable / Not Required:** trigger decision only, not a completed review; may be recorded only when the approved matrix supports it and the authorized assessor records the basis.

A reviewer comment, acknowledgement, meeting attendance or no-response is not an outcome. No silence-as-concurrence or deemed approval is permitted.

### 9.4 Finding disposition

The responsible technical lead coordinates responses within mandate; affected discipline authorities confirm their own technical contributions; the authorized conflict authority resolves matters within appointment. The reviewer assesses whether the response to findings is adequate for the exact reviewed scope.

The reviewer may not erase dissent or approve an unresolved technical conflict beyond their mandate. Material conflict remains governed by DD-03 and OR03-D04/D05. A review outcome cannot waive a missing discipline contribution, project requirement or external approval.

## 10. Change impact and re-review

### 10.1 Change capture

Any change potentially affecting the reviewed result must be recorded against the exact previously reviewed version. Examples include changes to:
- response text, recommendation, design solution or conclusion;
- assumptions, design basis, calculations, loads, criteria or boundary conditions;
- discipline contribution or technical confirmation;
- material evidence, drawing, specification, model or referenced document;
- project scope, interface, sequence or external dependency;
- conflict classification, disposition, dissent treatment or authority decision;
- applicable code, standard, contract/project requirement or risk matrix;
- reviewer appointment, competence, independence or review scope.

This is a capture list, not a universal materiality threshold.

### 10.2 Impact assessment record

The competent, evidenced authority must record:
- predecessor and successor candidate/version IDs;
- change description and reason;
- affected response sections, disciplines, interfaces and evidence;
- assumptions/conclusions potentially affected;
- dependencies on previously reviewed or cleared content;
- impact on findings and prior conditions;
- applicable matrix/version and whether its trigger decision changes;
- targeted versus full re-review rationale;
- decision authority, appointment and evidence;
- reviewer assignment and exact scope, if re-review is required.

### 10.3 Targeted versus full re-review

Targeted re-review may be used only where the affected scope and dependencies can be bounded and the applicable approved instrument permits it. Full re-review is required where the evidenced impact, interdependencies or approved instrument requires full reassessment.

A change being described as “minor” or “administrative” is not sufficient. If materiality, dependencies, scope or authority is unclear, hold the affected clearance and refer it to the competent authority.

### 10.4 Prior clearance

Prior review findings and clearance remain immutable historical evidence for the exact version reviewed. They do not automatically transfer to a successor version. Any new clearance must identify:
- exact successor candidate/version;
- exact evidence manifest/version set;
- exact review scope;
- inherited findings/conditions and their disposition;
- reviewer appointment and independence evidence;
- new outcome and rationale.

A changed response may retain valid review of unaffected portions only if the approved instrument and documented impact assessment support that limited reliance. No blanket carry-forward is assumed.

## 11. Reviewer substitution, withdrawal and interruption

- A reviewer may be substituted only by the competent appointing authority under the applicable instrument.
- Record reason, effective time, predecessor and successor reviewer, scope handover and independence reassessment.
- Preserve all prior comments, access events, partial work and decisions.
- A replacement reviewer must independently satisfy competence, appointment, scope and conflict requirements.
- A reviewer may not transfer their personal review judgement or clearance to a substitute without an explicitly approved and evidenced process.
- If an appointment expires, is revoked, becomes conflicted or is found out of scope, suspend further review action and hold the affected outcome pending competent authority.
- Interruption, unavailability or failure does not create automatic clearance or deemed acceptance.

## 12. Review record, audit and records lifecycle

Preserve attributable events for:
- instrument identification, version and applicability assessment;
- trigger decision and authority evidence;
- reviewer nomination, appointment, substitution, expiry and revocation;
- competence and independence assessment;
- package freeze, manifest identity, evidence integrity and access;
- review start, scope changes, findings, comments and responses;
- change-impact assessment and re-review;
- outcome, conditions, dissent, escalation and closure;
- access denial, security incident and recovery where relevant.

The review record must preserve the exact package and decision lineage without unnecessary personal data. Review records, evidence, comments and appointment evidence are subject to DD-14 records classification and approved retention/hold controls. This specification sets no retention period, legal hold, archive tier or destruction method.

## 13. Failure, exception and escalation controls

The following conditions prevent a valid review outcome or clearance for the affected scope:
- no applicable approved instrument where a trigger decision is needed;
- ambiguous or contradictory trigger, scope or authority;
- expired, revoked, unverified or out-of-scope reviewer appointment;
- competence evidence insufficient for the assigned subject;
- disqualifying self-review or unresolved conflict of interest;
- missing, corrupt or unverifiable required evidence;
- package/version mismatch or unrecorded package change;
- review scope not defined or expanded without authority;
- material blocking finding unresolved;
- required discipline input or conflict disposition missing;
- reviewer attempts to issue, close or exercise another authority outside appointment.

Escalation identifies the decision required and the competent authority; it does not transfer authority. If the authority is unknown or disputed, the affected review remains held. A technical or administrative administrator cannot override the hold.

## 14. Candidate lifecycle and relationship to RFI parent state

The review is a subordinate assurance record, not an independent parent RFI lifecycle.

Candidate subordinate review statuses may include: Not Assessed, Pending Authority Decision, Required, Assigned, In Review, Changes Required, Clarification Required, Conflict Escalated, Reviewed — No Blocking Comment, Unable to Complete, Superseded. These labels are not final system enums.

Rules:
- The parent RFI enters Under Independent Review only through the approved parent transition guard when a mandatory review is triggered and a valid review assignment exists.
- Review completion may satisfy one parent gate but does not by itself issue or close the RFI.
- A failed or changed review may return the parent only through the approved DD-01 transition and OR-01/OR-03 owner rules; this document does not create parent transitions.
- A Not Required trigger decision does not create a completed review.
- Review record closure, conflict record closure, technical issue, distribution, acknowledgement, archive and disposition remain distinct events.
- No subordinate review event autonomously changes the parent lifecycle.

## 15. Test and acceptance catalogue

The following are candidate scenario families for mapping into DD-15. They are not evidence of tests executed or passed.

| Test family | Required negative / positive behavior | Blocking result |
|---|---|---|
| Instrument validity | Missing, draft, expired, superseded or wrong-project matrix cannot be treated as applicable approval | No inferred trigger decision |
| Trigger authority | Unauthorized actor cannot mark Mandatory / Not Required | Decision rejected and audited |
| Ambiguous trigger | Ambiguity cannot default to Not Required | Affected issue gate remains held |
| Scope binding | Review applies only to identified response/evidence scope | No broader clearance |
| Reviewer appointment | Expired, revoked, absent or out-of-scope appointment cannot complete review | No valid outcome |
| Competence | Unsupported competence cannot be inferred from title or role | Review assignment held |
| Independence | Author/consolidator/conflict decision-maker cannot self-review where separation applies | Review denied |
| Exception | Role-combination exception without explicit instrument/approval cannot proceed | Exception denied |
| Evidence integrity | Missing/corrupt/mismatched evidence cannot pass | Review blocked |
| Exact-version binding | Changed candidate cannot reuse old clearance as current | Reassessment required |
| Finding disposition | Blocking finding cannot be silently closed or removed | Gate remains open |
| Change impact | Material/unclear change receives competent impact assessment | Affected clearance held |
| Targeted/full review | Scope cannot be narrowed where dependencies or matrix require full review | Re-review decision blocked |
| Substitution | New reviewer requires fresh appointment and independence check | No inherited authority |
| Parent lifecycle | Review completion is not issue, closure or distribution | Parent guards remain authoritative |
| Records/security | Unauthorized historical access denied; audit/history preserved | No metadata/content leakage |

All scenario definitions must be linked to approved requirements, expected results, actor permissions, exact synthetic test data, execution evidence and defect/retest records under DD-15 and DEC-110. Unresolved expected behavior is Blocked — Pending Design Decision/Prerequisite.

## 16. Open decisions and required specialist validation

| ID | Open decision / evidence required | Required authority / specialist | Interim rule |
|---|---|---|---|
| DD04-01 | Matrix owner, approval authority, controlled versioning and applicability | Owner; project governance; technical/quality authority | No matrix approval inferred |
| DD04-02 | Mandatory trigger criteria by project/RFI class and any thresholds | Project risk/quality and technical authorities; affected disciplines | No universal trigger/threshold; ambiguity held |
| DD04-03 | Authority to determine trigger and Not Required decision | Owner; appointing/project governance; technical authority | No fallback authority inferred |
| DD04-04 | Reviewer competence profiles and evidence standard | Discipline authorities; quality/independent assurance; appointing authority | No competence inferred from title |
| DD04-05 | Independence criteria, conflicts and prohibited combinations | Owner; quality; security/privacy; project governance | Apply approved separation; uncertain case held |
| DD04-06 | Permitted role-combination exceptions and compensating controls | Owner and authority named by approved instrument | No exception assumed |
| DD04-07 | Reviewer count/stages and reviewer disagreement route | Owner; technical/quality authority | No multi-stage review default |
| DD04-08 | Outcome/finding vocabulary and blocking classifications | Owner; technical/quality; QA | Candidate labels only |
| DD04-09 | Targeted/full re-review criteria and materiality | Technical authority; affected disciplines; QA/independent assurance | Unclear scope/materiality held |
| DD04-10 | Substitution, interruption, expiry and revocation | Appointing authority; project governance | No inherited appointment/clearance |
| DD04-11 | Confidentiality, recipient and internal access to review records | Security/privacy; records; Document Control | Least privilege; no implicit access |
| DD04-12 | Records series, retention, hold, archive and disposition mapping | Records; legal/contract as applicable; owner | DD-14 governs; no period invented |
| DD04-13 | Actual test scenarios, acceptance owner and release-signoff authority | QA; owner; security; records; architecture; technical authority | No test execution or pass inferred |

## 17. Cross-specification traceability

| DD-04 topic | Controlling reference | Required consistency |
|---|---|---|
| Parent state / transition guards | DD-01 in docs/72; DISP-OR01-014 | Review remains subordinate; no autonomous parent transition |
| Capability / appointments | DD-02 in docs/72; OR03-D01/D08 | Action-specific authority and evidenced appointment |
| Discipline contributions / conflict | DD-03 docs/111; OR03-D02–D07 | Review does not replace contributions or conflict decision |
| Review trigger | OR03-D09 docs/121; DEC-105 | Approved/versioned matrix only |
| Change impact | OR03-D10 docs/122 | Exact-version reassessment; targeted/full scope based on evidence |
| Evidence and integrity | DD-08 docs/76; DEC-107 | Immutable version references, integrity and per-action authorization |
| Distribution and acknowledgement | DEC-108; DD-09/10 | Review completion is not delivery or acknowledgement |
| Records lifecycle | DD-14 docs/82; DEC-109 | Separate classification, retention, hold, archive and disposition |
| Tests and acceptance | DD-15 docs/83; DEC-110 | Traceable scenarios, negative authorization, evidence and blockers |
| Cross-specification findings | docs/126 | Apply clarifications only after exact-version review |

## 18. Acceptance and promotion gates

DD-04 may be considered for promotion only after:
- owner confirms the exact DD-04 specification version and its intended scope;
- approved/versioned risk-and-authority matrix is supplied and its owner, approval, applicability and version-control evidence verified;
- trigger criteria, decision authority and Not Required rules are explicit;
- reviewer competence, appointment, independence and conflict controls are validated by relevant specialists;
- role-combination exceptions, if any, are expressly approved and bounded;
- exact-version evidence/manifest and access model are reconciled with DD-08;
- change-impact and re-review criteria are reconciled with OR03-D10 and DD-03;
- records, retention, hold and archive mapping are validated under DD-14;
- actual test definitions are imported and mapped under DD-15;
- all specialist findings, conditions, dissent and blockers are attributable and dispositioned by competent authorities;
- fresh cross-specification review is performed against the exact revised documents.

A desk review, conditional owner disposition, draft matrix template or passing document-integrity check is not formal specialist validation or approval.

## 19. Implementation boundary

This working draft does not authorize:
- reviewer appointment, role grant, capability or permission changes;
- workflow/status/transition implementation;
- UI/API/code, DB/schema/migrations/generated types, Storage, authentication or authorization/RLS changes;
- production-data access or modification;
- test execution or a claim of test pass;
- backup/restore or migration rehearsal;
- merge, deployment or release.

Any future implementation/test proposal requires a separate scoped plan, resolved prerequisites, exact owner and specialist approvals, evidenced appointments, approved non-production environment and synthetic data, and explicit owner authorization. DB/Storage work additionally requires verified backups, isolated restore/rehearsal and reconciliation before any change.

---

**End of DD-04 working draft — candidate independent-review control framework only. The risk-and-authority matrix, reviewer appointments, specialist validation and OR-03 formal closeout remain pending.**
