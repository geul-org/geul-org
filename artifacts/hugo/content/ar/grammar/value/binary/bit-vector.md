---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR صيغة Issuer خاصة بـ GEUL تحمل عدد البتات N في 32 بت ثم N بت بترتيب MSB-first."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR تسلسل بتات خام معلن الطول. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0000` GEUL، ورقم الصيغة `0xC002`، والعائلة BINARY. أول 2 WORD من Payload هما العدد غير الموقّع `N` من 32 بت، ويتبعهما `ceil(N/16)` WORD.

## التخطيط

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Issuer            1 WORD  0x0000 (GEUL)
رقم الصيغة        1 WORD  0xC002
Payload WORD 1st–2nd       Bit Count N (أعلى 16bit │ أدنى 16bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## التفسير والصلاحية

- `N` هي القيمة المقروءة من أول 2 WORD في Payload كعدد صحيح غير موقّع من 32 بت بترتيب big-endian.
- تُملأ بتات payload بدءاً من أعلى بت في كل WORD.
- عدد WORD في payload يساوي `ceil(N/16)` تماماً، ويجب أن تكون البتات الدنيا غير المستخدمة في آخر WORD كلها 0.
- إذا كانت `N=0` فلا توجد WORD في payload. ولا يتعارض هذا مع قاعدة الحد الأدنى 1 WORD في Payload، لأن WORD العدّ الاثنتين تشكلان Payload أصلاً.

## وضع الصيغة

- عدد البتات غير الموقّع من 32 بت، وترتيب MSB-first، وحشو الأصفار في آخر WORD، ليست اقتباساً من معيار صناعي خارجي بل framing خاص بـ GEUL.
- هذه الصفحة هي التي تعرّف التمثيل، بما فيه قواعد TAG وLength وWORD ذات 16 بت في GEUL.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وIssuer (1 WORD)، ورقم الصيغة (1 WORD)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويُحسب الـ TAG الممتد ضمن المجموع ([السجل وTAG WORD](/ar/grammar/record/)).

## أمثلة

- متجه البتات الفارغ: العدّ `0000 0000`، بلا payload، المجموع 5 WORD، `LLLL=0100`.
- تسلسل البتات `101`: العدّ `0000 0003`، payload هو `a000`، المجموع 6 WORD، `LLLL=0101`.
