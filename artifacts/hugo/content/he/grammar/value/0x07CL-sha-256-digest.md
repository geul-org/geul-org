---
title: "SHA-256-DIGEST (0x07CL)"
weight: 124
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA-256-DIGEST הוא Value ברוחב קבוע הנושא את התוצאה המלאה של SHA-256 ממשפחת SHA-2."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `SHA-256-DIGEST` (מסמך מפרט BIND `SHA-256-DIGEST`) |
| TAG ID | `0x07CL` |
| Codec ID | `0x000007C0` |
| מסמך מפרט | `0x00000000/codecs/0x000007C0/` (יעד DECLARE ‏`07C0`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 28 |
| Kind | Value · משפחה: BINARY |
| TAG WORD | `0000 0111 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | תוצאת SHA-256 ב-Payload קבוע של 16 WORD |
| בצד Hugo | `value/binary/sha-256-digest.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | ערך גולמי, 16 WORD |  |  |

SHA-256-DIGEST הוא Value ברוחב קבוע הנושא את התוצאה המלאה של SHA-256 ממשפחת SHA-2. קוד ישיר של Value ‏`0x07CL`, משפחה BINARY. ה-Payload הוא בדיוק 16 WORD (‏256 סיביות), וקיצוץ (truncation) אינו מותר.

## פריסה {#레이아웃}

```
TAG WORD          0x07CE (0000 0111 1100 1110)  LLLL=1110
Length TAG הרחבה  1 WORD  0x0012 (סך הכול 18 WORD)
Payload           16 WORD  SHA-256 Digest
```

## פירוש ותוקף {#해석과-유효성}

- קוראים את 32 ה-octet של ה-Payload בסדר הפלט של SHA-256 כמות שהוא. בכל WORD ה-octet העליון בא ראשון.
- אין מפעילים בנפרד המרת endian של GEUL על מחרוזת הסיביות של ה-digest. רק מקבצים את רצף ה-octet-ים של הפלט בזוגות לפי הסדר ועושים framing כ-WORD big-endian של 16 סיביות.
- אם ה-Payload אינו 16 WORD, או שהתוצאה קוצצה באופן שרירותי, דוחים. אין descriptor ואין padding.

## בסיס בתקנים {#표준-근거}

- אלגוריתם SHA-256 ותוצאת 256 הסיביות נקבעים לפי NIST ‏[FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- ‏TAG, ‏Length ו-framing של WORD בן 16 סיביות ב-GEUL הם כללים שפורמט זה מוסיף, ואינם חלק מאלגוריתם SHA-2.

## אורך {#길이}

- הסך הכול הוא בדיוק 18 WORD, ‏TAG של WORD אחד, ‏Length TAG של הרחבה של WORD אחד ו-Payload של 16 WORD, ומשתמשים ב-`LLLL=1110`. אין descriptor ואין padding.
- אם ה-Payload אינו בדיוק 16 WORD, דוחים.

## דוגמה {#예시}

- ה-octet-ים של ה-digest מ-`d[0]` עד `d[31]` מונחים לפי הסדר כ-WORD של ה-Payload מ-`(d[0]<<8)|d[1]` עד `(d[30]<<8)|d[31]`. ה-Length הכולל הוא תמיד 18 WORD.

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x000007C0/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007C000000000
BODY
#1 DECLARE 0x07C0
#2 FIELD #1 0x0010
#3 BIND #1 "SHA-256-DIGEST"
#4 BIND #2 "digest"
```
