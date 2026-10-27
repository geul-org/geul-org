---
title: "RGBA8-UNORM"
weight: 1014
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "RGBA8-UNORM הוא Value ששומר ארוז ארבעה רכיבי UNORM8, R, G, B, A, ב-Payload קבוע של 2 WORD (פורמט Issuer 0x0000 של KHRONOS)."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RGBA8-UNORM הוא Value ששומר ארוז ארבעה רכיבי UNORM8, R, G, B ו-A, ב-Payload קבוע של 2 WORD.

## פריסה

- קוד: Value ‏`ISSUER-1WORD` (`0x7C`), Issuer ‏`0x0041` KHRONOS, מספר פורמט `0x0000`. משפחה NUMERIC.

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  סך הכול 5 WORD
Issuer            WORD אחד  0x0041 (KHRONOS)
מספר פורמט        WORD אחד  0x0000
Payload WORD 1st: [R: 8 הביטים העליונים][G: 8 הביטים התחתונים]
Payload WORD 2nd: [B: 8 הביטים העליונים][A: 8 הביטים התחתונים]
```

## כללי פירוש

- סדר הבייטים בסריאליזציה הוא `R, G, B, A`, וערך כל בייט רכיב `b` הוא `b / 255`.
- זה מתאים לסדר הרכיבים של בייטים 0~3 ולמיפוי המספרי UNORM של `VK_FORMAT_R8G8B8A8_UNORM` ב-Vulkan.
- זה אינו פורמט `_SRGB`, ולכן אינו משתמע ממנו sRGB או מרחב צבע או transfer function אחרים. גם alpha הוא ערך UNORM, אך האם הוא straight או premultiplied והמשמעות של compositing הם הקשר חיצוני. אין ABI padding.

## תקינות

- כל דפוס של 8 ביט תקף. ה-Payload חייב להיות בדיוק 2 WORD.

## בסיס בתקנים ומעמד הפורמט

- סדר הרכיבים בזיכרון ומשמעות UNORM מותאמים ל-`VK_FORMAT_R8G8B8A8_UNORM` ב-[Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) ו-[Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) של Khronos.
- TAG/Length של GEUL ו-framing של שני WORD של 16 ביט ב-big-endian הם כללים ייחודיים של GEUL, ואינם מגדירים את הסריאליזציה של תמונת Vulkan עצמה.

## אורך

- הסך הכול הוא בדיוק 5 WORD: TAG אחד, Issuer של WORD אחד, מספר פורמט של WORD אחד ו-Payload של 2 WORD, עם אורך ישיר `LLLL=0100`. אין TAG הרחבת Length, descriptor או padding.
- אם ה-Payload אינו בדיוק 2 WORD, דוחים.

## דוגמה

- ה-Payload ‏`ff00 0080` הוא הבייטים `R=ff, G=00, B=00, A=80`.
