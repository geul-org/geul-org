---
title: "TEXT (0x121L)"
weight: 289
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TEXT היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN. משמעות: שם או מחרוזת.

| פריט | ערך |
|---|---|
| שם | `TEXT` (BIND `TEXT` במסמך המפרט) |
| TAG ID | `0x121L` |
| Codec ID | `0x00001210` |
| מסמך מפרט | `0x00000000/codecs/0x00001210/` (יעד DECLARE `1210`) |
| קטע | 9 `1001` (Edge, פורמט TOULMIN), היסט C בתוך הקטע = 1 |
| Kind | Edge · משפחה: פורמט TOULMIN, פריסה: ID, UTF8 Value |
| TAG WORD | `0001 0010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | שם או מחרוזת |
| בצד Hugo | `edge/toulmin/source.md` |

## פריסה {#레이아웃}

שם אחד או מחרוזת אחת. רשימות F_WITH ו-F_GROUNDS של NODE, ו-[LABEL](0x134L-label.md) ו-[IMPORTED-FROM](0x133L-imported-from.md) של LINK, מצביעות עליהם באמצעות REF.

```
ID
מחרוזת           רשומת UTF8-TEXT Value
```

- ID הוא Edge Id, ו-REF הוא ה-Edge Id של רשומת המסמך הזו (שדות משותפים של [TOULMIN](_index.md#공통-필드)). אין שדות Issuer ומספר Codec; ה-Payload בא אחרי ה-TAG.

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1210`). הצהרת השדות תיקבע יחד עם מסמך המפרט של Codec ב-TOULMIN ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [SOURCE ומקטעים](_index.md#source와-구획), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001210/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000121000000000
BODY
#1 DECLARE 0x1210
#2 BIND #1 "TEXT"
```
