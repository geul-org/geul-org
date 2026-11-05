---
title: "COMPLEX64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 הוא Value המייצג מספר מרוכב בשני רכיבי IEEE 754 binary32 בסדר (real, imag)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 הוא Value המייצג מספר מרוכב בשני רכיבי IEEE 754 binary32 בסדר `(real, imag)`. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x00000700`, משפחה NUMERIC.

## פריסה {#레이아웃}

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD בסך הכול
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x00000700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## פירוש ותוקף {#해석과-유효성}

- כל רכיב הוא interchange bits של binary32 בסדר WORD של big-endian.
- דפוס הביטים, כולל NaN payload ו-signed zero, נשמר כמות שהוא. אין ABI padding.
- ה-Payload הוא בדיוק 4 WORD. כל דפוסי ה-interchange bit של שני רכיבי ה-binary32 נשמרים.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- המשמעות ש-`complex64` מורכב מרכיב real של 32bit ורכיב imaginary של 32bit היא לפי [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), וסדר real-first זהה ל-complex raw-data mapping ב-[ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) הרשמי. דפוס הביטים של כל רכיב הוא לפי [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- ה-raw data של ONNX הוא fixed-width little-endian, אך הפורמט הזה משתמש ב-framing של WORD big-endian של GEUL, ולכן אינו ה-wire serialization של ONNX TensorProto עצמו.

## אורך {#길이}

- הסך הכול הוא בדיוק 9 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 4 WORD, עם אורך ישיר `LLLL=1000`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה {#예시}

- ה-Payload ‏`3F80 0000 4000 0000` הוא `1.0 + 2.0i`.
