# OR-01 / DISP-OR01-010 — Formal Issue and Technical Closure

**Document type:** Detailed lifecycle decision review memorandum  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — TECHNICAL RECOMMENDATIONS ONLY — OWNER DISPOSITION NOT RECORDED — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Related decisions:** DEC-103, DEC-104, DEC-105, DEC-106, DEC-107, DEC-108, DEC-109, DEC-110; DISP-OR01-004 through DISP-OR01-009; DEC-022-A/B as applicable.

> This memorandum proposes business rules for formal issue and technical closure. It does not approve the complete RFI lifecycle, appoint an issuer, define implementation transactions, or authorize implementation or testing.

## 1. Decision question and scope

DISP-OR01-010 defines the exact event by which a response becomes the official technical answer and the parent RFI becomes technically closed. It must determine:

1. What constitutes a successful formal issue and which immutable records identify it?
2. Which actor may issue, under what appointment/delegation and scope?
3. Which pre-issue and issue-time conditions must be revalidated?
4. Should formal issue and technical closure be one indivisible business outcome?
5. What is recorded when issue fails, is retried, or is attempted concurrently?
6. How are corrections, reopening, clarification, formal revision and linked new RFI handled after issue?
7. How are issue and closure kept separate from Transmittal dispatch, delivery, access, acknowledgement and substantive response?

This memorandum refines the candidate transition **Ready for Issue → Closed** in docs/72. It does not decide withdrawal/cancellation eligibility (DISP-OR01-011), reopening and post-issue new-cycle mechanics (DISP-OR01-013), or the complete lifecycle vocabulary.

## 2. Protected governance and prior owner dispositions

1. **DEC-104/105:** the formal technical response is issued only by the specifically authorized technical authority/issuer within evidenced scope. A coordinator, technical lead, independent reviewer, Document Control officer, project manager or system administrator does not acquire issue authority merely from title, membership, visibility or workflow activity.
2. **DEC-106:** preferred closure is automatic with successful formal issue once required contributions, conflicts and reviews are complete. A separate closure event is possible only under an explicit authorized rule; no default SLA, deemed acceptance or contractual consequence is created.
3. **DEC-107:** official RFI ID, formal revision, response version and evidence/file identifiers are distinct and stable. Issued evidence must retain immutable identity and traceable version lineage.
4. **DEC-108:** Document Control distributes the already authorized formal response through controlled Transmittal for formal external distribution. Distribution is not technical issue authority.
5. **DEC-103/108:** recipient-level delivery, access, acknowledgement and substantive response are independent events. None is a precondition for technical issue or closure unless a separate approved rule expressly says otherwise; no such rule is created here.
6. **DEC-109:** workload, overdue, notification, archive and reporting indicators do not create technical issue or closure.
7. **DEC-110:** acceptance evidence must trace requirement, decision, exact version, authority, result and evidence. This memo proposes testable criteria but executes no tests.
8. **DISP-OR01-004–009:** current appointments/assignments, required contribution completion, clarification blockers, conflict disposition, applicable exact-version independent review and Ready for Issue evidence must remain valid at the moment of issue. A readiness record is not itself issue authority.

## 3. Proposed meaning of formal issue

Formal issue is the attributable act of the currently appointed technical issuer that adopts one exact, complete and authorized response candidate as the official response for the specified RFI identity and formal revision/cycle.

A successful issue must create an immutable issue record that identifies at minimum:
- project and official RFI ID;
- formal revision/cycle and response version;
- exact candidate ID and frozen package manifest/version;
- exact contribution, attachment and supporting evidence versions relied upon;
- readiness confirmation record and any applicable independent-review outcome/version;
- issuer identity, appointment/delegation reference, authority scope and decision timestamp;
- formal response content/reference, issue sequence/identity and immutable integrity/lineage reference;
- parent lifecycle precondition and resulting technical closure record;
- any approved limitations, reservations, dissent or non-blocking observations included in the formal response.

The issue record must make clear which response is authoritative. Drafts, previews, readiness confirmations, review outcomes, notifications, Transmittals and recipient acknowledgements are not substitutes for this record.

## 4. Formal issuer authority and separation of duties

### 4.1 Issuer

The issuer must have a current, attributable appointment/delegation that expressly covers the project, party, discipline/technical scope, RFI class and issue action. Authority is checked at action time. Expired, revoked, disputed, out-of-scope or ambiguous authority causes a hold.

The issuer may be the same person as a readiness confirmer only if the formally approved appointment and separation-of-duties rules permit that combination. This memorandum does not impose dual signatures or require two different people by default. Where an approved risk/authority matrix requires independent separation, it must be enforced.

### 4.2 Roles that do not issue

