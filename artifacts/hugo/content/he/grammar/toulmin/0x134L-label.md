---
title: "LABEL (0x134L)"
weight: 308
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LABEL הוא Codec מסוג LINK שכותב קשר בגרף TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL הוא Codec מסוג LINK שכותב קשר בגרף TOULMIN. משמעות: צומת → TEXT, סימון שם.

| פריט | ערך |
|---|---|
| שם | `LABEL` (BIND `LABEL` במסמך המפרט) |
| TAG ID | `0x134L` |
| Codec ID | `0x00001340` |
| מסמך מפרט | `0x00000000/codecs/0x00001340/` (יעד DECLARE `1340`) |
| קטע | 9 `1001` (Edge, פורמט TOULMIN), היסט C בתוך הקטע = 20 |
| Kind | Edge · משפחה: פורמט TOULMIN, פריסה: LINK |
| TAG WORD | `0001 0011 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | צומת → TEXT, סימון שם |
| בצד Hugo | `edge/toulmin/link.md` |

## פריסה {#레이아웃}

הפריסה היא [LINK](_index.md#link) (ID, src, dst, flags, שדות מותנים, SPAN).

| פריט | ערך |
|---|---|
| TANGEUL | שם בגרשיים הפוכים (backtick) |
| src → dst | צומת → TEXT. סימון שם |

- dst הוא REF של רשומת TEXT. האם לתת לשם בגרשיים הפוכים תפקיד של [LABEL](../edge/0x0A4L-label.md) או [BIND](../edge/0x0A3L-bind.md) מסוג Edge של היגד היא בעיה פתוחה ([TOULMIN](_index.md#열린-문제)).
- F_FORCE אינו בשימוש (אם הוא מודלק, דוחים).
- השדות המשותפים (ID, REF, SPAN) והכללים המספריים נקבעים לפי [TOULMIN](_index.md#공통-필드).

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1340`). את השדות המותנים של פריסת LINK ואת רוחב ה-SPAN שקובע SOURCE אי אפשר להצהיר באמצעות FIELD, ולכן הצהרת השדות היא בעיה פתוחה ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001340/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000134000000000
BODY
#1 DECLARE 0x1340
#2 BIND #1 "LABEL"
```
