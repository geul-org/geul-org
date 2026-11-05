---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1023
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS הוא מספר ה-nanosecond המסומן מ-GPS epoch, 1980-01-06T00:00:00 GPS."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS הוא מספר ה-nanosecond המסומן מ-GPS epoch, `1980-01-06T00:00:00 GPS`. אין מחלקים אותו במספר GPS week ואין חותכים אותו לרוחב ה-week rollover של שדה ה-broadcast.

ייצוג ה-count המצטבר הזה אינו פורמט ה-wire של broadcast ב-IS-GPS-200, אלא profile ייחודי של GEUL הממפה את סקאלת הזמן GPS ל-int64 מסומן ברוחב קבוע.

## פריסה {#레이아웃}

- קוד: Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000016` GPS, מספר Codec ‏`0x00004001`. משפחה TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD בסך הכול
Issuer            2 WORD  0x00000016 (GPS)
מספר Codec        2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## פירוש ותוקף {#해석과-유효성}

- כל 4 ה-WORD של ה-Payload נקראים כ-count מסומן בן 64 ביט בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63` עד `2^63-1` ns. ערך שלילי הוא רגע בזמן GPS שקדם ל-GPS epoch.
- ה-count הוא ערך רציף שנמשך מה-epoch. לא מיושמים חיתוך (truncation) או rollover של שדה week-number ב-broadcast.
- גם ערכים קטנים תופסים תמיד 4 WORD. אינו מכיל פרמטרי המרה ל-UTC.

## אורך {#길이}

- הסך הכול הוא בדיוק 9 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 4 WORD, עם אורך ישיר `LLLL=1000`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה {#예시}

- ה-GPS epoch הוא Payload ‏`0000 0000 0000 0000`, 9 WORD בסך הכול, `LLLL=1000`.
- ננו-שנייה אחת אחרי ה-epoch הוא Payload ‏`0000 0000 0000 0001`.
- ננו-שנייה אחת לפני ה-epoch הוא Payload ‏`FFFF FFFF FFFF FFFF`.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) הוא אתר ההפצה הרשמי של מפרטי הממשק של GPS.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) קובע ש-GPS time היא סקאלת זמן רציפה ושבוע 0 מתחיל בחצות של 1980-01-06, ומגדיר את GPS week number ואת שדות ה-broadcast של time-of-week/Z-count.
- IS-GPS-200 אינו מגדיר ייצוג wire של int64 מסומן עבור nanosecond מצטבר מה-epoch. count רציף ביחידת nanosecond ללא rollover, ה-int64 המסומן וסידור ה-WORD big-endian של GEUL הם מיפוי ייחודי של GEUL.
