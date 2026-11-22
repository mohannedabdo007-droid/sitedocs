# OR-01 / DISP-OR01-007 — Return from Consolidation to Technical Assessment

**Document type:** Detailed lifecycle decision review memorandum  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — OWNER CONDITIONALLY APPROVED THE RECORDED BUSINESS PRINCIPLES ON 2026-11-12 — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Source detailed specification:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`, §§3.2–3.5, especially §3.3 Under Consolidation → In Technical Assessment and §3.4 items 2, 4 and 8  
**Related owner dispositions:** DISP-OR01-003 (late administrative correction does not silently reset parent state); DISP-OR01-004 (two-key technical/administrative hand-off); DISP-OR01-005 (dependency-based clarification blockers and guarded resume); DISP-OR01-006 (formal consolidation entry gate and provisional preparation distinction)  
**Controlling governance:** DEC-104, DEC-105, DEC-106, DEC-107, DEC-109, DEC-110; DEC-022-A/B where controlled response content changes

> This memorandum proposes business-level conditions and safeguards for a controlled return from Under Consolidation to In Technical Assessment. It does not approve a final state machine, appoint actors, define an SLA, authorize implementation or test execution, or alter DB/Storage/auth/RLS/production data.

## 1. Decision question and scope

DISP-OR01-007 asks:

1. Which newly discovered gaps, dependencies, material conflicts or changes require formal return to discipline-level technical assessment?
2. Which issues can be resolved within the existing consolidation mandate without changing the parent state?
3. Who may identify, recommend, authorize and administratively record the return?
4. What scope, contribution, candidate-response and evidence history must be preserved?
5. When is a new contribution version required, and what happens to unaffected contributions?
6. How does return affect a prior or pending independent review, clarification, response candidate and subsequent re-entry into consolidation?

The decision is about the parent transition from **Under Consolidation** to **In Technical Assessment** and its business-level guards. It does not decide the independent-review trigger or review outcome (DISP-OR01-008), Ready for Issue criteria (DISP-OR01-009), formal issue/closure (DISP-OR01-010), or reopening after formal issue (DISP-OR01-013).

## 2. Protected constraints

1. **DISP-OR01-003 / Option C:** a late administrative defect cannot use a generic administrative return to silently reset the technical lifecycle. A technical return under this memorandum requires an evidenced technical reason and authorized technical decision.
2. **DISP-OR01-004:** the appointed technical authority determines technical scope and required assignments; the coordinator remains administrative and cannot decide which discipline must redo work.
3. **DISP-OR01-005:** an originator clarification blocker is distinct from a technical return. A valid parent-progression blocker uses Awaiting Originator Clarification and guarded resume; a contribution-only blocker affects its defined work. Receipt alone does not resolve a blocker.
4. **DISP-OR01-006:** Under Consolidation is entered only after required contributions are complete and technically confirmed or formally removed by authorized scope change. Provisional preparation is subordinate and not a parent transition.
5. **DEC-105:** discipline positions, technical leadership, conflict disposition and formal technical authority remain appointment- and scope-bound. No coordinator tie-break, inferred concurrence or majority vote.
6. **DEC-106:** clarification, formal revision, linked new RFI, reopening and closure remain distinct. An issued formal response is not silently edited.
7. **DEC-107:** preserve the official RFI identity, evidence snapshots and immutable history.
8. **DEC-109:** no default SLA, timeout, pause clock, notification cadence, escalation, contractual effect or lifecycle implication from workload/communication indicators.
9. **DEC-110:** transition, authority, stale-state, concurrency, evidence and recovery outcomes require traceable verification design. No tests have been executed or passed.

## 3. Core distinction: correct in consolidation or return to assessment?

**Recommended baseline:** not every comment, edit, disagreement or clarification discovered during consolidation should cause a parent-stage return. Use a materiality and authority test.

- **Remain Under Consolidation:** the issue can be resolved by the appointed technical lead within the existing approved discipline scope and appointment, using already-complete contributions and without requiring a new or materially revised discipline determination, missing technical input, changed assignment, or external-originator information.
- **Return to In Technical Assessment:** the issue requires one or more disciplines to perform new or materially revised technical work, a required contribution is no longer technically complete/current, the approved technical scope or assumptions need a substantive reassessment, or a material technical conflict cannot be resolved within the consolidation mandate and requires discipline re-evaluation.
- **Awaiting Originator Clarification:** the missing information must come from the originator and an authorized technical actor has recorded a valid clarification dependency that blocks the affected work or parent progression under DISP-OR01-005. Do not mislabel an originator dependency as a discipline return.
- **Formal revision / linked new RFI / reopening:** where the issue changes controlled source content, raises a genuinely independent question, or arises after formal issue, apply DEC-022-A/B and DEC-106/OR-01 decisions as applicable; do not use a return transition as a shortcut.

The parent transition should reflect the actual work and authority required, not merely the fact that a reviewer or technical lead has requested a change.

## 4. Recommended return triggers

A formal return should be available only where at least one of the following is evidenced:

1. **Missing required technical work:** consolidation identifies that a required discipline assessment, calculation, inspection, design check, interface confirmation or other required technical contribution was not performed or is materially incomplete.
2. **New technical dependency:** one contribution reveals a dependency requiring another discipline to reassess, provide a new scoped position or validate an interface that was not covered by the completed contribution set.
3. **Material assumption or evidence defect:** an assumption, input, drawing, specification, reference, calculation or evidence item underpinning a required contribution is materially wrong, stale, contradictory or insufficient, and a competent discipline authority must reassess its effect.
4. **Material cross-discipline conflict:** the consolidated review reveals an unresolved conflict whose resolution requires new or revised discipline analysis rather than a decision that the appointed lead/authority can make within the existing mandate.
5. **Material dissent requiring technical re-evaluation:** a discipline's recorded dissent or reservation exposes a substantive technical issue that cannot be addressed by documenting the existing difference or escalating it within the consolidation authority.
6. **Authorized scope or assignment change:** the technical authority changes the required discipline set, scope, assumptions or accountable assignment in a way that requires new/revised contribution work. The scope change must be recorded before the return is treated as authorized.
7. **Material new information:** newly received information or evidence materially affects one or more completed contributions and requires their authors or competent discipline authorities to re-evaluate their conclusions.
8. **Consolidation integrity defect:** source-version mismatch, missing lineage or evidence integrity issue means the consolidated candidate cannot be reliably traced to the contributions on which it purports to rely, and the competent authority determines affected technical work must be repeated.

A return is not justified solely by stylistic preference, editorial wording, administrative delay, a late notification, workload indicator, recipient delivery/access/acknowledgement status, or an unsubstantiated desire to restart the process.

## 5. Issues that should not automatically trigger a parent return

| Issue | Recommended handling | Parent return? |
|---|---|---|
| Editorial formatting, grammar or clarity that does not change technical meaning | Appointed lead corrects within authority; preserve version history | No |
| Consolidated wording does not accurately reflect a completed contribution | Correct traceably within consolidation if no new technical judgement is required; otherwise refer to discipline authority | Only if substantive reassessment is needed |
| Existing contributions express different views, but all inputs are complete and the conflict is within the appointed authority's mandate | Record each position; resolve/escalate under conflict governance | Not automatically |
| Material conflict requires new discipline analysis or scope determination | Record the unresolved issue and affected disciplines; return | Yes |
| Missing originator information blocks technical assessment | Use clarification model under DISP-OR01-005 | Not by itself; use Awaiting Originator Clarification where parent-blocking |
| A contribution's evidence/version is stale or invalid | Determine affected scope; require the responsible discipline to verify/reissue its contribution | Yes if technical reassessment is required |
| New independent engineering question | Create linked new RFI under DEC-106 | No; separate RFI |
| Material controlled source-content change | Apply DEC-022-A/B classification and approved revision route | Not automatically; revision route governs |
| Recipient has not acknowledged or delivery failed | Track communication separately under DEC-103/108 | No |
| Reviewer requests a change while exact-version independent review is underway | Preserve review outcome/comments and route through DISP-OR01-008; determine whether targeted revision, full rework or return is required | Do not infer automatic return; review decision governs |
| Formal answer has already been issued | Use approved post-issue clarification/reopening/new-RFI governance | No silent return or edit |

## 6. Authority model: identify, recommend, authorize and execute

**Recommended separation:**

- **Any assigned technical contributor** may identify a specific gap in their own contribution and request a return recommendation within their assignment. This does not itself change the parent state.
- **Appointed technical lead** assesses cross-discipline impact and may initiate or recommend a return within the active appointment. The lead identifies affected disciplines, missing work, reason, candidate impact and proposed assignment actions.
- **Appointed technical authority / delegated assignment authority** decides disputed technical scope, adds/removes required disciplines, changes assignment scope, resolves authority gaps and approves exceptions outside the lead's explicit delegation.
- **Appointed coordinator / Document Control** may verify that the authorized decision and required record are present and execute an administrative state transition only if the project has explicitly delegated that action. The coordinator cannot determine technical materiality, require a discipline to redo work, remove a required contribution, close a conflict or decide the technical response.
- **Security / authorization** must enforce action-time authority for the exact project, party, RFI, cycle, discipline, assignment and action scope. Visibility or group membership is not authority.

Where the technical lead has explicit authority for the defined return decision, a separate technical-authority approval need not be invented as a universal dual-signature requirement. Where scope, competence, delegation or conflict is ambiguous, hold and refer to the designated technical authority. No appointment is inferred from title or availability.

## 7. Required return decision record

Before the parent returns, the record should identify:

1. Official RFI ID and active cycle; current parent state and version.
2. Return event ID, date/time, initiating actor and current appointment/delegation evidence.
3. Precise return reason and which §4 trigger applies.
4. Technical explanation of why the issue cannot be resolved within the current consolidation mandate.
5. Affected discipline(s), assignment(s), contribution(s), decision(s) and technical dependency.
6. Whether the return is limited to named work or requires broader reassessment; why the scope is proportionate.
7. Required new/revised technical outputs and acceptance/completion authority for each.
8. Any scope/assignment change, who authorized it, effective version and rationale.
9. Exact consolidated response candidate version and source contribution/evidence versions preserved at return.
10. Current clarification blockers, originator dependencies, material conflicts and dissent.
11. Impact on independent review, review comments, readiness status and any frozen candidate.
12. Re-entry conditions and the authority responsible for confirming them.
13. Parent state/version precondition and concurrency check outcome.

A generic reason such as “send back”, “revise” or “technical comments” is insufficient without identifying the actual gap and affected work.

## 8. Scope of return and discipline work

**Recommended baseline:** return only the affected technical work where the dependency is genuinely bounded; do not reset all discipline contributions by default.

- Affected discipline assignments return to an authorized work state with explicit required action, scope and due-date policy only if separately approved; no default SLA is created.
- Unaffected completed contributions retain their original identity, submitted version, author, appointment, evidence and completion history. They are not silently reopened or marked incomplete merely because another discipline must revise.
- If a new cross-discipline dependency makes an earlier contribution materially unreliable, that contribution must be explicitly included in the affected scope with technical rationale.
- Any reassignment or change in required discipline scope follows the appointed technical authority and DISP-OR01-004 principles; the coordinator cannot decide it.
- If all disciplines must reassess because the issue affects a common assumption, interface or baseline, the record must say so and explain why a narrow return is insufficient.
- Assignment and contribution states remain subordinate records. Their updates do not independently or automatically determine the parent state.

The exact subordinate labels and work-item transitions remain pending detailed design and specialist validation.

## 9. Contribution versioning and response-candidate preservation

1. A previously completed contribution is immutable historical evidence. A return does not erase, overwrite or silently reopen the original contribution.
2. Where the assigned discipline must change or supplement its technical position, it creates a new attributable contribution version or successor contribution record linked to the prior version. The exact versioning mechanism remains for detailed design.
3. A clerical correction that does not change technical meaning may follow a separately governed correction event; it must not be used to conceal substantive technical change.
4. The consolidated response candidate existing at return is preserved as a non-current/paused historical candidate with its exact source contribution versions and evidence manifest. It is not silently overwritten.
5. A successor consolidated candidate is created or versioned after the required reassessment and consolidation work is complete. It identifies which contribution versions changed and which were retained unchanged.
6. Every candidate must remain distinguishable as provisional, under consolidation, submitted for review, review-changed, or otherwise governed; no candidate is treated as issued unless formal issue succeeded under the approved issue gate.
7. Original RFI identity, submitted snapshot, prior response candidates, contribution versions, review comments and events remain traceable.

This memorandum recommends immutable lineage and successor versions as business outcomes, not a specific storage schema or database implementation.

## 10. Clarification, revision and post-issue interactions

- **Originator clarification:** if a gap requires information from the originator, apply DISP-OR01-005. The parent may enter Awaiting Originator Clarification only where a valid parent-progression blocker exists. A contribution-only blocker affects its defined contribution. Receipt/partial response is not resolution.
- **Resume after clarification during consolidation:** DISP-OR01-005 leaves the exact allowed source states and Under Consolidation handling open. Recommended conservative rule: if clarification is requested while consolidating, record the exact prior parent state and candidate version. After all relevant blockers are resolved, resume Under Consolidation only if the technical lead confirms the candidate and its source set remain valid; if the response exposes substantive new discipline work, route to In Technical Assessment under the authorized return rule. Do not auto-resume blindly.
- **Formal revision:** where the original RFI or controlled source content changes materially, classify under DEC-022-A/B. A return does not bypass formal revision requirements.
- **Linked new RFI:** an independent engineering question remains a new linked RFI under DEC-106; it must not be added as unrelated work in the original request.
- **Independent review:** a reviewer's change request is governed by the separate review process. Preserve the exact reviewed version and outcome; determine whether the issue requires targeted amendment, full re-review, or technical return under the approved review/return rules. No prior review outcome automatically approves a changed candidate.
- **After formal issue:** do not use this transition to alter an issued response. Apply the separately approved post-issue clarification, reopening or new-RFI route. Preserve the prior issue and recipient communications.

## 11. Re-entry to Under Consolidation

A return should not create an automatic loop or allow a coordinator to move the parent back when a comment is merely marked complete.

**Recommended re-entry gate:** after returned work is completed, the parent may re-enter Under Consolidation only when:

1. Every required contribution in the current authorized scope is complete and technically confirmed under DISP-OR01-006.
2. Every returned task has a current, attributable completion outcome and new contribution version where technical content changed.
3. Any scope/assignment change is authorized, recorded and reflected in the current required-contribution set.
4. All parent-progression clarification blockers are resolved under DISP-OR01-005; no unresolved blocker affects a required contribution.
5. Material conflicts and dissent are preserved and either within the consolidation mandate for resolution or referred to the competent authority; no unresolved blocker to the next gate is concealed.
6. The current response candidate is rebuilt/updated with exact contribution and evidence versions; superseded candidates remain preserved.
7. Technical lead appointment, discipline assignments, access and authority remain valid.
8. Current parent state/version and all evidence are rechecked; no concurrent withdrawal, cancellation, reopening, scope change or other transition has made the return package stale.

The parent remains In Technical Assessment if any required gate is incomplete, ambiguous or stale. The transition back to Under Consolidation is a new attributable parent event, not reversal or deletion of the prior return event.

## 12. Recommended transition and exception matrix

| Situation | Recommended parent outcome | Work/history treatment |
|---|---|---|
| Editorial correction within lead's mandate, no technical change | Remain Under Consolidation | New attributable candidate version/correction record as applicable |
| Gap requires one discipline to perform substantive new analysis | Return to In Technical Assessment | Reopen/assign only affected technical work; preserve other contributions and candidate |
| Gap affects multiple disciplines through shared assumption/interface | Return to In Technical Assessment | Record each affected scope and dependency; preserve unaffected work |
| Material conflict is resolvable within lead's appointment using complete inputs | Remain Under Consolidation | Record positions, rationale and dissent; no inferred concurrence |
| Material conflict requires new discipline analysis or authority outside lead scope | Return or hold pending technical authority decision | Preserve conflict and candidate; no majority vote |
| Missing originator information is a valid parent-progression blocker | Awaiting Originator Clarification under DISP-OR01-005 | Preserve candidate and exact resume point; re-evaluate after technical sufficiency decision |
| Clarification answer reveals substantive new discipline work | Route to In Technical Assessment under authorized return decision | Preserve request/response and affected candidate; create revised contribution versions |
| Required scope changes | Hold until technical authority records scope/assignment change; then return if new work is needed | Preserve old and new scope snapshots and assignment history |
| Reviewer requests material changes | Follow independent-review change/rework path; return only if that path requires technical reassessment | Preserve exact reviewed version and comments; re-review changed candidate as applicable |
| Source or evidence integrity is uncertain | Hold affected candidate and refer to competent authority; return if technical revalidation is required | Preserve evidence and custody history; no silent replacement |
| New independent question | Create linked new RFI | Original parent remains under its own lifecycle |
| Formal response already issued | Use approved post-issue route | Never edit issued version or erase issue/recipient history |
| Duplicate/stale return command | Reject or reconcile against current state/version | At most one valid ordered transition; preserve event history |

These are proposed business outcomes and test-design scenarios, not executed tests.

## 13. Version, concurrency and recovery safeguards

Before a return and before re-entry, verify:

- current parent state is Under Consolidation for the expected RFI cycle and version;
- the technical lead's appointment and scope remain active;
- the return decision references the current candidate and contribution/evidence versions;
- no concurrent review outcome, clarification resolution, scope change, withdrawal, cancellation, reopening or issue has superseded the proposed transition;
- only authorized affected assignments are changed; unaffected contribution history remains intact;
- a re-entry uses the current assignment/scope snapshot and all required contribution versions;
- duplicate/retried commands do not create duplicate return events, assignments or candidate successors;
- a failed or stale command does not partially alter parent state, contribution history or candidate status.

If a guard fails, do not commit a stale return or re-entry. Preserve the attempted action and refer to the designated authority where reconciliation is needed. Exact transaction, idempotency, locking, event and recovery mechanisms remain for architecture review. No DB change is authorized.

## 14. Failure and edge-case outcomes

| Scenario | Recommended outcome | Prohibited outcome |
|---|---|---|
| Lead requests stylistic edits only | Remain Under Consolidation | Reopen all disciplines |
| One discipline's calculation is materially incomplete | Return affected discipline work; parent returns to In Technical Assessment | Mark contribution complete or issue based on partial work |
| A conflict is within lead's appointment and all inputs are complete | Resolve/escalate within consolidation with dissent preserved | Automatic return for every disagreement |
| Conflict exceeds lead's appointment | Hold and refer to technical authority; return if new discipline work is required | Lead or coordinator decides outside appointment |
| Coordinator believes a document is administratively incomplete | Use separate DISP-OR01-003 correction route | Use technical return to bypass administrative return boundary |
| Originator clarification is needed | Apply DISP-OR01-005 blocker and resume logic | Treat as a discipline return or mark resolved on receipt |
| New originator response requires a new discipline analysis | Authorized return to In Technical Assessment | Resume consolidation without affected technical work |
| One contribution changes materially | Create new version; preserve prior version and rebuild affected candidate | Overwrite prior contribution/candidate |
| Unaffected contributions remain valid | Preserve as completed historical/current inputs | Reset all disciplines without reason |
| Scope expands to a new discipline | Technical authority approves scope and assignment change; return for work | Coordinator adds discipline by convenience |
| Review was completed on old candidate | Preserve outcome; reassess changed candidate under DISP-OR01-008 | Carry review clearance to changed content automatically |
| Formal answer already issued | Apply post-issue governance | Reopen technical assessment silently or edit issued response |
| Stale concurrent transition occurs | Reject/reconcile against current authoritative state | Commit conflicting parent transitions |
| Delivery or acknowledgement is pending | Keep communication status separate | Return technical work because a recipient has not acknowledged |

## 15. Owner decisions required

The owner should decide each point explicitly:

1. **Return trigger:** approve the material technical gap/dependency/conflict triggers in §4, or amend their scope?
2. **Non-return cases:** confirm editorial corrections and conflicts resolvable within the lead's mandate do not automatically cause parent return?
3. **Initiation and authority:** may an assigned discipline responder request a return, with the appointed technical lead making the scoped recommendation/decision within appointment and technical authority resolving scope/delegation disputes?
4. **Administrative execution:** may Document Control execute the parent state transition only after the authorized technical return decision and required evidence exist?
5. **Affected scope:** approve returning only affected discipline work where dependencies are bounded, rather than automatically reopening all contributions?
6. **Contribution versioning:** require a new attributable contribution version/successor whenever technical content changes, while preserving the previous contribution?
7. **Candidate preservation:** preserve the exact consolidated candidate as historical/non-current and create a successor candidate after reassessment, rather than overwrite?
8. **Clarification interaction:** confirm originator-dependent gaps use DISP-OR01-005, with guarded Under Consolidation resume only if the candidate remains valid; substantive discipline rework uses the return transition?
9. **Independent review:** confirm reviewer change requests remain governed by DISP-OR01-008, with exact reviewed versions and outcomes preserved?
10. **Re-entry gate:** require all current required contributions, blockers, scope, assignments and evidence to pass the DISP-OR01-006 gate before returning to Under Consolidation?
11. **Post-issue boundary:** confirm this return is pre-issue only and cannot modify an issued formal response?

## 16. Specialist validation requested

| Domain | Validation question | Evidence expected |
|---|---|---|
| Appointed technical lead / technical authority | Are return triggers clear enough to distinguish consolidation judgement from new discipline work? What decisions are within lead appointment? | Written authority boundary and representative cases |
| Discipline authorities | Are affected-scope and new-contribution rules appropriate? Which dependencies require multiple disciplines to reassess? | Discipline review and examples |
| Project/process owner | Are materiality, scope-change and exception routes operationally coherent? | Process review and authorized scope-change evidence |
| Document Control | Can parent return/re-entry, candidate versions and preserved contributions be traced without DC making technical decisions? | Records review and sample event lineage |
| Architecture | Can version-bound return, selective assignment rework, stale-state rejection and idempotent re-entry be supported? | Architecture/concurrency review; no DB change implied |
| Security | Are initiation, authorization, scope change, transition and assignment actions checked at action time? | Positive/negative authorization review |
| QA | Can material vs editorial change, selective return, clarification, review change, concurrency and post-issue negative cases be objectively tested? | Traceable test design; no execution implied |
| Records | Are prior contributions, candidates, reviews, dissent and successor versions retained and attributable under approved records rules? | Records classification and lineage review |

These are review domains, not named appointments or completed sign-offs.

## 17. Cross-specification dependencies and implementation boundary

This memorandum must reconcile with:

- **DISP-OR01-003:** technical return is not a generic administrative correction/return for completion.
- **DISP-OR01-004:** technical authority controls discipline scope and assignments; coordinator remains administrative.
- **DISP-OR01-005:** originator clarification blockers, partial responses, technical sufficiency and exact-state resume remain distinct; Under Consolidation source-state behavior still requires this reconciliation and specialist validation.
- **DISP-OR01-006:** re-entry must satisfy the complete required-contribution gate; provisional preparation does not satisfy it.
- **DISP-OR01-008:** independent-review triggers, reviewer changes and exact-version outcomes remain a separate pending decision.
- **DISP-OR01-009:** Ready for Issue remains separately gated; return/re-entry does not imply readiness.
- **DISP-OR01-010/013:** formal issue/closure and post-issue reopening/new cycle remain separate.
- **DEC-105/106/107/109/110 and DEC-022-A/B:** authority boundaries, clarification/revision/new-RFI distinctions, official identity/evidence history, no default SLA, verification and controlled-content change rules remain unchanged.

This memorandum does not amend DEC-103–DEC-110 or DEC-022-A/B; approve the complete lifecycle state machine; appoint actors; grant capabilities; define deadlines or contractual effects; implement workflow/UI/API/code; change DB/schema/migrations/generated types, Storage, authentication, authorization/RLS/grants or production data; execute tests; perform backup/restore; merge, deploy or release.

## 18. Technical recommendation summary

**Recommended baseline for owner consideration:**

1. Return from Under Consolidation only when a material technical gap, new dependency, invalidated contribution, material scope/evidence change or conflict requiring discipline reassessment cannot be resolved within the appointed consolidation mandate.
2. Keep editorial corrections and matters resolvable with complete inputs within Under Consolidation; do not return for every disagreement.
3. Allow assigned contributors to identify gaps; the appointed technical lead evaluates and authorizes the scoped return within appointment; technical authority resolves scope/appointment disputes; Document Control executes only a separately delegated administrative transition.
4. Return only affected discipline work where dependencies are bounded. Preserve unaffected contributions and their versions; broaden scope only with reasoned technical evidence.
5. Preserve the exact pre-return consolidated candidate and all source contribution/evidence versions. Technical changes create attributable successor contribution versions and a successor consolidated candidate; no silent overwrite.
6. Route originator information dependencies through DISP-OR01-005; reviewer changes through DISP-OR01-008; material controlled-content changes through DEC-022-A/B; independent questions to linked new RFI; post-issue matters through separate post-issue governance.
7. Re-enter Under Consolidation only after all current required contributions, blocker, scope, assignment, authority and version guards pass under DISP-OR01-006.
8. Treat every return and re-entry as a separate attributable parent event; no silent reset, automatic loop or inferred authority.

## 19. Owner disposition

**Disposition status:** **Conditionally approved** for the seven business principles summarized in §18.  
**Owner decision date:** 2026-11-12.  
**Decision evidence:** Explicit owner instruction “اعتمد” in the project decision conversation dated 2026-11-12, following presentation of the seven recommended principles in §18.

**Accepted scope:**  
1. Return from Under Consolidation only for a material technical gap, new dependency, invalidated contribution, material scope/evidence change or conflict requiring discipline reassessment beyond the appointed consolidation mandate.  
2. Editorial corrections and matters resolvable within the appointed lead's authority using complete inputs do not automatically trigger parent return.  
3. Assigned contributors may identify gaps; the appointed technical lead evaluates and authorizes a scoped return within appointment; the appointed technical authority resolves scope/delegation disputes; Document Control executes only an expressly delegated administrative transition after the technical decision.  
4. Return only affected discipline work where dependencies are bounded; preserve unaffected completed contributions and their histories.  
5. Preserve prior contribution versions and the exact consolidated candidate; substantive technical changes create attributable successor contribution versions and a successor candidate, with no silent overwrite.  
6. Keep originator clarification, independent review, formal revision, linked new RFI and post-issue matters under their separate governing routes.  
7. Re-enter Under Consolidation only after the DISP-OR01-006 required-contribution, blocker, scope, assignment, authority and version gates are re-satisfied; record each return/re-entry as a separate attributable event.

**Conditions and unresolved matters:** Specialist validation remains required from the appointed technical lead/authority, relevant discipline authorities, project/process owner, Document Control, architecture, security, QA and records as applicable. No specialist sign-off is claimed. Exact materiality examples, appointment/delegation evidence, discipline-specific work-state labels, candidate/version mechanics, clarification source-state handling, independent-review change paths, stale-state/concurrency and recovery mechanics remain subject to specialist review and detailed reconciliation.

**Preserved limits:** This owner disposition does not appoint actors, grant capabilities, approve the complete lifecycle state machine, set an SLA/clock pause/timeout/notification cadence/escalation/contractual effect/deemed acceptance, or authorize workflow implementation, test execution, DB/schema/migration/generated-type changes, Storage, authentication, authorization/RLS/grants, production-data operations, backup/restore, merge, deployment or release.

**Interim control:** No generic administrative reset, inferred technical authority, automatic reopening of all disciplines, silent overwrite, automatic return loop or re-entry using stale/ambiguous evidence. Where authority, scope, technical materiality or version validity is unclear, hold and refer to the designated authority.

---
**End of working draft — seven business principles conditionally approved by owner; specialist validation and detailed prerequisites remain pending.**
