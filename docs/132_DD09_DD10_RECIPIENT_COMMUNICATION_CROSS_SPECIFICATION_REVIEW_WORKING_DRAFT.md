# DD-09 / DD-10 Recipient Communication Cross-Specification Review — Working Draft

**Document type:** Exact-version desk review and cross-specification reconciliation  
**Date:** 2026-11-12  
**Status:** DESK REVIEW ONLY — OWNER / CONTRACT / SECURITY / IDENTITY / DOCUMENT CONTROL / RECORDS / QA VALIDATION PENDING — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Reviewed specifications:** docs/77 (DD-09), docs/78 (DD-10), docs/75 (DD-07), docs/76 (DD-08), docs/82 (DD-14), docs/83 (DD-15), docs/131 (DD-07/DD-08 evidence transaction and manifest contract)  
**Controlling decisions:** DEC-050, DEC-051, DEC-052, DEC-103, DEC-108, DEC-110; related DEC-021, DEC-049, DEC-104–DEC-109.

> This is a desk review of working drafts against recorded governance constraints. It is not owner approval, legal/contract interpretation, provider validation, identity/security sign-off, test execution or implementation authorization. No provider, channel, recipient entitlement, acknowledgement wording, response category, deadline, legal effect or capability is selected by this review.

## 1. Executive conclusion

The DD-09 and DD-10 drafts establish a coherent separation between recipient identity, technical delivery, authenticated access, explicit acknowledgement, substantive response and source-RFI technical decision. Their central controls are consistent with DEC-050/051/052, DEC-103 and DEC-108 and can be aligned with the exact-version manifest, immutable evidence, idempotency and recovery principles in docs/131.

**Desk-review result:** 0 direct normative contradictions identified in the reviewed text. This does not mean that the specifications are complete or approved. Twelve cross-specification findings and twelve unresolved authority/dependency items are recorded below. Several issues require explicit owner/contract/security/identity/records decisions before the specifications can be promoted.

## 2. Review method and exact-version scope

The review compared:
- DD-09 recipient identity, nomination, validation, channel options, recipient snapshots, delivery events, access scope, retries, revocation, privacy and exceptions;
- DD-10 acknowledgement/substantive-response dimensions, request binding, actor authority, immutable submissions, response lifecycle, corrections, aggregation and failure handling;
- DD-07 command identity, idempotency, replay, transaction boundaries and event recovery;
- DD-08 evidence/version/manifest identity, action-time authorization, integrity and custody;
- DD-14 record preservation, contact data, recipient-held copies, retention/hold/disposition boundaries;
- DD-15 candidate acceptance domains and actual-scenario import requirement;
- docs/131 evidence transaction and manifest contract;
- DEC-050/051/052/103/108/110 as the controlling governance boundaries.

The review does not infer test definitions from AT-RFI or E2E identifiers/counts. It does not treat candidate specification labels as approved production vocabulary.

## 3. Cross-specification findings

### RCP-01 — One frozen Transmittal context must bind recipient, package and request

**Finding:** DD-09 freezes Transmittal identity, source RFI/cycle/response version, exact manifest entries and recipient snapshot. DD-10 requires each acknowledgement/substantive request to bind to the exact Transmittal, manifest version, response version, recipient entry and relevant manifest entries. Docs/131 independently requires immutable manifest identity/version and exact evidence-version lineage.

**Required reconciliation:** treat the recipient snapshot, manifest version, request definition and each resulting acknowledgement/response as separately identifiable but explicitly linked records. Never resolve a request dynamically to the latest package or current directory state. A later package/recipient change requires the DEC-108 linked-Transmittal path and new request context where applicable.

**Status:** Consistent; canonical identity/cardinality and request-to-manifest-entry mapping remain open (DEP-RCP-01/02).

### RCP-02 — Delivery, access, acknowledgement, substantive response and source decision are distinct

**Finding:** Both DD-09 and DD-10 distinguish these events. DEC-052 and DEC-103 require the same separation. Docs/131 prevents a storage or worker side effect from creating a business outcome.

