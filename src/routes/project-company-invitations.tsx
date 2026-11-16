import { createFileRoute, Link } from "@tanstack/react-router";
import { useCallback, useEffect, useState } from "react";
import { ArrowLeft, Building2, Check, Clock3, LoaderCircle, Search, Send, ShieldCheck, X } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";

export const Route = createFileRoute("/project-company-invitations")({
  head: () => ({ meta: [{ title: "SiteDocs | دعوات الشركات" }] }),
  component: ProjectCompanyInvitationsPage,
});

type Party = "contractor" | "consultant" | "owner" | "pmc";
type Project = { id: string; code: string; name: string; name_ar: string | null; company_id: string };
type CompanyOption = { id: string; code: string; name: string; name_ar: string | null };
type Invitation = {
  id: string;
  project_id: string;
  project_code: string;
  project_name: string;
  owner_company_name: string;
  invited_company_name: string;
  party: Party;
  status: string;
  expires_at: string;
  created_at: string;
  direction: "sent" | "received";
  can_respond: boolean;
  can_revoke: boolean;
};

const partyLabels: Record<Party, string> = {
  contractor: "المقاول",
  consultant: "الاستشاري",
  owner: "المالك",
  pmc: "إدارة المشروع (PMC)",
};
const statusLabels: Record<string, string> = {
  pending: "بانتظار الرد",
  accepted: "مقبولة",
  rejected: "مرفوضة",
  revoked: "ملغاة",
  expired: "منتهية",
};

