---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF هو Meta تحقق يكتب بـ Reference الإقرار بحق المساهمة (git Signed-off-by, DCO)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

هو إقرار بحق المساهمة (git `Signed-off-by` وDCO).

## التخطيط

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[Length ممتد TAG]
Payload           Reference واحد
```

- Codec: Meta `0x42`، فئة التحقق (`100`)
- Payload: Reference مضمّن
- العدد: يمكن أكثر من واحد

## التفسير والصلاحية

- لا يوضع في مستند منشور على geul.org Reference يشير إلى شخص طبيعي ([Issuer والنشر](/ar/grammar/issuer/#النشر-على-geulorg)). بل يشير إلى منظمة أو Issuer. والاستثناء الإشارة إلى شخص طبيعي بـ [WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/) فهي مسموحة.
