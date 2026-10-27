---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT هو Meta سياسة يكتب نطاق الموافقة وأساسها بـ Reference أو نص."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب نطاق الموافقة وأساسها.

## التخطيط

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[Length ممتد TAG]
Payload           Reference يشير إلى أساس الموافقة، أو نص
```

- Codec: Meta `0x54`، فئة السياسة (`101`)
- Payload: Reference أو Value مضمّنة
- العدد: يمكن أكثر من واحد

## مسائل مفتوحة

- بنية تمثيل النطاق (الغرض والمدة والتوفير للغير).
