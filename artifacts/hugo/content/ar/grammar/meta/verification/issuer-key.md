---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY هو Meta تحقق يصرّح بمعرّف خوارزمية التوقيع والمفتاح العام لـ Issuer ذاتي الإصدار (16 WORD)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يصرّح بالمفتاح العام لـ Issuer ذاتي الإصدار (16 WORD). معرّف Issuer = SHA-256("GEUL-ISSUER-v1" ‖ معرّف الخوارزمية ‖ المفتاح العام) ([16 WORD Issuer](/ar/grammar/issuer/#16-word-issuer)).

## التخطيط

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[Length ممتد TAG]
معرّف الخوارزمية  1 WORD (0x0001 = Ed25519)
المفتاح العام     العرض الذي تحدده الخوارزمية (Ed25519 16 WORD)
```

- Codec: Meta `0x40`، فئة التحقق (`100`)
- Payload: قيمة خام (معرّف الخوارزمية + المفتاح العام)
- العدد: يمكن أكثر من واحد (تبديل المفاتيح)

## التفسير والصلاحية

- لأنه من فئة التحقق فهو مستثنى من تجزئة المحتوى.
- Issuer من 1 و2 و4 WORD يستخدم المفتاح المسجل في geul.org فلا حاجة إليه.
