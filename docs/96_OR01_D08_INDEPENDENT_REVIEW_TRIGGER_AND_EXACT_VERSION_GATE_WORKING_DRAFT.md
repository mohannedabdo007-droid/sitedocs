# OR-01 / DISP-OR01-008 — Independent Review Trigger and Exact-Version Gate

**Document type:** Detailed lifecycle decision review memorandum  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — TECHNICAL RECOMMENDATIONS ONLY — OWNER DISPOSITION NOT RECORDED — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Related decisions:** DEC-104, DEC-105, DEC-106, DEC-107, DEC-110; DISP-OR01-006/007; DEC-022-A/B as applicable.

> This memorandum proposes a decision framework only. It does not establish a risk matrix, appoint reviewers, approve a response or authorize implementation/testing.

## 1. Decision question

DISP-OR01-008 asks which conditions require independent review, who approves the trigger matrix and reviewer appointment, what exact package is reviewed, what outcomes are valid, and when changes require re-review.

DEC-105 requires independent review under an approved risk/authority matrix and applicable separation-of-duties rules, but the actual matrix and exact triggers remain open. No threshold, mandatory category, reviewer or credential is invented here.

## 2. Governing constraints

1. DEC-105 separates technical authority, technical lead, reviewer, issuer and Document Control; required independent review follows the approved matrix and applicable separation rules.
2. DISP-OR01-006 controls Under Consolidation entry; DISP-OR01-007 controls material return and preservation of candidate/contribution lineage.
3. DEC-022-A/B and DEC-106 govern controlled-content change, clarification, formal revision, linked new RFI and reopening.
4. DEC-107 keeps RFI identity distinct from response version and review record identifiers.
5. DEC-110 requires traceable review/acceptance evidence, but this is design only; no test execution is claimed.
6. DEC-103/108/109 keep delivery, access, acknowledgement, notification, reporting and archive separate from review clearance and technical lifecycle.

## 3. Trigger matrix governance

### 3.1 Approval and maintenance
- A project/organizational authority designated by the approved governance model must approve and version the risk/authority matrix before it becomes a mandatory workflow gate.
- The matrix must identify its owner, approval authority, scope, effective date/version, evidence basis and change-control route.
- Until the matrix and applicability are evidenced, do not invent a threshold or silently treat review as waived or mandatory. Hold the affected gate for competent authority determination.
- Technical lead may identify a potential trigger and recommend review; appointed technical/risk authority determines applicability within documented appointment. The coordinator cannot waive or determine technical risk.

### 3.2 Candidate dimensions for matrix development (not approved defaults)
The owner and specialists may evaluate: consequence/severity and uncertainty; cross-discipline interfaces and material dissent; departure from approved design basis/specifications/standards; safety/reliability/environment/operations/asset-integrity implications where applicable; novel or non-standard solutions, deviations or concessions; material scope/technical-basis/evidence changes; competence/delegation limitations; and specific owner/project assurance requirements.

The approved matrix must define measurable criteria, evidence sources, risk ownership, mandatory/conditional status, reviewer competence and exception authority. This memorandum establishes none of those thresholds.

### 3.3 Trigger record
Record matrix ID/version and criterion, evidence, decision and rationale, affected scope/response version, decision-maker and appointment evidence. Missing, expired, ambiguous or disputed matrix/authority/evidence means hold and refer. Schedule pressure, silence, majority preference or administrative convenience cannot waive a mandatory review.

## 4. Reviewer appointment, competence and independence

The authorized appointing authority must evidence reviewer identity, relevant competence, discipline/scope, appointment/delegation, effective period, review terms, independence/conflict declaration and access scope. No reviewer is inferred from title, group membership, email domain, prior access, seniority or availability.

- No person reviews their own authored or materially controlled work where the approved separation rule prohibits it.
- A technical lead who authored/directed/materially consolidated the response is not automatically its independent reviewer.
- Issuer authority is not independent review clearance.
- Cross-discipline review requires demonstrated competence, scope and independence; membership alone is insufficient.
- Conflicts or loss of independence/competence require recusal or reassignment by the appointing authority. Preserve original appointment, declaration, recusal, reason and replacement; do not erase prior comments.
- Any staffing exception requires explicit authority under an approved rule; no automatic self-approval or waiver.

