# OR-01 / DISP-OR01-006 — Under Consolidation Entry and Sequencing

**Document type:** Detailed lifecycle decision review memorandum  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — TECHNICAL RECOMMENDATIONS ONLY — OWNER DISPOSITION NOT RECORDED — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Source detailed specification:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`, §§3.2–3.5 and §§4.1–4.6  
**Related owner dispositions:** DISP-OR01-001 (controlled vocabulary refinement); DISP-OR01-004 (two-key hand-off and complete required-assignment gate); DISP-OR01-005 (dependency-based clarification blockers and guarded resume)  
**Controlling governance:** DEC-104, DEC-105, DEC-106, DEC-107, DEC-109, DEC-110; DEC-022-A/B where controlled content changes

> This memorandum separates preparatory consolidation activity from the official parent lifecycle transition. It proposes no default authority, appointment, SLA, technical acceptance or implementation mechanism. It does not authorize workflow/UI/API/code changes, DB/Storage/auth/RLS changes, test execution, production-data operations, backup/restore, merge or deployment.

## 1. Decision question and scope

DISP-OR01-006 asks:

1. What must be true before the parent RFI may enter **Under Consolidation**?
2. May a technical lead begin limited preparatory work while independent, non-blocking discipline work is still in progress?
3. How should required, optional/out-of-scope and incomplete contributions be distinguished?
4. Which authority may confirm that a required contribution is complete or formally removed from scope?
5. How should open clarification blockers, dissent, material conflict, response versions and concurrent changes affect entry?

The decision concerns the parent-stage entry and sequencing boundary. It does not decide the later return from consolidation to discipline work (DISP-OR01-007), independent-review triggers (DISP-OR01-008), or Ready for Issue criteria (DISP-OR01-009), except to preserve their dependencies.

## 2. Protected constraints

1. **DISP-OR01-004:** the appointed technical authority determines disciplines, scope, required lead and assignments; the coordinator performs administrative routing only. The complete required-assignment gate for entry into In Technical Assessment remains intact.
2. **DISP-OR01-005:** an explicit parent-progression clarification blocker prevents progression past its affected gate. A contribution-only blocker stops only affected work; independent work may continue only where it is genuinely independent and does not bypass a dependent gate. Receipt or partial response does not resolve a blocker.
3. **DEC-105:** technical responsibility and leadership are appointment- and scope-bound; a coordinator does not decide technical completeness or conflicts.
4. **DEC-106:** clarification, formal revision, linked new RFI, reopening and closure remain distinct.
5. **DEC-107:** preserve official RFI identity and submitted evidence history; no new number or replacement identity is created by consolidation.
6. **DEC-109:** no default SLA, pause clock, notification cadence, escalation or contractual consequence.
7. **DEC-110:** lifecycle, authorization, concurrency, evidence/history and recovery outcomes require traceable verification design; no test execution or pass is claimed.
8. Existing candidate lifecycle vocabulary remains subject to controlled refinement. This memorandum does not approve the complete state machine.

## 3. Key distinction: preparation versus parent-stage transition

**Recommended baseline:** distinguish two different things:

- **Preparatory consolidation activity:** subordinate, provisional work that may organize already-received contributions, identify themes, prepare an outline or map issues while independent work continues. It does not change the parent lifecycle state and does not represent that the required-contribution gate has passed.
- **Parent state Under Consolidation:** the formal lifecycle stage in which the technical lead is authorized to consolidate the defined set of required contributions into a controlled response candidate, resolve or escalate material conflicts, and prepare the candidate for any required independent review.

Preparatory activity must remain visibly provisional and subordinate to the parent **In Technical Assessment** state. It must not be described in dashboards, reports, notifications or exports as formal consolidation, completed assessment, technical agreement or readiness for issue.

This distinction allows useful parallel work without weakening the parent-stage gate or misrepresenting an incomplete required contribution as complete.

## 4. Recommended parent entry gate

The parent may transition from **In Technical Assessment** to **Under Consolidation** only when all of the following are evidenced against the current RFI cycle and scope:

1. **Required-scope baseline is current:** the appointed technical authority's discipline scope, required contribution set, technical lead and assignments are valid and current. Any scope change has been authorized and recorded; the coordinator cannot remove a requirement.
2. **Every required contribution is complete:** each contribution in the current required set has a recorded completion/submission outcome by its authorized assignee, with the required content and evidence references. A draft, partial response, acknowledgement, mere upload or unreviewed placeholder is not completion.
3. **Completeness has been technically confirmed:** the appointed technical lead, within appointment, confirms that each required contribution is sufficiently complete for consolidation. Where the technical lead lacks authority to determine a discipline-specific completion question, the relevant appointed discipline authority must decide it or refer it to the designated technical authority.
4. **No required contribution remains blocked:** no required contribution has an unresolved contribution-only clarification blocker that makes its required input incomplete. An open non-blocking clarification may remain only if its recorded dependency genuinely does not affect the required input, consolidation scope or next gate.
5. **No parent-progression blocker remains open:** under DISP-OR01-005, an open valid parent-level clarification blocker prevents the parent transition. A response receipt or partial response does not clear it; authorized technical sufficiency determination is required.
6. **Required assignments are not silently abandoned:** reassignment, cancellation or removal of a required contribution must follow an authorized scope/assignment change with reason, effective time, impact assessment and preserved prior assignment/contribution history.
7. **Material contributions and dissent are preserved:** the consolidation input set identifies submitted contribution versions, authors/appointments, discipline, evidence and any stated dissent or reservation. No contribution may be silently omitted, rewritten or represented as concurrence.
8. **Current-state and version guards pass:** the parent remains in the expected In Technical Assessment state and current cycle/version; no concurrent scope, assignment, clarification, withdrawal, cancellation, reopening or lifecycle event has invalidated the proposed entry package.

If any gate is missing, ambiguous, expired, disputed or stale, the parent remains in its current state and the matter is referred to the appropriate appointed authority. No default or inferred approval is permitted.

## 5. Treatment of incomplete, optional and non-blocking work

The terms below must not be conflated:

| Work category | Recommended treatment before parent entry |
|---|---|
| Required contribution, complete and technically confirmed | Included in the frozen consolidation input set |
| Required contribution, draft/partial/not submitted | Blocks parent entry; remain in In Technical Assessment |
| Required contribution, contribution-only clarification blocker unresolved | Blocks parent entry because a required input is incomplete; unrelated work may continue only within dependency boundaries |
| Required contribution formally removed by authorized scope change | No longer part of the current required set; preserve the prior assignment and reasoned scope-change evidence |
| Optional/advisory input not part of the required gate | May remain outstanding if the authority-defined scope explicitly classifies it as non-required and its absence does not affect safety, technical adequacy, conflict resolution or the next gate |
| Non-blocking clarification | May remain open only if an authorized technical actor has recorded why it does not affect the consolidation gate; preserve it as a separate open item |
| Independent work in another discipline | May continue during assessment/preparation if authorized and genuinely independent; it does not permit parent entry while a required contribution remains incomplete |

**Important:** “non-blocking” is not a label that can be applied for convenience to an incomplete required contribution. If a contribution is part of the required set, it must be completed or formally removed through an authorized scope change before the parent enters Under Consolidation.

## 6. Parallel preparatory work — permitted limits

**Recommended direction:** allow limited preparatory consolidation in parallel with remaining independent assessment work, subject to all of these controls:

- The parent remains **In Technical Assessment** until the complete required-contribution gate in §4 passes.
- Preparatory tasks are subordinate records with their own identity, owner, status and attributable history; they are not parent lifecycle transitions.
- The preparatory work may organize already-submitted inputs, create a provisional response outline, identify apparent overlaps, prepare a contribution matrix or list questions for technical lead review.
- It must not finalize or issue a consolidated technical position, resolve another discipline's technical position, suppress dissent, mark an incomplete required contribution complete, or create a false impression that the parent has entered Under Consolidation.
- Every provisional artifact identifies the exact contribution versions on which it relies and is clearly marked provisional/not for issue.
- New or revised contributions received later must be incorporated through versioned updates; earlier preparatory artifacts remain attributable and are not silently overwritten.
- Any material change to controlled content is classified under DEC-022-A/B. An independent question is routed as a linked new RFI under DEC-106.
- If a new clarification blocker, scope change, conflict or stale assignment affects a preparatory artifact, that artifact is reassessed before it is used in formal consolidation.

This is a candidate subordinate-work permission, not an approval of any particular UI, task type, state label, automation or technical implementation.

## 7. Entry does not mean conflict resolution or readiness for issue

Under Consolidation is the stage in which the technical lead prepares the unified response and resolves or escalates material conflicts. Accordingly:

1. Entry does not require that every technical difference has already been resolved; otherwise the consolidation stage could not perform its intended purpose.
2. Entry does require that every required contribution is present and technically complete enough to be considered together.
3. All material conflicts, differing assumptions, limitations and dissent must be explicitly identified and preserved.
4. The technical lead may resolve only matters within the active appointment/delegation. Matters outside that authority must be escalated to the designated technical authority or relevant discipline authority.
5. No majority vote, silence, missing comment or administrative convenience converts unresolved material conflict into concurrence.
6. A conflict that makes the required input set incomplete or prevents safe consolidation must be referred and may prevent entry; a conflict that can properly be evaluated within the consolidation mandate may be handled after entry.
7. The separate Ready for Issue gate remains controlling: no unresolved material conflict or mandatory review may be bypassed to mark the response Ready for Issue.

The exact materiality threshold and conflict escalation route remain subject to specialist review and DISP-OR01-007/009.

## 8. Authority and evidence boundaries

| Actor | Recommended responsibility | Must not infer |
|---|---|---|
| Appointed technical authority / delegated assignment authority | Establishes and changes required discipline scope, required contribution set and assignment authority within documented appointment | A coordinator or roster administrator cannot decide that a contribution is optional or remove it |
| Appointed technical lead | Confirms readiness of required inputs for consolidation within appointment; preserves dissent; coordinates the consolidated response | Lead title alone does not confer authority over every discipline or conflict |
| Appointed discipline authority / responder | Completes and confirms its own scoped contribution; identifies limitations and dissent | One discipline cannot certify another discipline's contribution |
| Coordinator / Document Control | Administrative tracking and records support; may execute an authorized administrative parent transition only if separately delegated and after the technical gate evidence exists | Cannot decide technical completeness, waive a required contribution or advance the parent based on elapsed time |
| Architecture / security / QA / records specialists | Validate design feasibility, authorization, integrity, testability and record traceability | Review does not itself approve project policy or grant operational appointments |

The evidence package should include at minimum: current scope/assignment snapshot; list of required contributions; exact contribution IDs and versions; completion/technical-confirmation evidence; outstanding clarification list and blocker classifications; authorized scope changes; dissent/conflict register; preparatory artifacts and their source versions; parent state/version precondition; actor and appointment evidence for the entry decision.

## 9. Proposed transition and sequencing logic

| Situation | Parent state | Permitted activity |
|---|---|---|
| Required assignments are still being established | Under Coordination | Administrative preparation only under DISP-OR01-004 |
| Required assignments are valid; required contributions underway | In Technical Assessment | Authorized discipline work and independent parallel work |
| One required contribution is incomplete; another is complete | In Technical Assessment | Continue independent work; limited provisional preparation may use completed inputs |
| Contribution-only blocker affects a required contribution | In Technical Assessment, unless a parent blocker independently applies | Affected contribution waits; independent work continues; parent cannot enter consolidation until required input is complete or scope is validly changed |
| Parent-progression clarification blocker is open | Awaiting Originator Clarification under DISP-OR01-005 | Only work permitted by the recorded dependency and authority may continue; no transition past blocked gate |
| All required contributions complete/confirmed; no parent blocker; current scope and versions valid | May transition to Under Consolidation | Formal consolidated response preparation and conflict resolution/escalation |
| A material new gap is found after entry | Under Consolidation pending the separate return rule | Preserve current candidate and route under DISP-OR01-007; do not silently reset or erase |
| Consolidated candidate is complete | Under Consolidation until next approved gate | Independent review or Ready for Issue only under separately validated DISP-OR01-008/009 rules |

The table is a proposed sequencing model, not a final transition matrix or an implementation specification.

## 10. Versioning, concurrency and stale-input safeguards

Before parent entry and when formal consolidation begins, the responsible authority should verify:

- the current parent lifecycle state and version still match the expected In Technical Assessment state;
- the RFI cycle, scope, assignments and required-contribution set have not changed;
- every required contribution version remains current and linked to the correct assignment and evidence;
- no new parent-progression clarification blocker or unresolved required-contribution blocker has appeared;
- no contribution was withdrawn, superseded, reassigned or formally removed without an authorized record;
- the technical lead's appointment and scope remain active;
- provisional artifacts are distinguishable from formal consolidation artifacts and identify their source versions.

If any input changes between gate evaluation and transition, the transition must not proceed on stale evidence. Re-evaluate the complete gate. Concurrent transition attempts must produce one coherent parent event and must not create duplicate consolidation entries or lose contribution history. The exact transaction, locking, idempotency and event implementation remains for architecture review.

## 11. Failure and edge-case outcomes

| Scenario | Recommended outcome | Prohibited outcome |
|---|---|---|
| One required contribution is still a draft while others are complete | Keep parent In Technical Assessment; permit independent work and provisional preparation only | Enter Under Consolidation and call the draft complete |
| A required contribution has an open contribution-only blocker | Keep parent in assessment; continue only independent work; wait for completion or authorized scope change | Treat the blocker as optional or omit the contribution |
| A non-blocking clarification remains open and is proven unrelated to the gate | It may remain separately tracked while parent enters consolidation, subject to technical validation | Assume every open clarification blocks, or ignore a real dependency |
| A parent-progression blocker remains open | Keep parent Awaiting Originator Clarification; do not pass the blocked gate | Enter Under Consolidation on partial response or receipt |
| A required discipline is removed to meet timing | Require authorized scope change and preserved impact/rationale before recalculating the gate | Coordinator or technical lead silently removes it without authority |
| A late contribution arrives after provisional drafting | Preserve provisional version; incorporate new contribution through attributable versioned update | Overwrite earlier artifact or hide its source set |
| Material dissent exists between complete contributions | Enter consolidation only if the conflict is within the authorized consolidation mandate; preserve dissent and resolve/escalate before readiness | Convert dissent into consensus by silence or majority vote |
| Conflict makes the input set unsafe or materially incomplete | Hold entry and refer to the competent authority | Treat formal submission as proof of technical completeness |
| Scope or assignment changes concurrently with entry | Reject stale transition and re-evaluate gate | Commit using old scope snapshot |
| Technical lead appointment expires or is revoked | Hold formal entry/action until valid authority is established | Infer replacement from title or availability |
| An optional contribution is later determined to be required | Reopen gate assessment; remain/return through authorized path as applicable | Retrospectively claim the prior gate was valid without review |
| A material controlled-content change is discovered | Apply DEC-022-A/B classification | Treat it as ordinary consolidation edit without revision assessment |

These are proposed outcomes and test-design cases; no tests have been executed.

## 12. Owner decisions required

The owner should decide each point explicitly; accepting one does not settle all implementation details:

1. **Parent entry gate:** approve the rule that the parent enters Under Consolidation only after every required contribution is complete and technically confirmed, or formally removed by an authorized scope change?
2. **Parallel preparation:** permit limited provisional preparatory consolidation while independent contributions remain in progress, with the parent remaining In Technical Assessment?
3. **Required versus optional:** require an explicit, authority-approved classification of required and non-required inputs; prohibit treating an incomplete required contribution as non-blocking by convenience?
4. **Clarification interaction:** confirm that any open parent-progression blocker prevents entry, and an unresolved blocker on a required contribution prevents entry until resolved or scope is validly changed?
5. **Completeness authority:** confirm the technical lead may confirm completeness only within appointment, with discipline authority referral where competence/authority is outside scope?
6. **Conflict timing:** allow entry with a material conflict only where all required inputs are complete and the conflict can be handled within the authorized consolidation mandate; otherwise hold and escalate?
7. **Evidence/version gate:** require current scope, assignments, exact contribution versions, blocker status and parent version to be checked at entry?
8. **Subordinate preparation records:** require provisional work to remain separate from parent lifecycle and formal response versions, with source lineage and no external issue authority?

## 13. Specialist validation requested

| Domain | Validation question | Evidence expected |
|---|---|---|
| Technical lead / technical authority | Is the proposed completeness gate workable across single- and multi-discipline RFIs? Which completion decision belongs to the lead versus discipline authority? | Reviewed representative RFI cases and documented delegation boundary |
| Discipline specialists | Can a contribution be declared complete while preserving assumptions, limitations and dissent? Which cross-discipline dependencies must block entry? | Discipline-specific review and counterexamples |
| Project/process owner | Which inputs are mandatory versus optional, and who may approve a scope change? | Approved scope classification and authority route |
| Document Control | Can parent transition evidence and subordinate provisional artifacts be distinguished in records and reporting? | Records and register review |
| Architecture | Can exact contribution versions, scope snapshots, stale-state detection and idempotent transition be supported? | Architecture/concurrency review; no DB change implied |
| Security | Are scope changes, completion confirmation and transition separately authorized at action time? | Positive/negative authorization review |
| QA | Are incomplete, optional, blocked, conflicting and concurrent contribution cases objectively testable? | Traceable test design; no execution implied |
| Records | Are provisional artifacts and formal consolidation inputs attributable, versioned and retained under approved records rules? | Records classification; no retention period invented |

These are review domains, not named appointments or completed sign-offs.

## 14. Cross-specification dependencies and implementation boundary

This memorandum must reconcile with:

- **DISP-OR01-001:** Under Consolidation remains a candidate official lifecycle label under controlled refinement; no final state-machine approval is implied.
- **DISP-OR01-004:** the two-key administrative/technical hand-off and complete required-assignment gate remain intact. This memo does not alter who determines scope or assigns disciplines.
- **DISP-OR01-005:** dependency-based clarification blocking, contribution-only versus parent-level effects and guarded exact-state resume remain controlling within their conditionally approved scope.
- **DISP-OR01-007:** the return from consolidation to technical assessment/discipline work remains a separate pending decision.
- **DISP-OR01-008/009:** independent-review triggers and Ready for Issue criteria remain separate pending decisions.
- **DEC-105:** coordinator remains administrative; technical authority and discipline responsibility remain distinct.
- **DEC-106/107/109/110:** clarification/revision/new-RFI distinctions, identity/evidence integrity, no default SLA, and verification principles remain unchanged.

This memorandum does not amend DEC-103–DEC-110 or DEC-022-A/B; approve the complete lifecycle vocabulary; appoint actors; grant capabilities; define deadlines or contractual effects; implement workflow/UI/API/code; change DB/schema/migrations/generated types, Storage, authentication, authorization/RLS/grants or production data; execute tests; perform backup/restore; merge, deploy or release.

## 15. Technical recommendation summary

**Recommended baseline for owner consideration:**

1. Keep the parent in **In Technical Assessment** until every required contribution is complete and technically confirmed, or formally removed from the required scope by an authorized, evidenced scope change.
2. Permit limited **provisional subordinate preparation** in parallel with independent work, but do not move the parent to Under Consolidation or represent the provisional artifact as a formal consolidated response.
3. Do not treat an incomplete required contribution as optional/non-blocking. Optional inputs must be explicitly classified by the competent authority and must not affect technical adequacy or the next gate.
4. An open parent-progression clarification blocker prevents entry. An unresolved blocker affecting a required contribution also prevents entry until technically resolved or the required scope is validly changed.
5. Allow the Under Consolidation stage to handle material conflicts among complete contributions, provided the conflict is within the authorized mandate; preserve dissent and escalate matters beyond that authority. No conflict may be bypassed at Ready for Issue.
6. Bind entry to current scope, assignment, contribution and evidence versions; stale or concurrent changes require re-evaluation.
7. Keep all provisional work, parent transitions, formal response candidates and recipient communication as distinct attributable records.

## 16. Owner disposition

**Disposition status:** Not recorded.  
**Owner decision date:** Not recorded.  
**Decision evidence:** No owner disposition has been supplied for DISP-OR01-006.

No approval is inferred from discussion, prior decisions or this recommendation. Specialist validation remains pending.

---
**End of working draft — technical recommendation only; owner disposition and specialist validation pending.**
