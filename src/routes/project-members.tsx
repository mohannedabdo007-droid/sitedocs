import { createFileRoute } from "@tanstack/react-router";
import { useCallback, useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";

export const Route = createFileRoute("/project-members")({
  head: () => ({ meta: [{ title: "SiteDocs | أعضاء المشروع" }] }),
  component: ProjectMembersPage,
});

type Party = "contractor" | "consultant" | "owner" | "pmc";
type Role = "controller" | "reviewer" | "viewer";
type Project = { id: string; code: string; name: string; name_ar: string | null };
type Company = { id: string; code: string; name: string; name_ar: string | null };
type Member = { id: string; email: string; role: string; party: Party; participant_company_id: string | null };

const partyLabels: Record<Party, string> = {
  contractor: "المقاول",
  consultant: "الاستشاري",
  owner: "المالك",
  pmc: "إدارة المشروع (PMC)",
};

const roleLabels: Record<Role, string> = {
  controller: "مراقب مستندات",
  reviewer: "مراجع",
  viewer: "مشاهد",
};

function ProjectMembersPage() {
  const [userId, setUserId] = useState<string | null>(null);
  const [projects, setProjects] = useState<Project[]>([]);
  const [projectId, setProjectId] = useState("");
  const [party, setParty] = useState<Party>("consultant");
  const [companies, setCompanies] = useState<Company[]>([]);
  const [companyId, setCompanyId] = useState("");
  const [email, setEmail] = useState("");
  const [role, setRole] = useState<Role>("viewer");
  const [members, setMembers] = useState<Member[]>([]);
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");

  useEffect(() => {
    let active = true;
    supabase.auth.getSession().then(({ data, error: authError }) => {
      if (!active) return;
      if (authError) setError(authError.message);
      setUserId(data.session?.user.id ?? null);
      setLoading(false);
    }).catch((cause: unknown) => {
      if (active) {
        setError(cause instanceof Error ? cause.message : "تعذر التحقق من الجلسة");
        setLoading(false);
      }
    });
    const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => {
      setUserId(session?.user.id ?? null);
      setProjects([]);
      setProjectId("");
      setMembers([]);
    });
    return () => {
      active = false;
      listener.subscription.unsubscribe();
    };
  }, []);

  const loadProjects = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    setError("");
    try {
      const { data, error: queryError } = await supabase
        .from("projects").select("id, code, name, name_ar").order("created_at", { ascending: false });
      if (queryError) throw queryError;
      const checks = await Promise.all((data ?? []).map(async (project) => {
        const { data: allowed, error: permissionError } = await supabase.rpc("can_manage_project", { _project: project.id });
        if (permissionError) throw permissionError;
        return allowed === true ? project as Project : null;
      }));
      const eligible = checks.filter((item): item is Project => item !== null);
      setProjects(eligible);
      setProjectId((current) => eligible.some((item) => item.id === current) ? current : (eligible[0]?.id ?? ""));
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "تعذر تحميل المشاريع");
    } finally {
      setLoading(false);
    }
  }, [userId]);

  useEffect(() => { void loadProjects(); }, [loadProjects]);

  const loadPartyCompanies = useCallback(async () => {
    if (!projectId) {
      setCompanies([]);
      setCompanyId("");
      return;
    }
    setError("");
    const { data: links, error: linkError } = await supabase
      .from("project_party_companies")
      .select("participant_company_id")
      .eq("project_id", projectId)
      .eq("party", party);
    if (linkError) {
      setError(linkError.message);
      setCompanies([]);
      setCompanyId("");
      return;
    }
    const ids = [...new Set((links ?? []).map((item) => item.participant_company_id))];
    if (!ids.length) {
      setCompanies([]);
      setCompanyId("");
      return;
    }
    const { data, error: companyError } = await supabase
      .from("companies").select("id, code, name, name_ar").in("id", ids).order("name");
    if (companyError) {
      setError(companyError.message);
      setCompanies([]);
      setCompanyId("");
      return;
    }
    const options = (data ?? []) as Company[];
    setCompanies(options);
    setCompanyId((current) => options.some((item) => item.id === current) ? current : (options.length === 1 ? options[0].id : ""));
  }, [projectId, party]);

  useEffect(() => { void loadPartyCompanies(); }, [loadPartyCompanies]);

  const addMember = async () => {
    if (!projectId || !companyId || !email.trim()) return;
    setBusy(true);
    setError("");
    setNotice("");
    const { error: addError } = await supabase.rpc("add_project_member", {
      _project: projectId,
      _email: email.trim(),
      _party: party,
      _role: role,
      _member_company: companyId,
    });
    setBusy(false);
    if (addError) {
      setError(addError.message);
      return;
    }
    setNotice("تمت إضافة العضو. تم التحقق من انتمائه للشركة المختارة داخل قاعدة البيانات.");
    setEmail("");
  };

  if (loading) return <main className="flex min-h-screen items-center justify-center" dir="rtl">جارٍ التحميل...</main>;
  if (!userId) return <main className="mx-auto flex min-h-screen max-w-xl flex-col items-center justify-center gap-3 px-6 text-center" dir="rtl"><h1 className="text-xl font-bold">يلزم تسجيل الدخول</h1><p className="text-sm text-muted-foreground">سجّل الدخول أولاً لإدارة أعضاء المشروع.</p><a href="/" className="rounded-lg bg-primary px-4 py-2 text-primary-foreground">العودة إلى SiteDocs</a></main>;

  return (
    <main dir="rtl" className="min-h-screen bg-background px-4 py-8 text-foreground">
      <div className="mx-auto max-w-4xl space-y-6">
        <header className="flex flex-wrap items-center justify-between gap-3">
          <div><p className="text-xs font-semibold text-muted-foreground">PROJECT ACCESS</p><h1 className="mt-1 text-2xl font-bold">إضافة أعضاء المشروع</h1><p className="mt-2 text-sm text-muted-foreground">في المشاريع المشتركة، اختر الشركة التي ينتمي إليها العضو داخل الطرف. لا يتم اختيار شركة تلقائياً إذا كان الطرف يضم أكثر من شركة.</p></div>
          <a href="/project-company-invitations" className="rounded-lg border border-border px-3 py-2 text-sm hover:bg-muted">إدارة دعوات الشركات</a>
        </header>

        {error && <div role="alert" className="rounded-lg border border-destructive/30 bg-destructive/5 p-3 text-sm">{error}</div>}
        {notice && <div role="status" className="rounded-lg border border-emerald-500/30 bg-emerald-500/5 p-3 text-sm">{notice}</div>}

        <section className="space-y-4 rounded-2xl border border-border bg-card p-5">
          <label className="block space-y-2 text-sm"><span className="font-medium">المشروع</span><select className="h-11 w-full rounded-lg border border-border bg-background px-3" value={projectId} onChange={(event) => setProjectId(event.target.value)}><option value="">اختر المشروع</option>{projects.map((project) => <option key={project.id} value={project.id}>{project.code} — {project.name_ar || project.name}</option>)}</select></label>
          <div className="grid gap-4 md:grid-cols-2">
            <label className="block space-y-2 text-sm"><span className="font-medium">طرف المشروع</span><select className="h-11 w-full rounded-lg border border-border bg-background px-3" value={party} onChange={(event) => setParty(event.target.value as Party)}>{(Object.keys(partyLabels) as Party[]).map((key) => <option key={key} value={key}>{partyLabels[key]}</option>)}</select></label>
            <label className="block space-y-2 text-sm"><span className="font-medium">الشركة المشاركة</span><select className="h-11 w-full rounded-lg border border-border bg-background px-3" value={companyId} onChange={(event) => setCompanyId(event.target.value)}><option value="">اختر الشركة المنتمية للطرف</option>{companies.map((company) => <option key={company.id} value={company.id}>{company.name_ar || company.name} — {company.code}</option>)}</select></label>
          </div>
          {companies.length > 1 && <p className="text-xs text-amber-700 dark:text-amber-300">هذا الطرف يضم {companies.length} شركات مشاركة؛ يجب تحديد الشركة الفعلية للعضو.</p>}
          {companies.length === 0 && projectId && <p className="text-xs text-muted-foreground">لا توجد شركة مرتبطة بهذا الطرف حالياً. أرسل دعوة شركة أولاً من صفحة دعوات الشركات.</p>}
          <div className="grid gap-4 md:grid-cols-2">
            <label className="block space-y-2 text-sm"><span className="font-medium">البريد الإلكتروني للعضو</span><input type="email" autoComplete="email" value={email} onChange={(event) => setEmail(event.target.value)} className="h-11 w-full rounded-lg border border-border bg-background px-3" placeholder="name@company.com" /></label>
            <label className="block space-y-2 text-sm"><span className="font-medium">دور العضو</span><select value={role} onChange={(event) => setRole(event.target.value as Role)} className="h-11 w-full rounded-lg border border-border bg-background px-3">{(Object.keys(roleLabels) as Role[]).map((key) => <option key={key} value={key}>{roleLabels[key]}</option>)}</select></label>
          </div>
          <button type="button" disabled={!projectId || !companyId || !email.trim() || busy} onClick={() => void addMember()} className="min-h-11 rounded-lg bg-primary px-5 text-sm font-semibold text-primary-foreground disabled:opacity-50">{busy ? "جارٍ إضافة العضو..." : "إضافة العضو إلى المشروع"}</button>
        </section>
        <p className="text-xs leading-6 text-muted-foreground">هذه الواجهة لا تمنح صلاحيات إدارة المشروع أو الاعتماد. إضافة العضو تمر عبر RPC التي تتحقق من صلاحية المدير، وعضوية المستخدم في الشركة المختارة، وربط الشركة بالطرف. لا تعتمد قاعدة البيانات على اختيارات المتصفح وحدها.</p>
      </div>
    </main>
  );
}
