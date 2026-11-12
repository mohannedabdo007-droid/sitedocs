# RFI Records Retention, Archive, Legal Hold and Disposition — Working Draft

**Document type:** Non-authoritative detailed-design working draft  
**Date:** 2026-11-12  
**Status:** PROPOSED FOR REVIEW — NOT GOVERNANCE APPROVAL — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Controlling governance baseline:** `governance/scan-lifecycle-design-2026-11-11`  
**Primary decisions:** DEC-012, DEC-021, DEC-049, DEC-104, DEC-107, DEC-109, DEC-110  
**Dependencies:** RFI-DD-01, RFI-DD-06, RFI-DD-07, RFI-DD-08, RFI-DD-09, RFI-DD-10, RFI-DD-11, RFI-DD-13  
**Backlog item:** RFI-DD-14

> This draft proposes records-control requirements for RFI records. It does not establish retention periods, legal-hold authority, archival technology, destruction authority, or any automated disposition. All such matters remain subject to owner and records/legal authority approval.

## 1. Purpose and status discipline

Define a controlled records lifecycle that preserves the evidential value, authenticity, integrity, accessibility and confidentiality of RFI records from creation through final disposition.

The following labels apply:
- **Approved constraint:** directly required by an existing governance decision.
- **Candidate design:** proposed control requiring review and approval.
- **Open decision:** policy, authority, duration, mechanism or threshold not yet approved.

A records lifecycle is not a substitute for the technical RFI lifecycle. This draft is design-only.

## 2. Controlling principles

1. Technical closure, withdrawal, cancellation, supersession, archive, retention expiry, legal hold and destruction are separate concepts and events.
2. Archive means controlled preservation and retrieval; it does not mean deletion, technical acceptance, workflow closure, or broader access.
3. Retention expiry permits an authorized review only; it does not trigger automatic deletion.
4. No retention duration, schedule, archive tier, legal-hold authority, disposition trigger or destruction authority is assumed.
5. Preserve attributable append-only history and exact issued versions under DEC-012 and DEC-109.
6. Historical access remains subject to current authorization, party/field scope, confidentiality and applicable hold restrictions.
7. RFI records, attachments, Transmittals, recipient events, notifications, exports, backups and replicas may have related but distinct records lifecycles.
8. Do not claim complete erasure while copies may remain in backups, replicas, caches, exports, recipient systems or downloaded files.

## 3. Records inventory and record-set boundaries

Candidate RFI record classes requiring an approved classification schedule:
- official RFI identity, numbering and registration events;
- originating question, submitted form and immutable submission snapshot;
- clarification rounds and linked-new-RFI relationships;
- formal revisions and exact response versions;
- discipline assignments, contributions, dissent/conflict records and consolidation;
- independent review evidence, reviewer comments and issue/closure records;
- withdrawal requests, cancellation decisions, reopening events and cycle history;
- evidence manifests, file/version IDs, integrity references, scan/quarantine outcomes and custody events;
- Transmittal package snapshots, recipient lists and recipient-specific delivery/access/acknowledgement/substantive response events;
- notification business-event references, recipient notification history and delivery attempts;
- reports, searches and exports generated from RFI records, including their definitions and as-of lineage;
- audit/security/authorization events and records exceptions;
- backup/replica/recovery manifests and restore/reconciliation evidence.

A record class is not automatically a separate retention series. The records authority must determine which records form one evidential set, which must be retained together, and which have independent triggers.

## 4. Lifecycle vocabulary and separation

| Concept | Meaning | Must not be interpreted as |
|---|---|---|
| Technical closure | RFI workflow reached an authorized technical terminal state | Archive or deletion |
| Withdrawal | Authorized pre-issue withdrawal under DEC-106 and DD-11 | Administrative cancellation or destruction |
| Cancellation | Authorized administrative invalid-registration/duplicate outcome | Technical rejection or deletion |
| Supersession | A newer controlled record/version replaces an earlier one for current use | Erasure of prior history |
| Archive | Controlled preservation and retrieval under records controls | Technical approval, public access or deletion |
| Retention | Period/rule governing preservation, once approved | Workflow status or automatic permission grant |
| Legal hold | Authorized preservation restriction suspending disposition within scope | New technical workflow state |
| Disposition review | Controlled evaluation after applicable retention/hold checks | Automatic destruction |
| Destruction/disposition | Authorized final action under an approved schedule and evidence trail | Ordinary archive or user delete |

