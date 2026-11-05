---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN. משמעות: תחילת קטע.

| פריט | ערך |
|---|---|
| שם | `SECTION` (BIND `SECTION` במסמך המפרט) |
| TAG ID | `0x122L` |
| Codec ID | `0x00001220` |
| מסמך מפרט | `0x00000000/codecs/0x00001220/` (יעד DECLARE `1220`) |
| קטע | 9 `1001` (Edge, פורמט TOULMIN), היסט C בתוך הקטע = 2 |
| Kind | Edge · משפחה: פורמט TOULMIN, פריסה: ID, קוד קטע ב-WORD אחד |
| TAG WORD | `0001 0010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | תחילת קטע |
| בצד Hugo | `edge/toulmin/source.md` |

## פריסה {#레이아웃}

תחילת קטע. קוד הקטע הוא WORD אחד.

```
ID
קוד קטע          1 WORD
```

| קוד | קטע | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | כללי ביטוי תנאי |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` אינו בשימוש. הקטעים מוצהרים לפי סדר הקודים הזה.
- כותרת הקטע היא [PROSE](0x125L-prose.md) שבא מיד אחרי SECTION.
- ID הוא Edge Id, ו-REF הוא ה-Edge Id של רשומת המסמך הזו (שדות משותפים של [TOULMIN](_index.md#공통-필드)). אין שדות Issuer ומספר Codec; ה-Payload בא אחרי ה-TAG.

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1220`). הצהרת השדות תיקבע יחד עם מסמך המפרט של Codec ב-TOULMIN ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [SOURCE ומקטעים](_index.md#source와-구획), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001220/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
