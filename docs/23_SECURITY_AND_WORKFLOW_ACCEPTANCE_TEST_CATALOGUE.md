# 23 — Security and Workflow Acceptance Test Catalogue

**Governing baseline:** `docs/21_CURRENT_APPROVED_BASELINE_AND_SUPERSEDED_RULES.md`  
**Execution order:** `docs/22_CONSOLIDATED_REMEDIATION_MASTER_MATRIX.md`  
**Evidence:** Static findings in reports 18, 19 and 20  
**Status:** Test design only — none of these tests has been executed.

## 1. Purpose

This catalogue converts the approved security and workflow requirements into repeatable acceptance cases. It is intended for implementation and verification by the application/database owner.

A hidden or disabled UI button is never sufficient evidence of authorization. Every denial case must be attempted directly against the authoritative RPC, API, RLS-protected relation, Storage operation, or signed-URL path.

## 2. Test identity fixtures

Create controlled test identities in an isolated restored environment. Use synthetic data only.

| Fixture | Description | Required relationship |
|---|---|---|
| U-ORIG | Originating contractor user | Originator party for document D-01 |
| U-ORIG-2 | Second user in originating company | Same company, distinct user |
| U-REVIEW | Assigned reviewer/controller | Current workflow party for D-02 |
| U-WRONG | Member of a different project party | Not the current workflow party |
| U-ADMIN | Project administrator | Admin role, not automatically workflow-authorized |
| U-COMPANY-ADMIN | Company owner/admin | No explicit project membership in one fixture |
| U-PM | Project Manager | Explicit read-only oversight role |
| U-X1-P2 | X1 company user | X1 party/company with P2 access |
| U-X1-OTHER | X1 user in another company | Not entitled to the first company's P2 records |
| U-VIEWER | Read-only project viewer | No mutation or workflow authority |
| U-ANON | Unauthenticated caller | No authenticated project identity |

Test fixtures must distinguish user identity, company identity, project party, project role, and workflow party. Do not collapse these concepts into a single role flag.

## 3. Draft and related-record visibility

| ID | Scenario | Expected result |
|---|---|---|
| DRAFT-01 | U-ORIG reads own draft document | Allow |
| DRAFT-02 | U-ORIG-2 reads same-company draft | Allow only if the approved party-level rule grants same-party visibility |
| DRAFT-03 | U-WRONG reads another party's draft | Deny / return no row |
| DRAFT-04 | U-ADMIN reads another party's draft | Deny unless explicitly assigned the distinct PM oversight role; admin alone is insufficient |
| DRAFT-05 | U-PM reads any project draft | Allow read-only |
| DRAFT-06 | U-PM attempts update/delete/submit/review/respond/return/close | Deny |
| DRAFT-07 | U-WRONG queries revisions of hidden draft by known document ID | Deny / no rows |
| DRAFT-08 | U-WRONG queries review history of hidden draft | Deny / no rows |
| DRAFT-09 | U-WRONG queries comments on hidden draft | Deny / no rows |
| DRAFT-10 | U-WRONG searches, counts, filters, or requests KPI data containing hidden draft | No disclosure of document existence or protected metadata |
| DRAFT-11 | U-WRONG queries audit entries containing hidden draft metadata | No unauthorized disclosure |
| DRAFT-12 | Draft becomes formally submitted by authorized actor | Visibility changes only according to the approved post-submission policy |
| DRAFT-13 | Document is returned to originator | Other-party visibility follows the approved returned-state rule; do not assume it equals submitted visibility |
| DRAFT-14 | Guessed UUID, sequential ID, or alternate query path | Same authorization result as normal lookup |

**Design dependency:** The approved baseline defines pre-submission confidentiality and PM oversight, but the exact visibility of returned, cancelled, closed, and archived records must be expressed in a complete lifecycle visibility table before implementation.

## 4. Storage and attachment authorization

