---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 שומר מספר רציונלי כשבר מצומצם של מונה int64 ומכנה int64 חיובי, בפורמט Issuer של ADHOC ברוחב קבוע של 11 WORD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 הוא Value שמייצג מספר רציונלי כשבר מצומצם של numerator מסוג int64 ב-big-endian ו-denominator מסוג int64. הוא Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x0702`, משפחה NUMERIC.

## פריסה

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  סך הכול 11 WORD
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## פירוש ותקינות

- כל int64 הוא מספר שלם ברוחב קבוע בשיטת המשלים ל-2 שמחוברים בו ה-WORD מה-WORD העליון, והערך הוא `numerator / denominator`.
- אין ABI padding.
- ה-Payload הוא בדיוק 8 WORD וה-denominator חייב להיות חיובי.
- מותרת רק הצורה המצומצמת `gcd(|numerator|, denominator) = 1`. את 0 כותבים רק כ-`0/1`.

## מעמד הפורמט

- שני int64, denominator חיובי, מחלק משותף מרבי 1 ונרמול של `0/1` הם פורמט ייחודי של GEUL ולא אימוץ של תקן wire חיצוני.
- הדף הזה מגדיר את הייצוג במלואו, כולל הפירוש של כל int64 בשיטת המשלים ל-2, סדר הרכיבים ו-framing של WORD ב-big-endian.

## אורך

- הסך הכול הוא בדיוק 11 WORD: TAG אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-Payload של 8 WORD, עם אורך ישיר `LLLL=1010`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## דוגמה

- numerator ‏`1` ו-denominator ‏`2` הם `1/2` תקין. `2/4`, ‏`0/2` ו-denominator ‏`-2` הם invalid.
