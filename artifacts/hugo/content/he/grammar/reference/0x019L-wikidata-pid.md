---
title: "WIKIDATA-PID (0x019L~0x01DL)"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID הוא Reference מצהיר המצביע על תכונה (Property) ב-Wikidata."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `WIKIDATA-PID` (קבוצת 5Q. שמות הקודים בטבלת החברים להלן) |
| TAG ID | `0x019L~0x01DL` |
| קטע | 0 `0000` (ישות Reference), היסט C בתוך הקטע = 25~29 |
| Kind | Reference · סיווג: הצהרה |
| צד Hugo | `reference/wikidata-pid.md` |

## חברים {#구성원}

דף זה עוסק בערכת 5Q שלמה, חמישה קודים יחד. הכימות הוא ההיסט בתוך הקטע `C % 5` ([Reference](_index.md#quantifier)). לכל קוד יש מסמך Codec אחד. השדות בחמשת מסמכי ה-Codec זהים, ורק יעד ה-DECLARE והשם (BIND) שונים.

| TAG ID | שם | כימות | Codec ID | מסמך מפרט | TAG WORD |
|---|---|---|---|---|---|
| `0x019L` | `WIKIDATA-PID-IDENTIFIED` | Identified | `0x00000190` | `0x00000000/codecs/0x00000190/` | `0000 0001 1001 LLLL` |
| `0x01AL` | `WIKIDATA-PID-GENERIC` | Generic | `0x000001A0` | `0x00000000/codecs/0x000001A0/` | `0000 0001 1010 LLLL` |
| `0x01BL` | `WIKIDATA-PID-FREE-CHOICE` | Free-choice | `0x000001B0` | `0x00000000/codecs/0x000001B0/` | `0000 0001 1011 LLLL` |
| `0x01CL` | `WIKIDATA-PID-UNIVERSAL` | Universal | `0x000001C0` | `0x00000000/codecs/0x000001C0/` | `0000 0001 1100 LLLL` |
| `0x01DL` | `WIKIDATA-PID-VARIABLE` | Variable | `0x000001D0` | `0x00000000/codecs/0x000001D0/` | `0000 0001 1101 LLLL` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך מפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מתקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `pid` | #2 | ערך גולמי לשארית (`0xFFFF`) |  |  |

WIKIDATA-PID הוא Reference מצהיר המצביע על תכונה (Property) ב-Wikidata. כותבים את החלק המספרי של ה-P ID, בלי ה-`P`, כמספר שלם ללא סימן.

## פריסה {#레이아웃}

```
TAG WORD          0000 0001 1001 LLLL      Codec 0x019L~0x01DL (Identified 0x019L)
[Length TAG הרחבה]
PID               unsigned big-endian ברוחב הקצר ביותר
```

- כותבים את ה-PID ברוחב הקצר ביותר. מספרי התכונות כיום נכנסים ב-WORD אחד ותופסים בסך הכול 2 WORD, ומעל 65535 הם מתארכים באופן טבעי ל-3 WORD.
- משמש בעיקר במקום Predicate של [TRIPLE](../edge/0x0AAL-triple.md) ובמקום Property של [QUALIFIER](../edge/0x0ABL-qualifier.md).

## דוגמה {#예시}

| תכונה | WORD sequence |
|---|---|
| `P31` (instance of) | `0191 001F` |
| `P279` (subclass of) | `0191 0117` |
| `P569` (date of birth) | `0191 0239` |

## דפים קשורים {#관련-페이지}

- [Reference](_index.md), [WIKIDATA-QID](0x014L-wikidata-qid.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## נוסח מסמך המפרט {#규격-문서-원문}

כך נראה מסמך המפרט `0x00000000/codecs/0x00000190/latest.geul` כשקוראים אותו ב-`geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000019000000000
BODY
#1 DECLARE 0x0190
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-PID-IDENTIFIED"
#4 BIND #2 "pid"
```

למעלה מסמך ה-Codec של `WIKIDATA-PID-IDENTIFIED` (`0x019L`). במסמכי ה-Codec של שאר החברים (`WIKIDATA-PID-GENERIC`, `WIKIDATA-PID-FREE-CHOICE`, `WIKIDATA-PID-UNIVERSAL`, `WIKIDATA-PID-VARIABLE`) שונים רק ה-Codec ID שב-DOC-ID, יעד ה-DECLARE והשם שנקשר ב-`#1` (BIND).
