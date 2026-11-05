---
title: "CASE-BEGIN (0x123L)"
weight: 291
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-BEGIN היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-BEGIN היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN. משמעות: תחילת טווח המקרה.

| פריט | ערך |
|---|---|
| שם | `CASE-BEGIN` (BIND `CASE-BEGIN` במסמך המפרט) |
| TAG ID | `0x123L` |
| Codec ID | `0x00001230` |
| מסמך מפרט | `0x00000000/codecs/0x00001230/` (יעד DECLARE `1230`) |
| קטע | 9 `1001` (Edge, פורמט TOULMIN), היסט C בתוך הקטע = 3 |
| Kind | Edge · משפחה: פורמט TOULMIN, פריסה: ID, REF (מקרה) |
| TAG WORD | `0001 0010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | תחילת טווח המקרה |
| בצד Hugo | `edge/toulmin/source.md` |

## פריסה {#레이아웃}

זוהי תחילת טווח המקרה.

```
ID
מקרה             REF(CASE-DECLARE NODE)
```

- הטווח של מקרה הוא בין CASE-BEGIN שמצביע על אותו מקרה ([CASE-DECLARE](0x100L-case-declare.md) NODE) לבין [CASE-END](0x124L-case-end.md).
- ID הוא Edge Id, ו-REF הוא ה-Edge Id של רשומת המסמך הזו (שדות משותפים של [TOULMIN](_index.md#공통-필드)). אין שדות Issuer ומספר Codec; ה-Payload בא אחרי ה-TAG.

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1230`). הצהרת השדות תיקבע יחד עם מסמך המפרט של Codec ב-TOULMIN ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [SOURCE ומקטעים](_index.md#source와-구획), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001230/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000123000000000
BODY
#1 DECLARE 0x1230
#2 BIND #1 "CASE-BEGIN"
```
