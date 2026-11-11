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
- **WIR** = Work Inspection Request.
- **RFI** = **Request for Inspection** in this project; it is separate from WIR, not Request for Information.
- **MQR** = Monthly Quality Report with an independent review workflow; do not apply the ordinary B/C response-code cycle to MQR by default.
- Preserve approved response semantics for other applicable document types.
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
