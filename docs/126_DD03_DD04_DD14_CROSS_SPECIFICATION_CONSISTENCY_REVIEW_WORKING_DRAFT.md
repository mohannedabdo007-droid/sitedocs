# DD-03 / DD-04 / DD-14 Cross-Specification Consistency Review

**Document type:** Cross-specification desk review — working draft  
**Date:** 2026-11-12  
**Status:** DOCUMENT-LEVEL REVIEW COMPLETE — SPECIALIST VALIDATION PENDING — NO SPECIFICATION PROMOTION — NOT IMPLEMENTATION AUTHORIZATION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Specifications reviewed:**
- DD-03: [docs/111 — Discipline Responsibility, Technical Leadership and Conflict Governance](111_RFI_DD03_DISCIPLINE_RESPONSIBILITY_TECHNICAL_LEADERSHIP_AND_CONFLICT_GOVERNANCE_WORKING_DRAFT.md)
- DD-08: [docs/76 — Attachment and Evidence Security](76_RFI_ATTACHMENT_AND_EVIDENCE_SECURITY_WORKING_DRAFT.md)
- DD-14: [docs/82 — Records Retention, Archive, Legal Hold and Disposition](82_RFI_RECORDS_RETENTION_ARCHIVE_LEGAL_HOLD_DISPOSITION_WORKING_DRAFT.md)
- DD-15: [docs/83 — Test Governance and Acceptance Catalogue](83_RFI_TEST_GOVERNANCE_AND_ACCEPTANCE_CATALOGUE_WORKING_DRAFT.md)
- OR-03 specialist validation coordination: [docs/125](125_OR03_SPECIALIST_VALIDATION_AND_EVIDENCE_MATRIX_WORKING_DRAFT.md)
- Owner dispositions: docs/121 (D09), docs/122 (D10), docs/123 (D11), docs/124 (D12)
- Controlling owner decisions: OR03-D01–D12, conditionally approved within their recorded scopes
- Governance constraints: DEC-103–DEC-110

> Scope note: DD-04 is treated here as the independent-review specification/dependency referenced by DD-03 and OR03-D09/D10. The review does not infer that a final, separately approved DD-04 specification or an approved project risk-and-authority matrix exists. DD-08 and DD-14 are included because the exact evidence and records controls are necessary dependencies for D10/D11.

## 1. Executive result

**No direct normative contradiction was identified** among the reviewed DD-03, DD-08, DD-14 and DD-15 working drafts when read with OR03-D09, D10 and D11. Their central boundaries are mutually reinforcing:

1. Technical conflict resolution is distinct from independent review.
2. Independent review is triggered only by an applicable approved/versioned risk-and-authority instrument.
3. Review clearance is bound to the exact response/evidence version actually reviewed.
4. Conflict positions, dissent, evidence and decisions remain attributable and historically preserved.
5. Technical closure, archive, retention, legal hold and disposition are separate concepts and controls.
6. No technical, communication, administrative or archive event autonomously changes another process's authority or lifecycle.
7. Unresolved authority, materiality, evidence integrity, retention or legal prerequisites remain blocked rather than inferred.

**Overall classification:** Aligned at principle level; conditional design dependencies remain open. This is a desk consistency review, not specialist sign-off, owner closeout, formal DD approval or implementation readiness.

## 2. Review method and classification

The review compared:
- authority and role boundaries;
- conflict classification, materiality and scoped blocking;
- independent-review trigger and reviewer independence;
- exact-version evidence and review clearance;
- dissent, correction, predecessor/successor and audit history;
- records classification, retention, archive, hold and disposition;
- recovery, access revocation and residual copies;
- testability and unresolved prerequisite handling.

Finding classes:
- **Aligned:** no contradiction identified; source rules reinforce one another.
- **Dependency / open design:** compatible principles depend on a missing approved instrument, detailed rule or specialist evidence.
- **Clarification recommended:** wording or cross-reference should be made explicit to prevent inconsistent implementation later.
- **Conflict:** two applicable rules cannot both be followed. No such direct conflict was found in this review.

## 3. Cross-specification findings

### CRX-01 — Conflict resolution is not independent review

**Sources:** DD-03 §§7–9 and §10; OR03-D05/D08/D09; docs/121; DD-15 §§4, 8 and 18.

**Finding:** Aligned. DD-03 states that the technical lead or conflict-resolution authority cannot waive mandatory independent review. OR03-D09 conditions independent review on an approved/versioned risk-and-authority matrix. DD-15 likewise requires independent acceptance review only where the approved matrix requires it.