**Required reconciliation:** preserve separate event identities and state/aggregation domains. Provider acceptance, mailbox delivery, portal availability, authenticated access, preview/download, acknowledgement and substantive response must not be collapsed into one delivered/complete flag. None changes source RFI issue, closure or technical disposition.

**Status:** Consistent; channel-specific delivery evidence semantics remain open (DEP-RCP-03).

### RCP-03 — Technical-delivery and acknowledgement denominators are intentionally different

**Finding:** DD-09 applies DEC-103's technical-delivery population to every intended recipient in the frozen manifest, including informational recipients. DD-09/DD-10 apply the acknowledgement denominator only to entries explicitly Required; Optional and Not Requested are excluded, and zero Required yields Not Required.

**Required reconciliation:** preserve separate denominator populations and separately named aggregate results. A recipient's acknowledgement classification must never remove that recipient from the technical-delivery population. A substantive-response request is a third independent dimension and must not enter either denominator.

**Status:** Consistent with DEC-103; exact aggregate treatment for unknown/unconfirmed delivery outcomes remains open (DEP-RCP-03).

### RCP-04 — Unknown delivery cannot be silently mapped to a confirmed DEC-103 result

**Finding:** DD-09 correctly preserves recipient-level Unknown / Unconfirmed when a channel cannot establish a reliable outcome, while DEC-103 defines Delivered, Partially Delivered and Failed from confirmed successes/failures.

**Required reconciliation:** no unapproved provider-specific mapping may turn Unknown into success or failure. Aggregate status must expose unresolved uncertainty and must not falsely claim Delivered, Partially Delivered or Failed until an owner-approved mapping explains how confirmed and unknown outcomes interact. The exact aggregate representation and reconciliation/timeout rules remain a decision, not a default.

**Status:** Open; provider/channel-specific technical and owner decision required (DEP-RCP-03/04).

### RCP-05 — Recipient identity, destination and represented-party authority are separate

**Finding:** DD-09 distinguishes destination validation, person authentication, party representation, package authorization and acknowledgement attribution. DD-10 requires an authenticated individual with current authority for the represented party and exact request. Organization mailboxes and role endpoints are not automatically individual identities.

**Required reconciliation:** retain recipient-entry identity, destination endpoint, authenticated actor identity and represented-party/appointment evidence as distinct concepts. A valid delivery to an organization endpoint does not by itself establish which human may acknowledge or submit a substantive response. Any organizational acknowledgement model needs express owner/security/contract approval and a defined evidentiary meaning.

**Status:** Consistent; identity assurance, endpoint governance, person/organization acknowledgement semantics and nomination/validation authority remain open (DEP-RCP-05/06).

### RCP-06 — Recipient-specific access must be narrower than general RFI visibility

**Finding:** DD-09 limits access to exact frozen manifest entries and purpose; excludes drafts, internal contributions, reviewer notes, sibling attachments and other recipients' submissions absent separate authority. DD-08 and docs/131 require per-operation current server-side authorization and exact version binding.

**Required reconciliation:** recipient access grants must bind to the specific Transmittal/manifest entry/version, recipient or authorized actor, represented party, purpose and permitted action. A link, directory membership, prior participation, one successful download or access to one entry must not expand access to sibling entries or the broader RFI. Search, counts, logs, exports, notifications and support tooling must enforce the same confidentiality boundaries.

**Status:** Consistent; exact capability matrix, identity assurance, revocation consistency and cache/session controls remain open (DEP-RCP-05/07).

### RCP-07 — Same-scope retry versus changed-scope Transmittal is a hard identity boundary

**Finding:** DD-09 and DEC-108 require a same-package/same-recipient retry to retain Transmittal identity and add an attempt; changed package or recipient scope requires a new linked Transmittal. DD-07 requires logical command identity, idempotent replay and changed-payload conflict rejection. Docs/131 pins exact manifest identity/version.

