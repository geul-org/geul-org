---
title: "IEEE-DECIMAL128-BID"
weight: 1025
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-BID הוא Value המייצג את ה-interchange encoding מסוג BID של IEEE 754 decimal128."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-BID הוא Value המייצג את ה-interchange encoding מסוג BID של IEEE 754 decimal128. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x0000000D` IEEE, מספר Codec ‏`0x00002005`, משפחה DECIMAL. דפוס הביטים של BID נשמר כמות שהוא, והוא נבדל מ-DPD.

## פריסה {#레이아웃}

```
TAG WORD          0x09DC  13 WORD בסך הכול
Issuer            2 WORD  0x0000000D (IEEE)
מספר Codec        2 WORD  0x00002005
Payload           8 WORD (128 ביט)  IEEE decimal128 BID Interchange
```

## פירוש {#해석}

- שמונת ה-WORD של ה-Payload, המחוברים מה-WORD העליון, נקראים כרצף ביטים של interchange מסוג BID של IEEE 754 decimal128.
- דפוס הביטים נשמר, ואין מפרשים אותו מחדש באופן שרירותי כ-DPD או כ-exact decimal.
- ערכים מיוחדים או payload אינם מנורמלים באופן שרירותי.

## תקינות ואורך {#유효성과-길이}

- הסך הכול הוא בדיוק 13 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 8 WORD, עם אורך ישיר `LLLL=1100`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.
- התוקף המשמעותי של רצף הביטים נקבע לפי כללי ה-interchange של IEEE BID.

## דוגמה {#예시}

| מבנה | קביעה |
|---|---|
| `09DC 0000 000D 0000 2005` + 8 WORD BID רצף ביטים | תקין |
| הסך הכול אינו 13 WORD (`LLLL=1100`) | invalid: אינו תואם לרוחב ה-Payload הקבוע |

## בסיס בתקנים {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): מיושם ה-binary coefficient encoding (BID) של פורמט ה-interchange ‏decimal128. אין המרה מספרית לחלופת DPD ש-IEEE מתירה; ה-encoding שנבחר בן 128 הביטים נשמר, ו-GEUL מוסיפה רק את ה-TAG ואת framing של WORD big-endian.
