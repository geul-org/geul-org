---
title: "Value — الزمن"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "صيغ التاريخ والوقت في عائلة TIME (Codec `0x20`~`0x3F`، أرقام الصيغ `0x4000`~`0x7FFF`): التاريخ الميلادي والطوابع الزمنية والزمن المنقضي وEDTF وتاريخ GEDCOM."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

عائلة TIME هي صيغ التاريخ والوقت. توضع في الرموز المباشرة `0x20`~`0x3F` وفي أرقام صيغ Issuer `0x4000`~`0x7FFF`.

| الدقة | الصيغة |
|---|---|
| تاريخ (التقويم الميلادي) | GREGORIAN-DATE |
| السنة والشهر، عدم اليقين، الفترة | EDTF |
| الكتابة الأصلية في تقويم آخر (اليولياني وغيره) | GEDCOM-DATE |
| الوقت | الطوابع الزمنية POSIX وTAI وGPS |
| الزمن المنقضي | DURATION-SECONDS, DURATION-NANOSECONDS |

- التاريخ الذي يمكن كتابته بـ GREGORIAN-DATE لا يُكتب بـ EDTF.
- الطوابع الزمنية بالنانوثانية وصيغ TAI وGPS هي صيغ تحت Issuer الخاص بكل جهة معيارية (IEEE وBIPM وGPS).
