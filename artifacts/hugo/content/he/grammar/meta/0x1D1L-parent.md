---
title: "PARENT (0x1D1L)"
weight: 465
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "רושם את hash התוכן של הגרסה הקודמת (git parent)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `PARENT` (BIND של מסמך מפרט: `PARENT`) |
| TAG ID | `0x1D1L` |
| Codec ID | `0x00001D10` |
| מסמך מפרט | `0x00000000/codecs/0x00001D10/` (יעד DECLARE: `1D10`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 17 |
| Kind | Meta · מחלקה: שושלת |
| TAG WORD | `0001 1101 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | hash התוכן של הגרסה הקודמת (git parent). אם אין, זו הגרסה הראשונה; אם יש כמה, זה מיזוג (git merge commit). |
| בצד Hugo | `meta/lineage/parent.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | רשומה | `07C0` SHA-256-DIGEST |  |

רושם את hash התוכן של הגרסה הקודמת (git parent).

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 0001 LLLL      Codec 0x1D1L
[TAG הרחבה של Length]
Payload           Value אחד מסוג SHA-256-DIGEST (16 WORD)
```

- Codec: Meta `0x1D1L`, מחלקת שושלת
- Payload: Value מובנה ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- מספר: אפשר כמה (מיזוג)

## פירוש ותוקף {#해석과-유효성}

- אם אין, זו הגרסה הראשונה. אם יש כמה, זה מיזוג (git merge commit).
- הוא נכלל ב-[hash התוכן](../document.md#내용-해시), ולכן כל ההיסטוריה הופכת לשרשרת hash.
- מסמך רשימת גרסאות מצביע על מסמך הרשימה הקודם ([PUBLICATION](../edge/0x0B8L-publication.md)).
- פורמט ה-digest מוטמע כ-Value כדי להשאיר מקום להחלפת אלגוריתם ה-hash. כרגע hash התוכן הוא SHA-256 בלבד.

## דוגמה {#예시}

- `0x1D1E 0x0014 0x07CE 0x0012 <16 WORD>` (Meta 20 WORD = TAG + הרחבה של Length + Value מובנה של 18 WORD)

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001D10/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D1000000000
BODY
#1 DECLARE 0x1D10
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "PARENT"
#4 BIND #2 "digest"
```
