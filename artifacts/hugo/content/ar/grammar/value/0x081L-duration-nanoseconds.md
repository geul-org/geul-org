---
title: "DURATION-NANOSECONDS (0x081L)"
weight: 129
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS هو زمن منقضٍ بالنانوثانية موقّع وبلا epoch."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS هو زمن منقضٍ بالنانوثانية موقّع (signed) وبلا epoch. فليس instant ولا مدة بالأشهر أو السنوات التقويمية.

| البند | القيمة |
|---|---|
| الاسم | `DURATION-NANOSECONDS` (BIND في مستند المواصفة `DURATION-NANOSECONDS`) |
| TAG ID | `0x081L` |
| Codec ID | `0x00000810` |
| مستند المواصفة | `0x00000000/codecs/0x00000810/` (هدف DECLARE `0810`) |
| القسم | 4 `0100` (Value)، الإزاحة C داخل القسم = 1 |
| Kind | Value · العائلة: TIME |
| TAG WORD | `0000 1000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | زمن منقضٍ بالنانوثانية موقّع وبلا epoch |
| جهة Hugo | `value/time/duration-nanoseconds.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | قيمة خام بـ 4 WORD |  |  |

## التخطيط {#레이아웃}

- الرمز: رمز مباشر لـ Value هو `0x081L`. العائلة TIME.
- يستعمل النوع الفيزيائي نفسه الثابت العرض signed int64 كما في Arrow `Duration(NANOSECOND)`.

```
TAG WORD          0x0814 (0000 1000 0001 0100)  المجموع 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## التفسير والصلاحية {#해석과-유효성}

- يُقرأ Payload بـ 4 WORD كله كعدد موقّع بتكميل الاثنين بطول 64 بت بترتيب WORD من نوع big-endian.
- المدى الصالح هو `-2^63`~`2^63-1` نانوثانية. والإشارة هي اتجاه الانقضاء، ولا تدل على instant في epoch معين.
- تُستعمل 4 WORD دائماً حتى للقيم الصغيرة.

## الطول {#길이}

- المجموع هو TAG بـ 1 WORD مع Payload بـ 4 WORD أي 5 WORD بالضبط، ويستعمل الطول المباشر `LLLL=0100`. لا TAG Length ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 4 WORD بالضبط.

## مثال {#예시}

- 0ns: Payload هو `0000 0000 0000 0000`، والمجموع 5 WORD، و`LLLL=0100`. فالكل `0814 0000 0000 0000 0000`.
- 1ns: Payload هو `0000 0000 0000 0001`.
- -1ns: Payload هو `FFFF FFFF FFFF FFFF`.

## المرجع المعياري {#표준-근거}

- يحدد [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) أن `Schema.fbs` هو المصدر المرجعي (authoritative) لأنواع بيانات Arrow المعيارية.
- في [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) المرجعي لـ Arrow، `Duration` زمن منقضٍ مطلق لا علاقة له بالتقويم، يدعم وحدة NANOSECOND، ويُمثَّل دائماً بعدد صحيح موقّع من 8 بايتات. ولا تضيف GEUL إليه سوى TAG وتأطير WORD ذي 16 بت بترتيب big-endian.

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000810/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000081000000000
BODY
#1 DECLARE 0x0810
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
