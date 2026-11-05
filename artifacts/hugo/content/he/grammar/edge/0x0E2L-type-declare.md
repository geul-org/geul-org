---
title: "TYPE-DECLARE (0x0E2L)"
weight: 226
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TYPE-DECLARE הוא Codec של קבוצת הצהרה באוסף ה-Edge של ביצוע."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TYPE-DECLARE הוא Codec של קבוצת הצהרה באוסף ה-Edge של ביצוע. משמעות: הצהרת טיפוס.

| פריט | ערך |
|---|---|
| שם | `TYPE-DECLARE` (BIND של מסמך המפרט `TYPE-DECLARE`) |
| TAG ID | `0x0E2L` |
| Codec ID | `0x00000E20` |
| מסמך מפרט | `0x00000000/codecs/0x00000E20/` (יעד DECLARE `0E20`) |
| קטע | 7 `0111` (Edge ביצוע), היסט בתוך הקטע C = 2 |
| Kind | Edge · משפחה: ביצוע, קבוצה: הצהרה |
| TAG WORD | `0000 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | הצהרת טיפוס. סמל והרכב (רשימת סמלי שדות, ערכי enum, יעד כינוי) |
| צד Hugo | `edge/_index.md` |

## רכיבים {#구성요소}

סמל והרכב (רשימת סמלי שדות, ערכי enum, יעד כינוי).

- הרכיבים מצביעים באמצעות LOCAL ID (REF) של מסמך זה. REF `0` פירושו אין. במקום של ביטוי מציבים Edge של ביטוי או סמל ([Edge](_index.md#실행-edge)).
- קודי אופרטורים, ייצוג טיפוסים ופריסת Payload טרם נקבעו (בעיות פתוחות ב-[Edge](_index.md#실행-edge)).

## מסמך Codec {#코덱-문서}

הפריסה טרם נקבעה. מסמך ה-Codec כולל רק DECLARE (יעד `0E20`). FIELD יתווסף כשהפריסה תיקבע.

## דפים קשורים {#관련-페이지}

- [Edge — Edge של ביצוע](_index.md#실행-edge), [FUNCTION-DECLARE](0x0E1L-function-declare.md)

## טקסט מקור של מסמך המפרט {#규격-문서-원문}

מסמך המפרט `0x00000000/codecs/0x00000E20/latest.geul` כפי שהוא נקרא ב-`geul show` (הקסדצימלי באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E2000000000
BODY
#1 DECLARE 0x0E20
#2 BIND #1 "TYPE-DECLARE"
```
