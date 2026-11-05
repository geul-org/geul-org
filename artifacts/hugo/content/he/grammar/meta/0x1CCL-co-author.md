---
title: "CO-AUTHOR (0x1CCL)"
weight: 460
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "רושם את הגורם שכתב את המסמך במשותף (git Co-authored-by)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `CO-AUTHOR` (BIND של מסמך מפרט: `CO-AUTHOR`) |
| TAG ID | `0x1CCL` |
| Codec ID | `0x00001CC0` |
| מסמך מפרט | `0x00000000/codecs/0x00001CC0/` (יעד DECLARE: `1CC0`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 12 |
| Kind | Meta · מחלקה: מוצא |
| TAG WORD | `0001 1100 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | כותב שותף. Reference (git `Co-authored-by`) |
| בצד Hugo | `meta/provenance/co-author.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | רשומה | כל רשומה (פרט לסמן מקום) |  |

רושם את הגורם שכתב את המסמך במשותף (git `Co-authored-by`).

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 1100 LLLL      Codec 0x1CCL
[TAG הרחבה של Length]
Payload           רשומת Reference אחת (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL וכו')
```

- Codec: Meta `0x1CCL`, מחלקת מוצא
- Payload: Reference מובנה
- מספר: אפשר כמה

## פירוש ותוקף {#해석과-유효성}

- ה-Reference אינו מוגבל ב-Codec. הוא יכול להיות אדם, ארגון, מודל או מנוע כללים ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md) וכו').
- במסמכים ש-geul.org מפרסם אין Reference שמצביע על אדם טבעי ([Issuer ופרסום](../issuer.md#geulorg-공표)). מצביעים על ארגון או Issuer. היוצא מן הכלל: מותר להצביע על אדם טבעי באמצעות [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md).
- אם זה LOCAL, מתארים את הפריט ב-BODY.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001CC0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CC000000000
BODY
#1 DECLARE 0x1CC0
#2 FIELD #1 record
#3 BIND #1 "CO-AUTHOR"
#4 BIND #2 "actor"
```
