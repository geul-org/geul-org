---
title: "NO-VALUE (0x002L)"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "NO-VALUE هو علامة موضع تعبّر عن «لا شيء»."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NO-VALUE هو [علامة موضع](../slot-marker.md) تعبّر عن «لا شيء». هو تقرير عن العالم بأنه لا توجد قيمة.

| البند | القيمة |
|---|---|
| الاسم | `NO-VALUE` (BIND `NO-VALUE` في مستند المواصفة) |
| TAG ID | `0x002L` |
| Codec ID | `0x00000020` |
| مستند المواصفة | `0x00000000/codecs/0x00000020/` (هدف DECLARE `0020`) |
| القسم | 0 `0000` (كيان Reference)، الإزاحة داخل القسم C = 2 |
| Kind | Reference · التصنيف: علامة موضع |
| TAG WORD | `0000 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | لا شيء. لا توجد قيمة (`novalue` في ويكي بيانات) |
| جهة Hugo | `reference/slot-marker.md` |

## التخطيط {#레이아웃}

```
TAG WORD          0000 0000 0010 0000      WORD 0x0020, 1 WORD
```

- لا يوجد Payload. ولا معرّف هدف ولا Quantifier ([علامة موضع](../slot-marker.md#레이아웃)).
- الصيغة التي فيها Payload (L ≥ 1) في `0x002L` هي Reserved.
- التمثيل النصي في `geul show` و`geul add`: `NONE`.

## المعنى {#뜻}

| البند | لا شيء |
|---|---|
| عن ماذا يتحدث | **العالم**: لا توجد قيمة |
| المنطق | `¬∃x. P(s, x)` |
| افتراض العالم | عالم مغلق بالنسبة إلى (s, P, شرط التقييد) |
| ويكي بيانات | `novalue` |

## القبول {#수용}

- لا يقبله إلا حقل له هدف CODEC `0020`. يقبل هذا الحقل التقرير «لا شيء». مثال: Object في [TRIPLE](../edge/0x0AAL-triple.md)، وValue في [QUALIFIER](../edge/0x0ABL-qualifier.md).
- لا يجوز استخدامه في المحرف الشامل، ولا في حقل بلا CODEC، ولا في موضع سجل HEAD أو BODY، ولا في موضع Edge Id، ولا في حقل قيمة خام (القاعدة المشتركة في [علامة موضع](../slot-marker.md#수용-규칙)).

## واجبات القارئ {#읽는-쪽의-의무}

- **NO-VALUE مغلق داخل شرط التقييد لتلك القضية.** إذا أُلحق به QUALIFIER فهو مغلق في ذلك النطاق فقط. Q30 P1304 NO-VALUE(P580 1811, P582 1816) يعني أنه لم يكن ثمة مصرف مركزي في الفترة 1811~1816 فقط، ولا يتعارض مع TRIPLE القيمة لنفس الخاصية (Federal Reserve، preferred).
- إذا وُجد لنفس Subject وPredicate كلٌّ من NO-VALUE وTRIPLE قيمة بالـrank نفسه دون تمييز بين شروط التقييد فهذا تناقض. يصدر المدقّق تحذيرًا ولا يرفض. فهذه حالة موجودة في ويكي بيانات أيضًا، ويختار القارئ بالـrank.
- **تُطبَّق rank بالطريقة نفسها.** عند اختيار القيمة الممثِّلة (truthy) تدخل TRIPLE التي فيها NO-VALUE ضمن المرشحين.
- **إذا استُخدم قيمةً في QUALIFIER فإنه يغيّر معنى ذلك التقييد.** `P582 = NONE` تقرّر أنه لم ينتهِ. وإذا لم يوجد QUALIFIER لـP582 أصلًا فلا يُعرف هل انتهى.
- لا يمكن قول «لا يوجد» إلا بـ**كتابته** NO-VALUE. وغياب TRIPLE من المستند هو عدم كتابة (عالم مفتوح).

## مثال {#예시}

`0x0020` WORD واحد. مثال: «لا أولاد» (P40) هو `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000` (TRIPLE، وموضع Object هو `0020`).

## مستند Codec {#코덱-문서}

لا يحتوي مستند Codec إلا على DECLARE واحد (الهدف `0020`). ولا يوجد FIELD لعدم وجود Payload. يضمّن المفكّك معنى العلامة وقواعد قبولها ([الطبقة 0](../publishing.md#층)). ولا يُراجَع مستند Codec لقراءة العلامة.

## صفحات ذات صلة {#관련-페이지}

- [علامة موضع](../slot-marker.md)، [ABSENT](0x000L-absent.md)، [UNKNOWN-VALUE](0x001L-unknown-value.md)
- [CODEC](../edge/0x0BEL-codec.md)، [مستند Codec](../codec-spec.md)، [TRIPLE](../edge/0x0AAL-triple.md)، [QUALIFIER](../edge/0x0ABL-qualifier.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000020/latest.geul` مقروءًا بـ`geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000002000000000
BODY
#1 DECLARE 0x0020
#2 BIND #1 "NO-VALUE"
```
