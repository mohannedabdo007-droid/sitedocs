# RFI Reopening, Withdrawal and Cancellation Gate Matrix — Working Specification

**Status:** WORKING — FOR OWNER / TECHNICAL AUTHORITY / RECORDS / DOCUMENT CONTROL / CONTRACT / SECURITY REVIEW — NOT IMPLEMENTATION AUTHORIZATION  
**Work item:** RFI-DD-11 in `docs/71_RFI_DETAILED_SPECIFICATION_BACKLOG.md`  
**Dependencies:** DD-01 lifecycle/authority, DD-05 clarification/revision classification, DD-07 transaction integrity, DD-08 evidence security, DD-09 recipient distribution, DD-10 acknowledgement/substantive response.  
**Controlling decisions:** DEC-104, DEC-106, DEC-108, DEC-109 and DEC-110.

> This specification elaborates the owner-confirmed policy boundaries. It does not create new authority, approve final state vocabulary, select a project-specific eligibility matrix, amend any issued response, or authorize implementation.

## 1. Purpose and governing distinction

Define separate, controlled gates for:
1. **Originator withdrawal request** — a request by the originator to withdraw an eligible pre-issue RFI.
2. **Authorized withdrawal** — a separately validated and approved pre-issue administrative outcome.
3. **Administrative cancellation** — cancellation of an invalid or duplicate registration (or another expressly approved administrative ground), not an engineering decision.
4. **Reopening** — a new technical response cycle after a formally issued and closed RFI, preserving the earlier issued response and closure.
5. **Clarification / formal revision / linked new RFI** — distinct paths governed by DEC-106, DEC-022-A/B and DD-05; none may be used as a disguised withdrawal or reopening.

These are not interchangeable labels. A request is not an approved outcome. Administrative disposition is not technical rejection. Reopening does not erase or rewrite the prior cycle. Cancellation or withdrawal does not retract a previously issued response or dispatched Transmittal.

## 2. Controlling decisions and non-negotiable rules

- **DEC-104:** RFI operating authority and lifecycle controls remain within explicit appointments/delegations; coordinator and Document Control roles do not gain technical authority by administration.
- **DEC-106:** originator withdrawal request is before formal response issue and requires a reason; designated records/workflow authority validates; technical-lead concurrence is required after substantive work begins. Administrative cancellation is limited to evidenced administrative grounds, with designated authority and technical-lead concurrence after technical work begins. Reopening is by designated technical authority, with recorded reason and a new cycle while preserving previous response/closure. Preferred closure is atomic with successful formal issue. Requested/target dates create no default SLA or contractual consequence.
- **DEC-108:** technical issue/closure is independent of dispatch, delivery, access, acknowledgement, substantive recipient response and silence. Reopening does not alter the frozen historical Transmittal/recipient package. Changed package or recipient scope requires a new linked Transmittal.
- **DEC-109:** reopening preserves prior cycle dates, responses, closure and history; it is a new cycle, not a new official RFI identity. Notifications and overdue indicators cannot perform or imply lifecycle actions.
- **DEC-110:** eligibility, negative authorization, concurrency, idempotency, history, evidence and recovery must be verified with traceable tests; no unrun test is a pass.

## 3. Shared action envelope and mandatory evidence

Every withdrawal request, validation, cancellation decision or reopening decision must record:
- Stable action/request ID and action type.
- RFI ID, exact cycle, current lifecycle state and relevant formal response/version references.
- Initiating actor, authenticated identity, represented party, active appointment/capability and authority scope at action time.
- Decision actor(s), authority source, delegation/appointment reference and any required concurrence.
- Reason code and meaningful narrative; supporting evidence references where required.
- Requested scope and approved scope, including affected cycle, assignments, contributions, reviews and response versions.
- Server-recorded timestamp, timezone and event ordering/version reference.
- Prior state, resulting state/cycle and immutable relationship to preceding events.
- Notifications or controlled records-distribution events required by approved policy.
- Concurrency/idempotency correlation and final transaction outcome.

No action is valid solely because a button, role label, email, notification, verbal instruction or draft record exists. Recheck capability, appointment, scope and state at the consequential commit.

