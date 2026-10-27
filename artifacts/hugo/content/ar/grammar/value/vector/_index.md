---
title: "Value — المتجهات"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "متجهات صيغ Issuer في عائلة NUMERIC (ADHOC `0x05xx` وKHRONOS): المتجهات الكثيفة الصحيحة والحقيقية، والنقاط ثنائية وثلاثية الأبعاد، والمربعات الحدية، وبكسلات RGBA8 وBGRA8."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

صيغ المتجهات هي صيغ Issuer في عائلة NUMERIC. المتجهات الكثيفة الصحيحة والحقيقية والنقاط والمربعات الحدية توضع في ADHOC (`0x0001`) بأرقام الصيغ `0x0500`~`0x050C`، وصيغ البكسل تحت KHRONOS (`0x0041`).

- تُخزَّن عناصر المتجه الكثيف متتالية بترتيب big-endian.
- لأنها صيغ Issuer يلحق بـ Codec ممتد TAG كل من Issuer ورقم الصيغة (2 WORD).
