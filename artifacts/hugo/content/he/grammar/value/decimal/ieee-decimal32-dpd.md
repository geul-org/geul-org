---
title: "IEEE-DECIMAL32-DPD"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD הוא Value ברוחב קבוע של 5 WORD שמכיל כמות שהוא את רצף הביטים של IEEE 754 decimal32 DPD interchange."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-DPD הוא Value שמייצג את IEEE 754 decimal32 DPD interchange encoding. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, מספר פורמט `0x2000`, משפחה DECIMAL. הוא שומר את ה-bit pattern של DPD כמות שהוא ומובחן מ-BID.

## פריסה

```
TAG WORD          0x0A7C  5 WORD בסך הכול
Issuer            1 WORD  0x0040 (IEEE)
מספר פורמט        1 WORD  0x2000
Payload           2 WORD (32 ביט)  IEEE decimal32 DPD Interchange
```

## פרשנות

- שני ה-Payload WORD משורשרים מה-WORD העליון, ונקראים כרצף הביטים של IEEE 754 decimal32 DPD interchange.
- ה-bit pattern נשמר, ואין לפרש אותו מחדש באופן שרירותי כ-BID או SIGNED-DECIMAL.
- אין לנרמל באופן שרירותי ערכים מיוחדים או payload.

## תקינות ואורך

- האורך הכולל הוא בדיוק 5 WORD: TAG אחד, Issuer אחד, מספר פורמט אחד ו-2 WORD של Payload, עם אורך ישיר `LLLL=0100`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 2 WORD, הרשומה נדחית.
- התקינות המשמעותית של רצף הביטים נקבעת לפי כללי IEEE DPD interchange.

## דוגמה

| מבנה | פסק דין |
|---|---|
| `0A7C 0040 2000` + 2 WORD של רצף ביטים DPD | מבנה אורך תקין |
| `0A7C 0040 2000` + 4 WORD | invalid: רוחב ה-Payload אינו תואם |
| אותם 32 ביט עם מספר פורמט `0x2003` | זהו פורמט BID ולא הטיפוס הזה |

## בסיס בתקנים

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): מיושם בו decimal coefficient encoding(DPD) של decimal32 interchange format. הפורמט שומר את ה-encoding בן 32 הביט שנבחר, בלי להמיר מספרית לחלופה BID שמותרת ב-IEEE, ורק מוסיף את GEUL TAG ואת framing של WORD ב-big-endian.
