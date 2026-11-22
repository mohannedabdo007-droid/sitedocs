export type RegisterStatus = "قيد المراجعة" | "معاد للتعديل" | "معتمد" | "مسودة";
export type RegisterType = "WIR" | "RFI" | "MQR" | "MOM";
export type RegisterRecord = {
  id: string;
  title: string;
  type: RegisterType;
  discipline: string;
  submittedBy: string;
  date: string;
  status: RegisterStatus;
  age: string;
};

export function filterDocumentRecords<T extends RegisterRecord>(
  records: readonly T[],
  query: string,
  type: string,
  status: string,
): T[] {
  const normalizedQuery = query.trim().toLocaleLowerCase();
  return records.filter((record) => {
    const matchesType = type === "الكل" || record.type === type;
    const matchesStatus = status === "الكل" || record.status === status;
    const searchable = [record.id, record.title, record.submittedBy, record.discipline];
    const matchesQuery = !normalizedQuery || searchable.some((value) => value.toLocaleLowerCase().includes(normalizedQuery));
    return matchesType && matchesStatus && matchesQuery;
  });
}


export const MAX_DASHBOARD_DOCUMENTS = 500;

/** Keep the dashboard's bounded result set explicit instead of implying it is complete. */
export function capDocumentRecords<T>(
  records: readonly T[],
  limit = MAX_DASHBOARD_DOCUMENTS,
): { records: T[]; hasMore: boolean } {
  if (!Number.isInteger(limit) || limit < 1) {
    throw new RangeError("limit must be a positive integer");
  }

  return {
    records: records.slice(0, limit),
    hasMore: records.length > limit,
  };
}
