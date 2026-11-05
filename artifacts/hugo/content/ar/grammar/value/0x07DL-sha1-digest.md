---
title: "SHA1-DIGEST (0x07DL)"
weight: 125
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST هو Value ثابت العرض يحمل ناتج SHA-1 كاملاً."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `SHA1-DIGEST` (BIND في مستند المواصفة `SHA1-DIGEST`) |
| TAG ID | `0x07DL` |
| Codec ID | `0x000007D0` |
| مستند المواصفة | `0x00000000/codecs/0x000007D0/` (هدف DECLARE `07D0`) |
| القسم | 3 `0011` (Value)، الإزاحة C داخل القسم = 29 |
| Kind | Value · العائلة: BINARY |
| TAG WORD | `0000 0111 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | ناتج SHA-1 في Payload ثابت من 10 WORD. لأغراض التعريف فقط كمعرّف كائن git |
| جهة Hugo | `value/binary/sha1-digest.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | قيمة خام بـ 10 WORD |  |  |

SHA1-DIGEST هو Value ثابت العرض يحمل ناتج SHA-1 كاملاً. وهو رمز مباشر لـ Value هو `0x07DL`، والعائلة BINARY. Payload هو 10 WORD بالضبط (160 بت)، ولا يُسمح بالاقتطاع (truncation).

**يُستعمل لأغراض التعريف فقط.** فقد انكسرت مقاومة SHA-1 للتصادم (SHAttered عام 2017). ولأساس سلامة البيانات والتوقيع يُستعمل [SHA-256-DIGEST](0x07CL-sha-256-digest.md). وُضعت هذه الصيغة لتحمل كما هي معرّفات سُمّيت أصلاً بـ SHA-1، وأبرزها معرّف كائن (معرّف commit) في مستودع git الذي يستعمل SHA-1. فمثلاً تحمل Version (معرّف commit) في [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md) في 11 WORD بدلاً من نص hex (22 WORD).

## التخطيط {#레이아웃}

```
TAG WORD          0x07DA (0000 0111 1101 1010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## التفسير والصلاحية {#해석과-유효성}

- تُقرأ octets الـ Payload الـ 20 بترتيب مخرجات SHA-1 كما هو. وفي كل WORD يأتي الـ octet الأعلى أولاً (التأطير نفسه كما في SHA-256-DIGEST).
- يُرفض ما لم يكن Payload 10 WORD، وكل تمثيل اقتُطع فيه الناتج اعتباطاً (كمعرّف git المختصر). لا descriptor ولا padding.
- معرّف كائن git هو القيمة التي حسبها git كما هي. فـ SHA-1 في git صيغة معدّلة أُضيف إليها كشف التصادم (SHA-1DC)، لكن ناتجها مع المدخلات التي ليست هجوم تصادم يطابق SHA-1.

## المرجع المعياري {#표준-근거}

- تتبع خوارزمية SHA-1 وناتجها ذو 160 بت المعيار NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- TAG في GEUL وتأطير WORD ذي 16 بت قواعد تضيفها هذه الصيغة.

## الطول {#길이}

- المجموع هو TAG بـ 1 WORD مع Payload بـ 10 WORD أي 11 WORD بالضبط، ويستعمل `LLLL=1010`. لا Length ممتد.

## مثال {#예시}

commit في git `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## صفحات ذات صلة {#관련-페이지}

- [Value](_index.md)، [SHA-256-DIGEST](0x07CL-sha-256-digest.md)، [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x000007D0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007D000000000
BODY
#1 DECLARE 0x07D0
#2 FIELD #1 0x000A
#3 BIND #1 "SHA1-DIGEST"
#4 BIND #2 "digest"
```
