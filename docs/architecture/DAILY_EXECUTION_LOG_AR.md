# SiteDocs — سجل التنفيذ اليومي التراكمي

**آخر تحديث:** 2026-11-14  
**المستودع:** `mohannedabdo007-droid/sitedocs`  
**فرع العمل:** `fix/cloudflare-workers-build-2026-11-13`  
**مصدر الحقيقة للكود:** GitHub. المستخدم أكد أن مشروع Lovable مربوط بهذا المستودع وفرع التطوير؛ لا يُطلب منه إعادة إثبات الربط. اختلاف SHA أو الملفات يُعامل كمسألة تزامن/تطابق مستقلة تُفحص تقنياً.

## 1. آخر حالة موثقة

- آخر SHA للشفرة التي اجتازت الاختبارات عند آخر تحديث: `1269ae3f0cd1cbdeaa8c4114dce39b38bcd6de27` (تحديث 2026-11-14).
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
4. ربط Lovable بالمستودع والفرع معتمد بتأكيد صاحب المشروع؛ لا يُطلب إثبات الربط مجدداً. قبل أي مزامنة، تُراجع SHA وفروق الملفات وتُحدد الملفات الآمنة للمزامنة، ولا يُستبدل شيء عشوائياً.

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


## 11. تحقق Actions — إغلاق جرد الجمعة

**وقت التحقق المباشر:** 2026-11-13 (UTC). **فرع العمل:** `fix/cloudflare-workers-build-2026-11-13`. **SHA:** `38babe67728ce8467e401008f69d5329663ed7b1`.

تمت قراءة GitHub Actions API والتحقق من أن التشغيلين التاليين مرتبطان بالـSHA نفسه، وحالتهما `completed` ونتيجتهما `success`، ثم جلب تفاصيل الوظائف والخطوات:

- [SiteDocs Quality Gate — Run 448](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43499705733): وظيفة `Lint, tests and production build` نجحت؛ خطوات ESLint وVitest وProduction build كلها `success`.
- [Cloudflare Workers build check — Run 26](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43499705716): وظيفة `Build and validate Worker bundle` نجحت؛ Cloudflare build وWrangler dry-run validation دون نشر كلها `success`.

هذا يثبت نجاح فحوص CI على SHA المذكور فقط. لا يثبت نشر الإنتاج أو سلامة Supabase الحية أو إغلاق كامل مهام الجمعة/السبت.


## 12. تنفيذ السبت 14 نوفمبر 2026 — إصلاح Excel ومطابقة البيئة بالأدلة

**SHA عند بدء هذا التشغيل:** 84882dbbc8be756eb115ca6dc9d6ef550fb2bc9b  
**SHA البرمجي بعد الإصلاح والتحقق:** 1269ae3f0cd1cbdeaa8c4114dce39b38bcd6de27  
**المصدر:** GitHub هو مصدر الحقيقة للكود. تأكيد المستخدم أن مشروع Lovable مربوط بالمستودع وفرع التطوير معتمد؛ لا يُطلب منه إعادة إثبات الربط.

### 12.1 GitHub والفرع والفروع

- قراءة المستودع نجحت؛ صلاحية المستودع المعادة هي admin مع push.
- تم إثبات الكتابة فعلياً بإنشاء commitين على فرع التطوير وتحريك ref بنجاح، ثم إعادة جلب الملفات والتحقق من blob SHAs.
- الفرع الحالي غير محمي بحسب حقل branch metadata. لم تُفعّل حماية أو تغيّر إعدادات.
- مقارنة الفرع مع main: الفرع متباعد، 622 commit للأمام و2 للخلف. لا دمج إلى main.
- لم يظهر PR مفتوح من الفرع الحالي في بحث PRs.
- شجرة الفروع احتوت 16 فرعاً؛ من الفروع المرجعية: main، dev/review-fixes، backup/lovable-2026-11-10، implementation/ui-foundation-2026-11-11، وفرع التطوير الحالي.
- لم يتم تعديل main أو النسخة الاحتياطية أو أي فرع آخر.

### 12.2 الإصلاح البرمجي الآمن

**العيب المؤكد:** في src/lib/import/excel.ts كانت دالة buildRecords تستخدم regex مزدوج الهروب /\\s+/g، وهذا لا يطابق whitespace العادي. نتيجة ذلك أن العناوين التي تحتوي مسافات متعددة أو tabs لا تُوحّد قبل إنشاء مفاتيح السجلات، وقد لا تُكتشف الأعمدة المكررة بعد التطبيع.

**الإصلاح:**
- استبدال regex إلى /\s+/g مع الإبقاء على trim.
- إضافة اختبارين إلى src/test/excel-resource-limits.test.ts: تطبيع المسافات الداخلية والبادئة/اللاحقة، ومنع تصادم العناوين التي تصبح متطابقة بعد التطبيع.
- توسيع خطوة ESLint في Quality Gate لتشمل src/lib/import/excel.ts وsrc/test/excel-resource-limits.test.ts.

