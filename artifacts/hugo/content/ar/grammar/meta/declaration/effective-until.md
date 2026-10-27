---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL هو Meta تعريف يصرّح بنهاية مدة سريان هذا الإصدار (قانون مؤقت) بقيمة تاريخ أو طابع زمني."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يصرّح بنهاية مدة سريان هذا الإصدار (قانون مؤقت). ومن ذلك الوقت لا يكون هذا الإصدار ساري المفعول.

## التخطيط

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[Length ممتد TAG]
Payload           قيمة TIME واحدة
```

- Codec: Meta `0x14`، فئة التعريف (`001`)
- Payload: Value مضمّنة ([GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/) أو [POSIX-TIMESTAMP-SECONDS](/ar/grammar/value/time/posix-timestamp-seconds/))
- العدد: واحد على الأكثر

## التفسير والصلاحية

- إذا غاب فهو ساري حتى يسري الإصدار التالي.
- إذا انقضت مدة السريان فلا يوجد إصدار ساري المفعول. ولا يعود الإصدار القديم إلى الحياة.
