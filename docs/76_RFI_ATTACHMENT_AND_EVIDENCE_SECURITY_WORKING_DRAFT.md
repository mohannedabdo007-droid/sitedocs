# RFI Attachment and Evidence Security — Working Specification

**Status:** WORKING — FOR SECURITY / RECORDS / ARCHITECTURE / OWNER REVIEW — NOT IMPLEMENTATION AUTHORIZATION  
**Work item:** RFI-DD-08 in `docs/71_RFI_DETAILED_SPECIFICATION_BACKLOG.md`  
**Related specifications:** `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`, `docs/73_RFI_CLARIFICATION_REVISION_CLASSIFICATION_WORKING_DRAFT.md`, `docs/74_RFI_OFFICIAL_NUMBERING_AND_LEGACY_RECONCILIATION_WORKING_DRAFT.md`, `docs/75_RFI_CONCURRENCY_IDEMPOTENCY_TRANSACTION_INTEGRITY_WORKING_DRAFT.md`

> This working specification elaborates the attachment/evidence requirements already established by DEC-104, DEC-107 and DEC-110, and applies the existing access, records, notification and Transmittal boundaries in DEC-021, DEC-049–053 and DEC-103/108/109. It does not amend approved policy, select a storage/security technology, settle retention or legal authority, or authorize implementation.

## 1. Purpose and security objectives

Define a secure, attributable and recoverable evidence lifecycle for files associated with RFI questions, discipline contributions, reviews, formal responses and controlled distribution.

The design must preserve:
1. **Confidentiality:** each file and exact version is accessible only to an authenticated actor with current, resource-specific authority.
2. **Integrity:** submitted, reviewed and issued evidence remains bound to the exact immutable version relied upon.
3. **Attribution:** uploader, source party, time, purpose, classification and related business context remain traceable.
4. **Availability and recoverability:** authorized users can retrieve retained evidence, and recovery does not silently change identity, content or access scope.
5. **Separation of purpose:** upload, scan, preview, download, opening, acknowledgement, review, approval and issue are distinct events and confer no authority on one another.
6. **Least privilege and deny-by-default:** missing, ambiguous, expired or revoked authorization fails closed.

## 2. Controlling governance and non-negotiable constraints

- **DEC-021:** authorization is capability-based, authenticated, scoped and deny-by-default. A role title, project membership, notification, link or visibility of an RFI summary does not create blanket file access.
- **DEC-104 / ODM-17:** submitted attachment manifests and attributable file versions are preserved immutably; each preview/download is authorized server-side for the exact file/version and user/party scope; upload implementation and security mechanisms require separate specification and approval.
- **DEC-107:** stable evidence/file and version identities; uploader/time/source party/project/classification/context and integrity reference as applicable; replacement creates a new version; no silent overwrite, substitution or deletion of submitted/issued evidence; preserve originator, contribution, review and response evidence separately; surface integrity mismatch or unavailable evidence; linked-record access is independently checked.
- **DEC-049–053 and DEC-103/108:** notifications and Transmittals do not grant access; recipient delivery, access and acknowledgement are distinct. A Transmittal carries a frozen manifest and recipient-specific scope, not a public or transferable entitlement.
- **DEC-109:** row-, field-, party- and attachment-level authorization applies consistently to direct access, search, facets, counts, dashboards, exports, previews and linked records; archival is separate from lifecycle and does not imply deletion or access expansion.
- **DEC-110:** acceptance must test immutable snapshots, stable identities, attribution, integrity mismatch, per-file authorization, revoked access, history and recovery. No test pass is claimed by this document.

## 3. Evidence taxonomy and ownership context

Evidence must be typed by its business origin and purpose. Candidate classes include:

| Evidence class | Origin / purpose | Required separation |
|---|---|---|
| Originator attachment | Supporting the submitted engineering question | Must not be represented as a discipline or issuer response |
| Clarification attachment | Additional material for a specific clarification round | Linked to that round and its exact version |
| Discipline contribution evidence | Supporting one assigned discipline's contribution | Attributed to contributor, discipline, assignment and contribution version |
| Technical-lead consolidation evidence | Interface or consolidation support | Does not overwrite source discipline evidence or dissent |
| Independent-review evidence | Review comments, calculations or referenced material | Bound to reviewer appointment and exact candidate reviewed |
| Formal-response evidence | Issuer's evidence supporting the issued response | Frozen with the exact response version and issue event |
| Transmittal/distribution evidence | Exact files intentionally included in a controlled dispatch | Bound to frozen Transmittal manifest and recipient scope |
| Administrative/audit evidence | Scan result, integrity verification, access event or custody record | Not treated as engineering evidence or approval |

