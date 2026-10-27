---
title: "MODIFIED-AT"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "MODIFIED-AT هو Meta مصدر يكتب وقت تعديل المستند بقيمة TIME."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب وقت تعديل المستند.

## التخطيط

```
TAG WORD          0001 1LLL L010 0011      Codec 0x23
[Length ممتد TAG]
Payload           قيمة TIME واحدة (GREGORIAN-DATE وPOSIX-TIMESTAMP-SECONDS وغيرهما)
```

- Codec: Meta `0x23`، فئة المصدر (`010`)
- Payload: Value مضمّنة (عائلة TIME: [GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/) و[POSIX-TIMESTAMP-SECONDS](/ar/grammar/value/time/posix-timestamp-seconds/) وغيرهما)
- العدد: واحد على الأكثر

## التفسير والصلاحية

- تُختار الصيغة من قيم عائلة TIME. وإذا لزمت الدقة فتُستخدم صيغة النانوثانية التي عرّفها Issuer (مثل [POSIX-TIMESTAMP-NANOSECONDS](/ar/grammar/value/time/posix-timestamp-nanoseconds/)).
