# 20 — Workflow RPC Authority, Self-Approval, and KPI Semantics Review

**Review type:** Static source review only  
**Branch:** `dev/review-fixes`  
**Files inspected:** `drizzle/migrations/0001_triggers_and_rpcs.sql`, `src/lib/domain.ts`, `src/lib/kpi.ts`, and prior approved project decisions  
**Runtime status:** No live RPC calls, database tests, authenticated-session tests, build, or automated test suite were run.

## Executive summary

The server RPC and UI helper intentionally mirror one another, but both encode an administrator bypass that conflicts with the approved separation between administration and workflow authority. The source allows an `admin` role to submit on behalf of the originating party and to start/respond/return regardless of the current workflow party. The close action is available to admin/controller roles based on lifecycle state, without a distinct close-authority party check.

The inspected transition function also does not visibly enforce a prohibition on the originator reviewing/responding to their own submission. This is a source-level gap requiring explicit policy and adversarial tests; it is not proof that a live user has exploited it.

KPI code counts B/C outcomes and leaves I outside the B/C numerator, consistent with the narrow exclusion rule, but it does not document a denominator/eligibility model for the reporting rates. A future KPI specification must distinguish document inventory totals from review-outcome denominators.

## 1. Approved rules used as criteria

- Workflow actions must be performed by the authorized party at the current workflow step.
- An administrative role must not automatically bypass party authorization.
- The originator must not review or approve its own submission.
- Project Manager is read-only, including for workflow actions.
- E is Cancelled by Contractor and is initiated by the originating contractor, not a reviewer.
- I is For Information Only; it closes the review cycle and is excluded from B/C outcome KPIs.
- MQR is Monthly Quality Report with its own workflow and no default A/B/C/D/E/I response-code cycle.
- RFI is Request for Inspection only and remains distinct from WIR.

## 2. Findings

### WF-01 — Admin bypasses authorized-party checks
**Priority:** Critical  
**Evidence:** In `transition_document`:
- `submit` permits admin without requiring `p = workflow_steps[1]`.
- `start_review` permits admin without requiring `p = cur`.
- `respond` and `return` permit admin without requiring `p = cur`.
The UI helper `availableActions` mirrors the same behavior by treating `isAdmin` as reviewer and allowing admin submission independent of party.

**Impact:** Administrative access can become workflow decision authority. This violates the approved least-privilege boundary and can allow a user outside the assigned party to issue workflow decisions.

**Required design:** Separate administrative management capabilities from workflow action capabilities. For every action, enforce current party and actor eligibility server-side. If any emergency override is genuinely required, define a separate audited, narrowly scoped, explicitly approved action rather than treating all admins as authorized workflow parties.

**Tests:** Admin from wrong party attempts submit/start_review/respond/return; correct-party controller/reviewer cases; admin with and without party membership; role changes during active review; UI/server parity.

### WF-02 — No explicit originator self-review/self-approval guard
**Priority:** Critical  
**Evidence:** The inspected transition path checks role and current party but contains no explicit check that the actor or actor's organization/party differs from the document originator before `start_review`, `respond`, or `return`. The current schema records originator party, current workflow steps, and actor ID in review history, but those facts are not visibly combined into a self-approval denial.

**Impact:** A workflow configured with overlapping parties, or an administrator bypass, may permit the originator to perform review actions on its own submission. Exact exploitability depends on live membership/workflow configuration and must be tested.

**Required design:** Define self-approval at the correct business identity boundary (user, company, party, or originating organization) and reject it in the authoritative RPC. Do not rely only on the UI. Preserve legitimate multi-step workflows where the same user identity may have separate authorized responsibilities only if explicitly permitted and auditable.

**Tests:** Same user, same company, same party, different party, multi-party membership, creator later promoted to admin, and PM read-only cases.

### WF-03 — Close authority is role-based, not party/decision-based
**Priority:** High  
**Evidence:** The RPC allows `admin` or `controller` to close a document when status is approved, or when review is not required and status is submitted. The UI helper similarly offers close to admin/controller based on lifecycle state. No explicit current-party check appears in this branch.

**Impact:** Closing can become a general administrative/editor capability rather than a controlled workflow transition. This risks bypassing the intended actor and audit semantics.

**Required design:** Specify who may close each document type and lifecycle path. Ensure I closure is performed as part of the authorized response transition, not by a generic administrative close action. Define whether non-review documents are closed by originator/controller and whether any oversight close is exceptional.

