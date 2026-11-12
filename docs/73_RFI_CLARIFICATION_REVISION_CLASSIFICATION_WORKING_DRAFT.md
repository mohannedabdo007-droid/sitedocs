# RFI Clarification, Formal Revision and Linked-New-RFI Classification — Working Specification

**Document type:** Detailed-design working specification; non-authoritative  
**Date:** 2026-11-12  
**Status:** WORKING — FOR TECHNICAL / OWNER REVIEW — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Controlling governance baseline:** `governance/scan-lifecycle-design-2026-11-11`  
**Related work:** RFI-DD-05 in `docs/71_RFI_DETAILED_SPECIFICATION_BACKLOG.md`; lifecycle/authority model in `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`

> This specification elaborates the owner-confirmed principles in DEC-104, DEC-106 and DEC-107, and applies the existing DEC-022-A/B numbering and revision boundaries. It is a classification aid, not a new owner decision. It does not approve a general RFI revision workflow, alter the approved lifecycle, or authorize implementation.

## 1. Purpose and governing distinctions

Every follow-up to a submitted RFI must be classified into one of three distinct paths:

1. **Clarification round** — additional explanation, evidence or completion that helps answer the original engineering question without materially changing the controlled inquiry.
2. **Formal revision** — a controlled-content change to the same RFI, only where the applicable approved document-family correction/resubmission rule permits and requires revision under DEC-022-B. This is not a generic label for every follow-up or a substitute for reopening an issued response.
3. **Linked new RFI** — a materially independent engineering question or decision that can be separately answered and tracked without changing the original inquiry.

These paths are not interchangeable. A clarification round is not a document revision; a revision is not a new RFI identity; a linked new RFI is not a way to erase or silently expand the original. The official RFI number, formal revision, clarification-round identifier, response version, contribution identifier and Transmittal ID remain separate identifiers.

## 2. Controlling approved constraints

- DEC-104 ODM-08: retain the same RFI for explanation/completion of the original question; create a linked new RFI for a materially independent technical decision or independently trackable scope; classification is by the technical lead or delegated technical authority with a recorded reason.
- DEC-104 ODM-09: use a clarification-round identifier for follow-up that does not materially change the controlled inquiry; use a formal revision only when the approved document-control rule classifies a material change to formal RFI content.
- DEC-106: clarification of the original question remains in the same RFI; an independent/independently trackable question creates a linked RFI and is classified by an authorized technical lead/authority with reason. Clarification rounds are distinct from formal revisions. A substantive change follows DEC-022-A/B. Post-issue response withdrawal is not permitted; reopening requires an authorized technical authority and a new cycle while preserving the prior issue/closure.
- DEC-107: official RFI number is assigned only on successful first formal submission; it is stable and never reused. Draft IDs, RFI numbers, formal revisions, clarification rounds, contribution IDs, response versions and Transmittal IDs must not be conflated. Submitted snapshots and attachment manifests are immutable.
- DEC-022-A: internal draft ID at draft creation; official number only on successful first formal submission; failed/abandoned drafts consume no official number.
- DEC-022-B: first formal issue is Rev.00; a controlled-content change after return/correction creates the next sequential revision; resubmission without controlled-content change retains the same revision; each revision has its own immutable snapshot and review/approval/signature/audit history; prior revisions are not overwritten and approvals/signatures do not carry across revisions. The official number remains stable. Minor/major labels and metadata-only treatment remain open for document-type profiles.

Nothing in this specification extends DEC-022-B to an unapproved RFI transition. In particular, it does not decide whether or how an RFI may be revised outside the approved return/correction context.

## 3. Classification decision sequence

Apply the following sequence to the proposed follow-up, not merely to its title or the user's chosen label.

### Gate 1 — Is the follow-up about the same original engineering question?

- If it supplies explanation, missing context, a requested reference, a response to a clarification request, or supporting evidence needed to understand the original question, continue to Gate 2.
- If it introduces a separate technical question, distinct design decision, materially different physical/work/package scope, independent cause, or an outcome that can be answered and tracked independently, classify it as a **candidate linked new RFI** and proceed to Gate 3.
- If the relationship is unclear, do not force a classification. Preserve the existing submitted record and route the ambiguity to the authorized technical classifier.

### Gate 2 — Does it materially change the controlled inquiry?

