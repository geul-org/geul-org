---
title: "DECLARE (0x0BBL)"
weight: 187
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE היא Edge של היגד שמצהירה על מבנה ה-Payload של Codec אחד."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `DECLARE` (BIND במסמך המפרט `DECLARE`) |
| TAG ID | `0x0BBL` |
| Codec ID | `0x00000BB0` |
| מסמך מפרט | `0x00000000/codecs/0x00000BB0/` (יעד DECLARE‏ `0BB0`) |
| קטע | 5 `0101` (Edge של היגד), היסט C בתוך הקטע = 27 |
| Kind | Edge · משפחה: היגד, קבוצה: אחר |
| TAG WORD | `0000 1011 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | הצהרה על מבנה ה-Payload של Codec אחד. ה-Kind וה-Codec של היעד |
| בצד Hugo | `edge/declare.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

הסדר של FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט Codec](../codec-spec.md)). ה-Edge Id של Edge אינו מוצהר באמצעות FIELD.

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | ערך גולמי, WORD אחד |  |  |
| 2 | `issuer` | #3 | שאר הערך הגולמי (`0xFFFF`) |  |  |

DECLARE היא Edge של היגד שמצהירה על מבנה ה-Payload של Codec אחד. Codec‏ `0x0BBL`.

יחד עם [FIELD](0x0BCL-field.md) (‏`0x0BCL`), ‏[ENUM](0x0BDL-enum.md) (‏`0x0BDL`) ו-[CODEC](0x0BEL-codec.md) (‏`0x0BEL`), זהו אוצר המילים לכתיבת מפרט Codec ([מסמך מפרט Codec](../codec-spec.md)). הפריסה של ארבע ה-Edge מובנית במפענח. כל מסמך מפרט Codec שנכתב באוצר מילים זה הוא מסמך רגיל. מפרט אחד משרת יחד אימות, פירוק והצגה (במציג). המציג אינו מחזיק קוד לכל Codec אלא מצייר לפי המפרט.

## פריסה {#레이아웃}

```
TAG WORD          0000 1011 1011 LLLL
[Length extension TAG]
Edge Id           רשומת LOCAL Reference
יעד               WORD אחד. מתוך ה-TAG WORD של ה-Codec המוצהר משתמשים רק במקום ה-Codec (קטע ו-C) (LLLL = 0)
[Issuer·מספר Codec] כשמצהירים על Codec של Issuer. Issuer ומספר Codec ב-2 WORD. אותה פריסה כמו Codec extension TAG, ושלושת ה-Kind זהים
                  מסמך המפרט של קוד ISSUER עצמו (GEUL Issuer) כולל רק את היעד
```

- רשימת השדות אינה נמצאת ב-DECLARE. כל [FIELD](0x0BCL-field.md) מצביע על ה-DECLARE שלו, והסדר של אותם FIELD במסמך הוא סדר שדות ה-Payload.

## כללי פירוש {#해석-규칙}

אלה הכללים לקריאה ולהצגה של רשומה לפי מפרט Codec.

- שדה של ערך גולמי נקרא במספר ה-WORD הקבוע ש-FIELD הצהיר עליו. שדה אחד יכול להיות שאר הערך הגולמי (רוחב `0xFFFF`), והוא נקרא כשאר ה-WORD פחות רוחב השדות הקבועים שאחריו. אחרי שדה השאר באים רק ערכים גולמיים ברוחב קבוע.
- שדה של רשומה מתחיל ב-TAG WORD, ונקרא לפי ה-Length של אותו TAG.
- שדה של ערך גולמי הוא מספר שלם ללא סימן בן n WORD ב-big-endian. הכתיבה היא `0x` + רוחב×4 ספרות hex, ואם יש ENUM של אותו ערך, כותבים יחד איתו גם את שם ה-BIND שלו.
- משמעות שדה של רשומה נקבעת על ידי מפרט ה-Codec של אותה רשומה. ערך שדורש פירוש, כמו סימן, שבר או תאריך, לא נכתב כערך גולמי אלא כרשומת Value.

אין כללי גבול נוספים. Codec שיש בו שני ערכים גולמיים משתנים או יותר, או שאחרי ערך גולמי משתנה באים רשומה או שדה משתנה, או שרוחב הערך הגולמי שלו תלוי בערך של שדה אחר או במצב המסמך, אי אפשר להצהיר עליו באוצר מילים זה. בפריסה כזו עוטפים את החלק המשתנה ברשומה כך שנשאר רק אחד (למשל: החותם ב-SIGNATURE הוא רשומת Reference).

## תוקף {#유효성}

