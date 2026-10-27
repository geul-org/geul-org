---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM هو Meta تعريف يصرّح بتاريخ سريان هذا الإصدار بقيمة تاريخ أو طابع زمني."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يصرّح بتاريخ سريان هذا الإصدار. تاريخ السريان يختلف عن وقت النشر ([المراجعة](/ar/grammar/document/#المراجعة)).

## التخطيط

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[Length ممتد TAG]
Payload           قيمة TIME واحدة
```

- Codec: Meta `0x13`، فئة التعريف (`001`)
- Payload: Value مضمّنة ([GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/) أو [POSIX-TIMESTAMP-SECONDS](/ar/grammar/value/time/posix-timestamp-seconds/))
- العدد: واحد على الأكثر

## التفسير والصلاحية

- إذا غاب فالسريان من وقت النشر.
- إذا وُجد [EFFECTIVE-UNTIL](/ar/grammar/meta/declaration/effective-until/) فيجب أن يسبقه.
- إذا اختلف تاريخ السريان بحسب المادة فيُكتب على حدة في Edge تلك المادة بـ QUALIFIER P580 (البداية) وP582 (النهاية) ([SOURCE](/ar/grammar/edge/source/#تمثيل-الأدلة-الأخرى)).
- تُقرأ هذه القيمة عند تفسير المستند بالنسبة إلى وقت معين.

## أمثلة

- سريان من 1970-01-02: `0x1993 0x0920 0x0000 0x0001`
