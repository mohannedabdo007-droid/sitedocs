import { createFileRoute } from "@tanstack/react-router";
import { filterDocumentRecords } from "@/lib/document-register";
import { dashboardCounts, dashboardTotal, dashboardShare } from "@/lib/dashboard-summary";
import { useMemo, useState } from "react";
import {
  Activity, Bell, BookOpen, Building2, CalendarDays, CheckCircle2, ChevronDown,
  ChevronLeft, CircleHelp, ClipboardCheck, FileCheck2, FileClock, FilePlus2, FileSearch, Files, Filter,
  FolderKanban, Gauge, HardHat, LayoutDashboard, Menu, MessageSquareText,
  Eye, MoreHorizontal, Plus, Search, Settings2, ShieldCheck, SlidersHorizontal,
  Upload, Users, X,
} from "lucide-react";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "SiteDocs | إدارة وثائق المشروع" },
      { name: "description", content: "منصة ضبط ومتابعة وثائق المشاريع الهندسية" },
    ],
  }),
  component: SiteDocsHome,
});

type DocumentStatus = "قيد المراجعة" | "معاد للتعديل" | "معتمد" | "مسودة";
type Doc = {
  id: string;
  title: string;
  type: "WIR" | "RFI" | "MQR" | "MOM";
  discipline: string;
  submittedBy: string;
  date: string;
  status: DocumentStatus;
  age: string;
};

const documents: Doc[] = [
  { id: "WIR-ARC-0261", title: "فحص أعمال العزل المائي – السطح", type: "WIR", discipline: "معماري", submittedBy: "مؤسسة البناء المتقدم", date: "11 نوفمبر 2026", status: "قيد المراجعة", age: "منذ ساعتين" },
  { id: "RFI-CIV-0084", title: "استفسار حول تفصيلة تسليح القاعدة F-12", type: "RFI", discipline: "مدني وإنشائي", submittedBy: "شركة التنفيذ المتحدة", date: "11 نوفمبر 2026", status: "قيد المراجعة", age: "منذ 4 ساعات" },
  { id: "WIR-ELE-0148", title: "فحص تمديدات الكابلات – الدور الثاني", type: "WIR", discipline: "كهرباء", submittedBy: "مؤسسة البناء المتقدم", date: "10 نوفمبر 2026", status: "معاد للتعديل", age: "يوم واحد" },
  { id: "MQR-2026-010", title: "التقرير الشهري للجودة – أكتوبر", type: "MQR", discipline: "عام", submittedBy: "استشاري المشروع", date: "10 نوفمبر 2026", status: "معتمد", age: "يوم واحد" },
  { id: "WIR-MEC-0092", title: "اختبار ضغط خطوط التكييف", type: "WIR", discipline: "ميكانيكا", submittedBy: "شركة التنفيذ المتحدة", date: "09 نوفمبر 2026", status: "قيد المراجعة", age: "يومان" },
  { id: "MOM-2026-034", title: "محضر اجتماع التنسيق الأسبوعي", type: "MOM", discipline: "عام", submittedBy: "إدارة المشروع", date: "08 نوفمبر 2026", status: "مسودة", age: "3 أيام" },
];

const navGroups = [
  { label: "الرئيسية", items: [{ label: "لوحة التحكم", icon: LayoutDashboard }, { label: "نظرة عامة", icon: Gauge }] },
  { label: "إدارة الوثائق", items: [{ label: "سجل المستندات", icon: Files, count: "128" }, { label: "طلبات الفحص WIR", icon: ClipboardCheck, count: "18" }, { label: "الاستفسارات RFI", icon: MessageSquareText, count: "07" }, { label: "تقارير الجودة MQR", icon: FileCheck2 }, { label: "محاضر الاجتماعات MOM", icon: BookOpen }] },
  { label: "المشروع", items: [{ label: "المشاريع", icon: FolderKanban }, { label: "الأطراف والمستخدمون", icon: Users }, { label: "التخصصات", icon: HardHat }] },
  { label: "النظام", items: [{ label: "سجل النشاط", icon: Activity }, { label: "الإعدادات", icon: Settings2 }] },
];

