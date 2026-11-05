---
title: "DURATION-NANOSECONDS (0x081L)"
weight: 129
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS הוא זמן שחלף ב-nanosecond עם סימן, ללא epoch."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS הוא זמן שחלף ב-nanosecond עם סימן (signed), ללא epoch. הוא אינו instant ואינו תקופה של חודשים או שנים בלוח השנה.

| פריט | ערך |
|---|---|
| שם | `DURATION-NANOSECONDS` (מסמך מפרט BIND `DURATION-NANOSECONDS`) |
| TAG ID | `0x081L` |
| Codec ID | `0x00000810` |
| מסמך מפרט | `0x00000000/codecs/0x00000810/` (יעד DECLARE ‏`0810`) |
| קטע | 4 `0100` (Value), היסט בתוך הקטע C = 1 |
| Kind | Value · משפחה: TIME |
| TAG WORD | `0000 1000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | זמן שחלף ב-nanosecond עם סימן, ללא epoch |
| בצד Hugo | `value/time/duration-nanoseconds.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | ערך גולמי, 4 WORD |  |  |

## פריסה {#레이아웃}

- קוד: קוד ישיר של Value ‏`0x081L`. משפחה TIME.
- משתמשים בטיפוס פיזי של signed int64 ברוחב קבוע, כמו `Duration(NANOSECOND)` של Arrow.

```
TAG WORD          0x0814 (0000 1000 0001 0100)  סך הכול 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## פירוש ותוקף {#해석과-유효성}

- קוראים את כל 4 ה-Payload WORD כספירה signed של 64 סיביות בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63`~`2^63-1` ns. הסימן הוא כיוון הזמן שחלף, והוא אינו מצביע על instant של epoch מסוים.
- גם ערך קטן משתמש תמיד ב-4 WORD.

## אורך {#길이}

- הסך הכול הוא בדיוק 5 WORD, ‏TAG של WORD אחד ו-Payload של 4 WORD, ומשתמשים באורך הישיר `LLLL=0100`. אין Length TAG של הרחבה, ואין descriptor ואין padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה {#예시}

- ‏0ns: ‏Payload ‏`0000 0000 0000 0000`, סך הכול 5 WORD, ‏`LLLL=0100`. השלם הוא `0814 0000 0000 0000 0000`.
- ‏1ns: ‏Payload ‏`0000 0000 0000 0001`.
- ‏-1ns: ‏Payload ‏`FFFF FFFF FFFF FFFF`.

## בסיס בתקנים {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) קובע את `Schema.fbs` כמקור הסמכותי לטיפוסי הנתונים התקניים של Arrow.
- ב-[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) הסמכותי של Arrow, ‏`Duration` הוא זמן שחלף מוחלט שאינו תלוי בלוח השנה, תומך ביחידת NANOSECOND ומיוצג תמיד כמספר שלם signed של 8 בייטים. GEUL מוסיפה לכך רק TAG ו-framing של WORD בן 16 סיביות ב-big-endian.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x00000810/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000081000000000
BODY
#1 DECLARE 0x0810
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
