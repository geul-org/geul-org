---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 هو Value يمثّل فترة مغلقة بنقطتَي نهاية IEEE 754 binary64 بالترتيب (lower, upper)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 هو Value يمثّل فترة مغلقة بنقطتَي نهاية IEEE 754 binary64 بالترتيب `(lower, upper)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x00000703`، العائلة NUMERIC.

## التخطيط {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  الإجمالي 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## التفسير والصلاحية {#해석과-유효성}

- نقطتا النهاية binary64 بترتيب WORD من نوع big-endian، وكلتاهما مشمولة في الفترة.
- يُحفظ نمط bits الخاص بالصفر ذي الإشارة (signed zero) في نقطة النهاية الصالحة كما هو. لا يوجد ABI padding.
- يجب أن يكون Payload بالضبط 8 WORD وأن يتحقق `lower ≤ upper`.
- لا يمكن مقارنة NaN، لذا يُرفض. وتُرفض كذلك نقطة النهاية اللانهائية (infinity) لأن الفترة حينئذ غير محدودة (unbounded).
- لا يمكن تمثيل الفترة الفارغة (empty) ولا غير المحدودة (unbounded) ولا المفتوحة (open interval) ولا NaI بهذه الصيغة، وتُرفض.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- صيغة نقطتَي النهاية العددية تتبع [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/)، ومعنى زوج نقطتَي النهاية المغلق مستمد من نموذج الفترات في [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) ومن flavor المبسَّطة [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- هذه الصيغة profile مبسَّط في GEUL لا يسمح إلا بالفترات المغلقة المنتهية وغير الفارغة. فهي لا تنفّذ decorations ولا NaI ولا الفترات الفارغة/غير المحدودة ولا نموذج العمليات والتبادل (interchange) الكامل في IEEE 1788/1788.1، ولا تسلسلها كما هي.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 8 WORD، أي 13 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1100`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 8 WORD بالضبط.

## مثال {#예시}

- نقطتا النهاية `(1.0, 2.0)` تمثّلان `[1.0, 2.0]` وهي صالحة. أما `(2.0, 1.0)` و`(NaN, 1.0)` فغير صالحتين (invalid).
