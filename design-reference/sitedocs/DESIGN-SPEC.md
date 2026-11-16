# Design and Workflow Reference

## Product identity
- Temporary interface label: **SiteDocs**; final name remains open.
- Name, logo, typography, and theme must be replaceable independently of logic, document IDs, database keys, APIs, and stored history.

## Canonical disciplines
| Code | Arabic | English |
|---|---|---|
| ARC | معماري | Architectural |
| CIVSTR | مدني وإنشائي | Civil & Structural |
| MEC | ميكانيكا | Mechanical |
| ELE | كهرباء | Electrical |
| SUR | أعمال المساحة | Surveying |

Legacy `CIV` and `STR` normalize to `CIVSTR`. Keep the combined discipline intact and emit only canonical codes for new references.

## Document types and review boundaries
### Approved baseline and project configuration
- **WIR** = **Work Inspection Request** (طلب فحص/معاينة الأعمال المنفذة).
- **RFI** = **Request for Information** (استفسار هندسي / طلب إيضاح).
- WIR and RFI are distinct document types. They must have separate forms, numbering streams, permissions, response handling, review workflows, status transitions, registers, and reports.
- WIR follows the project's inspection/review outcome process. RFI follows an engineering clarification lifecycle: draft → submitted / awaiting response → answered → closed (with clarification/revision loops where required). Do not force B/C inspection outcomes onto RFI.
- The above meanings are SiteDocs defaults, not a claim that every contract uses the same terminology. Each project may configure document-type codes, labels, definitions, and workflow mappings to match its governing contract and approved project procedures.
- Enforce uniqueness of the document-type code within each project: a code cannot map to two meanings or workflows in the same project. If a project uses a different contractual meaning for a code, configure that meaning explicitly before use; never silently reinterpret existing records.
- Configuration changes must preserve historical records and their original type definition/version.
- **MQR** = Monthly Quality Report with an independent review workflow; do not apply the ordinary B/C response-code cycle to MQR by default.
- Preserve approved response semantics for other applicable document types. Inspection outcomes such as B/C belong only to document types whose configured workflow explicitly uses them.
- Drafts stay hidden from other parties until official submission.
- Project Manager oversight is read-only, including drafts; it does not grant editing, review, response, closure, or revision rights.
- Preserve historical records; superseded items are marked, not deleted.

## Visual system
- Responsive bilingual Arabic/English with correct RTL/LTR.
- Consistent spacing, typography, field labels, status semantics, focus visibility, and keyboard navigation.
- Canonical discipline labels must match across forms, registers, reports, filters, and exports.
- Status must not be conveyed by color alone.
- Forms remain reusable and visually consistent with the application shell.

## Prototype limitations
Local JavaScript state, sample records, simulated scan/cloud flags, QR values, and trial controls are not production integrations or persistence. No real authorization, audit trail, server validation, storage, notifications, or external connector is implemented.

## Future changes
Visual identity and labels are extensible. Changes must not silently alter numbering, permissions, review authority, historical records, or data contracts.
