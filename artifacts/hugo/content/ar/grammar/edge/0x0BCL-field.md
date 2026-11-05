---
title: "FIELD (0x0BCL)"
weight: 188
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD هو Edge عبارة يصرِّح بحقل واحد من Payload الخاص بـ Codec."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `FIELD` (BIND مستند المواصفة `FIELD`) |
| TAG ID | `0x0BCL` |
| Codec ID | `0x00000BC0` |
| مستند المواصفة | `0x00000000/codecs/0x00000BC0/` (هدف DECLARE `0BC0`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 28 |
| Kind | Edge · العائلة: العبارة، الحزمة: أخرى |
| TAG WORD | `0000 1011 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | حقل Payload واحد. DECLARE الذي ينتمي إليه، العرض: سجل (Length الخاص بـ TAG) أو قيمة خام n WORD |
| جانب Hugo | `edge/field.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `declare` | #2 | سجل | `0050` LOCAL |  |
| 2 | `width` | #3 | قيمة خام 1 WORD |  | `0x0000` record، `0xFFFF` rest |

FIELD هو Edge عبارة يصرِّح بحقل واحد من Payload الخاص بـ Codec. Codec `0x0BCL`.

يشير FIELD إلى [DECLARE](0x0BBL-declare.md) الخاص به. وتشكِّل FIELD التي تشير إلى DECLARE واحد Payload بترتيبها في الوثيقة. التخطيط مضمَّن في المفكِّك ([مستند مواصفة Codec](../codec-spec.md)).

## التخطيط {#레이아웃}

```
TAG WORD          0000 1011 1100 LLLL
Edge Id           سجل LOCAL Reference
DECLARE           سجل LOCAL Reference. Edge من نوع DECLARE الذي ينتمي إليه هذا الحقل
العرض             1 WORD. 0 = سجل، n (1~65534) = قيمة خام n WORD، 0xFFFF = القيمة الخام المتبقية
```

## التفسير والصلاحية {#해석과-유효성}

- يشير DECLARE إلى Edge من نوع DECLARE في الوثيقة نفسها. FIELD واحد ينتمي إلى DECLARE واحد فقط. لا يُكتب الترتيب على حدة، بل هو الترتيب الذي وُضعت به سجلات FIELD في الوثيقة.
- يصرِّح مستند مواصفة FIELD بـ DECLARE بوصفه حقلاً بعرض `0` (سجل) وCODEC `0050` (LOCAL). لذلك يُرسم في رسم العارض ربطٌ FIELD ← DECLARE.
- العرض `0` حقل سجل. يبدأ بـ TAG WORD ويُقرأ بقدر Length ذلك TAG ([DECLARE](0x0BBL-declare.md) قواعد التفسير).
- العرض `n` (1~65534) حقل خام. وهو دائماً n WORD تماماً.
- العرض `0xFFFF` هو القيمة الخام المتبقية. يوضع واحد فقط في DECLARE ويجوز في المقدمة أو الوسط أو النهاية. عرضه هو WORD المتبقية التي يحددها Length الخاص بـ TAG السجل الخارجي مطروحاً منها عروض الحقول بعده. لذلك يجب أن تكون الحقول بعد الحقل المتبقي كلها قيماً خاماً ثابتة العرض (إذ لا تُعرف نهاية السجل إلا بالقراءة من البداية). ويجوز أن يكون 0 WORD. ولا يُلحق ENUM.
- يحدَّد Kind وCodec الذي يقبله الحقل بـ [CODEC](0x0BEL-codec.md). حقل السجل بلا CODEC يقبل أي سجل، ومع وجوده يجب أن يكون أحدها. وإن وُضع CODEC واحد لحقل خام فُسِّرت تلك القيمة الخام بوصفها ذلك Value بعد طرح TAG.
- يُربط اسم الحقل بـ Edge Id الخاص بـ FIELD عبر [BIND](0x0A3L-bind.md) (مثل `doc` و`hash`). وكل UTF8-TEXT يُلحق بـ DECLARE وFIELD وENUM وCODEC يكون بـ BIND، ولا يُلحق بـ Edge آخر مثل LABEL.
- يُلحق معنى قيم الرمز في الحقل الخام بـ [ENUM](0x0BDL-enum.md).
- لا يُعلَّم في الرسم الحقل الذي يشير إلى عقدة أخرى. فإذا كان حقل السجل Reference فهو الربط.

## الطول {#길이}

```
الكل = 1 + 2 + 2 + 1 WORD   (حين يكون Edge Id وDECLARE من نوع LOCAL ID بـ 1 WORD)
```

## مثال (غير معياري) {#예시-비규범}

- حقل سجل: Edge Id هو 7، وDECLARE هو #1، والعرض `0`. TAG 1 + Edge Id 2 + DECLARE 2 + العرض 1 = 6 WORD. ولقبول LOCAL فقط انظر مثال [CODEC](0x0BEL-codec.md).

```
0BC5 0051 0007 0051 0001 0000
```

- أما الحقل الخام مثل تجزئة المحتوى فانظر مثال [DECLARE](0x0BBL-declare.md).

## صفحات ذات صلة {#관련-페이지}

- [DECLARE](0x0BBL-declare.md)، [ENUM](0x0BDL-enum.md)، [CODEC](0x0BEL-codec.md)، [BIND](0x0A3L-bind.md)
- [مستند مواصفة Codec](../codec-spec.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000BC0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BC000000000
BODY
#1 DECLARE 0x0BC0
#2 FIELD #1 record
#13 CODEC #2 0x0050
#3 FIELD #1 0x0001
#5 ENUM #3 0x0000
#6 ENUM #3 0xFFFF
#7 BIND #1 "FIELD"
#8 BIND #2 "declare"
#9 BIND #3 "width"
#11 BIND #5 "record"
#12 BIND #6 "rest"
```
