---
title: "CASE-END (0x124L)"
weight: 292
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-END היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-END היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN. משמעות: סוף טווח המקרה.

| פריט | ערך |
|---|---|
| שם | `CASE-END` (BIND `CASE-END` במסמך המפרט) |
| TAG ID | `0x124L` |
| Codec ID | `0x00001240` |
| מסמך מפרט | `0x00000000/codecs/0x00001240/` (יעד DECLARE `1240`) |
| קטע | 9 `1001` (Edge, פורמט TOULMIN), היסט C בתוך הקטע = 4 |
| Kind | Edge · משפחה: פורמט TOULMIN, פריסה: ID, REF (מקרה) |
| TAG WORD | `0001 0010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | סוף טווח המקרה |
| בצד Hugo | `edge/toulmin/source.md` |

## פריסה {#레이아웃}

זהו סוף טווח המקרה.

```
ID
מקרה             REF(CASE-DECLARE NODE)
```

- הטווח של מקרה נקבע לפי אותו מקרה ([CASE-DECLARE](0x100L-case-declare.md) NODE): הוא בין [CASE-BEGIN](0x123L-case-begin.md) שמצביע עליו לבין CASE-END.
- ID הוא Edge Id, ו-REF הוא ה-Edge Id של רשומת המסמך הזו (שדות משותפים של [TOULMIN](_index.md#공통-필드)). אין שדות Issuer ומספר Codec; ה-Payload בא אחרי ה-TAG.

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1240`). הצהרת השדות תיקבע יחד עם מסמך המפרט של Codec ב-TOULMIN ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [SOURCE ומקטעים](_index.md#source와-구획), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001240/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000124000000000
BODY
#1 DECLARE 0x1240
#2 BIND #1 "CASE-END"
```
