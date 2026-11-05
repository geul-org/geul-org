---
title: "PROFILE (0x1C6L)"
weight: 454
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "מצהיר על הפרופיל שהוחל על המסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `PROFILE` (BIND של מסמך מפרט: `PROFILE`) |
| TAG ID | `0x1C6L` |
| Codec ID | `0x00001C60` |
| מסמך מפרט | `0x00000000/codecs/0x00001C60/` (יעד DECLARE: `1C60`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 6 |
| Kind | Meta · מחלקה: הצהרה |
| TAG WORD | `0001 1100 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | הפרופיל שהוחל |
| בצד Hugo | `meta/declaration/profile.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `profile` | #2 | רשומה | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

מצהיר על הפרופיל שהוחל על המסמך. את אותן הרשומות מפרשים לפי מסמכי ה-Codec שהפרופיל קובע (למשל, אם `tangeul-1.0`, אז [TOULMIN](../toulmin/_index.md)).

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 0110 LLLL      Codec 0x1C6L
[TAG הרחבה של Length]
Payload           Value מסוג UTF8-TEXT "<שם>-<major>.<minor>"
```

- Codec: Meta `0x1C6L`, מחלקת הצהרה
- Payload: Value מובנה ([UTF8-TEXT](../value/0x072L-utf8-text.md))
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- פרופיל עם major שונה נדחה. הבדל ב-minor מותר (שינויי הוספה בלבד).
- אם אין פרופיל, קוראים רק לפי דקדוק היסוד של GEUL ומפרט הקודים הישירים.

## דוגמה {#예시}

- `tangeul-1.0`: `0x1C67 0x0736 7461 6E67 6575 6C2D 312E 3000`

## בעיות פתוחות {#열린-문제}

- רישום שמות הפרופילים (geul.org) וכללי השמות.
- האם להצביע על הפרופיל במזהה מסמך (IMPORT) או להציבו כטקסט.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001C60/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C6000000000
BODY
#1 DECLARE 0x1C60
#2 FIELD #1 record
#3 BIND #1 "PROFILE"
#4 BIND #2 "profile"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
```
