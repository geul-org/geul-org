---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS قيمة Value تحمل الوقت المدني بلا تاريخ كعدد النانوثانية بعد منتصف الليل (Codec 0x21)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CIVIL-TIME-NANOSECONDS يمثل الوقت المدني بلا تاريخ بعدد النانوثانية بعد منتصف الليل.

## التخطيط

- الرمز: الرمز المباشر في Value هو `0x21`. العائلة TIME.
- يستخدم النوع الفيزيائي signed int64 ثابت العرض نفسه في Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)`.

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  المجموع 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## التفسير والصلاحية

- تُقرأ WORD الأربع في Payload كلها كعدد signed من 64 بت بمتمم اثنين بترتيب WORD وفق big-endian.
- النوع الفيزيائي signed int64 لكن النطاق الصالح هو `0 <= value < 86,400×10^9` ns. تُرفض القيمة السالبة وما بلغ الحد الأعلى فأكثر.
- لا يُسمح بـ `24:00` ولا بتسمية الثانية الكبيسة. ولا يحمل تاريخاً ولا منطقة زمنية ولا إزاحة UTC.
- القيم الصغيرة أيضاً تستخدم 4 WORD دائماً.

## الطول

- المجموع هو TAG (1 WORD) وPayload (4 WORD)، أي 5 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0100`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.

## أمثلة

- منتصف الليل: Payload `0000 0000 0000 0000` والمجموع 5 WORD و`LLLL=0100`.
- 1ns بعد منتصف الليل: Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns تساوي الحد الأعلى فهي غير صالحة.
- `ffff ffff ffff ffff` هي -1 كـ signed int64 فهي غير صالحة.

## السند المعياري

- يخزّن `TIME(isAdjustedToUTC=false, unit=NANOS)` في [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) النانوثانية بعد منتصف الليل في الوقت المحلي في `int64` ويستخدم ترتيب signed.
- يعرّف [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) المرجعي في [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) نوع Time بوحدة NANOSECOND كعدد صحيح signed من 64 بت، ويحصر النطاق الصالح بما يقل عن 86,400 ثانية شاملاً منتصف الليل، ولا يسمح بالثانية الكبيسة. ولا يضيف GEUL سوى TAG وframing بـ WORD ذات 16 بت وفق big-endian.
