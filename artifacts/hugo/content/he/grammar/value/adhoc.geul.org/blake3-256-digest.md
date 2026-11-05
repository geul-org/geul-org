---
title: "BLAKE3-256-DIGEST"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST הוא Value ברוחב קבוע המכיל את 32 ה-octet הראשונים (256 bit) של פלט BLAKE3 default hash mode."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST הוא Value ברוחב קבוע המכיל את 32 ה-octet הראשונים (256 bit) של פלט BLAKE3 default hash mode. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x0000C000`, משפחה BINARY. ה-Payload הוא בדיוק 16 WORD ואינו מכיל keyed hash mode, key derivation mode או פלט XOF באורך אחר.

## פריסה {#레이아웃}

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG הרחבת Length  1 WORD  0x0016 (22 WORD בסך הכול)
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x0000C000
Payload           16 WORD  BLAKE3-256 Digest
```

## פירוש ותוקף {#해석과-유효성}

- ה-Payload הוא 32 ה-octet הראשונים של output stream של BLAKE3 default hash mode. סדר הפלט נשמר, ובכל WORD ה-octet העליון בא ראשון.
- אין מפעילים על הפלט המרת endian של GEUL בנפרד. רצף ה-octet של הפלט מקובץ לפי הסדר בזוגות של שני octet ל-WORD big-endian של 16bit (framing).
- דוחים ייצוג שבו ה-Payload אינו 16 WORD, או שהוא מכיל תוצאת keyed_hash, derive_key או XOF באורך אחר. אין descriptor ו-padding.

## בסיס בתקנים {#표준-근거}

- האלגוריתם והגדרות ה-mode והפלט הם לפי [מאגר המימוש הרשמי](https://github.com/BLAKE3-team/BLAKE3) של צוות BLAKE3 ו-[BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- GEUL TAG, Length ו-framing של WORD בן 16bit הם כללים שהפורמט הזה מוסיף, ואינם חלק מאלגוריתם BLAKE3.

## אורך {#길이}

- הסך הכול הוא בדיוק 22 WORD: TAG של WORD אחד, TAG הרחבת Length של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 16 WORD, עם `LLLL=1110`. אין descriptor ו-padding.
- אם ה-Payload אינו בדיוק 16 WORD, דוחים.

## דוגמה {#예시}

- ה-octet של הפלט `d[0]` עד `d[31]` מונחים ב-16 WORD של ה-Payload לפי סדר הפלט, שני octet בכל WORD. ה-Length הכולל הוא תמיד 22 WORD.
