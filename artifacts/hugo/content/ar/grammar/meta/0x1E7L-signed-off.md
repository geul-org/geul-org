---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "إقرار بحق المساهمة (git Signed-off-by, DCO)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `SIGNED-OFF` (BIND مستند المواصفة `SIGNED-OFF`) |
| TAG ID | `0x1E7L` |
| Codec ID | `0x00001E70` |
| مستند المواصفة | `0x00000000/codecs/0x00001E70/` (هدف DECLARE `1E70`) |
| القسم | 15 `1111` (Meta)، الإزاحة داخل القسم C = 7 |
| Kind | Meta · الفئة: التحقق |
| TAG WORD | `0001 1110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | إقرار بحق المساهمة. Reference (git `Signed-off-by`, DCO) |
| جهة Hugo | `meta/verification/signed-off.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | سجل | أي سجل (باستثناء علامة الموضع) |  |

إقرار بحق المساهمة (git `Signed-off-by`, DCO).

## التخطيط {#레이아웃}

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[Length TAG ممتد]
Payload           Reference واحد
```

- Codec: Meta `0x1E7L`، فئة التحقق
- Payload: Reference مضمّن
- العدد: يجوز تعدده

## التفسير والصلاحية {#해석과-유효성}

- لا تُوضع في مستندات geul.org المنشورة Reference تشير إلى شخص طبيعي ([Issuer والنشر](../issuer.md#geulorg-공표)). بل تشير إلى منظمة أو Issuer. واستثناءً يُسمح بالإشارة إلى شخص طبيعي بـ [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001E70/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
