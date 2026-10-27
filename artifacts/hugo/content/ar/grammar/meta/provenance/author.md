---
title: "AUTHOR"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "AUTHOR هو Meta مصدر يكتب بـ Reference الجهة التي كتبت محتوى المستند (git author)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب الجهة التي كتبت محتوى المستند (git author).

## التخطيط

```
TAG WORD          0001 1LLL L010 0000      Codec 0x20
[Length ممتد TAG]
Payload           سجل Reference واحد (EXTERNAL-ISSUER-* وGEUL وWIKIDATA-QID وLOCAL وغيرها)
```

- Codec: Meta `0x20`، فئة المصدر (`010`)
- Payload: Reference مضمّن
- العدد: واحد على الأكثر

## التفسير والصلاحية

- لا يقيّد Reference بـ Codec محددة. يمكن أن يكون إنساناً أو منظمة أو نموذجاً أو محرك قواعد ([EXTERNAL-ISSUER](/ar/grammar/reference/external-issuer/) و[GEUL](/ar/grammar/reference/geul/) و[WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/) و[LOCAL](/ar/grammar/reference/local/) وغيرها).
- لا يوضع في مستند منشور على geul.org Reference يشير إلى شخص طبيعي ([Issuer والنشر](/ar/grammar/issuer/#النشر-على-geulorg)). بل يشير إلى منظمة أو Issuer. والاستثناء الإشارة إلى شخص طبيعي بـ [WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/) فهي مسموحة.
- إذا كان LOCAL فيُوصف ذلك الهدف في BODY.