function ProjectCompanyInvitationsPage() {
  const [userId, setUserId] = useState<string | null>(null);
  const [authReady, setAuthReady] = useState(false);
  const [projects, setProjects] = useState<Project[]>([]);
  const [invitations, setInvitations] = useState<Invitation[]>([]);
  const [selectedProject, setSelectedProject] = useState("");
  const [party, setParty] = useState<Party>("consultant");
  const [searchText, setSearchText] = useState("");
  const [companies, setCompanies] = useState<CompanyOption[]>([]);
  const [selectedCompany, setSelectedCompany] = useState<CompanyOption | null>(null);
  const [searching, setSearching] = useState(false);
  const [loading, setLoading] = useState(false);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [reason, setReason] = useState("");
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");

  useEffect(() => {
    let active = true;
    supabase.auth.getSession().then(({ data, error: sessionError }) => {
      if (!active) return;
      if (sessionError) setError(sessionError.message);
      setUserId(data.session?.user.id ?? null);
      setAuthReady(true);
    }).catch((cause: unknown) => {
      if (!active) return;
      setError(cause instanceof Error ? cause.message : "تعذر التحقق من الجلسة");
      setAuthReady(true);
    });
    const { data: authListener } = supabase.auth.onAuthStateChange((_event, session) => {
      setUserId(session?.user.id ?? null);
      setProjects([]);
      setInvitations([]);
      setSelectedProject("");
    });
    return () => {
      active = false;
      authListener.subscription.unsubscribe();
    };
  }, []);

  const loadData = useCallback(async () => {
    if (!userId) return;
    setLoading(true);
    setError("");
    try {
      const [projectResult, invitationResult] = await Promise.all([
        supabase.from("projects").select("id, code, name, name_ar, company_id").order("created_at", { ascending: false }),
        supabase.rpc("list_project_company_invitations", {}),
      ]);
      if (projectResult.error) throw projectResult.error;
      if (invitationResult.error) throw invitationResult.error;

      const permissionChecks = await Promise.all((projectResult.data ?? []).map(async (project) => {
        const [manageResult, ownerAdminResult] = await Promise.all([
          supabase.rpc("can_manage_project", { _project: project.id }),
          supabase.rpc("is_company_admin", { _company: project.company_id }),
        ]);
        return manageResult.data === true && ownerAdminResult.data === true
          ? project as Project
          : null;
      }));

      const eligibleProjects = permissionChecks.filter((project): project is Project => project !== null);
      setProjects(eligibleProjects);
      setInvitations((invitationResult.data ?? []) as Invitation[]);
      setSelectedProject((current) =>
        eligibleProjects.some((project) => project.id === current)
          ? current
          : (eligibleProjects[0]?.id ?? ""),
      );
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : "تعذر تحميل الدعوات");
    } finally {
      setLoading(false);
    }
  }, [userId]);

  useEffect(() => { void loadData(); }, [loadData]);

  useEffect(() => {
    let active = true;
    const term = searchText.trim();
    setSelectedCompany(null);
    if (!selectedProject || term.length < 3) {
      setCompanies([]);
      setSearching(false);
      return () => { active = false; };
    }
    setSearching(true);
    supabase.rpc("search_companies_for_project_invitation", {
      _project: selectedProject,
      _query: term,
    }).then(({ data, error: searchError }) => {
      if (!active) return;
      if (searchError) {
        setError(searchError.message);
        setCompanies([]);
      } else {
        setError("");
        setCompanies((data ?? []) as CompanyOption[]);
      }
    }).finally(() => {
      if (active) setSearching(false);
    });
    return () => { active = false; };
  }, [selectedProject, searchText]);

  const sendInvitation = async () => {
    if (!selectedProject || !selectedCompany) return;
    setBusyId("send");
    setError("");
    setNotice("");
    const { error: actionError } = await supabase.rpc("invite_project_company", {
      _project: selectedProject,
      _invited_company: selectedCompany.id,
      _party: party,
    });
    setBusyId(null);
    if (actionError) {
      setError(actionError.message);
      return;
    }
    setNotice("تم إرسال الدعوة. لن تُربط الشركة بالطرف إلا بعد قبول مسؤولها.");
    setSearchText("");
    setCompanies([]);
    setSelectedCompany(null);
    await loadData();
  };

  const respond = async (invitation: Invitation, action: "accept" | "reject" | "revoke") => {
    if (action === "revoke" && reason.trim().length < 5) {
      setError("سبب الإلغاء مطلوب، ويجب ألا يقل عن خمسة أحرف.");
      return;
    }
    setBusyId(invitation.id);
    setError("");
    setNotice("");
    let actionError: { message: string } | null = null;
    if (action === "accept") {
      const result = await supabase.rpc("accept_project_company_invitation", { _invitation: invitation.id });
      actionError = result.error;
    } else if (action === "reject") {
      const result = await supabase.rpc("reject_project_company_invitation", {
        _invitation: invitation.id,
        _reason: reason.trim(),
      });
      actionError = result.error;
    } else {
      const result = await supabase.rpc("revoke_project_company_invitation", {
        _invitation: invitation.id,
        _reason: reason.trim(),
      });
      actionError = result.error;
    }
    setBusyId(null);
    if (actionError) {
      setError(actionError.message);
      return;
    }
    setReason("");
    setNotice(action === "accept" ? "تم قبول الدعوة وربط الشركة بالطرف." : action === "reject" ? "تم رفض الدعوة." : "تم إلغاء الدعوة.");
    await loadData();
  };

  const dateLabel = (value: string) => new Intl.DateTimeFormat("ar-SA", { dateStyle: "medium" }).format(new Date(value));

  if (!authReady || loading && !userId) {
    return <main className="flex min-h-screen items-center justify-center bg-background text-foreground"><LoaderCircle className="animate-spin" /> <span className="ms-3">جارٍ التحميل...</span></main>;
  }
  if (!userId) {
    return <main dir="rtl" className="mx-auto flex min-h-screen max-w-2xl flex-col items-center justify-center gap-4 px-6 text-center"><ShieldCheck size={34} /><h1 className="text-xl font-bold">يلزم تسجيل الدخول</h1><p className="text-sm text-muted-foreground">سجّل الدخول أولاً للوصول إلى دعوات الشركات.</p><Link to="/" className="rounded-lg bg-primary px-4 py-2 text-sm text-primary-foreground">العودة إلى SiteDocs</Link></main>;
  }

  return (
    <main dir="rtl" className="min-h-screen bg-background text-foreground">
      <header className="border-b border-border bg-card">
        <div className="mx-auto flex max-w-6xl items-center justify-between gap-4 px-4 py-4">
          <div className="flex items-center gap-3"><div className="rounded-xl bg-gold p-2 text-navy"><Building2 size={22} /></div><div><div className="font-bold">SiteDocs</div><div className="text-xs text-muted-foreground">إدارة شركات المشروع والتحالفات</div></div></div>
          <Link to="/" className="inline-flex items-center gap-2 rounded-lg border border-border px-3 py-2 text-sm hover:bg-muted"><ArrowLeft size={16} /> لوحة التحكم</Link>
        </div>
      </header>

      <div className="mx-auto max-w-6xl space-y-6 px-4 py-7">
        <section><p className="text-xs font-semibold text-muted-foreground">PROJECT MEMBERSHIP</p><h1 className="mt-2 text-2xl font-bold">دعوات الشركات وقبولها</h1><p className="mt-2 max-w-3xl text-sm leading-7 text-muted-foreground">ابحث باسم الشركة أو رمزها، ثم أرسل دعوة لربطها بدور محدد. يمكن ربط عدة شركات بالطرف نفسه لدعم المشاريع المشتركة والتحالفات (JV)، مع بقاء صلاحيات كل شركة وأعضائها منفصلة.</p></section>

        {error && <div role="alert" className="rounded-lg border border-destructive/30 bg-destructive/5 px-4 py-3 text-sm">{error}</div>}
        {notice && <div role="status" className="rounded-lg border border-emerald-500/30 bg-emerald-500/5 px-4 py-3 text-sm">{notice}</div>}

        <section className="rounded-2xl border border-border bg-card p-5 shadow-sm">
          <div className="mb-4 flex items-center gap-2"><Send size={18} /><h2 className="font-bold">إرسال دعوة شركة</h2></div>
          {projects.length === 0 ? <p className="rounded-lg bg-muted p-4 text-sm text-muted-foreground">لا توجد مشاريع تملك فيها صلاحية إدارة المشروع وإدارة الشركة المالكة معاً.</p> : (
            <div className="grid gap-4 md:grid-cols-2">
              <label className="space-y-2 text-sm"><span className="font-medium">المشروع</span><select value={selectedProject} onChange={(event) => { setSelectedProject(event.target.value); setSearchText(""); setSelectedCompany(null); }} className="h-11 w-full rounded-lg border border-border bg-background px-3"><option value="">اختر المشروع</option>{projects.map((project) => <option key={project.id} value={project.id}>{project.code} — {project.name_ar || project.name}</option>)}</select></label>
              <label className="space-y-2 text-sm"><span className="font-medium">طرف المشروع</span><select value={party} onChange={(event) => setParty(event.target.value as Party)} className="h-11 w-full rounded-lg border border-border bg-background px-3">{(Object.keys(partyLabels) as Party[]).map((value) => <option key={value} value={value}>{partyLabels[value]}</option>)}</select></label>
              <div className="space-y-2 md:col-span-2"><label className="text-sm font-medium" htmlFor="company-search">البحث عن الشركة</label><div className="relative"><Search size={17} className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground" /><input id="company-search" value={searchText} onChange={(event) => setSearchText(event.target.value)} placeholder="اكتب ثلاثة أحرف على الأقل من الاسم أو الرمز" className="h-11 w-full rounded-lg border border-border bg-background pe-10 ps-3 text-sm outline-none focus:border-ring" /></div><p className="text-xs text-muted-foreground">تظهر فقط الشركات المؤهلة غير المرتبطة مسبقاً بالمشروع والتي لا تملك دعوة معلقة.</p>
                {searching && <p className="flex items-center gap-2 text-xs text-muted-foreground"><LoaderCircle size={14} className="animate-spin" /> جارٍ البحث...</p>}
                {companies.length > 0 && <div className="divide-y divide-border rounded-lg border border-border">{companies.map((company) => <button key={company.id} type="button" onClick={() => setSelectedCompany(company)} className="flex w-full items-center justify-between gap-3 px-3 py-3 text-start text-sm hover:bg-muted"><span><span className="block font-semibold">{company.name_ar || company.name}</span><span className="text-xs text-muted-foreground" dir="ltr">{company.code}</span></span><span className="text-xs text-primary">اختيار</span></button>)}</div>}
                {searchText.trim().length >= 3 && !searching && companies.length === 0 && !error && <p className="text-xs text-muted-foreground">لا توجد شركات مؤهلة تطابق البحث.</p>}
              </div>
              {selectedCompany && <div className="flex flex-wrap items-center justify-between gap-3 rounded-lg border border-primary/30 bg-primary/5 p-3 md:col-span-2"><div><div className="text-xs text-muted-foreground">الشركة المختارة</div><div className="font-semibold">{selectedCompany.name_ar || selectedCompany.name} <span className="font-mono text-xs text-muted-foreground" dir="ltr">{selectedCompany.code}</span></div><div className="text-xs text-muted-foreground">الطرف: {partyLabels[party]}</div></div><button type="button" onClick={() => setSelectedCompany(null)} className="rounded-lg border border-border p-2 hover:bg-muted" aria-label="إزالة الاختيار"><X size={16} /></button></div>}
              <div className="md:col-span-2"><button type="button" disabled={!selectedProject || !selectedCompany || busyId === "send"} onClick={() => void sendInvitation()} className="inline-flex min-h-11 items-center gap-2 rounded-lg bg-primary px-5 text-sm font-semibold text-primary-foreground disabled:cursor-not-allowed disabled:opacity-50"><Send size={16} />{busyId === "send" ? "جارٍ الإرسال..." : "إرسال الدعوة"}</button></div>
            </div>
          )}
        </section>

        <section className="rounded-2xl border border-border bg-card shadow-sm">
          <div className="flex items-center justify-between border-b border-border p-5"><div><h2 className="font-bold">صندوق دعوات الشركات</h2><p className="mt-1 text-xs text-muted-foreground">الدعوات المرسلة والواردة التي تسمح صلاحيات حسابك بعرضها</p></div><button type="button" onClick={() => void loadData()} className="rounded-lg border border-border px-3 py-2 text-xs hover:bg-muted">تحديث</button></div>
          {invitations.length === 0 ? <div className="p-10 text-center"><Clock3 className="mx-auto text-muted-foreground" size={28} /><p className="mt-3 text-sm text-muted-foreground">لا توجد دعوات ظاهرة لهذا الحساب.</p></div> : (
            <div className="divide-y divide-border">{invitations.map((invitation) => <article key={invitation.id} className="space-y-3 p-5">
              <div className="flex flex-col justify-between gap-3 md:flex-row md:items-start"><div><div className="flex flex-wrap items-center gap-2"><span className="font-semibold">{invitation.project_code} — {invitation.project_name}</span><span className={`rounded-full px-2.5 py-1 text-xs ${invitation.status === "pending" ? "bg-amber-500/10 text-amber-700 dark:text-amber-300" : "bg-muted text-muted-foreground"}`}>{statusLabels[invitation.status] || invitation.status}</span><span className="rounded-full bg-muted px-2.5 py-1 text-xs">{invitation.direction === "received" ? "واردة" : "مرسلة"}</span></div><p className="mt-2 text-sm">{invitation.direction === "received" ? invitation.owner_company_name : invitation.invited_company_name}</p><p className="mt-1 text-xs text-muted-foreground">الطرف: {partyLabels[invitation.party]} · تاريخ الإرسال: {dateLabel(invitation.created_at)} · تنتهي: {dateLabel(invitation.expires_at)}</p></div>
                <div className="flex flex-wrap gap-2">{invitation.can_respond && <><button type="button" disabled={busyId === invitation.id} onClick={() => void respond(invitation, "accept")} className="inline-flex items-center gap-1 rounded-lg bg-primary px-3 py-2 text-xs font-semibold text-primary-foreground disabled:opacity-50"><Check size={14} /> قبول</button><button type="button" disabled={busyId === invitation.id} onClick={() => void respond(invitation, "reject")} className="inline-flex items-center gap-1 rounded-lg border border-border px-3 py-2 text-xs hover:bg-muted disabled:opacity-50"><X size={14} /> رفض</button></>}{invitation.can_revoke && <button type="button" disabled={busyId === invitation.id} onClick={() => void respond(invitation, "revoke")} className="rounded-lg border border-destructive/40 px-3 py-2 text-xs text-destructive hover:bg-destructive/5 disabled:opacity-50">إلغاء الدعوة</button>}</div>
              </div>
              {(invitation.can_respond || invitation.can_revoke) && <label className="block max-w-xl space-y-1 text-xs text-muted-foreground"><span>{invitation.can_revoke ? "سبب الإلغاء (إلزامي عند الإلغاء)" : "ملاحظة الرفض (اختيارية)"}</span><input value={reason} onChange={(event) => setReason(event.target.value)} placeholder="اكتب السبب هنا" className="h-9 w-full rounded-lg border border-border bg-background px-3 text-sm text-foreground" /></label>}
            </article>)}</div>
          )}
        </section>
      </div>
    </main>
  );
}
