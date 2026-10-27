---
title: "DENSE-BINARY64-VECTOR"
weight: 1010
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY64-VECTOR הוא Value של וקטור חד-ממדי ששומר ברצף אלמנטים של IEEE 754 binary64 בלי descriptor (פורמט Issuer ‏0x0509 של ADHOC)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY64-VECTOR שומר ברצף דפוסי ביטי interchange של IEEE 754 binary64, בלי descriptor.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x0509`. משפחה NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] כשהכול 15 WORD ומעלה
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x0509
Payload: [binary64 bits 1st: 4 WORD] ... [binary64 bits Nth: 4 WORD]
```

## כללי פירוש

- כל אלמנט הוא 4 WORD רצופים שנקראים מה-WORD העליון. דפוס הביטים נשמר כמות שהוא, כולל NaN payload ו-signed zero.
- מספר האלמנטים הוא רבע ממספר ה-WORD של ה-Payload, ואין ABI padding.

## תקינות

- ה-Payload הוא לפחות 4 WORD וחייב להיות כפולה שלמה של 4 WORD. הפורמט הזה, שאין לו descriptor, אינו מתיר וקטור ריק.

## בסיס בתקנים ומעמד הפורמט

- פורמט ה-interchange של אלמנט binary64 הוא לפי ב-[IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- רצף חד-ממדי רציף בלי descriptor, ו-TAG/Length של GEUL ופריסת WORD של 16 ביט ב-big-endian הם פורמט ייחודי של GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) מניח native-endian, ולכן ה-Payload הזה אינו סריאליזציית wire של DLPack, Arrow או ONNX.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של WORD אחד, מספר פורמט של WORD אחד וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([Length](/he/grammar/record/)).

## דוגמה

- Payload ‏`3ff0 0000 0000 0000` הוא binary64 ‏`[1.0]`, ורשומה של 7 WORD בסך הכול.
