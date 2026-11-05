---
title: "UNSIGNED-DECIMAL (0x069L)"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL قيمة Value تمثل عدداً عشرياً دقيقاً (exact decimal) بمعامل coefficient بلا إشارة."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `UNSIGNED-DECIMAL` (مستند المواصفة BIND `UNSIGNED-DECIMAL`) |
| TAG ID | `0x069L` |
| Codec ID | `0x00000690` |
| مستند المواصفة | `0x00000000/codecs/0x00000690/` (هدف DECLARE هو `0690`) |
| القسم | 3 `0011` (Value)، الإزاحة داخل القسم C = 9 |
| Kind | Value · العائلة: DECIMAL |
| TAG WORD | `0000 0110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | `C×10^E` من signed exponent `E` وunsigned coefficient `C` بأقل عدد من WORD |
| جهة Hugo | `value/decimal/unsigned-decimal.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | قيمة خام 2 WORD |  |  |
| 2 | `coefficient` | #3 | القيمة الخام المتبقية (`0xFFFF`) |  |  |

UNSIGNED-DECIMAL قيمة Value تمثل عدداً عشرياً دقيقاً (exact decimal) بمعامل coefficient بلا إشارة. الرمز المباشر في Value هو `0x069L` والعائلة DECIMAL. أول WORD اثنتين من Payload هما exponent عشري `E` من نوع signed 32bit، والباقي unsigned coefficient `C` بأقل عدد من WORD، والقيمة هي `C×10^E`.

## التخطيط {#레이아웃}

```
TAG WORD          0000 0110 1001 LLLL      Codec 0x069L
[TAG ممتد لـ Length] عندما يبلغ المجموع 15 WORD أو أكثر
Payload WORD 1st–2nd (32 بت)         Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD فأكثر)  Unsigned Coefficient C
```

## التفسير {#해석}

- `E` عدد صحيح بمتمم الاثنين من نوع signed 32bit big-endian يُسجَّل بدءاً من WORD العليا.
- `C` هو unsigned magnitude بدقة اعتباطية تُقرأ فيه كل WORD المتبقية بدءاً من WORD العليا.
- يتبع `C` قاعدة أقل عدد من WORD نفسها في [UNSIGNED-INTEGER](0x062L-unsigned-integer.md). العدد 0 هو `0000`، وتُمنع WORD الأولى `0000` عند وجود WORD اثنتين أو أكثر.

## الطول والصلاحية {#길이와-유효성}

- المجموع هو عدد WORD في TAG (1 WORD) وTAG الممتد لـ Length (إن وُجد) وPayload معاً. يُستخدم الطول المباشر حتى 14 WORD، والطول الممتد `1110`·`1111` من 15 WORD فأكثر، وتُحسب TAG الممتدة ضمن المجموع ([السجل وTAG WORD](../record.md)).
- Payload هو exponent (2 WORD) وcoefficient (1 WORD فأكثر)، فحده الأدنى 3 WORD.
- لا يُفحص في قياسية تمثيل البايتات إلا تمثيل coefficient بأقل عدد من WORD.

## مثال {#예시}

| تمثيل القيمة | Payload (`E` + `C`) | الحكم |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | تمثيل البايتات قياسي |
| `10×10^-1` | `FFFF FFFF 000A` | تمثيل البايتات قياسي، والعلاقة القياسية (canonical) بالتمثيل أعلاه مسألة مفتوحة |
| `1×10^0` | `0000 0000 0000 0001` | غير قياسي: `0000` سابقة في coefficient لا حاجة إليها |
| coefficient سالب | لا ينطبق | invalid |

## مكانة الصيغة {#형식-지위}

- هذا التوزيع الذي يجمع exponent `E` من نوع signed 32 بت وunsigned coefficient `C` بأقل عدد من WORD هو صيغة خاصة بـ GEUL، وليس IEEE 754 decimal interchange ولا Apache Parquet `DECIMAL`.
- يستخدم Parquet `DECIMAL` قيمة unscaled ذات إشارة والصيغة `unscaledValue × 10^(-scale)` وmetadata إلزامية لـ precision/scale، والنوع الفيزيائي byte-array فيه بمتمم الاثنين big-endian وscale فيه 0 أو أكثر. وهذه الصيغة ليست الصيغة نفسها بسبب `C` بلا إشارة و`E` ذي الإشارة وغياب metadata لـ precision.
- التبادل مع IEEE 754 decimal أو Parquet `DECIMAL` يتطلب تحويلاً صريحاً يحدد الإشارة والمدى وprecision/scale وquantum وسياسة القيم الخاصة.
- مرجع المقارنة: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/)، [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## مسائل مفتوحة {#열린-문제}

- هناك عدة أزواج exponent/coefficient تمثل العدد نفسه، مثل `10×10^-1` و`1×10^0`.
- لم يُحدَّد بعد هل تحفظ هذه الصيغة quantum، وكيف يُحكم بتساوي القيم، وكيف يُطبَّع canonical exponent.
- لذلك يجب ألا تفرض التطبيقات تطبيعاً لـ exponent/coefficient خارج قاعدة أقل عدد من WORD لـ coefficient.

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يظهر عند قراءة مستند المواصفة `0x00000000/codecs/0x00000690/latest.geul` بالأمر `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000069000000000
BODY
#1 DECLARE 0x0690
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "UNSIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
