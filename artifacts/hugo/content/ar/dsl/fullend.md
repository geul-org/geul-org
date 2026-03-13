---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-13T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "أداة CLI تتحقق من الاتساق المتبادل بين 10 مصادر SSOT وتولّد الكود. تسد شقوق أسلوب Vibe Coding بالبنية."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — أداة CLI تتحقق من اتساق 10 مصادر SSOT دفعة واحدة وتولّد الكود.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">مستودع GitHub</a>

## الشقوق في أسلوب Vibe Coding

مع انتشار أسلوب Vibe Coding، بدأت الأنماط تتكشف.

تقول للذكاء الاصطناعي "أنشئ ميزة الحجز" فينشئها. تقول "أضف ميزة الإلغاء" فيضيفها. عند إضافة الميزة الخامسة تنكسر الميزة الثانية. تغيّر مخطط API لكن الواجهة الأمامية لا تُحدَّث. تضيف عمودًا في قاعدة البيانات لكن طبقة الخدمة لا تعلم بذلك.

السبب بسيط: الذكاء الاصطناعي لا يستطيع تذكّر الكود بأكمله.

فيفعل الناس ما يلي: يكتشفون الجزء المكسور ويقولون للذكاء الاصطناعي "أصلح هذا أيضًا". يصلحه فينكسر مكان آخر. "أصلح ذاك أيضًا." تتكرر هذه الحلقة. كلما كبر المشروع طالت الحلقة، وعند نقطة ما يصبح "إعادة البناء من الصفر أسرع".

## لماذا يتضخم الكود؟

يمتزج في الكود شيئان:

**القرارات**: ماذا نعرض، أي API نستدعي، بأي ترتيب نعالج، ماذا نخزّن.
**التوصيلات**: الكود الذي ينفّذ تلك القرارات في إطار عمل محدد.

لنفترض أننا نبني نظام حجز.

```
القرار: "عند إلغاء الحجز: التحقق من الصلاحية → الاستعلام → التحقق من انتقال الحالة → حساب الاسترداد → تغيير الحالة → الاستجابة"
```

هذا السطر الواحد من القرار يتوزع على React hooks وGo handlers واستعلامات SQL ومخططات API وموارد Terraform. يُغلَّف كل جزء بصياغة الإطار الخاص به، ويُضاف إليه معالجة الأخطاء وتحويل الأنواع.

من بين 100,000 سطر من الكود، القرارات هي 12,500 سطر فقط. الباقي — 87,500 سطر — توصيلات.

وكلاء الذكاء الاصطناعي لديهم نافذة سياق محدودة. عند إضافة الميزة العاشرة لا يتذكرون التسع السابقة، لأنهم لا يستطيعون قراءة 100,000 سطر دفعة واحدة.

لو فصلنا القرارات فقط فهي 12,500 سطر — 55% من سياق 200K توكن. حجم يمكن للذكاء الاصطناعي قراءته دفعة واحدة.

## 10 مصادر SSOT

يفصل Fullend جميع قرارات البرمجيات إلى 10 مواصفات تصريحية. كل مواصفة تصبح مصدر الحقيقة الوحيد (SSOT) للاهتمام المعني.

| الاهتمام | SSOT | ما تصرّح به |
|---|---|---|
| إعداد المشروع | fullend.yaml | مجموعة التقنيات، البرمجيات الوسيطة، مسارات الوحدات |
| الواجهة | [STML](/ar/dsl/stml/) (HTML5 + data-*) | ماذا نعرض وماذا نفعل |
| عقد API | OpenAPI 3.x | أي طلبات نستقبل وأي استجابات نعيد |
| تدفق الخدمة | [SSaC](/ar/dsl/ssac/) (.ssac DSL) | بأي ترتيب نعالج |
| بنية البيانات | SQL DDL + sqlc | ماذا نخزّن |
| الدوال الخارجية | Func Spec (Go) | واجهة المنطق المخصص وتنفيذه |
| انتقال الحالة | Mermaid stateDiagram | ما الحالات التي يمر بها المورد |
| سياسة الصلاحيات | OPA Rego | من يستطيع فعل ماذا |
| السيناريوهات | Gherkin (.feature) | التحقق من تدفقات الأعمال بين نقاط النهاية |
| البنية التحتية | Terraform HCL | أين نشغّل |

