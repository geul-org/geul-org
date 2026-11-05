---
title: "DENSE-BINARY16-VECTOR"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY16-VECTOR שומר דפוסי ביטים של interchange מסוג IEEE 754 binary16 ברצף, ללא descriptor."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY16-VECTOR שומר דפוסי ביטים של interchange מסוג IEEE 754 binary16 ברצף, ללא descriptor.

## פריסה {#레이아웃}

- קוד: Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x00000506`. משפחה NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x00000506
Payload: [binary16 bits 1st: 1 WORD] ... [binary16 bits Nth: 1 WORD]
```

## כללי פירוש {#해석-규칙}

- מספר האיברים הוא מספר ה-WORD ב-Payload. דפוס הביטים, כולל NaN payload ו-signed zero, נשמר כמות שהוא.
- אין ABI padding בין האיברים או בסופם.

## תקינות {#유효성}

- ה-Payload חייב להיות 1 WORD לפחות. הפורמט הזה, שאין בו descriptor, אינו מתיר vector ריק.
- גודל ה-Payload חייב להיות כפולה שלמה של רוחב האיבר, 1 WORD.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- פורמט ה-interchange של איברי binary16 הוא לפי [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- רצף חד-ממדי ללא descriptor, וכן הסידור של GEUL TAG/Length ושל WORD big-endian בן 16 ביט, הם פורמט ייחודי של GEUL. [`DLDataType` של DLPack](https://dmlc.github.io/dlpack/latest/c_api.html) מניח native-endian, ולכן ה-Payload הזה אינו ה-wire serialization של DLPack, Arrow או ONNX.

## אורך {#길이}

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload. עד 14 WORD משתמשים באורך ישיר, ומ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וה-TAG המורחב נכלל בסך הכול ([Length](../../record.md)).

## דוגמה {#예시}

- ה-Payload ‏`3C00 8000` הוא binary16 ‏`1.0` ו-`-0`, ורשומה של 7 WORD בסך הכול.
