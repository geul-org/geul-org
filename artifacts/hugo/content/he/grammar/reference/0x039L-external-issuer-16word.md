---
title: "EXTERNAL-ISSUER-16WORD (0x039L~0x03DL)"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER הוא Reference מכוון-מצהיר המצטט LOCAL ID של מסמך שפרסם Issuer, ברשומה אחת וללא IMPORT."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER הוא Reference מכוון-מצהיר המצטט LOCAL ID של מסמך שפרסם Issuer, ברשומה אחת וללא IMPORT.

| פריט | ערך |
|---|---|
| שם | `EXTERNAL-ISSUER-16WORD` (קבוצת 5Q. שמות הקודים בטבלת החברים להלן) |
| TAG ID | `0x039L~0x03DL` |
| קטע | 1 `0001` (Reference EXTERNAL), היסט C בתוך הקטע = 25~29 |
| Kind | Reference · סיווג: מכוון-מצהיר |
| צד Hugo | `reference/external-issuer.md` (הדף שם עוסק גם ב-[EXTERNAL-ISSUER-2WORD](0x02FL-external-issuer-2word.md) ו-[EXTERNAL-ISSUER-4WORD](0x034L-external-issuer-4word.md)) |

## חברים {#구성원}

דף זה עוסק בערכת 5Q שלמה, חמישה קודים יחד. הכימות הוא ההיסט בתוך הקטע `C % 5` ([Reference](_index.md#quantifier)). לכל קוד יש מסמך Codec אחד. השדות בחמשת מסמכי ה-Codec זהים, ורק יעד ה-DECLARE והשם (BIND) שונים.

| TAG ID | שם | כימות | Codec ID | מסמך מפרט | TAG WORD |
|---|---|---|---|---|---|
| `0x039L` | `EXTERNAL-ISSUER-16WORD-IDENTIFIED` | Identified | `0x00000390` | `0x00000000/codecs/0x00000390/` | `0000 0011 1001 LLLL` |
| `0x03AL` | `EXTERNAL-ISSUER-16WORD-GENERIC` | Generic | `0x000003A0` | `0x00000000/codecs/0x000003A0/` | `0000 0011 1010 LLLL` |
| `0x03BL` | `EXTERNAL-ISSUER-16WORD-FREE-CHOICE` | Free-choice | `0x000003B0` | `0x00000000/codecs/0x000003B0/` | `0000 0011 1011 LLLL` |
| `0x03CL` | `EXTERNAL-ISSUER-16WORD-UNIVERSAL` | Universal | `0x000003C0` | `0x00000000/codecs/0x000003C0/` | `0000 0011 1100 LLLL` |
| `0x03DL` | `EXTERNAL-ISSUER-16WORD-VARIABLE` | Variable | `0x000003D0` | `0x00000000/codecs/0x000003D0/` | `0000 0011 1101 LLLL` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | ערך גולמי 16 WORD |  |  |
| 2 | `doc` | #3 | ערך גולמי 4 WORD |  |  |
| 3 | `target-id` | #4 | ערך גולמי לשארית (`0xFFFF`) |  |  |

EXTERNAL-ISSUER הוא Reference מכוון-מצהיר המצטט LOCAL ID של מסמך שפרסם Issuer, בלי IMPORT. משמעותו שלמה ברשומה אחת, והוא עוקב אחר הגרסה העדכנית.

## פריסה {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (קטע 1)
[Length TAG הרחבה]
Issuer            ברוחב שנקבע ב-Codec (2/4/16 WORD)
ID מסמך           4 WORD
ID יעד            כל השאר. LOCAL ID של אותו מסמך, ברוחב הקצר ביותר
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | שם | רוחב Issuer |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD (רישום ב-geul.org, הוכחת דומיין) |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD (רישום ב-geul.org, ללא הוכחה) |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD (מחושב ממפתח ציבורי) |

- הרוחב נקבע לפי מספר הערכה: אם ערכה − 9 (`C / 5 − 3` של ההיסט `C` בתוך הקטע) הוא 0, 1 או 2, הרוחב הוא 2, 4 או 16 WORD. הכימות הוא `C % 5`.
- ה-Issuer ID הוא ערך שלם. ערכים שווים הם אותו Issuer. כותבים את ה-Issuer ברוחב הקצר ביותר שהערך נכנס בו ובוחרים את ה-Codec של אותו רוחב (4 WORD רק כשהערך `2^32` ומעלה, 16 WORD רק כשהערך `2^64` ומעלה). רישום ברוחב רחב יותר הוא invalid ([Issuer](../issuer.md)).
- רישום וניהול ה-Issuer נמצאים בידי geul.org.
- אין כותבים גרסה, והוא עוקב אחר הגרסה העדכנית. כדי לקבע גרסה משתמשים ב-[IMPORT-DOC](../meta/0x1E4L-import-doc.md) וב-[EXTERNAL-POINTER](0x020L-external-pointer-1word.md).
- המיקום נמצא לפי כללי כתובת הפרסום ([כתובת הפרסום ורשימת הגרסאות](../publishing.md)).
- אם זה אותו LOCAL ID של אותו מסמך, הוא אותו יעד, בין שנכתב בתוך אותו מסמך כ-LOCAL, בין שנכתב במסמך אחר כ-EXTERNAL-ISSUER ובין שנכתב כ-EXTERNAL-POINTER אחרי IMPORT.
- הוא מצביע רק על LOCAL של מסמך. המסמך עצמו מצביעים עליו ב-[DOC-POINTER](0x041L-doc-pointer.md), וה-Issuer עצמו ב-[ISSUER-POINTER](0x040L-issuer-pointer.md). לכן ID היעד אינו `0`. מסמך ID `0` הוא מסמך האינדקס של הגדרות המונחים של ה-Issuer.

## תקפות {#유효성}

- אם רוחב ה-Issuer אינו תואם ל-Codec, או שהערך נכנס ברוחב צר יותר, זה invalid.
- אם ID היעד הוא `0`, זה invalid. ID יעד `0` (המסמך עצמו) הוא תפקידו של DOC-POINTER.
- WORD מוביל `0x0000` ב-ID היעד אסור.

## דוגמה {#예시}

| יעד | WORD sequence |
|---|---|
| Issuer `0x00000002`, מסמך `0x…0002`, LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, מסמך `0x…0002`, LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## דפים קשורים {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer ופרסום](../issuer.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000390/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000039000000000
BODY
#1 DECLARE 0x0390
#2 FIELD #1 0x0010
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-16WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

למעלה מסמך ה-Codec של `EXTERNAL-ISSUER-16WORD-IDENTIFIED` (`0x039L`). במסמכי ה-Codec של שאר החברים (`EXTERNAL-ISSUER-16WORD-GENERIC`, `EXTERNAL-ISSUER-16WORD-FREE-CHOICE`, `EXTERNAL-ISSUER-16WORD-UNIVERSAL`, `EXTERNAL-ISSUER-16WORD-VARIABLE`) שונים רק ה-Codec ID שב-DOC-ID, יעד ה-DECLARE והשם שנקשר ב-`#1` (BIND).
