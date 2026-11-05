---
title: "COMPLEX64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 هو Value يمثّل عددًا مركّبًا بمكوّنين IEEE 754 binary32 بالترتيب (real, imag)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 هو Value يمثّل عددًا مركّبًا بمكوّنين IEEE 754 binary32 بالترتيب `(real, imag)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x00000700`، العائلة NUMERIC.

## التخطيط {#레이아웃}

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  الإجمالي 9 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x00000700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## التفسير والصلاحية {#해석과-유효성}

- كل مكوّن هو interchange bits من نوع binary32 بترتيب WORD من نوع big-endian.
- يُحفظ نمط bits كما هو، بما في ذلك NaN payload والصفر ذو الإشارة (signed zero). لا يوجد ABI padding.
- Payload هو 4 WORD بالضبط. وتُحفظ جميع أنماط interchange bits للمكوّنين binary32.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- كون `complex64` مكوَّنًا من جزء real بحجم 32bit وجزء imaginary بحجم 32bit مستمد من [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html)، وترتيب real أولًا يطابق complex raw-data mapping في [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) الرسمي. ونمط bits لكل مكوّن يتبع [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- ONNX raw data ثابت العرض وبترتيب little-endian، أما هذه الصيغة فتستخدم تأطير WORD من نوع big-endian في GEUL، فهي ليست wire serialization لـ ONNX TensorProto نفسه.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 4 WORD، أي 9 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1000`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 4 WORD بالضبط.

## مثال {#예시}

- Payload `3F80 0000 4000 0000` يمثّل `1.0 + 2.0i`.
