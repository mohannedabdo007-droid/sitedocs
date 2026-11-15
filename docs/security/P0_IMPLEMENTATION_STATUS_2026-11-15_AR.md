# SiteDocs — تقرير تنفيذ معالجة P0-1 وP0-2
**التاريخ:** 2026-11-15  
**الفرع:** `fix/cloudflare-workers-build-2026-11-13`  
**SHA الكود/الاختبارات قبل تحديث هذا التقرير:** `06e3b535307f9f64316c35612c6d040935f02fe1`  
**SHA تعليمات التشغيل والاختبار:** `d9e5be8825e77cb545bbba11fc92d64b7702ce88`  
**P0-1 / P0-2:** OPEN — NOT VERIFIED, NOT CLOSED.

## 1. فصل مدير المشروع عن مدير الشركة

### مدير المشروع
- أضيف الحقل `project_members.is_project_manager BOOLEAN NOT NULL DEFAULT false`.
- صفة مدير المشروع لا تستنتج من `project_role='viewer'` أو `party='pmc'`.
- التعيين الإشرافي منفصل عن `project_role`، ولا يمنح صلاحية إدارة المشروع أو تحرير الوثائق أو التعليق أو انتقال سير العمل.
- يستطيع مدير المشروع المعين صراحةً قراءة وثائق المشروع ومسوداته وبياناتها التابعة، بما فيها المرفقات ونتائج OCR وسجل التدقيق المسموح به، دون كتابة.
- يمكن تعيين أكثر من مدير إشرافي حالياً؛ إذا كان المطلوب مديراً واحداً فقط فهذا يحتاج قيداً وظيفياً منفصلاً.

### مدير الشركة
- استبدلت migration المرشحة `project_role_of()` بحيث تقرأ عضوية `project_members` الصريحة فقط.
- عضوية `company_members.role IN ('owner','admin')` لا تنشئ عضوية مشروع ولا ترث `project_role='admin'`.
- من ينشئ مشروعاً عبر `create_project()` يحصل على عضوية مشروع admin صريحة عند الإنشاء؛ هذا تفويض مشروع مستقل وليس توريثاً تلقائياً.

## 2. الإصلاحات المرشحة في migration 0004

الملف: `drizzle/migrations/0004_p0_draft_confidentiality_and_audit.sql`

1. مصدر تفويض موحد `can_read_document()` يربط القراءة بحالة الوثيقة والطرف والخطوة الحالية:
   - المسودة: المنشئ وأعضاء الطرف المنشئ ومدير المشروع المعين صراحةً.
   - submitted/under_review: الطرف المنشئ والطرف المكلف بالخطوة الحالية ومدير المشروع.
   - returned: الطرف المنشئ ومدير المشروع.
   - approved/closed: أطراف مسار workflow ومدير المشروع.
2. صلاحيات كتابة مستقلة على مستوى الوثيقة: `can_create_document()`, `can_edit_document()`, `can_attach_document()`, `can_comment_document()`.
3. استبدال سياسات insert/update العامة للوثائق والإصدارات والتعليقات والمرفقات بسياسات مرتبطة بالوثيقة والمنشئ والطرف والحالة.
4. RPC `transition_document()`: منع تجاوز admin للطرف الحالي، قصر التقديم على المنشئ، منع المنشئ من مراجعة وثيقته، وقصر الإغلاق على الطرف النهائي (أو الطرف المنشئ إذا لم تتطلب الوثيقة مراجعة).
5. Storage: القراءة تتطلب attachment مسجلاً ووثيقة يحق للمستخدم رؤيتها؛ والرفع يتطلب attachment مسجلاً وصلاحية رفع على الوثيقة.
6. Audit: allowlist منفصلة حسب نوع الكيان، تستبعد النصوص الحرة ومحتوى التعليقات وملاحظات المراجعة ومسارات/أسماء الملفات وبيانات الاستيراد الخام. أحداث import_batches مقيدة بمنشئ الدفعة أو مدير مشروع مخول.
7. منع مسارات جانبية عبر import staging وOCR: صفوف الاستيراد وسجلها محصور بمنشئ الدفعة/مدير مشروع مخول، وOCR يرث صلاحية قراءة الوثيقة المرتبطة بالمرفق.
8. إزالة EXECUTE الافتراضي من PUBLIC/anon عن RPCs الحساسة ودوال المساعدة وtrigger-only SECURITY DEFINER، مع منح authenticated عند الحاجة.

تم تسجيل migration في `drizzle/migrations/meta/_journal.json` وإضافة `0004_snapshot.json` وفق نمط ملفات snapshots السابقة في المستودع.

