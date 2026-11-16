# SiteDocs — Design Reference Kit

Independent design and UX references for PROJECT DOC CONTROL.

- `originals/`: exact uploaded HTML sources, preserved unchanged.
- `prototypes/`: revised standalone HTML prototypes.
- `DESIGN-SPEC.md`: approved terminology, configurable document-type definitions, and workflow constraints.

## Approved document-type baseline
- `WIR` = Work Inspection Request (طلب فحص/معاينة الأعمال المنفذة).
- `RFI` = Request for Information (استفسار هندسي/طلب إيضاح).
- WIR and RFI use separate forms, numbering streams, permissions, response handling, review workflows, and reports.
- Project configuration may adapt document codes and labels to the governing contract, but one code must never have two meanings within the same project.

## Safety boundary
These are standalone visual/interaction prototypes, not production integrations. Demo records and buttons remain browser-local simulations. No database, authentication, file storage, scanner, OneDrive, notifications, billing, server-side validation, or audit trail is connected.

This kit lives outside `src/` on its own branch. It does not change application runtime, schemas, migrations, generated types, protected branches, deployments, or existing pull requests.

## Naming
`SiteDocs` is a temporary UI label. Keep product name, logo, and visual identity independent from business logic, document identifiers, stored records, routes, and integrations.

## Evolution
1. Keep `originals/` immutable.
2. Iterate in `prototypes/`.
3. Update `DESIGN-SPEC.md` when an approved rule changes.
4. Before integrating anything into the app, prepare a separate implementation plan and review it against architecture and tests.
