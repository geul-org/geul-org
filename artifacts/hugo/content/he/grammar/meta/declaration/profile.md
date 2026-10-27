---
title: "PROFILE"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "PROFILE היא Meta של הצהרה שמצהירה בטקסט של שם וגרסה על הפרופיל שהוחל על המסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

מצהירה על הפרופיל שהוחל על המסמך. אותן רשומות מפורשות לפי מסמכי ה-Codec שהפרופיל קובע (למשל `tangeul-1.0` הוא [TOULMIN](/he/grammar/edge/toulmin/)).

## פריסה

```
TAG WORD          0001 1LLL L001 0001      Codec 0x11
[Length extension TAG]
Payload           Value מסוג UTF8-TEXT "<name>-<major>.<minor>"
```

- Codec: Meta `0x11`, מחלקת הצהרה (`001`)
- Payload: Value מוטמע ([UTF8-TEXT](/he/grammar/value/text/utf8-text/))
- מספר: לכל היותר אחד

## פירוש ותקינות

- פרופיל עם major שונה נדחה. הבדל ב-minor מותר (שינויים של הוספה בלבד).
- אם אין פרופיל, קוראים לפי הדקדוק הבסיסי של GEUL ומפרטי הקודים הישירים בלבד.

## דוגמה

- `tangeul-1.0`: `0x1B91 0x0B41 7461 6e67 6575 6c2d 312e 3000`

## שאלות פתוחות

- פנקס שמות פרופילים (geul.org) וכללי השמות.
- האם להצביע על הפרופיל באמצעות מזהה מסמך (IMPORT) או לכתוב אותו כטקסט.