- Technical lead: prepares/consolidates and confirms technical work within appointment; does not issue unless separately appointed as issuer.
- Independent reviewer: clears only the exact review scope/version; review clearance is not issue authorization.
- RFI coordinator: administrative routing and completeness only.
- Document Control: records administration and distribution of an already issued response; cannot create technical approval or issue.
- Project Manager oversight: read-only oversight remains read-only unless a separate explicit technical appointment grants a distinct capability.
- System/roster administrator: technical administration does not create engineering authority.

## 5. Mandatory issue-time gate

Immediately before formal issue, the system/process must revalidate all applicable conditions against current authoritative records:

**A. Parent and cycle integrity**
- Parent RFI is in Ready for Issue for the same active cycle/revision.
- No withdrawal, cancellation, reopening, supersession, competing issue or other incompatible transition has succeeded.
- Official RFI identity and formal revision are valid and not duplicated or reused.

**B. Current authority**
- Issuer appointment/delegation remains active and covers this exact action and scope.
- Required technical authority, discipline assignments and scope evidence remain current.
- No appointment revocation, conflict, expiry or unresolved authority dispute is present.

**C. Technical completeness**
- Every required contribution remains complete and technically confirmed, or its removal from scope is supported by a valid authorized scope change.
- No valid parent-progression clarification blocker remains open.
- No unresolved material technical conflict, blocking dissent, mandatory condition or issue-preventing assumption remains.
- The formal response accurately reflects the disposition of material cross-discipline inputs and dissent.

**D. Review and readiness**
- The readiness confirmation is valid for this exact response candidate and package manifest.
- Where independent review is mandatory, the approved matrix and trigger determination remain valid, and the passing outcome applies to the exact unchanged version.
- Blocking review comments are closed with evidence; any conditional clearance is usable only where expressly permitted and all pre-issue conditions are objectively closed.
- No changed/stale candidate inherits an earlier readiness or review clearance.

**E. Exact package and record integrity**
- Formal response, attachments, references, contribution versions and evidence match the frozen issue package exactly.
- No mutable or unversioned evidence is substituted.
- Required issue metadata, revision and response identifiers are complete and distinct.
- Authorization to access and issue each relevant record is valid at action time.

If any check is false, incomplete, stale, disputed or unavailable, issue must be held. A prior Ready for Issue state or visible badge does not override a failed current check.

## 6. Recommended issue-and-closure relationship

### 6.1 Preferred model: one atomic business outcome

Recommend that **successful formal issue and technical closure of the same parent RFI cycle occur as one indivisible business outcome**:

- If the issue operation succeeds, the exact response version becomes officially issued and the parent cycle becomes Closed with linked closure evidence.
- If the operation fails before successful commit, neither an official issue nor technical closure is recorded as successful.
- No externally visible state may say “issued” while the parent remains technically open due solely to a partial issue/closure write, or say “Closed” when no valid formal issue exists.
- The issue record and closure record are distinct evidence objects/identities but must refer to one successful issue outcome and exact response version.

This recommendation follows DEC-106's preferred automatic closure with formal issue. The exact storage/transaction mechanism is not selected here.

### 6.2 Separate evidence, not separate discretionary business decisions

Issue and closure evidence should remain separately identifiable for audit and reporting, but the recommended model does not require a second discretionary approval, second person, or later manual closure action after a successful issue.

A separate closure event after issue should be allowed only if the owner approves a clearly defined exception path with:
- specific eligibility and reason;
- separately appointed closure authority;
- objective closure conditions and evidence;
- preserved issued response and no ability to rewrite its content;
- explicit handling of the interim issued-but-not-closed condition;
- concurrency, recovery, audit and reporting safeguards.

No such exception is presumed by this memo. The owner must decide whether to retain the atomic default and whether any narrow exception is needed.

## 7. Failure, retry, duplicate and concurrency handling

### 7.1 Failed attempt

A failed attempt must not:
- create a successful formal issue record;
- move the parent to Closed;
- partially publish the response as authoritative;
- consume or silently change the official RFI identity or formal revision;
- erase the failed attempt or its diagnostic evidence.

The system/process should preserve an attributable failed-attempt record with actor, time, candidate/version, failed gate or outcome, correlation/idempotency reference and safe diagnostic evidence. Failed attempts remain non-authoritative.

### 7.2 Retry

A retry may proceed only after the failure cause is understood and all issue-time gates are re-evaluated. Retrying the same logical issue request must not create duplicate issue records or closure events. A materially changed response is a new candidate/version and must pass the applicable readiness/review gates again; it is not a retry of the same frozen package.

### 7.3 Concurrent actions

