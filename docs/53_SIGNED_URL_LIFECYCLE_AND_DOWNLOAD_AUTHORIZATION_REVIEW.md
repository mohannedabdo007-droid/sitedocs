# 53 — Signed URL Lifecycle, Revocation, and Download Authorization Review

**Repository:** `mohannedabdo007-droid/sitedocs`  
**Branch reviewed:** `dev/review-fixes`  
**Review type:** Static review of checked application source and SQL migrations  
**Priority:** High — authorization lifecycle must be verified before document-file workflows are considered secure  
**Status:** Findings documented only. No code, storage objects, database, bucket configuration, or permissions changed.

## Executive summary

The checked repository snapshot contains a project-membership-based Storage SELECT policy (reviewed in Report 52), but the inspected application source does not expose a complete signed-URL issuance, download, expiry, or revocation workflow that can be audited end-to-end.

This review therefore does **not** claim that signed URLs are currently generated insecurely. Instead, it records two verified design facts and a material verification gap:

1. Authenticated project members can read objects directly under the project-prefix Storage policy without resolving the object to an attachment/document visibility decision.
2. The checked source files do not establish who issues signed URLs, their lifetime, whether the application re-authorizes before issuance, or how access behaves after a role/status change.

A signed URL is a bearer capability: once issued, possession of the URL may be sufficient until its expiry or until the storage provider otherwise invalidates it. Removing a user's project membership or changing a document's status should not be assumed to revoke a previously issued URL.

## Evidence

### E53-01 — Direct Storage read path is independent of signed URL issuance

Migration `drizzle/migrations/0002_storage_policies.sql` grants authenticated SELECT on objects in `document-files` when `public.storage_project_id(name)` resolves to a project for which `public.is_project_member(project_id)` is true.

This policy does not require an attachment row or apply the document draft-visibility rule. Therefore, signed URLs are not the only access path that must be secured: direct authenticated Storage downloads also need the correct authorization boundary.

### E53-02 — No auditable signed-URL lifecycle found in inspected application source

The checked source tree includes the Supabase client integration and a small initial route structure. The inspected `src/integrations/supabase/client.ts` initializes the Supabase client and auth storage, but does not itself implement a document-file download or signed-URL authorization service.

The checked `src/routes` listing contains the root, index, and route README files; the checked `src/lib` listing contains domain, error, import, KPI, numbering, and utility modules. No signed-URL issuance/refresh/revocation path was established in those inspected files.

This is a repository-snapshot observation, not proof that no such functionality exists in an external service, an uninspected generated module, or a later deployed build.

### E53-03 — Revocation semantics are not defined by the checked migration

The checked Storage migration defines project-prefix read and upload policies, but does not define a signed-URL issuance procedure, maximum URL lifetime, revocation list, or authorization re-check endpoint.

No conclusion can be drawn from these migrations alone about provider-level behavior for already issued signed URLs.

## Security implications

- If a signed URL is issued to a user, later removal of project membership or a change from submitted to draft/returned does not automatically prove that the URL becomes unusable.
- If a URL has a long lifetime, the exposure window may continue after the underlying user's permissions change.
- If direct authenticated object reads remain available under the broad project-membership policy, fixing signed-URL issuance alone will not close the access path.
- URLs copied into comments, logs, browser history, analytics, or support tickets may be usable by anyone who obtains them until they expire or are otherwise invalidated.
- This report does not establish that signed URLs are currently used, leaked, long-lived, or publicly accessible.

## Required design and implementation controls

Before enabling or approving file-download workflows:

1. Resolve every requested object to its canonical attachment row and document.
2. Re-evaluate current user authorization at the moment a signed URL is issued, including party, document status, project, company, and the approved draft exception for creator/Project Manager.
3. Use short, explicitly configured URL lifetimes based on the sensitivity and operational need; document the selected duration.
4. Do not treat signed URL possession as an authorization identity or place signed URLs in audit payloads, analytics, or ordinary application logs.
5. Define the expected behavior after role removal, document status changes, attachment deactivation, and document deletion. If immediate revocation is required, use an architecture that can enforce it rather than relying only on URL expiry.
6. Keep direct authenticated Storage access aligned with the same attachment/document visibility check; signed URLs must not become a workaround for a stricter RLS policy.
7. Log issuance metadata (actor, attachment/document identifiers, issue time, expiry, purpose) without logging the bearer token itself.
8. Ensure service-role code validates the caller's authorization before generating a URL; service-role access must not silently bypass the product's role matrix.

## Required verification tests

- Issue a short-lived URL to an authorized reader and confirm access before expiry.
- Remove the user's project membership after issuance; document whether the existing URL remains valid and ensure the behavior matches the approved revocation policy.
- Change a submitted document to a confidential draft/returned state after issuance; verify expected access behavior.
- Deactivate or delete the attachment and verify both direct Storage access and any previously issued URL behavior.
- Attempt URL issuance for an arbitrary object with no attachment row: deny.
- Attempt URL issuance for another project/company's object: deny.
- Attempt URL issuance for a draft by an ordinary project party: deny.
- Verify the draft creator and explicitly authorized read-only Project Manager exceptions independently.
- Confirm URLs are not written into audit logs, error telemetry, analytics, or support-visible logs.
- Verify direct authenticated Storage download and signed URL issuance separately; passing one path does not prove the other is secure.

## Limitations

- Static review only; no live Supabase Storage API, bucket configuration, signed URL, or deployed application was queried.
- No runtime token was generated or tested.
- The inspected source snapshot is small and does not establish the existence or absence of all external/server-side download paths.
- No expiry or revocation behavior was assumed beyond the need to test the actual provider behavior.
- No source, SQL, database, storage object, bucket setting, or permission was changed.

## Decision required

Keep signed-URL and download authorization as an explicit release gate. Before implementation, approve the role/visibility matrix, URL lifetime, and revocation expectations. Any database/storage policy change remains blocked pending an independent backup, successful restore rehearsal, and explicit approval of the specific change.
