---
title: "SHA-256-DIGEST"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST הוא Value ברוחב קבוע של 18 WORD שמכיל את כל 256 הביטים של תוצאת SHA-256."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-256-DIGEST הוא Value ברוחב קבוע שמכיל את כל תוצאת SHA-256 ממשפחת SHA-2. הוא Value עם קוד ישיר `0x61`, משפחה BINARY. ה-Payload הוא בדיוק 16 WORD (256 ביט), וקיצוץ (truncation) אינו מותר.

## פריסה

```
TAG WORD          0x0F61 (0000 1111 0110 0001)  LLLL=1110
TAG הרחבת Length  1 WORD  0x0012 (18 WORD בסך הכול)
Payload           16 WORD  SHA-256 Digest
```

## פרשנות ותקינות

- 32 ה-octet של ה-Payload נקראים בסדר הפלט של SHA-256. בכל WORD ה-octet העליון בא ראשון.
- לא מופעלת על ה-digest bit string המרת endian נפרדת של GEUL. רצף ה-octet של הפלט רק מקובץ לפי הסדר לזוגות ומוגש כ-WORD של 16 ביט ב-big-endian.
- ייצוג שבו ה-Payload אינו 16 WORD, או שהתוצאה קוצצה באופן שרירותי, נדחה. אין descriptor ואין padding.

## בסיס בתקנים

- אלגוריתם SHA-256 והתוצאה בת 256 הביט נקבעים לפי NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL TAG, Length ו-framing של WORD בן 16 ביט הם כללים שהפורמט הזה מוסיף, ואינם חלק מאלגוריתם SHA-2.

## אורך

- האורך הכולל הוא בדיוק 18 WORD: TAG אחד, TAG הרחבת Length אחד ו-16 WORD של Payload, עם `LLLL=1110`. אין descriptor ואין padding.
- אם ה-Payload אינו בדיוק 16 WORD, הרשומה נדחית.

## דוגמה

- ה-octet של ה-digest `d[0]` עד `d[31]` ממוקמים לפי הסדר ב-Payload WORD, מ-`(d[0]<<8)|d[1]` עד `(d[30]<<8)|d[31]`. ה-Length הכולל הוא תמיד 18 WORD.
