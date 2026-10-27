---
title: "DECLARE"
weight: 28
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE هو Edge وصف يصرّح ببنية Payload لـ Codec واحد (Codec 0x1B). وهو مع FIELD وENUM وCODEC مفردات كتابة مستند مواصفة Codec."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECLARE هو Edge وصف يصرّح ببنية Payload لـ Codec واحد. Codec `0x1B`.

هو مع [FIELD](/ar/grammar/edge/field/) (`0x1C`) و[ENUM](/ar/grammar/edge/enum/) (`0x1D`) و[CODEC](/ar/grammar/edge/codec/) (`0x1E`) مفردات كتابة مواصفة Codec ([مواصفة Codec](/ar/grammar/codec-spec/)). تخطيط هذه الـ Edge الأربع مدمج في المفكك. أما كل مستند مواصفة Codec مكتوب بهذه المفردات فهو مستند عادي. وبمواصفة واحدة يجري التحقق والتحليل والعرض (العارض) معاً. فالعارض لا يضع كوداً لكل Codec بل يرسم بحسب المواصفة.

## التخطيط

```
TAG WORD          0001 0LLL L001 1011
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
الهدف             1 WORD. تُستخدم من TAG WORD الخاصة بالـ Codec المصرَّح به موضعا Kind وCodec فقط (LLLL = 0)
[Issuer·رقم الصيغة] عندما يكون الهدف صيغة Issuer. التخطيط نفسه في Codec ممتد TAG
```

- لا توضع قائمة الحقول في DECLARE. فكل [FIELD](/ar/grammar/edge/field/) يشير إلى DECLARE الخاص به، وترتيب تلك FIELD في المستند هو ترتيب حقول Payload.

## قواعد التفسير

هذه قواعد قراءة السجل وكتابته بمواصفة Codec.

- حقل القيمة الخام يُقرأ بعدد WORD الثابت الذي صرّح به FIELD. ويمكن أن يكون حقل واحد هو القيمة الخام المتبقية (العرض `0xFFFF`)، فيُقرأ منه ما بقي من WORD بعد طرح عروض الحقول الثابتة التي تليه. وبعد الحقل المتبقي لا توضع إلا قيم خام ثابتة العرض.
- حقل السجل يبدأ بـ TAG WORD ويُقرأ بقدر Length الخاص بذلك TAG.
- حقل القيمة الخام عدد صحيح بلا إشارة من n WORD بترتيب big-endian. وتُكتب بـ `0x` + عدد خانات hex يساوي العرض×4، وإذا وُجد ENUM لقيمة نفسها فيُكتب معها اسم BIND الخاص به.
- معنى حقل السجل تحدده مواصفة Codec الخاصة بذلك السجل. والقيم التي تحتاج إلى تفسير كالإشارة والكسر والتاريخ تُوضع في سجل Value لا في قيمة خام.

لا توجد قواعد حدود أخرى. فلا يمكن التصريح بهذه المفردات عن Codec فيه أكثر من قيمة خام متغيرة، أو يأتي بعد القيمة الخام المتغيرة سجل أو حقل متغير، أو يتغير فيه عرض القيمة الخام بحسب قيم حقول أخرى أو حالة المستند. وتترك مثل هذه التخطيطات جزءاً متغيراً واحداً بعد تغليف الجزء المتغير في سجل (مثلاً: الموقِّع في SIGNATURE سجل Reference).

## الصلاحية

- Kind الهدف هو أحد Reference وValue وEdge وMeta. وCodec في Reference هو موضع `CCCC` ويُترك Quantifier عند 0.
- [علامة الموضع](/ar/grammar/reference/slot-marker/) (Reference Codec `0000`) لا يمكن أن تكون هدف DECLARE. فهي مدمجة في المفكك (الطبقة 0).
- Edge Id الخاص بـ Edge لا يُصرَّح به بـ FIELD. فهو العنصر الأول في كل Edge فهو ضمني ([Edge](/ar/grammar/edge/)).
- حقول DECLARE هي FIELD التي تشير إليه، ويمكن أن تكون 0. وFIELD الواحدة تنتمي إلى DECLARE واحد فقط. وحتى الحقل ذو الشكل نفسه توضع له FIELD مستقلة لكل DECLARE.
- ليس في DECLARE شيء غير الهدف (وIssuer ورقم الصيغة إن كان الهدف صيغة Issuer).
- يجب أن يتطابق المؤشر بعد قراءة الحقول بالترتيب مع نهاية السجل تماماً. وإذا زاد أو نقص فهو مخالفة للمواصفة.
- لا يُصرَّح بالهدف نفسه مرتين في مستند واحد.
- المتغيرات التي تختلف في الحقول الأخيرة لا تُستخدم كفروع. يوضع DECLARE مستقل لكل Codec.

