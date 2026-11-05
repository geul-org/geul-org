---
title: "WORLD (0x0B0L)"
weight: 176
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "WORLD היא Edge של היגד שכותבת תפיסת עולם."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WORLD היא Edge של היגד שכותבת תפיסת עולם. משמעות: מבנה לייצוג תפיסת עולם.

| פריט | ערך |
|---|---|
| שם | `WORLD` (BIND במסמך המפרט `WORLD`) |
| TAG ID | `0x0B0L` |
| Codec ID | `0x00000B00` |
| מסמך מפרט | `0x00000000/codecs/0x00000B00/` (יעד DECLARE‏ `0B00`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 16 |
| Kind | Edge · משפחה: היגד, קבוצה: מבנה |
| TAG WORD | `0000 1011 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | מבנה לייצוג תפיסת עולם |
| בצד Hugo | `edge/_index.md` |

## פריסה {#레이아웃}

```
TAG WORD          0000 1011 0000 LLLL      Codec 0x0B0L
[Length extension TAG]
TAG של Codec      WORD אחד. תת-פורמט
Edge Id           רשומת LOCAL Reference
רכיבים            נקבעים על ידי התת-פורמט
```

- זהו Codec שיש לו תת-פורמטים. TAG של Codec ב-WORD אחד קובע את התת-פורמט ([רשומה ו-TAG WORD](../record.md#레코드-레이아웃)).
- התת-פורמטים והרכיבים טרם נקבעו.

## מסמך Codec {#코덱-문서}

הפריסה טרם נקבעה. במסמך ה-Codec יש רק DECLARE (יעד `0B00`). FIELD יתווסף כשהפריסה תיקבע.

## דפים קשורים {#관련-페이지}

- [TIMELINE](0x0B1L-timeline.md), [SCENE](0x0B2L-scene.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (דרך ההצהרה על Codec שיש לו תת-פורמטים)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000B00/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B0000000000
BODY
#1 DECLARE 0x0B00
#2 BIND #1 "WORLD"
```
