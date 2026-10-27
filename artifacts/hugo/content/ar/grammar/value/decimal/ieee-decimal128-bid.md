---
title: "IEEE-DECIMAL128-BID"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-BID قيمة Value ثابتة من 11 WORD تحمل سلسلة بتات التبادل IEEE 754 decimal128 BID كما هي."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-BID قيمة Value تمثل ترميز التبادل IEEE 754 decimal128 BID. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0040` IEEE، ورقم الصيغة `0x2005`، والعائلة DECIMAL. يحفظ نمط بتات BID كما هو ويميّزه عن DPD.

## التخطيط

```
TAG WORD          0x0D7C  المجموع 11 WORD
Issuer            1 WORD  0x0040 (IEEE)
رقم الصيغة        1 WORD  0x2005
Payload           8 WORD (128 بت)  IEEE decimal128 BID Interchange
```

## التفسير

- تُقرأ WORD الـ Payload الثماني موصولة بدءاً من أعلى WORD على أنها سلسلة بتات تبادل IEEE 754 decimal128 BID.
- يُحفظ نمط البتات، ولا يُعاد تفسيره تعسفاً كـ DPD أو كصيغة exact decimal.
- لا تُطبَّع القيم الخاصة ولا payload تعسفاً.

## الصلاحية والطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (8 WORD)، أي 11 WORD تماماً، ويُستخدم الطول المباشر `LLLL=1010`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 8 WORD تماماً.
- الصلاحية الدلالية لسلسلة البتات تتبع قواعد تبادل IEEE BID.

## أمثلة

| البنية | الحكم |
|---|---|
| `0D7C 0040 2005` + 8 WORD من سلسلة بتات BID | قياسي |
| المجموع ليس 11 WORD (`LLLL=1010`) | invalid: لا يطابق عرض Payload الثابت |

## السند المعياري

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): يُطبَّق ترميز BID الخاص بـ decimal128 interchange format (ترميز المعامل الثنائي). لا يُحوَّل رقمياً إلى البديل DPD الذي يسمح به IEEE، بل يُحفظ ترميز 128 بت المختار، ولا يُضاف سوى TAG في GEUL وframing بـ WORD بترتيب big-endian.
