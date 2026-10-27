---
title: "Value — النص"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "صيغ عائلة TEXT (Codec `0x40`~`0x5F`، أرقام الصيغ `0x8000`~`0xBFFF`): نص UTF-8 والنص المرفق بلغة وURI ورموز اللغات."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

عائلة TEXT هي صيغ النصوص ومعرّفات السلاسل. توضع في الرموز المباشرة `0x40`~`0x5F` وفي أرقام صيغ Issuer `0x8000`~`0xBFFF`.

- السلسلة بلا لغة هي UTF8-TEXT، والنص ذو اللغة مثل الأسماء والعناوين والجمل هو UTF8-LANGUAGE-TEXT.
- رموز اللغات (LANGUAGE-SHORT-CODE وLANGUAGE-BCP47-CODE) من عائلة TEXT أيضاً.
- سلاسل البايتات متغيرة الطول توضع في أزواج Codec زوجي/فردي. إذا كان أقل بت `1` فعدد البايتات فردي وبايت الأدنى في آخر WORD حشو `0x00` ([السجل وTAG WORD](/ar/grammar/record/)).
