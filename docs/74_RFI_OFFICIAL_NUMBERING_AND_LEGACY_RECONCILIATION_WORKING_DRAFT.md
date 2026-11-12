# RFI Official Numbering and Legacy Reconciliation — Working Specification

**Document type:** Detailed-design working specification; non-authoritative  
**Date:** 2026-11-12  
**Status:** WORKING — FOR OWNER / DOCUMENT CONTROL / DATA-RECORDS REVIEW — NOT IMPLEMENTATION AUTHORIZATION  
**Working branch:** `implementation/ui-foundation-2026-11-11`  
**Controlling governance baseline:** `governance/scan-lifecycle-design-2026-11-11`  
**Related work:** RFI-DD-06 in `docs/71_RFI_DETAILED_SPECIFICATION_BACKLOG.md`; lifecycle/authority in `docs/72_RFI_LIFECYCLE_AND_AUTHORITY_SPEC_WORKING_DRAFT.md`; classification in `docs/73_RFI_CLARIFICATION_REVISION_CLASSIFICATION_WORKING_DRAFT.md`

> This document elaborates, but does not amend, DEC-002, DEC-022-A/B, DEC-104, DEC-107 and DEC-110. The RFI display pattern, final uniqueness boundary, historical inventory, collision resolution and allocator contract remain unresolved. No number format or migration is approved by this working draft.

## 1. Purpose and non-negotiable identity model

Define a safe and auditable design for assigning a unique official RFI number at the first successful formal submission, preserving that identity for the life of the RFI, and reconciling historical records before any allocator is designed.

Keep these identifiers separate:

1. **Internal draft ID:** private system tracking identity created with a draft; not an official RFI number.
2. **Official RFI number:** stable identity of one formally submitted RFI.
3. **Formal revision:** controlled-content revision under DEC-022-B; not a new RFI identity.
4. **Clarification-round ID:** follow-up exchange on the same controlled inquiry; not a revision or new RFI.
5. **Response version:** exact technical response candidate or issued response.
6. **Discipline contribution ID/version:** attributable input from a scoped discipline.
7. **Transmittal ID:** identity of a distribution package, separate from the RFI and its response.
8. **Legacy/source reference:** original identifier retained for traceability; not automatically promoted to a new official RFI number.

RFI numbering must remain independent from WIR and other document-family numbering, consistent with DEC-002 and DEC-023. A generic document-numbering rule or WIR sequence must not silently become the RFI numbering policy.

## 2. Controlling approved rules

### 2.1 DEC-002 — RFI identity and family separation

RFI means Request for Information / engineering inquiry. It is fully separate from WIR in forms, numbering, permissions, lifecycle, reporting and audit. The former “Request for Inspection” interpretation is superseded.

### 2.2 DEC-022-A — official number allocation

- Create an internal draft identifier at draft creation.
- Allocate and fix the official number only when the first formal submission passes validation and commits successfully.
- Abandoned drafts and failed/unsuccessful submission attempts consume no official number.
- Editing, uploading, saving, validating or commenting does not allocate an official number.
- Once allocated, the official number remains associated with that RFI through its later lifecycle.

### 2.3 DEC-022-B — revision identity

- First formal issue is Rev.00.
- A controlled-content change after an authorized return/correction creates the next sequential revision.
- Resubmission without controlled-content change retains the same revision.
- Each revision has its own immutable snapshot and linked review/approval/signature/audit history.
- Prior revisions are not overwritten; approvals and signatures do not carry across revisions.
- The official RFI number remains stable across revisions.
- This specification does not extend DEC-022-B to an RFI stage or transition that has not been approved.

### 2.4 DEC-104 / DEC-107 — RFI-specific numbering direction

- RFI has a dedicated numbering stream.
- Project-scoped uniqueness is the default direction, subject to baseline and legacy reconciliation.
- The official number is allocated only at successful first formal submission and is never reused.
- Draft ID, official RFI number, formal revision, clarification round, contribution ID, response version and Transmittal ID remain distinct.
- The final display format, historical collision mapping and exact numbering profile remain open design dependencies.

### 2.5 DEC-110 — acceptance baseline

