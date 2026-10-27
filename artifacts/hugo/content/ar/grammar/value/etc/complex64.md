---
title: "COMPLEX64"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 صيغة Issuer من ADHOC ثابتة من 7 WORD تحمل عدداً مركباً بمكوّنين من binary32 للجزء الحقيقي والتخيلي."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 قيمة Value تمثل عدداً مركباً بمكوّنين من IEEE 754 binary32 بترتيب `(real, imag)`. هي Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0700`، والعائلة NUMERIC.

## التخطيط

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  المجموع 7 WORD
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## التفسير والصلاحية

- كل مكوّن هو بتات تبادل binary32 بترتيب WORD وفق big-endian.
- يُحفظ نمط البتات كما هو بما فيه NaN payload وsigned zero. لا يوجد ABI padding.
- Payload هو 4 WORD تماماً. تُحفظ كل أنماط بتات التبادل لمكوّني binary32.

## السند المعياري ووضع الصيغة

- أن `complex64` يتكون من مكوّن real بـ 32bit ومكوّن imaginary بـ 32bit يتبع [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html)، وترتيب real أولاً هو نفسه ترتيب complex raw-data mapping في [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) الرسمي. نمط بتات كل مكوّن يتبع [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- بيانات ONNX الخام ثابتة العرض بترتيب little-endian، أما هذه الصيغة فتستخدم framing بـ WORD وفق big-endian في GEUL، فهي ليست تسلسل ONNX TensorProto على السلك نفسه.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (4 WORD)، أي 7 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0110`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.

## أمثلة

- الـ Payload `3f80 0000 4000 0000` يمثل `1.0 + 2.0i`.
