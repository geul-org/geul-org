---
title: "TAI-TIMESTAMP-SECONDS"
weight: 1022
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-SECONDS הוא מספר ה-SI-second המסומן מ-1970-01-01T00:00:00 TAI."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-SECONDS הוא מספר ה-SI-second המסומן מ-`1970-01-01T00:00:00 TAI`. ייצוג ה-count המצטבר הזה אינו פורמט wire תקני של BIPM, אלא profile ייחודי של GEUL הממפה את סקאלת הזמן TAI ל-int64 מסומן ברוחב קבוע.

## פריסה {#레이아웃}

- קוד: Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000013` BIPM, מספר Codec ‏`0x00004000`. משפחה TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD בסך הכול
Issuer            2 WORD  0x00000013 (BIPM)
מספר Codec        2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed SI Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed SI Seconds
Payload WORD 3rd (bits 31..16)     Signed SI Seconds
Payload WORD 4th (bits 15..0)      Signed SI Seconds low 16bit
```

## פירוש ותוקף {#해석과-유효성}

- כל 4 ה-WORD של ה-Payload נקראים כ-count מסומן בן 64 ביט בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63` עד `2^63-1` שניות. ערך שלילי הוא רגע TAI שקדם ל-epoch ש-GEUL קבעה.
- גם ערכים קטנים תופסים תמיד 4 WORD. לא נשמרים UTC offset או טבלת leap-second.

## אורך {#길이}

- הסך הכול הוא בדיוק 9 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 4 WORD, עם אורך ישיר `LLLL=1000`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה {#예시}

- ה-epoch של GEUL ל-TAI הוא Payload ‏`0000 0000 0000 0000`, 9 WORD בסך הכול, `LLLL=1000`.
- שנייה אחת אחרי ה-epoch הוא Payload ‏`0000 0000 0000 0001`.
- שנייה אחת לפני ה-epoch הוא Payload ‏`FFFF FFFF FFFF FFFF`.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) קובע את ה-SI second ואת סקאלת הזמן International Atomic Time (TAI).
- BIPM אינו מגדיר count מצטבר בצורת int64 מסומן מ-epoch ‏`1970-01-01 TAI`, וגם לא encoding של wire עבורו. ה-epoch, ה-int64 המסומן וסידור ה-WORD big-endian של GEUL הם מיפוי ייחודי של GEUL.
- ה-int64 ברוחב הקבוע נבחר לשם עקביות בהחלפה עם פרופילי count אחרים של TIME, ואין בכך משום שחזור מדויק של פורמט BIPM.
