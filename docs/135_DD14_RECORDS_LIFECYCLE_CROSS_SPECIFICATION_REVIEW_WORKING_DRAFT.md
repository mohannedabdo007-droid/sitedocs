# DD-14 Records Lifecycle — Cross-Specification Review Working Draft

**Document type:** Non-authoritative document-level consistency review  
**Date:** 2026-11-12  
**Status:** REVIEW FINDINGS — OWNER / RECORDS / LEGAL / SECURITY / ARCHITECTURE VALIDATION PENDING — NOT GOVERNANCE APPROVAL — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Primary specification:** `docs/82_RFI_RECORDS_RETENTION_ARCHIVE_LEGAL_HOLD_DISPOSITION_WORKING_DRAFT.md`  
**Related specifications:** DD-01/06/07/08/09/10/11/12/13/15  
**Controlling governance references:** DEC-012, DEC-021, DEC-049, DEC-103, DEC-104–DEC-110  
**Related owner-confirmed records boundary:** DEC-109

> This review evaluates the existing DD-14 working draft against adjacent specifications and governance constraints. It does not establish retention schedules, legal interpretations, hold authority, archive technology, destruction methods, backup policy or implementation approval.

## 1. Review purpose and limits

Check that records preservation and disposition remain separate from technical RFI lifecycle, evidence custody, recipient communication, reporting/export, notification, authorization and recovery.

This is a document-level desk review only. It is not legal advice, a records-management determination, a security certification, an architecture approval or evidence of an executed test. The source draft remains the primary DD-14 specification.

## 2. Executive findings

DD-14 is comprehensive and directionally consistent with DEC-012 and DEC-109. It correctly separates technical closure, withdrawal, cancellation, supersession, archive, retention, legal hold, disposition review and destruction. It also avoids inventing retention periods or legal authority, requires current authorization for historical retrieval, preserves immutable evidence and recognizes residual copies in backups and recipient systems.

No direct contradiction with the reviewed governance constraints was identified. DD-14 is not ready for implementation or operational policy adoption. The critical open decisions are:
1. approved record-series classification and accountable records ownership;
2. schedule authority, triggers, durations, versioning and applicability;
3. legal-hold issuing/release authority, scope, confidentiality and precedence;
4. authoritative record-set relationships across RFI cycles, evidence, Transmittals, recipients, notifications, exports and linked document families;
5. backup/replica/cache/recipient-copy treatment and restore reconciliation;
6. disposition authorization, independent concurrence, method and proof standard;
7. exact test fixtures, evidence, reviewers and release gates.

## 3. Cross-specification control matrix

| Control area | DD-14 rule | Related source / governance | Review result |
|---|---|---|---|
| Technical lifecycle separation | Closure/withdrawal/cancellation/reopening are not archive or deletion | DEC-104/106/109; DD-01/DD-11 | Aligned; archive must never create or repair a technical outcome |
| Immutable evidence | Preserve exact evidence IDs, versions, manifests and custody | DEC-107; DD-08; DD-07 | Aligned; canonical evidence/manifest transaction contract remains under architecture review |
| Recipient communication | Preserve frozen Transmittals and recipient-level events | DEC-103/108; DD-09/DD-10 | Aligned; recipient-held copies remain outside any unsupported remote-recall claim |
| Notifications | Preserve business-event and recipient-notification history separately | DEC-049/109; DD-12 | Aligned; notification expiry/read state cannot delete or alter source records |
| Reports and exports | Preserve report definitions, as-of lineage and export versions | DEC-109; DD-13 | Aligned; exported artifacts need independent access, retention and hold mapping |
| Authorization | Historical/archive access remains current, scoped and server-side | DEC-021/109; DD-02/DD-08/DD-13 | Aligned; records/administrator titles do not confer broad rights |
| Linked document families | RFI archive does not imply access or disposition of WIR/MQR/MOM | DEC-104; DD-08/DD-13 | Aligned; linked-record existence and dependencies need explicit authorized scope |
| Legal hold | Hold is a preservation control, not a workflow state; overlapping holds remain independent | DEC-109; DD-14 | Aligned; actual authority, instruments and scope are unresolved |
| Retention and disposition | Expiry permits review only; deletion requires approved authority and gates | DEC-109; DD-14 | Aligned; no period, trigger or automatic deletion may be inferred |
| Recovery | Restore must reconcile evidence, access, holds and disposition history | DD-07/DD-08/DD-14/DD-15 | Directionally aligned; exact recovery and backup-copy policy remains unapproved |
| Verification | Proposed tests remain unexecuted and blocked on prerequisites | DEC-110; DD-15 | Aligned; test catalogue must import actual scenario definitions and evidence requirements |

## 4. Detailed review findings