Credential standards, competence thresholds, exception policy and appointment authority remain for owner/specialist confirmation.

## 5. Exact-version review package and freeze

Before review starts, freeze an immutable package manifest containing at minimum:

1. RFI ID, formal revision/cycle identifiers;
2. consolidated candidate ID and exact response version/content integrity reference;
3. approved scope and assignment snapshot;
4. exact required contribution IDs/versions used;
5. clarification requests/responses and blocker status;
6. conflict/dissent/assumption/limitation register and authorized dispositions;
7. supporting evidence, drawings, calculations, attachments and controlled references with exact IDs/versions;
8. applicable matrix ID/version and trigger assessment;
9. reviewer terms of reference, review scope and required outcome;
10. parent state/version precondition and package creator/authorizer/time.

A live mutable link is not an adequate frozen package. The reviewer must be able to identify precisely every included item. No specific hash, storage, encryption, scanning or database mechanism is approved here; architecture/security/records validation remains necessary.

## 6. Review outcomes and comment control

### 6.1 Candidate outcome catalogue (not final enum)
- **Review Passed:** exact frozen version meets the defined review scope with no blocking issue open.
- **Changes Required — Blocking:** issue prevents clearance; Ready for Issue is blocked.
- **Conditional / Limited Clearance:** permitted only if the approved matrix expressly allows it and defines conditions, accountable owner, objective evidence and pre-issue closure gate.
- **Unable to Complete / Out of Scope:** reviewer cannot give a substantive outcome because competence, evidence, scope or package adequacy is insufficient.
- **Withdrawn / Superseded Review:** administrative record of a stopped/superseded review, never a passing outcome.

Silence, elapsed time, delivery, access, download, acknowledgement or majority agreement is never Review Passed.

### 6.2 Comments
Each comment has stable ID, author/time, exact package/version, location, rationale, significance and requested action. The approved matrix/terms define blocking vs advisory. Technical lead coordinates but cannot close another authority's technical comment without evidence. Competent discipline authority resolves comments in scope; material conflict is escalated. Reviewer or authorized reviewer delegate verifies closure. Preserve comments, responses, dissent and closure evidence as attributable history.

Conditional clearance is not a default workaround. Any condition affecting safety, technical adequacy, mandatory criteria or material conflict blocks issue until objectively closed.

## 7. Exact-version validity and re-review

1. Review clearance attaches only to the exact frozen response version and package manifest.
2. Any response, contribution, assumption, technical reference, attachment or scope change creates an attributable successor version; never mutate the reviewed package.
3. The appointed authority/lead records a change-impact assessment identifying affected criteria, disciplines, evidence and whether targeted or full re-review is required.
4. Substantive technical change, changed design basis/risk classification, new material conflict, invalidated contribution or material evidence/scope change requires trigger reassessment and applicable targeted/full re-review. The approved matrix governs extent.
5. A metadata-only change may be classified non-impacting only by an authorized actor under an approved rule and only where technical content and evidence manifest demonstrably remain unchanged; the reviewed package itself is not modified.
6. Until a valid impact decision is recorded, the prior Review Passed outcome cannot clear the changed candidate.
7. Prior comments/outcomes may inform a successor review but do not transfer clearance automatically.
8. Post-issue change follows authorized reopening/new-cycle and DEC-022-A/B routes; never edit issued response or past review evidence in place.

## 8. Lifecycle interactions

| Situation | Proposed control |
|---|---|
| Under Consolidation and trigger applies | Freeze package; verify appointment/independence; enter Under Independent Review only when all entry prerequisites pass |
| No mandatory trigger | Record matrix/version assessment and authorized determination; proceed only under separate Ready for Issue gate |
| Blocking review change | Preserve review and candidate; create successor candidate; use DISP-OR01-007 if discipline reassessment is required |
| Reviewer requests clarification | Follow DEC-106 and DISP-OR01-005; determine blocker scope; clarification is not review clearance |
| Reviewer independence/appointment invalid | Hold, recuse/reassign through appointing authority; preserve invalid attempt |
| Candidate changes during review | Prior outcome cannot clear changed candidate; preserve frozen package and conduct impact assessment/new review |
| Review Passed on unchanged exact candidate | Satisfies only review gate, not readiness, issue, delivery or closure |
| After formal issue | Use authorized reopening/new-cycle and revision rules |

