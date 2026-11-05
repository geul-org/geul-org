---
title: "RATIONAL-I64"
weight: 1020
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 הוא Value המייצג מספר רציונלי כשבר מצומצם של numerator מסוג int64 ו-denominator מסוג int64 ב-big-endian."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 הוא Value המייצג מספר רציונלי כשבר מצומצם של numerator מסוג int64 ו-denominator מסוג int64 ב-big-endian. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x00000702`, משפחה NUMERIC.

## פריסה {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD בסך הכול
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x00000702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## פירוש ותוקף {#해석과-유효성}

- כל int64 הוא מספר שלם ברוחב קבוע בשיטת המשלים ל-2, המחובר מה-WORD העליון, והערך הוא `numerator / denominator`.
- אין ABI padding.
- ה-Payload הוא בדיוק 8 WORD, וה-denominator חייב להיות חיובי.
- מותרת רק צורה מצומצמת שבה `gcd(|numerator|, denominator) = 1`. את 0 כותבים רק כ-`0/1`.

## מעמד הפורמט {#형식-지위}

- שני int64, denominator חיובי, מחלק משותף מרבי 1 ונרמול `0/1` אינם אימוץ של תקן wire חיצוני, אלא פורמט ייחודי של GEUL.
- הדף הזה מגדיר את הייצוג במלואו, כולל הפירוש בשיטת המשלים ל-2 של כל int64, סדר הרכיבים ו-framing של WORD big-endian.

## אורך {#길이}

- הסך הכול הוא בדיוק 13 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 8 WORD, עם אורך ישיר `LLLL=1100`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## דוגמה {#예시}

- numerator ‏`1` ו-denominator ‏`2` הם `1/2` תקף. ‏`2/4`, ‏`0/2` ו-denominator ‏`-2` הם invalid.
