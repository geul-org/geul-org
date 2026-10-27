---
title: "IEEE-DECIMAL128-DPD"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-DPD قيمة Value ثابتة من 11 WORD تحمل سلسلة بتات التبادل IEEE 754 decimal128 DPD كما هي."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-DPD قيمة Value تمثل ترميز التبادل IEEE 754 decimal128 DPD. هو Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0040` IEEE، ورقم الصيغة `0x2002`، والعائلة DECIMAL. يحفظ نمط بتات DPD كما هو ويميّزه عن BID.

## التخطيط

```
TAG WORD          0x0D7C  المجموع 11 WORD
Issuer            1 WORD  0x0040 (IEEE)
رقم الصيغة        1 WORD  0x2002
Payload           8 WORD (128 بت)  IEEE decimal128 DPD Interchange
```

## التفسير

- تُقرأ WORD الـ Payload الثماني موصولة بدءاً من أعلى WORD على أنها سلسلة بتات تبادل IEEE 754 decimal128 DPD.
- يُحفظ نمط البتات، ولا يُعاد تفسيره تعسفاً كـ BID أو كصيغة exact decimal.
- لا تُطبَّع القيم الخاصة ولا payload تعسفاً.

## الصلاحية والطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (8 WORD)، أي 11 WORD تماماً، ويُستخدم الطول المباشر `LLLL=1010`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 8 WORD تماماً.
- الصلاحية الدلالية لسلسلة البتات تتبع قواعد تبادل IEEE DPD.

## أمثلة

| البنية | الحكم |
|---|---|
| `0D7C 0040 2002` + 8 WORD من سلسلة بتات DPD | قياسي |
| المجموع ليس 11 WORD (`LLLL=1010`) | invalid: لا يطابق عرض Payload الثابت |

## السند المعياري

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): يُطبَّق ترميز DPD الخاص بـ decimal128 interchange format (ترميز المعامل العشري). لا يُحوَّل رقمياً إلى البديل BID الذي يسمح به IEEE، بل يُحفظ ترميز 128 بت المختار، ولا يُضاف سوى TAG في GEUL وframing بـ WORD بترتيب big-endian.
