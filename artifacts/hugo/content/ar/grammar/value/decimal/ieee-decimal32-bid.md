---
title: "IEEE-DECIMAL32-BID"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-BID قيمة Value ثابتة من 5 WORD تحمل سلسلة بتات التبادل IEEE 754 decimal32 BID كما هي."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-BID قيمة Value تمثل ترميز التبادل IEEE 754 decimal32 BID. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0040` IEEE، ورقم الصيغة `0x2003`، والعائلة DECIMAL. يحفظ نمط بتات BID كما هو ويميّزه عن DPD.

## التخطيط

```
TAG WORD          0x0A7C  المجموع 5 WORD
Issuer            1 WORD  0x0040 (IEEE)
رقم الصيغة        1 WORD  0x2003
Payload           2 WORD (32 بت)  IEEE decimal32 BID Interchange
```

## التفسير

- تُقرأ WORD الـ Payload الاثنتان موصولة بدءاً من أعلى WORD على أنها سلسلة بتات تبادل IEEE 754 decimal32 BID.
- يُحفظ نمط البتات، ولا يُعاد تفسيره تعسفاً كـ DPD أو كصيغة SIGNED-DECIMAL.
- لا تُطبَّع القيم الخاصة ولا payload تعسفاً.

## الصلاحية والطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (2 WORD)، أي 5 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0100`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 2 WORD تماماً.
- الصلاحية الدلالية لسلسلة البتات تتبع قواعد تبادل IEEE BID.

## أمثلة

| البنية | الحكم |
|---|---|
| `0A7C 0040 2003` + 2 WORD من سلسلة بتات BID | بنية طول قياسية |
| `0A7C 0040 2003` + 4 WORD | invalid: عرض Payload غير مطابق |
| الرقم نفسه ذو 32 بت مع رقم الصيغة `0x2000` | صيغة DPD وليس هذا النوع |

## السند المعياري

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): يُطبَّق ترميز BID الخاص بـ decimal32 interchange format (ترميز المعامل الثنائي). لا يُحوَّل رقمياً إلى البديل DPD الذي يسمح به IEEE، بل يُحفظ ترميز 32 بت المختار، ولا يُضاف سوى TAG في GEUL وframing بـ WORD بترتيب big-endian.
