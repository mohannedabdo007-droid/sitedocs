import { createFileRoute } from "@tanstack/react-router";
import { useCallback, useEffect, useMemo, useState } from "react";
import type { ReactNode } from "react";
import {
  Activity, AlertCircle, Building2, CheckCircle2, ChevronDown, ClipboardCheck,
  FileClock, Files, Languages, LoaderCircle, LogIn, MessageSquareText, RefreshCw,
  Search, ShieldCheck,
} from "lucide-react";
import { supabase } from "@/integrations/supabase/client";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "SiteDocs | Project Document Control" },
      { name: "description", content: "Project document control dashboard" },
    ],
  }),
  component: SiteDocsDashboard,
});

type Locale = "ar" | "en";
type Project = { id: string; code: string; name: string; name_ar: string | null; status: string };
type DocRow = {
  id: string; project_id: string; doc_number: string; title: string;
  status: string; submitted_at: string | null; created_at: string;
  document_type_id: string; discipline_id: string | null;
};
type RefRow = { id: string; code: string; name_ar: string; name_en: string };
type DashboardData = { projects: Project[]; documents: DocRow[]; types: RefRow[]; disciplines: RefRow[] };

const copy = {
  ar: {
    brand: "SiteDocs", subtitle: "ضبط وثائق المشاريع", dashboard: "لوحة التحكم",
    overview: "نظرة تشغيلية مباشرة", language: "English", projects: "المشاريع",
    documents: "الوثائق", pending: "قيد المراجعة", approved: "معتمد",
    returned: "معاد للتعديل", drafts: "مسودات مرئية حسب الصلاحية",
    workflows: "حالات النماذج", latest: "سجل الوثائق", search: "ابحث برقم الوثيقة أو عنوانها",
    allProjects: "كل المشاريع", allTypes: "كل الأنواع", allStatuses: "كل الحالات",
    loading: "جارٍ تحميل بيانات حسابك...", signInTitle: "يلزم تسجيل الدخول",
    signInBody: "لا توجد جلسة مستخدم نشطة. سجّل الدخول عبر آلية المصادقة المعتمدة في بيئتك لعرض بياناتك.",
    noProjects: "لا توجد مشاريع متاحة لهذا الحساب",
    noProjectsBody: "لم تُرجع صلاحيات حسابك أي مشاريع. أنشئ مشروعاً من المسار المعتمد أو اطلب إضافتك إلى مشروع.",
    noDocs: "لا توجد وثائق مطابقة", noDocsBody: "لم تُرجع قاعدة البيانات وثائق تطابق عوامل البحث والتصفية.",
    error: "تعذر تحميل البيانات", retry: "إعادة المحاولة", noAccess: "قد تكون البيانات غير متاحة بسبب الجلسة أو سياسات الوصول (RLS).",
    status: "الحالة", number: "رقم الوثيقة", title: "العنوان", type: "النوع",
    discipline: "التخصص", project: "المشروع", created: "تاريخ الإنشاء",
    draft: "مسودة", submitted: "مرسل", under_review: "قيد المراجعة",
    returnedStatus: "معاد", approvedStatus: "معتمد", closed: "مغلق",
    active: "نشط", on_hold: "متوقف مؤقتاً", completed: "مكتمل", archived: "مؤرشف",
    noProject: "—", noDiscipline: "عام", noType: "غير محدد",
    dataNote: "الأرقام والبيانات أدناه مستمدة من استعلامات قاعدة البيانات المسموح بها للمستخدم الحالي. لا توجد بيانات تجريبية.",
    emptyValue: "—", unknown: "غير معروف", authError: "تعذر التحقق من الجلسة",
  },
  en: {
    brand: "SiteDocs", subtitle: "Project Document Control", dashboard: "Dashboard",
    overview: "Live operational overview", language: "العربية", projects: "Projects",
    documents: "Documents", pending: "Under review", approved: "Approved",
    returned: "Returned", drafts: "Drafts visible by permission",
    workflows: "Form status", latest: "Document register", search: "Search document number or title",
    allProjects: "All projects", allTypes: "All types", allStatuses: "All statuses",
    loading: "Loading your account data...", signInTitle: "Sign-in required",
    signInBody: "There is no active user session. Sign in through the authentication method configured for this environment.",
    noProjects: "No projects available for this account",
    noProjectsBody: "Your current permissions returned no projects. Create a project through the approved workflow or ask to be added to one.",
    noDocs: "No matching documents", noDocsBody: "The database returned no documents matching the current search and filters.",
    error: "Unable to load data", retry: "Retry", noAccess: "Data may be unavailable because of session state or Row Level Security (RLS).",
    status: "Status", number: "Document number", title: "Title", type: "Type",
    discipline: "Discipline", project: "Project", created: "Created",
    draft: "Draft", submitted: "Submitted", under_review: "Under review",
    returnedStatus: "Returned", approvedStatus: "Approved", closed: "Closed",
    active: "Active", on_hold: "On hold", completed: "Completed", archived: "Archived",
    noProject: "—", noDiscipline: "General", noType: "Unspecified",
    dataNote: "All figures and records below come from database queries allowed for the current user. No sample data is used.",
    emptyValue: "—", unknown: "Unknown", authError: "Unable to verify session",
  },
} as const;

