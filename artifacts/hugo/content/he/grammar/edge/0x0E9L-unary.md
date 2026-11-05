---
title: "UNARY (0x0E9L)"
weight: 233
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "UNARY הוא Codec של קבוצת ביטוי באוסף ה-Edge של ביצוע."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNARY הוא Codec של קבוצת ביטוי באוסף ה-Edge של ביצוע. משמעות: ביטוי אונרי.

| פריט | ערך |
|---|---|
| שם | `UNARY` (BIND של מסמך המפרט `UNARY`) |
| TAG ID | `0x0E9L` |
| Codec ID | `0x00000E90` |
| מסמך מפרט | `0x00000000/codecs/0x00000E90/` (יעד DECLARE `0E90`) |
| קטע | 7 `0111` (Edge ביצוע), היסט בתוך הקטע C = 9 |
| Kind | Edge · משפחה: ביצוע, קבוצה: ביטוי |
| TAG WORD | `0000 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | ביטוי אונרי. אופרטור ב-WORD אחד, אופרנד |
| צד Hugo | `edge/_index.md` |

## רכיבים {#구성요소}

אופרטור ב-WORD אחד, אופרנד.

- הרכיבים מצביעים באמצעות LOCAL ID (REF) של מסמך זה. REF `0` פירושו אין. במקום של ביטוי מציבים Edge של ביטוי או סמל ([Edge](_index.md#실행-edge)).
- קודי אופרטורים, ייצוג טיפוסים ופריסת Payload טרם נקבעו (בעיות פתוחות ב-[Edge](_index.md#실행-edge)).

## מסמך Codec {#코덱-문서}

הפריסה טרם נקבעה. מסמך ה-Codec כולל רק DECLARE (יעד `0E90`). FIELD יתווסף כשהפריסה תיקבע.

## דפים קשורים {#관련-페이지}

- [Edge — Edge של ביצוע](_index.md#실행-edge), [CONST](0x0E8L-const.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md)

## טקסט מקור של מסמך המפרט {#규격-문서-원문}

מסמך המפרט `0x00000000/codecs/0x00000E90/latest.geul` כפי שהוא נקרא ב-`geul show` (הקסדצימלי באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E9000000000
BODY
#1 DECLARE 0x0E90
#2 BIND #1 "UNARY"
```
