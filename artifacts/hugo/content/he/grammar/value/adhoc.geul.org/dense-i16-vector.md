---
title: "DENSE-I16-VECTOR"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I16-VECTOR הוא Value חד-ממדי הומוגני השומר איברי int16 בפורמט big-endian ברצף, ללא descriptor."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I16-VECTOR הוא Value חד-ממדי הומוגני השומר איברי int16 בפורמט big-endian ברצף, ללא descriptor.

## פריסה {#레이아웃}

- קוד: Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x00000500`. משפחה NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x00000500
Payload: [int16 1st: 1 WORD] ... [int16 Nth: 1 WORD]
```

## כללי פירוש {#해석-규칙}

- כל WORD נקרא כמספר שלם עצמאי בן 16 ביט, בשיטת המשלים ל-2. מספר האיברים הוא מספר ה-WORD ב-Payload.
- אין ABI padding בין האיברים או בסופם.

## תקינות {#유효성}

- ה-Payload חייב להיות 1 WORD לפחות. הפורמט הזה, שאין בו descriptor, אינו מתיר vector ריק.
- גודל ה-Payload חייב להיות כפולה שלמה של רוחב האיבר, 1 WORD.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- ה-signedness ורוחב 16 הביטים של dtype שלם מסומן (signed integer) מותאמים ל-dtype התעשייתי של [tensor element type ב-ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) ושל [`DLDataType` של DLPack](https://dmlc.github.io/dlpack/latest/c_api.html).
- הפירוש בשיטת המשלים ל-2, רצף חד-ממדי ללא descriptor, וכן הסידור של GEUL TAG/Length ושל WORD big-endian, הם פורמט ייחודי של GEUL. DLPack מניח ש-dtype הוא native-endian, ולכן ה-Payload הזה אינו ה-wire serialization של DLPack או ONNX.

## אורך {#길이}

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload. עד 14 WORD משתמשים באורך ישיר, ומ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וה-TAG המורחב נכלל בסך הכול ([Length](../../record.md)).

## דוגמה {#예시}

- ה-Payload ‏`FFFF 0002` הוא האיברים `[-1, 2]`, ורשומה של 7 WORD בסך הכול עם אורך ישיר `LLLL=0110`.
