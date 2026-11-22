// Core domain vocabulary shared by UI, import and tests.
// Response codes and lifecycle states are deliberately separate concepts.

export const LIFECYCLE = ["draft", "submitted", "under_review", "returned", "approved", "closed"] as const;
export type Lifecycle = (typeof LIFECYCLE)[number];

export const PARTIES = ["contractor", "consultant", "owner", "pmc"] as const;
export type Party = (typeof PARTIES)[number];

export const PROJECT_ROLES = ["admin", "controller", "reviewer", "viewer"] as const;
export type ProjectRole = (typeof PROJECT_ROLES)[number];

// Project Manager is a separate read-only authority, not an administrative project role.
export type WorkflowActorRole = ProjectRole | "project_manager";

export const COMPANY_ROLES = ["owner", "admin", "member"] as const;
export type CompanyRole = (typeof COMPANY_ROLES)[number];

export const RESPONSE_OUTCOMES = ["proceed", "return", "close"] as const;
export type ResponseOutcome = (typeof RESPONSE_OUTCOMES)[number];

export const OPEN_REVIEW_STATES: Lifecycle[] = ["submitted", "under_review"];

export type WorkflowAction = "submit" | "start_review" | "respond" | "return" | "close";

export interface WorkflowDoc {
  status: Lifecycle;
  workflow_steps: Party[];
  current_step: number; // 1-based index into workflow_steps
  requires_review: boolean;
  uses_response_codes: boolean;
}

export interface DocumentVisibilityRecord {
  status: Lifecycle;
  created_by: string;
  originator_party: Party;
}

export interface DocumentVisibilityActor {
  user_id: string;
  project_role: ProjectRole | null;
  party: Party | null;
  is_project_member: boolean;
  is_project_manager: boolean;
}

/**
 * Product rule: Project Managers can read every project document for oversight.
 * Other project members can read non-drafts, but drafts are limited to their
 * creator and the originating party. Company-level membership alone is not
 * project membership. This is a domain rule; RLS/Storage must enforce it too.
 */
export function canReadDocument(doc: DocumentVisibilityRecord, actor: DocumentVisibilityActor): boolean {
  if (actor.is_project_manager) return true;
  if (!actor.is_project_member || !actor.project_role) return false;
  if (doc.status !== "draft") return true;
  return actor.user_id === doc.created_by || actor.party === doc.originator_party;
}

export function currentParty(doc: WorkflowDoc): Party | null {
  return doc.workflow_steps[doc.current_step - 1] ?? null;
}

/**
 * Projects the approved workflow rules into the UI action list.
 * This is not a security boundary: RLS and server RPCs must enforce the same
 * rules independently before document workflows are enabled for real users.
 */
export function availableActions(doc: WorkflowDoc, role: WorkflowActorRole | null, party: Party | null): WorkflowAction[] {
  if (!role || !party || role === "viewer" || role === "project_manager") return [];
  const editor = role === "admin" || role === "controller";
  const reviewer = party === currentParty(doc);
  const actions: WorkflowAction[] = [];

  if ((doc.status === "draft" || doc.status === "returned") && editor && party === doc.workflow_steps[0]) {
    actions.push("submit");
  }
  if (doc.requires_review) {
    if (doc.status === "submitted" && reviewer) actions.push("start_review");
    if ((doc.status === "submitted" || doc.status === "under_review") && reviewer) {
      actions.push("respond", "return");
    }
  }
  if (editor && (doc.status === "approved" || (!doc.requires_review && doc.status === "submitted"))) {
    actions.push("close");
  }
  return actions;
}

export function canAddRevision(doc: Pick<WorkflowDoc, "status">, role: WorkflowActorRole | null): boolean {
  return (role === "admin" || role === "controller") && (doc.status === "returned" || doc.status === "approved");
}

/** Whole days a document has been waiting for a response (open review only). */
export function pendingDays(status: Lifecycle, submittedAt: string | null, today = new Date()): number | null {
  if (!submittedAt || !OPEN_REVIEW_STATES.includes(status)) return null;
  const start = Date.UTC(
    new Date(submittedAt).getUTCFullYear(),
    new Date(submittedAt).getUTCMonth(),
    new Date(submittedAt).getUTCDate(),
  );
  const end = Date.UTC(today.getUTCFullYear(), today.getUTCMonth(), today.getUTCDate());
  return Math.max(0, Math.round((end - start) / 86_400_000));
}

export function isOverdue(status: Lifecycle, dueDate: string | null, today = new Date()): boolean {
  if (!dueDate || !OPEN_REVIEW_STATES.includes(status)) return false;
  const todayIso = today.toISOString().slice(0, 10);
  return dueDate < todayIso;
}