Final class catalogue, mandatory metadata and classification authority remain open. A file may have more than one relationship only where each relationship and purpose is explicit; do not infer ownership or permission from folder location or filename.

## 4. Stable identity, versioning and immutable snapshots

Each logical evidence item should have a stable evidence ID. Each accepted file content version should have a distinct immutable version ID. Storage object keys, URLs, filenames and content hashes are not substitutes for business identity.

A version record should capture, as applicable:
- Evidence ID and version ID.
- Original filename and declared media type; independently detected media type.
- Byte size and integrity reference.
- Uploader's authenticated identity, originating party and upload timestamp.
- Project, RFI, cycle, revision, clarification round, contribution, review, response or Transmittal relationships as applicable.
- Evidence class, purpose, classification and any approved sensitivity label.
- Scan/quarantine status and verification event references.
- Source/parent version for a replacement or derivative, where applicable.

**Snapshot rule:** at formal submission, review binding, formal response issue and Transmittal freeze, record an immutable manifest of the exact evidence IDs, version IDs and integrity references relied upon. A later upload or replacement must never change an earlier manifest.

A replacement creates a new version and an attributable event. It must not overwrite, mutate or silently supersede a version referenced by a submitted or issued snapshot. A “latest file” pointer may be used for convenience only; it must never resolve a historical snapshot.

## 5. Upload intake and quarantine lifecycle

Candidate intake sequence:
1. Authenticate the actor and authorize the upload purpose, target record, party/project scope and evidence class before accepting the file.
2. Enforce approved request limits and reject malformed or unsupported input without creating an authoritative evidence attachment.
3. Place the received object in a non-public, non-downloadable quarantine area.
4. Record a provisional intake identity and immutable receipt metadata sufficient for investigation; do not treat it as accepted engineering evidence.
5. Perform server-side file-type validation and malware/security scanning using an approved, maintained mechanism.
6. Verify the stored content against the received content using the approved integrity process.
7. On successful checks, promote the exact bytes to controlled evidence storage and bind a stable evidence/version identity to the authorized business context.
8. On failure, retain a restricted quarantine/exception record according to approved security and records policy; do not expose the file to ordinary preview/download or attach it to a submitted/issued manifest.
9. Record each transition, scan engine/rule version, outcome, timestamp and responsible service identity.

A successful scan does not establish that the document is technically correct, safe to execute, approved, accepted or fit for construction. A failed, unavailable, timed-out or indeterminate scan must not be treated as clean. Rescan policy for previously accepted evidence, signatures/archives, encrypted files and scan-engine updates remains to be defined.

## 6. File validation and abuse resistance

The security design must consider:
- Extension and declared MIME type spoofing; compare with server-detected content type.
- Malformed files, parser exploits, polyglot files, macro-enabled documents and active content.
- Archive bombs, nested archives, decompression limits and path traversal.
- Oversized files, excessive page counts, image dimensions and resource exhaustion.
- Executables, scripts, embedded links and external content.
- Password-protected or encrypted files that cannot be inspected.
- Duplicate-content detection as a review aid only; never automatically merge evidence identities.
- Safe rendering/conversion isolated from privileged application services.
- Rate limits and abuse controls that do not create silent loss of legitimate submitted evidence.

The exact allowed formats, size/count limits, archive policy, active-content treatment and exception authority are unresolved. Do not invent defaults or accept an unsupported file merely because the browser can display it.

## 7. Integrity references and verification

An integrity reference must bind to the exact stored bytes of a specific version. The algorithm, canonicalization rules (if any), calculation point, verification frequency and key/metadata protection must be selected by security/architecture review.

Candidate requirements:
- Calculate an integrity digest server-side after intake and verify it after controlled storage promotion.
- Verify the exact version before security-sensitive retrieval, manifest freeze and recovery reconciliation, subject to approved performance controls.
- Record algorithm identifier, digest value, content length, calculation time and verification result.
- Do not use a client-supplied digest as proof of integrity.
- Do not treat a digest alone as authenticity, authorship, malware clearance or technical approval.
- Any mismatch, missing object, unexpected byte count or unavailable verification result is a visible integrity exception. Fail closed for use in a new formal submission, review or issue until resolved by an authorized process.
- Preserve original evidence and the exception trail; never “repair” a mismatch by silently replacing bytes or recalculating over untrusted content.