function SiteDocsHome() {
  const [activeNav, setActiveNav] = useState("لوحة التحكم");
  const [activeFilter, setActiveFilter] = useState("الكل");
  const [search, setSearch] = useState("");
  const [mobileNav, setMobileNav] = useState(false);
  const [showNotice, setShowNotice] = useState(true);

  const filteredDocs = useMemo(() => documents.filter((doc) => {
    const matchesFilter = activeFilter === "الكل" || doc.type === activeFilter;
    const query = search.trim().toLowerCase();
    const matchesSearch = !query || [doc.id, doc.title, doc.submittedBy, doc.discipline].some((v) => v.toLowerCase().includes(query));
    return matchesFilter && matchesSearch;
  }), [activeFilter, search]);

  return (
    <div dir="rtl" className="min-h-screen bg-background text-foreground" lang="ar">
      <div className="flex min-h-screen">
        {mobileNav && <button aria-label="إغلاق القائمة" className="fixed inset-0 z-40 bg-slate-950/40 lg:hidden" onClick={() => setMobileNav(false)} />}
        <aside className={`fixed inset-y-0 right-0 z-50 flex w-[272px] flex-col border-l border-sidebar-border bg-sidebar text-sidebar-foreground transition-transform lg:static lg:z-auto lg:translate-x-0 ${mobileNav ? "translate-x-0" : "translate-x-full lg:translate-x-0"}`}>
          <div className="flex h-[76px] items-center justify-between border-b border-sidebar-border px-5">
            <div className="flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gold text-navy"><FolderKanban size={21} /></div>
              <div><div className="text-lg font-bold tracking-tight">SiteDocs</div><div className="text-[11px] text-sidebar-foreground/60">PROJECT DOC CONTROL</div></div>
            </div>
            <button className="rounded-lg p-2 hover:bg-sidebar-accent lg:hidden" onClick={() => setMobileNav(false)} aria-label="إغلاق"><X size={18} /></button>
          </div>
          <div className="border-b border-sidebar-border p-4">
            <button type="button" disabled title="اختيار المشروع سيكون متاحاً بعد ربط المشاريع" className="flex w-full cursor-not-allowed items-center gap-3 rounded-xl bg-sidebar-accent px-3 py-3 text-right opacity-80">
              <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-gold/15 text-gold"><Building2 size={18} /></div>
              <div className="min-w-0 flex-1"><div className="truncate text-sm font-semibold">مشروع برج الأعمال</div><div className="mt-0.5 text-xs text-sidebar-foreground/55">SD-PRJ-2026-001</div></div>
              <ChevronDown size={16} className="text-sidebar-foreground/50" />
            </button>
          </div>
          <nav className="flex-1 space-y-6 overflow-y-auto px-3 py-5">
            {navGroups.map((group) => <div key={group.label}>
              <div className="mb-2 px-3 text-[10px] font-bold tracking-[.14em] text-sidebar-foreground/45">{group.label}</div>
              <div className="space-y-1">{group.items.map((item) => {
                const Icon = item.icon;
                const selected = activeNav === item.label;
                return <button key={item.label} onClick={() => { setActiveNav(item.label); setMobileNav(false); }} className={`flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm transition-colors ${selected ? "bg-sidebar-primary font-semibold text-sidebar-primary-foreground shadow-sm" : "text-sidebar-foreground/75 hover:bg-sidebar-accent hover:text-sidebar-foreground"}`}>
                  <Icon size={17} /><span className="flex-1 text-right">{item.label}</span>{item.count && <span className={`rounded-md px-2 py-0.5 text-[10px] ${selected ? "bg-white/15" : "bg-sidebar-accent"}`}>{item.count}</span>}
                </button>;
              })}</div>
            </div>)}
          </nav>
          <div className="border-t border-sidebar-border p-4">
            <div className="flex items-center gap-3 rounded-xl bg-sidebar-accent/70 p-3">
              <div className="flex h-9 w-9 items-center justify-center rounded-full bg-gold/20 text-xs font-bold text-gold">م ع</div>
              <div className="min-w-0 flex-1"><div className="truncate text-sm font-semibold">مدير ضبط الوثائق</div><div className="text-xs text-sidebar-foreground/55">مدير المشروع</div></div>
              <MoreHorizontal size={18} className="text-sidebar-foreground/50" />
            </div>
          </div>
        </aside>

        <main className="min-w-0 flex-1">
          <header className="sticky top-0 z-30 flex h-[76px] items-center justify-between border-b border-border bg-card/95 px-4 backdrop-blur md:px-8">
            <div className="flex items-center gap-3">
              <button className="rounded-lg border border-border p-2 hover:bg-muted lg:hidden" onClick={() => setMobileNav(true)} aria-label="فتح القائمة"><Menu size={19} /></button>
              <div><div className="text-xs text-muted-foreground">المشاريع / مشروع برج الأعمال</div><h1 className="mt-0.5 text-base font-bold md:text-lg">{activeNav}</h1></div>
            </div>
            <div className="flex items-center gap-2 md:gap-3">
              <div className="hidden items-center gap-2 rounded-lg border border-border bg-background px-3 py-2 text-xs text-muted-foreground sm:flex"><Search size={15} /><span>بحث سريع...</span><kbd className="mr-3 rounded border border-border px-1.5 py-0.5 text-[10px]">⌘ K</kbd></div>
              <button type="button" disabled title="الإشعارات غير مفعلة في النسخة التجريبية" className="relative cursor-not-allowed rounded-lg border border-border p-2.5 opacity-60" aria-label="الإشعارات"><Bell size={18} /><span className="absolute right-2 top-2 h-2 w-2 rounded-full border-2 border-card bg-destructive" /></button>
              <button type="button" disabled title="المساعدة ستكون متاحة لاحقاً" className="cursor-not-allowed rounded-lg border border-border p-2.5 opacity-60" aria-label="المساعدة"><CircleHelp size={18} /></button>
              <div className="hidden h-9 w-9 items-center justify-center rounded-full bg-primary text-xs font-bold text-primary-foreground sm:flex">م ع</div>
            </div>
          </header>

          {activeNav === "سجل المستندات" ? <DocumentRegister /> : activeNav === "لوحة التحكم" ? <div className="mx-auto max-w-[1500px] space-y-6 p-4 md:p-8">
            {showNotice && <div className="flex items-start gap-3 rounded-xl border border-gold/35 bg-gold-soft/50 px-4 py-3 text-sm">
              <ShieldCheck size={19} className="mt-0.5 shrink-0 text-gold-foreground" />
              <div className="flex-1"><div className="font-semibold">مساحة معاينة تصميمية</div><p className="mt-0.5 text-xs leading-6 text-muted-foreground">المعلومات المعروضة تجريبية لأغراض مراجعة الواجهة فقط. لم يتم ربط هذه الشاشة بقاعدة البيانات أو نظام الصلاحيات بعد.</p></div>
              <button onClick={() => setShowNotice(false)} className="rounded-md p-1 text-muted-foreground hover:bg-background" aria-label="إخفاء التنبيه"><X size={16} /></button>
            </div>}

            <section className="flex flex-col justify-between gap-4 md:flex-row md:items-end">
              <div><div className="mb-2 flex items-center gap-2 text-xs font-medium text-muted-foreground"><CalendarDays size={14} /> الأربعاء، 11 نوفمبر 2026</div><h2 className="text-2xl font-bold tracking-tight md:text-[28px]">مرحباً بك، أهلاً بعودتك</h2><p className="mt-1.5 text-sm text-muted-foreground">إليك ملخص حالة الوثائق والأنشطة في مشروعك.</p></div>
              <div className="flex flex-wrap gap-2"><button type="button" disabled title="الاستيراد ينتظر اعتماد قواعد الاستيراد والربط" className="inline-flex cursor-not-allowed items-center gap-2 rounded-lg border border-border bg-card px-4 py-2.5 text-sm font-semibold opacity-60"><Upload size={16} /> استيراد · قريباً</button><button type="button" disabled title="نماذج الإنشاء المنفصلة قيد الإعداد" className="inline-flex cursor-not-allowed items-center gap-2 rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground opacity-60"><Plus size={17} /> إنشاء مستند · قريباً</button></div>
            </section>

            <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
              <Metric title="إجمالي المستندات" value={String(dashboardTotal)} note="ضمن المشروع الحالي" icon={Files} tone="navy" trend="+12 هذا الشهر" />
              <Metric title="بانتظار المراجعة" value={String(dashboardCounts.underReview)} note="تتطلب إجراءً" icon={FileClock} tone="gold" trend="6 منذ اليوم" />
              <Metric title="معاد للتعديل" value={String(dashboardCounts.returned)} note="بانتظار إعادة التقديم" icon={MessageSquareText} tone="red" trend="3 متأخرة" />
              <Metric title="مستندات معتمدة" value={String(dashboardCounts.approved)} note="تم إكمال دورة المراجعة" icon={CheckCircle2} tone="green" trend="73% من الإجمالي" />
            </section>

            <section className="grid gap-4 xl:grid-cols-[1.55fr_1fr]">
              <div className="rounded-xl border border-border bg-card p-5 shadow-sm">
                <div className="mb-5 flex items-center justify-between"><div><h3 className="font-bold">حالة المستندات</h3><p className="mt-1 text-xs text-muted-foreground">توزيع المستندات حسب الحالة الحالية</p></div><button type="button" disabled title="لا توجد إجراءات متاحة في هذه البطاقة" className="cursor-not-allowed rounded-lg border border-border p-2 text-muted-foreground opacity-50" aria-label="المزيد"><MoreHorizontal size={18} /></button></div>
                <div className="flex h-3 overflow-hidden rounded-full bg-muted"><div style={{ width: `${dashboardShare(dashboardCounts.approved)}%` }} className="bg-emerald-600" /><div style={{ width: `${dashboardShare(dashboardCounts.underReview)}%` }} className="bg-amber-500" /><div style={{ width: `${dashboardShare(dashboardCounts.returned)}%` }} className="bg-rose-500" /><div style={{ width: `${dashboardShare(dashboardCounts.drafts)}%` }} className="bg-slate-400" /></div>
                <div className="mt-5 grid grid-cols-2 gap-4 sm:grid-cols-4">{[{label:"معتمد",value:String(dashboardCounts.approved),color:"bg-emerald-600"},{label:"قيد المراجعة",value:String(dashboardCounts.underReview),color:"bg-amber-500"},{label:"معاد للتعديل",value:String(dashboardCounts.returned),color:"bg-rose-500"},{label:"مسودة",value:String(dashboardCounts.drafts),color:"bg-slate-400"}].map((x)=><div key={x.label} className="flex items-center gap-2"><span className={`h-2.5 w-2.5 rounded-full ${x.color}`} /><div><div className="text-lg font-bold tabular-nums">{x.value}</div><div className="text-[11px] text-muted-foreground">{x.label}</div></div></div>)}</div>
              </div>
              <div className="rounded-xl border border-border bg-card p-5 shadow-sm">
                <div className="mb-4 flex items-center justify-between"><div><h3 className="font-bold">إجراءات سريعة</h3><p className="mt-1 text-xs text-muted-foreground">الوصول إلى المهام المتكررة</p></div><SlidersHorizontal size={18} className="text-muted-foreground" /></div>
                <div className="grid grid-cols-2 gap-2">{[{label:"طلب فحص WIR",icon:ClipboardCheck,target:"طلبات الفحص WIR"},{label:"استفسار RFI",icon:MessageSquareText,target:"الاستفسارات RFI"},{label:"إرسال مستند",icon:FilePlus2,disabled:true},{label:"عرض السجل",icon:FileSearch,target:"سجل المستندات"}].map((x)=><button key={x.label} type="button" disabled={x.disabled} onClick={() => x.target && setActiveNav(x.target)} title={x.disabled ? "الإجراء قيد الإعداد" : `فتح ${x.label}`} className={`flex min-h-[76px] flex-col items-start justify-between rounded-lg border border-border p-3 text-right transition-colors ${x.disabled ? "cursor-not-allowed opacity-50" : "hover:border-gold/60 hover:bg-gold-soft/30"}`}><x.icon size={19} className="text-primary" /><span className="text-xs font-semibold">{x.label}{x.disabled ? " · قريباً" : ""}</span></button>)}</div>
              </div>
            </section>

            <section className="overflow-hidden rounded-xl border border-border bg-card shadow-sm">
              <div className="flex flex-col gap-4 border-b border-border p-5 lg:flex-row lg:items-center lg:justify-between">
                <div><h3 className="font-bold">أحدث المستندات</h3><p className="mt-1 text-xs text-muted-foreground">آخر المستندات التي تم إنشاؤها أو تحديثها في المشروع</p></div>
                <div className="flex flex-col gap-2 sm:flex-row">
                  <div className="relative"><Search size={15} className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground" /><input value={search} onChange={(e) => setSearch(e.target.value)} placeholder="ابحث برقم أو عنوان المستند" className="h-10 w-full rounded-lg border border-border bg-background pr-9 pl-3 text-xs outline-none focus:border-ring sm:w-64" /></div>
                  <button type="button" disabled title="استخدم خيارات النوع أعلاه" className="inline-flex h-10 cursor-not-allowed items-center justify-center gap-2 rounded-lg border border-border px-3 text-xs font-medium opacity-50"><Filter size={14} /> تصفية إضافية · قريباً</button>
                </div>
              </div>
              <div className="flex gap-2 overflow-x-auto border-b border-border px-5 py-3">{["الكل","WIR","RFI","MQR","MOM"].map((f)=><button key={f} onClick={() => setActiveFilter(f)} className={`whitespace-nowrap rounded-lg px-3 py-1.5 text-xs font-semibold transition-colors ${activeFilter===f ? "bg-primary text-primary-foreground" : "text-muted-foreground hover:bg-muted"}`}>{f}</button>)}</div>
              <div className="overflow-x-auto">
                <table className="w-full min-w-[760px] text-right text-xs">
                  <thead className="bg-muted/50 text-muted-foreground"><tr>{["رقم المستند","العنوان","التخصص","مقدم الطلب","تاريخ التقديم","الحالة",""].map((h)=><th key={h} className="px-5 py-3 font-semibold">{h}</th>)}</tr></thead>
                  <tbody className="divide-y divide-border">{filteredDocs.map((doc)=><tr key={doc.id} className="transition-colors hover:bg-muted/30"><td className="px-5 py-4 font-mono text-[11px] font-semibold text-primary" dir="ltr">{doc.id}</td><td className="max-w-[250px] px-5 py-4"><div className="truncate font-semibold">{doc.title}</div><div className="mt-1 text-[10px] text-muted-foreground">{doc.type} · {doc.age}</div></td><td className="px-5 py-4 text-muted-foreground">{doc.discipline}</td><td className="px-5 py-4 text-muted-foreground">{doc.submittedBy}</td><td className="whitespace-nowrap px-5 py-4 text-muted-foreground">{doc.date}</td><td className="px-5 py-4"><StatusPill status={doc.status} /></td><td className="px-5 py-4"><button type="button" disabled aria-label={`خيارات ${doc.id} غير متاحة`} title="لا توجد إجراءات متاحة بعد" className="cursor-not-allowed rounded-md p-1.5 text-muted-foreground opacity-40"><MoreHorizontal size={17} /></button></td></tr>)}</tbody>
                </table>
                {filteredDocs.length===0 && <div className="p-10 text-center text-sm text-muted-foreground">لا توجد مستندات مطابقة لبحثك.</div>}
              </div>
              <div className="flex flex-col items-center justify-between gap-3 border-t border-border px-5 py-3 text-xs text-muted-foreground sm:flex-row"><span>عرض {filteredDocs.length} من 128 مستنداً (بيانات تجريبية)</span><button type="button" onClick={() => setActiveNav("سجل المستندات")} className="inline-flex items-center gap-1 font-semibold text-primary hover:underline">عرض جميع المستندات <ChevronLeft size={15} /></button></div>
            </section>
            <footer className="flex flex-col justify-between gap-2 pb-3 text-[11px] text-muted-foreground sm:flex-row"><span>SiteDocs · Project Document Control</span><span>نسخة واجهة أولية · غير متصلة بالخدمات الخلفية</span></footer>
          </div> : <ModulePlaceholder title={activeNav} />}
        </main>
      </div>
    </div>
  );
}



