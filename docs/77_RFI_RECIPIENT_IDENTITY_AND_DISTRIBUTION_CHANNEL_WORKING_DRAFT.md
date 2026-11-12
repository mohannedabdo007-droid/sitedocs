# RFI Recipient Identity and Distribution Channel — Working Specification

**Status:** WORKING — FOR OWNER / CONTRACT / SECURITY / IDENTITY / DOCUMENT CONTROL REVIEW — NOT IMPLEMENTATION AUTHORIZATION  
**Work item:** RFI-DD-09 in `docs/71_RFI_DETAILED_SPECIFICATION_BACKLOG.md`  
**Related specifications:** DD-05 through DD-08 in `docs/73`–`docs/76`; DEC-103 and DEC-108.

> This document elaborates recipient, identity and controlled-distribution requirements within the approved boundaries of DEC-050/051/052, DEC-103 and DEC-108. It does not select an external provider, communication channel, identity-proofing method, contractual notice mechanism or legal effect. It does not amend approved governance or authorize implementation.

## 1. Purpose and governing outcomes

Define how a formal RFI response package is addressed, delivered and made accessible to the correct external and internal recipients without granting broader access than intended.

The design must ensure:
1. The recipient is an identifiable person or explicitly governed organizational endpoint acting for a named party and project scope.
2. Recipient eligibility, package purpose, delivery route and file access are independently authorized.
3. Every recipient is evaluated independently for delivery, access and acknowledgement.
4. A recipient can access only the exact frozen package entries and versions authorized for that recipient.
5. Retries, changed recipients and changed packages preserve immutable Transmittal identity and history.
6. No channel event creates technical approval, acceptance, contractual notice or source-workflow closure by implication.

## 2. Controlling decisions and non-negotiable boundaries

- **DEC-050:** controlled Transmittal is the formal distribution record. It preserves package and recipient scope, dispatch attempts and outcomes; distribution is separate from source-document lifecycle and issue authority.
- **DEC-051:** recipient access is authenticated and scoped; access to the RFI summary or possession of a link does not create blanket access. Access telemetry is distinct from acknowledgement and legal notice.
- **DEC-052:** delivery receipt, access receipt, acknowledgement of receipt, acknowledgement of review/awareness, formal response and source-workflow decision are distinct. Silence or email read state is not deemed acceptance.
- **DEC-103:** every intended recipient is in the technical-delivery denominator unless an independently approved distribution rule expressly excludes them. Delivered requires all successful; Partially Delivered means some succeeded and some failed; Failed means all failed. Only Required acknowledgement recipients enter the acknowledgement denominator; no Required recipients means Not Required.
- **DEC-108:** authorized technical authority issues the response; Document Control distributes only within delegated scope. Freeze exact package and recipient scope. Same-package retries retain Transmittal identity; changed package or recipient scope requires a new linked Transmittal.
- **DEC-021 / DEC-104–109:** least privilege, current capability and party/project scope, separation of duties, no authority by role title or membership, no communication event implying technical decision, and server-side authorization for linked files and metadata.

## 3. Recipient identity model

A recipient entry should represent an intended delivery/access principal, not merely a typed email string.

Candidate recipient identity record:
- Stable recipient-entry ID within the Transmittal.
- Authenticated person identity where individual access is required.
- Represented organization/party and project relationship.
- Verified destination address or channel-specific endpoint reference.
- Identity assurance / verification status and verification evidence reference, where required.
- Authorized recipient scope and purpose.
- Sender/source of recipient nomination and approval/validation authority.
- Required/Optional/Not Requested acknowledgement classification, recorded separately from technical delivery inclusion.
- Effective-from/effective-to or validity state, if recipient authorization is time-bounded.
- Frozen display and destination snapshot used at dispatch, with controlled protection of personal/contact data.

An email address is a delivery destination, not proof that the person who opens a message is the intended recipient. A party mailbox is an organizational endpoint, not an authenticated individual acknowledgement unless a separately approved process establishes that meaning.