Competing issue attempts, response edits, scope changes, new blockers, reviewer comments, appointment revocation, withdrawal/reopening requests or parent-state changes must not allow stale issue authority or candidate content to commit.

Only one valid issue outcome may be authoritative for a given active RFI cycle/revision. Conflicting or stale actions must fail closed and retain attributable history. Detailed locking, compare-and-set, idempotency and transaction/recovery techniques require architecture, security and QA validation; none is prescribed as implementation here.

## 8. Post-issue integrity and correction routes

After successful formal issue:
- The issued response, exact package, issue identity, closure evidence and related history are immutable historical records.
- No user may edit or replace the issued answer in place.
- A genuine clarification, formal revision, independent new question or post-issue technical reassessment must use its separately governed route under DEC-022-A/B, DEC-106 and the relevant owner dispositions.
- Reopening, where authorized, creates a new active response cycle and preserves the prior issued response and closure; it does not erase or retroactively unissue the prior version.
- A correction to clerical metadata must be separately attributable and must not silently alter technical content, issued package or historical issue evidence.
- Any replacement or successor response must clearly identify its predecessor and supersession relationship where applicable.

Detailed reopening authority, triggers and return state remain for DISP-OR01-013. This memo does not approve those details.

## 9. Formal issue versus Transmittal and recipient events

The event boundaries must remain explicit:

| Event | Meaning | Does not mean |
|---|---|---|
| Ready for Issue | Pre-issue readiness gate passed for exact candidate/version | Officially issued or closed |
| Formal issue | Authorized technical issuer adopts exact response as official | Delivered to recipients or acknowledged |
| Technical closure | Parent technical cycle is closed as part of successful issue outcome under recommended atomic model | All recipients received/read/accepted |
| Transmittal creation/dispatch | Document Control prepares and sends controlled external distribution package | Technical issue authority or approval |
| Delivery | Technical delivery result per recipient | Access, acknowledgement or agreement |
| Access/view | Recipient access event | Acknowledgement or acceptance |
| Acknowledgement | Explicit recipient acknowledgement under required/optional rules | Technical approval or substantive agreement |
| Substantive response | Recipient's separate response event | Reopening or changing issued technical answer automatically |

A failed Transmittal or unacknowledged recipient does not roll back a successful formal issue or technical closure. Conversely, successful delivery, access, acknowledgement or silence cannot create a formal issue or close a parent RFI.

The internal availability of an issued response, where authorized, remains separate from formal external distribution and must not bypass controlled recipient access rules.

## 10. Records, evidence and audit

Preserve an append-only attributable sequence for:
- readiness confirmation and its exact package manifest;
- final issue-time gate result and authority snapshot;
- issue request/attempt, success/failure and idempotency/correlation identity;
- immutable issued response and evidence package;
- technical closure result and link to issue record;
- any post-issue correction, clarification, revision, reopening or successor cycle;
- subsequent Transmittal and recipient-level delivery/access/acknowledgement/substantive-response events.

Access to issue records, attachments, audit evidence and history remains subject to server-side authorization for project, party, discipline and appointment scope. Retention, legal hold, archival tier and disposition remain governed by the separate records workstream; no periods or deletion defaults are invented.

## 11. Proposed acceptance criteria for later test design

These are proposed design-level criteria only; no tests have been executed.

1. Unauthorized, expired, revoked, disputed or out-of-scope issuer cannot issue or close.
2. Coordinator, reviewer, Document Control, roster administrator or oversight-only actor cannot issue without a separate valid appointment.
3. Issue is blocked if parent is not Ready for Issue for the current cycle/revision.
4. Issue is blocked for incomplete required contribution, open parent blocker, unresolved material conflict, missing required evidence or failed mandatory review.
5. A stale readiness/review outcome or changed package cannot be reused for issue.
6. Successful issue records exact response/package/version and closes the same parent cycle with linked closure evidence.
7. Failed issue leaves neither successful issue nor Closed state.
8. Retry of the same logical issue request cannot duplicate issue or closure.
9. Concurrent issue attempts yield at most one authoritative successful issue for the active cycle/revision.
10. Concurrent candidate/scope/authority/blocker changes cannot be bypassed by stale issue action.
11. A failed Transmittal, undelivered recipient, unviewed response or missing acknowledgement does not roll back technical issue/closure.
12. Delivery, access, acknowledgement and substantive response remain separate events and cannot create issue/closure.
13. Post-issue technical change follows an authorized successor route and preserves the original issued response/closure.
14. Audit history identifies actor, authority, exact version, evidence, result, time and correlation identity.

These criteria must be reconciled with the actual DEC-110 scenario catalogue and specialist test governance before execution. They do not establish that any existing AT-RFI/E2E scenario has passed.

