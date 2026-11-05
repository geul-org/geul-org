---
title: "IEEE-DECIMAL32-DPD"
weight: 1028
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD הוא Value המייצג את ה-interchange encoding מסוג DPD של IEEE 754 decimal32."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-DPD הוא Value המייצג את ה-interchange encoding מסוג DPD של IEEE 754 decimal32. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x0000000D` IEEE, מספר Codec ‏`0x00002000`, משפחה DECIMAL. דפוס הביטים של DPD נשמר כמות שהוא, והוא נבדל מ-BID.

## פריסה {#레이아웃}

```
TAG WORD          0x09D6  7 WORD בסך הכול
Issuer            2 WORD  0x0000000D (IEEE)
מספר Codec        2 WORD  0x00002000
Payload           2 WORD (32 ביט)  IEEE decimal32 DPD Interchange
```

## פירוש {#해석}

- שני ה-WORD של ה-Payload, המחוברים מה-WORD העליון, נקראים כרצף ביטים של interchange מסוג DPD של IEEE 754 decimal32.
- דפוס הביטים נשמר, ואין מפרשים אותו מחדש באופן שרירותי כ-BID או כ-SIGNED-DECIMAL.
- ערכים מיוחדים או payload אינם מנורמלים באופן שרירותי.

## תקינות ואורך {#유효성과-길이}

- הסך הכול הוא בדיוק 7 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 2 WORD, עם אורך ישיר `LLLL=0110`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 2 WORD, דוחים.
- התוקף המשמעותי של רצף הביטים נקבע לפי כללי ה-interchange של IEEE DPD.

## דוגמה {#예시}

| מבנה | קביעה |
|---|---|
| `09D6 0000 000D 0000 2000` + 2 WORD DPD רצף ביטים | מבנה אורך תקין |
| `09D6 0000 000D 0000 2000` + 4 WORD | invalid: רוחב ה-Payload אינו תואם |
| אותם 32 ביט עם מספר Codec ‏`0x00002003` | זהו פורמט BID ולא הטיפוס הזה |

## בסיס בתקנים {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): מיושם ה-decimal coefficient encoding (DPD) של פורמט ה-interchange ‏decimal32. אין המרה מספרית לחלופת BID ש-IEEE מתירה; ה-encoding שנבחר בן 32 הביטים נשמר, ו-GEUL מוסיפה רק את ה-TAG ואת framing של WORD big-endian.
