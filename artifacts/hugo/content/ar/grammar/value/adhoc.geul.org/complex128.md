---
title: "COMPLEX128"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 هو Value يمثّل عددًا مركّبًا بمكوّنين IEEE 754 binary64 بالترتيب (real, imag)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 هو Value يمثّل عددًا مركّبًا بمكوّنين IEEE 754 binary64 بالترتيب `(real, imag)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x00000701`، العائلة NUMERIC.

## التخطيط {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  الإجمالي 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x00000701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## التفسير والصلاحية {#해석과-유효성}

- كل مكوّن هو interchange bits من نوع binary64 بترتيب WORD من نوع big-endian.
- يُحفظ نمط bits كما هو، بما في ذلك NaN payload والصفر ذو الإشارة (signed zero). لا يوجد ABI padding.
- Payload هو 8 WORD بالضبط. وتُحفظ جميع أنماط interchange bits للمكوّنين binary64.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- كون `complex128` مكوَّنًا من جزء real بحجم 64bit وجزء imaginary بحجم 64bit مستمد من [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html)، وترتيب real أولًا يطابق complex raw-data mapping في [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) الرسمي. ونمط bits لكل مكوّن يتبع [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- ONNX raw data ثابت العرض وبترتيب little-endian، أما هذه الصيغة فتستخدم تأطير WORD من نوع big-endian في GEUL، فهي ليست wire serialization لـ ONNX TensorProto نفسه.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 8 WORD، أي 13 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1100`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 8 WORD بالضبط.

## مثال {#예시}

- إذا كان binary64 في Payload هما `1.0, -0.0` فالقيمة جزؤها الحقيقي 1.0 وجزؤها التخيّلي -0.0.
