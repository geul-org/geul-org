---
title: "TOULMIN"
weight: 130
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "يكتب رسم الحكم والتنفيذ بنموذج الحجة عند Toulmin."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب رسم الحكم والتنفيذ بنموذج الحجة عند Toulmin. وهو العائلة الجوهرية التي تمكّن GEUL من وصف قواعدها بـ GEUL وتصحيح نفسها بنفسها.

| الحزمة | Codec |
|---|---|
| الإعلان | [CASE-DECLARE](0x100L-case-declare.md) (قضية)، [PREDICATE-DECLARE](0x101L-predicate-declare.md) (محمول)، [SPEC-DECLARE](0x102L-spec-declare.md) (معيار الحكم)، [RULE-DECLARE](0x103L-rule-declare.md) (ادعاء)، [COUNTER-DECLARE](0x104L-counter-declare.md) (دحض)، [EXCEPT-DECLARE](0x105L-except-declare.md) (استثناء) — [NODE](#node) |
| العلاقة | [ATTACKS](0x108L-attacks.md) (هجوم)، [SUPERSEDES](0x109L-supersedes.md) (إقصاء) — [LINK](#link)، [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) (سلسلة أولوية، التخطيط غير محدد) |
| التنفيذ | [RUN](0x110L-run.md)، [DO](0x111L-do.md)، [DO-ONCE](0x112L-do-once.md)، [UNDO](0x113L-undo.md)، [CHECKING](0x114L-checking.md) — [LINK](#link)، [ENTRY](0x115L-entry.md)، [TRIGGER](0x116L-trigger.md) — [NODE](#node) |
| النتيجة | [VERDICT](0x118L-verdict.md) (نتيجة الحكم: Pass وReview وFail)، [EVIDENCE](0x119L-evidence.md) (دليل الحكم) — التخطيط غير محدد |

- النص الأصلي والتقسيم والعقد والعلاقات المساعدة هي الرموز المباشرة `0x120L~0x134L` في عائلة صيغة TOULMIN ([SOURCE والتقسيم](#source와-구획)، [TOULMIN](#toulmin-형식)).
- تُوضع نتيجة الحكم في مستند غير مستند الهدف المحكوم عليه. ويستورد مستند النتيجة مستند الهدف ويشير إليه. لذا لا تتغير تجزئة محتوى مستند الهدف بالحكم عليه.

Edge في عائلة TOULMIN (الرموز المباشرة `0x100L~0x11BL`، والسجلات المساعدة في عائلة صيغة TOULMIN `0x120L~0x134L`) تكتب رسم الحكم والتنفيذ بنموذج الحجة عند Toulmin. وكلها Edge: إعلان الادعاء والدحض والاستثناء، وعلاقات الهجوم والإقصاء، وروابط التنفيذ، ونتيجة الحكم. ويصبح مستند TANGEUL واحد (لغة القواعد في محرك toulmin) مستند GEUL واحداً. وامتداد الملف هو `.geul` كسائر المستندات.

ما لا يحدده هذا المستند يتبع القواعد المشتركة لـ [Edge](../edge/_index.md) و[السجل وTAG WORD](../record.md).

## الإدراك الفوقي والمراجعة الذاتية {#메타-인지와-자기-개정}

TOULMIN هو Codec في GEUL لكي تُدرك GEUL نفسها إدراكاً فوقياً. فإذا كُتبت قواعد الحكم والتنفيذ كذلك بـ GEUL أمكن لـ TOULMIN أن يتخذها هدفاً ويصحح نفسه. ولذلك فـ TOULMIN ليس ملف تعريف تطبيقياً بل جوهر تشغيل GEUL، ويوضع في فضاء الرموز المباشرة لـ Edge (`0x100L~0x11BL`).

- الوصف الذاتي يتيح التحسين الذاتي لكنه يحمل خطر الخطأ الدائري. فإذا حكمت القاعدة بنفسها على مراجعتها نفسها أمكن أن تمر مراجعة تُرخي معيار الحكم (ترتفع نسبة النجاح وتنخفض الدقة الفعلية).
- يُقبل خطر الدائرية، لكنها تُقطع بالبنية.
  - **النواة الثابتة**: معنى الحكم (Pass وReview وFail، والهجوم والإقصاء والأولوية، والتقييم ثلاثي القيم والانتقال من U إلى Review في [الحكم على المجهول](#미상-위에서-판정하기) أدناه) ثابت في هذه المواصفة. ولا يمكن تغييره بمستند TOULMIN. وهو في موضع القواعد المضمنة في فاكّ الترميز (الطبقة 0 في [عناوين النشر وقائمة الإصدارات](../publishing.md#층)).
  - **فصل الإصدارات**: تُحكم مراجعة مستند القواعد v(n) بقواعد v(n−1) وبفحص خارجي. فلا تحكم القاعدة على نفسها. وتُوضع نتيجة الحكم في مستند غير مستند الهدف (فلا تتغير تجزئة محتوى الهدف).
  - **السجل الثابت**: تتراكم المراجعات إصداراتٍ جديدة (`PARENT` وتجزئة المحتوى والتوقيع). وبقاء الإصدارات القديمة يتيح اكتشاف الخطأ الدائري لاحقاً والرجوع عنه. وشبكة الأمان للمراجعة الذاتية هي نموذج الإصدارات في GEUL ([المستند](../document.md#개정)).
  - **المعيار الخارجي**: تُحفظ مجموعة حالات اختبار منفصلة لا يمكن لمسار المراجعة أن يمسّها. ويُتحقق من اعتماد المراجعة بنتيجة هذه المجموعة.
- اختبار الدحض: تُزرع عمداً قاعدة خاطئة واحدة. فإذا صححها النظام وارتفعت درجة المعيار الخارجي فالتحسين الذاتي يعمل. وإذا ارتفعت نسبة النجاح فقط وانخفضت درجة المعيار الخارجي فهو خطأ دائري.

## الرموز {#코드}

يستخدم سجل TOULMIN أحد ثلاثة تخطيطات. ويحدد Codec التخطيط.

| التخطيط | الاستخدام | الصفحة |
|---|---|---|
| NODE | عقد الرسم مثل القضية والقاعدة والتعريف ونقطة الدخول | [NODE](#node) |
| LINK | العلاقات بين العقد (الهجوم والإقصاء والتنفيذ والتعريف) | [LINK](#link) |
| EXPR | التعبير الشرطي (المحمول) | [EXPR](0x101L-predicate-declare.md) |

أما سجلات النص الأصلي والتقسيم (SOURCE وTEXT وSECTION وCASE-BEGIN وCASE-END وPROSE) فيحددها [SOURCE والتقسيم](#source와-구획).

### الرموز المباشرة {#직접-코드}

| Codec | الاسم | التخطيط | TANGEUL | المعنى |
|---|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | NODE | `in case of` | إعلان قضية. رسم حكم يحمل العقد والعلاقات |
| `0x101L` | [PREDICATE-DECLARE](0x101L-predicate-declare.md) | EXPR | شرط في Rules | إعلان المحمول. تعبير الحكم |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | NODE | بند في Definitions | إعلان معيار الحكم (Backing). تحدد بتات role نوع التعريف |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | NODE | general rule، واسم القاعدة في Rules | إعلان ادعاء (Warrant). يمكن مهاجمته |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | NODE | counter rule | إعلان دحض. يهاجم ولديه استنتاجه الخاص. Level الافتراضي هو Fail |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | NODE | except rule | إعلان استثناء. يهاجم دون استنتاج خاص به. Level الافتراضي هو Review |
| `0x108L` | [ATTACKS](0x108L-attacks.md) | LINK | `don't X when Y` | علاقة هجوم. يخفض حكمُ المهاجِم حكمَ الهدف تدريجياً بمقدار قوة الهجوم (0 إلى 1، والافتراضي 1) |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | LINK | `X supersedes Y` | علاقة إقصاء. إذا كان المهاجِم Active أُسقط الهدف من التجميع حتماً. تُكتب السلسلة (`A > B > C`) علاقةً واحدة لكل زوج |
| `0x10AL` | [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) | — | | سلسلة أولوية `A > B > C`. اختصار لـ SUPERSEDES الزوجية. لم يُخصَّص سوى الرمز، ولا يوجد تخطيط بعد |
| `0x110L` | [RUN](0x110L-run.md) | LINK | `run c when n` | تركيب التنفيذ. إذا كانت العقدة Active نُفِّذت قضية فرعية (DAG) |
| `0x111L` | [DO](0x111L-do.md) | LINK | `do fn when n` | إجراء يُنفَّذ إذا كانت العقدة Active |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | LINK | `do fn once when n` | إجراء يُنفَّذ مرة واحدة فقط حتى عند إعادة المحاولة |
| `0x113L` | [UNDO](0x113L-undo.md) | LINK | `undo fn when n` | إجراء تعويضي لـ DO (saga). إذا فشلت خطوة لاحقة نُفِّذ بترتيب عكسي |
| `0x114L` | [CHECKING](0x114L-checking.md) | LINK | `checking c` | ربط يُجري الحكم فقط دون أثر جانبي |
| `0x115L` | [ENTRY](0x115L-entry.md) | NODE | `provides x` | نقطة دخول خارجية. تُنفِّذ قضية أو تحكم فيها |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | NODE | `on` و`every` و`until` | نقطة دخول لحدث أو دورة دون استدعاء خارجي |
| `0x118L` | [VERDICT](0x118L-verdict.md) | — | | نتيجة الحكم لعقدة أو سجل. النتيجة (Pass وReview وFail) وقيمة الحكم وActivated وExcluded وLevel. لم يُخصَّص سوى الرمز، ولا يوجد تخطيط بعد |
| `0x119L` | [EVIDENCE](0x119L-evidence.md) | — | | دليل الحكم. الموضع والقيمة المتوقعة والقيمة الفعلية (Fact). لم يُخصَّص سوى الرمز، ولا يوجد تخطيط بعد |
| `0x11CL~0x11FL` | Reserved | | | |

- الرموز المباشرة غير المذكورة في الجدول (`0x106L` و`0x107L`، و`0x10BL`~`0x10FL`، و`0x117L`، و`0x11AL` و`0x11BL`) هي Reserved.
- الحزم هي: `0x100L~0x107L` الإعلان، و`0x108L~0x10FL` العلاقة، و`0x110L~0x117L` التنفيذ، و`0x118L~0x11FL` النتيجة (`0x11CL~0x11FL` هي Reserved).
- الحكم على المستند كله من اختصاص Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`)، والحكم على العقدة أو السجل من اختصاص TOULMIN `VERDICT` (Edge `0x118L`). وهما Codec منفصلان من Kind مختلف.

### صيغة TOULMIN {#toulmin-형식}

يوضع النص الأصلي والتقسيم والعقد والعلاقات المساعدة في الرموز المباشرة `0x120L~0x134L` من عائلة صيغة TOULMIN في Edge. لا توجد خانتا Issuer ورقم Codec، ويأتي Payload مباشرة بعد TAG.

```
TAG WORD          0001 0010 0000 LLLL      Edge، وCodec 0x120L (SOURCE). والرموز الأخرى في الموضع نفسه
[TAG ممتد لـ Length]
Edge Id           سجل Reference من نوع LOCAL
المكوّنات          التخطيط الذي تحدده الصيغة
```

| Codec | الاسم | التخطيط | المعنى |
|---|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID وWORD لعرض SPAN وقيمة UTF8 Value | النص الأصلي المكتوب |
| `0x121L` | [TEXT](0x121L-text.md) | ID وقيمة UTF8 Value | اسم أو سلسلة نصية |
| `0x122L` | [SECTION](0x122L-section.md) | ID ورمز القسم في 1 WORD | بداية قسم |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID وREF (القضية) | بداية نطاق القضية |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID وREF (القضية) | نهاية نطاق القضية |
| `0x125L` | [PROSE](0x125L-prose.md) | ID وSPAN | فقرة سردية |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | NODE | `this document is` |
| `0x127L` | [FUNC](0x127L-func.md) | NODE | إشارة إلى دالة |
| `0x128L` | [FIELD](0x128L-field.md) | NODE | `is required` |
| `0x129L` | [ALIAS](0x129L-alias.md) | NODE | `see … from` |
| `0x12AL` | [GROUP](0x12AL-group.md) | NODE | حزمة تنفيذ مرتبة |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | LINK | قضية → حقل |
| `0x12CL` | [MEANS](0x12CL-means.md) | LINK | بند تعريف → قيمة أو نوع |
| `0x12DL` | [HAS](0x12DL-has.md) | LINK | بند تعريف → حقل |
| `0x12EL` | [RUNS](0x12EL-runs.md) | LINK | نقطة دخول → قضية، تنفيذ |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | LINK | نقطة دخول → قضية، حكم |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | LINK | محفّز → قضية |
| `0x131L` | [UNTIL](0x131L-until.md) | LINK | محفّز → قضية (`every … until`) |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | LINK | عقدة → معرّف عام |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | LINK | كنية → مسار (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | LINK | عقدة → TEXT، كتابة الاسم |

## المستند {#문서}

ملف `.geul` واحد هو DOC واحد. ولا توضع بايتات أخرى خارج DOC.

```
DOC-1WORD/2WORD/4WORD     الطول الكلي
  SPEC-VERSION            0x0001 (v1، عدد صحيح دون Value مضمنة)
  PROFILE                 UTF8 Value "tangeul-<major>.<minor>". الحالي "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE Value. لغة الكتابة ("en" و"ko")
BODY
  SOURCE                  النص الأصلي المكتوب. أول سجل في BODY
  سجلات الجمل …            بترتيب إعلان المستند
END
```

- HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md) و[PROFILE](../meta/0x1C6L-profile.md) واختيارياً [DEFAULT-LANGUAGE](../meta/0x1CAL-default-language.md).
- يرفض فاكّ الترميز المستند إذا اختلف SPEC-VERSION أو اختلف major في PROFILE. ويقرؤه إذا اختلف minor فقط.
- أول سجل في BODY هو SOURCE. وكل SPAN هو نطاق داخل هذا النص الأصلي.
- ترتيب سجلات الجمل هو ترتيب إعلان المستند نفسه. ويعتمد ترتيب التنفيذ (إطلاق `do` و`run`، والتعويض العكسي لـ `undo`) على هذا الترتيب. وفي مستند TOULMIN يحمل ترتيب Edge معنى (استثناء من قاعدة الترتيب في [تخطيط Edge](../edge/_index.md#레이아웃)).
- كل سجلات BODY هي Edge. ولا توضع سجلات Value مستقلة. وتُضمَّن القيم في Payload الخاص بـ Edge.
- تُستخدم Meta [DOC-ID](../meta/0x1C7L-doc-id.md) و[IMPORT-DOC](../meta/0x1E4L-import-doc.md) لهوية القضية واستيرادها (Subject وSee في TANGEUL).

## الحقول المشتركة {#공통-필드}

| الحقل | العرض | الوصف |
|---|---|---|
| ID | سجل Reference من نوع LOCAL | Edge Id للسجل. العنصر الأول في Payload لكل سجل |
| REF | سجل Reference من نوع LOCAL | Edge Id يشير إلى سجل آخر في هذا المستند. `0` تعني لا شيء |
| SPAN | العرض الذي يحدده SOURCE × 2 | نطاق داخل النص الأصلي المكتوب. بايت البداية وعدد البايتات |

- ID وREF سجل Reference مضمن من نوع [LOCAL](../reference/0x005L-local.md) (`0000 0000 0101 LLLL` + ID بأقصر عرض). ويحدد Length في ذلك السجل العرض، ولا يُعلن على مستوى المستند.
- REF `0` (LOCAL `0`) تعني «لا شيء». وهي قاعدة Codec التي تستخدم LOCAL `0` بمعنى لا شيء ([LOCAL](../reference/0x005L-local.md)).
- يُخصَّص Edge Id بدءاً من 1 ولا يتكرر داخل المستند. ولا يُستخدم `0` Edge Id لأنه «لا شيء» في REF.
- تشير سجلات أخرى إلى العقد إشارة أمامية، فتأخذ العقد أرقامها أولاً بترتيب إعلان المستند. أما السجلات الأخرى (SOURCE وTEXT وLINK وFUNC وسجلات التقسيم) فيخصص لها المرمِّز أرقاماً بدءاً من الرقم التالي للعقد.
- يتحقق فاكّ الترميز فقط من أن Edge Id ليس 0 وأنه لا تكرار. ولا يستخدم ترتيب التخصيص في التفسير.
- تُشار إلى العقد والعلاقات بـ Edge Id.
- Value المضمنة هي سجل Value كما هو بما فيه TAG WORD. ويحدد ذلك TAG طولها.

## الأعداد {#수치}

- قيمة الحكم (−1~1) وQualifier (0~1) وقوة الهجوم (0~1) هي [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md) Value. ولا توجد صيغة فاصلة ثابتة منفصلة.
- يحذف المرمِّز الأصفار الأخيرة من المعامل. 0.8 هي `C=8, E=−1`. ويقبل فاكّ الترميز حتى أربع منازل عشرية.
- تُكتب بوابة الثقة (مثل `at least 75%`) بـ WORD واحدة لعامل المقارنة و[UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md) Value للنسبة المئوية (`E=0`) ([LINK](#link) F_GATE).
- قوة الهجوم هي حقل F_FORCE في ATTACKS ([LINK](#공격-세기)). وتُرفض إذا خرجت عن النطاق.

## محاور إعلان العقدة {#노드-선언의-축}

- لإعلان العقدة (RULE وCOUNTER وEXCEPT-DECLARE) دور (ادعاء أو دحض أو استثناء) وQualifier (0~1) وLevel (Unset أو Fail أو Review). ويحمل الدور Codec وrole في ترويسة NODE، ويحمل Qualifier الحقل F_QUAL، ويحمل Level الحقل level في الترويسة ([NODE](#node)).
- الصلابة (Strict وDefeasible وDefeater) محور مستقل عن الدور. ولم يُحدد موضعها بعد.
- قوة الهجوم (Force) ليست للعقدة بل هي قيمة حافة ATTACKS ([LINK](#공격-세기) F_FORCE). وهي محور مختلف عن الصلابة.

## الحكم على المجهول {#미상-위에서-판정하기}

حين يتلقى رسم الحكم وقائع GEUL مدخلاً تُقيَّم المفاهيم الثلاثة في [علامة الموضع](../slot-marker.md) (غير مكتوب، وغير معروف، ولا قيمة) تقييماً مختلفاً. وتقييم عوامل المقارنة في [EXPR](0x101L-predicate-declare.md) كما يلي.

| المدخل | `is empty` | `is not empty` | `equals` / `is in` / مقارنة الحجم |
|---|---|---|---|
| قيمة v | خطأ | صحيح | يُقيَّم بـ v |
| NO-VALUE (لا قيمة) | **صحيح** | خطأ | خطأ |
| UNKNOWN-VALUE (غير معروف) | خطأ | **صحيح** | **غير محدد (U)** |
| ABSENT (غير مكتوب) / لا عبارة | U (عالم مفتوح) | U | U |

- يُستخدم منطق Kleene القوي ثلاثي القيم. `NOT U = U`، و`خطأ AND U = خطأ`، و`صحيح OR U = صحيح`. وسائر التركيبات التي فيها U ناتجها U.
- `EXISTS any` صحيح إن كان أحد العناصر صحيحاً. وإن لم يوجد صحيح ووُجد U فهو U، وإن كانت كلها خطأ فهو خطأ.
- **إذا كان المحمول U فحكم تلك العقدة ليس Pass ولا Fail بل Review.** ما لا يُعرف يُحال إلى إنسان (أو إلى الخطوة التالية).
- ولكي يُعدّ ABSENT فارغاً (empty) لا U، يجب أن **يعلن** جانب المدخل عالماً مغلقاً (يُحقن بمعيار الحكم SPEC، مثل «مدخلات هذه القضية كاملة»). وبدون إعلان يكون U.
- هذا الجدول والمقابلة بين U وReview هما معنى الحكم، فهما **نواة ثابتة**. ولا يمكن تغييرهما بمستند TOULMIN.
- مثال: قاعدة «لا تُعدّ إلا الحدود السارية الآن» (`P582 is empty`) تستبعد الحالة إذا كان P582 = UNKNOWN-VALUE لأنها خطأ، وتُدرجها إذا كان P582 = NO-VALUE لأنها صحيحة، وتحيلها إلى Review إذا لم يوجد P582 لأنها U.

## نتيجة الحكم {#판정-결과}

- تُوضع نتيجة الحكم (`VERDICT` و`EVIDENCE`) في مستند غير مستند الهدف المحكوم عليه. ويستورد مستند النتيجة مستند الهدف بـ [IMPORT-DOC](../meta/0x1E4L-import-doc.md) ويشير إليه بـ [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md). لذا لا تتغير تجزئة محتوى مستند الهدف بالحكم عليه.
- الحكم على المستند كله هو Meta `VERDICT`، والحكم على العقدة أو السجل هو TOULMIN `VERDICT`.
- وتُستخدم أيضاً قواعد اختيار الإصدار الذي تُطبَّق عليه المراجعة (الأحكام الانتقالية، واختيار قانون وقت الفعل أو القانون الجديد) والتفسيرات والسوابق قواعدَ حكم ([المستند](../document.md#개정)).

## مسائل مفتوحة {#열린-문제}

- تخطيط SUPERSEDE-CHAIN (`0x10AL`) وVERDICT (`0x118L`) وEVIDENCE (`0x119L`). وهل تكفي الطريقة الحالية، أي كتابة SUPERSEDES لكل زوج، للسلسلة.
- موضع صلابة العقدة (Strict وDefeasible وDefeater).
- ATTACKS التي كُتبت فيها قوة الهجوم 1 وATTACKS التي لم تُكتب فيها حكمهما واحد لكن بايتاتهما مختلفة. ويجب أن تُقارن بالقيمة المفسَّرة لا بالبايتات لمعرفة تساوي الحكم.
- عدد العقد وعدد التسميات وفهرس التسمية داخل EXPR هي 1 WORD، وعدد الأبناء 13 بت. فالحدود العليا ثابتة.
- تخطيط PROVENANCE (مصدر القاعدة ومقدماتها).
- هل يوضع الاسم بين علامتَي backtick في [LABEL](../edge/0x0A4L-label.md) و[BIND](../edge/0x0A3L-bind.md) السرديين بدلاً من TEXT + LABEL (`0x134L`).
- جدول قيم رموز predicate وmode في Claim، وقيم رموز VerbCode في FuncRef.
- هل يكون إعلان العالم المغلق (قراءة ABSENT على أنه empty) بمعيار الحكم (SPEC) أم على مستوى القضية.
- [مستند مواصفة Codec](../codec-spec.md) لـ Codec في TOULMIN. فالحقول الشرطية في NODE وLINK وعرض SPAN الذي يحدده SOURCE تخطيطات لا يمكن إعلانها بـ FIELD.

## صفحات ذات صلة {#관련-페이지}

- [NODE](#node)، [LINK](#link)، [EXPR](0x101L-predicate-declare.md)، [SOURCE والتقسيم](#source와-구획)
- [المستند](../document.md)، [PROFILE](../meta/0x1C6L-profile.md)

## NODE {#node}

NODE تخطيط يكتب عقد رسم الحكم والتنفيذ في TOULMIN. يحدد Codec نوع العقدة، وتحدد ترويسة من 1 WORD الدور وLevel وشكل Claim والحقول الشرطية.

### Codec {#codec}

| Codec | الاسم | TANGEUL | العقدة |
|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | `in case of` | قضية |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | بند في Definitions (`means` و`has`) | معيار الحكم (Backing). يحدد role نوع التعريف |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | general rule | ادعاء (Warrant) |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | counter rule | دحض (Rebuttal) |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | except rule | استثناء (Defeater) |
| `0x115L` | [ENTRY](0x115L-entry.md) | `provides x` | نقطة دخول خارجية |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | `on` و`every` و`until` | نقطة دخول لحدث أو دورة |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | `this document is` | فضاء أسماء المستند |
| `0x127L` | [FUNC](0x127L-func.md) | إشارة إلى دالة | دالة خارجية (مثل `bank.withdraw`) |
| `0x128L` | [FIELD](0x128L-field.md) | `x is required [as Type]` | حقل إلزامي |
| `0x129L` | [ALIAS](0x129L-alias.md) | `see a from path` | كنية الحزمة المستوردة |
| `0x12AL` | [GROUP](0x12AL-group.md) | قائمة مرقمة `1.` | حزمة تنفيذ مرتبة |

`0x126L~0x12AL` هي رموز مباشرة في عائلة صيغة TOULMIN في Edge ([TOULMIN](#toulmin-형식)).

### التخطيط {#레이아웃}

```
ID               سجل Reference من نوع LOCAL (Edge Id)
ترويسة 1 WORD    role 2b | Reserved 2b | F_GROUNDS 1b | level 2b | نوع object 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS، أو 0 إن لم يوجد) + VerbCode في 1 WORD
[F_QUAL]         قيمة SIGNED-DECIMAL Value. Qualifier
[F_CHECK]        REF (القضية)
[F_CLAIM]        Claim: REF(subject) + predicate في 1 WORD + object + mode في 1 WORD
[F_VERDICT]      قيمة SIGNED-DECIMAL Value. القيمة الابتدائية للحكم
[F_WITH]         العدد (UNSIGNED-INTEGER Value) + REF(TEXT) × العدد
[F_GROUNDS]      العدد (UNSIGNED-INTEGER Value) + REF(TEXT) × العدد
SPAN             العرض الذي يحدده SOURCE × 2 (بايت البداية، عدد البايتات)
```

#### WORD الترويسة {#헤더-word}

| البت | الحقل | القيمة |
|---|---|---|
| 15–14 | role | 0 general، 1 counter، 2 except |
| 13–12 | Reserved | 0 |
| 11 | F_GROUNDS | توجد قائمة أدلة |
| 10–9 | level | 0 Unset، 1 Fail، 2 Review (3 Reserved) |
| 8–7 | نوع object | شكل object في Claim. 0 REF، 1 UNSIGNED-INTEGER Value، 2 SPAN |
| 6–0 | flags | الجدول أدناه |

| البت | flag | المعنى |
|---|---|---|
| b0 | F_FUNC | يوجد حقل FuncRef |
| b1 | F_QUAL | يوجد حقل Qualifier |
| b2 | F_CHECK | يوجد حقل القضية المستهدفة بـ `checking` |
| b3 | F_CLAIM | يوجد حقل Claim |
| b4 | F_VERDICT | يوجد حقل القيمة الابتدائية للحكم |
| b5 | F_STRIKE | إعلان شُطب بخط. ولا حقل له |
| b6 | F_WITH | يوجد حقل قائمة المعايير |

- تُوضع الحقول الشرطية بترتيب flag (F_FUNC وF_QUAL وF_CHECK وF_CLAIM وF_VERDICT وF_WITH وF_GROUNDS). والحقل الذي طُفئ flag الخاص به لا يشغل موضعاً.
- يُرفض السجل إذا شُغِّل flag ولم يوجد الحقل. ويجب أن يطابق موضع انتهاء قراءة الحقول بالتتابع نهاية السجل تماماً بعد SPAN.

### الحقول {#필드}

| الحقل | الوصف |
|---|---|
| FuncRef | موضع الدالة. REF هو سجل ALIAS الذي استورد الدالة، وهو `0` إن كانت الدالة من هذا المستند. VerbCode رمز من 1 WORD لم يُخصَّص بعد (`0x0000` مسموح). ويُكتب التمثيل النصي الأصلي للدالة منفصلاً بـ TEXT + [LABEL](#link) |
| Qualifier | درجة ثقة العقدة (0~1) |
| القضية | F_CHECK: القضية التي تكتفي هذه العقدة بالحكم عليها (`checking c`) |
| Claim | القضية المنطقية التي تحملها العقدة. subject REF وpredicate في 1 WORD وobject وmode في 1 WORD. ويحدد نوع object في الترويسة شكل object |
| قيمة الحكم | القيمة الابتدائية لقيمة الحكم (−1~1) |
| F_WITH | معيار الحكم وقت الإعلان (`기준으로 하는`). قائمة REF لسجلات TEXT |
| F_GROUNDS | أسماء الوقائع الخارجية التي تُفسَّر وقت التقييم (`근거로 하는`). قائمة REF لسجلات TEXT |
| SPAN | نطاق النص الأصلي الذي جاء منه هذا الإعلان |

- يتبع تمثيل قيمة الحكم وQualifier قواعد الأعداد في [TOULMIN](#수치).
- عدد عناصر القائمة هو سجل [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md) Value مضمن.
- الشكل الافتراضي لـ Claim السردي أن يكون subject وpredicate بالقيمة `0` وobject هو SPAN (نوع object هو 2). فيُثبَّت على التمثيل النصي الأصلي.

### التفسير والصلاحية {#해석과-유효성}

- يجب أن يطابق role في RULE وCOUNTER وEXCEPT-DECLARE قيمة Codec (0 general، و1 counter، و2 except). وفي SPEC-DECLARE هو نوع التعريف. وفي سائر Codec هو 0.
- إذا كان level بالقيمة 0 (Unset) استُخدمت القيمة الافتراضية للمحرك: Fail في COUNTER-DECLARE وReview في EXCEPT-DECLARE.
- قاعدة الدالة المضيفة في TANGEUL `tangl:규칙` (`쓰는 규칙이다`) تُكتب NODE من نوع RULE-DECLARE خارج القضية. فالدالة هي F_FUNC، والمعيار هو F_WITH، والأدلة هي F_GROUNDS. ولا يوضع [PREDICATE-DECLARE](0x101L-predicate-declare.md) في المقدمة إلا لقاعدة التعبير الشرطي.
- يجب أن تكون بتات Reserved (13–12) بالقيمة 0. ويُرفض السجل إذا شُغّلت بتة Reserved أو لم يطابق role قيمة Codec.

### صفحات ذات صلة {#관련-페이지-1}

- [TOULMIN](_index.md)، [LINK](#link)، [EXPR](0x101L-predicate-declare.md)، [SOURCE والتقسيم](#source와-구획)
- [LOCAL](../reference/0x005L-local.md)، [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## LINK {#link}

LINK تخطيط يكتب العلاقات بين العقد في رسم TOULMIN. ويحدد Codec نوع العلاقة.

### Codec {#codec-1}

| Codec | الاسم | TANGEUL | src → dst |
|---|---|---|---|
| `0x108L` | [ATTACKS](0x108L-attacks.md) | `don't X when Y` | قاعدة → قاعدة. يخفض الحكم تدريجياً بمقدار قوة الهجوم |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | `X supersedes Y` | قاعدة → قاعدة. إذا كان Active أُسقط الهدف من التجميع |
| `0x110L` | [RUN](0x110L-run.md) | `run c when n` | قاعدة → قضية |
| `0x111L` | [DO](0x111L-do.md) | `do fn when n` | قاعدة → FuncRef |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | `do fn once when n` | قاعدة → FuncRef |
| `0x113L` | [UNDO](0x113L-undo.md) | `undo fn when n` | قاعدة → FuncRef |
| `0x114L` | [CHECKING](0x114L-checking.md) | `checking c` | قاعدة → قضية. حكم دون أثر جانبي |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | `f is required` | قضية → حقل |
| `0x12CL` | [MEANS](0x12CL-means.md) | `means` في Definitions | بند تعريف → قيمة أو نوع |
| `0x12DL` | [HAS](0x12DL-has.md) | `has` في Definitions | بند تعريف → حقل |
| `0x12EL` | [RUNS](0x12EL-runs.md) | نقطة دخول `run c` | نقطة دخول → قضية (تنفيذ) |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | نقطة دخول `check c` | نقطة دخول → قضية (حكم) |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | محفّز `run c` | محفّز → قضية |
| `0x131L` | [UNTIL](0x131L-until.md) | `every … until c` | محفّز → قضية |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | | عقدة → معرّف عام |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | `see a from path` | كنية → مسار (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | اسم بين علامتَي backtick | عقدة → TEXT. كتابة الاسم |

### التخطيط {#레이아웃-1}

```
ID               سجل Reference من نوع LOCAL (Edge Id)
src              REF
dst              REF. وفي DO وDO-ONCE وUNDO هو FuncRef
flags 1 WORD     b0 F_ONCE، b1 F_GATE، b2 F_STRIKE، b3 F_ORDERED، b4 F_FORCE
[F_GATE]         عامل في 1 WORD (أعلى 2 بت) + UNSIGNED-DECIMAL Value (نسبة مئوية)
[F_FORCE]        قيمة SIGNED-DECIMAL Value. قوة الهجوم (0~1). في ATTACKS فقط
SPAN             العرض الذي يحدده SOURCE × 2
```

| flag | المعنى |
|---|---|
| b0 F_ONCE | يُنفَّذ مرة واحدة فقط (`once` الخاصة بـ UNDO) |
| b1 F_GATE | يوجد حقل بوابة الثقة |
| b2 F_STRIKE | علاقة شُطبت بخط |
| b3 F_ORDERED | تنتمي إلى قائمة مرقمة `1.` |
| b4 F_FORCE | يوجد حقل قوة الهجوم. في ATTACKS فقط |

| عامل البوابة | المعنى |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- تُوضع الحقول الشرطية بترتيب flag (F_GATE وF_FORCE). والحقل الذي طُفئ flag الخاص به لا يشغل موضعاً.

### قوة الهجوم {#공격-세기}

قوة الهجوم (F_FORCE) لا يستخدمها إلا [ATTACKS](0x108L-attacks.md#공격-세기). وتفصيل صيغة الحكم والتمثيل والمثال في صفحته.

### التفسير والصلاحية {#해석과-유효성-1}

- REF هو Edge Id لسجل في هذا المستند (الحقول المشتركة في [TOULMIN](#공통-필드)).
- يحدد Codec شكل dst. ففي DO وDO-ONCE وUNDO هو FuncRef (REF(ALIAS، أو 0 إن لم يوجد) + VerbCode في 1 WORD، [NODE](#필드))، وفي LABEL وIMPORTED-FROM هو REF لسجل TEXT، وفي الباقي هو REF لعقدة.
- يمثّل Codec من نوع DO-ONCE الصيغة `do … once`. ولا يُستخدم F_ONCE في flags الخاصة بـ DO-ONCE (يُرفض إن كان مفعّلًا). أما `once` الخاصة بـ UNDO فتُكتب بـ F_ONCE.
- عامل البوابة هو أعلى 2 بت في WORD العامل، والـ14 بت الباقية 0. والنسبة المئوية UNSIGNED-DECIMAL Value بـ `E=0` وقيمتها 0~100.
- البتات b5~b15 في flags هي Reserved ويجب أن تكون 0. وإلا رُفض السجل.
- يُستخدم F_FORCE في ATTACKS فقط. ويُرفض السجل إذا كان مفعّلاً في Codec آخر (SUPERSEDES وروابط التنفيذ والحكم وعلاقات صيغة TOULMIN).
- يُرفض السجل إذا لم تكن قوة الهجوم SIGNED-DECIMAL Value، أو كانت خارج 0~1، أو لم يمكن تمثيلها تمثيلاً دقيقاً بأربع منازل عشرية.
- تُكتب السلسلة `A > B > C` في SUPERSEDES علاقةَ SUPERSEDES واحدة لكل زوج.

### صفحات ذات صلة {#관련-페이지-2}

- [TOULMIN](_index.md)، [NODE](#node)، [SOURCE والتقسيم](#source와-구획)
- [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md)، [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## SOURCE والتقسيم {#source와-구획}

سجلات تكتب النص الأصلي والتقسيم في مستند TOULMIN. وكلها رموز مباشرة `0x120L~0x125L` في عائلة صيغة TOULMIN في Edge ([TOULMIN](#toulmin-형식)). ويأتي Payload بعد TAG دون خانتَي Issuer ورقم Codec.

### الصيغة {#형식}

| Codec | الاسم | التخطيط |
|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID وWORD لعرض SPAN وقيمة UTF8 Value |
| `0x121L` | [TEXT](0x121L-text.md) | ID وقيمة UTF8 Value |
| `0x122L` | [SECTION](0x122L-section.md) | ID ورمز القسم في 1 WORD |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID وREF (القضية) |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID وREF (القضية) |
| `0x125L` | [PROSE](0x125L-prose.md) | ID وSPAN |

- ID هو Edge Id، وREF هو Edge Id لسجل في هذا المستند (الحقول المشتركة في [TOULMIN](#공통-필드)).
- UTF8 Value هي سجل [UTF8-TEXT](../value/0x072L-utf8-text.md) Value. وتحمل البايتات كما هي.

### صفحات الصيغ {#형식별-쪽}

لكل صيغة صفحة مستقلة للتخطيط وجدول رموز القسم والتفسير.

- [SOURCE](0x120L-source.md): النص الأصلي المكتوب. هو أول سجل في BODY ويحدد عرض SPAN
- [TEXT](0x121L-text.md): اسم أو سلسلة نصية
- [SECTION](0x122L-section.md): بداية القسم ورمز القسم
- [CASE-BEGIN](0x123L-case-begin.md)، [CASE-END](0x124L-case-end.md): نطاق القضية
- [PROSE](0x125L-prose.md): فقرة سردية

### صفحات ذات صلة {#관련-페이지-3}

- [TOULMIN](_index.md)، [NODE](#node)، [LINK](#link)