## 9. Stale-state, concurrency and idempotency

At review start, outcome submission, comment closure and readiness transition, re-check parent state, candidate/version, package manifest, matrix version, reviewer appointment, access and conflict status. Reject/hold stale outcomes for superseded packages, expired appointments or changed matrix. Competing outcomes/candidate changes must not overwrite history. Retries must not duplicate reviews, clearances, comment closures or transitions. Failed/stale actions must not partially alter parent state or discard evidence. Check revoked appointment/access at action time.

## 10. Security and records

Review access is purpose- and scope-limited to the exact package. Every attachment preview/download requires current server-side authorization by project, party, discipline, appointment and record context. Reviewer access grants no edit, issue, distribution or wider visibility. Exports, caches, notifications and archival copies have separate authorization/lifecycle controls. Retention, legal hold and disposition remain subject to the separate records workstream; no retention period or deletion method is invented.

## 11. Proposed audit evidence

Preserve matrix/version and trigger assessment; reviewer appointment/competence/scope/independence and recusal history; immutable package manifest and exact response/evidence versions; review start/submission and action-time checks; outcomes/comments/responses/dissent/closure; candidate changes/impact assessments/supersession/re-review links; stale/failed/retried events and recovery evidence; and readiness decision bound to the exact version. No retention duration or storage technology is prescribed.

## 12. Specialist validation requested

| Specialist | Required validation |
|---|---|
| Project/process owner and risk/assurance authority | Matrix approval/ownership, scope, change control, trigger authority and exceptions |
| Technical authority and discipline authorities | Trigger dimensions, competence, blocking comments, materiality and escalation |
| QA / independent assurance | Independence, outcomes, substitutions, evidence sufficiency and objective closure |
| Architecture | Immutable manifest, version lineage, concurrency, idempotency, stale rejection and recovery |
| Security / privacy | Least privilege, conflict privacy, attachment authorization, export/cache and revocation |
| Document Control / records | Package identification, event traceability, records classification and retention dependencies |

These are review domains, not appointments or completed sign-offs.

## 13. Owner decision points

1. Require mandatory review triggers to come only from a formally approved, versioned risk/authority matrix.
2. Confirm who approves/maintains the matrix and determines applicability.
3. Require evidenced reviewer competence, appointment scope and independence for the exact RFI/version; no prohibited self-review.
4. Confirm immutable exact-version package/manifest and source-version traceability.
5. Confirm review clearance applies only to the version reviewed; changed candidates require impact assessment and matrix-governed re-review.
6. Confirm blocking comments prevent Ready for Issue; conditional clearance exists only if expressly authorized with objective closure controls.
7. Confirm stale versions, invalid appointments, unresolved conflicts or missing evidence hold the gate; silence is never approval.
8. Preserve separation between review clearance, technical readiness, formal issue, distribution, acknowledgement and closure.

## 14. Interim controls

Until owner disposition and specialist validation: do not invent/activate triggers or thresholds; infer no appointment/competence/independence; prohibit prohibited self-review; do not let changed/stale candidates inherit clearance; do not treat silence/delivery/access/acknowledgement as review; hold uncertain matrix/authority/package/version cases; do not promote final lifecycle state machine or implement review workflow.

## 15. Exclusions and open decisions

No final matrix, numeric threshold, reviewer credential standard, role/appointment model, final outcome enum, conditional-clearance policy, retention schedule, hash/storage mechanism or transaction design is approved. This does not amend DEC-103–DEC-110 or DEC-022-A/B, appoint actors, grant capabilities, authorize workflow implementation, test execution, DB/schema/migration/generated types, Storage, authentication, authorization/RLS/grants, production-data operations, backup/restore, merge, deployment or release.

