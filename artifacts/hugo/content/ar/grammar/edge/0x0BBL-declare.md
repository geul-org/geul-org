---
title: "DECLARE (0x0BBL)"
weight: 187
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE هو Edge عبارة يصرِّح بتركيب Payload لـ Codec واحد."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `DECLARE` (BIND مستند المواصفة `DECLARE`) |
| TAG ID | `0x0BBL` |
| Codec ID | `0x00000BB0` |
| مستند المواصفة | `0x00000000/codecs/0x00000BB0/` (هدف DECLARE `0BB0`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 27 |
| Kind | Edge · العائلة: العبارة، الحزمة: أخرى |
| TAG WORD | `0000 1011 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | التصريح بتركيب Payload لـ Codec واحد. Kind وCodec الهدف |
| جانب Hugo | `edge/declare.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | قيمة خام 1 WORD |  |  |
| 2 | `issuer` | #3 | القيمة الخام المتبقية (`0xFFFF`) |  |  |

DECLARE هو Edge عبارة يصرِّح بتركيب Payload لـ Codec واحد. Codec `0x0BBL`.

هو مع [FIELD](0x0BCL-field.md) (`0x0BCL`) و[ENUM](0x0BDL-enum.md) (`0x0BDL`) و[CODEC](0x0BEL-codec.md) (`0x0BEL`) مفردات لكتابة مواصفة Codec ([مستند مواصفة Codec](../codec-spec.md)). تخطيط هذه الـ Edge الأربع مضمَّن في المفكِّك. أما مستند مواصفة كل Codec المكتوب بهذه المفردات فهو وثيقة عادية. وبمواصفة واحدة يتم التحقق والتفكيك والعرض (العارض) معاً. لا يضع العارض شيفرة لكل Codec بل يرسم وفق المواصفة.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1011 1011 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
الهدف             1 WORD. من TAG WORD الخاص بالـ Codec المصرَّح به لا يُستخدم إلا موضع Codec (القسم وC) (LLLL = 0)
[Issuer·رقم Codec] عند التصريح بـ Codec خاص بـ Issuer. Issuer ورقم Codec في 2 WORD. التخطيط نفسه كـ Codec TAG الممتد وهو متماثل في الـ Kind الثلاثة
                  مستند مواصفة رمز ISSUER نفسه (GEUL Issuer) لا يضع إلا الهدف
```

- لا تُوضع قائمة الحقول في DECLARE. كل [FIELD](0x0BCL-field.md) يشير إلى DECLARE الخاص به، وترتيب تلك FIELD داخل المستند هو ترتيب حقول Payload.

## قواعد التفسير {#해석-규칙}

قواعد قراءة السجل وتدوينه بمواصفة Codec.

- يُقرأ الحقل الخام بعدد WORD الثابت الذي صرّح به FIELD. وقد يكون أحد الحقول قيمة خام متبقية (العرض `0xFFFF`)، فيُقرأ منها ما تبقى من WORD مطروحاً منه عروض الحقول الثابتة بعده. ولا يوضع بعد الحقل المتبقي إلا قيمة خام ثابتة العرض.
- يبدأ حقل السجل بـ TAG WORD ويُقرأ بقدر Length ذلك TAG.
- الحقل الخام هو عدد صحيح دون إشارة big-endian من n WORD. ويُدوَّن بـ `0x` + hex بعدد خانات العرض×4، وإن وُجد ENUM لتلك القيمة دُوِّن معه اسم BIND الخاص به.
- معنى حقل السجل تحدده مواصفة Codec لذلك السجل. أما القيم التي تحتاج إلى تفسير (الإشارة والكسور والتواريخ) فتوضع في سجل Value لا في قيمة خام.

لا قواعد حدود أخرى. لا يمكن التصريح بـ Codec فيه قيمتان خامتان متغيرتان أو أكثر، أو يأتي بعد القيمة الخام المتغيرة سجل أو حقل متغير، أو يتغير عرض القيمة الخام بحسب قيمة حقل آخر أو حالة الوثيقة، بهذه المفردات. يُلفّ الجزء المتغير في تخطيط كهذا بسجل ليبقى واحداً (مثل موقّع SIGNATURE وهو سجل Reference).

## الصلاحية {#유효성}

- Kind الهدف أحد: Reference أو Value أو Edge أو Meta. مستند مواصفة الرمز المباشر في GEUL واحد لكل رمز. ونظام 5Q في Reference أيضاً يُصرَّح به لكل رمز تكميم على حدة (LOCAL Identified `0050`، وGeneric `0060`، …). والمؤشرات (`0x040L` و`0x041L` و`0x042L`) وعلامات الموضع ورمز ISSUER هي أيضاً الرمز نفسه. أما Codec الخاص بـ Issuer الذي يتحدد برقم Issuer ورقم Codec بعد رمز ISSUER فتعرّفه وثيقة ذلك Issuer.
- [علامة الموضع](../slot-marker.md) (Reference `0x000L~0x002L`) هي أيضاً هدف لـ DECLARE. لا Payload لها فلا يوضع إلا DECLARE بلا FIELD. معنى العلامة وقواعد قبولها مضمَّنة في المفكِّك (الطبقة 0). وCodec الذي لم يُحدَّد تخطيطه بعد (SUPERSEDE-CHAIN وVERDICT وEVIDENCE وغيرها) لا يوضع له إلا DECLARE أيضاً.
- لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD. لأنه العنصر الأول في كل Edge فهو ضمني ([Edge](_index.md)). وفي EDGE-ISSUER هو العنصر الأول بعد Issuer ورقم Codec ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)).
- حقول DECLARE هي FIELD التي تشير إليه، ويجوز أن تكون 0. FIELD واحد ينتمي إلى DECLARE واحد فقط. ولو كان الحقل بالشكل نفسه يوضع FIELD منفصل لكل DECLARE.
- لا يوجد في DECLARE إلا الهدف (وIssuer ورقم Codec إن كان الهدف بصيغة Issuer).
- يجب أن يطابق المؤشر بعد قراءة الحقول بالتتابع نهاية السجل تماماً. وإن زاد أو نقص فالسجل مخالف للمواصفة.
- لا يُصرَّح بالهدف نفسه مرتين في وثيقة واحدة.
- لا تُستخدم المتغيرات ذات الحقول الذيلية المختلفة بوصفها تفرعاً. يوضع DECLARE منفصل لكل Codec.

## مستند المواصفة {#규격-문서}

- مستند مواصفة الرمز المباشر هو وثيقة Codec في GEUL Issuer `0x00000000`. وCodec ID هو قيمة TAG WORD الهدف (L=0) مكتوبة في 32 بت (`0x0B80` ← `0x00000B80`)، ويُنشر في `<Issuer>/codecs/<Codec ID>/` بـ ID الإصدار و`versions.geul` ([مستند مواصفة Codec](../codec-spec.md)).
- توضع وثيقة Codec الخاص بـ Issuer في `<Issuer>/codecs/<رقم Codec>/` لذلك Issuer. ولا يتكرر رقم Codec داخل ذلك Issuer أياً كان Kind. ويعدّ المفسِّر خطأً أن يختلف Kind السجل عن Kind هدف DECLARE ([عنوان النشر وقائمة الإصدارات](../publishing.md#id-표기)).
- في مستند مواصفة واحد DECLARE واحد، ويجب أن يساوي هدفه TAG WORD الخاص بـ Codec ID. و`DOC-ID` هو [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000` وCodec ID ذاك و`0`).

