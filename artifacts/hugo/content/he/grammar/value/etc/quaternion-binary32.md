---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 שומר קווטרניון מארבעה רכיבי binary32 בסדר (x, y, z, w), בפורמט Issuer של ADHOC ברוחב קבוע של 11 WORD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 הוא Value שמייצג קווטרניון (quaternion) מארבעה רכיבי IEEE 754 binary32 בסדר `(x, y, z, w)`. הוא Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x0704`, משפחה NUMERIC.

## פריסה

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  סך הכול 11 WORD
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## פירוש ותקינות

- כל רכיב הוא ביטי interchange של binary32 בסדר WORD של big-endian.
- frame, handedness, unit norm והשוויון `q/-q` הם הקשר חיצוני ואינם חלק ממשמעות הפורמט הזה.
- דפוס הביטים של NaN payload ו-signed zero נשמר, ואין ABI padding.
- ה-Payload הוא בדיוק 8 WORD. הפורמט הזה אינו כופה unit norm או נרמול `q/-q`.

## בסיס בתקנים ומעמד הפורמט

- הסדר `x, y, z, w` זהה לסדר רכיבי הקווטרניון ב-[glTF 2.0 specification/registry](https://registry.khronos.org/glTF/) של Khronos, וכל רכיב הוא [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- ה-rotation של node ב-glTF דורש unit quaternion ש-W הוא הסקלר בו. הפורמט הזה הוא קווטרניון כללי שאינו כופה unit norm או משמעות של rotation, ולכן אי אפשר לראות בו זהה ל-rotation של glTF אלא אם פרופיל חיצוני מוסיף את התנאי הזה.

## אורך

- הסך הכול הוא בדיוק 11 WORD: TAG אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-Payload של 8 WORD, עם אורך ישיר `LLLL=1010`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## דוגמה

- הרכיבים `(0.0, 0.0, 0.0, 1.0)` הם ערך תקף שבו ארבעת דפוסי הביטים נשמרים לפי הסדר.
