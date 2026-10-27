---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS قيمة Value تحمل عدد الثواني signed int64 منذ Unix epoch (Codec 0x22)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS هو عدد الثواني signed منذ Unix epoch `1970-01-01T00:00:00Z`. كما في seconds-since-the-Epoch في POSIX يُعدّ كل يوم 86,400 ثانية تماماً ولا تُحسب الثواني الكبيسة.

## التخطيط

- الرمز: الرمز المباشر في Value هو `0x22`. العائلة TIME.
- لتبادل بيانات الصناعة يستخدم النوع الفيزيائي signed int64 ثابت العرض نفسه في Arrow `timestamp[s]`.

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  المجموع 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## التفسير والصلاحية

- تُقرأ WORD الأربع في Payload كلها كعدد signed من 64 بت بمتمم اثنين بترتيب WORD وفق big-endian.
- النطاق الصالح هو `-2^63`~`2^63-1` ثانية. القيمة السالبة هي instant قبل epoch.
- القيم الصغيرة أيضاً تستخدم 4 WORD دائماً. ولا يجوز اختزالها إلى تمثيل عدد صحيح بأقل عدد من WORD.
- لا تُحمل المنطقة الزمنية ولا إزاحة UTC الأصلية ولا تسمية الثانية الكبيسة ولا جدول الثواني الكبيسة.

## الطول

- المجموع هو TAG (1 WORD) وPayload (4 WORD)، أي 5 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0100`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.

## أمثلة

- epoch: Payload `0000 0000 0000 0000` والمجموع 5 WORD و`LLLL=0100`.
- ثانية واحدة بعد epoch: Payload `0000 0000 0000 0001`.
- ثانية واحدة قبل epoch: Payload `ffff ffff ffff ffff`.

## السند المعياري

- يعرّف [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) العضوين `time_t tv_sec` و`long tv_nsec` فقط، ولا يعرّف صيغة wire تسلسل الثواني التراكمية كـ signed int64. العرض الفعلي لـ `time_t` وتمثيله يتبعان بيئة التنفيذ ولا يطابقان تمثيل Payload في GEUL.
- يعرّف [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) مقابلة الثواني بعد epoch بالتقويم وقاعدة اليوم 86,400 ثانية.
- يعرّف [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) و[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) المرجعي الطابع الزمني كعدد صحيح signed من 64 بت منذ epoch ثابت، ويدعم وحدة SECOND وعدم عدّ الثواني الكبيسة. ولا يضيف GEUL إلى هذا النوع الفيزيائي سوى TAG وframing بـ WORD ذات 16 بت وفق big-endian.
