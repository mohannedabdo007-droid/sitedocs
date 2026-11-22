# RFI Acknowledgement and Substantive Response Catalogue — Working Specification

**Status:** WORKING — FOR OWNER / DOCUMENT CONTROL / TECHNICAL AUTHORITY / CONTRACT / SECURITY / RECORDS REVIEW — NOT IMPLEMENTATION AUTHORIZATION  
**Work item:** RFI-DD-10 in `docs/71_RFI_DETAILED_SPECIFICATION_BACKLOG.md`  
**Dependencies:** DD-09 recipient identity and distribution; DD-07 transaction/idempotency; DD-08 evidence security.  
**Controlling decisions:** DEC-052, DEC-103, DEC-108 and DEC-110.

> This document defines a candidate RFI-specific catalogue and control model for acknowledgement and substantive recipient responses. It elaborates, but does not amend, DEC-052/103/108. Candidate labels and templates are not approved production vocabulary until owner and relevant authority review.

## 1. Purpose and required distinctions

Provide an unambiguous model for what a recipient is being asked to do after receiving an issued RFI response package.

The design must never collapse the following into one generic “response received” or “completed” state:
1. Technical delivery receipt from a channel.
2. Authenticated access evidence.
3. Explicit acknowledgement of receipt.
4. Explicit acknowledgement of review/awareness, if separately requested.
5. Substantive response to a defined request.
6. A technical decision in the source RFI workflow.

A successful event in one category does not satisfy another category unless an explicitly approved rule defines that relationship. In particular, acknowledgement is not engineering approval, and a recipient's substantive comments do not automatically reopen, revise or invalidate an issued RFI response.

## 2. Controlling policy and interpretation

- **DEC-052:** delivery receipt, access receipt, acknowledgement of receipt, acknowledgement of review/awareness, formal response and source-workflow decision are distinct. Requirements must be explicit per recipient and, where relevant, per manifest entry. Silence, read state and expiry do not create deemed acceptance or approval.
- **DEC-103:** only recipients explicitly classified Required for acknowledgement enter the required-acknowledgement denominator. Optional and Not Requested do not enter it. If no recipient is Required, aggregate acknowledgement is Not Required. Delivery and acknowledgement are independent.
- **DEC-108:** the issued response and frozen Transmittal manifest/recipient scope are the reference context. Same-package retries retain Transmittal identity; changed package or recipient scope requires a new linked Transmittal. Technical issue/closure is independent of distribution and acknowledgement.
- **DEC-021 / DEC-104–109:** current identity, party/project scope, capability and separation of duties apply to every consequential action; notifications and read events do not confer authority or complete a workflow.

## 3. Two independent request dimensions

For each intended recipient, store two separately governed request dimensions:

### 3.1 Acknowledgement requirement

- **Required:** explicit acknowledgement is required for the defined package or manifest entry.
- **Optional:** an acknowledgement may be recorded if provided, but is not required for aggregate completion.
- **Not Requested:** no acknowledgement is requested.

This classification controls only acknowledgement obligation and its DEC-103 aggregate denominator. It does not alter the technical-delivery denominator.

### 3.2 Substantive-response requirement

Candidate request classification:
- **Required:** a substantive response is explicitly requested from this recipient for the defined question/package scope.
- **Optional:** the recipient may provide a substantive response, but it is not an outstanding required action.
- **Not Requested:** no substantive response is requested.

This is a separate proposed response-obligation dimension, not a new DEC-103 acknowledgement denominator or a source RFI lifecycle state. Whether the project adopts this exact three-value vocabulary requires owner approval. Do not infer a substantive response requirement from acknowledgement status, recipient class, distribution, or a target date.

The two dimensions may differ. For example, a recipient may be required to acknowledge receipt but not asked for comments; another may be asked for a substantive response while receipt acknowledgement is not requested. Each setting must be explicit and attributable.

## 4. Acknowledgement catalogue

Candidate acknowledgement types:

| Type | Meaning | What it does not mean |
|---|---|---|
| Receipt acknowledgement | Confirms receipt of the identified Transmittal/package and manifest version | Does not prove review, understanding, agreement or approval |
| Review/awareness acknowledgement | Confirms the recipient states that the specified material has been reviewed or brought to their attention, only when expressly requested | Does not certify technical correctness, acceptance, no-objection or contractual compliance |
| Administrative receipt exception | Records inability to acknowledge normally, with a reason and supporting detail where appropriate | Does not count as a successful acknowledgement unless an approved rule explicitly defines an authorized substitute |