| ID | Scenario | Expected result |
|---|---|---|
| FILE-01 | Authorized originator reads attachment of own draft | Allow |
| FILE-02 | Other party reads same draft attachment by known object path | Deny |
| FILE-03 | Other party reads attachment metadata by guessed attachment ID | Deny |
| FILE-04 | Other party requests a signed URL for hidden draft attachment | Deny; no usable URL issued |
| FILE-05 | Authorized user uploads to a document they may edit | Allow only when parent document, revision, company and lifecycle all match |
| FILE-06 | Viewer or PM uploads an attachment | Deny unless a separately approved upload capability exists; PM is read-only |
| FILE-07 | User uploads to another party's document | Deny |
| FILE-08 | User supplies a revision ID belonging to a different document | Deny |
| FILE-09 | User uploads to orphan, malformed, or unregistered object path | Deny |
| FILE-10 | User guesses another project's object path | Deny |
| FILE-11 | Attachment points to a deleted/closed/unauthorized parent | Apply explicit lifecycle policy; never rely on project membership alone |
| FILE-12 | Signed URL created before permission revocation | Verify expiry/revocation behavior and document the residual exposure window |

Verify metadata table access and object-store access separately. A secure attachment row does not prove the underlying object is protected, and vice versa.

## 5. Workflow authority and self-approval

| ID | Scenario | Expected result |
|---|---|---|
| WF-TEST-01 | Originator controller submits own eligible draft | Allow |
| WF-TEST-02 | Wrong party submits | Deny |
| WF-TEST-03 | Admin outside originator party submits | Deny |
| WF-TEST-04 | Current workflow party starts review | Allow when state/prerequisites pass |
| WF-TEST-05 | Wrong party starts review | Deny |
| WF-TEST-06 | Admin outside current party starts review | Deny |
| WF-TEST-07 | Current reviewer responds with eligible code | Allow |
| WF-TEST-08 | Wrong party responds | Deny |
| WF-TEST-09 | Admin outside current party responds | Deny |
| WF-TEST-10 | Current reviewer returns document | Allow when return prerequisites pass |
| WF-TEST-11 | Wrong party or admin outside current party returns | Deny |
| WF-TEST-12 | Originator user attempts to review/respond to own submission | Deny |
| WF-TEST-13 | Different user in same originating company attempts review | Apply the explicitly approved identity/organization boundary; no implicit assumption |
| WF-TEST-14 | User has both originator and reviewer memberships | Deny self-review under the approved identity boundary |
| WF-TEST-15 | PM invokes any workflow RPC directly | Deny |
| WF-TEST-16 | User's role/party changes while review is active | Re-evaluate current authorization server-side; stale UI state must not grant action |
| WF-TEST-17 | Duplicate transition/replay request | Idempotent or safely rejected; no duplicate review outcome |
| WF-TEST-18 | Caller invokes RPC with forged actor/user/project/document identifiers | Server derives identity from trusted session and validates all resource relationships |

The self-approval boundary must be decided explicitly: user ID only, same company, same party, or a combination. Until approved, implementation must fail closed for ambiguous overlap cases.

## 6. Response-code semantics

| ID | Scenario | Expected result |
|---|---|---|
| CODE-01 | Authorized reviewer chooses A | Approved outcome; current step advances/closes according to approved workflow |
| CODE-02 | Authorized reviewer chooses B | Approved as Noted; counted in B metric |
| CODE-03 | Authorized reviewer chooses C | Revise and Resubmit; counted in C metric |
| CODE-04 | Authorized reviewer chooses D | Rejected; lifecycle follows approved rejection policy |
| CODE-05 | Reviewer attempts E | Deny |
| CODE-06 | Originating contractor attempts E at permitted lifecycle point | Allow; mark Cancelled by Contractor |
| CODE-07 | Originating contractor attempts E after prohibited lifecycle point | Deny according to approved cancellation timing |
| CODE-08 | Authorized reviewer chooses I | Close review cycle and archive; no further response step remains |
| CODE-09 | I record appears in B/C numerator | Must not happen |
| CODE-10 | I record appears in B/C denominator | Must not happen under the approved exclusion |
| CODE-11 | Client submits unknown/inactive/cross-project response code | Server rejects |
| CODE-12 | Project admin changes reserved code meaning through configuration | Reject or preserve canonical semantics |
| CODE-13 | UI label says one meaning but server outcome encodes another | Test fails; label and lifecycle must agree |

**Open policy dependency:** Define the exact point at which E cancellation is allowed and whether it is a cancellation request or immediate terminal transition. Do not invent this rule in code.

## 7. Project role and tenant boundaries

