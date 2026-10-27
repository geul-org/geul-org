---
title: "END"
weight: 16
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "END هو Meta بنية من 1 WORD يغلق المستند. وهو إلزامي في كل مستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

هو السجل الذي يغلق المستند.

## التخطيط

```
TAG WORD          0001 1LLL L000 1111      Codec 0x0F
[Length ممتد TAG]
```

- Codec: Meta `0x0F`، فئة البنية (`000`)
- Payload: لا شيء (1 WORD)
- العدد: واحد لكل مستند، في النهاية

## التفسير والصلاحية

- إلزامي. ويُتحقق من موضعه بطول [DOC](/ar/grammar/meta/structure/doc/) (`DOC-*`).
- إذا انتهى المدخل دون END فالمستند مقطوع. وهل يُعدّ محتوى المستند المقطوع صالحاً هو من سياسة المفكك.
- لا يأتي بعده شيء.

## أمثلة

- `0x180F`
