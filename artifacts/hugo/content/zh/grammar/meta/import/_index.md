---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Meta IMPORT 类（高 3 位 `110`，`0x60`~`0x6F`）以 IMPORT ID 导入外部文档。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta IMPORT 类（高 3 位 `110`，Codec `0x60`~`0x6F`）以 IMPORT ID 导入外部文档。Codec 只有 `IMPORT-DOC`（`0x60`）一个。

- IMPORT 只导入文档。被导入文档中的目标，在 BODY 中用 Reference `EXTERNAL-POINTER-*`（IMPORT ID、LOCAL ID）指向（[Reference](/zh/grammar/reference/)）。
- 写明版本 ID 则绑定到该版本，为 `0` 则绑定到解读时刻的最新版本。公布的文档要写明版本。
- 不导入被导入文档的 HEAD。Reference·Value 记录不是导入，而是复制。