**Control:** Keep two separate records and decisions: (a) technical conflict disposition by the evidenced competent authority, and (b) independent-review trigger/appointment/clearance under the applicable approved instrument. One cannot substitute for the other.

**Open dependency:** The actual approved matrix, version, triggers, decision authority and reviewer appointment evidence are not supplied by these working drafts.

**Disposition:** Aligned — matrix and appointment prerequisites remain Pending / Blocked where absent.

### CRX-02 — Conflict class, materiality and blocking scope

**Sources:** DD-03 §§7.1 and 7.4; OR03-D04/D05; docs/116 and docs/117; DD-15 §§8 and 18.

**Finding:** Aligned with an unresolved validation dependency. C0–C4 are descriptive conflict types, not a severity ranking. Materiality and blocking scope require a reasoned, attributable assessment; unresolved material conflict blocks affected content, while a broader parent hold requires a real recorded dependency.

**Control:** Do not derive risk severity, materiality thresholds or parent-level blocking from the C-number. Where criteria, authority or affected dependencies are unclear, hold the affected gate and refer to the competent authority.

**Open dependency:** Worked examples and project-approved materiality/risk criteria require technical, discipline and risk/quality specialist validation. No universal threshold is established.

**Disposition:** Aligned — specialist validation and project-specific criteria pending.

### CRX-03 — Exact-version review clearance and evidence identity

**Sources:** DD-03 §§5, 7.2, 7.3 and 9; OR03-D10 / docs/122; DD-08 §§3–4, 7 and 12; DD-15 §§3 and 11.

**Finding:** Aligned. DD-03 requires contribution/candidate versions and review impact to be recorded. OR03-D10 says prior clearance remains tied to the exact reviewed version. DD-08 requires stable evidence/version IDs and immutable manifests at review binding and other formal freeze points. DD-15 requires exact evidence references and retained execution evidence.

**Control:** A review record must identify the exact response candidate/version and the exact evidence IDs/version IDs/integrity references relied upon. A later file upload, new contribution, changed assumption or successor candidate must not silently inherit prior clearance.

**Open dependency:** The final canonical identity relationships among RFI cycle, response version, contribution version, evidence version, review record and manifest remain subject to DD-05–DD-08 detailed design and architecture/security review.

**Disposition:** Aligned — canonical identity and manifest contract require detailed-design reconciliation.

### CRX-04 — Conflict history, dissent and correction traceability

**Sources:** DD-03 §§7.2–7.3 and 9; OR03-D06/D11; docs/118 and docs/123; DD-08 §12; DD-14 §§15–16.

**Finding:** Aligned. DD-03 requires source positions, versions, dissent, decision rationale and event history. OR03-D11 prohibits destructive replacement and requires predecessor/successor traceability. DD-08 requires append-only attributable custody/security events. DD-14 requires attributable correction/reclassification and records incident history.

**Control:** Distinguish at minimum:
- the original technical position/contribution;
- a later corrected or successor position;
- the conflict classification and scope assessment;
- the authorized conflict decision and its rationale;
- the review/re-review result for the exact candidate;
- any records metadata correction or reclassification event.

A correction to a record must not rewrite the underlying historical technical position or decision. A conflict closure event does not close the parent RFI or satisfy archive/disposition gates.

**Open dependency:** A common event taxonomy, identity/lineage model, authoritative record owner, access model and retention mapping have not been approved.

**Disposition:** Aligned — detailed event/identity/records mapping pending.

### CRX-05 — Retention, archive, legal hold and disposition remain outside technical conflict closure

**Sources:** OR03-D11 / docs/123; DD-14 §§4–5, 7, 10–14 and 22; DD-08 §13; DEC-109.

**Finding:** Aligned. Conflict closure and parent RFI closure are not records disposition. DD-14 explicitly separates technical closure, supersession, archive, retention, legal hold, disposition review and destruction. Expiry is only a candidate trigger for controlled review, not automatic deletion.

**Control:** Preserve conflict and dissent evidence according to an approved records schedule and applicable hold. Do not invent a retention trigger from conflict closure, RFI closure, supersession, last access or upload date.

**Open dependency:** Records series/classification, retention schedule, trigger authority, hold authority/scope/release, archive package, disposition authority, backup and residual-copy treatment require records/legal/contract/security/architecture validation.

**Disposition:** Aligned — all records-policy and disposition controls remain unapproved and blocked.

### CRX-06 — Access authorization is separate from historical preservation

**Sources:** DD-08 §§8–9 and 11–12; DD-14 §§9 and 12; DEC-021 and DEC-109.

