---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "يعلن تاريخ سريان هذا الإصدار."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `EFFECTIVE-FROM` (BIND مستند المواصفة `EFFECTIVE-FROM`) |
| TAG ID | `0x1C8L` |
| Codec ID | `0x00001C80` |
| مستند المواصفة | `0x00000000/codecs/0x00001C80/` (هدف DECLARE `1C80`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 8 |
| Kind | Meta · الفئة: التعريف |
| TAG WORD | `0001 1100 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | تاريخ سريان هذا الإصدار. قيمة GREGORIAN-DATE أو POSIX-TIMESTAMP. وإذا غاب فهو وقت النشر |
| جهة Hugo | `meta/declaration/effective-from.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | سجل | `06A0` GREGORIAN-DATE، `06C0` POSIX-TIMESTAMP-SECONDS |  |

يعلن تاريخ سريان هذا الإصدار. وتاريخ السريان يختلف عن وقت النشر ([التعديل](../document.md#개정)).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[Length TAG ممتد]
Payload           قيمة TIME واحدة
```

- Codec: Meta `0x1C8L`، فئة التعريف
- Payload: Value مضمّنة ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) أو [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- إذا غاب فالسريان من وقت النشر.
- إذا وُجد [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) فيجب أن يسبقه.
- إذا اختلف تاريخ السريان بين المواد فيُكتب منفصلاً في Edge تلك المادة بـ QUALIFIER P580 (البداية) وP582 (النهاية) ([SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).
- تُقرأ هذه القيمة عند تفسير المستند بالنسبة إلى لحظة معينة.

## مثال {#예시}

- سريان من 1970-01-02: `0x1C83 0x06A2 0x0000 0x0001`

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001C80/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
