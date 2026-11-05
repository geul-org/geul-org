---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1016
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR هو Value لتنسور يكتب shape وpacked format في descriptor الخاص بـ Payload ثم يخزّن العناصر الأصغر من WORD بصورة packed."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR هو Value لتنسور يكتب shape وpacked format في descriptor الخاص بـ Payload ثم يخزّن العناصر الأصغر من WORD بصورة packed. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x00000601`، العائلة NUMERIC.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length TAG ممتد] عندما يكون الإجمالي 15 WORD فأكثر
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x00000601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload الباقي    [packed payload octet stream, low-bit-first]
```

## التفسير {#해석}

- rank قيمة من 4bit في descriptor، فلا يمثّل بنيويًا إلا `0..15`. كل dimension هو uint32 غير سالب بترتيب big-endian. الترتيب المنطقي هو C-contiguous row-major.
- كما في قاعدة tensor المنطقي في ONNX، فإن shape ذا rank صفر `[]` هو scalar من عنصر واحد، وإذا كان أي dimension صفرًا فعدد العناصر صفر. وفيما عدا ذلك فعدد العناصر هو حاصل ضرب جميع الـ dimension.
- يثبّت packed-format ترميز العنصر وعرض bit له، مثل int2/int4 وFP4/FP6 وبعض متغيرات FP8.
- لتكن octet sequence الخاصة بـ payload هي `p[0], p[1], ...`، ولننظر إليها كعدد صحيح little-bit-endian هو `P = Σ(p[j] << (8j))`؛ فالعنصر المنطقي `i` ذو العرض `w` هو `(P >> (i × w)) & ((1 << w) - 1)`. أي يوضع العنصر الأول في أدنى bit ثم تتوالى العناصر.
- في WORD يوضع `p[0]` في octet الأعلى من أول WORD ثم `p[1]` في octet الأدنى، وهكذا. يجب أن تكون tail bit العليا غير المستخدمة في آخر octet مستخدَم أصفارًا، وإذا كان عدد octet في payload فرديًا فيجب أن يكون octet الأدنى غير المستخدم في آخر WORD كله `00`.

## الصلاحية {#유효성}

- عند تطبيق عرض bit الخاص بالـ format المدعوم، يجب أن يطابق حاصل ضرب dimension في shape المحسوب دون overflow عدد عناصر payload.
- يُرفض إن كانت أي tail bit عليا أو octet padding بعد bit payload المطلوبة تساوي 1. ويجب أن يقع descriptor وshape وpayload بالكامل داخل Length السجل.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- المعنى المنطقي لـ shape وscalar ذي rank صفر وdimension الصفري يتبع [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). أما قاعدة وضع عناصر sub-byte بدءًا من أدنى bit فتتبع int2/int4 packing في [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) الرسمي وlittle bit-endian packing في [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- rank بعرض 4bit وdimension من نوع uint32 وحقلا version/packed-format وطريقة تجميع octet في WORD من نوع big-endian وTAG/Length في GEUL هي descriptor خاص بـ GEUL. وهي ليست serialization سلكية أو في الذاكرة لـ ONNX أو [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) أو DLPack نفسها.

## الطول {#길이}

- الإجمالي هو عدد WORD في TAG بمقدار 1 WORD، وLength TAG ممتد (إن وُجد)، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload. ما كان 14 WORD فأقل يستخدم الطول المباشر، وما كان 15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل Length TAG الممتد في العدد الكلي ([السجل وTAG WORD](../../record.md)).
- descriptor هو 1 WORD، وshape هو `2 × rank` WORD، والباقي هو packed payload.
- إذا كان عدد العناصر المنطقية `N` وعرض العنصر `w` فعدد octet في payload هو `ceil(N × w / 8)`، وعدد WORD في payload هو `ceil(عدد octet في payload / 2)`.

## مثال {#예시}

- في profile ذي rank يساوي 2، تكون 4 WORD بعد descriptor هي shape، وما بعدها octet sequence لـ payload بترتيب low-bit-first. ويُحكم بعرض العنصر والسماح الفعلي وفق profile الـ format المؤكد.
- octet sequence لـ payload للعناصر ذات 4bit `[1, 2, 3]` هي `21 03`، وWORD الخاص بـ payload هو `2103`. العنصر الأول في nibble الأدنى من octet الأول، وnibble الأعلى غير المستخدم من octet الأخير يساوي 0.

## مسائل مفتوحة {#열린-문제}

- لم تُحدَّد بعدُ قيم سجل version وpacked-format، ولا نطاق profile المدعوم من rank الممكن تمثيله `0..15`.
