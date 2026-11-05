---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER הוא Reference מכוון-מצהיר המצביע על ה-Issuer עצמו."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `ISSUER-POINTER` (מסמך מפרט BIND `ISSUER-POINTER`) |
| TAG ID | `0x040L` |
| Codec ID | `0x00000400` |
| מסמך מפרט | `0x00000000/codecs/0x00000400/` (יעד DECLARE `0400`) |
| קטע | 2 `0010` (Reference שונים), היסט C בתוך הקטע = 0 |
| Kind | Reference · סיווג: מכוון-מצהיר |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| צד Hugo | `reference/issuer-pointer.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | ערך גולמי לשארית (`0xFFFF`) |  |  |

ISSUER-POINTER הוא Reference מכוון-מצהיר המצביע על ה-Issuer עצמו. הוא יכול להיות יעד של `BIND` שם ה-Issuer, של `LABEL` ושל Edge של פסק דין.

## פריסה {#레이아웃}

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[Length TAG הרחבה]
Issuer            2/4/16 WORD
```

- רוחב ה-Issuer הוא כל ה-Payload. ה-Codec אינו מחלק את הרוחב. אם הרוחב אינו 2, 4 או 16 WORD, או שערך ה-Issuer נכנס ברוחב צר יותר, זה invalid (צורה קנונית של Issuer).
- אם ה-Issuer הוא 16 WORD, הסך הכול 17 WORD, ולכן מצורף WORD אחד של הרחבת Length.
- זהו מקום אחד, Codec `0x040L`. אין כימות (Identified).
- ערך ה-Issuer נקבע לפי ההקצאה ב-[Issuer](../issuer.md).
- שימושים: Subject של BIND ברשימת ה-Issuer `issuers/` ([כתובת הפרסום ורשימת הגרסאות](../publishing.md#issuer-목록)), LABEL של שם התצוגה של ה-Issuer, פסק דין על Issuer, חותם, וכל מקום אחר שבו ה-Issuer עצמו הוא היעד.
- הצורה היחידה להצבעה על ה-Issuer עצמו היא ISSUER-POINTER. הצבעה על Issuer באמצעות `EXTERNAL-ISSUER-*` עם ID מסמך `0` ו-ID יעד `0` היא invalid.

## דוגמה {#예시}

| Issuer | WORD sequence |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## דפים קשורים {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [Issuer ופרסום](../issuer.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000400/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
