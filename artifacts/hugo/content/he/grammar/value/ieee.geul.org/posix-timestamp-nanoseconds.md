---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1032
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS הוא מספר ה-nanosecond המסומן מ-Unix epoch, 1970-01-01T00:00:00Z."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS הוא מספר ה-nanosecond המסומן מ-Unix epoch, ‏`1970-01-01T00:00:00Z`. כמו seconds-since-the-Epoch ב-POSIX, הוא רואה כל יום כ-86,400 שניות בדיוק ואינו סופר שניות מעוברות (leap second).

## פריסה {#레이아웃}

- קוד: Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x0000000D` IEEE, מספר Codec ‏`0x00004000`. משפחה TIME.
- לצורך החלפת נתונים בתעשייה משתמשים באותו סוג פיזי int64 מסומן ברוחב קבוע כמו ב-`TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` של Parquet.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD בסך הכול
Issuer            2 WORD  0x0000000D (IEEE)
מספר Codec        2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## פירוש ותוקף {#해석과-유효성}

- כל 4 ה-WORD של ה-Payload נקראים כ-count מסומן בן 64 ביט בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63` עד `2^63-1` ns, וטווח ה-instant הוא `1677-09-21 00:12:43.145224192Z` עד `2262-04-11 23:47:16.854775807Z`.
- גם ערכים קטנים תופסים תמיד 4 WORD. אסור לקצר אותם לייצוג שלם מינימלי ב-WORD.
- אינו מכיל timezone, UTC offset מקורי, label של שנייה מעוברת או טבלת leap-second.

## אורך {#길이}

- הסך הכול הוא בדיוק 9 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 4 WORD, עם אורך ישיר `LLLL=1000`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה {#예시}

- ה-epoch הוא Payload ‏`0000 0000 0000 0000`, 9 WORD בסך הכול, `LLLL=1000`.
- ננו-שנייה אחת אחרי ה-epoch היא Payload ‏`0000 0000 0000 0001`.
- ננו-שנייה אחת לפני ה-epoch היא Payload ‏`FFFF FFFF FFFF FFFF`.

## בסיס בתקנים {#표준-근거}

- ה-[POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) מגדיר את החברים `time_t tv_sec` ו-`long tv_nsec` ואת `0 <= tv_nsec < 10^9`. הרוחב והייצוג המדויקים של `time_t` תלויים בסביבת המימוש, והוא אינו מגדיר פורמט wire של int64 מסומן המצטבר ב-nanosecond משני החברים.
- ה-[POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) רואה כל יום כ-86,400 שניות בדיוק.
- ‏`TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` ב-[Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) שומר nanosecond מ-Unix epoch ב-`int64` יחיד. GEUL מוסיפה לסוג הפיזי הזה רק את ה-TAG ואת framing של WORD בן 16 ביט ב-big-endian.
