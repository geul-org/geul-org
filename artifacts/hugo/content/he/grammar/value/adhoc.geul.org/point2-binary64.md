---
title: "POINT2-BINARY64"
weight: 1017
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 היא נקודה דו-ממדית משני רכיבי IEEE 754 binary64 בסדר (x, y)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 היא נקודה דו-ממדית משני רכיבי IEEE 754 binary64 בסדר `(x, y)`.

## פריסה {#레이아웃}

- קוד: Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x0000050A`. משפחה NUMERIC.

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD בסך הכול
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x0000050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## כללי פירוש {#해석-규칙}

- כל רכיב נקרא מה-WORD העליון, ודפוסי הביטים של NaN payload ו-signed zero נשמרים.
- CRS, משמעות הצירים וסדרם והיחידה הם הקשר חיצוני. אין ABI padding.

## תקינות {#유효성}

- ה-Payload הוא בדיוק 8 WORD, וכל קטע של 4 WORD הוא interchange bits של binary64.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- סדר קואורדינטות `x, y` של הנקודה מתייחס ל-Point/WKB axis order ב-[GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) של OGC, וכל רכיב הוא לפי [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- ה-Payload הזה הוא compact profile של GEUL שאינו מכיל כותרת WKB type/byte-order או כותרת GeoPackage, והוא אינו ה-wire format של OGC WKB. CRS, משמעות הצירים והיחידה הם הקשר חיצוני.

## אורך {#길이}

- הסך הכול הוא בדיוק 13 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 8 WORD, עם אורך ישיר `LLLL=1100`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## דוגמה {#예시}

- ה-Payload ‏`3FF0 0000 0000 0000 4000 0000 0000 0000` הוא `(1.0, 2.0)`.
