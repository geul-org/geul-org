---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT הוא Codec של Edge ב-TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT הוא Codec של Edge ב-TOULMIN. משמעות: תוצאת פסק הדין של צומת או רשומה. תוצאה (Pass, Review, Fail), ערך פסק דין, Activated, Excluded, Level.

| פריט | ערך |
|---|---|
| שם | `VERDICT` (BIND `VERDICT` במסמך המפרט) |
| TAG ID | `0x118L` |
| Codec ID | `0x00001180` |
| מסמך מפרט | `0x00000000/codecs/0x00001180/` (יעד DECLARE `1180`) |
| קטע | 8 `1000` (Edge TOULMIN), היסט C בתוך הקטע = 24 |
| Kind | Edge · משפחה: TOULMIN, קבוצה: תוצאה |
| TAG WORD | `0001 0001 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | תוצאת פסק הדין של צומת או רשומה. תוצאה (Pass, Review, Fail), ערך פסק דין, Activated, Excluded, Level. הפריסה טרם נקבעה |
| בצד Hugo | `edge/toulmin/_index.md` |

## פריסה {#레이아웃}

הוקצה רק הקוד, ועדיין אין פריסה ([TOULMIN](_index.md#열린-문제)).

- פסק הדין של המסמך כולו מוטל על VERDICT של Meta‏ ([VERDICT](../meta/0x1E9L-verdict.md), `0x1E9L`). השניים הם Codec נפרדים עם Kind שונה.
- תוצאת פסק הדין נשמרת במסמך שונה מהמסמך שנפסק ([TOULMIN](_index.md#판정-결과)).

## מסמך Codec {#코덱-문서}

הפריסה טרם נקבעה. מסמך ה-Codec מכיל רק DECLARE (יעד `1180`). FIELD יתווסף כשהפריסה תיקבע.

## דפים קשורים {#관련-페이지}

- [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001180/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