## 4. Recipient classes

Candidate classes for controlled RFI response distribution:

| Recipient class | Intended use | Identity and access boundary |
|---|---|---|
| Internal project individual | Named internal project participant | Current authenticated account and project/party capability |
| Internal controlled role mailbox | Authorized operational group endpoint | Explicitly approved mailbox ownership, membership and access governance; no shared-account impersonation |
| External named individual | Consultant, contractor, supplier or other external participant | Verified person identity and represented party; recipient-specific package scope |
| External organization endpoint | Contractually designated organization mailbox/portal endpoint | Authorized organization destination and separately governed access/acknowledgement evidence |
| Authority / client representative | Named external authority or client contact | Project/contract authority and specific distribution purpose |
| Informational recipient | Recipient receiving a copy without required acknowledgement | Still part of technical-delivery denominator if included in manifest; access remains scoped |
| Restricted oversight recipient | Authorized oversight function | Explicit read-only scope; no issue, approval, recipient-management or source-workflow authority by visibility alone |

This is a candidate catalogue. Final classes, naming and whether any class may use group endpoints require owner, project/contract, identity/security and records review. No class is automatically entitled by job title, organization membership, prior participation or being copied on an email.

## 5. Recipient nomination, validation and approval

1. Recipient nomination must be tied to the specific project, RFI, issued response package, distribution purpose and recipient class.
2. The nominator must have an explicit capability to propose recipients within the relevant party/project scope.
3. A designated recipient-validation authority confirms that the destination and represented party are correct and that the recipient is eligible for the intended information.
4. Document Control may prepare the distribution list and validate administrative completeness only within delegated scope; it cannot resolve contractual entitlement or create technical authority.
5. A recipient added after package freeze is not silently appended to the existing Transmittal. Changed recipient scope requires a new linked Transmittal under DEC-108.
6. Recipient removal or correction after dispatch must preserve the original recipient snapshot and all delivery/access/acknowledgement events. Any corrective distribution or access restriction is a separately authorized action with its own audit trail.
7. The exact approver, dual-control trigger and recipient-change authority remain open; no default self-approval or single-role authority is assumed.

## 6. Identity assurance and authentication

The security/identity design must distinguish:
- Destination validation (is this address/endpoint correctly associated with the intended recipient?).
- Person authentication (who is accessing the package?).
- Party representation (which organization is the person acting for?).
- Authorization (may this person access this exact package entry for this purpose now?).
- Acknowledgement attribution (did the authorized person explicitly confirm the requested event?).

Candidate controls for review include verified organizational domains, invitation-based account activation, independent identity proofing for higher-risk material, multi-factor authentication, step-up authentication for sensitive actions, managed federation, and time-bounded access enrollment.

No authentication strength, proofing level, federation provider, domain rule, MFA policy, guest-account model or identity-proofing vendor is selected here. Shared credentials, unverified forwarding and possession of a bearer link must not be treated as proof of individual identity.

## 7. Recipient-specific access scope

For each recipient, define the minimum necessary access scope:
- Specific Transmittal ID and frozen manifest version.
- Exact included evidence/file/version entries.
- Purpose of access (e.g., receive issued response, provide a requested response).
- Permitted actions (view, preview, download, acknowledge, submit a response) separately.
- Any permitted time window or expiry, only if an approved policy defines it.
- Represented party and project scope.
- Current authorization and revocation source.

Access to one manifest entry does not grant access to sibling attachments, the whole RFI record, internal drafts, discipline contributions, reviewer notes, previous or later versions, other recipients' responses, or unrelated linked records. A recipient cannot widen their own scope by forwarding a URL or message.

Apply DD-08: every preview/download and linked-record operation is authorized server-side for the exact version. Search, counts, notifications and error responses must not disclose unauthorized recipients, filenames or record existence.

## 8. Distribution channels — decision framework, not selection

