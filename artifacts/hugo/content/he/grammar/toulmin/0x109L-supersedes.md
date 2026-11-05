---
title: "SUPERSEDES (0x109L)"
weight: 265
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDES הוא Codec מסוג LINK שכותב קשר בגרף TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDES הוא Codec מסוג LINK שכותב קשר בגרף TOULMIN. משמעות: יחס הדרה. אם התוקף Active, הוא מוציא את היעד מהצבירה באופן מכריע. שרשרת (`A > B > C`) נכתבת בקשר אחד לכל זוג.

| פריט | ערך |
|---|---|
| שם | `SUPERSEDES` (BIND `SUPERSEDES` במסמך המפרט) |
| TAG ID | `0x109L` |
| Codec ID | `0x00001090` |
| מסמך מפרט | `0x00000000/codecs/0x00001090/` (יעד DECLARE `1090`) |
| קטע | 8 `1000` (Edge TOULMIN), היסט C בתוך הקטע = 9 |
| Kind | Edge · משפחה: TOULMIN, קבוצה: קשר, פריסה: LINK |
| TAG WORD | `0001 0000 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | יחס הדרה. אם התוקף Active, הוא מוציא את היעד מהצבירה באופן מכריע. שרשרת (`A > B > C`) נכתבת בקשר אחד לכל זוג |
| בצד Hugo | `edge/toulmin/link.md` |

## פריסה {#레이아웃}

הפריסה היא [LINK](_index.md#link) (ID, src, dst, flags, שדות מותנים, SPAN).

| פריט | ערך |
|---|---|
| TANGEUL | `X supersedes Y` |
| src → dst | כלל → כלל. אם Active, מוציא את היעד מהצבירה |

- שרשרת `A > B > C` של SUPERSEDES נכתבת ב-SUPERSEDES אחד לכל זוג. לקיצור [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) עדיין אין פריסה.
- F_FORCE אינו בשימוש (אם הוא מודלק, דוחים).
- השדות המשותפים (ID, REF, SPAN) והכללים המספריים נקבעים לפי [TOULMIN](_index.md#공통-필드).

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1090`). את השדות המותנים של פריסת LINK ואת רוחב ה-SPAN שקובע SOURCE אי אפשר להצהיר באמצעות FIELD, ולכן הצהרת השדות היא בעיה פתוחה ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001090/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000109000000000
BODY
#1 DECLARE 0x1090
#2 BIND #1 "SUPERSEDES"
```
