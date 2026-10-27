---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR הוא Value של וקטור חד-ממדי ששומר ברצף אלמנטים של bfloat16 בלי descriptor (פורמט Issuer ‏0x0507 של ADHOC)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR שומר ברצף דפוסי ביטים של אלמנט bfloat16 בן 16 ביט, בלי descriptor. זהו פורמט שונה מ-binary16.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x0507`. משפחה NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] כשהכול 15 WORD ומעלה
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x0507
Payload: [BF16 bits 1st: WORD אחד] ... [BF16 bits Nth: WORD אחד]
```

## כללי פירוש

- מספר האלמנטים הוא מספר ה-WORD של ה-Payload. דפוס הביטים נשמר כמות שהוא, כולל NaN payload ו-signed zero.
- אין ABI padding בין האלמנטים או בסופם.

## תקינות

- ה-Payload הוא לפחות WORD אחד. הפורמט הזה, שאין לו descriptor, אינו מתיר וקטור ריק.
- גודל ה-Payload חייב להיות כפולה שלמה של רוחב האלמנט, WORD אחד.

## בסיס בתקנים ומעמד הפורמט

- dtype נפרד של 16 ביט, bfloat16, וההבחנה שלו מ-binary16 מותאמים ל-[ONNX IR tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) ול-[DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html).
- רצף חד-ממדי רציף של דפוסי ביטים בלי descriptor, ו-TAG/Length של GEUL ופריסת WORD של 16 ביט ב-big-endian הם פורמט ייחודי של GEUL. DLPack מניח native-endian, ולכן ה-Payload הזה אינו סריאליזציית wire של DLPack, Arrow או ONNX.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של WORD אחד, מספר פורמט של WORD אחד וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([Length](/he/grammar/record/)).

## דוגמה

- Payload ‏`3f80 8000` הוא BF16 ‏`1.0` ו-`-0`, ורשומה של 5 WORD בסך הכול.
