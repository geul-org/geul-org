---
title: "CIVIL-TIME-NANOSECONDS (0x06BL)"
weight: 107
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS يمثل الوقت المدني بلا تاريخ بعدد النانوثانية بعد منتصف الليل."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `CIVIL-TIME-NANOSECONDS` (مستند المواصفة BIND `CIVIL-TIME-NANOSECONDS`) |
| TAG ID | `0x06BL` |
| Codec ID | `0x000006B0` |
| مستند المواصفة | `0x00000000/codecs/0x000006B0/` (هدف DECLARE هو `06B0`) |
| القسم | 3 `0011` (Value)، الإزاحة داخل القسم C = 11 |
| Kind | Value · العائلة: TIME |
| TAG WORD | `0000 0110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | عدد unsigned من النانوثانية بعد منتصف ليل اليوم المدني |
| جهة Hugo | `value/time/civil-time-nanoseconds.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | قيمة خام 4 WORD |  |  |

CIVIL-TIME-NANOSECONDS يمثل الوقت المدني بلا تاريخ بعدد النانوثانية بعد منتصف الليل.

## التخطيط {#레이아웃}

- الرمز: رمز مباشر في Value هو `0x06BL`. العائلة TIME.
- يستخدم النوع الفيزيائي signed int64 ثابت العرض نفسه في Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)`.

```
TAG WORD          0x06B4 (0000 0110 1011 0100)  المجموع 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## التفسير والصلاحية {#해석과-유효성}

- يُقرأ Payload كله (4 WORD) على أنه عدد signed بمتمم الاثنين ذي 64 بت بترتيب WORD من نوع big-endian.
- النوع الفيزيائي هو signed int64 لكن المدى الصالح هو `0 <= value < 86,400×10^9` ns. تُرفض القيمة السالبة والقيمة التي تساوي الحد الأعلى أو تزيد عليه.
- لا يُسمح بـ `24:00` ولا بتسمية الثانية الكبيسة. ولا يُحفظ التاريخ ولا المنطقة الزمنية ولا UTC offset.
- تُستخدم دائماً 4 WORD حتى للقيم الصغيرة.

## الطول {#길이}

- المجموع هو TAG (1 WORD) وPayload (4 WORD)، أي 5 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0100`. لا يوجد TAG ممتد لـ Length ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.

## مثال {#예시}

- منتصف الليل هو Payload `0000 0000 0000 0000`، المجموع 5 WORD، `LLLL=0100`.
- بعد منتصف الليل بنانوثانية واحدة (1ns) هو Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns تساوي الحد الأعلى فهي غير صالحة.
- `FFFF FFFF FFFF FFFF` تساوي -1 في signed int64 فهي غير صالحة.

## الأساس المعياري {#표준-근거}

- `TIME(isAdjustedToUTC=false, unit=NANOS)` في [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) يخزن النانوثانية بعد منتصف ليل الوقت المحلي في `int64` ويستخدم ترتيب signed.
- يعرّف Schema.fbs المرجعي ([Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html)، [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs)) النوع Time بدقة NANOSECOND على أنه عدد صحيح signed من 64 بت، ويحدد المدى الصالح بأقل من 86,400 ثانية بدءاً من منتصف الليل، ولا يسمح بالثانية الكبيسة. ولا تضيف GEUL إلا TAG وإطار WORD ذي 16 بت بترتيب big-endian.

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يظهر عند قراءة مستند المواصفة `0x00000000/codecs/0x000006B0/latest.geul` بالأمر `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006B000000000
BODY
#1 DECLARE 0x06B0
#2 FIELD #1 0x0004
#3 BIND #1 "CIVIL-TIME-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