## الاسم {#이름}

- يُربط اسم Codec بـ Edge Id الخاص بـ DECLARE عبر [BIND](0x0A3L-bind.md) (مثل `PUBLICATION`). وكل UTF8-TEXT يُلحق بـ DECLARE وFIELD وENUM وCODEC يكون بـ BIND، ولا يُلحق بـ Edge آخر مثل LABEL.
- يُربط اسم الحقل واسم enum بـ FIELD وENUM بالطريقة نفسها.

## مثال {#예시}

مستند مواصفة PUBLICATION (Edge `0x0B8L`) `0x00000000/codecs/0x00000B80/`: بعد Edge Id سجل DOC-POINTER، وتجزئة المحتوى 16 WORD.

```
0BB3 0051 0001 0B80                 DECLARE #1  Edge 0x0B8L               (BIND "PUBLICATION")
0BC5 0051 0002 0051 0001 0000       FIELD #2    DECLARE #1، سجل            (BIND "doc")
0BE5 0051 0009 0051 0002 0410       CODEC #9    FIELD #2، DOC-POINTER
0BE5 0051 000A 0051 0002 0420       CODEC #10   FIELD #2، CODEC-POINTER (قائمة إصدارات Codec)
0BC5 0051 0004 0051 0001 0010       FIELD #4    DECLARE #1، قيمة خام 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + الهدف 1 = 4 WORD، و`LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + العرض 1 = 6 WORD (`LLLL = 0101`). ويوضع Kind وCodec المقبولان على حدة بـ [CODEC](0x0BEL-codec.md) (`0410` = DOC-POINTER، `0420` = CODEC-POINTER).
- يُصرَّح بالحقل الاختياري بهدف CODEC هو `0000`. ويوضع ABSENT (`0x0000`) في الموضع المحذوف ([CODEC](0x0BEL-codec.md) الحقل الاختياري).
- ترتيب الحقول هو الترتيب الذي وُضع به FIELD #2 و#4 في المستند. ولا يلزم أن تكون Edge Id متصلة (LOCAL AUTO INCREMENT توصية).

## مسائل مفتوحة {#열린-문제}

- التكرار. تركيب يحدد فيه قيمة خام سابقة العدد، مثل «المعاملات × عدد المعاملات» في `CALL`. لا يمكن التصريح به الآن.
- طريقة التصريح بـ Codec ذي صيغ فرعية (TAG خاص بالـ Codec) مثل WORLD.
- أي حزمة إصدارات من مستندات مواصفة الرموز المباشرة يعنيها `SPEC-VERSION`.

## صفحات ذات صلة {#관련-페이지}

- [FIELD](0x0BCL-field.md)، [ENUM](0x0BDL-enum.md)، [CODEC](0x0BEL-codec.md)، [BIND](0x0A3L-bind.md)
- [Edge](_index.md)، [مستند مواصفة Codec](../codec-spec.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000BB0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BB000000000
BODY
#1 DECLARE 0x0BB0
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "DECLARE"
#5 BIND #2 "target"
#6 BIND #3 "issuer"
```
