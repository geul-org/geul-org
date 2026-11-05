---
title: "UNDO (0x113L)"
weight: 275
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "UNDO הוא Codec מסוג LINK שכותב קשר בגרף TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNDO הוא Codec מסוג LINK שכותב קשר בגרף TOULMIN. משמעות: פעולת פיצוי של DO‏ (saga). אם שלב מאוחר יותר נכשל, מבוצעת בסדר הפוך.

| פריט | ערך |
|---|---|
| שם | `UNDO` (BIND `UNDO` במסמך המפרט) |
| TAG ID | `0x113L` |
| Codec ID | `0x00001130` |
| מסמך מפרט | `0x00000000/codecs/0x00001130/` (יעד DECLARE `1130`) |
| קטע | 8 `1000` (Edge TOULMIN), היסט C בתוך הקטע = 19 |
| Kind | Edge · משפחה: TOULMIN, קבוצה: ביצוע, פריסה: LINK |
| TAG WORD | `0001 0001 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | פעולת פיצוי של DO‏ (saga). אם שלב מאוחר יותר נכשל, מבוצעת בסדר הפוך |
| בצד Hugo | `edge/toulmin/link.md` |

## פריסה {#레이아웃}

הפריסה היא [LINK](_index.md#link) (ID, src, dst, flags, שדות מותנים, SPAN).

| פריט | ערך |
|---|---|
| TANGEUL | `undo fn when n` |
| src → dst | כלל → FuncRef |

- dst הוא FuncRef. ה-`once` של UNDO נכתב ב-F_ONCE של flags.
- F_FORCE אינו בשימוש (אם הוא מודלק, דוחים).
- השדות המשותפים (ID, REF, SPAN) והכללים המספריים נקבעים לפי [TOULMIN](_index.md#공통-필드).

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1130`). את השדות המותנים של פריסת LINK ואת רוחב ה-SPAN שקובע SOURCE אי אפשר להצהיר באמצעות FIELD, ולכן הצהרת השדות היא בעיה פתוחה ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001130/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000113000000000
BODY
#1 DECLARE 0x1130
#2 BIND #1 "UNDO"
```
