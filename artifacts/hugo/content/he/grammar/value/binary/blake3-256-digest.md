---
title: "BLAKE3-256-DIGEST"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BLAKE3-256-DIGEST הוא פורמט Issuer ברוחב קבוע של 20 WORD שמכיל את 32 ה-octet הראשונים בפלט ה-hash mode הרגיל של BLAKE3."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLAKE3-256-DIGEST הוא Value ברוחב קבוע שמכיל את 32 ה-octet הראשונים (256 ביט) בפלט ה-default hash mode של BLAKE3. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, מספר פורמט `0xC000`, משפחה BINARY. ה-Payload הוא בדיוק 16 WORD, ואינו מכיל keyed hash mode, key derivation mode או פלט XOF באורך אחר.

## פריסה

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
TAG הרחבת Length  1 WORD  0x0014 (20 WORD בסך הכול)
Issuer            1 WORD  0x0001 (ADHOC)
מספר פורמט        1 WORD  0xC000
Payload           16 WORD  BLAKE3-256 Digest
```

## פרשנות ותקינות

- ה-Payload הוא 32 ה-octet הראשונים של output stream ב-default hash mode של BLAKE3. סדר הפלט נשמר, ובכל WORD ה-octet העליון בא ראשון.
- לא מופעלת על הפלט המרת endian נפרדת של GEUL. רצף ה-octet של הפלט מקובץ לפי הסדר לזוגות ומוגש כ-WORD של 16 ביט ב-big-endian.
- ייצוג שבו ה-Payload אינו 16 WORD, או שמכיל תוצאת keyed_hash, derive_key או XOF באורך אחר, נדחה. אין descriptor ואין padding.

## בסיס בתקנים

- ההגדרות של האלגוריתם, ה-mode והפלט נקבעות לפי [המאגר הרשמי](https://github.com/BLAKE3-team/BLAKE3) של צוות BLAKE3 ו-[BLAKE3 specification](https://github.com/BLAKE3-team/BLAKE3-specs/blob/master/blake3.pdf).
- GEUL TAG, Length ו-framing של WORD בן 16 ביט הם כללים שהפורמט הזה מוסיף, ואינם חלק מאלגוריתם BLAKE3.

## אורך

- האורך הכולל הוא בדיוק 20 WORD: TAG אחד, TAG הרחבת Length אחד, Issuer אחד, מספר פורמט אחד ו-16 WORD של Payload, עם `LLLL=1110`. אין descriptor ואין padding.
- אם ה-Payload אינו בדיוק 16 WORD, הרשומה נדחית.

## דוגמה

- ה-octet של הפלט `d[0]` עד `d[31]` ממוקמים ב-16 ה-Payload WORD לפי סדר הפלט, שני octet בכל WORD. ה-Length הכולל הוא תמיד 20 WORD.
