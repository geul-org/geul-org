---
title: "QUATERNION-BINARY32"
weight: 1019
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 הוא Value המייצג quaternion בארבעה רכיבי IEEE 754 binary32 בסדר (x, y, z, w)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 הוא Value המייצג quaternion בארבעה רכיבי IEEE 754 binary32 בסדר `(x, y, z, w)`. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x00000704`, משפחה NUMERIC.

## פריסה {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD בסך הכול
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x00000704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## פירוש ותוקף {#해석과-유효성}

- כל רכיב הוא interchange bits של binary32 בסדר WORD של big-endian.
- frame, handedness, unit norm והשקילות `q/-q` הם הקשר חיצוני ואינם חלק מהמשמעות של הפורמט הזה.
- דפוסי הביטים של NaN payload ו-signed zero נשמרים. אין ABI padding.
- ה-Payload הוא בדיוק 8 WORD. הפורמט הזה אינו כופה unit norm או נרמול `q/-q`.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- הסדר `x, y, z, w` זהה לסדר רכיבי ה-quaternion ב-[glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) של Khronos, וכל רכיב הוא [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- ב-glTF, ה-rotation של node דורש unit quaternion ש-W בו הוא scalar. הפורמט הזה הוא quaternion כללי שאינו כופה unit norm או משמעות של rotation, ולכן אין לראות בו שווה ערך ל-rotation של glTF, אלא אם profile חיצוני מוסיף את התנאי הזה.

## אורך {#길이}

- הסך הכול הוא בדיוק 13 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 8 WORD, עם אורך ישיר `LLLL=1100`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## דוגמה {#예시}

- הרכיבים `(0.0, 0.0, 0.0, 1.0)` הם ערך תקף ששומר את ארבעת דפוסי הביטים לפי הסדר.
