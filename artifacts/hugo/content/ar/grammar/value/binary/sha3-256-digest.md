---
title: "SHA3-256-DIGEST"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST صيغة Issuer من NIST ثابتة من 20 WORD تحمل ناتج SHA3-256 كاملاً (256bit)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST قيمة Value ثابتة العرض تحمل ناتج SHA3-256 كاملاً. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0062` NIST، ورقم الصيغة `0xC001`، والعائلة BINARY. Payload هو 16 WORD (256 bit) تماماً، ولا يُسمح بالاقتطاع (truncation).

## التخطيط

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length ممتد TAG   1 WORD  0x0014 (المجموع 20 WORD)
Issuer            1 WORD  0x0062 (NIST)
رقم الصيغة        1 WORD  0xC001
Payload           16 WORD  SHA3-256 Digest
```

## التفسير والصلاحية

- تُقرأ octets الـ 32 في Payload بترتيب ناتج SHA3-256 كما هو. في كل WORD يأتي octet الأعلى أولاً.
- لا يُطبَّق على سلسلة بتات الـ digest تحويل endian خاص بـ GEUL. تُجمَّع octets الناتج بالترتيب كل اثنين في WORD ذات 16bit بترتيب big-endian، لا أكثر.
- يُرفض التمثيل الذي لا يكون Payload فيه 16 WORD أو الذي اقتُطع فيه الناتج تعسفاً. لا يوجد descriptor ولا padding.

## السند المعياري

- خوارزمية SHA3-256 والناتج ذو 256bit يتبعان NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). ويعرض [مشروع Hash Functions](https://csrc.nist.gov/Projects/hash-functions) من NIST معيار SHA-3 أيضاً.
- قواعد TAG وLength وframing بـ WORD ذات 16bit في GEUL هي ما تضيفه هذه الصيغة، وليست جزءاً من خوارزمية SHA-3.

## الطول

- المجموع هو TAG (1 WORD) وLength ممتد TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (16 WORD)، أي 20 WORD تماماً، ويُستخدم `LLLL=1110`. لا يوجد descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 16 WORD تماماً.

## أمثلة

- octets الـ digest من `d[0]` إلى `d[31]` توضع في 16 WORD من Payload بترتيب الناتج، كل اثنين معاً. الطول الكلي دائماً 20 WORD.