- If no: use a **clarification round** under the same RFI identity. The original submitted inquiry snapshot remains unchanged. Record the clarification request/response and any new evidence as attributable, versioned events.
- If yes: do not call it a clarification merely because it is phrased as an explanation or arrives in a clarification response. Proceed to Gate 3 to decide whether it is a controlled change to the same inquiry or an independent inquiry.
- A clarification response may reveal that the original inquiry was incomplete or based on a misunderstanding. That fact alone does not determine the path; assess the actual effect on scope, decision and controlled content.

### Gate 3 — Is the materially changed content still the same underlying inquiry?

- If the technical objective and decision boundary remain the same, but controlled RFI content must be corrected or materially changed, classify it as a **candidate formal revision** only if the applicable approved RFI correction/resubmission path permits that revision under DEC-022-B.
- If the change creates a distinct engineering decision or independently answerable/trackable scope, create a **linked new RFI**. Preserve the original inquiry and its lifecycle unchanged except for an authorized relationship event.
- If neither path is clearly supported by an approved transition or authority rule, classify as **Blocked — Pending Design/Authority Decision**. Do not invent a revision route, overwrite the snapshot, or append the independent scope to the existing RFI.

### Gate 4 — Has a formal response already been issued?

- Before formal issue: apply the same-RFI clarification / applicable correction-revision / linked-new-RFI tests above, subject to the approved lifecycle gates.
- After formal issue: the issued response and its closure history are immutable. Do not revise, withdraw, or replace the issued response in place. If the original technical answer requires further work, an authorized technical authority must decide whether the RFI is reopened into a new cycle under DEC-106 or whether a materially independent question requires a linked new RFI.
- A new response cycle does not erase or supersede the historical fact that the earlier response was issued. Prior reviews and approvals do not automatically apply to changed content.

## 4. Materiality criteria

No single criterion is determinative in isolation. The authorized technical classifier should record the affected dimensions and explain the overall conclusion.

| Dimension | Usually clarification (non-material) | Potential material change / revision candidate | Potential independent scope / linked new RFI |
|---|---|---|---|
| Engineering objective | Explains the same objective | Changes the controlled wording/requirement needed to preserve the same objective | Introduces a different objective or decision |
| Technical decision | Requests explanation of the same decision | Alters an assumption or input that changes the same decision's controlled basis | Requires a separate technical decision that can stand alone |
| Physical / design scope | Clarifies location or reference already within original scope | Corrects a scope description while retaining the same defined subject | Adds a different asset, area, system, package or work scope independently answerable |
| Discipline interface | Clarifies an existing interface question | Changes the controlled interface definition for the same inquiry | Introduces a separate discipline/interface question with independent disposition |
| Design basis / criteria | Supplies missing citation or explains existing basis | Changes a controlled criterion/assumption within the same inquiry, where correction/revision is permitted | Seeks a separate alternative, deviation or design approval |
| Evidence / attachments | Adds evidence supporting the original question without changing its meaning | Replaces/corrects controlled evidence in a manner that changes the formal inquiry snapshot | Evidence concerns a separate issue or separate scope |
| Response consequence | Explains or completes the answer to the same question | Requires re-evaluation of the same question against materially changed controlled content | Can be answered and closed independently of the original |
| Contract / cost / programme / safety impact | Clarifies an existing impact statement without changing the question | Changes the controlled basis or risk of the same question | Raises a distinct issue requiring its own technical disposition |

**Important:** “Potential” means the classifier must assess the full context; it is not an automatic rule. No cost, schedule, safety or quantity threshold is established here.

## 5. Classification outcomes and record treatment

### 5.1 Clarification round — same RFI

Required record elements proposed:

- Stable official RFI number and current applicable formal revision (if any).
- Unique clarification-round identifier, sequence and timestamp.
- Exact clarification request, requester, authority/scope, reason and affected question/discipline/contribution.
- Originator's exact response and response timestamp, or an explicit no-response/withdrawal event where separately authorized.
- Added references/attachments as new attributable evidence versions; never replace the original submitted manifest.
- Whether the clarification blocks one or more technical actions and the recorded prior stage to resume when all blocking requests are resolved.
- Classification rationale confirming that the controlled inquiry was not materially changed.

A clarification round does not consume a new RFI number, does not increment the formal revision by itself, does not create a new RFI, and does not rewrite the submitted snapshot. It does not itself answer, approve, issue or close the RFI.

### 5.2 Formal revision — same RFI identity

A formal revision is available only when an approved RFI correction/resubmission rule applies. The specification must not invent a free-standing “revise” action.

Where DEC-022-B applies:

