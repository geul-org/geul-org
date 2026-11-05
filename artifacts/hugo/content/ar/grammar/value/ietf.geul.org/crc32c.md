---
title: "CRC32C"
weight: 1033
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C هو Value ثابت العرض يحمل ناتج CRC-32C."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C هو Value ثابت العرض يحمل ناتج CRC-32C. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000007` IETF، رقم Codec `0x0000C000`، العائلة BINARY. Payload هو 2 WORD بالضبط (32 bit).

## التخطيط {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  الإجمالي 7 WORD
Issuer            2 WORD  0x00000007 (IETF)
رقم Codec         2 WORD  0x0000C000
Payload           2 WORD  CRC32C الـ 16bit العليا │ الـ 16bit الدنيا
```

## التفسير والصلاحية {#해석과-유효성}

- بحسب تدوين معاملات CRC: width يساوي 32، وكثير الحدود (polynomial) لـ Castagnoli هو `0x1EDC6F41`، وrefin/refout يساويان true، وinit يساوي `0xFFFFFFFF`، وxorout يساوي `0xFFFFFFFF`.
- يُخزَّن العدد الصحيح الناتج من الحساب (unsigned 32bit) بترتيب WORD من نوع big-endian. وهذا التسلسل ليس توزيع حقل SCTP Checksum في RFC 3309 ولا تعيين byte في digest الخاص بـ iSCSI في RFC 3720.
- يُرفض إن لم يكن Payload 2 WORD.

## المرجع القياسي {#표준-근거}

- يتبع حساب CRC-32C وكثير حدود Castagnoli وقواعد الانعكاس تعريف CRC32C في [RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) و[RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- إن TAG وLength في GEUL وتأطير العدد الصحيح 32bit المحسوب في WORD بعرض 16bit من نوع big-endian قواعد تضيفها هذه الصيغة.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 2 WORD، أي 7 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=0110`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 2 WORD بالضبط.

## مثال {#예시}

قيمة التحقق (check value) لـ CRC-32C للنص ASCII `123456789` هي `0xE3069283`:

```
09D6 0000 0007 0000 C000 E306 9283
```
