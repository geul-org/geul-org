---
title: "TOULMIN"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Edge الخاصة بـ TOULMIN (Codec 0x60~0x7B) تكتب رسم الأحكام والتنفيذ بنموذج الحجة عند Toulmin. تحدد هذه الصفحة قواعد مستند TOULMIN والحقول المشتركة وجدول الرموز وقواعد القيم العددية والنواة الثابتة للمراجعة الذاتية."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge من عائلة TOULMIN (أعلى بتّين في Codec هما `11`، والرموز المباشرة `0x60`~`0x7B`) تكتب رسم الأحكام والتنفيذ بنموذج الحجة عند Toulmin. تصريحات الدعوى والدحض والاستثناء، وعلاقات الهجوم والإقصاء، وروابط التنفيذ، ونتائج الحكم، كلها Edge. ومستند TANGEUL واحد (لغة قواعد محرك toulmin) يصير مستند GEUL واحداً. وامتداد الملف هو `.geul` نفسه كبقية المستندات.

ما لم تحدده هذه الصفحة يتبع القواعد المشتركة في [Edge](/ar/grammar/edge/) و[السجل وTAG WORD](/ar/grammar/record/).

## الإدراك الميتا والمراجعة الذاتية

سبب كون TOULMIN من Codec في GEUL هو أن يدرك GEUL نفسه إدراكاً ميتا. فيجب أن تُوصف قواعد الحكم والتنفيذ أيضاً بـ GEUL حتى يستطيع TOULMIN أن يتخذها هدفاً فيصححها بنفسه. لذلك فـ TOULMIN ليس profile تطبيقياً بل جوهر تشغيل GEUL، ويوضع في فضاء الرموز المباشرة لـ Edge (`0x60`~`0x7B`).

