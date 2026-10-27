---
title: "SHA-512-DIGEST"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST הוא פורמט Issuer של NIST ברוחב קבוע של 36 WORD שמכיל את כל 512 הביטים של תוצאת SHA-512."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST הוא Value ברוחב קבוע שמכיל את כל תוצאת SHA-512 ממשפחת SHA-2. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0062` NIST, מספר פורמט `0xC000`, משפחה BINARY. ה-Payload הוא בדיוק 32 WORD (512 ביט), וקיצוץ (truncation) אינו מותר.

## פריסה

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG הרחבת Length  1 WORD  0x0024 (36 WORD בסך הכול)
Issuer            1 WORD  0x0062 (NIST)
מספר פורמט        1 WORD  0xC000
Payload           32 WORD  SHA-512 Digest
```

## פרשנות ותקינות

- 64 ה-octet של ה-Payload נקראים בסדר הפלט של SHA-512. בכל WORD ה-octet העליון בא ראשון.
- לא מופעלת על ה-digest bit string המרת endian נפרדת של GEUL. רצף ה-octet של הפלט רק מקובץ לפי הסדר לזוגות ומוגש כ-WORD של 16 ביט ב-big-endian.
- ייצוג שבו ה-Payload אינו 32 WORD, או שהתוצאה קוצצה באופן שרירותי, נדחה. אין descriptor ואין padding.

## בסיס בתקנים

- אלגוריתם SHA-512 והתוצאה בת 512 הביט נקבעים לפי NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL TAG, Length ו-framing של WORD בן 16 ביט הם כללים שהפורמט הזה מוסיף, ואינם חלק מאלגוריתם SHA-2.

## אורך

- האורך הכולל הוא בדיוק 36 WORD: TAG אחד, TAG הרחבת Length אחד, Issuer אחד, מספר פורמט אחד ו-32 WORD של Payload, עם `LLLL=1110`. אין descriptor ואין padding.
- אם ה-Payload אינו בדיוק 32 WORD, הרשומה נדחית.

## דוגמה

- ה-octet של ה-digest `d[0]` עד `d[63]` ממוקמים לפי הסדר ב-Payload WORD, מ-`(d[0]<<8)|d[1]` עד `(d[62]<<8)|d[63]`. ה-Length הכולל הוא תמיד 36 WORD.
