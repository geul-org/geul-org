---
title: "BLAKE3-256-DIGEST"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST هو Value ثابت العرض يحمل أول 32 octet (256 bit) من ناتج BLAKE3 في وضع default hash."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST هو Value ثابت العرض يحمل أول 32 octet (256 bit) من ناتج BLAKE3 في وضع default hash. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x0000C000`، العائلة BINARY. Payload هو 16 WORD بالضبط، ولا يحمل keyed hash mode ولا key derivation mode ولا ناتج XOF بطول آخر.

## التخطيط {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length TAG ممتد   1 WORD  0x0016 (الإجمالي 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x0000C000
Payload           16 WORD  BLAKE3-256 Digest
```

## التفسير والصلاحية {#해석과-유효성}

- Payload هو أول 32 octet من output stream لوضع BLAKE3 default hash. يُحفظ ترتيب الناتج، وفي كل WORD يأتي octet الأعلى أولًا.
- لا يُطبَّق على الناتج تحويل endian خاص بـ GEUL. تُجمَّع octet sequence الناتجة بالترتيب كل اثنين من octets معًا وتُؤطَّر على هيئة WORD بعرض 16bit من نوع big-endian.
- يُرفض Payload الذي ليس 16 WORD، وكذلك التمثيل الذي يحمل نتيجة keyed_hash أو derive_key أو XOF بطول آخر. لا يوجد descriptor ولا padding.

## المرجع القياسي {#표준-근거}

- تتبع الخوارزمية وتعريفات mode وoutput [المستودع الرسمي للتنفيذ](https://github.com/BLAKE3-team/BLAKE3) من فريق BLAKE3 و[BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- إن TAG وLength وتأطير WORD بعرض 16bit في GEUL قواعد تضيفها هذه الصيغة وليست جزءًا من خوارزمية BLAKE3.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وLength TAG ممتد 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 16 WORD، أي 22 WORD بالضبط، ويُستخدم `LLLL=1110`. لا يوجد descriptor ولا padding.
- يُرفض إن لم يكن Payload 16 WORD بالضبط.

## مثال {#예시}

- توضع octets الناتج من `d[0]` إلى `d[31]` في 16 WORD من Payload بترتيب الناتج، كل اثنين من octets معًا. الطول الكلي دائمًا 22 WORD.
