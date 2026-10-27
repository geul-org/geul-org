---
title: "DENSE-I16-VECTOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I16-VECTOR הוא Value של וקטור חד-ממדי ששומר ברצף אלמנטים של int16 בלי descriptor (פורמט Issuer ‏0x0500 של ADHOC)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I16-VECTOR הוא Value חד-ממדי הומוגני ששומר ברצף אלמנטים int16 ב-big-endian בלי descriptor.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x0500`. משפחה NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] כשהכול 15 WORD ומעלה
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x0500
Payload: [int16 1st: WORD אחד] ... [int16 Nth: WORD אחד]
```

## כללי פירוש

- כל WORD נקרא כמספר שלם עצמאי של 16 ביט בשיטת המשלים ל-2. מספר האלמנטים הוא מספר ה-WORD של ה-Payload.
- אין ABI padding בין האלמנטים או בסופם.

## תקינות

- ה-Payload הוא לפחות WORD אחד. הפורמט הזה, שאין לו descriptor, אינו מתיר וקטור ריק.
- גודל ה-Payload חייב להיות כפולה שלמה של רוחב האלמנט, WORD אחד.

## בסיס בתקנים ומעמד הפורמט

- ה-signedness והרוחב של 16 ביט של dtype שלם עם סימן מותאמים ל-dtype התעשייתי של [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) ושל [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- הפירוש בשיטת המשלים ל-2, רצף חד-ממדי רציף בלי descriptor, ו-TAG/Length של GEUL ופריסת WORD ב-big-endian הם פורמט ייחודי של GEUL. DLPack מניח dtype ב-native-endian, ולכן ה-Payload הזה אינו סריאליזציית wire של DLPack או של ONNX.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של WORD אחד, מספר פורמט של WORD אחד וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([Length](/he/grammar/record/)).

## דוגמה

- Payload ‏`ffff 0002` הוא האלמנטים `[-1, 2]`, ורשומה של 5 WORD בסך הכול באורך ישיר `LLLL=0100`.
