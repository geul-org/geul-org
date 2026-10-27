---
title: "DURATION-SECONDS"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS قيمة Value تحمل زمناً منقضياً signed int64 بالثواني بلا epoch (Codec 0x23)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-SECONDS زمن منقضٍ signed بالثواني بلا epoch. وليس instant ولا مدة بالأشهر والسنوات في تقويم.

## التخطيط

- الرمز: الرمز المباشر في Value هو `0x23`. العائلة TIME.
- يستخدم النوع الفيزيائي signed int64 ثابت العرض نفسه في Arrow `Duration(SECOND)`.

```
TAG WORD          0x0A23 (0000 1010 0010 0011)  المجموع 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## التفسير والصلاحية

- تُقرأ WORD الأربع في Payload كلها كعدد signed من 64 بت بمتمم اثنين بترتيب WORD وفق big-endian.
- النطاق الصالح هو `-2^63`~`2^63-1` ثانية. الإشارة هي اتجاه الانقضاء ولا تشير إلى instant في epoch بعينه.
- القيم الصغيرة أيضاً تستخدم 4 WORD دائماً.

## الطول

- المجموع هو TAG (1 WORD) وPayload (4 WORD)، أي 5 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0100`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.

## أمثلة

- 0 ثانية: Payload `0000 0000 0000 0000` والمجموع 5 WORD و`LLLL=0100`.
- ثانية واحدة: Payload `0000 0000 0000 0001`.
- -1 ثانية: Payload `ffff ffff ffff ffff`.

## السند المعياري

- يحدد [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) أن `Schema.fbs` هو المصدر المرجعي لأنواع بيانات Arrow القياسية.
- في [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) المرجعي في Arrow يكون `Duration` زمناً منقضياً مطلقاً لا علاقة له بالتقويم، ويدعم وحدة SECOND، ويُمثَّل دائماً كعدد صحيح signed من 8 بايتات. ولا يضيف GEUL إلى ذلك سوى TAG وframing بـ WORD ذات 16 بت وفق big-endian.
