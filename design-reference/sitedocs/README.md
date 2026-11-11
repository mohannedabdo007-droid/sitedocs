# SiteDocs — Design Reference Kit

Independent design and UX references for PROJECT DOC CONTROL.

- `originals/`: exact uploaded HTML sources, preserved unchanged.
- `prototypes/`: revised standalone HTML prototypes.
- `DESIGN-SPEC.md`: approved terminology and design constraints.

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
