---
title: "DELTA-BASE (0x1DBL)"
weight: 475
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "זהו סימן לכך שקובץ הגרסה הזה אינו snapshot אלא diff ביחס לגרסת בסיס של אותו מסמך (delta של git packfile)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `DELTA-BASE` (BIND של מסמך מפרט: `DELTA-BASE`) |
| TAG ID | `0x1DBL` |
| Codec ID | `0x00001DB0` |
| מסמך מפרט | `0x00000000/codecs/0x00001DB0/` (יעד DECLARE: `1DB0`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 27 |
| Kind | Meta · מחלקה: שושלת |
| TAG WORD | `0001 1101 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | קובץ הגרסה הזה הוא diff ביחס לגרסת בסיס של אותו מסמך (מזהה גרסה של 2 WORD) (git packfile delta) |
| בצד Hugo | `meta/lineage/delta-base.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | ערך גולמי, 2 WORD | `0620` UNSIGNED-INTEGER |  |

זהו סימן לכך שקובץ הגרסה הזה אינו תצלום מצב (snapshot) אלא **diff** ביחס לגרסת בסיס של אותו מסמך (delta של git packfile). הגרסה עצמה עדיין מוגדרת כ-snapshot. hash התוכן, רשימת הגרסאות והחתימות כולם מתייחסים ל-snapshot ששוחזר בהחלת ה-diff ([אחסון diff](../document.md#diff-저장)).

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 1011 LLLL      Codec 0x1DBL
מזהה גרסה         unsigned של 2 WORD (גרסת הבסיס של אותו מסמך)
```

- Codec: Meta `0x1DBL`, מחלקת שושלת
- Payload: מזהה גרסה של 2 WORD (ערך גולמי)
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- משתמשים רק במסמך שיש בו [DOC-ID](0x1C7L-doc-id.md). רשימת הגרסאות `versions.geul`, שאין בה `DOC-ID`, מסמכי רשימה (גרסאות של `issuers/`) ומסמכים בלי שם אינם מכילים diff.
- גרסת הבסיס היא גרסה שפורסמה של אותו `DOC-ID` והיא קודמת לגרסה הזו. `0` (בלי גרסה) הוא invalid.
- hash התוכן של ה-snapshot ששוחזר חייב להיות שווה ל-hash של הגרסה הזו ברשימת הגרסאות ([PUBLICATION](../edge/0x0B8L-publication.md)). אם לא, ה-diff הזה הוא invalid. לכן אין רושמים בתוך ה-diff hash תוצאה נפרד.
- רק מסמך שכל הרשומות ב-BODY שלו הן Edge (רשומות שיש להן Edge Id) יכול להיות diff. הסיבה: יחידת ה-diff היא LOCAL ID (Edge Id).
- כללי שחזור ה-snapshot הם לפי [אחסון diff](../document.md#diff-저장). המחיקה היא תפקידו של [DELTA-REMOVE](0x1DCL-delta-remove.md).
- אין סימן נפרד להוספה או לתיקון. אם ה-Edge Id ב-BODY של ה-diff קיים בבסיס, זה תיקון; אם לא, זו הוספה. הוספה מקבלת מספר החל מ-[NEXT-LOCAL-ID](0x1DDL-next-local-id.md) ברשימת הגרסאות. שימוש חוזר ב-LOCAL ID שנמחק הוא invalid ([תיקון](../document.md#개정)).

## דוגמה {#예시}

diff ביחס לגרסת בסיס 3:

```
1DB2 0000 0003
```

- TAG `1DB2` (Meta `0x1DBL`, `LLLL=0010`, 3 WORD), מזהה גרסה `0000 0003`.

## בעיות פתוחות {#열린-문제}

1. מרווח ה-snapshot: כל כמה גרסאות לשים snapshot מלא (אורך שרשרת ה-diff מול עלות השחזור).
2. האם להגביל את גרסת הבסיס לגרסה הקודמת.
3. מקום האחסון של קובץ ה-diff: האם לשים אותו במקום קובץ הגרסה (`<מזהה גרסה>.geul`), ומה הקשר שלו לכתובת hash התוכן `<Issuer>/hashes/` (`hashes/` נמצא לפי hash התוכן של ה-snapshot).

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001DB0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DB000000000
BODY
#1 DECLARE 0x1DB0
#2 FIELD #1 0x0002
#3 BIND #1 "DELTA-BASE"
#4 BIND #2 "version"
#5 CODEC #2 0x0620
```
