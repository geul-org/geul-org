---
title: "REVERTS (0x1D6L)"
weight: 470
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "يكتب تجزئة محتوى الإصدار الهدف الذي جرى التراجع عن تغييره (git revert)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `REVERTS` (BIND مستند المواصفة `REVERTS`) |
| TAG ID | `0x1D6L` |
| Codec ID | `0x00001D60` |
| مستند المواصفة | `0x00000000/codecs/0x00001D60/` (هدف DECLARE `1D60`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 22 |
| Kind | Meta · الفئة: النسب |
| TAG WORD | `0001 1101 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | تجزئة محتوى الإصدار الهدف الذي جرى التراجع عن تغييره (git revert) |
| جهة Hugo | `meta/lineage/reverts.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | سجل | `07C0` SHA-256-DIGEST |  |

يكتب تجزئة محتوى الإصدار الهدف الذي جرى التراجع عن تغييره (git revert).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 0110 LLLL      Codec 0x1D6L
[Length TAG ممتد]
Payload           قيمة SHA-256-DIGEST واحدة (16 WORD)
```

- Codec: Meta `0x1D6L`، فئة النسب
- Payload: Value مضمّنة ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- العدد: يجوز تعدده

## التفسير والصلاحية {#해석과-유효성}

- تُضمَّن صيغة الـ digest في Value لإبقاء المجال مفتوحاً لتغيير خوارزمية التجزئة. وتجزئة المحتوى الآن SHA-256 فقط.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001D60/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D6000000000
BODY
#1 DECLARE 0x1D60
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "REVERTS"
#4 BIND #2 "digest"
```
