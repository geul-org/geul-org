---
title: "DENSE-I16-VECTOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I16-VECTOR متجه أحادي البعد من القيمة Value يحمل عناصر big-endian int16 متتالية دون descriptor (صيغة ADHOC Issuer 0x0500)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I16-VECTOR قيمة Value أحادية البعد متجانسة تخزّن عناصر big-endian int16 متتالية دون descriptor.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0500`. العائلة NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0500
Payload: [int16 1st: 1 WORD] ... [int16 Nth: 1 WORD]
```

## قواعد التفسير

- تُقرأ كل WORD كعدد صحيح مستقل من 16 بت بمتمم اثنين. عدد العناصر هو عدد WORD في Payload.
- لا يوجد ABI padding بين العناصر ولا في النهاية.

## الصلاحية

- يجب ألا يقل Payload عن 1 WORD. هذه الصيغة التي لا descriptor فيها لا تسمح بمتجه فارغ.
- يجب أن يكون حجم Payload مضاعفاً صحيحاً لعرض العنصر (1 WORD).

## السند المعياري ووضع الصيغة

- إشارة النوع الصحيح signed وعرضه 16 بت يوافقان dtype الصناعي في [نوع عنصر tensor في ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) و[DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- تفسير متمم اثنين والتسلسل أحادي البعد المتصل بلا descriptor وتوزيع TAG/Length وWORD وفق big-endian في GEUL هي صيغة خاصة بـ GEUL. يفترض DLPack أن dtype بترتيب native-endian، فهذا Payload ليس تسلسل wire في DLPack أو ONNX.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وIssuer (1 WORD)، ورقم الصيغة (1 WORD)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل الـ TAG الممتد في المجموع ([Length](/ar/grammar/record/)).

## أمثلة

- Payload `ffff 0002` يمثل العناصر `[-1, 2]`، والسجل كله 5 WORD بطول مباشر `LLLL=0100`.