Algorithm, key protection, verification cadence and exception-resolution authority remain open.

## 8. Authorization model for every file operation

Authorization is evaluated server-side at action time against the authenticated individual, current capability/appointment, project and party scope, target RFI/cycle/revision, evidence class, exact file/version, workflow context and purpose.

| Operation | Minimum authorization boundary | Required denial behavior |
|---|---|---|
| Upload | Explicit upload capability for target/context and evidence class | Reject; do not create an accessible evidence record |
| List / metadata | Permission to discover that exact evidence metadata in context | Avoid leaking filename, existence, uploader or classification |
| Preview / render | Current permission for exact file/version and preview purpose | Deny without revealing protected content or existence |
| Download | Current permission for exact file/version and download purpose | Deny; never rely on an old URL or prior preview authorization |
| Replace / supersede | Explicit authority for new version in same permitted context | Preserve old version and all snapshots |
| Link to another record | Permission to create the relationship and permission to access target metadata as applicable | No implicit cross-record access |
| Export / bulk download | Authorization for every included record, field and attachment | Exclude or fail safely; no unauthorized partial bundle |
| Delete / disposition | Separate approved records authority and retention/hold checks | No user self-service deletion of submitted/issued evidence |
| Restore | Approved recovery authority and reconciliation process | Keep restored content inaccessible until identity, integrity and access are reconciled |

Authorization must be rechecked for direct APIs, background jobs, preview/render services, download endpoints, exports, search/autocomplete/facets/counts, notification links, Transmittal links and cached content. A signed URL or bearer token, if later approved, is only a narrowly scoped transport mechanism with bounded lifetime and cannot replace current authorization policy. No public bucket, anonymous link or broadly reusable file URL is assumed.

Revocation, party removal, reassignment, appointment expiry and project-scope changes must take effect for subsequent requests. Previously delivered bytes cannot be recalled; this limitation must be explicit in the risk model and access logs.

## 9. Linked records and cross-context access

A relationship to an RFI, contribution, review, response or Transmittal does not automatically grant access to the linked file or to the other record.

For every linked preview/download:
- Authorize the requesting actor against the exact target file/version.
- Check the target record's current project/party and field/attachment visibility rules.
- Check the relationship's purpose and scope.
- Prevent existence, filename, content, counts or metadata leakage when the actor lacks access.
- Recheck access after revocation and when following historical links.
- Preserve the original evidence relationship even when the viewer is denied.

A Transmittal recipient may access only the exact files/versions intentionally included and authorized for that recipient and purpose. It does not grant access to the whole RFI, sibling attachments, draft evidence or later versions. Acknowledgement is separate from access and file opening.

## 10. Encryption, secrets and storage architecture

Security/architecture review must specify:
- Encryption in transit and at rest, including object stores, temporary/quarantine areas, replicas and backups.
- Key ownership, access boundaries, rotation, revocation, recovery, separation of duties and audit.
- Secret management; no credentials, tokens, encryption keys or production configuration in repository code, logs or test fixtures.
- Storage region/residency and any applicable contractual/project restrictions.
- Isolation between tenants/projects and between quarantine, accepted evidence and derived previews.
- Private-by-default object access and least-privilege service identities.
- Temporary render/cache lifecycle and protection of thumbnails, OCR text, extracted metadata and generated derivatives.
- Resilience, versioning/replication, backup and restore consistency.

No provider, bucket layout, encryption algorithm, key-management service, region or retention period is selected by this working draft.

## 11. Preview, rendering, derivative and cache security

Preview is a separate operation from download and must be authorized for the exact source version. Rendering must occur in an isolated, least-privileged service with bounded resources and safe parsers.

Derived previews, thumbnails, OCR text, extracted metadata and converted files must:
- Carry a traceable relationship to the exact source evidence/version and transformation version.
- Never replace the original source evidence.
- Inherit no broader access than the source and may require stricter access depending on extracted content.
- Be purged or invalidated from active caches on access revocation or policy changes to the extent technically controllable.
- Avoid exposing content through shared cache keys, predictable URLs, browser history, referrers or error messages.
- Be clearly identified as derivatives and never treated as the authoritative submitted/issued file unless an explicit approved process says so.

