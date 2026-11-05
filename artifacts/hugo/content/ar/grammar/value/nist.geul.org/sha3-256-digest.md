---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST هو Value ثابت العرض يحمل ناتج SHA3-256 كاملًا."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST هو Value ثابت العرض يحمل ناتج SHA3-256 كاملًا. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000015` NIST، رقم Codec `0x0000C001`، العائلة BINARY. Payload هو 16 WORD بالضبط (256 bit) ولا يُسمح بالاقتطاع (truncation).

## التخطيط {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length TAG ممتد   1 WORD  0x0016 (الإجمالي 22 WORD)
Issuer            2 WORD  0x00000015 (NIST)
رقم Codec         2 WORD  0x0000C001
Payload           16 WORD  SHA3-256 Digest
```

## التفسير والصلاحية {#해석과-유효성}

- تُقرأ octets الـ 32 في Payload بترتيب ناتج SHA3-256 كما هو. وفي كل WORD يأتي octet الأعلى أولًا.
- لا يُطبَّق على digest bit string تحويل endian خاص بـ GEUL. بل تُجمَّع octet sequence الناتجة بالترتيب كل اثنين من octets معًا وتُؤطَّر فقط على هيئة WORD بعرض 16bit من نوع big-endian.
- يُرفض Payload الذي ليس 16 WORD، وكذلك التمثيل الذي اقتُطع فيه الناتج اعتباطيًّا. لا يوجد descriptor ولا padding.

## المرجع القياسي {#표준-근거}

- تتبع خوارزمية SHA3-256 والناتج بعرض 256bit المرجع NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). كما يقدّم [مشروع Hash Functions](https://csrc.nist.gov/Projects/hash-functions) من NIST معيار SHA-3 أيضًا.
- إن TAG وLength وتأطير WORD بعرض 16bit في GEUL قواعد تضيفها هذه الصيغة وليست جزءًا من خوارزمية SHA-3.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وLength TAG ممتد 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 16 WORD، أي 22 WORD بالضبط، ويُستخدم `LLLL=1110`. لا يوجد descriptor ولا padding.
- يُرفض إن لم يكن Payload 16 WORD بالضبط.

## مثال {#예시}

- توضع octets الـ digest من `d[0]` إلى `d[31]` في 16 WORD من Payload بترتيب الناتج، كل اثنين من octets معًا. الطول الكلي دائمًا 22 WORD.
