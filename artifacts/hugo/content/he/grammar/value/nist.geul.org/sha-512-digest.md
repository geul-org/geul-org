---
title: "SHA-512-DIGEST"
weight: 1039
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-512-DIGEST הוא Value ברוחב קבוע המכיל את כל התוצאה של SHA-512 ממשפחת SHA-2."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA-512-DIGEST הוא Value ברוחב קבוע המכיל את כל התוצאה של SHA-512 ממשפחת SHA-2. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000015` NIST, מספר Codec ‏`0x0000C000`, משפחה BINARY. ה-Payload הוא בדיוק 32 WORD (‏512 bit), וקיצוץ (truncation) אינו מותר.

## פריסה {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG הרחבת Length  1 WORD  0x0026 (38 WORD בסך הכול)
Issuer            2 WORD  0x00000015 (NIST)
מספר Codec        2 WORD  0x0000C000
Payload           32 WORD  SHA-512 Digest
```

## פירוש ותוקף {#해석과-유효성}

- 64 ה-octet של ה-Payload נקראים בסדר הפלט של SHA-512 כמות שהוא. בכל WORD ה-octet העליון בא ראשון.
- אין מפעילים על מחרוזת הביטים של ה-digest המרת endian של GEUL בנפרד. רצף ה-octet של הפלט רק מקובץ לפי הסדר בזוגות של שני octet ל-WORD big-endian של 16bit (framing).
- דוחים ייצוג שבו ה-Payload אינו 32 WORD, או שהתוצאה קוצצה באופן שרירותי. אין descriptor ו-padding.

## בסיס בתקנים {#표준-근거}

- אלגוריתם SHA-512 ותוצאת 512 הביטים שלו הם לפי NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL TAG, Length ו-framing של WORD בן 16bit הם כללים שהפורמט הזה מוסיף, ואינם חלק מאלגוריתם SHA-2.

## אורך {#길이}

- הסך הכול הוא בדיוק 38 WORD: TAG של WORD אחד, TAG הרחבת Length של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 32 WORD, עם `LLLL=1110`. אין descriptor ו-padding.
- אם ה-Payload אינו בדיוק 32 WORD, דוחים.

## דוגמה {#예시}

- ה-octet של ה-digest מ-`d[0]` עד `d[63]` מונחים לפי הסדר כ-WORD של ה-Payload, מ-`(d[0]<<8)|d[1]` עד `(d[62]<<8)|d[63]`. ה-Length הכולל הוא תמיד 38 WORD.
