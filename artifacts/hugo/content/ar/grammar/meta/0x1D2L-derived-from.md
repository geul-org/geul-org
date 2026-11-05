---
title: "DERIVED-FROM (0x1D2L)"
weight: 466
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "يكتب أن هذا المستند مشتق من مستند أو مادة في نسب آخر."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `DERIVED-FROM` (BIND مستند المواصفة `DERIVED-FROM`) |
| TAG ID | `0x1D2L` |
| Codec ID | `0x00001D20` |
| مستند المواصفة | `0x00000000/codecs/0x00001D20/` (هدف DECLARE `1D20`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 18 |
| Kind | Meta · الفئة: النسب |
| TAG WORD | `0001 1101 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | مشتق من سجل أو مادة في نسب آخر. وللتثبيت على إصدار معين من مادة خارجية يُلحق بـ [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) في HEAD تجزئةُ النص الأصلي بـ QUALIFIER (P4092) (git submodule). |
| جهة Hugo | `meta/lineage/derived-from.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `source` | #2 | سجل | `000F` القسم 0 كله (حرف بدل، Reference)، `020F` القسم 1 كله (حرف بدل، Reference)، `040F` القسم 2 كله (حرف بدل، Reference)، `07C0` SHA-256-DIGEST، `0740` URI-EVEN، `0750` URI-ODD |  |

يكتب أن هذا المستند مشتق من مستند أو مادة في نسب آخر.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 0010 LLLL      Codec 0x1D2L
[Length TAG ممتد]
Payload           Reference، أو SHA-256-DIGEST (تجزئة المحتوى)، أو قيمة URI
```

- Codec: Meta `0x1D2L`، فئة النسب
- Payload: Reference أو Value مضمّنة
- العدد: يجوز تعدده

## التفسير والصلاحية {#해석과-유효성}

- إذا كان الاشتقاق من مستند GEUL وُضعت تجزئة محتواه ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))، وإذا كان من مادة خارجية وُضع [URI](../value/0x074L-uri.md). ولتثبيت نسخة المادة الخارجية بالتجزئة يُلحق بـ [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) في HEAD تجزئةُ النص الأصلي بـ QUALIFIER (P4092).
- المصدر على مستوى السجل يتولاه Edge الدليل [SOURCE](../edge/0x0C0L-source.md)، أما السجل القديم قبل النقل والتقسيم والدمج فيتولاه QUALIFIER P1365 في Edge الهدف (وقيمته Edge Id القديم).

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001D20/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D2000000000
BODY
#1 DECLARE 0x1D20
#2 FIELD #1 record
#3 BIND #1 "DERIVED-FROM"
#4 BIND #2 "source"
#5 CODEC #2 0x000F
#9 CODEC #2 0x020F
#10 CODEC #2 0x040F
#6 CODEC #2 0x07C0
#7 CODEC #2 0x0740
#8 CODEC #2 0x0750
```