These concepts must be represented separately in reports and interfaces if implemented. No single generic status should collapse them.

## 5. Candidate records classification and schedule design

Before any schedule is approved, each record series should define:
- series ID and description;
- business/legal/evidential purpose;
- record owner and accountable records authority;
- originating system and authoritative source;
- included record classes and linked evidence;
- event-based trigger and trigger evidence;
- retention duration or approved event-based rule;
- whether retention is minimum, fixed, or subject to another legal/contractual rule;
- hold interaction and precedence;
- disposition authority and required concurrence;
- archival format, metadata and retrieval requirements;
- backup/replica/export treatment;
- review date, policy version and approval history.

No duration or trigger is proposed in this draft. Project completion, RFI closure, contract completion, supersession, last access or upload date must not be assumed as a retention trigger without records/legal approval.

## 6. Retention trigger and calculation controls

Candidate requirements:
1. The trigger must be defined by the approved records schedule, not inferred from a convenient timestamp.
2. Preserve the original trigger event, source reference, actor/authority, timestamp and schedule version.
3. Distinguish event time, registration time, ingestion time, archive time and calculation time.
4. If a trigger is corrected, retain the prior value and an attributable correction event; do not silently reset the clock.
5. If trigger evidence is missing, conflicting or unverified, disposition remains blocked pending records-authority review.
6. Changes to a schedule must define prospective/retrospective applicability and preserve the schedule version used for each decision.
7. No default timezone, working calendar, grace period, automatic pause or restart rule is created.

## 7. Archive eligibility and package completeness

Candidate archive-readiness checks, not an approved automatic closure rule:
- source RFI identity and all relevant cycle/version identifiers are stable;
- applicable technical lifecycle outcome is recorded by an authorized actor;
- formal response and issue evidence are preserved where issued;
- clarification, revision, linked-RFI and supersession relationships are retained;
- required contributions, reviews, dissent and resolution history are preserved;
- withdrawal/cancellation/reopening events and their authority evidence are retained;
- exact Transmittal manifests and recipient events are linked and preserved;
- evidence manifests, file/version references and integrity/scan exceptions are accounted for;
- audit history and required metadata are present;
- open actions, unresolved integrity/security incidents, active legal holds and records exceptions are identified.

Archive processing must not manufacture a missing technical outcome, resolve an outstanding action, issue a response or close an RFI. An incomplete package remains pending or exception-managed under an approved records process.

## 8. Archive package and metadata integrity

Candidate archive package manifest:
- stable archive package ID and version;
- source system, source RFI ID and record-series classification;
- exact included record/version/event references;
- file/evidence manifest with stable file and version IDs;
- Transmittal and recipient-event references;
- source and package integrity references;
- classification/confidentiality labels and access policy reference;
- applicable retention schedule/version and trigger evidence, if approved;
- active hold references and scope;
- archive creation actor/service, authority, timestamp and processing result;
- exceptions, missing items, integrity failures and reconciliation outcome.

The archive manifest must not replace source evidence. Any transformed representation, preview or migration copy must be traceable to its source and must not silently become the authoritative original.

## 9. Retrieval, access and historical visibility

- Archive access remains permission-controlled and subject to current authorization at request, preview and download.
- Historical participation, prior assignment, project membership or possession of an old URL does not independently grant access.
- Project Manager oversight remains read-only under DEC-021; it does not grant edit, review, issue or disposition authority.
- Document Control or records staff receive only explicitly approved records capabilities; the title alone does not create a grant.
- Preserve party, project, discipline, field and attachment confidentiality restrictions for archived material.
- Revalidate access after revocation and before every retrieval/export.
- Access to an RFI archive does not automatically authorize access to linked WIR, MQR, MOM, Transmittal recipient records or attachments.
- Log retrieval, preview, download, privileged access and denial events according to the approved audit policy.

## 10. Legal hold model and authority

A legal hold is a records-preservation control, not a technical RFI state.

Before any hold mechanism is implemented, the owner must approve:
- the authority or office permitted to issue, amend, release and oversee holds;
- acceptable legal/contractual/investigation triggers and required evidence;
- identity and scope of custodians, projects, parties, RFIs, cycles, versions, evidence, Transmittals and related copies;
- effective time, issuing authority, case/reference ID, reason classification and review owner;
- notification and acknowledgement requirements for custodians/records operators;
- confidentiality of hold existence and details;
- review cadence and release authority;
- audit, challenge, exception and escalation route.

