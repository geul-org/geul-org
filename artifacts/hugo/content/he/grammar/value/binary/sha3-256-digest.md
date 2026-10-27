---
title: "SHA3-256-DIGEST"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST הוא פורמט Issuer של NIST ברוחב קבוע של 20 WORD שמכיל את כל 256 הביטים של תוצאת SHA3-256."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST הוא Value ברוחב קבוע שמכיל את כל תוצאת SHA3-256. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, מספר פורמט `0xC001`, משפחה BINARY. ה-Payload הוא בדיוק 16 WORD (256 ביט), וקיצוץ (truncation) אינו מותר.

## פריסה

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG הרחבת Length  1 WORD  0x0014 (20 WORD בסך הכול)
Issuer            1 WORD  0x0062 (NIST)
מספר פורמט        1 WORD  0xC001
Payload           16 WORD  SHA3-256 Digest
```

## פרשנות ותקינות

- 32 ה-octet של ה-Payload נקראים בסדר הפלט של SHA3-256. בכל WORD ה-octet העליון בא ראשון.
- לא מופעלת על ה-digest bit string המרת endian נפרדת של GEUL. רצף ה-octet של הפלט רק מקובץ לפי הסדר לזוגות ומוגש כ-WORD של 16 ביט ב-big-endian.
- ייצוג שבו ה-Payload אינו 16 WORD, או שהתוצאה קוצצה באופן שרירותי, נדחה. אין descriptor ואין padding.

## בסיס בתקנים

- אלגוריתם SHA3-256 והתוצאה בת 256 הביט נקבעים לפי NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). גם [פרויקט Hash Functions](https://csrc.nist.gov/Projects/hash-functions) של NIST מפנה לתקן SHA-3.
- GEUL TAG, Length ו-framing של WORD בן 16 ביט הם כללים שהפורמט הזה מוסיף, ואינם חלק מאלגוריתם SHA-3.

## אורך

- האורך הכולל הוא בדיוק 20 WORD: TAG אחד, TAG הרחבת Length אחד, Issuer אחד, מספר פורמט אחד ו-16 WORD של Payload, עם `LLLL=1110`. אין descriptor ואין padding.
- אם ה-Payload אינו בדיוק 16 WORD, הרשומה נדחית.

## דוגמה

- ה-octet של ה-digest `d[0]` עד `d[31]` ממוקמים ב-16 ה-Payload WORD לפי סדר הפלט, שני octet בכל WORD. ה-Length הכולל הוא תמיד 20 WORD.
