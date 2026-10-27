---
title: "POINT3-BINARY64"
weight: 1012
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 قيمة Value لنقطة ثلاثية الأبعاد بثلاثة مكوّنات IEEE 754 binary64 بترتيب (x, y, z) (صيغة ADHOC Issuer 0x050B)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 نقطة ثلاثية الأبعاد بثلاثة مكوّنات IEEE 754 binary64 بترتيب `(x, y, z)`.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x050B`. العائلة NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length ممتد TAG   1 WORD  0x0010 (المجموع 16 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## قواعد التفسير

- يُقرأ كل مكوّن بدءاً من أعلى WORD، ويُحفظ نمط البتات لـ NaN payload وsigned zero.
- نظام الإحداثيات (CRS) ومعنى المحاور وترتيبها ووحدتها من السياق الخارجي. لا يوجد ABI padding.

## الصلاحية

- Payload هو 12 WORD تماماً، وكل مقطع من 4 WORD هو بتات تبادل binary64.

## السند المعياري ووضع الصيغة

- ترتيب إحداثيات النقطة `x, y, z` يرجع إلى axis order في Point/WKB من OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html)، وكل مكوّن يتبع [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- هذا Payload هو compact profile في GEUL لا يحمل ترويسة WKB type/byte-order ولا ترويسة GeoPackage، وليس صيغة wire في OGC WKB. نظام الإحداثيات ومعنى المحاور والوحدة من السياق الخارجي.

## الطول

- المجموع هو TAG (1 WORD) وLength ممتد TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (12 WORD)، أي 16 WORD تماماً، ويُستخدم `LLLL=1110`. لا يوجد descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 12 WORD تماماً.

## أمثلة

- إذا كانت binary64 الثلاثة في Payload هي `1.0, 2.0, 3.0` فهي النقطة `(1.0, 2.0, 3.0)`.
