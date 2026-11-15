# SiteDocs — تقرير تنفيذ معالجة P0-1 وP0-2
**التاريخ:** 2026-11-15  
**الفرع:** `fix/cloudflare-workers-build-2026-11-13`  
**الحالة:** Patch committed to development branch; database execution and acceptance tests blocked.  
**آخر SHA بعد إعداد الـ patch:** `e746c391d20f7bf7bbb12e4b8a1b0fcda2ce24d6`  
**P0-1 / P0-2:** OPEN — NOT VERIFIED, NOT CLOSED.

## 1. ما أُنجز في المستودع

أُضيفت migration مرشحة:

- `drizzle/migrations/0004_p0_draft_confidentiality_and_audit.sql`

وتتضمن:
1. إضافة `project_members.is_project_manager` كتعيين إشرافي صريح، مستقل عن `project_role`.
2. إزالة التوريث التلقائي لدور project admin من عضوية مالك/مدير الشركة؛ عضوية المشروع يجب أن تكون صريحة.
3. إضافة `can_read_document(document_id)` كمصدر قرار مركزي: منشئ الوثيقة، أعضاء الطرف المنشئ للمسودة، ومدير المشروع المعين صراحةً يستطيعون القراءة؛ بقية الأطراف لا تستطيع قراءة المسودة.
4. ربط RLS للوثائق والإصدارات والمراجعات والتعليقات والمرفقات بالتحقق من الوثيقة الأصلية.
5. تقييد سجل التدقيق: كل حدث مرتبط بوثيقة يرث صلاحية قراءة الوثيقة، مع إبقاء نطاق مستقل لأحداث المشروع/الشركة غير المرتبطة بوثيقة.
6. تقوية Storage: لا تُقرأ ملفات bucket `document-files` إلا بوجود attachment مسجل يطابق المسار والمشروع والوثيقة التي يملك المستخدم صلاحية قراءتها.
7. تقليل حقول وثيقة التدقيق المحفوظة، ومنع تسجيل description/location/metadata وحقول استيراد داخل سجل التدقيق.
8. إزالة تجاوز admin للطرف الحالي في RPC `transition_document`، ومنع المنشئ من بدء مراجعة وثيقته أو الرد عليها، وتقييد EXECUTE للـ RPC.

تم تسجيل migration في `drizzle/migrations/meta/_journal.json` وإضافة snapshot مطابق لنمط snapshots الحالية.

## 2. الاختبارات المضافة

- `drizzle/tests/p0_draft_audit_rls.acceptance.sql`
- `drizzle/tests/README_P0_DRAFT_AUDIT.md`

تتضمن الحزمة اختبارات SQL بهويات JWT اصطناعية للمنشئ، وعضو الطرف المنشئ، وطرف آخر، ومدير المشروع، ومدير الشركة دون عضوية مشروع، ومستخدم مستأجر آخر. وتغطي قراءة المسودات والوثائق المقدمة والـ child rows وسجل التدقيق وStorage، ومنع تعديل/انتقال مدير المشروع، ومنع الاعتماد الذاتي.

تبقى اختبارات PostgREST وStorage signed URL وACL الفعلية مطلوبة وفق README؛ ملف SQL وحده لا يثبت سلوك إصدار الروابط الموقعة.

## 3. اتساق الأنواع والتوثيق

- تم تحديث `src/integrations/supabase/types.ts` لإضافة الحقل الجديد إلى نوع `project_members`.
- تم تصحيح مصفوفة الصلاحيات لتتفق مع القرار المعتمد: المسودة متاحة لمنشئها وأعضاء الطرف المنشئ، ومدير المشروع المعين صراحةً للقراءة فقط.
- تم توسيع خطة حالات السماح والمنع وربطها بمصفوفة الصلاحيات.

## 4. ما لم يُنفذ — بوابة الإغلاق

حاولنا الوصول إلى مشروع Supabase الصحيح `jezpyxuxjzxotxjykhky` عبر اتصال SiteDocs للتحقق من المشروع وإنشاء فرع قاعدة تطوير معزول. أعاد الاتصال رفض صلاحية الوصول. لذلك:

- لم تُنشأ قاعدة اختبار معزولة.
- لم تُطبق migration على أي قاعدة.
- لم تُشغّل اختبارات SQL أو PostgREST أو Storage.
- لم تُفحص routine privileges / live ACL في PostgreSQL.
- لم تُختبر signed URL.
- لم تُسجل أي حالة PASS.
- لم تظهر GitHub Status Checks أو Workflow Runs لهذا الـ SHA عند آخر تحقق؛ لذلك لا توجد نتيجة CI يمكن نسبتها إليه.

وعليه، لا يجوز إعلان إغلاق P0-1 أو P0-2 حتى تتوفر صلاحية Supabase لفرع تطوير مستقل، وتُطبق migration هناك، وتُشغّل الاختبارات مع حفظ الأدلة.

## 5. حدود الأمان

- جميع تغييرات GitHub على فرع التطوير فقط.
- لا تعديل على قاعدة SiteDocs الحية أو Storage الحي.
- لا نشر إلى الإنتاج.
- لا دمج إلى `main`.
- لا استخدام `service_role` كبديل لاختبار صلاحيات المستخدمين.

## 6. ملفات العمل

- `drizzle/migrations/0004_p0_draft_confidentiality_and_audit.sql`
- `drizzle/migrations/meta/_journal.json`
- `drizzle/migrations/meta/0004_snapshot.json`
- `drizzle/tests/p0_draft_audit_rls.acceptance.sql`
- `drizzle/tests/README_P0_DRAFT_AUDIT.md`
- `src/integrations/supabase/types.ts`
- `docs/security/ROLE_PERMISSION_MATRIX_DRAFT_CONFIDENTIALITY_AR.md`
- `docs/security/P0_DRAFT_AUDIT_ACCEPTANCE_TEST_PLAN_AR.md`

**قرار الحالة:** Implementation patch prepared; P0-1 and P0-2 remain open pending isolated database execution and passing evidence.
