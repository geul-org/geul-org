---
title: "PROSE (0x125L)"
weight: 293
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PROSE היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PROSE היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN. משמעות: פסקת תיאור.

| פריט | ערך |
|---|---|
| שם | `PROSE` (BIND `PROSE` במסמך המפרט) |
| TAG ID | `0x125L` |
| Codec ID | `0x00001250` |
| מסמך מפרט | `0x00000000/codecs/0x00001250/` (יעד DECLARE `1250`) |
| קטע | 9 `1001` (Edge, פורמט TOULMIN), היסט C בתוך הקטע = 5 |
| Kind | Edge · משפחה: פורמט TOULMIN, פריסה: ID, SPAN |
| TAG WORD | `0001 0010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | פסקת תיאור |
| בצד Hugo | `edge/toulmin/source.md` |

## פריסה {#레이아웃}

פסקת תיאור שאינה כלל. היא מצביעה רק על טווח (SPAN) בטקסט המקור.

```
ID
SPAN             הרוחב שקבע SOURCE × 2 (בייט התחלה, מספר בייטים)
```

- ID הוא Edge Id, ו-REF הוא ה-Edge Id של רשומת המסמך הזו (שדות משותפים של [TOULMIN](_index.md#공통-필드)). אין שדות Issuer ומספר Codec; ה-Payload בא אחרי ה-TAG.

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1250`). את רוחב ה-SPAN קובע SOURCE ולכן אי אפשר להצהיר עליו באמצעות FIELD; הצהרת השדות היא בעיה פתוחה ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [SOURCE ומקטעים](_index.md#source와-구획), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001250/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000125000000000
BODY
#1 DECLARE 0x1250
#2 BIND #1 "PROSE"
```