## 4. High-level gate matrix

| Action | Eligible source condition | Initiator / decision authority | Mandatory gate | Result and history |
|---|---|---|---|---|
| Request withdrawal | Pre-issue state only; no formal response issued | Originator requests; no self-approval assumed | Reason, exact RFI/cycle, current-state check | Pending request only; no lifecycle change yet |
| Approve withdrawal | Eligible pre-issue request | Designated records/workflow authority validates; technical-lead concurrence after substantive work begins | Eligibility, evidence, authority, concurrence, no issue race | Withdrawn administrative outcome; immutable history and number retained |
| Administrative cancellation | Evidenced duplicate/invalid registration or other expressly approved administrative ground | Designated records/workflow authority | Reason/evidence; technical-lead concurrence if technical work began; no engineering merits decision | Cancelled administrative outcome; identity/history retained |
| Reopen | Previously Closed RFI with formally issued response | Designated technical authority | Reason, scope, new cycle, authority, reassessment of assignments/conflicts/review | New active cycle under same official RFI identity; prior cycle immutable |
| Clarification | Existing question/response needs explanation or missing detail | Authorized participant under DD-05/DEC-106 | Same-question classification and exact response/cycle reference | Clarification round; no disguised independent question |
| Formal revision | Material change to formally controlled response/document | Authorized technical process under DEC-022-A/B | Revision basis, review/issue gates and version preservation | New controlled revision/version; prior version retained |
| Linked new RFI | Independent question requiring independent traceability | Technical lead/designated authority classifies under DEC-106 | Reason for independence and link to predecessor | New official RFI identity and separate lifecycle |

This table is a policy crosswalk, not a final executable state-transition table. Exact pre-issue eligible states and detailed actor mapping remain open for owner/authority approval.

## 5. Withdrawal request — pre-issue only

1. The originator may submit a withdrawal request only before the formal technical response has been issued.
2. The request must identify the official RFI and current cycle, state a reason and specify whether the request concerns the entire RFI or a permitted defined scope. The default candidate is whole-RFI withdrawal; item/discipline-level partial withdrawal is not created by this specification.
3. Submitting the request does not itself withdraw, cancel, close or freeze the RFI. The existing authorized workflow continues or is held only under an independently approved rule.
4. The designated records/workflow authority validates registration, originator authority, eligibility, evidence and whether the request is within the approved scope.
5. Once substantive technical work has begun, technical-lead concurrence is required under DEC-106. Concurrence is not a substitute for the designated validating authority's decision.
6. If substantive work has not begun, DEC-106 does not impose that concurrence gate; any additional approval remains an open project authority decision and must not be invented.
7. If the formal response is issued before the withdrawal decision commits, withdrawal must not proceed. The request is recorded as ineligible/blocked and the issued response remains authoritative.
8. If the originator no longer has current authority, the request is denied or held for the proper authority; prior authorship alone is not sufficient.
9. Withdrawal request and outcome are append-only events. Rejection/denial preserves the request and rationale and leaves the RFI in its valid current lifecycle state.

## 6. Withdrawal decision gates and post-effects

Required gates:
- The RFI has a valid official identity and the target cycle is not formally issued/closed.
- No successful issue transaction has committed for the relevant response.
- Requester is the authorized originator or an explicitly appointed substitute with scoped authority.
- Reason and scope are recorded and not prohibited by project/contract policy.
- Designated records/workflow authority validates.
- Technical-lead concurrence is recorded if substantive technical work has begun.
- No conflicting cancellation, reopening or issue action has already won the concurrency race.
- All relevant assignments, contributions, clarifications and review actions are captured in the final disposition snapshot.

Upon authorized withdrawal:
- Mark only the authorized RFI/cycle disposition as Withdrawn according to the final approved lifecycle model.
- Preserve official RFI number permanently; never reuse it.
- Preserve draft/submission, assignments, contributions, dissent, reviews, evidence, response versions and action history.
- Do not delete or rewrite any prior contribution, review, evidence or notification.
- Do not infer that any technical position was accepted or rejected.
- Do not automatically cancel or revoke a separate Transmittal, recipient access, acknowledgement or response; if a formal response was already issued, withdrawal is not eligible.
- Any required notification is an independently recorded event under DEC-049/DD-12 and does not itself effect withdrawal.

