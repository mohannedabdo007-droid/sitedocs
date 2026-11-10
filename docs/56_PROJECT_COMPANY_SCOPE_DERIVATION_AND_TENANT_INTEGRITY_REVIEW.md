# 56 — Project/company scope derivation and tenant-integrity review

**Branch:** `dev/review-fixes`  
**Review type:** Static migration and trigger review only  
**Scope:** Project/company ownership, project membership, document/revision/review/attachment/comment scope fields, scope-derivation triggers, grants, and RLS predicates  
**Outcome:** The checked migrations consistently derive company scope from the parent project or document on several INSERT paths. This is a useful defence against client-supplied tenant IDs. However, the triggers are not uniformly defined for all mutable scope fields, and the schema generally stores project/company IDs as separate foreign keys rather than enforcing their relationship with composite constraints.

## Executive summary

The source contains a deliberate tenant-scope pattern: project-scoped child records derive `company_id` from the parent project, while documents derive `company_id` from the selected project. Attachments and comments similarly derive project/company scope from the parent document. Revision insertion also derives scope from its parent document. This reduces reliance on client-supplied company IDs.

The important limitation is the trigger event coverage. The shared project-scope trigger is attached to INSERT and UPDATE OF `project_id`, not UPDATE OF `company_id`. The attachment/comment scope triggers are INSERT-only. The revision scope trigger is also INSERT-only. In addition, the foreign keys independently validate that project and company IDs exist; they do not generally prove that the two IDs describe the same tenant relationship. Authenticated grants and RLS constrain many ordinary write paths, but the service role has broad privileges and the static schema does not establish equivalent invariants for every privileged update path.

This is a schema-integrity review, not evidence of an observed cross-tenant exploit or live data corruption.

## Evidence

### 1. Project and membership model

`public.projects` has a non-null `company_id` foreign key to `public.companies`. `public.project_members` stores both `project_id` and `company_id` as separate foreign keys, plus user, party, and role.

The migration grants authenticated SELECT, INSERT, UPDATE, and DELETE on `project_members`, with RLS policies restricting insert/update/delete to project managers (and preventing an admin from deleting their own membership through the shown delete predicate).

The trigger function `set_scope_from_project()` selects the parent project's `company_id` into the child row and rejects a missing project. It is attached to project_members, project_response_codes, project_workflows, numbering_schemes, and import_batches on INSERT or UPDATE OF `project_id`.

That trigger correctly overrides a supplied company ID when it fires. But an UPDATE that changes only `company_id` does not match the declared UPDATE OF `project_id` event. The separate company foreign key only checks existence, not equality with the project's company. The checked RLS policy predicates authorize by `project_id`; they do not themselves encode the company equality invariant.

### 2. Document scope

`documents_before_insert()` loads the project row and assigns `new.company_id := proj.company_id`. Thus ordinary document creation does not trust the client-provided company ID. The document table also stores `project_id` and `company_id` as separate references.

The checked document UPDATE guard protects project/company identity fields from ordinary updates unless the transaction-local workflow transition flag is set. That is a useful protection for the document row. The checked review and document RLS policies are project-based.

### 3. Revision scope

`revisions_before_insert()` locks and loads the parent document, then derives the revision's project/company IDs from that document. The revision table's project/company references are otherwise separate foreign keys. Authenticated users receive SELECT and INSERT, not UPDATE/DELETE; service_role receives ALL.

The trigger is a BEFORE INSERT trigger. The checked migration does not attach a scope-derivation trigger to revision UPDATE. No authenticated UPDATE grant is shown, but privileged maintenance paths remain a separate trust boundary.

### 4. Attachment and comment scope

The `set_scope_from_document()` trigger derives `project_id` and `company_id` from the parent document and checks that a supplied revision belongs to the same document. It is attached to attachments on BEFORE INSERT only.

The `comments_before_insert()` trigger performs the same scope derivation and revision/document pairing check, then derives author identity and party. It is attached to comments on BEFORE INSERT only.

The attachment and comment schemas store document, project, and company references independently. Their foreign keys do not form a composite constraint proving that all three values refer to the same tenant/document hierarchy. The INSERT triggers provide the intended consistency for the covered path, but are not a substitute for declarative constraints or UPDATE validation on privileged paths.

