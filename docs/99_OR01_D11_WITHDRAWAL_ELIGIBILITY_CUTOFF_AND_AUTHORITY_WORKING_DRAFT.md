# OR-01 / DISP-OR01-011 — Withdrawal Eligibility, Cutoff and Authority

**Document type:** Detailed lifecycle decision review memorandum  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — DISP-OR01-011 CONDITIONALLY APPROVED BY OWNER FOR THE RECORDED SCOPE — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Related decisions:** DEC-104, DEC-105, DEC-106, DEC-107, DEC-108, DEC-109, DEC-110; DISP-OR01-003 through DISP-OR01-010.

> This memorandum proposes rules for requesting, validating and authorizing withdrawal of an RFI before formal issue. It does not approve the complete RFI lifecycle, appoint a withdrawal authority or technical lead, or authorize implementation or testing.

## 1. Decision question and scope

DISP-OR01-011 determines:
1. Who may request withdrawal and for which RFI?
2. Until what lifecycle point may a request be considered?
3. What evidence distinguishes administrative intake/assignment from substantive technical work?
4. When is technical-lead concurrence required, and what happens if no valid lead is appointed or the lead is unavailable?
5. Who independently validates and authorizes the withdrawal?
6. What happens to contributions, clarification requests, reviews, response candidates, evidence, official number and communication records?
7. How are concurrent withdrawal and formal issue, cancellation or other lifecycle actions reconciled?

This decision concerns withdrawal only. Administrative cancellation for duplicate/invalid registration or another specifically approved ground remains DISP-OR01-012. Reopening after successful issue remains DISP-OR01-013. Formal issue and technical closure are governed by DISP-OR01-010 and DEC-106.

## 2. Protected governance and owner decisions

1. **DEC-106:** withdrawal request and authorized withdrawal are distinct; the request is not itself a state transition. After substantive technical work begins, technical-lead concurrence is required under the adopted governance boundary. Official identity and history are preserved.
2. **DEC-105:** technical authority, technical lead and coordinator boundaries are appointment- and scope-bound. A coordinator cannot make a technical judgment merely by administering the request.
3. **DISP-OR01-004–009:** preserve current authority/assignment evidence, contribution history, clarification blockers, conflict and review records, exact-version readiness and any concurrent transition guards.
4. **DISP-OR01-010:** successful formal issue and technical closure are one atomic business outcome. Once issue succeeds, pre-issue withdrawal is no longer an available route. A racing withdrawal request cannot reverse a completed issue.
5. **DEC-107/109:** official RFI identity, audit history and records lineage remain preserved. Withdrawal is not deletion, erasure, archive disposition or retention expiry.
6. **DEC-108:** any existing Transmittal, delivery, access or acknowledgement history remains a separate immutable communication record. Withdrawal does not silently retract or erase a sent package.
7. **DEC-110:** proposed acceptance criteria must trace authority, state, evidence, action and result. No tests are executed by this memorandum.

## 3. Proposed meaning of withdrawal

Withdrawal is an authorized pre-issue administrative termination of the active RFI request at the request of its eligible originating party, after validation of eligibility, authority, scope, timing and any required technical-lead concurrence.

The following are distinct:
- **Withdrawal request:** attributable request submitted by the authorized originator; it does not itself change the parent lifecycle.
- **Withdrawal review:** administrative and, where required, technical validation of the request and its current context.
- **Authorized withdrawal:** an explicit decision by the designated authority that changes the eligible pre-issue RFI to Withdrawn.
- **Withdrawal rejection/deferral:** an attributable decision that the request is ineligible, insufficiently evidenced, disputed or cannot yet be authorized; the RFI remains in its current valid state.

A request, draft, notification, comment, assignment response or silence is not an authorized withdrawal.

## 4. Recommended eligibility and cutoff

### 4.1 Pre-issue cutoff

Recommend that withdrawal may be requested and authorized only before the successful formal issue event for the active RFI cycle.

The route may be considered in pre-issue states only where the RFI is still active and no incompatible terminal or superseding action has succeeded. Candidate eligible states include Submitted, Under Coordination, Returned for Completion, In Technical Assessment, Awaiting Originator Clarification, Under Consolidation, Under Independent Review and Ready for Issue, subject to current-state checks and any specific exclusions the owner approves.

