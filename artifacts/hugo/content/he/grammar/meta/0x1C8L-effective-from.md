---
title: "EFFECTIVE-FROM (0x1C8L)"
weight: 456
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "מצהיר על מועד כניסתה לתוקף של הגרסה הזו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `EFFECTIVE-FROM` (BIND של מסמך מפרט: `EFFECTIVE-FROM`) |
| TAG ID | `0x1C8L` |
| Codec ID | `0x00001C80` |
| מסמך מפרט | `0x00000000/codecs/0x00001C80/` (יעד DECLARE: `1C80`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 8 |
| Kind | Meta · מחלקה: הצהרה |
| TAG WORD | `0001 1100 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | מועד כניסתה לתוקף של הגרסה הזו. Value מסוג GREGORIAN-DATE או POSIX-TIMESTAMP. אם אין, מועד הפרסום |
| בצד Hugo | `meta/declaration/effective-from.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | רשומה | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

מצהיר על מועד כניסתה לתוקף של הגרסה הזו. מועד הכניסה לתוקף שונה ממועד הפרסום ([תיקון](../document.md#개정)).

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 1000 LLLL      Codec 0x1C8L
[TAG הרחבה של Length]
Payload           Value אחד מסוג TIME
```

- Codec: Meta `0x1C8L`, מחלקת הצהרה
- Payload: Value מובנה ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) או [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- אם אין, הגרסה בתוקף ממועד הפרסום.
- אם יש [EFFECTIVE-UNTIL](0x1C9L-effective-until.md), הערך הזה חייב להקדים אותו.
- אם מועד הכניסה לתוקף שונה בין סעיפים, רושמים אותו בנפרד ב-Edge של הסעיף עם QUALIFIER P580 (התחלה) ו-P582 (סוף) ([SOURCE](../edge/0x0C0L-source.md#다른-근거의-표현)).
- כשמפרשים את המסמך לפי נקודת זמן מסוימת, קוראים את הערך הזה.

## דוגמה {#예시}

- נכנס לתוקף ב-1970-01-02: `0x1C83 0x06A2 0x0000 0x0001`

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001C80/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C8000000000
BODY
#1 DECLARE 0x1C80
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-FROM"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