**Required reconciliation:** distinguish Transmittal ID, dispatch command ID, recipient-entry ID, per-recipient attempt ID, provider callback/event ID and manifest ID/version. Same logical dispatch retry must resolve to its original command/Transmittal and must not erase prior recipient outcomes. A changed destination, recipient, package, evidence version or purpose must not be smuggled into the old idempotency key or frozen manifest.

**Status:** Consistent; key scope/retention, provider callback correlation and unknown-outcome retry policy remain open (DEP-RCP-04/08).

### RCP-08 — Post-freeze recipient correction, revocation and wrong-recipient handling need separate authority

**Finding:** DD-09 preserves original recipient/destination snapshots and events; changed recipient scope uses a new linked Transmittal. It also recognizes that portal access may be revoked but external downloads/prints/copies cannot be recalled. DD-14 requires residual-copy and recipient-held material to be handled honestly.

**Required reconciliation:** distinguish (a) preventing future access, (b) corrective distribution, (c) wrong-recipient incident response, and (d) preservation/records handling. Do not rewrite recipient snapshots or imply that revocation retracts previously delivered bytes. Define who can suspend access, authorize correction, notify affected parties and determine contractual/legal escalation.

**Status:** Consistent; authority, urgency, incident severity, residual-copy response and legal/contract notification consequences remain open (DEP-RCP-07/09).

### RCP-09 — Acknowledgement and substantive response are two independent request dimensions

**Finding:** DD-10 correctly separates Required/Optional/Not Requested acknowledgement classification from the candidate substantive-response requirement classification. The latter is not a DEC-103 denominator and is not yet owner-approved.

**Required reconciliation:** never infer one dimension from the other, recipient class, delivery, access, read telemetry or target date. Track receipt acknowledgement and review/awareness acknowledgement as distinct requested statements. Do not treat an optional acknowledgement or substantive response as an outstanding Required action.

**Status:** Conceptually consistent; adoption of the substantive-response tri-state and exact acknowledgement wording/localization remain open (DEP-RCP-10).

### RCP-10 — Per-recipient versus per-manifest-entry requirement granularity is unresolved

**Finding:** DEC-052 and DD-10 allow requirements to be explicit per recipient and, where relevant, per manifest entry. DD-09's recipient-level access is entry-scoped. The drafts do not yet settle when an acknowledgement is one per recipient for a whole package versus one or more acknowledgements scoped to selected manifest entries.

**Required reconciliation:** do not multiply or redefine the DEC-103 recipient denominator by manifest-entry count without an explicit decision. Define the request unit, the recipient completion rule, how multiple required entry-level statements roll up to one recipient, and how corrections/new manifests affect outstanding requests. Keep recipient count, request count and submission/event count separately labelled in reporting.

**Status:** Open; owner, Document Control and architecture decision required (DEP-RCP-02/10).

### RCP-11 — Acknowledgement authority may differ from substantive-response authority

**Finding:** DD-10 states that receipt acknowledgement authority may differ from substantive technical response authority. DD-09 requires current identity/party/project scope. DEC-108 reserves technical response issuance to the authorized technical authority and Document Control to distribution only.

**Required reconciliation:** define separate action-specific capabilities and appointment evidence for receipt acknowledgement, review/awareness acknowledgement, substantive response submission, response review/closure and source-RFI technical decision. A recipient's permission to view or acknowledge receipt must not imply authority to submit a technical position; a substantive response must not itself alter the source RFI.

**Status:** Consistent; role/capability matrix, delegation, group mailbox and appointment evidence remain open (DEP-RCP-06/11).

### RCP-12 — Substantive responses must be immutable, scoped and routed without mutating source workflow

**Finding:** DD-10 binds each submission to the exact request/package/version, preserves original submissions and requires corrections/supplements to be linked records. It routes a new independent engineering question for classification under DEC-106 rather than silently expanding the existing RFI. DD-11 dependencies govern withdrawal, supersession and closure.

