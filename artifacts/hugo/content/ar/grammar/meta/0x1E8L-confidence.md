---
title: "CONFIDENCE (0x1E8L)"
weight: 488
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "يكتب موثوقية المستند كله."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `CONFIDENCE` (BIND مستند المواصفة `CONFIDENCE`) |
| TAG ID | `0x1E8L` |
| Codec ID | `0x00001E80` |
| مستند المواصفة | `0x00000000/codecs/0x00001E80/` (هدف DECLARE `1E80`) |
| القسم | 15 `1111` (Meta)، الإزاحة داخل القسم C = 8 |
| Kind | Meta · الفئة: التحقق |
| TAG WORD | `0001 1110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | الموثوقية |
| جهة Hugo | `meta/verification/confidence.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `confidence` | #2 | سجل | `0690` UNSIGNED-DECIMAL |  |

يكتب موثوقية المستند كله. أما الموثوقية على مستوى السجل فتُكتب بـ QUALIFIER يُلحق بـ Edge الهدف (الخاصية لم تُحدد بعد، [SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1110 1000 LLLL      Codec 0x1E8L
[Length TAG ممتد]
Payload           قيمة UNSIGNED-DECIMAL، من 0 إلى 1
```

- Codec: Meta `0x1E8L`، فئة التحقق
- Payload: Value مضمّنة ([UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md))
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- من الذي قدّر القيمة يُكتب معها بـ [GENERATED-BY](0x1D3L-generated-by.md) وغيره.

## مسائل مفتوحة {#열린-문제}

- المقياس (0 إلى 1) وعلاقته بحكم TOULMIN.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001E80/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E8000000000
BODY
#1 DECLARE 0x1E80
#2 FIELD #1 record
#5 CODEC #2 0x0690
#3 BIND #1 "CONFIDENCE"
#4 BIND #2 "confidence"
```
