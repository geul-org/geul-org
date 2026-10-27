---
title: "CRC32C"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "CRC32C הוא פורמט Issuer של IETF ברוחב קבוע של 5 WORD שמכיל את תוצאת Castagnoli CRC-32C בת 32 ביט."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CRC32C הוא Value ברוחב קבוע שמכיל תוצאת CRC-32C. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, מספר פורמט `0xC000`, משפחה BINARY. ה-Payload הוא בדיוק 2 WORD (32 ביט).

## פריסה

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  5 WORD בסך הכול
Issuer            1 WORD  0x0020 (IETF)
מספר פורמט        1 WORD  0xC000
Payload           2 WORD  CRC32C 16 ביט עליונים │ 16 ביט תחתונים
```

## פרשנות ותקינות

- בסימון פרמטרי CRC: width 32, פולינום Castagnoli `0x1EDC6F41`, refin/refout true, init `0xffffffff`, xorout `0xffffffff`.
- תוצאת החישוב, מספר שלם unsigned של 32 ביט, נשמרת בסדר WORD של big-endian. הסריאליזציה הזו אינה פריסת שדה ה-SCTP Checksum של RFC 3309 ואינה מיפוי הבייטים של digest ב-iSCSI לפי RFC 3720.
- אם ה-Payload אינו 2 WORD, הרשומה נדחית.

## בסיס בתקנים

- חישוב CRC-32C, פולינום Castagnoli וכללי ההשתקפות נקבעים לפי הגדרות CRC32C ב-[RFC 3309](https://www.rfc-editor.org/rfc/rfc3309.html) וב-[RFC 3720](https://www.rfc-editor.org/rfc/rfc3720.html).
- GEUL TAG, Length ו-framing של השלם בן 32 הביט ל-WORD של 16 ביט ב-big-endian הם כללים שהפורמט הזה מוסיף.

## אורך

- האורך הכולל הוא בדיוק 5 WORD: TAG אחד, Issuer אחד, מספר פורמט אחד ו-2 WORD של Payload, עם אורך ישיר `LLLL=0100`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 2 WORD, הרשומה נדחית.

## דוגמה

ערך הבדיקה CRC-32C של ASCII `123456789`, `0xe3069283`:

```
0A7C 0020 C000 e306 9283
```
