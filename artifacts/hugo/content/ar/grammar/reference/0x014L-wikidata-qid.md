---
title: "WIKIDATA-QID (0x014L~0x018L)"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID هو Reference تصريحي يشير إلى عنصر (Item) في ويكي بيانات."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `WIKIDATA-QID` (حزمة 5Q. اسم كل رمز في جدول الأعضاء أدناه) |
| TAG ID | `0x014L~0x018L` |
| القسم | 0 `0000` (كيان Reference)، الإزاحة داخل القسم C = 20~24 |
| Kind | Reference · التصنيف: تصريح |
| جهة Hugo | `reference/wikidata-qid.md` |

## الأعضاء {#구성원}

تتناول هذه الصفحة منظومة 5Q واحدة، أي خمسة رموز معًا. التكميم هو الإزاحة داخل القسم `C % 5` ([Reference](_index.md#quantifier)). لكل رمز مستند Codec واحد. حقول مستندات Codec الخمسة واحدة، ويختلف فقط هدف DECLARE والاسم (BIND).

| TAG ID | الاسم | التكميم | Codec ID | مستند المواصفة | TAG WORD |
|---|---|---|---|---|---|
| `0x014L` | `WIKIDATA-QID-IDENTIFIED` | Identified | `0x00000140` | `0x00000000/codecs/0x00000140/` | `0000 0001 0100 LLLL` |
| `0x015L` | `WIKIDATA-QID-GENERIC` | Generic | `0x00000150` | `0x00000000/codecs/0x00000150/` | `0000 0001 0101 LLLL` |
| `0x016L` | `WIKIDATA-QID-FREE-CHOICE` | Free-choice | `0x00000160` | `0x00000000/codecs/0x00000160/` | `0000 0001 0110 LLLL` |
| `0x017L` | `WIKIDATA-QID-UNIVERSAL` | Universal | `0x00000170` | `0x00000000/codecs/0x00000170/` | `0000 0001 0111 LLLL` |
| `0x018L` | `WIKIDATA-QID-VARIABLE` | Variable | `0x00000180` | `0x00000000/codecs/0x00000180/` | `0000 0001 1000 LLLL` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `qid` | #2 | قيمة خام متبقية (`0xFFFF`) |  |  |

WIKIDATA-QID هو Reference تصريحي يشير إلى عنصر (Item) في ويكي بيانات. يُكتب الجزء الرقمي من معرّف Q بعد حذف `Q` عددًا صحيحًا بلا إشارة.

## التخطيط {#레이아웃}

```
TAG WORD          0000 0001 0100 LLLL      Codec 0x014L~0x018L (Identified 0x014L)
[TAG الامتداد Length]
QID               unsigned big-endian بأقصر عرض
```

- يُكتب QID بأقصر عرض. من `Q1` إلى `Q65535` الإجمالي 2 WORD، وما فوقها 3 WORD.
- بيانات ويكي بيانات بترخيص CC0.
- في حالة Variable يكون متغيرًا مجهولًا من النوع الذي يشير إليه ذلك العنصر (Variable في [Reference](_index.md)).

## مثال {#예시}

| العنصر | WORD sequence |
|---|---|
| `Q5` (human) | `0141 0005` |
| `Q76` (Barack Obama) | `0141 004C` |
| `Q884` (South Korea) | `0141 0374` |
| `Q317521` (Elon Musk) | `0142 0004 D851` |
| `Q30461` (president), Variable | `0181 76FD` |

## صفحات ذات صلة {#관련-페이지}

- [Reference](_index.md)، [WIKIDATA-PID](0x019L-wikidata-pid.md)، [TRIPLE](../edge/0x0AAL-triple.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000140/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000014000000000
BODY
#1 DECLARE 0x0140
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-QID-IDENTIFIED"
#4 BIND #2 "qid"
```

ما سبق هو مستند Codec لـ`WIKIDATA-QID-IDENTIFIED` (`0x014L`). أما مستندات Codec للأعضاء الآخرين (`WIKIDATA-QID-GENERIC` و`WIKIDATA-QID-FREE-CHOICE` و`WIKIDATA-QID-UNIVERSAL` و`WIKIDATA-QID-VARIABLE`) فيختلف فيها فقط Codec ID في DOC-ID وهدف DECLARE والاسم المربوط (BIND) في `#1`.
