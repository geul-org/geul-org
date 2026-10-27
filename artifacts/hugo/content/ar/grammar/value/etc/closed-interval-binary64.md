---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 صيغة Issuer من ADHOC ثابتة من 11 WORD تحمل فترة مغلقة منتهية وغير فارغة بحدّ أدنى وحدّ أعلى من binary64."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 قيمة Value تمثل فترة مغلقة بنقطتَي نهاية من IEEE 754 binary64 بترتيب `(lower, upper)`. هي Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0703`، والعائلة NUMERIC.

## التخطيط

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  المجموع 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## التفسير والصلاحية

- نقطتا النهاية من binary64 بترتيب WORD وفق big-endian، وتُضمّان الطرفين في الفترة.
- يُحفظ نمط البتات لـ signed zero في نقطة نهاية صالحة كما هو. لا يوجد ABI padding.
- Payload هو 8 WORD تماماً ويجب أن يكون `lower ≤ upper`.
- NaN غير قابلة للمقارنة فتُرفض. وتُرفض نقطة نهاية infinity أيضاً لأنها فترة غير محدودة (unbounded).
- الفترات الفارغة (empty) وغير المحدودة (unbounded) والمفتوحة (open) وNaI لا يمكن تمثيلها بهذه الصيغة وتُرفض.

## السند المعياري ووضع الصيغة

- الصيغة العددية لنقطة النهاية تتبع [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/)، ومعنى زوج نقطتَي النهاية المغلق يرجع إلى نموذج الفترات في [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) والنكهة المبسطة [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- هذه الصيغة profile مبسط في GEUL لا يسمح إلا بالفترات المغلقة المنتهية غير الفارغة. لا تنفّذ decorations ولا NaI ولا الفترات الفارغة/غير المحدودة ولا النموذج الكامل للعمليات والتبادل في IEEE 1788/1788.1، ولا تسلسلها كما هي.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (8 WORD)، أي 11 WORD تماماً، ويُستخدم الطول المباشر `LLLL=1010`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 8 WORD تماماً.

## أمثلة

- نقطتا النهاية `(1.0, 2.0)` تعنيان `[1.0, 2.0]` وهما صالحتان. أما `(2.0, 1.0)` و`(NaN, 1.0)` فهما invalid.
