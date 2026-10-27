---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE 是记录本文档及字节序列内作品许可证的策略 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录本文档及字节序列内作品的许可证。

## 布局

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[Length 扩展 TAG]
Payload           指向许可证的 Reference，或 SPDX 标识符 UTF8-TEXT，或 URI Value
```

- Codec：Meta `0x50`，策略类（`101`）
- Payload：内置 Reference 或 Value（[UTF8-TEXT](/zh/grammar/value/text/utf8-text/)、[URI](/zh/grammar/value/text/uri/)）
- 数量：至多一个

## 解读与有效性

- geul.org 公布的文档为 CC0。私有公布由 Issuer 决定（[Issuer](/zh/grammar/issuer/)）。
- 记录来源作品的原始许可证。

## 未决问题

- SPDX 标识符是以文本放置，还是以 GEUL 实体 Reference 放置。
