---
title: "GEUL-SIDX (0x00FL~0x013L)"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX هو Reference تصريحي يشير إلى الهدف بـGEUL SIDX (Semantic-aligned Index)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `GEUL-SIDX` (حزمة 5Q. اسم كل رمز في جدول الأعضاء أدناه) |
| TAG ID | `0x00FL~0x013L` |
| القسم | 0 `0000` (كيان Reference)، الإزاحة داخل القسم C = 15~19 |
| Kind | Reference · التصنيف: تصريح |
| جهة Hugo | `reference/geul-sidx.md` |

## الأعضاء {#구성원}

تتناول هذه الصفحة منظومة 5Q واحدة، أي خمسة رموز معًا. التكميم هو الإزاحة داخل القسم `C % 5` ([Reference](_index.md#quantifier)). لكل رمز مستند Codec واحد. حقول مستندات Codec الخمسة واحدة، ويختلف فقط هدف DECLARE والاسم (BIND).

| TAG ID | الاسم | التكميم | Codec ID | مستند المواصفة | TAG WORD |
|---|---|---|---|---|---|
| `0x00FL` | `GEUL-SIDX-IDENTIFIED` | Identified | `0x000000F0` | `0x00000000/codecs/0x000000F0/` | `0000 0000 1111 LLLL` |
| `0x010L` | `GEUL-SIDX-GENERIC` | Generic | `0x00000100` | `0x00000000/codecs/0x00000100/` | `0000 0001 0000 LLLL` |
| `0x011L` | `GEUL-SIDX-FREE-CHOICE` | Free-choice | `0x00000110` | `0x00000000/codecs/0x00000110/` | `0000 0001 0001 LLLL` |
| `0x012L` | `GEUL-SIDX-UNIVERSAL` | Universal | `0x00000120` | `0x00000000/codecs/0x00000120/` | `0000 0001 0010 LLLL` |
| `0x013L` | `GEUL-SIDX-VARIABLE` | Variable | `0x00000130` | `0x00000000/codecs/0x00000130/` | `0000 0001 0011 LLLL` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `sidx` | #2 | قيمة خام متبقية (`0xFFFF`) |  |  |

GEUL-SIDX هو Reference تصريحي يشير إلى الهدف بـGEUL SIDX (Semantic-aligned Index). SIDX معرّف تحمل بتاته نفسها المعنى (النوع والخاصية).

## التخطيط {#레이아웃}

```
TAG WORD          0000 0000 1111 LLLL      Codec 0x00FL~0x013L (Identified 0x00FL)
[TAG الامتداد Length]
SIDX              كل ما تبقى
```

- Quantifier كما في سائر Codec التصريح. في حالة Variable يكون متغيرًا مجهولًا من ذلك النوع (Variable في [Reference](_index.md)). يكون التكميم برموز 5Q وحدها (`0x00FL~0x013L`, `C % 5`). ولا يوضع تكميم في قيمة SIDX.
- يصرّح مستند المواصفة بـSIDX حقل قيمة خام واحدًا بعرض المتبقي. سيتغير ذلك متى تحددت قاعدة العرض.

## مثال {#예시}

| SIDX | WORD sequence |
|---|---|
| (غير معياري) 64 بتًا `0x1234 5678 9ABC DEF0`, Identified | `00F4 1234 5678 9ABC DEF0` |

## سياسة التخصيص {#배정-방침}

- يختلف دوره عن [GEUL](0x00AL-geul.md). GEUL معرّف هوية يُخصَّص غالبًا بالترتيب (auto increment)، أما GEUL-SIDX فعنوان دلالي تُعطى فيه الأهداف المتقاربة معنًى قيمًا متقاربة.
- تُحدَّد درجة التقارب إحصائيًا بتراكم بيانات الاستخدام. وقبل اجتماع الإحصاءات يُستخدم GEUL ID، وبعد تخصيص SIDX يُوصل GEUL وGEUL-SIDX للهدف نفسه بـ[SAME-NODE](../edge/0x0A1L-same-node.md).

## مسائل مفتوحة {#열린-문제}

- **العرض.** يُحدَّد بعد النظر في الإحصاءات. يُنظر في 4 WORD (64 بتًا) و16 WORD وغيرهما. للبتات العليا في SIDX معنى، فلا تصلح قاعدة «أقصر عرض» (منع WORD `0x0000` في البداية) المطبقة في Codec التصريح الأخرى. لذلك سيكون عرضًا ثابتًا (أو عرضًا ثابتًا لكل صيغة فرعية). وإلى أن يتحدد يصرّح مستند المواصفة بـSIDX قيمةً خامًا بعرض المتبقي.
- **استقرار التخصيص.** في Reference يكون الهدف واحدًا إذا تساوت القيمة الصحيحة، ولا يُعاد استخدام معرّف خُصِّص. ولكي لا يُنقل SIDX خُصِّص من قبل إذا تغيرت الإحصاءات لا بد من تخصيص append-only (تخصيص متناثر يترك أماكن قريبة المعنى). وإذا كثر النقل يُقرَّر هل يُعرَّف SIDX فهرسًا مرتبطًا بنسخة السجل لا معرّفًا دائمًا.
- **التفرّد.** إذا وُلِّد SIDX بمعنى البتات وقد يحدث تصادم فلن يتفق ذلك مع فرضية «القيمة الصحيحة نفسها هي الهدف نفسه». يُحَلّ التصادم عند التخصيص لضمان التفرّد.
- الكتاب الرمزي (codebook) وصيغة نشر السجل.

## صفحات ذات صلة {#관련-페이지}

- [Reference](_index.md)، [GEUL](0x00AL-geul.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x000000F0/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000F000000000
BODY
#1 DECLARE 0x00F0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-SIDX-IDENTIFIED"
#4 BIND #2 "sidx"
```

ما سبق هو مستند Codec لـ`GEUL-SIDX-IDENTIFIED` (`0x00FL`). أما مستندات Codec للأعضاء الآخرين (`GEUL-SIDX-GENERIC` و`GEUL-SIDX-FREE-CHOICE` و`GEUL-SIDX-UNIVERSAL` و`GEUL-SIDX-VARIABLE`) فيختلف فيها فقط Codec ID في DOC-ID وهدف DECLARE والاسم المربوط (BIND) في `#1`.
