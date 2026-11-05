---
title: "UNKNOWN-VALUE (0x001L)"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "UNKNOWN-VALUE هو علامة موضع تعبّر عن «غير معروف»."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNKNOWN-VALUE هو [علامة موضع](../slot-marker.md) تعبّر عن «غير معروف». هو تقرير عن العالم بأن القيمة موجودة لكن لا يُعرف ما هي.

| البند | القيمة |
|---|---|
| الاسم | `UNKNOWN-VALUE` (BIND `UNKNOWN-VALUE` في مستند المواصفة) |
| TAG ID | `0x001L` |
| Codec ID | `0x00000010` |
| مستند المواصفة | `0x00000000/codecs/0x00000010/` (هدف DECLARE `0010`) |
| القسم | 0 `0000` (كيان Reference)، الإزاحة داخل القسم C = 1 |
| Kind | Reference · التصنيف: علامة موضع |
| TAG WORD | `0000 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | غير معروف. القيمة موجودة لكن لا يُعرف ما هي (`somevalue` في ويكي بيانات) |
| جهة Hugo | `reference/slot-marker.md` |

## التخطيط {#레이아웃}

```
TAG WORD          0000 0000 0001 0000      WORD 0x0010, 1 WORD
```

- لا يوجد Payload. ولا معرّف هدف ولا Quantifier ([علامة موضع](../slot-marker.md#레이아웃)).
- الصيغة التي فيها Payload (L ≥ 1) في `0x001L` هي Reserved.
- التمثيل النصي في `geul show` و`geul add`: `UNKNOWN`.

## المعنى {#뜻}

| البند | غير معروف |
|---|---|
| عن ماذا يتحدث | **العالم**: القيمة موجودة. ولا يُعرف ما هي |
| المنطق | `∃x. P(s, x)`، وx غير محدَّد الهوية |
| افتراض العالم | الوجود مغلق، والهوية مفتوحة |
| ويكي بيانات | `somevalue` |

## القبول {#수용}

- لا يقبله إلا حقل له هدف CODEC `0010`. يقبل هذا الحقل التقرير «غير معروف». مثال: Object في [TRIPLE](../edge/0x0AAL-triple.md)، وValue في [QUALIFIER](../edge/0x0ABL-qualifier.md)، وOrigin في [SOURCE](../edge/0x0C0L-source.md).
- لا يجوز استخدامه في المحرف الشامل، ولا في حقل بلا CODEC، ولا في موضع سجل HEAD أو BODY، ولا في موضع Edge Id، ولا في حقل قيمة خام (القاعدة المشتركة في [علامة موضع](../slot-marker.md#수용-규칙)).

## واجبات القارئ {#읽는-쪽의-의무}

- **UNKNOWN-VALUE ليس قيمة بل تقرير وجود.** لا يساوي أي قيمة أخرى ولا يخالفها (نتيجة المقارنة غير محسومة). ولا يُعدّ UNKNOWN-VALUE اثنين متساويين فيما بينهما. كل ظهور تكميم وجودي مستقل (كالعقدة الفارغة في ويكي بيانات).
- لذلك فإن TRIPLE متطابقتي البايتات (`P40 Q… UNKNOWN` مرتين) ليستا تكرارًا. قد يكون للشخص ولدان وقد يكون ولد واحد. لا تُدمج TRIPLE التي تحتوي UNKNOWN-VALUE على أنها مكررة.
- إذا اتضحت الهوية لاحقًا يصدر إصدار جديد معدَّل من تلك TRIPLE. لا يمكن الإشارة إلى UNKNOWN-VALUE. وإذا لزمت إحالة مشتركة فاستخدم Variable في LOCAL (Variable في [Reference](_index.md#quantifier)).
- **تُطبَّق rank بالطريقة نفسها.** عند اختيار القيمة الممثِّلة (truthy) تدخل TRIPLE التي فيها UNKNOWN-VALUE ضمن المرشحين.
- **إذا استُخدم قيمةً في QUALIFIER فإنه يغيّر معنى ذلك التقييد.** `P582 = UNKNOWN` تعني أنه انتهى ولا يُعرف وقت الانتهاء. ولا تُقرأ على أنها قضية ما زالت سارية.
- UNKNOWN-VALUE تقرير بأن «ثمة قيمة»، فلا يُستخدم إلا إذا قال المصدر ذلك. ولا يُكتب UNKNOWN-VALUE لقيمة تعذّر نقلها.

## مثال {#예시}

`0x0010` WORD واحد. مثال: وقت انتهاء (P582) حدود Q30–Q34266 غير معروف: `0AB7 0051 0C58 0191 0246 0051 080C 0010` (QUALIFIER، وموضع Value هو `0010`).

## مستند Codec {#코덱-문서}

لا يحتوي مستند Codec إلا على DECLARE واحد (الهدف `0010`). ولا يوجد FIELD لعدم وجود Payload. يضمّن المفكّك معنى العلامة وقواعد قبولها ([الطبقة 0](../publishing.md#층)). ولا يُراجَع مستند Codec لقراءة العلامة.

## صفحات ذات صلة {#관련-페이지}

- [علامة موضع](../slot-marker.md)، [ABSENT](0x000L-absent.md)، [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md)، [مستند Codec](../codec-spec.md)، [TRIPLE](../edge/0x0AAL-triple.md)، [QUALIFIER](../edge/0x0ABL-qualifier.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000010/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000001000000000
BODY
#1 DECLARE 0x0010
#2 BIND #1 "UNKNOWN-VALUE"
```