**الملفات:** src/lib/import/excel.ts، src/test/excel-resource-limits.test.ts، .github/workflows/quality-gate.yml.

**سجل commits:**
- ee282699e25fa88bcf3418a674830cbc50065e40 — إصلاح regex وإضافة الاختبارات وتوسيع lint. فشل تشغيل Quality Gate الوسيط بسبب أن fixture الثاني مثّل tab كنص حرفي \t بدلاً من tab escape صحيح؛ typecheck وlint نجحا، واختبارات الوحدة فشلت في حالة واحدة.
- 1269ae3f0cd1cbdeaa8c4114dce39b38bcd6de27 — تصحيح fixture إلى tab escape صحيح، وإعادة تسمية خطوة lint. هذا هو SHA الذي اجتاز الفحوصات النهائية أدناه.

### 12.3 بوابة الجودة على SHA واحد

جميع الفحوصات المطلوبة اكتملت بنجاح على SHA 1269ae3f0cd1cbdeaa8c4114dce39b38bcd6de27:

- [SiteDocs Quality Gate — Run 43624401753](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43624401753): TypeScript typecheck، lint للوحدات المحددة بما فيها Excel، 5 test files / 41 tests passed، وproduction build كلها success.
- [Cloudflare Workers build check — Run 43624401801](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43624401801): TanStack Start Cloudflare build وWrangler deploy --dry-run كلاهما success. لم يحدث نشر.
- تشغيل Quality Gate الوسيط [43624261260](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43624261260) فشل في اختبار fixture واحد فقط، ثم أُصلح السبب وأُعيدت الفحوصات على SHA أحدث ونجحت. لا نخفي فشل المحاولة الوسيطة ولا نستخدمها للحكم على SHA النهائي.
- لا يوجد typecheck منفصل خارج Quality Gate؛ خطوة CI المسماة TypeScript typecheck نفذت bun run typecheck بنجاح.

### 12.4 مطابقة GitHub وLovable

- مشروع Lovable: 8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c.
- get_project وlist_files وread_file نجحت للقراءة.
- SHA المقروء من Lovable بقي 34fdc2f274c183513671f3cf8ab38cc40c555731، بينما GitHub HEAD البرمجي 1269ae3f0cd1cbdeaa8c4114dce39b38bcd6de27. الربط المؤكد من المستخدم لا يعني أن الملفات أو SHA متزامنة.
- الجرد الحالي: GitHub 303 ملفات، Lovable 117، مشتركة 104، GitHub-only عددها 199، وLovable-only عددها 13.
- من الملفات الحرجة: index route مختلف جذرياً (Lovable placeholder مقابل dashboard في GitHub)، domain.ts مختلف (GitHub يتضمن Project Manager read-only وcanReadDocument)، excel.ts مختلف (GitHub يتضمن resource limits وتطبيع العناوين)، وvite.config.ts مختلف (GitHub يحدد Cloudflare Workers/Nitro).
- package.json يختلف في scripts فقط؛ 79 dependency versions المقارنة متطابقة. GitHub يضيف typecheck وdeploy:cloudflare.
- bun.lock وtsconfig.json وvitest.config.ts وsrc/routes/__root.tsx وsrc/router.tsx وsrc/routeTree.gen.ts متطابقة.
- ملفات migration SQL 0000–0003، وdrizzle metadata snapshots 0000–0003 و_journal.json، وdrizzle/schema.ts وsupabase/config.toml متطابقة حرفياً في المقارنة.
- src/test/app-routing.test.tsx وsrc/test/setup.ts متطابقان. domain-rules.test.ts مختلف. dashboard-summary.test.ts وdocument-register.test.ts وexcel-resource-limits.test.ts موجودة في GitHub وغير موجودة في Lovable.
- i18n.tsx مختلف نصياً. i18n-dict.ts يحتوي 341 key في GitHub مقابل 384 في Lovable؛ 43 key موجودة في Lovable فقط ولا توجد مفاتيح GitHub-only في المقارنة. يلزم فحص call sites قبل أي مزامنة.
- 13 ملفاً خاصاً في Lovable يجب حفظها، ومنها .env وملفات الأيقونات ومكونات app وsrc/lib/error-capture.ts وsrc/lib/errors.ts وsrc/lib/queries.ts وtests/db/core_flow_rollback.sql. لم نفتح .env ولم نقرأ أي قيمة سرية.
- لم تتم كتابة أو مزامنة أي ملف Lovable، ولم يحدث Connect/Disconnect/Switch Branch أو استهلاك رصيد Agent أو نشر.

