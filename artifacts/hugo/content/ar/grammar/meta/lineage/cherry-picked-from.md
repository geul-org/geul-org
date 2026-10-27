---
title: "CHERRY-PICKED-FROM"
weight: 53
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "CHERRY-PICKED-FROM هو Meta نسب يكتب تجزئة محتوى الإصدار الأصلي الذي أُخذ منه تغيير من نسب آخر (git cherry-pick -x)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب تجزئة محتوى الإصدار الأصلي الذي أُخذ منه التغيير من نسب آخر (git cherry-pick `-x`).

## التخطيط

```
TAG WORD          0001 1LLL L011 0100      Codec 0x34
[Length ممتد TAG]
Payload           قيمة SHA-256-DIGEST واحدة (16 WORD)
```

- Codec: Meta `0x34`، فئة النسب (`011`)
- Payload: Value مضمّنة ([SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/))
- العدد: يمكن أكثر من واحد

## التفسير والصلاحية

- تُضمَّن صيغة digest كـ Value ليبقى مجال لتغيير خوارزمية التجزئة. وتجزئة المحتوى الآن SHA-256 فقط.