The list is a candidate, not a final state-machine approval. In particular, the owner should decide whether withdrawal remains available in Ready for Issue before the issue action has succeeded. The recommendation is yes, but with mandatory current-state and concurrency revalidation; Ready for Issue does not itself mean issued.

### 4.2 Post-issue cutoff

After successful formal issue:
- Do not permit the pre-issue withdrawal route.
- Do not convert the issued response into Withdrawn or pretend the issue never occurred.
- Use the separately governed post-issue route: clarification, formal revision, authorized reopening/new cycle, linked new RFI, or another explicitly approved correction mechanism.
- Preserve the original issued response, issue/closure record and all related Transmittal/recipient events.

A request received before issue but not validly authorized before the issue commit does not defeat a successful issue. The issue/withdrawal race must resolve to one authoritative outcome, not a partial or contradictory state.

## 5. Who may request withdrawal

Recommend that only the authorized originator, or a specifically evidenced delegate of the same originating party with explicit RFI/project scope, may submit a withdrawal request for that RFI.

Minimum request evidence:
- project and official RFI ID;
- originating party and requester identity;
- current appointment/delegation and scope reference;
- reason for withdrawal and supporting facts/evidence;
- whether technical work, clarification, review, consolidation or external communication is known to have begun;
- requested effective scope (normally the whole parent RFI);
- request timestamp and attributable request identity.

Membership, being the author of a draft, coordinator status, PM oversight, responder assignment or read access alone does not establish request authority.

A different party, reviewer, technical responder, coordinator or Document Control officer may raise a concern or refer the matter to the originator/authorized authority, but does not submit an originator withdrawal on the originator's behalf without valid delegation.

## 6. Recommended definition of substantive technical work

The cutoff for requiring technical-lead concurrence must be evidence-based and not depend on informal impressions or a job title.

### 6.1 Activities that are not, by themselves, substantive technical work

Unless accompanied by technical analysis, these administrative events alone should not trigger the substantive-work concurrence requirement:
- successful RFI submission and number allocation;
- coordinator intake, completeness checking or routing;
- appointment/assignment creation;
- responder notification or assignment acceptance alone;
- opening or viewing the RFI or its attachments;
- administrative return for completion;
- creation of an empty contribution placeholder;
- automated scanning, indexing or document conversion.

These events remain recorded and may be relevant to records/security review, but do not by themselves prove that technical assessment has begun.

### 6.2 Evidence that substantive technical work has begun

Recommend treating substantive work as begun when at least one properly appointed technical participant has performed and recorded a meaningful technical activity within assigned scope, such as:
- technical examination or interpretation of the engineering question, drawings, specifications, calculations, models or evidence;
- recording a technical assessment, finding, assumption, risk, recommendation or discipline position;
- preparing or submitting a substantive discipline contribution;
- raising a technical clarification because a material technical dependency prevents assessment;
- identifying, evaluating or dispositioning a material technical conflict;
- conducting a technical review of a response candidate or recording review comments.

The evidence must identify actor, active appointment/scope, activity type, timestamp, RFI/contribution/candidate version and supporting record/reference. A status flag without attributable underlying evidence is insufficient.

### 6.3 Boundary cases

- Assignment accepted but no technical analysis recorded: not substantive by itself.
- A technical clarification is raised for a genuine engineering dependency: substantive work has begun for concurrence purposes, even if no completed contribution exists.
- A technical participant opens a file without analysis: not substantive by itself.
- Technical notes or analysis exist outside the system: the requester/authority must disclose them and the validator must seek attributable evidence; absence of a system event is not proof that no work occurred.
- Work by an unappointed or out-of-scope person does not establish valid technical work authority, but any discovered work product or security incident must be preserved and referred for appropriate review; it must not be silently discarded.

Specialists must validate these examples and the final evidence standard before operational use.

## 7. Technical-lead concurrence after substantive work begins

### 7.1 Required concurrence

