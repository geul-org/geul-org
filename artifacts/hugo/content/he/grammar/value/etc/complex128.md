---
title: "COMPLEX128"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX128 שומר מספר מרוכב משני רכיבי binary64, החלק הממשי והחלק המדומה, בפורמט Issuer של ADHOC ברוחב קבוע של 11 WORD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX128 הוא Value שמייצג מספר מרוכב משני רכיבי IEEE 754 binary64 בסדר `(real, imag)`. הוא Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x0701`, משפחה NUMERIC.

## פריסה

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  סך הכול 11 WORD
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x0701
Payload           [real binary64: 4 WORD][imag binary64: 4 WORD]
```

## פירוש ותקינות

- כל רכיב הוא ביטי interchange של binary64 בסדר WORD של big-endian.
- דפוס הביטים נשמר כמות שהוא, כולל NaN payload ו-signed zero, ואין ABI padding.
- ה-Payload הוא בדיוק 8 WORD. כל דפוסי ה-interchange של שני רכיבי ה-binary64 נשמרים.

## בסיס בתקנים ומעמד הפורמט

- המשמעות ש-`complex128` מורכב מרכיב ממשי של 64 ביט ומרכיב מדומה של 64 ביט היא לפי [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html), וסדר real-first זהה למיפוי ה-raw-data של complex ב-[ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) הרשמי. דפוס הביטים של כל רכיב הוא לפי [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- ה-raw data של ONNX הוא little-endian ברוחב קבוע, אך הפורמט הזה משתמש ב-framing של WORD ב-big-endian של GEUL, ולכן אינו סריאליזציית wire של ONNX TensorProto עצמה.

## אורך

- הסך הכול הוא בדיוק 11 WORD: TAG אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-Payload של 8 WORD, עם אורך ישיר `LLLL=1010`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 8 WORD, דוחים.

## דוגמה

- אם שני ה-binary64 ב-Payload הם `1.0, -0.0`, הערך הוא בעל חלק ממשי 1.0 וחלק מדומה -0.0.
