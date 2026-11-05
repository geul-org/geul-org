---
title: "IEEE-DECIMAL128-DPD"
weight: 1026
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-DPD هو Value يمثّل ترميز التبادل IEEE 754 decimal128 DPD."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-DPD هو Value يمثّل ترميز التبادل IEEE 754 decimal128 DPD. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x0000000D` IEEE، رقم Codec `0x00002002`، العائلة DECIMAL. يحفظ نمط bits الخاص بـ DPD كما هو ويميّزه عن BID.

## التخطيط {#레이아웃}

```
TAG WORD          0x09DC  الإجمالي 13 WORD
Issuer            2 WORD  0x0000000D (IEEE)
رقم Codec         2 WORD  0x00002002
Payload           8 WORD (128bit)  IEEE decimal128 DPD Interchange
```

## التفسير {#해석}

- يُقرأ Payload بوصل كل WORD فيه بدءًا من WORD الأعلى على أنه سلسلة bits لترميز التبادل IEEE 754 decimal128 DPD.
- يُحفظ نمط bits ولا يُعاد تفسيره اعتباطيًّا على أنه BID أو صيغة exact decimal.
- لا تُطبَّع القيم الخاصة ولا payload اعتباطيًّا.

## الصلاحية والطول {#유효성과-길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 8 WORD، أي 13 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1100`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 8 WORD بالضبط.
- الصلاحية الدلالية لسلسلة bits تتبع قواعد ترميز التبادل DPD في IEEE.

## مثال {#예시}

| البنية | الحكم |
|---|---|
| `09DC 0000 000D 0000 2002` + 8 WORD بتسلسل DPD | سليم |
| الإجمالي ليس 13 WORD (`LLLL=1100`) | invalid: لا يطابق عرض Payload الثابت |

## المرجع القياسي {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): يُطبَّق decimal coefficient encoding لصيغة تبادل decimal128. لا يُحوَّل عدديًّا إلى البديل BID الذي يجيزه IEEE، بل يُحفظ ترميز 128bit المختار كما هو، ولا يُضاف إلا TAG في GEUL وتأطير WORD من نوع big-endian.
