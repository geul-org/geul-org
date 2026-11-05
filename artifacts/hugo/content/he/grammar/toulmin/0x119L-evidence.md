---
title: "EVIDENCE (0x119L)"
weight: 281
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EVIDENCE הוא Codec של Edge ב-TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EVIDENCE הוא Codec של Edge ב-TOULMIN. משמעות: ראיה לפסק הדין. מיקום, ערך צפוי, ערך בפועל (Fact).

| פריט | ערך |
|---|---|
| שם | `EVIDENCE` (BIND `EVIDENCE` במסמך המפרט) |
| TAG ID | `0x119L` |
| Codec ID | `0x00001190` |
| מסמך מפרט | `0x00000000/codecs/0x00001190/` (יעד DECLARE `1190`) |
| קטע | 8 `1000` (Edge TOULMIN), היסט C בתוך הקטע = 25 |
| Kind | Edge · משפחה: TOULMIN, קבוצה: תוצאה |
| TAG WORD | `0001 0001 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | ראיה לפסק הדין. מיקום, ערך צפוי, ערך בפועל (Fact). הפריסה טרם נקבעה |
| בצד Hugo | `edge/toulmin/_index.md` |

## פריסה {#레이아웃}

הוקצה רק הקוד, ועדיין אין פריסה ([TOULMIN](_index.md#열린-문제)).

- תוצאת פסק הדין נשמרת במסמך שונה מהמסמך שנפסק ([TOULMIN](_index.md#판정-결과)).

## מסמך Codec {#코덱-문서}

הפריסה טרם נקבעה. מסמך ה-Codec מכיל רק DECLARE (יעד `1190`). FIELD יתווסף כשהפריסה תיקבע.

## דפים קשורים {#관련-페이지}

- [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001190/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000119000000000
BODY
#1 DECLARE 0x1190
#2 BIND #1 "EVIDENCE"
```
