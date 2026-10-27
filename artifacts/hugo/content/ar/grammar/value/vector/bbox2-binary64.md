---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 قيمة Value لمربع حدي ثنائي الأبعاد بأربعة مكوّنات IEEE 754 binary64 بترتيب (minX, minY, maxX, maxY) (صيغة ADHOC Issuer 0x050C)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 مربع حدي ثنائي الأبعاد بأربعة مكوّنات IEEE 754 binary64 بترتيب `(minX, minY, maxX, maxY)`.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x050C`. العائلة NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length ممتد TAG   1 WORD  0x0014 (المجموع 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## قواعد التفسير

- كل مكوّن binary64 ويُقرأ بدءاً من أعلى WORD. يُحفظ نمط البتات لـ signed zero.
- نظام الإحداثيات (CRS) ومعنى المحاور وترتيبها ووحدتها من السياق الخارجي. لا يوجد ABI padding.

## الصلاحية

- يجب أن يكون Payload هو 16 WORD تماماً وأن يكون `minX ≤ maxX` و`minY ≤ maxY`.
- NaN غير قابلة للمقارنة فتُرفض إذا وُجدت في أي مكوّن.

## السند المعياري ووضع الصيغة

- معنى الإحداثيات الدنيا والعليا يرجع إلى bounding envelope في OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html)، وكل مكوّن يتبع [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- ترتيب المصفوفة ثنائية الأبعاد لـ GeoPackage envelope هو `[minx, maxx, miny, maxy]`. أما الترتيب `(minX, minY, maxX, maxY)` في هذه الصيغة فليس wire order ذاك بل tuple مضغوط حدده GEUL، ولا تحمل هذه الصيغة ترويسة WKB/GeoPackage. نظام الإحداثيات ومعنى المحاور والوحدة من السياق الخارجي.

## الطول

- المجموع هو TAG (1 WORD) وLength ممتد TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (16 WORD)، أي 20 WORD تماماً، ويُستخدم `LLLL=1110`. لا يوجد descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 16 WORD تماماً.

## أمثلة

- إذا كانت المكوّنات `(0.0, 1.0, 2.0, 3.0)` فهي صالحة، وإذا كانت `(2.0, 1.0, 0.0, 3.0)` فهي invalid.
