# SiteDocs — سجل التنفيذ اليومي التراكمي

**آخر تحديث:** 2026-11-13  
**المستودع:** `mohannedabdo007-droid/sitedocs`  
**فرع العمل:** `fix/cloudflare-workers-build-2026-11-13`  
**مصدر الحقيقة للكود:** GitHub. المستخدم أكد أن مشروع Lovable مربوط بهذا المستودع وفرع التطوير؛ لا يُطلب منه إعادة إثبات الربط. اختلاف SHA أو الملفات يُعامل كمسألة تزامن/تطابق مستقلة تُفحص تقنياً.

## 1. آخر حالة موثقة

- آخر SHA للشفرة التي اجتازت الاختبارات: `e0c2f6d49ceb96875410743c98112271b3fa310c`.
- كان SHA السابق المسجل في تقرير مطابقة قاعدة البيانات `cc4f58e833c5afe6de409858f50e47e437ace648`؛ مقارنة GitHub أثبتت أن الفرع الحالي تقدم عنه بـ15 commit.
- المستودع خاص، والفرع موجود وغير محمي حالياً (لا branch protection ولا required status checks على ref).
- `main` هو الفرع الافتراضي، ولم يُعدّل أو يُدمج إليه أي تغيير في هذا التشغيل.

## 2. ما نُفّذ فعلياً في هذا التشغيل

### إصلاح لوحة السجل

**المشكلة:** `src/routes/index.tsx` كان يجلب 500 وثيقة فقط، ثم يحسب مؤشرات الوثائق من هذه المجموعة دون إظهار أن النتائج قد تكون مقتطعة. عند وجود أكثر من 500 وثيقة كانت الأرقام قابلة لأن تُفهم خطأً على أنها إجماليات المشروع.

**التغيير:**
- إضافة `MAX_DASHBOARD_DOCUMENTS = 500` و`capDocumentRecords` في `src/lib/document-register.ts`.
- جلب 501 صف لاكتشاف وجود نتائج إضافية، ثم الاحتفاظ بأحدث 500.
- إضافة `hasMoreDocuments` وتنبيه عربي/إنجليزي يوضح أن السجل والمؤشرات يخصان أحدث 500 وثيقة فقط.
- إضافة اختبارات حدّية لعدم التجاوز، واكتشاف الزيادة، ورفض limit غير صالح.