const statusKeys = ["draft", "submitted", "under_review", "returned", "approved", "closed"] as const;
const formCodes = ["WIR", "RFI", "MIR", "MQR"] as const;

function SiteDocsDashboard() {
  const [locale, setLocale] = useState<Locale>("ar");
  const [userId, setUserId] = useState<string | null>(null);
  const [authReady, setAuthReady] = useState(false);
  const [data, setData] = useState<DashboardData | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [projectFilter, setProjectFilter] = useState("all");
  const [typeFilter, setTypeFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");
  const [query, setQuery] = useState("");
  const t = copy[locale];
  const rtl = locale === "ar";

  useEffect(() => {
    let active = true;
    supabase.auth.getSession().then(({ data: sessionData, error: sessionError }) => {
      if (!active) return;
      if (sessionError) setError(sessionError.message);
      setUserId(sessionData.session?.user.id ?? null);
      setAuthReady(true);
    }).catch((reason: unknown) => {
      if (!active) return;
      setError(reason instanceof Error ? reason.message : t.authError);
      setAuthReady(true);
    });
    const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => {
      setUserId(session?.user.id ?? null);
      setData(null);
      setError(null);
    });
    return () => {
      active = false;
      listener.subscription.unsubscribe();
    };
  }, [t.authError]);

  const loadData = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    setError(null);
    try {
      // Every query uses the browser client and the signed-in user's JWT. RLS remains authoritative.
      const [projectsResult, typesResult, disciplinesResult] = await Promise.all([
        supabase.from("projects").select("id, code, name, name_ar, status").order("created_at", { ascending: false }),
        supabase.from("document_types").select("id, code, name_ar, name_en").order("sort"),
        supabase.from("disciplines").select("id, code, name_ar, name_en").order("sort"),
      ]);
      if (projectsResult.error) throw projectsResult.error;
      if (typesResult.error) throw typesResult.error;
      if (disciplinesResult.error) throw disciplinesResult.error;
      const projects = (projectsResult.data ?? []) as Project[];
      let documents: DocRow[] = [];
      if (projects.length) {
        const result = await supabase.from("documents")
          .select("id, project_id, doc_number, title, status, submitted_at, created_at, document_type_id, discipline_id")
          .in("project_id", projects.map((project) => project.id))
          .order("created_at", { ascending: false })
          .limit(500);
        if (result.error) throw result.error;
        documents = (result.data ?? []) as DocRow[];
      }
      setData({
        projects,
        documents,
        types: (typesResult.data ?? []) as RefRow[],
        disciplines: (disciplinesResult.data ?? []) as RefRow[],
      });
    } catch (reason) {
      setError(reason instanceof Error ? reason.message : "Database query failed");
      setData(null);
    } finally {
      setLoading(false);
    }
  }, [userId]);

  useEffect(() => { void loadData(); }, [loadData]);

  const typeById = useMemo(() => new Map((data?.types ?? []).map((item) => [item.id, item])), [data]);
  const disciplineById = useMemo(() => new Map((data?.disciplines ?? []).map((item) => [item.id, item])), [data]);
  const projectById = useMemo(() => new Map((data?.projects ?? []).map((item) => [item.id, item])), [data]);
  const visibleDocs = useMemo(() => (data?.documents ?? []).filter((doc) => {
    const matchesProject = projectFilter === "all" || doc.project_id === projectFilter;
    const code = typeById.get(doc.document_type_id)?.code ?? "";
    const matchesType = typeFilter === "all" || code === typeFilter;
    const matchesStatus = statusFilter === "all" || doc.status === statusFilter;
    const needle = query.trim().toLocaleLowerCase();
    const matchesQuery = !needle || [doc.doc_number, doc.title].some((value) => value.toLocaleLowerCase().includes(needle));
    return matchesProject && matchesType && matchesStatus && matchesQuery;
  }), [data, projectFilter, typeFilter, statusFilter, query, typeById]);

  const countStatus = (status: string) => (data?.documents ?? []).filter((doc) => doc.status === status).length;
  const countType = (code: string) => (data?.documents ?? []).filter((doc) => typeById.get(doc.document_type_id)?.code === code).length;
  const fmtDate = (value: string) => {
    const date = new Date(value);
    return Number.isNaN(date.getTime()) ? t.emptyValue : new Intl.DateTimeFormat(rtl ? "ar-SA" : "en-GB", { dateStyle: "medium" }).format(date);
  };
  const statusLabel = (status: string) => {
    const labels: Record<string, string> = {
      draft: t.draft, submitted: t.submitted, under_review: t.under_review,
      returned: t.returnedStatus, approved: t.approvedStatus, closed: t.closed,
    };
    return labels[status] ?? status;
  };
  const projectName = (project: Project) => rtl ? (project.name_ar || project.name) : project.name;

  return (
    <div dir={rtl ? "rtl" : "ltr"} lang={locale} className="min-h-screen bg-background text-foreground">
      <header className="sticky top-0 z-20 border-b border-border bg-card/95 backdrop-blur">
        <div className="mx-auto flex min-h-16 max-w-[1600px] items-center justify-between gap-4 px-4 md:px-8">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gold text-navy"><Files size={21} /></div>
            <div><div className="font-bold tracking-tight">{t.brand}</div><div className="text-[11px] text-muted-foreground">{t.subtitle}</div></div>
          </div>
          <div className="flex items-center gap-2">
            <span className="hidden text-xs text-muted-foreground sm:inline">{t.dashboard}</span>
            <button onClick={() => setLocale(rtl ? "en" : "ar")} className="inline-flex min-h-10 items-center gap-2 rounded-lg border border-border px-3 text-sm font-semibold hover:bg-muted" type="button">
              <Languages size={16} />{t.language}
            </button>
            <button onClick={() => void loadData()} disabled={!userId || loading} aria-label={t.retry} title={t.retry} className="rounded-lg border border-border p-2.5 hover:bg-muted disabled:opacity-50" type="button"><RefreshCw size={16} className={loading ? "animate-spin" : ""} /></button>
          </div>
        </div>
      </header>

      <main className="mx-auto max-w-[1600px] space-y-6 px-4 py-6 md:px-8 md:py-8">
        <section className="flex flex-col justify-between gap-3 sm:flex-row sm:items-end">
          <div><div className="flex items-center gap-2 text-xs text-muted-foreground"><Activity size={14} />{t.overview}</div><h1 className="mt-2 text-2xl font-bold md:text-3xl">{t.dashboard}</h1></div>
          {userId && <div className="flex items-center gap-2 rounded-full border border-emerald-500/30 bg-emerald-500/5 px-3 py-1.5 text-xs text-emerald-700 dark:text-emerald-300"><ShieldCheck size={14} />{locale === "ar" ? "جلسة مستخدم نشطة" : "Authenticated session"}</div>}
        </section>

        <div className="rounded-xl border border-border bg-card px-4 py-3 text-xs leading-6 text-muted-foreground">{t.dataNote}</div>

        {!authReady || loading ? (
          <StatePanel icon={<LoaderCircle className="animate-spin" size={24} />} title={t.loading} body={t.noAccess} />
        ) : !userId ? (
          <StatePanel icon={<LogIn size={25} />} title={t.signInTitle} body={t.signInBody} />
        ) : error ? (
          <StatePanel icon={<AlertCircle size={25} />} title={t.error} body={error} action={<button type="button" onClick={() => void loadData()} className="rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground">{t.retry}</button>} />
        ) : !data || data.projects.length === 0 ? (
          <StatePanel icon={<Building2 size={25} />} title={t.noProjects} body={t.noProjectsBody} />
        ) : (
          <>
            <section className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
              <Metric icon={<Building2 size={19} />} label={t.projects} value={data.projects.length} />
              <Metric icon={<Files size={19} />} label={t.documents} value={data.documents.length} />
              <Metric icon={<FileClock size={19} />} label={t.pending} value={countStatus("submitted") + countStatus("under_review")} />
              <Metric icon={<CheckCircle2 size={19} />} label={t.approved} value={countStatus("approved")} />
            </section>

            <section className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
              {formCodes.map((code) => <div key={code} className="rounded-xl border border-border bg-card p-4 shadow-sm">
                <div className="flex items-center justify-between"><span className="text-xs text-muted-foreground">{t.workflows}</span><span className="rounded-md bg-muted px-2 py-1 font-mono text-xs font-bold">{code}</span></div>
                <div className="mt-3 text-2xl font-bold tabular-nums">{countType(code)}</div>
                <div className="mt-1 text-xs text-muted-foreground">{locale === "ar" ? "وثيقة في نطاق صلاحيتك" : "records within your access"}</div>
              </div>)}
            </section>

            <section className="rounded-xl border border-border bg-card shadow-sm">
              <div className="border-b border-border p-4 md:p-5">
                <div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
                  <div><h2 className="font-bold">{t.latest}</h2><p className="mt-1 text-xs text-muted-foreground">{t.documents}: {data.documents.length}</p></div>
                  <div className="grid gap-2 sm:grid-cols-2 lg:grid-cols-4">
                    <label className="relative"><Search size={15} className="absolute start-3 top-1/2 -translate-y-1/2 text-muted-foreground" /><input value={query} onChange={(event) => setQuery(event.target.value)} placeholder={t.search} className="h-10 w-full rounded-lg border border-border bg-background ps-9 pe-3 text-xs outline-none focus:border-ring" /></label>
                    <select value={projectFilter} onChange={(event) => setProjectFilter(event.target.value)} className="h-10 rounded-lg border border-border bg-background px-3 text-xs"><option value="all">{t.allProjects}</option>{data.projects.map((project) => <option key={project.id} value={project.id}>{projectName(project)}</option>)}</select>
                    <select value={typeFilter} onChange={(event) => setTypeFilter(event.target.value)} className="h-10 rounded-lg border border-border bg-background px-3 text-xs"><option value="all">{t.allTypes}</option>{data.types.map((type) => <option key={type.id} value={type.code}>{type.code}</option>)}</select>
                    <select value={statusFilter} onChange={(event) => setStatusFilter(event.target.value)} className="h-10 rounded-lg border border-border bg-background px-3 text-xs"><option value="all">{t.allStatuses}</option>{statusKeys.map((status) => <option key={status} value={status}>{statusLabel(status)}</option>)}</select>
                  </div>
                </div>
              </div>

              <div className="grid gap-3 border-b border-border p-4 sm:grid-cols-3 md:p-5">
                <Metric icon={<MessageSquareText size={17} />} label={t.returned} value={countStatus("returned")} compact />
                <Metric icon={<ClipboardCheck size={17} />} label={t.drafts} value={countStatus("draft")} compact />
                <Metric icon={<FileClock size={17} />} label={t.pending} value={countStatus("submitted") + countStatus("under_review")} compact />
              </div>

              {visibleDocs.length === 0 ? <div className="p-10 text-center"><Files className="mx-auto text-muted-foreground" size={28} /><h3 className="mt-3 font-semibold">{t.noDocs}</h3><p className="mt-1 text-sm text-muted-foreground">{t.noDocsBody}</p></div> : (
                <div className="overflow-x-auto">
                  <table className="w-full min-w-[780px] text-start text-xs">
                    <thead className="bg-muted/50 text-muted-foreground"><tr>
                      {[t.number,t.title,t.project,t.type,t.discipline,t.created,t.status].map((label) => <th key={label} className="px-4 py-3 font-semibold">{label}</th>)}
                    </tr></thead>
                    <tbody className="divide-y divide-border">
                      {visibleDocs.map((doc) => {
                        const type = typeById.get(doc.document_type_id);
                        const discipline = doc.discipline_id ? disciplineById.get(doc.discipline_id) : null;
                        const project = projectById.get(doc.project_id);
                        return <tr key={doc.id} className="hover:bg-muted/30">
                          <td className="whitespace-nowrap px-4 py-3 font-mono font-semibold" dir="ltr">{doc.doc_number}</td>
                          <td className="max-w-[300px] px-4 py-3"><span className="block truncate font-medium">{doc.title}</span></td>
                          <td className="whitespace-nowrap px-4 py-3">{project ? projectName(project) : t.noProject}</td>
                          <td className="px-4 py-3 font-semibold">{type?.code ?? t.noType}</td>
                          <td className="px-4 py-3">{discipline ? (rtl ? discipline.name_ar : discipline.name_en) : t.noDiscipline}</td>
                          <td className="whitespace-nowrap px-4 py-3">{fmtDate(doc.created_at)}</td>
                          <td className="px-4 py-3"><span className="inline-flex whitespace-nowrap rounded-full bg-muted px-2.5 py-1 font-medium">{statusLabel(doc.status)}</span></td>
                        </tr>;
                      })}
                    </tbody>
                  </table>
                </div>
              )}
            </section>
          </>
        )}
      </main>
    </div>
  );
}

function Metric({ icon, label, value, compact = false }: { icon: ReactNode; label: string; value: number; compact?: boolean }) {
  return <div className={`rounded-xl border border-border bg-card shadow-sm ${compact ? "p-3" : "p-4"}`}>
    <div className="flex items-center gap-2 text-muted-foreground">{icon}<span className="text-xs">{label}</span></div>
    <div className={`mt-2 font-bold tabular-nums ${compact ? "text-xl" : "text-2xl"}`}>{value.toLocaleString()}</div>
  </div>;
}

function StatePanel({ icon, title, body, action }: { icon: ReactNode; title: string; body: string; action?: ReactNode }) {
  return <section className="flex min-h-[300px] flex-col items-center justify-center rounded-xl border border-dashed border-border bg-card px-6 py-12 text-center">
    <div className="flex h-12 w-12 items-center justify-center rounded-full bg-muted text-muted-foreground">{icon}</div>
    <h2 className="mt-4 text-lg font-bold">{title}</h2>
    <p className="mt-2 max-w-xl text-sm leading-7 text-muted-foreground">{body}</p>
    {action && <div className="mt-5">{action}</div>}
  </section>;
}