Duplicate official identity/number is an acceptance blocker. Number allocation and reconciliation must be tested for concurrency, idempotency, failure-after-commit, stale submissions, history integrity and recovery. Existing scenarios are test-design inputs only; no tests are claimed executed.

## 3. Numbering lifecycle — candidate contract

| Event / condition | Official number effect | Required record treatment |
|---|---|---|
| Draft created | None | Create internal draft ID only |
| Draft edited / attachment uploaded / saved | None | Preserve draft history as separately governed |
| Validation preview | None | Preview is advisory; no reservation or consumption |
| Validation fails | None | No official number consumed |
| Submission attempt fails before successful commit | None | Preserve failure event; retry may proceed under approved idempotency rules |
| First formal submission succeeds | Allocate exactly one official RFI number | Number assignment and successful submission must commit as one logical atomic outcome |
| Retry after timeout where first submission actually committed | Do not allocate another number | Resolve the original committed result by stable request/idempotency identity |
| RFI returned for completion | Retain same official number | Revision treatment follows DEC-022-B only where applicable |
| Clarification round | Retain same official number | Separate clarification-round identity; no number increment |
| Formal revision | Retain same official number | Increment revision only under applicable DEC-022-B conditions |
| Reopening after issue | Retain same official number | New cycle/response version under DEC-106; preserve prior issue/closure |
| Linked new RFI | Allocate a different official number at its own successful first formal submission | Store typed relationship to source; do not borrow source identity |
| Authorized withdrawal or administrative cancellation | Number remains consumed and permanently non-reusable | Preserve record, reason, actor, authority, time and links |
| Archive / supersession | No number change | Preserve identity and history; archive is not deletion |

**Critical invariant:** no event may create two official numbers for one RFI identity, and no official number may be assigned to two RFI identities within the approved uniqueness boundary.

## 4. Display format — intentionally unresolved

No final human-readable format is selected here. Candidate components that may be considered by the owner and Document Control include:

- Project code or project identifier.
- Explicit RFI document-family prefix.
- Optional discipline or responsible-scope marker, if it does not undermine identity stability.
- Sequential numeric component and optional year/period component.

These are design dimensions, not an approved pattern. Do not publish, code, seed or migrate a candidate format before the owner approves a concrete pattern and its transition/legacy rules.

### Format evaluation criteria

A proposed pattern should be:

1. Unambiguously recognizable as an RFI and distinguishable from WIR and all other document families.
2. Unique within the approved project boundary, including historical records and aliases.
3. Stable when discipline assignments change, contributions are added, the technical lead changes, or the RFI is reopened.
4. Independent of formal revision, clarification-round, response-version and Transmittal identifiers.
5. Readable in Arabic/English interfaces, exports, transmittals and external references.
6. Compatible with project-code changes, project renaming and long-term archival references without rewriting issued numbers.
7. Deterministic and validated against the full legacy inventory before activation.
8. Able to handle sequence exhaustion, year rollover, project code collisions and concurrent submissions without reuse or regression.

A discipline code in the visible number is a consequential unresolved choice. If a number includes a discipline, the design must explain what happens when the discipline scope changes or an RFI becomes multidisciplinary. It must not silently rename an existing RFI. A discipline-neutral RFI identifier is a viable candidate, but is not approved by this draft.

## 5. Uniqueness boundary and namespace

DEC-104 establishes project-scoped uniqueness as the default direction, subject to reconciliation. The detailed uniqueness key still requires owner confirmation.

Candidate model for review:

- Namespace: RFI family only, isolated from WIR and other document types.
- Scope: one project.
- Uniqueness: one official RFI number maps to one official RFI identity for that project, across all lifecycle states and historical/legacy records.
- Revisions, clarification rounds, cycles, response versions and Transmittals do not create new official-number namespace entries.
- Numbers remain reserved permanently once a successful formal submission has allocated them, including withdrawn, cancelled, closed, archived and superseded RFIs.

Open questions requiring owner / Document Control disposition:

- Is project-scoped uniqueness sufficient when project codes are reused, projects are merged, or records are consolidated?
- Must uniqueness also be enforced across an enterprise portfolio, or only within a project?
- Is the project identifier embedded in the displayed number or maintained as a separate namespace attribute?
- How are legacy RFIs without reliable project attribution handled?
- Can an imported historical number be duplicated across projects and, if so, what canonical reference is used without rewriting the original?

