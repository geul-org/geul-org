---
title: "CREATED-AT"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CREATED-AT هو Meta مصدر يكتب وقت تأليف المستند بقيمة TIME (git author date)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب وقت تأليف المستند (git author date).

## التخطيط

```
TAG WORD          0001 1LLL L010 0010      Codec 0x22
[Length ممتد TAG]
Payload           قيمة TIME واحدة (GREGORIAN-DATE وPOSIX-TIMESTAMP-SECONDS وغيرهما)
```

- Codec: Meta `0x22`، فئة المصدر (`010`)
- Payload: Value مضمّنة (عائلة TIME: [GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/) و[POSIX-TIMESTAMP-SECONDS](/ar/grammar/value/time/posix-timestamp-seconds/) وغيرهما)
- العدد: واحد على الأكثر

## التفسير والصلاحية

- تُختار الصيغة من قيم عائلة TIME. وإذا لزمت الدقة فتُستخدم صيغة النانوثانية التي عرّفها Issuer (مثل [POSIX-TIMESTAMP-NANOSECONDS](/ar/grammar/value/time/posix-timestamp-nanoseconds/)).
