# 39 — Comment, Review-History, and Parent-Document Visibility Review

**Status:** Static migration review only  
**Branch:** `dev/review-fixes`  
**Scope:** `drizzle/migrations/0000_core_schema.sql`, `0001_triggers_and_rpcs.sql`, and `0002_storage_policies.sql`.  
**Not performed:** No live database/catalog access, authenticated session test, SQL execution, application UI test, source edit, migration, or deployment.

## Executive summary

The schema separates comments from workflow review history and gives comments an `internal/external` visibility attribute. However, the visible row-level policies do not consistently inherit the visibility decision for the parent document. In particular, review-history rows are readable by any project member, while comment visibility is evaluated by comment visibility and author party without a visible check of the parent document's lifecycle visibility.

This creates a potential side-channel around the approved rule that drafts remain visible only to their originator party and the read-only Project Manager. The exact live exposure depends on deployed policies, membership data, and application query paths; none were runtime-tested.

## Findings

### F39-01 — Workflow review history is project-member readable without parent-document visibility filtering
**Priority: Critical — confidentiality boundary**

The visible policy for `document_reviews` is `is_project_member(project_id)`. It does not visibly join or test the parent document's lifecycle/party visibility. The table contains document and revision IDs, workflow action, from/to status, response code, notes, actor, party, and timestamps.

**Risk:** A project member who cannot read a draft document under the approved draft-confidentiality rule may still be able to query its workflow history directly, learning that the document exists, its review activity, response details, actors, and notes.

**Required action:** Make review-history SELECT authorization inherit the same parent-document visibility predicate as the document itself, with any explicitly approved PM read-only exception. Avoid relying solely on hiding the review-history UI.

### F39-02 — Internal comments are party-scoped, not parent-document-scoped
**Priority: Critical — draft confidentiality**

The visible comments SELECT policy allows a project member to read a comment when it is external, or when its `author_party` equals the reader's current project party. The policy does not visibly require that the reader can see the parent document under its current lifecycle visibility rules.

**Risk:** Internal comments attached to a draft may be visible to other members of the same party even when they are not the document originator or an authorized PM. External comments attached to a draft may be visible to all project members under this policy. Both cases can bypass draft confidentiality through the child table.

**Required action:** Require parent-document visibility first, then apply comment visibility as an additional restriction. An `external` comment must not make an otherwise hidden draft visible. Define how comment visibility behaves after submission, return, cancellation, closure, and archive in line with the approved lifecycle policy.

### F39-03 — Comment insertion is project-contributor scoped, not visibly document-state scoped
**Priority: High — workflow integrity**

The comments INSERT policy checks `can_comment(project_id)`, `author_id = auth.uid()`, and `author_party = project_party_of(project_id)`. The insert trigger derives the author and party and checks that the document and optional revision exist and that the revision belongs to the document. The visible policy/trigger does not additionally check whether the parent document is a draft hidden from that user, whether the document is in a state that accepts comments, or whether the user's party is currently permitted to comment at that workflow step.

**Risk:** Project-level contribution authority may be broader than document-level communication authority. A user may be able to add comments to documents or lifecycle stages where the business process should restrict discussion.

**Required action:** Define comment permissions by document visibility, lifecycle, party, and any document-type exception. Enforce the rule in the database, not only in UI controls. Preserve the distinction between internal and external comments.

### F39-04 — Workflow history records the action and actor, but not a durable policy/configuration snapshot
**Priority: Medium — audit interpretability**

The review-history row stores step, party, action, from/to status, response code, notes, actor, and timestamp. The visible structure does not capture the workflow-step configuration version or the response-code configuration/outcome as they stood at the time of the action.

**Risk:** If a project later changes workflow steps or response-code configuration, historical rows may be difficult to interpret against the rules that were active when the action occurred. This matters for audits and disputes.

**Required action:** Consider recording immutable workflow/configuration version identifiers or a minimal decision snapshot at transition time. Do not duplicate unnecessary personal or sensitive data; define retention and correction rules first.

### F39-05 — Review-history and comment parent references need consistent referential guarantees
**Priority: Medium — referential integrity**

Both tables reference the document, and each may reference a revision. The visible migration uses separate foreign keys for `document_id` and `revision_id`; the comment/revision insertion trigger checks same-document ownership for newly inserted comments. The review-history INSERT is performed inside the workflow RPC using the document's current revision, which is a sound controlled path, but the schema itself does not visibly enforce a composite same-document relationship for every privileged write path.

**Risk:** Future privileged paths, data repair, or imports could create child records whose revision belongs to another document unless every path repeats the check.

**Required action:** Prefer database-enforced composite referential integrity for (document_id, revision_id), or a consistent trigger constraint for both tables. Validate existing data before adding constraints.

## Positive controls observed

- Comments distinguish `internal` and `external` visibility.
- Comment body length is constrained to 1–5000 characters.
- The comment insert trigger derives project/company scope and author identity from the parent document and authenticated user.
- The comment insert trigger checks that an optional revision belongs to the same document.
- Authenticated users receive SELECT (not direct INSERT/UPDATE/DELETE) on `document_reviews`; workflow history insertion is performed by the transition RPC in the visible migration.
- The audit trigger explicitly excludes comment body from the shared audit log.

## Acceptance tests required (not executed)

1. A non-originating party project member queries a draft's document, comments, and review history directly; all three must enforce the same draft visibility boundary.
2. A same-party user other than the draft creator queries internal comments; access must follow the approved originator/PM draft rule, not party membership alone.
3. A different-party member queries external comments on a hidden draft; the comment must not reveal the hidden parent document.
4. A Project Manager reads draft, comments, and review history but cannot insert comments or change workflow decisions unless separately authorized.
5. After formal submission, verify the approved party visibility for document, comments, and history.
6. After return, cancellation, closure, and archive, test each state against the policy decisions that remain open in report 24.
7. Attempt comment insertion from a party not authorized at the current workflow step and in a lifecycle state where comments are disallowed.
8. Attempt to associate a comment or review-history row with a revision belonging to another document.
9. Verify that changing a workflow or response-code configuration does not rewrite the interpretation of historical review events.

## Dependencies and unresolved policy

- Report 24 still marks post-draft lifecycle visibility, MQR-specific workflow, and close/cancellation details as decisions requiring explicit approval.
- This report does not invent those policies. It recommends one shared parent-document visibility predicate and treats comment visibility as an additional restriction.
- The Project Manager's approved read-only access must apply consistently to document, comment, and review-history reads without granting write or workflow authority.

## Required boundaries

- No source, SQL, migration, schema, or database object was changed.
- No live database was queried; no row-level security test or Storage test was run.
- No tests, build, lint, or deployment were executed.
- This is a static review, not a security certification.

## Conclusion

Comments and workflow history must not become alternate paths around document confidentiality. The next implementation design should centralize parent-document visibility and reuse it consistently across documents, revisions, comments, review history, attachments, and audit views. The precise lifecycle rules beyond drafts must follow the user's approved policy decisions rather than being guessed in code.
