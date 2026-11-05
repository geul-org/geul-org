---
title: "GROUP (0x12AL)"
weight: 298
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "GROUP הוא Codec מסוג NODE שכותב צומת בגרף TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GROUP הוא Codec מסוג NODE שכותב צומת בגרף TOULMIN. משמעות: קבוצת ביצוע מסודרת.

| פריט | ערך |
|---|---|
| שם | `GROUP` (BIND `GROUP` במסמך המפרט) |
| TAG ID | `0x12AL` |
| Codec ID | `0x000012A0` |
| מסמך מפרט | `0x00000000/codecs/0x000012A0/` (יעד DECLARE `12A0`) |
| קטע | 9 `1001` (Edge, פורמט TOULMIN), היסט C בתוך הקטע = 10 |
| Kind | Edge · משפחה: פורמט TOULMIN, פריסה: NODE |
| TAG WORD | `0001 0010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | קבוצת ביצוע מסודרת |
| בצד Hugo | `edge/toulmin/node.md` |

## פריסה {#레이아웃}

הפריסה היא [NODE](_index.md#node). WORD כותרת אחד קובע את role, level, צורת ה-Claim והשדות המותנים.

| פריט | ערך |
|---|---|
| TANGEUL | `1.` רשימה ממוספרת |
| צומת | קבוצת ביצוע מסודרת |

- role חייב להיות 0.
- השדות המשותפים (ID, REF, SPAN) והכללים המספריים נקבעים לפי [TOULMIN](_index.md#공통-필드).

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `12A0`). את השדות המותנים של פריסת NODE ואת רוחב ה-SPAN שקובע SOURCE אי אפשר להצהיר באמצעות FIELD, ולכן הצהרת השדות היא בעיה פתוחה ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x000012A0/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012A000000000
BODY
#1 DECLARE 0x12A0
#2 BIND #1 "GROUP"
```
