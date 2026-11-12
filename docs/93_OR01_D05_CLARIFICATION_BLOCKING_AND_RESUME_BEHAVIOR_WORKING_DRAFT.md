# OR-01 / DISP-OR01-005 — Clarification Blocking and Resume Behavior

**Document type:** Detailed lifecycle decision review memorandum  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — OWNER DISPOSITION CONDITIONALLY APPROVED FOR THE RECORDED SCOPE — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Source detailed specification:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`, §§3.2–3.5 and §§4.1–4.6  
**Related owner dispositions:** DISP-OR01-003 (Option C) and DISP-OR01-004 (two-key hand-off / complete required-assignment gate)  
**Controlling governance:** DEC-104, DEC-105, DEC-106, DEC-107, DEC-109, DEC-110; DEC-022-A/B where a response changes controlled content

> This memorandum proposes clarification request, response, blocking, aggregation and resume semantics. It does not authorize workflow implementation, define an SLA, or convert clarification into formal revision, a linked new RFI, technical acceptance or external acknowledgement.

## 1. Decision question and scope

DISP-OR01-005 asks:
1. Which clarification requests block technical progress and which remain non-blocking?
2. How should multiple simultaneous requests be represented and aggregated at parent RFI level?
3. What happens when the originator responds partially, late, ambiguously or more than once?
4. Who determines whether the response satisfies the request and who may close the clarification?
5. Which exact parent stage and subordinate work must resume after all blocking requests are resolved?

The decision covers clarification of the original RFI question within the same official RFI identity. A genuinely independent engineering question remains a linked new RFI; a material change to controlled content is classified under DEC-022-A/B; neither is silently treated as clarification.

## 2. Protected constraints

1. **DEC-106:** clarification continues the original question in the same RFI; a separate question creates a linked new RFI; material controlled-content change follows formal revision classification; issued formal responses are not silently edited.
2. **DEC-105:** only an authorized technical participant may raise/validate technical clarification within active assignment and scope. The originator supplies information; the coordinator performs only administrative handling and does not decide technical sufficiency.
3. **DEC-107:** preserve the official RFI number and submitted evidence identity. A clarification request/round/response has its own identity and does not allocate or replace the official RFI number.
4. **DEC-109:** no default SLA, clock pause, overdue trigger, notification cadence, escalation or contractual consequence is created.
5. **DEC-110:** concurrent requests, partial and duplicate responses, unauthorized actions, stale state, evidence/history and recovery require explicit verifiable outcomes. No test is claimed executed.
6. **DISP-OR01-003 / Option C:** administrative return after technical assessment begins cannot be used as a shortcut to reset the parent lifecycle when a clarification is technically required.
7. **DISP-OR01-004:** clarification must not bypass the complete-assignment gate or transfer technical authority to the coordinator.

## 3. Terminology and separate records

For owner consideration, use the following distinctions:

- **Clarification request:** a uniquely identified, attributable request for information/explanation needed to understand or assess the original RFI question.
- **Clarification response:** an immutable, attributable originator submission answering one or more specifically identified requests.
- **Blocking request:** a clarification request explicitly determined by an authorized technical actor to prevent specified technical work or a defined parent-level progression gate until adequate information is received and validated.
- **Non-blocking request:** a clarification request whose absence does not prevent the affected technical work or the next authorized parent-stage gate; it must not be treated as a hidden blocker.
- **Affected work scope:** the discipline assignment, contribution, technical decision, response candidate or parent progression gate that depends on the requested information.
- **Parent resume point:** the exact parent lifecycle state recorded immediately before the first active blocking request caused entry into Awaiting Originator Clarification.

Clarification requests, responses, discipline contributions, assignments, parent lifecycle events and recipient communication events remain separate records. Do not collapse them into one mutable flag or overwrite the original request when a response arrives.

## 4. Recommended blocking model — explicit, scoped and dependency-based

**Recommended direction:** a clarification request is not automatically blocking merely because it exists. It becomes blocking only when an authorized technical actor explicitly records why the missing information prevents identified work or a defined progression gate.

A valid blocking determination should include:
- request ID and official RFI/cycle reference;
- exact question and requested information, phrased so the originator can answer;
- requesting actor, active appointment, discipline and assignment scope;
- technical reason and dependency explaining why the missing information blocks work;
- affected discipline/contribution(s), response candidate or parent progression gate;
- blocking classification and its scope;
- date/time, evidence references and current request version;
- the technical authority responsible for adequacy determination.

A discipline responder may request clarification within their assigned scope. The technical lead may coordinate and determine cross-discipline impact only within explicit appointment. A parent-level block that affects the lifecycle gate should be confirmed by the appointed technical lead or technical authority under the project's approved delegation. If authority or impact is unclear, the item remains pending technical determination; the coordinator must not classify it.

### 4.1 Blocking versus non-blocking

| Case | Recommended classification | Effect |
|---|---|---|
| Missing information makes a discipline's engineering assessment unsafe or materially incomplete | Blocking for that discipline contribution | Affected contribution cannot be completed; unrelated authorized work may continue |
| Missing information prevents a required technical decision, conflict resolution or progression to the next parent gate | Parent-progression blocking | Parent enters Awaiting Originator Clarification; no transition past the blocked gate |
| Information is useful context but does not prevent the affected work or next gate | Non-blocking | Record and track separately; no parent lifecycle transition |
| Request duplicates information already supplied or has no clear dependency | Not a valid blocker until corrected/validated | Do not suspend parent by default |
| The question is outside the original RFI or materially changes controlled content | Not clarification under this model | Route to linked new RFI or formal revision classification as applicable |

**Recommended parent aggregation rule:** the parent enters **Awaiting Originator Clarification** when at least one valid, open, explicitly parent-progression-blocking request exists. A discipline-only blocker may block that contribution while the parent remains **In Technical Assessment**, allowing independent, authorized, non-dependent disciplines to continue. However, the parent must not pass a gate that depends on the blocked contribution. If the existing state vocabulary cannot represent this distinction safely, use the parent Awaiting state conservatively and record the unaffected subordinate work separately.

This is a proposed policy choice; specialist validation must confirm that the project process can distinguish contribution-level and parent-progression blockers without misleading dashboards or allowing premature consolidation.

## 5. Parent lifecycle entry and exact resume point

The candidate parent state **Awaiting Originator Clarification** should be used only when a valid blocking request prevents parent progression. It is not a generic status for every question, message or outstanding response.

Recommended sequence:

1. Record the current parent lifecycle state and its version immediately before the first parent-progression-blocking request.
2. Validate the requesting actor's authority, scope and evidence at action time.
3. Create the immutable clarification request and its affected-work/dependency links.
4. If it is parent-progression-blocking, transition the parent to **Awaiting Originator Clarification**, recording the exact prior state as the resume point.
5. If it is contribution-only blocking, retain the parent state and mark only the affected contribution/assignment as awaiting clarification.
6. Additional requests created while the parent is already Awaiting are attached to the same active clarification episode and each retains its own scope and evidence. They do not overwrite the original resume point.
7. The parent cannot progress through a gate that depends on any open blocking request.
8. Once all parent-progression blockers are validly resolved, resume the exact recorded parent state, provided its other guards and current assignments still remain valid.
9. Preserve all request/response/resolution events and the previous parent state. Do not restart the RFI, allocate a new number or erase completed contributions.

### 5.1 Exact prior stage

The recommended resume point is the exact parent state recorded when the first open parent-progression blocker caused the transition to Awaiting Originator Clarification, not a generic default to In Technical Assessment.

- If the request arose during **In Technical Assessment**, resume that state.
- If a future approved process permits a blocking clarification during **Under Consolidation**, preserve and resume Under Consolidation only if the technical lead confirms that the consolidation context and candidate remain valid; otherwise route the affected work back through an explicitly authorized transition.
- If the request arises during independent review or after a response candidate has been frozen, distinguish a reviewer change request/rework from an originator clarification. Do not automatically reuse the clarification transition.
- No clarification transition is permitted after formal issue as a silent edit to the issued answer. Use the applicable post-issue clarification/new RFI/reopening governance.

The detailed allowed source states and any exception for Under Consolidation require owner and specialist confirmation.

## 6. Multiple concurrent clarification requests

**Recommended model:** maintain an independent record for each request and aggregate only the active blockers.

Each request should have:
- unique request ID and request version;
- exact RFI identity, active cycle, relevant revision and submitted evidence references;
- requester and appointment/scope evidence;
- affected discipline, contribution and technical decision;
- explicit blocker type (contribution-only or parent-progression);
- exact dependency and reason;
- originator response(s), each immutable and linked to the request;
- technical sufficiency outcome and authorized actor;
- status history and closure/supersession reason.

Aggregation rules:
1. One open parent-progression blocker is sufficient to keep the parent in Awaiting Originator Clarification.
2. Closing one request does not resume the parent while another parent-progression blocker remains open.
3. A contribution-only blocker does not automatically block unrelated assignments.
4. A request may affect multiple disciplines, but the affected scope must be explicit; do not infer global scope.
5. The same response may answer multiple requests only when each request is explicitly referenced and a competent technical actor validates the response against each one independently.
6. Parent resume occurs once, when the set of parent-progression blockers becomes empty and the stored resume point remains valid.
7. Repeated, concurrent or out-of-order responses must not duplicate closure events or overwrite earlier response evidence.

No single boolean such as `clarification_pending` is sufficient as the authoritative record; any summary indicator must be derived from the request set.

## 7. Originator response, partial response and adequacy

1. The originator submits a response against one or more exact request IDs. The response is recorded as a new immutable event/evidence version.
2. A response may be partial. It must be mapped to the requests and sub-questions it addresses; unanswered items remain open.
3. Receipt or upload of a response does not itself resolve a clarification request or resume the parent.
4. The authorized requesting technical actor or designated technical authority evaluates sufficiency within the affected technical scope. The coordinator may verify administrative receipt only.
5. If adequate, the authorized technical actor records the request as Responded/Resolved (candidate subordinate labels) with a reason and evidence reference.
6. If incomplete, ambiguous or technically insufficient, the technical actor records the remaining gap and either keeps the same request open with an attributable follow-up round or creates a separately linked clarification request where the question materially changes. The exact policy for same-request follow-up versus new linked request requires owner confirmation.
7. If the response reveals a material change to controlled content, classify under DEC-022-A/B before treating it as a clarification response. If it is an independent question, create a linked new RFI under DEC-106.
8. An originator response does not imply acceptance of the eventual technical answer, waive objections, satisfy recipient acknowledgement, or constitute a contractual notice.

## 8. Correction, withdrawal and supersession of clarification requests

Recommended safeguards:
- A requester may correct an obvious clerical defect only through an attributable, versioned correction that preserves the prior request.
- A technically invalid or no-longer-needed request may be withdrawn/superseded only by an actor with authority over the originating technical scope, with a recorded reason and affected-work impact.
- The coordinator cannot withdraw a technical blocker or declare it resolved.
- A response already received remains in history even if the request is corrected, withdrawn or superseded.
- Supersession must identify the successor request and preserve the relationship; it must not silently delete the original.
- If a blocker is removed, reassess all remaining blockers and parent progression guards before resuming.
- The exact eligibility and authority for request withdrawal/correction remain subject to owner and specialist validation.

## 9. Resume guard and integrity contract

When all blocking requests are resolved, the system should not blindly restore a stale state. Before resumption, verify:
- no other open parent-progression blocker remains;
- the exact stored resume state is still a valid state for the current RFI cycle;
- the current actor/authority is permitted to execute the resume transition;
- affected assignments and technical appointments remain current;
- response evidence and its version are linked to the correct request(s);
- any changed controlled content has been classified under DEC-022-A/B;
- no concurrent transition, withdrawal, cancellation, reopening or supersession has made the stored resume point stale;
- the current parent state/version still matches the expected Awaiting state and episode.

If any guard fails, do not auto-resume. Preserve the record in a controlled pending/exception condition and refer to the designated technical authority. No automatic rollback, new cycle or parent closure is inferred.

The clarification response and resolution records should commit with attributable history. Concurrent resolution of multiple blockers must produce one coherent parent resume event, not duplicate or conflicting state changes. The exact transaction, lock, idempotency and event implementation remains for architecture review.

## 10. Roles and authority boundaries

| Actor | Recommended permitted action | Must not infer |
|---|---|---|
| Assigned discipline responder | Raise a clarification request within active assignment; identify affected contribution and technical dependency; evaluate response within delegated scope | Cannot block unrelated disciplines or close parent RFI without authority |
| Technical lead | Coordinate cross-discipline dependencies, validate parent-progression impact, assess whether all blockers are cleared and recommend/perform authorized resume | Cannot erase discipline dissent or exceed appointment |
| Technical authority | Decide unresolved scope/impact/adequacy questions within appointment; authorize exceptions and technical disposition | Appointment must be evidenced and scoped |
| Originator | Provide information against exact request IDs and evidence references | Response upload is not technical acceptance or automatic resolution |
| Coordinator / Document Control | Administrative receipt, routing and records support within explicit delegation | Cannot decide technical adequacy, change blocker classification or resume technical work |
| Security / platform authorization | Enforce exact project/party/RFI/assignment/request scope server-side | UI visibility, membership or notification does not grant authority |

## 11. Failure and edge-case outcomes

| Scenario | Recommended outcome | Prohibited outcome |
|---|---|---|
| Two blocking requests are open; only one is answered adequately | Keep parent Awaiting; preserve the resolved request and open blocker | Resume when first response arrives |
| One request has three sub-questions; only two are answered | Keep unresolved sub-question open; record partial response | Mark whole request resolved automatically |
| Contribution-only blocker affects MEC while ARC and CIV work are independent | Block affected contribution; permit unrelated authorized work to continue if dependencies allow | Freeze all work by default or ignore blocked contribution at readiness |
| Parent-level blocker is open but non-dependent work continues | Keep parent Awaiting; track allowed subordinate work independently | Change parent back to assessment merely because some work continues |
| Response uploaded but no technical sufficiency review | Keep request open/awaiting validation | Treat upload/receipt as resolution |
| Response is ambiguous or insufficient | Record gap and keep blocker open or create linked follow-up under approved rule | Silently close or overwrite request |
| Request is duplicated | Link/mark duplicate with reason; preserve both identities/history as governed | Delete one request or lose evidence |
| Request is withdrawn by coordinator without technical authority | Deny; preserve current request/blocker | Remove parent blocker |
| Response arrives after request superseded | Preserve response; route to authorized technical actor to classify against successor/current scope | Apply it automatically to successor |
| Parent has two blockers resolved concurrently | One idempotent parent resume after all guards pass | Duplicate resume transitions or conflicting resume states |
| Stored resume point is stale due to another authorized lifecycle event | Do not auto-resume; technical authority resolves next valid stage | Force restore old state |
| Response changes controlled content materially | Apply DEC-022-A/B formal revision classification | Treat material revision as clarification |
| New independent question appears | Create linked new RFI | Add it as unrelated sub-question in same RFI |
| Formal response has already been issued | Preserve issued version; use approved post-issue path | Edit issued answer in place |
| Notification/delivery fails | Keep technical request/resolution state separate from communication status | Treat delivery failure as request rejection or parent-state change |

These are proposed design outcomes and test scenarios, not executed or passed tests.

## 12. Owner decisions required

The owner should decide the following separately; approval of the general approach must not silently settle unresolved details:

1. **Blocking criterion:** approve explicit technical dependency-based classification rather than treating every clarification request as blocking?
2. **Contribution-only blockers:** may unaffected disciplines continue while one contribution awaits clarification, subject to no dependent gate being passed?
3. **Parent aggregation:** should one open parent-progression blocker place the parent in Awaiting Originator Clarification, with resume only after all such blockers are resolved?
4. **Source stages:** may a parent-level clarification be raised from In Technical Assessment only, or also from Under Consolidation under a controlled rule?
5. **Resume point:** approve exact restoration of the parent state recorded before the first active parent-level blocker, subject to current guards?
6. **Partial responses:** require explicit technical sufficiency review per request/sub-question; receipt alone never resolves?
7. **Follow-up model:** may an insufficient response keep the same request open with a new response round, or must a materially changed question create a linked new clarification request?
8. **Correction/withdrawal:** who may correct, withdraw or supersede a clarification request, and what approval/concurrence is required?
9. **Cross-discipline requests:** who confirms parent-level impact where multiple disciplines are affected or disagree?
10. **Post-issue path:** confirm that no clarification can silently modify an issued response and that post-issue handling remains governed separately.

## 13. Specialist validation requested

| Domain | Validation question | Evidence expected |
|---|---|---|
| Technical authority / technical lead | Are blocking dependencies, affected scopes and adequacy checks practical for single- and multi-discipline RFIs? | Reviewed examples and documented authority boundary |
| Discipline specialists | Can independent work continue safely while another contribution is blocked? | Representative cross-discipline scenarios and dissent where applicable |
| Project/process owner | Is parent Awaiting state reserved for true progression blockers? | Process disposition and approved exception path |
| Document Control | Can request, response and correction histories be maintained without administrative closure of technical blockers? | Reviewed records/events catalogue |
| Architecture | Can concurrent requests, partial responses, idempotent resolution and exact resume state be represented without lost updates? | Architecture integrity review |
| Security | Are request creation, response, sufficiency determination, withdrawal and resume separately authorized at action time? | Positive/negative authorization review |
| QA | Are aggregation, concurrency, partial response, stale resume and post-issue negative cases testable? | Test-design traceability; no execution implied |
| Records | Are each request, response, supersession and parent transition attributable and retained under approved records rules? | Records classification; no retention period invented |

These are review domains, not named appointments or completed sign-offs.

## 14. Cross-specification dependencies and implementation boundary

This memorandum must reconcile with:
- **DISP-OR01-001:** Awaiting Originator Clarification remains a candidate official lifecycle label under controlled refinement; this memo does not approve the entire lifecycle vocabulary.
- **DISP-OR01-003 / Option C:** technical clarification must not be confused with administrative return or used to reset the parent state after assessment begins.
- **DISP-OR01-004:** only valid technical authority determines technical scope and blocking impact; coordinator remains administrative; the complete assignment gate remains intact.
- **DEC-106:** clarification versus linked new RFI, withdrawal/cancellation/reopening and closure remain distinct.
- **DEC-107:** official identity and submitted evidence are preserved.
- **DEC-109:** no default SLA, pause clock, overdue or notification cadence.
- **DEC-110:** verification design must cover authorization, concurrency, evidence/history and recovery.

This memorandum does not amend DEC-103–DEC-110 or DEC-022-A/B; approve final lifecycle vocabulary; appoint actors; create capabilities; define deadlines or contractual effects; implement workflow/UI/API/code; change DB/schema/migrations/generated types, Storage, authentication, authorization/RLS/grants or production data; execute tests; perform backup/restore; merge, deploy or release.

## 15. Technical recommendation summary

**Recommended baseline for owner consideration:**
1. A clarification request is blocking only when an authorized technical actor explicitly records a reasoned dependency and affected scope.
2. Distinguish contribution-only blockers from parent-progression blockers. Permit unaffected work to continue only where it is genuinely independent and no blocked gate is bypassed.
3. Parent enters Awaiting Originator Clarification when at least one valid parent-progression blocker is open; it resumes only when every such blocker is resolved.
4. Preserve each request and response independently. Partial response or receipt alone never closes a request.
5. Resume the exact parent state recorded before the first parent-level blocker, subject to current authorization, assignments, evidence and lifecycle guards.
6. Keep clarification distinct from formal revision, linked new RFI, administrative return, review rework, recipient acknowledgement and post-issue correction.
7. Keep the coordinator administrative; technical actors decide blocking, adequacy and resolution.

## 16. Owner disposition — Revision 1

**Disposition status:** **Conditionally approved**  
**Decision date:** 2026-11-12  
**Decision evidence:** The project owner explicitly stated: “اعتمد” in response to the five recommended principles in this memorandum.

### 16.1 Accepted scope

The owner conditionally approves the five principles in §15:

1. A clarification blocks only when an authorized technical actor records a reasoned technical dependency and affected scope; a clarification request is not automatically blocking merely because it exists.
2. A contribution-only blocker stops only the affected contribution. Other disciplines may continue only where their work is independent, authorized and does not bypass a dependent gate.
3. The parent enters Awaiting Originator Clarification when at least one valid parent-progression blocker is open, and cannot progress past the affected gate while any such blocker remains unresolved.
4. Each request and response is separately preserved. Partial response or mere receipt does not resolve a request; technical sufficiency must be validated by the authorized technical actor.
5. Once all parent-progression blockers are resolved, the parent may resume the exact prior parent state recorded before the first parent-level blocker, subject to current authority, assignment, evidence, lifecycle and concurrency guards.

### 16.2 Conditions and limits

- Specialist validation remains required from process owner, technical authority/lead, discipline specialists, architecture, security, Document Control, QA and records as applicable. No specialist sign-off is claimed.
- Exact source states, cross-discipline authority, partial-response follow-up, request correction/withdrawal/supersession, Under Consolidation handling, stale-state exceptions and post-issue handling remain open for detailed validation.
- No default SLA, clock pause, timeout, notification cadence, escalation, contractual effect or deemed acceptance is created.
- The disposition does not appoint actors, grant capabilities, approve a final lifecycle state machine, or authorize workflow/UI/API/code implementation, DB/schema/migrations, Storage, authentication, authorization/RLS, production-data changes, test execution, backup/restore, merge, deployment or release.

This is a conditional owner disposition for the five principles above only. All unresolved details remain subject to further review and specialist validation.

---
**End of working draft — conditional owner disposition recorded; specialist validation and detailed prerequisites remain pending.**
