---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "רושם ב-diff (DELTA-BASE) את ה-LOCAL ID (Edge Id) של הרשומה שיש להסיר מה-BODY של ה-snapshot הבסיסי (“מחיקת סעיף X”)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `DELTA-REMOVE` (BIND של מסמך מפרט: `DELTA-REMOVE`) |
| TAG ID | `0x1DCL` |
| Codec ID | `0x00001DC0` |
| מסמך מפרט | `0x00000000/codecs/0x00001DC0/` (יעד DECLARE: `1DC0`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 28 |
| Kind | Meta · מחלקה: שושלת |
| TAG WORD | `0001 1101 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | רשימת LOCAL ID (Edge Id) להסרה מה-BODY הבסיסי ב-diff |
| בצד Hugo | `meta/lineage/delta-remove.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | ערך גולמי לכל השאר (`0xFFFF`) |  |  |

רושם, ב-diff ([DELTA-BASE](0x1DBL-delta-base.md)), את ה-LOCAL ID (Edge Id) של הרשומה שיש להסיר מה-BODY של ה-snapshot הבסיסי (“מחיקת סעיף X”).

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[TAG הרחבה של Length]
LOCAL ID למחיקה   רשומת LOCAL Reference × 1 ומעלה
```

- Codec: Meta `0x1DCL`, מחלקת שושלת
- Payload: רשומת [LOCAL](../reference/0x005L-local.md) Reference אחת או יותר
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- מציבים רק במסמך שיש בו `DELTA-BASE`.
- כל LOCAL ID חייב להיות Edge Id שקיים ב-BODY של ה-snapshot הבסיסי. אם אין, זה invalid. הצבת אותו ID פעמיים היא invalid.
- הצבת אותו Edge Id שוב ב-BODY של אותו diff היא invalid (אי אפשר למחוק ולתקן יחד).
- LOCAL ID שנמחק אינו מוקצה מחדש לפריט אחר בגרסאות הבאות ([תיקון](../document.md#개정)).
- היעדר רשומה ב-BODY של ה-diff פירושו “לא השתנה”. לכן מחיקה מתבטאת רק ב-Meta הזה.
- HEAD Edge (ה-[SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) של המסמך כולו וה-QUALIFIER שלו) אינו נרשם. ה-HEAD מוחלף בשלמותו ב-HEAD של ה-diff ([אחסון diff](../document.md#diff-저장)).

## דוגמה {#예시}

מחיקת LOCAL `#7` ו-`#12`:

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4` (Meta `0x1DCL`, `LLLL=0100`, 5 WORD), LOCAL Reference ‏`0051 0007`, `0051 000C`.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001DC0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
