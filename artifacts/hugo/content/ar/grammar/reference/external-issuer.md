---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER هو Reference إشارة وتصريح يقتبس معرّف LOCAL في مستند نشره Issuer بسجل واحد دون IMPORT."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER هو Reference إشارة وتصريح يقتبس معرّف LOCAL في مستند نشره Issuer دون IMPORT. يكتمل معناه بسجل واحد ويتبع الإصدار الأحدث.

## التخطيط

```
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[Length ممتد TAG]
Issuer            العرض الذي يحدده WW (00=1 و01=2 و10=4 و11=16 WORD)
معرّف المستند     4 WORD
معرّف الهدف       كل الباقي. معرّف LOCAL في ذلك المستند، بأقصر عرض
```

| CCCC | الاسم | عرض Issuer |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD (يخصصه geul.org) |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD (يسجله geul.org، مع إثبات النطاق) |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD (يسجله geul.org، بلا إثبات) |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD (يُحسب من المفتاح العام) |

- معرّف Issuer قيمة عددية. إذا تساوت القيمة فهو Issuer نفسه. يُكتب Issuer بأقصر عرض يتسع للقيمة ويُختار Codec ذلك العرض (2 WORD فقط إذا تجاوزت القيمة `0xFFFF`، و4 WORD فقط إذا بلغت `2^32` فأكثر، و16 WORD فقط إذا بلغت `2^64` فأكثر). والكتابة بعرض أوسع invalid ([Issuer](/ar/grammar/issuer/)).
- تسجيل Issuer وإدارته من شأن geul.org.
- لا يُكتب الإصدار ويتبع الإصدار الأحدث. ولتثبيت الإصدار يُستخدم [IMPORT-DOC](/ar/grammar/meta/import/import-doc/) و[EXTERNAL-POINTER](/ar/grammar/reference/external-pointer/).
- يُعثر على الموضع بقاعدة عنوان النشر ([عنوان النشر وقائمة الإصدارات](/ar/grammar/publishing/)).
- إذا كان معرّف LOCAL في ذلك المستند هو نفسه، فهو الهدف نفسه سواء كُتب في ذلك المستند بـ LOCAL أو في مستند آخر بـ EXTERNAL-ISSUER (أو بـ EXTERNAL-POINTER بعد IMPORT).
- يشير إلى LOCAL في المستند فقط. ويُشار إلى المستند نفسه بـ [DOC-POINTER](/ar/grammar/reference/doc-pointer/) وإلى Issuer نفسه بـ [ISSUER-POINTER](/ar/grammar/reference/issuer-pointer/). لذلك لا يكون معرّف الهدف `0`. ومعرّف المستند `0` هو مستند فهرس تعريف مصطلحات Issuer.

## الصلاحية

- يكون invalid إذا لم يطابق عرض Issuer مع Codec، أو كانت قيمته تتسع في عرض أضيق.
- يكون invalid إذا كان معرّف الهدف `0`. فمعرّف الهدف `0` (المستند نفسه) من شأن DOC-POINTER.
- تُحظر `0x0000` WORD في بداية معرّف الهدف.

## أمثلة

| الهدف | تسلسل WORD |
|---|---|
| Issuer `0x0001` والمستند `0x…0002` وLOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345` والمستند `0x…0002` وLOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## صفحات ذات صلة

- [Reference](/ar/grammar/reference/)، [DOC-POINTER](/ar/grammar/reference/doc-pointer/)، [ISSUER-POINTER](/ar/grammar/reference/issuer-pointer/)، [EXTERNAL-POINTER](/ar/grammar/reference/external-pointer/)
- [Issuer والنشر](/ar/grammar/issuer/)
