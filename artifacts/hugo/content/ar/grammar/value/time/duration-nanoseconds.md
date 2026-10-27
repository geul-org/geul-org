---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS قيمة Value تحمل زمناً منقضياً signed int64 بالنانوثانية بلا epoch (صيغة GEUL Issuer 0x4000)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS زمن منقضٍ signed بالنانوثانية بلا epoch. وليس instant ولا مدة بالأشهر والسنوات في تقويم.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0000` GEUL، ورقم الصيغة `0x4000`. العائلة TIME.
- يستخدم النوع الفيزيائي signed int64 ثابت العرض نفسه في Arrow `Duration(NANOSECOND)`.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  المجموع 7 WORD
Issuer            1 WORD  0x0000 (GEUL)
رقم الصيغة        1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## التفسير والصلاحية

- تُقرأ WORD الأربع في Payload كلها كعدد signed من 64 بت بمتمم اثنين بترتيب WORD وفق big-endian.
- النطاق الصالح هو `-2^63`~`2^63-1` ns. الإشارة هي اتجاه الانقضاء ولا تشير إلى instant في epoch بعينه.
- القيم الصغيرة أيضاً تستخدم 4 WORD دائماً.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (4 WORD)، أي 7 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0110`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.

## أمثلة

- 0ns: Payload `0000 0000 0000 0000` والمجموع 7 WORD و`LLLL=0110`.
- 1ns: Payload `0000 0000 0000 0001`.
- -1ns: Payload `ffff ffff ffff ffff`.

## السند المعياري

- يحدد [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) أن `Schema.fbs` هو المصدر المرجعي لأنواع بيانات Arrow القياسية.
- في [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) المرجعي في Arrow يكون `Duration` زمناً منقضياً مطلقاً لا علاقة له بالتقويم، ويدعم وحدة NANOSECOND، ويُمثَّل دائماً كعدد صحيح signed من 8 بايتات. ولا يضيف GEUL إلى ذلك سوى TAG وframing بـ WORD ذات 16 بت وفق big-endian.