### 12.5 Supabase المستهدف

- تم طلب get_project حصراً للمرجع jezpyxuxjzxotxjykhky عبر اتصال SiteDocs.
- النتيجة: permission denied. لم تُستخدم قائمة المشاريع الأخرى بديلاً، ولم يتم الاتصال بأي مشروع CRM أو Lovable database.
- لا يوجد فحص حي لـRLS أو Storage أو RPC أو migrations المطبقة لهذا المشروع في هذا التشغيل.
- لم تنفذ SQL أو migration أو أي تغيير في قاعدة البيانات.

### 12.6 Cloudflare — قراءة فعلية

- اتصال Cloudflare نجح، وتمت قراءة الحساب والـWorker metadata وsettings عبر GET فقط.
- Worker باسم sitedocs موجود؛ last_deployed_from = dash_template، compatibility_date = 2026-11-13، observability.enabled = false، ولا توجد bindings في settings المعادة.
- vite.config.ts في GitHub يحدد Worker باسم sitedocs ويضبط observability.enabled = true، مع Cloudflare module preset وpreviews. لذلك إعداد Worker الحي لا يطابق إعداد المصدر الحالي بالكامل.
- وجود CI build وWrangler dry-run ناجح لا يثبت نشر GitHub SHA إلى Worker. لم يتم تغيير إعداد Cloudflare أو نشر الإنتاج.
- يوجد Worker منفصل باسم sitedocs-mcp-gateway؛ لم تُقرأ قيم أسراره ولم تُكشف.

### 12.7 العيوب والعوائق المفتوحة

- P0: صلاحيات RLS/RPC/Storage وسرية المسودات ما زالت غير معالجة على قاعدة Supabase المستهدفة؛ الوصول مرفوض، وأي تغيير DB محظور دون بوابة الموافقة والنسخ الاحتياطي والاستعادة.
- P1: Lovable snapshot متأخر ومختلف عن GitHub في الملفات الحرجة؛ يلزم reconciliation انتقائي يحفظ 13 ملفاً خاصاً ولا ينسخ .env.
- P1: Worker sitedocs الحي لا يطابق إعداد المصدر في observability، وآخر مصدر نشر معاد من API هو dash_template؛ لا نشر أو تغيير إنتاجي ضمن هذا التشغيل.
- P2: عيب تطبيع whitespace في Excel أُصلح واختُبر على SHA الحالي.
- حد السجل 500 وثيقة ما زال قائماً؛ الإصلاح السابق يوضح الاقتطاع ولا يضيف pagination.

### 12.8 الخطوة التالية

1. مواصلة تدقيق منطق الصلاحيات والرؤية في المصدر واختبارات domain دون ادعاء أنها بديل عن RLS.
2. استكمال خطة المزامنة الانتقائية لملفات Lovable من diff، مع حفظ الملفات الخاصة وعدم الكتابة قبل السماح الصريح.
3. إعادة محاولة قراءة مشروع Supabase المحدد فقط عند توفر صلاحية؛ لا بديل CRM.
4. إبقاء Worker الإنتاجي وmain وقاعدة البيانات دون تغيير. أي نشر أو DB change أو merge يتطلب موافقة صريحة.


## 13. تشغيل 14 نوفمبر 2026 — إصلاح fail-closed في صلاحيات إجراءات سير المستند

**SHA عند بدء التشغيل:** `a2d26608fe5d8b8434ceee0272497a97cc678a5d`  
**SHA البرمجي بعد الإصلاح:** `0ee2d4dddea2b5e994188630da465c4d626fcfe5`  
**مصدر الكود:** GitHub هو المصدر المعتمد. تأكيد المستخدم لربط Lovable بالمستودع والفرع مقبول ولا يُطلب إثباته مجدداً.

### 13.1 جرد GitHub والفروع

- نجحت قراءة المستودع وبيانات الفرع، وصلاحية المستودع تشمل push. تم إثبات الكتابة الفعلية بإنشاء commit على فرع التطوير وتحريك ref باستخدام expected SHA، ثم إعادة جلب الملفين والتحقق من blob SHAs.
- HEAD الحالي بعد الإصلاح: `0ee2d4dddea2b5e994188630da465c4d626fcfe5`.
- الفرع غير محمي بحسب GitHub branch metadata؛ لم نغيّر إعدادات الحماية.
- مقارنة الفرع مع `main`: متباعد، 624 commit للأمام و2 للخلف. مقارنة الفرع مع `dev/review-fixes`: متباعد، 546 commit للأمام و2 للخلف. لا دمج إلى main.
- تسعة PRs مفتوحة في المستودع، ولا يوجد بينها PR مصدره فرع التطوير الحالي.
- الفروع الأخرى لم تُعدّل.

### 13.2 الإصلاح البرمجي المنفذ

