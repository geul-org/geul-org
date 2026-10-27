---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID هو Reference تصريح يشير إلى خاصية (Property) في ويكي بيانات بالرقم في معرّف P."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-PID هو Reference تصريح يشير إلى خاصية (Property) في ويكي بيانات. يُكتب الجزء الرقمي من معرّف P بعد حذف `P` كعدد صحيح بلا إشارة.

## التخطيط

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[Length ممتد TAG]
PID               unsigned big-endian بأقصر عرض
```

- يُكتب PID بأقصر عرض. أرقام الخصائص الحالية تتسع في 1 WORD فالمجموع 2 WORD، وإذا تجاوزت 65535 صارت 3 WORD تلقائياً.
- يُستخدم أساساً في موضع Predicate في [TRIPLE](/ar/grammar/edge/triple/) وموضع Property في [QUALIFIER](/ar/grammar/edge/qualifier/).

## أمثلة

| الخاصية | تسلسل WORD |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## صفحات ذات صلة

- [Reference](/ar/grammar/reference/)، [WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/)، [TRIPLE](/ar/grammar/edge/triple/)، [QUALIFIER](/ar/grammar/edge/qualifier/)
