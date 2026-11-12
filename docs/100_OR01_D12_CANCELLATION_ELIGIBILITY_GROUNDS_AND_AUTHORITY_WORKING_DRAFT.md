# OR-01 / DISP-OR01-012 — Cancellation Eligibility, Grounds and Authority

**Document type:** Detailed lifecycle decision review memorandum  
**Date:** 2026-11-12  
**Status:** WORKING DRAFT — DISP-OR01-012 CONDITIONALLY APPROVED BY OWNER FOR THE RECORDED SCOPE — SPECIALIST VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent worksheet:** `docs/88_RFI_OR01_LIFECYCLE_DECISION_DECOMPOSITION_WORKING_DRAFT.md`  
**Disposition register:** `docs/87_RFI_DECISION_DISPOSITION_REGISTER_WORKING_DRAFT.md`  
**Owner review package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md`  
**Related work:** DEC-104–DEC-110; DISP-OR01-010 and DISP-OR01-011; DD-01, DD-06, DD-07, DD-08, DD-09, DD-11 and DD-14.

> This memorandum recommends a narrow administrative cancellation route for an invalid or duplicate RFI registration. It does not authorize cancellation of an issued response, decide a technical question, appoint an authority, approve a final lifecycle state machine or authorize implementation/testing.

## 1. Decision question and scope

DISP-OR01-012 determines:
1. Which grounds qualify as administrative cancellation rather than withdrawal, return for completion, technical rejection, correction or reopening?
2. Which lifecycle points remain eligible, and what is the cutoff?
3. What evidence proves a duplicate or invalid registration?
4. Who may raise the matter, validate it and authorize cancellation?
5. When is technical-lead concurrence required?
6. How are duplicate/canonical records, contributions, reviews, evidence and communication history preserved?
7. How do cancellation and formal issue, withdrawal or another competing action interact?

This item concerns the administrative outcome **Cancelled**. It does not decide the separate withdrawal route (DISP-OR01-011), post-issue reopening (DISP-OR01-013), or formal issue/technical closure (DISP-OR01-010).

## 2. Controlling governance and protected boundaries

1. **DEC-106:** cancellation is administrative only, requires an evidenced permitted ground and a designated authority; technical-lead concurrence is required after technical work has begun. Cancellation must not become technical rejection or an alternative to withdrawal.
2. **DEC-105:** coordinator and Document Control do not gain decision authority by handling records. Authority is appointment-, party-, project- and scope-bound.
3. **DISP-OR01-010:** successful formal issue and technical closure are one atomic business outcome. Once issue commits, pre-issue cancellation is unavailable; cancellation cannot reverse or erase the issued response.
4. **DISP-OR01-011:** withdrawal is a voluntary originator-requested route. Cancellation is a separate administrative route and must not be used to bypass the originator-request boundary.
5. **DEC-107/109:** official identity, audit history and records lineage remain preserved. Cancellation is not deletion, number recycling, retention expiry or archive disposition.
6. **DEC-108:** any Transmittal, delivery, access, acknowledgement and substantive-response history remains a separate immutable communication record.
7. **DEC-110:** proposed acceptance criteria require traceable authority, reason, evidence, expected result and negative/concurrency coverage; no tests are executed here.

## 3. Recommended meaning of administrative cancellation

Administrative cancellation is an authorized, evidence-based terminal administrative disposition of an RFI registration that should not continue as an active RFI because a permitted administrative defect is established.

It is not:
- an engineering answer, technical rejection or adverse technical disposition;
- a substitute for an originator's withdrawal request;
- a way to avoid technical review, conflict resolution or an unfavorable outcome;
- a correction to the contents of an already issued response;
- an automatic consequence of a missed target date, inactivity, non-response, failed delivery, recipient silence or overdue indicator;
- a deletion, archival disposition or erasure of the official record.

The decision must identify the exact official RFI and active pre-issue cycle, the ground, supporting evidence, decision authority and any required technical-lead concurrence.

## 4. Recommended permitted grounds

### 4.1 Baseline grounds

Recommend that the baseline permitted grounds be narrowly limited to:

1. **Duplicate official registration:** two or more official RFI identities represent the same originating request because of a proven duplicate submission/registration. The cancellation record must identify the surviving canonical RFI and establish the duplicate relationship.
2. **Invalid registration:** objective evidence establishes that the record was not validly registered as the intended RFI under the approved project/party/document-family rules. Examples for specialist validation include a demonstrably unauthorized or misattributed registration, a record created against the wrong project/party/document family, or a registration created by a verified technical/system duplication defect.

These examples are candidates for review, not an exhaustive approved taxonomy. A clerical defect that can be corrected without terminating the RFI should use the authorized correction/return route instead.

### 4.2 Grounds not permitted by default

Do not cancel because:
- the technical question is difficult, disputed, unanswered or likely to receive an unfavorable answer;
- the originator no longer wishes to pursue the question (use DISP-OR01-011);
- a required field or supporting document can be supplied through the ordinary completion route;
- an assigned engineer, reviewer or coordinator is unavailable;
- a target date has passed, the RFI is aging, or a notification was not acknowledged;
- a Transmittal failed, a recipient did not respond, or external distribution is inconvenient;
- the RFI is under technical assessment, consolidation or independent review and the work is inconvenient to continue;
- the record should be archived, retained, deleted or removed from a dashboard.

Any additional ground requires a separate explicit owner/project-policy decision and competent specialist review. No broad "cancel for any reason" discretion is recommended.

## 5. Eligibility and pre-issue cutoff

Recommend that cancellation may be authorized only before successful formal issue of the active RFI cycle.

Candidate pre-issue states for possible eligibility include Submitted, Under Coordination, Returned for Completion, In Technical Assessment, Awaiting Originator Clarification, Under Consolidation, Under Independent Review and Ready for Issue. This is a candidate state set, not final state-machine approval; each state and ground must be checked against the approved project policy.

After successful issue/technical closure:
- cancellation is not available;
- the issued response and closure remain authoritative historical records;
- use the applicable clarification, formal revision, authorized reopening/new cycle or linked-new-RFI route;
- do not relabel the issued RFI Cancelled or imply the issue never occurred.

A cancellation request/review pending at the time of issue does not defeat an issue transaction that validly commits first.

## 6. Who may raise, validate and authorize cancellation

Recommend separating referral from decision:

1. **Raise/referral:** any participant who identifies a suspected duplicate or invalid registration may submit an attributable referral with the facts/evidence. A referral is not a cancellation request on behalf of the originator and does not change lifecycle state.
2. **Administrative validation and decision:** only a designated records/workflow authority with a current, evidenced appointment for the exact project/party/RFI scope may validate the ground and authorize cancellation.
3. **Technical concurrence:** where substantive technical work has begun, the currently appointed technical lead must provide recorded concurrence/impact assessment under DEC-106. The concurrence does not itself authorize cancellation.
4. **Additional external concurrence:** obtain client/owner/contract/records/legal concurrence only where an applicable approved project or contractual rule requires it. No universal extra signature is invented here.
5. **Administrative execution:** a coordinator may perform the administrative transition only under explicit delegation after the decision. Document Control may record and communicate the outcome but has no cancellation authority merely by title.

If the designated authority, delegation, scope or role compatibility is missing, expired, disputed or unavailable, hold and refer. Do not infer authority from job title, membership, read access or system-administrator status.

## 7. Technical-work cutoff and concurrence

Use the same evidence-based substantive-work boundary recommended for DISP-OR01-011 to avoid inconsistent definitions across terminal administrative outcomes.

Activities that do not, by themselves, establish substantive technical work include submission, coordinator intake, administrative completeness checks, assignment creation/acceptance, file viewing, notification, automated indexing and an empty contribution placeholder.

Evidence that substantive technical work has begun includes attributable technical analysis of the question/evidence, a substantive discipline contribution, a technical clarification raised for a genuine engineering dependency, a material conflict assessment or technical review of a response candidate.

The evidence must identify actor, active appointment/scope, activity, timestamp, exact RFI/cycle and relevant contribution/candidate version. Where work has begun, recorded technical-lead concurrence is required. If no valid lead exists or the lead's scope/appointment is disputed, hold; do not infer concurrence from silence or coordinator action.

Where substantive work has not begun, DEC-106 does not itself impose technical-lead concurrence. Any additional requirement must come from an explicit project rule; it must not be invented by this memorandum.

## 8. Duplicate registration and canonical-record reconciliation

For a duplicate case:
- identify the canonical surviving RFI using documented evidence and the authorized records rule;
- identify every duplicate RFI ID and the exact relationship to the canonical record;
- record why the canonical record was selected, who decided, the authority basis and effective timestamp;
- retain each duplicate's official number permanently; never recycle or silently renumber it;
- preserve all contributions, reviews, attachments, evidence, clarifications, response candidates and communication events on the RFI where they were originally created;
- do not automatically merge, copy, transfer, reassign or relabel historical content, attachments, Transmittals, recipient lists, acknowledgements or access rights;
- if information is relevant to the canonical RFI, create an explicit, attributable cross-reference or a new authorized submission under the canonical RFI's own scope and controls;
- keep the duplicate-to-canonical mapping auditable and permission-controlled.

If canonical identity is uncertain, multiple records have materially different scope, or reconciliation would risk losing provenance, do not cancel or merge; hold for records/Document Control and technical authority review.

## 9. Invalid registration and correction boundary

Invalid registration must be supported by objective evidence that the registration itself is invalid, not merely that its technical content is incomplete or contested.

Before cancellation, determine whether the issue can be corrected through a separately authorized administrative correction/return route without terminating the RFI. Where the record belongs to another project/party/document family, do not silently move it or change its identity; hold for an authorized correction decision and establish whether a new correctly scoped RFI is required.

Cancellation does not authorize automatic transfer of the official number, evidence, assignments or work products to a replacement record. Any replacement or linked RFI must have its own valid submission, identity and lineage under DEC-107.

## 10. Required decision record and outcomes

Minimum evidence:
- cancellation/referral ID and event type;
- official RFI ID, active cycle, current state and exact version references;
- ground code and reasoned narrative;
- supporting evidence and duplicate/canonical link where applicable;
- referring actor and authenticated party context;
- validating/deciding authority, appointment/delegation and exact scope;
- technical-lead concurrence and work evidence if required;
- any project/client/contract concurrence required by an approved rule;
- issue/withdrawal/cancellation concurrency check and authoritative event/version reference;
- decision timestamp, outcome and preserved-history references.

Proposed administrative review outcomes (not new parent lifecycle states):
- **Referral received:** no parent state change.
- **Pending validation:** ground, identity, evidence or authority not yet established.
- **Pending technical concurrence:** substantive work has begun and required concurrence is outstanding.
- **Cancelled:** authorized ground and all applicable gates satisfied before formal issue.
- **Rejected / not eligible:** evidence does not establish a permitted ground; current valid RFI state remains.
- **Deferred / held:** authority, canonical mapping, scope, evidence or concurrency is uncertain.
- **Superseded by issue:** issue committed first; referral remains historical and non-effective.

## 11. Preservation and downstream effects

Cancellation must preserve:
- official RFI number and original successful submission snapshot;
- all prior state transitions, assignments and appointment evidence;
- discipline contributions, clarifications, technical notes, conflicts/dissent and reviews;
- response candidates, evidence versions and package manifests;
- cancellation referral, ground, validation, concurrence and decision history;
- all Transmittal, delivery, access, acknowledgement and substantive-response history;
- duplicate/canonical relationships and any later authorized cross-references.

Cancellation must not:
- delete or overwrite the record or its evidence;
- reuse or silently renumber its official ID;
- copy or merge records without an explicit authorized, auditable action;
- imply technical rejection, technical acceptance, formal response, closure or recipient notice;
- automatically revoke access, delete files, shorten retention or release a legal hold.

Archive, retention, legal hold and disposition remain separate under DEC-109/DD-14.

## 12. Interaction with withdrawal, issue, revision and reopening

- **Withdrawal:** voluntary originator-requested pre-issue route under DISP-OR01-011. Cancellation cannot be used where the real reason is simply that the originator no longer wants the RFI.
- **Formal issue/closure:** atomic under DISP-OR01-010. If issue commits first, cancellation is ineligible; if cancellation validly commits first, stale issue must fail. No contradictory dual success.
- **Administrative correction:** correctable deficiencies use the separately authorized correction/return route; cancellation is not a shortcut for missing information.
- **Technical rejection/disagreement:** never an administrative cancellation ground.
- **Reopening/revision/clarification:** post-issue actions follow their own governed routes; cancellation cannot rewrite the issued response or prior closure.
- **Linked new RFI:** a genuinely independent question receives its own official identity and explicit predecessor link.

## 13. Concurrency, idempotency and failure handling

1. Validate the current RFI/cycle state, authority, scope and evidence at the consequential commit.
2. Serialize cancellation against formal issue/closure, withdrawal and other terminal administrative actions.
3. If issue commits first, cancellation fails as ineligible and preserves the referral.
4. If cancellation commits first, formal issue and competing withdrawal must fail their stale-state guard.
5. Duplicate retries must return/reconcile one logical cancellation outcome; they must not create multiple terminal events or canonical mappings.
6. Timeout-after-success must be reconciled against authoritative event history before retry.
7. Revoked/expired appointment, changed party/project scope, changed canonical mapping or changed evidence version invalidates the pending decision until revalidated.
8. Partial failure must not expose the RFI as both Cancelled and active/issued, or duplicate identities as silently merged.
9. Preserve failed attempts, denial reasons, transaction correlation and recovery evidence.
10. No database transaction, locking, schema or idempotency implementation is approved here.

## 14. Proposed acceptance criteria for later test design

Design-only criteria; no tests have been executed:
1. A participant may raise a referral but cannot authorize cancellation without the current scoped appointment.
2. Cancellation is blocked where no approved administrative ground or objective evidence exists.
3. Technical merits, unfavorable outcome, originator convenience, missed target date, silence, failed delivery or archive status cannot justify cancellation by default.
4. A correctable administrative deficiency follows its approved correction route rather than cancellation.
5. Cancellation after formal issue is denied and the issued response/closure remains unchanged.
6. Where substantive technical work has begun, cancellation requires attributable current technical-lead concurrence.
7. Missing/expired/disputed authority or lead appointment holds the decision.
8. Duplicate cancellation identifies the canonical RFI and preserves both IDs and all original evidence/communication lineage without automatic merge.
9. A wrong-project/party/document-family case cannot silently transfer the RFI or its official number.
10. Cancellation preserves official number and complete history; no deletion or number reuse.
11. Issue-versus-cancellation concurrency produces one authoritative winner and no partial/dual success.
12. Duplicate/retried cancellation does not create duplicate terminal events or canonical mappings.
13. Unauthorized direct action/API attempts fail even if UI controls are hidden/disabled.
14. Referral receipt, notification or Document Control action alone never changes the parent lifecycle.

Confirmed unauthorized cancellation, post-issue cancellation, technical-merits cancellation, overwritten evidence/history, number reuse, silent merge/transfer, invalid authority or contradictory concurrent outcomes is a blocking defect.

## 15. Owner decision points

The owner is asked to decide the business recommendations, not specialist or statutory matters:
1. Approve the narrow baseline grounds (proven duplicate registration and objectively invalid registration) while requiring a separate explicit decision for any additional ground.
2. Confirm the pre-issue-only cutoff and that no cancellation may reverse successful issue/technical closure.
3. Confirm that a referral may be raised by a participant but only a designated records/workflow authority may validate and authorize cancellation.
4. Confirm technical-lead concurrence after substantive technical work begins, using the same evidence-based threshold as DISP-OR01-011.
5. Confirm that a duplicate must retain its own official identity/history and be linked to a canonical RFI without automatic merge/transfer.
6. Confirm that correctable administrative deficiencies use a correction route, not cancellation.
7. Confirm that cancellation is distinct from withdrawal, technical rejection, closure, revision and reopening.
8. Confirm that any external/client/contract concurrence is required only where an approved project/contract rule expressly says so.
9. Confirm issue/cancellation concurrency by the first valid authoritative commit, with no contradictory dual success.
10. Confirm no deletion, number reuse, retention change or legal/contractual effect is created by cancellation.

## 16. Conditions and interim controls

Specialist validation and authority prerequisites remain pending after the owner disposition. Until those prerequisites are satisfied:
- treat duplicate/invalid grounds as recommendations only; no operational cancellation is authorized;
- hold where canonical identity, evidence, authority, appointment, technical-work status, concurrence or issue state is missing/stale/disputed;
- do not cancel for technical merits, originator convenience, inactivity, missed target, recipient silence, failed delivery or archival reasons;
- do not merge, transfer, renumber, delete or purge any RFI or evidence;
- do not cancel after successful issue; use the appropriate post-issue route;
- preserve the complete history and communication lineage.

Specialist validation remains required from project/process owner, appointing/records authority, technical lead and discipline authorities, Document Control, architecture, security, QA, records and contract/legal governance as applicable. No specialist sign-off is claimed.

No default SLA, clock pause, timeout, notification cadence, escalation, deemed receipt, deemed acceptance or contractual notice effect is created.

This memorandum does not appoint actors, grant capabilities, approve a final full lifecycle state machine, authorize workflow/UI/API/code implementation, test execution, DB/schema/migration/generated types, Storage, authentication, authorization/RLS/grants, production-data operations, backup/restore, merge, deployment or release.

## 17. Technical recommendation summary

Adopt a narrow, evidence-based, pre-issue administrative cancellation route limited by default to proven duplicate registration or objectively invalid registration, with any additional ground requiring separate explicit approval. A participant may refer a suspected defect, but only a currently appointed records/workflow authority may validate and authorize cancellation. Require recorded technical-lead concurrence after substantive work begins. Preserve every official identity, original record, contribution, review, evidence and communication event; duplicate reconciliation uses an auditable canonical link without silent merge or transfer. If issue commits first, cancellation is blocked; if cancellation commits first, competing issue is blocked. Cancellation must never become technical rejection, originator withdrawal, deletion or a post-issue correction route.

## 18. Open decisions and required specialist reviewers

| Open decision | Required review |
|---|---|
| Exhaustive permitted grounds and definition of invalid registration | Owner; project/process owner; records; Document Control; contract governance |
| Exact pre-issue eligible-state list | Owner; technical authority; Document Control; architecture |
| Appointment authority, scope and delegation evidence for cancellation decision | Project governance; records authority; security |
| Technical-work threshold and lead appointment/concurrence evidence | Technical authority/lead; discipline specialists; QA |
| Additional external/client/contract concurrence | Contract/project governance; owner |
| Canonical-record selection and legacy-number conflicts | Document Control; records/data stewardship; architecture |
| Correctable-defect versus cancellation classification | Process owner; Document Control; technical authority |
| Exact action record, transaction, idempotency and recovery design | Architecture; security; QA; records |
| Notice/communication handling and legal effect | Document Control; contract/legal; security; records |
| Retention, legal hold, backup/replica and disposition | Records; legal/privacy; security; operations |

Unresolved items remain **Blocked — Pending Authority Decision/Prerequisite**. No default is inferred.

---
## 18.1 DD-11 cross-specification review reference

The exact-version DD-11 cross-specification review is recorded in [docs/142 — DD-11 Reopening, Withdrawal and Cancellation Cross-Specification Review](142_DD11_REOPENING_WITHDRAWAL_CANCELLATION_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md). RCL-01–RCL-15 and DEP-RCL-01–DEP-RCL-15 specifically review the narrow duplicate/invalid-registration grounds, correctable-defect boundary, canonical duplicate lineage, substantive-work concurrence, issue race, immutable communication history and DD-14 records dependencies. The desk review does not expand cancellation grounds or close specialist prerequisites.

## 19. Owner disposition — Revision 1

**Disposition ID:** DISP-OR01-012  
**Recorded date:** 2026-11-12  
**Owner decision:** **Conditionally approved** for the ten principles and exact scope set out in §15 and summarized in §17. The owner explicitly instructed: “اعتمد”.  
**Approved scope:** The narrow baseline grounds are proven duplicate official registration and objectively invalid registration; any additional ground requires a separate explicit owner decision. Cancellation is pre-issue only. Any participant may raise a referral, but only a currently appointed records/workflow authority with evidenced scope may validate and authorize. Recorded technical-lead concurrence is required after substantive technical work begins. Correctable administrative deficiencies use a correction route. Duplicate records retain distinct official IDs and histories and are linked to a canonical RFI without silent merge/transfer. Cancellation remains distinct from withdrawal, technical rejection, closure, revision and reopening. Any external/client/contract concurrence is required only where an approved rule expressly requires it. Issue/cancellation concurrency is resolved by the first valid authoritative commit. No deletion, number reuse, retention change or legal/contractual effect is created.
**Conditions:** Specialist validation remains required from the project/process owner, appointing/records authority, technical lead and discipline authorities, Document Control, architecture, security, QA, records and contract/legal governance as applicable. No specialist sign-off is claimed. Exhaustive permitted grounds, exact eligible states, invalid-registration evidence taxonomy, appointment/delegation evidence, technical-work threshold, canonical-record selection, correction boundary, external concurrence and concurrency/recovery mechanics remain subject to specialist confirmation.
**Interim control:** Until specialist validation and dependent authority/evidence prerequisites are satisfied, no operational cancellation is authorized under this disposition. Hold uncertain grounds, authority, appointment, technical-work evidence, concurrence, canonical mapping or issue state. No technical-merits cancellation, post-issue cancellation, silent merge/transfer, renumbering, deletion or archival disposition.
**Implementation boundary:** This conditional owner approval does not appoint actors, grant capabilities, approve a final lifecycle state machine, authorize workflow/UI/API/code implementation, test execution, DB/schema/migration/generated types, Storage, authentication, authorization/RLS/grants, production-data operations, backup/restore, merge, deployment or release.

**End of working draft — DISP-OR01-012 conditionally approved for the recorded scope; specialist validation pending. No implementation or test execution is authorized.**