Potential channel patterns to evaluate:

| Channel pattern | Potential benefit | Key risks / controls required |
|---|---|---|
| Authenticated SiteDocs recipient portal | Strong package-level access control and recipient attribution | External account lifecycle, identity assurance, availability, session security |
| Approved enterprise email with protected notification and portal link | Familiar notification route; package remains in controlled portal | Email forwarding, mailbox compromise, link leakage, delivery semantics and no false read/ack inference |
| Approved secure document exchange platform | May align with client/contractor systems | Provider assurance, recipient identity mapping, manifest integrity, access logs and revocation |
| Controlled encrypted file delivery | May support recipients without portal access | Key exchange, recipient verification, expiry, revocation limitations, offline copies and audit completeness |
| Hybrid notification plus authenticated retrieval | Separates notification from authoritative file access | Cross-channel correlation, duplicate events, recipient mapping and consistent audit history |

No channel is the default. Selection requires project/contract communication rules, security threat model, identity assurance, records evidence, privacy, availability, data residency, integration feasibility and explicit owner approval.

Ordinary email body text or attachment delivery must not be assumed to provide authenticated package access, reliable read evidence, revocation or legally effective notice.

## 9. Dispatch package and recipient snapshot

Before dispatch, the controlled Transmittal should freeze:
- Transmittal ID and linked prior Transmittal, if any.
- Source RFI identity, applicable cycle/revision and exact formal response version.
- Issuer identity, authority context and formal issue event.
- Exact manifest entries, evidence/version IDs and integrity references.
- Each recipient-entry ID, represented party, recipient class, validated destination snapshot and access scope.
- Delivery route/channel identifier and configuration version, where approved.
- Acknowledgement and formal-response requirements per recipient, separately classified.
- Dispatch authorization, sender, dispatch time and package integrity reference.

The frozen snapshot is authoritative for what was sent and to whom. Current directory changes must not rewrite historical recipients or destinations. Sensitive contact data must be protected in display, logs, exports and retention.

## 10. Delivery events and aggregate status

Record recipient-level events independently:
- Prepared / validated.
- Dispatch attempted.
- Channel accepted / queued, where the provider exposes this as a distinct technical fact.
- Technical delivery confirmed.
- Delivery failed / bounced / rejected / unknown.
- Retry attempt and final known outcome.

Do not conflate provider acceptance, SMTP acceptance, mailbox delivery, portal availability, authenticated access or human acknowledgement. The exact measurable technical event depends on the approved channel and provider.

Apply DEC-103 exactly:
- **Delivered:** every intended manifest recipient has confirmed technical delivery.
- **Partially Delivered:** at least one intended recipient has succeeded and at least one has failed.
- **Failed:** every intended recipient has failed.
- If the channel cannot establish a reliable delivery result, preserve an **Unknown / Unconfirmed** recipient-level outcome; do not falsely promote it to Delivered. The final aggregate treatment of unknown outcomes requires provider-specific mapping and owner review, and must never conceal uncertainty.

An empty or invalid recipient manifest must be rejected before dispatch; it must not be interpreted as a vacuous Delivered state.

## 11. Access, acknowledgement and formal response

Keep these separate per recipient:
1. Technical delivery result.
2. Authenticated access event (e.g. portal access, preview or download) with exact manifest entry and timestamp.
3. Explicit acknowledgement of receipt, if requested.
4. Acknowledgement of review/awareness, only if separately requested.
5. Substantive formal response, if requested and authorized.
6. Source RFI technical decision, which remains within its own workflow.

A download is not proof of reading or understanding. An access event is not an acknowledgement. An acknowledgement confirms only the specified package/receipt statement. A formal response must be submitted by an authenticated individual with current capability for the represented party and exact request.

