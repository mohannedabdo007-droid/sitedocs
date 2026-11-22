# OR-01 SV-01 — Dictionary and Transition Cross-Consistency Review

**Status:** WORKING DRAFT — DESK REVIEW — SPECIALIST VALIDATION PENDING  
**Date:** 2026-11-12  
**Branch:** `implementation/ui-foundation-2026-11-11`

## 1. Scope and reviewed versions

This review compares the current candidate dictionary, transition crosswalk, prior desk validation and source DD-01/DD-02 draft.

| Source | Reviewed SHA | Role |
|---|---|---|
| docs/108 Canonical RFI Lifecycle Dictionary | `06988f0f841b4d1819f3dfe62f760a0f2c0fe6af` | Candidate semantic dictionary |
| docs/106 Parent Transition and Authority Crosswalk | `64bc870b3ca11c1eb9a4041f24bf26678b03fa7f` | Candidate transition/authority mapping |
| docs/107 Transition Crosswalk Desk Validation | `42805d1bee467cfd2ca146b937fc97c3ccb39f6c` | Prior desk findings |
| docs/72 RFI Lifecycle and Authority Specification | `4cb82360490ec283ddf334af1115d23869212ab9` | Original DD-01/DD-02 candidate specification |
| docs/71 RFI Detailed Specification Backlog | `c6f9abdc0f3c90668318633aad9c7903b239f592` | Work item dependencies/status |
| docs/104 Specialist Validation Matrix | `00e258638bae660655bf8729a8408879ddf072cd` | Specialist evidence register |

This is a document consistency review only. It is not specialist approval, owner approval of a new detailed-design baseline, test execution or implementation authorization.

## 2. Executive finding

The dictionary and crosswalk are **broadly aligned in their governing semantic boundaries**, but the source docs/72 contains candidate transition wording that is less constrained than later owner dispositions. The consolidated DD-01/DD-02 package must therefore use the owner-confirmed constraints as boundaries and retain unresolved mechanics as explicit open fields.

No evidence supports promoting SV-01 to specialist-validated or closing G-01–G-06.

## 3. Consistency matrix

| Topic | Docs/108 | Docs/106 / docs/72 | Finding | Required treatment in unified package |
|---|---|---|---|---|
| Draft vs official RFI | Draft/Abandoned Draft are pre-submission conditions outside parent lifecycle | Docs/72 similarly distinguishes draft from submitted RFI | Aligned | Preserve distinct draft-record owner; no official number before successful submission |
| Parent stage vocabulary | Eleven candidate labels; no parent “Reopened” label | Docs/72 uses the same core labels and a reopening event/new cycle | Aligned with qualification | Keep labels provisional and cycle projection unresolved |
| Under Coordination → Technical Assessment | Function split and two-key hand-off | Docs/72 says technical authority sets scope while coordinator routes | Docs/72 is less explicit about complete required assignment gate | Apply DISP-OR01-004: technical scope/assignment decision plus administrative readiness execution; all required assignments must be evidenced |
| Returned for Completion | Ordinary pre-technical return; late defect separate Option C route | Docs/72 candidate row allows administrative return but lacks full late-correction route | Needs refinement | Distinguish ordinary return from late correction; no silent technical reset |
| Clarification | Parent blocker vs contribution-only blocker; exact prior-stage resume | Docs/72 has a broad transition row from In Technical Assessment and resume when all blockers satisfied | Material incompleteness | Do not infer eligible source stages; require reasoned parent dependency, scoped blocker, preserve first prior stage, resolve all parent blockers and revalidate guards |
| Consolidation | Required contributions complete or valid scope change; provisional prep remains subordinate | Docs/72 allows consolidation after all required contributions or scope change, but asks about parallel preparation | Owner disposition adds precision | Parent remains In Technical Assessment during provisional preparation; no formal consolidation/readiness/issue implication |
| Scoped return from consolidation | Only material technical gap/dependency/invalidated contribution/scope/evidence/conflict; preserve unaffected work and versions | Docs/72 broad technical-lead route | Docs/72 less bounded | Use DISP-OR01-007 bounded return and exact contribution/candidate version lineage |
| Independent review | Exact-version and approved matrix trigger | Docs/72 refers to approved risk trigger and frozen version | Aligned, prerequisite incomplete | Do not invent matrix owner, thresholds, appointment or review state transitions |
| Ready for Issue | Separate readiness record, exact package and authority; not issue | Docs/72 candidate readiness state | Docs/72 does not fully express distinct readiness record | Require exact candidate/package-bound readiness confirmation; issue-time revalidation |
| Formal issue and closure | Distinct evidence identities, one indivisible successful business outcome | Docs/72 says atomic issue/closure | Aligned, detailed transaction contract open | No partial successful issue/closure; architecture/recovery/idempotency design remains open |
| Withdrawal / cancellation | Distinct whole-parent/pre-issue outcomes with narrow grounds and authority | Docs/72 uses broader candidate wording including “other specifically approved” cancellation grounds | Needs constraint tightening | Use only current owner-approved baseline grounds; do not expand eligible states or authorities |
| Reopening | New response cycle; prior cycle remains immutable; parent projection unresolved | Docs/72 says Closed → Reopened event/new active cycle | Conceptually aligned, parent projection unresolved | No “Reopened” parent stage; define cycle identity and starting-stage assessment; G-01 remains open |
| Subordinate records/events/indicators | Distinct semantic types and record owners | Docs/72 lists independent child states and indicators | Aligned at principle level | Qualify every state by owning record; child event never autonomously changes parent |
| Authority | Function is not appointment; action-time scope/evidence | Docs/72 has role responsibility and capability matrix | Aligned, but candidate labels can be mistaken for real roles | No real person, capability ID, appointment or grant inferred; actual instruments required |