Receipt and review/awareness are different statements. Do not use one generic checkbox or label if the requested meaning differs. The exact wording, localization and legal effect require separate review.

A delivery receipt, mailbox read receipt, portal view, preview or download is system telemetry and must never be recorded as a human acknowledgement.

## 5. Substantive RFI response catalogue

Candidate response types for later owner/technical authority selection:

| Candidate type | Intended meaning | Boundary |
|---|---|---|
| Comments on issued response | Provides observations or comments against the exact issued response/package | Does not itself alter the issued response |
| Clarification requested | Identifies an ambiguity or asks for explanation of the issued response | Does not silently start a new RFI cycle or amend the response |
| Technical concern / objection | Records a reasoned technical concern against a defined statement or scope | Does not itself constitute a formal rejection or override the issuer |
| Additional information supplied | Provides evidence or information relevant to the response | Does not automatically become an accepted source record or revision |
| No further comment | States that the recipient has no further comment within the expressly stated review scope | Must not be labelled “approved”, “accepted” or universal “no objection” |
| Formal source-workflow referral | Requests consideration by an identified authorized source-workflow authority | The source workflow decision remains separate and must be made there |

These are candidate categories, not a default code set. Avoid generic A/B/C/D/E/I codes or generic “Approved/Accepted” choices for RFI recipient responses. WIR disposition codes must not be imported into RFI. Any project-specific “No Objection” or equivalent term requires explicit definition, scope, authority and contract/legal review; it must not be treated as technical approval by default.

## 6. Request definition and immutable context

For every acknowledgement or substantive response request, preserve:
- Request ID and request type (receipt acknowledgement, review/awareness acknowledgement, or substantive response).
- Requesting actor and authority/capability context.
- Intended recipient entry, represented party and verified identity context from DD-09.
- Exact Transmittal ID, manifest version and package integrity reference.
- Exact RFI identity, cycle, formal response version/revision and relevant manifest entries.
- Requested response type, explicit instruction, scope and permitted submission method.
- Required/Optional/Not Requested classification, separately for acknowledgement and substantive response.
- Request creation/issue timestamp and any target date supplied by an authorized source.
- Applicable policy/template version and language.
- Supersession/correction relationships, where relevant.

A request must point to the exact issued response/package. Do not resolve it dynamically to “latest”. A changed package or recipient scope requires a new linked Transmittal and corresponding request context under DEC-108; do not mutate old requests or their response history.

## 7. Recipient eligibility and authority to respond

1. Acknowledgement or substantive response must be submitted by an authenticated individual.
2. The actor must have current capability to act for the represented recipient party, project and exact Transmittal/request scope.
3. A mailbox, distribution list, email read receipt, shared login or forwarded link is not an individual acknowledgement unless a separately approved organizational identity model explicitly governs it.
4. The recipient's authority to acknowledge receipt may differ from authority to submit a substantive technical response.
5. A substantive response must be routed only to the authorized recipient party and the source RFI participants who need it; it must not be broadcast to every Transmittal recipient by default.
6. Document Control may track and distribute requests within delegated authority but cannot create technical response authority or decide the content.
7. A recipient's ability to access the package does not automatically grant ability to acknowledge or submit a formal response; each action is separately authorized at action time.

## 8. Submission and response record integrity

For each submitted acknowledgement or substantive response, preserve:
- Stable response/acknowledgement ID and event type.
- Authenticated acting person, represented party, current capability/appointment and authorization context.
- Server-recorded timestamp and timezone.
- Exact Transmittal, manifest, RFI cycle and response-version references.
- Acknowledgement statement or response category, structured fields and narrative.
- Scope of reviewed/commented material and any cited manifest entries.
- Evidence/attachment IDs and immutable version/integrity references where applicable.
- Submission channel, correlation/reference and idempotency outcome.
- Links to prior, corrected, clarified or superseding submissions.

The user must be shown the exact statement, response text and included evidence before final submission. Drafts remain visible only to their authorized author/team under DEC-008/021 and applicable project rules. Submission creates an attributable immutable record; later correction or supplement creates a linked subsequent record and never overwrites the original.

## 9. Candidate response lifecycle and event model

The following is a proposed tracking model, not an approved universal state machine:

