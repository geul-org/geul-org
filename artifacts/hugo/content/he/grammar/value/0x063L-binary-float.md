---
title: "BINARY-FLOAT (0x063L)"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT הוא Value המייצג scalar בפורמט binary interchange של IEEE 754."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `BINARY-FLOAT` (מסמך מפרט BIND `BINARY-FLOAT`) |
| TAG ID | `0x063L` |
| Codec ID | `0x00000630` |
| מסמך מפרט | `0x00000000/codecs/0x00000630/` (יעד DECLARE `0630`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 3 |
| Kind | Value · משפחה: NUMERIC |
| TAG WORD | `0000 0110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | scalar של IEEE 754 binary16/32/64/128 ב-Payload של 1/2/4/8 WORD |
| בצד Hugo | `value/numeric/binary-float.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ieee-binary` | #2 | ערך גולמי, השאר (`0xFFFF`) |  |  |

BINARY-FLOAT הוא Value המייצג scalar בפורמט binary interchange של IEEE 754. קוד ישיר של Value הוא `0x063L`, משפחה NUMERIC. Payload של 1/2/4/8 WORD הוא binary16/32/64/128 בהתאמה. רצף הסיביות של ה-interchange נשמר כמות שהוא, וגדלי Payload אחרים אינם מותרים.

## פריסה {#레이아웃}

```
TAG WORD          0000 0110 0011 LLLL      Codec 0x063L
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
Payload WORD 1st  (WORD עליון)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (WORD תחתון)   IEEE Binary Interchange Nth
```

## פירוש {#해석}

- WORD של ה-Payload מחוברים בסדר big-endian ונקראים כרצף סיביות binary interchange של IEEE 754 ברוחב המתאים.
- תבניות הסיביות של ה-interchange נשמרות, כולל NaN payload ו-signed zero.
- מפענח אינו רשאי להחליף NaN ב-NaN קנוני כלשהו אחד או למחוק את סימנו של signed zero.
- שיטת העיגול וההתנהגות החשבונית אינן נקבעות בפורמט סריאליזציה זה.

## אורך {#길이}

הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) ו-Payload ([רשומה ו-TAG WORD](../record.md)).

| פורמט | Payload | קוד Length | TAG הרחבת Length | Length כולל |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | אין | 2 WORD |
| binary32 | 2 WORD | `0010` | אין | 3 WORD |
| binary64 | 4 WORD | `0100` | אין | 5 WORD |
| binary128 | 8 WORD | `1000` | אין | 9 WORD |

גם binary128 נמצא בטווח הישיר של 1~14 WORD, ולכן אין משתמשים ב-TAG הרחבת Length.

## תוקף {#유효성}

- ה-Payload הוא בדיוק אחד מהגדלים 1, 2, 4, 8 WORD.
- כל גודל Payload חייב להתאים בדיוק לייצוג ה-Length שבטבלה שלעיל.
- קידוד מחדש המשנה את הרוחב, או WORD של padding לפני ה-Payload או אחריו, אינם מותרים.

## דוגמה {#예시}

| פורמט | TAG | TAG הרחבת Length | דוגמת Payload | קביעה |
|---|---|---|---|---|
| binary16 | `0631` | אין | `0000` | קנוני |
| binary32 | `0632` | אין | `0000 0000` | קנוני |
| binary64 | `0634` | אין | `0000 0000 0000 0000` | קנוני |
| binary128 | `0638` | אין | רצף סיביות של 8 WORD | קנוני |
| כלשהו | אינו תואם לגודל המסומן ב-Length | כלשהו | כלשהו | invalid |

## בסיס תקני {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): מיושם בו קידוד ה-interchange של binary16, binary32, binary64, binary128. GEUL מוסיף לרצף הסיביות הזה רק TAG ומסגור big-endian של WORD בן 16 סיביות.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000630/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000063000000000
BODY
#1 DECLARE 0x0630
#2 FIELD #1 rest
#3 BIND #1 "BINARY-FLOAT"
#4 BIND #2 "ieee-binary"
```