Once substantive technical work has begun, recommend that withdrawal authorization requires a recorded concurrence from the currently appointed technical lead for the active RFI scope, confirming at minimum:
- whether substantive work has begun and the evidence supporting that finding;
- affected disciplines, assignments, contributions, clarifications, conflicts, reviews and response candidates;
- whether any work is incomplete, disputed or relied upon by another active process;
- whether withdrawal would leave an external dependency, safety/quality concern, unresolved technical issue or required records action;
- what must be preserved and whether a separate referral is necessary.

Concurrence is a technical impact assessment, not the withdrawal decision itself. It does not grant the technical lead authority to withdraw on behalf of the originator or to override the designated withdrawal authority.

### 7.2 No valid technical lead / unavailable lead

If substantive work has begun but no valid technical lead is appointed, the lead's appointment is expired/revoked, scope is disputed, or the lead is unavailable:
- hold the withdrawal decision;
- refer to the formally appointed technical authority or project appointing authority for a valid replacement/delegated technical assessment;
- do not infer concurrence from silence, elapsed time, coordinator convenience, majority agreement or assignment status;
- do not let the coordinator act as technical substitute.

Any substitute or delegated reviewer must have explicit current appointment, scope and evidence. No automatic substitute hierarchy or timeout is created here.

### 7.3 No substantive work

Where the evidence review establishes that substantive technical work has not begun, technical-lead concurrence is not required under the recommended rule. Administrative validation remains mandatory, and the validator must record the basis for concluding that the cutoff has not been crossed.

## 8. Withdrawal authorization and separation of duties

Recommend a two-part decision boundary:
1. **Administrative eligibility validation and authorization:** a designated records/workflow authority, explicitly appointed for the project/party/RFI scope, validates originator authority, pre-issue state, reason, completeness and absence of a competing successful transition, then records the withdrawal decision.
2. **Technical concurrence where required:** the appointed technical lead (or a specifically appointed competent technical authority if no lead exists) records the technical impact/concurrence described in §7.

The coordinator may perform the administrative steps only if separately delegated. Document Control may preserve the resulting record and communicate the decision but does not acquire technical authority. The originator/requester must not self-authorize the withdrawal unless a separately approved project governance rule explicitly permits that combination and any applicable separation-of-duties requirement is satisfied.

The exact appointing authority, role compatibility, decision maker and delegation evidence remain open for owner/specialist confirmation. This memorandum appoints nobody.

## 9. Scope: whole RFI versus partial withdrawal

Recommend that **Withdrawn is a parent-RFI outcome**, normally applying to the entire active RFI identity/cycle, not a convenient way to remove one discipline contribution or a selected question after work has begun.

If only one discipline, work package or part of the scope is no longer required:
- use a formally authorized scope/assignment change with reason, impact assessment, effective date and preserved before/after scope snapshots;
- identify effects on required contributions, technical lead, candidate response, review and evidence;
- do not label the parent RFI Withdrawn if the remaining parent question continues;
- if the remaining question is genuinely independent or materially different, consider a linked new RFI under the applicable governance route.

The owner should explicitly confirm whether any project-specific partial withdrawal mechanism is needed. No partial-withdrawal state or feature is presumed.

## 10. Decision outcomes and required evidence

| Outcome | Meaning | Required evidence |
|---|---|---|
| Request received | Authorized originator request captured; no parent state change yet | Request ID, actor/delegation, reason, scope, time |
| Pending administrative validation | Eligibility/authority/state or records checks incomplete | Assigned validator, missing evidence, current parent state |
| Pending technical concurrence | Substantive work has begun and valid technical concurrence is outstanding | Technical-work evidence, appointed lead/authority and affected scope |
| Withdrawn | Designated authority approved eligible pre-issue withdrawal | Decision maker/appointment, concurrence where required, rationale, effective event and preserved record |
| Rejected / not eligible | Request fails eligibility or authority requirements | Reasoned decision, actor/authority, evidence, current state retained |
| Deferred / held | Evidence, authority, concurrence or concurrency is uncertain | Hold reason, required decision/evidence and referral owner |
| Superseded by issue | Formal issue committed before withdrawal authorization | Link to issue/closure record; withdrawal request retained as non-effective request |

These are proposed request/review outcomes, not approval of additional parent lifecycle states. The final event and request vocabulary requires specialist reconciliation.

