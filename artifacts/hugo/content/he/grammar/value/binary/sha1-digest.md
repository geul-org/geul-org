---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST הוא Value ברוחב קבוע של 11 WORD שמכיל את כל 160 הביטים של תוצאת SHA-1, ומשמש לזיהוי בלבד, למשל מזהה אובייקט ב-git."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA1-DIGEST הוא Value ברוחב קבוע שמכיל את כל תוצאת SHA-1. הוא Value עם קוד ישיר `0x62`, משפחה BINARY. ה-Payload הוא בדיוק 10 WORD (160 ביט), וקיצוץ (truncation) אינו מותר.

**משמש לזיהוי בלבד.** עמידות ההתנגשות של SHA-1 נשברה (SHAttered, 2017). כבסיס לשלמות ולחתימה יש להשתמש ב-[SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/). הפורמט הזה קיים כדי להכיל כמות שהוא מזהה שכבר נקבע באמצעות SHA-1, ובעיקר מזהה אובייקט (מזהה commit) במאגר git מסוג SHA-1. לדוגמה, ה-Version (מזהה commit) של [TRANSFORMED-BY](/he/grammar/meta/lineage/transformed-by/) מוכל ב-11 WORD במקום טקסט hex (22 WORD).

## פריסה

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## פרשנות ותקינות

- 20 ה-octet של ה-Payload נקראים בסדר הפלט של SHA-1. בכל WORD ה-octet העליון בא ראשון (אותו framing כמו ב-SHA-256-DIGEST).
- ייצוג שבו ה-Payload אינו 10 WORD, או שהתוצאה קוצצה באופן שרירותי (כגון מזהה מקוצר של git), נדחה. אין descriptor ואין padding.
- מזהה אובייקט של git הוא הערך ש-git חישב, כמות שהוא. ה-SHA-1 של git הוא גרסה עם זיהוי התנגשויות (SHA-1DC), אך עבור קלט שאינו התקפת התנגשות התוצאה זהה ל-SHA-1.

## בסיס בתקנים

- אלגוריתם SHA-1 והתוצאה בת 160 הביט נקבעים לפי NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL TAG ו-framing של WORD בן 16 ביט הם כללים שהפורמט הזה מוסיף.

## אורך

- האורך הכולל הוא בדיוק 11 WORD: TAG אחד ו-10 WORD של Payload, עם `LLLL=1010`. אין הרחבת Length.

## דוגמה

git commit `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## דפים קשורים

- [Value](/he/grammar/value/), [SHA-256-DIGEST](/he/grammar/value/binary/sha-256-digest/), [TRANSFORMED-BY](/he/grammar/meta/lineage/transformed-by/)
