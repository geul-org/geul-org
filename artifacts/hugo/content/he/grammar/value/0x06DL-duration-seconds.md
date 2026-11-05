---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS הוא זמן שחלף ביחידות שניות signed, ללא epoch."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `DURATION-SECONDS` (מסמך מפרט BIND `DURATION-SECONDS`) |
| TAG ID | `0x06DL` |
| Codec ID | `0x000006D0` |
| מסמך מפרט | `0x00000000/codecs/0x000006D0/` (יעד DECLARE `06D0`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 13 |
| Kind | Value · משפחה: TIME |
| TAG WORD | `0000 0110 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | זמן שחלף ב-SI-second עם סימן, ללא epoch |
| בצד Hugo | `value/time/duration-seconds.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | ערך גולמי, 4 WORD |  |  |

DURATION-SECONDS הוא זמן שחלף ביחידות שניות signed, ללא epoch. הוא אינו instant ואינו משך בחודשים או בשנים של לוח השנה.

## פריסה {#레이아웃}

- קוד: קוד ישיר של Value `0x06DL`. משפחה TIME.
- נעשה שימוש בטיפוס פיזי signed int64 ברוחב קבוע, כמו `Duration(SECOND)` של Arrow.

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  סך הכול 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## פירוש ותוקף {#해석과-유효성}

- ארבעת ה-WORD של ה-Payload נקראים כולם כמניין signed בן 64 סיביות בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63`~`2^63-1` שניות. הסימן הוא כיוון הזמן שחלף, ואינו מצביע על instant של epoch מסוים.
- גם ערך קטן תמיד נכתב ב-4 WORD.

## אורך {#길이}

- הסך הכול הוא בדיוק 5 WORD, TAG אחד ו-Payload של 4 WORD, ונעשה שימוש באורך הישיר `LLLL=0100`. אין TAG הרחבת Length, אין descriptor ואין padding.
- אם ה-Payload אינו 4 WORD בדיוק, הוא נדחה.

## דוגמה {#예시}

- 0 שניות הוא Payload `0000 0000 0000 0000`, סך הכול 5 WORD, `LLLL=0100`.
- שנייה אחת היא Payload `0000 0000 0000 0001`.
- -1 שנייה היא Payload `FFFF FFFF FFFF FFFF`.

## בסיס תקני {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) קובע את `Schema.fbs` כמקור הסמכותי לטיפוסי הנתונים הסטנדרטיים של Arrow.
- ב-[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) הסמכותי של Arrow, `Duration` הוא זמן שחלף מוחלט שאינו תלוי בלוח שנה, תומך ביחידת SECOND ומיוצג תמיד כמספר שלם signed בן 8 בתים. GEUL מוסיף לכך רק TAG ומסגור WORD של 16 סיביות big-endian.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x000006D0/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
