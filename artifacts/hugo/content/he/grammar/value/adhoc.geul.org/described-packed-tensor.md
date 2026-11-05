---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1016
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR הוא Value של טנזור הרושם shape ו-packed format ב-descriptor של ה-Payload ושומר באופן packed איברים קטנים מ-WORD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR הוא Value של טנזור הרושם shape ו-packed format ב-descriptor של ה-Payload ושומר באופן packed איברים קטנים מ-WORD. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x00000601`, משפחה NUMERIC.

## פריסה {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x00000601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
שאר ה-Payload     [packed payload octet stream, low-bit-first]
```

## פירוש {#해석}

- ה-rank הוא ערך של 4bit ב-descriptor, ולכן מבנית ניתן לייצג רק `0..15`. כל dimension הוא uint32 big-endian שאינו שלילי. הסדר הלוגי הוא C-contiguous row-major.
- כמו בכללי הטנזור הלוגיים של ONNX, shape ‏`[]` ב-rank 0 הוא scalar בעל איבר אחד, ואם אחד מה-dimension הוא 0, מספר האיברים הוא 0. בשאר המקרים מספר האיברים הוא מכפלת כל ה-dimension.
- ה-packed-format קובע את ה-encoding של האיבר ואת רוחב הביטים שלו, כמו int2/int4, ‏FP4/FP6 או וריאנטים מסוימים של FP8.
- אם רצף ה-octet של ה-payload הוא `p[0], p[1], ...`, ומתייחסים אליו כמספר שלם little-bit-endian ‏`P = Σ(p[j] << (8j))`, אז האיבר הלוגי `i` ברוחב `w` הוא `(P >> (i × w)) & ((1 << w) - 1)`. כלומר מניחים מהאיבר הראשון בביט הנמוך ביותר.
- ב-WORD, ‏`p[0]` נישא ב-octet העליון של ה-WORD הראשון, ‏`p[1]` ב-octet התחתון, וכן הלאה. ביטי ה-tail העליונים שאינם בשימוש ב-octet האחרון שבשימוש חייבים להיות 0, ואם מספר ה-octet ב-payload אי-זוגי, כל ה-octet התחתון שאינו בשימוש ב-WORD האחרון חייב להיות `00`.

## תקינות {#유효성}

- כשמיישמים את רוחב הביטים של ה-format הנתמך, מכפלת ה-dimension של ה-shape, שחושבה ללא overflow, חייבת להתאים למספר האיברים ב-payload.
- דוחים אם ביט tail עליון או padding של octet אחרי ביטי ה-payload הנדרשים הוא 1 ולו באחד. ה-descriptor, ה-shape וה-payload חייבים להיכנס במלואם ב-Length של הרשומה.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- המשמעות הלוגית של shape, scalar ב-rank 0 ו-zero dimension היא לפי [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). הכלל של הנחת איברי sub-byte החל מהביט הנמוך הוא לפי packing של int2/int4 ב-[ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) הרשמי ולפי packing מסוג little bit-endian ב-[`DLDataType` של DLPack](https://dmlc.github.io/dlpack/latest/c_api.html).
- rank של 4bit, dimension מסוג uint32, שדות version/packed-format, אופן אריזת ה-octet ל-WORD big-endian ו-GEUL TAG/Length הם descriptor ייחודי של GEUL. הם אינם ה-serialization של wire או של זיכרון ב-ONNX, ב-[Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html) או ב-DLPack עצמם.

## אורך {#길이}

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload. עד 14 WORD משתמשים באורך ישיר, ומ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וה-TAG המורחב נכלל בסך הכול ([רשומה ו-TAG WORD](../../record.md)).
- ה-descriptor הוא WORD אחד, ה-shape הוא `2 × rank` WORD, והשאר הוא ה-packed payload.
- אם מספר האיברים הלוגי הוא `N` ורוחב האיבר הוא `w`, מספר ה-octet ב-payload הוא `ceil(N × w / 8)`, ומספר ה-WORD ב-payload הוא `ceil(מספר ה-octet ב-payload / 2)`.

## דוגמה {#예시}

- בפרופיל שבו rank הוא 2, 4 ה-WORD שאחרי ה-descriptor הם ה-shape, ואחריהם רצף ה-octet של ה-payload ב-low-bit-first. רוחב האיבר והאם זה מותר בפועל נקבעים לפי פרופיל format מוסכם.
- רצף ה-octet של ה-payload לאיברי 4bit ‏`[1, 2, 3]` הוא `21 03`, וה-WORD של ה-payload הוא `2103`. האיבר הראשון נמצא ב-nibble הנמוך של ה-octet הראשון, וה-nibble העליון שאינו בשימוש ב-octet האחרון הוא 0.

## בעיות פתוחות {#열린-문제}

- הערכים ברישום (registry) של version ו-packed-format, וטווח הפרופילים שייתמכו מתוך ה-rank הניתן לייצוג `0..15`, טרם נקבעו.
