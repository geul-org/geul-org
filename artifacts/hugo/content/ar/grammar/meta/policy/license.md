---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE هو Meta سياسة يكتب ترخيص هذا المستند والمصنفات داخل سلسلة البايتات."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب ترخيص هذا المستند والمصنفات داخل سلسلة البايتات.

## التخطيط

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[Length ممتد TAG]
Payload           Reference يشير إلى الترخيص، أو UTF8-TEXT بمعرّف SPDX، أو قيمة URI
```

- Codec: Meta `0x50`، فئة السياسة (`101`)
- Payload: Reference أو Value مضمّنة ([UTF8-TEXT](/ar/grammar/value/text/utf8-text/) و[URI](/ar/grammar/value/text/uri/))
- العدد: واحد على الأكثر

## التفسير والصلاحية

- المستند المنشور على geul.org بترخيص CC0. أما النشر الخاص فيحدده Issuer ([Issuer](/ar/grammar/issuer/)).
- يُسجَّل الترخيص الأصلي للمصنف المصدري.

## مسائل مفتوحة

- هل يوضع معرّف SPDX نصاً أم Reference يشير إلى كيان في GEUL.
