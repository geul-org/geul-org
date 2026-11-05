---
title: "AUTHOR (0x1CBL)"
weight: 459
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "يسجّل الجهة التي كتبت محتوى المستند (git author)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `AUTHOR` (BIND مستند المواصفة `AUTHOR`) |
| TAG ID | `0x1CBL` |
| Codec ID | `0x00001CB0` |
| مستند المواصفة | `0x00000000/codecs/0x00001CB0/` (هدف DECLARE `1CB0`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 11 |
| Kind | Meta · الفئة: المصدر |
| TAG WORD | `0001 1100 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | المؤلف. Reference (git author) |
| جهة Hugo | `meta/provenance/author.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | سجل | أي سجل (باستثناء علامة الموضع) |  |

يسجّل الجهة التي كتبت محتوى المستند (git author).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1100 1011 LLLL      Codec 0x1CBL
[Length TAG ممتد]
Payload           سجل Reference واحد (EXTERNAL-ISSUER-*، GEUL، WIKIDATA-QID، LOCAL وغيرها)
```

- Codec: Meta `0x1CBL`، فئة المصدر
- Payload: Reference مضمّن
- العدد: واحد على الأكثر

## التفسير والصلاحية {#해석과-유효성}

- لا يُشترط في Reference نوع Codec معيّن. فقد يكون إنساناً أو منظمة أو نموذجاً أو محرك قواعد ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md) و[GEUL](../reference/0x00AL-geul.md) و[WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) و[LOCAL](../reference/0x005L-local.md) وغيرها).
- لا تُوضع في مستندات geul.org المنشورة Reference تشير إلى شخص طبيعي ([Issuer والنشر](../issuer.md#geulorg-공표)). بل تشير إلى منظمة أو Issuer. واستثناءً يُسمح بالإشارة إلى شخص طبيعي بـ [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).
- إذا كان LOCAL فيُوصف ذلك الهدف في BODY.

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001CB0/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CB000000000
BODY
#1 DECLARE 0x1CB0
#2 FIELD #1 record
#3 BIND #1 "AUTHOR"
#4 BIND #2 "actor"
```
