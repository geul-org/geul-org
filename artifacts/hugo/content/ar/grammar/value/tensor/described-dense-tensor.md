---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR صيغة Issuer من ADHOC تحمل بعد descriptor من element format وrank وshape عناصر بترتيب C-contiguous row-major."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR قيمة Value لتنسور تُكتب فيها shape وelement format في descriptor الـ Payload ويُخزَّن payload بترتيب C-contiguous row-major. هي Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0600`، والعائلة NUMERIC.

## التخطيط

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload الباقي    [dense payload]
```

## التفسير

- rank قيمة من 4bit في descriptor، فبنيوياً لا يُمثَّل إلا `0..15`. كل dimension هو uint32 غير سالب بترتيب big-endian.
- كما في قواعد tensor المنطقية في ONNX، shape بـ rank 0 وهي `[]` هي scalar من عنصر واحد، وإذا كان أي dimension صفراً فعدد العناصر صفر. وفيما عدا ذلك عدد العناصر هو حاصل ضرب كل dimension.
- يُقرأ payload بـ element format في descriptor وبترتيب C-contiguous row-major. يجب أن يساوي عدد العناصر المنطقي المحسوب عدد عناصر payload بعد descriptor.

## الصلاحية

- بعد أن تتحدد version وelement format المدعومتان، تُستعاد حدود payload بعرض العنصر، ويُتحقق من مطابقتها لحاصل ضرب shape المحسوب دون overflow.
- يجب أن يقع descriptor وكل dimension وpayload كاملة ضمن Length السجل، ولا يوجد ABI padding اعتباطي.

## السند المعياري ووضع الصيغة

- قاعدة أن shape قائمة dimension غير سالبة وأن عدد القيم يساوي حاصل ضرب dimension، ومعنى rank 0 scalar وzero dimension، تتبع [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). والترتيب المنطقي C-contiguous row-major موافق لترتيب [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- rank من 4bit وdimension من uint32 وحقلا version/element-format وTAG/Length في GEUL وpayload بـ WORD وفق big-endian هي descriptor خاص بـ GEUL. وليست تسلسل wire أو ذاكرة في [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html) أو ONNX TensorProto أو [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وIssuer (1 WORD)، ورقم الصيغة (1 WORD)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويُحسب الـ TAG الممتد ضمن المجموع ([السجل وTAG WORD](/ar/grammar/record/)).
- descriptor هو 1 WORD، وshape هي `2 × rank` WORD، والباقي payload.

## أمثلة

- في profile يكون فيه rank يساوي 2، تكون 4 WORD بعد descriptor هي حقلا dimension من نوع uint32، ثم كل ما بعدها payload بترتيب row-major. ويلزم profile مؤكد لـ version وformat لتحديد ما يُسمح به فعلاً والتحقق من عدد العناصر.

## مسائل مفتوحة

- لم تتحدد بعد قيم سجل version وelement-format، ولا نطاق profile المدعوم من rank الممكن تمثيله `0..15`.
