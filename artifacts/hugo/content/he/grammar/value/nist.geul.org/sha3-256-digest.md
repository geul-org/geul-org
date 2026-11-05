---
title: "SHA3-256-DIGEST"
weight: 1040
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA3-256-DIGEST הוא Value ברוחב קבוע המכיל את כל התוצאה של SHA3-256."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA3-256-DIGEST הוא Value ברוחב קבוע המכיל את כל התוצאה של SHA3-256. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000015` NIST, מספר Codec ‏`0x0000C001`, משפחה BINARY. ה-Payload הוא בדיוק 16 WORD (‏256 bit), וקיצוץ (truncation) אינו מותר.

## פריסה {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG הרחבת Length  1 WORD  0x0016 (22 WORD בסך הכול)
Issuer            2 WORD  0x00000015 (NIST)
מספר Codec        2 WORD  0x0000C001
Payload           16 WORD  SHA3-256 Digest
```

## פירוש ותוקף {#해석과-유효성}

- 32 ה-octet של ה-Payload נקראים בסדר הפלט של SHA3-256 כמות שהוא. בכל WORD ה-octet העליון בא ראשון.
- אין מפעילים על מחרוזת הביטים של ה-digest המרת endian של GEUL בנפרד. רצף ה-octet של הפלט רק מקובץ לפי הסדר בזוגות של שני octet ל-WORD big-endian של 16bit (framing).
- דוחים ייצוג שבו ה-Payload אינו 16 WORD, או שהתוצאה קוצצה באופן שרירותי. אין descriptor ו-padding.

## בסיס בתקנים {#표준-근거}

- אלגוריתם SHA3-256 ותוצאת 256 הביטים שלו הם לפי NIST [FIPS 202, SHA-3 Standard](https://csrc.nist.gov/pubs/fips/202/final). גם [פרויקט Hash Functions](https://csrc.nist.gov/Projects/hash-functions) של NIST מציג את תקן SHA-3.
- GEUL TAG, Length ו-framing של WORD בן 16bit הם כללים שהפורמט הזה מוסיף, ואינם חלק מאלגוריתם SHA-3.

## אורך {#길이}

- הסך הכול הוא בדיוק 22 WORD: TAG של WORD אחד, TAG הרחבת Length של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 16 WORD, עם `LLLL=1110`. אין descriptor ו-padding.
- אם ה-Payload אינו בדיוק 16 WORD, דוחים.

## דוגמה {#예시}

- ה-octet של ה-digest מ-`d[0]` עד `d[31]` מונחים ב-16 WORD של ה-Payload לפי סדר הפלט, שני octet בכל WORD. ה-Length הכולל הוא תמיד 22 WORD.
