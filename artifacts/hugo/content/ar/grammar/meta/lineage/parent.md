---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT هو Meta نسب يكتب تجزئة محتوى الإصدار السابق (git parent). إن كانت عدة فهو دمج."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب تجزئة محتوى الإصدار السابق (git parent).

## التخطيط

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[Length ممتد TAG]
Payload           قيمة SHA-256-DIGEST واحدة (16 WORD)
```

- Codec: Meta `0x30`، فئة النسب (`011`)
- Payload: Value مضمّنة ([SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/))
- العدد: يمكن أكثر من واحد (دمج)

## التفسير والصلاحية

- إذا غاب فهو الإصدار الأول، وإن كانت عدة فهو دمج (git merge commit).
- يدخل في [تجزئة المحتوى](/ar/grammar/document/#تجزئة-المحتوى) فيصير التاريخ كله سلسلة تجزئة.
- مستند قائمة الإصدارات يشير إلى مستند القائمة السابق ([PUBLICATION](/ar/grammar/edge/publication/)).
- تُضمَّن صيغة digest كـ Value ليبقى مجال لتغيير خوارزمية التجزئة. وتجزئة المحتوى الآن SHA-256 فقط.

## أمثلة

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>` (Meta بطول 20 WORD = TAG + Length ممتد + Value مضمّنة بطول 18 WORD)
