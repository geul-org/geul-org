---
title: "POINT3-BINARY64"
weight: 1018
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 هي نقطة ثلاثية الأبعاد من ثلاثة مكوّنات IEEE 754 binary64 بالترتيب (x, y, z)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 هي نقطة ثلاثية الأبعاد من ثلاثة مكوّنات IEEE 754 binary64 بالترتيب `(x, y, z)`.

## التخطيط {#레이아웃}

- الرمز: Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x0000050B`. العائلة NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length TAG ممتد   1 WORD  0x0012 (الإجمالي 18 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x0000050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## قواعد التفسير {#해석-규칙}

- يُقرأ كل مكوّن بدءًا من WORD الأعلى، وتُحفظ أنماط bits الخاصة بـ NaN payload والصفر ذي الإشارة (signed zero).
- نظام الإحداثيات المرجعي (CRS) ومعنى المحاور وترتيبها ووحدتها سياق خارجي. لا يوجد ABI padding.

## الصلاحية {#유효성}

- Payload هو 12 WORD بالضبط، وكل مقطع من 4 WORD هو interchange bits من نوع binary64.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- ترتيب إحداثيات النقطة `x, y, z` مستمد من Point/WKB axis order في OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html)، وكل مكوّن يتبع [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- هذا Payload هو profile مضغوط في GEUL لا يحمل رأس WKB type/byte-order ولا رأس GeoPackage، وهو ليس OGC WKB wire format. وCRS ومعنى المحاور ووحدتها سياق خارجي.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وLength TAG ممتد 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 12 WORD، أي 18 WORD بالضبط، ويُستخدم `LLLL=1110`. لا يوجد descriptor ولا padding.
- يُرفض إن لم يكن Payload 12 WORD بالضبط.

## مثال {#예시}

- إذا كانت binary64 الثلاثة في Payload هي `1.0, 2.0, 3.0` فالنقطة `(1.0, 2.0, 3.0)`.
