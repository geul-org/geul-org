---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE هو Meta نسب يكتب في diff قائمة LOCAL ID (Edge Id) التي تُحذف من BODY الـ snapshot الأساس."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب في diff ([DELTA-BASE](/ar/grammar/meta/lineage/delta-base/)) معرّفات LOCAL (Edge Id) للسجلات التي تُحذف من BODY الـ snapshot الأساس ("حذف المادة X").

## التخطيط

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[Length ممتد TAG]
LOCAL ID المحذوفة  سجلات Reference من نوع LOCAL × 1 فأكثر
```

- Codec: Meta `0x3B`، فئة النسب (`011`)
- Payload: سجل [LOCAL](/ar/grammar/reference/local/) Reference واحد فأكثر
- العدد: واحد على الأكثر

## التفسير والصلاحية

- لا يوضع إلا في مستند فيه `DELTA-BASE`.
- يجب أن يكون كل LOCAL ID هو Edge Id موجوداً في BODY الـ snapshot الأساس. وإلا فهو invalid. وإن وُضع المعرّف نفسه مرتين فهو invalid.
- يكون invalid وضع Edge Id نفسه مرة أخرى في BODY الخاص بـ diff نفسه (لا يمكن الحذف والمراجعة معاً).
- لا يُعاد تخصيص LOCAL ID المحذوف لهدف آخر في الإصدارات اللاحقة ([المراجعة](/ar/grammar/document/#المراجعة)).
- خلو BODY الخاص بـ diff من سجل يعني "لم يتغير". لذلك لا يُعبَّر عن الحذف إلا بهذا الـ Meta.
- لا يُكتب Edge الـ HEAD ([SOURCE](/ar/grammar/edge/source/#مصدر-المستند-كله) للمستند كله وQUALIFIER الخاصة به). فـ HEAD يتغير كاملاً بوصفه HEAD الخاص بـ diff ([تخزين diff](/ar/grammar/document/#تخزين-diff)).

## أمثلة

حذف LOCAL `#7` و`#12`:

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B` (Meta `0x3B`، و`LLLL=0100`، و5 WORD)، وسجلا LOCAL Reference هما `0088 0007` و`0088 000C`.