## 11. Preservation, records and downstream effects

An authorized withdrawal must not:
- delete, overwrite or recycle the official RFI ID;
- erase the original submitted snapshot, formal revision history or attachments;
- delete or rewrite contributions, clarifications, technical notes, conflict/dissent records, review packages/comments or candidate response versions;
- erase the fact that substantive technical work occurred;
- erase failed or superseded withdrawal requests or decisions;
- remove Transmittal, delivery, access, acknowledgement or substantive-response history;
- imply that the RFI was technically rejected, technically answered, accepted or formally issued.

Instead:
- retain all records with attribution, version lineage and the Withdrawn decision link;
- preserve incomplete work as historical records with clear non-current/non-issued status;
- record the reason, scope, decision authority, concurrence evidence (if applicable), timestamp and effective outcome;
- keep archival, retention, legal hold and disposition separate under DEC-109 and the records workstream;
- apply server-side access controls to the withdrawn record and its evidence.

Withdrawal does not itself authorize deletion, retention shortening, external communication retraction or destruction of copies.

## 12. Concurrency and interaction with other lifecycle actions

### 12.1 Withdrawal versus formal issue

DISP-OR01-010 requires issue and technical closure to succeed atomically. The withdrawal decision must use the same current-state/version discipline:
- if withdrawal is validly authorized and committed first, formal issue must be blocked for that active cycle;
- if formal issue commits first, withdrawal is ineligible and the request is retained as non-effective history;
- if either action encounters stale state, conflicting version or uncertain commit outcome, hold/reconcile using authoritative event history; do not infer success from a client response or duplicate retry.

### 12.2 Withdrawal versus cancellation

Withdrawal and administrative cancellation are distinct outcomes with distinct grounds and authority. A duplicate/invalid registration should be evaluated under DISP-OR01-012 rather than mislabelled as originator withdrawal. A pending withdrawal request must not automatically become cancellation, or vice versa.

### 12.3 Withdrawal versus clarification, revision and scope change

- An open clarification request does not automatically prevent withdrawal, but its dependency and technical work must be included in the technical impact assessment.
- A formal revision or scope change must not be silently discarded; preserve its record and determine which exact active version is being withdrawn.
- A scope-only reduction should normally use an authorized scope change, not parent withdrawal.
- An independent new question remains a linked new RFI.

### 12.4 Withdrawal versus external communication

A prior Transmittal and recipient events remain historical. Any notice that an RFI has been withdrawn must use an authorized communication/records route and must not imply recall or deletion of already delivered records. No default notice channel, SLA or legal effect is created.

## 13. Proposed acceptance criteria for later test design

These are proposed design-level criteria only; no tests have been executed.

1. A user without current originator/delegate authority cannot submit a withdrawal request for the RFI.
2. A withdrawal request creates a request record but does not itself change parent lifecycle state.
3. A request after successful formal issue cannot transition the issued RFI to Withdrawn.
4. An authorized request in an eligible pre-issue state may proceed to validation; ineligible/terminal states are held or rejected with evidence.
5. Submission, coordinator intake, assignment creation/acceptance, file viewing or empty placeholders alone do not trigger the substantive-work concurrence rule.
6. Attributable technical analysis, substantive contribution, technical clarification, conflict disposition or response review triggers technical-lead concurrence under the approved evidence standard.
7. Where substantive work has begun, withdrawal cannot be authorized without valid recorded technical concurrence.
8. Missing, expired, disputed or unavailable technical-lead appointment causes hold and referral, not inferred concurrence.
9. The designated withdrawal authority is independently evidenced and cannot be inferred from coordinator, Document Control or PM oversight titles.
10. Authorized withdrawal preserves official RFI number, submitted snapshot, attachments, contributions, clarifications, reviews, candidate versions and communication/audit history.
11. Partial discipline removal uses authorized scope/assignment change rather than parent Withdrawn, unless a separately approved rule says otherwise.
12. Concurrent issue and withdrawal cannot both succeed; the authoritative commit order determines the valid outcome and all losing/stale attempts remain attributable.
13. Withdrawal cannot be used as cancellation for duplicate/invalid registration or as technical rejection.
14. A withdrawn RFI cannot be silently deleted or have its official number reused.
15. A post-withdrawal communication notice does not erase prior Transmittal/delivery/access/acknowledgement evidence.