OpenAPI وSQL DDL وTerraform معايير صناعية. أما الاهتمامات الأخرى فلم يكن لها SSOT DSL مقابل. تدفقات الخدمة كانت متناثرة في Go handlers، وقرارات الواجهة مدفونة في React hooks، وانتقالات الحالة مخفية في تفريعات if-else، والصلاحيات مُثبَّتة مباشرة في البرمجيات الوسيطة. لذلك صمّمنا STML وSSaC وFunc Spec وربط stateDiagram وربط OPA وربط Gherkin. هي لغات DSL وعمليات الربط التي أنشأها هذا المشروع.

```
specs/my-project/
├── fullend.yaml             → إعداد المشروع
├── api/openapi.yaml         → OpenAPI 3.x
├── db/*.sql                 → SQL DDL + sqlc queries
├── service/**/*.ssac        → SSaC (امتداد .ssac)
├── model/*.go               → Go structs (// @dto)
├── func/<pkg>/*.go          → Func Spec
├── states/*.md              → Mermaid stateDiagram
├── policy/*.rego            → OPA Rego
├── scenario/*.feature       → Gherkin
├── frontend/*.html          → STML
└── terraform/*.tf           → HCL
```

`specs/` هي الحقيقة. `artifacts/` يمكن إعادة توليدها في أي وقت.

## التحقق الفردي موجود بالفعل

أدوات التحقق لعدة طبقات موجودة بالفعل.

- sqlc يتحقق من اتساق DDL والاستعلامات.
- أدوات التحقق من OpenAPI تفحص صحة المخططات.
- Terraform يتحقق من صياغة HCL والتبعيات.

أنشأنا أيضًا أدوات تحقق مدمجة لكل من STML وSSaC. يتحقق SSaC من الاتساق الداخلي لتدفقات الخدمة، وتتحقق STML من تطابق تصريحات الواجهة مع OpenAPI.

كل SSOT يمكنه التحقق من ذاته داخليًا. المشكلة تحدث **بين** المصادر.

الواجهة الأمامية تعرض حقلًا بـ `data-bind="memo"`، لكن مخطط استجابة API لا يحتوي على `memo`. يستدعي SSaC الدالة `@delete Reservation.SoftDelete(request.ReservationID)`، لكن استعلامات sqlc لا تحتوي على الطريقة `SoftDelete`. يُعرَّف انتقال `PublishCourse` في مخطط الحالة، لكن لا توجد دالة مقابلة في SSaC. تستعلم سياسة OPA عن ملكية المورد `course` عبر `courses.instructor_id`، لكن DDL لا يحتوي على هذا العمود.

الأدوات الفردية ترى طبقتها فقط. الشقوق بين الطبقات تبقى غير مرئية.

## إخفاء البنية

"ولكن ألا يجب تعلّم 10 لغات DSL؟"

صحيح. لكن البنية لا يجب أن تُعرض على المستخدم.

إذا وضعنا مجموعة التقنيات وقواعد SSOT مسبقًا في موجّه نظام الوكيل، يكفي أن يقول المستخدم "أنشئ ميزة الحجز". يقوم الوكيل تلقائيًا بإضافة نقطة نهاية في OpenAPI، وإنشاء جدول في DDL، وتصريح تدفق الخدمة في SSaC، ورسم مخطط الحالة، وكتابة سياسة OPA، ورسم الواجهة في STML، وتشغيل `fullend validate` للتحقق من الاتساق.

ما يراه المستخدم هو النتيجة فقط. البنية يستهلكها الوكيل، وليست شيئًا على المستخدم تعلّمه.

تجربة Vibe Coding تبقى كما هي. ما يتغيّر هو أن شيئًا لا ينكسر في الخلفية.

## دور Fullend

Fullend هو أداة تحقق متبادل. لا يعيد اختراع الأدوات الفردية. يستدعي كل أداة ويفحص الحدود بين مصادر SSOT.

```bash
fullend validate <specs-dir>
fullend validate --skip states,terraform <specs-dir>
```