The exact supported preview formats and cache invalidation guarantees require technical review.

## 12. Audit, custody and security-event history

Preserve attributable, append-only events for:
- Intake, upload attempt, accepted/rejected/quarantined outcome.
- Scan and integrity verification, including engine/rule/algorithm versions and exceptions.
- Evidence/version creation, replacement, linking/unlinking and manifest freeze.
- Preview, download, export and access denial where policy requires.
- Authorization context and relevant policy/appointment version.
- Revocation, quarantine release, security investigation and controlled recovery.
- Administrative action, retention review, legal hold and authorized disposition.

Events should identify actor or service identity, action, target evidence/version, project/RFI context, purpose, outcome, timestamp and correlation reference. Avoid storing file contents, credentials, raw tokens or unnecessary personal data in logs. Log access must itself be restricted and audited. Audit retention duration and detailed event catalogue remain open under DD-14 and applicable records policy.

## 13. Retention, legal hold, deletion and backup boundaries

This specification does not set retention periods, archive tiers, legal-hold authority, disposition triggers or automatic deletion.

Before any disposition design:
- Establish the authoritative records classification and retention schedule.
- Identify all linked snapshots, Transmittals, recipient events, review evidence and legal/contractual holds.
- Determine how holds apply to originals, versions, derivatives, replicas, exports, caches and backups.
- Require an authorized disposition decision with evidence and a traceable result.
- Distinguish logical removal from active systems from expiry in backups and replicas.
- Define backup expiry and restore behavior separately; a restore must not resurrect unauthorized access or erase a valid hold.
- Preserve a verifiable record of what was disposed, under which authority and when, without retaining prohibited content unnecessarily.

No complete-erasure claim may be made without technical verification across all governed copies and systems.

## 14. Failure, incident and recovery model

| Failure / incident | Required safe behavior |
|---|---|
| Upload interrupted before acceptance | No authoritative attachment or submitted manifest entry; preserve only permitted intake diagnostics |
| Scan service unavailable or indeterminate | Keep quarantined; do not mark clean or expose as accepted evidence |
| Integrity mismatch | Fail closed for new formal use; preserve evidence and incident trail; no silent replacement |
| Object missing or storage unavailable | Surface an availability exception; preserve manifest and identity; do not substitute “latest” |
| Unauthorized preview/download attempt | Deny and record according to security policy without metadata leakage |
| Access revoked while a link/cache exists | Recheck on each request; invalidate controllable caches/tokens; record residual exposure limitations |
| Partial promotion or transaction failure | Reconcile provisional object, metadata and event state; no orphaned accessible object or false accepted record |
| Backup restore | Restore into isolation; reconcile IDs, versions, manifests, digests, access policy, holds and event history before re-enabling access |
| Suspected malware or compromise | Quarantine affected exact versions; preserve chain of custody; notify authorized security/records roles under approved incident process |

Incident severity, notification channel, response times, recovery objectives and evidence-preservation authority remain open and must not be invented here.

## 15. Concurrency and transaction dependencies

Apply DD-07:
- Evidence identity/version creation and its metadata/event records must have a consistent committed outcome.
- A manifest freeze must bind exact evidence versions and integrity references; concurrent replacement cannot mutate the frozen manifest.
- A scan result applies only to the exact bytes/version scanned, not a later replacement.
- A stale upload or delayed worker must not promote content into a record whose authorization or context has changed.
- Idempotent retries must not create duplicate evidence versions, duplicate manifest entries or duplicate accepted-upload events for one logical command.
- External scanning, rendering and storage services must use durable, recoverable state transitions; do not claim one distributed atomic transaction where the services cannot participate in it.
- Recheck current authorization and business state before consequential promotion, linking, manifest freeze or release from quarantine.

Exact transaction boundaries, object-store consistency, worker leases, idempotency keys and retry policy remain architecture decisions under DD-07.

## 16. Acceptance and security test catalogue

Candidate tests must be mapped to DEC-110 and executed only in an approved non-production environment with synthetic/test data and retained evidence.

### 16.1 Authorization and confidentiality
- Unauthorized actor cannot upload, enumerate, preview, download, replace, link, export or dispose evidence.
- Access is checked for each exact file/version and linked record, not inferred from RFI summary visibility.
- PM read-only oversight does not grant attachment modification, technical review or issue authority.
- Party, project, discipline, appointment expiry/revocation and reassignment boundaries are enforced.
- Search, counts, facets, notifications, exports and old links do not leak protected metadata or bypass authorization.
- Transmittal recipient sees only the exact authorized manifest entries, not sibling or later evidence.

