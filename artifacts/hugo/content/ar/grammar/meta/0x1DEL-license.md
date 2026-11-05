---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "يكتب ترخيص هذا المستند والمصنفات داخل سلسلة البايتات."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `LICENSE` (BIND مستند المواصفة `LICENSE`) |
| TAG ID | `0x1DEL` |
| Codec ID | `0x00001DE0` |
| مستند المواصفة | `0x00000000/codecs/0x00001DE0/` (هدف DECLARE `1DE0`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 30 |
| Kind | Meta · الفئة: السياسة |
| TAG WORD | `0001 1101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | الترخيص. Reference |
| جهة Hugo | `meta/policy/license.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | سجل | `000F` القسم 0 كله (حرف بدل، Reference)، `020F` القسم 1 كله (حرف بدل، Reference)، `040F` القسم 2 كله (حرف بدل، Reference)، `0720` UTF8-TEXT-EVEN، `0730` UTF8-TEXT-ODD، `0740` URI-EVEN، `0750` URI-ODD |  |

يكتب ترخيص هذا المستند والمصنفات داخل سلسلة البايتات.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[Length TAG ممتد]
Payload           Reference يشير إلى الترخيص، أو UTF8-TEXT لمعرّف SPDX، أو قيمة URI
```

- Codec: Meta `0x1DEL`، فئة السياسة
- Payload: Reference أو Value مضمّنة ([UTF8-TEXT](../value/0x072L-utf8-text.md) و[URI](../value/0x074L-uri.md))
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- مستندات geul.org المنشورة هي CC0. أما النشر الخاص فيحدده Issuer ([Issuer](../issuer.md)).
- يُسجَّل الترخيص الأصلي للمصنف المصدري.

## مسائل مفتوحة {#열린-문제}

- هل يوضع معرّف SPDX نصاً أم Reference إلى كيان GEUL.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001DE0/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
