---
title: "FIELD"
weight: 29
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD هو Edge وصف يصرّح بحقل واحد في Payload الخاص بـ Codec (Codec 0x1C). يكتب DECLARE الذي ينتمي إليه والعرض (سجل أو قيمة خام بعدد n من WORD أو القيمة الخام المتبقية)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD هو Edge وصف يصرّح بحقل واحد في Payload الخاص بـ Codec. Codec `0x1C`.

يشير FIELD إلى [DECLARE](/ar/grammar/edge/declare/) الخاص به. وتكوّن FIELD التي تشير إلى DECLARE واحد Payload بترتيبها في المستند. تخطيطه مدمج في المفكك ([مواصفة Codec](/ar/grammar/codec-spec/)).

## التخطيط

```
TAG WORD          0001 0LLL L001 1100
Edge Id           سجل Reference من نوع LOCAL
DECLARE           سجل Reference من نوع LOCAL. Edge من نوع DECLARE ينتمي إليه هذا الحقل
العرض             1 WORD. 0 = سجل، n (1~65534) = قيمة خام بعدد n من WORD، 0xFFFF = القيمة الخام المتبقية
```

## التفسير والصلاحية

- يشير DECLARE إلى Edge من نوع DECLARE في المستند نفسه. وFIELD الواحد ينتمي إلى DECLARE واحد فقط. ولا يُكتب الترتيب على حدة بل هو ترتيب وضع سجلات FIELD في المستند.
- يصرّح مستند مواصفة FIELD بـ DECLARE كحقل عرضه `0` (سجل) وCODEC `0008` (LOCAL). لذلك يُرسم في رسم العارض اتصال FIELD → DECLARE.
- العرض `0` هو حقل سجل. يبدأ بـ TAG WORD ويُقرأ بقدر Length ذلك TAG (قواعد التفسير في [DECLARE](/ar/grammar/edge/declare/)).
- العرض `n` (1~65534) هو حقل قيمة خام. ودائماً n WORD بالضبط.
- العرض `0xFFFF` هو القيمة الخام المتبقية. لا يوضع منه في DECLARE إلا واحد ويجوز أن يكون في البداية أو الوسط أو النهاية. عرضه هو ما بقي من WORD بحسب Length في TAG السجل الخارجي بعد طرح عروض الحقول التي تليه. لذلك يجب أن تكون كل الحقول بعد الحقل المتبقي قيماً خاماً ثابتة العرض (فالسجل يجب أن يُقرأ من البداية ليُعرف آخره). ويجوز أن يكون 0 WORD. ولا يُلحق به ENUM.
- Kind وCodec اللذان يقبلهما الحقل يحددهما [CODEC](/ar/grammar/edge/codec/). حقل السجل إن لم يكن له CODEC قَبِل أي سجل، وإن كان له فيجب أن يكون أحدها. وإذا وُضع CODEC واحد لحقل قيمة خام فُسِّرت تلك القيمة الخام على أنها Value ذاك بعد طرح TAG.
- اسم الحقل يُربط بـ Edge Id الخاص بـ FIELD بـ [BIND](/ar/grammar/edge/bind/) (مثل `doc` و`hash`). وكل UTF8-TEXT يُلحق بـ DECLARE وFIELD وENUM وCODEC يكون بـ BIND، ولا يُلحق بـ Edge أخرى مثل LABEL.
- معنى قيمة الرمز في حقل القيمة الخام يُلحق بـ [ENUM](/ar/grammar/edge/enum/).
- الحقل الذي يشير إلى عقدة أخرى في الرسم لا يُعلَّم على حدة. فإذا كان حقل السجل Reference فهذا هو الاتصال.

## الطول

```
المجموع = 1 + 2 + 2 + 1 WORD   (عندما يكون كل من Edge Id وDECLARE معرّف LOCAL من 1 WORD)
```

## أمثلة (غير معيارية)

- حقل سجل: Edge Id 7، وDECLARE #1، والعرض `0`. TAG (1) + Edge Id (2) + DECLARE (2) + العرض (1) = 6 WORD. ولجعله يقبل LOCAL فقط انظر مثال [CODEC](/ar/grammar/edge/codec/).

```
129C 0088 0007 0088 0001 0000
```

- حقل القيمة الخام مثل تجزئة المحتوى: انظر مثال [DECLARE](/ar/grammar/edge/declare/).

## صفحات ذات صلة

- [DECLARE](/ar/grammar/edge/declare/)، [ENUM](/ar/grammar/edge/enum/)، [CODEC](/ar/grammar/edge/codec/)، [BIND](/ar/grammar/edge/bind/)
- [مواصفة Codec](/ar/grammar/codec-spec/)
