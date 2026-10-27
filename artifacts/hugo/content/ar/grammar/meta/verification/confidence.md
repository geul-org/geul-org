---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE هو Meta تحقق يكتب موثوقية المستند كله بقيمة عشرية Value من 0 إلى 1."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب موثوقية المستند كله. أما الموثوقية على مستوى السجل فتُكتب بـ QUALIFIER تُلحق بـ Edge الهدف (الخاصية لم تتحدد، [SOURCE](/ar/grammar/edge/source/#تمثيل-الأدلة-الأخرى)).

## التخطيط

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[Length ممتد TAG]
Payload           قيمة UNSIGNED-DECIMAL، من 0 إلى 1
```

- Codec: Meta `0x43`، فئة التحقق (`100`)
- Payload: Value مضمّنة ([UNSIGNED-DECIMAL](/ar/grammar/value/decimal/unsigned-decimal/))
- العدد: واحد على الأكثر

## التفسير والصلاحية

- من وضع القيمة يُكتب معها بـ [GENERATED-BY](/ar/grammar/meta/lineage/generated-by/) وغيره.

## مسائل مفتوحة

- المقياس (0~1) وعلاقته بحكم TOULMIN.
