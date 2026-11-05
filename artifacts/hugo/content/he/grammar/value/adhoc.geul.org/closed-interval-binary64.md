---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 הוא Value המייצג קטע סגור בשתי נקודות קצה endpoint מסוג IEEE 754 binary64 בסדר (lower, upper)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 הוא Value המייצג קטע סגור בשתי נקודות קצה endpoint מסוג IEEE 754 binary64 בסדר `(lower, upper)`. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x00000703`, משפחה NUMERIC.

## פריסה {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD בסך הכול
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## פירוש ותוקף {#해석과-유효성}

- שתי נקודות הקצה הן binary64 בסדר WORD של big-endian, והקטע כולל את שני קצותיו.
- דפוס הביטים של signed zero בנקודת קצה תקפה נשמר כמות שהוא. אין ABI padding.
- ה-Payload הוא בדיוק 8 WORD, ו-`lower ≤ upper`.
- NaN אינו ניתן להשוואה, ולכן דוחים. גם endpoint אינסופי נדחה, כי הקטע אינו חסום.
- קטע ריק (empty), קטע לא חסום (unbounded), קטע פתוח (open interval) ו-NaI אינם ניתנים לייצוג בפורמט הזה, ולכן דוחים.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- הפורמט המספרי של נקודות הקצה הוא לפי [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), והמשמעות של זוג endpoint סגור מתייחסת למודל ה-interval של [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) ושל ה-simplified flavor, [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- הפורמט הזה הוא profile פשוט של GEUL המתיר רק קטעים סגורים סופיים שאינם ריקים. הוא אינו מממש ואינו מסריאל כמות שהם את decorations, NaI, קטעים ריקים או לא חסומים, או את מודל הפעולות וה-interchange המלא של IEEE 1788/1788.1.

## אורך {#길이}

- הסך הכול הוא בדיוק 13 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 8 WORD, עם אורך ישיר `LLLL=1100`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## דוגמה {#예시}

- נקודות הקצה `(1.0, 2.0)` הן `[1.0, 2.0]` ותקפות. `(2.0, 1.0)` ו-`(NaN, 1.0)` הן invalid.
