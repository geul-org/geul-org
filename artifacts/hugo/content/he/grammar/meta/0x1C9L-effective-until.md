---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "מצהיר על סוף תקופת התוקף של הגרסה הזו (חוק לזמן קצוב)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `EFFECTIVE-UNTIL` (BIND של מסמך מפרט: `EFFECTIVE-UNTIL`) |
| TAG ID | `0x1C9L` |
| Codec ID | `0x00001C90` |
| מסמך מפרט | `0x00000000/codecs/0x00001C90/` (יעד DECLARE: `1C90`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 9 |
| Kind | Meta · מחלקה: הצהרה |
| TAG WORD | `0001 1100 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | סוף תקופת התוקף של הגרסה הזו (חוק לזמן קצוב). אם אין, עד שהגרסה הבאה נכנסת לתוקף |
| בצד Hugo | `meta/declaration/effective-until.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | רשומה | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

מצהיר על סוף תקופת התוקף של הגרסה הזו (חוק לזמן קצוב). מאותו מועד הגרסה הזו אינה בתוקף.

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[TAG הרחבה של Length]
Payload           Value אחד מסוג TIME
```

- Codec: Meta `0x1C9L`, מחלקת הצהרה
- Payload: Value מובנה ([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) או [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- אם אין, הגרסה תקפה עד שהגרסה הבאה נכנסת לתוקף.
- עם תום תקופת התוקף אין נוסח בתוקף. הנוסח הישן אינו קם לתחייה.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001C90/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