**العيب المؤكد:** في `src/lib/domain.ts` كانت `availableActions` تقارن `party === currentParty(doc)` دون رفض غياب party. إذا كانت `current_step` غير صالحة، فإن `currentParty` تعيد `null`. وعندما تكون هوية الطرف الحالي أيضاً `null` تصبح المقارنة صحيحة، وقد تعرض الواجهة `start_review` و`respond` و`return` لمراجع في مستند submitted رغم عدم وجود طرف حالي صالح.

**الإصلاح:**
- أضيف شرط fail-closed: غياب `role` أو `party` يمنع إظهار أي إجراء.
- حُدّث اختبار Project Manager ليختبر مستنداً في حالة active review، وليس مسودة فقط.
- أضيف اختبار انحدار لحالة current_step غير الصالحة مع actor party = null.

**الملفات:**
- `src/lib/domain.ts` — blob SHA: `35658aa7c6e1993405510cae23b60ba22df1c0bf`.
- `src/test/domain-rules.test.ts` — blob SHA: `fb6372fd8d5b977697ac91244b6c37112c83ad39`.

**Commit:** [`0ee2d4dddea2b5e994188630da465c4d626fcfe5`](https://github.com/mohannedabdo007-droid/sitedocs/commit/0ee2d4dddea2b5e994188630da465c4d626fcfe5).

هذا إصلاح لقاعدة إجراءات الواجهة فقط، وليس بديلاً عن RLS أو فحص RPC في الخادم. كما أن `src/routes/index.tsx` لا يستدعي `canReadDocument` حالياً؛ لذلك لا نزعم أن helper الرؤية وحده يفرض سرية المسودات في التشغيل الفعلي.

### 13.3 بوابة الجودة على SHA واحد

على SHA `0ee2d4dddea2b5e994188630da465c4d626fcfe5` اكتملت الفحوصات التالية بنجاح:

- [SiteDocs Quality Gate — Run 43626323780](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43626323780): TypeScript `tsc --noEmit` نجح، ESLint نجح، Vitest نجح (5 ملفات اختبار، 42 اختباراً)، وProduction build نجح.
- [Cloudflare Workers build check — Run 43626323794](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43626323794): TanStack Start Cloudflare build و`wrangler deploy --dry-run` نجحا. لم يحدث نشر.
- لم نستخدم تشغيلات SHA أقدم لإثبات حالة هذا الإصلاح.

### 13.4 مطابقة GitHub وLovable بعد commit

- مشروع Lovable: `8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`.
- القراءة المباشرة لـ`get_project` و`list_files` و`read_file` نجحت. بقي `latest_commit_sha` في Lovable عند `34fdc2f274c183513671f3cf8ab38cc40c555731` حتى بعد دفع commit GitHub الجديد؛ حالة المشروع Ready وآخر تعديل مسجل 2026-11-13 08:22:10 UTC.
- Lovable API يعيد SHA على مستوى snapshot للمشروع ولا يعيد blob SHA مستقلاً لكل ملف. لذلك سجّلنا SHA المشروع وحالة المقارنة النصية، ولم نخترع SHA لملفات Lovable.
- نتيجة الملفات الحرجة:

| الملف | GitHub | Lovable | الحالة والأثر |
|---|---|---|---|
| `AGENTS.md` | `c248f30fcb99f2e95fa2d982b2bc6cb5c11e3943` | ضمن snapshot `34fdc2f...` | مختلف؛ نسخة GitHub تتضمن قواعد المشروع الموسعة للمساءلة والأدلة والموافقات. |
| `src/routes/index.tsx` | `f0f386f1e5c34cafe5e17924ece9d2e945cf3a78` | ضمن snapshot `34fdc2f...` | مختلف جوهرياً؛ Lovable route placeholder (23 سطراً)، وGitHub dashboard (317 سطراً). |
| `src/lib/domain.ts` | `35658aa7c6e1993405510cae23b60ba22df1c0bf` | ضمن snapshot `34fdc2f...` | مختلف؛ GitHub يتضمن Project Manager read-only و`canReadDocument` وإصلاح fail-closed؛ Lovable لا يتضمن قواعد الرؤية هذه. |
| `src/test/domain-rules.test.ts` | `fb6372fd8d5b977697ac91244b6c37112c83ad39` | ضمن snapshot `34fdc2f...` | مختلف؛ GitHub يتضمن اختبارات رؤية المسودات وProject Manager واختبار null-party الجديد. |
| `src/lib/i18n.tsx` | `95b590abcc309c3a13fc511e2ce1734e057656ca` | ضمن snapshot `34fdc2f...` | مختلف نصياً؛ فرق صغير في معالجة المفتاح الفارغ، يحتاج مراجعة call sites قبل المزامنة. |
| `src/lib/i18n-dict.ts` | `506e8e12f77b20fe141be4c4c20bf363192ceea6` | ضمن snapshot `34fdc2f...` | مختلف؛ 341 مفتاحاً في GitHub مقابل 384 في Lovable، و43 مفتاحاً في Lovable فقط؛ لا حذف قبل فحص الاستخدام. |
| `src/lib/import/excel.ts` | `56ae77e24359c1325e4aef9b12a53731e15d35d0` | ضمن snapshot `34fdc2f...` | مختلف؛ GitHub يفرض حدود الموارد ويحتوي تطبيع whitespace، ونسخة Lovable أقدم. |
| `src/test/excel-resource-limits.test.ts` | `2f141a7c6b9f1bbd1aac4da7e73cde66593aa89f` | مفقود | اختبار GitHub غير موجود في Lovable؛ 9 اختبارات حدود استيراد Excel غير ممثلة في snapshot Lovable. |
| `package.json` | `b0f3659e817da791b5089267621ffa62c7de31e0` | ضمن snapshot `34fdc2f...` | مختلف في scripts؛ إصدارات الاعتماديات المقارنة متطابقة. GitHub يضيف `typecheck` و`deploy:cloudflare`. |
| `vite.config.ts` | `b6b401f8964c29d310dc73626776f7ed3866e250` | ضمن snapshot `34fdc2f...` | مختلف؛ GitHub يحدد Cloudflare module وWorker name `sitedocs` وobservability=true. |
| `src/test/app-routing.test.tsx` | `6caef97e5b6f8520ec60294654fd07ad2490ec07` | ضمن snapshot `34fdc2f...` | مطابق حرفياً. |
| `src/routes/__root.tsx` | `32cee8af6a4f088afbe73fb0079e7681b5394cb2` | ضمن snapshot `34fdc2f...` | مطابق حرفياً. |
| migrations `0000`–`0003` | SHAs موثقة أدناه | ضمن snapshot `34fdc2f...` | متطابقة حرفياً في المقارنة المباشرة. |
| `supabase/config.toml` | `6ee0b58c3acef51427d7852500c794c553f14109` | ضمن snapshot `34fdc2f...` | مطابق حرفياً. |

**مقارنة migrations المباشرة:**
- `0000_core_schema.sql`: GitHub blob `6eeac6f0ddb29d77e0ab1320ac143bab6f834c47`; النصان 30,230 حرفاً ومتطابقان.
- `0001_triggers_and_rpcs.sql`: GitHub blob `667f793732f8841c4d8394721eb3128e04181c7f`; النصان 36,321 حرفاً ومتطابقان.
- `0002_storage_policies.sql`: GitHub blob `8b49fc98fdeb656a76a10d203187dbd316d06b9f`; النصان 721 حرفاً ومتطابقان.
- `0003_import_validation_and_kpi_buckets.sql`: GitHub blob `7f72ee1669c28d6724ee433e485c2d7e0208261c`; النصان 3,406 أحرف ومتطابقان.

الجرد الكامل السابق: GitHub 303 ملفات، Lovable 117، مشتركة 104، GitHub-only 199، Lovable-only 13. يجب حفظ ملفات Lovable-only وعدم فتح أو نسخ `.env`. لم تحدث مزامنة أو كتابة في Lovable أو branch switch أو استهلاك رصيد Agent أو نشر.

**خطة المعالجة:** GitHub يبقى المصدر المعتمد. لا نسخ شامل. الأولوية لمراجعة/مزامنة انتقائية للـroute/domain/tests/excel/config بعد تحليل الاعتماديات، مع إبقاء الملفات الـ13 الخاصة، وعدم حذف مفاتيح الترجمة الـ43 قبل تتبع call sites. لا يوجد إذن بتنفيذ مزامنة كتابية في هذا التشغيل.

### 13.5 Supabase المستهدف

- `get_project` للمشروع `jezpyxuxjzxotxjykhky` عبر اتصال SiteDocs رُفض برسالة permission denied.
- `list_projects` عبر الاتصال نفسه أعاد قائمة فارغة؛ لم يظهر المشروع المستهدف.
- لم تُستخدم أي قاعدة CRM أو قاعدة Lovable بديلاً، ولم تُنفذ SQL أو migrations أو أي تغييرات في RLS/Auth/Storage.
- لا توجد أدلة حية على حالة المشروع المستهدف أو migrations المطبقة أو سياساته.

### 13.6 Cloudflare — اتصال وقراءة فعلية

- Cloudflare API connection نجح، وتمت قراءة الحساب وقائمة Workers وsettings وscript-settings وdeployments عبر GET فقط.
- Worker `sitedocs` موجود؛ `compatibility_date=2026-11-13`، و`observability.enabled=false`، وbindings المعادة فارغة.
- آخر deployments المعادة مصدرها `dash_template`، وأحدث سجل منها بتاريخ 2026-11-13 09:02:20 UTC.
- إعداد GitHub في `vite.config.ts` يحدد Worker `sitedocs` و`observability.enabled=true`. توجد فجوة بين إعداد المصدر والـWorker الحي.
- CI build وWrangler dry-run ناجحان على SHA الإصلاح، لكنهما لا يثبتان نشر ذلك SHA إلى Worker. لم نغيّر Cloudflare ولم ننشر.

### 13.7 المراجعات الأسبوعية

- مهمة التطوير اليومية `تطوير ومراجعة SiteDocs يومياً` ما زالت مفعّلة.
- المراجعة الأسبوعية `متابعة أمان وتقدم مشروع Project Doc Control أسبوعياً` ما زالت مفعّلة، وموعدها القادم الثلاثاء 17 نوفمبر 2026، 19:00 بتوقيت الرياض.
- `متابعة مراجعة حزمة التصميم` ما زالت مفعّلة، وموعدها القادم الأربعاء 18 نوفمبر 2026، 09:00 بتوقيت الرياض.
- لم نغيّر جداول هذه المهام أو نوقفها.

### 13.8 العيوب والعوائق المفتوحة

- **P0:** لا يوجد تحقق حي من RLS/RPC/Storage أو سرية المسودات على Supabase المستهدف بسبب رفض الصلاحية. لا يُستعاض عن ذلك باختبارات الواجهة.
- **P1:** helper `canReadDocument` موجود ومختبر لكنه غير مستدعًى من `src/routes/index.tsx`؛ تكامل الرؤية الفعلي ما زال غير مثبت.
- **P1:** Lovable snapshot `34fdc2f...` لا يزال مختلفاً عن GitHub HEAD؛ لا كتابة/مزامنة آلية.
- **P1:** إعداد Worker الحي يختلف عن `vite.config.ts` في observability ومصدر deployment؛ لا تعديل إنتاجي.
- **P2:** حد السجل 500 وثيقة ما زال قائماً؛ إصلاح الاقتطاع السابق يوضح الحد ولا يضيف pagination.
- **P2:** عيب null-party في `availableActions` أُصلح واختُبر على SHA `0ee2d4d...`.

### 13.9 الخطوة التالية

1. مواصلة فحص مسار تحميل/عرض المستندات وتحديد موضع دمج `canReadDocument` دون اختراع هوية مستخدم أو صلاحيات من الواجهة.
2. إبقاء RLS/RPC/Storage كحاجز تشغيل حقيقي حتى يتاح وصول موثق للمشروع المستهدف وخطة backup/restore وموافقة مستقلة.
3. استكمال خطة Lovable الانتقائية للملفات الحرجة مع حفظ الملفات الخاصة؛ لا مزامنة عمياء.
4. إبقاء Worker الإنتاجي و`main` وقاعدة البيانات دون تغيير.


## 14. تشغيل 15 نوفمبر 2026 — تقوية خصوصية مخزن الملفات وصلاحيات دوال Trigger

**SHA عند بدء التشغيل:** `0beaf6f4742f67e7381b5dba84b8e886cfca15dc`  
**HEAD بعد إصلاحات الكود والاختبار:** `63fbffa976e5dcaf9e262933bcf3ac80860d808c`  
**الفرع:** `fix/cloudflare-workers-build-2026-11-13`

### 14.1 الإصلاح المرشح المنفذ على GitHub

أظهر تدقيق migration المرشحة `0004_p0_draft_confidentiality_and_audit.sql` أن سياسات RLS على `storage.objects` لا تكفي إذا كان bucket `document-files` عاماً؛ فالـpublic bucket يتجاوز حماية object-level RLS. كما كانت دالتا trigger-only `set_updated_at()` و`documents_guard_update()` تحتفظان بمنح EXECUTE الافتراضي.

**الإصلاح على فرع التطوير فقط:**
- أضيف إلى migration 0004 تحديث صريح يجعل `storage.buckets.public=false` للـbucket `document-files` عند تطبيق migration. لا تنشئ migration الـbucket إذا كان مفقوداً؛ اختبار القبول يفشل إذا لم يوجد.
- أزيل EXECUTE عن `set_updated_at()` و`documents_guard_update()` من PUBLIC وanon وauthenticated.
- أضيفت assertions مقابلة إلى `drizzle/tests/p0_draft_audit_rls.acceptance.sql`.
- أضيف اختبار مصدر ثابت من اختبارين إلى `src/test/security-migration-source.test.ts`، وأدرج ضمن lint في Quality Gate.
- صُحح تعبير assertion في commit لاحق قبل بوابة الجودة النهائية.

**الملفات وBlob SHAs:**
- `drizzle/migrations/0004_p0_draft_confidentiality_and_audit.sql`: `3cfc536df4955d8ab3bd0b89aa8011a2c6864ca8`
- `drizzle/tests/p0_draft_audit_rls.acceptance.sql`: `1fc8b5bfae7ae900a1c833b59f47a03e2c176972`
- `src/test/security-migration-source.test.ts`: `439f065aa40a53b75ff1d4fea2c0e02e11863662`
- `.github/workflows/quality-gate.yml`: `1f84bc23f12a6b46c41615c5ebaf4916bbe00385`

**Commits:**
- [7096e3f480fd01e2a06feb1e81b9640cfcbff361](https://github.com/mohannedabdo007-droid/sitedocs/commit/7096e3f480fd01e2a06feb1e81b9640cfcbff361) — تحديث migration واختبار القبول وQuality Gate.
- [63fbffa976e5dcaf9e262933bcf3ac80860d808c](https://github.com/mohannedabdo007-droid/sitedocs/commit/63fbffa976e5dcaf9e262933bcf3ac80860d808c) — تصحيح assertion المصدر الثابت.

### 14.2 بوابة الجودة على SHA واحد

على SHA `63fbffa976e5dcaf9e262933bcf3ac80860d808c` نجحت جميع الخطوات:

- [SiteDocs Quality Gate — Run 43745306508](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43745306508): TypeScript typecheck، ESLint، Vitest (**6 ملفات / 44 اختباراً**) وproduction build — كلها success.
- [Cloudflare Workers build check — Run 43745306515](https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43745306515): TanStack Start Cloudflare build وWrangler dry-run دون نشر — كلاهما success.

هذه الاختبارات تثبت سلامة بناء التطبيق واختبارات المصدر الثابت فقط؛ **لم تشغّل SQL acceptance على PostgreSQL** ولا تثبت RLS/Storage على قاعدة حية.

### 14.3 GitHub والفروع

- HEAD تحقق مباشرةً من Git ref: `63fbffa976e5dcaf9e262933bcf3ac80860d808c`.
- مقارنة فرع التطوير مع `main`: **707 commits ahead و2 behind**؛ الحالة diverged. لا merge ولا تغيير في `main`.
- لا يوجد PR مفتوح مصدره فرع التطوير الحالي. توجد PRs أخرى مفتوحة بالمستودع، منها PR #17 يستهدف فرع التطوير.
- قراءة branch protection وrepository rulesets رُفضت بـ403؛ لذلك لا يمكن تأكيد حالة الحماية الحالية من هذا الاتصال. لم تُغيّر إعدادات الحماية.

### 14.4 مطابقة GitHub وLovable

- GitHub HEAD: `63fbffa976e5dcaf9e262933bcf3ac80860d808c`.
- Lovable project: `8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`، snapshot SHA: `34fdc2f274c183513671f3cf8ab38cc40c555731`، والحالة Ready.
- الجرد: **GitHub 311 ملفاً، Lovable 117 ملفاً، 104 ملفات مشتركة، 207 ملفات GitHub-only، و13 ملفاً Lovable-only**.
- مقارنة الملفات الحرجة بالنص الفعلي:

| الملف | نتيجة المقارنة | الأثر |
|---|---|---|
| `AGENTS.md` | مختلف | تعليمات GitHub أحدث وأوسع |
| `src/routes/index.tsx` | مختلف جوهرياً | GitHub dashboard فعلي؛ Lovable placeholder |
| `src/lib/domain.ts` | مختلف | Lovable لا يحتوي Project Manager read-only وcanReadDocument وfail-closed guard |
| `src/test/domain-rules.test.ts` | مختلف | اختبارات الرؤية وnull-party في GitHub غير موجودة في Lovable |
| `src/lib/i18n.tsx` | مختلف | فرق في معالجة المفتاح الفارغ |
| `src/lib/i18n-dict.ts` | مختلف | 341 مفتاحاً في GitHub مقابل 384 في Lovable؛ 43 مفتاحاً Lovable-only |
| `src/lib/import/excel.ts` | مختلف | Lovable أقدم ويفتقد حدود الموارد وتطبيع العناوين الحالي |
| `src/test/excel-resource-limits.test.ts` | مفقود في Lovable | اختبارات حدود الاستيراد غير ممثلة |
| `package.json` | مختلف | scripts مختلفة؛ إصدارات الاعتماديات المقارنة متطابقة |
| `vite.config.ts` | مختلف | إعداد Cloudflare Worker في GitHub غير موجود في Lovable |
| `src/test/app-routing.test.tsx` | مطابق | — |
| `src/routes/__root.tsx` | مطابق | — |
| `src/test/setup.ts` و`src/router.tsx` | مطابقان | — |
| migrations `0000`–`0003` | متطابقة حرفياً | لا فرق نصياً |
| migration `0004_p0_draft_confidentiality_and_audit.sql` | مفقودة في Lovable | إصلاح P0 المرشح غير موجود في snapshot |
| `supabase/config.toml` | مطابق | — |

لا يعيد Lovable blob SHA مستقلاً لكل ملف؛ لذلك أُثبتت حالة المقارنة النصية وربطها بـsnapshot SHA فقط. الملفات الـ13 الخاصة في Lovable محفوظة دون تغيير؛ لم يُفتح `.env` ولم تتم أي مزامنة أو كتابة أو branch switch أو نشر.

**خطة المزامنة:** لا نسخ شامل. تبقى ملفات Lovable-only محفوظة، ويُؤجل نقل الملفات الحرجة إلى مزامنة انتقائية بعد مراجعة الاعتماديات و43 مفتاح ترجمة إضافياً. لا كتابة في Lovable دون إذن مستقل.

### 14.5 Supabase المستهدف

- تمت إعادة محاولة قراءة المشروع المحدد حصراً `jezpyxuxjzxotxjykhky` عبر اتصال SiteDocs؛ النتيجة **permission denied**.
- لم تُستخدم أي قاعدة أخرى أو CRM أو قاعدة Lovable بديلاً.
- لم تُنفذ SQL أو migrations أو أي تغييرات في قاعدة البيانات أو RLS أو Storage أو Auth.
- migration 0004 ما زالت مرشحة في GitHub فقط، ولم تُطبق على قاعدة حية ضمن هذا التشغيل.

### 14.6 Cloudflare

- نجحت قراءة Worker `sitedocs` وإعداداته عبر GET.
- `compatibility_date=2026-11-13`، و`observability.enabled=false`، ولا توجد bindings ظاهرة في الإعدادات المعادة.
- أحدث deployment ظاهر مصدره `dash_template` بتاريخ `2026-11-13T09:02:20Z`.
- إعداد GitHub في `vite.config.ts` يحدد `observability.enabled=true`؛ عدم التطابق ما زال مفتوحاً. لا تعديل إعدادات ولا نشر.

### 14.7 دورة العمل الأسبوعية

- مهمة التطوير اليومية ما زالت مفعّلة.
- مراجعة الأمان والتقدم الأسبوعية ما زالت مفعّلة؛ موعدها القادم **الثلاثاء 17 نوفمبر 2026، 19:00 بتوقيت الرياض**.
- مراجعة حزمة التصميم ما زالت مفعّلة؛ موعدها القادم **الأربعاء 18 نوفمبر 2026، 09:00 بتوقيت الرياض**.
- لم تُعدّل جداول المهام أو تُوقف.

### 14.8 العيوب والعوائق المفتوحة

- **P0 — OPEN:** migration 0004 واختبار القبول لم يُنفذا على PostgreSQL معزول؛ لا دليل حي على RLS أو Storage أو ACL أو signed URLs.
- **P0 — OPEN:** الوصول إلى Supabase المستهدف مرفوض؛ لا يمكن تأكيد migrations المطبقة أو حالة bucket الحية.
- **P1 — OPEN:** Lovable مختلف عن GitHub في الملفات الحرجة وSHA؛ لم تتم المزامنة.
- **P1 — OPEN:** إعداد Worker الحي لا يطابق إعداد GitHub؛ لم يحدث نشر.
- **P1 — OPEN:** branch protection/rulesets غير قابلين للقراءة عبر اتصال GitHub الحالي.
- **P1 — OPEN:** واجهة `src/routes/index.tsx` لا تستدعي `canReadDocument`؛ لا يُعتمد helper الواجهة كحاجز أمني، وتبقى RLS على قاعدة البيانات هي الحاجز المطلوب بعد التحقق.
- **P2 — OPEN:** سجل الوثائق يعرض أحدث 500 وثيقة مع تنبيه؛ لا توجد pagination كاملة بعد.

### 14.9 الخطوة التالية

1. الحصول على صلاحية قراءة المشروع `jezpyxuxjzxotxjykhky` أو توفير بيئة PostgreSQL معزولة موثقة، ثم تشغيل migration المرشحة واختبارات SQL/PostgREST/Storage/signed URL على fixtures اصطناعية فقط.
2. مراجعة صلاحيات RLS وRPC الحية قبل أي قرار تطبيق؛ لا تغيير DB أو migrations مطبقة دون موافقة صريحة.
3. متابعة reconciliation انتقائي لـLovable مع الحفاظ على الملفات الخاصة.
4. معالجة فجوة Worker بعد مراجعة إعدادات النشر، دون تغيير الإنتاج.
5. عدم الدمج إلى `main` أو النشر أو مزامنة Lovable كتابةً دون إذن مستقل.
