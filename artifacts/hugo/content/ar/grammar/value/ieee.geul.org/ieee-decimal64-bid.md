---
title: "IEEE-DECIMAL64-BID"
weight: 1029
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-BID هو Value يمثّل ترميز التبادل IEEE 754 decimal64 BID."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-BID هو Value يمثّل ترميز التبادل IEEE 754 decimal64 BID. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x0000000D` IEEE، رقم Codec `0x00002004`، العائلة DECIMAL. يحفظ نمط bits الخاص بـ BID كما هو ويميّزه عن DPD.

## التخطيط {#레이아웃}

```
TAG WORD          0x09D8  الإجمالي 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
رقم Codec         2 WORD  0x00002004
Payload           4 WORD (64bit)  IEEE decimal64 BID Interchange
```

## التفسير {#해석}

- يُقرأ Payload بوصل كل WORD فيه بدءًا من WORD الأعلى على أنه سلسلة bits لترميز التبادل IEEE 754 decimal64 BID.
- يُحفظ نمط bits ولا يُعاد تفسيره اعتباطيًّا على أنه DPD أو صيغة exact decimal.
- لا تُطبَّع القيم الخاصة ولا payload اعتباطيًّا.

## الصلاحية والطول {#유효성과-길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 4 WORD، أي 9 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1000`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 4 WORD بالضبط.
- الصلاحية الدلالية لسلسلة bits تتبع قواعد ترميز التبادل BID في IEEE.

## مثال {#예시}

| البنية | الحكم |
|---|---|
| `09D8 0000 000D 0000 2004` + 4 WORD بتسلسل bits من نوع BID | بنية بطول معياري |
| `09D8 0000 000D 0000 2004` + 2 WORD | invalid: عرض Payload غير مطابق |
| نفس الـ 64bit مع رقم Codec `0x00002001` | صيغة DPD وليست هذا النوع |

## المرجع القياسي {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): يُطبَّق binary coefficient encoding لصيغة تبادل decimal64. لا يُحوَّل عدديًّا إلى البديل DPD الذي يجيزه IEEE، بل يُحفظ ترميز 64bit المختار كما هو، ولا يُضاف إلا TAG في GEUL وتأطير WORD من نوع big-endian.
