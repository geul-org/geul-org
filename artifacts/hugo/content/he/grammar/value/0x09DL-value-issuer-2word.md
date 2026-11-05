---
title: "VALUE-ISSUER-2WORD (0x09DL)"
weight: 157
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-2WORD הוא פורמט Value שה-Issuer מגדיר."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-2WORD הוא פורמט Value שה-Issuer מגדיר. הוא אחד משלושת התאים האחרונים באזור ה-Value, ורוחב ה-Issuer הוא 2 WORD. פריסת ISSUER של שלושת ה-Kind זהה ([רשומה ו-TAG WORD](../record.md#issuer-형식-레코드)).

| פריט | ערך |
|---|---|
| שם | `VALUE-ISSUER-2WORD` (מסמך מפרט BIND `VALUE-ISSUER-2WORD`) |
| TAG ID | `0x09DL` |
| Codec ID | `0x000009D0` |
| מסמך מפרט | `0x00000000/codecs/0x000009D0/` (יעד DECLARE ‏`09D0`) |
| קטע | 4 `0100` (Value), היסט בתוך הקטע C = 29 |
| Kind | Value · סיווג: פורמט Issuer |
| TAG WORD | `0000 1001 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | 2 WORD של Issuer ו-2 WORD של מספר Codec. הפורמט נקבע במסמך ה-Codec של ה-Issuer |
| בצד Hugo | `value/_index.md` |

## פריסה {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length TAG הרחבה]
Issuer            2 WORD
מספר Codec        2 WORD. ה-Issuer מגדיר
Payload           נקבע במסמך ה-Codec שה-Issuer פרסם
```

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | ערך גולמי, 2 WORD |  |  |
| 2 | `codec` | #3 | ערך גולמי, 2 WORD |  |  |
| 3 | `payload` | #4 | שארית ערך גולמי (`0xFFFF`) |  |  |

מבנה ה-`payload` נקבע במסמך ה-Codec של אותו Issuer.

## פירוש ותוקף {#해석과-유효성}

- GEUL יודעת באמצעות Length רק את גבול ה-Payload. מפענח שאינו מכיר את הפורמט יודע עד Kind, ‏Length, ‏Issuer ומספר ה-Codec, ומדלג באמצעות Length.
- פירוש ה-Payload נקבע במסמך ה-Codec של ה-Issuer. פורמטי Value של Issuer שנרשמו כעת נמצאים ב-[אינדקס Codec](../codec-index.md#value-issuer-형식).
- ה-Issuer נכתב ברוחב הקצר ביותר שהערך נכנס בו ([Issuer ופרסום](../issuer.md#issuer-등급)). Issuer של 2 WORD יכול להכיל כל ערך.
- מספר ה-Codec הוא 2 WORD. ה-Issuer מקצה אותו בתוך `codecs/` שלו כך שלא יהיו חפיפות, בלי קשר ל-Kind. אם המספרים אינם מספיקים, מקבלים Issuer נוסף.
- מסמך ה-Codec מונח תחת `<Issuer>/codecs/<מספר Codec>/` של אותו Issuer ([כתובת פרסום ורשימת גרסאות](../publishing.md#id-표기)).
- הרישיון של פורמט Issuer נקבע על ידי אותו Issuer ([Issuer ופרסום](../issuer.md#라이선스)).

## דפים קשורים {#관련-페이지}

- [Value — פורמט Issuer](_index.md#issuer-형식), [VALUE-ISSUER-4WORD](0x09EL-value-issuer-4word.md), [VALUE-ISSUER-16WORD](0x09FL-value-issuer-16word.md)
- [רשומה ו-TAG WORD](../record.md#issuer-형식-레코드), [Issuer ופרסום](../issuer.md)

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x000009D0/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009D000000000
BODY
#1 DECLARE 0x09D0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-2WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
