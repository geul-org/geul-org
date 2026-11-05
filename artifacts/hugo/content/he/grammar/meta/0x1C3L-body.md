---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "רשומה שמסיימת את ה-HEAD ומתחילה את ה-BODY."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `BODY` (BIND של מסמך מפרט: `BODY`) |
| TAG ID | `0x1C3L` |
| Codec ID | `0x00001C30` |
| מסמך מפרט | `0x00000000/codecs/0x00001C30/` (יעד DECLARE: `1C30`) |
| קטע | 14 `1110` (Meta), היסט C בתוך הקטע = 3 |
| Kind | Meta · מחלקה: מבנה |
| TAG WORD | `0001 1100 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | WORD אחד. מסיים את ה-HEAD של המסמך ומתחיל את ה-BODY. |
| בצד Hugo | `meta/structure/body.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

במסמך המפרט אין FIELD. לא מוצהרים שדות Payload.

רשומה שמסיימת את ה-HEAD ומתחילה את ה-BODY.

## פריסה {#레이아웃}

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[TAG הרחבה של Length]
```

- Codec: Meta `0x1C3L`, מחלקת מבנה
- Payload: אין (WORD אחד)
- מספר: לכל היותר אחד לכל מסמך

## פירוש ותוקף {#해석과-유효성}

- אם ה-HEAD ריק, משמיטים. מסמך בלי `BODY` כולו BODY. אם יש ב-HEAD Meta או HEAD Edge (ה-[SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) של המסמך כולו וה-QUALIFIER שלו), מציבים.
- אין Payload. סך הכול WORD אחד.

## דוגמה {#예시}

- `0x1C30`

## הנוסח המקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001C30/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
