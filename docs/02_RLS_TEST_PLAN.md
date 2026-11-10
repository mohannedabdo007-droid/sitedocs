# 02 - RLS test plan

**Documentation only; runs on the TEST project, never on live.**

## Goal

Prove tenant isolation, party separation and workflow rules with real accounts. Nothing here runs until Phase 0 passes
and the owner approves. Tests are written BEFORE fixes: tests marked KNOWN-BUG must FAIL today and PASS after the fix.

## Fixture (test project only)

- Company A (tenant 1) and Company B (tenant 2).
- Project P1 in Company A with members: C1 (contractor, controller), C2 (contractor, viewer), K1 (consultant, reviewer),
  K2 (consultant, controller), O1 (owner, reviewer), PA (contractor, admin).
- Company B project P2 with member X1 (contractor, admin): the outsider; X1 may see only P2 documents for which X1 has valid membership, never P1 or any unrelated tenant's documents.
- Documents on P1: D-draft-C (draft by contractor), D-draft-K (draft by consultant), D-sub (submitted, waiting consultant),
  D-closed (closed with B), D-cancel (cancel action recorded under the approved workflow without assuming a new enum value), D-info (closed with I), plus one MQR (no codes).
- One attachment per document in storage path `{project}/{document}/...`.
- Seed the approved target discipline catalogue in the isolated test project: ARC Architectural, CIVSTR Civil & Structural, MEC Mechanical, ELE Electrical, and SUR Survey. Assert exactly five selectable disciplines; Civil and Structural must not appear as separate options. This is a target-design test only until an approved forward migration is implemented.

## How a test runs

Each test is one transaction that ends with ROLLBACK:

```sql
begin;
set local role authenticated;
select set_config('request.jwt.claims', json_build_object('sub','<user uuid>','role','authenticated')::text, true);
-- act, then assert with:
do $$ begin
  assert (select count(*) from public.documents where id='<doc>') = 0, 'message';
end $$;
rollback;
```

Anonymous: `set local role anon;` (no claims).

Expected-error tests use `begin ... exception when others then` and assert the SQLSTATE/message prefix (e.g. 'FORBIDDEN').

## Matrix 1: visibility (select)

| actor \ object | D-draft-C | D-draft-K | D-sub | D-closed | attachment of draft-K | audit rows of draft-K | other company doc |
|---|---|---|---|---|---|---|---|
| C1 (contractor) | see | NO | see | see | NO | NO | NO |
| K1 (consultant) | NO | see | see | see | see | see | NO |
| O1 (owner) | NO | NO | see | see | NO | NO | NO |
| PM (project manager for P1) | see | see | see | see | see | see | NO (not a P2 member) |
| X1 (Company B member of P2 only) | NO | NO | NO | NO | NO | NO | see P2 documents only |
| anon | NO | NO | NO | NO | NO | NO | NO |

Today: draft rows are visible to all members: these are KNOWN-BUG for the NO cells (decision 1 hides drafts).
Cancelled/closed/I documents are visible according to project membership and document-visibility rules. PM may read all P1 documents, including drafts, for oversight only.

## Matrix 2: writes

| action | actor | expected |
|---|---|---|
| insert document | C1 (editor) | allowed; originator_party = contractor |
| insert document | C2 (viewer) | denied |
| insert document in P1 | X1 | denied |
| update draft-K fields | C1 | denied (not visible/not own party) |
| submit | originator party controller | allowed |
| submit | consultant on contractor-originated doc | denied |
| respond B/C/D | reviewing party reviewer | allowed |
| respond | originator party | denied |
| respond with code not in project codes | any | denied (FK) KNOWN-BUG (free text today) |
| respond with E | reviewer | denied (E = cancel by contractor only) |
| cancel (E) | originating party, before final response | allowed -> approved cancel action/state handling; do not add a `cancelled` enum value without a separate migration approval |
| cancel | consultant | denied |
| any document mutation/review/approval/closure | PM by PM role alone | denied; PM is read-only for oversight |
| respond I | reviewer | allowed -> review cycle closed, archived, excluded from B/C counts |
| MQR respond with a code | any | denied (no codes) |
| PA (admin, contractor) approves a doc he submitted | PA | denied (submitter <> approver) KNOWN-BUG |
| PA changes his own party to consultant | PA (update / add_project_member upsert) | denied KNOWN-BUG |
| PA changes another member's party | PA | denied or owner-only with audit KNOWN-BUG |
| admin bypass of party check | PA acts as reviewer | denied KNOWN-BUG |
| update/delete audit_log, document_reviews, document_revisions | any authenticated | denied (grants + trigger) |
| update company_id of any row | any | denied |
| insert attachment with storage_path outside `{project}/{document}/` | contributor | denied KNOWN-BUG |

## Matrix 3: storage (bucket document-files)

| actor | read file of draft-K | read file of D-sub | upload to own doc path | upload outside doc path | delete/update |
|---|---|---|---|---|---|
| C1 | NO | yes | yes (editor) | NO | NO |
| K1 | yes | yes | yes | NO | NO |
| X1 | NO | NO | NO | NO | NO |
| anon | NO | NO | NO | NO | NO |

## Matrix 4: RPC / functions (finding B)

For every security-definer RPC: anon execute = false (query in 01_SCHEMA_INVENTORY.md); authenticated without membership = error;
add_*_member for an unregistered email returns the same generic response as for a registered one (no enumeration).

## Matrix 5: numbering and import (data integrity)

- 50 concurrent inserts (two sessions) produce unique, gap-aware serials; per type+discipline+year counters.
- Discipline reference-data test returns exactly the five approved target disciplines; Civil & Structural is one combined option and Survey is distinct. Verify legacy code/reference mapping before any migration.
- Import: server rejects a row that the client marked valid but violates rules; `A` and `00` revisions do not collide.

## Pass criteria

All cells match; zero KNOWN-BUG tests failing after the fix PR; every test rolls back (fixtures reset by re-seed script).
Report format: a table of test id, expected, actual, pass/fail, attached to the PR.

## Do not

- Run on live; commit real passwords/keys; use service_role for tests of user-visible behaviour (it bypasses RLS).
