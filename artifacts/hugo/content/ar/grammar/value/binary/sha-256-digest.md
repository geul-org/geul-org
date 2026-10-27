---
title: "SHA-256-DIGEST"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST قيمة Value ثابتة من 18 WORD تحمل ناتج SHA-256 كاملاً (256bit)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-256-DIGEST قيمة Value ثابتة العرض تحمل ناتج SHA-256 من عائلة SHA-2 كاملاً. الرمز المباشر في Value هو `0x61` والعائلة BINARY. Payload هو 16 WORD (256 bit) تماماً، ولا يُسمح بالاقتطاع (truncation).

## التخطيط

```
TAG WORD          0x0F61 (0000 1111 0110 0001)  LLLL=1110
Length ممتد TAG   1 WORD  0x0012 (المجموع 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## التفسير والصلاحية

- تُقرأ octets الـ 32 في Payload بترتيب ناتج SHA-256 كما هو. في كل WORD يأتي octet الأعلى أولاً.
- لا يُطبَّق على سلسلة بتات الـ digest تحويل endian خاص بـ GEUL. تُجمَّع octets الناتج بالترتيب كل اثنين في WORD ذات 16bit بترتيب big-endian، لا أكثر.
- يُرفض التمثيل الذي لا يكون Payload فيه 16 WORD أو الذي اقتُطع فيه الناتج تعسفاً. لا يوجد descriptor ولا padding.

## السند المعياري

- خوارزمية SHA-256 والناتج ذو 256bit يتبعان NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- قواعد TAG وLength وframing بـ WORD ذات 16bit في GEUL هي ما تضيفه هذه الصيغة، وليست جزءاً من خوارزمية SHA-2.

## الطول

- المجموع هو TAG (1 WORD) وLength ممتد TAG (1 WORD) وPayload (16 WORD)، أي 18 WORD تماماً، ويُستخدم `LLLL=1110`. لا يوجد descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 16 WORD تماماً.

## أمثلة

- octets الـ digest من `d[0]` إلى `d[31]` توضع في WORD الـ Payload من `(d[0]<<8)|d[1]` إلى `(d[30]<<8)|d[31]` بالترتيب. الطول الكلي دائماً 18 WORD.
