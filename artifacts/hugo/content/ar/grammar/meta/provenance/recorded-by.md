---
title: "RECORDED-BY"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-BY هو Meta مصدر يكتب بـ Reference الجهة التي سجّلت المستند (git committer)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب الجهة التي سجّلت المستند (git committer).

## التخطيط

```
TAG WORD          0001 1LLL L010 0100      Codec 0x24
[Length ممتد TAG]
Payload           سجل Reference واحد (EXTERNAL-ISSUER-* وGEUL وWIKIDATA-QID وLOCAL وغيرها)
```

- Codec: Meta `0x24`، فئة المصدر (`010`)
- Payload: Reference مضمّن
- العدد: واحد على الأكثر

## التفسير والصلاحية

- لا يقيّد Reference بـ Codec محددة. يمكن أن يكون إنساناً أو منظمة أو نموذجاً أو محرك قواعد ([EXTERNAL-ISSUER](/ar/grammar/reference/external-issuer/) و[GEUL](/ar/grammar/reference/geul/) و[WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/) و[LOCAL](/ar/grammar/reference/local/) وغيرها).
- لا يوضع في مستند منشور على geul.org Reference يشير إلى شخص طبيعي ([Issuer والنشر](/ar/grammar/issuer/#النشر-على-geulorg)). بل يشير إلى منظمة أو Issuer. والاستثناء الإشارة إلى شخص طبيعي بـ [WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/) فهي مسموحة.
- إذا كان LOCAL فيُوصف ذلك الهدف في BODY.
