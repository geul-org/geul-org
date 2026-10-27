---
title: "NEXT-LOCAL-ID"
weight: 61
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "NEXT-LOCAL-ID هو Meta نسب يكتب في قائمة الإصدارات LOCAL ID الذي سيخصصه الإصدار التالي من المستند للأوصاف الجديدة (auto increment)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب LOCAL ID الذي سيخصصه الإصدار التالي من ذلك المستند للأوصاف الجديدة (auto increment في DBMS، و`AUTO_INCREMENT` في MySQL). وكل LOCAL ID خُصص في أي إصدار من المستند أصغر من هذه القيمة.

## التخطيط

```
TAG WORD          0001 1LLL L011 1100      Codec 0x3C
Payload           LOCAL ID التالي الذي سيُخصَّص، عدد صحيح unsigned بأقصر عرض
```

- Codec: Meta `0x3C`، فئة النسب (`011`)
- Payload: قيمة خام (عدد صحيح unsigned بأقصر عرض)
- العدد: واحد على الأكثر
- موضعه: HEAD في مستند قائمة الإصدارات `versions.geul` ([PUBLICATION](/ar/grammar/edge/publication/))

## التفسير والصلاحية

- LOCAL ID (بما فيه Edge Id) هو هوية تتجاوز الإصدارات ([المراجعة](/ar/grammar/document/#المراجعة)). يأخذ الوصف الجديد هذه القيمة ثم تزداد القيمة بمقدار 1. ولا يُعاد استخدام LOCAL ID المحذوف. لذلك لا تنقص هذه القيمة حتى لو حُذف الوصف الذي له أكبر قيمة.
- LOCAL ID `0` لا يُخصَّص فالقيمة الأولى هي `1`. وإذا لم يوجد إصدار بعد فلا يوضع هذا الـ Meta ويكون الرقم التالي `1`.
- عندما ينشر الناشر إصداراً يحدّثه ويكتبه في مستند القائمة الجديد. ويجب أن يكون أكبر من أي LOCAL ID استُخدم في الإصدارات المنشورة. وإن كان أصغر منها أو مساوياً لها فهو invalid.
- القيمة تزداد فقط. وإذا كانت أصغر من قيمة مستند القائمة السابق ([PARENT](/ar/grammar/meta/lineage/parent/)) فهو invalid.
- لا يوجد في المستندات التي لا تُدار إصداراتها (مستند بلا `versions.geul` ومستند بلا اسم). ولا يوضع diff ([DELTA-BASE](/ar/grammar/meta/lineage/delta-base/)) لمثل هذه المستندات.
- لا يوضع في متن المستند (مستند الإصدار). فحفظ الرقم ليس من محتوى المستند بل من حالة الناشر الذي يضيف إلى المستند (جهة refs في git لا commit).

## أمثلة

رقم التخصيص التالي 524:

```
18BC 020C
```

- TAG `18BC` (Meta `0x3C`، و`LLLL=0001`، و2 WORD)، وPayload `020C`.
