---
title: "EDGE-ISSUER-2WORD (0x1BDL)"
weight: 445
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "EDGE-ISSUER-2WORD הוא פורמט Edge שמוגדר על ידי Issuer."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDGE-ISSUER-2WORD הוא פורמט Edge שמוגדר על ידי Issuer. הוא אחד משלושת התאים האחרונים באזור ה-Edge, ורוחב ה-Issuer שלו הוא 2 WORD. פריסת ה-ISSUER זהה בשלושת ה-Kind ([רשומה ו-TAG WORD](../record.md#issuer-형식-레코드)).

| פריט | ערך |
|---|---|
| שם | `EDGE-ISSUER-2WORD` (BIND של מסמך המפרט `EDGE-ISSUER-2WORD`) |
| TAG ID | `0x1BDL` |
| Codec ID | `0x00001BD0` |
| מסמך מפרט | `0x00000000/codecs/0x00001BD0/` (יעד DECLARE `1BD0`) |
| קטע | 13 `1101` (Edge (שלושת התאים האחרונים, ISSUER)), היסט בתוך הקטע C = 29 |
| Kind | Edge · סיווג: פורמט Issuer |
| TAG WORD | `0001 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | Issuer ב-2 WORD ומספר Codec ב-2 WORD. הפורמט נקבע במסמך ה-Codec של ה-Issuer |
| צד Hugo | `edge/_index.md` |

## פריסה {#레이아웃}

```
TAG WORD          0001 1011 1101 LLLL      Codec 0x1BDL
[TAG הרחבה של Length]
Issuer            2 WORD
מספר Codec        2 WORD. מוגדר על ידי ה-Issuer
Edge Id           רשומת LOCAL Reference. האיבר הראשון אחרי ה-Issuer ומספר ה-Codec
שאר ה-Payload     נקבע במסמך Codec שפרסם ה-Issuer
```

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר ב-FIELD. ה-Edge Id של EDGE-ISSUER בא אחרי מספר ה-Codec ולפני השדה `payload` ([פריסה](#레이아웃)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | ערך גולמי 2 WORD |  |  |
| 2 | `codec` | #3 | ערך גולמי 2 WORD |  |  |
| 3 | `payload` | #4 | שאר הערך הגולמי (`0xFFFF`) |  |  |

הרכב ה-`payload` נקבע במסמך ה-Codec של אותו Issuer.

## פירוש ותוקף {#해석과-유효성}

- GEUL יודע מ-Length רק את גבול ה-Payload. מפענח שאינו מכיר את הפורמט יודע עד Kind, Length, Issuer ומספר Codec, ודולג קדימה לפי Length.
- ה-Payload מתחיל ב-Edge Id (LOCAL Reference) ([Edge](_index.md#레이아웃)). הרכיבים אחרי ה-Edge Id נקבעים במסמך ה-Codec של ה-Issuer.
- Issuer נכתב ברוחב הקצר ביותר שהערך נכנס בו ([Issuer ופרסום](../issuer.md#issuer-등급)). Issuer ב-2 WORD יכול לשאת כל ערך.
- מספר ה-Codec הוא 2 WORD. ה-Issuer מקצה אותו בתוך `codecs/` שלו ללא חפיפה, בלי קשר ל-Kind. אם המספרים אינם מספיקים, מקבלים Issuer נוסף.
- מסמך ה-Codec נמצא תחת `<Issuer>/codecs/<מספר Codec>/` של אותו Issuer ([כתובת פרסום ורשימת גרסאות](../publishing.md#id-표기)).
- רישיון הפורמט של Issuer נקבע על ידי אותו Issuer ([Issuer ופרסום](../issuer.md#라이선스)).

## דפים קשורים {#관련-페이지}

- [Edge — Edge בפורמט Issuer](_index.md#issuer-형식-edge), [EDGE-ISSUER-4WORD](0x1BEL-edge-issuer-4word.md), [EDGE-ISSUER-16WORD](0x1BFL-edge-issuer-16word.md)
- [רשומה ו-TAG WORD](../record.md#issuer-형식-레코드), [Issuer ופרסום](../issuer.md)

## טקסט מקור של מסמך המפרט {#규격-문서-원문}

מסמך המפרט `0x00000000/codecs/0x00001BD0/latest.geul` כפי שהוא נקרא ב-`geul show` (הקסדצימלי באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001BD000000000
BODY
#1 DECLARE 0x1BD0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "EDGE-ISSUER-2WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