- الوصف الذاتي يجعل التحسين الذاتي ممكناً لكنه يتحمل خطر الخطأ الدوري. فإذا حكمت القواعد على مراجعتها الذاتية بنفسها أمكن أن تمرّ المراجعة التي تخفف معيار الحكم (ترتفع نسبة النجاح وتنخفض الدقة الفعلية).
- يُقبل خطر الدوران لكنه يُقطع ببنية.
  - **نواة ثابتة**: معنى الحكم (Pass وReview وFail، والهجوم والإقصاء والأولوية، والتقييم بثلاث قيم وU → Review في [الحكم على أساس المجهول](#الحكم-على-أساس-المجهول) أدناه) مثبت في هذه المواصفة. ولا يمكن تغييره بمستند TOULMIN. وهو موضع القواعد المدمجة في المفكك (الطبقة 0 في [عنوان النشر وقائمة الإصدارات](/ar/grammar/publishing/#الطبقات)) نفسه.
  - **فصل الإصدارات**: تُحكم مراجعة مستند القواعد v(n) بقواعد v(n−1) وبفحص خارجي. فلا تحكم القواعد على نفسها. وتوضع نتيجة الحكم في مستند مختلف عن الهدف (فلا تتغير تجزئة محتوى الهدف).
  - **سجل ثابت**: تتراكم المراجعات إصدارات جديدة (`PARENT` وتجزئة المحتوى والتوقيع). وبما أن الإصدارات القديمة تبقى يمكن اكتشاف الخطأ الدوري لاحقاً والتراجع عنه. وشبكة أمان المراجعة الذاتية هي نموذج إصدارات GEUL ([المستند](/ar/grammar/document/#المراجعة)).
  - **معيار خارجي**: تُوضع على حدة مجموعة حالات اختبار لا يستطيع مسار المراجعة أن يمسها. ويُتأكد من اعتماد المراجعة بنتيجة هذه المجموعة.
- اختبار الدحض: تُزرع قاعدة خاطئة عمداً. فإذا صححها النظام وارتفعت درجة المعيار الخارجي فالتحسين الذاتي يعمل. وإذا ارتفعت نسبة النجاح فقط وانخفضت درجة المعيار الخارجي فهو خطأ دوري.

## الرموز

يستخدم سجل TOULMIN أحد ثلاثة تخطيطات. ويحدد التخطيط Codec (أو رقم الصيغة).

| التخطيط | الاستخدام | الصفحة |
|---|---|---|
| NODE | عقد الرسم مثل القضية والقاعدة والتعريف ونقطة الدخول | [NODE](/ar/grammar/edge/toulmin/node/) |
| LINK | العلاقات بين العقد (الهجوم والإقصاء والتنفيذ والتعريف) | [LINK](/ar/grammar/edge/toulmin/link/) |
| EXPR | تعبير الشرط (المحمول) | [EXPR](/ar/grammar/edge/toulmin/expr/) |

سجلات النص الأصلي والأقسام (SOURCE وTEXT وSECTION وCASE-BEGIN·CASE-END وPROSE) تحددها [SOURCE والأقسام](/ar/grammar/edge/toulmin/source/).

### الرموز المباشرة

| Codec | الاسم | التخطيط | TANGEUL | المعنى |
|---|---|---|---|---|
| `0x60` | [CASE-DECLARE](/ar/grammar/edge/toulmin/node/) | NODE | `in case of` | تصريح بقضية. رسم حكم يحمل العقد والعلاقات |
| `0x61` | [PREDICATE-DECLARE](/ar/grammar/edge/toulmin/expr/) | EXPR | تعبير الشرط في Rules | تصريح بمحمول. تعبير الحكم |
| `0x62` | [SPEC-DECLARE](/ar/grammar/edge/toulmin/node/) | NODE | بند في Definitions | تصريح بمعيار الحكم (Backing). بت role هو نوع التعريف |
| `0x63` | [RULE-DECLARE](/ar/grammar/edge/toulmin/node/) | NODE | general rule، واسم القاعدة في Rules | تصريح بدعوى (Warrant). يمكن مهاجمتها |
| `0x64` | [COUNTER-DECLARE](/ar/grammar/edge/toulmin/node/) | NODE | counter rule | تصريح بدحض. يهاجم بنتيجة خاصة به. المستوى الافتراضي Fail |
| `0x65` | [EXCEPT-DECLARE](/ar/grammar/edge/toulmin/node/) | NODE | except rule | تصريح باستثناء. يهاجم بلا نتيجة خاصة به. المستوى الافتراضي Review |
| `0x68` | [ATTACKS](/ar/grammar/edge/toulmin/link/) | LINK | `don't X when Y` | علاقة هجوم. حكم المهاجم ينقص حكم الهدف تدريجياً بقدر شدة الهجوم (0~1، والافتراضي 1) |
| `0x69` | [SUPERSEDES](/ar/grammar/edge/toulmin/link/) | LINK | `X supersedes Y` | علاقة إقصاء. إذا كان المهاجم Active أخرج الهدف من التجميع حتماً. السلسلة (`A > B > C`) تُكتب بواحد لكل زوج |
| `0x6A` | SUPERSEDE-CHAIN | — | | سلسلة أولوية `A > B > C`. اختصار لـ SUPERSEDES الثنائية. خُصص الرمز فقط ولا تخطيط له بعد |
| `0x70` | [RUN](/ar/grammar/edge/toulmin/link/) | LINK | `run c when n` | تركيب التنفيذ. إذا كانت العقدة Active نُفِّذت القضية الفرعية (DAG) |
| `0x71` | [DO](/ar/grammar/edge/toulmin/link/) | LINK | `do fn when n` | عمل يُنفَّذ إذا كانت العقدة Active |
| `0x72` | [DO-ONCE](/ar/grammar/edge/toulmin/link/) | LINK | `do fn once when n` | عمل يُنفَّذ مرة واحدة ولو أُعيدت المحاولة |
| `0x73` | [UNDO](/ar/grammar/edge/toulmin/link/) | LINK | `undo fn when n` | عمل تعويضي لـ DO (saga). إذا فشلت مرحلة لاحقة نُفِّذ بترتيب عكسي |
| `0x74` | [CHECKING](/ar/grammar/edge/toulmin/link/) | LINK | `checking c` | ربط يحكم فقط بلا آثار جانبية |
| `0x75` | [ENTRY](/ar/grammar/edge/toulmin/node/) | NODE | `provides x` | نقطة دخول خارجية. تنفّذ القضية أو تحكم فيها |
| `0x76` | [TRIGGER](/ar/grammar/edge/toulmin/node/) | NODE | `on`, `every`, `until` | نقطة دخول لحدث أو دورة بلا استدعاء خارجي |
| `0x78` | VERDICT | — | | نتيجة حكم العقدة أو السجل. النتيجة (Pass وReview وFail) وقيمة الحكم وActivated وExcluded وLevel. خُصص الرمز فقط ولا تخطيط له بعد |
| `0x79` | EVIDENCE | — | | دليل الحكم. الموضع والقيمة المتوقعة والقيمة الفعلية (Fact). خُصص الرمز فقط ولا تخطيط له بعد |
| `0x7C`~`0x7F` | ISSUER-* | | | صيغة عرّفها Issuer. انظر صيغة ISSUER أدناه |

- الرموز المباشرة غير المذكورة في الجدول (`0x66`·`0x67` و`0x6B`~`0x6F` و`0x77` و`0x7A`·`0x7B`) محجوزة.
- أعلى بتّين من أدنى 5 بتات في Codec هما الحزمة: `00` تصريح، `01` علاقة، `10` تنفيذ، `11` نتيجة (`0x7C`~`0x7F` هي ISSUER).
- حكم المستند كله من شأن Meta [VERDICT](/ar/grammar/meta/verification/verdict/) (`0x44`)، وحكم العقدة والسجل من شأن TOULMIN `VERDICT` (Edge `0x78`). وهما Codec منفصلان من Kind مختلف.

### صيغة ISSUER

سجل TOULMIN الذي لا تكفيه الرموز المباشرة يوضع برقم صيغة تحت `ISSUER-1WORD` (`0x7C`) وIssuer `0x0000` (GEUL). أرقام الصيغ من عائلة TOULMIN (`0xC000`~`0xFFFF`، وأعلى بتّين `11`).

```
TAG WORD          0001 0LLL L111 1100      Edge، وCodec 0x7C
[Length ممتد TAG]
Issuer            0x0000
رقم الصيغة        0xC000~0xC029
Edge Id           سجل Reference من نوع LOCAL
المكوّنات         التخطيط الذي تحدده الصيغة
```

| رقم الصيغة | الاسم | التخطيط | المعنى |
|---|---|---|---|
| `0xC000` | [SOURCE](/ar/grammar/edge/toulmin/source/) | ID وWORD عرض SPAN وقيمة UTF8 | النص الأصلي المؤلَّف |
| `0xC001` | [TEXT](/ar/grammar/edge/toulmin/source/) | ID وقيمة UTF8 | اسم أو سلسلة |
| `0xC002` | [SECTION](/ar/grammar/edge/toulmin/source/) | ID ورمز القسم (1 WORD) | بداية قسم |
| `0xC003` | [CASE-BEGIN](/ar/grammar/edge/toulmin/source/) | ID وREF (القضية) | بداية نطاق قضية |
| `0xC004` | [CASE-END](/ar/grammar/edge/toulmin/source/) | ID وREF (القضية) | نهاية نطاق قضية |
| `0xC005` | [PROSE](/ar/grammar/edge/toulmin/source/) | ID وSPAN | فقرة وصفية |
| `0xC010` | [NAMESPACE](/ar/grammar/edge/toulmin/node/) | NODE | `this document is` |
| `0xC011` | [FUNC](/ar/grammar/edge/toulmin/node/) | NODE | إشارة إلى دالة |
| `0xC012` | [FIELD](/ar/grammar/edge/toulmin/node/) | NODE | `is required` |
| `0xC013` | [ALIAS](/ar/grammar/edge/toulmin/node/) | NODE | `see … from` |
| `0xC014` | [GROUP](/ar/grammar/edge/toulmin/node/) | NODE | حزمة تنفيذ مرتبة |
| `0xC020` | [REQUIRES](/ar/grammar/edge/toulmin/link/) | LINK | قضية → حقل |
| `0xC021` | [MEANS](/ar/grammar/edge/toulmin/link/) | LINK | بند تعريف → قيمة أو نوع |
| `0xC022` | [HAS](/ar/grammar/edge/toulmin/link/) | LINK | بند تعريف → حقل |
| `0xC023` | [RUNS](/ar/grammar/edge/toulmin/link/) | LINK | نقطة دخول → قضية، تنفيذ |
| `0xC024` | [EVALUATES](/ar/grammar/edge/toulmin/link/) | LINK | نقطة دخول → قضية، حكم |
| `0xC025` | [TRIGGERS](/ar/grammar/edge/toulmin/link/) | LINK | محفّز → قضية |
| `0xC026` | [UNTIL](/ar/grammar/edge/toulmin/link/) | LINK | محفّز → قضية (`every … until`) |
| `0xC027` | [SAME-AS](/ar/grammar/edge/toulmin/link/) | LINK | عقدة → معرّف عام |
| `0xC028` | [IMPORTED-FROM](/ar/grammar/edge/toulmin/link/) | LINK | كنية → مسار (TEXT) |
| `0xC029` | [LABEL](/ar/grammar/edge/toulmin/link/) | LINK | عقدة → TEXT، كتابة الاسم |

- فضاء أرقام الصيغ منفصل لكل Kind. فصيغة GEUL في Value `0xC000` (OPAQUE-BYTES-EVEN) و`0xC000` في Edge (SOURCE) صيغتان مختلفتان.
- أرقام الصيغ تُضاف فقط. والرقم الذي خُصص لا يُعاد استخدامه لصيغة أخرى.

## المستند

ملف `.geul` واحد هو DOC واحد. ولا توضع بايتات أخرى خارج DOC.

```
DOC-1WORD/2WORD/4WORD     الطول الكلي
  SPEC-VERSION            0x0001 (v1، عدد صحيح بلا Value مدمجة)
  PROFILE                 قيمة UTF8 "tangeul-<major>.<minor>". الحالي "tangeul-1.0"
  [DEFAULT-LANGUAGE]      قيمة LANGUAGE-BCP47-CODE. لغة التأليف ("en" و"ko")
BODY
  SOURCE                  النص الأصلي المؤلَّف. أول سجل في BODY
  سجلات الجمل …            بترتيب تصريح المستند
END
```

- HEAD: [SPEC-VERSION](/ar/grammar/meta/declaration/spec-version/) و[PROFILE](/ar/grammar/meta/declaration/profile/) و[DEFAULT-LANGUAGE](/ar/grammar/meta/declaration/default-language/) (اختياري).
- يرفض المفكك إذا اختلف SPEC-VERSION أو major في PROFILE. ويقرأ إذا اختلف minor فقط.
- أول سجل في BODY هو SOURCE. وكل SPAN نطاق داخل هذا النص الأصلي.
- ترتيب سجلات الجمل هو ترتيب تصريح المستند نفسه. ويعتمد ترتيب التنفيذ (إطلاق `do` و`run`، وتعويض `undo` بترتيب عكسي) على هذا الترتيب. ففي مستند TOULMIN لترتيب Edge معنى (استثناء من قاعدة الترتيب في [Edge](/ar/grammar/edge/)).
- كل سجلات BODY هي Edge. ولا توضع سجلات Value مستقلة. وتُضمَّن القيمة في Payload الـ Edge.
- هوية القضية والاستيراد تستخدم Meta [DOC-ID](/ar/grammar/meta/declaration/doc-id/) و[IMPORT-DOC](/ar/grammar/meta/import/import-doc/) (Subject وSee في TANGEUL).

## الحقول المشتركة

| الحقل | العرض | الوصف |
|---|---|---|
| ID | سجل Reference من نوع LOCAL | Edge Id الخاص بالسجل. العنصر الأول في Payload كل سجل |
| REF | سجل Reference من نوع LOCAL | Edge Id يشير إلى سجل آخر في هذا المستند. و`0` تعني لا شيء |
| SPAN | العرض الذي يحدده SOURCE × 2 | نطاق داخل النص الأصلي المؤلَّف. بايت البداية وعدد البايتات |

- ID وREF سجل [LOCAL](/ar/grammar/reference/local/) Reference مدمج (`0000 0LLL L000 1000` + معرّف بأقصر عرض). ويحدد Length ذلك السجل العرض ولا يُصرَّح به على مستوى المستند.
- REF `0` (LOCAL `0`) تعني "لا شيء". وهذا اتفاق في Codec يستخدم LOCAL `0` بمعنى لا شيء ([LOCAL](/ar/grammar/reference/local/)).
- يُخصَّص Edge Id بدءاً من 1 ولا يتكرر في المستند. و`0` لا تُستخدم Edge Id لأنها "لا شيء" في REF.
- العقد تُشار إليها من سجلات أخرى بإشارة أمامية، فتأخذ أرقامها أولاً بترتيب تصريح المستند. وبقية السجلات (SOURCE وTEXT وLINK وFUNC وسجلات الأقسام) يخصص لها المرمِّز أرقاماً بعد أرقام العقد.
- لا يفحص المفكك إلا أن Edge Id ليس 0 وأنه غير مكرر. ولا يستخدم ترتيب التخصيص في التفسير.
- تُشار العقد والعلاقات بـ Edge Id.
- Value المضمّنة هي سجل Value كما هو بما فيه TAG WORD. ويحدد طولها ذلك TAG.

## القيم العددية

- قيمة الحكم (−1~1) وQualifier (0~1) وشدة الهجوم (0~1) هي Value من [SIGNED-DECIMAL](/ar/grammar/value/decimal/signed-decimal/). ولا توضع صيغة عشرية ثابتة على حدة.
- يحذف المرمِّز الأصفار في نهاية المعامل. فـ 0.8 هي `C=8, E=−1`. ويقبل المفكك حتى 4 خانات عشرية.
- بوابة الثقة (مثل `at least 75%`) تُكتب بمُعامل مقارنة (1 WORD) وValue من [UNSIGNED-DECIMAL](/ar/grammar/value/decimal/unsigned-decimal/) بالنسبة المئوية (`E=0`) (F_GATE في [LINK](/ar/grammar/edge/toulmin/link/)).
- شدة الهجوم هي حقل F_FORCE في ATTACKS ([LINK](/ar/grammar/edge/toulmin/link/#شدة-الهجوم)). وإذا خرجت عن المدى رُفضت.

## محور تصريح العقدة

- تصريح العقدة (RULE·COUNTER·EXCEPT-DECLARE) له دور (دعوى أو دحض أو استثناء) وQualifier (0~1) وLevel (Unset وFail وReview). الدور في Codec وrole في ترويسة NODE، وQualifier في F_QUAL، وLevel في level في الترويسة ([NODE](/ar/grammar/edge/toulmin/node/)).
- القوة (Strict وDefeasible وDefeater) محور مستقل عن الدور. ولم يتحدد موضعها بعد.
- شدة الهجوم (Force) ليست قيمة للعقدة بل لحافة ATTACKS ([LINK](/ar/grammar/edge/toulmin/link/#شدة-الهجوم) F_FORCE). وهي محور مختلف عن القوة.

## الحكم على أساس المجهول

عندما يتلقى رسم الحكم حقائق GEUL مدخلات، تُقيَّم المفاهيم الثلاثة في [علامة موضع](/ar/grammar/reference/slot-marker/) (غير مكتوب وغير معروف ولا شيء) تقييماً مختلفاً. وتقييم مُعاملات المقارنة في [EXPR](/ar/grammar/edge/toulmin/expr/) كما يلي.

| المدخل | `is empty` | `is not empty` | `equals` / `is in` / مقارنة الحجم |
|---|---|---|---|
| قيمة v | خطأ | صحيح | يُقيَّم بـ v |
| NO-VALUE (لا شيء) | **صحيح** | خطأ | خطأ |
| UNKNOWN-VALUE (غير معروف) | خطأ | **صحيح** | **غير محدد (U)** |
| ABSENT (غير مكتوب) / لا وصف | U (عالم مفتوح) | U | U |

- يستخدم المنطق ثلاث قيم قوية لـ Kleene. `NOT U = U` و`خطأ AND U = خطأ` و`صحيح OR U = صحيح`. وبقية التراكيب التي فيها U تعطي U.
- `EXISTS any` صحيح إذا كان أحد العناصر صحيحاً. وإن لم يوجد صحيح ووُجد U فهو U، وإن كانت كلها خطأ فهو خطأ.
- **إذا كان المحمول U فحكم تلك العقدة ليس Pass ولا Fail بل Review.** وما لا يُعرف يُسلَّم إلى إنسان (أو المرحلة التالية).
- ولكي يُعدّ ABSENT فارغاً (empty) لا U يجب أن **تصرّح** جهة المدخلات بعالم مغلق (تُحقن بمعيار الحكم SPEC، مثل "مدخلات هذه القضية كاملة"). وبلا تصريح فهو U.
- هذا الجدول ومقابلة U → Review معنى الحكم فهما **نواة ثابتة**. ولا يمكن تغييرهما بمستند TOULMIN.
- مثال: قاعدة "عدّ الحدود السارية الآن فقط" (`P582 is empty`) تستبعد P582 = UNKNOWN-VALUE لأنها خطأ، وتشمل P582 = NO-VALUE لأنها صحيحة، وإذا لم يوجد P582 فهي U فتُرسَل إلى Review.

## نتيجة الحكم

- توضع نتيجة الحكم (`VERDICT` و`EVIDENCE`) في مستند مختلف عن مستند موضوع الحكم. يستورد مستند النتيجة مستند الموضوع بـ [IMPORT-DOC](/ar/grammar/meta/import/import-doc/) ويشير إليه بـ [EXTERNAL-POINTER-*](/ar/grammar/reference/external-pointer/). لذلك لا تتغير تجزئة محتوى مستند الموضوع بالحكم.
- حكم المستند كله هو Meta `VERDICT`، وحكم العقدة والسجل هو TOULMIN `VERDICT`.
- قواعد اختيار الإصدار الذي تُطبَّق به المراجعة (الأحكام الانتقالية واختيار القانون وقت الفعل أو القانون الجديد) وكذلك التفسيرات والسوابق القضائية تُكتب بقواعد الحكم ([المستند](/ar/grammar/document/#المراجعة)).

## مسائل مفتوحة

- تخطيط SUPERSEDE-CHAIN (`0x6A`) وVERDICT (`0x78`) وEVIDENCE (`0x79`). وهل تكفي السلسلة بالطريقة الحالية التي تُكتب فيها SUPERSEDES لكل زوج.
- موضع قوة العقدة (Strict وDefeasible وDefeater).
- ATTACKS الذي يكتب شدة 1 وATTACKS الذي لا يكتب شدة يعطيان الحكم نفسه لكن بايتاتهما مختلفة. فالمقارنة بين حكمين تكون بالقيم بعد فك الترميز لا بالبايتات.
- عدد العقد في EXPR وعدد التسميات (label) وفهرس التسمية 1 WORD، وعدد الأبناء 13 بتاً. فالحدود الأعلى ثابتة.
- تخطيط PROVENANCE (مصدر القاعدة ومقدماتها).
- هل توضع الأسماء بين علامتي backtick بـ [LABEL](/ar/grammar/edge/label/) و[BIND](/ar/grammar/edge/bind/) الوصفيين بدل TEXT + LABEL (`0xC029`).
- جدول قيم رمز predicate وmode في Claim وقيم رمز VerbCode في FuncRef.
- هل يكون تصريح العالم المغلق (قراءة ABSENT كفارغ) على مستوى معيار الحكم (SPEC) أم على مستوى القضية.
- [مواصفة Codec](/ar/grammar/codec-spec/) الخاصة بـ Codec في TOULMIN. فالحقول الشرطية في NODE وLINK وعرض SPAN الذي يحدده SOURCE تخطيطات لا يمكن التصريح بها بـ FIELD.

## صفحات ذات صلة

- [NODE](/ar/grammar/edge/toulmin/node/)، [LINK](/ar/grammar/edge/toulmin/link/)، [EXPR](/ar/grammar/edge/toulmin/expr/)، [SOURCE والأقسام](/ar/grammar/edge/toulmin/source/)
- [Edge](/ar/grammar/edge/)، [المستند](/ar/grammar/document/)، [PROFILE](/ar/grammar/meta/declaration/profile/)
