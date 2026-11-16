import { readFileSync } from "node:fs";
import { describe, expect, it } from "vitest";

const migration = readFileSync("drizzle/migrations/0004_p0_draft_confidentiality_and_audit.sql", "utf8");
const acceptance = readFileSync("drizzle/tests/p0_draft_audit_rls.acceptance.sql", "utf8");

describe("P0 security migration source guards", () => {
  it("forces the document-files bucket to remain private", () => {
    expect(migration).toContain(
      "update storage.buckets\n   set public = false\n where id = 'document-files';",
    );
    expect(acceptance).toContain("document-files bucket is public and bypasses object RLS");
  });

  it("revokes client execution on trigger-only guard functions", () => {
    expect(migration).toContain(
      "revoke all on function public.set_updated_at() from public, anon, authenticated;",
    );
    expect(migration).toContain(
      "revoke all on function public.documents_guard_update() from public, anon, authenticated;",
    );
    expect(acceptance).toContain("public.set_updated_at()");
    expect(acceptance).toContain("public.documents_guard_update()");
  });

  it("requires an independent MQR workflow and closes response I", () => {
    expect(migration).toContain("MQR_WORKFLOW_REQUIRED");
    expect(migration).toContain("documents_mqr_workflow_guard");
    expect(migration).toContain("public.require_mqr_specific_workflow()");
    expect(migration).toContain("dt.code <> 'MQR'");
    expect(migration).toContain("rc.code = 'I'");
    expect(acceptance).toContain("P0_FAIL MQR response I did not close the review cycle");
    expect(acceptance).toContain("mqr_document_id");
  });
});
