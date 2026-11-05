---
title: "RGBA8-UNORM"
weight: 1038
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "RGBA8-UNORM هو Value يخزّن أربعة مكوّنات UNORM8 بالترتيب R, G, B, A بصورة packed في Payload ثابت من 2 WORD."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RGBA8-UNORM هو Value يخزّن أربعة مكوّنات UNORM8 بالترتيب R, G, B, A بصورة packed في Payload ثابت من 2 WORD.

## التخطيط {#레이아웃}

- الرمز: Value `VALUE-ISSUER-2WORD` (`0x09DL`)، Issuer `0x0000000E` KHRONOS، رقم Codec `0x00000000`. العائلة NUMERIC.

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  الإجمالي 7 WORD
Issuer            2 WORD  0x0000000E (KHRONOS)
رقم Codec         2 WORD  0x00000000
Payload WORD 1st: [R: الـ 8bit العليا][G: الـ 8bit الدنيا]
Payload WORD 2nd: [B: الـ 8bit العليا][A: الـ 8bit الدنيا]
```

## قواعد التفسير {#해석-규칙}

- ترتيب byte في التسلسل هو `R, G, B, A`، وقيمة كل مكوّن byte `b` هي `b / 255`.
- وهذا يقابل ترتيب مكوّنات byte 0~3 وتعيين القيم العددية UNORM في `VK_FORMAT_R8G8B8A8_UNORM` من Vulkan.
- ليست هذه صيغة `_SRGB`، فلا تدل على sRGB ولا على أي فضاء لوني أو transfer function آخر. كما أن alpha قيمة UNORM عددية، لكن كونه straight/premultiplied ومعنى compositing سياق خارجي. لا يوجد ABI padding.

## الصلاحية {#유효성}

- كل أنماط الـ 8 bit صالحة. ويجب أن يكون Payload 2 WORD بالضبط.

## المرجع القياسي والمرتبة الشكلية {#표준-근거와-형식-지위}

- يوافق component memory order ومعنى UNORM الصيغة `VK_FORMAT_R8G8B8A8_UNORM` في [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) و[Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) من Khronos.
- إن TAG/Length في GEUL وتأطير WORD الاثنين بعرض 16bit من نوع big-endian قواعد خاصة بـ GEUL، ولا تعرّف serialization لصورة Vulkan نفسها.

## الطول {#길이}

- الإجمالي هو TAG بمقدار 1 WORD، وIssuer 2 WORD، ورقم Codec 2 WORD، وPayload 2 WORD، أي 7 WORD بالضبط، ويُستخدم الطول المباشر `LLLL=0110`. لا يوجد Length TAG ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 2 WORD بالضبط.

## مثال {#예시}

- Payload `FF00 0080` هو bytes `R=FF, G=00, B=00, A=80`.
