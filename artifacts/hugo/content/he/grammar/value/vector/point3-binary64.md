---
title: "POINT3-BINARY64"
weight: 1012
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 הוא Value של נקודה תלת-ממדית משלושה רכיבי IEEE 754 binary64 בסדר (x, y, z) (פורמט Issuer 0x050B של ADHOC)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 היא נקודה תלת-ממדית משלושה רכיבי IEEE 754 binary64 בסדר `(x, y, z)`.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x050B`. משפחה NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG הרחבת Length  WORD אחד  0x0010 (16 WORD בסך הכול)
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## כללי פירוש

- כל רכיב נקרא מה-WORD העליון, ודפוס הביטים של NaN payload ו-signed zero נשמר.
- מערכת הקואורדינטות (CRS), משמעות הצירים וסדרם והיחידה הם הקשר חיצוני. אין ABI padding.

## תקינות

- ה-Payload הוא בדיוק 12 WORD, וכל קטע של 4 WORD הוא ביטי interchange של binary64.

## בסיס בתקנים ומעמד הפורמט

- סדר הקואורדינטות `x, y, z` של הנקודה מתייחס לסדר הצירים של Point/WKB ב-[GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) של OGC, וכל רכיב הוא לפי [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- ה-Payload הוא פרופיל compact של GEUL שאינו מכיל כותרת type/byte-order של WKB או כותרת GeoPackage, ואינו wire format של OGC WKB. מערכת הקואורדינטות, משמעות הצירים והיחידה הם הקשר חיצוני.

## אורך

- הסך הכול הוא בדיוק 16 WORD: TAG אחד, TAG הרחבת Length של WORD אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-Payload של 12 WORD, עם `LLLL=1110`. אין descriptor ו-padding.
- אם ה-Payload אינו בדיוק 12 WORD, דוחים.

## דוגמה

- אם שלושת ה-binary64 ב-Payload הם `1.0, 2.0, 3.0`, הנקודה היא `(1.0, 2.0, 3.0)`.
