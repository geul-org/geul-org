---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER הוא Reference מכוון-מצהיר המצביע על גרסה אחת של מסמך Codec שפרסם Issuer."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER הוא Reference מכוון-מצהיר המצביע על גרסה אחת של מסמך Codec שפרסם Issuer. למסמך Codec אין ID מסמך, והוא מצביע על עצמו ועל גרסתו ב-CODEC-POINTER.

| פריט | ערך |
|---|---|
| שם | `CODEC-POINTER` (מסמך מפרט BIND `CODEC-POINTER`) |
| TAG ID | `0x042L` |
| Codec ID | `0x00000420` |
| מסמך מפרט | `0x00000000/codecs/0x00000420/` (יעד DECLARE `0420`) |
| קטע | 2 `0010` (Reference שונים), היסט C בתוך הקטע = 2 |
| Kind | Reference · סיווג: מכוון-מצהיר |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | גרסה אחת של Codec של Issuer. Issuer + Codec ID של 2 WORD + ID גרסה של 2 WORD, בלי ID יעד |
| צד Hugo | `reference/codec-pointer.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | ערך גולמי לשארית (`0xFFFF`) |  |  |
| 2 | `codec` | #3 | ערך גולמי 2 WORD |  |  |
| 3 | `version` | #4 | ערך גולמי 2 WORD |  |  |

## פריסה {#레이아웃}

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[Length TAG הרחבה]
Issuer            2/4/16 WORD
Codec ID          2 WORD
ID גרסה           2 WORD
```

## פירוש ותוקף {#해석과-유효성}

- רוחב ה-Issuer הוא מה שנותר מה-Payload אחרי הפחתת 4 WORD של Codec ID ו-ID הגרסה. ה-Payload הוא אחד מ-6, 8 או 20 WORD, וכל אורך אחר הוא invalid. אם ערך ה-Issuer נכנס ברוחב צר יותר, זה invalid (צורה קנונית של Issuer).
- אם ה-Issuer הוא 16 WORD, הסך הכול 21 WORD, ולכן מצורף WORD אחד של הרחבת Length.
- ה-Codec ID הוא 32 ביט. ה-Codec ID של direct code של GEUL הוא ערך ה-TAG WORD שלו (L=0) כ-32 ביט (TRIPLE `0x0AAL` → `0x00000AA0`). ה-Codec ID של Codec של Issuer הוא מספר ה-Codec של הרשומה, וה-Issuer קובע אותו בתוך ה-`codecs/` שלו כך שלא יחפוף, בלי קשר ל-Kind ([כתובת הפרסום ורשימת הגרסאות](../publishing.md#id-표기)).
- ID גרסה `0` הוא הגרסה העדכנית. כל ערך אחר מקבע את הגרסה הזאת.
- זהו מקום אחד, Codec `0x042L`. אין כימות (Identified). מכיוון שהוא בקטע 2, אין לקרוא אותו ככימות או כערכה.
- היכן משתמשים: Meta [DOC-ID](../meta/0x1C7L-doc-id.md) של מסמך Codec, [PUBLICATION](../edge/0x0B8L-publication.md), DEPRECATION ו-TOMBSTONE ברשימת גרסאות ה-Codec, ו-[IMPORT-DOC](../meta/0x1E4L-import-doc.md) שמייבא מסמך Codec. במקומות אלה הוא בא במקום DOC-POINTER.
- כתובת הפרסום היא `/.well-known/geul/<Issuer>/codecs/<Codec ID>/<ID גרסה>.geul` ([כתובת הפרסום ורשימת הגרסאות](../publishing.md#공표-주소)).

## דוגמה {#예시}

Codec של TRIPLE של Issuer GEUL `0x00000000` (Codec ID `0x00000AA0`).

| גרסה | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| עדכנית (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + Codec ID 2 + ID גרסה 2 = 7 WORD, ו-`LLLL=0110`. ה-TAG הוא `0000 0100 0010 0110` = `0426`.

## דפים קשורים {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [מסמך מפרט של Codec](../codec-spec.md)
- [כתובת הפרסום ורשימת הגרסאות](../publishing.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000420/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
