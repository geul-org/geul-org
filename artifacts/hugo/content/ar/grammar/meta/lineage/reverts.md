---
title: "REVERTS"
weight: 54
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REVERTS هو Meta نسب يكتب تجزئة محتوى الإصدار الهدف الذي جرى التراجع عن تغييره (git revert)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب تجزئة محتوى الإصدار الهدف الذي جرى التراجع عن تغييره (git revert).

## التخطيط

```
TAG WORD          0001 1LLL L011 0101      Codec 0x35
[Length ممتد TAG]
Payload           قيمة SHA-256-DIGEST واحدة (16 WORD)
```

- Codec: Meta `0x35`، فئة النسب (`011`)
- Payload: Value مضمّنة ([SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/))
- العدد: يمكن أكثر من واحد

## التفسير والصلاحية

- تُضمَّن صيغة digest كـ Value ليبقى مجال لتغيير خوارزمية التجزئة. وتجزئة المحتوى الآن SHA-256 فقط.
