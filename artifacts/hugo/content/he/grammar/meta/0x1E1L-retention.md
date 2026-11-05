---
title: "RETENTION (0x1E1L)"
weight: 481
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "רושם את תקופת השמירה של המסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `RETENTION` (BIND של מסמך מפרט: `RETENTION`) |
| TAG ID | `0x1E1L` |
| Codec ID | `0x00001E10` |
| מסמך מפרט | `0x00000000/codecs/0x00001E10/` (יעד DECLARE: `1E10`) |
| קטע | 15 `1111` (Meta), היסט C בתוך הקטע = 1 |
| Kind | Meta · מחלקה: מדיניות |
| TAG WORD | `0001 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | תקופת שמירה |
| בצד Hugo | `meta/policy/retention.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `retention` | #2 | רשומה | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE, `06D0` DURATION-SECONDS |  |

רושם את תקופת השמירה של המסמך.

## פריסה {#레이아웃}

```
TAG WORD          0001 1110 0001 LLLL      Codec 0x1E1L
[TAG הרחבה של Length]
Payload           מועד תפוגה (GREGORIAN-DATE וכו') או משך (DURATION-SECONDS)
```

- Codec: Meta `0x1E1L`, מחלקת מדיניות
- Payload: Value מובנה (משפחת TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) וכו', או [DURATION-SECONDS](../value/0x06DL-duration-seconds.md))
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- אם זה משך, סופרים אותו מ-[RECORDED-AT](0x1D0L-recorded-at.md).

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001E10/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E1000000000
BODY
#1 DECLARE 0x1E10
#2 FIELD #1 record
#3 BIND #1 "RETENTION"
#4 BIND #2 "retention"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
#11 CODEC #2 0x06D0
```
