---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE هو Meta نسب يكتب سبب التغيير نصاً مرفقاً بلغة (git commit message)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب سبب التغيير (git commit message).

## التخطيط

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[Length ممتد TAG]
الرسالة           قيمة UTF8-LANGUAGE-TEXT واحدة
```

- Codec: Meta `0x38`، فئة النسب (`011`)
- Payload: Value مضمّنة ([UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/))
- العدد: واحد على الأكثر لكل لغة

## التفسير والصلاحية

- تُحمل الرسالة ولغتها في UTF8-LANGUAGE-TEXT واحد. ولا يوجد أكثر من MESSAGE واحد للغة نفسها.
- تكتبه مواصفة geul.org بـ [CODEC](/ar/grammar/edge/codec/) `084A`·`084B`.