Until these are resolved, a global allocator or final display pattern is blocked.

## 6. Legacy inventory and evidence model

Before selecting a sequence start or designing an allocator, build a read-only inventory of every known RFI source. Do not assume that the current document table, a seed file, a numbering scheme's next-sequence value, or a spreadsheet is complete.

### 6.1 Sources to inventory

- Existing application records and any RFI-like records stored under legacy document-type labels.
- Historical project registers, transmittals, correspondence registers and approved document logs.
- Imported spreadsheets, CSV files and bulk-import batches.
- Archived/exported registers and prior system extracts.
- RFI references embedded in WIR, NCR, MOM, drawings, correspondence, transmittals and other linked records.
- Existing source-code, schema, migration and configuration evidence that describes numbering behavior.
- Existing RFI draft records and failed/abandoned submission events, if available, clearly separated from official submissions.

### 6.2 Minimum inventory fields

| Field | Purpose |
|---|---|
| Source system / file / table / import batch | Provenance |
| Source record primary key | Stable source identity |
| Project ID and source project code/name | Project attribution |
| Raw document type / source classification | Distinguish actual RFI from similarly named records |
| Raw official number exactly as found | Preserve original representation |
| Normalized comparison key | Detect equivalent strings without rewriting raw values |
| Revision / clarification / response references | Avoid treating suffixes as separate RFI identities |
| Discipline raw value and canonical mapping, if relevant | Historical context only; not automatic renumbering |
| First submission / issue / creation timestamps and evidence source | Establish lifecycle status and ordering |
| Source authority / verification state | Separate verified official records from unverified references |
| Related Transmittal / attachment / response links | Preserve graph of evidence |
| Duplicate / collision / ambiguity flags | Reconciliation work queue |
| Proposed canonical identity and rationale | Controlled mapping proposal, not an automatic mutation |
| Reviewer, review date and disposition | Accountability |

Inventory must distinguish **confirmed official RFI**, **probable RFI**, **unverified reference**, **draft**, **duplicate candidate**, **non-RFI misclassification**, and **unresolved**. A textual reference to an RFI number is not by itself proof of an official RFI record.

## 7. Normalization and collision analysis

Normalization is for comparison and analysis only. Preserve the raw source string and source bytes/record unchanged.

Candidate comparison normalization may identify differences in case, whitespace, punctuation, separators, leading zeros and known project-code aliases. No normalization may automatically merge two records or rewrite an issued number.

### 7.1 Collision classes

1. **Exact duplicate:** same raw number appears on multiple records in the same candidate uniqueness scope.
2. **Equivalent-format duplicate:** two strings normalize to the same comparison key.
3. **Cross-project duplicate:** same number appears in different projects; requires project attribution and uniqueness-scope decision.
4. **Cross-type collision:** same visible string is used by RFI and another document family; assess namespace separation and human ambiguity.
5. **Sequence collision:** proposed next sequence would generate a number already present in current or historical records.
6. **Alias collision:** different project codes or legacy prefixes resolve to the same candidate identity.
7. **Identity split:** one real RFI appears under multiple numbers or source records.
8. **Identity merge:** one source number appears to represent multiple independent inquiries.
9. **Unverified reference collision:** an external reference resembles an official number but lacks authoritative source evidence.

### 7.2 Required collision disposition

Each collision must have a documented case record with:

- All affected raw records and their source provenance.
- Project and document-family scope.
- Evidence supporting whether records represent the same RFI or distinct RFIs.
- Proposed canonical identity and relationship mapping.
- Explicit treatment of linked documents, Transmittals, revisions, attachments and audit events.
- Decision authority and independent review where required.
- Before/after uniqueness proof and reconciliation evidence.
- Recovery/rollback implications.

Never resolve a collision by simply choosing the numerically largest value, taking the maximum sequence, overwriting a row, appending a suffix, or renumbering one record without a reviewed identity decision.

## 8. Sequence baseline and next-number determination

The next sequence must not be inferred from `MAX(sequence)`, a single scheme's `next_seq`, or the latest visible number.

Before recommending a start point:

