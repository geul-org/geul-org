---
title: "COMPLEX128"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 صيغة Issuer من ADHOC ثابتة من 11 WORD تحمل عدداً مركباً بمكوّنين من binary64 للجزء الحقيقي والتخيلي."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 قيمة Value تمثل عدداً مركباً بمكوّنين من IEEE 754 binary64 بترتيب `(real, imag)`. هي Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0701`، والعائلة NUMERIC.

## التخطيط

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  المجموع 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## التفسير والصلاحية

- كل مكوّن هو بتات تبادل binary64 بترتيب WORD وفق big-endian.
- يُحفظ نمط البتات كما هو بما فيه NaN payload وsigned zero. لا يوجد ABI padding.
- Payload هو 8 WORD تماماً. تُحفظ كل أنماط بتات التبادل لمكوّني binary64.

## السند المعياري ووضع الصيغة

- أن `complex128` يتكون من مكوّن real بـ 64bit ومكوّن imaginary بـ 64bit يتبع [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html)، وترتيب real أولاً هو نفسه ترتيب complex raw-data mapping في [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) الرسمي. نمط بتات كل مكوّن يتبع [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- بيانات ONNX الخام ثابتة العرض بترتيب little-endian، أما هذه الصيغة فتستخدم framing بـ WORD وفق big-endian في GEUL، فهي ليست تسلسل ONNX TensorProto على السلك نفسه.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (8 WORD)، أي 11 WORD تماماً، ويُستخدم الطول المباشر `LLLL=1010`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 8 WORD تماماً.

## أمثلة

- إذا كان binary64 في Payload هما `1.0, -0.0` فالقيمة جزؤها الحقيقي 1.0 وجزؤها التخيلي -0.0.
