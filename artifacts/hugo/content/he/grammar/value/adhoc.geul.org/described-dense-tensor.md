---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR הוא Value של טנזור הרושם shape ו-element format ב-descriptor של ה-Payload ושומר payload בסדר C-contiguous row-major."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR הוא Value של טנזור הרושם shape ו-element format ב-descriptor של ה-Payload ושומר payload בסדר C-contiguous row-major. Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x00000002` ADHOC, מספר Codec ‏`0x00000600`, משפחה NUMERIC.

## פריסה {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG הרחבת Length] כאשר הסך הכול 15 WORD ומעלה
Issuer            2 WORD  0x00000002 (ADHOC)
מספר Codec        2 WORD  0x00000600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
שאר ה-Payload     [dense payload]
```

## פירוש {#해석}

- ה-rank הוא ערך של 4bit ב-descriptor, ולכן מבנית ניתן לייצג רק `0..15`. כל dimension הוא uint32 big-endian שאינו שלילי.
- כמו בכללי הטנזור הלוגיים של ONNX, shape ‏`[]` ב-rank 0 הוא scalar בעל איבר אחד, ואם אחד מה-dimension הוא 0, מספר האיברים הוא 0. בשאר המקרים מספר האיברים הוא מכפלת כל ה-dimension.
- ה-payload נקרא לפי ה-element format שב-descriptor, בסדר C-contiguous row-major. מספר האיברים הלוגי שחושב חייב להיות שווה למספר האיברים ב-payload שאחרי ה-descriptor.

## תקינות {#유효성}

- משנקבעו ה-version וה-element format הנתמכים, משחזרים את גבול ה-payload לפי רוחב האיבר ובודקים שהוא תואם למכפלת ה-shape, שחושבה ללא overflow.
- ה-descriptor, כל ה-dimension וה-payload חייבים להיכנס במלואם ב-Length של הרשומה, ואין ABI padding שרירותי.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- הכלל ש-shape הוא רשימת dimension שאינם שליליים ומספר הערכים שווה למכפלת ה-dimension, וכן המשמעות של scalar ב-rank 0 ושל zero dimension, הם לפי [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). הסדר הלוגי C-contiguous row-major מותאם לסדר של [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- rank של 4bit, dimension מסוג uint32, שדות version/element-format, GEUL TAG/Length ו-payload של WORD big-endian הם descriptor ייחודי של GEUL. הם אינם ה-serialization של wire או של זיכרון ב-[Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), ב-ONNX TensorProto או ב-[DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## אורך {#길이}

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload. עד 14 WORD משתמשים באורך ישיר, ומ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וה-TAG המורחב נכלל בסך הכול ([רשומה ו-TAG WORD](../../record.md)).
- ה-descriptor הוא WORD אחד, ה-shape הוא `2 × rank` WORD, והשאר הוא ה-payload.

## דוגמה {#예시}

- בפרופיל שבו rank הוא 2, 4 ה-WORD שאחרי ה-descriptor הם שני dimension מסוג uint32, וכל מה שאחריהם הוא ה-payload ב-row-major. כדי לקבוע אם זה מותר בפועל ולאמת את מספר האיברים נדרש פרופיל version ו-format מוסכם.

## בעיות פתוחות {#열린-문제}

- הערכים ברישום (registry) של version ו-element-format, וטווח הפרופילים שייתמכו מתוך ה-rank הניתן לייצוג `0..15`, טרם נקבעו.
