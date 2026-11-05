---
title: "QUATERNION-BINARY32"
weight: 1019
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 هو Value يمثّل quaternion بأربعة مكوّنات IEEE 754 binary32 بالترتيب (x, y, z, w)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 هو Value يمثّل quaternion بأربعة مكوّنات IEEE 754 binary32 بالترتيب `(x, y, z, w)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x00000704`، العائلة NUMERIC.

## التخطيط {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  الإجمالي 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x00000704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## التفسير والصلاحية {#해석과-유효성}

- كل مكوّن هو interchange bits من نوع binary32 بترتيب WORD من نوع big-endian.
- إطار الإسناد (frame) وhandedness وunit norm وتكافؤ `q/-q` سياق خارجي وليست داخلة في معنى هذه الصيغة.
- تُحفظ أنماط bits الخاصة بـ NaN payload والصفر ذي الإشارة (signed zero)، ولا يوجد ABI padding.
- Payload هو 8 WORD بالضبط. ولا تفرض هذه الصيغة unit norm ولا تطبيع `q/-q`.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- ترتيب `x, y, z, w` هو ترتيب مكوّنات quaternion في [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) من Khronos، وكل مكوّن هو [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- يتطلب node rotation في glTF وحدة quaternion (unit quaternion) يكون فيها W هو الـ scalar. وهذه الصيغة quaternion عام لا يفرض unit norm ولا معنى الدوران، فلا يُعدّ مطابقًا لـ rotation في glTF ما لم يضف profile خارجي ذلك الشرط.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 8 WORD، أي 13 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1100`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 8 WORD بالضبط.

## مثال {#예시}

- المكوّنات `(0.0, 0.0, 0.0, 1.0)` قيمة صالحة تُخزَّن فيها أنماط bits الأربعة بالترتيب.
