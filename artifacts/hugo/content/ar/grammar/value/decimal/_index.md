---
title: "Value — الأعداد العشرية"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "عائلة DECIMAL (Codec `0x10`~`0x1F`، أرقام الصيغ `0x2000`~`0x3FFF`) هي صيغ الأعداد العشرية الدقيقة: SIGNED-DECIMAL وUNSIGNED-DECIMAL وIEEE 754 decimal32/64/128."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

عائلة DECIMAL هي صيغ الأعداد العشرية الدقيقة. توضع في الرموز المباشرة `0x10`~`0x1F` (أعلى 3 بتات من Codec هي `001`) وفي أرقام صيغ Issuer `0x2000`~`0x3FFF`.

- الرمزان المباشران SIGNED-DECIMAL وUNSIGNED-DECIMAL يكتبان `C × 10^E` ويحملان خانات الكتابة الأصلية كما هي. `1.20` (`C=120, E=−2`) و`1.2` (`C=12, E=−1`) سجلان مختلفان. تساوي القيمة والحفاظ على quantum من المسائل المفتوحة في [SIGNED-DECIMAL](/ar/grammar/value/decimal/signed-decimal/#مسائل-مفتوحة).
- ترميزات DPD وBID في IEEE 754 decimal32/64/128 هي صيغ Issuer الخاصة بـ IEEE (`0x0040`).