1. Reconcile every confirmed official RFI across every source in the approved project scope.
2. Parse only formats that have been explicitly identified and validated; retain unparseable values for manual review.
3. Detect exact and normalized collisions across historical and current sources.
4. Separate RFI numbers from revision, clarification, response, Transmittal and WIR attempt suffixes.
5. Identify reserved/consumed numbers from successful submissions, including later withdrawn/cancelled records.
6. Identify gaps without assuming they are available for reuse.
7. Generate candidate future numbers under each proposed format and test them against every known issued and historical value.
8. Produce a per-project sequence recommendation with evidence, exceptions and a second-person review.
9. Require owner/Document Control approval before any baseline is activated.

A gap in a historical sequence is not proof that a number was never allocated. An unrecorded failed submission is not assumed to have consumed a number; DEC-022-A says unsuccessful/abandoned drafts do not consume official numbers, but the evidence must still be checked to avoid duplicating a number issued outside the system.

## 9. Legacy mapping and preservation

- Preserve original document IDs, raw official numbers, source records, revisions, attachments, comments, review/approval events, Transmittals, acknowledgements and audit history.
- Do not automatically renumber existing issued RFI records to match a new display pattern.
- Do not rewrite a legacy RFI number because its old discipline code is now non-canonical.
- Keep raw legacy values and any canonical comparison/mapping value side by side.
- Map source records to a canonical RFI identity only after evidence-based reconciliation and authorized review.
- If two source records are determined to be duplicate representations of one RFI, preserve both source identities and all provenance while creating an explicit duplicate/alias relationship; do not destructively delete one.
- If one source number was reused for distinct inquiries, do not merge them. Record an explicit exception and an approved stable internal identity for each; external-facing treatment requires owner/records authority decision.
- If project attribution or official status cannot be established, mark the record unresolved and prevent it from influencing allocator baseline until resolved.
- Historical links must continue to resolve to the exact original record or a transparent, authorized cross-reference. Never silently redirect an old number to a different RFI.

## 10. Proposed allocator contract — design requirements only

The allocator is not to be implemented in this workstream. A future approved allocator must satisfy at least:

1. **Atomicity:** official number assignment and first successful formal submission are one logical commit. No orphan allocation on failed submission.
2. **Concurrency safety:** simultaneous submissions in the same uniqueness scope cannot receive the same number.
3. **Idempotency:** retries of one submission cannot allocate another number after a timeout or lost response.
4. **Non-reuse:** allocated numbers remain consumed permanently, regardless of later withdrawal, cancellation or archival.
5. **Stable identity:** revision, clarification, reopening, reassignment, discipline changes and Transmittal events never change the official number.
6. **Scope enforcement:** every allocation is checked against the approved project and RFI namespace, including legacy mappings.
7. **Collision defense:** candidate values are checked against authoritative current records and reconciled legacy identities; uniqueness is enforced at the authoritative data boundary.
8. **No client authority:** a browser preview or client-supplied number cannot reserve or assign an official number.
9. **Auditability:** record allocation event, RFI identity, project namespace, allocated number, actor/authority context, timestamp, request identity and relevant baseline/configuration version.
10. **Failure recovery:** distinguish failure-before-commit from timeout-after-commit; recover the already committed number rather than allocate a second.
11. **Sequence integrity:** no silent regression, sequence reset or manual skip; exceptional correction requires authorized, attributable records action.
12. **Fail closed:** missing project scope, unresolved legacy collision, unavailable numbering configuration or uncertain commit result blocks allocation rather than guessing.

Exact locking, transaction, idempotency-key, uniqueness-constraint and recovery implementation belongs to DD-07 and a separate architecture review.

## 11. Preview, reservation and user-facing behavior

- A preview is advisory and must state that the number is not reserved and may change before successful submission.
- Draft creation, save, validation, upload and editing never reserve a number.
- The final official number appears only after the successful first formal submission result is confirmed.
- If submission outcome is uncertain because of a timeout, the interface must resolve the existing submission result; it must not invite a blind second submission that can allocate another number.
- A failed submission must clearly remain unnumbered.
- A user must never be allowed to type over, choose, or manually reuse an official RFI number unless a separately approved controlled import/reconciliation process explicitly handles a historical record.
- The interface must distinguish internal draft ID from official RFI number and from revision/clarification labels.

