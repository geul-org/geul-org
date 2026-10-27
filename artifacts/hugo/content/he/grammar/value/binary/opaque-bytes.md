---
title: "OPAQUE-BYTES"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES הוא פורמט Issuer של GEUL שמכיל רצף בייטים שרירותי שאינו קובע בעצמו משמעות או פורמט."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES הוא רצף בייטים שרירותי שהמשמעות והפורמט שלו אינם נקבעים בפורמט עצמו. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, מספרי פורמט `0xC000`·`0xC001` (מספר בייטים זוגי ואי-זוגי), משפחה BINARY. מספר הבייטים נקבע לפי הביט התחתון ביותר של מספר הפורמט ולפי מספר ה-Payload WORD: `2 × מספר Payload WORD − הביט התחתון ביותר`, ואין Byte Count נפרד ([Value](/he/grammar/value/)).

## פריסה

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG הרחבת Length] כשהכול 15 WORD ומעלה
Issuer            1 WORD  0x0000 (GEUL)
מספר פורמט        1 WORD  0xC000/0xC001
Payload WORD 1st ... Nth   בייטים / zero padding אחרון
```

## פרשנות ותקינות

- מה-Payload קוראים לפי הסדר מספר בייטים כמספר הבייטים. בתוך WORD ה-byte העליון בא ראשון.
- מספר ה-Payload WORD הוא `ceil(מספר בייטים/2)`. אם הקוד אי-זוגי וה-byte התחתון של ה-WORD האחרון אינו `00`, הרשומה נדחית.
- אם הקוד הזוגי/אי-זוגי, מספר ה-Payload WORD וה-zero padding אינם תואמים זה לזה, הרשומה נדחית.

## מעמד הפורמט

- זוג הקודים הזוגי/אי-זוגי, פריסת ה-payload ו-zero padding ב-WORD האחרון אינם מצוטטים מתקן תעשייתי חיצוני אלא framing ייחודי של GEUL.

## אורך

- האורך הכולל הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer אחד, מספר פורמט אחד וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([רשומות ו-TAG WORD](/he/grammar/record/)).
- 0 בייטים נכתבים עם מספר פורמט זוגי (`0xC000`) כרשומה של 3 WORD בלי Payload (TAG, Issuer, מספר פורמט).

## דוגמה

הבייטים `ab cd ef` הם 3 בייטים (אי-זוגי), לכן מספר הפורמט הוא `0xC001` וה-Payload הוא `abcd ef00`. האורך הכולל 5 WORD, ולכן `LLLL=0100`.

```
0A7C 0000 C001 abcd ef00
```
