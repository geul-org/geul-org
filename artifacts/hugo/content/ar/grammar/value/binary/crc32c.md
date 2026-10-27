---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C صيغة Issuer من IETF ثابتة من 5 WORD تحمل 32 بت من نتيجة Castagnoli CRC-32C."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C قيمة Value ثابتة العرض تحمل نتيجة CRC-32C. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0020` IETF، ورقم الصيغة `0xC000`، والعائلة BINARY. Payload هو 2 WORD (32 bit) تماماً.

## التخطيط

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  المجموع 5 WORD
Issuer            1 WORD  0x0020 (IETF)
رقم الصيغة        1 WORD  0xC000
Payload           2 WORD  CRC32C أعلى 16bit │ أدنى 16bit
```

## التفسير والصلاحية

- بمصطلحات معاملات CRC: width 32، كثيرة حدود Castagnoli هي `0x1EDC6F41`، وrefin/refout هما true، وinit هو `0xffffffff`، وxorout هو `0xffffffff`.
- يُخزَّن العدد الصحيح غير الموقّع من 32 بت الناتج عن الحساب بترتيب WORD وفق big-endian. وهذا التسلسل ليس ترتيب حقل SCTP Checksum في RFC 3309 ولا ربط بايتات digest في iSCSI من RFC 3720.
- يُرفض ما لا يكون Payload فيه 2 WORD.

## السند المعياري

- حساب CRC-32C وكثيرة حدود Castagnoli وقواعد الانعكاس تتبع تعريف CRC32C في [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) و[RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- قواعد TAG وLength وframing العدد الصحيح الناتج من 32 بت في WORD ذات 16 بت بترتيب big-endian هي ما تضيفه هذه الصيغة.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (2 WORD)، أي 5 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0100`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 2 WORD تماماً.

## أمثلة

قيمة فحص CRC-32C لـ ASCII `123456789` هي `0xe3069283`:

```
0A7C 0020 C000 e306 9283
```
