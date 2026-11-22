# OR03-D04 — Conflict Classification and Scoped Blocking Owner Disposition

**Status:** CONDITIONALLY APPROVED BY OWNER — SPECIALIST VALIDATION PENDING — WORKING DISPOSITION — NOT IMPLEMENTATION AUTHORIZATION  
**Date:** 2026-11-12  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Parent owner package:** `docs/86_RFI_OWNER_REVIEW_PACKAGE_WORKING_DRAFT.md` §OR-03  
**Decision package:** `docs/112_OR03_DISCIPLINE_CONFLICT_AND_INDEPENDENT_REVIEW_OWNER_DECISION_PACKAGE_WORKING_DRAFT.md` §OR03-D04  
**Detailed candidate specification:** `docs/111_RFI_DD03_DISCIPLINE_RESPONSIBILITY_TECHNICAL_LEADERSHIP_AND_CONFLICT_GOVERNANCE_WORKING_DRAFT.md`

## 1. Owner disposition

The owner conditionally approves retaining C0–C4 as **descriptive conflict classes**, not as a severity scale, priority ranking, risk score or automatic escalation ladder. The class number alone must not determine materiality, blocking extent, authority, urgency or issue outcome.

The candidate descriptions retained for specialist validation are:

| Class | Descriptive nature | Candidate handling boundary |
|---|---|---|
| C0 | Compatible inputs | Record the compatible synthesis and source attribution; this class alone creates no conflict block, subject to all other gates. |
| C1 | Interface or assumption clarification | Seek targeted clarification and preserve source positions; hold affected content only where clarification is necessary to establish technical correctness. |
| C2 | Material technical disagreement | Preserve each position and its evidence; block the affected response content until an authorized disposition resolves the material disagreement. |
| C3 | Authority or scope dispute | Hold the affected decision and refer it to the evidenced competent authority; no coordinator tie-break or assumed delegation. |
| C4 | External or unresolved dependency | Record the dependency, responsible external/internal party and required input; hold only the dependent content or decision until the dependency is resolved or an authorized, technically valid disposition is recorded. |

These are descriptive categories. The detailed criteria, examples and mapping to project-specific procedures remain subject to specialist validation; no class is a substitute for recording the facts and impact of the actual issue.

## 2. Mandatory blocking and scope controls

1. A material, unresolved technical conflict blocks the **affected response content** from issue.
2. A dispute over authority or decision scope blocks the affected decision until the competent authority and its mandate are evidenced.
3. An external or unavailable dependency blocks only the content or decision that genuinely depends on it.
4. A conflict in one discipline or interface does not automatically stop the entire RFI, all unrelated contributions or the whole project.
5. The blocking scope must be explicitly recorded: affected discipline/interface, response section or decision, dependent items, reason, evidence and the authority required to resolve it.
6. A broader block is justified only where a real technical, safety, regulatory, contractual or logical dependency is identified and evidenced. The rationale and extent of that dependency must be recorded; it must not be presumed from the C0–C4 label.
7. No affected content may be represented as resolved, technically confirmed or ready for issue while its material blocker remains open.
8. Resolution of a blocker releases only the scope it actually affected and does not automatically satisfy independent review, readiness, issue or other lifecycle gates.

## 3. Classification is not severity or authority

C0–C4 must not be interpreted as increasing severity from zero to four. In particular:
- C4 is not inherently more severe than C2; it describes an external or unresolved dependency.
- C3 identifies an authority/scope question, not an engineering severity rating.
- C1 may require a hold if technical correctness cannot otherwise be established, but it is not automatically a material technical disagreement.
- C0 does not waive any unrelated required contribution, review, evidence, approval or readiness control.

Materiality and the proportional scope of any block must be assessed from the actual technical impact, applicable project requirements and evidenced dependencies by the competent authorized persons. No numerical threshold, severity score, default SLA or priority is created by this disposition.

## 4. Authority, record and escalation

The person recording a class must preserve the facts, affected scope, source positions, evidence, dependencies, classification rationale, current blocker status and required decision authority. Classification itself does not confer authority to resolve the conflict.

The technical lead may coordinate classification and consolidation within the mandate conditionally approved under OR03-D03. A conflict beyond that mandate must be referred to the properly appointed competent authority. The RFI coordinator remains administrative and cannot settle a technical conflict.

If the class, materiality, affected scope, dependency or competent authority is disputed or ambiguous, the affected decision remains on hold pending an evidenced determination. No majority vote, silence-as-concurrence or silent override is permitted.

## 5. Independent review remains separate

This classification and blocking disposition does not create, waive or replace independent review. Any mandatory independent review remains a separate DD-04 gate governed by an approved, versioned risk-and-authority matrix. Conflict resolution does not itself satisfy that gate; a C0 classification does not exempt a response from independent review where the approved matrix requires it.

## 6. Conditions and specialist validation

This disposition is conditional on review by the affected discipline authorities, technical/conflict authority, project/process owner, independent assurance/QA, design/engineering authority, Document Control/records and relevant contractual/regulatory authority as applicable.

Specialists must validate:
- descriptive definitions, examples and classification boundaries for C0–C4;
- criteria for materiality and evidence needed to justify a blocking scope;
- how affected content, cross-discipline interfaces and dependent decisions are identified;
- who is authorized to classify, challenge, resolve and release each type of blocker;
- external dependency handling and any project-specific authority route;
- consistency with OR03-D01 through OR03-D03, DD-04 independent review and the approved project governance framework.

No final severity taxonomy, risk matrix, thresholds, project checklist, appointment or permission is approved here.

## 7. Owner confirmation

**Owner decision:** Conditionally approved with the controls in this memorandum.  
**Exact scope:** C0–C4 are descriptive conflict classes, not severity levels; unresolved material conflict blocks affected content; authority disputes hold affected decisions; external dependencies block only dependent scope; broader holds require evidenced dependencies; independent review remains separate.  
**Conditions:** Specialist validation and evidenced authority/project criteria remain prerequisites.  
**Decision date:** 2026-11-12.  
**Decision source:** Explicit owner instruction in the project conversation: “اعتمد مع الضوابط”.

---

**End of OR03-D04 owner disposition — specialist validation pending; no implementation, risk-matrix approval or authority appointment.**
