# سجل قرار معماري — بوابة SiteDocs MCP
**التاريخ:** 2026-11-14  
**الحالة:** نُشرت نسخة Worker مستقلة، واجتاز فحص HTTP الأساسي؛ اختبار MCP المصادق عليه ومصافحة البروتوكول ما زالا مطلوبين.

## القرار
تشغيل خدمة MCP مستقلة باسم `sitedocs-mcp-gateway` على Cloudflare Workers، منفصلة عن Worker تطبيق SiteDocs وإعدادات إنتاجه. تستخدم Cloudflare Agents SDK (`createMcpHandler`) ونقل Streamable HTTP على المسار `/mcp`.

## الحالة التشغيلية المثبتة
- Worker مستقل موجود في Cloudflare باسم `sitedocs-mcp-gateway`.
- عنوان الخدمة: https://sitedocs-mcp-gateway.mohanned-abdo007.workers.dev
- نسخة Worker المنشورة: `34f025c4-a041-4b8f-ad95-01c41063e13a`.
- سجل التوزيع: `07e17c34-a84c-4b4f-9bbe-c13abae11404`، بنسبة 100% لهذه النسخة.
- تم اكتشاف أن إتاحة workers.dev كانت معطلة (`enabled=false`). فُعّلت للخدمة فقط، مع إبقاء روابط المعاينة معطلة (`previews_enabled=false`)، ثم تمت قراءة الإعداد مجدداً وتأكدت القيمة `enabled=true`.
- فحص خارجي حي لـ `GET /health`: HTTP 200، والجسم:
  `{"status":"ok","service":"sitedocs-mcp-gateway","version":"0.1.0"}`.
- فحص خارجي غير مصادق لـ `GET /mcp`: HTTP 401 مع `unauthorized`، وهو السلوك الأمني المتوقع.
- إعداد Cloudflare يعرض `GATEWAY_BEARER_TOKEN` كـ `secret_text`؛ لا تُقرأ قيمة السر ولا تُعرض.
- CI السابق للبوابة نجح على GitHub Actions run: https://github.com/mohannedabdo007-droid/sitedocs/actions/runs/43509932322

## ما لم يثبت بعد
- لم تُنفذ حتى الآن مصافحة MCP `initialize` عبر POST من عميل خارجي.
- لم يثبت قبول Bearer token الصحيح أو استدعاء الأدوات المصادق عليها عبر عميل MCP فعلي.
- الأدوات الثلاث الموجودة حالياً هي `health_check` و`integration_status` و`gateway_capabilities` فقط؛ لا توجد بعد موصلات فعلية متصلة بـ GitHub أو Cloudflare أو Supabase أو Lovable داخل Gateway.
- لذلك الخدمة متاحة على HTTP وتطبق رفض الوصول غير المصادق، لكنها ليست بعد منصة تنفيذ مهام متعددة الأدوات مكتملة.

## الضوابط الأمنية
1. ابدأ بأدوات القراءة فقط وقوائم سماح دقيقة.
2. الأسرار في Cloudflare Secrets حصراً؛ يمنع إدراجها في Git أو السجلات أو المحادثات.
3. لا عمليات كتابة على قاعدة البيانات أو migrations أو نشر إنتاجي أو دمج إلى `main` دون موافقة صريحة.
4. لا يُعد نجاح CI أو رفع نسخة Worker دليلاً على نجاح مصافحة MCP.
5. سجّل اسم الأداة والفاعل والهدف والقرار والنتيجة دون أسرار أو حمولات حساسة.
6. ارفض الأدوات غير المعروفة والمدخلات غير المتوقعة.

## خطة الربط
- GitHub: قراءة الفرع المعتمد والـ commits ونتائج CI أولاً، مع نطاق محدود.
- Cloudflare: قراءة حالة Worker وإصداراته وسجلاته، دون تغيير إعدادات الإنتاج.
- Supabase: لا ربط قبل توفر صلاحية للمشروع الصحيح `jezpyxuxjzxotxjykhky`؛ لا تستبدله بمشروع آخر.
- Lovable: استخدام API مدعوم ومصرح فقط، مع المحافظة على ملفات Lovable وعدم المزامنة العمياء.

## معايير قبول التشغيل الكامل
- نجاح `GET /health` من عميل خارجي.
- رفض الطلب غير المصادق عليه على `/mcp` بـ 401.
- نجاح MCP `initialize` باستخدام Bearer token صحيح.
- نجاح `tools/list` ثم تنفيذ `health_check` و`integration_status` و`gateway_capabilities`.
- اختبار رفض أداة غير مسموحة وعدم كشف الأسرار.
- توثيق نتيجة كل اختبار مع الوقت والنسخة المستخدمة.

## غير مسموح في هذه المرحلة
لا تغيير Worker تطبيق SiteDocs الحالي، ولا إعدادات الإنتاج أو DNS، ولا قاعدة البيانات أو migrations، ولا `main`، ولا مزامنة ملفات Lovable دون diff كامل وخطة تحفظ الملفات الخاصة.
