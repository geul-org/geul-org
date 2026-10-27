---
title: "ACCESS"
weight: 82
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ACCESS هو Meta سياسة يكتب نطاق إتاحة المستند (عام وداخلي وسري) بدرجة من 1 WORD."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب نطاق إتاحة المستند.

## التخطيط

```
TAG WORD          0001 1LLL L101 0001      Codec 0x51
[Length ممتد TAG]
الدرجة            1 WORD (0 عام، 1 داخلي، 2 سري، وما عداها محجوز)
```

- Codec: Meta `0x51`، فئة السياسة (`101`)
- Payload: قيمة خام (الدرجة في 1 WORD)
- العدد: واحد على الأكثر

## التفسير والصلاحية

- المستند السري لا يُنشر ([Issuer](/ar/grammar/issuer/)).
- لا يغيّر التفسير. يحدد المعاملة فقط.

## مسائل مفتوحة

- جدول رموز الدرجات.
