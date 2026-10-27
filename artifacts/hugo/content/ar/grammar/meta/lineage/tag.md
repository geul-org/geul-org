---
title: "TAG"
weight: 58
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TAG هو Meta نسب يكتب اسماً ثابتاً يُلحق بإصدار (git annotated tag)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب اسماً ثابتاً يُلحق بإصدار (git annotated tag).

## التخطيط

```
TAG WORD          0001 1LLL L011 1001      Codec 0x39
[Length ممتد TAG]
الاسم             قيمة UTF8-TEXT-*
الهدف             قيمة SHA-256-DIGEST، أو علامة الحذف 0x0000 (حقل اختياري). وإذا حُذف فهو هذا الإصدار
```

- Codec: Meta `0x39`، فئة النسب (`011`)
- Payload: Value مضمّنة (نص + تجزئة محتوى اختيارية)
- العدد: يمكن أكثر من واحد

## التفسير والصلاحية

- الاسم هو [UTF8-TEXT](/ar/grammar/value/text/utf8-text/) والهدف هو [SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/).
- إذا حُذف الهدف (ABSENT `0x0000`، [CODEC](/ar/grammar/edge/codec/) الحقل الاختياري) فالاسم مُلحق بهذا المستند نفسه. فلا يمكن كتابة تجزئة المحتوى الخاصة بالمستند داخله. ومواصفة geul.org `0x1839` حقلا سجل هما name (`0840`·`0841`) وtarget (`0861`·`0000`).
- لا يُعاد استخدام الاسم نفسه لإصدار آخر.

## أمثلة

- الاسم `v1`، وهذا الإصدار: `19B9 08C0 7631 0000`

## مسائل مفتوحة

- هل يلزم TAG مع وجود معرّف الإصدار (الرقم التسلسلي)، والفصل بين دوره ودور اسم المستند (`BIND`).
