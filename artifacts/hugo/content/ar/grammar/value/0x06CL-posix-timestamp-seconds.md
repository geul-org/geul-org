---
title: "POSIX-TIMESTAMP-SECONDS (0x06CL)"
weight: 108
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS عدد ثوانٍ signed منذ Unix epoch 1970-01-01T00:00:00Z."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `POSIX-TIMESTAMP-SECONDS` (مستند المواصفة BIND `POSIX-TIMESTAMP-SECONDS`) |
| TAG ID | `0x06CL` |
| Codec ID | `0x000006C0` |
| مستند المواصفة | `0x00000000/codecs/0x000006C0/` (هدف DECLARE هو `06C0`) |
| القسم | 3 `0011` (Value)، الإزاحة داخل القسم C = 12 |
| Kind | Value · العائلة: TIME |
| TAG WORD | `0000 0110 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | عدد ثوانٍ signed منذ Unix/POSIX epoch |
| جهة Hugo | `value/time/posix-timestamp-seconds.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | قيمة خام 4 WORD |  |  |

POSIX-TIMESTAMP-SECONDS عدد ثوانٍ signed منذ Unix epoch `1970-01-01T00:00:00Z`. وكما في seconds-since-the-Epoch في POSIX، يُعدّ كل يوم 86,400 ثانية تماماً ولا تُحسب الثواني الكبيسة.

## التخطيط {#레이아웃}

- الرمز: رمز مباشر في Value هو `0x06CL`. العائلة TIME.
- لتبادل بيانات الصناعة يُستخدم النوع الفيزيائي signed int64 ثابت العرض نفسه في Arrow `timestamp[s]`.

```
TAG WORD          0x06C4 (0000 0110 1100 0100)  المجموع 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## التفسير والصلاحية {#해석과-유효성}

- يُقرأ Payload كله (4 WORD) على أنه عدد signed بمتمم الاثنين ذي 64 بت بترتيب WORD من نوع big-endian.
- المدى الصالح هو من `-2^63` إلى `2^63-1` ثانية. والقيمة السالبة instant قبل epoch.
- تُستخدم دائماً 4 WORD حتى للقيم الصغيرة. ولا يجوز اختصارها بتمثيل العدد الصحيح بأقل عدد من WORD.
- لا يُحفظ timezone ولا UTC offset الأصلي ولا تسمية الثانية الكبيسة ولا leap-second table.

## الطول {#길이}

- المجموع هو TAG (1 WORD) وPayload (4 WORD)، أي 5 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0100`. لا يوجد TAG ممتد لـ Length ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.

## مثال {#예시}

- epoch هو Payload `0000 0000 0000 0000`، المجموع 5 WORD، `LLLL=0100`.
- بعد epoch بثانية واحدة هو Payload `0000 0000 0000 0001`.
- قبل epoch بثانية واحدة هو Payload `FFFF FFFF FFFF FFFF`.

## الأساس المعياري {#표준-근거}

- يعرّف [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) العضوين `time_t tv_sec` و`long tv_nsec` فقط، ولا يعرّف wire format يُسلسل الثواني المتراكمة بصيغة signed int64. عرض `time_t` وتمثيله يتبعان بيئة التنفيذ وليسا مثل تمثيل Payload في GEUL.
- يعرّف [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) مقابلة الثواني بعد epoch للتقويم وقاعدة اليوم الواحد 86,400 ثانية.
- يعرّف [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) و[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) المرجعي timestamp بأنه عدد صحيح signed من 64 بت منذ epoch ثابتة، ويدعم وحدة SECOND وعدم عدّ الثواني الكبيسة. ولا تضيف GEUL إلى هذا النوع الفيزيائي إلا TAG وإطار WORD ذي 16 بت بترتيب big-endian.

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يظهر عند قراءة مستند المواصفة `0x00000000/codecs/0x000006C0/latest.geul` بالأمر `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006C000000000
BODY
#1 DECLARE 0x06C0
#2 FIELD #1 0x0004
#3 BIND #1 "POSIX-TIMESTAMP-SECONDS"
#4 BIND #2 "seconds"
```