No role, legal trigger, hold type or legal interpretation is invented here. A technical administrator must not independently create or release a legal hold merely because the system permits it.

## 11. Hold scope, overlap and precedence

Candidate controls:
1. A hold applies only to its explicitly recorded scope; scope expansion requires an authorized amendment with history.
2. Multiple holds may apply independently to the same record set.
3. Releasing one hold does not release any other active hold.
4. Disposition remains blocked while any applicable hold remains active.
5. A hold on an RFI may require preservation of linked evidence, Transmittals, recipient events, exports, backups or custodial copies; exact relationship expansion must be determined by the authorized records/legal authority.
6. A hold must not alter technical RFI state, assignment, response, recipient delivery or user capability.
7. Hold status and sensitive case details are disclosed only to authorized records/legal roles; ordinary users receive only the minimum necessary operational restriction notice.
8. Uncertain scope or conflicting instructions fail closed pending authority resolution.

## 12. Backup, replica, cache and recovery boundaries

Backups, replicas, exports, caches, previews, search indexes and recipient-held copies have distinct technical lifecycles. They must not be treated as one archive object.

Candidate requirements:
- inventory each copy class, owner, location/provider, purpose, encryption/key dependency, refresh/expiry policy and restore capability;
- link backup sets to source-system/version/time and preserve backup integrity and custody evidence;
- define how active holds affect backup rotation, expiry, restore and post-restore disposition;
- ensure a restore does not silently reintroduce records that were validly disposed or bypass an active hold;
- ensure a restore does not remove a hold or erase a disposition/audit event;
- reconcile source records, evidence manifests, access policies, holds and disposition logs before restored service is declared available;
- handle immutable/offline backups through a separately approved exception process rather than claiming immediate erasure;
- govern search indexes and caches so revoked access and disposition restrictions propagate under approved consistency targets;
- recognize that downloaded/forwarded recipient copies cannot be remotely erased by a SiteDocs archive action.

No backup technology, rotation period, recovery point/objective or storage region is selected by this draft.

## 13. Disposition eligibility and authorization gates

Retention expiry is only a candidate trigger for a controlled review.

Before any final disposition, require:
1. authoritative schedule and correct series identification;
2. verified trigger and calculation under the applicable schedule version;
3. confirmation that no active legal hold or other preservation restriction applies;
4. confirmation of linked-record, evidence, Transmittal, recipient, export and backup dependencies;
5. documented business/legal/contractual review where required;
6. explicit disposition authority and any required independent concurrence;
7. defined scope and method, including treatment of derivatives, replicas and backups;
8. risk/exception review for missing or corrupt records;
9. immutable disposition authorization and execution evidence;
10. post-action reconciliation and exception reporting.

If any prerequisite is unknown, contradictory, inaccessible or not authorized, the action is blocked. No automated deletion is approved.

## 14. Destruction, deletion and proof boundaries

If destruction is separately authorized in the future:
- distinguish logical removal from physical media sanitization and provider-level expiry;
- define exactly which primary objects, versions, derivatives, thumbnails, previews, OCR text, indexes, caches, exports and replicas are in scope;
- preserve the authority, schedule, scope, method, actor/service, timestamps, exceptions and verification evidence;
- preserve a minimal lawful disposition record where approved, without retaining content that the approved disposition requires to be destroyed;
- report partial completion and inaccessible copies honestly;
- do not claim complete erasure if backups, offline media, third-party systems or recipient-held copies remain;
- define recovery behavior if a restore reintroduces disposed material;
- ensure a later hold or preservation instruction is evaluated by authorized records/legal staff before further disposition.

The exact destruction method, proof standard, certificate wording, media sanitization and residual-copy treatment remain open.

## 15. Corrections, reclassification and schedule changes

- Correcting metadata must create an attributable correction event and preserve the previous value.
- Reclassification requires an authorized reason, source evidence, effective date and impact analysis on retention/holds/access.
- Schedule changes must not silently rewrite prior retention calculations or disposition eligibility.
- If a classification or schedule error is discovered after disposition, open a records incident and follow an approved recovery/notification process; do not fabricate recovered content.
- Changes to project, party, discipline, contract or record ownership must not silently transfer records authority or broaden access.
- A new linked RFI or reopened cycle must retain its own identity/history and be assessed under the applicable approved series mapping.

