---
title: "DOC-ID"
weight: 19
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DOC-ID هو Meta تعريف يصرّح بمعرّف المستند بـ DOC-POINTER يشير إلى المستند نفسه (Issuer ومعرّف المستند والإصدار 0)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يصرّح بمعرّف هذا المستند. وهو لازم لكي تشير المستندات الأخرى إلى هذا المستند والأهداف داخله.

## التخطيط

```
TAG WORD          0001 1LLL L001 0010      Codec 0x12
[Length ممتد TAG]
المستند           سجل Reference من نوع DOC-POINTER. (Issuer ومعرّف المستند والإصدار 0)
```

- Codec: Meta `0x12`، فئة التعريف (`001`)
- Payload: Reference مضمّن واحد هو [DOC-POINTER](/ar/grammar/reference/doc-pointer/) (Issuer ومعرّف المستند والإصدار 0)
- العدد: واحد على الأكثر. وهو إلزامي في المستند الذي يبدأ اسمه بـ `0x`

## التفسير والصلاحية

- Payload هو سجل Reference من نوع `DOC-POINTER` (Issuer ومعرّف المستند والإصدار `0`) واحد بالضبط. ولا يُستخدم لمعرّف الإصدار إلا `0`. فالإصدار لا يخصصه المستند بل قائمة الإصدارات. وQuantifier هو `000`.
- لذلك يتطابق التعبير الذي يشير إلى "هذا المستند" في DOC-ID وفي Subject لـ [BIND](/ar/grammar/edge/bind/) في `documents.geul` وفي اقتباس مستند آخر.
- المستند نفسه بصرف النظر عن الإصدار له `DOC-ID` نفسه. ولا يُكتب معرّف الإصدار ولا تجزئة المحتوى في المستند ([الإصدار](/ar/grammar/document/#الإصدار)).
- الاسم المستخدم في العنوان يتولاه `BIND` الوصفي في فهرس الأسماء `documents.geul` ([عنوان النشر وقائمة الإصدارات](/ar/grammar/publishing/#اسم-المستند))، والعنوان الذي يقرؤه الإنسان يتولاه [LABEL](/ar/grammar/edge/label/) الوصفي.
- إذا غاب فالمستند بلا اسم ولا يمكن الإشارة إليه إلا بتجزئة المحتوى. وهو لازم لكي تشير مستندات أخرى إلى LOCAL في هذا المستند بـ Reference إشارة.
- الجهة التي تستورد مستنداً تتحقق من أن `DOC-ID` للمستند المستلم يساوي Issuer ومعرّف المستند المطلوبين.
- معرّف المستند `0x0000000000000000` هو مستند فهرس تعريف مصطلحات Issuer ([Issuer](/ar/grammar/issuer/)). وهذا المستند أيضاً يبدأ اسمه بـ `0x` فيوضع له DOC-ID (`DOC-POINTER` (Issuer، و`0`، و`0`)). ويمثل Issuer نفسه [ISSUER-POINTER](/ar/grammar/reference/issuer-pointer/).
- `DOC-ID` إلزامي للمستند الذي يبدأ اسمه بـ `0x` تحت `.well-known/geul/` (مستند الإصدار `<معرّف الإصدار>.geul` ومستند المواصفة).
- المستند الذي لا يبدأ اسمه بـ `0x` استثناء ولا يوضع فيه `DOC-ID`: قائمة الإصدارات `versions.geul` ([PUBLICATION](/ar/grammar/edge/publication/)) وفهرس أسماء المستندات `documents.geul` وفهرس أسماء Issuer `issuers.geul` ([عنوان النشر وقائمة الإصدارات](/ar/grammar/publishing/)). ومخزن تجزئة المحتوى `h/` نسخ من المستندات أعلاه فيتبع الأصل.
- مستند مواصفة Codec هو مستند في GEUL Issuer `0x0000`. ومعرّف المستند هو TAG WORD الخاصة بـ Kind وCodec ممدودة إلى 4 WORD (`0x1018` → `0x0000000000001018`). وReference `0000` محجوز فلا يصير معرّف المستند `0` ([مستند المواصفة](/ar/grammar/codec-spec/)).

## أمثلة

- Issuer `0x0001` والمستند `0x…0005`: `1C12 03B8 0001 0000 0000 0000 0005 0000 0000` (TAG الـ Meta (1) + TAG الـ Reference (1) + Issuer (1) + معرّف المستند (4) + الإصدار (2) = 9 WORD)
