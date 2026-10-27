---
title: "POINT2-BINARY64"
weight: 1011
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 قيمة Value لنقطة ثنائية الأبعاد بمكوّنين IEEE 754 binary64 بترتيب (x, y) (صيغة ADHOC Issuer 0x050A)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 نقطة ثنائية الأبعاد بمكوّنين IEEE 754 binary64 بترتيب `(x, y)`.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x050A`. العائلة NUMERIC.

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  المجموع 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## قواعد التفسير

- يُقرأ كل مكوّن بدءاً من أعلى WORD، ويُحفظ نمط البتات لـ NaN payload وsigned zero.
- نظام الإحداثيات (CRS) ومعنى المحاور وترتيبها ووحدتها من السياق الخارجي. لا يوجد ABI padding.

## الصلاحية

- Payload هو 8 WORD تماماً، وكل مقطع من 4 WORD هو بتات تبادل binary64.

## السند المعياري ووضع الصيغة

- ترتيب إحداثيتَي النقطة `x, y` يرجع إلى axis order في Point/WKB من OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html)، وكل مكوّن يتبع [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- هذا Payload هو compact profile في GEUL لا يحمل ترويسة WKB type/byte-order ولا ترويسة GeoPackage، وليس صيغة wire في OGC WKB. نظام الإحداثيات ومعنى المحاور والوحدة من السياق الخارجي.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (8 WORD)، أي 11 WORD تماماً، ويُستخدم الطول المباشر `LLLL=1010`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 8 WORD تماماً.

## أمثلة

- الـ Payload `3ff0 0000 0000 0000 4000 0000 0000 0000` هو `(1.0, 2.0)`.
