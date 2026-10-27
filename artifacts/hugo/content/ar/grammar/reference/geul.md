---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL هو Reference تصريح يشير إلى هدف بمعرّف كيان يصدره geul.org بترخيص CC0."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL هو Reference تصريح يشير إلى كيان يصدره geul.org بترخيص CC0. هو معرّف متسلسل لا تحمل أرقامه معنى. أما المعرّف الذي تحمل بتاته المعنى فمن شأن Codec مستقل هو [GEUL-SIDX](/ar/grammar/reference/geul-sidx/) (`0011`).

## التخطيط

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[Length ممتد TAG]
GEUL ID           unsigned big-endian بأقصر عرض
```

- تُخصَّص الأرقام الصغيرة للكيانات الكثيرة التكرار. المعرّف الذي يتسع في 1 WORD مجموعه 2 WORD.
- تخصيص المعرّفات والسجل من شأن geul.org. ولا يوضع في السجل إلا ما جاء من مصادر CC0.
- إذا كان Variable فهو متغير مجهول من ذلك النوع ([Reference](/ar/grammar/reference/) Variable).

## أمثلة

| GEUL ID | تسلسل WORD |
|---|---|
| 1، Identified | `0090 0001` |
| 1، Variable | `0094 0001` |
| 70000، Generic | `0111 0001 1170` |

## مسائل مفتوحة

- قاعدة تخصيص GEUL ID والصيغة العامة للسجل.

## صفحات ذات صلة

- [Reference](/ar/grammar/reference/)، [GEUL-SIDX](/ar/grammar/reference/geul-sidx/)
