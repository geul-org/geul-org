---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR הוא פורמט Issuer של ADHOC שממלא אלמנטים קטנים מ-WORD בשיטת low-bit-first אחרי descriptor של packed format, rank ו-shape."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR הוא Value של טנסור שרושם את ה-shape ואת ה-packed format ב-descriptor של ה-Payload ושומר ארוז אלמנטים קטנים מ-WORD. הוא Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x0601`, משפחה NUMERIC.

## פריסה

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] כשהכול 15 WORD ומעלה
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x0601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload השאר      [packed payload octet stream, low-bit-first]
```

## פירוש

- ה-rank הוא ערך של 4 ביט ב-descriptor, ולכן מבנית אפשר לבטא רק `0..15`. כל dimension הוא uint32 לא שלילי ב-big-endian. הסדר הלוגי הוא row-major מסוג C-contiguous.
- כמו בכללי הטנסור הלוגי של ONNX, shape ריק `[]` ב-rank 0 הוא scalar בעל אלמנט אחד, ואם אחד מה-dimension הוא 0, מספר האלמנטים הוא 0. בכל מקרה אחר מספר האלמנטים הוא מכפלת כל ה-dimension.
- ה-packed-format מקבע את הקידוד של האלמנט ואת רוחב הביטים, כמו int2/int4, FP4/FP6 ווריאנטים מסוימים של FP8.
- נסמן את רצף ה-octet של ה-payload ב-`p[0], p[1], ...` ונראה אותו כמספר שלם little-bit-endian `P = Σ(p[j] << (8j))`. האלמנט הלוגי `i` ברוחב `w` הוא `(P >> (i × w)) & ((1 << w) - 1)`. כלומר מציבים את האלמנט הראשון בביט הנמוך ביותר.
- ב-WORD, `p[0]` נטען ב-octet העליון של ה-WORD הראשון, ואחריו `p[1]` ב-octet התחתון, וכן הלאה. ביטי הזנב העליונים שלא בשימוש ב-octet האחרון שבשימוש חייבים להיות 0, ואם מספר ה-octet ב-payload אי-זוגי, כל ה-octet התחתון שלא בשימוש ב-WORD האחרון חייב להיות `00`.

## תקינות

- כשמחילים את רוחב הביטים של ה-format הנתמך, מכפלת ה-dimension של ה-shape שחושבה בלי overflow חייבת להתאים למספר האלמנטים ב-payload.
- אם ביט זנב עליון או ריפוד octet אחרי ביטי ה-payload הדרושים הוא 1, אפילו אחד, דוחים. ה-descriptor, ה-shape וה-payload חייבים להיכנס כולם בתוך ה-Length של הרשומה.

## בסיס בתקנים ומעמד הפורמט

- המשמעות הלוגית של shape, scalar ב-rank 0 ו-zero dimension היא לפי [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). הכלל להציב אלמנטים קטנים מבייט מהביט הנמוך הוא לפי packing של int2/int4 ב-[ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) הרשמי ולפי packing של little bit-endian ב-[DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- rank של 4 ביט, dimension מסוג uint32, שדות version/packed-format, האריזה של octet ל-WORD ב-big-endian ו-TAG/Length של GEUL הם descriptor ייחודי של GEUL. אלה אינם סריאליזציית wire או זיכרון של ONNX, של [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) או של DLPack עצמו.

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של WORD אחד, מספר פורמט של WORD אחד וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([רשומות ו-TAG WORD](/he/grammar/record/)).
- ה-descriptor הוא WORD אחד, ה-shape הוא `2 × rank` WORD, והשאר הוא ה-payload הארוז.
- אם מספר האלמנטים הלוגי הוא `N` ורוחב האלמנט הוא `w`, מספר ה-octet של ה-payload הוא `ceil(N × w / 8)`, ומספר ה-WORD של ה-payload הוא `ceil(מספר octet של ה-payload / 2)`.

## דוגמה

- אם זה פרופיל עם rank 2, 4 ה-WORD אחרי ה-descriptor הם ה-shape, ואחריהם רצף octet של payload מסוג low-bit-first. רוחב האלמנט והאם זה מותר בפועל נקבעים לפי פרופיל format שנקבע.
- רצף ה-octet של ה-payload עבור אלמנטי 4 ביט `[1, 2, 3]` הוא `21 03`, וה-WORD של ה-payload הוא `2103`. האלמנט הראשון נמצא ב-nibble התחתון של ה-octet הראשון, וה-nibble העליון שלא בשימוש ב-octet האחרון הוא 0.

## שאלות פתוחות

- ערכי הפנקס של version ו-packed-format, וטווח הפרופילים שיהיו נתמכים מתוך `0..15` ה-rank שאפשר לבטא, טרם נקבעו.
