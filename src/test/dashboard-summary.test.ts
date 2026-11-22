import { describe, expect, it } from "vitest";
import { dashboardCounts, dashboardShare, dashboardTotal } from "@/lib/dashboard-summary";

describe("dashboard sample summary", () => {
  it("keeps the headline total equal to the sum of status counts", () => {
    expect(dashboardTotal).toBe(128);
    expect(dashboardCounts).toEqual({
      approved: 94,
      underReview: 18,
      returned: 10,
      drafts: 6,
    });
  });

  it("calculates proportional chart segments that add up to 100 percent", () => {
    const shares = Object.values(dashboardCounts).map(dashboardShare);
    expect(shares.reduce((sum, share) => sum + share, 0)).toBeCloseTo(100);
    expect(dashboardShare(0)).toBe(0);
  });
});