function ModulePlaceholder({ title }: { title: string }) {
  const isWIR = title === "طلبات الفحص WIR";
  const isRFI = title === "الاستفسارات RFI";
  return (
    <div className="mx-auto max-w-[1100px] space-y-5 p-4 md:p-8">
      <div className="rounded-xl border border-gold/35 bg-gold-soft/40 p-4 text-sm">
        <div className="font-semibold">وحدة مستقلة قيد الإعداد</div>
        <p className="mt-1 text-xs leading-6 text-muted-foreground">هذه معاينة تنظيمية فقط. لا توجد هنا عمليات تقديم أو مراجعة أو اعتماد فعلية، ولا اتصال بقاعدة البيانات أو الصلاحيات.</p>
      </div>
      <section className="rounded-xl border border-border bg-card p-6 shadow-sm md:p-8">
        <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-primary/10 text-primary">{isWIR ? <ClipboardCheck size={24} /> : isRFI ? <MessageSquareText size={24} /> : <FolderKanban size={24} />}</div>
        <h2 className="mt-4 text-2xl font-bold">{title}</h2>
        <p className="mt-2 max-w-2xl text-sm leading-7 text-muted-foreground">
          {isWIR ? "طلبات فحص الأعمال المنفذة ستُبنى كوحدة مستقلة، مع فصل الطلب عن عناصر الفحص ومحاولات إعادة المعاينة وسجل النتائج. تفاصيل دورة العمل ما زالت خاضعة لبوابة التصميم والاعتماد." : isRFI ? "الاستفسارات الهندسية وطلبات المعلومات ستُدار في نموذج ودورة مستقلة تماماً عن WIR، مع مسار خاص بالتخصصات والردود الهندسية. لا نفترض حالات أو صلاحيات لم تُعتمد بعد." : "سيتم تجهيز هذه الوحدة بعد استكمال متطلبات التصميم والصلاحيات والربط."}
        </p>
        <div className="mt-6 flex flex-wrap gap-2">
          <span className="rounded-full border border-border bg-muted px-3 py-1.5 text-xs">مستقلة عن الوحدات الأخرى</span>
          <span className="rounded-full border border-border bg-muted px-3 py-1.5 text-xs">لا توجد بيانات تشغيلية</span>
          {isWIR && <span className="rounded-full border border-border bg-muted px-3 py-1.5 text-xs">مراجعة قواعد DEC-102 مطلوبة قبل التنفيذ</span>}
        </div>
        <button type="button" onClick={() => window.history.length > 1 ? window.history.back() : undefined} className="mt-7 rounded-lg border border-border px-4 py-2 text-sm font-semibold hover:bg-muted">العودة</button>
      </section>
    </div>
  );
}

