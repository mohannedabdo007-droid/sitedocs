# 57 — SECURITY DEFINER RPC execute privileges and authorization review

**Branch:** `dev/review-fixes`  
**Review type:** Static SQL migration review only  
**Scope:** Functions in `0001_triggers_and_rpcs.sql`, SECURITY DEFINER declarations, internal authorization checks, and explicit EXECUTE ACL statements  
**Outcome:** The business-facing RPCs inspected contain meaningful in-function authorization checks. However, the migration explicitly revokes EXECUTE from `anon` only for selected RPCs and does not explicitly revoke EXECUTE from `PUBLIC` or establish a complete authenticated-only grant list. PostgreSQL's default function EXECUTE privileges and any external default-privilege configuration therefore need verification against the live database before exposure can be certified.

## Executive summary

The migration uses SECURITY DEFINER for several privileged operations, including company/project creation, project membership management, document workflow transitions, and import commits. The checked implementations generally perform an authorization check using the authenticated identity and project/company role helpers before changing data.

The ACL section at the end of the migration revokes EXECUTE from `anon` on six named functions. It does not show corresponding revokes from `PUBLIC`, nor explicit grants to `authenticated` for those RPCs. PostgreSQL commonly grants EXECUTE on newly created functions to PUBLIC by default unless database default privileges have been changed. A revoke from the `anon` role alone does not remove a grant inherited through PUBLIC. The checked migration alone therefore cannot prove that these functions are inaccessible to anonymous callers.

This is a privilege-hardening and verification gap, not proof that anonymous execution is possible in the deployed database: project-level default privileges, later migrations, dashboard changes, or deployment tooling may alter the effective ACL.

## Function and authorization observations

### 1. Company and project creation

- `create_company(...)` is SECURITY DEFINER and rejects calls where `auth.uid()` is null. It creates the company and assigns the caller as owner.
- `create_project(...)` is SECURITY DEFINER and checks `is_company_admin(_company)` before creating a project, membership, response-code defaults, and workflow defaults.
- These checks are positive authorization controls in the function body. They do not remove the need for a least-privilege EXECUTE ACL.

### 2. Project membership management

- `add_project_member(...)` is SECURITY DEFINER and checks `can_manage_project(_project)` before looking up the target user and upserting membership.
- The membership scope trigger derives company scope from the project.
- The function's role and party inputs are accepted after the project-admin check; confirm the allowed role/party combinations and any company-level restrictions in the live workflow contract before treating this RPC as fully constrained.

### 3. Workflow transition RPC

- `transition_document(...)` is SECURITY DEFINER and locks the target document row.
- It derives the caller's project role and party, rejects missing/viewer roles, and applies action-specific checks for submit, start_review, respond/return, and close.
- Submission restricts non-admin callers to the workflow's originating party. Review actions restrict non-admin callers to the current workflow party. Response codes are checked against active project response codes where enabled.
- The code includes an admin exception for some party checks. This should be compared with the approved separation-of-duties rules and tested explicitly; the existence of a function-level admin exception should not be interpreted as blanket permission for a project manager to act on behalf of another party.
- The function inserts workflow history and updates document/revision state through the controlled transition path.

### 4. Import commit RPC

- `commit_import_rows(...)` is SECURITY DEFINER and checks `can_edit_documents(b.project_id)` after loading and locking the batch.
- It limits the processing chunk, checks batch status/type, and records row-level outcomes.
- Its privileged execution should be limited to the intended authenticated import workflow and must not be assumed safe solely because the function body contains an authorization check.

### 5. Read/helper functions

- `preview_document_number(...)` is SECURITY DEFINER and checks project membership.
- `document_kpi_matrix(...)` and `existing_revisions_for_numbers(...)` are SECURITY INVOKER, so the caller's ordinary privileges/RLS apply.
- `resolve_numbering_scheme(...)` is explicitly revoked from PUBLIC, anon, and authenticated in the checked migration, which is a useful example of explicit hardening for an internal helper.
- Several role/party helper functions are SECURITY DEFINER. Their effective EXECUTE ACLs and intended exposure should be verified alongside the business RPCs.

## ACL finding

The migration's final ACL statements revoke EXECUTE from `anon` for:

- `create_company(text, text, text)`
- `create_project(uuid, text, text, project_party, text, text, text)`
- `add_project_member(uuid, text, project_party, project_role, text)`
- `transition_document(uuid, text, text, text)`
- `commit_import_rows(uuid, int)`
- `preview_document_number(uuid, uuid, uuid)`

