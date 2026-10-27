---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 صيغة Issuer من ADHOC ثابتة من 11 WORD تحمل عدداً نسبياً ككسر غير قابل للاختزال بسط int64 ومقام int64 موجب."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 قيمة Value تمثل عدداً نسبياً ككسر غير قابل للاختزال بسط (numerator) من big-endian int64 ومقام (denominator) من int64. هي Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0001` ADHOC، ورقم الصيغة `0x0702`، والعائلة NUMERIC.

## التخطيط

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  المجموع 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
رقم الصيغة        1 WORD  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## التفسير والصلاحية

- كل int64 عدد صحيح ثابت العرض بمتمم اثنين يتكوّن من وصل WORD بدءاً من أعلى WORD، والقيمة `numerator / denominator`.
- لا يوجد ABI padding.
- Payload هو 8 WORD تماماً ويجب أن يكون denominator موجباً.
- لا يُسمح إلا بالصورة غير القابلة للاختزال أي `gcd(|numerator|, denominator) = 1`. الصفر يُكتب `0/1` فقط.

## وضع الصيغة

- int64 للبسط والمقام، والمقام الموجب، والقاسم المشترك الأكبر 1، وتوحيد `0/1` (canonicalization) ليست تبنياً لمعيار wire خارجي بل صيغة خاصة بـ GEUL.
- هذه الصفحة تعرّف التمثيل تعريفاً كاملاً، بما فيه تفسير كل int64 بمتمم اثنين وترتيب المكوّنات وframing بـ WORD وفق big-endian.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (8 WORD)، أي 11 WORD تماماً، ويُستخدم الطول المباشر `LLLL=1010`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 8 WORD تماماً.

## أمثلة

- البسط `1` والمقام `2` هو `1/2` الصالح. أما `2/4` و`0/2` والمقام `-2` فهي invalid.
