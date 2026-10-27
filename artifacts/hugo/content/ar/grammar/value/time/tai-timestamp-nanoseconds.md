---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS قيمة Value تحمل عدد النانوثانية signed منذ 1970-01-01T00:00:00 TAI (صيغة BIPM Issuer 0x4001)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDS هو عدد النانوثانية signed منذ TAI epoch نفسه `1970-01-01T00:00:00 TAI`. تمثيل العدّ التراكمي هذا ليس صيغة wire معيارية من BIPM بل profile خاص بـ GEUL يطابق مقياس زمن TAI على signed int64 ثابت العرض.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0060` BIPM، ورقم الصيغة `0x4001`. العائلة TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  المجموع 7 WORD
Issuer            1 WORD  0x0060 (BIPM)
رقم الصيغة        1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## التفسير والصلاحية

- تُقرأ WORD الأربع في Payload كلها كعدد signed من 64 بت بمتمم اثنين بترتيب WORD وفق big-endian.
- النطاق الصالح هو `-2^63`~`2^63-1` ns. القيمة السالبة هي TAI instant قبل epoch الذي حدده GEUL.
- القيم الصغيرة أيضاً تستخدم 4 WORD دائماً. لا تُخزَّن إزاحة UTC ولا جدول الثواني الكبيسة.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (4 WORD)، أي 7 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0110`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.

## أمثلة

- GEUL TAI epoch: Payload `0000 0000 0000 0000` والمجموع 7 WORD و`LLLL=0110`.
- 1ns بعد epoch: Payload `0000 0000 0000 0001`.
- 1ns قبل epoch: Payload `ffff ffff ffff ffff`.

## السند المعياري ووضع الصيغة

- يحدد [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) الثانية في النظام الدولي SI ومقياس زمن International Atomic Time (TAI).
- لا يعرّف BIPM عدد النانوثانية التراكمي signed int64 منذ epoch `1970-01-01 TAI` ولا ترميز wire له. فـ epoch والعدّ بكل وحدة وsigned int64 وتوزيع WORD وفق big-endian في GEUL هي مطابقة خاصة بـ GEUL.
- اختير int64 ثابت العرض لاتساق التبادل مع TIME count profiles الأخرى، ولا يعني ذلك أنه يعيد إنتاج صيغة BIPM كما هي.