## 16. Technical recommendation summary

Adopt: (1) mandatory review only through approved versioned matrix; (2) evidenced competence, appointment, independence and recusal; (3) immutable exact-version package manifest; (4) explicit attributable outcomes/comments with blocking controls; (5) clearance only for the exact reviewed version, with impact assessment and matrix-governed re-review after changes; (6) hold on stale state, invalid appointment, conflict or missing evidence; (7) review clearance separate from readiness, issue, distribution, acknowledgement and closure.

## 17. Owner disposition — Revision 1

**Disposition:** **Conditionally approved by the owner**  
**Decision date:** 2026-11-12  
**Decision evidence:** The owner explicitly stated: “اعتمد” in response to the seven recommended principles and their stated conditions for DISP-OR01-008.

### 17.1 Approved principles and bounded scope

1. **Matrix-controlled triggers:** Mandatory independent-review triggers must derive from a formally approved, versioned risk/authority matrix. No default trigger category, numerical threshold or waiver is created by this disposition.
2. **Matrix ownership and application:** The matrix approval/maintenance authority and the authority determining applicability to an RFI must be formally identified and evidenced before operational use.
3. **Reviewer independence and appointment:** Reviewer competence, appointment, scope, independence and conflict declaration must be evidenced for the specific RFI and response version. Self-review is prohibited wherever the applicable approved separation rule requires independence.
4. **Exact frozen package:** Independent review must use an immutable, identifiable package manifest tied to the exact response candidate/version and exact contribution/evidence versions reviewed.
5. **Version-bound clearance:** Review clearance applies only to the exact version reviewed. A changed candidate requires a documented impact assessment and matrix-governed targeted or full re-review as applicable; prior clearance does not transfer automatically.
6. **Blocking and conditional outcomes:** Blocking review comments prevent Ready for Issue. Conditional/limited clearance is not a default; it may be used only if an approved matrix expressly permits it and defines objective conditions, accountable ownership and pre-issue closure evidence.
7. **Stale-state and separation safeguards:** Stale versions, invalid appointments, unresolved conflicts or missing package/evidence hold the gate. Silence is never approval. Review clearance remains separate from technical readiness, formal issue, distribution, acknowledgement and closure.

### 17.2 Conditions and specialist validation

- Specialist validation remains required from the project/process owner and risk/assurance authority, appointed technical authority and relevant discipline authorities, QA/independent assurance, architecture, security/privacy, Document Control and records specialists as applicable. No specialist sign-off is claimed.
- The actual matrix, its owner/approver, measurable criteria, trigger thresholds, exception authority and applicability evidence remain to be established by competent authority.
- Reviewer competence criteria, appointment/delegation evidence, independence/conflict rules, recusal/substitution and any staffing exception require specialist confirmation.
- Final review outcome vocabulary, blocking/advisory classification, conditional-clearance eligibility, comment-resolution authority and objective closure evidence remain subject to owner/specialist reconciliation.
- Exact package-manifest structure, integrity mechanism, immutable version/candidate lineage, action-time authorization, concurrency/idempotency and stale-state recovery require architecture/security/QA/records validation.
- Targeted versus full re-review criteria and the materiality of changes require technical authority and relevant discipline validation.
- No default SLA, clock pause, timeout, notification cadence, escalation, contractual effect or deemed acceptance is introduced.
- This conditional approval does not appoint reviewers, grant capabilities, approve a final risk matrix or final state machine, or authorize implementation, test execution, DB/schema/migration/generated-type changes, Storage, authentication, authorization/RLS/grants, production-data operations, backup/restore, merge, deployment or release.

### 17.3 Interim controls

Until the conditions and specialist validations are satisfied: do not activate invented review triggers or thresholds; do not infer reviewer appointment or independence; do not allow prohibited self-review; do not let a changed/stale candidate inherit clearance; do not treat silence, delivery, access or acknowledgement as review approval; and hold cases with uncertain matrix, authority, reviewer, package or version evidence.

---
**End of working draft — owner disposition conditionally approved within the bounded scope above; specialist validation and detailed prerequisites remain pending.**