function DocumentRegister() {
  const [query, setQuery] = useState("");
  const [type, setType] = useState("الكل");
  const [status, setStatus] = useState("الكل");
  const [selected, setSelected] = useState<Doc | null>(null);
  const records = useMemo(() => filterDocumentRecords(documents, query, type, status), [query, type, status]);

  return (
    <div className="mx-auto max-w-[1500px] space-y-6 p-4 md:p-8">
      <section className="flex flex-col justify-between gap-4 md:flex-row md:items-end">
        <div>
          <div className="mb-2 text-xs text-muted-foreground">إدارة الوثائق / سجل المستندات</div>
          <h2 className="text-2xl font-bold tracking-tight">سجل المستندات</h2>
          <p className="mt-1.5 text-sm text-muted-foreground">استعرض المستندات وابحث فيها وصنّفها حسب النوع والحالة.</p>
        </div>
        <div className="flex flex-wrap gap-2">
          <button type="button" className="inline-flex items-center gap-2 rounded-lg border border-border bg-card px-4 py-2.5 text-sm font-semibold hover:bg-muted" onClick={() => { setQuery(""); setType("الكل"); setStatus("الكل"); }}>
            <X size={16} /> مسح عوامل التصفية
          </button>
          <span className="inline-flex items-center rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground">{records.length} مستندات</span>
        </div>
      </section>

      <section className="rounded-xl border border-border bg-card p-4 shadow-sm md:p-5">
        <div className="grid gap-3 md:grid-cols-[1fr_190px_210px]">
          <label className="relative block">
            <span className="sr-only">البحث في السجل</span>
            <Search size={16} className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
            <input aria-label="البحث في السجل" value={query} onChange={(event) => setQuery(event.target.value)} placeholder="ابحث برقم المستند أو العنوان أو مقدم الطلب..." className="h-11 w-full rounded-lg border border-border bg-background pr-10 pl-3 text-sm outline-none focus:border-ring" />
          </label>
          <label className="grid gap-1 text-xs font-semibold text-muted-foreground">
            نوع المستند
            <select aria-label="نوع المستند" value={type} onChange={(event) => setType(event.target.value)} className="h-11 rounded-lg border border-border bg-background px-3 text-sm text-foreground outline-none focus:border-ring">
              {["الكل", "WIR", "RFI", "MQR", "MOM"].map((value) => <option key={value}>{value}</option>)}
            </select>
          </label>
          <label className="grid gap-1 text-xs font-semibold text-muted-foreground">
            حالة المستند
            <select aria-label="حالة المستند" value={status} onChange={(event) => setStatus(event.target.value)} className="h-11 rounded-lg border border-border bg-background px-3 text-sm text-foreground outline-none focus:border-ring">
              {["الكل", "قيد المراجعة", "معاد للتعديل", "معتمد", "مسودة"].map((value) => <option key={value}>{value}</option>)}
            </select>
          </label>
        </div>
      </section>

      <section className="overflow-hidden rounded-xl border border-border bg-card shadow-sm">
        <div className="flex items-center justify-between border-b border-border px-5 py-4">
          <div><h3 className="font-bold">جميع المستندات</h3><p className="mt-1 text-xs text-muted-foreground">النتائج المعروضة بيانات تجريبية وليست سجلات إنتاجية.</p></div>
          <Files size={19} className="text-muted-foreground" />
        </div>
        <div className="overflow-x-auto">
          <table className="w-full min-w-[800px] text-right text-xs">
            <thead className="bg-muted/50 text-muted-foreground"><tr>{["رقم المستند", "العنوان", "النوع", "التخصص", "مقدم الطلب", "التاريخ", "الحالة", "التفاصيل"].map((heading) => <th key={heading} className="px-4 py-3 font-semibold">{heading}</th>)}</tr></thead>
            <tbody className="divide-y divide-border">
              {records.map((record) => <tr key={record.id} className="hover:bg-muted/30">
                <td className="px-4 py-4 font-mono text-[11px] font-semibold text-primary" dir="ltr">{record.id}</td>
                <td className="max-w-[240px] px-4 py-4"><div className="truncate font-semibold">{record.title}</div><div className="mt-1 text-[10px] text-muted-foreground">{record.age}</div></td>
                <td className="px-4 py-4"><span className="rounded-md bg-muted px-2 py-1 font-semibold">{record.type}</span></td>
                <td className="px-4 py-4 text-muted-foreground">{record.discipline}</td>
                <td className="px-4 py-4 text-muted-foreground">{record.submittedBy}</td>
                <td className="whitespace-nowrap px-4 py-4 text-muted-foreground">{record.date}</td>
                <td className="px-4 py-4"><StatusPill status={record.status} /></td>
                <td className="px-4 py-4"><button type="button" onClick={() => setSelected(record)} className="inline-flex items-center gap-1 rounded-md border border-border px-2.5 py-1.5 font-semibold hover:bg-muted"><Eye size={14} /> عرض</button></td>
              </tr>)}
            </tbody>
          </table>
          {records.length === 0 && <div className="p-12 text-center"><FileSearch size={28} className="mx-auto text-muted-foreground" /><p className="mt-3 text-sm font-semibold">لا توجد نتائج مطابقة</p><p className="mt-1 text-xs text-muted-foreground">غيّر كلمات البحث أو عوامل التصفية وحاول مرة أخرى.</p></div>}
        </div>
        <div className="border-t border-border px-5 py-3 text-xs text-muted-foreground">تم عرض {records.length} من {documents.length} سجلات تجريبية</div>
      </section>

      {selected && <div className="fixed inset-0 z-[70] flex items-center justify-center bg-slate-950/50 p-4" role="presentation" onMouseDown={(event) => { if (event.target === event.currentTarget) setSelected(null); }}>
        <section role="dialog" aria-modal="true" aria-labelledby="document-detail-title" className="w-full max-w-xl rounded-2xl border border-border bg-card p-5 shadow-2xl md:p-6">
          <div className="flex items-start justify-between gap-3">
            <div><div className="text-xs text-muted-foreground">تفاصيل المستند</div><h3 id="document-detail-title" className="mt-1 text-lg font-bold">{selected.title}</h3><p className="mt-1 font-mono text-xs text-primary" dir="ltr">{selected.id}</p></div>
            <button type="button" aria-label="إغلاق التفاصيل" onClick={() => setSelected(null)} className="rounded-lg border border-border p-2 hover:bg-muted"><X size={17} /></button>
          </div>
          <div className="mt-5 grid grid-cols-1 gap-3 sm:grid-cols-2">
            {[["نوع المستند", selected.type], ["التخصص", selected.discipline], ["مقدم الطلب", selected.submittedBy], ["تاريخ التقديم", selected.date], ["الحالة", selected.status], ["آخر تحديث", selected.age]].map(([label, value]) => <div key={label} className="rounded-lg border border-border bg-muted/30 p-3"><div className="text-[11px] text-muted-foreground">{label}</div><div className="mt-1 text-sm font-semibold">{value}</div></div>)}
          </div>
          <div className="mt-5 rounded-lg border border-gold/30 bg-gold-soft/40 p-3 text-xs leading-6 text-muted-foreground">هذه شاشة تفاصيل أولية للعرض فقط. لا توجد حالياً إجراءات اعتماد أو تعديل أو رفع مرفقات مرتبطة ببيانات حقيقية.</div>
          <div className="mt-5 flex justify-end"><button type="button" onClick={() => setSelected(null)} className="rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground">إغلاق</button></div>
        </section>
      </div>}
    </div>
  );
}

