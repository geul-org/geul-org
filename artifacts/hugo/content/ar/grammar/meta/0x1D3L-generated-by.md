---
title: "GENERATED-BY (0x1D3L)"
weight: 467
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "يكتب الجهة التي أنتجت المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `GENERATED-BY` (BIND مستند المواصفة `GENERATED-BY`) |
| TAG ID | `0x1D3L` |
| Codec ID | `0x00001D30` |
| مستند المواصفة | `0x00000000/codecs/0x00001D30/` (هدف DECLARE `1D30`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 19 |
| Kind | Meta · الفئة: النسب |
| TAG WORD | `0001 1101 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | الجهة المنتِجة. إنسان أو نموذج أو محرك قواعد |
| جهة Hugo | `meta/lineage/generated-by.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `agent` | #2 | سجل | أي سجل (باستثناء علامة الموضع) |  |
| 2 | `version` | #5 | سجل | `0720` UTF8-TEXT-EVEN، `0730` UTF8-TEXT-ODD، `0000` ABSENT (حقل اختياري) |  |

يكتب الجهة التي أنتجت المستند. وقد تكون إنساناً أو نموذجاً أو محرك قواعد.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 0011 LLLL      Codec 0x1D3L
[Length TAG ممتد]
الجهة المنتِجة    Reference (إنسان أو نموذج أو محرك قواعد)
الإصدار           قيمة UTF8-TEXT، أو علامة الحذف 0x0000 (حقل اختياري)
```

- Codec: Meta `0x1D3L`، فئة النسب
- Payload: Reference مضمّن + نص الإصدار (اختياري)
- العدد: يجوز تعدده

## التفسير والصلاحية {#해석과-유효성}

- إذا كان نموذجاً فيُكتب معه إصدار النموذج.
- إذا لم يُعرف الإصدار أو لم يُرد وضعه فيُحذف موضعه ويُستخدم ABSENT (`0x0000`) (الحقل الاختياري في [CODEC](../edge/0x0BEL-codec.md)). فمواصفة geul.org `0x1D30` هي سجلان: agent (بلا CODEC) وversion (`0720` و`0730` و`0000`).
- أما إصدار مصدر البرنامج (commit) فصيغة [TRANSFORMED-BY](0x1D4L-transformed-by.md) (digest، إلزامي) أدق. وإصدار GENERATED-BY يُكتب نصاً لما ليس معرّف commit مثل اسم النموذج وإصداره.
- لا تُوضع في مستندات geul.org المنشورة Reference تشير إلى شخص طبيعي ([Issuer والنشر](../issuer.md#geulorg-공표)). بل تشير إلى منظمة أو Issuer. واستثناءً يُسمح بالإشارة إلى شخص طبيعي بـ [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001D30/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D3000000000
BODY
#1 DECLARE 0x1D30
#2 FIELD #1 record
#3 BIND #1 "GENERATED-BY"
#4 BIND #2 "agent"
#5 FIELD #1 record
#6 BIND #5 "version"
#7 CODEC #5 0x0720
#8 CODEC #5 0x0730
#9 CODEC #5 0x0000
```
