---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM هو Edge وصف يعطي معنى لقيمة رمز واحدة في حقل القيمة الخام (Codec 0x1D). يُربط الاسم بـ BIND."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM هو Edge وصف يعطي معنى لقيمة رمز واحدة في حقل القيمة الخام. Codec `0x1D`.

هو مع [FIELD](/ar/grammar/edge/field/) مفردات كتابة مواصفة Codec. تخطيطه مدمج في المفكك ([مواصفة Codec](/ar/grammar/codec-spec/)).

## التخطيط

```
TAG WORD          0001 0LLL L001 1101
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
الحقل             سجل Reference من نوع LOCAL يشير إلى Edge من نوع FIELD
قيمة الرمز        قيمة خام. بعدد WORD يساوي عرض ذلك FIELD
```

## التفسير والصلاحية

- يجب أن يكون الحقل FIELD لقيمة خام (العرض `n ≥ 1`). لا يُلحق ENUM بحقل سجل. فمعنى السجل يقوله Codec الخاص بذلك السجل.
- قيمة الرمز بقدر عرض ذلك FIELD بالضبط. ويُتحقق من الحدود بـ Length سجل ENUM.
- لا يُصرَّح بقيمة الرمز نفسها مرتين في حقل واحد.
- اسم قيمة الرمز يُربط بـ Edge Id الخاص بـ ENUM بـ [BIND](/ar/grammar/edge/bind/). وكل UTF8-TEXT يُلحق بـ DECLARE وFIELD وENUM وCODEC يكون بـ BIND، ولا يُلحق بـ Edge أخرى مثل LABEL.
- قيمة الرمز غير المصرَّح بها ليست خطأً. يعرضها العارض كقيمة خام كما هي. وإغلاق القيم المسموحة من شأن مواصفة Codec، وليس في المفردات الحالية علامة للإغلاق.

## الطول

```
المجموع = 1 + N_len + N_id + N_field + n WORD
```

## أمثلة (غير معيارية)

يُصرَّح بالرمز `0x0001` في حقل فئة السبب (FIELD #4، قيمة خام من 1 WORD) في مستند مواصفة TOMBSTONE. Edge Id 10. ويُربط الاسم بـ BIND على حدة. وجدول رموز فئات السبب لم يتحدد بعد، فقيمة الرمز مثال.

- TAG (1) + Edge Id (2) + الحقل (2) + قيمة الرمز (1) = 6 WORD، `LLLL = 0101`.

```
129D 0088 000A 0088 0004 0001
```

يضع مستند مواصفة TRIPLE ثلاث ENUM (`0` و`1` و`2`) في حقل Rank (FIELD #5) ويربطها بـ BIND بالأسماء `normal` و`preferred` و`deprecated` ([TRIPLE](/ar/grammar/edge/triple/)).

## صفحات ذات صلة

- [DECLARE](/ar/grammar/edge/declare/)، [FIELD](/ar/grammar/edge/field/)، [CODEC](/ar/grammar/edge/codec/)، [BIND](/ar/grammar/edge/bind/)
- [مواصفة Codec](/ar/grammar/codec-spec/)