| ID | Scenario | Expected result |
|---|---|---|
| ROLE-01 | PM reads documents across all project parties | Allow |
| ROLE-02 | PM attempts document edit or workflow transition | Deny |
| ROLE-03 | Company admin has no explicit project membership | Must not silently inherit workflow authority or PM access |
| ROLE-04 | Project admin manages approved project settings | Allow only management capabilities explicitly assigned |
| ROLE-05 | Project admin attempts another party's workflow action | Deny |
| ROLE-06 | X1 user reads P2 document for own company | Allow |
| ROLE-07 | X1 user reads non-P2 document | Deny |
| ROLE-08 | X1 user reads P2 document belonging to another company | Deny |
| ROLE-09 | X1 user queries revision/comment/attachment of unauthorized document | Deny |
| ROLE-10 | Viewer attempts edit, upload, membership change or workflow action | Deny |
| ROLE-11 | Unauthorized user adds, promotes, or removes project member | Deny |
| ROLE-12 | Admin removes last remaining authorized project administrator | Prevent lockout unless a documented recovery process is used |

## 8. Import commit integrity

| ID | Scenario | Expected result |
|---|---|---|
| IMP-TEST-01 | Client submits valid mapped row with authorized project editor | Allow after full server-side revalidation |
| IMP-TEST-02 | Client forges `validation_status=valid` for invalid data | Reject |
| IMP-TEST-03 | Client forges `decision=import` | Does not bypass validation |
| IMP-TEST-04 | Inactive/unknown response code | Reject |
| IMP-TEST-05 | Response code belongs to another project | Reject |
| IMP-TEST-06 | Forged discipline UUID or noncanonical discipline | Reject or map through explicit approved alias |
| IMP-TEST-07 | Invalid date or impossible chronology | Reject |
| IMP-TEST-08 | Contradictory lifecycle and timestamp fields | Reject |
| IMP-TEST-09 | Negative/invalid revision number or overlong fields | Reject |
| IMP-TEST-10 | Duplicate document/revision or cross-type number collision | Reject safely |
| IMP-TEST-11 | Row ID from another batch/project | Reject |
| IMP-TEST-12 | Unauthorized user calls commit RPC directly | Deny |
| IMP-TEST-13 | Partial batch error occurs | Transaction/row behavior matches documented atomicity policy; no silent partial corruption |
| IMP-TEST-14 | Same batch committed twice | Idempotent or safely rejected; no duplicate documents |
| IMP-TEST-15 | Caller manipulates transaction-local GUC flags | No privilege escalation; flags are only set by trusted server-owned path and cleared safely |

## 9. Function privilege and direct-call tests

For every exposed function, record owner, SECURITY DEFINER/INVOKER, EXECUTE grants to PUBLIC, anon, authenticated, service_role, and any custom role.

- PRIV-01: anon cannot execute functions that require an authenticated project identity.
- PRIV-02: PUBLIC has no unintended EXECUTE grant on privileged SECURITY DEFINER functions.
- PRIV-03: authenticated users can execute only functions intended for their role.
- PRIV-04: service_role privileges are documented and not confused with client access.
- PRIV-05: SECURITY DEFINER functions use a safe fixed search_path and fully qualified privileged objects.
- PRIV-06: caller-supplied project/company/user IDs are checked against trusted session identity and resource ownership.
- PRIV-07: exception paths do not leak protected values or leave transaction flags enabled.
- PRIV-08: catalog grants match the reviewed migration and approved privilege matrix.

Do not infer live grants from migration text. These cases require live catalog inspection in the restored test environment.

## 10. Evidence template

For each case, record:

| Field | Required value |
|---|---|
| Test ID | Stable ID from this catalogue |
| Build / commit | Exact tested source commit |
| Environment | Restored isolated environment identifier |
| Actor | Synthetic user ID and role/party/company fixture |
| Resource | Synthetic project/document/revision/attachment ID |
| Initial state | Lifecycle and workflow party before action |
| Operation | Exact query/RPC/API/Storage request |
| Expected | Allow/deny and expected state transition |
| Actual | Observed response and resulting state |
| Side effects | Audit event, storage object, rows changed |
| Result | Pass/fail/not run |
| Evidence | Redacted logs/query output/test artifact |

## 11. Execution safety and status

- This catalogue is a test specification only.
- No tests were executed while preparing it.
- No application source, SQL, migration, database, storage object, permissions, or deployment was changed.
- Execute first against a separately restored test database, not production.
- Production migration remains blocked until independent backup, successful restore rehearsal, exact migration approval, and reviewed test evidence exist.
- Current lifecycle visibility for returned/cancelled/closed/archived documents, self-approval identity boundary, E cancellation timing, and generic close authority remain explicit design decisions to settle before implementation.
