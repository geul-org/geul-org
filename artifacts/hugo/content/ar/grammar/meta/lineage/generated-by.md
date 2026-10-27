---
title: "GENERATED-BY"
weight: 51
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "GENERATED-BY هو Meta نسب يكتب الجهة التي أنتجت المستند (إنسان أو نموذج أو محرك قواعد) وإصدارها."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب الجهة التي أنتجت المستند. ويمكن أن تكون إنساناً أو نموذجاً أو محرك قواعد.

## التخطيط

```
TAG WORD          0001 1LLL L011 0010      Codec 0x32
[Length ممتد TAG]
الجهة المنتِجة     Reference (إنسان أو نموذج أو محرك قواعد)
الإصدار           قيمة UTF8-TEXT، أو علامة الحذف 0x0000 (حقل اختياري)
```

- Codec: Meta `0x32`، فئة النسب (`011`)
- Payload: Reference مضمّن + نص الإصدار (اختياري)
- العدد: يمكن أكثر من واحد

## التفسير والصلاحية

- إذا كانت نموذجاً فيُكتب إصدار النموذج معها.
- إذا لم يُعرف الإصدار أو لم يوضع فيُحذف موضعه وتُكتب ABSENT (`0x0000`) ([CODEC](/ar/grammar/edge/codec/) الحقل الاختياري). ومواصفة geul.org `0x1832` حقلا سجل هما agent (بلا CODEC) وversion (`0840`·`0841`·`0000`).
- إصدار مصدر البرنامج (commit) تكتبه بدقة أكبر صيغة [TRANSFORMED-BY](/ar/grammar/meta/lineage/transformed-by/) (digest، إلزامي). أما الإصدار في GENERATED-BY فيكتب نصاً ما ليس معرّف commit مثل اسم النموذج وإصداره.
- لا يوضع في مستند منشور على geul.org Reference يشير إلى شخص طبيعي ([Issuer والنشر](/ar/grammar/issuer/#النشر-على-geulorg)). بل يشير إلى منظمة أو Issuer. والاستثناء الإشارة إلى شخص طبيعي بـ [WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/) فهي مسموحة.
