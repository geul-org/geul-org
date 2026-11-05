---
title: "REFERENCE-ISSUER-16WORD (0x05FL)"
weight: 95
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-16WORD הוא פורמט Reference שה-Issuer הגדיר."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-16WORD הוא פורמט Reference שה-Issuer הגדיר. הוא אחד משלושת המקומות האחרונים באזור Reference, ורוחב ה-Issuer שלו הוא 16 WORD. פריסת ה-ISSUER זהה בשלושת ה-Kind ([רשומה ו-TAG WORD](../record.md#issuer-형식-레코드)).

| פריט | ערך |
|---|---|
| שם | `REFERENCE-ISSUER-16WORD` (מסמך מפרט BIND `REFERENCE-ISSUER-16WORD`) |
| TAG ID | `0x05FL` |
| Codec ID | `0x000005F0` |
| מסמך מפרט | `0x00000000/codecs/0x000005F0/` (יעד DECLARE `05F0`) |
| קטע | 2 `0010` (Reference שונים), היסט C בתוך הקטע = 31 |
| Kind | Reference · סיווג: פורמט Issuer |
| TAG WORD | `0000 0101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | Issuer של 16 WORD ומספר Codec של 2 WORD. הפורמט נקבע במסמך ה-Codec של ה-Issuer |
| צד Hugo | `reference/reference-issuer.md` |

## פריסה {#레이아웃}

```
TAG WORD          0000 0101 1111 LLLL      Codec 0x05FL
[Length TAG הרחבה]
Issuer            16 WORD
מספר Codec        2 WORD. ה-Issuer מגדיר
Payload           נקבע במסמך ה-Codec ש-Issuer פרסם
```

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | ערך גולמי 16 WORD |  |  |
| 2 | `codec` | #3 | ערך גולמי 2 WORD |  |  |
| 3 | `payload` | #4 | ערך גולמי לשארית (`0xFFFF`) |  |  |

מבנה ה-`payload` נקבע במסמך ה-Codec של אותו Issuer.

## פירוש ותוקף {#해석과-유효성}

- GEUL מכיר רק את גבול ה-Payload דרך Length. מפענח שאינו מכיר את הפורמט יודע עד Kind, Length, Issuer ומספר Codec, ומדלג דרך Length.
- משמעות מספר ה-Codec, הכימות ומה שהוא מצביע עליו נקבעים במסמך ה-Codec ש-Issuer פרסם. כללי Reference המשותפים, כמו הרוחב הקצר ביותר של ID היעד וקריאת הכימות, אינם חלים ([REFERENCE-ISSUER](_index.md#해석과-유효성)).
- ה-Issuer נכתב ברוחב הקצר ביותר שהערך נכנס בו ([Issuer ופרסום](../issuer.md#issuer-등급)). אם 12 ה-WORD העליונים של ערך ה-Issuer הם 0, זה invalid. ערך כזה נכתב בקוד ברוחב צר יותר.
- מספר ה-Codec הוא 2 WORD. ה-Issuer מקצה אותו בתוך ה-`codecs/` שלו כך שלא יחפוף, בלי קשר ל-Kind. אם המספרים אינם מספיקים, מקבלים Issuer נוסף.
- מסמך ה-Codec נמצא תחת `<Issuer>/codecs/<מספר Codec>/` של אותו Issuer ([כתובת הפרסום ורשימת הגרסאות](../publishing.md#id-표기)).
- הרישיון של פורמט Issuer נקבע על ידי אותו Issuer ([Issuer ופרסום](../issuer.md#라이선스)).

## דפים קשורים {#관련-페이지}

- [REFERENCE-ISSUER](_index.md#reference-issuer), [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md)
- [רשומה ו-TAG WORD](../record.md#issuer-형식-레코드), [Issuer ופרסום](../issuer.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x000005F0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005F000000000
BODY
#1 DECLARE 0x05F0
#2 FIELD #1 0x0010
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-16WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
