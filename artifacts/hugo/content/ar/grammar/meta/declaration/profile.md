---
title: "PROFILE"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "PROFILE هو Meta تعريف يصرّح بالـ profile المطبَّق على المستند باسمه ونص إصداره."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يصرّح بالـ profile المطبَّق على المستند. وتُفسَّر السجلات نفسها بمستندات Codec التي حددها الـ profile (مثلاً: إذا كان `tangeul-1.0` فهو [TOULMIN](/ar/grammar/edge/toulmin/)).

## التخطيط

```
TAG WORD          0001 1LLL L001 0001      Codec 0x11
[Length ممتد TAG]
Payload           قيمة UTF8-TEXT "<الاسم>-<major>.<minor>"
```

- Codec: Meta `0x11`، فئة التعريف (`001`)
- Payload: Value مضمّنة ([UTF8-TEXT](/ar/grammar/value/text/utf8-text/))
- العدد: واحد على الأكثر

## التفسير والصلاحية

- يُرفض profile مختلف في major. ويُسمح بالاختلاف في minor (تغييرات بالإضافة فقط).
- إذا غاب الـ profile فيُقرأ بنحو GEUL الأساسي ومواصفات الرموز المباشرة فقط.

## أمثلة

- `tangeul-1.0`: `0x1B91 0x0B41 7461 6e67 6575 6c2d 312e 3000`

## مسائل مفتوحة

- سجل أسماء profile (geul.org) وقواعد التسمية.
- هل يُشار إلى الـ profile بمعرّف مستند (IMPORT) أم يوضع نصاً.