**الملفات:**
- [src/lib/document-register.ts](https://github.com/mohannedabdo007-droid/sitedocs/blob/fix/cloudflare-workers-build-2026-11-13/src/lib/document-register.ts)
- [src/test/document-register.test.ts](https://github.com/mohannedabdo007-droid/sitedocs/blob/fix/cloudflare-workers-build-2026-11-13/src/test/document-register.test.ts)
- [src/routes/index.tsx](https://github.com/mohannedabdo007-droid/sitedocs/blob/fix/cloudflare-workers-build-2026-11-13/src/routes/index.tsx)

**Commit:** [e0c2f6d49ceb96875410743c98112271b3fa310c](https://github.com/mohannedabdo007-droid/sitedocs/commit/e0c2f6d49ceb96875410743c98112271b3fa310c)

## 3. نتائج التحقق

| الفحص | النتيجة | الدليل |
|---|---|---|
| Lint | Passed | [Quality Gate](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43482577909) |
| Vitest unit tests | Passed | [Quality Gate](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43482577909) |
| Production build | Passed | [Quality Gate](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43482577909) |
| Cloudflare Worker build | Passed | [Cloudflare check](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43482578039) |
| Wrangler dry-run | Passed; no publish | [Cloudflare check](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43482578039) |
| Separate typecheck | Not configured/run as a separate CI step | لا يوجد script مستقل لـtypecheck في `package.json` |

لم يتم تشغيل اختبارات مباشرة على مستخدمين أو قاعدة بيانات حقيقية. نجاح CI لا يثبت صحة RLS أو Storage أو RPC.

## 4. مقارنة GitHub وLovable

**Lovable project:** `8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`  
**آخر Lovable SHA معروف:** `34fdc2f274c183513671f3cf8ab38cc40c555731`  
**الحالة:** المشروع جاهز للمعاينة وقاعدة Lovable مفعّلة، لكن SHA لا يطابق GitHub.

| المجال | نتيجة المقارنة |
|---|---|
| `src/lib/domain.ts` | مختلف؛ GitHub يحتوي قواعد رؤية المسودات ودور مدير المشروع المنفصل، ونسخة Lovable أقدم |
| `src/test/domain-rules.test.ts` | مختلف؛ اختبارات GitHub أحدث وتشمل ضوابط مدير المشروع والرؤية |
| `src/routes/index.tsx` | مختلف جذرياً؛ GitHub لوحة بيانات فعلية، وLovable ما زال placeholder فارغاً |
| `drizzle/migrations/0000`–`0003` | متطابقة حرفياً في المقارنة |
| `bun.lock` | متطابق |
| `vitest.config.ts` و`tsconfig.json` | متطابقان |
| `package.json` | اختلاف scripts فقط؛ GitHub يضيف `deploy:cloudflare`، وإصدارات dependencies المقارنة متطابقة |
| `vite.config.ts` | مختلف؛ GitHub يصرّح بإعداد Cloudflare Worker واسم Worker وتاريخ التوافق والمعاينات والمراقبة |

لم تتم مزامنة Lovable عشوائياً، ولم يتم استبدال أي ملف فيه.

## 5. حالة Supabase المستهدف

- الهدف الحصري: `jezpyxuxjzxotxjykhky`.
- `get_project` رُفض بسبب الصلاحية، ولم يظهر الهدف في قائمة المشاريع المتاحة للحساب المتصل.
- قاعدة Lovable معلنة كمفعّلة عبر Supabase، لكن لم يثبت أنها الهدف المحدد.
- لم يتم الاستعلام عن قاعدة Lovable أو أي مشروع بديل، ولم تُستخدم قواعد CRM.
- لا توجد كتابة أو migrations أو تغييرات RLS/Auth/Storage أو بيانات.

## 6. العيوب المفتوحة والأولوية

### P0 — صلاحيات الخادم وقاعدة البيانات
تحليل المصدر يثبت أن `project_role_of` يرفع Company Owner/Admin تلقائياً إلى Project Admin، وأن `is_project_member` يعتمد عليه. كما توجد فجوات موثقة في `transition_document` وRLS للوثائق والإصدارات والمراجعات والمرفقات وStorage، إضافة إلى مراجعة grants لدوال `SECURITY DEFINER`. هذا يتعارض مع الفصل بين عضوية الشركة والمشروع ومع صلاحية مدير المشروع للقراءة فقط.

**الحالة:** مفتوح ومحجوب عن التنفيذ؛ يحتاج مشروع Supabase الصحيح، ونسخة احتياطية قابلة للاستعادة وتجربة استعادة، وخطة migration مستقلة وموافقة صريحة. لا تُعدّل migrations المطبقة أو قاعدة البيانات ضمن العمل اليومي الآمن.

### P1 — اختلاف GitHub وLovable
الواجهة والمنطق والاختبارات لا تتطابق. المزامنة مؤجلة حتى تُراجع فروق الملفات وSHA وتُحدد آلية مزامنة آمنة؛ تأكيد المستخدم للربط معتمد ولا يُطلب منه إثباته مجدداً. لا يُستبدل شيء تلقائياً.

### P2 — حد سجل الوثائق
تمت معالجة التضليل بإظهار حد 500 واكتشاف وجود نتائج إضافية. ما زال السجل يعرض أحدث 500 فقط؛ لا يدّعي هذا الإصلاح أنه أضاف pagination أو إجماليات كاملة.

## 7. الفروع وطلبات الدمج المرصودة

الفروع التي ظهرت في البحث: `fix/cloudflare-workers-build-2026-11-13`, `fix/client-workflow-party-guard-2026-11-11`, `fix/discipline-kpi-normalization-2026-11-11`, `fix/excel-import-resource-limits-2026-11-11`, `fix/import-invalid-date-blocking-2026-11-11`, `fix/restore-test-fail-fast-2026-11-13`, `fix/review-reports-12-64`, `dev/review-fixes`, `implementation/ui-foundation-2026-11-11`, `governance/current-approved-baseline-2026-11-11`, `governance/scan-lifecycle-design-2026-11-11`.

طلبات الدمج المفتوحة التي ظهرت في البحث تشمل #12–#17 و#5 و#6 و#1. لم يتم دمج أو تعديل أي PR في هذا التشغيل.

## 8. الخطوة التالية

1. استعادة الوصول إلى مشروع Supabase ذي المرجع المحدد حصراً، ثم إعادة التحقق من الهوية قبل أي استعلام.
2. مواصلة مراجعة authorization call graph وSECURITY DEFINER grants على المصدر، مع إبقاء أي تعديل DB/RLS/Storage خارج التنفيذ حتى اكتمال بوابات الموافقة والنسخ الاحتياطي.
3. معالجة أي عيب UI أو domain مستقل لا يتطلب تغيير قاعدة البيانات، مع اختبار regression وCI بعد كل commit.
4. إبقاء Lovable منفصلاً حتى يتم إثبات الربط بالفرع الحالي ومراجعة diff قبل أي مزامنة.

## 9. حدود التنفيذ

لا merge إلى `main`، لا نشر إنتاجي، لا تغيير قواعد بيانات أو migrations مطبقة أو بيانات أو RLS أو Storage أو Auth أو أسرار. هذا السجل تراكمي؛ يضاف إليه كل تشغيل يومي مع SHA وcommit ونتائج الاختبار والعيوب والعوائق الجديدة.


## 10. التزام التنفيذ والإدارة — توجيه معتمد

اعتباراً من 2026-11-13، هذه قواعد تشغيل ملزمة لكل أعمال SiteDocs ومهام المتابعة المرتبطة به:

1. القرارات والاتفاقات التي اعتمدها صاحب المشروع هي المرجع الرسمي. لا تُعاد مناقشتها ولا يُطلب اعتمادها أو شرحها مرة أخرى.
2. GitHub repository `mohannedabdo007-droid/sitedocs` هو مصدر الحقيقة الأساسي للكود، وفرع التطوير المعتمد هو `fix/cloudflare-workers-build-2026-11-13`. تأكيد المستخدم أن Lovable مربوط بالمستودع والفرع معتمد؛ يُمنع طلب إعادة إثبات الربط. يُفحص اختلاف SHA أو الملفات بوصفه اختلاف مزامنة، لا سبباً لإعادة فتح قرار الربط.
3. قبل أي سؤال، راجع هذا السجل والتقارير السابقة والمستودع والاتصالات المتاحة. لا تطلب من المستخدم معلومات يمكن للأدوات أو الملفات أو السياق توفيرها.
4. بادر بالفحص والتنفيذ والاختبار والإصلاح الآمن. إذا تعطلت أداة، ابحث عن بديل وواصل الأعمال الممكنة؛ لا تجعل تعطل أداة واحدة يوقف المهمة كلها.
5. اعتماد القرار الوظيفي لا يعفي التنفيذ من الاختبار التقني. اختبر ما نُفذ، وأصلح المخالفات دون إعادة طلب اعتماد التصميم أو القرار المعتمد.
6. لا تتوقف إلا عند قرار جديد أو تغيير جوهري أو إجراء يتطلب موافقة صريحة.
7. يُحظر تعديل قاعدة البيانات أو migrations المطبقة أو النشر الإنتاجي أو الدمج إلى `main` دون موافقة صريحة.
8. لا تدّعِ تنفيذاً أو اتصالاً أو اختباراً أو نجاحاً دون دليل قابل للتحقق. اذكر بدقة ما لم يُنفذ وما تعذر ولماذا.
9. لا تكرر على المستخدم شروحاً أو تحذيرات سبق توضيحها ما لم يظهر مستجد يغيّر القرار.

**نطاق التحديث:** أُدرج هذا التوجيه في سجل المشروع، كما حُدّثت مهام المتابعة الثلاث النشطة لتلتزم به. لا يعني ذلك تغيير إعدادات الإنتاج أو قاعدة البيانات أو الدمج إلى `main`.
