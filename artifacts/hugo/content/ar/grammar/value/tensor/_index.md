---
title: "Value — التنسور"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "تنسورات صيغ Issuer في عائلة NUMERIC (ADHOC `0x0600`~`0x0601`): تنسورات dense وpacked المرفقة بصيغة العنصر وrank وshape."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

صيغ التنسور هي صيغ Issuer في عائلة NUMERIC. توضع في ADHOC (`0x0001`) بأرقام الصيغ `0x0600`~`0x0601`.

- يحمل DESCRIBED-DENSE-TENSOR صيغة العنصر وrank وshape وpayload من نوع dense بترتيب C-contiguous.
- يحمل DESCRIBED-PACKED-TENSOR صيغة packed وrank وshape وpayload من نوع packed يُملأ داخل octet بترتيب low-bit-first.
