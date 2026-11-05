---
title: "TAG (0x1DAL)"
weight: 474
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "רושם שם בלתי משתנה שניתן לגרסה (git annotated tag)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `TAG` (BIND של מסמך מפרט: `TAG`) |
| TAG ID | `0x1DAL` |
| Codec ID | `0x00001DA0` |
| מסמך מפרט | `0x00000000/codecs/0x00001DA0/` (יעד DECLARE: `1DA0`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 26 |
| Kind | Meta · מחלקה: שושלת |
| TAG WORD | `0001 1101 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | שם בלתי משתנה שניתן לגרסה. Value מסוג TEXT ו-hash תוכן (git annotated tag) |
| בצד Hugo | `meta/lineage/tag.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD בתוך המסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `name` | #2 | רשומה | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |
| 2 | `target` | #7 | רשומה | `07C0` SHA-256-DIGEST, `0000` ABSENT (שדה אופציונלי) |  |

רושם שם בלתי משתנה שניתן לגרסה (git annotated tag).

## פריסה {#레이아웃}

```
TAG WORD          0001 1101 1010 LLLL      Codec 0x1DAL
[TAG הרחבה של Length]
שם                Value מסוג UTF8-TEXT-*
יעד               Value מסוג SHA-256-DIGEST, או סמן השמטה 0x0000 (שדה אופציונלי). אם משמיטים, זו הגרסה הזו
```

- Codec: Meta `0x1DAL`, מחלקת שושלת
- Payload: Value מובנה (טקסט + hash תוכן אופציונלי)
- מספר: אפשר כמה

## פירוש ותוקף {#해석과-유효성}

- השם הוא [UTF8-TEXT](../value/0x072L-utf8-text.md) והיעד הוא [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md).
- אם משמיטים את היעד (ABSENT `0x0000`, שדה אופציונלי של [CODEC](../edge/0x0BEL-codec.md)), השם ניתן למסמך עצמו. את hash התוכן של עצמו אי אפשר לכתוב בתוך עצמו. מפרט geul.org `0x1DA0` הוא שדה של שתי רשומות: name (`0720`, `0730`) ו-target (`07C0`, `0000`).
- אין להשתמש באותו שם שוב בגרסה אחרת.

## דוגמה {#예시}

- שם `v1`, הגרסה הזו: `1DA3 0721 7631 0000`

## בעיות פתוחות {#열린-문제}

- האם TAG נדרש בכלל כשיש מזהה גרסה (מספר סידורי).

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001DA0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DA000000000
BODY
#1 DECLARE 0x1DA0
#2 FIELD #1 record
#3 BIND #1 "TAG"
#4 BIND #2 "name"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
#7 FIELD #1 record
#8 BIND #7 "target"
#9 CODEC #7 0x07C0
#10 CODEC #7 0x0000
```
