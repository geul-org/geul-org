---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS הוא Value ששומר מספר ננו-שניות signed int64 מאז ה-epoch של Unix (פורמט Issuer 0x4000 של IEEE)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS הוא מספר ננו-שניות עם סימן מאז ה-epoch של Unix, `1970-01-01T00:00:00Z`. כמו seconds-since-the-Epoch של POSIX, הוא רואה כל יום כ-86,400 שניות בדיוק ואינו סופר שניות מעוברות.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0040` IEEE, מספר פורמט `0x4000`. משפחה TIME.
- לצורך החלפת נתונים תעשייתית, משתמש בטיפוס פיזי ברוחב קבוע signed int64, כמו `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` של Parquet.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  סך הכול 7 WORD
Issuer            WORD אחד  0x0040 (IEEE)
מספר פורמט        WORD אחד  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## פירוש ותקינות

- כל 4 ה-WORD של ה-Payload נקראים כמספר עם סימן של 64 ביט בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63`~`2^63-1` ננו-שניות, וטווח ה-instant הוא `1677-09-21 00:12:43.145224192Z`~`2262-04-11 23:47:16.854775807Z`.
- גם ערך קטן תמיד נכתב ב-4 WORD. אסור לקצר אותו לייצוג שלם במינימום WORD.
- אזור זמן, הפרש ה-UTC המקורי, תווית של שנייה מעוברת וטבלת שניות מעוברות אינם נשמרים.

## אורך

- הסך הכול הוא בדיוק 7 WORD: TAG אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-4 WORD של Payload, עם אורך ישיר `LLLL=0110`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה

- ה-epoch הוא Payload `0000 0000 0000 0000`, 7 WORD בסך הכול, `LLLL=0110`.
- ננו-שנייה אחת אחרי ה-epoch היא Payload `0000 0000 0000 0001`.
- ננו-שנייה אחת לפני ה-epoch היא Payload `ffff ffff ffff ffff`.

## בסיס בתקנים

- [`timespec` ב-POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) מגדיר את החברים `time_t tv_sec` ו-`long tv_nsec` ואת `0 <= tv_nsec < 10^9`. הרוחב והייצוג המדויקים של `time_t` תלויים בסביבת המימוש, והוא אינו מגדיר wire format של signed int64 של ננו-שניות מצטברות שמאחד את שני החברים.
- [Seconds Since the Epoch ב-POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) רואה יום כ-86,400 שניות בדיוק.
- `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` ב-[Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) שומר ננו-שניות מאז ה-epoch של Unix ב-`int64` יחיד. GEUL מוסיפה לטיפוס הפיזי הזה רק TAG ו-framing של WORD בן 16 ביט ב-big-endian.