**Required reconciliation:** distinguish response request, draft, submission, correction/supplement, clarification, withdrawal, supersession and administrative closure from the source RFI lifecycle. A recipient's comment, objection, "no further comment", silence or referral is not an approval, rejection or source workflow transition. Preserve the exact cited manifest entries and immutable evidence versions for every submission.

**Status:** Consistent; response vocabulary, legal effect, review/withdrawal/supersession/closure authority and target-date semantics remain open (DEP-RCP-10/11/12).

## 4. Open dependencies and authority decisions

| ID | Open dependency / required decision | Required reviewers |
|---|---|---|
| DEP-RCP-01 | Canonical recipient-entry, Transmittal, manifest, request and response identity/cardinality and immutable linkage | Architecture; Document Control; records; owner |
| DEP-RCP-02 | Whether and when acknowledgement/substantive-response requirements are recipient-level or manifest-entry-level; roll-up rules without changing DEC-103 denominator | Owner; Document Control; architecture; QA |
| DEP-RCP-03 | Technical-delivery success evidence per approved channel and aggregate semantics for mixed confirmed/unknown/failure outcomes | Architecture; provider/integration owner; Document Control; QA; owner |
| DEP-RCP-04 | Provider event/callback correlation, retry, timeout/unknown reconciliation and idempotency key scope/retention | Architecture; operations; security; QA; owner |
| DEP-RCP-05 | Recipient classes, destination/endpoint governance, external identity proofing, authentication and represented-party verification | Owner; identity/security; privacy; project/party authority |
| DEP-RCP-06 | Recipient nomination/validation, organizational endpoint rules and separate acknowledgement/substantive-response authority | Owner; project/contract communication authority; Document Control; identity/security |
| DEP-RCP-07 | Per-recipient/per-entry access matrix, revocation consistency, session/cache controls and residual-copy response | Security/privacy; architecture; records; owner |
| DEP-RCP-08 | Same-package retry and changed-package/recipient/purpose correction rules, including Transmittal linking and manifest immutability | Document Control; architecture; records; owner |
| DEP-RCP-09 | Wrong-recipient incident authority, suspension/correction, contractual/legal notification and recipient-held copy handling | Owner; security; contract/legal; records; Document Control |
| DEP-RCP-10 | Final acknowledgement types/wording/localization, substantive-response Required/Optional/Not Requested adoption, response categories and counting units | Owner; Document Control; technical authority; contract/legal; QA |
| DEP-RCP-11 | Action-specific capability/appointment/delegation for acknowledgement, substantive response, review/closure and source technical decision | Owner; identity/security; project/party and technical authorities |
| DEP-RCP-12 | Response lifecycle, target dates and legal/evidentiary effect, including withdrawal/supersession/closure under DD-11 | Owner; technical authority; records; contract/legal; project controls |

All unresolved items remain **Blocked — Pending Authority Decision/Prerequisite**. Role labels, mailbox membership, email read state, prior participation, generic contract wording or provider features must not be used to infer a missing authority or legal effect.

## 5. Required DD-07 / DD-08 / DD-14 / DD-15 reconciliation

Before promotion:
1. Bind each dispatch attempt and provider callback to a stable logical command and exact Transmittal/recipient entry; distinguish attempt events from the logical dispatch outcome.
2. Bind every recipient access, acknowledgement and substantive submission to the exact manifest version and evidence entry/version, while checking current action-time authorization.
3. Define idempotent replay for acknowledgement/substantive submission after timeout; reconcile unknown outcomes before retry and reject changed-payload reuse.
4. Preserve frozen recipient and manifest snapshots; any changed package/recipient scope follows a new linked Transmittal and new request context.
5. Preserve immutable acknowledgement/substantive response records and link corrections/supplements; do not mutate the original.
6. Ensure recipient-held copies, contact data, provider records, logs, exports, caches and backups are accounted for under DD-14; do not promise remote recall or complete erasure.
7. Use the source-preserving AT-RFI-01–13 and E2E-01–28 inventory in `docs/137_DD15_CONTROLLED_AT_RFI_AND_E2E_TEST_INVENTORY_WORKING_DRAFT.md` and map applicable cases to RCP-01–RCP-12 and DEP-RCP-01–12. Preserve original scenario IDs and do not infer scenario content from counts.