يتحقق من كل مصدر من مصادر SSOT العشرة فرديًا، ثم يُجري التحقق المتبادل بينها. يُتحقق من Func فقط عند وجود مجلد `func/`. يمكن استبعاد مصادر SSOT محددة باستخدام `--skip`.

```
✓ Config       my-project, go/gin, typescript/react
✓ OpenAPI      7 endpoints
✓ DDL          3 tables, 18 columns
✓ SSaC         7 service functions
✓ Model        3 files
✓ STML         4 pages, 6 bindings
✓ States       1 diagrams, 3 transitions
✓ Policy       1 files, 5 rules, 3 ownership mappings
✓ Scenario     4 features, 5 scenarios
✓ Func         3 funcs
✓ Terraform    2 files
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

إذا فشل أي فحص:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

عند نجاح التحقق يُولَّد الكود. خيار `--skip` يعمل بنفس طريقة validate.

```bash
fullend gen <specs-dir> <artifacts-dir>
fullend gen --skip terraform <specs-dir> <artifacts-dir>
```

sqlc يولّد نماذج قاعدة البيانات، وoapi-codegen يولّد أنواع API، وSSaC يولّد معالجات gin، وSTML يولّد مكوّنات React، وتُولَّد حزم آلة الحالة وOPA Authorizer، ويُولَّد اختبارات Hurl من Gherkin، وFullend يولّد كود الربط الذي يجمعها معًا.

### gen-model

يولّد ملف نموذج Go (واجهة + أنواع + عميل HTTP) من مستند OpenAPI خارجي. يقبل مسار ملف محلي أو عنوان URL.

```bash
fullend gen-model <openapi-source> <output-dir>
fullend gen-model https://api.stripe.com/openapi.yaml ./external/
```

### chain

يتتبع جميع عقد SSOT المرتبطة بعملية API واحدة. يُدخَل operationId واحد، فتخرج خريطة file:line لجميع الطبقات.

```bash
fullend chain <operationId> <specs-dir>
```

```
── Feature Chain: AcceptProposal ──

  OpenAPI    api/openapi.yaml:296                          POST /proposals/{id}/accept
  SSaC       service/proposal/accept_proposal.ssac:19      @get @empty @auth @state @put @call @post @response
  DDL        db/gigs.sql:1                                 CREATE TABLE gigs
  DDL        db/proposals.sql:1                            CREATE TABLE proposals
  DDL        db/transactions.sql:1                         CREATE TABLE transactions
  Rego       policy/authz.rego:3                           resource: gig
  StateDiag  states/gig.md:7                               diagram: gig → AcceptProposal
  StateDiag  states/proposal.md:6                          diagram: proposal → AcceptProposal
  FuncSpec   func/billing/hold_escrow.go:8                 @func billing.HoldEscrow
  Gherkin    scenario/gig_lifecycle.feature:4              Scenario: Happy Path - Full Gig Lifecycle
```

### status

يعرض ملخصًا لمصادر SSOT المُكتشفة وإحصائياتها.

```bash
fullend status <specs-dir>
```

```
SSOT Status:
  OpenAPI      api/openapi.yaml               7 endpoints
  DDL          db                             3 tables, 18 columns
  SSaC         service                        7 functions
  STML         frontend                       4 pages
  States       states                         1 diagrams, 3 transitions
  Policy       policy                         1 files, 5 rules
  Scenario     scenario                       4 features, 5 scenarios
  Func         func                           3 funcs
