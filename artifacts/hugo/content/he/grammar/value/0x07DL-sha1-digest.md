---
title: "SHA1-DIGEST (0x07DL)"
weight: 125
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST הוא Value ברוחב קבוע הנושא את התוצאה המלאה של SHA-1."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| פריט | ערך |
|---|---|
| שם | `SHA1-DIGEST` (מסמך מפרט BIND `SHA1-DIGEST`) |
| TAG ID | `0x07DL` |
| Codec ID | `0x000007D0` |
| מסמך מפרט | `0x00000000/codecs/0x000007D0/` (יעד DECLARE ‏`07D0`) |
| קטע | 3 `0011` (Value), היסט בתוך הקטע C = 29 |
| Kind | Value · משפחה: BINARY |
| TAG WORD | `0000 0111 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| תיאור באינדקס | תוצאת SHA-1 ב-Payload קבוע של 10 WORD. למטרות זיהוי בלבד, כמו מזהה אובייקט של git |
| בצד Hugo | `value/binary/sha1-digest.md` |

## שדות (מסמך מפרט) {#필드-규격-문서}

סדר ה-FIELD במסמך הוא סדר שדות ה-Payload ([מסמך המפרט של Codec](../codec-spec.md)).

| סדר | שדה (BIND) | FIELD | רוחב | פורמט מקבל (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | ערך גולמי, 10 WORD |  |  |

SHA1-DIGEST הוא Value ברוחב קבוע הנושא את התוצאה המלאה של SHA-1. קוד ישיר של Value ‏`0x07DL`, משפחה BINARY. ה-Payload הוא בדיוק 10 WORD (‏160 סיביות), וקיצוץ (truncation) אינו מותר.

**משתמשים בו רק למטרות זיהוי.** עמידות ההתנגשות של SHA-1 נשברה (SHAttered, ‏2017). כבסיס לשלמות ולחתימה משתמשים ב-[SHA-256-DIGEST](0x07CL-sha-256-digest.md). פורמט זה קיים כדי לשאת כמות שהם מזהים שכבר נקבעו ב-SHA-1, ובעיקר מזהה אובייקט (מזהה commit) של מאגר git מבוסס SHA-1. לדוגמה, את ה-Version (מזהה commit) של [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md) הוא נושא ב-11 WORD במקום בטקסט hex (‏22 WORD).

## פריסה {#레이아웃}

```
TAG WORD          0x07DA (0000 0111 1101 1010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## פירוש ותוקף {#해석과-유효성}

- קוראים את 20 ה-octet של ה-Payload בסדר הפלט של SHA-1 כמות שהוא. בכל WORD ה-octet העליון בא ראשון (אותו framing כמו SHA-256-DIGEST).
- אם ה-Payload אינו 10 WORD, או שהתוצאה קוצצה באופן שרירותי (מזהה מקוצר של git וכו'), דוחים. אין descriptor ואין padding.
- מזהה אובייקט של git הוא הערך כפי ש-git חישב אותו. ה-SHA-1 של git הוא גרסה שהוכנסה בה זיהוי התנגשויות (SHA-1DC), אך בקלט שאינו מתקפת התנגשות התוצאה זהה ל-SHA-1.

## בסיס בתקנים {#표준-근거}

- אלגוריתם SHA-1 ותוצאת 160 הסיביות נקבעים לפי NIST ‏[FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- ‏TAG ו-framing של WORD בן 16 סיביות ב-GEUL הם כללים שפורמט זה מוסיף.

## אורך {#길이}

- הסך הכול הוא בדיוק 11 WORD, ‏TAG של WORD אחד ו-Payload של 10 WORD, ומשתמשים ב-`LLLL=1010`. אין הרחבת Length.

## דוגמה {#예시}

commit של git ‏`ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## דפים קשורים {#관련-페이지}

- [Value](_index.md), [SHA-256-DIGEST](0x07CL-sha-256-digest.md), [TRANSFORMED-BY](../meta/0x1D4L-transformed-by.md)

## הטקסט המקורי של מסמך המפרט {#규격-문서-원문}

זהו מסמך המפרט `0x00000000/codecs/0x000007D0/latest.geul` כפי שהוא נקרא באמצעות `geul show` (ספרות הקסדצימליות באותיות גדולות).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007D000000000
BODY
#1 DECLARE 0x07D0
#2 FIELD #1 0x000A
#3 BIND #1 "SHA1-DIGEST"
#4 BIND #2 "digest"
```
