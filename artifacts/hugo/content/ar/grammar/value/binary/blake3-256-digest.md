---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST صيغة Issuer ثابتة من 20 WORD تحمل أول 32 octet من ناتج وضع التجزئة الافتراضي في BLAKE3."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST قيمة Value ثابتة العرض تحمل أول 32 octet (256 bit) من ناتج وضع التجزئة الافتراضي في BLAKE3. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0xC000`، والعائلة BINARY. Payload هو 16 WORD تماماً، ولا يحمل ناتج وضع keyed hash ولا وضع key derivation ولا ناتج XOF بأطوال أخرى.

## التخطيط

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length ممتد TAG   1 WORD  0x0014 (المجموع 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## التفسير والصلاحية

- Payload هو أول 32 octet من تدفق ناتج وضع التجزئة الافتراضي في BLAKE3. يُحفظ ترتيب الناتج، وفي كل WORD يأتي octet الأعلى أولاً.
- لا يُطبَّق على الناتج تحويل endian خاص بـ GEUL. يُجمَّع تسلسل octet الناتج بالترتيب كل اثنين من octet في WORD ذات 16 بت بترتيب big-endian.
- يُرفض التمثيل الذي لا يكون Payload فيه 16 WORD أو الذي يحمل نتيجة keyed_hash أو derive_key أو XOF بطول آخر. لا يوجد descriptor ولا padding.

## السند المعياري

- تعريف الخوارزمية والأوضاع والناتج يتبع [مستودع التنفيذ الرسمي](https://github.com/BLAKE3-team/BLAKE3) و[مواصفة BLAKE3](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf) من فريق BLAKE3.
- قواعد TAG وLength وframing بـ WORD ذات 16 بت في GEUL هي ما تضيفه هذه الصيغة، وليست جزءاً من خوارزمية BLAKE3.

## الطول

- المجموع هو TAG (1 WORD) وLength ممتد TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (16 WORD)، أي 20 WORD تماماً، ويُستخدم `LLLL=1110`. لا يوجد descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 16 WORD تماماً.

## أمثلة

- يوضع octet الناتج من `d[0]` إلى `d[31]` في 16 WORD من Payload بترتيب الناتج، كل اثنين من octet معاً. الطول الكلي دائماً 20 WORD.
