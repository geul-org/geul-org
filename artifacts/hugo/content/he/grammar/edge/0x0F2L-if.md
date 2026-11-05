---
title: "IF (0x0F2L)"
weight: 242
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "IF הוא Codec של קבוצת פקודה באוסף ה-Edge של ביצוע."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IF הוא Codec של קבוצת פקודה באוסף ה-Edge של ביצוע. משמעות: הסתעפות מותנית.

| פריט | ערך |
|---|---|
| שם | `IF` (BIND של מסמך המפרט `IF`) |
| TAG ID | `0x0F2L` |
| Codec ID | `0x00000F20` |
| מסמך מפרט | `0x00000000/codecs/0x00000F20/` (יעד DECLARE `0F20`) |
| קטע | 7 `0111` (Edge ביצוע), היסט בתוך הקטע C = 18 |
| Kind | Edge · משפחה: ביצוע, קבוצה: פקודה |
| TAG WORD | `0000 1111 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | הסתעפות מותנית. תנאי, BLOCK של אמת, ענף שקר (BLOCK או IF, אם אין אז 0) |
| צד Hugo | `edge/_index.md` |

## רכיבים {#구성요소}

תנאי, BLOCK של אמת, ענף שקר (BLOCK או IF, אם אין אז 0).

- הרכיבים מצביעים באמצעות LOCAL ID (REF) של מסמך זה. REF `0` פירושו אין. במקום של ביטוי מציבים Edge של ביטוי או סמל ([Edge](_index.md#실행-edge)).
- קודי אופרטורים, ייצוג טיפוסים ופריסת Payload טרם נקבעו (בעיות פתוחות ב-[Edge](_index.md#실행-edge)).

## מסמך Codec {#코덱-문서}

הפריסה טרם נקבעה. מסמך ה-Codec כולל רק DECLARE (יעד `0F20`). FIELD יתווסף כשהפריסה תיקבע.

## דפים קשורים {#관련-페이지}

- [Edge — Edge של ביצוע](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## טקסט מקור של מסמך המפרט {#규격-문서-원문}

מסמך המפרט `0x00000000/codecs/0x00000F20/latest.geul` כפי שהוא נקרא ב-`geul show` (הקסדצימלי באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F2000000000
BODY
#1 DECLARE 0x0F20
#2 BIND #1 "IF"
```
