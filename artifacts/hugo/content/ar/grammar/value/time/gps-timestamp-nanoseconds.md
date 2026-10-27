---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS قيمة Value تحمل عدد النانوثانية signed منذ GPS epoch 1980-01-06T00:00:00 GPS (صيغة GPS Issuer 0x4001)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS هو عدد النانوثانية signed منذ GPS epoch `1980-01-06T00:00:00 GPS`. لا يُقسَّم برقم GPS week ولا يُقتطع بعرض week rollover في حقل البث (broadcast field).

تمثيل العدّ التراكمي هذا ليس صيغة wire للبث في IS-GPS-200 بل profile خاص بـ GEUL يطابق مقياس زمن GPS على signed int64 ثابت العرض.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0063` GPS، ورقم الصيغة `0x4001`. العائلة TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  المجموع 7 WORD
Issuer            1 WORD  0x0063 (GPS)
رقم الصيغة        1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## التفسير والصلاحية

- تُقرأ WORD الأربع في Payload كلها كعدد signed من 64 بت بمتمم اثنين بترتيب WORD وفق big-endian.
- النطاق الصالح هو `-2^63`~`2^63-1` ns. القيمة السالبة هي GPS-time instant قبل GPS epoch.
- العدّ قيمة متصلة مستمرة منذ epoch. لا يُطبَّق truncation ولا rollover لحقل week-number في البث.
- القيم الصغيرة أيضاً تستخدم 4 WORD دائماً. لا تُحمل معاملات التحويل إلى UTC.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (4 WORD)، أي 7 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0110`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.

## أمثلة

- GPS epoch: Payload `0000 0000 0000 0000` والمجموع 7 WORD و`LLLL=0110`.
- 1ns بعد epoch: Payload `0000 0000 0000 0001`.
- 1ns قبل epoch: Payload `ffff ffff ffff ffff`.

## السند المعياري ووضع الصيغة

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) هو الموزّع الرسمي لمواصفات واجهة GPS.
- يحدد [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) أن زمن GPS مقياس زمني متصل وأن week 0 يبدأ عند منتصف ليل 1980-01-06، ويعرّف GPS week number وحقلي time-of-week/Z-count في البث.
- لا يعرّف IS-GPS-200 تمثيل wire بعدد النانوثانية التراكمي منذ epoch كـ signed int64. العدّ المتصل بوحدة النانوثانية بلا rollover وsigned int64 وتوزيع WORD وفق big-endian في GEUL هي مطابقة خاصة بـ GEUL.
