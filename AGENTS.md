<!-- LOVABLE:BEGIN -->
> [!IMPORTANT]
> This project is connected to [Lovable](https://lovable.dev). Avoid rewriting
> published git history — force pushing, or rebasing/amending/squashing commits
> that are already pushed — as it rewrites history on Lovable's side and the
> user will likely lose their project history.
>
> Commits you push to the connected branch sync back to Lovable and show up in
> the editor, so keep the branch in a working state.

## What Lovable manages

Rules outside this block are the project's own. Change the pieces below in
Lovable, not by hand. With the [Lovable MCP](https://mcp.lovable.dev)
connected, `send_message` asks Lovable to do it; otherwise ask the user to
use the editor.

- **Database.** Do not add or edit `supabase/migrations/` or `drizzle/`.
  Ask Lovable to change the schema.
- **Generated files.** Do not edit a file whose header says it is automatically
  generated.
- **AI gateway.** Keep model calls on Lovable's gateway, and keep
  `LOVABLE_API_KEY` out of browser code.
- **Connectors.** Lovable provides native connectors. `list_connectors` shows
  which are enabled; `add_connector` only returns the dashboard link. When a
  connector is enabled, calls go through the connector gateway and need
  `LOVABLE_API_KEY`. When Lovable does not provide one, users can bring their
  own key and store it in Secrets.
- **Secrets.** Lovable manages them. Do not put secret values in the repo.
<!-- LOVABLE:END -->


# تعليمات دائمة — المساءلة وجودة التنفيذ

هذه التعليمات ملزمة للجميع دون استثناء: صاحب المشروع ليس مطالباً بتخفيف حذره، وكل مطوّر أو مهندس أو مراجع أو مساهم بشري، وكل مساعد ذكاء اصطناعي أو وكيل آلي أو سير عمل أو أداة تنفيذ تشارك في التحليل أو التصميم أو البرمجة أو الاختبار أو المراجعة أو النشر أو التشغيل على SiteDocs. تسري هذه القواعد عبر جميع المحادثات والقنوات والأدوات ومراحل العمل، ولا يعفي أي طرفٍ منها اختلاف دوره أو أداته أو مصدر تكليفه. على كل طرف قراءتها وتطبيقها، وعلى منسّق العمل التأكد من التزام الأطراف التي يوجّهها بها. تُقرأ مع قرارات المشروع وسجل التنفيذ اليومي. عند التعارض، تُحترم قيود الأمان والموافقات الصريحة وقرارات صاحب المشروع المعتمدة.

1. **القرارات المعتمدة مرجع ملزم:** راجع القرارات والاتفاقات السابقة قبل السؤال أو التنفيذ. لا تعِد فتح قرار حُسم، ولا تطلب من صاحب المشروع إعادة اعتماد ما اعتمده بالفعل.
2. **تحقق قبل التصريح:** لا تقل «تم» أو «نجح» أو «اكتمل» إلا بعد تنفيذ الإجراء والتحقق من نتيجته الفعلية. النية أو بدء العملية أو وجود commit لا يثبت نجاح الاختبار أو النشر.
3. **كل ادعاء تنفيذي له دليل:** اربط نتائج GitHub Actions بالفرع وSHA المطابقين، واذكر رابط التشغيل وحالة الوظيفة والخطوات ذات الصلة. اربط كل تعديل برابط commit والملفات التي تغيرت. لا تستخدم نتائج تشغيل قديم لإثبات حالة SHA أحدث.
4. **افصل الحقائق عن الاستنتاجات:** صنّف بوضوح ما تم التحقق منه، وما لم يتم التحقق منه، وما تعذر تنفيذه، وسبب التعذر. لا تخلط نجاح lint/tests/build مع نجاح النشر أو سلامة قاعدة البيانات أو RLS أو تطابق Lovable.
5. **لا تخفِ عدم اليقين ولا تبالغ في الثقة:** إذا كانت الأدلة ناقصة أو الأداة لا تتيح التحقق، قل ذلك صراحة. لا تخمّن SHA أو حالة فرع أو محتوى ملف أو نتيجة اختبار.
6. **التنفيذ المستقل الآمن:** بادر بالفحص والتنفيذ والاختبار والإصلاح ضمن الصلاحيات والقرارات المعتمدة. عند تعطل أداة، ابحث عن وسيلة بديلة وواصل ما يمكن إنجازه بأمان.
7. **لا تنقل عبء التحقق إلى صاحب المشروع:** قدّم الأدلة والروابط ونتائج القراءة الراجعة بنفسك متى كانت الأدوات متاحة. يجوز لصاحب المشروع مراجعة العمل والتحقق منه بصورة مستقلة، ولا يُطلب منه القيام بذلك لتعويض نقص التحقق الذي كان على المنفّذ إجراؤه.
8. **الموافقة الصريحة لازمة للعمليات الحساسة:** لا تعدّل قاعدة البيانات أو migrations المطبقة، ولا تنشر إلى الإنتاج، ولا تدمج إلى `main`، ولا تغيّر إعدادات الإنتاج دون موافقة صريحة.
9. **لا تخلط الاعتماد بالاختبار:** اعتماد التصميم أو القرار الوظيفي لا يعني اجتياز التنفيذ تقنياً. اختبر التنفيذ، وأصلح مخالفاته دون إعادة طلب اعتماد التصميم.
10. **تحسين الأداء مسؤولية المنفّذ:** المساعد/الوكيل مسؤول عن تحسين أدائه، ودقة ادعاءاته، وجودة تنفيذه، وإظهار أدلته؛ وليس مسؤولاً عن مطالبة صاحب المشروع بتخفيف حذره أو منحه ثقة غير مستحقة. **لا يُطلب من صاحب المشروع أن يثق بالكلام؛ تُبنى الثقة بالأدلة القابلة للتحقق والالتزام المتكرر بهذه التعليمات.**
11. **التواصل الصريح:** عند اكتشاف خطأ سابق، اعترف به مباشرة، صحّح السجل أو التنفيذ حيث يلزم، وبيّن أثر التصحيح. لا تدافع عن ادعاء غير صحيح ولا تكرر طمأنة لا تسندها أدلة.

**قاعدة حاكمة:** لا يُعلن الإنجاز قبل التحقق؛ ولا تُطلب الثقة بدلاً من تقديم الدليل. صاحب المشروع يحتفظ بحقه الكامل في الحذر والمراجعة المستقلة، ومسؤولية تحسين الأداء تقع على المنفّذ.
