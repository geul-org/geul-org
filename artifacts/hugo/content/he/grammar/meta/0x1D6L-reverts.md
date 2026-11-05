---
title: "REVERTS (0x1D6L)"
weight: 470
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "רושם את hash התוכן של הגרסה שהשינוי בה בוטל (git revert)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `REVERTS` (BIND של מסמך מפרט: `REVERTS`) |
| TAG ID | `0x1D6L` |
| Codec ID | `0x00001D60` |
| מסמך מפרט | `0x00000000/codecs/0x00001D60/` (יעד DECLARE: `1D60`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 214 |
| Kind | Meta · מחלקה: שושלת |
| TAG WORD | `0001 1101 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | hash התוכן של הגרסה שהשינוי בה בוטל (git revert) |
| בצד Hugo | `meta/lineage/reverts.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | רשומה | `07C0` SHA-256-DIGEST |  |

רושם את hash התוכן של הגרסה שהשינוי בה בוטל (git revert).

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 0110 LLLL      Codec 0x1D6L
[TAG הרחבה של Length]
Payload           Value אחד מסוג SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x1D6L`, מחלקת שושלת
- Payload: Value מובנה ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- מספר: אפשר כמה

## פירוש ותוקף {#해석과-유효성}

- פורמט ה-digest מוטמע כ-Value כדי להשאיר מקום להחלפת אלגוריתם ה-hash. כרגע hash התוכן הוא SHA-256 בלבד.

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001D60/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D6000000000
BODY
#1 DECLARE 0x1D60
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "REVERTS"
#4 BIND #2 "digest"
```
