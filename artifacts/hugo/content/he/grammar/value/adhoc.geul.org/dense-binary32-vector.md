---
title: "DENSE-BINARY32-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY32-VECTOR שומר דפוסי ביטים של interchange מסוג IEEE 754 binary32 ברצף, ללא descriptor."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY32-VECTOR שומר דפוסי ביטים של interchange מסוג IEEE 754 binary32 ברצף, ללא descriptor.

## פריסה {#레이아웃}

- קוד: Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x00000508`. משפחה NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x00000508
Payload: [binary32 bits 1st: 2 WORD] ... [binary32 bits Nth: 2 WORD]
```

## כללי פירוש {#해석-규칙}

- 2 WORD רצופים הם איבר אחד, ונקראים מה-WORD העליון. דפוס הביטים, כולל NaN payload ו-signed zero, נשמר כמות שהוא.
- מספר האיברים הוא מספר ה-WORD ב-Payload חלקי 2, ואין ABI padding.

## תקינות {#유효성}

- ה-Payload הוא 2 WORD לפחות, וכפולה שלמה של 2 WORD. הפורמט הזה, שאין בו descriptor, אינו מתיר vector ריק.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- פורמט ה-interchange של איברי binary32 הוא לפי [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- רצף חד-ממדי ללא descriptor, וכן הסידור של GEUL TAG/Length ושל WORD big-endian בן 16 ביט, הם פורמט ייחודי של GEUL. [`DLDataType` של DLPack](https://dmlc.github.io/dlpack/latest/c_api.html) מניח native-endian, ולכן ה-Payload הזה אינו ה-wire serialization של DLPack, Arrow או ONNX.

## אורך {#길이}

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload. עד 14 WORD משתמשים באורך ישיר, ומ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וה-TAG המורחב נכלל בסך הכול ([Length](../../record.md)).

## דוגמה {#예시}

- ה-Payload ‏`3F80 0000 8000 0000` הוא binary32 ‏`[1.0, -0]`, ורשומה של 9 WORD בסך הכול.
