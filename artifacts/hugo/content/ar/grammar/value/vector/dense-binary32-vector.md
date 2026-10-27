---
title: "DENSE-BINARY32-VECTOR"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY32-VECTOR متجه أحادي البعد من القيمة Value يحمل عناصر binary32 متتالية دون descriptor (صيغة ADHOC Issuer 0x0508)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY32-VECTOR يخزّن أنماط بتات تبادل IEEE 754 binary32 متتالية دون descriptor.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0508`. العائلة NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0508
Payload: [binary32 bits 1st: 2 WORD] ... [binary32 bits Nth: 2 WORD]
```

## قواعد التفسير

- كل 2 WORD متتالية عنصر واحد وتُقرأ بدءاً من أعلى WORD. تُحفظ أنماط البتات بما فيها NaN payload وsigned zero كما هي.
- عدد العناصر هو نصف عدد WORD في Payload، ولا يوجد ABI padding.

## الصلاحية

- يجب ألا يقل Payload عن 2 WORD وأن يكون مضاعفاً صحيحاً لـ 2 WORD. هذه الصيغة التي لا descriptor فيها لا تسمح بمتجه فارغ.

## السند المعياري ووضع الصيغة

- صيغة تبادل عناصر binary32 تتبع [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- التسلسل أحادي البعد المتصل بلا descriptor وتوزيع TAG/Length وWORD ذات 16 بت وفق big-endian في GEUL هي صيغة خاصة بـ GEUL. يفترض [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) أن dtype بترتيب native-endian، فهذا Payload ليس تسلسل wire في DLPack أو Arrow أو ONNX.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وIssuer (1 WORD)، ورقم الصيغة (1 WORD)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل الـ TAG الممتد في المجموع ([Length](/ar/grammar/record/)).

## أمثلة

- Payload `3f80 0000 8000 0000` هو binary32 `[1.0, -0]`، والسجل كله 7 WORD.
