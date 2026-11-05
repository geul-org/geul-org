---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN הוא Codec של Edge ב-TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN הוא Codec של Edge ב-TOULMIN. משמעות: שרשרת עדיפויות `A > B > C`. קיצור של SUPERSEDES לפי זוגות.

| פריט | ערך |
|---|---|
| שם | `SUPERSEDE-CHAIN` (BIND `SUPERSEDE-CHAIN` במסמך המפרט) |
| TAG ID | `0x10AL` |
| Codec ID | `0x000010A0` |
| מסמך מפרט | `0x00000000/codecs/0x000010A0/` (יעד DECLARE `10A0`) |
| קטע | 8 `1000` (Edge TOULMIN), היסט C בתוך הקטע = 10 |
| Kind | Edge · משפחה: TOULMIN, קבוצה: קשר |
| TAG WORD | `0001 0000 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | שרשרת עדיפויות `A > B > C`. קיצור של SUPERSEDES לפי זוגות. הפריסה טרם נקבעה |
| בצד Hugo | `edge/toulmin/_index.md` |

## פריסה {#레이아웃}

הוקצה רק הקוד, ועדיין אין פריסה ([TOULMIN](_index.md#열린-문제)).

- כרגע כותבים [SUPERSEDES](0x109L-supersedes.md) אחד לכל זוג. האם זה מספיק לשרשרת היא בעיה פתוחה.

## מסמך Codec {#코덱-문서}

הפריסה טרם נקבעה. מסמך ה-Codec מכיל רק DECLARE (יעד `10A0`). FIELD יתווסף כשהפריסה תיקבע.

## דפים קשורים {#관련-페이지}

- [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x000010A0/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