- Preserve the official RFI number.
- First formal issue is Rev.00.
- A controlled-content change after an authorized return/correction creates the next sequential revision.
- Resubmission with no controlled-content change retains the same revision.
- Freeze a new immutable content and attachment manifest for the revision.
- Preserve the previous revision and its review/approval/signature/audit history.
- Require fresh review/approval against the new revision; no prior signature or approval carries forward.
- Keep clarification-round identifiers separate from revision identifiers.

The exact set of RFI fields that constitute controlled content, treatment of metadata-only changes, and the applicability of the return/correction path to each RFI stage remain open. A proposed change outside the approved DEC-022-B conditions is blocked pending an explicit document-family rule.

### 5.3 Linked new RFI — separate identity

A linked new RFI is required when the follow-up is materially independent or independently trackable.

- Create a new draft and allocate a new official RFI number only on its successful first formal submission under DEC-022-A.
- Record a typed relationship to the original RFI (for example: related question, follow-on scope, split-out issue, or clarification-derived independent issue). These are candidate relationship labels, not approved final vocabulary.
- Record the classification authority, reason, affected scope and date.
- Do not copy the original RFI's authority, assignments, contributions, reviews, approvals, response or recipients as if they automatically apply to the new RFI.
- Reuse of source references or evidence must preserve provenance and independently enforce access rights.
- The original RFI is not automatically revised, reopened, closed, withdrawn or otherwise changed merely because a linked RFI is created.
- Any cross-reference visible to a user must respect authorization on both records; knowledge of one RFI must not reveal restricted metadata or attachments from the other.

## 6. Authority and escalation

1. The technical lead or a specifically delegated technical authority classifies the technical relationship and materiality, recording the rationale (DEC-104/106).
2. The coordinator may identify a possible duplicate, clarification or scope split and may request classification, but cannot make the technical classification solely for administrative convenience.
3. The originator may explain intent and supply facts but cannot unilaterally dictate that a material change is “only clarification” or force a new RFI classification.
4. Document Control preserves identity, revision and records integrity; it does not decide engineering materiality or issue authority.
5. If the technical lead's appointment does not cover the affected discipline/scope, or a material conflict exists, refer the classification to the authorized technical authority. Escalation does not itself grant authority.
6. If there is no valid appointment, no agreed technical scope, unresolved material conflict, or no approved transition for the proposed change, keep the action blocked and preserve the current authoritative record.
7. Any disagreement or dissent is retained with attribution; no majority vote or silence is treated as concurrence.

## 7. Event, version and linkage integrity

The following identities must remain distinct:

| Identity | Meaning | Must not be used as |
|---|---|---|
| Official RFI number | Stable identity of one formally submitted RFI | Revision or clarification-round number |
| Formal revision | Controlled document-content revision under DEC-022-B | Clarification round or new RFI |
| Clarification-round ID | Follow-up exchange on the same controlled inquiry | Formal revision or new RFI |
| Response version | Exact candidate/formally issued technical response | RFI revision or Transmittal ID |
| Contribution ID/version | Attributable discipline input | Consolidated response or RFI identity |
| Linked RFI number | Separate official identity related to another RFI | A revision of the original |
| Transmittal ID | Controlled distribution package identity | RFI identity, response version or acknowledgement |

For each classification event, retain at minimum: source RFI and cycle/version; proposed change; classification outcome; affected controlled fields/scope; decision rationale; actor and authority/appointment context; timestamp; linked clarification/revision/new-RFI identifier; affected evidence references; and any dissent or escalation.

Submitted and issued snapshots are immutable. A new event/version may reference prior content, but must not silently replace it. Access to the record, its attachments and linked records is independently authorized at action time.

## 8. Concurrency and conflict guards

- Classification must be bound to the exact submitted RFI snapshot and version assessed. If the source version changes before the consequential action, re-evaluate against the current version.
- Concurrent clarification and revision/new-RFI classification attempts must not silently overwrite one another. Conflicting decisions are held for authorized resolution.
- Repeated client submission of the same classification command must not create duplicate clarification rounds or duplicate linked RFIs; idempotency design remains a technical dependency.
- A linked RFI submission must not partially alter the source RFI if its own submission fails.
- Formal issue, reopening, revision and clarification actions must be serialized or otherwise guarded so a stale classification cannot mutate an already issued/closed snapshot.
- Exact transaction, locking, idempotency-key and stale-version mechanics belong to DD-07 and are not specified or implemented here.

## 9. Decision examples for review