## 6. DD-15 candidate acceptance coverage prompts

The following are coverage prompts only, not new approved test IDs or executed tests:
- all intended recipients remain in the technical-delivery denominator irrespective of acknowledgement classification;
- Required-only acknowledgement denominator, Optional/Not Requested exclusion and zero Required = Not Required;
- unknown provider outcome never becomes false confirmed delivery;
- organization endpoint delivery does not fabricate an individual acknowledgement;
- forwarded link, wrong-party identity, cross-recipient enumeration and revoked-session access are denied;
- access, preview/download, acknowledgement, substantive response and source technical decision remain separate;
- same-scope retry preserves Transmittal identity and recipient history; changed recipient/package/purpose creates a linked new Transmittal;
- duplicate/late provider callbacks and timeout retries do not duplicate or erase logical outcomes;
- request binds exact Transmittal/manifest/response/evidence versions, not latest/current;
- entry-level versus recipient-level request granularity is tested only after approval;
- unauthorized or duplicate acknowledgement/substantive submission is denied/idempotently resolved;
- correction/supplement/withdrawal/supersession preserves prior response and cited evidence;
- new independent engineering question routes to DEC-106 classification and does not mutate the source RFI;
- recipient lists, response content, logs, search/counts, notifications and exports do not leak other parties' information;
- delivery, access, acknowledgement and response metrics disclose separate units and as-of context.

Any unauthorized access, cross-recipient leakage, false delivery confirmation, incorrect DEC-103 denominator, duplicate logical submission, mutable history or inferred technical/legal approval is a candidate blocker. The source definitions are now imported in `docs/137`; validated mappings, approved expected results, owners, thresholds and execution evidence remain prerequisites. No test is executed or passed by this review.

## 7. Review and promotion gates

- [ ] Owner confirms recipient classes, nomination/validation authority and distribution purpose.
- [ ] Contract/legal authority confirms channel and legal/evidentiary effect where applicable.
- [ ] Identity/security approves person, organization endpoint, authentication, revocation and per-action scope.
- [ ] Document Control confirms Transmittal, recipient snapshot, retry and corrective-distribution rules.
- [ ] Owner/Document Control/architecture resolve recipient-vs-manifest-entry request granularity.
- [ ] Provider/integration architecture defines observable delivery outcomes and unknown reconciliation.
- [ ] Technical authority confirms response category and action authority boundaries.
- [ ] Records/privacy confirms contact-data, provider-event, recipient-copy and response-history treatment.
- [x] QA source import is recorded in `docs/137`.\n- [ ] QA validates exact-version coverage mappings to RCP-01–RCP-12 and DEP-RCP-01–12.
- [ ] Exact-version specialist findings, conditions and dissent are recorded; no implicit sign-off.

## 8. Explicit implementation boundary

This review does not approve recipient classes, identity proofing, channels/providers, delivery semantics, acknowledgement wording, response categories, request granularity, due dates, legal notice/evidentiary effect, permissions, capabilities, APIs, UI, workflow or state machines. It does not authorize external messages, Transmittal dispatch, recipient provisioning, live provider callbacks, test execution, DB/schema/migrations, Storage, auth/RLS/grants, production data, backup/restore, merge or deployment. Any future work requires separate exact-scope plans and explicit owner authorization; DB/Storage work additionally requires verified backups, isolated restore/rehearsal and reconciliation.

**Current disposition:** DD-09/DD-10 desk review recorded; no direct normative contradiction identified; RCP-01–RCP-12 and DEP-RCP-01–DEP-RCP-12 remain subject to authority/specialist review; no implementation or test execution authorized.