## 7. Administrative cancellation — narrow purpose

Administrative cancellation is intended for evidenced registration defects such as a duplicate official registration or an invalid registration that should not have proceeded as an RFI. It is not a substitute for:
- technical rejection or disagreement;
- an unfavorable answer;
- an originator's withdrawal request;
- a late change to an issued response;
- a missed target date or lack of recipient acknowledgement;
- archival, retention expiry or deletion.

Required gates:
1. A specific administrative ground is defined by approved project policy.
2. Evidence demonstrates the ground (for example, duplicate identity mapping or registration defect).
3. The actor is the designated records/workflow authority with current scoped capability.
4. Technical-lead concurrence is recorded if technical work began.
5. Any external owner/client/contract authority concurrence required by project policy is obtained.
6. No formal response issue has occurred for the target registration; post-issue correction must use a separately approved revision/reopening/correction route, not cancellation.
7. A duplicate case identifies the surviving canonical RFI and preserves a permanent cross-reference; it must not transfer or merge history silently.

The list of permitted grounds, decision authority, external concurrence and exact eligible lifecycle states remain open. No broad “cancel for any reason” permission is proposed.

## 8. Cancellation outcome and duplicate reconciliation

- The cancelled RFI retains its official number and immutable record; it is never recycled.
- If it is a duplicate, preserve the duplicate-to-canonical relationship, decision rationale, authority and effective timestamp.
- Contributions, reviews, evidence and communications remain attached to the RFI where originally recorded. Any necessary contextual cross-reference must not imply that records were authored under the canonical RFI.
- Do not automatically copy, merge or reassign contributions, attachments, responses, Transmittals, recipient acknowledgements or access rights to the surviving RFI.
- If information must be considered in the canonical RFI, create an explicit, attributable reference or a new submission under its own authority and authorization.
- Any correction to the official register or display mapping must preserve the original identity and audit history and follow DD-06 numbering/legacy reconciliation rules.
- Cancellation does not constitute technical rejection, approval, acceptance, no-objection or closure of another RFI.

## 9. Reopening — a new cycle, not a rewrite

A formally Closed RFI may be reopened only by the designated technical authority under DEC-106.

The reopening decision must:
- Identify the official RFI identity and exact closed predecessor cycle.
- State a reason and technical scope for reopening.
- Identify new evidence, changed assumptions, discovered error, unresolved technical issue or other approved basis.
- Record the designated technical authority's active appointment and scope.
- Create a distinct new cycle under the same official RFI number; do not allocate a new number merely because the RFI is reopened.
- Preserve the prior issued response, revision/version, closure event, contributors, reviewers, evidence, timestamps and cycle metrics unchanged.
- Reassess discipline assignments, technical leadership, conflicts/dissent, independent-review triggers and issuer appointment for the new cycle.
- Identify whether the work is reopening the same question, requires a formal revision under DEC-022-A/B, or is an independent new question requiring a linked RFI under DEC-106/DD-05.
- Define how the new cycle references the previous response without presenting the old response as current approval of the new technical outcome.

Reopening is not a means to edit or retract the prior issued response. The previous cycle remains a completed historical cycle.

## 10. Reopening eligibility and blocked conditions

Candidate eligibility:
- The RFI has a valid formal issue and Closed technical state.
- The requester/initiator is authorized to propose reopening, if a request step is required by the approved project model.
- The decision-maker is the designated technical authority with current competence, appointment and delegated scope.
- Reason, technical scope, predecessor response and evidence are recorded.
- The new cycle can be uniquely identified and linked without changing the official RFI number.
- Required discipline and review appointments can be re-established.
- No unresolved authorization, integrity or record-reconciliation blocker exists.

Block or hold reopening where:
- The record is only delivered, acknowledged, archived or overdue but not technically Closed.
- The actor has only Document Control, coordinator, recipient, read-only or system-administration authority.
- The reason is solely a recipient's acknowledgement, silence or distribution failure.
- The request would silently change a different RFI or unrelated Transmittal.
- The official record or evidence integrity cannot be established.
- The requested action is actually an independent question or a formal revision that should follow a different governed route.
- The authority matrix or required appointment is missing/ambiguous.