| Scenario | Candidate classification | Reason / guard |
|---|---|---|
| Originator explains an abbreviation or confirms a reference already requested | Clarification round | Same question; no controlled inquiry change |
| Originator supplies a missing dimension needed to interpret the original question | Usually clarification; assess materiality | If it merely completes context, same RFI; if it changes the technical basis/scope, escalate |
| Technical responder asks which of two already-listed drawing references is intended | Clarification round | Resolves ambiguity within original scope |
| Originator adds a supporting photograph showing the originally described condition | Clarification round | New evidence, same inquiry; preserve as new evidence version |
| Originator changes the requested design solution or adds a different design alternative | Candidate revision or linked new RFI | Determine whether same decision boundary remains; do not assume clarification |
| Originator adds a different building/area/system not included in the original scope | Linked new RFI candidate | Independently trackable physical scope |
| A multi-discipline RFI receives a new question that can be answered independently by another discipline | Linked new RFI candidate | Preserve original assignments and contributions; do not append unrelated scope |
| A returned RFI has a controlled question correction within the same inquiry | Formal revision candidate under DEC-022-B | Next sequential revision only if approved return/correction rule applies |
| A returned RFI is resubmitted with only a missing administrative field completed and no controlled-content change | Same revision | DEC-022-B; preserve return and resubmission history |
| A follow-up challenges an already issued response on the same question | Authorized reopening candidate | Preserve prior issue/closure; new response cycle under DEC-106 |
| A follow-up after issue asks a separate engineering question | Linked new RFI candidate | Do not revise or withdraw the issued response |
| A request mixes clarification of the original with a separate independent question | Split: clarification + linked new RFI candidate | Keep the original clarification focused; separately classify the independent issue |
| Classifier cannot determine whether the scope is independent | Blocked — Pending Design/Authority Decision | Preserve original record; no silent scope expansion |

These are candidate examples for review, not exhaustive or automatically binding rules.

## 10. Acceptance criteria and traceability

DD-05 is ready for technical review only when reviewers can demonstrate that:

1. Every follow-up is evaluated against the same-question, materiality, independence and post-issue gates.
2. Clarification rounds do not mutate submitted snapshots, consume RFI numbers or increment formal revisions by default.
3. Formal revisions are created only under the applicable approved DEC-022-B return/correction conditions; same-content resubmission retains its revision.
4. Linked new RFIs receive separate official identities only on successful first formal submission and preserve a typed, authorized relationship to the source.
5. Issued responses and prior closure/review history remain immutable; post-issue changes route through authorized reopening or a linked new RFI.
6. Classification is attributable to a properly appointed technical authority, with rationale, scope and version recorded.
7. Uncertain or unauthorized classifications fail closed and remain pending rather than being guessed.
8. Evidence, access rights, concurrency conflicts and duplicate commands are addressed in the detailed test design.

Candidate acceptance scenarios should be mapped to DEC-110's functional/lifecycle, authorization-negative, concurrency/idempotency, evidence/history and reporting controls. This document does not claim any test has been executed or passed.

## 11. Open decisions and dependencies

The following remain unresolved and must not be inferred:

- Exact RFI controlled-content field set and metadata-only change treatment.
- Whether the RFI family has an approved return/correction route that invokes DEC-022-B at each candidate lifecycle stage.
- Exact post-issue reopening trigger and classification authority mapping for each technical discipline.
- Final relationship-type catalogue and whether one follow-up may be split into multiple linked RFIs.
- Required evidence and attachment classifications for clarification versus revision.
- Detailed classification authority appointment, delegation and conflict-of-interest mapping.
- Idempotency, concurrency and transaction contract (DD-07).
- Final lifecycle transition model and how clarification requests resume prior stages (DD-01).
- Test-case identifiers and evidence retention details (DD-15).

Until these are resolved, any consequential path depending on them is **Blocked — Pending Design/Authority Decision**.

## 12. Governance alignment and implementation boundary

This working specification is intended to remain consistent with DEC-002, DEC-022-A/B, DEC-104, DEC-106, DEC-107 and DEC-110. It does not amend those decisions, create a new owner-approved policy, or settle unresolved document-family rules.

**Design only:** no RFI workflow/state engine, clarification or revision action, numbering allocator, API/UI/code, DB/schema/migration/generated types, Storage/upload/replacement/deletion, auth/RLS/grants, notification/delivery provider, production-data operation, live workflow test, backup/restore operation, merge or deployment is authorized. Any implementation requires a separately reviewed plan, security/records impact assessment, test plan, non-production rehearsal and explicit owner authorization. Database/Storage changes remain subject to verified backups, isolated restore/rehearsal and reconciliation gates.
