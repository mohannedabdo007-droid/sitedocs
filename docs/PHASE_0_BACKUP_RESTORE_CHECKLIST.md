# Phase 0 — Independent Backup and Restore Checklist

**Status:** Preparation checklist only. No backup or restore has been executed by this document.  
**Purpose:** Prove recoverability before any schema, RLS, Storage, or data change.

## 1. Identify the correct backend first

- [ ] Establish the exact Supabase project reference actually connected to Project Doc Control.
- [ ] Distinguish Lovable Cloud/local Supabase configuration from any unrelated Supabase project.
- [ ] Confirm the target environment is production, staging, or test using authoritative dashboard metadata.
- [ ] Do not infer the backend from a local `supabase/config.toml` project ID alone.
- [ ] Do not use the separately supplied `realestate-crm` project reference unless an authoritative connection check proves it is the Project Doc Control backend.

## 2. Backup requirements

- [ ] Create an independent database backup using a supported method for the identified backend and plan.
- [ ] Record backup timestamp, project reference, PostgreSQL version, backup format, and exact scope.
- [ ] Include schema, data, roles/grants where supported, RLS policies, functions, triggers, extensions, and relevant metadata.
- [ ] Treat Storage object bytes separately from Storage metadata/policies; confirm whether object files are included and back them up separately if needed.
- [ ] Store the backup outside the project being modified, in access-controlled storage.
- [ ] Never place passwords, access tokens, service-role keys, or connection strings in shell history, Git, logs, or this repository.
- [ ] Verify archive integrity and record a cryptographic hash.
- [ ] Confirm retention and access permissions for the backup.

## 3. Restore test requirements

- [ ] Provision a separate disposable Supabase project with compatible PostgreSQL/extensions.
- [ ] Restore the backup into that isolated project; never restore over production as a test.
- [ ] Confirm schema and object counts.
- [ ] Compare tables, constraints, indexes, sequences, enums, functions, triggers, grants, and RLS policies.
- [ ] Verify representative row counts and referential integrity.
- [ ] Verify Storage metadata and separately restore/check object bytes if included in scope.
- [ ] Run the isolated RLS/workflow test suite against the restored copy or a synthetic equivalent.
- [ ] Record restore start/end, errors, warnings, and evidence.
- [ ] Confirm the restored project is not connected to production services or outbound integrations.

## 4. Restore acceptance criteria

A backup is not considered verified merely because:
- a backup job reports success;
- a file exists;
- `pg_restore --list` can read its table of contents;
- a dashboard offers a Restore button;
- a backup is stored in the same project/account without independent recovery access.

A restore is verified only after a full restore into a separate compatible environment and comparison of the required schema/data/security objects, with documented exceptions.

## 5. Current known constraints (must be rechecked)

- Project Doc Control's actual connected Supabase project reference has not been conclusively established in the reviewed evidence.
- The separately supplied Supabase project reference `vlccylkpkhxosivygafx` / dashboard name `realestate-crm` is not proven to be this application's backend.
- Lovable's backup screen previously exposed Restore but not a direct download path; do not click Restore as a way to obtain a backup.
- The user's Supabase Free plan was previously reported not to include scheduled backups or PITR; recheck current plan capabilities before choosing a backup method.
- A local `pg_dump` binary was found at PostgreSQL 17.11, but no export was started.
- A `pg_restore --list` check alone is not a restore test.

## 6. Approval gate

Before any production change, present:
1. verified backend identity;
2. independent backup location and hash;
3. successful isolated restore evidence;
4. exact proposed migration/policy diff;
5. isolated test results;
6. rollback/forward-recovery plan and limitations.

Obtain the user's explicit written approval for the exact production change. This checklist does not authorize database access, backup creation, restore, or schema changes.
