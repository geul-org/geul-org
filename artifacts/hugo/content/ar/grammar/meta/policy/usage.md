---
title: "USAGE"
weight: 86
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "USAGE هو Meta سياسة يكتب قيود الاستخدام مثل منع التدريب ومنع الاستخدام التجاري."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب قيود الاستخدام (مثل منع التدريب ومنع الاستخدام التجاري).

## التخطيط

```
TAG WORD          0001 1LLL L101 0101      Codec 0x55
[Length ممتد TAG]
Payload           نص أو Reference يمثل قيد الاستخدام
```

- Codec: Meta `0x55`، فئة السياسة (`101`)
- Payload: Value أو Reference مضمّن
- العدد: يمكن أكثر من واحد

## مسائل مفتوحة

- جدول رموز أنواع القيود.