These criteria must be reconciled with the actual DEC-110 scenario catalogue and specialist test governance before execution. They do not establish that any existing AT-RFI/E2E scenario has passed.

## 14. Specialist validation requested

| Specialist | Required validation |
|---|---|
| Project/process owner | Eligible state set, originator request boundary, whole-RFI versus partial scope and approval authority |
| Appointing authority / technical governance | Definition of substantive technical work, technical-lead concurrence and substitute authority evidence |
| Technical lead / discipline authorities | Technical-work indicators, impact assessment, open contribution/clarification/conflict/review treatment |
| Document Control / records | Request/decision record, official number/history preservation, communication and archive boundaries |
| Architecture | State/version guards, withdrawal-vs-issue concurrency, idempotency, recovery and audit integrity |
| Security / privacy | Originator/delegate authorization, party/project/discipline scope, evidence visibility and action-time checks |
| QA / assurance | Negative authority tests, boundary cases, preservation criteria and failure/retry evidence |
| Legal / contract / project governance as applicable | Any project-specific notice or contractual consequences; none is inferred by this memorandum |

These are review domains, not appointments or completed sign-offs.

## 15. Owner decision points

1. Confirm that only an authorized originator or evidenced same-party delegate may request withdrawal.
2. Confirm the pre-issue cutoff: withdrawal may be authorized only before successful formal issue; after issue, use separately governed post-issue routes.
3. Confirm the candidate eligible pre-issue state set, including whether Ready for Issue remains eligible until issue commits.
4. Confirm the evidence-based definition of substantive technical work in §6, including boundary examples and minimum event evidence.
5. Confirm that technical-lead concurrence is required once substantive technical work has begun, and that concurrence is a technical impact assessment rather than the withdrawal decision itself.
6. Confirm hold/referral when no valid lead is appointed, the lead is unavailable or authority is disputed; no silence or coordinator substitute.
7. Confirm that a separately appointed records/workflow authority validates and authorizes withdrawal, subject to technical concurrence where required.
8. Confirm Withdrawn is a whole-parent-RFI outcome by default; partial discipline/scope removal uses an authorized scope/assignment change.
9. Confirm preservation of number, submitted snapshot, contributions, clarifications, reviews, response candidates, evidence and communication history.
10. Confirm deterministic withdrawal-versus-issue concurrency: whichever valid action commits first controls; the losing action cannot create a contradictory outcome.
11. Confirm withdrawal remains distinct from cancellation, technical rejection, revision, reopening and archival/disposition.

## 16. Recommended interim controls

Until owner disposition and specialist validation are complete:
- Treat every withdrawal as a request requiring an explicit authorized decision; never auto-withdraw on request receipt.
- Hold withdrawal if current state, originator authority, substantive-work evidence, technical-lead appointment/concurrence or competing lifecycle action is missing, stale, disputed or ambiguous.
- Require technical-lead concurrence after evidence of substantive technical work; do not infer it from silence, assignment acceptance or coordinator action.
- Do not allow pre-issue withdrawal after successful formal issue.
- Do not erase/reuse official RFI identity or delete/overwrite work products, evidence, review or communication history.
- Do not use parent withdrawal to remove a single discipline contribution or to disguise administrative cancellation or technical rejection.
- Reconcile issue/withdrawal races against authoritative committed history; never allow both to succeed.

## 17. Explicit exclusions and open decisions

This memorandum does not approve a final lifecycle state machine, exhaustive eligible-state list, named withdrawal validator/approver, named technical lead, delegation instrument, final substantive-work taxonomy, partial-withdrawal feature, notification channel, legal/contractual effect, retention schedule, deletion/disposition rule, issue/withdrawal transaction design or test execution. It does not amend DEC-103–DEC-110, appoint actors, grant capabilities, create SLA/deemed acceptance, authorize implementation, test execution, DB/schema/migration/generated-type changes, Storage, authentication, authorization/RLS/grants, production-data operations, backup/restore, merge, deployment or release.