```

## الدوال والنماذج المدمجة

يأتي Fullend مع تنفيذات دوال شائعة الاستخدام وواجهات نماذج مدمجة. يمكن استدعاؤها عبر `@call` في SSaC.

### Default Functions (pkg/)

| الحزمة | الدالة | الوصف |
|---|---|---|
| `auth` | `hashPassword` | تجزئة كلمة المرور بـ bcrypt |
| `auth` | `verifyPassword` | التحقق من كلمة المرور بـ bcrypt |
| `auth` | `issueToken` | توليد رمز وصول JWT (24 ساعة) |
| `auth` | `verifyToken` | التحقق من رمز JWT + استخراج المطالبات |
| `auth` | `refreshToken` | توليد رمز تحديث (7 أيام) |
| `auth` | `generateResetToken` | رمز hex عشوائي لإعادة تعيين كلمة المرور |
| `crypto` | `encrypt` | تشفير متماثل AES-256-GCM |
| `crypto` | `decrypt` | فك تشفير AES-256-GCM |
| `crypto` | `generateOTP` | سر TOTP + عنوان QR للتوفير |
| `crypto` | `verifyOTP` | التحقق من رمز TOTP |
| `storage` | `uploadFile` | رفع ملف متوافق مع S3 |
| `storage` | `deleteFile` | حذف ملف متوافق مع S3 |
| `storage` | `presignURL` | عنوان تنزيل S3 presigned |
| `mail` | `sendEmail` | بريد إلكتروني نصي عبر SMTP |
| `mail` | `sendTemplateEmail` | بريد HTML بقالب Go عبر SMTP |
| `text` | `generateSlug` | تحويل يونيكود إلى slug آمن للروابط |
| `text` | `sanitizeHTML` | تنقية HTML لمنع XSS |
| `text` | `truncateText` | اقتطاع نص آمن مع يونيكود |
| `image` | `ogImage` | توليد صورة OG (1200x630, PNG) |
| `image` | `thumbnail` | توليد صورة مصغرة (200x200, PNG) |

يمكن للمشاريع تجاوز هذه الدوال بتوفير تنفيذات مخصصة في `specs/<project>/func/<pkg>/`.

### Built-in Models (pkg/)

واجهات @model بادئة الحزمة للمدخلات/المخرجات غير العلائقية التي لا تُعرَّف بـ DDL. تُهيَّأ الواجهة الخلفية عبر `fullend.yaml`.

| الحزمة | الواجهة | الواجهات الخلفية | الاستخدام في SSaC |
|---|---|---|---|
| `session` | `SessionModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `session.Session.Get({key: ...})` |
| `cache` | `CacheModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `cache.Cache.Set({key: ..., value: ..., ttl: ...})` |
| `file` | `FileModel` (Upload/Download/Delete) | S3, LocalFile | `file.File.Upload({key: ..., body: ...})` |
| `queue` | Singleton Pub/Sub (Publish/Subscribe) | PostgreSQL, Memory | `@publish "topic" {payload}` |

### Middleware (مُولَّد)

يولّد Fullend ملف `internal/middleware/bearerauth.go` خاصًا بالمشروع من إعدادات claims في `fullend.yaml`.

| البرمجية الوسيطة | المُحفِّز | الوصف |
|---|---|---|
| `BearerAuth(secret)` | `securitySchemes.bearerAuth` + `backend.auth.claims` | يستخرج JWT → يضبط `*model.CurrentUser` في سياق gin |

يُحدَّد تجميع المسارات بحقل `security` في OpenAPI. العمليات التي تحتوي على `security: [{bearerAuth: []}]` تنتمي لمجموعة المصادقة؛ والعمليات بدونها تنتمي للمجموعة العامة.

## قواعد التحقق المتبادل

القيمة الجوهرية لـ Fullend تكمن في التحقق المتبادل. بعد أن تتحقق كل أداة فردية من طبقتها، يكشف Fullend عن التناقضات بين مصادر SSOT.

**fullend.yaml ↔ OpenAPI**

| هدف التحقق | القاعدة |
|---|---|
| اسم البرمجية الوسيطة | هل يتطابق مع مفتاح securitySchemes؟ |

**OpenAPI ↔ DDL**

| هدف التحقق | القاعدة |
|---|---|
| x-sort.allowed | هل العمود موجود في الجدول؟ |
| x-sort ↔ DDL index | هل يوجد فهرس على هذا العمود؟ (WARNING) |
| x-filter.allowed | هل العمود موجود في الجدول؟ |
| x-include.allowed | هل هو جدول مرتبط عبر FK؟ |

**SSaC ↔ DDL**

| هدف التحقق | القاعدة |
|---|---|
| Model.Method | هل الطريقة موجودة في استعلامات sqlc؟ |
| @result Type | هل يتطابق مع النوع المشتق من جدول DDL؟ |
| حقول المعاملات | هل يمكن تحويلها إلى أعمدة DDL؟ |

**SSaC ↔ OpenAPI**

| هدف التحقق | القاعدة |
|---|---|
| اسم الدالة | هل يتطابق مع operationId؟ |
| معاملات request | هل الحقل موجود في مخطط الطلب؟ |
| حقول @response | هل الحقل موجود في مخطط الاستجابة؟ |

**States ↔ SSaC ↔ OpenAPI ↔ DDL**

| هدف التحقق | القاعدة |
|---|---|
| حدث الانتقال | هل يتطابق مع اسم دالة SSaC؟ |
| حدث الانتقال | هل يتطابق مع operationId في OpenAPI؟ |
| SSaC @state | هل يوجد stateDiagram مُشار إليه؟ |
| حقل @state | هل يوجد كعمود في DDL؟ |

**Policy ↔ SSaC ↔ DDL ↔ States**

| هدف التحقق | القاعدة |
|---|---|
| allow (action, resource) | هل يتطابق مع @auth في SSaC؟ |
| @ownership table.column | هل موجود في DDL؟ |
| @ownership via join | هل مفتاح FK لجدول الربط موجود في DDL؟ |
| حدث انتقال الحالة | هل توجد قاعدة Rego مطابقة للانتقالات التي تحتوي @auth؟ |

**Func ↔ SSaC**

| هدف التحقق | القاعدة |
|---|---|
| مرجع @call | هل يوجد تنفيذ Func مقابل؟ |
| عدد المعاملات | هل معاملات @call تتطابق مع عدد حقول Request؟ |
| أنواع المعاملات | هل الأنواع الموضعية تتطابق عبر DDL/OpenAPI؟ |
| النتيجة/الاستجابة | هل result/response متسقة؟ |
| جسم الدالة | هل هو مجرد TODO stub؟ (WARNING) |

**Scenario ↔ OpenAPI ↔ States**

| هدف التحقق | القاعدة |
|---|---|
| operationId | هل موجود في OpenAPI؟ |
| HTTP method | هل يتطابق مع طريقة OpenAPI؟ |
| حقول JSON | هل موجودة في مخطط الطلب؟ |
| ترتيب الخطوات | هل يتبع قواعد انتقال الحالة؟ |

**Queue (Pub/Sub)**

| هدف التحقق | القاعدة |
|---|---|
| @publish topic | هل توجد دالة @subscribe مطابقة؟ |
| حقول payload/message | هل هي متسقة؟ |
| إعدادات queue | هل يوجد queue config في fullend.yaml؟ |

**STML ↔ SSaC** — كلاهما يشير إلى نفس operationId في OpenAPI. عند نجاح التحقق من كليهما، يُضمن تلقائيًا تطابق API التي تستدعيها الواجهة الأمامية مع API التي تعالجها الخلفية.

## اختبار وقت التشغيل

يولّد `fullend gen` اختبارات [Hurl](https://hurl.dev) من مواصفات OpenAPI وسيناريوهات Gherkin.

```bash
# شغّل الخادم أولًا، ثم:
hurl --test --variable host=http://localhost:8080 artifacts/my-project/tests/*.hurl
```

الاختبارات المُولَّدة:

- **smoke.hurl** — اختبارات دخان لنقاط نهاية OpenAPI (تُولَّد تلقائيًا)
- **scenario-*.hurl** — اختبارات سيناريوهات الأعمال (من ملفات .feature)
- **invariant-*.hurl** — اختبارات الثوابت بين نقاط النهاية (من ملفات .feature)

## تصميم موجّه للوكلاء

Fullend مصمَّم لوكلاء الذكاء الاصطناعي.

ليتمكن الوكيل من كتابة المواصفات، عليه معرفة أنواع التسلسل العشرة في SSaC، وسمات data-* في STML، وامتدادات x- في OpenAPI، وقواعد stateDiagram، وأنماط سياسات OPA، وصياغة سيناريوهات Gherkin، وقواعد Func Spec، وقواعد مطابقة الأسماء. لذلك نوفّر دليلًا للذكاء الاصطناعي من نحو 830 سطرًا. يُضاف مرة واحدة إلى موجّه نظام الوكيل.

حلقة التحقق بعد كتابة المواصفات بسيطة:

```
سير عمل الوكيل:
1. تعديل specs/
2. fullend validate specs/my-project
3. إذا وُجدت أخطاء → إصلاح SSOT المعني → العودة إلى 2
4. صفر أخطاء → fullend gen specs/my-project artifacts/my-project
```

لا حاجة لفهم النظام بأكمله. يكفي إصلاح ما يشير إليه validate لاستعادة الاتساق. النماذج الذكية تصيب من أول محاولة، والنماذج الأصغر تصيب من الثالثة. النتيجة واحدة.

## حجم SSOT حسب الحجم

| الحجم | مثال | SSOT | كود التنفيذ | نسبة شغل السياق |
|---|---|---|---|---|
| صغير | حجز صالون تجميل | ~1,500 سطر | ~10,000 سطر | ~8% |
| متوسط | بمستوى Jira أو Notion | ~12,500 سطر | ~100,000 سطر | ~55% |
| كبير | بمستوى Shopify | ~30,000 سطر | ~300,000 سطر | ~90% |

بناءً على سياق 200K توكن. حتى تطبيقات SaaS المتوسطة يمكن للوكيل قراءة تصميمها بالكامل دفعة واحدة.

## تحويل الاستثناءات إلى أنماط

ما لا يمكن التعبير عنه بأنواع التسلسل العشرة يُحال إلى `@call`. وما لا يمكن التعبير عنه بسمات data-* يُحال إلى `custom.ts`. إذا تجاوزت مخارج الطوارئ هذه 20% من الإجمالي، تفقد الهيكلة معناها.

لكن الاستثناء لحظة عزله يصبح قابلًا للملاحظة. عندما تُهيكَل مشاريع كثيرة بـ Fullend، ستظهر أنماط متكررة في `@call` و`custom.ts`.

أنواع التسلسل العشرة في SSaC لم تُصمَّم من البداية. بل تقاربت إلى 10 بعد مراقبة مئات من أكواد الخدمة. نتوقع أن يتكرر المبدأ نفسه مع مخارج الطوارئ. أنماط `@call` المتكررة تصبح أنواع تسلسل جديدة، وأنماط `custom.ts` المتكررة تصبح سمات data-* جديدة.

الاستثناءات لا تتقلص — بل تنمو منها البنية.

## توسيع مجموعة التقنيات

حاليًا Fullend مُثبَّت على Go(gin) + React + PostgreSQL + Terraform. هذا مقصود. في مرحلة إثبات المفهوم، الأولوية هي اختراق مجموعة تقنية واحدة بالكامل.

لكن كثيرًا من مصادر SSOT العشرة (OpenAPI، SQL DDL، Terraform، Mermaid، OPA Rego، Gherkin) مستقلة عن اللغة بالفعل. أنواع التسلسل العشرة في SSaC أنماط غير مرتبطة بلغة محددة — تُعبَّر فقط بتعليقات Go. وSTML تستخدم سمات HTML5 data-* فهي مستقلة عن الإطار.

التوسيع مسألة إضافة واجهات خلفية لتوليد الكود. منطق التحقق وقواعد التحقق المتبادل تبقى كما هي.

## العلاقة مع GEUL

10 مصادر SSOT تشكّل جميع قرارات البرمجيات. وSSOT بيانات مهيكلة. والبيانات المهيكلة رسم بياني. والرسم البياني يمكن ترميزه بـ GEUL.

`data-fetch="ListReservations"` في STML هو علاقة بين كيانات. `@get → @empty → @state → @call → @put → @response` في SSaC هو تسلسل أحداث. انتقالات stateDiagram هي رسم بياني للحالة. سياسات OPA هي علاقات صلاحيات. تعريف نقطة النهاية في OpenAPI هو عقد. كلها بنى دلالية يمكن التعبير عنها بأضلاع الثلاثي وأضلاع الحدث6 وعقد الكيان في GEUL.

الطريقة التي يجري بها Fullend التحقق المتبادل بين 10 مصادر SSOT — المطابقة الرمزية، والتحقق من تطابق الأنواع، والتحقق من سلامة المراجع — هي نفس مبدأ التحقق الآلي في تدفقات GEUL.

## الترخيص

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
