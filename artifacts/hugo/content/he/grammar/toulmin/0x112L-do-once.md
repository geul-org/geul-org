---
title: "DO-ONCE (0x112L)"
weight: 274
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "DO-ONCE הוא Codec מסוג LINK שכותב קשר בגרף TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DO-ONCE הוא Codec מסוג LINK שכותב קשר בגרף TOULMIN. משמעות: פעולה שמבוצעת פעם אחת בלבד גם בניסיון חוזר.

| פריט | ערך |
|---|---|
| שם | `DO-ONCE` (BIND `DO-ONCE` במסמך המפרט) |
| TAG ID | `0x112L` |
| Codec ID | `0x00001120` |
| מסמך מפרט | `0x00000000/codecs/0x00001120/` (יעד DECLARE `1120`) |
| קטע | 8 `1000` (Edge TOULMIN), היסט C בתוך הקטע = 18 |
| Kind | Edge · משפחה: TOULMIN, קבוצה: ביצוע, פריסה: LINK |
| TAG WORD | `0001 0001 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | פעולה שמבוצעת פעם אחת בלבד גם בניסיון חוזר |
| בצד Hugo | `edge/toulmin/link.md` |

## פריסה {#레이아웃}

הפריסה היא [LINK](_index.md#link) (ID, src, dst, flags, שדות מותנים, SPAN).

| פריט | ערך |
|---|---|
| TANGEUL | `do fn once when n` |
| src → dst | כלל → FuncRef |

- dst הוא FuncRef. `do … once` מיוצג על ידי ה-Codec הזה. לא משתמשים ב-F_ONCE ב-flags (אם הוא מודלק, דוחים).
- F_FORCE אינו בשימוש (אם הוא מודלק, דוחים).
- השדות המשותפים (ID, REF, SPAN) והכללים המספריים נקבעים לפי [TOULMIN](_index.md#공통-필드).

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1120`). את השדות המותנים של פריסת LINK ואת רוחב ה-SPAN שקובע SOURCE אי אפשר להצהיר באמצעות FIELD, ולכן הצהרת השדות היא בעיה פתוחה ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001120/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000112000000000
BODY
#1 DECLARE 0x1120
#2 BIND #1 "DO-ONCE"
```
