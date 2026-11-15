import { readFileSync } from "node:fs";
import { describe, expect, it } from "vitest";

const migration = readFileSync("drizzle/migrations/0004_p0_draft_confidentiality_and_audit.sql", "utf8");
const acceptance = readFileSync("drizzle/tests/p0_draft_audit_rls.acceptance.sql", "utf8");

describe("P0 security migration source guards", () => {
  it("forces the document-files bucket to remain private", () => {
    expect(migration).toMatch(
      /update\\s+storage\\.buckets\\s+set\\s+public\\s*=\\s*false\\s+where\\s+id\\s*=\\s*'document-files'/i,
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
});
