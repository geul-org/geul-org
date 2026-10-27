---
title: "COMPLEX64"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64 שומר מספר מרוכב משני רכיבי binary32, החלק הממשי והחלק המדומה, בפורמט Issuer של ADHOC ברוחב קבוע של 7 WORD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64 הוא Value שמייצג מספר מרוכב משני רכיבי IEEE 754 binary32 בסדר `(real, imag)`. הוא Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x0700`, משפחה NUMERIC.

## פריסה

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  סך הכול 7 WORD
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x0700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## פירוש ותקינות

- כל רכיב הוא ביטי interchange של binary32 בסדר WORD של big-endian.
- דפוס הביטים נשמר כמות שהוא, כולל NaN payload ו-signed zero, ואין ABI padding.
- ה-Payload הוא בדיוק 4 WORD. כל דפוסי ה-interchange של שני רכיבי ה-binary32 נשמרים.

## בסיס בתקנים ומעמד הפורמט

- המשמעות ש-`complex64` מורכב מרכיב ממשי של 32 ביט ומרכיב מדומה של 32 ביט היא לפי [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), וסדר real-first זהה למיפוי ה-raw-data של complex ב-[ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) הרשמי. דפוס הביטים של כל רכיב הוא לפי [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- ה-raw data של ONNX הוא little-endian ברוחב קבוע, אך הפורמט הזה משתמש ב-framing של WORD ב-big-endian של GEUL, ולכן אינו סריאליזציית wire של ONNX TensorProto עצמה.

## אורך

- הסך הכול הוא בדיוק 7 WORD: TAG אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-Payload של 4 WORD, עם אורך ישיר `LLLL=0110`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 4 WORD, דוחים.

## דוגמה

- ה-Payload ‏`3f80 0000 4000 0000` הוא `1.0 + 2.0i`.
