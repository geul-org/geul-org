---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "يعلن نهاية مدة سريان هذا الإصدار (قانون مؤقت)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `EFFECTIVE-UNTIL` (BIND مستند المواصفة `EFFECTIVE-UNTIL`) |
| TAG ID | `0x1C9L` |
| Codec ID | `0x00001C90` |
| مستند المواصفة | `0x00000000/codecs/0x00001C90/` (هدف DECLARE `1C90`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 9 |
| Kind | Meta · الفئة: التعريف |
| TAG WORD | `0001 1100 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | نهاية مدة سريان هذا الإصدار (قانون مؤقت). وإذا غاب فحتى سريان الإصدار التالي |
| جهة Hugo | `meta/declaration/effective-until.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | سجل | `06A0` GREGORIAN-DATE، `06C0` POSIX-TIMESTAMP-SECONDS |  |

يعلن نهاية مدة سريان هذا الإصدار (قانون مؤقت). ومن ذلك الوقت لا يكون هذا الإصدار ساري المفعول.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[Length TAG ممتد]
Payload           قيمة TIME واحدة
```

- Codec: Meta `0x1C9L`، فئة التعريف
- Payload: Value مضمّنة ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) أو [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- إذا غاب فهو ساري حتى يسري الإصدار التالي.
- بعد انقضاء مدة السريان لا توجد نسخة سارية. ولا تعود النسخة القديمة إلى الحياة.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001C90/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
