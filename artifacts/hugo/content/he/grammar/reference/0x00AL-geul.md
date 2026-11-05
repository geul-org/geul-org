---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL הוא Reference מצהיר המצביע על ישויות ש-geul.org מנפיק ברישיון CC0."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `GEUL` (קבוצת 5Q. שמות הקודים בטבלת החברים להלן) |
| TAG ID | `0x00AL~0x00EL` |
| קטע | 0 `0000` (ישות Reference), היסט C בתוך הקטע = 10~14 |
| Kind | Reference · סיווג: הצהרה |
| צד Hugo | `reference/geul.md` |

## חברים {#구성원}

דף זה עוסק בערכת 5Q שלמה, חמישה קודים יחד. הכימות הוא ההיסט בתוך הקטע `C % 5` ([Reference](_index.md#quantifier)). לכל קוד יש מסמך Codec אחד. השדות בחמשת מסמכי ה-Codec זהים, ורק יעד ה-DECLARE והשם (BIND) שונים.

| TAG ID | שם | כימות | Codec ID | מסמך מפרט | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | ערך גולמי לשארית (`0xFFFF`) |  |  |

GEUL הוא Reference מצהיר המצביע על ישויות ש-geul.org מנפיק ברישיון CC0. זהו ID סידורי שהמספר שלו אינו נושא משמעות. מזהה שהביטים שלו נושאים משמעות נמצא ב-Codec נפרד, [GEUL-SIDX](0x00FL-geul-sidx.md) (`0x00FL~0x013L`).

## פריסה {#레이아웃}

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[Length TAG הרחבה]
GEUL ID           unsigned big-endian ברוחב הקצר ביותר
```

- מספרים קטנים מוקצים לישויות בתדירות גבוהה. ID שנכנס ב-WORD אחד תופס בסך הכול 2 WORD.
- הקצאת ה-ID והרישום מנוהלים על ידי geul.org. ברישום נכנס רק מה שמקורו במקורות CC0.
- ב-Variable זהו משתנה אנונימי מאותו סוג ([Reference](_index.md) Variable).

## דוגמה {#예시}

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## בעיות פתוחות {#열린-문제}

- כללי הקצאת GEUL ID והפורמט הציבורי של הרישום.

## דפים קשורים {#관련-페이지}

- [Reference](_index.md), [GEUL-SIDX](0x00FL-geul-sidx.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x000000A0/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

למעלה מסמך ה-Codec של `GEUL-IDENTIFIED` (`0x00AL`). במסמכי ה-Codec של שאר החברים (`GEUL-GENERIC`, `GEUL-FREE-CHOICE`, `GEUL-UNIVERSAL`, `GEUL-VARIABLE`) שונים רק ה-Codec ID שב-DOC-ID, יעד ה-DECLARE והשם שנקשר ב-`#1` (BIND).
