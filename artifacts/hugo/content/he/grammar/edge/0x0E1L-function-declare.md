---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE הוא Codec של קבוצת הצהרה באוסף ה-Edge של ביצוע."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE הוא Codec של קבוצת הצהרה באוסף ה-Edge של ביצוע. משמעות: הצהרת פונקציה.

| פריט | ערך |
|---|---|
| שם | `FUNCTION-DECLARE` (BIND של מסמך המפרט `FUNCTION-DECLARE`) |
| TAG ID | `0x0E1L` |
| Codec ID | `0x00000E10` |
| מסמך מפרט | `0x00000000/codecs/0x00000E10/` (יעד DECLARE `0E10`) |
| קטע | 7 `0111` (Edge ביצוע), היסט בתוך הקטע C = 1 |
| Kind | Edge · משפחה: ביצוע, קבוצה: הצהרה |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | הצהרת פונקציה. סמל, רשימת סמלי פרמטרים, טיפוס החזרה, גוף (BLOCK) |
| צד Hugo | `edge/_index.md` |

## רכיבים {#구성요소}

סמל, רשימת סמלי פרמטרים, טיפוס החזרה, גוף (BLOCK).

- הרכיבים מצביעים באמצעות LOCAL ID (REF) של מסמך זה. REF `0` פירושו אין. במקום של ביטוי מציבים Edge של ביטוי או סמל ([Edge](_index.md#실행-edge)).
- קודי אופרטורים, ייצוג טיפוסים ופריסת Payload טרם נקבעו (בעיות פתוחות ב-[Edge](_index.md#실행-edge)).

## מסמך Codec {#코덱-문서}

הפריסה טרם נקבעה. מסמך ה-Codec כולל רק DECLARE (יעד `0E10`). FIELD יתווסף כשהפריסה תיקבע.

## דפים קשורים {#관련-페이지}

- [Edge — Edge של ביצוע](_index.md#실행-edge), [TYPE-DECLARE](0x0E2L-type-declare.md)

## טקסט מקור של מסמך המפרט {#규격-문서-원문}

מסמך המפרט `0x00000000/codecs/0x00000E10/latest.geul` כפי שהוא נקרא ב-`geul show` (הקסדצימלי באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