- ה-Kind של היעד הוא אחד מ-Reference, Value, Edge, Meta. מסמך המפרט של קוד ישיר של GEUL הוא אחד לכל קוד. גם מערכת ה-5Q של Reference מוצהרת בנפרד לכל קוד כימות (LOCAL Identified‏ `0050`, ‏Generic‏ `0060`, …). גם מצביעים (‏`0x040L`, ‏`0x041L`, ‏`0x042L`), סמני מקום וקוד ISSUER הם הקוד עצמו. Codec של Issuer שנקבע על ידי Issuer ומספר Codec שאחרי קוד ISSUER מוגדר במסמכי אותו Issuer.
- גם [סמן מקום](../slot-marker.md) (Reference‏ `0x000L~0x002L`) הוא יעד של DECLARE. אין לו Payload, ולכן יש רק DECLARE בלי FIELD. המשמעות של הסמן וכללי הקבלה שלו מובנים במפענח (שכבה 0). גם Codec שהפריסה שלו טרם נקבעה (SUPERSEDE-CHAIN, ‏VERDICT, ‏EVIDENCE וכד') כולל רק DECLARE.
- ה-Edge Id של Edge אינו מוצהר באמצעות FIELD. הוא הרכיב הראשון בכל Edge, ולכן משתמע ([Edge](_index.md)). ב-EDGE-ISSUER הוא הרכיב הראשון אחרי Issuer ומספר Codec ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)).
- השדות של DECLARE הם ה-FIELD שמצביעים עליו, ואפשר שיהיו 0. FIELD אחד שייך ל-DECLARE אחד בלבד. גם שדה באותה צורה מקבל FIELD נפרד בכל DECLARE.
- ב-DECLARE אין דבר מלבד היעד (ו-Issuer ומספר Codec של יעד בפורמט Issuer).
- הסמן אחרי קריאת השדות לפי הסדר חייב להתלכד בדיוק עם סוף הרשומה. אם נשאר או חסר, הרשומה מפרה את המפרט.
- לא מצהירים על אותו יעד פעמיים במסמך אחד.
- וריאנטים שנבדלים בשדות הזנב לא נכתבים כענפים. לכל Codec יש DECLARE נפרד.

## מסמך מפרט {#규격-문서}

- מסמך המפרט של קוד ישיר הוא מסמך ה-Codec של GEUL Issuer‏ `0x00000000`. מזהה ה-Codec הוא TAG WORD היעד (L=0) כתוב ב-32 ביט (`0x0B80` ← `0x00000B80`), והוא מתפרסם ב-`<Issuer>/codecs/<מזהה Codec>/` עם מזהה גרסה ו-`versions.geul` ([מסמך מפרט Codec](../codec-spec.md)).
- מסמך ה-Codec של Codec של Issuer נמצא ב-`<Issuer>/codecs/<מספר Codec>/` של אותו Issuer. מספר ה-Codec אינו מתנגש בתוך אותו Issuer, בלי קשר ל-Kind. המפרש רואה בכך שגיאה אם ה-Kind של הרשומה שונה מה-Kind של יעד ה-DECLARE ([כתובת פרסום ורשימת גרסאות](../publishing.md#id-표기)).
- במסמך מפרט אחד יש DECLARE אחד, והיעד שלו חייב להיות שווה ל-TAG WORD של מזהה ה-Codec. ה-`DOC-ID` הוא [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (‏`0x00000000`, מזהה ה-Codec הזה, `0`).

## שם {#이름}

- שם ה-Codec נקשר ל-Edge Id של ה-DECLARE באמצעות [BIND](0x0A3L-bind.md) (למשל: `PUBLICATION`). כל UTF8-TEXT שמצורף ל-DECLARE, FIELD, ENUM ו-CODEC נעשה באמצעות BIND, ולא מצרפים אותו באמצעות Edge אחרת כמו LABEL.
- שם שדה ושם enum נקשרים באותה דרך ל-FIELD ול-ENUM.

## דוגמה {#예시}

מסמך המפרט `0x00000000/codecs/0x00000B80/` של PUBLICATION (Edge ‏`0x0B8L`): אחרי ה-Edge Id באים רשומת DOC-POINTER ו-hash תוכן של 16 WORD.

```
0BB3 0051 0001 0B80                 DECLARE #1  Edge 0x0B8L               (BIND "PUBLICATION")
0BC5 0051 0002 0051 0001 0000       FIELD #2    DECLARE #1, רשומה          (BIND "doc")
0BE5 0051 0009 0051 0002 0410       CODEC #9    FIELD #2, DOC-POINTER
0BE5 0051 000A 0051 0002 0420       CODEC #10   FIELD #2, CODEC-POINTER (רשימת גרסאות של Codec)
0BC5 0051 0004 0051 0001 0010       FIELD #4    DECLARE #1, ערך גולמי 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + יעד 1 = 4 WORD, ‏`LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + רוחב 1 = 6 WORD (‏`LLLL = 0101`). ה-Kind וה-Codec המתקבלים מוצבים בנפרד באמצעות [CODEC](0x0BEL-codec.md) (‏`0410` = DOC-POINTER, ‏`0420` = CODEC-POINTER).
- שדה אופציונלי מוצהר עם יעד CODEC‏ `0000`. במקום שהושמט כותבים ABSENT (‏`0x0000`) ([CODEC](0x0BEL-codec.md), שדה אופציונלי).
- סדר השדות הוא הסדר שבו FIELD‏ #2 ו-#4 מונחים במסמך. ה-Edge Id-ים לא חייבים להיות רצופים (LOCAL AUTO INCREMENT הוא המלצה).

## בעיות פתוחות {#열린-문제}

- חזרה. מבנה שבו ערך גולמי קודם קובע את הכמות, כמו “ארגומנט × מספר ארגומנטים” ב-`CALL`. כרגע אי אפשר להצהיר עליו.
- דרך ההצהרה על Codec שיש לו תת-פורמטים (TAG לפי Codec), כמו WORLD.
- לאיזו חבילת גרסאות של מסמכי המפרט של הקודים הישירים מתייחס `SPEC-VERSION`.

## דפים קשורים {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Edge](_index.md), [מסמך מפרט Codec](../codec-spec.md)

## טקסט מקורי של מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000BB0/latest.geul` כשהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BB000000000
BODY
#1 DECLARE 0x0BB0
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "DECLARE"
#5 BIND #2 "target"
#6 BIND #3 "issuer"
```
