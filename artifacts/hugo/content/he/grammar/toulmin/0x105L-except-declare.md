---
title: "EXCEPT-DECLARE (0x105L)"
weight: 261
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXCEPT-DECLARE הוא Codec מסוג NODE שכותב צומת בגרף TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXCEPT-DECLARE הוא Codec מסוג NODE שכותב צומת בגרף TOULMIN. משמעות: הצהרת חריג. תוקף ללא מסקנה משלו. ה-Level המשתמע הוא Review.

| פריט | ערך |
|---|---|
| שם | `EXCEPT-DECLARE` (BIND `EXCEPT-DECLARE` במסמך המפרט) |
| TAG ID | `0x105L` |
| Codec ID | `0x00001050` |
| מסמך מפרט | `0x00000000/codecs/0x00001050/` (יעד DECLARE `1050`) |
| קטע | 8 `1000` (Edge TOULMIN), היסט C בתוך הקטע = 5 |
| Kind | Edge · משפחה: TOULMIN, קבוצה: הצהרה, פריסה: NODE |
| TAG WORD | `0001 0000 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | הצהרת חריג. תוקף ללא מסקנה משלו. ה-Level המשתמע הוא Review |
| בצד Hugo | `edge/toulmin/node.md` |

## פריסה {#레이아웃}

הפריסה היא [NODE](_index.md#node). WORD כותרת אחד קובע את role, level, צורת ה-Claim והשדות המותנים.

| פריט | ערך |
|---|---|
| TANGEUL | except rule |
| צומת | חריג (Defeater) |

- role חייב להיות 2 (except). אם level הוא 0 (Unset), משתמשים בברירת המחדל של המנוע, Review.
- השדות המשותפים (ID, REF, SPAN) והכללים המספריים נקבעים לפי [TOULMIN](_index.md#공통-필드).

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1050`). את השדות המותנים של פריסת NODE ואת רוחב ה-SPAN שקובע SOURCE אי אפשר להצהיר באמצעות FIELD, ולכן הצהרת השדות היא בעיה פתוחה ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001050/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000105000000000
BODY
#1 DECLARE 0x1050
#2 BIND #1 "EXCEPT-DECLARE"
```
