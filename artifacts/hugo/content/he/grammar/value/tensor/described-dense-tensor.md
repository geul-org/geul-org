---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR הוא פורמט Issuer של ADHOC ששומר אלמנטים בסדר row-major מסוג C-contiguous אחרי descriptor של element format, rank ו-shape."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR הוא Value של טנסור שרושם את ה-shape ואת ה-element format ב-descriptor של ה-Payload ושומר payload בסדר row-major מסוג C-contiguous. הוא Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0001` ADHOC, מספר פורמט `0x0600`, משפחה NUMERIC.

## פריסה

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] כשהכול 15 WORD ומעלה
Issuer            WORD אחד  0x0001 (ADHOC)
מספר פורמט        WORD אחד  0x0600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload השאר      [dense payload]
```

## פירוש

- ה-rank הוא ערך של 4 ביט ב-descriptor, ולכן מבנית אפשר לבטא רק `0..15`. כל dimension הוא uint32 לא שלילי ב-big-endian.
- כמו בכללי הטנסור הלוגי של ONNX, shape ריק `[]` ב-rank 0 הוא scalar בעל אלמנט אחד, ואם אחד מה-dimension הוא 0, מספר האלמנטים הוא 0. בכל מקרה אחר מספר האלמנטים הוא מכפלת כל ה-dimension.
- ה-payload נקרא לפי ה-element format של ה-descriptor, בסדר row-major מסוג C-contiguous. מספר האלמנטים הלוגי שחושב חייב להיות שווה למספר האלמנטים ב-payload שאחרי ה-descriptor.

## תקינות

- אחרי שנקבעים ה-version וה-element format הנתמכים, משחזרים את גבולות ה-payload לפי רוחב האלמנט ומוודאים שהם מתאימים למכפלת ה-shape שחושבה בלי overflow.
- ה-descriptor, כל ה-dimension וה-payload חייבים להיכנס כולם בתוך ה-Length של הרשומה, ואין ABI padding שרירותי.

## בסיס בתקנים ומעמד הפורמט

- הכלל ש-shape הוא רשימת dimension לא שליליים ושמספר הערכים שווה למכפלת ה-dimension, והמשמעות של scalar ב-rank 0 ושל zero dimension, הם לפי [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). הסדר הלוגי row-major מסוג C-contiguous מותאם לסדר של [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- rank של 4 ביט, dimension מסוג uint32, שדות version/element-format, TAG/Length של GEUL ו-payload של WORD ב-big-endian הם descriptor ייחודי של GEUL. אלה אינם סריאליזציית wire או זיכרון של [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), של ONNX TensorProto או של [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## אורך

- הסך הכול הוא מספר ה-WORD של TAG אחד, TAG הרחבת Length (אם יש), Issuer של WORD אחד, מספר פורמט של WORD אחד וה-Payload. עד 14 WORD משתמשים באורך ישיר, מ-15 WORD ומעלה באורך מורחב `1110`·`1111`, וגם TAG ההרחבה נכלל באורך הכולל ([רשומות ו-TAG WORD](/he/grammar/record/)).
- ה-descriptor הוא WORD אחד, ה-shape הוא `2 × rank` WORD, והשאר הוא ה-payload.

## דוגמה

- אם זה פרופיל עם rank 2, 4 ה-WORD אחרי ה-descriptor הם שני dimension מסוג uint32, וכל מה שאחריהם הוא payload מסוג row-major. כדי לדעת אם זה מותר בפועל ולאמת את מספר האלמנטים, דרוש פרופיל version ו-format שנקבע.

## שאלות פתוחות

- ערכי הפנקס של version ו-element-format, וטווח הפרופילים שיהיו נתמכים מתוך `0..15` ה-rank שאפשר לבטא, טרם נקבעו.
