---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT הוא Value שמכיל כמות שהוא את רצף ביטי ה-interchange של IEEE 754 binary16/32/64/128."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY-FLOAT הוא Value שמייצג scalar בינארי של IEEE 754 interchange. הוא Value עם קוד ישיר `0x03`, משפחה NUMERIC. אם ה-Payload הוא 1/2/4/8 WORD, הוא binary16/32/64/128 בהתאמה. הוא שומר את רצף ביטי ה-interchange כמות שהוא, ואינו מתיר גדלי Payload אחרים.

## פריסה

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[Length extension TAG] כשהכול 15 WORD ומעלה
Payload WORD 1st  (WORD עליון)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (WORD תחתון)   IEEE Binary Interchange Nth
```

## פירוש

- מחברים את ה-WORD של ה-Payload בסדר big-endian וקוראים אותם כרצף ביטי interchange בינארי של IEEE 754 ברוחב המתאים.
- שומרים את דפוס ביטי ה-interchange, כולל NaN payload ו-signed zero.
- המפענח אסור שיחליף NaN ב-NaN קנוני אחד כלשהו, ואסור שימחק את הסימן של signed zero.
- שיטת העיגול והתנהגות החישוב אינן נקבעות על ידי פורמט הסריאליזציה הזה.

## אורך

הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש) וה-Payload ([רשומות ו-TAG WORD](/he/grammar/record/)).

| פורמט | Payload | קוד Length | TAG הרחבת Length | Length כולל |
|---|---:|---|---|---:|
| binary16 | WORD אחד | `0001` | אין | 2 WORD |
| binary32 | 2 WORD | `0010` | אין | 3 WORD |
| binary64 | 4 WORD | `0100` | אין | 5 WORD |
| binary128 | 8 WORD | `1000` | אין | 9 WORD |

גם binary128 נמצא בטווח הישיר של 1~14 WORD, ולכן לא משתמשים בו ב-TAG הרחבת Length.

## תקינות

- ה-Payload הוא בדיוק אחד מ-1, 2, 4, 8 WORD.
- כל גודל Payload חייב להתאים בדיוק לייצוג ה-Length בטבלה שלמעלה.
- קידוד מחדש שמשנה רוחב, או WORD של padding לפני ה-Payload או אחריו, אינם מותרים.

## דוגמה

| פורמט | TAG | TAG הרחבת Length | דוגמת Payload | פסק דין |
|---|---|---|---|---|
| binary16 | `0883` | אין | `0000` | קנוני |
| binary32 | `0903` | אין | `0000 0000` | קנוני |
| binary64 | `0A03` | אין | `0000 0000 0000 0000` | קנוני |
| binary128 | `0C03` | אין | רצף ביטים של 8 WORD | קנוני |
| כלשהו | לא תואם לגודל ש-Length מציין | כלשהו | כלשהו | invalid |

## בסיס בתקנים

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): מחילים את קידוד ה-interchange של binary16, binary32, binary64 ו-binary128. GEUL מוסיפה לרצף הביטים רק TAG ו-framing של WORD בן 16 ביט ב-big-endian.