The precise reopening request initiators, mandatory external concurrence, and eligible closure subtypes remain owner/project decisions.

## 11. Reopened-cycle scope and preservation rules

A new cycle must not silently inherit prior approvals or imply that previous work remains valid for changed content.

Reassess and explicitly record:
- Applicable disciplines and technical lead.
- New or continuing assignments and their scope.
- Prior contributions retained as historical evidence versus newly required contributions.
- Materiality of new information and whether prior conflict disposition remains applicable.
- Independent-review trigger and reviewer independence for the new candidate version.
- Issuer appointment and authority for the new cycle.
- Relevant drawings/specifications/contract baselines and evidence versions.
- Relationship to prior formal response, revision, Transmittal and recipient feedback.

Prior-cycle assignments, contribution completion, review outcomes, issue and closure are not automatically reset or rewritten. Reuse of a prior contribution/review in a new cycle requires an explicit version/scope relevance decision by the competent authority; the historical record remains unchanged.

## 12. Relationship to clarification, revision and linked new RFI

Apply DD-05 and DEC-106:
- **Clarification:** same underlying question; record a distinct clarification round linked to the same RFI/cycle and exact response where applicable.
- **Formal revision:** material change to the controlled formal response/document; use DEC-022-A/B revision control and all applicable technical review/issue gates.
- **Linked new RFI:** independent engineering question needing independent identity, lifecycle, response and closure; create a new official RFI linked to the predecessor.
- **Reopening:** a new technical cycle under the same official RFI identity after a formally Closed issue.
- **Withdrawal/cancellation:** pre-issue administrative disposition under the narrow gates above.

Classification must be made by the designated technical authority/technical lead within delegation, with reason. A coordinator or originator cannot choose a path merely to avoid the controls of another path. If classification is ambiguous, block and seek authority decision.

## 13. Transmittals, recipients and acknowledgements

- Withdrawal/cancellation before issue creates no formal issued response to distribute. Any prior administrative communication remains historical and must not be represented as a formal response.
- Reopening does not invalidate, edit or delete the prior issued response or its Transmittal.
- Prior recipient delivery, access and acknowledgement remain attached to the exact prior Transmittal, manifest and response version.
- A new formal response from the reopened cycle, once authorized and issued, requires its own controlled issue and distribution process under DEC-108; a changed package or recipient scope requires a new linked Transmittal.
- Recipient substantive feedback may be evidence considered by technical authority, but it does not itself reopen the RFI.
- Do not reset prior Required acknowledgements, delivery outcomes or recipient history because a new cycle begins.
- Do not infer that recipients must acknowledge a reopened cycle until a new controlled distribution defines the recipient-specific requirement.

## 14. Response requests, acknowledgements and external feedback

- A withdrawal or cancellation request is an internal source-workflow action request, not a recipient acknowledgement.
- A recipient acknowledgement under DD-10 cannot request or effect withdrawal, cancellation or reopening unless that person separately has the explicit capability and submits the action through the governed source workflow.
- A substantive recipient response is preserved and routed for technical classification; it is not a formal reopening decision.
- No response, non-response, failed delivery, mailbox read state, overdue indicator or expiry is a valid withdrawal/cancellation/reopening trigger by itself.
- Corrections or supplements to recipient responses preserve original submissions and cannot overwrite the formal RFI response.
- New independent questions are classified under DEC-106 and may require a linked RFI.

## 15. Authorization and separation-of-duties matrix

