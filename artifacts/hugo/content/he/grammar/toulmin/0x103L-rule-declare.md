---
title: "RULE-DECLARE (0x103L)"
weight: 259
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RULE-DECLARE הוא Codec מסוג NODE שכותב צומת בגרף TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RULE-DECLARE הוא Codec מסוג NODE שכותב צומת בגרף TOULMIN. משמעות: הצהרת טענה (Warrant). אפשר לתקוף אותה.

| פריט | ערך |
|---|---|
| שם | `RULE-DECLARE` (BIND `RULE-DECLARE` במסמך המפרט) |
| TAG ID | `0x103L` |
| Codec ID | `0x00001030` |
| מסמך מפרט | `0x00000000/codecs/0x00001030/` (יעד DECLARE `1030`) |
| קטע | 8 `1000` (Edge TOULMIN), היסט C בתוך הקטע = 3 |
| Kind | Edge · משפחה: TOULMIN, קבוצה: הצהרה, פריסה: NODE |
| TAG WORD | `0001 0000 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | הצהרת טענה (Warrant). אפשר לתקוף אותה |
| בצד Hugo | `edge/toulmin/node.md` |

## פריסה {#레이아웃}

הפריסה היא [NODE](_index.md#node). WORD כותרת אחד קובע את role, level, צורת ה-Claim והשדות המותנים.

| פריט | ערך |
|---|---|
| TANGEUL | general rule, שם הכלל ב-Rules |
| צומת | טענה (Warrant) |

- role חייב להיות 0 (general).
- השדות המשותפים (ID, REF, SPAN) והכללים המספריים נקבעים לפי [TOULMIN](_index.md#공통-필드).

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1030`). את השדות המותנים של פריסת NODE ואת רוחב ה-SPAN שקובע SOURCE אי אפשר להצהיר באמצעות FIELD, ולכן הצהרת השדות היא בעיה פתוחה ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001030/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000103000000000
BODY
#1 DECLARE 0x1030
#2 BIND #1 "RULE-DECLARE"
```
