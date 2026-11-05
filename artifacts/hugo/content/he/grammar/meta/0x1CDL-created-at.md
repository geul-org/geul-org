---
title: "CREATED-AT (0x1CDL)"
weight: 461
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "רושם את מועד כתיבת המסמך (git author date)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `CREATED-AT` (BIND של מסמך מפרט: `CREATED-AT`) |
| TAG ID | `0x1CDL` |
| Codec ID | `0x00001CD0` |
| מסמך מפרט | `0x00000000/codecs/0x00001CD0/` (יעד DECLARE: `1CD0`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 13 |
| Kind | Meta · מחלקה: מוצא |
| TAG WORD | `0001 1100 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | מועד כתיבה. Value מסוג TIME (git author date) |
| בצד Hugo | `meta/provenance/created-at.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | רשומה | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS, `06E0` EDTF, `06F0` EDTF, `0700` GEDCOM-DATE, `0710` GEDCOM-DATE |  |

רושם את מועד כתיבת המסמך (git author date).

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 1101 LLLL      Codec 0x1CDL
[TAG הרחבה של Length]
Payload           Value אחד מסוג TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS וכו')
```

- Codec: Meta `0x1CDL`, מחלקת מוצא
- Payload: Value מובנה (משפחת TIME: [GREGORIAN-DATE](../value/0x06AL-gregorian-date.md), [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md) וכו')
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- הפורמט נבחר מבין ה-Value של משפחת TIME. כשנדרש דיוק, משתמשים בפורמט ננו-שניות שה-Issuer הגדיר (למשל [POSIX-TIMESTAMP-NANOSECONDS](../value/ieee.geul.org/posix-timestamp-nanoseconds.md)).

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001CD0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CD000000000
BODY
#1 DECLARE 0x1CD0
#2 FIELD #1 record
#3 BIND #1 "CREATED-AT"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
#7 CODEC #2 0x06E0
#8 CODEC #2 0x06F0
#9 CODEC #2 0x0700
#10 CODEC #2 0x0710
```
