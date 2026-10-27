---
title: "IEEE-DECIMAL128-BID"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-BID הוא Value ברוחב קבוע של 11 WORD שמכיל כמות שהוא את רצף הביטים של IEEE 754 decimal128 BID interchange."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-BID הוא Value שמייצג את IEEE 754 decimal128 BID interchange encoding. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, מספר פורמט `0x2005`, משפחה DECIMAL. הוא שומר את ה-bit pattern של BID כמות שהוא ומובחן מ-DPD.

## פריסה

```
TAG WORD          0x0D7C  11 WORD בסך הכול
Issuer            1 WORD  0x0040 (IEEE)
מספר פורמט        1 WORD  0x2005
Payload           8 WORD (128 ביט)  IEEE decimal128 BID Interchange
```

## פרשנות

- שמונת ה-Payload WORD משורשרים מה-WORD העליון, ונקראים כרצף הביטים של IEEE 754 decimal128 BID interchange.
- ה-bit pattern נשמר, ואין לפרש אותו מחדש באופן שרירותי כ-DPD או לפורמט עשרוני מדויק.
- אין לנרמל באופן שרירותי ערכים מיוחדים או payload.

## תקינות ואורך

- האורך הכולל הוא בדיוק 11 WORD: TAG אחד, Issuer אחד, מספר פורמט אחד ו-8 WORD של Payload, עם אורך ישיר `LLLL=1010`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 8 WORD, הרשומה נדחית.
- התקינות המשמעותית של רצף הביטים נקבעת לפי כללי IEEE BID interchange.

## דוגמה

| מבנה | פסק דין |
|---|---|
| `0D7C 0040 2005` + 8 WORD של רצף ביטים BID | תקין |
| האורך הכולל אינו 11 WORD (`LLLL=1010`) | invalid: אינו תואם לרוחב ה-Payload הקבוע |

## בסיס בתקנים

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): מיושם בו binary coefficient encoding(BID) של decimal128 interchange format. הפורמט שומר את ה-encoding בן 128 הביט שנבחר, בלי להמיר מספרית לחלופה DPD שמותרת ב-IEEE, ורק מוסיף את GEUL TAG ואת framing של WORD ב-big-endian.
