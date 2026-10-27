---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR صيغة Issuer من ADHOC تحمل بعد descriptor من packed format وrank وshape عناصر أصغر من WORD معبّأة بترتيب low-bit-first."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR قيمة Value لتنسور تُكتب فيها shape وpacked format في descriptor الـ Payload وتُخزَّن العناصر الأصغر من WORD بصورة packed. هي Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0601`، والعائلة NUMERIC.

## التخطيط

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload الباقي    [packed payload octet stream, low-bit-first]
```

## التفسير

- rank قيمة من 4bit في descriptor، فبنيوياً لا يُمثَّل إلا `0..15`. كل dimension هو uint32 غير سالب بترتيب big-endian. الترتيب المنطقي هو C-contiguous row-major.
- كما في قواعد tensor المنطقية في ONNX، shape بـ rank 0 وهي `[]` هي scalar من عنصر واحد، وإذا كان أي dimension صفراً فعدد العناصر صفر. وفيما عدا ذلك عدد العناصر هو حاصل ضرب كل dimension.
- يثبّت packed-format ترميز العنصر وعرض البتات، كما في int2/int4 وFP4/FP6 وبعض متغيرات FP8.
- إذا سُمّي تسلسل octet في payload `p[0], p[1], ...` وقُرئ كعدد صحيح little-bit-endian `P = Σ(p[j] << (8j))`، فالعنصر المنطقي `i` بعرض `w` هو `(P >> (i × w)) & ((1 << w) - 1)`. أي يوضع أول عنصر في أدنى البتات.
- في WORD يوضع `p[0]` في octet الأعلى من أول WORD ثم `p[1]` في octet الأدنى وهكذا. يجب أن تكون بتات الذيل العليا غير المستخدمة في آخر octet مستخدم أصفاراً، وإذا كان عدد octet في payload فردياً فيجب أن يكون octet الأدنى غير المستخدم في آخر WORD كله `00`.

## الصلاحية

- يجب أن يطابق عدد عناصر payload حاصل ضرب dimension في shape المحسوب دون overflow عند تطبيق عرض البتات في format المدعوم.
- يُرفض السجل إذا كان أي من بتات الذيل العليا أو حشو octet بعد بتات payload المطلوبة يساوي 1. يجب أن يقع descriptor وshape وpayload كاملة ضمن Length السجل.

## السند المعياري ووضع الصيغة

- المعنى المنطقي لـ shape وrank 0 scalar وzero dimension يتبع [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). وقاعدة وضع عناصر sub-byte بدءاً من أدنى بت تتبع packing الـ int2/int4 في [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) الرسمي وlittle bit-endian packing في [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- rank من 4bit وdimension من uint32 وحقلا version/packed-format وطريقة تجميع octet في WORD وفق big-endian وTAG/Length في GEUL هي descriptor خاص بـ GEUL. وليست تسلسل wire أو ذاكرة في ONNX أو [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) أو DLPack نفسها.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وIssuer (1 WORD)، ورقم الصيغة (1 WORD)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويُحسب الـ TAG الممتد ضمن المجموع ([السجل وTAG WORD](/ar/grammar/record/)).
- descriptor هو 1 WORD، وshape هي `2 × rank` WORD، والباقي packed payload.
- إذا كان عدد العناصر المنطقي `N` وعرض العنصر `w` فعدد octet في payload هو `ceil(N × w / 8)` وعدد WORD في payload هو `ceil(عدد octet في payload / 2)`.

## أمثلة

- في profile يكون فيه rank يساوي 2، تكون 4 WORD بعد descriptor هي shape، وما بعدها تسلسل octet في payload بترتيب low-bit-first. يُحكم في عرض العنصر وما يُسمح به فعلاً من format profile المؤكد.
- تسلسل octet في payload للعناصر ذات 4bit `[1, 2, 3]` هو `21 03` وWORD الـ payload هي `2103`. العنصر الأول في nibble الأدنى من octet الأول، وnibble الأعلى غير المستخدم في آخر octet يساوي 0.

## مسائل مفتوحة

- لم تتحدد بعد قيم سجل version وpacked-format، ولا نطاق profile المدعوم من rank الممكن تمثيله `0..15`.
