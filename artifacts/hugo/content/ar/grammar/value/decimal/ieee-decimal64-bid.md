---
title: "IEEE-DECIMAL64-BID"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-BID قيمة Value ثابتة من 7 WORD تحمل سلسلة بتات التبادل IEEE 754 decimal64 BID كما هي."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-BID قيمة Value تمثل ترميز التبادل IEEE 754 decimal64 BID. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0040` IEEE، ورقم الصيغة `0x2004`، والعائلة DECIMAL. يحفظ نمط بتات BID كما هو ويميّزه عن DPD.

## التخطيط

```
TAG WORD          0x0B7C  المجموع 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
رقم الصيغة        1 WORD  0x2004
Payload           4 WORD (64 بت)  IEEE decimal64 BID Interchange
```

## التفسير

- تُقرأ WORD الـ Payload الأربع موصولة بدءاً من أعلى WORD على أنها سلسلة بتات تبادل IEEE 754 decimal64 BID.
- يُحفظ نمط البتات، ولا يُعاد تفسيره تعسفاً كـ DPD أو كصيغة exact decimal.
- لا تُطبَّع القيم الخاصة ولا payload تعسفاً.

## الصلاحية والطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (4 WORD)، أي 7 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0110`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 4 WORD تماماً.
- الصلاحية الدلالية لسلسلة البتات تتبع قواعد تبادل IEEE BID.

## أمثلة

| البنية | الحكم |
|---|---|
| `0B7C 0040 2004` + 4 WORD من سلسلة بتات BID | بنية طول قياسية |
| `0B7C 0040 2004` + 2 WORD | invalid: عرض Payload غير مطابق |
| الرقم نفسه ذو 64 بت مع رقم الصيغة `0x2001` | صيغة DPD وليس هذا النوع |

## السند المعياري

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): يُطبَّق ترميز BID الخاص بـ decimal64 interchange format (ترميز المعامل الثنائي). لا يُحوَّل رقمياً إلى البديل DPD الذي يسمح به IEEE، بل يُحفظ ترميز 64 بت المختار، ولا يُضاف سوى TAG في GEUL وframing بـ WORD بترتيب big-endian.
