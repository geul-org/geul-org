---
title: "SOURCE والأقسام"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "سجلات النص الأصلي المؤلَّف في مستند TOULMIN (SOURCE) والسلاسل (TEXT) وحدود الأقسام والقضايا (SECTION وCASE-BEGIN وCASE-END) والفقرة الوصفية (PROSE) هي صيغ GEUL ISSUER 0xC000~0xC005."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

هذه سجلات تكتب النص الأصلي وحدود الأقسام في مستند TOULMIN. وكلها Edge تستخدم أرقام صيغ تحت `ISSUER-1WORD` (`0x7C`) وIssuer `0x0000` (GEUL) ([TOULMIN](/ar/grammar/edge/toulmin/#صيغة-issuer)).

## الصيغ

| رقم الصيغة | الاسم | التخطيط |
|---|---|---|
| `0xC000` | SOURCE | ID وWORD عرض SPAN وقيمة UTF8 |
| `0xC001` | TEXT | ID وقيمة UTF8 |
| `0xC002` | SECTION | ID ورمز القسم (1 WORD) |
| `0xC003` | CASE-BEGIN | ID وREF (القضية) |
| `0xC004` | CASE-END | ID وREF (القضية) |
| `0xC005` | PROSE | ID وSPAN |

- ID هو Edge Id، وREF هو Edge Id لسجل في هذا المستند (الحقول المشتركة في [TOULMIN](/ar/grammar/edge/toulmin/#الحقول-المشتركة)).
- قيمة UTF8 هي سجل Value من نوع [UTF8-TEXT](/ar/grammar/value/text/utf8-text/). وتحمل البايتات كما هي.

## SOURCE

هو النص الأصلي المؤلَّف كله. وكل SPAN هو نطاق بايتات داخل هذا النص الأصلي.

```
ID
WORD عرض SPAN     أعلى بتّين = العرض (00=1 و01=2 و10=4 و11=8 WORD)، والبتات الـ 14 الباقية = 0
النص الأصلي       سجل Value من نوع UTF8-TEXT
```

- SOURCE هو أول سجل في BODY. وفي المستند واحد منه.
- SPAN حقلان: بايت البداية وعدد البايتات. كل حقل عدد صحيح unsigned بالعرض الذي تحدده WORD عرض SPAN (1/2/4/8 WORD).

## TEXT

اسم أو سلسلة واحدة. تشير إليها بـ REF قوائم F_WITH وF_GROUNDS في NODE وLABEL وIMPORTED-FROM في LINK.

## SECTION

بداية قسم. رمز القسم 1 WORD.

| الرمز | القسم | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means` و`has` |
| 4 | Rules | قواعد تعبير الشرط |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on` و`every` |

- لا يُستخدم `0`. وتُصرَّح الأقسام بترتيب هذه الرموز.
- عنوان القسم هو PROSE الذي يلي SECTION مباشرة.

## CASE-BEGIN وCASE-END

- نطاق القضية هو ما بين CASE-BEGIN وCASE-END اللذين يشيران إلى القضية نفسها (NODE من CASE-DECLARE).

## PROSE

فقرة وصفية ليست قاعدة. وتشير فقط إلى نطاق (SPAN) في النص الأصلي.

## صفحات ذات صلة

- [TOULMIN](/ar/grammar/edge/toulmin/)، [NODE](/ar/grammar/edge/toulmin/node/)، [LINK](/ar/grammar/edge/toulmin/link/)
