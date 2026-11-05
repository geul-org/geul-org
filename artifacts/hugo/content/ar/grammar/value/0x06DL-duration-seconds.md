---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS مدة زمنية منقضية بالثواني من نوع signed بلا epoch."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `DURATION-SECONDS` (مستند المواصفة BIND `DURATION-SECONDS`) |
| TAG ID | `0x06DL` |
| Codec ID | `0x000006D0` |
| مستند المواصفة | `0x00000000/codecs/0x000006D0/` (هدف DECLARE هو `06D0`) |
| القسم | 3 `0011` (Value)، الإزاحة داخل القسم C = 13 |
| Kind | Value · العائلة: TIME |
| TAG WORD | `0000 0110 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | مدة منقضية بثواني SI من نوع signed بلا epoch |
| جهة Hugo | `value/time/duration-seconds.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | قيمة خام 4 WORD |  |  |

DURATION-SECONDS مدة زمنية منقضية بالثواني من نوع signed بلا epoch. وليست instant ولا مدة بالأشهر أو السنوات في التقويم.

## التخطيط {#레이아웃}

- الرمز: رمز مباشر في Value هو `0x06DL`. العائلة TIME.
- يستخدم النوع الفيزيائي signed int64 ثابت العرض نفسه في Arrow `Duration(SECOND)`.

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  المجموع 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## التفسير والصلاحية {#해석과-유효성}

- يُقرأ Payload كله (4 WORD) على أنه عدد signed بمتمم الاثنين ذي 64 بت بترتيب WORD من نوع big-endian.
- المدى الصالح هو من `-2^63` إلى `2^63-1` ثانية. والإشارة هي اتجاه الانقضاء ولا تشير إلى instant في epoch معينة.
- تُستخدم دائماً 4 WORD حتى للقيم الصغيرة.

## الطول {#길이}

- المجموع هو TAG (1 WORD) وPayload (4 WORD)، أي 5 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0100`. لا يوجد TAG ممتد لـ Length ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.

## مثال {#예시}

- 0 ثانية هي Payload `0000 0000 0000 0000`، المجموع 5 WORD، `LLLL=0100`.
- ثانية واحدة هي Payload `0000 0000 0000 0001`.
- -1 ثانية هي Payload `FFFF FFFF FFFF FFFF`.

## الأساس المعياري {#표준-근거}

- يعيّن [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) الملف `Schema.fbs` مصدراً مرجعياً لأنواع بيانات Arrow القياسية.
- في [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) المرجعي لـ Arrow يكون `Duration` زمناً منقضياً مطلقاً لا علاقة له بالتقويم، ويدعم وحدة SECOND، ويُمثَّل دائماً بعدد صحيح signed من 8 بايت. ولا تضيف GEUL إلى ذلك إلا TAG وإطار WORD ذي 16 بت بترتيب big-endian.

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يظهر عند قراءة مستند المواصفة `0x00000000/codecs/0x000006D0/latest.geul` بالأمر `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
