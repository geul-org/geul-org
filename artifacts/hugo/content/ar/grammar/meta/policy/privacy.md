---
title: "PRIVACY"
weight: 83
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "PRIVACY هو Meta سياسة يكتب درجة خصوصية المستند في 1 WORD."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب درجة خصوصية المستند.

## التخطيط

```
TAG WORD          0001 1LLL L101 0010      Codec 0x52
[Length ممتد TAG]
الدرجة            1 WORD
```

- Codec: Meta `0x52`، فئة السياسة (`101`)
- Payload: قيمة خام (الدرجة في 1 WORD)
- العدد: واحد على الأكثر

## التفسير والصلاحية

- لا يغيّر التفسير. يحدد المعاملة فقط.

## مسائل مفتوحة

- جدول رموز الدرجات (المقابلة مع تصنيف قانون حماية المعلومات الشخصية).
