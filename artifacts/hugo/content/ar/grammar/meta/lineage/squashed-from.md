---
title: "SQUASHED-FROM"
weight: 56
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "SQUASHED-FROM هو Meta نسب يكتب تجزئة محتوى الإصدارات الأصلية التي دُمجت في واحد (git squash)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب تجزئة محتوى الإصدارات الأصلية التي دُمجت في واحد (git squash).

## التخطيط

```
TAG WORD          0001 1LLL L011 0111      Codec 0x37
[Length ممتد TAG]
Payload           قيمة SHA-256-DIGEST واحدة (16 WORD)
```

- Codec: Meta `0x37`، فئة النسب (`011`)
- Payload: Value مضمّنة ([SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/))
- العدد: يمكن أكثر من واحد (واحد لكل إصدار أصلي)

## التفسير والصلاحية

- تُضمَّن صيغة digest كـ Value ليبقى مجال لتغيير خوارزمية التجزئة. وتجزئة المحتوى الآن SHA-256 فقط.
