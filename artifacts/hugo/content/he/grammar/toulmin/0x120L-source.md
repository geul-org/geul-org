---
title: "SOURCE (0x120L)"
weight: 288
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SOURCE היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE היא רשומת טקסט מקור וחלוקה למקטעים במסמך TOULMIN. משמעות: טקסט המקור של הכתיבה.

| פריט | ערך |
|---|---|
| שם | `SOURCE` (BIND `SOURCE` במסמך המפרט) |
| TAG ID | `0x120L` |
| Codec ID | `0x00001200` |
| מסמך מפרט | `0x00000000/codecs/0x00001200/` (יעד DECLARE `1200`) |
| קטע | 9 `1001` (Edge, פורמט TOULMIN), היסט C בתוך הקטע = 0 |
| Kind | Edge · משפחה: פורמט TOULMIN, פריסה: ID, WORD רוחב SPAN, UTF8 Value |
| TAG WORD | `0001 0010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | טקסט המקור של הכתיבה |
| בצד Hugo | `edge/toulmin/source.md` |

## פריסה {#레이아웃}

זהו כל טקסט המקור של הכתיבה. כל SPAN הוא טווח בייטים בתוך טקסט המקור הזה.

```
ID
WORD רוחב SPAN     2 הביטים העליונים = רוחב (00=1, 01=2, 10=4, 11=8 WORD), 14 הביטים הנותרים = 0
טקסט מקור          רשומת UTF8-TEXT Value
```

- SOURCE היא הרשומה הראשונה ב-BODY. יש אחת במסמך.
- SPAN הוא שני שדות: בייט התחלה ומספר בייטים. כל שדה הוא מספר שלם unsigned ברוחב שקובע ה-WORD של רוחב SPAN (‏1/2/4/8 WORD).
- זהו Codec שונה מ-Edge הראיות [SOURCE](../edge/0x0C0L-source.md) (`0x0C0L`).
- ID הוא Edge Id, ו-REF הוא ה-Edge Id של רשומת המסמך הזו (שדות משותפים של [TOULMIN](_index.md#공통-필드)). אין שדות Issuer ומספר Codec; ה-Payload בא אחרי ה-TAG.

## מסמך Codec {#코덱-문서}

מסמך ה-Codec מכיל DECLARE (יעד `1200`). הצהרת השדות תיקבע יחד עם מסמך המפרט של Codec ב-TOULMIN ([TOULMIN](_index.md#열린-문제)).

## דפים קשורים {#관련-페이지}

- [SOURCE ומקטעים](_index.md#source와-구획), [TOULMIN](_index.md)

## נוסח מקור של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00001200/latest.geul` כשקוראים אותו באמצעות `geul show` (הספרות ההקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000120000000000
BODY
#1 DECLARE 0x1200
#2 BIND #1 "SOURCE"
```