Apply DEC-103/108: Required-only acknowledgement denominator; Optional and Not Requested do not enter it; if no Required recipients, aggregate acknowledgement is Not Required. Delivery and acknowledgement outcomes remain independent. No response, silence, expiry, email read state or technical access event implies acceptance, approval, consent, waiver or source-workflow closure.

Detailed acknowledgement wording and response categories are DD-10, not decided here.

## 12. Retry, changed recipient, correction and supersession

- A retry of the same unchanged package to the same frozen recipient scope retains the same Transmittal ID and manifest and adds a new attributable attempt.
- Retry must not erase successful delivery, duplicate acknowledgements or reset recipient history.
- A changed package, included version, distribution purpose or recipient scope requires a new linked Transmittal under DEC-108.
- Correcting a mistyped destination after dispatch must preserve the original destination and failed/uncertain attempt. Any corrected distribution is recorded as a new linked Transmittal or other explicitly approved corrective record; never rewrite the original.
- If access must be revoked or a package superseded, preserve prior delivery and access history and issue an authorized corrective notification/instruction. Do not claim that already downloaded or printed copies have been recalled.
- Provider retry semantics, idempotency keys and unknown-outcome reconciliation must follow DD-07; retrying an uncertain delivery must not silently create a second logical Transmittal.

## 13. Recipient changes, revocation and offboarding

Define controlled processes for:
- Person leaves project/party or changes role.
- External appointment expires or is revoked.
- Destination mailbox is compromised or reassigned.
- Recipient organization changes.
- Wrong recipient is discovered after dispatch.
- Project access or contract entitlement is suspended.
- A Transmittal or specific package entry is superseded or restricted.

Future access requests must re-evaluate current authorization. Revoke controllable portal sessions/tokens and invalidate caches according to approved security design. Preserve the historical recipient snapshot and prior events. Revocation cannot retract bytes already received, downloaded, printed or copied outside the system; this residual risk must be disclosed.

The authority and urgency rules for revocation, recipient replacement and corrective distribution require owner/security/contract review.

## 14. Privacy, confidentiality and information leakage

- Minimize recipient personal/contact data to what is needed for verified distribution, access and records evidence.
- Protect recipient lists from disclosure to other recipients unless an approved distribution purpose permits it.
- Use per-recipient notifications or protected distribution mechanisms where shared addressing would expose identities or project relationships.
- Avoid exposing other recipients' delivery, access, acknowledgement or response state.
- Apply authorization to recipient search, recipient counts, export, audit history, notification previews and support tooling.
- Prevent subject lines, email previews, filenames, URLs and error messages from leaking confidential RFI content.
- Define retention and lawful handling of contact data under DD-14 and applicable project policy; do not invent retention periods.

## 15. Failure and exception catalogue

| Scenario | Required handling |
|---|---|
| Recipient identity/destination cannot be validated | Block dispatch to that entry; do not silently substitute a guessed address |
| Recipient lacks current entitlement | Exclude only through an authorized pre-freeze correction; after freeze use a controlled linked corrective Transmittal |
| Provider accepts request but final delivery is unknown | Preserve Unknown / Unconfirmed; reconcile via provider evidence or approved retry |
| One recipient fails while others succeed | Preserve per-recipient results; aggregate Partially Delivered under DEC-103 |
| Shared mailbox used without approved governance | Block or mark Pending Authority Decision; do not claim individual acknowledgement |
| Recipient accesses forwarded link | Re-authenticate and re-authorize exact recipient/package scope; deny unauthorized person |
| External identity provider unavailable | Fail closed for protected access; preserve dispatch/delivery events separately |
| Recipient revoked during access session | Recheck on subsequent requests; invalidate controllable sessions/caches; record limitations |
| Package or recipient list changes during retry | Do not mutate frozen Transmittal; create new linked Transmittal for changed scope |
| Duplicate/late provider callbacks | Deduplicate same technical event using provider correlation and DD-07 controls; preserve distinct attempts |
| Recipient reports wrong/unsafe package | Suspend further access where authorized, preserve evidence, initiate controlled incident/correction path |