### 16.2 Integrity, versioning and manifests
- Replacing a file creates a new immutable version and leaves all prior snapshots unchanged.
- Altered bytes, missing objects, digest mismatch and scan/version mismatch are detected and surfaced.
- A submitted/reviewed/issued/Transmittal manifest resolves to the exact versions originally frozen.
- Duplicate content does not silently merge distinct evidence identities.
- Derivatives are traceable and never substitute for source evidence.

### 16.3 Intake, malware and file abuse
- Spoofed extension/MIME, malformed files, archive bombs, nested archives, active content, oversized input and parser failures are safely rejected or quarantined.
- Scan timeout, scanner outage, unknown result and encrypted/unscannable files never become clean by default.
- A scan result for an earlier version cannot authorize a replacement version.
- Quarantined content is inaccessible through direct, guessed, cached, preview, export or notification paths.

### 16.4 Concurrency, failure and recovery
- Concurrent replacement and manifest freeze cannot create a mixed or ambiguous snapshot.
- Duplicate upload retries yield one logical accepted evidence result.
- Failure injection at each intake/promotion stage leaves no partially accessible accepted record.
- Revocation during asynchronous scan prevents unauthorized promotion.
- Isolated restore reconciles object bytes, IDs, versions, manifests, integrity references, holds and authorization before access resumes.

Any unauthorized access, evidence corruption, silent substitution, manifest mismatch, unscanned promotion or unreconciled recovery result is an acceptance blocker under the DEC-110 framework. These are proposed tests only; no execution or pass is claimed.

## 17. Open decisions and required reviewers

| Open decision | Required authority / reviewer |
|---|---|
| Final evidence classes, sensitivity labels and mandatory metadata | Owner; Document Control; records authority; technical leads |
| Allowed file types, size/count/page limits and archive policy | Security; architecture; project/technical authority |
| Malware scanning engine, signatures, quarantine release and rescan policy | Security authority; architecture |
| Integrity algorithm, verification timing and exception disposition | Security; architecture; records authority |
| Encryption, key management, storage provider/region and service identities | Security; architecture; owner / contractual authority as applicable |
| Preview formats, safe rendering, OCR and derivative controls | Security; architecture; records authority |
| Per-operation capability IDs and appointment/scope mapping | Identity/security authority; owner; project/party authority |
| Retention, legal hold, disposition and backup expiry | Records authority; legal/compliance authority as applicable; owner |
| Incident response, evidence preservation and recovery objectives | Security; records; operations; owner |
| Exact acceptance cases, test owners, severity and residual-risk authority | QA; security; records; owner under separate test/release plan |

If any required authority, scope, evidence class, scan result, integrity state or retention rule is missing or ambiguous, the affected operation remains **Blocked — Pending Design/Authority Decision**.

## 17.1 Cross-specification review reference

The exact-version desk review of DD-08 against DD-07, DD-04, DD-14 and DD-15 is recorded in [docs/130 — DD-08 Evidence Security Cross-Specification Review](130_DD08_EVIDENCE_SECURITY_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md). It records EVD-01–EVD-11 findings and DEP-EVD-01–DEP-EVD-11 dependencies. This review is not specialist approval and does not promote this working specification; unresolved items remain open pending the authorities identified in docs/130.

## 18. Governance alignment and implementation boundary

This working specification is intended to remain consistent with DEC-021, DEC-049–053, DEC-103, DEC-104, DEC-107, DEC-109 and DEC-110, and with DD-05/06/07. It does not amend any approved decision, grant access, approve a file class, select a provider or resolve retention/legal authority.

**Design only:** no Storage bucket/object change, upload/preview/download/replacement/deletion implementation, malware scanning service, integrity/hash service, encryption/key-management change, API/UI/code, DB/schema/migration/generated types, authentication/authorization/RLS/grants, production-data operation, live workflow test, backup/restore operation, merge or deployment is authorized. Any implementation requires a separate exact architecture and threat model, records/security/privacy impact review, capability matrix, test plan, non-production rehearsal and explicit owner authorization. Database/Storage work remains subject to verified DB and Storage backups, isolated restore/rehearsal and reconciliation gates.
