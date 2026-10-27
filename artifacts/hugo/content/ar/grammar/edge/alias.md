---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS هو Edge وصف يربط اسماً آخر (كنية) لهدف Subject (Codec 0x05). تخطيطه مثل LABEL."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS هو Edge وصف يربط اسماً آخر (كنية) لهدف Subject على أنه Object. Codec `0x05`.

[LABEL](/ar/grammar/edge/label/) هو الاسم الرئيسي في تلك اللغة (لا يزيد على واحد لكل لغة)، أما ALIAS فاسم آخر للهدف نفسه (عدة أسماء لكل لغة، "also known as" في ويكي بيانات). ويُستخدم أساساً في البحث. تخطيطه وصلاحيته مثل LABEL.

## التخطيط

```
TAG WORD          0001 0LLL L000 0101
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
Subject           سجل Reference واحد
Object            قيمة UTF8-LANGUAGE-TEXT أو سجل Reference واحد من نوع LOCAL
```

## التفسير والصلاحية

- قواعد Subject وObject مثل [LABEL](/ar/grammar/edge/label/) (Object هو [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/) أو LOCAL يُحل إليه).
- يمكن وضع عدة ALIAS لـ Subject واللغة نفسيهما. وترتيبها هو ترتيبها في المستند.
- لا يوضع نص مطابق لـ LABEL لـ Subject واللغة نفسيهما في ALIAS (يكفي LABEL واحد للاسم الرئيسي). وهذه القاعدة توصية.
- تقصر مواصفة geul.org الـ Object على [CODEC](/ar/grammar/edge/codec/) (`084A` و`084B` و`0008`، مثل LABEL).

## أمثلة (غير معيارية)

Edge Id `0003`، وSubject Q42 (`00A0 002a`)، وObject `DNA` (en): اللغة `08C6 656e` (BCP47 `en`) + نص من 3 bytes (فردي) ← `UTF8-LANGUAGE-TEXT-ODD` (`0x4B`)، `0A4B 08C6 656e 444e 4100`.

- TAG (1) + Edge Id (2) + Subject (2) + Object (5) = 10 WORD و`LLLL=1001`. وTAG هو `1485`.

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## صفحات ذات صلة

- [Edge](/ar/grammar/edge/)، [LABEL](/ar/grammar/edge/label/)، [DESCRIPTION](/ar/grammar/edge/description/)، [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/)
