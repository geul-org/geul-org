---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "فئة IMPORT في Meta (أعلى 3 بتات `110`، من `0x60` إلى `0x6F`) تستورد مستنداً خارجياً بـ IMPORT ID."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

فئة IMPORT في Meta (أعلى 3 بتات `110`، وCodec `0x60`~`0x6F`) تستورد مستنداً خارجياً بـ IMPORT ID. وCodec فيها واحد هو `IMPORT-DOC` (`0x60`).

- IMPORT يستورد المستندات فقط. ويُشار إلى الهدف داخل المستند المستورد في BODY بـ Reference `EXTERNAL-POINTER-*` (IMPORT ID وLOCAL ID) ([Reference](/ar/grammar/reference/)).
- إذا كُتب معرّف الإصدار ارتبط بذلك الإصدار، وإذا كان `0` ارتبط بأحدث إصدار وقت التفسير. والمستند المنشور يكتب الإصدار.
- لا يُستورد HEAD المستند المستورد. ولا تُستورد سجلات Reference وValue بل تُنسخ.
