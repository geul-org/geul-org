---
title: "CIVIL-TIME-NANOSECONDS (0x06BL)"
weight: 107
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS מייצג שעה אזרחית ללא תאריך כמספר nanosecond מאז חצות."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `CIVIL-TIME-NANOSECONDS` (מסמך מפרט BIND `CIVIL-TIME-NANOSECONDS`) |
| TAG ID | `0x06BL` |
| Codec ID | `0x000006B0` |
| מסמך מפרט | `0x00000000/codecs/0x000006B0/` (יעד DECLARE `06B0`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 11 |
| Kind | Value · משפחה: TIME |
| TAG WORD | `0000 0110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | מניין unsigned של nanosecond מאז חצות של יום אזרחי |
| בצד Hugo | `value/time/civil-time-nanoseconds.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | ערך גולמי, 4 WORD |  |  |

CIVIL-TIME-NANOSECONDS מייצג שעה אזרחית ללא תאריך כמספר nanosecond מאז חצות.

## פריסה {#레이아웃}

- קוד: קוד ישיר של Value `0x06BL`. משפחה TIME.
- נעשה שימוש בטיפוס פיזי signed int64 ברוחב קבוע, כמו `TIME(isAdjustedToUTC=false, unit=NANOS)` של Parquet.

```
TAG WORD          0x06B4 (0000 0110 1011 0100)  סך הכול 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## פירוש ותוקף {#해석과-유효성}

- ארבעת ה-WORD של ה-Payload נקראים כולם כמניין signed בן 64 סיביות בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטיפוס הפיזי הוא signed int64, אך הטווח התקף הוא `0 <= value < 86,400×10^9`ns. ערך שלילי וערך השווה לגבול העליון או גדול ממנו נדחים.
- `24:00` ותווית שניית מעבר (leap second) אינם מותרים. גם תאריך, אזור זמן והיסט UTC אינם נשמרים.
- גם ערך קטן תמיד נכתב ב-4 WORD.

## אורך {#길이}

- הסך הכול הוא בדיוק 5 WORD, TAG אחד ו-Payload של 4 WORD, ונעשה שימוש באורך הישיר `LLLL=0100`. אין TAG הרחבת Length, אין descriptor ואין padding.
- אם ה-Payload אינו 4 WORD בדיוק, הוא נדחה.

## דוגמה {#예시}

- חצות היא Payload `0000 0000 0000 0000`, סך הכול 5 WORD, `LLLL=0100`.
- 1ns אחרי חצות הוא Payload `0000 0000 0000 0001`.
- `86,400×10^9`ns שווה לגבול העליון, ולכן אינו תקף.
- `FFFF FFFF FFFF FFFF` הוא -1 כ-signed int64, ולכן אינו תקף.

## בסיס תקני {#표준-근거}

- `TIME(isAdjustedToUTC=false, unit=NANOS)` ב-[Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) שומר nanosecond מאז חצות של local time ב-`int64`, ובעל סדר signed.
- לפי [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) ו-[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) הסמכותי, Time ברזולוציית NANOSECOND מוגדר כמספר שלם signed בן 64 סיביות, הטווח התקף מוגבל לפחות מ-86,400 שניות כולל חצות, ואינו מתיר שניית מעבר. GEUL מוסיף רק TAG ומסגור WORD של 16 סיביות big-endian.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x000006B0/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006B000000000
BODY
#1 DECLARE 0x06B0
#2 FIELD #1 0x0004
#3 BIND #1 "CIVIL-TIME-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
