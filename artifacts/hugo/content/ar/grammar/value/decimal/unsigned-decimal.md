---
title: "UNSIGNED-DECIMAL"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL قيمة Value تحمل العدد العشري الدقيق C×10^E بأس E موقّع من 32bit ومعامل C بلا إشارة بأقل عدد من WORD."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-DECIMAL قيمة Value لعدد عشري دقيق (exact decimal) ذي coefficient بلا إشارة. الرمز المباشر في Value هو `0x11` والعائلة DECIMAL. أول 2 WORD في Payload هما exponent عشري `E` موقّع من 32bit، والباقي coefficient `C` بلا إشارة بأقل عدد من WORD، والقيمة `C×10^E`.

## التخطيط

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x11
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Payload WORD 1st–2nd (32 بت)        Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD فأكثر) Unsigned Coefficient C
```

## التفسير

- `E` عدد صحيح موقّع من 32bit بمتمم اثنين وبترتيب big-endian، يُكتب بدءاً من أعلى WORD.
- `C` مقدار (magnitude) بلا إشارة بدقة اعتباطية، يُقرأ من كل WORD المتبقية بدءاً من أعلى WORD.
- يتبع `C` قاعدة أقل عدد من WORD نفسها في [UNSIGNED-INTEGER](/ar/grammar/value/numeric/unsigned-integer/). الصفر هو `0000`، ويُحظر أن تكون أول WORD هي `0000` عندما يبلغ العدد WORD 2 فأكثر.

## الطول والصلاحية

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويُحسب الـ TAG الممتد ضمن المجموع ([السجل وTAG WORD](/ar/grammar/record/)).
- Payload هو exponent (2 WORD) وcoefficient (1 WORD فأكثر)، فحده الأدنى 3 WORD.
- لا يُفحص في قياسية تمثيل البايتات إلا التمثيل الأدنى من WORD في coefficient.

## أمثلة

| تمثيل القيمة | Payload (`E` + `C`) | الحكم |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | تمثيل البايتات قياسي |
| `10×10^-1` | `ffff ffff 000a` | تمثيل البايتات قياسي، وعلاقته القياسية (canonical) بالتمثيل أعلاه مسألة مفتوحة |
| `1×10^0` | `0000 0000 0000 0001` | غير قياسي: `0000` البادئة في coefficient غير لازمة |
| coefficient سالب | لا ينطبق | invalid |

## وضع الصيغة

- هذا التخطيط الذي يجمع exponent `E` موقّعاً من 32 بت وcoefficient `C` بلا إشارة بأقل عدد من WORD صيغة خاصة بـ GEUL، وليست تبادل IEEE 754 decimal ولا `DECIMAL` في Apache Parquet.
- يستخدم `DECIMAL` في Parquet unscaled value موقّعاً و`unscaledValue × 10^(-scale)` وبيانات precision/scale الإلزامية، والنوع الفيزيائي byte-array فيه بمتمم اثنين big-endian وscale فيه لا تقل عن 0. أما هذه الصيغة فليست الصيغة نفسها بسبب `C` بلا إشارة و`E` موقّع وغياب بيانات precision.
- للتبادل مع IEEE 754 decimal أو `DECIMAL` في Parquet يلزم تحويل صريح يحدد سياسة الإشارة والنطاق وprecision/scale وquantum والقيم الخاصة.
- مراجع المقارنة: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/)، [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## مسائل مفتوحة

- توجد أزواج exponent/coefficient عدة تمثل العدد نفسه، مثل `10×10^-1` و`1×10^0`.
- لم يتقرر بعد هل تحافظ هذه الصيغة على quantum، وكيف يُحكم بتساوي القيمة، وكيف يُطبَّع canonical exponent.
- لذلك يجب ألا يفرض أي تنفيذ تعسفاً تطبيعاً لـ exponent/coefficient خارج قاعدة أقل عدد من WORD في coefficient.
