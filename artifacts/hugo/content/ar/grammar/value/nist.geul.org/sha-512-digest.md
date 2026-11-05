---
title: "SHA-512-DIGEST"
weight: 1039
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST هو Value ثابت العرض يحمل ناتج SHA-512 من عائلة SHA-2 كاملًا."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST هو Value ثابت العرض يحمل ناتج SHA-512 من عائلة SHA-2 كاملًا. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000015` NIST، رقم Codec `0x0000C000`، العائلة BINARY. Payload هو 32 WORD بالضبط (512 bit) ولا يُسمح بالاقتطاع (truncation).

## التخطيط {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length TAG ممتد   1 WORD  0x0026 (الإجمالي 38 WORD)
Issuer            2 WORD  0x00000015 (NIST)
رقم Codec         2 WORD  0x0000C000
Payload           32 WORD  SHA-512 Digest
```

## التفسير والصلاحية {#해석과-유효성}

- تُقرأ octets الـ 64 في Payload بترتيب ناتج SHA-512 كما هو. وفي كل WORD يأتي octet الأعلى أولًا.
- لا يُطبَّق على digest bit string تحويل endian خاص بـ GEUL. بل تُجمَّع octet sequence الناتجة بالترتيب كل اثنين من octets معًا وتُؤطَّر فقط على هيئة WORD بعرض 16bit من نوع big-endian.
- يُرفض Payload الذي ليس 32 WORD، وكذلك التمثيل الذي اقتُطع فيه الناتج اعتباطيًّا. لا يوجد descriptor ولا padding.

## المرجع القياسي {#표준-근거}

- تتبع خوارزمية SHA-512 والناتج بعرض 512bit المرجع NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- إن TAG وLength وتأطير WORD بعرض 16bit في GEUL قواعد تضيفها هذه الصيغة وليست جزءًا من خوارزمية SHA-2.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وLength TAG ممتد 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 32 WORD، أي 38 WORD بالضبط، ويُستخدم `LLLL=1110`. لا يوجد descriptor ولا padding.
- يُرفض إن لم يكن Payload 32 WORD بالضبط.

## مثال {#예시}

- توضع octets الـ digest من `d[0]` إلى `d[63]` في Payload WORD من `(d[0]<<8)|d[1]` إلى `(d[62]<<8)|d[63]` بالترتيب. الطول الكلي دائمًا 38 WORD.
