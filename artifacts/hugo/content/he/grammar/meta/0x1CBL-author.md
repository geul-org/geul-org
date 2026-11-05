---
title: "AUTHOR (0x1CBL)"
weight: 459
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "רושם את הגורם שכתב את תוכן המסמך (git author)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `AUTHOR` (BIND של מסמך מפרט: `AUTHOR`) |
| TAG ID | `0x1CBL` |
| Codec ID | `0x00001CB0` |
| מסמך מפרט | `0x00000000/codecs/0x00001CB0/` (יעד DECLARE: `1CB0`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 11 |
| Kind | Meta · מחלקה: מוצא |
| TAG WORD | `0001 1100 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | כותב. Reference (git author) |
| בצד Hugo | `meta/provenance/author.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |

רושם את הגורם שכתב את תוכן המסמך (git author).

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 1011 LLLL      Codec 0x1CBL
[TAG הרחבה של Length]
Payload           רשומת Reference אחת (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL וכו')
```

- Codec: Meta `0x1CBL`, מחלקת מוצא
- Payload: Reference מובנה
- מספר: לכל היותר אחד

## פירוש ותוקף {#해석과-유효성}

- ה-Reference אינו מוגבל ב-Codec. הוא יכול להיות אדם, ארגון, מודל או מנוע כללים ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md) וכו').
- במסמכים ש-geul.org מפרסם אין Reference שמצביע על אדם טבעי ([Issuer ופרסום](../issuer.md#geulorg-공표)). מצביעים על ארגון או Issuer. היוצא מן הכלל: מותר להצביע על אדם טבעי באמצעות [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).
- אם זה LOCAL, מתארים את הפריט ב-BODY.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001CB0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CB000000000
BODY
#1 DECLARE 0x1CB0
#2 FIELD #1 record
#3 BIND #1 "AUTHOR"
#4 BIND #2 "actor"
```
