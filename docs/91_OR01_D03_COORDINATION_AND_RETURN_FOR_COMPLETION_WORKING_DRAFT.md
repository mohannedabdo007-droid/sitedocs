# OR-01 / DISP-OR01-003 — Coordination and Return for Completion

**Document type:** Detailed lifecycle decision review memorandum  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — DISP-OR01-003 CONDITIONALLY APPROVED BY OWNER FOR OPTION C — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Source detailed specification:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`, §§3.2–3.5 and responsibility/capability matrices  
**Controlling governance:** DEC-104, DEC-105, DEC-106, DEC-107, DEC-109, DEC-110; DEC-022-A/B where controlled-content revision classification is implicated

> This memorandum proposes a bounded administrative return model for owner and specialist review. It does not approve a transition, appoint an actor, amend governance or authorize workflow implementation or test execution.

## 1. Decision question and scope

DISP-OR01-003 asks when an official RFI may move from **Under Coordination** to **Returned for Completion**, who may authorize that action, what constitutes an eligible deficiency, and how the originator's subsequent response returns the same official RFI to coordination without erasing its submission history.

The review is limited to administrative completeness and intake coordination. It does not authorize the coordinator to judge engineering adequacy, decide technical scope, resolve discipline conflicts, determine the technical answer, or replace a formal clarification/revision process.

## 2. Protected constraints

The following controls remain fixed and are not reopened here:

1. **DEC-105:** the RFI coordinator performs administrative coordination only. A coordinator title does not grant engineering judgment, technical conflict resolution, review, issue or closure authority.
2. **DEC-107:** an official number is allocated only on the first successful formal submission. A post-submission return preserves that official identity and number; it is not a failed initial submission and does not create a replacement RFI number.
3. **DEC-022-A/B:** if a returned item changes controlled technical content materially, classify that change through the existing formal revision policy. A return action itself is not a revision and cannot silently overwrite the submitted snapshot.
4. **DEC-109:** lifecycle status is distinct from workload, aging, notification and communication indicators. No default SLA, pause rule, escalation cadence or contractual effect is created here.
5. **DEC-110:** the eventual design must support traceable positive and negative authorization tests, invalid-transition denial, concurrency/idempotency, evidence/history preservation and failure/recovery testing. No tests are claimed executed.
6. **DEC-106:** preserve the distinct meanings of clarification, withdrawal, cancellation, reopening and closure. An administrative return is not a disguised withdrawal, cancellation or technical rejection.

## 3. Technical recommendation — narrow administrative return

**Recommended direction for owner consideration:** permit a return for completion only where an objectively identifiable administrative/intake deficiency prevents the RFI from being routed or coordinated in accordance with the approved administrative intake checklist.

The return should be:
- specific to the official RFI and the exact deficiency identified;
- issued by a currently authorized and appropriately scoped administrative coordinator, or a separately designated records/document-control authority where the governing appointment explicitly permits that action;
- accompanied by a mandatory reason code or controlled reason category, a clear factual explanation, the missing/corrective information requested, and attributable actor/time evidence;
- limited to correction of the identified administrative deficiency;
- reversible only through a recorded originator completion/resubmission event and subsequent administrative verification;
- auditable as a new lifecycle event, retaining the earlier successful submission, official number, submitted snapshot, prior routing events and any earlier return/completion rounds.

This recommendation does not select a final reason taxonomy or appoint a particular role/person.

## 4. Candidate eligible administrative deficiencies

The following are examples for validation, not an exhaustive or approved taxonomy:

| Candidate category | Possible evidence | Boundary |
|---|---|---|
| Administrative identification mismatch | Project/party/originator metadata inconsistent with the authorized project register | Do not change engineering meaning or infer party authority |
| Missing administrative routing information | Required discipline/recipient routing metadata absent or invalid under an approved project rule | Coordinator may identify the missing routing datum, not decide the engineering discipline where ambiguous |
| Incomplete administrative context | Required location, asset, drawing/document reference or work-package identifier absent where the approved form requires it | Do not decide whether the technical question is adequate |
| Attachment administration defect | Referenced attachment is missing, inaccessible to the authorized workflow or does not match the declared attachment list | Do not replace, alter or silently remove evidence; preserve custody/history and refer security/integrity issues to the appropriate authority |
| Duplicate or conflicting administrative registration | Evidence indicates the same request may already have an official identity | Do not merge, cancel or renumber automatically; escalate for controlled identity reconciliation |
| Formal submission metadata inconsistency | A required administrative field conflicts with authoritative project/party records | Preserve the submitted snapshot; corrections must be attributable and versioned |

**Open dependency:** the project must approve the mandatory administrative intake checklist and permitted reason categories before any return action can be operationalized. Missing or ambiguous criteria must not be filled by coordinator discretion.

## 5. Excluded grounds — not an administrative return

The following should not be used as a coordinator-initiated Returned for Completion reason:

- the coordinator considers the engineering question technically weak, incorrect, unsafe, incomplete in engineering substance or outside the technical solution preferred by the coordinator;
- a discipline responder disagrees with the question or wants it rewritten to make the technical answer easier;
- a technical conflict exists between disciplines or reviewers;
- a formal clarification is needed from the originator after technical assessment has begun;
- a formal revision is required because controlled technical content has materially changed;
- an authorized technical reviewer has requested technical rework;
- a technical answer is unfavorable, unavailable or delayed;
- the originator has not responded within an assumed/default period.

These matters belong to the relevant technical assessment, clarification, revision, review, withdrawal/cancellation or monitoring process under the applicable authority. Silence or elapsed time must not create an automatic return, rejection or cancellation.

## 6. Stage eligibility and timing — alternatives for owner decision

The source draft leaves open whether a return is permitted after technical work begins. Three models merit explicit consideration:

### Option A — Strict pre-assessment administrative return

Return is permitted only while the official RFI is in **Under Coordination** and before it enters **In Technical Assessment**.

- Advantage: clean separation between administrative intake and technical work.
- Limitation: an administrative metadata defect discovered after routing cannot use the same parent transition without a separately defined correction mechanism.
- Safeguard: later discoveries are corrected through a controlled administrative record amendment or separately defined exception, not by pretending the technical assessment never began.

### Option B — Administrative return at any pre-issue stage

A return may occur after technical work begins if a genuine administrative defect is discovered.

- Advantage: permits correction of material administrative errors discovered late.
- Risks: can interrupt technical work, obscure which contributions remain valid, or be misused to route technical objections through an administrative action.
- Minimum safeguards: exact administrative reason category, independent confirmation where technical work is active, explicit impact assessment for assignments/contributions/reviews, no silent reset of technical stage or history, and a controlled resumption rule.

### Option C — Hybrid (technical recommendation)

Use Option A as the normal rule. If a genuine administrative defect is discovered after technical assessment begins, do not apply a generic Returned for Completion transition. Record the defect and refer it to the designated process/records authority for a separately authorized correction path; the parent lifecycle remains unchanged unless an explicit owner-approved transition rule governs the case.

**Recommendation:** Option C offers the clearest separation of duties while avoiding the fiction that late-discovered administrative defects do not exist. It is a recommendation only; the owner must choose the permitted stage gate and exception route.

## 7. Authority and separation of duties

| Actor / function | Candidate permitted action | Prohibited inference |
|---|---|---|
| Originator | Respond to the exact completion request and resubmit corrected administrative information | Cannot self-clear the return without required verification |
| RFI coordinator | Identify and document administrative deficiencies; initiate return only under explicit scoped capability and approved reason rules | No technical adequacy decision, discipline-scope decision, conflict resolution, technical rejection, issue or closure |
| Document Control / records authority | Validate record identity and administrative metadata only where an explicit appointment/delegation grants that capability | Job title or document access alone does not confer return authority |
| Technical lead / discipline authority | Advise on technical impact where an administrative defect touches active technical work; use technical clarification/rework routes for substantive issues | Cannot relabel a technical disagreement as an administrative deficiency |
| Security / architecture | Validate authorization, evidence integrity and safe correction paths | Review participation does not create operational appointment |
| Project owner / process authority | Decide the project policy, permitted stage gate, reason categories and exception path | Owner policy approval does not itself appoint named operational users |

Every consequential action remains subject to current server-side authorization at action time under the approved capability model. A hidden UI control is not an authorization boundary.

## 8. Return notice and evidence requirements

A candidate return record should capture, at minimum, as business-level evidence:

- stable official RFI identity and current cycle;
- return event identifier and sequence/round;
- prior parent state and exact transition point;
- one or more controlled administrative reason categories;
- factual explanation and precise missing/corrective information requested;
- affected field/metadata/attachment reference, where relevant;
- requester/originator notified through the separately governed communication process, without assuming a notification channel or SLA;
- issuing actor, active appointment/capability basis, project/party scope and event timestamp;
- any technical-impact referral, specialist finding or dissent where work had already begun;
- relationship to the immutable original submission snapshot and any later correction/version;
- completion/resubmission event, verifier, verification result and subsequent routing decision.

This is a requirements checklist, not a database schema or field-level implementation mandate. Do not store credentials, secrets or unnecessary personal information in the reason text.

## 9. Originator completion and return to coordination

**Recommended business sequence:**

1. Authorized actor records the administrative return with a specific reason and evidence.
2. The official RFI remains the same numbered record; the original successful submission and its snapshot remain preserved.
3. The originator supplies the requested correction as an attributable completion/resubmission event. A new official RFI is not created merely because the original was returned.
4. Any corrected controlled content is versioned; material technical change is classified under DEC-022-A/B rather than silently accepted as a metadata correction.
5. The authorized administrative verifier checks only the stated administrative deficiency and records the result.
6. If complete, the RFI may return to **Under Coordination** under the approved transition authority. If incomplete, another separately recorded return round may be considered only if the approved policy permits it.
7. The coordinator then routes the RFI onward under the distinct DISP-OR01-004 process. Completion of an administrative return does not itself authorize technical assessment, appoint discipline responders or establish technical acceptance.

A failed or incomplete correction must not erase the previous return, overwrite the original submission, or generate a new official number.

## 10. Parent lifecycle, subordinate work and reporting

- Returned for Completion is a parent lifecycle state only if the owner approves that model; it must not be confused with a subordinate attachment/metadata task status.
- Any active assignment, contribution, clarification, review or Transmittal history must remain independently traceable.
- The parent state must not be changed merely because an email/notification was sent, delivered, opened or acknowledged.
- Aging/workload reporting may identify time spent in return or awaiting originator completion, but no SLA, clock pause, escalation or contractual consequence is inferred.
- Repeated return rounds should remain separately countable and attributable; reporting must distinguish number of RFI records from number of return events/rounds.

## 11. Failure, concurrency and negative cases

| Scenario | Required design outcome | Prohibited outcome |
|---|---|---|
| Coordinator lacks current scoped capability | Deny return; retain state and audit attempted action as permitted | UI visibility or job title grants authority |
| Reason is vague or absent | Reject the return command as incomplete | Generic “incomplete” return with no actionable explanation |
| Technical disagreement presented as admin defect | Route to technical authority; no administrative return | Coordinator makes technical judgment |
| RFI already in technical assessment (Option A/C normal rule) | Deny generic return; use approved exception/correction route if applicable | Silently reset to Under Coordination |
| Originator submits correction twice | Preserve one attributable completion outcome or safely reconcile duplicates | Duplicate transitions or duplicate official identities |
| Correction is incomplete | Preserve prior return and record verification failure; follow approved next step | Delete or overwrite prior return |
| Correction materially changes technical content | Apply DEC-022-A/B classification and required review | Treat as clerical completion to bypass revision/review |
| Original attachment is replaced | Preserve original evidence/version and custody; add new version | Silent replacement of submitted evidence |
| Notification delivery fails | Keep lifecycle outcome independent; record communication failure separately | Reopen or undo return because a notification failed |
| Concurrent return and completion actions | Reconcile against current version/state; at most one valid ordered transition | Conflicting or duplicated lifecycle history |
| Duplicate RFI suspected | Refer to controlled identity reconciliation | Automatically merge, cancel or renumber |
| No originator response | Apply no default timeout consequence; use separately approved monitoring/escalation policy if one exists | Automatic rejection, cancellation or SLA assumption |

These are proposed design/test scenarios, not executed or passed tests.

## 12. Owner decisions required

The owner should record a discrete disposition for each question below; a general approval of the memorandum must not be interpreted as answering every item unless explicitly stated:

1. **Eligibility taxonomy:** Which administrative deficiency categories are permitted, and who approves changes to that catalogue?
2. **Stage gate:** Option A, B or C — at which parent states can an administrative return be issued?
3. **Late-discovered defect:** What correction/exception route applies if an administrative defect is found after technical work begins?
4. **Return authority:** Which role/authority may issue the return, and what appointment/delegation evidence is required?
5. **Independent check:** Is a second administrative verifier required for any category or stage?
6. **Return rounds:** Are repeated return rounds permitted, and what controls prevent repetitive or abusive returns?
7. **Originator completion:** What constitutes sufficient completion evidence and who verifies it?
8. **Content/version impact:** Which corrections are metadata-only, and which require formal revision classification under DEC-022-A/B?
9. **Technical work in progress:** What happens to active assignments/contributions/reviews when a late administrative defect is discovered?
10. **Communication:** Which separately governed notice/recipient process informs the originator, without creating an assumed channel or SLA?

## 13. Specialist validation requested

| Domain | Validation question | Evidence expected |
|---|---|---|
| Document Control | Are the administrative intake checklist, reason categories and evidence trail complete and usable? | Reviewed checklist and sample records |
| Process owner | Is the stage gate and exception route operationally workable and consistent with project governance? | Written process disposition |
| Technical authority | Do excluded technical grounds remain routed through the correct technical clarification/rework/revision process? | Boundary review and examples |
| Architecture | Can retries, concurrent correction and return commands preserve one ordered, auditable lifecycle history? | Design review; no implementation implied |
| Security | Are return/completion capabilities checked at action time and scoped to the exact project/RFI/party? | Positive/negative authorization review |
| QA | Are invalid return, stale state, duplicate correction, version mismatch and history-preservation cases testable? | Traceable test design; no execution implied |
| Records | Are original submission, return rounds and corrections preserved under the applicable records rules? | Records classification/schedule reference; no retention period invented |

These are review domains, not named appointments or completed sign-offs.

## 14. Proposed technical recommendation summary

For owner consideration, the preferred model is:

- administrative return is narrow and evidence-based;
- ordinary return is limited to the pre-technical **Under Coordination** stage;
- a technical issue is never relabelled as an administrative deficiency;
- a genuine late-discovered administrative defect uses a separately authorized correction/exception route, not an automatic parent-state reset;
- the official RFI identity, number, original submission snapshot and all prior events remain preserved;
- originator completion is a new attributable event, followed by administrative verification and a governed return to Under Coordination;
- formal revision, technical clarification, withdrawal, cancellation, notification and external delivery remain separate processes.

**Owner disposition recorded:** Option C is conditionally approved for the bounded scope and conditions in §16. The detailed reason taxonomy, appointments, operational exception authority and downstream transition mechanics remain subject to specialist validation and further decisions.

## 15. Explicit exclusions

This memorandum does not amend DEC-104–DEC-110 or DEC-022-A/B; approve a final reason taxonomy or transition matrix; appoint a coordinator or verifier; grant capabilities; define SLA/retention/contractual effects; create UI/API/code/workflow/state-machine behavior; change DB/schema/migrations/generated types, Storage, authentication, authorization/RLS/grants or production data; execute tests; perform backup/restore; merge, deploy or release.

---
**End of working draft — Option C conditionally approved by owner for the recorded scope; specialist validation and remaining detailed decisions pending. No implementation authorization.**


## 16. Owner disposition — DISP-OR01-003 / Revision 1

| Field | Recorded disposition |
|---|---|
| Disposition ID / revision | DISP-OR01-003 / Rev 1 |
| Decision authority / evidence | Project owner; explicit instruction in the project decision conversation dated 2026-11-12: “أعتمد C ..اوافق” |
| Disposition status | **Conditionally approved — Option C (hybrid stage gate)** |
| Accepted scope | The normal administrative return-for-completion route is limited to the pre-technical-assessment stage (Option A as the normal rule). If a genuine administrative defect is discovered after technical assessment begins, it must not trigger a generic Returned for Completion transition or silently reset the parent lifecycle. The defect is recorded and referred through a separately authorized administrative correction/exception path. The parent lifecycle remains unchanged unless a distinct, explicit owner-approved transition rule governs the case. |
| Preserved safeguards | Administrative coordination remains separate from technical judgment under DEC-105. The official RFI identity/number, original successful submission snapshot, prior routing, technical contributions, review evidence and event history must remain traceable. A correction does not create a new RFI number merely because it follows an administrative return. Any material change to controlled technical content remains subject to DEC-022-A/B. Communication, delivery, access, acknowledgement and workload indicators remain separate from the parent lifecycle. |
| Conditions / not decided | Specialist validation is pending. The permitted administrative-defect taxonomy/checklist, designated correction authority and appointment evidence, independent verification requirements, effect on active technical assignments/contributions, correction completion criteria, repeat-round controls and detailed transition mechanics are not approved by this disposition and require separate review/decision. No default SLA, timeout, contractual effect or automatic pause is created. |
| Specialist review / dissent | Pending; no specialist sign-off or dissent is claimed. |
| Limits | This is a scoped owner disposition only. It does not finalize the complete RFI state machine, appoint an operational actor, grant capabilities, authorize workflow/UI/API/code implementation, DB/Storage/authentication/authorization/RLS changes, test execution, merge, deployment or release. |
| Effective date | 2026-11-12 |

**Interpretation rule:** Option C approval must not be broadened into Option B. A late-discovered administrative defect is not, by itself, authority to interrupt technical work, invalidate prior technical contributions, move the parent RFI backward, or alter its official identity. The separately authorized correction path and its impact on active work remain subject to specialist validation and any further owner disposition required.
