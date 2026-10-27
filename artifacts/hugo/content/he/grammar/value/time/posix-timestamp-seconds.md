---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS הוא Value ששומר מספר שניות signed int64 מאז ה-epoch של Unix (Codec 0x22)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS הוא מספר שניות עם סימן מאז ה-epoch של Unix, `1970-01-01T00:00:00Z`. כמו seconds-since-the-Epoch של POSIX, הוא רואה כל יום כ-86,400 שניות בדיוק ואינו סופר שניות מעוברות.

## פריסה

- קוד: קוד ישיר של Value `0x22`. משפחה TIME.
- לצורך החלפת נתונים תעשייתית, משתמש בטיפוס פיזי ברוחב קבוע signed int64, כמו `timestamp[s]` של Arrow.

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  סך הכול 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## פירוש ותקינות

- כל 4 ה-WORD של ה-Payload נקראים כמספר עם סימן של 64 ביט בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63`~`2^63-1` שניות. ערך שלילי הוא instant לפני ה-epoch.
- גם ערך קטן תמיד נכתב ב-4 WORD. אסור לקצר אותו לייצוג שלם במינימום WORD.
- אזור זמן, הפרש ה-UTC המקורי, תווית של שנייה מעוברת וטבלת שניות מעוברות אינם נשמרים.

## אורך

- הסך הכול הוא בדיוק 5 WORD: TAG אחד ו-4 WORD של Payload, עם אורך ישיר `LLLL=0100`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה

- ה-epoch הוא Payload `0000 0000 0000 0000`, 5 WORD בסך הכול, `LLLL=0100`.
- שנייה אחת אחרי ה-epoch היא Payload `0000 0000 0000 0001`.
- שנייה אחת לפני ה-epoch היא Payload `ffff ffff ffff ffff`.

## בסיס בתקנים

- [`timespec` ב-POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) מגדיר רק את החברים `time_t tv_sec` ו-`long tv_nsec`, ואינו מגדיר wire format שמסריאל שניות מצטברות כ-signed int64. הרוחב והייצוג המדויקים של `time_t` תלויים בסביבת המימוש ואינם זהים לייצוג ה-Payload של GEUL.
- [Seconds Since the Epoch ב-POSIX.1-2024](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) מגדיר את ההתאמה ללוח השנה של שניות אחרי ה-epoch ואת הכלל של 86,400 שניות ליום.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) ו-[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) הסמכותי מגדירים timestamp כמספר שלם עם סימן של 64 ביט מאז epoch קבוע, ותומכים ביחידת SECOND ובאי-ספירת שניות מעוברות. GEUL מוסיפה לטיפוס הפיזי הזה רק TAG ו-framing של WORD בן 16 ביט ב-big-endian.
