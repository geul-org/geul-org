---
title: "RATIONAL-I64"
weight: 1020
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 هو Value يمثّل عددًا نسبيًّا ككسر غير قابل للاختزال من numerator وdenominator كلٌّ منهما int64 بترتيب big-endian."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 هو Value يمثّل عددًا نسبيًّا ككسر غير قابل للاختزال من numerator وdenominator كلٌّ منهما int64 بترتيب big-endian. Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x00000002` ADHOC، رقم Codec `0x00000702`، العائلة NUMERIC.

## التخطيط {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  الإجمالي 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
رقم Codec         2 WORD  0x00000702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## التفسير والصلاحية {#해석과-유효성}

- كل int64 هو عدد صحيح ثابت العرض بمتمم الاثنين (two's complement) يُركَّب بوصل WORD بدءًا من الأعلى، والقيمة هي `numerator / denominator`.
- لا يوجد ABI padding.
- Payload هو 8 WORD بالضبط ويجب أن يكون denominator موجبًا.
- لا يُسمح إلا بالصورة غير القابلة للاختزال حيث `gcd(|numerator|, denominator) = 1`. ويُكتب الصفر دائمًا `0/1` فقط.

## المرتبة الشكلية {#형식-지위}

- int64 اثنان، وdenominator موجب، وأكبر قاسم مشترك 1، وتوحيد الصورة القانونية `0/1` (canonicalization)، كلها خاصة بـ GEUL وليست اعتمادًا لمعيار wire خارجي.
- تعرّف هذه الصفحة التمثيل تعريفًا كاملًا، بما في ذلك تفسير كل int64 بمتمم الاثنين وترتيب المكوّنين وتأطير WORD من نوع big-endian.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 8 WORD، أي 13 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=1100`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 8 WORD بالضبط.

## مثال {#예시}

- numerator `1` وdenominator `2` هو `1/2` الصالح. أما `2/4` و`0/2` وdenominator `-2` فغير صالحة (invalid).
