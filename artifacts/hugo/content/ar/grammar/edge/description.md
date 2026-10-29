---
title: "DESCRIPTION"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION هو Edge وصف يربط وصفاً قصيراً واحداً بحسب اللغة لهدف Subject (Codec 0x06). تخطيطه مثل LABEL."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIPTION هو Edge وصف يربط وصفاً بلغة معينة لهدف Subject على أنه Object. Codec `0x06`.

الوصف عبارة قصيرة تميّز الهدف (description في ويكي بيانات، مثل: "عاصمة ألمانيا وأكبر مدنها"). ليس تعريفاً للهدف ولا دعوى. والقضايا عن الهدف تُكتب بـ [TRIPLE](/ar/grammar/edge/triple/). تخطيطه مثل [LABEL](/ar/grammar/edge/label/). ويُحمل الوصف ولغته في Object واحد هو [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/). ولا يوجد حقل قيمة خام.

## التخطيط

```
TAG WORD          0001 0LLL L000 0110
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
Subject           سجل Reference واحد
Object            قيمة UTF8-LANGUAGE-TEXT أو سجل Reference واحد من نوع LOCAL
```

## التفسير والصلاحية

- قواعد Subject وObject مثل [LABEL](/ar/grammar/edge/label/). Subject هو سجل Reference كامل واحد بالضبط. وObject إما سجل UTF8-LANGUAGE-TEXT (`0x4A`·`0x4B`) كامل واحد بالضبط، أو Reference من نوع LOCAL يُحل إلى UTF8-LANGUAGE-TEXT بربط [REFERENCE-NODE](/ar/grammar/edge/reference-node/) في المستند نفسه.
- النص بلا لغة (UTF8-TEXT) لا يمكن أن يكون DESCRIPTION. فالوصف واحد لكل لغة، وبوجود لغة تقوم تلك القاعدة. والوصف المشترك بين عدة لغات يُكتب بلغة `mul`.
- لا يكون لـ Subject واللغة نفسيهما أكثر من DESCRIPTION واحد.
- يُستخدم الوصف للتمييز عن هدف آخر يحمل الاسم نفسه. والأفضل ألا يتداخل زوج LABEL وDESCRIPTION في اللغة نفسها بين هدفين، لكن المواصفة لا تفحص ذلك (وهو توصية في ويكي بيانات أيضاً لا إلزام).
- تقصر مواصفة geul.org الـ Object على [CODEC](/ar/grammar/edge/codec/) (`084A` و`084B` و`0008`، مثل LABEL).

## الطول

```
المجموع = 1 + N_len + N_id + N_subject + N_object WORD
```

- سجل اللغة وعدد بايتات النص في Object من شأن سجل Object. ويجب أن يتطابق المؤشر بعد قراءة آخر سجل مع نهاية Edge تماماً.
- الوصف أطول من التسمية، فيسهل أن يتجاوز كل من Object وEdge 15 WORD. وعندئذ يُستخدم Length الممتد ([السجل](/ar/grammar/record/)).

## أمثلة (غير معيارية)

Edge Id `0009`، وSubject Q64 (`00A0 0040`)، وObject `capital and largest city of Germany` (en). اللغة مثال على صيغة LANGUAGE-BCP47-CODE (لـ `en` رقم السجل `0x0784`، فيمكن كتابتها أيضاً بصيغة SHORT-CODE).

- Object هو اللغة `08C6 656E` (BCP47 `en`، 2 WORD) + نص من 35 byte (فردي، 18 WORD) فهو `0x4B`، وTAG (1) + TAG ممتد (1) + 20 = 22 WORD، `0F4B 0016 …`.
- Edge هو TAG (1) + TAG ممتد (1) + Edge Id (2) + Subject (2) + Object (22) = 28 WORD فـ `LLLL=1110`، وTAG هو `1706`، وTAG الممتد `001C`.

```
1706 001C 0088 0009 00A0 0040
0F4B 0016 08C6 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## المقابل في ويكي بيانات

- `descriptions` الخاصة بالعنصر (واحد لكل لغة) ← DESCRIPTION واحد لكل لغة. ويُنقل رمز اللغة بجدول مقابلة رموز اللغات نفسه في LABEL.

## مسائل مفتوحة

- هل توجد حالات تستدعي السماح بوصف UTF8-TEXT بلا لغة (غير مسموح الآن).

## صفحات ذات صلة

- [Edge](/ar/grammar/edge/)، [LABEL](/ar/grammar/edge/label/)، [ALIAS](/ar/grammar/edge/alias/)، [CODEC](/ar/grammar/edge/codec/)
- [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/)، [LOCAL](/ar/grammar/reference/local/)، [REFERENCE-NODE](/ar/grammar/edge/reference-node/)
