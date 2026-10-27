---
title: "UNSIGNED-INTEGER"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER הוא Value שמכיל מספר שלם בלי סימן כ-magnitude של big-endian במינימום WORD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-INTEGER הוא Value שמייצג ערך של מספר שלם בלי סימן. הוא Value עם קוד ישיר `0x02`, משפחה NUMERIC. כל ה-Payload נקרא כ-unsigned magnitude ברמת דיוק שרירותית, בסדר WORD של big-endian. ה-Payload הוא לפחות WORD אחד, ומותר רק הייצוג הקנוני במינימום WORD.

## פריסה

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x02
[Length extension TAG] כשהכול 15 WORD ומעלה
Payload WORD 1st  (WORD עליון)   Unsigned Magnitude 1st
...
Payload WORD Nth  (WORD תחתון)   Unsigned Magnitude Nth
```

## פירוש

- ה-WORD הראשון ב-Payload הוא הספרה הגבוהה ביותר, והאחרון הנמוכה ביותר.
- אם ה-Payload הוא N WORD, קוראים אותו כ-unsigned magnitude אחד של `16N` ביט.
- הרוחב הזה אינו רוחב אחסון מוצהר, ואין bit width descriptor.

## ייצוג קנוני

- 0 הוא Payload של WORD אחד `0000`.
- כש-Payload הוא 2 WORD ומעלה, אם ה-WORD הראשון הוא `0000` הוא אינו קנוני, כי מחיקתו אינה משנה את הערך.
- המפענח חייב לדחות ייצוג שיש בו WORD מוביל מיותר של אפסים.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([רשומות ו-TAG WORD](/he/grammar/record/)).
- רוחבים מוצהרים כמו UINT8·UINT16·UINT32 אינם נשמרים, ונשמר רק הערך המספרי.

## דוגמה

| ערך | WORD של Payload | פסק דין |
|---:|---|---|
| 0 | `0000` | קנוני |
| 1 | `0001` | קנוני |
| 65535 | `ffff` | קנוני |
| 65536 | `0001 0000` | קנוני |
| 1 | `0000 0001` | לא קנוני: `0000` מוביל מיותר |
| Payload של 7 WORD | 7 ה-WORD שאחרי TAG `0b82` (אורך ישיר `LLLL=0111`, 8 WORD בסך הכול) | קנוני |
| Payload של 7 WORD | 7 ה-WORD שאחרי TAG הרחבת אורך וערך מורחב `0009` | לא קנוני: עד 14 WORD כותבים באורך ישיר |

## מעמד הפורמט

- הייצוג הזה, שמנרמל unsigned magnitude בדיוק שרירותי לרצף WORD של 16 ביט במינימום ומצמיד אותו ל-TAG של GEUL, הוא scalar profile ייחודי של GEUL.
- בהחלפה עם טיפוסים חיצוניים ברוחב קבוע כמו UINT8/16/32/64 דרושות בדיקת טווח והמרת רוחב מפורשת.
