---
title: "IEEE-DECIMAL64-DPD"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-DPD הוא Value ברוחב קבוע של 7 WORD שמכיל כמות שהוא את רצף הביטים של IEEE 754 decimal64 DPD interchange."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-DPD הוא Value שמייצג את IEEE 754 decimal64 DPD interchange encoding. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, מספר פורמט `0x2001`, משפחה DECIMAL. הוא שומר את ה-bit pattern של DPD כמות שהוא ומובחן מ-BID.

## פריסה

```
TAG WORD          0x0B7C  7 WORD בסך הכול
Issuer            1 WORD  0x0040 (IEEE)
מספר פורמט        1 WORD  0x2001
Payload           4 WORD (64 ביט)  IEEE decimal64 DPD Interchange
```

## פרשנות

- ארבעת ה-Payload WORD משורשרים מה-WORD העליון, ונקראים כרצף הביטים של IEEE 754 decimal64 DPD interchange.
- ה-bit pattern נשמר, ואין לפרש אותו מחדש באופן שרירותי כ-BID או לפורמט עשרוני מדויק.
- אין לנרמל באופן שרירותי ערכים מיוחדים או payload.

## תקינות ואורך

- האורך הכולל הוא בדיוק 7 WORD: TAG אחד, Issuer אחד, מספר פורמט אחד ו-4 WORD של Payload, עם אורך ישיר `LLLL=0110`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 4 WORD, הרשומה נדחית.
- התקינות המשמעותית של רצף הביטים נקבעת לפי כללי IEEE DPD interchange.

## דוגמה

| מבנה | פסק דין |
|---|---|
| `0B7C 0040 2001` + 4 WORD של רצף ביטים DPD | מבנה אורך תקין |
| `0B7C 0040 2001` + 2 WORD | invalid: רוחב ה-Payload אינו תואם |
| אותם 64 ביט עם מספר פורמט `0x2004` | זהו פורמט BID ולא הטיפוס הזה |

## בסיס בתקנים

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): מיושם בו decimal coefficient encoding(DPD) של decimal64 interchange format. הפורמט שומר את ה-encoding בן 64 הביט שנבחר, בלי להמיר מספרית לחלופה BID שמותרת ב-IEEE, ורק מוסיף את GEUL TAG ואת framing של WORD ב-big-endian.
