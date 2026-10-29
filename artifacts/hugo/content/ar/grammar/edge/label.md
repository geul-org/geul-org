---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL هو Edge وصف يربط اسماً واحداً بحسب اللغة لهدف Subject بـ Object من نوع UTF8-LANGUAGE-TEXT (Codec 0x04)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL هو Edge وصف يربط اسماً (label) بلغة معينة لهدف Subject على أنه Object. Codec `0x04`. وليس Edge يمثل lemma بالمعنى المعجمي العام.

يُحمل الاسم ولغته في Object واحد هو [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/). ولا يوجد حقل قيمة خام.

## التخطيط

```
TAG WORD          0001 0LLL L000 0100
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
Subject           سجل Reference واحد
Object            قيمة UTF8-LANGUAGE-TEXT أو سجل Reference واحد من نوع LOCAL
```

## التفسير والصلاحية

- Subject هو سجل Reference كامل واحد بالضبط. تُعرف حدوده بـ Length الخاص به، ويكون invalid إن لم يكن Reference أو كان ناقصاً.
- Object هو سجل [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/) (`0x4A`·`0x4B`) كامل واحد بالضبط. وقواعد اللغة والنص (قبول صيغتي اللغة كلتيهما ومقارنة اللغة نفسها) تتبع تلك الصيغة.
- يمكن أن يكون Object أيضاً Reference من نوع LOCAL. وعندئذ يجب أن يُحل إلى UTF8-LANGUAGE-TEXT بربط [REFERENCE-NODE](/ar/grammar/edge/reference-node/) في المستند نفسه. وإن لم يُحل أو حُل إلى هدف من نوع آخر فهو invalid.
- تكتب مواصفة geul.org هذا القيد بـ [CODEC](/ar/grammar/edge/codec/) (Object = `084A`·`084B`·`0008`). ولا يُعبَّر بـ CODEC عن هدف حلّ LOCAL.
- يكون invalid إذا لم يكن Object أحد الصيغتين أعلاه أو كان السجل ناقصاً. والنص بلا لغة (UTF8-TEXT) لا يمكن أن يكون LABEL. والاسم بلا لغة للآلة يُكتب بـ [BIND](/ar/grammar/edge/bind/). والاسم المشترك بين عدة لغات يُكتب بلغة `mul`.
- لا يكون لـ Subject واللغة نفسيهما أكثر من LABEL واحد. والأسماء الأخرى تُكتب بـ [ALIAS](/ar/grammar/edge/alias/).

## الطول

```
المجموع = 1 + N_len + N_id + N_subject + N_object WORD
```

- سجل اللغة وعدد بايتات النص في Object من شأن سجل Object لا Edge. ويجب أن يتطابق المؤشر بعد قراءة آخر سجل مع نهاية Edge تماماً.

## أمثلة (غير معيارية)

رمز اللغة `0784` لـ `en` هو الرقم الوارد في مسودة GEUL Language Registry (draft-0). ولأن السجل لم يُختم بعد، فهو قيمة غير معيارية وليس رمزاً نهائياً.

### LANGUAGE-SHORT-CODE

Edge Id `0007`، وSubject Q22686 (`00A0 589e`)، وObject `Donald Trump` (en).

- Object هو اللغة `08C8 0784` (SHORT-CODE 2 WORD) + نص من 12 byte (زوجي، 6 WORD) فهو `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`)، والمجموع 9 WORD `0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70`.
- Edge هو TAG (1) + Edge Id (2) + Subject (2) + Object (9) = 14 WORD و`LLLL=1101`. وTAG هو `1684`.

```
1684 0088 0007 00A0 589e 0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`، وSubject Q155 (`00A0 009b`)، وObject `Brasil` (pt-BR).

- Object هو اللغة `09C7 7074 2d42 5200` (BCP47 `pt-BR`، 4 WORD) + نص من 6 bytes (زوجي، 3 WORD) فالمجموع 8 WORD `0BCA 09C7 7074 2d42 5200 4272 6173 696c`.
- Edge هو TAG (1) + Edge Id (2) + Subject (2) + Object (8) = 13 WORD و`LLLL=1100`. وTAG هو `1604`.

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## صفحات ذات صلة

- [Edge](/ar/grammar/edge/)، [ALIAS](/ar/grammar/edge/alias/)، [DESCRIPTION](/ar/grammar/edge/description/)، [BIND](/ar/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/)، [LANGUAGE-SHORT-CODE](/ar/grammar/value/text/language-short-code/)، [LANGUAGE-BCP47-CODE](/ar/grammar/value/text/language-bcp47-code/)
- [LOCAL](/ar/grammar/reference/local/)، [REFERENCE-NODE](/ar/grammar/edge/reference-node/)
