---
title: "BBOX2-BINARY64"
weight: 1000
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 هو صندوق حدّي ثنائي الأبعاد مكوَّن من أربعة مكوّنات IEEE 754 binary64 بالترتيب (minX, minY, maxX, maxY)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 هو صندوق حدّي ثنائي الأبعاد مكوَّن من أربعة مكوّنات IEEE 754 binary64 بالترتيب `(minX, minY, maxX, maxY)`.

## التخطيط {#레이아웃}

- الرمز: Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x0000050C`. العائلة NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length TAG ممتد   1 WORD  0x0016 (الإجمالي 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x0000050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## قواعد التفسير {#해석-규칙}

- كل مكوّن binary64 ويُقرأ بدءًا من WORD الأعلى. يُحفظ نمط bits الخاص بالصفر ذي الإشارة (signed zero).
- نظام الإحداثيات المرجعي (CRS) ومعنى المحاور وترتيبها ووحدتها سياق خارجي. لا يوجد ABI padding.

## الصلاحية {#유효성}

- يجب أن يكون Payload بالضبط 16 WORD، وأن يتحقق `minX ≤ maxX` و`minY ≤ maxY`.
- لا يمكن مقارنة NaN، لذا يُرفض إن وُجد في أي مكوّن.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- معنى الإحداثيات الدنيا والعليا مستمد من bounding envelope في OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html)، وكل مكوّن يتبع [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- ترتيب المصفوفة ثنائية الأبعاد لـ envelope في GeoPackage هو `[minx, maxx, miny, maxy]`. أما الترتيب `(minX, minY, maxX, maxY)` في هذه الصيغة فهو tuple مضغوط حدّده GEUL وليس wire order ذاك، ولا تحمل الصيغة رأس WKB/GeoPackage. وCRS ومعنى المحاور ووحدتها سياق خارجي.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وLength TAG ممتد 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 16 WORD، أي 22 WORD بالضبط، ويُستخدم `LLLL=1110`. لا يوجد descriptor ولا padding.
- يُرفض إن لم يكن Payload 16 WORD بالضبط.

## مثال {#예시}

- إذا كانت المكوّنات `(0.0, 1.0, 2.0, 3.0)` فهي صالحة، وإذا كانت `(2.0, 1.0, 0.0, 3.0)` فهي غير صالحة (invalid).
