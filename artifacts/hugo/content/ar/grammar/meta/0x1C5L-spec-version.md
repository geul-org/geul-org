---
title: "SPEC-VERSION (0x1C5L)"
weight: 453
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "يعلن إصدار مواصفة GEUL الذي يتبعه المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `SPEC-VERSION` (BIND مستند المواصفة `SPEC-VERSION`) |
| TAG ID | `0x1C5L` |
| Codec ID | `0x00001C50` |
| مستند المواصفة | `0x00000000/codecs/0x00001C50/` (هدف DECLARE `1C50`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 5 |
| Kind | Meta · الفئة: التعريف |
| TAG WORD | `0001 1100 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | إصدار مواصفة GEUL المتبَع. Payload هو نفسه عدد صحيح unsigned بأقصر عرض. v1 هو `0x0001` (السجل `0x1C51 0x0001`) |
| جهة Hugo | `meta/declaration/spec-version.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | قيمة خام للباقي (`0xFFFF`) |  |  |

يعلن إصدار مواصفة GEUL الذي يتبعه المستند. وتحدد هذه القيمة كيف تُقرأ بقية السجلات.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1100 0101 LLLL      Codec 0x1C5L
[Length TAG ممتد]
Payload           إصدار المواصفة. v1 = 0x0001
```

- Codec: Meta `0x1C5L`، فئة التعريف
- Payload: قيمة خام (عدد صحيح unsigned بأقصر عرض)
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- لا يعتمد على رموز Value. يوضع عدد صحيح فقط دون Value مضمَّن ليقرأه مفكك أي إصدار.
- إذا كان الإصدار غير معروف فإن المفكك يرفض أو يحذّر.
- إذا غاب قرأه المفكك بالإصدار الذي يعرفه. والمستند المنشور يكتبه.

## مثال {#예시}

- `0x1C51 0x0001`: GEUL v1

## مسائل مفتوحة {#열린-문제}

- التقابل مع إصدار مستند codebook ([مستند المواصفة](../codec-spec.md)).

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001C50/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C5000000000
BODY
#1 DECLARE 0x1C50
#2 FIELD #1 rest
#3 BIND #1 "SPEC-VERSION"
#4 BIND #2 "version"
```
