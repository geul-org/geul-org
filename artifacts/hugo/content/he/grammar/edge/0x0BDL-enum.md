---
title: "ENUM (0x0BDL)"
weight: 189
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM היא Edge של היגד שמצרפת משמעות לערך קוד אחד של שדה ערך גולמי."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `ENUM` (BIND במסמך המפרט `ENUM`) |
| TAG ID | `0x0BDL` |
| Codec ID | `0x00000BD0` |
| מסמך מפרט | `0x00000000/codecs/0x00000BD0/` (יעד DECLARE‏ `0BD0`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 29 |
| Kind | Edge · משפחה: היגד, קבוצה: אחר |
| TAG WORD | `0000 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | ערך קוד אחד של שדה ערך גולמי. השדה, ערך הקוד |
| בצד Hugo | `edge/enum.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | רשומה | `0050` LOCAL |  |
| 2 | `code` | #3 | שאר הערך הגולמי (`0xFFFF`) |  |  |

ENUM היא Edge של היגד שמצרפת משמעות לערך קוד אחד של שדה ערך גולמי. Codec‏ `0x0BDL`.

יחד עם [FIELD](0x0BCL-field.md), זהו אוצר המילים לכתיבת מפרט Codec. הפריסה מובנית במפענח ([מסמך מפרט Codec](../codec-spec.md)).

## פריסה {#레이아웃}

```
TAG WORD          0000 1011 1101 LLLL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
שדה               רשומת LOCAL Reference שמצביעה על Edge של FIELD
ערך קוד           ערך גולמי. מספר WORD כמו הרוחב של אותו FIELD
```

## פירוש ותוקף {#해석과-유효성}

- השדה חייב להיות FIELD של ערך גולמי (רוחב `n ≥ 1`). לא מצרפים ENUM לשדה של רשומה. משמעות הרשומה נקבעת על ידי ה-Codec של אותה רשומה.
- ערך הקוד הוא בדיוק ברוחב ה-FIELD. הגבולות נבדקים לפי ה-Length של רשומת ה-ENUM.
- לא מצהירים על אותו ערך קוד פעמיים באותו שדה.
- שם ערך הקוד נקשר ל-Edge Id של ה-ENUM באמצעות [BIND](0x0A3L-bind.md). כל UTF8-TEXT שמצורף ל-DECLARE, FIELD, ENUM ו-CODEC נעשה באמצעות BIND, ולא מצרפים אותו באמצעות Edge אחרת כמו LABEL.
- ערך קוד שלא הוצהר אינו שגיאה. המציג מציג אותו כערך גולמי. אם לסגור את הערכים המותרים, זה עניין של מפרט ה-Codec, ובאוצר המילים הנוכחי אין סימון לסגירה.

## אורך {#길이}

```
סה"כ = 1 + N_len + N_id + N_field + n WORD
```

## דוגמה (לא נורמטיבית) {#예시-비규범}

בשדה קטגוריית הסיבה (FIELD‏ #4, ערך גולמי של WORD אחד) במסמך המפרט של TOMBSTONE מצהירים על הקוד `0x0001`. ה-Edge Id הוא 10. השם נקשר בנפרד באמצעות BIND. טבלת הקודים של קטגוריית הסיבה טרם נקבעה, ולכן ערך הקוד הוא דוגמה.

- TAG 1 + Edge Id 2 + שדה 2 + ערך קוד 1 = 6 WORD, ‏`LLLL = 0101`.

```
0BD5 0051 000A 0051 0004 0001
```

במסמך המפרט של TRIPLE מציבים שלושה ENUM (‏`0`·`1`·`2`) בשדה Rank (FIELD‏ #5) וקושרים אותם ב-BIND ל-`normal`·`preferred`·`deprecated` ([TRIPLE](0x0AAL-triple.md)).

## דפים קשורים {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [FIELD](0x0BCL-field.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [מסמך מפרט Codec](../codec-spec.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000BD0/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BD000000000
BODY
#1 DECLARE 0x0BD0
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "ENUM"
#5 BIND #2 "field"
#6 BIND #3 "code"
#7 CODEC #2 0x0050
```
