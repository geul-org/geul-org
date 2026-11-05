---
title: "DENSE-U32-VECTOR"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "يخزّن DENSE-U32-VECTOR عناصر uint32 بترتيب big-endian متتالية بلا descriptor، وهو Value أحادي البعد متجانس."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يخزّن DENSE-U32-VECTOR عناصر uint32 بترتيب big-endian متتالية بلا descriptor، وهو Value أحادي البعد متجانس.

## التخطيط {#레이아웃}

- الرمز: Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x00000503`. العائلة NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length TAG ممتد] عندما يكون الإجمالي 15 WORD فأكثر
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x00000503
Payload: [uint32 1st: 2 WORD] ... [uint32 Nth: 2 WORD]
```

## قواعد التفسير {#해석-규칙}

- تُدمَج كل 2 WORD متتالية بدءًا من WORD الأعلى وتُقرأ عددًا صحيحًا بعرض 32 bit بلا إشارة (unsigned).
- عدد العناصر هو 1/2 من عدد WORD في Payload، ولا يوجد ABI padding.

## الصلاحية {#유효성}

- يجب أن يكون Payload بحجم 2 WORD على الأقل ومضاعفًا صحيحًا لـ 2 WORD. هذه الصيغة بلا descriptor ولا تسمح بـ vector فارغ.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- التفسير بلا إشارة (unsigned) لنوع dtype الصحيح بلا إشارة وعرضه 32 bit يوافقان dtype الصناعي في [tensor element type في ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) و[DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- المتتالية أحادية البعد بلا descriptor، وTAG/Length في GEUL، وتوزيع WORD من نوع big-endian، كلها خاصة بصيغة GEUL. يفترض DLPack أن dtype بترتيب native-endian، لذا ليس هذا Payload wire serialization لـ DLPack أو ONNX.

## الطول {#길이}

- الإجمالي هو عدد WORD في TAG بمقدار 1 WORD، وLength TAG ممتد (إن وُجد)، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload. ما كان 14 WORD فأقل يستخدم الطول المباشر، وما كان 15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل Length TAG الممتد في العدد الكلي ([Length](../../record.md)).

## مثال {#예시}

- Payload `0000 0000 FFFF FFFF` هو العناصر `[0, 4294967295]`، والسجل كله 9 WORD.
