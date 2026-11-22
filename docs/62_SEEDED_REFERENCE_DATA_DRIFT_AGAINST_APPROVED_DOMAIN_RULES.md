# 62 - Seeded Reference Data Drift Against Approved Project Domain Rules

**Repository:** `mohannedabdo007-droid/sitedocs`  
**Branch:** `dev/review-fixes`  
**Review type:** Static migration review and comparison against explicitly approved project decisions

## Executive summary

The reference-data seed statements in the checked `0000_core_schema.sql` snapshot still encode several domain definitions that conflict with decisions explicitly approved for PROJECT DOC CONTROL:
- Structural and Civil are seeded as separate disciplines, while the approved taxonomy combines them as Civil & Structural and adds Survey as the fifth discipline.
- RFI is seeded as “Request for Inspection / Information”, while the approved meaning is Request for Inspection only.
- MQR is seeded as “Material Quality Report” with response codes and review enabled, while the approved meaning is Monthly Quality Report with an independent review cycle and no default A/B/C/D/E/I response-code workflow.

These are source-seed discrepancies. This review does not establish which seed rows are currently deployed or whether later application-level configuration overrides them.

## Findings

### 1. Discipline seed data conflicts with the approved five-discipline taxonomy

The checked migration seeds:
- ARC — Architectural
- STR — Structural
- MEC — Mechanical
- ELE — Electrical
- CIV — Civil

The approved project taxonomy is:
- ARC — Architectural
- CIVSTR — Civil & Structural (one combined discipline)
- MEC — Mechanical
- ELE — Electrical
- SUR — Survey

The checked seed therefore preserves the superseded separate STR and CIV entries and does not include SUR. It also uses no combined CIVSTR code.

**Impact:** A fresh database initialized from this seed may expose an obsolete discipline taxonomy, causing inconsistent discipline selection, reporting, document numbering, and data interpretation relative to the approved project model.

### 2. RFI seed retains a superseded dual meaning

The checked seed defines RFI as:
- English: `Request for Inspection / Information`
- Arabic: `طلب فحص / استفسار`
- Category: `inspection`

The approved definition is Request for Inspection only. It must not represent a Request for Information workflow or combine two document purposes.

**Impact:** The seeded label can mislead users, encourage RFI to be used as a general information request, and blur the strict separation between document types and their workflows.

### 3. MQR seed conflicts with the approved Monthly Quality Report workflow

The checked seed defines MQR as:
- English: `Material Quality Report`
- Arabic: `تقرير جودة المواد`
- `uses_response_codes = true`
- `requires_review = true`

The approved definition is Monthly Quality Report. Its review cycle is independent and must not default to the ordinary A/B/C/D/E/I response-code model.

**Impact:** A newly seeded environment may label MQR incorrectly and route it through response-code behavior that was explicitly not approved for this report type. The independent workflow requirement cannot be considered satisfied merely because the generic `requires_review` flag is true.

## Evidence location

In `drizzle/migrations/0000_core_schema.sql`, inspect the final seed statements:
- `insert into public.disciplines ... values`
- `insert into public.document_types ... values`

The discrepancies are directly visible in those seed rows. The migration also declares generic `uses_response_codes` and `requires_review` fields on document types; those flags do not, by themselves, implement an independent MQR review lifecycle.

## Recommended remediation for a separately approved change

1. Align the discipline seed with ARC, CIVSTR, MEC, ELE, and SUR. Treat separate STR/CIV definitions as superseded for new operational configuration; do not delete historical records or rewrite existing documents merely to normalize labels.
2. Change the RFI reference definition to Request for Inspection only in English and Arabic. Keep any future Request for Information as a separately specified document type and workflow, subject to explicit product approval.
3. Correct MQR to Monthly Quality Report in both languages and implement its own review lifecycle without default response-code semantics. Do not simply rename the seed row while leaving generic transition behavior unchanged.
4. Review document-type metadata, UI labels, numbering, KPI classification, imports, and workflow configuration together so that the corrected reference data is used consistently.
5. Add tests that assert the approved discipline codes, RFI meaning, MQR label, and MQR response-code/workflow behavior on a clean database initialization.
6. Before any migration, obtain an independent backup, demonstrate a successful restore, review the exact migration, and obtain explicit approval.

## Scope and limitations

- Static inspection of `drizzle/migrations/0000_core_schema.sql` on `dev/review-fixes`.
- Comparison against the explicit domain decisions approved for this project.
- No live database, deployed seed state, existing reference rows, UI runtime, imports, KPI output, or document numbering behavior was queried or executed.
- No application tests, lint, or build were run.
- No source files, migrations, generated files, database objects, or project settings were changed.
- This report records discrepancies and recommendations only; it does not authorize remediation, data conversion, or deployment.

## Conclusion

The checked seed data is not aligned with the approved operational vocabulary for disciplines, RFI, and MQR. These are material domain-definition discrepancies that should be corrected together in a controlled, tested migration and corresponding application workflow implementation, after the required backup/restore gate and explicit approval.
