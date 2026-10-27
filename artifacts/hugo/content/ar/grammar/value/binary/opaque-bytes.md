---
title: "OPAQUE-BYTES"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES صيغة Issuer خاصة بـ GEUL تحمل سلسلة بايتات اعتباطية لا تحدد الصيغة معناها ولا شكلها بنفسها."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES سلسلة بايتات اعتباطية لا تحدد هذه الصيغة معناها ولا شكلها بنفسها. هي Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0000` GEUL، ورقم الصيغة `0xC000`·`0xC001` (عدد بايتات زوجي/فردي)، والعائلة BINARY. يُحدد عدد البايتات بأقل بت في رقم الصيغة وبعدد WORD في Payload: `2 × عدد WORD في Payload − أقل بت`، ولا يوجد Byte Count ([Value](/ar/grammar/value/)).

## التخطيط

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Issuer            1 WORD  0x0000 (GEUL)
رقم الصيغة        1 WORD  0xC000/0xC001
Payload WORD 1st ... Nth   البايتات / zero padding في الأخير
```

## التفسير والصلاحية

- يُقرأ من Payload عدد البايتات المحدد بالترتيب. داخل WORD يأتي byte الأعلى أولاً.
- عدد WORD في Payload هو `ceil(عدد البايتات/2)`. يُرفض ما كان الرمز فيه فردياً لكن byte الأدنى في آخر WORD ليس `00`.
- يُرفض ما لا تتطابق فيه الرموز الزوجية/الفردية وعدد WORD في Payload وzero padding.

## وضع الصيغة

- زوج الرموز زوجي/فردي وترتيب payload وzero padding في آخر WORD ليست اقتباساً من معيار صناعي خارجي بل framing خاص بـ GEUL.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وIssuer (1 WORD)، ورقم الصيغة (1 WORD)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويُحسب الـ TAG الممتد ضمن المجموع ([السجل وTAG WORD](/ar/grammar/record/)).
- 0 byte تُكتب برقم الصيغة الزوجي (`0xC000`) كسجل من 3 WORD بلا Payload (TAG وIssuer ورقم الصيغة).

## أمثلة

البايتات `ab cd ef` ثلاثة bytes (فردي)، فرقم الصيغة `0xC001` وPayload هو `abcd ef00`. المجموع 5 WORD فـ `LLLL=0100`.

```
0A7C 0000 C001 abcd ef00
```