## 3. الاختبارات المضافة

- `drizzle/tests/p0_draft_audit_rls.acceptance.sql`
- `drizzle/tests/README_P0_DRAFT_AUDIT.md`

تغطي SQL fixtures بهويات JWT مستقلة:
- المنشئ وعضو الطرف المنشئ.
- عضو `pmc` غير معين مديراً للمشروع.
- مدير مشروع صريح بدور viewer.
- مدير شركة دون عضوية مشروع.
- المراجع الحالي.
- مستخدم من مستأجر آخر.

وتشمل اختبارات:
- قراءة المسودات والوثائق المقدمة حسب الطرف/الخطوة.
- منع تعديل مسودة الغير ومنع PM من الكتابة أو RPC.
- منع توريث دور المشروع لمدير الشركة.
- منع تسريب audit payload والحقول غير المسموحة.
- منع الوصول إلى Storage وimport batches/rows وOCR من الأطراف غير المخولة.
- التحقق من ACL لدوال RPC الحساسة.
- السماح للمنشئ بتقديم وثيقته ومنع عضو آخر من الطرف نفسه من تقديمها نيابة عنه.

اختبارات PostgREST وStorage signed URL وupload وACL الفعلية ما زالت مطلوبة بجلسات JWT مستقلة؛ ملف SQL لا يثبت سلوك إصدار الروابط الموقعة.

## 4. ما تم التحقق منه وما لم يتم

### تحقق ثابت عبر GitHub
- تم حفظ migration والاختبارات والتوثيق على فرع التطوير.
- تمت مراجعة أسماء السياسات القديمة للتأكد من إسقاط السياسات العامة قبل إنشاء السياسات الأضيق.
- تمت مراجعة حدود الدوال وكتل SQL نصياً، ولا توجد delimiters ناقصة في آخر مراجعة ثابتة.
- تمت مراجعة تزامن أنواع TypeScript مع حقل `is_project_manager`.

هذا فحص مصدر ثابت فقط؛ لا يساوي تنفيذ SQL أو اختبار PostgreSQL.

### لم يُنفذ — بوابة الإغلاق
- اتصال Supabase SiteDocs استطاع عرض المنظمة، لكن قائمة المشاريع أعادت قائمة فارغة (لا يظهر مشروع SiteDocs عبر هذا الاتصال).
- `get_project(jezpyxuxjzxotxjykhky)` و`list_branches(jezpyxuxjzxotxjykhky)` أعادا رفض صلاحية.
- لذلك لم يمكن إنشاء Development Branch أو الوصول إلى قاعدة اختبار معزولة.
- لم تُطبق migration على أي قاعدة.
- لم تُشغّل اختبارات SQL أو PostgREST أو Storage أو OCR.
- لم تُفحص routine privileges / live ACL في PostgreSQL.
- لم تُختبر signed URL أو مسار upload.
- لم تُسجل أي حالة PASS.
- لم تظهر GitHub Status Checks أو Workflow Runs قابلة للاستناد إليها في آخر فحص؛ لا توجد نتيجة CI مؤكدة لهذا التغيير.

وعليه، **P0-1 وP0-2 لا يزالان مفتوحين** حتى تتوفر قاعدة معزولة وتنجح الاختبارات مع أدلة.

## 5. حدود الأمان

- جميع تغييرات GitHub على فرع التطوير فقط.
- لا تعديل على قاعدة SiteDocs الحية أو Storage الحي.
- لا نشر إلى الإنتاج.
- لا دمج إلى `main`.
- لا استخدام `service_role` كبديل لاختبار صلاحيات المستخدمين.
- لا يُسمح بتطبيق migration على قاعدة حية قبل backup موثق واختبار استعادة وموافقة صريحة.

## 6. ملفات العمل

- `drizzle/migrations/0004_p0_draft_confidentiality_and_audit.sql`
- `drizzle/migrations/meta/_journal.json`
- `drizzle/migrations/meta/0004_snapshot.json`
- `drizzle/tests/p0_draft_audit_rls.acceptance.sql`
- `drizzle/tests/README_P0_DRAFT_AUDIT.md`
- `src/integrations/supabase/types.ts`
- `docs/security/ROLE_PERMISSION_MATRIX_DRAFT_CONFIDENTIALITY_AR.md`
- `docs/security/P0_DRAFT_AUDIT_ACCEPTANCE_TEST_PLAN_AR.md`

**قرار الحالة:** Candidate implementation expanded and reviewed statically; P0-1 and P0-2 remain open pending isolated PostgreSQL execution and passing API/Storage evidence.