### CR-135-01 — Record-series authority and record-set boundary

DD-14 correctly distinguishes record classes from retention series. Before a schedule is approved, the records authority must identify the authoritative series, record owner, accountable authority, inclusion/exclusion rules and evidential groupings. Do not assume that one RFI, one cycle, one file or one Transmittal is automatically a separate retention unit.

**Required reviewers:** Owner; records authority; Document Control; legal/contract authority as applicable.

### CR-135-02 — Schedule versioning and trigger applicability

The schedule design must specify whether a retention rule is minimum/fixed/event-based, its exact trigger evidence, timezone/calculation semantics, prospective or retrospective applicability and correction treatment. A new schedule version must not silently recalculate historical eligibility or legitimize an earlier disposition. If trigger or schedule applicability is uncertain, block disposition.

**Required authority/reviewers:** Records authority; owner; legal/contract authority; QA.

### CR-135-03 — Legal-hold authority and instrument evidence

A system capability cannot itself establish legal authority. Before hold functionality or operations, identify the approved office/role, governing instrument or case reference, authorized issuer/amender/releaser, required concurrence, effective time, review owner, confidentiality and challenge/escalation process. Technical administrators must not independently create or release holds.

**Required authority/reviewers:** Owner; legal/compliance authority; records authority; security; project governance.

### CR-135-04 — Hold scope across related copies and records

DD-14 appropriately leaves relationship expansion to the authorized records/legal authority. Define how scope reaches relevant cycles, revisions, evidence, linked WIR/MQR/MOM, Transmittals, recipient events, notification records, reports/exports, backups, replicas and custodial copies. Do not automatically expand a hold to every related record or narrow it to the parent RFI without an authorized scope decision.

**Required reviewers:** Legal/records authority; owner; document-family owners; security/privacy; architecture.

### CR-135-05 — Retention grouping and dependency mapping

The archive/disposition dependency inventory must map canonical identities and relationships from DD-07/DD-08: evidence ID/version ID, frozen manifests, derivatives, source events, Transmittal identity, recipient events, notification events, report/export version and backup-set identity. A convenience pointer or “latest” reference must not replace the exact historical snapshot. Orphaned or ambiguous references block clean disposition pending reconciliation.

**Required reviewers:** Architecture; security; records; Document Control; QA.

### CR-135-06 — Recipient-held and externally controlled copies

A SiteDocs disposition action cannot claim to erase files already downloaded, printed, forwarded, copied to external systems or stored by recipients. Define what can be controlled by SiteDocs, what requires an authorized external instruction, and what remains a documented residual-copy limitation. A corrective Transmittal or notice does not retroactively revoke a prior delivery or acknowledgement.

**Required reviewers:** Owner; records/legal/contract authority; security; Document Control.

### CR-135-07 — Backup, immutable media and restore semantics

DD-14 correctly keeps backups and replicas on distinct lifecycles. Before any implementation, specify copy inventory, provider/owner, encryption/key dependency, retention/rotation, hold interaction, restore process, post-restore reapplication of access restrictions and holds, and reconciliation of disposed records. If an immutable/offline backup cannot be selectively modified, document its approved exception/expiry treatment rather than claim immediate erasure.

**Required reviewers:** Architecture; operations; security; records/legal authority.

### CR-135-08 — Disposition authority and separation of duties

The disposition gate is appropriately fail-closed, but the exact actor/capability matrix remains open. Define who may request, assess, approve, concur, execute and independently verify disposition; prevent one actor or technical service from bypassing required review. An administrator's technical access is not disposition authority. Partial failures must remain exceptions, not be reported as complete.

**Required authority/reviewers:** Owner; records authority; legal/contract authority; security; internal assurance/QA.

### CR-135-09 — Residual copies, deletion proof and honest completion states

Distinguish primary-object removal, version/derivative removal, index/cache invalidation, provider expiry, backup expiry, offline media and external recipient copies. Define evidence and completion states for full, partial, blocked and unverifiable outcomes. A minimal disposition record is itself subject to an approved records basis; do not preserve prohibited content under the label of audit evidence.

**Required reviewers:** Records/legal authority; security; architecture; operations; QA.

### CR-135-10 — Retention and legal-hold reporting/privacy boundary

Search, dashboards, notification badges and reports must not disclose sensitive hold existence, case references, custodians, privileged legal notes or restricted disposition plans to ordinary users. Authorized records staff may need operational restriction information, but exact visibility is a field-level entitlement decision. A hold is not a technical RFI state and must not be counted as one.

**Required reviewers:** Security/privacy; legal/records authority; owner; reporting authority.

### CR-135-11 — Testability and operational readiness

