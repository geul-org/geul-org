---
title: "CHECKING (0x114L)"
weight: 276
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CHECKING הוא Codec מסוג LINK שכותב קשר בגרף TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CHECKING הוא Codec מסוג LINK שכותב קשר בגרף TOULMIN. משמעות: חיבור שרק פוסק, ללא תופעות לוואי.

| פריט | ערך |
|---|---|
| שם | `CHECKING` (BIND `CHECKING` במסמך המפרט) |
| TAG ID | `0x114L` |
| Codec ID | `0x00001140` |
| מסמך מפרט | `0x00000000/codecs/0x00001140/` (יעד DECLARE `1140`) |
| קטע | 8 `1000` (Edge TOULMIN), היסט C בתוך הקטע = 20 |
| Kind | Edge · משפחה: TOULMIN, קבוצה: ביצוע, פריסה: LINK |
| TAG WORD | `0001 0001 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | חיבור שרק פוסק, ללא תופעות לוואי |
| בצד Hugo | `edge/toulmin/link.md` |

## פריסה {#레이아웃}

הפריסה היא [LINK](_index.md#link) (ID, src, dst, flags, שדות מותנים, SPAN).

| פריט | ערך |
|---|---|
| TANGEUL | `checking c` |
| src → dst | כלל → מקרה. פסק דין ללא תופעות לוואי |

- dst הוא REF של צומת.
- F_FORCE אינו בשימוש (אם הוא מודלק, דוחים).
- השדות המשותפים (ID, REF, SPAN) והכללים המספריים נקבעים לפי [TOULMIN](_index.md#공통-필드).

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1140`). את השדות המותנים של פריסת LINK ואת רוחב ה-SPAN שקובע SOURCE אי אפשר להצהיר באמצעות FIELD, ולכן הצהרת השדות היא בעיה פתוחה ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001140/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000114000000000
BODY
#1 DECLARE 0x1140
#2 BIND #1 "CHECKING"
```