## 18. Technical recommendation summary

Adopt an explicit pre-issue withdrawal request and authorization model. Only the authorized originator or evidenced same-party delegate may request; request receipt never changes the parent state. Permit authorized withdrawal only before successful formal issue. Define substantive work through attributable technical activity evidence, not mere assignment or file viewing; once substantive work has begun, require recorded technical-lead concurrence as a technical impact assessment. A separately appointed records/workflow authority makes the administrative eligibility decision. Hold where authority or evidence is uncertain. Treat Withdrawn as a whole-parent-RFI outcome by default; use authorized scope change for partial discipline removal. Preserve official number and all work/evidence/communication history. Resolve issue/withdrawal concurrency by the first valid authoritative commit, with no contradictory dual success.

## 18.1 DD-11 cross-specification review reference

The exact-version DD-11 cross-specification review is recorded in [docs/142 — DD-11 Reopening, Withdrawal and Cancellation Cross-Specification Review](142_DD11_REOPENING_WITHDRAWAL_CANCELLATION_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md). RCL-01–RCL-15 and DEP-RCL-01–DEP-RCL-15 cover the shared substantive-work threshold, Ready for Issue cutoff, issue/withdrawal/cancellation race, parent/cycle projection, records preservation and adjacent communication/test controls. This desk review does not alter the conditional owner disposition in §19 or close specialist prerequisites.

## 19. Owner disposition — Revision 1

**Disposition:** **Conditionally approved by the owner** on 2026-11-12, following the owner's explicit instruction: «اعتمد توصياتك».

**Approved scope:** The owner approved the technical recommendation's ten principles in §15 and the interim-control boundaries in §16, including these three expressly confirmed points:
1. Withdrawal remains eligible in **Ready for Issue** only while successful formal issue has not yet committed. Once issue commits, pre-issue withdrawal is unavailable and a separately governed post-issue route applies.
2. Assignment acceptance alone does **not** establish that substantive technical work has begun. The determination requires attributable evidence of meaningful technical activity; the activity examples and evidentiary threshold in §6 remain subject to specialist validation.
3. **Withdrawn** applies to the whole parent RFI by default. Removing one discipline or reducing only part of the scope requires an authorized scope/assignment change, not a parent withdrawal.

The remaining approved principles include authorized-originator/delegate request authority; separation of request receipt from the withdrawal decision; technical-lead concurrence after substantive technical work begins; hold/referral where valid appointment or authority is missing; a separately appointed administrative withdrawal authority; preservation of official identity and all work/evidence/communication history; and deterministic issue/withdrawal concurrency.

**Conditions and outstanding prerequisites:**
- Specialist validation remains required from the project/process owner, appointing authority, appointed technical lead and discipline authorities, Document Control/records, architecture, security, QA and contract/project governance as applicable. No specialist sign-off is claimed.
- The final eligible-state list, substantive-work taxonomy and evidence standard, lead appointment/substitution rules, exact withdrawal decision authority, any role compatibility/separation rule, scope-change mechanics and event vocabulary require specialist confirmation.
- Technical-lead concurrence remains a technical impact assessment, not the withdrawal decision itself. No concurrence is inferred from silence, assignment acceptance or coordinator action.
- Any external withdrawal notice remains subject to separately authorized communication and applicable project governance; no legal/contractual notice effect is created here.
- No default SLA, clock pause, timeout, notification cadence, escalation, deemed receipt or deemed acceptance is established.
- This conditional owner disposition does not appoint any person, grant capabilities, approve a final full lifecycle state machine, or authorize workflow implementation, test execution, DB/schema/migration/generated-type changes, Storage, authentication, authorization/RLS/grants, production-data operations, backup/restore, merge, deployment or release.

**Interim control:** Until specialist validation and dependent decisions are complete, hold withdrawal where authority, state, substantive-work evidence, concurrence, scope or competing transition is missing, stale, disputed or ambiguous. Do not withdraw after successful issue, infer concurrence, partially withdraw the parent by discipline, or erase/reuse identity or history.

---
**End of working draft — ten principles conditionally approved by owner; specialist validation and implementation prerequisites remain pending.**
