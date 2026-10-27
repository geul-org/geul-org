---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR متجه أحادي البعد من القيمة Value يحمل عناصر BF16 متتالية دون descriptor (صيغة ADHOC Issuer 0x0507)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR يخزّن أنماط بتات عناصر bfloat16 ذات 16 بت متتالية دون descriptor. وهي صيغة مختلفة عن binary16.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0507`. العائلة NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## قواعد التفسير

- عدد العناصر هو عدد WORD في Payload. تُحفظ أنماط البتات بما فيها NaN payload وsigned zero كما هي.
- لا يوجد ABI padding بين العناصر ولا في النهاية.

## الصلاحية

- يجب ألا يقل Payload عن 1 WORD. هذه الصيغة التي لا descriptor فيها لا تسمح بمتجه فارغ.
- يجب أن يكون حجم Payload مضاعفاً صحيحاً لعرض العنصر (1 WORD).

## السند المعياري ووضع الصيغة

- كون bfloat16 نوع 16 بت مستقلاً ومميزاً عن binary16 يوافق [نوع عنصر tensor في ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) و[DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html).
- التسلسل أحادي البعد المتصل بأنماط البتات بلا descriptor وتوزيع TAG/Length وWORD ذات 16 بت وفق big-endian في GEUL هي صيغة خاصة بـ GEUL. يفترض DLPack أن dtype بترتيب native-endian، فهذا Payload ليس تسلسل wire في DLPack أو Arrow أو ONNX.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وIssuer (1 WORD)، ورقم الصيغة (1 WORD)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل الـ TAG الممتد في المجموع ([Length](/ar/grammar/record/)).

## أمثلة

- Payload `3f80 8000` هو BF16 `1.0` و`-0`، والسجل كله 5 WORD.
