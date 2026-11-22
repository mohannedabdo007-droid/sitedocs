export const dashboardCounts = {
  approved: 94,
  underReview: 18,
  returned: 10,
  drafts: 6,
} as const;

export const dashboardTotal = Object.values(dashboardCounts).reduce((total, count) => total + count, 0);

export function dashboardShare(count: number): number {
  if (dashboardTotal === 0) return 0;
  return (count / dashboardTotal) * 100;
}
