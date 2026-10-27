---
title: "VERDICT"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "VERDICT هو Meta تحقق يكتب في 1 WORD نتيجة الحكم على المستند كله (Pass وReview وFail)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب نتيجة الحكم على المستند كله. والحكم على مستوى العقدة والسجل من شأن [TOULMIN](/ar/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`).

## التخطيط

```
TAG WORD          0001 1LLL L100 0100      Codec 0x44
[Length ممتد TAG]
الحكم             1 WORD (0 Pass، 1 Review، 2 Fail)
```

- Codec: Meta `0x44`، فئة التحقق (`100`)
- Payload: قيمة خام (الحكم في 1 WORD)
- العدد: واحد على الأكثر

## التفسير والصلاحية

- لأنه من فئة التحقق فهو مستثنى من تجزئة المحتوى.
- الحكم على مستند آخر يوضع في BODY مستند مختلف عن مستند موضوع الحكم.

## مسائل مفتوحة

- هل تُكتب جهة الحكم وأساسه معه.