Incident severity, support escalation, provider retry cadence and contractual notification consequences remain open.

## 16. Acceptance and verification catalogue

Candidate non-production tests under DEC-110, using synthetic recipients and package evidence:
- Recipient cannot access a Transmittal or manifest entry outside their party/project/recipient scope.
- A valid recipient cannot enumerate other recipients or their access/acknowledgement state.
- Forwarded link does not grant access to an unauthenticated or unauthorized person.
- Revoked or expired recipient loses future access despite old notification/link.
- Recipient sees only exact frozen manifest entries, not drafts, sibling attachments or later versions.
- A shared mailbox cannot submit an individual acknowledgement unless a specifically approved identity model permits it.
- Delivery events are independently preserved for each recipient; mixed success/failure yields Partially Delivered.
- Unknown provider outcomes are not represented as confirmed delivery.
- Required-only acknowledgement aggregation follows DEC-103, including zero Required recipients = Not Required.
- Access, download, acknowledgement, substantive response and source technical closure remain distinct.
- Same-package retry preserves Transmittal identity and successful recipient outcomes.
- Changed recipient scope/package creates a new linked Transmittal; prior manifest/history remains immutable.
- Duplicate/late callbacks do not duplicate logical outcomes or erase attempt history.
- Unauthorized metadata is not leaked through search, counts, notifications, logs or exports.

Any cross-recipient leakage, unauthorized access, false Delivered status, incorrect acknowledgement denominator, mutable historical recipient snapshot or silent package substitution is an acceptance blocker. These are proposed tests only; no tests are claimed as executed.

## 17. Open decisions and required reviewers

| Open decision | Required reviewers / authority |
|---|---|
| Final recipient classes and whether group/role mailboxes are permitted | Owner; project/contract communication authority; security; records |
| Recipient nomination and validation capability/approval matrix | Owner; Document Control; project/party authorities; security |
| External identity proofing and authentication strength | Security/identity authority; privacy; owner |
| Approved delivery channels and provider criteria | Owner; contract/legal authority as applicable; security; architecture; operations |
| Technical definition of delivery success/unknown per channel | Architecture; provider/integration owner; Document Control; QA |
| Access expiry, revocation and residual-copy risk | Security; records; project/contract authority |
| Recipient-specific visibility and privacy rules | Security/privacy; records; owner |
| Corrective Transmittal and wrong-recipient incident authority | Owner; Document Control; security; contract authority |
| Acknowledgement wording and response categories | Owner; Document Control; technical authority (DD-10) |
| Retention, legal hold, contact-data retention and disposition | Records; privacy/legal as applicable; owner |
| Provider outage, retry, deduplication and recovery behavior | Architecture; operations; security; QA under DD-07 |
| Quantitative acceptance thresholds and test ownership | QA; security; records; owner under DD-15 |

If identity, recipient entitlement, channel evidence or legal/contractual effect is uncertain, the affected distribution remains **Blocked — Pending Authority Decision**. Do not substitute a generic email, public link or inferred recipient.

## 18. Governance alignment and implementation boundary

This working specification applies DEC-050/051/052, DEC-103 and DEC-108 and remains consistent with DEC-021, DEC-049, DEC-104, DEC-107, DEC-109 and DEC-110, and with DD-07/08. It does not amend any approved decision, authorize recipients, establish contractual notice, select a provider or grant access.

**Design only:** no identity-provider integration, external account provisioning, session/token configuration, email or delivery-provider integration, signed/public link, Transmittal automation, API/UI/code, DB/schema/migration/generated types, Storage, auth/RLS/grants, production-data operation, live workflow test, merge or deployment is authorized. Any implementation requires a separate channel/identity architecture, threat and privacy review, contract/records assessment, capability matrix, test plan, non-production rehearsal and explicit owner approval. Database/Storage work remains subject to verified backups, isolated restore/rehearsal and reconciliation gates.
