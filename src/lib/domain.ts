// Core domain vocabulary shared by UI, import and tests.
// Response codes and lifecycle states are deliberately separate concepts.

export const LIFECYCLE = ["draft", "submitted", "under_review", "returned", "approved", "closed"] as const;
export type Lifecycle = (typeof LIFECYCLE)[number];

export const PARTIES = ["contractor", "consultant", "owner", "pmc"] as const;
export type Party = (typeof PARTIES)[number];

export const PROJECT_ROLES = ["admin", "controller", "reviewer", "viewer"] as const;
export type ProjectRole = (typeof PROJECT_ROLES)[number];

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

export function currentParty(doc: WorkflowDoc): Party | null {
  return doc.workflow_steps[doc.current_step - 1] ?? null;
}

/**
 * Mirrors public.transition_document on the server so the UI only offers
 * actions the server will accept. The server remains the authority.
 */
export function availableActions(doc: WorkflowDoc, role: ProjectRole | null, party: Party | null): WorkflowAction[] {
  if (!role || role === "viewer") return [];
  const isAdmin = role === "admin";
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

export function canAddRevision(doc: Pick<WorkflowDoc, "status">, role: ProjectRole | null): boolean {
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