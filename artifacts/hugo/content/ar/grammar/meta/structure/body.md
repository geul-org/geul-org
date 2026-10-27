---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY هو Meta بنية من 1 WORD ينهي HEAD المستند ويبدأ BODY."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

هو السجل الذي ينهي HEAD ويبدأ BODY.

## التخطيط

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[Length ممتد TAG]
```

- Codec: Meta `0x0E`، فئة البنية (`000`)
- Payload: لا شيء (1 WORD)
- العدد: واحد على الأكثر لكل مستند

## التفسير والصلاحية

- يُحذف إذا كان HEAD فارغاً. والمستند الذي بلا `BODY` كله BODY. ويوضع إذا وُجد في HEAD Meta أو Edge في HEAD ([SOURCE](/ar/grammar/edge/source/#مصدر-المستند-كله) للمستند كله وQUALIFIER الخاصة به).
- لا يوجد Payload. والمجموع 1 WORD.

## أمثلة

- `0x180E`
