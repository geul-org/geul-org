---
title: "UNSIGNED-INTEGER (0x062L)"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER הוא Value המייצג ערך שלם ללא סימן."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `UNSIGNED-INTEGER` (מסמך מפרט BIND `UNSIGNED-INTEGER`) |
| TAG ID | `0x062L` |
| Codec ID | `0x00000620` |
| מסמך מפרט | `0x00000000/codecs/0x00000620/` (יעד DECLARE `0620`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 2 |
| Kind | Value · משפחה: NUMERIC |
| TAG WORD | `0000 0110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | מספר שלם unsigned magnitude בפורמט big-endian במספר WORD מינימלי |
| בצד Hugo | `value/numeric/unsigned-integer.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `magnitude` | #2 | ערך גולמי, השאר (`0xFFFF`) |  |  |

UNSIGNED-INTEGER הוא Value המייצג ערך שלם ללא סימן. קוד ישיר של Value הוא `0x062L`, משפחה NUMERIC. כל ה-Payload נקרא כ-unsigned magnitude בדיוק שרירותי, בסדר WORD של big-endian. ה-Payload הוא לפחות WORD אחד, ומותר רק הייצוג הקנוני במספר ה-WORD המינימלי.

## פריסה {#레이아웃}

```
TAG WORD          0000 0110 0010 LLLL      Codec 0x062L
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
Payload WORD 1st  (WORD עליון)   Unsigned Magnitude 1st
...
Payload WORD Nth  (WORD תחתון)   Unsigned Magnitude Nth
```

## פירוש {#해석}

- ה-WORD הראשון ב-Payload הוא הספרה הגבוהה ביותר, והאחרון הנמוכה ביותר.
- אם ה-Payload הוא N WORD, הוא נקרא כ-unsigned magnitude אחד של `16N` סיביות.
- רוחב זה אינו רוחב אחסון מוצהר, ואין descriptor של רוחב סיביות.

## ייצוג קנוני {#정규-표현}

- 0 הוא Payload של WORD אחד: `0000`.
- כאשר ה-Payload הוא 2 WORD ומעלה, ה-WORD הראשון `0000` אינו קנוני, שכן הסרתו אינה משנה את הערך.
- מפענח חייב לדחות ייצוג שיש בו WORD אפס מוביל מיותר.

## אורך {#길이}

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) ו-Payload. עד 14 WORD משתמשים באורך ישיר, ו-15 WORD ומעלה משתמשים באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נספר בסך הכול ([רשומה ו-TAG WORD](../record.md)).
- רוחב מוצהר כגון UINT8·UINT16·UINT32 אינו נשמר, ונשמר רק הערך המספרי.

## דוגמה {#예시}

| ערך | WORD של Payload | קביעה |
|---:|---|---|
| 0 | `0000` | קנוני |
| 1 | `0001` | קנוני |
| 65535 | `FFFF` | קנוני |
| 65536 | `0001 0000` | קנוני |
| 1 | `0000 0001` | לא קנוני: `0000` מוביל מיותר |
| Payload של 7 WORD | 7 ה-WORD שאחרי TAG `0627` (אורך ישיר `LLLL=0111`, סך הכול 8 WORD) | קנוני |
| Payload של 7 WORD | 7 ה-WORD שאחרי TAG של אורך מורחב וערך ההרחבה `0009` | לא קנוני: עד 14 WORD משתמשים באורך ישיר |

## מעמד הפורמט {#형식-지위}

- ייצוג זה, המנרמל unsigned magnitude בדיוק שרירותי לרצף WORD של 16 סיביות לפחות ומצמיד אותו ל-TAG של GEUL, הוא scalar profile ייחודי ל-GEUL.
- בהמרה מול טיפוסים חיצוניים ברוחב קבוע כגון UINT8/16/32/64 נדרשות בדיקת טווח והמרת רוחב מפורשת.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000620/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000062000000000
BODY
#1 DECLARE 0x0620
#2 FIELD #1 rest
#3 BIND #1 "UNSIGNED-INTEGER"
#4 BIND #2 "magnitude"
```
