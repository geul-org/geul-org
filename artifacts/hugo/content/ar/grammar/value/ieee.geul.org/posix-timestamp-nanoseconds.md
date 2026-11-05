---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1032
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS هو عدد nanosecond الموقَّع (signed) منذ Unix epoch في 1970-01-01T00:00:00Z."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS هو عدد nanosecond الموقَّع (signed) منذ Unix epoch في `1970-01-01T00:00:00Z`. وكما في seconds-since-the-Epoch في POSIX، يُعدّ كل يوم 86,400 ثانية بالضبط ولا تُحسب الثواني الكبيسة.

## التخطيط {#레이아웃}

- الرمز: Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x0000000D` IEEE، رقم Codec `0x00004000`. العائلة TIME.
- لتبادل البيانات الصناعي يُستخدم النوع الفيزيائي int64 الموقَّع ثابت العرض نفسه الذي في Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  الإجمالي 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
رقم Codec         2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## التفسير والصلاحية {#해석과-유효성}

- يُقرأ Payload كله (4 WORD) على أنه count موقَّع (signed) بعرض 64 bit بمتمم الاثنين (two's complement) بترتيب WORD من نوع big-endian.
- النطاق الصالح هو `-2^63`~`2^63-1` ns، ونطاق instant هو `1677-09-21 00:12:43.145224192Z`~`2262-04-11 23:47:16.854775807Z`.
- تُستخدم دائمًا 4 WORD حتى للقيم الصغيرة. ولا يجوز اختصارها إلى أصغر تمثيل بعدد صحيح من WORD.
- لا تُحمَل المنطقة الزمنية (timezone) ولا UTC offset الأصلي ولا label الثانية الكبيسة ولا جدول leap-second.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 4 WORD، أي 9 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1000`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 4 WORD بالضبط.

## مثال {#예시}

- epoch هو Payload `0000 0000 0000 0000`، والسجل كله 9 WORD، و`LLLL=1000`.
- بعد epoch بـ 1ns يكون Payload `0000 0000 0000 0001`.
- قبل epoch بـ 1ns يكون Payload `FFFF FFFF FFFF FFFF`.

## المرجع القياسي {#표준-근거}

- يعرّف [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) العضوين `time_t tv_sec` و`long tv_nsec` والشرط `0 <= tv_nsec < 10^9`. أما العرض المحدد لـ `time_t` وتمثيله فيتبعان بيئة التنفيذ، ولا يعرّف wire format بـ int64 موقَّع لعدد nanosecond التراكمي الذي يجمع العضوين.
- يعدّ [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) اليوم 86,400 ثانية بالضبط.
- يخزّن `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` في [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) عدد nanosecond منذ Unix epoch في `int64` واحد. ولا يضيف GEUL إلى هذا النوع الفيزيائي إلا TAG وتأطير WORD بعرض 16 bit من نوع big-endian.