**Tests:** Wrong-party close, approved close, non-review submitted close, I response closure, repeated close, PM close denial, and audit history actor/party assertions.

### WF-04 — Response-code outcome behavior depends on mutable project configuration
**Priority:** High  
**Evidence:** The transition RPC reads an active project response code and uses its configured `outcome` (`proceed`, `return`, `close`) to determine the next lifecycle. Project response-code labels/outcomes are described as editable. The seed defaults for E and I were already found inconsistent with approved rules in report 17.

**Impact:** A code label may appear correct while its configured outcome produces the wrong lifecycle. For E and I this can directly contradict approved business semantics. Merely changing a label is insufficient.

**Required design:** Enforce immutable semantic meaning for reserved codes (A/B/C/D/E/I), or validate project configuration against canonical definitions. E must be originator cancellation, not a reviewer proceed outcome. I must close/archive the cycle and be excluded from B/C outcome metrics. MQR must not inherit generic response-code workflow.

**Tests:** Attempt to alter reserved code outcomes; inactive/missing codes; I close + archive + KPI exclusion; E actor eligibility and cancellation; MQR with no response-code defaults; generic document types.

### WF-05 — UI helper is not an independent security boundary
**Priority:** High  
**Evidence:** `availableActions` explicitly says it mirrors the server RPC and reproduces the admin bypass. UI actions are convenience only; server RPC is authoritative. Current unit tests for domain rules cannot prove RLS/RPC authorization.

**Impact:** UI/server parity can make a flawed policy look consistent. A hidden button does not secure a callable RPC, and a visible button does not prove the server will accept only valid actors.

**Required design:** Correct server authorization first, then mirror the policy in UI. Add integration tests invoking RPC directly under authenticated identities and compare outcomes to UI availability.

**Tests:** Direct RPC calls bypassing UI for every action/role/party/state combination; UI parity tests only after server tests pass.

### KPI-01 — I is outside B/C numerator, but denominator semantics need an explicit specification
**Priority:** Medium  
**Evidence:** `src/lib/kpi.ts` increments B and C only when `response_code === "B"` or `"C"`; therefore I is not included in `bc`. However, total document counts and by-status/by-code aggregates include rows for I. The SQL matrix groups records by response code and lifecycle without defining a response-outcome denominator.

**Impact:** Inventory totals may correctly include I, while B/C rates or quality-performance ratios may be misleading if the denominator includes I or non-response documents. The phrase “exclude I from B/C KPI” needs an explicit metric-by-metric definition.

**Required design:** Keep I in document inventory/archive totals, but exclude it from B/C response-outcome numerators and denominators. Define eligible denominator (e.g., completed review decisions A/B/C/D only, if that matches the business reporting intent) separately from total documents. Preserve E as cancellation and define whether it is excluded from review-performance rates.

**Tests:** Mixed A/B/C/D/E/I dataset; assert inventory total, response distribution, B/C numerator, denominator, percentage, archived I, and cancelled E independently.

## 3. Minimum authorization test matrix

| Role / party | Action | Expected result |
|---|---|---|
| Originator controller | Submit own draft/returned document | Allow if all document prerequisites pass |
| Non-originating party | Submit | Deny |
| Admin outside originator party | Submit | Deny under approved rule |
| Current reviewer | Start review/respond/return | Allow if code and notes requirements pass |
| Wrong party | Start review/respond/return | Deny |
| Admin outside current party | Start review/respond/return | Deny |
| Originator identity/organization | Review/respond to own submission | Deny |
| Authorized actor | I response | Close cycle and archive |
| Reviewer | E cancellation | Deny; E belongs to originating contractor |
| Originating contractor | E cancellation | Allow only under explicitly defined cancellation timing |
| PM | Any mutation/workflow action | Deny |
| Admin/controller | Generic close | Only if exact document-specific policy authorizes it |

## 4. Implementation dependencies

1. Finalize the party/identity definition for self-approval.
2. Define exact E cancellation transition and whether it is permitted only before review starts.
3. Define generic close authority and remove overlap with I-specific closure.
4. Define MQR workflow separately from generic response-code transitions.
5. Lock canonical reserved response-code semantics.
6. Define KPI denominator and E treatment for each reported rate.
7. Then update server RPC, UI action helper, and tests together.

## 5. Change and test status

- No SQL, application source, or tests were changed.
- No migration was created or applied.
- No live database or RPC was called.
- No build, lint, or automated tests were run.
- This report documents static findings and proposed verification; it is not a runtime security certification.