| Stage/event | Meaning | Control |
|---|---|---|
| Not Requested | No substantive response request exists | Not an outstanding action |
| Requested | Authorized request issued to recipient | Binds exact package/request and requirement |
| Draft | Recipient is preparing a response | Private to authorized author/team |
| Submitted | Authenticated authorized actor formally submitted | Immutable submission event |
| Clarification Requested | Authorized recipient/source participant asks for clarification of the response | Records question, actor, scope and time |
| Supplement Submitted | A linked additional response/evidence is submitted | Preserves original response |
| Superseded | A later authorized submission replaces the current tracking reference | Historical record remains immutable |
| Withdrawn | An authorized withdrawal occurred where applicable rules permit | Does not erase original submission |
| Closed | Request is administratively concluded under an approved rule | Does not change source RFI technical lifecycle |

A separate response review state (if required) must be designed explicitly and must not be inferred from submission alone. The final lifecycle vocabulary, transitions, withdrawal rights and closure authority depend on DD-01/DD-02/DD-11 and owner review. Do not implement this candidate table as a state engine.

## 10. Clarification, correction, withdrawal and supersession

- A question that clarifies what a recipient meant in a submitted response should be linked to that response and request; it does not mutate the original.
- A correction or supplement creates a new linked event with author, reason, timestamp and relationship to the prior response.
- Withdrawal of a submitted response is permitted only where an explicitly approved rule identifies eligible states, actor authority, reason and effect. Do not assume the sender can erase a response after submission.
- Supersession must identify the replacing response and preserve the prior one and its status at the time.
- A substantive response that identifies a new independent engineering question must be routed through the technical authority for classification under DEC-106/ODM-08; if independent, it may require a new linked RFI rather than silently expanding the existing RFI.
- A recipient response cannot reopen, revise, cancel, withdraw or close the source RFI by itself.
- A request or response change must not rewrite the frozen Transmittal manifest or the original distribution history.

## 11. Due dates, reminders and silence

- Any target response date is informational/monitoring-only unless a separately approved project/contract rule defines its meaning.
- This catalogue creates no default SLA, contractual deadline, pause/resume clock, escalation threshold, deemed receipt, deemed response, acceptance by silence or waiver.
- Overdue indicators may identify an outstanding required request but cannot create a technical decision or alter the source RFI lifecycle.
- Reminders and notifications follow DEC-049 and DD-12 once defined; read/dismissed notifications do not acknowledge receipt or submit a substantive response.
- Silence, non-response, mailbox read status, expiry or failed delivery must never be interpreted as agreement, approval, no objection, acceptance or waiver.

## 12. Aggregation and reporting rules

### 12.1 Acknowledgement aggregation

Apply DEC-103 without change:
- Only recipient entries explicitly set to **Required** enter the acknowledgement completion denominator.
- **Optional** and **Not Requested** entries are excluded from that denominator.
- If no recipient is Required, the aggregate is **Not Required**.
- A Required recipient is complete only after a valid explicit acknowledgement of the requested type is recorded for the exact package/request.
- Technical delivery, access, preview, download, notification read or substantive response does not automatically satisfy the acknowledgement requirement.

### 12.2 Substantive response tracking

Track substantive response requests independently:
- Count by request and recipient, not as acknowledgement events.
- Distinguish Required, Optional and Not Requested only if that model is approved for this dimension.
- Report Requested, Draft, Submitted, Clarification Requested and other approved states as response-work tracking, not source RFI lifecycle.
- Do not combine response requests and acknowledgement requests into one completion percentage or one “recipient complete” flag.
- A substantive response being submitted does not imply that it has been reviewed, resolved or accepted by the source RFI authority.

### 12.3 Visibility and metrics

Every report must disclose its counting unit (recipient, acknowledgement request, response request, submission or event), source population, time period, timezone and as-of point. Apply current row-, field-, party- and attachment-level authorization. Recipients must not see other parties' response content or status without explicit authority.

## 13. Failure, duplicate and recovery behavior

| Scenario | Required handling |
|---|---|
| Unauthorized person attempts acknowledgement | Deny; preserve security event without creating a valid acknowledgement |
| Recipient acknowledges wrong/older package | Do not count against the current request; preserve the exact package reference and route for correction |
| Recipient submits twice after timeout | DD-07 idempotency prevents duplicate logical submissions; preserve attempt/correlation history |
| Acknowledgement submitted but confirmation lost | Reconcile the authoritative event before retry; do not create a second acknowledgement |
| Required recipient's delivery failed | Acknowledgement remains outstanding; delivery failure is not acknowledgement |
| Optional recipient acknowledges | Preserve the event, but do not alter Required denominator |
| No Required recipients | Aggregate acknowledgement is Not Required, not Complete by implication |
| Response contains new independent engineering question | Route for technical classification; create linked RFI if independently trackable under DEC-106 |
| Attachment is unavailable or integrity mismatches | Block or flag submission according to DD-08; do not silently substitute another file |
| Response is corrected or withdrawn | Preserve original; require authorized linked event and reason |
| Notification is read but no action submitted | No acknowledgement or response event is created by read telemetry |

