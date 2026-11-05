---
title: "PROFILE (0x1C6L)"
weight: 454
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "يعلن الـ profile المطبَّق على المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `PROFILE` (BIND مستند المواصفة `PROFILE`) |
| TAG ID | `0x1C6L` |
| Codec ID | `0x00001C60` |
| مستند المواصفة | `0x00000000/codecs/0x00001C60/` (هدف DECLARE `1C60`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 6 |
| Kind | Meta · الفئة: التعريف |
| TAG WORD | `0001 1100 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | الـ profile المطبَّق |
| جهة Hugo | `meta/declaration/profile.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `profile` | #2 | سجل | `0720` UTF8-TEXT-EVEN، `0730` UTF8-TEXT-ODD |  |

يعلن الـ profile المطبَّق على المستند. وتُفسَّر السجلات نفسها بمستندات Codec التي حددها الـ profile (مثلاً: إذا كان `tangeul-1.0` فهو [TOULMIN](../toulmin/_index.md)).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1100 0110 LLLL      Codec 0x1C6L
[Length TAG ممتد]
Payload           قيمة UTF8-TEXT "<الاسم>-<major>.<minor>"
```

- Codec: Meta `0x1C6L`، فئة التعريف
- Payload: Value مضمّنة ([UTF8-TEXT](../value/0x072L-utf8-text.md))
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- يُرفض profile مختلف في major. ويُسمح بالاختلاف في minor (تغييرات بالإضافة فقط).
- إذا غاب الـ profile فيُقرأ بنحو GEUL الأساسي ومواصفات الرمز المباشر فقط.

## مثال {#예시}

- `tangeul-1.0`: `0x1C67 0x0736 7461 6E67 6575 6C2D 312E 3000`

## مسائل مفتوحة {#열린-문제}

- سجل أسماء profile (geul.org) وقواعد التسمية.
- هل يُشار إلى الـ profile بمعرّف مستند (IMPORT) أم يوضع نصاً.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001C60/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C6000000000
BODY
#1 DECLARE 0x1C60
#2 FIELD #1 record
#3 BIND #1 "PROFILE"
#4 BIND #2 "profile"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
```