DD-14's 18 scenarios are candidate tests, not proof of capability. DD-15 must map each to exact approved rules, actors, synthetic data, expected result, evidence, reviewer and release gate. DB/Storage backup and restore rehearsal requires its own approved plan, verified backups, isolated environment and reconciliation; this desk review authorizes none of it.

**Required reviewers:** QA; architecture; security; records; owner.

## 5. Candidate acceptance scenarios for DD-15 mapping

1. Technical closure, withdrawal, cancellation or supersession does not archive or delete a record by itself.
2. Archive processing preserves exact historical cycles, revisions, evidence manifests, Transmittals and recipient events without changing their source status.
3. Archive access and every preview/download/export retrieval enforce current row-, field-, party-, project- and attachment-level authorization.
4. A Project Manager's read-only oversight does not grant archive administration, hold management or disposition authority.
5. Missing series classification, schedule version, trigger evidence or conflicting trigger values block disposition.
6. Retention expiry alone creates no deletion or automatic disposition action.
7. An active hold blocks disposition only within its authorized scope; an unclear scope fails closed.
8. Releasing one of multiple holds does not release the others.
9. Unauthorized actors cannot create, amend, release or conceal a hold.
10. A hold or disposition restriction does not change technical RFI state, assignment, response or recipient communication.
11. Disposition dependency analysis accounts for exact evidence versions, frozen manifests, linked records, recipient events, reports/exports and backup copies.
12. Recipient downloads/forwarded copies prevent unsupported claims of complete erasure.
13. Restore re-applies active holds and current access policy and reconciles disposition history before service is exposed.
14. A partial or unverifiable disposition is not reported as complete.
15. Schedule reclassification preserves the previous classification, schedule version and calculation evidence.
16. Restricted legal-hold metadata does not leak through search, facets, counts, notification badges, exports or ordinary user interfaces.
17. Every disposition action records authority, scope, schedule/trigger basis, concurrence, method, time, outcome, exceptions and verification evidence.
18. A failed or unauthorized disposition attempt and its evidence cannot be silently deleted or rewritten.

These are test-design proposals only. They have not been executed and must be mapped to approved expected behavior and synthetic fixtures under DEC-110/DD-15.

## 6. Open decisions and review ownership

| Open decision / evidence | Required authority / reviewers |
|---|---|
| Record-series catalogue, ownership and evidential grouping | Owner; records authority; Document Control |
| Approved schedules, triggers, duration and version applicability | Records authority; legal/contract authority; owner |
| Legal-hold authority, governing instrument, scope and release | Legal/compliance; records; owner; project governance |
| Cross-record and residual-copy scope | Records/legal; document-family owners; security/privacy; architecture |
| Canonical identity/manifest/dependency contract | Architecture; DD-07/DD-08 owners; records; QA |
| Archive package completeness and retrieval entitlements | Owner; records; security; Document Control |
| Backup/replica/cache inventory, expiry and restore behavior | Architecture; operations; security; records |
| Disposition request/approval/concurrence/execution/verification authority | Owner; records; legal; security; assurance |
| Deletion proof, partial/unverifiable outcomes and residual-copy language | Records/legal; security; architecture; operations |
| Hold/disposition field visibility and reporting | Security/privacy; records/legal; reporting authority |
| DD-15 test ownership, environment, evidence and release gates | QA; security; architecture; records; owner |

All unresolved matters remain **Blocked — Pending Authority Decision / Prerequisite**. No retention duration, legal interpretation, hold authority, backup period, destruction mechanism or release threshold is set by this review.

## 7. Disposition and backlog action

- DD-14 is **directionally consistent** with the reviewed governance and adjacent specification boundaries.
- CR-135-01 through CR-135-11 are review findings and candidate clarifications, not approved decisions.
- Keep `docs/82_RFI_RECORDS_RETENTION_ARCHIVE_LEGAL_HOLD_DISPOSITION_WORKING_DRAFT.md` as the primary DD-14 specification; do not create a duplicate or silently rewrite its candidate rules.
- Link this review in the detailed specification backlog and make owner/specialist disposition the next DD-14 action.
- Update DD-14 only after exact-version authority decisions are recorded; then repeat the cross-specification review.
- Map accepted scenarios into DD-15 only after expected outcomes and authorities are approved.
- No new governance DEC is created by this desk review.

## 8. Explicit non-authorization

This review authorizes no retention schedule, archive/hold/disposition policy operation, archive service, legal-hold mechanism, deletion or sanitization job, backup/restore/replication operation, DB/schema/migration/generated types, Storage, auth/RLS/grants, API/UI/code, production-data action, live test, merge or deployment. Any implementation requires a separate owner-approved plan, records/legal authority, security/privacy and architecture review, test plan, verified backups, isolated restore/rehearsal and reconciliation, and explicit authorization.
