---
title: "RECORDED-AT"
weight: 38
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-AT هو Meta مصدر يكتب وقت تسجيل المستند بقيمة TIME (git commit date)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب وقت تسجيله مستنداً (git commit date).

## التخطيط

```
TAG WORD          0001 1LLL L010 0101      Codec 0x25
[Length ممتد TAG]
Payload           قيمة TIME واحدة (GREGORIAN-DATE وPOSIX-TIMESTAMP-SECONDS وغيرهما)
```

- Codec: Meta `0x25`، فئة المصدر (`010`)
- Payload: Value مضمّنة (عائلة TIME: [GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/) و[POSIX-TIMESTAMP-SECONDS](/ar/grammar/value/time/posix-timestamp-seconds/) وغيرهما)
- العدد: واحد على الأكثر

## التفسير والصلاحية

- تُختار الصيغة من قيم عائلة TIME. وإذا لزمت الدقة فتُستخدم صيغة النانوثانية التي عرّفها Issuer (مثل [POSIX-TIMESTAMP-NANOSECONDS](/ar/grammar/value/time/posix-timestamp-nanoseconds/)).
- مستند قائمة الإصدارات ([PUBLICATION](/ar/grammar/edge/publication/)) يستخدم هذه القيمة وقتاً للنشر والإهمال (deprecate) والحذف.

## مسائل مفتوحة

- Meta المصدر يدخل في تجزئة المحتوى. هل يُسمح بأن تتغير التجزئة إذا سُجّل المحتوى نفسه في وقت آخر.