## 12. Reconciliation outputs and review gates

The read-only reconciliation exercise should produce:

1. Source inventory and coverage statement, including inaccessible or incomplete sources.
2. Raw-number register with source provenance and project attribution.
3. Parsed/normalized comparison view, preserving raw values.
4. Duplicate, collision, split-identity, merge-identity and unverified-reference registers.
5. Per-project sequence history and proposed next-sequence rationale.
6. Proposed display-pattern comparison and uniqueness-boundary decision paper.
7. Legacy-to-canonical identity mapping with confidence, evidence, reviewer and authority.
8. Before/after record-count and reference-integrity reconciliation plan.
9. Exception register and unresolved decision list.
10. Non-production rehearsal and recovery plan for any later migration/allocator work.

No reconciliation report may claim completeness if source systems, archives or historical registers were unavailable. State coverage limitations explicitly.

## 13. Acceptance criteria and candidate tests

DD-06 is ready for technical/owner review only when:

- The approved RFI display pattern and uniqueness scope are explicit.
- Every available source has a documented inventory and coverage status.
- Raw historical identifiers remain preserved.
- All duplicate/collision candidates have a disposition or remain explicitly blocked.
- Every confirmed RFI identity has one stable official number within the approved scope.
- Withdrawn/cancelled/archived records remain included in non-reuse checks.
- The proposed next-sequence baseline is supported by a complete reconciliation, not a maximum-value guess.
- Preview does not reserve or consume a number.
- First successful submission assigns exactly one number; abandoned drafts and failed attempts consume none.
- Concurrent first submissions cannot produce duplicates or sequence regression.
- Timeout-after-success retries return the original committed identity.
- Linked new RFIs receive separate numbers only on their own successful first submission.
- Revisions, clarification rounds, reopenings and Transmittals never increment the official RFI number.
- No legacy record is destructively renumbered or merged without explicit authority and a verified recovery plan.

Candidate tests must be mapped to DEC-110, including negative authorization, concurrency/idempotency, evidence/history, failure recovery and reconciliation. These are acceptance criteria only; no execution or pass is claimed.

## 14. Open decisions and blocking dependencies

1. Final human-readable RFI number pattern and permitted characters/separators.
2. Final uniqueness scope: project-only, portfolio-wide, or another explicitly governed namespace.
3. Whether project code is embedded in the displayed number and how project renaming/merger is handled.
4. Whether discipline appears in the number; how multidisciplinary scope and discipline changes are handled.
5. Treatment of historical RFIs with missing, duplicate or ambiguous project attribution.
6. Complete source inventory and authoritative source-of-truth hierarchy.
7. Treatment of external/historical numbers that conflict with current records.
8. Canonical identity and alias model for duplicate/split legacy records.
9. Per-project sequence baseline and gaps after reconciliation.
10. Controlled manual correction/exception authority and evidence requirements.
11. Detailed allocator transaction/idempotency/locking/recovery contract (DD-07).
12. Final RFI controlled-content and revision model remains governed by DD-05 and DEC-022-A/B.

Until these decisions and prerequisites are resolved, the numbering profile and allocator design remain blocked. No developer default or existing implementation pattern may silently decide them.

## 15. Governance alignment and implementation boundary

This working specification is intended to remain consistent with DEC-002, DEC-004/005, DEC-022-A/B, DEC-023, DEC-104, DEC-107 and DEC-110. The static findings in `docs/06_DISCIPLINE_AND_NUMBERING_AUDIT.md` are historical audit evidence about discipline and general document-numbering sources; they are not proof that an RFI-specific allocator is complete, correct or active. In particular, do not assume the general document numbering scheme or its discipline fallback is an approved RFI numbering design.

**Design and read-only planning only:** no allocator, sequence reservation, DB/schema/migration/generated types, data mutation, historical renumbering, import/backfill, Storage, auth/RLS/grants, API/UI/code, production-data operation, live workflow test, backup/restore operation, merge or deployment is authorized. Any later data migration or allocator requires a separate exact plan, complete verified DB and Storage backups, successful isolated restore/rehearsal, reconciliation, security/records review, test plan and explicit owner authorization.
