---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE هو Meta تعريف يصرّح بقيمة لغة هي اللغة الافتراضية لنص المستند."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يصرّح باللغة الافتراضية لنص المستند. والنص الذي لم تُكتب له لغة على حدة هو بهذه اللغة.

## التخطيط

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[Length ممتد TAG]
Payload           قيمة لغة واحدة
```

- Codec: Meta `0x16`، فئة التعريف (`001`)
- Payload: Value مضمّنة ([LANGUAGE-BCP47-CODE](/ar/grammar/value/text/language-bcp47-code/) أو [LANGUAGE-SHORT-CODE](/ar/grammar/value/text/language-short-code/))
- العدد: واحد على الأكثر

## التفسير والصلاحية

- يكتب مستند TANGEUL لغة التأليف (مثل `en` و`ko`).

## أمثلة

- `en`: `0x1916 0x08C6 0x656E`
