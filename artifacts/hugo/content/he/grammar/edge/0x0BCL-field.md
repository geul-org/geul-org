---
title: "FIELD (0x0BCL)"
weight: 188
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD היא Edge של היגד שמצהירה על שדה אחד ב-Payload של Codec."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `FIELD` (BIND במסמך המפרט `FIELD`) |
| TAG ID | `0x0BCL` |
| Codec ID | `0x00000BC0` |
| מסמך מפרט | `0x00000000/codecs/0x00000BC0/` (יעד DECLARE‏ `0BC0`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 28 |
| Kind | Edge · משפחה: היגד, קבוצה: אחר |
| TAG WORD | `0000 1011 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | שדה אחד ב-Payload. ה-DECLARE שאליו הוא שייך, הרוחב: רשומה (ה-Length של ה-TAG) או ערך גולמי של n WORD |
| בצד Hugo | `edge/field.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `declare` | #2 | רשומה | `0050` LOCAL |  |
| 2 | `width` | #3 | ערך גולמי, WORD אחד |  | `0x0000` record, ‏`0xFFFF` rest |

FIELD היא Edge של היגד שמצהירה על שדה אחד ב-Payload של Codec. Codec‏ `0x0BCL`.

ה-FIELD מצביע על ה-[DECLARE](0x0BBL-declare.md) שלו. ה-FIELD-ים שמצביעים על DECLARE אחד בונים את ה-Payload לפי הסדר שלהם במסמך. הפריסה מובנית במפענח ([מסמך מפרט Codec](../codec-spec.md)).

## פריסה {#레이아웃}

```
TAG WORD          0000 1011 1100 LLLL
Edge Id           רשומת LOCAL Reference
DECLARE           רשומת LOCAL Reference. ה-Edge של DECLARE שהשדה הזה שייך אליו
רוחב              WORD אחד. 0 = רשומה, n (1~65534) = ערך גולמי של n WORD, ‏0xFFFF = שאר הערך הגולמי
```

## פירוש ותוקף {#해석과-유효성}

- ה-DECLARE מצביע על Edge של DECLARE באותו מסמך. FIELD אחד שייך ל-DECLARE אחד בלבד. הסדר אינו נכתב בנפרד, והוא הסדר שבו רשומות FIELD מונחות במסמך.
- מסמך המפרט של FIELD מצהיר על ה-DECLARE כשדה ברוחב `0` (רשומה) עם CODEC‏ `0050` (LOCAL). לכן בגרף של המציג הוא מצויר כחיבור FIELD ← DECLARE.
- רוחב `0` הוא שדה של רשומה. הוא מתחיל ב-TAG WORD ונקרא לפי ה-Length של אותו TAG (כללי הפירוש של [DECLARE](0x0BBL-declare.md)).
- רוחב `n` (1~65534) הוא שדה של ערך גולמי. הוא תמיד בדיוק n WORD.
- רוחב `0xFFFF` הוא שאר הערך הגולמי. מציבים רק אחד ב-DECLARE, ואפשר בהתחלה, באמצע או בסוף. הרוחב הוא ה-WORD שנותרו לפי ה-Length של ה-TAG של הרשומה החיצונית פחות רוחב השדות שאחריו. לכן כל השדות אחרי שדה השאר חייבים להיות ערכים גולמיים ברוחב קבוע (את סוף הרשומה אפשר לדעת רק בקריאה מההתחלה). אפשר שיהיה 0 WORD. לא מצרפים ENUM.
- ה-Kind וה-Codec ששדה מקבל נקבעים באמצעות [CODEC](0x0BEL-codec.md). שדה של רשומה בלי CODEC מקבל כל רשומה, ואם יש, חייב להיות אחד מהם. אם מציבים CODEC אחד בשדה של ערך גולמי, הערך הגולמי מפורש כאותו Value בלי ה-TAG.
- שם השדה נקשר ל-Edge Id של ה-FIELD באמצעות [BIND](0x0A3L-bind.md) (למשל: `doc`, ‏`hash`). כל UTF8-TEXT שמצורף ל-DECLARE, FIELD, ENUM ו-CODEC נעשה באמצעות BIND, ולא מצרפים אותו באמצעות Edge אחרת כמו LABEL.
- משמעות ערכי הקוד של שדה ערך גולמי מצורפת באמצעות [ENUM](0x0BDL-enum.md).
- שדה שמצביע על צומת אחר בגרף אינו מסומן בנפרד. אם שדה של רשומה הוא Reference, זה החיבור.

## אורך {#길이}

```
סה"כ = 1 + 2 + 2 + 1 WORD   (כש-Edge Id ו-DECLARE הם LOCAL בני WORD אחד)
```

## דוגמה (לא נורמטיבית) {#예시-비규범}

- שדה של רשומה: Edge Id הוא 7, ‏DECLARE‏ #1, רוחב `0`. TAG 1 + Edge Id 2 + DECLARE 2 + רוחב 1 = 6 WORD. כדי שיקבל רק LOCAL, ראו את הדוגמה של [CODEC](0x0BEL-codec.md).

```
0BC5 0051 0007 0051 0001 0000
```

- לשדה של ערך גולמי כמו hash תוכן, ראו את הדוגמה של [DECLARE](0x0BBL-declare.md).

## דפים קשורים {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [מסמך מפרט Codec](../codec-spec.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000BC0/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BC000000000
BODY
#1 DECLARE 0x0BC0
#2 FIELD #1 record
#13 CODEC #2 0x0050
#3 FIELD #1 0x0001
#5 ENUM #3 0x0000
#6 ENUM #3 0xFFFF
#7 BIND #1 "FIELD"
#8 BIND #2 "declare"
#9 BIND #3 "width"
#11 BIND #5 "record"
#12 BIND #6 "rest"
```
