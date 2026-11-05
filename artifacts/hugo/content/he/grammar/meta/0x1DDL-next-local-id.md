---
title: "NEXT-LOCAL-ID (0x1DDL)"
weight: 477
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "רושם את ה-LOCAL ID שהגרסה הבאה של המסמך תקצה להיגד חדש (auto increment של DBMS, AUTO_INCREMENT ב-MySQL)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `NEXT-LOCAL-ID` (BIND של מסמך מפרט: `NEXT-LOCAL-ID`) |
| TAG ID | `0x1DDL` |
| Codec ID | `0x00001DD0` |
| מסמך מפרט | `0x00000000/codecs/0x00001DD0/` (יעד DECLARE: `1DD0`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 29 |
| Kind | Meta · מחלקה: שושלת |
| TAG WORD | `0001 1101 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | ה-LOCAL ID הבא להקצאה (auto increment). מוצב ב-HEAD של רשימת הגרסאות `versions.geul` |
| בצד Hugo | `meta/lineage/next-local-id.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `next` | #2 | ערך גולמי לכל השאר (`0xFFFF`) |  |  |

רושם את ה-LOCAL ID שהגרסה הבאה של המסמך תקצה להיגד חדש (auto increment של DBMS, `AUTO_INCREMENT` ב-MySQL). כל LOCAL ID שהוקצה בכל גרסה של המסמך קטן מהערך הזה.

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 1101 LLLL      Codec 0x1DDL
Payload           ה-LOCAL ID הבא להקצאה, מספר שלם unsigned ברוחב הקצר ביותר
```

- Codec: Meta `0x1DDL`, מחלקת שושלת
- Payload: ערך גולמי (מספר שלם unsigned ברוחב הקצר ביותר)
- מספר: לכל היותר אחד
- מיקום: ב-HEAD של מסמך רשימת הגרסאות `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md))

## פירוש ותוקף {#해석과-유효성}

- LOCAL ID (כולל Edge Id) הוא זהות שחוצה גרסאות ([תיקון](../document.md#개정)). היגד חדש מקבל את הערך הזה והערך גדל ב-1. LOCAL ID שנמחק אינו בשימוש חוזר. לכן גם אם נמחק ההיגד שהיה בעל הערך הגבוה ביותר, הערך הזה אינו קטן.
- LOCAL ID `0` אינו מוקצה, ולכן הערך ההתחלתי הוא `1`. אם עדיין אין גרסה, לא מציבים את ה-Meta הזה והמספר הבא הוא `1`.
- המפרסם מעדכן אותו במסמך הרשימה החדש כשהוא מפרסם גרסה. הוא חייב להיות גדול מכל LOCAL ID ששימש בגרסה שפורסמה. אם קטן או שווה, זה invalid.
- הערך רק גדל. אם הוא קטן מהערך במסמך הרשימה הקודם ([PARENT](0x1D1L-parent.md)), זה invalid.
- אין אותו במסמך שאין לו ניהול גרסאות (מסמך בלי `versions.geul`, מסמך בלי שם). מסמך כזה אינו מכיל גם diff ([DELTA-BASE](0x1DBL-delta-base.md)).
- לא מציבים אותו בגוף המסמך (מסמך הגרסה). זכירת המספר אינה תוכן המסמך אלא מצב של המפרסם שממשיך את המסמך (בצד ה-refs של git, לא ה-commit).

## דוגמה {#예시}

המספר הבא להקצאה 524:

```
1DD1 020C
```

- TAG `1DD1` (Meta `0x1DDL`, `LLLL=0001`, 2 WORD), Payload ‏`020C`.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001DD0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DD000000000
BODY
#1 DECLARE 0x1DD0
#2 FIELD #1 rest
#3 BIND #1 "NEXT-LOCAL-ID"
#4 BIND #2 "next"
```
