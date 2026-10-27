---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT 是以 Reference 或文本记录同意范围与依据的策略 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录同意的范围与依据。

## 布局

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[Length 扩展 TAG]
Payload           指向同意依据的 Reference 或文本
```

- Codec：Meta `0x54`，策略类（`101`）
- Payload：内置 Reference 或 Value
- 数量：可有多个

## 未决问题

- 范围表示（目的·期限·向第三方提供）的结构。
