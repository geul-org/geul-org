---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "يخزّن DENSE-BFLOAT16-VECTOR أنماط bits لعناصر bfloat16 بعرض 16 bit متتالية بلا descriptor."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يخزّن DENSE-BFLOAT16-VECTOR أنماط bits لعناصر bfloat16 بعرض 16 bit متتالية بلا descriptor. وهو صيغة مختلفة عن binary16.

## التخطيط {#레이아웃}

- الرمز: Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x00000507`. العائلة NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length TAG ممتد] عندما يكون الإجمالي 15 WORD فأكثر
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x00000507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## قواعد التفسير {#해석-규칙}

- عدد العناصر هو عدد WORD في Payload. تُحفظ أنماط bits كما هي، بما في ذلك NaN payload والصفر ذو الإشارة (signed zero).
- لا يوجد ABI padding بين العناصر ولا في النهاية.

## الصلاحية {#유효성}

- يجب أن يكون Payload بحجم 1 WORD على الأقل. هذه الصيغة بلا descriptor ولا تسمح بـ vector فارغ.
- يجب أن يكون حجم Payload مضاعفًا صحيحًا لعرض العنصر وهو 1 WORD.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- كون bfloat16 نوع dtype مستقلًّا بعرض 16 bit وتمييزه عن binary16 يوافق [tensor element type في ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) و[DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html).
- المتتالية أحادية البعد من أنماط bits بلا descriptor، وTAG/Length في GEUL، وتوزيع WORD بعرض 16 bit من نوع big-endian، كلها خاصة بصيغة GEUL. يفترض DLPack native-endian، لذا ليس هذا Payload wire serialization لـ DLPack أو Arrow أو ONNX.

## الطول {#길이}

- الإجمالي هو عدد WORD في TAG بمقدار 1 WORD، وLength TAG ممتد (إن وُجد)، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload. ما كان 14 WORD فأقل يستخدم الطول المباشر، وما كان 15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل Length TAG الممتد في العدد الكلي ([Length](../../record.md)).

## مثال {#예시}

- Payload `3F80 8000` هو BF16 `1.0` و`-0`، والسجل كله 7 WORD.