**Finding:** Aligned. Preservation of a historical conflict record does not create access entitlement. Each file operation and historical retrieval is authorized server-side for the exact actor, record, file/version and purpose. Archive access remains permission-controlled. Linked-record relationships do not grant cross-record access automatically.

**Control:** A record may remain preserved while a particular actor is denied access. Revocation must apply to subsequent requests; prior downloaded or recipient-held copies cannot be represented as remotely recalled.

**Open dependency:** Exact capability, party/project/discipline visibility and cache/index revocation consistency are not finalized.

**Disposition:** Aligned — security/privacy/architecture review pending.

### CRX-07 — Recovery and backup copies must preserve history and restrictions

**Sources:** DD-08 §§10, 13; DD-14 §12; DD-15 §§6, 15 and 18.

**Finding:** Aligned. A restored system must reconcile evidence manifests, access policies, legal holds, disposition logs and linked records before service is declared available. Backup/replica/cache/recipient-held copies have distinct lifecycles. Restore must not erase a hold or resurrect disposed material without controlled handling.

**Control:** Do not claim that conflict history or evidence is fully preserved merely because a primary database record exists. Recovery acceptance requires evidence and reconciliation across relevant copies and restrictions.

**Open dependency:** Backup architecture, recovery objectives, retention/hold effects on rotation, reconciliation method and residual-copy exception process remain unspecified.

**Disposition:** Aligned — separate recovery architecture and rehearsal plan required before any DB/Storage change.

### CRX-08 — Test catalogue follows the same authority and evidence boundaries

**Sources:** DD-15 §§3–6, 8, 11, 15–18; DD-03 §§7–9; DD-08; DD-14; DEC-110.

**Finding:** Aligned. Tests cannot approve a policy gap, invent a trigger, grant authority or report Pass without an approved expected result and retained execution evidence. Unresolved behavior is Blocked — Pending Design Decision/Prerequisite.

**Control:** Map tests separately for:
- conflict classification and affected-scope blocking;
- conflict authority and preserved dissent;
- matrix-driven independent-review trigger and reviewer independence;
- exact-version review and change-impact/re-review;
- evidence integrity and immutable manifests;
- records correction/history and authorized access;
- retention/hold/disposition and recovery reconciliation.

**Open dependency:** Actual AT-RFI and E2E scenario definitions must be imported and mapped; no test execution or pass is claimed.

**Disposition:** Aligned — test mapping and specialist approval pending.

## 4. Consolidated dependency and blocker register

| ID | Dependency / prerequisite | Required validation authority | Interim treatment |
|---|---|---|---|
| DEP-01 | Approved/versioned risk-and-authority matrix, trigger criteria, scope and decision authority | Project risk/quality authority; appointing/project governance; QA/independent assurance | Block mandatory-review determination where absent or ambiguous |
| DEP-02 | Reviewer competence, appointment, independence and conflict-of-interest evidence | Appointing authority; QA/independent assurance; relevant technical authority | No reviewer clearance or inferred appointment |
| DEP-03 | Project-specific materiality, affected-scope and dependency criteria | Technical authority; affected discipline authorities; risk/quality | Hold affected gate where uncertain; no universal threshold |
| DEP-04 | Canonical identity/version/manifest relationships for contribution, conflict, candidate, review and evidence | Architecture/data; Document Control/records; security | No silent version inheritance or assumed identity mapping |
| DEP-05 | Approved records classification, series, retention schedule and trigger authority | Records authority; legal/contract where applicable; owner | No retention period or trigger invented; no disposition |
| DEP-06 | Legal-hold authority, scope, overlap, review and release route | Legal/records/contract authority | Hold scope remains unresolved; fail closed |
| DEP-07 | Archive/disposition authority, linked-copy scope, backup and residual-copy treatment | Records/legal/security/architecture | No archive/deletion implementation or erasure claim |
| DEP-08 | Exact-version access, revocation, cache/index and linked-record authorization | Security/privacy/architecture | No access grant; server-side authorization remains mandatory |
| DEP-09 | Actual test scenario definitions and approved expected outcomes | QA; owner; security; records; architecture; technical authorities | Block test mapping/execution where source scenario or expected result is missing |

## 5. Clarifications recommended before specification promotion

These are documentation clarifications, not new policy decisions:

