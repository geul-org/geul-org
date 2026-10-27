---
title: "DENSE-I64-VECTOR"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I64-VECTOR הוא Value של וקטור חד-ממדי ששומר ברצף אלמנטים של int64 בלי descriptor (פורמט Issuer ‏0x0504 של ADHOC)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I64-VECTOR הוא Value חד-ממדי הומוגני ששומר ברצף אלמנטים int64 ב-big-endian בלי descriptor.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x0504`. משפחה NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] כשהכול 15 WORD ומעלה
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x0504
Payload: [int64 1st: 4 WORD] ... [int64 Nth: 4 WORD]
```

## כללי פירוש

- כל 4 WORD רצופים מחוברים, מה-WORD העליון, ונקראים כמספר שלם של 64 ביט בשיטת המשלים ל-2.
- מספר האלמנטים הוא רבע ממספר ה-WORD של ה-Payload, ואין ABI padding.

## תקינות

- ה-Payload הוא לפחות 4 WORD וחייב להיות כפולה שלמה של 4 WORD. הפורמט הזה, שאין לו descriptor, אינו מתיר וקטור ריק.

## בסיס בתקנים ומעמד הפורמט

- ה-signedness והרוחב של 64 ביט של dtype שלם עם סימן מותאמים ל-dtype התעשייתי של [ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) ושל [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- הפירוש בשיטת המשלים ל-2, רצף חד-ממדי רציף בלי descriptor, ו-TAG/Length של GEUL ופריסת WORD ב-big-endian הם פורמט ייחודי של GEUL. DLPack מניח dtype ב-native-endian, ולכן ה-Payload הזה אינו סריאליזציית wire של DLPack או של ONNX.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של WORD אחד, מספר פורמט של WORD אחד וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([Length](/he/grammar/record/)).

## דוגמה

- Payload ‏`ffff ffff ffff ffff` הוא האלמנטים `[-1]`, ורשומה של 7 WORD בסך הכול.
