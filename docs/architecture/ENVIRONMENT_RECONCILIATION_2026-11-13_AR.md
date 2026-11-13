# تقرير مطابقة بيئات SiteDocs — 2026-11-13

## النطاق والمرجع
- المستودع: `mohannedabdo007-droid/sitedocs`
- فرع التطوير: `fix/cloudflare-workers-build-2026-11-13`
- SHA GitHub المفحوص: `232b975cba208d03c5587bc779f6ce0f8cc7ef89`
- مشروع Lovable: `Project Doc Control` (`8f8e1a3c-893d-4e20-aca8-f0e9fe9a169c`)
- SHA Lovable المفحوص: `34fdc2f274c183513671f3cf8ab38cc40c555731`

GitHub هو مرجع الشفرة. لا يثبت اتصال Lovable بالمستودع أن ملفات المشروع متزامنة معه.

## نتائج الاختبارات على SHA GitHub
نجح Quality Gate على SHA المذكور:
- TypeScript typecheck
- Lint
- Unit tests
- Production application build

ونجح Cloudflare Build Check على SHA نفسه:
- TanStack Start build for Cloudflare
- Wrangler deployment bundle validation (بدون نشر)

روابط التشغيل:
- https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43503320195
- https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43503320237

## مطابقة الملفات الحرجة مع Lovable
تمت قراءة المحتوى الفعلي من الطرفين ومقارنة الملفات التالية:

| الملف | GitHub | Lovable | النتيجة |
|---|---:|---:|---|
| src/routes/index.tsx | 20,946 حرفاً / 317 سطراً | 694 حرفاً / 23 سطراً | اختلاف جوهري؛ Lovable placeholder |
| src/lib/domain.ts | 4,626 / 111 | 3,513 / 82 | اختلاف قواعد المجال |
| src/lib/i18n.tsx | 3,235 / 92 | 3,213 / 90 | اختلاف |
| src/lib/import/excel.ts | 2,665 / 72 | 2,664 / 71 | اختلاف صغير |
| package.json | 3,456 / 105 | 3,357 / 102 | اختلاف scripts/dependencies |
| vite.config.ts | 1,274 / 31 | 1,046 / 18 | اختلاف إعدادات البناء |
| src/test/domain-rules.test.ts | 8,782 / 203 | 6,751 / 153 | تغطية اختبار أقل في Lovable |
| AGENTS.md | 4,496 / 50 | 1,462 / 30 | تعليمات تطوير أقل في Lovable |

لم تتم أي كتابة إلى Lovable. سبب الامتناع أن استبدال الملفات الآن قد يزيل إعدادات ومكونات محلية ويعيد placeholder إلى مسار التشغيل أو يغيّر تكوين البناء. المطلوب خطة مزامنة واعية لكل ملف مع الحفاظ على ملفات Lovable غير الموجودة في GitHub، ثم اختبار نسخة موحدة.

## Cloudflare
الاتصال بالحساب ناجح. Worker `sitedocs` موجود، لكن سجل النشر وبيانات النسخة الحالية يبيّنان:
- `last_deployed_from = dash_template`
- مصدر النسخة `dash`
- trigger = `upload`
- لا يوجد دليل ربط للنسخة المنشورة مع SHA GitHub أو workflow run.

إذن نجاح Cloudflare Build Check يثبت صلاحية بناء الحزمة والتحقق منها فقط، ولا يثبت أن Worker المنشور يشغّل SHA التطوير. لم يحدث أي نشر أو تعديل إعدادات.

## Supabase
تمت محاولة قراءة المشروع المستهدف `jezpyxuxjzxotxjykhky` مباشرة، والنتيجة `permission denied`.
قائمة المشاريع المتاحة للاتصال أعادت مشروعاً آخر فقط: `ndbcldrgrfkecqryscba`. لم يُستخدم بديلاً ولم تُجرَ عليه أي قراءة بيانات أو تغييرات. لا يمكن إثبات اتصال المشروع المستهدف أو اختبار RLS/Auth/Storage عبر هذا الاتصال الحالي.

## ملاحظة حوكمة على Knowledge في Lovable
نص Project Knowledge يحتوي فقرة قديمة تعرّف RFI بأنه Request for Inspection وتعرّف CIVSTR كدمج Civil & Structural، بينما القرارات الأحدث المعتمدة في المشروع تعتبر RFI = Request for Information والتخصصات الخمسة المنفصلة Mec/Arc/Civ/Surve/Ele. يجب تصحيح هذا التعارض في Knowledge لاحقاً، دون إعادة فتح القرارات الوظيفية المعتمدة. لم يتم تعديل Knowledge في هذه المراجعة.

## قرارات الحماية المتبعة
- لا تعديل لقاعدة البيانات أو migrations.
- لا نشر إلى Cloudflare production.
- لا تعديل لفرع main أو دمج.
- لا مزامنة كتابة إلى Lovable.
- لا استخدام لمشروع Supabase غير المستهدف.

## شروط إغلاق المطابقة
1. منح صلاحية قراءة للمشروع Supabase المستهدف أو إصلاح ربط الحساب الذي يملك الوصول، ثم التحقق من المشروع الصحيح فقط.
2. مزامنة Lovable بخطة ملفية، مع حفظ الملفات الإضافية وملفات إعداداته وعدم استخدام استبدال شامل.
3. تحديث Project Knowledge لإزالة التعارضات القديمة بعد مراجعة الملفات المتأثرة، مع إبقاء القرارات المعتمدة كما هي.
4. إثبات أن Worker المنشور مصدره commit محدد، بعد موافقة منفصلة على النشر إن لزم.
5. إعادة جميع الاختبارات على SHA موحد، وإجراء اختبارات تكامل حقيقية عند توافر Supabase.

**الحالة: غير مغلقة.** نجاح CI لا يعوّض عدم تطابق النسخ أو غياب إثبات البيئة الحية.
