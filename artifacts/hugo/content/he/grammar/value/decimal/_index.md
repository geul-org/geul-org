---
title: "Value — עשרוני"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "הפורמטים העשרוניים המדויקים של משפחת DECIMAL (Codec `0x10`–`0x1F`, מספרי פורמט `0x2000`–`0x3FFF`): SIGNED-DECIMAL ו-UNSIGNED-DECIMAL, ו-IEEE 754 decimal32/64/128."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

משפחת DECIMAL היא משפחת פורמטים של מספרים עשרוניים מדויקים. היא יושבת בקודים ישירים `0x10`–`0x1F` (שלושת הביטים העליונים של ה-Codec הם `001`) ובמספרי פורמט של Issuer `0x2000`–`0x3FFF`.

- הקודים הישירים SIGNED-DECIMAL ו-UNSIGNED-DECIMAL נכתבים כ-`C × 10^E` ושומרים את מספר הספרות של הכתיב המקורי כמות שהוא. `1.20` (`C=120, E=−2`) ו-`1.2` (`C=12, E=−1`) הן רשומות שונות. שוויון ערכים ושימור quantum הם שאלה פתוחה של [SIGNED-DECIMAL](/he/grammar/value/decimal/signed-decimal/#שאלות-פתוחות).
- קידודי DPD ו-BID של IEEE 754 decimal32/64/128 הם פורמטים של Issuer מסוג IEEE (`0x0040`).