1. Add a direct cross-reference in DD-03 conflict closure text stating that closure of the conflict record does not satisfy RFI closure, archive eligibility, retention expiry or disposition eligibility.
2. In the DD-04 specification, explicitly require the independent-review record to bind to the exact candidate version and the exact evidence manifest/version references reviewed.
3. In DD-14, explicitly map conflict records, original discipline positions, dissent, conflict decisions, review/re-review records and successor versions into the records classification exercise; do not presume they all form one retention series.
4. In DD-08, explicitly cross-reference OR03-D10 and DD-04 so that changed evidence/version triggers documented review-impact assessment without automatic full RFI restart.
5. In DD-15, ensure tests distinguish conflict resolution, independent-review clearance, technical issue/closure, archive, legal hold and disposition as separate outcomes.

No clarification above creates a new authority, threshold, retention period, trigger, permission or operational transition.

## 6. Verification checklist for the next revision

- [ ] DD-03 exact version checked against OR03-D01–D12.
- [ ] DD-04 exact version and approved risk-and-authority instrument identified.
- [ ] DD-08 exact evidence identity and manifest design reconciled.
- [ ] DD-14 records classification and retention authority supplied.
- [ ] DD-15 test scenarios imported and mapped to approved requirements.
- [ ] Findings from discipline, technical, QA, security, records, legal/contract and architecture reviewers are attributable and version-bound.
- [ ] All conditions, dissent and blockers are dispositioned by the competent authority.
- [ ] A fresh cross-specification review is performed on the exact revised files.

## 7. Conclusion and boundaries

**Conclusion:** The reviewed documents are coherent at the level of core principles. No direct contradiction was identified. The material gaps are dependencies requiring approved instruments, exact-version identity design, specialist findings and records/legal/security decisions. They must remain visible blockers and must not be converted into defaults.

This review does not:
- formally approve DD-03, DD-04, DD-08 or DD-14;
- close OR-03 or mark specialist validation complete;
- appoint reviewers or grant authority/capabilities;
- approve a risk matrix, severity/materiality thresholds or legal/contractual interpretation;
- establish retention periods, legal-hold authority, archive tier or destruction method;
- authorize implementation, UI/API/code, DB/schema/migrations/generated types, Storage, authentication, authorization/RLS, production-data operations, test execution, backup/restore, merge, deployment or release.

Any future implementation or test execution requires a separate scoped plan, resolved prerequisites, exact owner and specialist approvals, evidenced appointments, approved non-production environment and synthetic data, and explicit authorization. DB/Storage changes additionally require verified backups, isolated restore/rehearsal and reconciliation before changes.

---

**Review result:** 8 cross-specification findings recorded; 0 direct normative contradictions identified; 9 explicit dependencies/blockers retained; specialist validation remains pending; no implementation or test execution performed.


## 8. Follow-on DD-04 specification status note

After this desk review was prepared, a consolidated DD-04 candidate specification was created at `docs/127_RFI_DD04_INDEPENDENT_REVIEW_AND_SEPARATION_OF_DUTIES_SPEC_WORKING_DRAFT.md`. It elaborates the preliminary DD-04 material in docs/72 §10 and preserves OR03-D09/D10 boundaries. **Document 127 was not part of the source set reviewed in this document.** It therefore remains subject to owner/specialist review and a fresh cross-specification consistency review against DD-03, DD-08, DD-14, DD-15, DEC-103–DEC-110 and OR03-D09/D10 before any promotion. This status note does not amend the eight findings or imply validation of the new specification.


## 9. Follow-on DD-04 decision matrix status note

A candidate decision/control matrix was subsequently created at `docs/128_RFI_DD04_DECISION_AND_REVIEW_CONTROL_MATRIX_WORKING_DRAFT.md`, containing DM-01–DM-20. This matrix was not part of the source set for the original eight-finding desk review and has not been specialist-validated. It is linked to docs/127, docs/125, docs/71 and docs/83. Before promotion, conduct a fresh exact-version cross-specification review of docs/127–128 against DD-03, DD-08, DD-14, DD-15, DEC-103–DEC-110 and OR03-D08/D09/D10. Verify that every decision authority, trigger, reviewer appointment, outcome and hold is supported by an approved instrument and current appointment evidence. No matrix criteria, thresholds, appointments, permissions or implementation authority are created by this follow-on note.


## 10. Subsequent DD-04 matrix review reference

The follow-on review of the consolidated DD-04 specification and decision matrix is recorded separately in `docs/129_DD04_DECISION_MATRIX_CROSS_SPECIFICATION_REVIEW_WORKING_DRAFT.md`. That review identifies no direct normative contradiction after two clarifications in docs/128, while retaining DEP-01–DEP-09 as open prerequisites. It is a desk review only and does not amend the original eight findings or validate project-specific instruments, appointments, security/records implementation or tests.