## 16. Exceptions, incidents and audit

Preserve append-only, attributable records for:
- archive package creation, verification, retrieval and failure;
- schedule assignment/version and trigger evidence;
- hold creation, amendment, scope, review, release and denial;
- disposition review, approvals, concurrence, execution, partial failure and verification;
- backup/restore, reconciliation and exception handling;
- reclassification, correction, migration and integrity incidents;
- privileged access, unauthorized attempts and access-policy changes.

A records incident may require preservation of affected records and related evidence. Incident response authority and notification duties remain governed by separate security/records procedures. Do not delete or rewrite the evidence of a failed or unauthorized disposition attempt.

## 17. Acceptance and non-production rehearsal scenarios

Proposed DEC-110-aligned tests; not executed:
1. technical closure does not automatically archive or delete an RFI;
2. archive does not change technical status, revision, issue or recipient communication state;
3. archived record retrieval enforces current row/field/party/attachment authorization;
4. revoked access blocks old links, previews, downloads and export retrieval;
5. PM read-only oversight cannot edit, review, issue or dispose;
6. historical versions, cycles, evidence and recipient events remain linked and distinguishable;
7. missing archive manifest item or integrity mismatch blocks clean archive completion and raises an exception;
8. retention expiry alone cannot trigger deletion;
9. missing/ambiguous schedule or trigger blocks disposition;
10. any active hold blocks disposition within its approved scope;
11. releasing one of multiple holds does not release the others;
12. unauthorized user cannot create, amend or release a hold;
13. linked records and copies are evaluated under the approved scope without unauthorized cross-record access;
14. backup restore preserves holds and disposition history and reconciles restored records before service;
15. offline backup or recipient copy prevents an unsupported complete-erasure claim;
16. authorized disposition records scope, authority, method, evidence and residual exceptions;
17. schedule reclassification preserves prior calculation and approval history;
18. partial failure is reported honestly and does not mark the entire disposition complete.

All tests require synthetic/non-production data, approved expected results, evidence capture and independent review. DB/Storage backup/restore rehearsal is not authorized by this draft and requires a separate approved plan and isolated environment.

## 18. Open decisions and required reviewers

| Open decision | Required authority / reviewer |
|---|---|
| RFI records series, classification and ownership | Owner; records authority; Document Control |
| Retention durations, triggers and schedule versioning | Records authority; legal/contract authority as applicable; owner |
| Archive eligibility and completeness rules | Owner; Document Control; technical authority; records |
| Archive package format, storage tier and integrity evidence | Architecture; security; records; owner |
| Historical retrieval entitlements and field-level access | Owner; identity/security; project/party authority |
| Legal-hold issuing/amending/release authority and evidence | Legal/records authority; owner |
| Hold scope expansion across linked records, backups and custodians | Legal/records authority; security; architecture |
| Backup/replica/cache lifecycle, rotation and restore behavior | Architecture; operations; security; records |
| Disposition authority, concurrence and review requirements | Owner; records/legal authority; contract authority as applicable |
| Destruction methods, sanitization and proof standard | Security; records; architecture; legal authority |
| Residual copies, exports and external recipient-held material | Owner; records; security; contract/legal authority |
| Exception handling, incident escalation and recovery | Security; records; operations; owner |
| Test owners, evidence retention and release signoff | QA; records; security; owner under DD-15 |

## 19. Governance alignment and explicit exclusions

This draft elaborates DEC-109's records-preservation safeguards and remains consistent with DEC-012's historical preservation, DEC-021's read-only oversight boundary, DEC-107's immutable evidence/version principles and DEC-110's verification framework. It does not amend governance decisions or determine legal interpretation, statutory/contractual periods or records authority.

**Design-only boundary:** no retention schedule, legal-hold authority, archive service, disposition workflow, deletion job, DB/schema/migration/generated types, Storage operation, auth/RLS/grant, backup/restore, production-data action, live test, merge or deployment is authorized or performed. A separate records/legal policy approval, security/privacy/architecture review, detailed implementation and test plan, isolated non-production rehearsal and explicit owner authorization are mandatory. DB/Storage changes remain subject to verified backups, successful isolated restore/rehearsal and reconciliation gates.