### 5. RLS and grants

The checked RLS policies for documents, revisions, reviews, attachments, and comments use project membership/party predicates. The project-membership management policies use `can_manage_project(project_id)`. The policies generally do not include an additional `company_id = project.company_id` predicate.

This does not automatically mean those policies are bypassable: the INSERT triggers normalize scope on the covered tables, and the project-based authorization functions are the primary access boundary. It does mean the database's tenant relationship is partly maintained by procedural triggers rather than consistently encoded in relational constraints.

## Findings and risk

| ID | Finding | Risk |
|---|---|---|
| TEN-56-01 | Shared project-scope triggers fire on INSERT or UPDATE OF project_id, but not a company_id-only update. | Medium — privileged or future update paths could create a child row whose company_id disagrees with its project. |
| TEN-56-02 | Attachment and comment scope triggers are INSERT-only; their project/company/document references are separate foreign keys. | Medium — privileged updates or future write paths could break the tenant/document relationship after insertion. |
| TEN-56-03 | Revision scope is derived on INSERT, while no equivalent UPDATE trigger is defined in the checked migration. | Medium — privileged updates are not covered by the same normalization rule. |
| TEN-56-04 | Multiple related tables rely on project-based RLS plus trigger-derived company scope rather than composite tenant-consistency constraints. | Medium — defence in depth is weaker than it could be if a privileged or alternate write path bypasses the expected trigger sequence. |
| TEN-56-05 | Document identity fields have a dedicated update guard, but equivalent uniform guards were not identified for every related child table. | Medium — integrity protections differ by entity and operation. |

## Recommended controls before implementation

1. **Make tenant identity declarative where possible.** Add suitable unique parent keys and composite foreign keys so child `(project_id, company_id)` pairs must match the owning project, and document-linked children must match the owning document's project/company pair.
2. **Cover all mutation events.** For child rows with denormalized scope, derive or validate scope on INSERT and UPDATE of the parent identifier or tenant identifier. Do not silently accept company-only changes.
3. **Keep parent-child identity constraints complete.** For attachments, comments, revisions, and workflow history, enforce that revision/document/project/company references form one consistent chain.
4. **Restrict service-role writes.** Inventory all server-side callers, keep service credentials off clients, and require explicit authorization, actor attribution, and audit correlation for maintenance operations.
5. **Preserve project-based RLS as the access boundary.** Add consistency checks as defence in depth, not as a replacement for the approved party/role rules. Avoid granting access merely because a company ID matches.
6. **Test tenant boundary cases.** Attempt mismatched company/project pairs, cross-company parent references, company-only updates, project reassignment, attachment/comment revision mismatch, and service-role writes in an isolated restored environment.
7. **Audit existing data before adding constraints.** Produce read-only mismatch reports for each affected table, reconcile legitimate exceptions, back up and restore-test, then propose one reviewed migration at a time for explicit approval.

## Validation plan (not executed)

- Create two test companies and projects, then attempt to create child rows using a company ID from the other tenant.
- Verify each INSERT trigger replaces client-supplied scope with the canonical parent scope.
- Attempt UPDATE of only `company_id` for project_members, response_codes, workflows, numbering_schemes, import_batches, attachments, comments, and revisions under authenticated and service-role contexts.
- Attempt changing parent IDs and confirm all dependent scope fields remain consistent or the operation is rejected.
- Test document/revision/attachment/comment references across two projects and companies.
- Run read-only consistency queries against a restored copy before any proposed constraint migration.
- Verify RLS independently for members, non-members, company admins, project admins, and service-role processes.

## Scope limitations

- Static inspection of `dev/review-fixes`, principally `0000_core_schema.sql` and `0001_triggers_and_rpcs.sql`.
- No live Supabase database, deployed policies, production tenant data, or service-role process was queried.
- No runtime tests, migration execution, build, lint, or end-to-end test was run.
- No source code, SQL, migration, database record, or project setting was changed.
- This report is documentation only; it does not authorize a migration or tenant-data repair.
