---
title: "GPS-TIMESTAMP-SECONDS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-SECONDS הוא Value ששומר מספר שניות עם סימן מאז ה-epoch של GPS, 1980-01-06T00:00:00 GPS (פורמט Issuer 0x4000 של GPS)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-SECONDS הוא מספר שניות עם סימן מאז ה-epoch של GPS, `1980-01-06T00:00:00 GPS`. אינו מחלקים אותו למספר שבוע של GPS ואינו חותכים אותו לרוחב ה-week rollover של שדה broadcast.

הייצוג הזה של count מצטבר אינו wire format של שידור IS-GPS-200 אלא פרופיל ייחודי של GEUL שמעביר את סקאלת הזמן של GPS ל-signed int64 ברוחב קבוע.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0063` GPS, מספר פורמט `0x4000`. משפחה TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  סך הכול 7 WORD
Issuer            WORD אחד  0x0063 (GPS)
מספר פורמט        WORD אחד  0x4000
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## פירוש ותקינות

- כל 4 ה-WORD של ה-Payload נקראים כמספר עם סימן של 64 ביט בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63`~`2^63-1` שניות. ערך שלילי הוא instant של זמן GPS לפני ה-epoch של GPS.
- ה-count הוא ערך רציף שממשיך מה-epoch. לא מחילים חיתוך או rollover של שדה מספר השבוע בשידור.
- גם ערך קטן תמיד נכתב ב-4 WORD. לא שומרים פרמטרי המרה ל-UTC.

## אורך

- הסך הכול הוא בדיוק 7 WORD: TAG אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-4 WORD של Payload, עם אורך ישיר `LLLL=0110`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה

- ה-epoch של GPS הוא Payload `0000 0000 0000 0000`, 7 WORD בסך הכול, `LLLL=0110`.
- שנייה אחת אחרי ה-epoch היא Payload `0000 0000 0000 0001`.
- שנייה אחת לפני ה-epoch היא Payload `ffff ffff ffff ffff`.

## בסיס בתקנים ומעמד הפורמט

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) הוא מקום הפצה רשמי של מפרטי הממשק של GPS.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) קובע שזמן GPS הוא סקאלת זמן רציפה ושבוע 0 מתחיל בחצות של 1980-01-06, ומגדיר את מספר שבוע ה-GPS ואת שדות השידור time-of-week/Z-count.
- IS-GPS-200 אינו מגדיר ייצוג wire נוכחי של signed int64 מצטבר מאז epoch. ה-count הרציף בלי rollover, ה-signed int64 ופריסת ה-WORD ב-big-endian של GEUL הם התאמה ייחודית של GEUL.
