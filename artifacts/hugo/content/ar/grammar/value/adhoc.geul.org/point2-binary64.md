---
title: "POINT2-BINARY64"
weight: 1017
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 هي نقطة ثنائية الأبعاد من مكوّنين IEEE 754 binary64 بالترتيب (x, y)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 هي نقطة ثنائية الأبعاد من مكوّنين IEEE 754 binary64 بالترتيب `(x, y)`.

## التخطيط {#레이아웃}

- الرمز: Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x0000050A`. العائلة NUMERIC.

```
TAG WORD          0x09DC (0000 1001 1101 1100)  الإجمالي 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x0000050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## قواعد التفسير {#해석-규칙}

- يُقرأ كل مكوّن بدءًا من WORD الأعلى، وتُحفظ أنماط bits الخاصة بـ NaN payload والصفر ذي الإشارة (signed zero).
- نظام الإحداثيات المرجعي (CRS) ومعنى المحاور وترتيبها ووحدتها سياق خارجي. لا يوجد ABI padding.

## الصلاحية {#유효성}

- Payload هو 8 WORD بالضبط، وكل مقطع من 4 WORD هو interchange bits من نوع binary64.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- ترتيب إحداثيات النقطة `x, y` مستمد من Point/WKB axis order في OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html)، وكل مكوّن يتبع [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- هذا Payload هو profile مضغوط في GEUL لا يحمل رأس WKB type/byte-order ولا رأس GeoPackage، وهو ليس OGC WKB wire format. وCRS ومعنى المحاور ووحدتها سياق خارجي.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 8 WORD، أي 13 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1100`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 8 WORD بالضبط.

## مثال {#예시}

- Payload `3FF0 0000 0000 0000 4000 0000 0000 0000` هو `(1.0, 2.0)`.
