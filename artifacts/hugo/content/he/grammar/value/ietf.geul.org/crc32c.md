---
title: "CRC32C"
weight: 1033
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C הוא Value ברוחב קבוע המכיל תוצאת CRC-32C."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C הוא Value ברוחב קבוע המכיל תוצאת CRC-32C. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000007` IETF, מספר Codec ‏`0x0000C000`, משפחה BINARY. ה-Payload הוא בדיוק 2 WORD (‏32 bit).

## פריסה {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  7 WORD בסך הכול
Issuer            2 WORD  0x00000007 (IETF)
מספר Codec        2 WORD  0x0000C000
Payload           2 WORD  CRC32C 16bit עליונים │ 16bit תחתונים
```

## פירוש ותוקף {#해석과-유효성}

- בכתיב של פרמטרי CRC: width ‏32, פולינום Castagnoli ‏`0x1EDC6F41`, ‏refin/refout true, ‏init ‏`0xFFFFFFFF`, ‏xorout ‏`0xFFFFFFFF`.
- המספר השלם unsigned בן 32bit שהתקבל מהחישוב נשמר בסדר WORD של big-endian. הסריאליזציה הזו אינה סידור שדה ה-SCTP Checksum של RFC 3309 או מיפוי ה-byte של digest ב-iSCSI של RFC 3720 עצמם.
- אם ה-Payload אינו 2 WORD, דוחים.

## בסיס בתקנים {#표준-근거}

- חישוב CRC-32C, פולינום Castagnoli וכללי ההשתקפות הם לפי הגדרת CRC32C ב-[RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) וב-[RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- GEUL TAG, Length ו-framing של WORD big-endian בן 16bit למספר השלם בן 32bit שחושב הם כללים שהפורמט הזה מוסיף.

## אורך {#길이}

- הסך הכול הוא בדיוק 7 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 2 WORD, עם אורך ישיר `LLLL=0110`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 2 WORD, דוחים.

## דוגמה {#예시}

ערך הבדיקה (check value) של CRC-32C עבור ASCII ‏`123456789` הוא `0xE3069283`:

```
09D6 0000 0007 0000 C000 E306 9283
```
