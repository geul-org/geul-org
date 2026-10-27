---
title: "RGBA8-UNORM"
weight: 1014
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "RGBA8-UNORM قيمة Value لبكسل تحمل أربعة مكوّنات UNORM8 بترتيب R وG وB وA في 2 WORD من Payload (صيغة KHRONOS Issuer 0x0000)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RGBA8-UNORM قيمة Value تخزّن أربعة مكوّنات UNORM8 هي R وG وB وA بصورة packed في Payload ثابت من 2 WORD.

## التخطيط

- الرمز: Value `ISSUER-1WORD` (`0x7C`)، وIssuer `0x0041` KHRONOS، ورقم الصيغة `0x0000`. العائلة NUMERIC.

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  المجموع 5 WORD
Issuer            1 WORD  0x0041 (KHRONOS)
رقم الصيغة        1 WORD  0x0000
Payload WORD 1st: [R: أعلى 8bit][G: أدنى 8bit]
Payload WORD 2nd: [B: أعلى 8bit][A: أدنى 8bit]
```

## قواعد التفسير

- ترتيب byte في التسلسل هو `R, G, B, A`، وقيمة كل مكوّن byte `b` هي `b / 255`.
- هذا يقابل ترتيب مكوّنات byte 0~3 والتطابق العددي UNORM في `VK_FORMAT_R8G8B8A8_UNORM` من Vulkan.
- ليست صيغة `_SRGB` فلا تشير إلى sRGB ولا إلى أي فضاء ألوان أو transfer function آخر. وalpha أيضاً قيمة عددية UNORM، لكن كونها straight أو premultiplied ومعنى compositing من السياق الخارجي. لا يوجد ABI padding.

## الصلاحية

- كل أنماط الـ 8 بتات صالحة. يجب أن يكون Payload هو 2 WORD تماماً.

## السند المعياري ووضع الصيغة

- ترتيب مكوّنات الذاكرة ومعنى UNORM مطابقان لـ `VK_FORMAT_R8G8B8A8_UNORM` في [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) و[Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) من Khronos.
- قواعد TAG/Length في GEUL وframing بـ WORD ذات 16 بت وفق big-endian قواعد خاصة بـ GEUL، ولا تعرّف تسلسل صورة Vulkan نفسها.

## الطول

- المجموع هو TAG (1 WORD) وIssuer (1 WORD) ورقم الصيغة (1 WORD) وPayload (2 WORD)، أي 5 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0100`. لا يوجد Length ممتد TAG ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 2 WORD تماماً.

## أمثلة

- الـ Payload `ff00 0080` هو bytes `R=ff, G=00, B=00, A=80`.
