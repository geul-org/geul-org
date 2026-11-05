---
title: "TRIGGER (0x116L)"
weight: 278
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TRIGGER הוא Codec מסוג NODE שכותב צומת בגרף TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIGGER הוא Codec מסוג NODE שכותב צומת בגרף TOULMIN. משמעות: נקודת כניסה של אירוע או מחזור, ללא קריאה חיצונית.

| פריט | ערך |
|---|---|
| שם | `TRIGGER` (BIND `TRIGGER` במסמך המפרט) |
| TAG ID | `0x116L` |
| Codec ID | `0x00001160` |
| מסמך מפרט | `0x00000000/codecs/0x00001160/` (יעד DECLARE `1160`) |
| קטע | 8 `1000` (Edge TOULMIN), היסט C בתוך הקטע = 22 |
| Kind | Edge · משפחה: TOULMIN, קבוצה: ביצוע, פריסה: NODE |
| TAG WORD | `0001 0001 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | נקודת כניסה של אירוע או מחזור, ללא קריאה חיצונית |
| בצד Hugo | `edge/toulmin/node.md` |

## פריסה {#레이아웃}

הפריסה היא [NODE](_index.md#node). WORD כותרת אחד קובע את role, level, צורת ה-Claim והשדות המותנים.

| פריט | ערך |
|---|---|
| TANGEUL | `on`, `every`, `until` |
| צומת | נקודת כניסה של אירוע או מחזור |

- role חייב להיות 0.
- השדות המשותפים (ID, REF, SPAN) והכללים המספריים נקבעים לפי [TOULMIN](_index.md#공통-필드).

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1160`). את השדות המותנים של פריסת NODE ואת רוחב ה-SPAN שקובע SOURCE אי אפשר להצהיר באמצעות FIELD, ולכן הצהרת השדות היא בעיה פתוחה ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001160/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000116000000000
BODY
#1 DECLARE 0x1160
#2 BIND #1 "TRIGGER"
```
