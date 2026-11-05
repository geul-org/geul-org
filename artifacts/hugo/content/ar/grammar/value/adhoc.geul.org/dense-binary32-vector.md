---
title: "DENSE-BINARY32-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "يخزّن DENSE-BINARY32-VECTOR أنماط interchange bits لعناصر IEEE 754 binary32 متتالية بلا descriptor."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يخزّن DENSE-BINARY32-VECTOR أنماط interchange bits لعناصر IEEE 754 binary32 متتالية بلا descriptor.

## التخطيط {#레이아웃}

- الرمز: Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x00000508`. العائلة NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length TAG ممتد] عندما يكون الإجمالي 15 WORD فأكثر
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x00000508
Payload: [binary32 bits 1st: 2 WORD] ... [binary32 bits Nth: 2 WORD]
```

## قواعد التفسير {#해석-규칙}

- كل 2 WORD متتاليتين تشكّلان عنصرًا واحدًا ويُقرآن بدءًا من WORD الأعلى. تُحفظ أنماط bits كما هي، بما في ذلك NaN payload والصفر ذو الإشارة (signed zero).
- عدد العناصر هو 1/2 من عدد WORD في Payload، ولا يوجد ABI padding.

## الصلاحية {#유효성}

- يجب أن يكون Payload بحجم 2 WORD على الأقل ومضاعفًا صحيحًا لـ 2 WORD. هذه الصيغة بلا descriptor ولا تسمح بـ vector فارغ.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- صيغة تبادل عناصر binary32 هي [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- المتتالية أحادية البعد بلا descriptor، وTAG/Length في GEUL، وتوزيع WORD بعرض 16 bit من نوع big-endian، كلها خاصة بصيغة GEUL. يفترض [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) native-endian، لذا ليس هذا Payload wire serialization لـ DLPack أو Arrow أو ONNX.

## الطول {#길이}

- الإجمالي هو عدد WORD في TAG بمقدار 1 WORD، وLength TAG ممتد (إن وُجد)، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload. ما كان 14 WORD فأقل يستخدم الطول المباشر، وما كان 15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل Length TAG الممتد في العدد الكلي ([Length](../../record.md)).

## مثال {#예시}

- Payload `3F80 0000 8000 0000` هو binary32 `[1.0, -0]`، والسجل كله 9 WORD.
