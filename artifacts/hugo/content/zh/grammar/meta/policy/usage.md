---
title: "USAGE"
weight: 86
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "USAGE 是记录禁止训练、禁止商业使用等使用限制的策略 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录使用限制（例：禁止训练、禁止商业使用）。

## 布局

```
TAG WORD          0001 1LLL L101 0101      Codec 0x55
[Length 扩展 TAG]
Payload           表示使用限制的文本或 Reference
```

- Codec：Meta `0x55`，策略类（`101`）
- Payload：内置 Value 或 Reference
- 数量：可有多个

## 未决问题

- 限制种类码表。