## 12. Specialist validation requested

| Specialist | Required validation |
|---|---|
| Project/process owner | Meaning of formal issue and technical closure; atomic default; any narrow separate-closure exception |
| Appointed technical authority / issuer governance | Issuer competence, appointment/delegation, scope and issue-time decision authority |
| Discipline authorities / technical lead | Contribution completion, conflict/dissent, assumptions, technical response and evidence adequacy |
| Independent reviewer / QA | Exact-version review validity, blocking comments, conditional clearance and separation-of-duties triggers |
| Document Control / records | Formal issue record, immutable response identity, Transmittal handoff, corrections and audit/records evidence |
| Architecture | Atomic issue/closure outcome, transaction integrity, idempotency, concurrency, stale-state and recovery |
| Security / privacy | Action-time authorization, least privilege, revocation, evidence access and audit integrity |
| Legal / contract / project governance as applicable | Whether any project-specific issue/notice effect or exception is authorized; no legal or contractual effect is inferred here |

These are review domains, not appointments or completed sign-offs.

## 13. Owner decision points

1. Confirm the definition of formal issue as the authorized adoption of one exact response version as the official technical response.
2. Confirm the issuer must hold a current evidenced appointment/delegation for the exact project/party/discipline/RFI scope and action.
3. Confirm the full issue-time revalidation gate in §5, including parent/cycle, authority, technical completeness, blocker/conflict, exact-version review/readiness and evidence integrity.
4. Approve the preferred **atomic issue-and-technical-closure business outcome**: successful issue and closure succeed together; failure leaves neither successful issue nor Closed.
5. Confirm issue and closure retain distinct linked evidence identities without a second discretionary approval or default dual-signature.
6. Decide whether any narrow separately authorized post-issue closure exception is needed; if yes, define its eligibility, authority, evidence and interim-state safeguards before use.
7. Approve failed-attempt, retry, idempotency, duplicate and concurrency safeguards as business outcomes.
8. Confirm issued response and closure history are immutable; post-issue changes follow authorized clarification/revision/reopening/new-RFI routes.
9. Preserve the separation between technical issue/closure and Transmittal, delivery, access, acknowledgement and substantive response.
10. Confirm no delivery, access, acknowledgement, silence or recipient response can roll back or create technical issue/closure.

## 14. Recommended interim controls

Until owner disposition and specialist validation are complete:

- No formal issue by any actor without a current, evidenced, scope-specific technical issuer appointment.
- No issue from a state other than Ready for Issue for the exact active cycle and response version.
- Revalidate all authority, scope, assignment, contribution, clarification, conflict, review, readiness, package and evidence guards at issue time.
- Treat issue and closure as one business outcome; never expose partial success or infer Closed without a successful formal issue.
- Failed attempts remain non-authoritative and attributable; retry must be idempotent and revalidated.
- Never allow a stale candidate, readiness confirmation, review clearance or revoked appointment to authorize issue.
- Keep Transmittal, delivery, access, acknowledgement and substantive response outside the issue/closure gate.
- Preserve issued content and history; route post-issue changes through separately authorized processes.

## 15. Explicit exclusions and open decisions

This memorandum does not approve a database transaction design, locking/idempotency implementation, issue numbering format, electronic signature method, legal/contractual notice effect, final exception taxonomy, named issuer appointment, role/capability grants, final lifecycle state machine, retention schedule, post-issue reopening mechanics or a separate closure route. It does not amend DEC-103–DEC-110 or DEC-022-A/B, appoint actors, grant capabilities, create SLA/deemed acceptance, authorize implementation, test execution, DB/schema/migration/generated-type changes, Storage, authentication, authorization/RLS/grants, production-data operations, backup/restore, merge, deployment or release.

## 16. Technical recommendation summary

Adopt formal issue as an authorized, immutable, exact-version technical decision by a specifically appointed issuer, subject to full action-time revalidation. Prefer one atomic business outcome in which successful formal issue and technical closure of the same active RFI cycle are committed together; a failed attempt produces neither successful issue nor Closed. Preserve distinct linked issue/closure evidence, idempotent retries, concurrency/stale-state safeguards and immutable post-issue history. Keep Transmittal distribution and all recipient events independent. Do not allow delivery, access, acknowledgement or silence to create or reverse issue/closure.

## 17. Owner disposition

**Disposition status:** Not recorded.  
**Owner decision date:** Not recorded.  
**Decision evidence:** No owner disposition has been supplied for DISP-OR01-010.

No approval is inferred. Specialist validation remains pending.

---
**End of working draft — technical recommendation only; owner disposition and specialist validation pending.**
