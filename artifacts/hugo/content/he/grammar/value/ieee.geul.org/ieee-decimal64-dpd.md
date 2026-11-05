---
title: "IEEE-DECIMAL64-DPD"
weight: 1030
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL64-DPD הוא Value המייצג את ה-interchange encoding מסוג DPD של IEEE 754 decimal64."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL64-DPD הוא Value המייצג את ה-interchange encoding מסוג DPD של IEEE 754 decimal64. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x0000000D` IEEE, מספר Codec ‏`0x00002001`, משפחה DECIMAL. דפוס הביטים של DPD נשמר כמות שהוא, והוא נבדל מ-BID.

## פריסה {#레이아웃}

```
TAG WORD          0x09D8  9 WORD בסך הכול
Issuer            2 WORD  0x0000000D (IEEE)
מספר Codec        2 WORD  0x00002001
Payload           4 WORD (64 ביט)  IEEE decimal64 DPD Interchange
```

## פירוש {#해석}

- ארבעת ה-WORD של ה-Payload, המחוברים מה-WORD העליון, נקראים כרצף ביטים של interchange מסוג DPD של IEEE 754 decimal64.
- דפוס הביטים נשמר, ואין מפרשים אותו מחדש באופן שרירותי כ-BID או כ-exact decimal.
- ערכים מיוחדים או payload אינם מנורמלים באופן שרירותי.

## תקינות ואורך {#유효성과-길이}

- הסך הכול הוא בדיוק 9 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 4 WORD, עם אורך ישיר `LLLL=1000`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.
- התוקף המשמעותי של רצף הביטים נקבע לפי כללי ה-interchange של IEEE DPD.

## דוגמה {#예시}

| מבנה | קביעה |
|---|---|
| `09D8 0000 000D 0000 2001` + 4 WORD DPD רצף ביטים | מבנה אורך תקין |
| `09D8 0000 000D 0000 2001` + 2 WORD | invalid: רוחב ה-Payload אינו תואם |
| אותם 64 ביט עם מספר Codec ‏`0x00002004` | זהו פורמט BID ולא הטיפוס הזה |

## בסיס בתקנים {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): מיושם ה-decimal coefficient encoding (DPD) של פורמט ה-interchange ‏decimal64. אין המרה מספרית לחלופת BID ש-IEEE מתירה; ה-encoding שנבחר בן 64 הביטים נשמר, ו-GEUL מוסיפה רק את ה-TAG ואת framing של WORD big-endian.
