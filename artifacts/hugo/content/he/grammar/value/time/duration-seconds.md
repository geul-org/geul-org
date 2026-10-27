---
title: "DURATION-SECONDS"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS הוא Value ששומר זמן שחלף בשניות כ-signed int64 בלי epoch (Codec 0x23)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-SECONDS הוא זמן שחלף בשניות עם סימן, בלי epoch. הוא אינו instant ואינו משך של חודשים או שנים בלוח.

## פריסה

- קוד: קוד ישיר של Value `0x23`. משפחה TIME.
- משתמש בטיפוס פיזי ברוחב קבוע signed int64, כמו `Duration(SECOND)` של Arrow.

```
TAG WORD          0x0A23 (0000 1010 0010 0011)  סך הכול 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## פירוש ותקינות

- כל 4 ה-WORD של ה-Payload נקראים כמספר עם סימן של 64 ביט בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^63`~`2^63-1` שניות. הסימן הוא כיוון הזמן שחלף, ואינו מצביע על instant של epoch מסוים.
- גם ערך קטן תמיד נכתב ב-4 WORD.

## אורך

- הסך הכול הוא בדיוק 5 WORD: TAG אחד ו-4 WORD של Payload, עם אורך ישיר `LLLL=0100`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה

- 0 שניות הוא Payload `0000 0000 0000 0000`, 5 WORD בסך הכול, `LLLL=0100`.
- שנייה אחת היא Payload `0000 0000 0000 0001`.
- -1 שנייה היא Payload `ffff ffff ffff ffff`.

## בסיס בתקנים

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) מציין את `Schema.fbs` כמקור הסמכותי לטיפוסי הנתונים הסטנדרטיים של Arrow.
- ב-[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) הסמכותי של Arrow, `Duration` הוא זמן שחלף מוחלט שאינו תלוי בלוח, תומך ביחידת SECOND ומיוצג תמיד כמספר שלם עם סימן של 8 בייטים. GEUL מוסיפה לכך רק TAG ו-framing של WORD בן 16 ביט ב-big-endian.
