---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 صيغة Issuer من ADHOC ثابتة من 11 WORD تحمل quaternion بأربعة مكوّنات binary32 بترتيب (x, y, z, w)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 قيمة Value تمثل quaternion بأربعة مكوّنات من IEEE 754 binary32 بترتيب `(x, y, z, w)`. هي Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0704`، والعائلة NUMERIC.

## التخطيط

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  المجموع 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## التفسير والصلاحية

- كل مكوّن هو بتات تبادل binary32 بترتيب WORD وفق big-endian.
- الإطار (frame) واليدية (handedness) وطول الوحدة (unit norm) وتكافؤ `q/-q` من السياق الخارجي وليست داخلة في معنى هذه الصيغة.
- تُحفظ أنماط البتات لـ NaN payload وsigned zero. لا يوجد ABI padding.
- Payload هو 8 WORD تماماً. لا تفرض هذه الصيغة unit norm ولا تطبيع `q/-q`.

## السند المعياري ووضع الصيغة

- ترتيب `x, y, z, w` هو ترتيب مكوّنات quaternion نفسه في [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) من Khronos، وكل مكوّن هو [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- يتطلب node rotation في glTF unit quaternion يكون W فيه هو scalar. وهذه الصيغة quaternion عام لا يفرض unit norm ولا معنى الدوران، فلا يُعدّ مطابقاً لدوران glTF ما لم يضف profile خارجي هذا الشرط.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (8 WORD)، أي 11 WORD تماماً، ويُستخدم الطول المباشر `LLLL=1010`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 8 WORD تماماً.

## أمثلة

- المكوّنات `(0.0, 0.0, 0.0, 1.0)` قيمة صالحة تُخزَّن فيها أنماط البتات الأربعة بالترتيب.
