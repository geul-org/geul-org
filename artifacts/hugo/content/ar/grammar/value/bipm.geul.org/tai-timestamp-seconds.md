---
title: "TAI-TIMESTAMP-SECONDS"
weight: 1022
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-SECONDS هو عدد SI-second الموقَّع (signed) منذ 1970-01-01T00:00:00 TAI."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-SECONDS هو عدد SI-second الموقَّع (signed) منذ `1970-01-01T00:00:00 TAI`. هذا التمثيل بالـ count التراكمي ليس wire format معياريًّا من BIPM، بل هو profile خاص بـ GEUL يُسقِط مقياس الزمن TAI على int64 موقَّع ثابت العرض.

## التخطيط {#레이아웃}

- الرمز: Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000013` BIPM، رقم Codec `0x00004000`. العائلة TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  الإجمالي 9 WORD
Issuer            2 WORD  0x00000013 (BIPM)
رقم Codec         2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed SI Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed SI Seconds
Payload WORD 3rd (bits 31..16)     Signed SI Seconds
Payload WORD 4th (bits 15..0)      Signed SI Seconds low 16bit
```

## التفسير والصلاحية {#해석과-유효성}

- يُقرأ Payload كله (4 WORD) على أنه count موقَّع (signed) بعرض 64 bit بمتمم الاثنين (two's complement) بترتيب WORD من نوع big-endian.
- النطاق الصالح هو `-2^63`~`2^63-1` ثانية. القيمة السالبة هي لحظة TAI سابقة لـ epoch الذي حدّده GEUL.
- تُستخدم دائمًا 4 WORD حتى للقيم الصغيرة. ولا يُخزَّن UTC offset ولا جدول leap-second.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 4 WORD، أي 9 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1000`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 4 WORD بالضبط.

## مثال {#예시}

- epoch الـ TAI في GEUL هو Payload `0000 0000 0000 0000`، والسجل كله 9 WORD، و`LLLL=1000`.
- بعد epoch بثانية واحدة يكون Payload `0000 0000 0000 0001`.
- قبل epoch بثانية واحدة يكون Payload `FFFF FFFF FFFF FFFF`.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- يحدّد [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) الثانية في النظام الدولي (SI second) ومقياس الزمن International Atomic Time (TAI).
- لا يعرّف BIPM count تراكميًّا بـ int64 موقَّع منذ epoch `1970-01-01 TAI` ولا wire encoding له. وكل من epoch وint64 الموقَّع وتوزيع WORD من نوع big-endian هو تعيين خاص بـ GEUL.
- اختير int64 ثابت العرض لاتساق التبادل مع profiles أخرى لـ TIME count، ولا يعني ذلك أنه يعيد إنتاج صيغة BIPM كما هي.
