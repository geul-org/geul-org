---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST هو Value ثابت العرض يحمل ناتج SHA-256 من عائلة SHA-2 كاملاً."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `SHA-256-DIGEST` (BIND في مستند المواصفة `SHA-256-DIGEST`) |
| TAG ID | `0x07CL` |
| Codec ID | `0x000007C0` |
| مستند المواصفة | `0x00000000/codecs/0x000007C0/` (هدف DECLARE `07C0`) |
| القسم | 3 `0011` (Value)، الإزاحة C داخل القسم = 28 |
| Kind | Value · العائلة: BINARY |
| TAG WORD | `0000 0111 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | ناتج SHA-256 في Payload ثابت من 16 WORD |
| جهة Hugo | `value/binary/sha-256-digest.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | قيمة خام بـ 16 WORD |  |  |

SHA-256-DIGEST هو Value ثابت العرض يحمل ناتج SHA-256 من عائلة SHA-2 كاملاً. وهو رمز مباشر لـ Value هو `0x07CL`، والعائلة BINARY. Payload هو 16 WORD بالضبط (256 بت)، ولا يُسمح بالاقتطاع (truncation).

## التخطيط {#레이아웃}

```
TAG WORD          0x07CE (0000 0111 1100 1110)  LLLL=1110
Length ممتد TAG   1 WORD  0x0012 (المجموع 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## التفسير والصلاحية {#해석과-유효성}

- تُقرأ octets الـ Payload الـ 32 بترتيب مخرجات SHA-256 كما هو. وفي كل WORD يأتي الـ octet الأعلى أولاً.
- لا يُطبَّق على سلسلة بتات الـ digest أي تحويل endian خاص بـ GEUL. وإنما تُجمع octets الناتج بالترتيب كل octet اثنين لتؤطَّر كـ WORD ذي 16 بت big-endian.
- يُرفض ما لم يكن Payload 16 WORD، وكل تمثيل اقتُطع فيه الناتج اعتباطاً. لا descriptor ولا padding.

## المرجع المعياري {#표준-근거}

- تتبع خوارزمية SHA-256 وناتجها ذو 256 بت المعيار NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- TAG في GEUL وLength وتأطير WORD ذي 16 بت قواعد تضيفها هذه الصيغة، وليست من خوارزمية SHA-2.

## الطول {#길이}

- المجموع هو TAG بـ 1 WORD وTAG Length ممتد بـ 1 WORD وPayload بـ 16 WORD أي 18 WORD بالضبط، ويستعمل `LLLL=1110`. لا descriptor ولا padding.
- يُرفض إن لم يكن Payload 16 WORD بالضبط.

## مثال {#예시}

- تُوضع octets الـ digest من `d[0]` إلى `d[31]` في WORD الـ Payload بالترتيب من `(d[0]<<8)|d[1]` إلى `(d[30]<<8)|d[31]`. ويبقى Length الكلي 18 WORD دائماً.

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x000007C0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
