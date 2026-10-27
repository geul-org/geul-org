---
title: "Meta — 验证"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Meta 验证类（高 3 位 `100`，`0x40`~`0x4F`）记录判断文档是否可信的素材（公钥、签名、可信度、判定）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 验证类（高 3 位 `100`，Codec `0x40`~`0x4F`）记录判断文档是否可信的素材：自行颁发的 Issuer 的公钥、签名、贡献权利确认、可信度，以及整个文档的判定结果。

- 验证类不参与内容哈希计算。因此即使把签名放进文档，或追加多个签名，内容哈希也不会改变（与 git `gpgsig` 方式相同）。
- 类可由 Codec 的高 3 位得知，所以无需 codebook 就能计算哈希。
- 节点·记录级别的判定由 [TOULMIN](/zh/grammar/edge/toulmin/) Edge `VERDICT`（`0x78`）负责。
