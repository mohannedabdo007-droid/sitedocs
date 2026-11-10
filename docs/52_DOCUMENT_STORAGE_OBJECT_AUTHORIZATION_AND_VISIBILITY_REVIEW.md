# 52 — Document Storage Object Authorization and Attachment Visibility Review

**Repository:** `mohannedabdo007-droid/sitedocs`  
**Branch reviewed:** `dev/review-fixes`  
**Review type:** Static review of storage and attachment SQL policies  
**Priority:** High — storage authorization is broader than document-level visibility  
**Status:** Documentation only. No storage policy, application source, database, or bucket configuration was changed.

## Executive summary

The checked storage migration authorizes reading any object in the `document-files` bucket when the first path segment identifies a project of which the authenticated user is a member.

The policy does not visibly verify that the object:
- corresponds to a row in `public.attachments`;
- belongs to a document the user is allowed to see;
- is associated with a formally submitted document rather than a confidential draft;
- is an active, non-orphaned attachment.

This creates a separate storage access path that may bypass intended document and attachment visibility rules. It is project-scoped in the inspected predicate; this review does not establish cross-project access.

## Evidence

### E52-01 — Project-prefix extraction

Migration `drizzle/migrations/0002_storage_policies.sql` defines `public.storage_project_id(_name text)`. It extracts the first slash-delimited segment of the object name and returns it as a UUID only when it matches the UUID textual pattern. Otherwise it returns NULL.

The helper does not resolve the object path against a document or attachment record.

### E52-02 — Read policy checks membership only

The same migration defines:

```sql
create policy "document files: project members read"
on storage.objects for select to authenticated
using (
  bucket_id = 'document-files'
  and public.is_project_member(public.storage_project_id(name))
);
```

The predicate checks the bucket and project membership derived from the path. It does not join `storage.objects.name` to `public.attachments.storage_path`, nor check the linked document's status or any attachment visibility rule.

### E52-03 — Attachment records have their own RLS boundary

Migration `drizzle/migrations/0000_core_schema.sql` defines `public.attachments` with `document_id`, `project_id`, `company_id`, and unique `storage_path`. Its SELECT policy is project-member based, and its INSERT policy uses `public.can_comment(project_id)`.

The storage-object SELECT policy does not consult that attachment row. Consequently, hiding an attachment record at the application/query layer would not, by itself, prove that the underlying object is inaccessible through Storage.

### E52-04 — Upload policy and missing mutation policies in this migration

The checked migration defines object INSERT as:

```sql
create policy "document files: contributors upload"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'document-files'
  and public.can_comment(public.storage_project_id(name))
);
```

This allows the project roles accepted by `can_comment` to upload under a project-prefixed path. The checked migration contains no corresponding authenticated UPDATE or DELETE policy for this bucket. Other policies or service-role workflows were not established by this review.

## Impact and scope

- A project member may be able to read project-prefixed objects without proving that the object is a registered attachment or belongs to a document visible to that member.
- If draft files use the same bucket and project-prefix convention, this storage policy can undermine draft confidentiality even if document rows or UI lists are later restricted.
- Unregistered/orphaned objects under a valid project prefix may remain readable to project members.
- The inspected predicate derives the project from the first path segment; malformed or non-UUID prefixes resolve to NULL and do not satisfy the membership check.
- No evidence in this review demonstrates cross-project reads, public bucket access, or an exploitable signed-URL flow.

## Required design alignment

Before implementation, approve a storage authorization model that:

1. Resolves every object to a canonical attachment record and its document/project.
2. Applies the same draft visibility rule as the document row: creator and explicitly authorized read-only Project Manager may read drafts; other parties only after formal submission.
3. Rejects object reads when the attachment row is missing, inactive, or inconsistent with the object path.
4. Prevents path manipulation and verifies the object belongs to the same project/company recorded by the attachment and document.
5. Keeps upload authorization separate from read authorization; the ability to comment or upload must not imply permission to read every file in the project.
6. Defines explicit, audited deletion/retention and orphan-cleanup behavior without granting broad object mutation privileges.
7. Ensures privileged service-role or signed-URL flows enforce equivalent authorization before issuing access.

## Recommended verification tests

- Project member requests a registered attachment for a submitted document: allowed only according to approved party visibility.
- Other project party requests an attachment for a draft: denied.
- Draft creator requests their own draft attachment: allowed.
- Authorized Project Manager requests a draft attachment: allowed read-only; document edit/review actions remain separately denied unless authorized.
- Member requests an arbitrary object under a valid project UUID prefix with no attachment row: denied.
- Member requests an attachment whose path, project, company, or document linkage is inconsistent: denied.
- Member from project A requests an object under project B's prefix: denied.
- Verify malformed paths and encoded path segments cannot bypass the project/attachment resolution.
- Verify upload, replacement, deletion, and signed URL generation independently under each relevant role.

Tests must exercise direct authenticated Storage API requests, not only application UI behavior.

## Limitations

- Static review of committed migrations only; no live Supabase Storage policies or bucket settings were queried.
- The exact object path convention used by application upload/download code was not established from the source files inspected for this report.
- No runtime requests, signed URL flows, SQL tests, or bucket tests were executed.
- No storage objects, database records, source code, migrations, or permissions were changed.
- This report does not claim that the bucket is public or that cross-project access is possible.

## Decision required

Treat storage-object authorization as a high-priority alignment item alongside Report 51. Approve the exact role/visibility matrix and a proposed storage policy before any change. Database/storage changes remain blocked pending an independent backup, successful restore rehearsal, and explicit approval of the specific migration and bucket-policy changes.
