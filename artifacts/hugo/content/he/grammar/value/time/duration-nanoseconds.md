---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS הוא Value ששומר זמן שחלף בננו-שניות כ-signed int64 בלי epoch (פורמט Issuer 0x4000 של GEUL)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS הוא זמן שחלף בננו-שניות עם סימן, בלי epoch. הוא אינו instant ואינו משך של חודשים או שנים בלוח.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0000` GEUL, מספר פורמט `0x4000`. משפחה TIME.
- משתמש בטיפוס פיזי ברוחב קבוע signed int64, כמו `Duration(NANOSECOND)` של Arrow.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  סך הכול 7 WORD
Issuer            WORD אחד  0x0000 (GEUL)
מספר פורמט        WORD אחד  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## פירוש ותקינות

- כל 4 ה-WORD של ה-Payload נקראים כמספר עם סימן של 64 ביט בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63`~`2^63-1` ננו-שניות. הסימן הוא כיוון הזמן שחלף, ואינו מצביע על instant של epoch מסוים.
- גם ערך קטן תמיד נכתב ב-4 WORD.

## אורך

- הסך הכול הוא בדיוק 7 WORD: TAG אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-4 WORD של Payload, עם אורך ישיר `LLLL=0110`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה

- 0 ננו-שניות הוא Payload `0000 0000 0000 0000`, 7 WORD בסך הכול, `LLLL=0110`.
- ננו-שנייה אחת היא Payload `0000 0000 0000 0001`.
- -1 ננו-שנייה היא Payload `ffff ffff ffff ffff`.

## בסיס בתקנים

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) מציין את `Schema.fbs` כמקור הסמכותי לטיפוסי הנתונים הסטנדרטיים של Arrow.
- ב-[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) הסמכותי של Arrow, `Duration` הוא זמן שחלף מוחלט שאינו תלוי בלוח, תומך ביחידת NANOSECOND ומיוצג תמיד כמספר שלם עם סימן של 8 בייטים. GEUL מוסיפה לכך רק TAG ו-framing של WORD בן 16 ביט ב-big-endian.