The migration does **not** show `REVOKE EXECUTE ... FROM PUBLIC` for these functions, nor an explicit subsequent `GRANT EXECUTE ... TO authenticated`. PostgreSQL function EXECUTE defaults and database-level default privileges determine the effective result. Revoking from `anon` alone is not sufficient if `PUBLIC` still has EXECUTE, because anon inherits privileges granted to PUBLIC.

The migration does not include a complete ACL inventory for every SECURITY DEFINER helper/trigger function. Trigger invocation and direct RPC invocation are different exposure paths; each function should be classified and its effective ACL reviewed accordingly.

## Findings and risk

| ID | Finding | Risk |
|---|---|---|
| RPC-57-01 | Selected RPCs revoke EXECUTE from anon but do not explicitly revoke from PUBLIC in this migration. | High pending live ACL verification — a PUBLIC grant could leave the function executable by anon despite the role-specific revoke. |
| RPC-57-02 | No explicit authenticated-only EXECUTE grants are shown for the selected business RPCs. | Medium — intended caller scope is not self-documenting or migration-enforced in this snapshot. |
| RPC-57-03 | The migration does not provide a complete ACL inventory for all SECURITY DEFINER functions. | Medium — helper functions may have broader direct invocation rights than intended. |
| RPC-57-04 | SECURITY DEFINER RPCs contain authorization checks, but admin exceptions and accepted role/party combinations need focused negative tests against approved separation-of-duties rules. | Medium — policy correctness depends on both ACL and function-body behavior. |
| RPC-57-05 | The effective default privileges and deployed ACLs are not available in the static source snapshot. | Verification gap — no conclusion about the live project's actual anonymous execution rights can be made from this migration alone. |

## Recommended controls before implementation

1. **Inventory effective function ACLs in the target database.** Query `pg_proc`, `pg_namespace`, `proacl`, and `aclexplode()` for every function in `public`, including inherited PUBLIC grants and the effective privileges of anon/authenticated/service_role.
2. **Set explicit least-privilege ACLs.** For each client-callable RPC, revoke EXECUTE from PUBLIC and anon, then grant EXECUTE only to the intended role(s). Keep trigger-only/internal functions non-callable by client roles unless a documented use case requires otherwise.
3. **Harden default privileges.** Review the function default privileges for the actual migration owner and ensure future functions do not silently become PUBLIC-executable.
4. **Preserve function-body authorization.** ACL hardening is not a substitute for checking auth.uid(), project membership, company ownership, party, role, document state, and action-specific conditions inside SECURITY DEFINER RPCs.
5. **Review admin exceptions.** Explicitly test whether project admins may perform actions reserved for another workflow party and whether this is consistent with the approved manager read-only / no proxy approval rule.
6. **Verify SECURITY DEFINER safety.** Confirm fixed search_path, schema-qualified object references, controlled ownership, no unsafe dynamic SQL, and no unintended ability to alter caller-controlled session flags.
7. **Apply changes only through a reviewed migration.** First take an independent backup, complete a restore test, inspect the live ACLs, prepare one narrowly scoped migration, and obtain explicit approval before execution.

## Validation plan (not executed)

- Query effective ACLs for all SECURITY DEFINER functions, distinguishing explicit grants from PUBLIC/default privileges.
- Test anonymous, authenticated non-member, viewer, contributor/controller, reviewer, project admin, company admin, and service-role invocation paths.
- Confirm anonymous callers cannot execute any business RPC or privileged helper unless intentionally public.
- Confirm authenticated callers can execute only the intended client-facing RPCs.
- Test negative cases: cross-company project IDs, non-member document IDs, invalid workflow party, creator self-approval, project-admin proxy response, invalid response code, and unauthorized import batch.
- Verify that trigger functions continue to run through table operations after direct EXECUTE is revoked from client roles.
- Re-run the ACL inventory after deployment and retain it as release evidence.

## Scope limitations

- Static inspection of `dev/review-fixes`, principally `0001_triggers_and_rpcs.sql`.
- No live PostgreSQL/Supabase ACLs, role memberships, database default privileges, or deployed function owners were queried.
- No function was invoked; no runtime tests, migration execution, build, or lint was run.
- No source code, SQL, migration, database record, or project setting was changed.
- This report is documentation only and does not authorize an ACL migration.