## 14. Acceptance and verification catalogue

Candidate synthetic non-production tests under DEC-110:
- Receipt acknowledgement wording and record bind to exact Transmittal and manifest version.
- Review/awareness acknowledgement is distinct from receipt acknowledgement.
- Delivery receipt, authenticated access, acknowledgement and substantive response remain separate.
- Required-only denominator matches DEC-103; Optional/Not Requested are excluded; zero Required yields Not Required.
- A substantive-response request does not silently create an acknowledgement obligation, and vice versa.
- A mailbox read receipt or portal download cannot satisfy a human acknowledgement.
- An unauthorized or wrong-party actor cannot acknowledge or submit a substantive response.
- A valid recipient cannot submit a technical response beyond their party/project/request scope.
- Draft response content remains private to authorized author/team.
- Duplicate/timeout retries do not create duplicate acknowledgements or submissions.
- Corrections/supplements preserve prior responses and exact package references.
- A new independent technical question is classified under DEC-106 and not silently merged.
- Recipient response, silence or acknowledgement cannot approve, reopen, revise or close the source RFI.
- Reports distinguish acknowledgement requests, substantive response requests, submissions and source lifecycle.

Any unauthorized acknowledgement, incorrect denominator, duplicate logical submission, mutable response history, cross-party leakage or inferred technical approval is an acceptance blocker. These are proposed tests only; no tests are claimed as executed.

## 15. Open decisions and required reviewers

| Open decision | Required reviewers / authority |
|---|---|
| Exact acknowledgement wording and language/localization | Owner; Document Control; contract/legal authority as applicable |
| Whether receipt and review/awareness acknowledgement are both supported | Owner; project/contract communication authority; records |
| Whether substantive response Required/Optional/Not Requested is adopted as a separate dimension | Owner; technical authority; Document Control |
| Final RFI substantive response category catalogue and definitions | Owner; technical authority; project/contract authority |
| Per-recipient versus per-manifest-entry requirement granularity | Owner; Document Control; architecture |
| Which roles may acknowledge receipt versus submit substantive responses | Owner; identity/security; party authorities |
| Response review, clarification, withdrawal, supersession and closure authority | Owner; technical authority; records (DD-11 dependencies) |
| Response target dates, if any, and their contractual effect | Owner; contract/legal authority; project controls |
| Attachments, response evidence classification and retention | Security; records; privacy |
| Reporting, notification and reminder rules | Owner; security; project operations (DD-12/DD-13) |
| Legal/evidentiary effect and acceptable electronic acknowledgement method | Competent legal/contract authority; records; security |

Unresolved values remain **Blocked — Pending Authority Decision**. No wording, category, legal effect, due date or response authority is inferred from a generic Transmittal or role label.

## 15.1 DD-09 / DD-10 cross-specification review reference

The exact-version desk review is recorded in [docs/132 — DD-09 / DD-10 Recipient Communication Cross-Specification Review](132_DD09_DD10_RECIPIENT_COMMUNICATION_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md). It records RCP-01–RCP-12 and DEP-RCP-01–DEP-RCP-12, including the unresolved distinction between recipient-level and manifest-entry-level request granularity, action-specific authority for acknowledgement versus substantive response, immutable package/request binding, and independent delivery/acknowledgement/response aggregates. No wording, response category, legal effect or request granularity is approved by that desk review.

## 16. Governance alignment and implementation boundary

This working specification elaborates DEC-052, DEC-103 and DEC-108 and remains consistent with DEC-021, DEC-049, DEC-050/051, DEC-104–110 and DD-07–09. It does not amend any approved decision, define a universal response code set, grant recipient capabilities, or make a source RFI technical decision.

**Design only:** no acknowledgement/response form, workflow or status engine, API/UI/code, database/schema/migration/generated types, Storage, authentication/authorization/RLS/grants, notification provider, external delivery integration, production-data operation, live workflow test, merge or deployment is authorized. Any implementation requires a separate detailed lifecycle and capability plan, security/records/contract review, test plan, non-production rehearsal and explicit owner approval. Database/Storage work remains subject to verified backups, isolated restore/rehearsal and reconciliation gates.
