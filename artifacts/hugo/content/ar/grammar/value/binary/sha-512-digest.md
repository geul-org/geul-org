---
title: "SHA-512-DIGEST"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST صيغة Issuer من NIST ثابتة من 36 WORD تحمل ناتج SHA-512 كاملاً (512bit)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST قيمة Value ثابتة العرض تحمل ناتج SHA-512 من عائلة SHA-2 كاملاً. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0062` NIST، ورقم الصيغة `0xC000`، والعائلة BINARY. Payload هو 32 WORD (512 bit) تماماً، ولا يُسمح بالاقتطاع (truncation).

## التخطيط

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length ممتد TAG   1 WORD  0x0024 (المجموع 36 WORD)
Issuer            1 WORD  0x0062 (NIST)
رقم الصيغة        1 WORD  0xC000
Payload           32 WORD  SHA-512 Digest
```

## التفسير والصلاحية

- تُقرأ octets الـ 64 في Payload بترتيب ناتج SHA-512 كما هو. في كل WORD يأتي octet الأعلى أولاً.
- لا يُطبَّق على سلسلة بتات الـ digest تحويل endian خاص بـ GEUL. تُجمَّع octets الناتج بالترتيب كل اثنين في WORD ذات 16bit بترتيب big-endian، لا أكثر.
- يُرفض التمثيل الذي لا يكون Payload فيه 32 WORD أو الذي اقتُطع فيه الناتج تعسفاً. لا يوجد descriptor ولا padding.

## السند المعياري

- خوارزمية SHA-512 والناتج ذو 512bit يتبعان NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- قواعد TAG وLength وframing بـ WORD ذات 16bit في GEUL هي ما تضيفه هذه الصيغة، وليست جزءاً من خوارزمية SHA-2.

## الطول

- المجموع هو TAG (1 WORD) وLength ممتد TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (32 WORD)، أي 36 WORD تماماً، ويُستخدم `LLLL=1110`. لا يوجد descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 32 WORD تماماً.

## أمثلة

- octets الـ digest من `d[0]` إلى `d[63]` توضع في WORD الـ Payload من `(d[0]<<8)|d[1]` إلى `(d[62]<<8)|d[63]` بالترتيب. الطول الكلي دائماً 36 WORD.