| Role / authority | Withdrawal request | Validate/approve withdrawal | Administrative cancellation | Reopen closed RFI |
|---|---|---|---|---|
| Originator | May request within own authorized scope | No, unless separately appointed to independent validating authority and conflict controls permit | No by originator status alone | May propose only if project rule permits; no decision authority by default |
| RFI coordinator | No by coordinator title | Only if separately designated records/workflow authority | Only if separately designated records/workflow authority | No by coordinator title |
| Technical lead | No by lead title | Required concurrence after substantive work begins; does not replace validator | Required concurrence if technical work began; does not replace cancellation authority | Only if separately designated technical authority for reopening |
| Designated records/workflow authority | No by title unless also authorized originator | Validates/decides withdrawal within explicit appointment | Decides narrow administrative cancellation within explicit appointment | No, unless separately appointed technical authority |
| Designated technical authority | No by title alone | No automatic records validation authority | No automatic records cancellation authority | May decide reopening within explicit appointment/scope |
| Document Control | No by records administration alone | No unless specifically appointed | No unless specifically appointed | No |
| Project Manager oversight | No by read access | No by read access | No by read access | No by read access |
| System/roster administrator | No | No | No | No |

This matrix is a responsibility proposal, not an actual user-role grant. The same individual may hold multiple appointments only where project governance explicitly permits the combination and separation-of-duties checks are satisfied. Self-approval, retrospective appointment and role-title inference are prohibited.

## 16. Concurrency, idempotency and atomicity gates

Reconcile with DD-07:
1. Withdrawal approval, administrative cancellation, formal issue/closure and reopening must use an authoritative version/state check at commit time.
2. If formal issue commits before a withdrawal/cancellation decision, the pre-issue action must fail as ineligible; it must not reverse or overwrite the issue.
3. If withdrawal/cancellation commits first, a competing issue transaction must fail its state/version guard and cannot issue from stale state.
4. Reopening must atomically create the new cycle identity/relationship and record the reopening event, or use a recoverable transaction design that cannot expose a partial cycle.
5. Concurrent reopening commands for the same predecessor cycle must produce one logical new cycle; duplicates return/reconcile the same outcome through idempotency controls.
6. Duplicate cancellation/withdrawal commands must not create contradictory terminal outcomes or duplicate official identities.
7. A stale actor appointment, revoked capability or changed party/project scope must be rechecked at commit time.
8. Partial failure must not leave the record both Closed and actively Reopened, both Issued and Withdrawn, or both Canonically Duplicated and independently active without an explicit governed relationship.
9. Preserve event ordering, transaction correlation, actor, authority, reason and recovery evidence. Timeout-after-success must be reconciled before retry.
10. No transaction, lock, schema, state engine or idempotency mechanism is implemented by this specification.

## 17. Records, audit and recovery

Preserve append-only history for:
- Original submission and all prior lifecycle transitions.
- Withdrawal request, validation, concurrence, approval/denial and reason.
- Cancellation ground, supporting evidence, canonical duplicate link, approval and concurrence.
- Every prior issue, response version, review, closure and cycle.
- Reopening decision, authority, reason, scope, new cycle and reassessment outcomes.
- Related Transmittals, manifests, recipient delivery/access/acknowledgement and substantive feedback.
- Notifications, audit events, authorization failures and recovery/reconciliation actions.

Archival is separate from lifecycle disposition. No withdrawal, cancellation or reopening automatically deletes, purges, changes retention, releases legal hold, revokes historical access or removes backup copies. Retention/legal hold/disposition remain subject to DD-14 and DEC-109. Any recovery must reconcile source records, event history, evidence references and external communication records before claiming completion.

## 18. Acceptance and verification catalogue

Candidate synthetic non-production tests under DEC-110:
- Originator cannot withdraw after formal response issue.
- A withdrawal request alone does not change the parent RFI lifecycle.
- Authorized withdrawal requires reason and designated validation; technical-lead concurrence is enforced after substantive work begins.
- Coordinator or Document Control cannot approve withdrawal by title alone.
- Administrative cancellation rejects engineering-merits grounds and requires an evidenced approved administrative ground.
- Cancellation after formal issue is blocked; correction follows the separately governed post-issue route.
- Duplicate cancellation identifies a canonical record without merging or reassigning historical evidence or Transmittals.
- Official RFI number is retained and never reused after withdrawal/cancellation.
- Only designated technical authority can reopen a Closed RFI.
- Reopening creates one new cycle under the same official RFI ID and preserves prior response/closure byte-for-byte or by verified immutable reference.
- Prior assignments, contributions, reviews and recipient acknowledgements remain attached to the prior cycle/version.
- New cycle reassesses discipline scope, conflicts, independent review and issuer authority.
- Clarification, formal revision, reopening and linked new RFI classification follow DD-05/DEC-106.
- Recipient feedback, silence, delivery failure, archive or overdue state cannot trigger reopening/withdrawal/cancellation.
- Concurrent issue versus withdrawal/cancellation has one valid serialized winner and no contradictory outcome.
- Duplicate/retried reopening commands do not create multiple cycles.
- Unauthorized direct API/action attempts are denied even if UI controls are hidden or disabled.
- Recovery from timeout-after-success reconciles the original action rather than duplicating it.

