# DD-15 Repository Test Inventory — Working Draft

**Document type:** Repository-wide static test-source inventory for the inspected branch  
**Date:** 2026-11-12  
**Status:** SOURCE INVENTORY VERIFIED — NO TEST EXECUTION  
**Branch:** `implementation/ui-foundation-2026-11-11`  
**Tree ref inspected:** `1e4ccdfe0bd8e4df1ae5dd252344e0def9364993`  
**Scope:** All repository paths matching `*.test.*` or `*.spec.*` in the recursive Git tree, plus `src/test` directory contents.

## 1. Inventory result

<badge>4 test files / 20 test cases</badge>

A recursive Git tree inspection returned 276 repository entries and found exactly four tracked test files matching the test/spec filename pattern. The `src/test` directory contains those four test files plus `setup.ts`. No other tracked `.test.*` or `.spec.*` files were found in that inspected tree.

This is a static source inventory only. No test runner was invoked and no pass/fail result is claimed.

## 2. Test-file inventory

| File | Test cases | Source coverage observed | RFI acceptance relevance |
|---|---:|---|---|
| `src/test/app-routing.test.tsx` | 1 | Root route matches a page rather than the not-found route; router matching only, no loaders/rendering. | No RFI lifecycle or authority acceptance coverage. |
| `src/test/dashboard-summary.test.ts` | 2 | Sample dashboard status counts sum to headline total; chart proportions sum to 100% and zero share behavior. | No RFI-specific lifecycle, recipient, security or acceptance coverage. |
| `src/test/document-register.test.ts` | 4 | Document register filtering, combined type/status filters, case-insensitive search and whitespace/no-match behavior over three sample WIR/RFI records. | UI/helper filtering only; does not test RFI submission, lifecycle, authority, evidence, communication or security. |
| `src/test/domain-rules.test.ts` | 13 | Generic document numbering; WIR/MIR examples; legacy workflow role/action checks; pending/overdue/KPI calculations; Excel import mapping, validation, duplicate and revision handling. | No RFI-specific lifecycle/authority or DEC-103–DEC-110 acceptance tests. Existing generic/legacy rules must not be mistaken for the new approved RFI operating model. |

**Total:** 20 test cases across four tracked test files.

## 3. Case-level inventory

### 3.1 `app-routing.test.tsx` — 1 case

- App routing: matches a page for `/` instead of falling back to not found.

### 3.2 `dashboard-summary.test.ts` — 2 cases

- Keeps the headline total equal to the sum of status counts.
- Calculates proportional chart segments that add up to 100 percent.

### 3.3 `document-register.test.ts` — 4 cases

- Returns all records when no filters are selected.
- Filters by document type and status together.
- Searches identifiers, titles, submitters and disciplines without case sensitivity.
- Trims query whitespace and returns an empty result for no matches.

### 3.4 `domain-rules.test.ts` — 13 cases

**Document numbering (2):**
- Formats project/type/discipline/sequence tokens.
- Uses GEN when no discipline and never truncates long sequences.

**Legacy workflow rules (4):**
- Only the originating party (contractor) can submit a draft.
- Only the current reviewing party can respond.
- Viewers get no actions.
- New revisions only after Returned or Approved.

**Pending days and overdue (2):**
- Counts days only while in open review.
- Is overdue only when open and past due date.

**KPI summary (1):**
- Counts B/C codes and averages pending days.

**Excel import validation (4):**
- Never auto-maps UR.
- Flags unmapped values as errors instead of guessing.
- Keeps duplicates and existing revisions flagged, never dropped.
- Parses revisions and dates with the chosen order.

## 4. Important scope distinctions

1. The four test files are the complete filename-pattern inventory from the inspected recursive branch tree, not a claim that no tests exist in external systems or untracked local files.
2. `domain-rules.test.ts` exercises existing generic/legacy workflow logic and numbering. Its sample actors and response-code conventions must not be assumed to implement or validate the approved RFI model.
3. `document-register.test.ts` includes one sample RFI record, but only tests local filtering/search behavior; presence of an RFI fixture is not RFI lifecycle acceptance coverage.
4. Dashboard tests use sample aggregate data; they do not prove RFI metric source lineage, authorization, cycle handling or recipient denominator semantics.
5. The inventory does not include runtime execution, CI status, coverage percentage or mutation testing.

## 5. DD-15 implications

- Current inspected repository tests: **20**.
- RFI-specific acceptance tests identified: **0**.
- Existing UI/helper tests may remain useful for their narrow current purposes, but they cannot be counted as passing AT-RFI or E2E scenarios.
- The 41 source scenarios in docs/137 remain proposed future acceptance cases, not implemented tests.
- The candidate traceability in docs/138 and governance coverage in docs/139/140 remain design artifacts.
- Any future RFI test implementation requires a separate implementation authorization and must follow approved test fixtures, authority, evidence and release controls.

## 6. Evidence and reproducibility

The inventory was derived from the Git tree at the branch SHA stated above and direct source reads of the four test files and `src/test/setup.ts`. File blob SHAs:

| Path | Blob SHA |
|---|---|
| `src/test/app-routing.test.tsx` | `6caef97e5b6f8520ec60294654fd07ad2490ec07` |
| `src/test/dashboard-summary.test.ts` | `88d0364ba6459b17e8b347db3973b0349eac6c01` |
| `src/test/document-register.test.ts` | `ef0c83d18909445120501f072c8e8a5c396bd56e` |
| `src/test/domain-rules.test.ts` | `8ae12c19befbf237213968da3871ce144646cea3` |
| `src/test/setup.ts` | `d6156cf12de435663e938b9359d49d4d2d008ce2` |

## 7. Explicit non-authorization

This inventory authorizes no test execution, code/test additions, RFI lifecycle implementation, production-data access, live workflow, external communication, DB/schema/migration/generated types, Storage, auth/RLS/grants, backup/restore, merge, deployment or release. It is a static source review only.
