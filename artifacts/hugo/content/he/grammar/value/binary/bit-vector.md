---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR הוא פורמט Issuer של GEUL שמכיל מספר ביטים N ב-32 ביט ואחריו N ביטים בסדר MSB-first."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR הוא raw bit sequence שאורכו מוצהר. הוא Value מסוג `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, מספר פורמט `0xC002`, משפחה BINARY. שני ה-Payload WORD הראשונים הם bit count `N` כמספר unsigned של 32 ביט, ואחריהם `ceil(N/16)` WORD.

## פריסה

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[TAG הרחבת Length] כשהכול 15 WORD ומעלה
Issuer            1 WORD  0x0000 (GEUL)
מספר פורמט        1 WORD  0xC002
Payload WORD 1st–2nd       Bit Count N (16 ביט עליונים │ 16 ביט תחתונים)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## פרשנות ותקינות

- `N` הוא הערך שמתקבל מקריאת שני ה-Payload WORD הראשונים כמספר שלם unsigned של 32 ביט ב-big-endian.
- ביטי ה-payload ממלאים כל WORD לפי הסדר, החל מהביט העליון ביותר.
- מספר ה-payload WORD הוא בדיוק `ceil(N/16)`, וכל הביטים התחתונים שאינם בשימוש ב-WORD האחרון חייבים להיות 0.
- כש-`N=0` אין payload WORD. שני ה-count WORD כבר מהווים את ה-Payload, ולכן אין סתירה לכלל המינימום של Payload באורך WORD אחד.

## מעמד הפורמט

- bit count unsigned של 32 ביט, סידור MSB-first ו-zero padding ב-WORD האחרון אינם מצוטטים מתקן תעשייתי חיצוני אלא framing ייחודי של GEUL.
- הדף הזה מגדיר את הייצוג, כולל כללי GEUL TAG, Length ו-WORD של 16 ביט.

## אורך

- האורך הכולל הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer אחד, מספר פורמט אחד וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([רשומות ו-TAG WORD](/he/grammar/record/)).

## דוגמה

- וקטור ביטים ריק: count `0000 0000`, ללא payload, 5 WORD בסך הכול, `LLLL=0100`.
- רצף הביטים `101`: count `0000 0003`, payload `a000`, 6 WORD בסך הכול, `LLLL=0101`.
