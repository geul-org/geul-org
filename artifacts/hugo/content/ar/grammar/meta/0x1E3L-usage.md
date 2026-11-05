---
title: "USAGE (0x1E3L)"
weight: 483
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "يكتب قيود الاستخدام مثل منع التدريب ومنع الاستخدام التجاري."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `USAGE` (BIND مستند المواصفة `USAGE`) |
| TAG ID | `0x1E3L` |
| Codec ID | `0x00001E30` |
| مستند المواصفة | `0x00000000/codecs/0x00001E30/` (هدف DECLARE `1E30`) |
| القسم | 15 `1111` (Meta)، الإزاحة داخل القسم C = 3 |
| Kind | Meta · الفئة: السياسة |
| TAG WORD | `0001 1110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | قيود الاستخدام |
| جهة Hugo | `meta/policy/usage.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `usage` | #2 | سجل | `000F` القسم 0 كله (حرف بدل، Reference)، `020F` القسم 1 كله (حرف بدل، Reference)، `040F` القسم 2 كله (حرف بدل، Reference)، `0720` UTF8-TEXT-EVEN، `0730` UTF8-TEXT-ODD، `0780` UTF8-LANGUAGE-TEXT، `0790` UTF8-LANGUAGE-TEXT |  |

يكتب قيود الاستخدام (مثلاً: منع التدريب، ومنع الاستخدام التجاري).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1110 0011 LLLL      Codec 0x1E3L
[Length TAG ممتد]
Payload           نص أو Reference يدل على قيد الاستخدام
```

- Codec: Meta `0x1E3L`، فئة السياسة
- Payload: Reference أو Value مضمّنة
- العدد: يجوز تعدده

## مسائل مفتوحة {#열린-문제}

- جدول رموز أنواع القيود.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001E30/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E3000000000
BODY
#1 DECLARE 0x1E30
#2 FIELD #1 record
#3 BIND #1 "USAGE"
#4 BIND #2 "usage"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
