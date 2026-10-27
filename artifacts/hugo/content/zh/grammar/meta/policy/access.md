---
title: "ACCESS"
weight: 82
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ACCESS 是以 1 WORD 等级记录文档公开范围（公开、内部、机密）的策略 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录文档的公开范围。

## 布局

```
TAG WORD          0001 1LLL L101 0001      Codec 0x51
[Length 扩展 TAG]
等级              1 WORD (0 公开, 1 内部, 2 机密, 其余保留)
```

- Codec：Meta `0x51`，策略类（`101`）
- Payload：原始值（等级 1 WORD）
- 数量：至多一个

## 解读与有效性

- 机密文档不公布（[Issuer](/zh/grammar/issuer/)）。
- 不改变解读，只规定处理方式。

## 未决问题

- 等级码表。
