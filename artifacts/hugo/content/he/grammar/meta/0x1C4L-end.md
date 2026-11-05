---
title: "END (0x1C4L)"
weight: 452
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "רשומה שסוגרת את המסמך."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `END` (BIND של מסמך מפרט: `END`) |
| TAG ID | `0x1C4L` |
| Codec ID | `0x00001C40` |
| מסמך מפרט | `0x00000000/codecs/0x00001C40/` (יעד DECLARE: `1C40`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 4 |
| Kind | Meta · מחלקה: מבנה |
| TAG WORD | `0001 1100 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | WORD אחד. סוגר את המסמך. |
| בצד Hugo | `meta/structure/end.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

במסמך המפרט אין FIELD. לא מוצהרים שדות Payload.

רשומה שסוגרת את המסמך.

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 0100 LLLL      Codec 0x1C4L
[TAG הרחבה של Length]
```

- Codec: Meta `0x1C4L`, מחלקת מבנה
- Payload: אין (WORD אחד)
- מספר: אחד לכל מסמך, בסופו

## פירוש ותוקף {#해석과-유효성}

- חובה. את מקומו בודקים לפי האורך של [DOC](0x1C0L-doc-1word.md) (`DOC-*`).
- אם הקלט נגמר בלי END, המסמך קטוע. האם לראות את תוכנו של מסמך קטוע כתקף היא מדיניות המפענח.
- אחריו לא בא דבר.

## דוגמה {#예시}

- `0x1C40`

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001C40/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C4000000000
BODY
#1 DECLARE 0x1C40
#2 BIND #1 "END"
```
