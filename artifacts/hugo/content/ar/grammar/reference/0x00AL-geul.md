---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL هو Reference تصريحي يشير إلى كيان يصدره geul.org بترخيص CC0."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `GEUL` (حزمة 5Q. اسم كل رمز في جدول الأعضاء أدناه) |
| TAG ID | `0x00AL~0x00EL` |
| القسم | 0 `0000` (كيان Reference)، الإزاحة داخل القسم C = 10~14 |
| Kind | Reference · التصنيف: تصريح |
| جهة Hugo | `reference/geul.md` |

## الأعضاء {#구성원}

تتناول هذه الصفحة منظومة 5Q واحدة، أي خمسة رموز معًا. التكميم هو الإزاحة داخل القسم `C % 5` ([Reference](_index.md#quantifier)). لكل رمز مستند Codec واحد. حقول مستندات Codec الخمسة واحدة، ويختلف فقط هدف DECLARE والاسم (BIND).

| TAG ID | الاسم | التكميم | Codec ID | مستند المواصفة | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | قيمة خام متبقية (`0xFFFF`) |  |  |

GEUL هو Reference تصريحي يشير إلى كيان يصدره geul.org بترخيص CC0. هو معرّف تسلسلي لا يحمل الرقم فيه معنى. أما المعرّف الذي تحمل بتاته معنى فتتولاه Codec مستقلة هي [GEUL-SIDX](0x00FL-geul-sidx.md) (`0x00FL~0x013L`).

## التخطيط {#레이아웃}

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[TAG الامتداد Length]
GEUL ID           unsigned big-endian بأقصر عرض
```

- تُخصَّص الأرقام الصغيرة للكيانات الأكثر تواترًا. المعرّف الذي يتسع في WORD واحد إجماليه 2 WORD.
- يدير geul.org تخصيص المعرّفات والسجل. ولا يدخل السجل إلا ما جاء من مصادر CC0.
- في حالة Variable يكون متغيرًا مجهولًا من ذلك النوع (Variable في [Reference](_index.md)).

## مثال {#예시}

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## مسائل مفتوحة {#열린-문제}

- قاعدة تخصيص GEUL ID وصيغة نشر السجل.

## صفحات ذات صلة {#관련-페이지}

- [Reference](_index.md)، [GEUL-SIDX](0x00FL-geul-sidx.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x000000A0/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

ما سبق هو مستند Codec لـ`GEUL-IDENTIFIED` (`0x00AL`). أما مستندات Codec للأعضاء الآخرين (`GEUL-GENERIC` و`GEUL-FREE-CHOICE` و`GEUL-UNIVERSAL` و`GEUL-VARIABLE`) فيختلف فيها فقط Codec ID في DOC-ID وهدف DECLARE والاسم المربوط (BIND) في `#1`.