Unauthorized disposition, post-issue cancellation, overwritten prior response/closure, duplicate cycles, number reuse, cross-scope action or unreconciled partial state is a release blocker. These are proposed tests only; no tests are claimed as executed.

## 19. Open decisions and required reviewers

| Open decision | Required reviewers / authority |
|---|---|
| Exact lifecycle states eligible for withdrawal request/approval | Owner; technical authority; Document Control; records |
| Definition and evidence threshold for “substantive work has begun” | Owner; technical authority; project/contract authority |
| Designated records/workflow authority and delegation source | Owner; records governance; Document Control |
| Technical-lead concurrence mechanism and alternate when no lead is appointed | Owner; technical authority |
| Additional concurrence where substantive work has not begun | Owner; project/contract authority; records |
| Permitted administrative cancellation grounds beyond duplicate/invalid registration | Owner; records; contract authority |
| Exact cancellation-eligible states and external approval requirements | Owner; technical authority; records; contract authority |
| Duplicate canonicalization and legacy-number reconciliation rules | Owner; records; Document Control; DD-06 |
| Reopening initiator/request gate and designated technical authority | Owner; technical authority; project governance |
| Reopening reasons, scope granularity and any external concurrence | Owner; technical authority; contract authority |
| New-cycle assignment/review reuse criteria and reviewer independence | Technical authority; QA; security as applicable |
| Formal revision versus reopening versus linked-new-RFI decision examples | Owner; technical authority; Document Control (DD-05/DEC-022) |
| Corrective notifications and recipient handling | Owner; Document Control; security; records (DD-09/12) |
| Retention, legal hold and disposition across all cycles | Records; privacy/legal as applicable; owner (DD-14) |
| Quantitative concurrency/recovery acceptance thresholds and test ownership | QA; architecture; security; owner (DD-15) |

Unresolved eligibility, authority, scope or evidence rules remain **Blocked — Pending Authority Decision**. No default is inferred from job title, project membership, technical progress label or user-interface state.

## 19.1 DD-11 cross-specification review reference

The exact-version lifecycle review is recorded in [docs/142 — DD-11 Reopening, Withdrawal and Cancellation Cross-Specification Review](142_DD11_REOPENING_WITHDRAWAL_CANCELLATION_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md). It reconciles this gate matrix and DISP-OR01-011/012/013 against DD-01/05/07/08/09/10/14/15, DISP-OR01-014, docs/131 and docs/132. RCL-01–RCL-15 and DEP-RCL-01–DEP-RCL-15 identify the cross-specification findings and unresolved dependencies. In particular, the singular parent/current-cycle projection, substantive-work evidence threshold, exact pre-issue eligibility, post-issue correction boundary and cycle-specific recipient/records lineage remain subject to specialist/authority resolution. The review does not promote this specification or authorize lifecycle actions.

## 20. Governance alignment and implementation boundary

This working specification elaborates DEC-104/106/108/109 and aligns with DEC-021/022-A/B, DEC-103, DEC-107 and DEC-110 and DD-01/05/07–10. It does not amend approved governance, authorize a real user, define final production state vocabulary, or authorize lifecycle behavior.

**Design only:** no RFI workflow/state engine, withdrawal/cancellation/reopening action, API/UI/code, DB/schema/migration/generated types, Storage, auth/RLS/grants, notification or provider integration, production-data operation, live workflow test, backup/restore operation, merge or deployment is authorized. Any implementation requires a separately approved detailed transition/capability matrix, security and records review, test plan, non-production rehearsal and explicit owner approval. Database/Storage work remains subject to verified backups, isolated restore/rehearsal and reconciliation gates.
