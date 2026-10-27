---
title: "Value — الأعداد"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "صيغ الأعداد الأساسية في عائلة NUMERIC (Codec `0x00`~`0x0F`): BOOL والأعداد الصحيحة والفاصلة العائمة IEEE 754 وإحداثيات الأرض والأجرام السماوية وQUANTITY المرفقة بوحدة."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

هذه صيغ الأعداد الأساسية في عائلة NUMERIC. توضع في الرموز المباشرة `0x00`~`0x0F` (أعلى 3 بتات من Codec هي `000`) وفي أرقام صيغ Issuer `0x0000`~`0x1FFF`.

- تشمل BOOL والأعداد الصحيحة الموقّعة وغير الموقّعة والفاصلة العائمة الثنائية IEEE 754 والإحداثيات على الأرض (WGS 84) وعلى الأجرام السماوية وQUANTITY التي تجمع الكمية والوحدة والحدود.
- تُكتب الأعداد الصحيحة بأقل عدد من WORD يتسع للقيمة.
- صيغ Issuer للكميات العددية الصغيرة (BFLOAT16 وFP8 وFP4) خُصصت لها أرقام صيغ فقط وليس لها مواصفة تفصيلية (مسألة مفتوحة في [Value](/ar/grammar/value/#مسائل-مفتوحة)).
- المتجهات والتنسورات والأعداد المركبة والكسور والفترات أيضاً من عائلة NUMERIC، لكنها صيغ Issuer فتوضع في الحزم [vector](/ar/grammar/value/vector/) و[tensor](/ar/grammar/value/tensor/) و[etc](/ar/grammar/value/etc/).
