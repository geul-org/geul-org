---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND هو Edge وصف يربط Subject باسم تطابقه الآلة (UTF8-TEXT بلا لغة) (Codec 0x03)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND هو Edge وصف يربط Subject باسم تطابقه الآلة. Codec `0x03`.

هو تسمية. أما الاسم الذي يقرؤه الإنسان (العنوان بحسب اللغة) فمن شأن [LABEL](/ar/grammar/edge/label/). ويُكتب باسم رمز البرنامج والاسم المستخدم في عنوان المستند بالسجل نفسه.

## التخطيط

```
TAG WORD          0001 0LLL L000 0011
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
Subject           سجل Reference واحد، أو 1 WORD هي TAG WORD الخاصة بـ codec
الاسم             قيمة UTF8-TEXT-* واحدة
```

## التفسير والصلاحية

- Subject هو سجل [Reference](/ar/grammar/reference/) كامل واحد بالضبط. إن كان LOCAL فهو هدف في هذا المستند (رمز وغيره)، وإن كان Reference إشارة فهو هدف في مستند آخر. ويُشار إلى المستند نفسه بـ [DOC-POINTER](/ar/grammar/reference/doc-pointer/) وإلى Issuer نفسه بـ [ISSUER-POINTER](/ar/grammar/reference/issuer-pointer/).
- أو يكون Subject هو TAG WORD واحدة خاصة بـ codec (Kind وCodec فقط، و`LLLL = 0`، بلا Payload). وهذه ليست سجلاً Payload فيه فارغ بل تشير إلى الرمز المباشر نفسه، أي إلى مستند مواصفته (مستند GEUL Issuer `0x000000000000<TAG>`) ([مواصفة Codec](/ar/grammar/codec-spec/)، [DECLARE](/ar/grammar/edge/declare/)). مثال: `1018` هو PUBLICATION. وفي فهرس الأسماء يُستخدم Subject من نوع DOC-POINTER. ولا تُستخدم codec صيغة Issuer.
- السجلات الأخرى (Value وغيرها) لا يمكن أن تكون Subject. ولأن FIELD في مواصفة BIND يصرّح بـ Subject بعرض `0` (سجل) فقط، فهذا القيد قاعدة في متن BIND.
- الاسم هو قيمة [UTF8-TEXT](/ar/grammar/value/text/utf8-text/) واحدة بالضبط. لا لغة له ولا يُطبَّع. يجب أن تتطابق البايتات ليكون الاسم نفسه.
- نطاق الاسم هو المستند الذي يحمل BIND. ولا يُربط الاسم نفسه بـ Subject مختلفين في مستند واحد.
- يمكن ربط عدة أسماء بـ Subject واحد (كنى وأسماء قديمة). وما لم يحدد المستند غير ذلك فآخر BIND هو الاسم الرئيسي.
- لا تشير السجلات الأخرى إلى الهدف بالاسم بل بمعرّف LOCAL. ويُستخدم الاسم للمطابقة مع الخارج (دالة المضيف وإدخال العنوان والإنسان).
- الحروف المسموح بها في الاسم يحددها الاستخدام. والاسم المستخدم في عنوان المستند يتبع قاعدة اسم المستند (slug بحروف ASCII صغيرة) ([عنوان النشر وقائمة الإصدارات](/ar/grammar/publishing/#اسم-المستند)).

## الطول

```
المجموع = 1 + N_len + N_id + N_subject + N_name WORD
```

## أمثلة (غير معيارية)

رمز برنامج: Edge Id `0003`، وSubject LOCAL 7، والاسم `main`.

- الاسم `main` هو 4 bytes (زوجي) فهو `0940 6d61 696e` أي 3 WORD.
- Edge هو TAG (1) + Edge Id (2) + Subject (2) + الاسم (3) = 8 WORD، وTAG هو `1383`.

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

اسم المستند (داخل مستند قائمة الإصدارات `0x0000/0xffff000000000002/versions.geul` الخاص بذلك المستند): Edge Id `0005`، وSubject `DOC-POINTER` (Issuer `0x0000` والمستند `0xffff000000000002` والإصدار `0` = المستند نفسه)، والاسم `this-is-sample-doc`.

- Subject هو TAG `03B8` + Issuer (1) + معرّف المستند (4) + معرّف الإصدار (2) = 8 WORD.
- الاسم 18 byte (زوجي) فهو TAG `0CC0` + 9 WORD = 10 WORD.
- Edge هو TAG (1) + Length ممتد (1) + Edge Id (2) + Subject (8) + الاسم (10) = 22 WORD فـ `LLLL=1110`، وTAG هو `1703`، والممتد `0016`.

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## صفحات ذات صلة

- [Edge](/ar/grammar/edge/)، [LABEL](/ar/grammar/edge/label/)، [PUBLICATION](/ar/grammar/edge/publication/) (اسم المستند في مستند قائمة الإصدارات)
- [LOCAL](/ar/grammar/reference/local/)، [DOC-POINTER](/ar/grammar/reference/doc-pointer/)، [ISSUER-POINTER](/ar/grammar/reference/issuer-pointer/)
