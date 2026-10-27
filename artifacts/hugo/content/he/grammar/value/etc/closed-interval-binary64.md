---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 שומר קטע סגור סופי ולא ריק בגבול תחתון ועליון של binary64, בפורמט Issuer של ADHOC ברוחב קבוע של 11 WORD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 הוא Value שמייצג קטע סגור באמצעות שתי נקודות קצה של IEEE 754 binary64 בסדר `(lower, upper)`. הוא Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x0703`, משפחה NUMERIC.

## פריסה

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  סך הכול 11 WORD
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x0703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## פירוש ותקינות

- שתי נקודות הקצה הן binary64 בסדר WORD של big-endian, והקטע כולל את שני הקצוות.
- דפוס הביטים של signed zero בנקודת קצה תקפה נשמר כמות שהוא. אין ABI padding.
- ה-Payload הוא בדיוק 8 WORD וחייב להתקיים `lower ≤ upper`.
- NaN אינו ניתן להשוואה ולכן נדחה. גם נקודת קצה של infinity נדחית, כי הקטע אינו חסום.
- קטע ריק, קטע לא חסום, קטע פתוח ו-NaI אי אפשר לבטא בפורמט הזה, ודוחים אותם.

## בסיס בתקנים ומעמד הפורמט

- הפורמט המספרי של נקודות הקצה הוא לפי [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), והמשמעות של זוג נקודות קצה סגור מתייחסת למודל הקטעים של [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) ושל הטעם הפשוט שלו, [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- הפורמט הזה הוא פרופיל GEUL פשוט שמתיר רק קטעים סגורים, סופיים ולא ריקים. הוא אינו מממש ואינו מסריאל כמות שהוא decorations, NaI, קטע ריק או לא חסום, או את מודל הפעולות וה-interchange המלא של IEEE 1788/1788.1.

## אורך

- הסך הכול הוא בדיוק 11 WORD: TAG אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-Payload של 8 WORD, עם אורך ישיר `LLLL=1010`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## דוגמה

- נקודות הקצה `(1.0, 2.0)` הן `[1.0, 2.0]` ותקפות. `(2.0, 1.0)` ו-`(NaN, 1.0)` הם invalid.
