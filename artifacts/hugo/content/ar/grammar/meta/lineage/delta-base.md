---
title: "DELTA-BASE"
weight: 59
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-BASE هو Meta نسب يبيّن أن ملف هذا الإصدار هو diff بالنسبة إلى إصدار أساس من المستند نفسه."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

هو علامة على أن ملف هذا الإصدار ليس snapshot بل **diff** بالنسبة إلى إصدار أساس من المستند نفسه (delta في git packfile). ويبقى الإصدار نفسه معرَّفاً على أنه snapshot. وتجزئة المحتوى وقائمة الإصدارات والتوقيع كلها بالنسبة إلى snapshot الذي استُعيد بتطبيق diff ([تخزين diff](/ar/grammar/document/#تخزين-diff)).

## التخطيط

```
TAG WORD          0001 1LLL L011 1010      Codec 0x3A
معرّف الإصدار     2 WORD unsigned (إصدار الأساس من المستند نفسه)
```

- Codec: Meta `0x3A`، فئة النسب (`011`)
- Payload: معرّف إصدار من 2 WORD (قيمة خام)
- العدد: واحد على الأكثر

## التفسير والصلاحية

- لا يُستخدم إلا في مستند فيه [DOC-ID](/ar/grammar/meta/declaration/doc-id/) (مستند تُدار إصداراته بقائمة الإصدارات). أما `versions.geul` و`documents.geul` و`issuers.geul` التي لا تُدار إصداراتها، والمستند بلا اسم، فلا يوضع لها diff.
- إصدار الأساس هو إصدار منشور من `DOC-ID` نفسه ويسبق هذا الإصدار. و`0` (بلا إصدار) invalid.
- يجب أن تساوي تجزئة محتوى snapshot المستعاد تجزئة هذا الإصدار في قائمة الإصدارات ([PUBLICATION](/ar/grammar/edge/publication/)). وإلا فهذا diff invalid. لذلك لا تُكتب تجزئة النتيجة داخل diff.
- لا يمكن وضع diff إلا لمستند كل سجلات BODY فيه Edge (سجل له Edge Id). لأن وحدة diff هي LOCAL ID (Edge Id).
- قاعدة استعادة snapshot تتبع [تخزين diff](/ar/grammar/document/#تخزين-diff). والحذف من شأن [DELTA-REMOVE](/ar/grammar/meta/lineage/delta-remove/).
- لا توضع علامة للإضافة أو المراجعة. فإذا كان Edge Id في BODY الخاص بـ diff موجوداً في الأساس فهو مراجعة، وإن لم يكن فهو إضافة. وتأخذ الإضافة أرقامها بدءاً من [NEXT-LOCAL-ID](/ar/grammar/meta/lineage/next-local-id/) في قائمة الإصدارات. وإعادة استخدام LOCAL ID محذوف invalid ([المراجعة](/ar/grammar/document/#المراجعة)).

## أمثلة

diff بالنسبة إلى الإصدار 3 كأساس:

```
193A 0000 0003
```

- TAG `193A` (Meta `0x3A`، و`LLLL=0010`، و3 WORD)، ومعرّف الإصدار `0000 0003`.

## مسائل مفتوحة

1. الفاصل بين snapshots: كل كم إصدار يوضع snapshot كامل (طول سلسلة diff وكلفة الاستعادة).
2. هل يُقصر إصدار الأساس على الإصدار السابق مباشرة.
3. موضع تخزين ملف diff: هل يوضع في موضع ملف الإصدار (`<معرّف الإصدار>.geul`)، والعلاقة بمخزن العنونة بالمحتوى `h/` (يُعثر على `h/` بتجزئة محتوى snapshot).
