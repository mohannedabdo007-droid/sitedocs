# Project Doc Control backup manifest

- Source Lovable project: https://lovable.dev/projects/8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c
- Source commit: `963a4af6226e1451b0b155913abb2a4f6770485f`
- Backup branch: `backup/lovable-2026-11-10`
- Backup commit before this manifest update: `73c6628d8b0216b3893187571e51d4482be39107`
- Text/source files copied: 105
- Git tree verified: 106 tracked files including the repository initialization note.
- Environment files: excluded; `.env` and `.env.*` are now ignored.
- Binary assets not copied: `public/apple-touch-icon.png`, `public/favicon.png`, `public/icon-192.png`, `public/icon-512.png`. They remain in the source Lovable project.
- Supabase database: enabled. Read-only inventory captured in `backup/database-seed-snapshot.json`.
- Business data at capture time: 0 projects, 0 documents, 0 revisions, 0 attachments, 0 users; 5 discipline rows and 12 document-type rows.
- Storage: private `document-files` bucket; 0 objects reported.
- This is a source-code plus metadata/lookup snapshot, not a full Supabase physical backup or a tested restore.

## Known corrections required before production
See `critical_findings` in `backup/database-seed-snapshot.json`. Do not treat current MQR/RFI seed labels as approved definitions.