## مستند المواصفة

- مستند مواصفة الرمز المباشر هو مستند عادي في GEUL Issuer `0x0000`. معرّف المستند هو TAG WORD الهدف ممدوداً إلى 4 WORD (`0x1018` → `0x0000000000001018`)، ويُنشر بالطريقة نفسها لمستندات Issuer الأخرى (معرّف الإصدار و`versions.geul`) ([مواصفة Codec](/ar/grammar/codec-spec/)).
- في مستند مواصفة واحد DECLARE واحد، ويجب أن يطابق هدفه TAG WORD الموجودة في معرّف المستند. و`DOC-ID` هو DOC-POINTER (`0x0000` ومعرّف ذلك المستند و`0`).

## الاسم

- اسم Codec يُربط بـ Edge Id الخاص بـ DECLARE بـ [BIND](/ar/grammar/edge/bind/) (مثل `PUBLICATION`). وكل UTF8-TEXT يُلحق بـ DECLARE وFIELD وENUM وCODEC يكون بـ BIND، ولا يُلحق بـ Edge أخرى مثل LABEL.
- واسم الحقل واسم enum يُربطان بـ FIELD وENUM بالطريقة نفسها.

## أمثلة

مستند مواصفة PUBLICATION (Edge `0x18`) `geul.org/publication`: بعد Edge Id سجل DOC-POINTER ثم تجزئة المحتوى من 16 WORD.

```
119B 0088 0001 1018                 DECLARE #1  Edge 0x18                 (BIND "PUBLICATION")
129C 0088 0002 0088 0001 0000       FIELD #2    DECLARE #1, سجل            (BIND "doc")
129E 0088 0009 0088 0002 0038       CODEC #9    FIELD #2, DOC-POINTER
129C 0088 0004 0088 0001 0010       FIELD #4    DECLARE #1, قيمة خام 16 WORD   (BIND "hash")
```

- DECLARE: TAG (1) + Edge Id (2) + الهدف (1) = 4 WORD، و`LLLL = 0011`.
- FIELD: TAG (1) + Edge Id (2) + DECLARE (2) + العرض (1) = 6 WORD (`LLLL = 0101`). أما Kind وCodec اللذان يقبلهما فيوضعان على حدة بـ [CODEC](/ar/grammar/edge/codec/) (`0038` = DOC-POINTER).
- الحقل الاختياري يُصرَّح به بهدف CODEC `0000`. وفي الموضع المحذوف تُكتب ABSENT (`0x0000`) ([CODEC](/ar/grammar/edge/codec/) الحقل الاختياري).
- ترتيب الحقول هو ترتيب وضع FIELD #2 و#4 في المستند. ولا يلزم أن تتتابع Edge Id (LOCAL AUTO INCREMENT توصية).

## مسائل مفتوحة

- التكرار. بنية يحدد فيها قيمة خام سابقة العدد مثل "المعاملات × عددها" في `CALL`. لا يمكن التصريح بها الآن.
- طريقة التصريح بـ Codec له صيغ فرعية (TAG لكل Codec) مثل WORLD.
- طريقة العثور على مستند مواصفة صيغة Issuer (Issuer ورقم الصيغة ← عنوان مستند المواصفة).
- أي حزمة إصدارات من مستندات مواصفة الرموز المباشرة يعنيها `SPEC-VERSION`.

## صفحات ذات صلة

- [FIELD](/ar/grammar/edge/field/)، [ENUM](/ar/grammar/edge/enum/)، [CODEC](/ar/grammar/edge/codec/)، [BIND](/ar/grammar/edge/bind/)
- [Edge](/ar/grammar/edge/)، [مواصفة Codec](/ar/grammar/codec-spec/)
