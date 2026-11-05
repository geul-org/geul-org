---
title: "BGRA8-UNORM"
weight: 1037
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORM הוא Value השומר באופן packed ארבעה רכיבי UNORM8, B, G, R, A, ב-Payload קבוע של 2 WORD."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORM הוא Value השומר באופן packed ארבעה רכיבי UNORM8, B, G, R, A, ב-Payload קבוע של 2 WORD.

## פריסה {#레이아웃}

- קוד: Value ‏`VALUE-ISSUER-2WORD` (`0x09DL`), Issuer ‏`0x0000000E` KHRONOS, מספר Codec ‏`0x00000001`. משפחה NUMERIC.

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  7 WORD בסך הכול
Issuer            2 WORD  0x0000000E (KHRONOS)
מספר Codec        2 WORD  0x00000001
Payload WORD 1st: [B: 8bit עליונים][G: 8bit תחתונים]
Payload WORD 2nd: [R: 8bit עליונים][A: 8bit תחתונים]
```

## כללי פירוש {#해석-규칙}

- סדר ה-byte בסריאליזציה הוא `B, G, R, A`, והערך של byte ‏`b` בכל רכיב הוא `b / 255`.
- הדבר מתאים לסדר הרכיבים של byte 0~3 ולמיפוי המספרי UNORM של `VK_FORMAT_B8G8R8A8_UNORM` ב-Vulkan.
- זה אינו פורמט `_SRGB`, ולכן אינו מרמז על sRGB או על מרחב צבע אחר או transfer function. גם alpha הוא ערך מספרי UNORM, אך השאלה אם הוא straight או premultiplied והמשמעות של compositing הן הקשר חיצוני. אין ABI padding.

## תקינות {#유효성}

- כל דפוסי 8 הביטים תקפים. ה-Payload חייב להיות בדיוק 2 WORD.

## בסיס בתקנים ומעמד הפורמט {#표준-근거와-형식-지위}

- סדר הרכיבים בזיכרון והמשמעות של UNORM מותאמים ל-`VK_FORMAT_B8G8R8A8_UNORM` ב-[Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) וב-[Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) של Khronos.
- GEUL TAG/Length ו-framing של שני WORD big-endian בני 16 ביט הם כללים ייחודיים של GEUL, והם אינם מגדירים serialization של תמונת Vulkan עצמה.

## אורך {#길이}

- הסך הכול הוא בדיוק 7 WORD: TAG של WORD אחד, Issuer של 2 WORD, מספר Codec של 2 WORD ו-Payload של 2 WORD, עם אורך ישיר `LLLL=0110`. אין TAG הרחבת Length, descriptor ו-padding.
- אם ה-Payload אינו בדיוק 2 WORD, דוחים.

## דוגמה {#예시}

- ה-Payload ‏`0000 FF80` הוא bytes ‏`B=00, G=00, R=FF, A=80`.
