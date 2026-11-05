---
title: "BIT-VECTOR (0x080L)"
weight: 128
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR هو تسلسل بتات خام (raw bit sequence) معلن الطول."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR تسلسل بتات خام (raw bit sequence) معلن الطول. وهو رمز مباشر لـ Value هو `0x080L`، والعائلة BINARY. أول 2 WORD من Payload هما عدد البتات `N` كعدد غير موقّع من 32 بت، ويتبعهما `ceil(N/16)` WORD.

| البند | القيمة |
|---|---|
| الاسم | `BIT-VECTOR` (BIND في مستند المواصفة `BIT-VECTOR`) |
| TAG ID | `0x080L` |
| Codec ID | `0x00000800` |
| مستند المواصفة | `0x00000000/codecs/0x00000800/` (هدف DECLARE `0800`) |
| القسم | 4 `0100` (Value)، الإزاحة C داخل القسم = 0 |
| Kind | Value · العائلة: BINARY |
| TAG WORD | `0000 1000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | N بت مخزَّنة بترتيب MSB-first بعد bit-count |
| جهة Hugo | `value/binary/bit-vector.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bit-count` | #2 | قيمة خام بـ 2 WORD |  |  |
| 2 | `bits` | #3 | قيمة خام للباقي (`0xFFFF`) |  |  |

## التخطيط {#레이아웃}

```
TAG WORD          0000 1000 0000 LLLL      Codec 0x080L
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Payload WORD 1st–2nd       Bit Count N (أعلى 16bit │ أدنى 16bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## التفسير والصلاحية {#해석과-유효성}

- `N` هي القيمة المقروءة من أول 2 WORD في Payload كعدد صحيح غير موقّع من 32 بت بترتيب big-endian.
- تُملأ بتات payload بدءاً من أعلى بت في كل WORD.
- عدد WORD في payload يساوي `ceil(N/16)` تماماً، ويجب أن تكون البتات الدنيا غير المستعملة في آخر WORD كلها 0.
- إذا كانت `N=0` فلا WORD في payload. فلا يتعارض هذا مع قاعدة أن Payload لا يقل عن 1 WORD، لأن WORDَي العدد يكوّنان Payload فعلاً.

## مكانة الصيغة {#형식-지위}

- عدد البتات غير الموقّع بـ 32 بت وترتيب MSB-first وzero padding في آخر WORD هي framing خاص بـ GEUL، وليست اقتباساً من معيار صناعي خارجي.
- تعرّف هذه الصفحة التمثيل، بما فيه TAG في GEUL وLength وقواعد WORD ذي 16 بت.

## الطول {#길이}

- المجموع هو عدد WORD في TAG واحد، وTAG Length الممتد (إن وُجد)، وPayload. حتى 14 WORD يُستعمل الطول المباشر، ومن 15 WORD فأكثر يُستعمل الطول الممتد `1110`·`1111`، ويدخل TAG الممتد في المجموع ([السجل وTAG WORD](../record.md)).

## مثال {#예시}

- متجه البتات الفارغ: count هو `0000 0000`، ولا payload، والمجموع 3 WORD، و`LLLL=0010`. فالكل `0802 0000 0000`.
- تسلسل البتات `101`: count هو `0000 0003`، وpayload هو `A000`، والمجموع 4 WORD، و`LLLL=0011`. فالكل `0803 0000 0003 A000`.

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000800/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000080000000000
BODY
#1 DECLARE 0x0800
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "BIT-VECTOR"
#5 BIND #2 "bit-count"
#6 BIND #3 "bits"
```
