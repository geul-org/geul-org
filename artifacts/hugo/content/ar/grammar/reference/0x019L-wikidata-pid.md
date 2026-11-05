---
title: "WIKIDATA-PID (0x019L~0x01DL)"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID هو Reference تصريحي يشير إلى خاصية (Property) في ويكي بيانات."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `WIKIDATA-PID` (حزمة 5Q. اسم كل رمز في جدول الأعضاء أدناه) |
| TAG ID | `0x019L~0x01DL` |
| القسم | 0 `0000` (كيان Reference)، الإزاحة داخل القسم C = 25~29 |
| Kind | Reference · التصنيف: تصريح |
| جهة Hugo | `reference/wikidata-pid.md` |

## الأعضاء {#구성원}

تتناول هذه الصفحة منظومة 5Q واحدة، أي خمسة رموز معًا. التكميم هو الإزاحة داخل القسم `C % 5` ([Reference](_index.md#quantifier)). لكل رمز مستند Codec واحد. حقول مستندات Codec الخمسة واحدة، ويختلف فقط هدف DECLARE والاسم (BIND).

| TAG ID | الاسم | التكميم | Codec ID | مستند المواصفة | TAG WORD |
|---|---|---|---|---|---|
| `0x019L` | `WIKIDATA-PID-IDENTIFIED` | Identified | `0x00000190` | `0x00000000/codecs/0x00000190/` | `0000 0001 1001 LLLL` |
| `0x01AL` | `WIKIDATA-PID-GENERIC` | Generic | `0x000001A0` | `0x00000000/codecs/0x000001A0/` | `0000 0001 1010 LLLL` |
| `0x01BL` | `WIKIDATA-PID-FREE-CHOICE` | Free-choice | `0x000001B0` | `0x00000000/codecs/0x000001B0/` | `0000 0001 1011 LLLL` |
| `0x01CL` | `WIKIDATA-PID-UNIVERSAL` | Universal | `0x000001C0` | `0x00000000/codecs/0x000001C0/` | `0000 0001 1100 LLLL` |
| `0x01DL` | `WIKIDATA-PID-VARIABLE` | Variable | `0x000001D0` | `0x00000000/codecs/0x000001D0/` | `0000 0001 1101 LLLL` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `pid` | #2 | قيمة خام متبقية (`0xFFFF`) |  |  |

WIKIDATA-PID هو Reference تصريحي يشير إلى خاصية (Property) في ويكي بيانات. يُكتب الجزء الرقمي من معرّف P بعد حذف `P` عددًا صحيحًا بلا إشارة.

## التخطيط {#레이아웃}

```
TAG WORD          0000 0001 1001 LLLL      Codec 0x019L~0x01DL (Identified 0x019L)
[TAG الامتداد Length]
PID               unsigned big-endian بأقصر عرض
```

- يُكتب PID بأقصر عرض. أرقام الخصائص الحالية تتسع في WORD واحد فالإجمالي 2 WORD، وإذا تجاوزت 65535 يزداد العرض إلى 3 WORD تلقائيًا.
- يُستخدم أساسًا في موضع Predicate في [TRIPLE](../edge/0x0AAL-triple.md) وموضع Property في [QUALIFIER](../edge/0x0ABL-qualifier.md).

## مثال {#예시}

| الخاصية | WORD sequence |
|---|---|
| `P31` (instance of) | `0191 001F` |
| `P279` (subclass of) | `0191 0117` |
| `P569` (date of birth) | `0191 0239` |

## صفحات ذات صلة {#관련-페이지}

- [Reference](_index.md)، [WIKIDATA-QID](0x014L-wikidata-qid.md)، [TRIPLE](../edge/0x0AAL-triple.md)، [QUALIFIER](../edge/0x0ABL-qualifier.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000190/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000019000000000
BODY
#1 DECLARE 0x0190
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-PID-IDENTIFIED"
#4 BIND #2 "pid"
```

ما سبق هو مستند Codec لـ`WIKIDATA-PID-IDENTIFIED` (`0x019L`). أما مستندات Codec للأعضاء الآخرين (`WIKIDATA-PID-GENERIC` و`WIKIDATA-PID-FREE-CHOICE` و`WIKIDATA-PID-UNIVERSAL` و`WIKIDATA-PID-VARIABLE`) فيختلف فيها فقط Codec ID في DOC-ID وهدف DECLARE والاسم المربوط (BIND) في `#1`.
