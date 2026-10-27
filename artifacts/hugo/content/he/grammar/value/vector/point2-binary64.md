---
title: "POINT2-BINARY64"
weight: 1011
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 הוא Value של נקודה דו-ממדית משני רכיבי IEEE 754 binary64 בסדר (x, y) (פורמט Issuer 0x050A של ADHOC)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 היא נקודה דו-ממדית משני רכיבי IEEE 754 binary64 בסדר `(x, y)`.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x050A`. משפחה NUMERIC.

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  סך הכול 11 WORD
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## כללי פירוש

- כל רכיב נקרא מה-WORD העליון, ודפוס הביטים של NaN payload ו-signed zero נשמר.
- מערכת הקואורדינטות (CRS), משמעות הצירים וסדרם והיחידה הם הקשר חיצוני. אין ABI padding.

## תקינות

- ה-Payload הוא בדיוק 8 WORD, וכל קטע של 4 WORD הוא ביטי interchange של binary64.

## בסיס בתקנים ומעמד הפורמט

- סדר הקואורדינטות `x, y` של הנקודה מתייחס לסדר הצירים של Point/WKB ב-[GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) של OGC, וכל רכיב הוא לפי [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- ה-Payload הוא פרופיל compact של GEUL שאינו מכיל כותרת type/byte-order של WKB או כותרת GeoPackage, ואינו wire format של OGC WKB. מערכת הקואורדינטות, משמעות הצירים והיחידה הם הקשר חיצוני.

## אורך

- הסך הכול הוא בדיוק 11 WORD: TAG אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-Payload של 8 WORD, עם אורך ישיר `LLLL=1010`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## דוגמה

- ה-Payload ‏`3ff0 0000 0000 0000 4000 0000 0000 0000` הוא `(1.0, 2.0)`.
