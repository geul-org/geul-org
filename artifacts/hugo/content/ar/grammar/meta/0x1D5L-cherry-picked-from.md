---
title: "CHERRY-PICKED-FROM (0x1D5L)"
weight: 469
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "يكتب تجزئة محتوى الإصدار الأصلي الذي أُخذ منه تغيير من نسب آخر (git cherry-pick -x)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `CHERRY-PICKED-FROM` (BIND مستند المواصفة `CHERRY-PICKED-FROM`) |
| TAG ID | `0x1D5L` |
| Codec ID | `0x00001D50` |
| مستند المواصفة | `0x00000000/codecs/0x00001D50/` (هدف DECLARE `1D50`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 21 |
| Kind | Meta · الفئة: النسب |
| TAG WORD | `0001 1101 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | تجزئة محتوى الإصدار الأصلي الذي أُخذ منه تغيير من نسب آخر (git cherry-pick `-x`) |
| جهة Hugo | `meta/lineage/cherry-picked-from.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | سجل | `07C0` SHA-256-DIGEST |  |

يكتب تجزئة محتوى الإصدار الأصلي الذي أُخذ منه تغيير من نسب آخر (git cherry-pick `-x`).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 0101 LLLL      Codec 0x1D5L
[Length TAG ممتد]
Payload           قيمة SHA-256-DIGEST واحدة (16 WORD)
```

- Codec: Meta `0x1D5L`، فئة النسب
- Payload: Value مضمّنة ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- العدد: يجوز تعدده

## التفسير والصلاحية {#해석과-유효성}

- تُضمَّن صيغة الـ digest في Value لإبقاء المجال مفتوحاً لتغيير خوارزمية التجزئة. وتجزئة المحتوى الآن SHA-256 فقط.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001D50/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D5000000000
BODY
#1 DECLARE 0x1D50
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "CHERRY-PICKED-FROM"
#4 BIND #2 "digest"
```
