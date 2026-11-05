---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE הוא מספר ימים עם סימן (signed) שבו 1970-01-01 בלוח הגרגוריאני הפרולפטי הוא יום 0."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `GREGORIAN-DATE` (מסמך מפרט BIND `GREGORIAN-DATE`) |
| TAG ID | `0x06AL` |
| Codec ID | `0x000006A0` |
| מסמך מפרט | `0x00000000/codecs/0x000006A0/` (יעד DECLARE `06A0`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 10 |
| Kind | Value · משפחה: TIME |
| TAG WORD | `0000 0110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | מספר ימים signed ביחס ל-`1970-01-01` בלוח הגרגוריאני הפרולפטי (proleptic Gregorian) |
| בצד Hugo | `value/time/gregorian-date.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | ערך גולמי, 2 WORD |  |  |

GREGORIAN-DATE הוא מספר ימים signed שבו `1970-01-01` בלוח הגרגוריאני הפרולפטי (proleptic Gregorian) הוא day 0. אין בו אזור זמן ואין שעה ביום.

## פריסה {#레이아웃}

- קוד: קוד ישיר של Value `0x06AL`. משפחה TIME.
- נעשה שימוש בטיפוס פיזי signed int32 ברוחב קבוע, כמו Arrow Date32 ו-`DATE` של Parquet.

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  סך הכול 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## פירוש ותוקף {#해석과-유효성}

- שני ה-WORD של ה-Payload נקראים כולם כ-day count signed בן 32 סיביות בשיטת המשלים ל-2, בסדר WORD של big-endian.
- הטווח התקף הוא `-2^31`~`2^31-1` ימים. ערך שלילי הוא תאריך לפני ה-epoch.
- בחישוב חזרה מ-day count לשנה, חודש ויום משתמשים בלוח הגרגוריאני הפרולפטי, ללא מעברי לוח היסטוריים.
- גם ערך קטן תמיד נכתב ב-2 WORD.

## אורך {#길이}

- הסך הכול הוא בדיוק 3 WORD, TAG אחד ו-Payload של 2 WORD, ונעשה שימוש באורך הישיר `LLLL=0010`. אין TAG הרחבת Length, אין descriptor ואין padding.
- אם ה-Payload אינו 2 WORD בדיוק, הוא נדחה.

## דוגמה {#예시}

| תאריך | Payload | Length כולל |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `FFFF FFFF` | 3 WORD (`LLLL=0010`) |

## הקשר ל-EDTF {#edtf와의-관계}

- דיוק גס יותר מיום, אי-ודאות או קירוב, וטווחים נכתבים ב-[EDTF](0x06EL-edtf.md). תאריך שאפשר לכתוב במדויק ב-GREGORIAN-DATE אינו נכתב ב-EDTF (הצורה הקנונית של EDTF).

## בסיס תקני {#표준-근거}

- `DATE` ב-[Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) הוא `int32` השומר את מספר הימים מ-1970-01-01, ה-Unix epoch, ובעל סדר signed.
- Date32 ב-[Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) וב-[Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) הסמכותי שומר את מספר הימים מה-Unix epoch כמספר שלם signed בן 32 סיביות.
- החישוב החוזר בלוח הגרגוריאני הפרולפטי הוא calendar profile של GEUL שפורמט זה מאמץ. משמעות day-count ה-int32 של Arrow/Parquet נשארת כמות שהיא, ונוספים רק TAG ומסגור WORD של 16 סיביות big-endian.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x000006A0/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
