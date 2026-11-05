---
title: "BINARY-FLOAT (0x063L)"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT قيمة Value تمثل scalar بصيغة IEEE 754 binary interchange."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `BINARY-FLOAT` (مستند المواصفة BIND `BINARY-FLOAT`) |
| TAG ID | `0x063L` |
| Codec ID | `0x00000630` |
| مستند المواصفة | `0x00000000/codecs/0x00000630/` (هدف DECLARE هو `0630`) |
| القسم | 3 `0011` (Value)، الإزاحة داخل القسم C = 3 |
| Kind | Value · العائلة: NUMERIC |
| TAG WORD | `0000 0110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | scalar بصيغة IEEE 754 binary16/32/64/128 في Payload من 1/2/4/8 WORD |
| جهة Hugo | `value/numeric/binary-float.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ieee-binary` | #2 | القيمة الخام المتبقية (`0xFFFF`) |  |  |

BINARY-FLOAT قيمة Value تمثل IEEE 754 binary interchange scalar. الرمز المباشر في Value هو `0x063L` والعائلة NUMERIC. إذا كان Payload من 1/2/4/8 WORD فهو binary16/32/64/128 على التوالي. تُحفظ سلسلة بتات interchange كما هي، ولا يُسمح بأي حجم آخر لـ Payload.

## التخطيط {#레이아웃}

```
TAG WORD          0000 0110 0011 LLLL      Codec 0x063L
[TAG ممتد لـ Length] عندما يبلغ المجموع 15 WORD أو أكثر
Payload WORD 1st  (WORD العليا)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (WORD الدنيا)   IEEE Binary Interchange Nth
```

## التفسير {#해석}

- تُوصَل Payload WORD بترتيب big-endian وتُقرأ على أنها سلسلة بتات IEEE 754 binary interchange بالعرض المقابل.
- تُحفظ أنماط بتات interchange بما فيها NaN payload وsigned zero.
- لا يجوز للمفكّك استبدال NaN بأي NaN قياسي واحد، ولا محو إشارة signed zero.
- لا يحدد هذا الشكل التسلسلي طريقة التقريب ولا سلوك العمليات الحسابية.

## الطول {#길이}

المجموع هو عدد WORD في TAG (1 WORD) وTAG الممتد لـ Length (إن وُجد) وPayload معاً ([السجل وTAG WORD](../record.md)).

| الصيغة | Payload | رمز Length | TAG ممتد لـ Length | Length الكلي |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | لا يوجد | 2 WORD |
| binary32 | 2 WORD | `0010` | لا يوجد | 3 WORD |
| binary64 | 4 WORD | `0100` | لا يوجد | 5 WORD |
| binary128 | 8 WORD | `1000` | لا يوجد | 9 WORD |

binary128 أيضاً ضمن المدى المباشر من 1 إلى 14 WORD، فلا تُستخدم TAG ممتدة لـ Length.

## الصلاحية {#유효성}

- Payload هو بالضبط واحد من 1 أو 2 أو 4 أو 8 WORD.
- يجب أن يطابق كل حجم لـ Payload تمثيل Length في الجدول أعلاه تماماً.
- لا يُسمح بإعادة الترميز بتغيير العرض ولا بإضافة padding WORD قبل Payload أو بعده.

## مثال {#예시}

| الصيغة | TAG | TAG ممتد لـ Length | مثال Payload | الحكم |
|---|---|---|---|---|
| binary16 | `0631` | لا يوجد | `0000` | قياسي |
| binary32 | `0632` | لا يوجد | `0000 0000` | قياسي |
| binary64 | `0634` | لا يوجد | `0000 0000 0000 0000` | قياسي |
| binary128 | `0638` | لا يوجد | سلسلة بتات من 8 WORD | قياسي |
| أي صيغة | الحجم لا يطابق ما يدل عليه Length | أي | أي | invalid |

## الأساس المعياري {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): تُطبَّق ترميزات interchange لصيغ binary16 وbinary32 وbinary64 وbinary128. ولا تضيف GEUL إلى سلسلة البتات هذه سوى TAG وإطار WORD ذي 16 بت بترتيب big-endian.

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يظهر عند قراءة مستند المواصفة `0x00000000/codecs/0x00000630/latest.geul` بالأمر `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000063000000000
BODY
#1 DECLARE 0x0630
#2 FIELD #1 rest
#3 BIND #1 "BINARY-FLOAT"
#4 BIND #2 "ieee-binary"
```
