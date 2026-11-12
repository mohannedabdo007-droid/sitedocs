# OR-01 / DISP-OR01-014 — Parent Lifecycle, Subordinate Records and Independent Indicators

**Document type:** Detailed lifecycle decision review memorandum  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — TECHNICAL RECOMMENDATIONS ONLY — OWNER DISPOSITION NOT RECORDED — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Source model:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`, §§3.1–3.5  
**Related governance:** DEC-103, DEC-104–DEC-110; DEC-022-A/B; DISP-OR01-001 and DISP-OR01-003–013; detailed specifications DD-01–DD-16.

> This memorandum proposes parent/subordinate aggregation semantics. It does not approve the complete RFI state machine, finalize subordinate state vocabularies, create metrics/SLA defaults, or authorize implementation or test execution.

## 1. Decision question and scope

DISP-OR01-014 determines:
1. What is the authoritative parent RFI lifecycle state, and which events may change it?
2. Which subordinate records maintain their own state and history?
3. When may a subordinate condition block a parent transition without itself becoming a parent transition?
4. How should multiple assignments, contributions, clarifications, reviews and response candidates aggregate?
5. Which communication, monitoring, reporting, archival and recipient events remain independent indicators?
6. How do parent lifecycle, response cycle, technical closure, Transmittal, archive and linked records remain distinguishable?
7. How are counts, dashboards, exports, access control, concurrency and audit history prevented from conflating different record units?

This decision closes the parent/subordinate aggregation question after the individual lifecycle decisions DISP-OR01-001 and DISP-OR01-003–013. It must not reopen or dilute those scoped decisions or DEC-103–DEC-110.

## 2. Controlling design principles

1. **One authoritative parent stage:** each official RFI identity has one authoritative current parent lifecycle stage at a time, interpreted in the context of its active response cycle where applicable.
2. **Separate subordinate state:** assignments, contributions, clarification requests, response candidates, reviews, Transmittals, recipient events and records/archive controls have their own identifiers, states and event histories.
3. **Explicit transition gates:** subordinate records may satisfy or block a defined parent transition only where an approved rule explicitly makes them a prerequisite. Their state does not autonomously write or infer a parent state.
4. **No communication substitution:** dispatch, delivery, access, read/open, acknowledgement, substantive recipient response, notification or silence is not technical assessment, approval, formal issue or technical closure.
5. **No monitoring substitution:** overdue, aging, workload, dashboard, report, search, export, archive or retention indicators do not constitute lifecycle events.
6. **Authority at action time:** parent transitions require the current actor's explicit capability, appointment/delegation and scope; child-record permission does not imply parent-transition authority.
7. **Immutable history:** every parent and subordinate event remains attributable and version-bound; aggregation is a derived view, not a destructive consolidation of histories.
8. **DEC-110 traceability:** any future implementation must prove correct positive/negative gates, aggregation, security, concurrency, idempotency, evidence/history and recovery. No tests are executed here.

## 3. Recommended record hierarchy and ownership

| Record class | Authoritative purpose | Own lifecycle/state? | May affect parent? |
|---|---|---|---|
| Official RFI parent | Official identity and current overall technical/administrative stage | Yes | It is the parent |
| Response cycle | Distinct assessment/response cycle, including reopened cycle | Yes, subordinate to parent identity | Its authorized start and gate outcomes determine which parent-stage transitions may be proposed; prior cycle remains historically closed |
| Discipline assignment | Scoped responsibility, assignee, acceptance and work progress | Yes | Required assignment absence/invalidity blocks applicable hand-off or readiness gate; assignment status alone does not set parent stage |
| Discipline contribution | Attributable technical position/version, completion and changes | Yes | Required incomplete contribution blocks Under Consolidation/Ready for Issue gates under DISP-OR01-006/007/009; does not autonomously advance parent |
| Clarification request | One scoped question, response and technical sufficiency decision | Yes, each request separately | Only an authorized, explicitly parent-progression blocker may place/keep parent in Awaiting Originator Clarification; contribution-only blockers affect only scoped work |
| Response candidate/version | Consolidated answer candidate and exact evidence manifest | Yes | Exact candidate readiness/review/issue gates may block parent progression; candidate labels do not independently issue or close parent |
| Independent review | Review of exact candidate/package version by appointed independent reviewer | Yes | Mandatory blocking review prevents Ready for Issue; review clearance applies only to exact version |
| Readiness confirmation | Attributable confirmation for exact candidate/package | Yes, immutable record | Satisfies a required pre-issue gate only; does not confer issue authority or issue/close parent |
| Formal issue/closure event | Authoritative issue and technical closure outcome | Immutable event linked to parent and cycle | Successful atomic issue/closure changes parent/cycle technical lifecycle under DISP-OR01-010 |
| Transmittal | Controlled distribution package and dispatch attempts | Yes | No parent technical-stage change |
| Transmittal recipient | Recipient-specific delivery, access, acknowledgement and substantive response | Yes, per recipient | No parent technical-stage change |
| Notification event | Attempt, result, retry and processing evidence | Yes, operational history | No parent technical-stage change |
| Monitoring/report/export snapshot | Derived metrics, filters, as-of views and output | Versioned derived artifact | No parent technical-stage change |
| Archive/retention/legal hold/disposition | Records preservation, retrieval, hold and authorized disposition | Yes, separate records controls | No technical-stage change; may govern records access/preservation/disposition only |
| Linked WIR/MQR/MOM/other record | Independent source workflow and identity | Yes, under its own governing rules | No automatic state propagation in either direction |

This table defines separation of responsibility, not a final database schema or complete state vocabulary.

## 4. Parent lifecycle transitions — explicit gate model

Recommend that only an authorized parent lifecycle command/event changes the authoritative parent stage. A subordinate event may provide evidence for a gate, but must not directly mutate parent state.

| Parent transition/gate | Subordinate evidence that may be evaluated | Recommended aggregation rule |
|---|---|---|
| Submitted → Under Coordination / intake routing | Official submission identity and required intake evidence | Only successful formal submission creates the official RFI; child task creation or email receipt is not submission |
| Under Coordination → In Technical Assessment | Current technical authority's scope/lead/required assignment determination and coordinator's delegated administrative readiness check | All required appointments/assignments and scope/access evidence must be valid; incomplete/ambiguous assignments hold the parent under DISP-OR01-004 |
| In Technical Assessment → Under Consolidation | Required discipline contribution versions and authorized scope-removal decisions | Every required contribution is technically complete/confirmed or formally removed from required scope through authorized evidenced change; provisional subordinate preparation does not satisfy completion |
| Technical stage → Awaiting Originator Clarification | One or more clarification requests with an authorized parent-progression blocker designation | Parent enters/remains Awaiting Originator Clarification only while at least one valid parent-progression blocker is open; contribution-only blocker does not pause unrelated parent work |
| Awaiting Originator Clarification → prior valid parent stage | Responses to every relevant parent-progression blocker and technical sufficiency determinations | Resume only when all parent-level blockers are resolved; preserve exact prior parent state under DISP-OR01-005; partial response/receipt alone is insufficient |
| Under Consolidation → In Technical Assessment | Authorized scoped return under DISP-OR01-007 | Return only affected work where dependencies are bounded; unaffected contributions remain preserved; parent transition is an explicit authorized event |
| Under Consolidation → Under Independent Review | Frozen candidate/package and applicable approved risk/authority matrix trigger | Only the appointed independent-review route can establish review stage; review is exact-version bound |
| Under Independent Review → Under Consolidation / technical reassessment | Review outcome and authorized disposition of comments | Blocking comments require authorized resolution and version impact; advisory comments do not silently become blocking or approval |
| Technical stage → Ready for Issue | Required contributions, blocker/conflict resolution, mandatory review and exact candidate/package; readiness confirmation | Every required gate must be satisfied for exact version; readiness is not issue or closure |
| Ready for Issue → Closed | Current authorized issuer, final action-time revalidation and exact frozen package | Only successful atomic formal issue + technical closure under DISP-OR01-010 changes parent/cycle to Closed |
| Closed → reopened active cycle | Authorized reopening decision and new cycle record under DISP-OR01-013 | Prior cycle remains closed; new cycle is distinct; parent current stage reflects only the authorized new-cycle start decision |
| Pre-issue → Withdrawn/Cancelled | Separate authorized withdrawal/cancellation decision under DISP-OR01-011/012 | Terminal parent outcomes require their own authority/evidence; child histories are retained and are not bulk-deleted |

The table does not approve every candidate label as final. Exact stage names and any additional transition require reconciliation with the relevant owner decisions and specialist validation.

## 5. Discipline assignments and contributions

1. Each discipline assignment has a stable identity, discipline/scope, assignee, appointment/delegation reference, required/optional classification, current status, version/history and relevant parent/cycle reference.
2. Assignment Accepted, In Progress, Contribution Submitted or Completed are subordinate facts, not parent lifecycle commands.
3. A required assignment that is absent, invalid, unaccepted where acceptance is a required rule, or unstaffed blocks the applicable parent hand-off/readiness gate; it does not by itself set parent stage to In Technical Assessment or Under Coordination.
4. Required contribution completion is evaluated against the authorized assignment scope and discipline-specific completion criteria. A file upload or submit click alone is not technical confirmation.
5. A contribution may be complete for its own assignment while another required contribution remains incomplete. Parent consolidation/readiness gates use the full required set, not the most recently updated child.
6. Reassignment, cancellation or scope removal must be authorized and evidenced; a required contribution cannot be made optional by convenience or silence.
7. Partial/provisional subordinate preparation may continue only within DISP-OR01-006 limits and must not be represented as parent consolidation or technical agreement.
8. Parent dashboards may summarize assignment/contribution counts, but must show the counting unit and distinguish required, optional, active, completed, cancelled and formally removed scopes.

## 6. Clarification aggregation

1. Every clarification request is a distinct record with exact source contribution/discipline, question, version, requester, recipient, scope, blocker classification, request/response events and technical sufficiency decision.
2. A clarification may be:
   - contribution-only: blocks only the affected contribution/work item;
   - parent-progression blocking: an authorized technical actor records why the unresolved dependency prevents the next parent gate.
3. The parent may show Awaiting Originator Clarification only while at least one valid parent-progression blocker is open.
4. Multiple parent-level blockers aggregate using an **any-open-blocker rule**: one unresolved valid parent blocker is sufficient to keep the parent in the clarification-wait state; the parent resumes only after all parent-level blockers are technically resolved or validly withdrawn/superseded under the applicable authority.
5. Closing one request does not close another. A partial response, receipt acknowledgement or administrative marking of “responded” does not establish technical sufficiency.
6. Contribution-only clarification does not automatically pause independent work or change the parent stage.
7. When the last parent-progression blocker is resolved, restore the exact prior parent state recorded before the first parent-level blocker, subject to current authority, scope, assignment, evidence and concurrency guards under DISP-OR01-005.
8. Clarification request counts and aging are reported per request/round, not treated as unique RFI counts or parent state changes.

## 7. Response candidates, consolidation and review

1. Each response candidate/version is a subordinate technical artifact with exact source contribution versions, evidence references, scope, author, timestamp and status.
2. Drafting, candidate submission, changes requested, review passed and candidate-ready labels remain distinct from the parent lifecycle.
3. A candidate may be under preparation while parent remains In Technical Assessment only within the controlled provisional-preparation rules in DISP-OR01-006; this does not mean parent Under Consolidation.
4. Parent Under Consolidation is permitted only after the required contribution gate is satisfied under DISP-OR01-006.
5. Review status is bound to the exact candidate/package manifest. A material change creates a successor candidate/version and requires the applicable impact assessment and targeted/full review under DISP-OR01-008.
6. Mandatory blocking independent review prevents Ready for Issue. An advisory/non-blocking review outcome cannot be promoted to blocking or treated as clearance without the approved matrix and authorized decision.
7. Review Passed is not formal issue, and a response candidate marked Issued cannot independently create a parent issue event. Only the authorized atomic issue/closure command does so.
8. Prior candidate/review/readiness records remain immutable when a new cycle is opened; prior clearance does not transfer automatically under DISP-OR01-013.

## 8. Formal issue, technical closure and response-cycle aggregation

1. Successful formal issue and technical closure of the same active cycle remain one indivisible business outcome under DISP-OR01-010.
2. The parent current lifecycle is changed only by the successful authorized issue/closure outcome; neither response candidate status nor a Transmittal state can substitute for it.
3. Issue/closure event records retain distinct linked evidence identities, exact response version, package manifest, authority, timestamp and cycle.
4. A reopened RFI retains the prior cycle as closed historical evidence while a new cycle has its own lifecycle. Do not reopen, overwrite or relabel the prior cycle as active.
5. Parent-level summaries must identify whether they refer to the official RFI identity, active cycle, all historical cycles or a particular response version.
6. A reopened RFI is one official RFI identity for identity-level counts, but may have multiple distinct cycles and response versions for cycle/history reporting. Never add these counts together without explicit labels.
7. Withdrawal and cancellation are parent terminal outcomes only within their pre-issue eligibility and authority boundaries; they do not delete subordinate work, contributions, evidence, reviews or communication history.

## 9. Transmittal and recipient event separation

Under DEC-103/108:
- Transmittal dispatch is a distribution event for an exact frozen package and recipient snapshot.
- Delivery is calculated at recipient level: Delivered only when all intended recipients succeed; Partially Delivered when some succeed and some fail; Failed when all fail; unconfirmed/unknown is not success.
- Acknowledgement completion counts only Required recipients; Optional/Not Requested do not enter the denominator; zero Required recipients is Not Required.
- Access/open/download evidence, receipt acknowledgement, review-awareness acknowledgement and substantive recipient response are distinct events.
- Delivery/access/acknowledgement/substantive response/silence do not create, reverse, pause or close parent technical lifecycle.
- A new response cycle/formal response uses its own controlled Transmittal; prior recipient events remain attached to their prior Transmittal and version.
- Internal authorized record visibility is separate from external formal distribution.

No recipient aggregation formula may be used as a parent lifecycle transition.

## 10. Notifications and monitoring indicators

The following are independent operational/analytical indicators:
- notification queued/sent/delivered/failed/retried;
- unread/read/opened/accessed;
- target-date, aging, overdue and elapsed-time indicators;
- assignment workload and capacity;
- response/clarification/review/Transmittal processing backlog;
- report snapshot, filter, export and dashboard freshness;
- archive-ready, archived, hold and retention-review indicators.

Rules:
1. An indicator is a projection from authoritative source records/events, not an independent authority to change them.
2. Indicator refresh or calculation failure must not change the underlying lifecycle.
3. No default SLA, clock pause, timeout, escalation, priority, notification cadence or contractual effect is created.
4. Requested date remains informational; target date and overdue semantics require an approved project rule.
5. Each metric defines its owner, source, unit, numerator/denominator, scope, as-of time, timezone, treatment of reopened cycles/terminal outcomes and permission rules before implementation.
6. Dashboard cards must distinguish unique RFI count, cycle count, assignment count, clarification-request count, candidate/version count, Transmittal count and recipient count.
7. Aggregate/facet counts must apply authorization before aggregation; do not expose hidden record existence or infer global totals.

## 11. Archive, retention, legal hold and disposition

1. Archive, retention review, legal hold, disposition eligibility and authorized destruction are records-management controls, not parent technical lifecycle states.
2. Technical closure does not automatically mean archive package complete, retention clock started, legal hold released or deletion permitted.
3. Archive readiness may report missing records/evidence or open exceptions; archive processing must not manufacture technical closure or close outstanding technical work.
4. A legal hold governs preservation and access of its explicitly scoped records; it does not itself reopen, close or change technical assessment.
5. Retention expiry permits controlled records review only; no automatic deletion or change to parent lifecycle.
6. Parent, cycle, contribution, review, Transmittal, recipient, export, backup, replica and cache records retain their own authorized records controls and lineage.
7. Archive access and linked-record access remain independently permission-controlled. RFI access does not automatically grant WIR/MQR/MOM or recipient-record access.
8. Archive and disposition indicators must never be displayed as technical approval, closure or acceptance.

## 12. Reporting and counting units

Recommend a metric dictionary with explicit unit:
- **RFI identity count:** distinct official RFI IDs; reopened cycles do not create additional RFI identities.
- **Active parent RFI count:** distinct parent identities whose authoritative current parent stage meets the published inclusion rule; terminal outcome treatment must be explicit.
- **Cycle count:** distinct response-cycle IDs, including historical/reopened cycles when the report says so.
- **Assignment count:** distinct assignment IDs, not unique RFI count.
- **Contribution count:** distinct contribution records/versions as separately defined; do not equate versions with unique disciplines.
- **Clarification count:** distinct clarification requests/rounds; separate parent-blocking from contribution-only.
- **Review count:** distinct review assignments/outcomes bound to exact versions.
- **Candidate/version count:** distinct response candidate/version identities.
- **Transmittal count:** distinct Transmittal IDs; dispatch attempts are a separate count.
- **Recipient count:** distinct recipient entries per Transmittal; delivery and acknowledgement are recipient-level outcomes.
- **Notification count:** distinct notification events/attempts, not RFI count.
- **Archive/hold count:** distinct archive packages or hold records, not closed RFIs.

Each published metric must define as-of timestamp, timezone, project/party scope, filters, inclusion/exclusion of demo/test records, reopened cycles, withdrawn/cancelled records and permission suppression. No performance ranking or SLA metric is approved here.

## 13. Authorization, visibility and linked records

1. Parent visibility does not automatically grant visibility to every child, attachment, reviewer comment, recipient identity, legal hold or linked workflow.
2. Subordinate action authority does not grant parent transition authority; parent oversight/read-only access does not grant edit, review, issue or disposition rights.
3. Search, facets, counts, snippets, exports and drill-downs must apply current authorization at the appropriate record/field level before returning data.
4. A dashboard aggregate must not leak hidden child records through small counts, filters, difference queries or existence signals.
5. A linked WIR/MQR/MOM or external record keeps its own identity, authority and lifecycle; cross-link display is permitted only where the viewer is authorized for the relationship and disclosed fields.
6. Every consequential parent or child action revalidates actor, scope, appointment, state, version and evidence at action time.

## 14. Concurrency, event history and recovery

1. Parent transition decisions must evaluate the complete authoritative set of relevant child records at commit time, not a stale dashboard/cache projection.
2. Concurrent child updates that change a required gate (e.g., contribution completion, scope removal, clarification resolution or review version) must cause revalidation of the parent transition.
3. A child event and parent transition must be linked by explicit event/evidence references; no implicit cascade or partial success is permitted.
4. Duplicate child events must be idempotently reconciled without duplicate contributions, acknowledgements, parent transitions or counts.
5. Late or out-of-order notification/delivery/archive events cannot overwrite current technical stage.
6. Reopening, issue/closure, withdrawal/cancellation and relevant child events must preserve the first valid authoritative outcome and prevent contradictory parent state.
7. Failure recovery reconciles authoritative event history and child records before retry; do not rely solely on client status or dashboard state.
8. No transaction, schema, locking, event bus, API or storage implementation is authorized by this design memorandum.

## 15. Proposed acceptance criteria for later verification

Design-only; no tests have been executed:
1. A child assignment status change alone cannot mutate the parent lifecycle.
2. All required assignments must be valid before the authorized hand-off; missing/ambiguous assignment blocks it.
3. One incomplete required contribution blocks the applicable consolidation/readiness gate even if other disciplines are complete.
4. Contribution-only clarification does not pause unrelated work or change parent state.
5. One valid parent-progression clarification blocker keeps parent Awaiting Originator Clarification until all such blockers are resolved.
6. Partial response/receipt does not clear a technical clarification blocker.
7. Parent resumes the exact previously recorded stage only after all parent blockers resolve and current guards pass.
8. Parent Under Consolidation cannot be inferred from draft candidate preparation or one completed contribution.
9. A mandatory blocking review prevents Ready for Issue; prior-version review clearance cannot clear a changed candidate.
10. Readiness confirmation does not issue or close parent; only authorized atomic issue/closure does.
11. Transmittal dispatch/delivery/access/acknowledgement/substantive response cannot alter parent technical stage.
12. Notification/read/open/overdue/workload/dashboard/export events cannot alter parent technical stage.
13. Archive, retention expiry or legal hold cannot create or reverse technical closure; retention expiry does not delete automatically.
14. Reopening preserves prior closed cycle and creates a separately traceable new cycle under the same RFI identity.
15. Parent identity counts, cycle counts, assignment counts, recipient counts and notification counts remain distinct and correctly labeled.
16. Search, aggregates and exports do not leak unauthorized parent/child/recipient/hold metadata.
17. Concurrent child updates force parent gate revalidation; duplicate events do not create duplicate parent transitions or counts.
18. Linked WIR/MQR/MOM lifecycle remains independent and access does not cascade.

Blocking defects include any unauthorized parent transition from child/communication/monitoring/archive event; parent advancement with missing required assignment/contribution/review; premature clarification resumption; stale-version review/readiness inheritance; delivery/acknowledgement treated as technical acceptance; archive/retention treated as closure/deletion; count-unit conflation; unauthorized child/recipient leakage; or duplicate/concurrent parent outcomes.

## 16. Owner decision points

The owner is asked to decide:
1. Confirm one authoritative parent RFI lifecycle stage per official RFI identity, with response-cycle context preserved separately.
2. Confirm separate state and event histories for assignments, contributions, clarification requests, response candidates, reviews, readiness records, Transmittals, recipient events, notifications, reports/exports and records controls.
3. Confirm subordinate events never autonomously change parent stage; they may only satisfy/block a specifically defined, authorized parent transition gate.
4. Confirm complete valid required assignments are a prerequisite to the technical hand-off, under DISP-OR01-004.
5. Confirm every required contribution must be technically complete or validly removed from scope before consolidation/readiness gates, under DISP-OR01-006/009.
6. Confirm the any-open-parent-blocker rule for Awaiting Originator Clarification and exact prior-stage resumption, under DISP-OR01-005.
7. Confirm contribution-only blockers affect only their scoped work and do not automatically pause the parent or independent work.
8. Confirm exact-version candidate/review/readiness gates remain separate; prior review/readiness never transfers to changed/new candidates or reopened cycles.
9. Confirm formal issue/technical closure changes parent only through the atomic authorized issue/closure outcome under DISP-OR01-010.
10. Confirm Transmittal, recipient delivery/access/acknowledgement/substantive response and notification events never change parent technical lifecycle under DEC-103/108.
11. Confirm workload, aging, overdue, dashboard, search, export, archive, retention and legal-hold indicators remain separate from technical lifecycle under DEC-109.
12. Confirm archive/retention/hold/disposition does not manufacture closure or authorize deletion; linked WIR/MQR/MOM records retain independent lifecycle and access.
13. Confirm metric definitions distinguish RFI IDs, cycles, assignments, contributions, clarifications, candidates, reviews, Transmittals, recipients, notifications and archive/hold records.
14. Confirm action-time authorization, permission-safe aggregation, concurrency/idempotency and event-history reconciliation as required design safeguards.
15. Confirm no default SLA, clock pause, notification cadence, escalation, ranking, contractual effect or deemed receipt/acceptance is created.

## 17. Conditions and interim controls

Until owner disposition and specialist validation:
- no implementation-ready parent/subordinate aggregation model is approved;
- preserve independent child records, event histories and exact version/recipient lineage;
- do not infer parent stage from child status, message, read receipt, delivery, acknowledgement, notification, dashboard, archive or retention event;
- do not advance a parent gate while required assignment, contribution, clarification, conflict, review, package or authority prerequisite is missing/stale/ambiguous;
- do not treat every child blocker as a parent blocker; only a specifically authorized parent-progression dependency may hold the parent;
- do not collapse identity, cycle, assignment, contribution, request, candidate, review, Transmittal, recipient, notification or archive counts;
- do not allow linked WIR/MQR/MOM access or state to cascade automatically;
- no default metric formula, SLA, overdue rule, report audience, threshold or retention period is established.

Specialist validation remains required from project/process owner, technical authority/lead and affected discipline authorities, Document Control, records, architecture, security/privacy, reporting/data governance, independent assurance/QA and contract/project governance as applicable. No specialist sign-off is claimed.

No appointment, capability grant, final full state machine, workflow/UI/API/code implementation, test execution, DB/schema/migration/generated type, Storage, authentication, authorization/RLS/grants, production-data operation, backup/restore, merge, deployment or release is authorized.

## 18. Technical recommendation summary

Adopt an explicit parent/subordinate separation model: the official RFI parent has one authoritative current lifecycle stage; each assignment, contribution, clarification, response candidate, review, Transmittal, recipient event, notification, report/export and records-control object maintains its own identity and history. Subordinate records may satisfy or block a specific authorized parent transition gate, but never autonomously mutate the parent. Communication, monitoring, archive and recipient indicators remain independent. Aggregation must use complete authoritative evidence, distinguish parent-level from contribution-only blockers, preserve exact-cycle/version history, and label every metric by its true counting unit. No implementation or test execution is authorized by this recommendation.

## 19. Open decisions and required specialist reviewers

| Open decision | Required review |
|---|---|
| Final parent and subordinate state vocabulary and transition ownership | Owner; technical authority; process owner; Document Control; architecture; QA |
| Exact required/optional assignment and contribution completion criteria | Technical authority/lead; discipline authorities; project/process owner |
| Clarification blocker classification and multi-request aggregation | Technical authority; discipline specialists; process owner; QA |
| Response candidate and review state ownership/version model | Technical authority; independent assurance; architecture; records |
| Exact cycle-to-parent projection, especially reopened cycles | Owner; technical authority; architecture; Document Control; records |
| Metric dictionary, counting keys, denominators and as-of semantics | Reporting/data governance; project owner; architecture; QA |
| Permission-safe aggregates, search, exports and small-count privacy | Security/privacy; architecture; records; reporting owner |
| Transmittal/recipient reporting and DEC-103 aggregation | Document Control; security; records; contract/project governance |
| Archive/hold/retention and parent/child record linkage | Records; legal/privacy; security; operations |
| Cross-family WIR/MQR/MOM linkage and access | Process owners; security; architecture; Document Control |
| Concurrency, idempotency, event ordering and recovery | Architecture; security; QA; records |

Unresolved items remain **Blocked — Pending Authority Decision/Prerequisite**. No default is inferred.

---
## 20. Owner disposition — Revision 1

**Disposition ID:** DISP-OR01-014  
**Owner decision date:** 2026-11-12  
**Decision:** **Conditionally approved — parent/subordinate separation and gate-based aggregation model.**  
**Decision evidence:** The owner explicitly stated: “اعتمد” in response to the fifteen owner decision points in this memorandum.

### 20.1 Approved scope

The owner approves the fifteen principles in §16, subject to the conditions below, including:
1. One authoritative current parent lifecycle stage per official RFI identity, with distinct response-cycle identities/history.
2. Independent identity, state and event history for subordinate assignments, contributions, clarification requests, response candidates, reviews, readiness records, Transmittals, recipients, notifications, reports/exports and records controls.
3. Subordinate events may satisfy or block only an expressly defined and authorized parent transition gate; no child event autonomously changes parent stage.
4. Required valid assignments gate technical hand-off; required contributions gate consolidation/readiness; contribution-only clarification blockers remain scoped.
5. Any open valid parent-progression clarification blocker holds the parent in Awaiting Originator Clarification; resume the exact prior stage only after all such blockers resolve and current guards pass.
6. Exact-version review/readiness, atomic formal issue and technical closure, and separate post-issue response-cycle handling remain governed by DISP-OR01-008 through DISP-OR01-013.
7. Transmittal, recipient delivery/access/acknowledgement/substantive response, notifications, workload/aging, reporting/export, archive, retention and legal-hold events do not change technical parent lifecycle.
8. Distinct counting units, permission-safe aggregation, independent linked WIR/MQR/MOM lifecycles, action-time authorization, concurrency/idempotency and event-history reconciliation remain required design safeguards.

### 20.2 Conditions and exclusions

- Specialist validation remains required from project/process owner, technical authority/lead and affected discipline authorities, Document Control, records, architecture, security/privacy, reporting/data governance, QA/independent assurance and contract/project governance as applicable. No specialist sign-off is claimed.
- Final parent/subordinate state vocabulary, required/optional completion criteria, clarification blocker classification, cycle-to-parent projection, metric dictionary/counting keys, permission-safe aggregate/export design, Transmittal/recipient reporting, archive/hold/retention, cross-family linkage and concurrency/recovery mechanics remain subject to specialist validation.
- No default SLA, overdue rule, notification cadence, escalation, ranking, contractual effect, deemed receipt or deemed acceptance is approved.
- No appointment, capability grant or final full lifecycle state machine is created.
- No workflow/UI/API/code implementation, test execution, DB/schema/migration/generated type, Storage, authentication, authorization/RLS/grants, production-data operation, backup/restore, merge, deployment or release is authorized.

### 20.3 Interim control

Do not infer or mutate parent stage from subordinate status, communication, recipient, notification, monitoring, reporting, archive or retention events. Hold any parent transition whose required assignment, contribution, blocker, review, package, authority, version or evidence prerequisite is missing, stale, disputed or ambiguous. Keep contribution-only blockers scoped. Preserve parent/cycle/child identities and histories and never conflate metric units.

**Specialist validation status:** Pending.  
**Implementation authorization:** Not granted.  
**Test execution authorization:** Not granted.

---
**End of working draft — DISP-OR01-014 conditionally approved within the exact scope in §20; specialist validation remains pending. No implementation or test execution is authorized.**