## 4. Material corrections required when using docs/72

The following are not amendments to owner decisions; they are guardrails against carrying forward broader candidate wording:

1. **Clarification source stage:** docs/72's illustrative In Technical Assessment → Awaiting Originator Clarification row must not be read as an exhaustive eligible source-stage rule. G-02 remains open.
2. **Consolidation:** provisional preparation may occur while the parent remains In Technical Assessment. It must not be called formal parent Under Consolidation until DISP-OR01-006 entry conditions pass.
3. **Cancellation:** docs/72's phrase “or other specifically approved administrative ground” cannot be used to broaden the currently approved narrow baseline. Any added ground needs a separate explicit owner decision.
4. **Withdrawal/cancellation authority:** a coordinator or Document Control function is not automatically the approving authority. The evidenced appointed records/workflow authority and any required technical-lead concurrence govern.
5. **Reopening:** “Closed → Reopened” is an event/cycle creation concept, not an approved new parent stage. Parent projection remains G-01.
6. **Ready for Issue:** readiness is a separate attributable record tied to exact candidate/package; it does not itself issue or close.
7. **Issue/closure:** issue and technical closure remain separate evidence identities but one indivisible successful business outcome; detailed transaction/recovery contract remains pending.
8. **Returned for Completion:** ordinary pre-technical return and late material administrative correction must not be conflated.
9. **Authority matrix:** docs/72 capability labels are conceptual. They do not establish actual appointment/delegation or live authorization.

## 5. Semantic ownership and naming checks

The dictionary provides a workable conceptual ownership split:
- Official parent RFI owns one current parent stage.
- Response-cycle record owns its cycle identity, stage and outcome history.
- Assignment, contribution, clarification, response candidate, review, readiness, Transmittal, recipient, notification, report/export and records-control records own their own subordinate state/events.
- Immutable event records own occurrence history.
- Indicator projections own derived workload, aging, delivery and acknowledgement metrics.

Remaining risk: unqualified words such as “Closed”, “Completed”, “Resolved”, “Accepted”, “Issued” and “Acknowledged” can still be ambiguous when copied into UI labels or reports. The unified package must always name the owning record and semantic type.

## 6. DD-01/DD-02 package completeness assessment

| Required design element | Current source coverage | Package status |
|---|---|---|
| Parent and cycle semantic model | docs/108 + docs/106 + docs/72 | Candidate consolidated; G-01 open |
| Parent transition catalogue | docs/106 + docs/72 | Candidate consolidated; G-02/G-03/G-06 open |
| Child-state/event/indicator separation | docs/108 + docs/106 | Candidate consolidated; specialist review pending |
| Action-level authority boundaries | docs/72 §4 + docs/106 | Candidate consolidated; actual appointments absent |
| Action-time authorization and deny-by-default | docs/72 §4 | Candidate consolidated; security review pending |
| Capability catalogue identifiers and grant/revoke authority | docs/72 §4.4 and open decisions | Not complete; do not invent IDs or grants |
| Separation of duties | docs/72 §4.5 and DISP-OR01-008/010 | Candidate constraints captured; appointment evidence and matrix open |
| Failure/recovery/idempotency for each transition | docs/75 dependency; docs/106 G-06 | Not complete; separate DD-07 dependency |
| Test scenarios and acceptance evidence | docs/83; DEC-110 | Design catalogue only; no execution |
| Specialist evidence | docs/104 | Pending; no sign-offs recorded |

## 7. Open issues and required authorities

| Issue | Required decision/evidence domains | Status |
|---|---|---|
| G-01 parent stage during reopened cycle | Process owner, technical authority, architecture/data, Document Control, records | Open |
| G-02 eligible parent clarification source stages and blocker aggregation | Technical authority/lead, affected disciplines, process owner, architecture, QA | Open |
| G-03 late administrative correction route | Process owner, records/correction authority, Document Control, technical authority, architecture, QA | Open |
| G-04 actual appointment/delegation and function combination | Appointing authority, project governance, technical authority, security, architecture | Open |
| G-05 final semantic dictionary and metric ownership | Process owner, technical authority, architecture, records/reporting, QA | Open |
| G-06 complete transition guard/failure/recovery contract | Architecture, security, QA, records, technical authority, engineering | Open |
| Capability identifiers/grant/revoke authority | Identity/security authority, appointing/project governance, owner | Open |
| Discipline-specific assignment and completion criteria | Discipline authorities, appointed technical lead/authority, process owner | Open |
| Independent-review risk matrix | Risk/quality authority, technical authority, owner, security/QA | Open |
| Numbering/legacy reconciliation dependencies | Document Control, records/data governance, architecture, owner | Separate DD-06 dependency; not a blocker to dictionary vocabulary alone |

## 8. Disposition

- Docs/108 is accepted as the current **candidate semantic dictionary for controlled review**, not a final canonical state model.
- Docs/106 remains the candidate transition/authority crosswalk.
- Docs/72 remains the source working draft, but broad transition language must be read subject to later conditional owner dispositions.
- Docs/109 records the consistency findings and guardrails.
- The unified DD-01/DD-02 package may be used for structured owner/specialist review only.
- Specialist validation remains pending; no review evidence or sign-off is inferred.
- G-01–G-06 remain open. DD-01/DD-02 are not implementation-ready.

## 9. Explicit exclusions

No final state machine, schema, capability identifiers, role bundles, appointments, grants, workflow, UI/API/code, DB/migrations/generated types, Storage, authentication, authorization/RLS, production data, test execution, backup/restore, merge, deployment or release is created or authorized.

---

**End of consistency review — candidate sources reconciled with owner constraints; specialist validation and detailed-design promotion remain pending.**
