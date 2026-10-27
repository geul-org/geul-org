---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 הוא Value של תיבה תוחמת דו-ממדית מארבעה רכיבי IEEE 754 binary64 בסדר (minX, minY, maxX, maxY) (פורמט Issuer 0x050C של ADHOC)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 היא תיבה תוחמת דו-ממדית מארבעה רכיבי IEEE 754 binary64 בסדר `(minX, minY, maxX, maxY)`.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x050C`. משפחה NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG הרחבת Length  WORD אחד  0x0014 (20 WORD בסך הכול)
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## כללי פירוש

- כל רכיב הוא binary64 ונקרא מה-WORD העליון. דפוס הביטים של signed zero נשמר.
- מערכת הקואורדינטות (CRS), משמעות הצירים וסדרם והיחידה הם הקשר חיצוני. אין ABI padding.

## תקינות

- ה-Payload חייב להיות בדיוק 16 WORD, ו-`minX ≤ maxX` ו-`minY ≤ maxY`.
- NaN אינו ניתן להשוואה, ולכן אם הוא קיים באחד הרכיבים, דוחים.

## בסיס בתקנים ומעמד הפורמט

- משמעות הקואורדינטות המינימליות והמרביות מתייחסת ל-bounding envelope ב-[GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) של OGC, וכל רכיב הוא לפי [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- סדר המערך הדו-ממדי של envelope ב-GeoPackage הוא `[minx, maxx, miny, maxy]`. הסדר `(minX, minY, maxX, maxY)` בפורמט הזה אינו סדר ה-wire הזה אלא tuple compact ש-GEUL קבעה, והוא גם אינו מכיל כותרת WKB/GeoPackage. מערכת הקואורדינטות, משמעות הצירים והיחידה הם הקשר חיצוני.

## אורך

- הסך הכול הוא בדיוק 20 WORD: TAG אחד, TAG הרחבת Length של WORD אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-Payload של 16 WORD, עם `LLLL=1110`. אין descriptor ו-padding.
- אם ה-Payload אינו בדיוק 16 WORD, דוחים.

## דוגמה

- אם הרכיבים הם `(0.0, 1.0, 2.0, 3.0)`, התיבה תקפה, ואם `(2.0, 1.0, 0.0, 3.0)`, היא invalid.
