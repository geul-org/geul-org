---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR هو Value لتنسور يكتب shape وelement format في descriptor الخاص بـ Payload ثم يخزّن payload بترتيب C-contiguous row-major."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR هو Value لتنسور يكتب shape وelement format في descriptor الخاص بـ Payload ثم يخزّن payload بترتيب C-contiguous row-major. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x00000600`، العائلة NUMERIC.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length TAG ممتد] عندما يكون الإجمالي 15 WORD فأكثر
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x00000600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload الباقي    [dense payload]
```

## التفسير {#해석}

- rank قيمة من 4bit في descriptor، فلا يمثّل بنيويًا إلا `0..15`. كل dimension هو uint32 غير سالب بترتيب big-endian.
- كما في قاعدة tensor المنطقي في ONNX، فإن shape ذا rank صفر `[]` هو scalar من عنصر واحد، وإذا كان أي dimension صفرًا فعدد العناصر صفر. وفيما عدا ذلك فعدد العناصر هو حاصل ضرب جميع الـ dimension.
- يُقرأ payload وفق element format في descriptor وبترتيب C-contiguous row-major. يجب أن يساوي عدد العناصر المنطقي المحسوب عدد عناصر payload الذي يلي descriptor.

## الصلاحية {#유효성}

- متى تحدّدت version وelement format المدعومتان، تُستعاد حدود payload بعرض العنصر ذاك، ويُتحقق من مطابقتها لحاصل ضرب shape المحسوب دون overflow.
- يجب أن يقع descriptor وكل dimension وpayload بالكامل داخل Length السجل، ولا يوجد ABI padding اعتباطي.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- القاعدة التي تجعل shape قائمة dimension غير سالبة وعدد القيم مساويًا لحاصل ضرب الـ dimension، ومعنى scalar ذي rank صفر وdimension الصفري، تتبع [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). أما الترتيب المنطقي C-contiguous row-major فيوافق ترتيب [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- rank بعرض 4bit وdimension من نوع uint32 وحقلا version/element-format وTAG/Length في GEUL وpayload من WORD بترتيب big-endian هي descriptor خاص بـ GEUL. وهي ليست serialization سلكية أو في الذاكرة لـ [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html) أو ONNX TensorProto أو [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## الطول {#길이}

- الإجمالي هو عدد WORD في TAG بمقدار 1 WORD، وLength TAG ممتد (إن وُجد)، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload. ما كان 14 WORD فأقل يستخدم الطول المباشر، وما كان 15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل Length TAG الممتد في العدد الكلي ([السجل وTAG WORD](../../record.md)).
- descriptor هو 1 WORD، وshape هو `2 × rank` WORD، والباقي هو payload.

## مثال {#예시}

- في profile ذي rank يساوي 2، تكون 4 WORD بعد descriptor هي dimensionين من نوع uint32، ثم كل ما بعدها payload بترتيب row-major. أما السماح الفعلي والتحقق من عدد العناصر فيتطلبان profile مؤكدًا لـ version وformat.

## مسائل مفتوحة {#열린-문제}

- لم تُحدَّد بعدُ قيم سجل version وelement-format، ولا نطاق profile المدعوم من rank الممكن تمثيله `0..15`.
