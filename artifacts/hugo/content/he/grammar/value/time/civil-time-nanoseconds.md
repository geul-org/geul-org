---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS הוא Value ששומר שעה אזרחית בלי תאריך כמספר ננו-שניות מאז חצות (Codec 0x21)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CIVIL-TIME-NANOSECONDS מבטא שעה אזרחית בלי תאריך כמספר ננו-שניות מאז חצות.

## פריסה

- קוד: קוד ישיר של Value `0x21`. משפחה TIME.
- משתמש בטיפוס פיזי ברוחב קבוע signed int64, כמו `TIME(isAdjustedToUTC=false, unit=NANOS)` של Parquet.

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  סך הכול 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## פירוש ותקינות

- כל 4 ה-WORD של ה-Payload נקראים כמספר עם סימן של 64 ביט בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטיפוס הפיזי הוא signed int64, אך הטווח התקף הוא `0 <= value < 86,400×10^9` ננו-שניות. ערך שלילי וערך שווה לגבול העליון או גדול ממנו נדחים.
- `24:00` ותווית של שנייה מעוברת (leap second) אסורים. גם תאריך, אזור זמן והפרש UTC אינם נשמרים.
- גם ערך קטן תמיד נכתב ב-4 WORD.

## אורך

- הסך הכול הוא בדיוק 5 WORD: TAG אחד ו-4 WORD של Payload, עם אורך ישיר `LLLL=0100`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה

- חצות הוא Payload `0000 0000 0000 0000`, 5 WORD בסך הכול, `LLLL=0100`.
- ננו-שנייה אחת אחרי חצות היא Payload `0000 0000 0000 0001`.
- `86,400×10^9` ננו-שניות שווה לגבול העליון ולכן אינו תקף.
- `ffff ffff ffff ffff` הוא -1 ב-signed int64 ולכן אינו תקף.

## בסיס בתקנים

- `TIME(isAdjustedToUTC=false, unit=NANOS)` ב-[Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) שומר ננו-שניות מאז חצות של שעה מקומית ב-`int64` ומשתמש בסדר signed.
- [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) הסמכותי של [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) מגדיר Time ברזולוציית NANOSECOND כמספר שלם עם סימן של 64 ביט, מגביל את הטווח התקף לפחות מ-86,400 שניות כולל חצות, ואינו מתיר שנייה מעוברת. GEUL מוסיפה רק TAG ו-framing של WORD בן 16 ביט ב-big-endian.
