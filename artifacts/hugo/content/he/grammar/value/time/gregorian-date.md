---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE הוא Value של מספר ימים כ-signed int32 כש-1970-01-01 בלוח proleptic Gregorian הוא יום 0 (Codec 0x20)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GREGORIAN-DATE הוא מספר ימים עם סימן כש-`1970-01-01` בלוח proleptic Gregorian הוא יום 0. הוא אינו מכיל אזור זמן או שעה ביום.

## פריסה

- קוד: קוד ישיר של Value `0x20`. משפחה TIME.
- משתמש בטיפוס פיזי ברוחב קבוע signed int32, כמו Arrow Date32 ו-`DATE` של Parquet.

```
TAG WORD          0x0920 (0000 1001 0010 0000)  סך הכול 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## פירוש ותקינות

- כל 2 ה-WORD של ה-Payload נקראים כמספר ימים עם סימן של 32 ביט בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^31`~`2^31-1` ימים. ערך שלילי הוא תאריך לפני ה-epoch.
- כשמחשבים מספר ימים בחזרה לשנה, חודש ויום, משתמשים בלוח proleptic Gregorian, בלי מעברי לוח היסטוריים.
- גם ערך קטן תמיד נכתב ב-2 WORD.

## אורך

- הסך הכול הוא בדיוק 3 WORD: TAG אחד ו-2 WORD של Payload, עם אורך ישיר `LLLL=0010`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 2 WORD, דוחים.

## דוגמה

| תאריך | Payload | Length כולל |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `ffff ffff` | 3 WORD (`LLLL=0010`) |

## הקשר ל-EDTF

- דיוק גס מיום, אי-ודאות ודמיון, וקטע נכתבים ב-[EDTF](/he/grammar/value/time/edtf/). תאריך שאפשר לכתוב במדויק ב-GREGORIAN-DATE לא נכתב ב-EDTF (הצורה הקנונית של EDTF).

## בסיס בתקנים

- `DATE` ב-[Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) הוא `int32` ששומר את מספר הימים מאז ה-epoch של Unix, 1970-01-01, ומשתמש בסדר signed.
- Date32 ב-[Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) וב-[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) הסמכותי שומר את מספר הימים מאז ה-epoch של Unix כמספר שלם של 32 ביט עם סימן.
- חישוב חזרה ב-proleptic Gregorian הוא פרופיל הלוח של GEUL שהפורמט הזה אימץ. משמעות int32 של מספר הימים ב-Arrow/Parquet נשארת כמות שהיא, ומוסיפים רק TAG ו-framing של WORD בן 16 ביט ב-big-endian.
