---
title: "DENSE-U32-VECTOR"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U32-VECTOR متجه أحادي البعد من القيمة Value يحمل عناصر big-endian uint32 متتالية دون descriptor (صيغة ADHOC Issuer 0x0503)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U32-VECTOR قيمة Value أحادية البعد متجانسة تخزّن عناصر big-endian uint32 متتالية دون descriptor.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0503`. العائلة NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0503
Payload: [uint32 1st: 2 WORD] ... [uint32 Nth: 2 WORD]
```

## قواعد التفسير

- تُوصل كل 2 WORD متتالية بدءاً من أعلى WORD وتُقرأ كعدد صحيح unsigned من 32 بت.
- عدد العناصر هو نصف عدد WORD في Payload، ولا يوجد ABI padding.

## الصلاحية

- يجب ألا يقل Payload عن 2 WORD وأن يكون مضاعفاً صحيحاً لـ 2 WORD. هذه الصيغة التي لا descriptor فيها لا تسمح بمتجه فارغ.

## السند المعياري ووضع الصيغة

- تفسير unsigned وعرض 32 بت للنوع الصحيح unsigned يوافقان dtype الصناعي في [نوع عنصر tensor في ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) و[DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- التسلسل أحادي البعد المتصل بلا descriptor وتوزيع TAG/Length وWORD وفق big-endian في GEUL هي صيغة خاصة بـ GEUL. يفترض DLPack أن dtype بترتيب native-endian، فهذا Payload ليس تسلسل wire في DLPack أو ONNX.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وIssuer (1 WORD)، ورقم الصيغة (1 WORD)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل الـ TAG الممتد في المجموع ([Length](/ar/grammar/record/)).

## أمثلة

- Payload `0000 0000 ffff ffff` يمثل العناصر `[0, 4294967295]`، والسجل كله 7 WORD.
