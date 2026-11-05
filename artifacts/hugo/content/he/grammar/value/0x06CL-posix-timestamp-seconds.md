---
title: "POSIX-TIMESTAMP-SECONDS (0x06CL)"
weight: 108
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS הוא מספר שניות signed מה-Unix epoch 1970-01-01T00:00:00Z."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `POSIX-TIMESTAMP-SECONDS` (מסמך מפרט BIND `POSIX-TIMESTAMP-SECONDS`) |
| TAG ID | `0x06CL` |
| Codec ID | `0x000006C0` |
| מסמך מפרט | `0x00000000/codecs/0x000006C0/` (יעד DECLARE `06C0`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 12 |
| Kind | Value · משפחה: TIME |
| TAG WORD | `0000 0110 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | מניין שניות signed מה-epoch של Unix/POSIX |
| בצד Hugo | `value/time/posix-timestamp-seconds.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | ערך גולמי, 4 WORD |  |  |

POSIX-TIMESTAMP-SECONDS הוא מספר שניות signed מה-Unix epoch `1970-01-01T00:00:00Z`. כמו seconds-since-the-Epoch של POSIX, הוא רואה כל יום כ-86,400 שניות בדיוק ואינו סופר שניות מעבר.

## פריסה {#레이아웃}

- קוד: קוד ישיר של Value `0x06CL`. משפחה TIME.
- לצורך חילופי נתונים תעשייתיים נעשה שימוש בטיפוס פיזי signed int64 ברוחב קבוע, כמו `timestamp[s]` של Arrow.

```
TAG WORD          0x06C4 (0000 0110 1100 0100)  סך הכול 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## פירוש ותוקף {#해석과-유효성}

- ארבעת ה-WORD של ה-Payload נקראים כולם כמניין signed בן 64 סיביות בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63`~`2^63-1` שניות. ערך שלילי הוא instant לפני ה-epoch.
- גם ערך קטן תמיד נכתב ב-4 WORD. אסור לקצר אותו לייצוג מספר שלם ב-WORD מינימלי.
- timezone, היסט UTC מקורי, תווית שניית מעבר (leap second) וטבלת leap-second אינם נשמרים.

## אורך {#길이}

- הסך הכול הוא בדיוק 5 WORD, TAG אחד ו-Payload של 4 WORD, ונעשה שימוש באורך הישיר `LLLL=0100`. אין TAG הרחבת Length, אין descriptor ואין padding.
- אם ה-Payload אינו 4 WORD בדיוק, הוא נדחה.

## דוגמה {#예시}

- ה-epoch הוא Payload `0000 0000 0000 0000`, סך הכול 5 WORD, `LLLL=0100`.
- שנייה אחת אחרי ה-epoch היא Payload `0000 0000 0000 0001`.
- שנייה אחת לפני ה-epoch היא Payload `FFFF FFFF FFFF FFFF`.

## בסיס תקני {#표준-근거}

- [`timespec` ב-POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) מגדיר רק את החברים `time_t tv_sec` ו-`long tv_nsec`, ואינו מגדיר wire format לסריאליזציה של שניות מצטברות כ-signed int64. הרוחב והייצוג המעשיים של `time_t` תלויים בסביבת המימוש ואינם זהים לייצוג ה-Payload של GEUL.
- [Seconds Since the Epoch ב-POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) מגדיר את ההתאמה ללוח השנה של שניות מאז ה-epoch ואת כלל 86,400 השניות ליום.
- לפי [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) ו-[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) הסמכותי, timestamp מוגדר כמספר שלם signed בן 64 סיביות מ-epoch קבוע, ויש תמיכה ביחידת SECOND ובאי-ספירה של שניות מעבר. GEUL מוסיף לטיפוס פיזי זה רק TAG ומסגור WORD של 16 סיביות big-endian.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x000006C0/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006C000000000
BODY
#1 DECLARE 0x06C0
#2 FIELD #1 0x0004
#3 BIND #1 "POSIX-TIMESTAMP-SECONDS"
#4 BIND #2 "seconds"
```
