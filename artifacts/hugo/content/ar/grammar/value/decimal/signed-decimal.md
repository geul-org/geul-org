---
title: "SIGNED-DECIMAL"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL قيمة Value تحمل العدد العشري الدقيق C×10^E بأس E موقّع من 32bit ومعامل C بمتمم اثنين بأقل عدد من WORD."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SIGNED-DECIMAL قيمة Value لعدد عشري دقيق (exact decimal) ذي coefficient موقّع. الرمز المباشر في Value هو `0x10` والعائلة DECIMAL. أول 2 WORD في Payload هما exponent عشري `E` موقّع من 32bit، والباقي coefficient `C` بمتمم اثنين بأقل عدد من WORD، والقيمة `C×10^E`.

## التخطيط

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x10
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Payload WORD 1st–2nd (32 بت)        Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD فأكثر) Signed Two's-complement Coefficient C
```

## التفسير

- `E` عدد صحيح موقّع من 32bit بمتمم اثنين وبترتيب big-endian، يُكتب بدءاً من أعلى WORD.
- `C` عدد صحيح بمتمم اثنين بدقة اعتباطية، يتكوّن من وصل كل WORD المتبقية بدءاً من أعلى WORD.
- يتبع `C` قاعدة أقل عدد من WORD نفسها في [SIGNED-INTEGER](/ar/grammar/value/numeric/signed-integer/). يُحظر أي WORD بادئة `0000` أو `ffff` يمكن حذفها.

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
| Payload من 7 WORD | طول مباشر `LLLL=0111`، المجموع 8 WORD | بنية طول قياسية |

## وضع الصيغة

- هذا التخطيط الذي يجمع exponent `E` موقّعاً من 32 بت وcoefficient `C` بأقل عدد من WORD صيغة خاصة بـ GEUL، وليست تبادل IEEE 754 decimal ولا `DECIMAL` في Apache Parquet.
- يستخدم `DECIMAL` في Parquet القيمة `unscaledValue × 10^(-scale)` مع بيانات precision/scale الإلزامية، ويخزّن unscaled value في النوع الفيزيائي byte-array بمتمم اثنين big-endian، وscale فيه لا تقل عن 0. أما هذه الصيغة فتضع `E` موقّعاً في المتن وليس فيها بيانات precision، فهي ليست الصيغة نفسها.
- للتبادل مع IEEE 754 decimal أو `DECIMAL` في Parquet يلزم تحويل صريح يحدد سياسة النطاق وprecision/scale وquantum والقيم الخاصة.
- مراجع المقارنة: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/)، [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## مسائل مفتوحة

- توجد أزواج exponent/coefficient عدة تمثل العدد نفسه، مثل `10×10^-1` و`1×10^0`.
- لم يتقرر بعد هل تحافظ هذه الصيغة على quantum، وكيف يُحكم بتساوي القيمة، وكيف يُطبَّع canonical exponent.
- لذلك يجب ألا يفرض أي تنفيذ تعسفاً تطبيعاً لـ exponent/coefficient خارج قاعدة أقل عدد من WORD في coefficient.
