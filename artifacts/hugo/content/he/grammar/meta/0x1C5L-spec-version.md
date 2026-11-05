---
title: "SPEC-VERSION (0x1C5L)"
weight: 453
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "מצהיר על גרסת מפרט GEUL שהמסמך עוקב אחריה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `SPEC-VERSION` (BIND של מסמך מפרט: `SPEC-VERSION`) |
| TAG ID | `0x1C5L` |
| Codec ID | `0x00001C50` |
| מסמך מפרט | `0x00000000/codecs/0x00001C50/` (יעד DECLARE: `1C50`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 5 |
| Kind | Meta · מחלקה: הצהרה |
| TAG WORD | `0001 1100 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | גרסת מפרט GEUL שהמסמך עוקב אחריה. ה-Payload הוא עצמו מספר שלם unsigned ברוחב הקצר ביותר. v1 היא `0x0001` (הרשומה `0x1C51 0x0001`) |
| בצד Hugo | `meta/declaration/spec-version.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | ערך גולמי לכל השאר (`0xFFFF`) |  |  |

מצהיר על גרסת מפרט GEUL שהמסמך עוקב אחריה. הערך הזה קובע איך קוראים את שאר הרשומות.

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 0101 LLLL      Codec 0x1C5L
[TAG הרחבה של Length]
Payload           גרסת המפרט. v1 = 0x0001
```

- Codec: Meta `0x1C5L`, מחלקת הצהרה
- Payload: ערך גולמי (מספר שלם unsigned ברוחב הקצר ביותר)
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- לא נשענים על קוד Value. כדי שמפענח של כל גרסה יוכל לקרוא, מציבים מספר שלם בלבד, בלי Value מובנה.
- אם הגרסה אינה מוכרת, המפענח דוחה או מזהיר.
- אם אין הצהרה, המפענח קורא לפי הגרסה שהוא מכיר. מסמך מפורסם מציין אותה.

## דוגמה {#예시}

- `0x1C51 0x0001`: GEUL v1

## בעיות פתוחות {#열린-문제}

- ההתאמה לגרסת מסמך ספר ה-Codec ([מסמך מפרט](../codec-spec.md)).

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001C50/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C5000000000
BODY
#1 DECLARE 0x1C50
#2 FIELD #1 rest
#3 BIND #1 "SPEC-VERSION"
#4 BIND #2 "version"
```
