---
title: "ENUM (0x0BDL)"
weight: 189
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM هو Edge عبارة يُلحق معنى بقيمة رمز واحدة في حقل خام."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `ENUM` (BIND مستند المواصفة `ENUM`) |
| TAG ID | `0x0BDL` |
| Codec ID | `0x00000BD0` |
| مستند المواصفة | `0x00000000/codecs/0x00000BD0/` (هدف DECLARE `0BD0`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 29 |
| Kind | Edge · العائلة: العبارة، الحزمة: أخرى |
| TAG WORD | `0000 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | قيمة رمز واحدة لحقل خام. الحقل وقيمة الرمز |
| جانب Hugo | `edge/enum.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | سجل | `0050` LOCAL |  |
| 2 | `code` | #3 | القيمة الخام المتبقية (`0xFFFF`) |  |  |

ENUM هو Edge عبارة يُلحق معنى بقيمة رمز واحدة في حقل خام. Codec `0x0BDL`.

هو مع [FIELD](0x0BCL-field.md) مفردات لكتابة مواصفة Codec. التخطيط مضمَّن في المفكِّك ([مستند مواصفة Codec](../codec-spec.md)).

## التخطيط {#레이아웃}

```
TAG WORD          0000 1011 1101 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
الحقل             سجل LOCAL Reference يشير إلى Edge من نوع FIELD
قيمة الرمز        قيمة خام. بعدد WORD مساوٍ لعرض ذلك FIELD
```

## التفسير والصلاحية {#해석과-유효성}

- يجب أن يكون الحقل FIELD خاماً (العرض `n ≥ 1`). لا يُلحق ENUM بحقل السجل. فمعنى السجل يقوله Codec ذلك السجل.
- قيمة الرمز بقدر عرض ذلك FIELD تماماً. ويُتحقَّق من الحدود بـ Length سجل ENUM.
- لا تُعلَن قيمة الرمز نفسها مرتين في حقل واحد.
- يُربط اسم قيمة الرمز بـ Edge Id الخاص بـ ENUM عبر [BIND](0x0A3L-bind.md). وكل UTF8-TEXT يُلحق بـ DECLARE وFIELD وENUM وCODEC يكون بـ BIND، ولا يُلحق بـ Edge آخر مثل LABEL.
- قيمة الرمز غير المعلَنة ليست خطأً. يعرضها العارض قيمةً خاماً كما هي. وإغلاق القيم المسموحة من شأن مواصفة Codec، وليس في المفردات الحالية علامة للإغلاق.

## الطول {#길이}

```
الكل = 1 + N_len + N_id + N_field + n WORD
```

## مثال (غير معياري) {#예시-비규범}

يُصرَّح بالرمز `0x0001` في حقل فئة السبب (FIELD #4، قيمة خام 1 WORD) في مستند مواصفة TOMBSTONE. Edge Id هو 10. ويُربط الاسم على حدة بـ BIND. ولأن جدول رموز فئة السبب لم يُحدَّد بعد فقيمة الرمز مثال.

- TAG 1 + Edge Id 2 + الحقل 2 + قيمة الرمز 1 = 6 WORD، و`LLLL = 0101`.

```
0BD5 0051 000A 0051 0004 0001
```

يضع مستند مواصفة TRIPLE ثلاثة ENUM (`0` و`1` و`2`) في حقل Rank (FIELD #5) ويربطها بـ BIND بالأسماء `normal` و`preferred` و`deprecated` على التوالي ([TRIPLE](0x0AAL-triple.md)).

## صفحات ذات صلة {#관련-페이지}

- [DECLARE](0x0BBL-declare.md)، [FIELD](0x0BCL-field.md)، [CODEC](0x0BEL-codec.md)، [BIND](0x0A3L-bind.md)
- [مستند مواصفة Codec](../codec-spec.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000BD0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BD000000000
BODY
#1 DECLARE 0x0BD0
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "ENUM"
#5 BIND #2 "field"
#6 BIND #3 "code"
#7 CODEC #2 0x0050
```
