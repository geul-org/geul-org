---
title: "DENSE-I64-VECTOR"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I64-VECTOR متجه أحادي البعد من القيمة Value يحمل عناصر big-endian int64 متتالية دون descriptor (صيغة ADHOC Issuer 0x0504)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I64-VECTOR قيمة Value أحادية البعد متجانسة تخزّن عناصر big-endian int64 متتالية دون descriptor.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0504`. العائلة NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0504
Payload: [int64 1st: 4 WORD] ... [int64 Nth: 4 WORD]
```

## قواعد التفسير

- تُوصل كل 4 WORD متتالية بدءاً من أعلى WORD وتُقرأ كعدد صحيح من 64 بت بمتمم اثنين.
- عدد العناصر هو ربع عدد WORD في Payload، ولا يوجد ABI padding.

## الصلاحية

- يجب ألا يقل Payload عن 4 WORD وأن يكون مضاعفاً صحيحاً لـ 4 WORD. هذه الصيغة التي لا descriptor فيها لا تسمح بمتجه فارغ.

## السند المعياري ووضع الصيغة

- إشارة النوع الصحيح signed وعرضه 64 بت يوافقان dtype الصناعي في [نوع عنصر tensor في ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) و[DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- تفسير متمم اثنين والتسلسل أحادي البعد المتصل بلا descriptor وتوزيع TAG/Length وWORD وفق big-endian في GEUL هي صيغة خاصة بـ GEUL. يفترض DLPack أن dtype بترتيب native-endian، فهذا Payload ليس تسلسل wire في DLPack أو ONNX.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وIssuer (1 WORD)، ورقم الصيغة (1 WORD)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل الـ TAG الممتد في المجموع ([Length](/ar/grammar/record/)).

## أمثلة

- Payload `ffff ffff ffff ffff` يمثل العناصر `[-1]`، والسجل كله 7 WORD.
