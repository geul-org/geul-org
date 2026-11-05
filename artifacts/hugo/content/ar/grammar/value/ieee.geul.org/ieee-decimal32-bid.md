---
title: "IEEE-DECIMAL32-BID"
weight: 1027
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-BID هو Value يمثّل ترميز التبادل IEEE 754 decimal32 BID."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-BID هو Value يمثّل ترميز التبادل IEEE 754 decimal32 BID. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x0000000D` IEEE، رقم Codec `0x00002003`، العائلة DECIMAL. يحفظ نمط bits الخاص بـ BID كما هو ويميّزه عن DPD.

## التخطيط {#레이아웃}

```
TAG WORD          0x09D6  الإجمالي 7 WORD
Issuer            2 WORD  0x0000000D (IEEE)
رقم Codec         2 WORD  0x00002003
Payload           2 WORD (32bit)  IEEE decimal32 BID Interchange
```

## التفسير {#해석}

- يُقرأ Payload بوصل كل WORD فيه بدءًا من WORD الأعلى على أنه سلسلة bits لترميز التبادل IEEE 754 decimal32 BID.
- يُحفظ نمط bits ولا يُعاد تفسيره اعتباطيًّا على أنه DPD أو SIGNED-DECIMAL.
- لا تُطبَّع القيم الخاصة ولا payload اعتباطيًّا.

## الصلاحية والطول {#유효성과-길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 2 WORD، أي 7 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=0110`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 2 WORD بالضبط.
- الصلاحية الدلالية لسلسلة bits تتبع قواعد ترميز التبادل BID في IEEE.

## مثال {#예시}

| البنية | الحكم |
|---|---|
| `09D6 0000 000D 0000 2003` + 2 WORD بتسلسل bits من نوع BID | بنية بطول معياري |
| `09D6 0000 000D 0000 2003` + 4 WORD | invalid: عرض Payload غير مطابق |
| نفس الـ 32bit مع رقم Codec `0x00002000` | صيغة DPD وليست هذا النوع |

## المرجع القياسي {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): يُطبَّق binary coefficient encoding لصيغة تبادل decimal32. لا يُحوَّل عدديًّا إلى البديل DPD الذي يجيزه IEEE، بل يُحفظ ترميز 32bit المختار كما هو، ولا يُضاف إلا TAG في GEUL وتأطير WORD من نوع big-endian.