function Metric({ title, value, note, icon: Icon, tone, trend }: { title: string; value: string; note: string; icon: typeof Files; tone: "navy" | "gold" | "red" | "green"; trend: string }) {
  const tones = { navy: "bg-primary/10 text-primary", gold: "bg-gold/15 text-gold-foreground", red: "bg-rose-500/10 text-rose-600", green: "bg-emerald-600/10 text-emerald-700" };
  return <div className="rounded-xl border border-border bg-card p-5 shadow-sm"><div className="flex items-center justify-between"><span className="text-xs font-medium text-muted-foreground">{title}</span><span className={`flex h-9 w-9 items-center justify-center rounded-lg ${tones[tone]}`}><Icon size={18} /></span></div><div className="mt-4 flex items-end justify-between"><div><div className="text-3xl font-bold tracking-tight tabular-nums">{value}</div><div className="mt-1 text-[11px] text-muted-foreground">{note}</div></div><span className="text-[10px] font-semibold text-muted-foreground">{trend}</span></div></div>;
}

function StatusPill({ status }: { status: DocumentStatus }) {
  const styles: Record<DocumentStatus, string> = {
    "قيد المراجعة": "border-amber-500/20 bg-amber-500/10 text-amber-700 dark:text-amber-300",
    "معاد للتعديل": "border-rose-500/20 bg-rose-500/10 text-rose-700 dark:text-rose-300",
    "معتمد": "border-emerald-600/20 bg-emerald-600/10 text-emerald-700 dark:text-emerald-300",
    "مسودة": "border-slate-500/20 bg-slate-500/10 text-slate-600 dark:text-slate-300",
  };
  return <span className={`inline-flex whitespace-nowrap rounded-full border px-2.5 py-1 text-[10px] font-semibold ${styles[status]}`}>{status}</span>;
}
