# 59 - Document workflow separation of duties and administrative transition bypass review

- Repository: `mohannedabdo007-droid/sitedocs`
- Branch: `dev/review-fixes`
- Review type: static migration review only
- Reviewed snapshot:
  - `drizzle/migrations/0000_core_schema.sql`
  - `drizzle/migrations/0001_triggers_and_rpcs.sql`
- Source blob SHAs:
  - `0000_core_schema.sql`: `6eeac6f0ddb29d77e0ab1320ac143bab6f834c47`
  - `0001_triggers_and_rpcs.sql`: `667f793732f8841c4d8394721eb3128e04181c7f`

## Executive summary

The database workflow RPC centralizes document lifecycle changes and checks project membership, role, current workflow party, allowed source states, and response-code validity. However, the inspected `transition_document` implementation explicitly exempts the project role `admin` from party matching in submission, review-start, response, and return paths. The function also does not compare the acting user with the document creator before allowing a review response.

These are material separation-of-duties gaps against the approved project rule: workflow actions must be performed by the authorized workflow party; an administrative or supervisory role must not automatically inherit another party's review/approval authority; and a creator must not approve their own document. The code evidence establishes the bypass conditions in the migration, but does not establish whether a deployed user can exploit them in a particular live project. Effective role assignment, RPC ACLs, application routing, and deployed database state were not queried.

No source, migration, database, permission, or deployment changes were made.

## Scope and method

Static inspection of the two named migration files on `dev/review-fixes`, focusing on:
- project role and party derivation;
- `transition_document` action branches;
- document creator identity and workflow party fields;
- review-history schema and recorded actor/party values.

This is not a live database assessment. No SQL was executed against Supabase. No tests, lint, build, browser workflow, or authenticated role simulation was run.

## Findings

### F59-01 - Project admin bypasses workflow-party authorization

**Evidence**

In `transition_document`, the submit branch checks that a non-admin actor belongs to the configured originator party, but the condition expressly skips this check when `r = 'admin'`:

```sql
if r <> 'admin' and p is distinct from d.workflow_steps[1] then
  raise exception 'FORBIDDEN: only the originating party submits';
end if;
```

The `start_review` branch and the `respond/return` branch similarly enforce current-party matching only when `r <> 'admin'`:

```sql
if r <> 'admin' and p is distinct from cur then
  raise exception 'FORBIDDEN: not the reviewing party';
end if;
```

**Assessment**

A project admin can pass these party checks without being a member of the configured workflow party for the current step. The function still requires a project role and validates lifecycle state, but those checks do not restore the party separation that the explicit exception bypasses.

This conflicts with the approved rule that workflow-party authority is distinct from general project administration. The project manager's read/supervisory access must not become authority to submit, review, respond, or approve on behalf of a party.

**Risk**

Potential unauthorized cross-party workflow action, including response or approval, if a project admin invokes the RPC while not assigned to the current workflow party. The live reachability and actual role assignments remain unverified.

**Required design direction**

Remove implicit admin substitution for workflow-party membership. If a separately authorized override is ever required, model it as a narrow, explicit, auditable action with its own permission, reason, and policy—not as a blanket bypass of party matching. Preserve the rule that administrative visibility does not grant review or approval authority.

### F59-02 - No creator-versus-reviewer self-approval guard in the transition RPC

**Evidence**

The function loads the document row and derives the actor's project role and party. In the `respond/return` branch it validates the current workflow party (subject to the admin bypass above), response code, and notes for a return. It does not compare `auth.uid()` with `d.created_by` before writing the response and updating the current revision's `response_by`.

The document schema contains `created_by`; the revision response records `response_by`; and `document_reviews.actor_id` records the actor. The inspected transition function does not use these identity fields to reject a creator's own approval.

**Assessment**

No database-level self-approval guard is visible in the inspected transition path. If a user who created a document is also able to act as the current reviewing party—or uses the admin bypass—the function contains no explicit creator/actor separation check to prevent that user from responding or approving the same document.

This is a control gap in the reviewed migration, not proof that a live user has already self-approved a document. Other application-layer restrictions were not comprehensively established in this static pass and must not be treated as a substitute for a database-side invariant.

**Required design direction**

Enforce creator/reviewer separation in the authoritative workflow RPC, based on the authenticated actor and immutable document creator identity. Apply it to every action that can record a review outcome, including response-code outcomes that produce `approved` or `closed`. Define and test the intended behavior for subsequent revisions and delegated roles.

### F59-03 - Review history records the actor's project party, which may not represent an administrative override

**Evidence**

At the beginning of the function, `p` is set from `project_party_of(d.project_id)`. The review-history insert records `party = p` and `actor_id = auth.uid()`. For a company-level administrator whose project party is null, the schema permits `document_reviews.party` to be null.

**Assessment**

Where the admin bypass is used by a user with no project-party assignment, the history row can identify the actor while leaving the party null. This is not sufficient by itself to identify which workflow party the actor was acting for, or whether the action was a legitimate override. It weakens audit interpretation of cross-party actions.

**Required design direction**

Do not silently represent an administrative override as an ordinary workflow-party action. If explicit overrides are authorized in future, record the actor's actual role, the intended workflow party/step, the override permission, and a mandatory reason in a structured audit record. Otherwise reject the action.

## Approved project rules checked

- Workflow actions are restricted to the party authorized for the current step.
- A document creator cannot approve their own document.
- Project Manager read/supervisory access does not grant authority to edit, review, or approve on behalf of another party.
- Company/project administration is not a blanket substitute for workflow-party authorization.
- RFI remains Request for Inspection only; RFI/WIR separation is not changed by this review.
- MQR has its own review workflow and must not inherit generic response-code behavior by assumption.

## Recommended verification before any remediation

1. Enumerate live project roles and party assignments, including company admins who have no project-party assignment.
2. Inspect the effective deployed function definition and grants; do not infer them from migration text alone.
3. In an isolated restored test database, exercise each transition as:
   - originator party controller;
   - current reviewing party reviewer/controller;
   - non-current party member;
   - project admin assigned to a different party;
   - company admin with no project-party assignment;
   - document creator attempting to respond to/approve their own document;
   - a different authorized reviewer attempting the same action.
4. Verify that unauthorized attempts fail atomically and do not change document status, revision response fields, or review history.
5. Verify that approved MQR workflow behavior remains independent and that no generic response-code path is applied to it by accident.

## Limitations

- Findings are based only on the named migration snapshot and the exact function body reviewed.
- No live Supabase schema, deployed function body, effective ACL, user membership, or audit history was queried.
- No runtime exploit or successful unauthorized transition was demonstrated.
- No source changes, SQL changes, migrations, policy changes, tests, lint, build, merge, or deployment were performed.
- Remediation must be implemented by the source owner (Lovable) after backup and successful restore testing, with a separately reviewed migration and explicit approval. No database change is authorized by this report.

## Conclusion

The central workflow RPC has useful state and role checks, but the explicit project-admin party bypass and missing creator-versus-reviewer check are inconsistent with the approved separation-of-duties model. Treat these as high-priority design findings requiring controlled remediation and isolated role-matrix tests before any production migration.
