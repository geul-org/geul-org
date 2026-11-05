---
title: "BBOX2-BINARY64"
weight: 1000
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 היא תיבה תוחמת דו-ממדית מארבעה רכיבי IEEE 754 binary64 בסדר (minX, minY, maxX, maxY)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 היא תיבה תוחמת דו-ממדית מארבעה רכיבי IEEE 754 binary64 בסדר `(minX, minY, maxX, maxY)`.

## פריסה {#레이아웃}

- קוד: Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x0000050C`. משפחה NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG הרחבת Length  1 WORD  0x0016 (22 WORD בסך הכול)
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x0000050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## כללי פירוש {#해석-규칙}

- כל רכיב הוא binary64 ונקרא מה-WORD העליון. דפוס הביטים של signed zero נשמר.
- CRS, משמעות הצירים וסדרם והיחידה הם הקשר חיצוני. אין ABI padding.

## תקינות {#유효성}

- ה-Payload חייב להיות בדיוק 16 WORD, ו-`minX ≤ maxX` ו-`minY ≤ maxY`.
- NaN אינו ניתן להשוואה, ולכן אם הוא קיים בכל אחד מהרכיבים, דוחים.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- משמעות הקואורדינטות המינימליות והמרביות מתייחסת ל-bounding envelope ב-[GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) של OGC, וכל רכיב הוא לפי [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- סדר המערך הדו-ממדי של envelope ב-GeoPackage הוא `[minx, maxx, miny, maxy]`. הסדר `(minX, minY, maxX, maxY)` בפורמט הזה אינו סדר ה-wire הזה אלא tuple compact ש-GEUL קבעה, והוא גם אינו מכיל כותרת WKB/GeoPackage. CRS, משמעות הצירים והיחידה הם הקשר חיצוני.

## אורך {#길이}

- הסך הכול הוא בדיוק 22 WORD: TAG של WORD אחד, TAG הרחבת Length של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 16 WORD, עם `LLLL=1110`. אין descriptor ו-padding.
- אם ה-Payload אינו בדיוק 16 WORD, דוחים.

## דוגמה {#예시}

- אם הרכיבים הם `(0.0, 1.0, 2.0, 3.0)`, התיבה תקפה, ואם `(2.0, 1.0, 0.0, 3.0)`, היא invalid.
