---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS قيمة Value تحمل عدد النانوثانية signed int64 منذ Unix epoch (صيغة IEEE Issuer 0x4000)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS هو عدد النانوثانية signed منذ Unix epoch `1970-01-01T00:00:00Z`. كما في seconds-since-the-Epoch في POSIX يُعدّ كل يوم 86,400 ثانية تماماً ولا تُحسب الثواني الكبيسة.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0040` IEEE، ورقم الصيغة `0x4000`. العائلة TIME.
- لتبادل بيانات الصناعة يستخدم النوع الفيزيائي signed int64 ثابت العرض نفسه في Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  المجموع 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
رقم الصيغة        1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## التفسير والصلاحية

- تُقرأ WORD الأربع في Payload كلها كعدد signed من 64 بت بمتمم اثنين بترتيب WORD وفق big-endian.
- النطاق الصالح هو `-2^63`~`2^63-1` ns، ونطاق instant هو `1677-09-21 00:12:43.145224192Z`~`2262-04-11 23:47:16.854775807Z`.
- القيم الصغيرة أيضاً تستخدم 4 WORD دائماً. ولا يجوز اختزالها إلى تمثيل عدد صحيح بأقل عدد من WORD.
- لا تُحمل المنطقة الزمنية ولا إزاحة UTC الأصلية ولا تسمية الثانية الكبيسة ولا جدول الثواني الكبيسة.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (4 WORD)، أي 7 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0110`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.

## أمثلة

- epoch: Payload `0000 0000 0000 0000` والمجموع 7 WORD و`LLLL=0110`.
- 1ns بعد epoch: Payload `0000 0000 0000 0001`.
- 1ns قبل epoch: Payload `ffff ffff ffff ffff`.

## السند المعياري

- يعرّف [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) العضوين `time_t tv_sec` و`long tv_nsec` والشرط `0 <= tv_nsec < 10^9`. أما العرض الفعلي لـ `time_t` وتمثيله فيتبعان بيئة التنفيذ، ولا يعرّف صيغة wire بعدد النانوثانية التراكمي signed int64 الذي يجمع العضوين.
- يعدّ [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) اليوم 86,400 ثانية تماماً.
- يخزّن `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` في [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) النانوثانية منذ Unix epoch في `int64` واحد. ولا يضيف GEUL إلى هذا النوع الفيزيائي سوى TAG وframing بـ WORD ذات 16 بت وفق big-endian.
