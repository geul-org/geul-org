---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL הוא Reference מסוג הצהרה שמצביע על יעד באמצעות ID של ישות ש-geul.org מנפיקה ב-CC0."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL הוא Reference מסוג הצהרה שמצביע על ישות ש-geul.org מנפיקה ב-CC0. זהו ID סדרתי שהמספר שלו אינו נושא משמעות. מזהה שהביטים שלו נושאים משמעות נמצא ב-Codec נפרד, [GEUL-SIDX](/he/grammar/reference/geul-sidx/) (`0011`).

## פריסה

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[Length extension TAG]
GEUL ID           unsigned big-endian ברוחב הקצר ביותר
```

- מספרים קטנים מוקצים לישויות בעלות תדירות גבוהה. ID שנכנס ב-WORD אחד הוא 2 WORD בסך הכול.
- הקצאת ה-ID והפנקס מנוהלים על ידי geul.org. בפנקס נכנס רק חומר שמקורו ב-CC0.
- אם זה Variable, זהו משתנה אנונימי מאותו סוג (Variable ב-[Reference](/he/grammar/reference/)).

## דוגמה

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `0090 0001` |
| 1, Variable | `0094 0001` |
| 70000, Generic | `0111 0001 1170` |

## שאלות פתוחות

- כללי הקצאת GEUL ID ופורמט הפרסום של הפנקס.

## דפים קשורים

- [Reference](/he/grammar/reference/), [GEUL-SIDX](/he/grammar/reference/geul-sidx/)
