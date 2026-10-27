---
title: "SPEC-VERSION"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "SPEC-VERSION 是以一个整数声明文档所遵循 GEUL 规范版次的定义 Meta。GEUL v1 为 0x0001。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

声明文档所遵循的 GEUL 规范版次。其余记录如何读取，由此值决定。

## 布局

```
TAG WORD          0001 1LLL L001 0000      Codec 0x10
[Length 扩展 TAG]
Payload           规范版次。v1 = 0x0001
```

- Codec：Meta `0x10`，定义类（`001`）
- Payload：原始值（最短宽度的 unsigned 整数）
- 数量：至多一个

## 解读与有效性

- 不依赖 Value 码。为了让任何版次的解码器都能读取，不使用内置 Value，只放整数。
- 遇到不认识的版次，解码器拒绝或发出警告。
- 没有它则按解码器所知的版次读取。公布的文档必须写明。

## 示例

- `0x1890 0x0001`：GEUL v1

## 未决问题

- 与 codebook 文档版本的对应（[规范文档](/zh/grammar/codec-spec/)）。
