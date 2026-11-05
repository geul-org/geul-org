---
title: "GPS-TIMESTAMP-SECONDS"
weight: 1024
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-SECONDS هو عدد الثواني الموقَّع (signed) منذ epoch نظام GPS في 1980-01-06T00:00:00 GPS."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-SECONDS هو عدد الثواني الموقَّع (signed) منذ epoch نظام GPS في `1980-01-06T00:00:00 GPS`. لا يُقسَّم على رقم GPS week ولا يُقتطع بعرض week rollover في حقل broadcast.

هذا التمثيل بالـ count التراكمي ليس broadcast wire format في IS-GPS-200، بل هو profile خاص بـ GEUL يُسقِط مقياس زمن GPS على int64 موقَّع ثابت العرض.

## التخطيط {#레이아웃}

- الرمز: Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000016` GPS، رقم Codec `0x00004000`. العائلة TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  الإجمالي 9 WORD
Issuer            2 WORD  0x00000016 (GPS)
رقم Codec         2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## التفسير والصلاحية {#해석과-유효성}

- يُقرأ Payload كله (4 WORD) على أنه count موقَّع (signed) بعرض 64 bit بمتمم الاثنين (two's complement) بترتيب WORD من نوع big-endian.
- النطاق الصالح هو `-2^63`~`2^63-1` ثانية. القيمة السالبة هي لحظة بزمن GPS سابقة لـ epoch الـ GPS.
- الـ count قيمة متصلة ممتدة من epoch. ولا يُطبَّق اقتطاع أو rollover لحقل week-number في broadcast.
- تُستخدم دائمًا 4 WORD حتى للقيم الصغيرة. ولا تُحمَل معاملات التحويل إلى UTC.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 4 WORD، أي 9 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1000`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 4 WORD بالضبط.

## مثال {#예시}

- epoch الـ GPS هو Payload `0000 0000 0000 0000`، والسجل كله 9 WORD، و`LLLL=1000`.
- بعد epoch بثانية واحدة يكون Payload `0000 0000 0000 0001`.
- قبل epoch بثانية واحدة يكون Payload `FFFF FFFF FFFF FFFF`.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) هو المصدر الرسمي لتوزيع مواصفات واجهات GPS.
- يحدّد [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) أن زمن GPS مقياس زمني متصل وأن week 0 تبدأ عند منتصف ليل 1980-01-06، ويعرّف GPS week number وحقول time-of-week/Z-count في broadcast.
- لا يعرّف IS-GPS-200 تمثيل wire بـ int64 موقَّع تراكمي منذ epoch بصيغته الحالية. والـ count المتصل بلا rollover وint64 الموقَّع وتوزيع WORD من نوع big-endian تعيين خاص بـ GEUL.
