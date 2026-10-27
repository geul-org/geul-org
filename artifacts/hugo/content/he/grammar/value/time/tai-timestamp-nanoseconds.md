---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS הוא Value ששומר מספר ננו-שניות עם סימן מאז 1970-01-01T00:00:00 TAI (פורמט Issuer 0x4001 של BIPM)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-NANOSECONDS הוא מספר ננו-שניות עם סימן מאז אותו epoch של TAI, `1970-01-01T00:00:00 TAI`. הייצוג הזה של count מצטבר אינו wire format סטנדרטי של BIPM אלא פרופיל ייחודי של GEUL שמעביר את סקאלת הזמן TAI ל-signed int64 ברוחב קבוע.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0060` BIPM, מספר פורמט `0x4001`. משפחה TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  סך הכול 7 WORD
Issuer            WORD אחד  0x0060 (BIPM)
מספר פורמט        WORD אחד  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## פירוש ותקינות

- כל 4 ה-WORD של ה-Payload נקראים כמספר עם סימן של 64 ביט בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63`~`2^63-1` ננו-שניות. ערך שלילי הוא instant של TAI לפני ה-epoch ש-GEUL קבעה.
- גם ערך קטן תמיד נכתב ב-4 WORD. לא שומרים הפרש UTC או טבלת שניות מעוברות.

## אורך

- הסך הכול הוא בדיוק 7 WORD: TAG אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-4 WORD של Payload, עם אורך ישיר `LLLL=0110`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה

- ה-epoch של TAI ב-GEUL הוא Payload `0000 0000 0000 0000`, 7 WORD בסך הכול, `LLLL=0110`.
- ננו-שנייה אחת אחרי ה-epoch היא Payload `0000 0000 0000 0001`.
- ננו-שנייה אחת לפני ה-epoch היא Payload `ffff ffff ffff ffff`.

## בסיס בתקנים ומעמד הפורמט

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) קובע את שנייה SI ואת סקאלת הזמן International Atomic Time (TAI).
- BIPM אינו מגדיר ננו-שניות מצטברות של signed int64 מאז epoch של `1970-01-01 TAI`, ואינו מגדיר את הקידוד שלו ב-wire. ה-epoch, ה-count לפי יחידה, ה-signed int64 ופריסת ה-WORD ב-big-endian של GEUL הם התאמה ייחודית של GEUL.
- ה-int64 ברוחב קבוע נבחר לעקביות החלפה עם פרופילי count אחרים של TIME, ואין בכך משמעות שהפורמט של BIPM שוחזר כמות שהוא.
