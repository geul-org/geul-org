---
title: "PARENT (0x1D1L)"
weight: 465
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "يكتب تجزئة محتوى الإصدار السابق مباشرة (git parent)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `PARENT` (BIND مستند المواصفة `PARENT`) |
| TAG ID | `0x1D1L` |
| Codec ID | `0x00001D10` |
| مستند المواصفة | `0x00000000/codecs/0x00001D10/` (هدف DECLARE `1D10`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 17 |
| Kind | Meta · الفئة: النسب |
| TAG WORD | `0001 1101 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | تجزئة محتوى الإصدار السابق مباشرة (git parent). وإذا غاب فهو الإصدار الأول، وإذا تعدد فهو دمج (git merge commit). |
| جهة Hugo | `meta/lineage/parent.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | سجل | `07C0` SHA-256-DIGEST |  |

يكتب تجزئة محتوى الإصدار السابق مباشرة (git parent).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 0001 LLLL      Codec 0x1D1L
[Length TAG ممتد]
Payload           قيمة SHA-256-DIGEST واحدة (16 WORD)
```

- Codec: Meta `0x1D1L`، فئة النسب
- Payload: Value مضمّنة ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- العدد: يجوز تعدده (دمج)

## التفسير والصلاحية {#해석과-유효성}

- إذا غاب فهو الإصدار الأول، وإذا تعدد فهو دمج (git merge commit).
- يدخل في [تجزئة المحتوى](../document.md#내용-해시) فيصير التاريخ كله سلسلة تجزئات.
- يشير مستند قائمة الإصدارات إلى مستند القائمة السابق ([PUBLICATION](../edge/0x0B8L-publication.md)).
- تُضمَّن صيغة الـ digest في Value لإبقاء المجال مفتوحاً لتغيير خوارزمية التجزئة. وتجزئة المحتوى الآن SHA-256 فقط.

## مثال {#예시}

- `0x1D1E 0x0014 0x07CE 0x0012 <16 WORD>` (Meta بطول 20 WORD = TAG + Length ممتد + Value مضمّنة 18 WORD)

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001D10/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D1000000000
BODY
#1 DECLARE 0x1D10
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "PARENT"
#4 BIND #2 "digest"
```
